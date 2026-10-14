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
debug_zone = false;

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

// Persecución agresiva
chaseJumpSpeed = 10; // fuerza de salto al perseguir (tu player salta con 10)
chaseJumpH = 4; // velocidad horizontal en el aire al perseguir
chaseJumpRange = 140; // distancia horizontal máxima para saltar hacia un player que está arriba
chaseMaxDrop = 64;  // caída máxima que acepta persiguiendo (más que esto = se frena y cancela)
chaseGapMax = 32;   // ancho máximo de hueco que cruza caminando (1 bloque)
chaseJumpTimer = 0; // pausa entre saltos hacia el player

// Perder al player colgado del techo
hangTimer = 0;
hangLimit = room_speed * 10; // 10 segundos
chaseGiveUpDist = 900; // si el player queda más lejos que esto (px), pierde la persecución
chaseCooldown = 0; // pausa antes de poder volver a detectar al player
chaseCooldownMax = room_speed * 3; // 3 segundos




