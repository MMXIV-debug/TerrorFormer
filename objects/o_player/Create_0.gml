// Stats ----------------------
hpMax = 10;
hp = hpMax


// Movimiento -----------------
	// Variales en X --------------
xSpeedMax = 5.5;
xSpeed = 0;
xAccel = 0.5;

	//Variables en Y ---------------
ySpeed = 0;
fallMax = 11;
grav = 0.5;

// Control --------------------
is_on_floor = 0; // Variable de control de si esta en el suelo
facing = 1;
jumpSpeed = 10;


gpu_set_texfilter(false);

// Reconocimiento de TileMap -----------------------
tileId = layer_tilemap_get_id("ts_terrain");
all_collision = [tileId, o_floor_1, o_wall_1]

// Ataque ---------------------
weaponSlots = ["Slash", "Bullet"]
current_weapon_index = 0;
weapon = weaponSlots[current_weapon_index];
atkCooldown = 12;
canAttack = 1;


// Respawn e invulnerabilidad ---------------
spawn_x = x;        // dónde reaparece (por ahora, donde empieza en la room)
spawn_y = y;
invulMax = 120;     // frames de invulnerabilidad al reaparecer (60 = 1 segundo)
invul_timer = 0;