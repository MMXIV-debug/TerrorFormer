function c_att_blaster()
{
    var b = instance_create_layer(x + 32 * facing, y - 4, "att", o_bullet);
	b.dir = facing;
	atkCooldown = 15;
}