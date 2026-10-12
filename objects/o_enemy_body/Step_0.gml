//  1. Gravedad ------------
if (c_collision(x, y + 1))
{
    is_on_floor = true;
    ySpeed = 0;
    air_hspeed = walkSpeed;   // en el suelo, la velocidad "de aire" vuelve a la normal
}
else
{
    is_on_floor = false;
    ySpeed = min(ySpeed + grav, fallMax);
}
if (ySpeed < 0 && c_collision(x, y - 1)) ySpeed = 0;   // golpe con el techo

// Al aterrizar se permite volver a decidir
if (is_on_floor && !was_on_floor) decisionCooldown = 0;
was_on_floor = is_on_floor;
if (decisionCooldown > 0) decisionCooldown--;

// 2. Estado --------------------
var hSpeed = 0;
var player_exists = instance_exists(o_player);

switch (state)
{
	// Caso de idle
	case Enemy_STATE.IDLE:
		// ¿Ve al player? Entonces lo persigue
        if (chaseCooldown > 0) chaseCooldown--;

        if (player_exists && chaseCooldown <= 0 && c_enemy_detect())
        {
            state = Enemy_STATE.CHASE;
            lostTimer = lostTimerMax;
            break;
        }

        idleTimer--;
		
		switch (idleAction)
        {
            // ---- Quieto, mirando a los lados ----
            case IDLE_ACTION.WAIT:
                hSpeed = 0;

                lookTimer--;
                if (lookTimer <= 0)
                {
                    facing *= -1;   // mira al otro lado
                    lookTimer = irandom_range(lookMin, lookMax);
                }

                if (idleTimer <= 0) c_enemy_set_walk();
                break;
			 // ---- Caminando / saltando ----
            case IDLE_ACTION.WALK:

                // En el suelo camina normal; en el aire mantiene la velocidad del salto
                hSpeed = facing * (is_on_floor ? walkSpeed : air_hspeed);
				if (is_on_floor && decisionCooldown <= 0)
                {
					// Verifica que hay delante
                    var front = (facing == 1) ? bbox_right : bbox_left;
                    var wall_ahead = c_collision(x + facing * 2, y);
                    var ground_ahead = c_solid_point(front + facing * 2, y + 1);
					
					if (wall_ahead || !ground_ahead)
                    {
                        // Opciones posibles. "turn" (dar la vuelta) siempre vale.
                        var options = ["turn"];

                        if (c_enemy_sim_jump(facing, -jumpSpeed, jumpHSpeed))
                            array_push(options, "jump");

                        if (!wall_ahead && c_enemy_sim_jump(facing, 0, walkSpeed))
                            array_push(options, "drop");

                        // Elige una al azar
                        var pick = options[irandom(array_length(options) - 1)];
						switch (pick)
                        {
                            case "turn":
                                facing *= -1;
                                break;
                            case "jump":
                                c_enemy_jump(jumpHSpeed);
                                break;
                            case "drop":
                                decisionCooldown = 60;   // sigue caminando y se cae
                                break;
                        }
					}
				}
				// Cansado de caminar: se queda quieto un rato (solo si está en el suelo)
                if (idleTimer <= 0 && is_on_floor) c_enemy_set_wait();
                break;
		}
		break;
		// Caso de persecusion
		case Enemy_STATE.CHASE:
			// Se rinde al instante si el player se esconde
			if (!player_exists || o_player.is_hidden)
			{
				hangTimer = 0;
				state = Enemy_STATE.IDLE;
				c_enemy_set_wait();
				break;
			}
			
			// Se rinde si el player quedó demasiado lejos
			if (point_distance(x, y, o_player.x, o_player.y) > chaseGiveUpDist)
			{
				hangTimer = 0;
				state = Enemy_STATE.IDLE;
				c_enemy_set_wait();
				break;
			}

			// Mirar al player solo en el suelo (en el aire mantiene la dirección del salto)
			if (is_on_floor)
			{
				var dirToPlayer = sign(o_player.x - x);
				if (dirToPlayer != 0) facing = dirToPlayer;
			}

			// Player colgado del techo con el gancho (sin tocar el piso): cuenta el tiempo
			var _hanging = (o_player.grapple == 2 && !o_player.is_on_floor && o_player.anchor_y < o_player.y - 32);
			if (_hanging) hangTimer++;
			else hangTimer = 0;

			// Si aguanta colgado 10 segundos seguidos, lo pierde
			if (hangTimer >= hangLimit)
			{
				hangTimer = 0;
				state = Enemy_STATE.IDLE;
				c_enemy_set_wait();
				break;
			}

			hSpeed = c_enemy_chase_move();
			break;
		// Caso de aturdido
		case Enemy_STATE.STUN:
			hSpeed = 0;          // no se mueve (la gravedad sigue funcionando)
			stunTimer--;
			if (stunTimer <= 0)
			{
				state = Enemy_STATE.CHASE;   // al recuperarse, te persigue
				lostTimer = lostTimerMax;
			}
			break;
}

image_xscale = facing;
image_blend = (state == Enemy_STATE.STUN) ? c_aqua : c_white;

// 3. Movimiento en X ----------------
var dist = abs(hSpeed);
var dir = sign(hSpeed);
while (dist > 0)
{
    var step = min(1, dist);
    if (!c_collision(x + dir * step, y)) x += dir * step;
    else break;
    dist -= step;
}

// 4. Movimiento en Y ----------------
dist = abs(ySpeed);
dir = sign(ySpeed);
while (dist > 0)
{
    var step = min(1, dist);
    if (!c_collision(x, y + dir * step)) y += dir * step;
    else { ySpeed = 0; break; }
    dist -= step;
}

// 5. Matar al player de un toque (si no es invulnerable) ------------
if (player_exists && !o_player.is_hidden && state != Enemy_STATE.STUN && o_player.invul_timer <= 0 && place_meeting(x, y, o_player))
{
	o_player.hp = 0;
}