xSpeed = 12;
dir = 1;
stun_time = 120;   // frames aturdido (60 = 1 segundo)
tileId = layer_tilemap_get_id("ts_terrain");
all_collision = [o_floor_1, o_wall_1, tileId];

gpu_set_texfilter(false);