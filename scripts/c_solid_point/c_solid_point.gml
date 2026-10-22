function c_solid_point(_px, _py)
{
    var _tm = layer_tilemap_get_id("ts_terrain");
    if (_tm != -1)
    {
        var _t = tilemap_get_at_pixel(_tm, _px, _py);
        if (_t > 0 && tile_get_index(_t) != 0) return true;
    }
	
	var _cm = layer_tilemap_get_id("ts_cloud");
	if (_cm != -1)
	{
	    var _tc = tilemap_get_at_pixel(_cm, _px, _py);
	    if (_tc > 0 && tile_get_index(_tc) != 0) return true;
	}


    if (position_meeting(_px, _py, o_floor_1) || position_meeting(_px, _py, o_wall_1))
    {
        return true;
    }

    return false;
}