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