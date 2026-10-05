// 0. Cuerda (click derecho) --------------------------
if (gr_cd > 0) gr_cd--;

// Lanzar el gancho hacia el mouse
if (mouse_check_button_pressed(mb_right) && grapple == 0 && gr_cd <= 0)
{
	grapple = 1;
	hook_x = x;
	hook_y = y - gr_hand;
	var ang = point_direction(hook_x, hook_y, mouse_x, mouse_y);
	hook_dx = lengthdir_x(1, ang);
	hook_dy = lengthdir_y(1, ang);
	hook_dist = 0;
}

// Soltar el click: cancela el gancho o suelta la cuerda
if (grapple != 0 && !mouse_check_button(mb_right))
{
	grapple = 0;
	gr_cd = gr_cooldown;
}

// Gancho en vuelo: avanza de a 4 px buscando algo sólido
if (grapple == 1)
{
	repeat (gr_fly_speed div 4)
	{
		var hx = hook_x + hook_dx * 4;
		var hy = hook_y + hook_dy * 4;

		if (c_solid_point(hx, hy))
		{
			// Acercarse de a 1 px hasta tocar la superficie
			repeat (4)
			{
				if (c_solid_point(hook_x + hook_dx, hook_y + hook_dy)) break;
				hook_x += hook_dx;
				hook_y += hook_dy;
			}
			grapple = 2;
			anchor_x = hook_x;
			anchor_y = hook_y;
			rope_len = max(gr_min_len, point_distance(x, y - gr_hand, anchor_x, anchor_y));
			break;
		}

		hook_x = hx;
		hook_y = hy;
		hook_dist += 4;

		if (hook_dist >= gr_max)
		{
			grapple = 0;   // no pegó con nada: se recoge
			gr_cd = gr_cooldown;
			break;
		}
	}
}

// ¿Está colgado en el aire?
var swinging = (grapple == 2 && !is_on_floor);

// 1. Input ----------------------
if (swinging)
{
	// [NUEVO] Colgado: A/D empujan para balancearse
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

// 2. Facing --------------------------
if (keyboard_check(ord("D")) && !keyboard_check(ord("A"))) facing = 1;
if (keyboard_check(ord("A")) && !keyboard_check(ord("D"))) facing = -1;
image_xscale = facing;

// 3. Frenados (no se frena mientras se columpia en el aire)
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

// 3.5 Cuerda: física del péndulo ---------------------
if (grapple == 2)
{
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

// 4.Movimiento ------------------
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

// 4.5 Cuerda: corregir la posición si se estiró ---------------
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
			if (!c_collision(x + ux * s, y)) x += ux * s;
			if (!c_collision(x, y + uy * s)) y += uy * s;
			over -= s;
		}
	}
}

// 5. Checks ----------------------
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


// 6. Salto ----------------------------

if (keyboard_check_pressed(vk_space) && is_on_floor) ySpeed = -jumpSpeed;
if (keyboard_check_released(vk_space) and ySpeed < 0) ySpeed *= 0.5; // En caso de soltar antes de tiempo realiza un salto pequeño

// 7.Ataques ---------------------

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
	switch(weapon)
	{
		case "Slash":
			c_att_slash();
			break;
		case "Bullet":
			c_att_blaster()
			break;
	}
}

// 8. Invulnerabilidad y muerte ---------------------------
if (invul_timer > 0) invul_timer--;

if (hp <= 0)
{
	// Reaparece en el punto de respawn
	x = spawn_x;
	y = spawn_y;
	xSpeed = 0;
	ySpeed = 0;
	hp = hpMax;
	invul_timer = invulMax;
	grapple = 0;   // Suelta la cuerda al morir

	// La cámara salta directo al player (si no, viajaría deslizándose por todo el mapa)
	if (instance_exists(o_camera)) o_camera.snapped = false;
}