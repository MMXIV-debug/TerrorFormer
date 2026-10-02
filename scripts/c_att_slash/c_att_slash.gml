function c_att_slash()
{
	var s = instance_create_layer(x + 20 * facing, y - 32, "att", o_slash);
	s.dir = facing;
	s.owner = id;
	s.image_xscale = facing;   
	atkCooldown = 15;
}