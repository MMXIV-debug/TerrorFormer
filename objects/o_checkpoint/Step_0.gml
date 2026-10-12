if (!instance_exists(o_player)) exit;

var _d = point_distance(x, y - 24, o_player.x, o_player.y - 10);
cerca = (_d <= reach);

// Al pasar cerca del checkpoint
if (cerca)
{
	// Si nunca se había activado, registrar su orden en la progresión
	if (!is_active)
	{
		is_active = true;
		global.checkpoint_counter++;
		order_index = (checkpoint_order > 0) ? checkpoint_order : global.checkpoint_counter;
	}

	// Solo actualiza el punto de reaparición si este checkpoint es igual o más
	// avanzado que el que el jugador tiene actualmente.
	// Si el jugador retrocede a un checkpoint anterior, NO pierde su punto avanzado.
	if (order_index >= o_player.spawn_order)
	{
		o_player.spawn_order = order_index;
		o_player.spawn_x = x;
		o_player.spawn_y = y;
	}
}

// Alternar entre sprites activo e inactivo
sprite_index = is_active ? s_checkpoint_active : s_checkpoint_inactive;
