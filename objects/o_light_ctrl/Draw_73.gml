var _cam = view_camera[0];
var _cx = camera_get_view_x(_cam);
var _cy = camera_get_view_y(_cam);
var _cw = camera_get_view_width(_cam);
var _ch = camera_get_view_height(_cam);

if (!surface_exists(light_surf)) light_surf = surface_create(_cw, _ch);

draw_set_alpha(1);

// Rango de tiles visibles en cámara
var _tm = dmg_tm;
var _x0 = 0, _x1 = -1, _y0 = 0, _y1 = -1, _tw = 32, _th = 32;
if (_tm != -1)
{
    _tw = tilemap_get_tile_width(_tm);
    _th = tilemap_get_tile_height(_tm);
    _x0 = max(0, floor(_cx / _tw));
    _x1 = min(tilemap_get_width(_tm)  - 1, floor((_cx + _cw) / _tw));
    _y0 = max(0, floor(_cy / _th));
    _y1 = min(tilemap_get_height(_tm) - 1, floor((_cy + _ch) / _th));
}

// 1. MAPA DE LUZ
surface_set_target(light_surf);
draw_clear(ambient);
gpu_set_blendmode(bm_add);

// Luz del player: pequeña, y se encoge cuando le queda poca vida
with (o_player)
{
    var _f  = clamp(hp / hpMax, 0, 1);
    var _r  = lerp(65, 180, _f);
    var _fl = 1 + sin(current_time * 0.006) * 0.05 + random_range(-0.02, 0.02);
    c_light_draw(x - _cx, y - 16 - _cy, _r * _fl, make_color_rgb(190, 200, 225), 0.85);
}

// Luces débiles del escenario
with (o_light_weak)
{
    if (x > _cx - light_r && x < _cx + _cw + light_r && y > _cy - light_r && y < _cy + _ch + light_r)
        c_light_draw(x - _cx, y - _cy, light_r * flick, light_col, light_k * flick);
}

// El ácido se ilumina a sí mismo y alumbra hacia arriba
for (var i = _x0; i <= _x1; i++)
{
    for (var j = _y0; j <= _y1; j++)
    {
        if (!c_is_acid(tile_get_index(tilemap_get(_tm, i, j)))) continue;

        var _px = i * _tw - _cx;
        var _py = j * _th - _cy;
        var _pulse = 0.5 + 0.5 * sin(t * 0.04 + i * 0.6);
        var _self = make_color_rgb(190, 215, 190);

        draw_rectangle_color(_px, _py, _px + _tw, _py + _th, _self, _self, _self, _self, false);

        if (!c_is_acid(tile_get_index(tilemap_get(_tm, i, j - 1))))
            c_light_draw(_px + _tw / 2, _py, 56 + _pulse * 8, make_color_rgb(80, 255, 70), 0.45);
    }
}

gpu_set_blendmode(bm_normal);
surface_reset_target();

// 2. MULTIPLICAR LA OSCURIDAD SOBRE EL JUEGO
gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
gpu_set_texfilter(true);                 // luz suave, no pixelada
draw_surface(light_surf, _cx, _cy);
gpu_set_texfilter(false);
gpu_set_blendmode(bm_normal);

// 3. BRILLO REAL (aditivo, por encima de la oscuridad)
gpu_set_blendmode(bm_add);

for (var i = _x0; i <= _x1; i++)
{
    for (var j = _y0; j <= _y1; j++)
    {
        if (!c_is_acid(tile_get_index(tilemap_get(_tm, i, j)))) continue;
        if (c_is_acid(tile_get_index(tilemap_get(_tm, i, j - 1)))) continue;   // solo superficie

        var _pulse = 0.5 + 0.5 * sin(t * 0.04 + i * 0.6);
        c_light_draw(i * _tw + _tw / 2, j * _th + 4, 44 + _pulse * 10, make_color_rgb(60, 255, 60), 0.28 + _pulse * 0.08);
    }
}

// Burbujas con brillo aditivo
with (o_bubble)
    draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_white, image_alpha);

gpu_set_blendmode(bm_normal);