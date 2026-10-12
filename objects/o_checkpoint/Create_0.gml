sprite_index = s_checkpoint_inactive;
is_active = false;
reach = 48; // distancia de activación en px
cerca = false;

// Orden de progresión (0 = automático por descubrimiento)
checkpoint_order = 0;
order_index = 0;

if (!variable_global_exists("checkpoint_counter"))
{
	global.checkpoint_counter = 0;
}
