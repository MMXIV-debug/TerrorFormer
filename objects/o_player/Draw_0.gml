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

draw_self();