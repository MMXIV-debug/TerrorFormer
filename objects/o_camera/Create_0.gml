// Control del view 0
cam = view_camera[0];
cam_h = camera_get_view_height(cam);
cam_w = camera_get_view_width(cam);

// Posicion real de la camara
cam_x = 0;
cam_y = 0;

smooth = 0.1;
offset_y = -30;

snapped = false;