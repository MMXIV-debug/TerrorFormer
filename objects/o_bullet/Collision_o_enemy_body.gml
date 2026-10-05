var _t = stun_time;
with (other)
{
	state = Enemy_STATE.STUN;
	stunTimer = _t;
}
instance_destroy();