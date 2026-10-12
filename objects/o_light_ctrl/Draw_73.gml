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

// Luz del player: solo halo personal + destello de disparo (sin linterna)
with (o_player)
{
    if (is_hidden) continue;

    var _px = x;
    var _py = y - 12;

    // Halo personal para ver los pies y cuerpo cercano
    c_light_draw(_px - _cx, _py - _cy, 42, make_color_rgb(140, 150, 180), 0.55);
}

// Luces de Checkpoints
with (o_checkpoint)
{
    var _col = is_active ? make_color_rgb(80, 255, 200) : make_color_rgb(240, 60, 60);
    var _rad = is_active ? (70 + sin(current_time * 0.005) * 8) : 40;
    var _k   = is_active ? 0.85 : 0.45;
    c_light_draw(x - _cx, y - 30 - _cy, _rad, _col, _k);
}

// Luces débiles del escenario
with (o_light_weak)
{
    if (x > _cx - light_r && x < _cx + _cw + light_r && y > _cy - light_r && y < _cy + _ch + light_r)
        c_light_draw(x - _cx, y - _cy, light_r * flick, light_col, light_k * flick);
}

// Luces y escáneres neón de los robots en la oscuridad
with (o_enemy_body)
{
    if (x > _cx - 160 && x < _cx + _cw + 160 && y > _cy - 160 && y < _cy + _ch + 160)
    {
        var _is_chase = (state == Enemy_STATE.CHASE);
        var _is_stun  = (state == Enemy_STATE.STUN);

        if (object_index == o_enemy_1)
        {
            // Robot 1: Mech Pesado - Haz frontal de búsqueda rojo carmesí + aura de reactor
            var _c_beam = _is_stun ? make_color_rgb(0, 200, 255) : (_is_chase ? make_color_rgb(255, 30, 40) : make_color_rgb(230, 40, 50));
            var _aim_dir = (facing == 1) ? 350 : 190;
            var _range   = _is_chase ? 140 : 100;
            var _eye_x   = x + facing * 8;
            var _eye_y   = y - 48;

            // Haz cónico de búsqueda que corta la oscuridad y descubre paredes
            c_light_cone(_eye_x, _eye_y, _aim_dir, 55, _range, _c_beam, 0.85, _cx, _cy, other.terrain_tm);

            // Halo de iluminación alrededor del chasis
            c_light_draw(x - _cx, y - 32 - _cy, 48, _c_beam, 0.55);
        }
        else
        {
            // Robot 2: Araña Táctica - Lente de escaneo cyan en IDLE, cambia a ROJO ALARMA en CHASE
            var _c_beam = _is_stun ? make_color_rgb(0, 180, 255) : (_is_chase ? make_color_rgb(255, 40, 30) : make_color_rgb(0, 230, 255));
            var _aim_dir = (facing == 1) ? 345 : 195;
            var _range   = _is_chase ? 130 : 85;
            var _eye_x   = x + facing * 10;
            var _eye_y   = y - 14;

            // Cono de escaneo óptico (cyan en patrulla, rojo intenso en ataque)
            c_light_cone(_eye_x, _eye_y, _aim_dir, 65, _range, _c_beam, 0.85, _cx, _cy, other.terrain_tm);

            // Resplandor neón inferior en el suelo bajo el robot
            c_light_draw(x - _cx, y - 8 - _cy, 44, _c_beam, 0.65);
        }
    }
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
gpu_set_texfilter(true);
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

// Brillo propio de las luces de emergencia
with (o_light_lamp)
{
    c_light_draw(x, y, 55 * flick, light_col, 0.35 * flick);
}

// Brillo propio del núcleo de los checkpoints
with (o_checkpoint)
{
    var _col = is_active ? make_color_rgb(80, 255, 200) : make_color_rgb(255, 60, 60);
    var _glow = is_active ? (18 + sin(current_time * 0.006) * 3) : 12;
    c_light_draw(x, y - 33, _glow, _col, 0.45);
}

// Brillo neón aditivo de los robots (sensores ópticos y núcleos que perforan la oscuridad)
with (o_enemy_body)
{
    if (x > _cx - 64 && x < _cx + _cw + 64 && y > _cy - 64 && y < _cy + _ch + 64)
    {
        var _is_chase = (state == Enemy_STATE.CHASE);
        var _is_stun  = (state == Enemy_STATE.STUN);

        if (object_index == o_enemy_1)
        {
            var _c_core = _is_stun ? make_color_rgb(0, 220, 255) : (_is_chase ? make_color_rgb(255, 30, 40) : make_color_rgb(255, 60, 70));
            var _vx = x + facing * 8;
            var _vy = y - 48;
            var _pulse = sin(current_time * 0.008) * 2;

            // Destello del visor ciclópeo rojo
            c_light_draw(_vx, _vy, 16 + _pulse, _c_core, 0.85);
            c_light_draw(_vx, _vy, 5, c_white, 0.95);

            // Núcleo del reactor en el pecho
            c_light_draw(x + facing * 2, y - 35, 11, _c_core, 0.65);
            c_light_draw(x + facing * 2, y - 35, 3, c_white, 0.85);
        }
        else
        {
            var _c_core = _is_stun ? make_color_rgb(0, 180, 255) : (_is_chase ? make_color_rgb(255, 30, 40) : make_color_rgb(0, 240, 255));
            var _ex = x + facing * 10;
            var _ey = y - 14;
            var _pulse = sin(current_time * 0.01) * 2.5;

            // Destello de las lentes ópticas (cyan en IDLE, rojo alarma intenso en CHASE)
            c_light_draw(_ex, _ey, 16 + _pulse, _c_core, 0.95);
            c_light_draw(_ex, _ey, 5, c_white, 1.0);

            // Resplandor neón inferior en el suelo
            c_light_draw(x, y - 8, 22, _c_core, 0.72);
            c_light_draw(x, y - 8, 6, c_white, 0.85);
        }
    }
}


gpu_set_blendmode(bm_normal);

// 4. Fundido suave de muerte (Fade Out / Fade In)
if (instance_exists(o_player) && o_player.fade_alpha > 0)
{
    draw_set_alpha(o_player.fade_alpha);
    draw_rectangle_color(_cx, _cy, _cx + _cw, _cy + _ch, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1);
}