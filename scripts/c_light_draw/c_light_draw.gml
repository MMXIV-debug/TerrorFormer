function c_light_draw(_x, _y, _r, _col, _k = 1)
{
    var c = merge_color(c_black, _col, _k * 0.5);
    draw_circle_color(_x, _y, _r, c, c_black, false);
    draw_circle_color(_x, _y, _r * 0.5, c, c_black, false);
}

/// @description Dibuja un haz cónico de linterna con oclusión/sombras de paredes de tilemap
function c_light_cone(_wx, _wy, _dir, _fov, _r, _col, _k, _ox, _oy, _tm)
{
    var _n = 36; // Cantidad de rayos para suavidad y rendimiento
    var _half_fov = _fov * 0.5;
    var _c = merge_color(c_black, _col, _k * 0.65);

    // 1. Raymarching para cada rayo en el cono
    var _len = array_create(_n + 1, _r);
    for (var i = 0; i <= _n; i++)
    {
        var _a  = _dir - _half_fov + (_fov * (i / _n));
        var _dx = lengthdir_x(1, _a);
        var _dy = lengthdir_y(1, _a);
        var _d  = 0;

        while (_d < _r)
        {
            var _nd = min(_d + 12, _r);
            if (_tm != -1 && tilemap_get_at_pixel(_tm, _wx + _dx * _nd, _wy + _dy * _nd) != 0)
            {
                // Refinamiento binario
                var _lo = _d;
                var _hi = _nd;
                repeat (3)
                {
                    var _mid = (_lo + _hi) * 0.5;
                    if (tilemap_get_at_pixel(_tm, _wx + _dx * _mid, _wy + _dy * _mid) != 0) _hi = _mid;
                    else _lo = _mid;
                }
                _d = _hi;
                break;
            }
            _d = _nd;
        }
        _len[i] = _d;
    }

    // 2. Haz exterior (Triangle Fan con degradado perimetral)
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(_wx - _ox, _wy - _oy, _c, 1);
    for (var k = 0; k <= _n; k++)
    {
        var _ang = _dir - _half_fov + (_fov * (k / _n));
        var _dd  = _len[k];
        var _side_dist = abs(k - (_n * 0.5)) / (_n * 0.5);
        var _fade_edge = 1 - (_side_dist * _side_dist * 0.55);
        var _edge_c = merge_color(c_black, _c, _fade_edge * (1 - (_dd / _r)));
        draw_vertex_color(_wx + lengthdir_x(_dd, _ang) - _ox, _wy + lengthdir_y(_dd, _ang) - _oy, _edge_c, 1);
    }
    draw_primitive_end();

    // 3. Núcleo central brillante
    var _core_c = merge_color(c_black, _col, _k * 0.45);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(_wx - _ox, _wy - _oy, _core_c, 1);
    for (var k = 0; k <= _n; k++)
    {
        var _ang = _dir - _half_fov + (_fov * (k / _n));
        var _dd  = min(_len[k], _r * 0.45);
        draw_vertex_color(_wx + lengthdir_x(_dd, _ang) - _ox, _wy + lengthdir_y(_dd, _ang) - _oy, c_black, 1);
    }
    draw_primitive_end();
}