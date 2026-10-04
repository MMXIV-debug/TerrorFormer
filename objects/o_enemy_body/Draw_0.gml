draw_self();

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