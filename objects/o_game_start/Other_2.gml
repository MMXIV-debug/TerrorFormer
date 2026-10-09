// Particulas  disparos --------------

global.p_shot = part_type_create();

part_type_shape(global.p_shot,pt_shape_square);
part_type_size(global.p_shot,0.15,0.15,0,0);
part_type_scale(global.p_shot,1,1);
part_type_color3(global.p_shot, c_white, make_color_rgb(200, 130, 255), make_color_rgb(138, 43, 226));
part_type_alpha2(global.p_shot,1,0);
part_type_speed(global.p_shot,1,1,0,0);
part_type_direction(global.p_shot,0,359,0,0);
part_type_gravity(global.p_shot,0,270);
part_type_blend(global.p_shot,1);
part_type_life(global.p_shot,60,60);


// Particulas de aturdimiento ----------------------------

global.p_stun = part_type_create();

part_type_shape(global.p_stun,pt_shape_star);
part_type_size(global.p_stun,0.20,0.20,0,0);
part_type_scale(global.p_stun,1,1);
part_type_color3(global.p_stun,65535,8454143,65535);
part_type_alpha1(global.p_stun,1);
part_type_speed(global.p_stun,0.70,1,0,0);
part_type_direction(global.p_stun,0,359,1,0);
part_type_gravity(global.p_stun,0,270);
part_type_orientation(global.p_stun,0,359,0,0,1);
part_type_blend(global.p_stun,1);
part_type_life(global.p_stun,60,60);







