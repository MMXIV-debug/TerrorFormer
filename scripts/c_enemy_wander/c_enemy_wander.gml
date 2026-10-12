/// Pasa a la acción "quieto mirando a los lados"
function c_enemy_set_wait()
{
    idleAction = IDLE_ACTION.WAIT;
    idleTimer = irandom_range(waitMin, waitMax);
    lookTimer = irandom_range(lookMin, lookMax);
}

/// Pasa a la acción "caminar"
function c_enemy_set_walk()
{
    idleAction = IDLE_ACTION.WALK;
    idleTimer = irandom_range(walkMin, walkMax);
    if (irandom(1) == 0) facing *= -1;   // a veces arranca hacia el otro lado
}

/// Ejecuta el salto: impulso vertical y velocidad horizontal en el aire
function c_enemy_jump(_hs)
{
    ySpeed = -jumpSpeed;
    air_hspeed = _hs;
    is_on_floor = false;
    decisionCooldown = 60;
}

/// Detecta si hay un peligro mortal (pinchos o ácido) en la posición
function c_enemy_hazard_at(_px, _py)
{
    if (_px < 0 || _px >= room_width || _py < 0 || _py >= room_height) return false;
    var _tm = layer_tilemap_get_id("ts_dmg_obj");
    if (_tm == -1) return false;
    var _tile = tilemap_get_at_pixel(_tm, _px, _py);
    if (_tile == 0 || _tile == -1) return false;
    var _idx = tile_get_index(_tile);
    return (_idx != 0 && c_tile_hitbox(_idx) != -1);
}