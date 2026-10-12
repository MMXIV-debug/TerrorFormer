// 0. Esconderse (E) ---------------------------
// -1. Flujo de muerte y respawn suave ------------------
if (respawn_state == 1) // Fase 1: Fundido a negro y reposicionamiento
{
    xSpeed = 0;
    ySpeed = 0;
    grapple = 0;
    fade_alpha = min(1, fade_alpha + 0.04);
    if (fade_alpha >= 1)
    {
        x = spawn_x;
        y = spawn_y;
        while (c_collision(x, y) && y > 0)
        {
            y -= 1;
        }
        xSpeed = 0;
        ySpeed = 0;
        hp = hpMax;
        invul_timer = invulMax;
        is_alive = 1;
        gr_hang_timer = 0;
        gr_charges = gr_charges_max;

        if (instance_exists(o_camera)) o_camera.snapped = false;

        // Calmar a los enemigos para evitar spawn-kill
        with (o_enemy_body)
        {
            state = Enemy_STATE.IDLE;
            hangTimer = 0;
            chaseCooldown = chaseCooldownMax;
            c_enemy_set_wait();
        }

        respawn_state = 2; // Pasa a fase de fade in
    }
    exit;
}
else if (respawn_state == 2) // Fase 2: Fundido de regreso a la vista
{
    fade_alpha = max(0, fade_alpha - 0.04);
    if (fade_alpha <= 0)
    {
        fade_alpha = 0;
        respawn_state = 0;
    }
}

if (is_hidden)
{
    xSpeed = 0;
    ySpeed = 0;
    grapple = 0;

    if (keyboard_check_pressed(ord("E")))
    {
        is_hidden = false;
        hide_spot = noone;
    }
    else exit;   // escondido: no se mueve, no dispara, no usa el gancho
}
else if (keyboard_check_pressed(ord("E")) && is_on_floor)
{
    var _spot = instance_nearest(x, y, o_hiding_spot);
    if (_spot != noone && _spot.cerca)
    {
        is_hidden = true;
        hide_spot = _spot;
        x = _spot.x;
        xSpeed = 0;
        grapple = 0;
        exit;
    }
}

// 1. Cuerda (click derecho) --------------------------
if (gr_cd > 0) gr_cd--;

// Lanzar el gancho hacia el mouse
if (mouse_check_button_pressed(mb_right) && grapple == 0 && gr_cd <= 0 && (is_on_floor || gr_charges > 0))
{
	if (!is_on_floor) gr_charges--;   // gasta carga solo si dispara en el aire
	grapple = 1;
	hook_x = x;
	hook_y = y - gr_hand;
	var ang = point_direction(hook_x, hook_y, mouse_x, mouse_y);
	hook_dx = lengthdir_x(1, ang);
	hook_dy = lengthdir_y(1, ang);
	hook_dist = 0;
	gr_hang_timer = 0;
}

// Soltar el click: cancela el gancho o suelta la cuerda
if (grapple != 0 && !mouse_check_button(mb_right))
{
	grapple = 0;
	gr_cd = gr_cooldown;
	gr_hang_timer = 0;
}

// Gancho en vuelo: avanza hacia el destino buscando colisión sólida
if (grapple == 1)
{
	repeat (gr_fly_speed)
	{
		hook_x += hook_dx;
		hook_y += hook_dy;
		hook_dist += 1;

		if (c_solid_point(hook_x, hook_y))
		{
			// Si recorrió al menos 16 px, se engancha con firmeza a la superficie
			if (hook_dist >= 16)
			{
				grapple = 2;
				anchor_x = hook_x;
				anchor_y = hook_y;
				rope_len = max(gr_min_len, point_distance(x, y - gr_hand, anchor_x, anchor_y));
				break;
			}
			else
			{
				// Pared pegada al cuerpo: cancela sin crear ancla fantasma
				grapple = 0;
				gr_cd = gr_cooldown;
				break;
			}
		}

		if (hook_dist >= gr_max)
		{
			grapple = 0;   // límite de alcance alcanzado
			gr_cd = gr_cooldown;
			break;
		}
	}
}

// ¿Está colgado en el aire?
var swinging = (grapple == 2 && !is_on_floor);

// 2. Input ----------------------
if (swinging)
{
	// Colgado: A/D empujan para balancearse
	if (keyboard_check(ord("D"))) xSpeed += gr_push;
	if (keyboard_check(ord("A"))) xSpeed -= gr_push;
}
else
{
	if(keyboard_check(ord("D")))
	{
		if(xSpeed < xSpeedMax) xSpeed += xAccel;
	}

	if(keyboard_check(ord("A")))
	{
		if(xSpeed > -xSpeedMax) xSpeed -= xAccel;
	}
}

// 3. Facing --------------------------
if (keyboard_check(ord("D")) && !keyboard_check(ord("A"))) facing = 1;
if (keyboard_check(ord("A")) && !keyboard_check(ord("D"))) facing = -1;
image_xscale = facing;

// 4. Frenados (no se frena mientras se columpia en el aire)
if (!swinging)
{
	// Frenado si se apretan ambas a la vez
	if(keyboard_check(ord("D")) and keyboard_check(ord("A"))) xSpeed = 0;
	// Frenado gradual si no se presiona ni A ni D
	if(!keyboard_check(ord("D")) and !keyboard_check(ord("A")))
	{
		if (xSpeed > 0) xSpeed = max(0, xSpeed - xAccel);
		else if (xSpeed < 0) xSpeed = min(0, xSpeed + xAccel);
	}
}

