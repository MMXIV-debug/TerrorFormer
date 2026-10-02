function c_att_blaster()
{
	var b = instance_create_layer(x + 30 * facing, y - 32, "att", o_bullet);
	b.dir = facing;
	atkCooldown = 15;
}