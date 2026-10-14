var futura_x = x + (xSpeed * dir); 
var futura_y = y + vspeed;
var t = tilemap_get_at_pixel(tileId, futura_x, futura_y); 

x += xSpeed * dir;
image_xscale = dir;

if (place_meeting(x, y, o_floor_1)) instance_destroy();

if (x < 50 || x > room_width + 50) instance_destroy();

if (t > 0)
{
    instance_destroy();
}