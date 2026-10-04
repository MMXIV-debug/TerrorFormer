function c_solid_point(_px, _py)
{
    for (var i = 0; i < array_length(all_collision); i++)
    {
        var hit = collision_point(_px, _py, all_collision[i], false, true);
        if (hit != noone && hit != 0) return true;
    }
    return false;
}