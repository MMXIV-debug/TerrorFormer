function c_light_cast(_wx, _wy, _r, _col, _k, _ox, _oy, _tm)
{
    var _n = 96;                                    // cantidad de rayos
    var _c = merge_color(c_black, _col, _k * 0.5);

    // 1. Largo de cada rayo: se corta al chocar con un tile
    var _len = array_create(_n + 1, _r);
    for (var i = 0; i <= _n; i++)
    {
        var _a  = i / _n * 360;
        var _dx = lengthdir_x(1, _a);
        var _dy = lengthdir_y(1, _a);
        var _d  = 0;

        while (_d < _r)
        {
            var _nd = min(_d + 8, _r);
            if (tilemap_get_at_pixel(_tm, _wx + _dx * _nd, _wy + _dy * _nd) != 0)
            {
                // afinar el punto de choque
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

    // 2. Dibujar el polígono de luz (mismo degradado que antes)
    for (var f = 0; f < 2; f++)
    {
        var _rr = (f == 0) ? _r : _r * 0.5;
        draw_primitive_begin(pr_trianglefan);
        draw_vertex_color(_wx - _ox, _wy - _oy, _c, 1);
        for (var k = 0; k <= _n; k++)
        {
            var _dd  = min(_len[k], _rr);
            var _ang = k / _n * 360;
            var _e   = merge_color(_c, c_black, _dd / _rr);
            draw_vertex_color(_wx + lengthdir_x(_dd, _ang) - _ox, _wy + lengthdir_y(_dd, _ang) - _oy, _e, 1);
        }
        draw_primitive_end();
    }
}