function c_enemy_zone()
{
	var x1, x2;
	
	// Segun a donde ve al eneigo este gira a la izquierda a la derecha
	if (facing == 1)
	{
		x1 = x;
		x2 = x + detectRange;
	}
	else
	{
		x1 = x - detectRange;
		x2 = x;
	}
	
	// La zona va de los pies hacia arriba
	var y1 = y - detectH;
	var y2 = y;
	
	return[x1, y1, x2, y2];
}