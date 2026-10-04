if (!instance_exists(o_player))
{
	exit;
}

// 1. A donde va a mirar la camara
var tx = o_player.x - cam_w / 2;
var ty = o_player.y + offset_y - cam_h / 2;

// 2. Acercamiento suave
var s = snapped ? smooth : 1;
snapped = true;
cam_x = lerp(cam_x, tx, s);
cam_y = lerp(cam_y, ty, s);

// 3. No se sale del mapa
cam_x = clamp(cam_x, 0, room_width - cam_w);
cam_y = clamp(cam_y, 0, room_height - cam_h);

// 4. Un redondeo para que no tiemble el oixel art
camera_set_view_pos(cam, round(cam_x), round(cam_y));