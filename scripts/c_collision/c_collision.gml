function c_collision(_x, _y)
{
	return place_meeting(_x, _y, tileId) || place_meeting(_x, _y, all_collision);
}