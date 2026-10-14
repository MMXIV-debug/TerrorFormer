// Colisiones similares al player cada instancia ocupa las suyas
tileId = layer_tilemap_get_id("ts_terrain");
all_collision = [tileId, o_floor_1, o_wall_1];

// Stats
reloadSpeed = 12;


// Movimiento
facing = 1;
chaseSpeed = 3;
xSpeed = 1;
xCheck = 11;
grav = 0.5;
fallMax = 11;
is_on_floor = true;
avoid_ledges = true; // No se tira por el borde a menos que persiga

// Comportamiento
if (irandom(1))
{
	hspeed = xSpeed;
}
else
{
	hspeed = -xSpeed;
	image_xscale *= -1;
}

// Estado
state = Enemy_STATE.IDLE;

// Aturdimiento
stunTimer = 0;