// 1. Input ----------------------

if(keyboard_check(ord("D")))
{
	if(xSpeed < xSpeedMax) xSpeed += xAccel;
}

if(keyboard_check(ord("A")))
{
	if(xSpeed > -xSpeedMax) xSpeed -= xAccel;
}

// 2. Facing --------------------------
if (keyboard_check(ord("D")) && !keyboard_check(ord("A"))) facing = 1;
if (keyboard_check(ord("A")) && !keyboard_check(ord("D"))) facing = -1;
image_xscale = facing;

// 3. Frenados
// Frenado si se apretan ambas a la vez
if(keyboard_check(ord("D")) and keyboard_check(ord("A"))) xSpeed = 0;
// Frenado gradual si no se presiona ni A ni D
if(!keyboard_check(ord("D")) and !keyboard_check(ord("A")))
{
	if (xSpeed > 0) xSpeed = max(0, xSpeed - xAccel);
	else if (xSpeed < 0) xSpeed = min(0, xSpeed + xAccel);
}

// 4.Movimiento ------------------
	// Movimiento en X
if(xSpeed != 0)
{
	if(xSpeed > 0)
	{
		move_contact_solid(0, xSpeed);
	}
	else
	{
		move_contact_solid(180, abs(xSpeed));
	}
}
	// Movimiento en Y
if(ySpeed != 0)
{
	if(ySpeed > 0)
	{
		move_contact_solid(270, ySpeed);
	}
	else
	{
		move_contact_solid(90, abs(ySpeed));
	}
}

// 5.Checks ----------------------

if (!place_free(x, y + 1))
{
	is_on_floor = 1;
	ySpeed = 0;
}
else
{
	is_on_floor = 0;
	ySpeed = min(ySpeed + grav, fallMax);
	
}
if (ySpeed < 0 && !place_free(x, y - 1)) ySpeed = 0;


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


