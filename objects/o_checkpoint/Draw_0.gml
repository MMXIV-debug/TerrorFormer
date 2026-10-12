// 1. Dibuja el sprite actual (s_checkpoint_active o s_checkpoint_inactive)
draw_self();

// 4. Texto informativo si el player está cerca
if (cerca)
{
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	var _str = "PUNTO DE CONTROL";
	var _tcol = c_ltgray;
	if (is_active)
	{
		if (instance_exists(o_player) && o_player.spawn_x == x && o_player.spawn_y == y)
		{
			_str = "CHECKPOINT ACTUAL";
			_tcol = make_color_rgb(80, 255, 200);
		}
		else
		{
			_str = "CHECKPOINT ANTERIOR";
			_tcol = make_color_rgb(120, 180, 210);
		}
	}
	draw_text_transformed_color(x, y - 52, _str, 0.7, 0.7, 0, _tcol, _tcol, _tcol, _tcol, 0.9);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
