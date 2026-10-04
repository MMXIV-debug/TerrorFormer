function c_enemy_detect()
{
	if (!instance_exists(o_player)) return false;
	
	// 1. Valida si el player esta en la zona de adelante
	var z = c_enemy_zone();
	if (collision_rectangle(z[0], z[1], z[2], z[3], o_player, false, true) == noone) return false;
	
	// 2. Valida si hay una pared entre los dos y se apaga con use_line_of_sight
	if (use_line_of_sight)
	{
		var eye_y = y - detectH / 2;
		var _tx = o_player.x;
		var _ty = o_player.y - 5;
		
		for(var i = 0; i < array_length(all_collision); i++)
		{
			var hit = collision_line(x, eye_y, _tx, _ty, all_collision[i], false, true);
			if (hit != noone && hit != 0) return false;
		}
	}
	
	return true;
	
}