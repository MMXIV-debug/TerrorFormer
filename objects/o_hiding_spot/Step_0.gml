if (instance_exists(o_player))
{
	cerca = !o_player.is_hidden 
		&& point_distance(x, y - sprite_height / 2, o_player.x, o_player.y - 16) <= reach;
}
else cerca = false;

image_index = cerca ? 1 : 0;