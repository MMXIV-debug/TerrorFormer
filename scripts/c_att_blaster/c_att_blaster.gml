function c_att_blaster()
{
    var stunShot = instance_create_layer(x + 32 * facing, y - 4, "att", o_bullet);
	stunShot.dir = facing;
	atkCooldown = 15;
}