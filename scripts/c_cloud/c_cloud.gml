// Devuelve true si en (_x,_y) hay una nube que me sostiene.
// Solo es sólida si mis pies estaban por ENCIMA del tile (one-way).
function c_cloud(_x, _y)
{
    if (cloudId == -1 || cloud_drop > 0) return false;

    var _dx = _x - x;
    var _dy = _y - y;
    var _row = bbox_bottom + _dy;                 // fila de píxeles de mis pies en la posición a probar
    var _th = tilemap_get_tile_height(cloudId);
    var _top = floor(_row / _th) * _th;           // borde superior del tile en el que caerían los pies

    // Si mis pies ya estaban dentro del tile, lo atravieso (salto desde abajo)
    if (bbox_bottom > _top) return false;

    var _t = tilemap_get_at_pixel(cloudId, bbox_left + _dx, _row);
    if (_t > 0 && tile_get_index(_t) != 0) return true;

    _t = tilemap_get_at_pixel(cloudId, bbox_right + _dx, _row);
    if (_t > 0 && tile_get_index(_t) != 0) return true;

    return false;
}