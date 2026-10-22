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
is_alive = 1;
crouch = 0;


gpu_set_texfilter(false);

// Reconocimiento de TileMap -----------------------
tileId = layer_tilemap_get_id("ts_terrain");
all_collision = [tileId, o_floor_1, o_wall_1]

// Ataque ---------------------
weaponSlots = ["Bullet", "Slash"]
current_weapon_index = 0;
weapon = weaponSlots[current_weapon_index];
atkCooldown = 12;
canAttack = 1;


// Respawn e invulnerabilidad ---------------
spawn_x = x; // dónde reaparece (se actualiza con los checkpoints)
spawn_y = y;
spawn_order = 0; // orden del último checkpoint alcanzado (evita retroceder)
invulMax = 120; // frames de invulnerabilidad al reaparecer (60 = 1 segundo)
invul_timer = 0;
respawn_state = 0; // 0 = normal, 1 = muriendo (fade out), 2 = reapareciendo (fade in)
fade_alpha = 0; // opacidad del fundido a negro (0 a 1)

// Cuerda o gancho ---------------
grapple = 0; // 0 = nada, 1 = gancho volando, 2 = enganchado
gr_max = 300; // alcance máximo del gancho (px)
gr_fly_speed = 32; // velocidad del gancho en vuelo (múltiplo de 4)
gr_min_len = 24; // largo mínimo de la cuerda (px)
gr_hand = 8; // altura desde donde sale la cuerda (px sobre los pies)
gr_reel = 4; // cuánto se acorta o alarga la cuerda por frame (W / S)
gr_pull = 0.7; // fuerza del tirón hacia el ancla (W)
gr_push = 0.15; // empuje de A/D para balancearse
gr_speed_max = 14; // velocidad máxima al columpiarse
gr_cooldown = 15; // frames de espera antes de poder lanzar otra vez
gr_cd = 0;
gr_hang_timer = 0; // Contador de fatiga al colgarse
gr_hang_max = 240; // ~4 segundos (a 60 fps) antes de que los brazos se cansen y se suelte

hook_x = 0;  hook_y = 0; // posición del gancho en vuelo
hook_dx = 0; hook_dy = 0; // dirección del gancho (vector de largo 1)
hook_dist = 0; // cuánto recorrió
anchor_x = 0; anchor_y = 0; // punto donde quedó enganchado
rope_len = 0; // largo actual de la cuerda
gr_charges_max = 3;               // disparos disponibles en el aire
gr_charges = gr_charges_max;

// Daño por tiles --------------
dmgTileId = layer_tilemap_get_id("ts_dmg_obj");
hitInvul = 60;      // frames de invulnerabilidad tras recibir daño// 

// Hiding spot ---------------
is_hidden = false;
hide_spot = noone;

// Plataformas nube -------------
cloudId = layer_tilemap_get_id("ts_cloud");
cloud_drop = 0;   // frames que las nubes se ignoran al bajar con S + Espacio