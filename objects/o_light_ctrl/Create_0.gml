light_surf = -1;
ambient = make_color_rgb(45, 70, 80); // Ambiente ligeramente más oscuro para mayor suspenso
dmg_tm = layer_tilemap_get_id("ts_dmg_obj");
terrain_tm = layer_tilemap_get_id("ts_terrain");
t = 0;
draw_set_circle_precision(64);
