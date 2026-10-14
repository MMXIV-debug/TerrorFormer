//  1. Gravedad ------------
if (c_collision(x, y + 1))
{
    is_on_floor = true;
    ySpeed = 0;
}
else
{
    is_on_floor = false;
    ySpeed = min(ySpeed + grav, fallMax);
}
if (ySpeed < 0 && c_collision(x, y - 1)) ySpeed = 0;   // golpe con el techo

// 2. Checks --------------------------
if (hspeed > 0) 
{
	if (place_meeting(x + xCheck, y, all_collision))
	{
		c_flip();
	}
	else
	{
		if (collision_rectangle(x + 18, y, x + 20, y + 2, all_collision, false, true) == noone)
		{
			c_flip();
		}
	}
}
if (hspeed < 0)
{
	if (place_meeting(x - xCheck, y, all_collision))
	{
		c_flip();
	}
		else
	{
		if (collision_rectangle(x - 18, y, x - 20, y + 2, all_collision, false, true) == noone)
		{
			c_flip();
		}
	}
}