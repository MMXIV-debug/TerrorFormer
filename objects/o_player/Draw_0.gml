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

draw_self();

// Cuerda
if (grapple != 0)
{
	var _hx = (grapple == 1) ? hook_x : anchor_x;
	var _hy = (grapple == 1) ? hook_y : anchor_y;

	draw_set_color(c_ltgray);
	draw_line_width(x, y - gr_hand, _hx, _hy, 1);
	draw_circle(_hx, _hy, 2, false);   // el gancho
	draw_set_color(c_white);
}