// 4.5 Cuerda: física del péndulo ---------------------
if (grapple == 2)
{
	// Fatiga al colgarse en el aire (no camper infinito en el techo)
	if (!is_on_floor)
	{
		gr_hang_timer++;
		if (gr_hang_timer >= gr_hang_max)
		{
			grapple = 0;
			gr_cd = gr_cooldown * 2;
			gr_hang_timer = 0;
		}
	}
	else
	{
		gr_hang_timer = 0;
	}

	var rx = x - anchor_x;
	var ry = (y - gr_hand) - anchor_y;
	var rd = max(point_distance(0, 0, rx, ry), 0.001);
	var nx = rx / rd;   // dirección desde el ancla hacia el player
	var ny = ry / rd;

	// W = tirar hacia el ancla, S = soltar más cuerda
	if (keyboard_check(ord("W")))
	{
		rope_len = max(gr_min_len, rope_len - gr_reel);
		if (rd > gr_min_len + 4)
		{
			xSpeed -= nx * gr_pull;
			ySpeed -= ny * gr_pull;
			// Si está parado en el suelo, un empujón para despegarse
			if (is_on_floor && ny > 0.3) ySpeed -= 2;
		}
	}
	if (keyboard_check(ord("S"))) rope_len = min(gr_max, rope_len + gr_reel);

	// Si la cuerda está tensa, se elimina la velocidad que aleja del ancla
	if (rd >= rope_len - 0.5)
	{
		var vr = xSpeed * nx + ySpeed * ny;
		if (vr > 0)
		{
			xSpeed -= vr * nx;
			ySpeed -= vr * ny;
		}
	}

	// Límite de velocidad
	var sp = point_distance(0, 0, xSpeed, ySpeed);
	if (sp > gr_speed_max)
	{
		xSpeed *= gr_speed_max / sp;
		ySpeed *= gr_speed_max / sp;
	}
}

// 5.Movimiento ------------------
	// Movimiento en X
var dist = abs(xSpeed);
var dir = sign(xSpeed);
while (dist > 0)
{
	var step = min(1, dist);
	if(!c_collision(x + dir * step, y)) x += dir * step;
	else { xSpeed = 0; break; }
	dist -= step;
}
	// Movimiento en Y
dist = abs(ySpeed);
dir = sign(ySpeed);
while (dist > 0)
{
	var step = min(1, dist);
	if (!c_collision(x, y + dir * step)) y += dir * step;
	else { ySpeed = 0; break; }
	dist -= step;
}

// 5.5 Cuerda: corregir la posición si se estiró ---------------
if (grapple == 2)
{
	var cx = x;
	var cy = y - gr_hand;
	var cd = point_distance(cx, cy, anchor_x, anchor_y);
	if (cd > rope_len)
	{
		var over = cd - rope_len;
		var ux = (anchor_x - cx) / cd;
		var uy = (anchor_y - cy) / cd;
		while (over > 0)
		{
			var s = min(1, over);
			if (!c_collision(x + ux * s, y + uy * s))
			{
				x += ux * s;
				y += uy * s;
			}
			else if (!c_collision(x + ux * s, y))
			{
				x += ux * s;
			}
			else if (!c_collision(x, y + uy * s))
			{
				y += uy * s;
			}
			over -= s;
		}
	}
}

// 6. Checks ----------------------
if (c_collision(x, y + 1))
{
	is_on_floor = 1;
	ySpeed = 0;
}
else
{
	is_on_floor = 0;
	ySpeed = min(ySpeed + grav, fallMax);
}
if (ySpeed < 0 && c_collision(x, y - 1)) ySpeed = 0;

if (c_collision(x, y + 1))
{
	is_on_floor = 1;
	ySpeed = 0;
	gr_charges = gr_charges_max;   // recarga al pisar el suelo
}


// 7. Salto ----------------------------
if (keyboard_check_pressed(vk_space))
{
	if (grapple == 2)
	{
		grapple = 0;
		gr_cd = gr_cooldown;
		ySpeed = -jumpSpeed * 0.9;
	}
	else if (is_on_floor)
	{
		ySpeed = -jumpSpeed;
	}
}
if (keyboard_check_released(vk_space) and ySpeed < 0) ySpeed *= 0.5; // En caso de soltar antes de tiempo realiza un salto pequeño

// 8.Ataques ---------------------

if (atkCooldown > 0) atkCooldown--;

var changeWeapon = (keyboard_check_pressed(ord("Q")) && canAttack);
if (changeWeapon) 
{
	var total = array_length(weaponSlots);
	if (total > 1)
	{
		current_weapon_index++;
		if (current_weapon_index >= total) current_weapon_index = 0;
		
		weapon = weaponSlots[current_weapon_index];
	}
}

if (mouse_check_button_pressed(mb_left) && atkCooldown <= 0)
{
	// Disparar o golpear suelta el gancho inmediatamente (manos ocupadas / retroceso)
	if (grapple != 0)
	{
		grapple = 0;
		gr_cd = gr_cooldown;
		gr_hang_timer = 0;
	}

	switch(weapon)
	{
		case "Bullet":
			c_att_blaster();
			muzzle_flash_timer = 4;
			break;
		case "Slash":
			c_att_slash();
			break;
	}
}

// 9. Invulnerabilidad y muerte ---------------------------
if (invul_timer > 0) invul_timer--;

c_tile_damage();

if (hp <= 0 && respawn_state == 0)
{
	respawn_state = 1;
	grapple = 0;
	is_alive = 0;
	xSpeed = 0;
	ySpeed = 0;
}
