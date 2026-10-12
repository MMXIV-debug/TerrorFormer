// Sprite checks ---------------------
if (is_on_floor)
{
	if(xSpeed = 0)
		sprite_index = s_player
	else
	{
		sprite_index = s_player_move;
	}
}

if (!is_on_floor)
{
	if (ySpeed < 0)
		sprite_index = s_player_up;
	else
	{
		sprite_index = s_player_down;
	}
}

mask_index = s_player;

// Parpadeo mientras es invulnerable
image_alpha = (invul_timer > 0 && (invul_timer div 4) mod 2 == 1) ? 0.3 : 1;

if (!is_hidden) draw_self();

if (!is_hidden && !is_on_floor)
{
	for (var i = 0; i < gr_charges_max; i++)
	{
		draw_set_color(i < gr_charges ? c_white : c_dkgray);
		draw_circle(x - 8 + i * 8, y - 44, 2, false);
	}
	draw_set_color(c_white);
}


// Cuerda
if (grapple != 0)
{
	var _hx = (grapple == 1) ? hook_x : anchor_x;
	var _hy = (grapple == 1) ? hook_y : anchor_y;

	var _rope_col = c_ltgray;
	var _shake = 0;
	if (grapple == 2 && gr_hang_timer > gr_hang_max * 0.65)
	{
		var _fatigue_ratio = (gr_hang_timer - gr_hang_max * 0.65) / (gr_hang_max * 0.35);
		_rope_col = merge_color(c_yellow, c_red, _fatigue_ratio);
		_shake = random_range(-1, 1);
	}

	draw_set_color(_rope_col);
	draw_line_width(x + _shake, y - gr_hand, _hx, _hy, 1);
	draw_circle(_hx, _hy, 2, false);
	draw_set_color(c_white);
}