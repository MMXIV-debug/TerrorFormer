// Input ----------------------

if(keyboard_check(ord("D")))
{
	if(xSpeed < xSpeedMax) xSpeed += xAccel;
}

if(keyboard_check(ord("A")))
{
	if(xSpeed > -xSpeedMax) xSpeed -= xAccel;
}

// Frenado si se apretan ambas a la vez
if(keyboard_check(ord("D")) and keyboard_check(ord("A"))) xSpeed = 0;
// Frenado gradual si no se presiona ni A ni D
if(!keyboard_check(ord("D")) and !keyboard_check(ord("A")))
{
	if (xSpeed > 0) xSpeed = max(0, xSpeed - xAccel);
	else if (xSpeed < 0) xSpeed = min(0, xSpeed + xAccel);
}

// Movimiento ------------------
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

// Checks ----------------------

if (!place_free(x, y + 1))
{
	is_on_floor = 1;
	ySpeed = 0;
}
else
{
	is_on_floor = 0;
	ySpeed += grav;
	
}