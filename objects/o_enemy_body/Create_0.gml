// Colisiones similares al player cada instancia ocupa las suyas
tileId = layer_tilemap_get_id("ts_terrain");
all_collision = [tileId, o_floor_1, o_wall_1];

// Movimiente
facing = 1;
chaseSpeed = 3;
ySpeed = 0;
grav = 0.5;
fallMax = 11;
is_on_floor = true;
avoid_ledges = true; // No se tira por el borde a menos que persiga

// Detección
detectRange = 160; // Largo de la zona hacia adelante en px
detectH = 48;  // Alto de la zona variando del tamaño del sprite
use_line_of_sight = true; // Con true no ve a traves de las paredes
lostTimerMax = 90; // Frames que va a buscar una vez perdido al player
lostTimer = 0; 

// Estado
state = Enemy_STATE.IDLE;

// Aturdimiento
stunTimer = 0;

// Debug: muestra la zona de detección
debug_zone = true;

// Deambular del IDLE
walkSpeed = 1.2;
jumpSpeed = 9;
jumpHSpeed = 2.5;
air_hspeed = walkSpeed;
maxDrop = 96;
minProgress = 20;
was_on_floor = false;
decisionCooldown = 0;

idleAction = IDLE_ACTION.WAIT;
idleTimer = 0;
lookTimer = 0;
waitMin = 90;  waitMax = 240; 
walkMin = 120; walkMax = 300;
lookMin = 30;  lookMax = 80;

c_enemy_set_wait(); 