x += xSpeed * dir;
image_xscale = dir;
if (place_meeting(x, y, o_floor_1)) instance_destroy();
if (x < 50 || x > room_width + 50) instance_destroy();