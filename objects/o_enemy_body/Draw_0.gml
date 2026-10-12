draw_self();

// 1. Efecto visual de ALERTA / PERSECUCIÓN (CHASE): Cambio drástico de color a rojo peligro
if (state == Enemy_STATE.CHASE)
{
    gpu_set_blendmode(bm_add);
    var _pulse = 0.75 + 0.25 * sin(current_time * 0.02);

    if (object_index == o_enemy_2)
    {
        // En la Araña: Sus ojos y lente cambian a ROJO ALERTA vibrante
        var _ex = x + image_xscale * 10;
        var _ey = y - 14;
        draw_circle_color(_ex, _ey, 10 * _pulse, make_color_rgb(255, 30, 40), c_black, false);
        draw_circle_color(_ex, _ey, 4, c_white, c_black, false);
        // Resplandor rojo en el caparazón
        draw_circle_color(x, y - 12, 16 * _pulse, make_color_rgb(255, 40, 20), c_black, false);
    }
    else
    {
        // En el Mech: Visor rojo sobrecargado
        var _vx = x + image_xscale * 8;
        var _vy = y - 48;
        draw_circle_color(_vx, _vy, 12 * _pulse, make_color_rgb(255, 20, 30), c_black, false);
        draw_circle_color(_vx, _vy, 4, c_white, c_black, false);
        // Núcleo de pecho sobrecargado
        draw_circle_color(x + image_xscale * 2, y - 35, 9 * _pulse, make_color_rgb(255, 30, 30), c_black, false);
    }
    gpu_set_blendmode(bm_normal);
}
// 2. Efecto visual de ATURDIMIENTO (STUN): Descarga eléctrica cyan y blanco
else if (state == Enemy_STATE.STUN)
{
    gpu_set_blendmode(bm_add);
    var _blink = (current_time % 120 < 60) ? 0.75 : 0.3;
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, make_color_rgb(80, 230, 255), _blink);

    // Arcos de chispas eléctricas
    draw_set_color(make_color_rgb(220, 255, 255));
    for (var k = 0; k < 2; k++)
    {
        var _rx = x + random_range(-14, 14);
        var _ry = y - random_range(4, 24);
        draw_line(_rx, _ry, _rx + random_range(-6, 6), _ry + random_range(-6, 6));
    }
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}

// Dibuja la zona de deteccion
if (debug_zone)
{
	draw_text(x - 16, y - detectH - 16, string(state) + " / " + string(idleAction));
	
	var z = c_enemy_zone();
	
	draw_set_alpha(0.25);
	draw_set_color (state == Enemy_STATE.CHASE ? c_red : c_yellow);
	draw_rectangle(z[0], z[1], z[2], z[3], false);
	
	// Restaurar porsi
	draw_set_alpha(1);
	draw_set_colour(c_white);
}