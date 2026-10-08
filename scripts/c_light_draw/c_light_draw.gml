function c_light_draw(_x, _y, _r, _col, _k = 1)
{
    var c = merge_color(c_black, _col, _k * 0.5);
    draw_circle_color(_x, _y, _r, c, c_black, false);
    draw_circle_color(_x, _y, _r * 0.5, c, c_black, false);
}