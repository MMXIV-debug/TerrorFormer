/// Cancela la persecución: el enemigo se frena y vuelve a IDLE con una pausa
function c_enemy_chase_stop()
{
    hangTimer = 0;
    chaseCooldown = chaseCooldownMax;
    state = Enemy_STATE.IDLE;
    c_enemy_set_wait();
    return 0;
}

/// Persecución: devuelve la velocidad horizontal.
/// Cruza huecos angostos, baja caídas cortas, y se frena en huecos grandes o caídas profundas.
function c_enemy_chase_move()
{
    if (chaseJumpTimer > 0) chaseJumpTimer--;

    // En el aire mantiene el impulso (salto = chaseJumpH, caída = chaseSpeed)
    if (!is_on_floor) return facing * ((air_hspeed > walkSpeed) ? air_hspeed : chaseSpeed);

    var dx = o_player.x - x;
    var dy = o_player.y - y; // dy < 0: player arriba | dy > 0: player abajo
    if (abs(dx) < 6) return 0; // alineado con el player: no vibrar

    var hs = facing * chaseSpeed;

    // Mira un poco más lejos que lo que avanza por frame
    var look  = max(2, ceil(chaseSpeed));
    var front = (facing == 1) ? bbox_right : bbox_left;
    var wall_ahead   = c_collision(x + facing * 2, y);
    var ground_ahead = c_solid_point(front + facing * look, y + 1);
    var hazard_ahead = c_enemy_hazard_at(front + facing * look, y)
                    || c_enemy_hazard_at(front + facing * look, y - 16)
                    || c_enemy_hazard_at(front + facing * look, y + 16);

    // 0. Peligro de pinchos o ácido al frente
    if (hazard_ahead)
    {
        // Intenta saltar con seguridad sobre el peligro
        var _md0 = maxDrop;
        maxDrop = 8;
        var _jump_safe = c_enemy_sim_jump(facing, -chaseJumpSpeed, chaseJumpH);
        maxDrop = _md0;

        if (_jump_safe && chaseJumpTimer <= 0)
        {
            ySpeed = -chaseJumpSpeed;
            air_hspeed = chaseJumpH;
            is_on_floor = false;
            chaseJumpTimer = 45;
            return facing * chaseJumpH;
        }

        // Si no puede saltarlo seguro, frena la persecución
        return c_enemy_chase_stop();
    }

    // 1. Sin piso adelante
    if (!wall_ahead && !ground_ahead)
    {
        // a) Hueco angosto (hasta chaseGapMax): hay piso al otro lado, lo cruza caminando
        if (c_solid_point(front + facing * (look + chaseGapMax), y + 1)) return hs;

        // b) Hueco ancho o borde: solo avanza si la caída es corta (se puede volver a subir)
        var _md = maxDrop;
        maxDrop = chaseMaxDrop;
        var _safe = c_enemy_sim_jump(facing, 0, chaseSpeed);
        maxDrop = _md;
        if (_safe) return hs;

        // c) Caída grande: se frena y cancela el chase
        return c_enemy_chase_stop();
    }

    // 2. Pared adelante, o el player está en una plataforma alta: intenta saltar
    var want_jump = wall_ahead || (dy < -24 && abs(dx) < chaseJumpRange && chaseJumpTimer <= 0);
    if (want_jump)
    {
        // Solo vale si aterriza al mismo nivel o más arriba (máx. 8 px más abajo)
        var _md2 = maxDrop;
        maxDrop = 8;
        var _ok = c_enemy_sim_jump(facing, -chaseJumpSpeed, chaseJumpH);
        maxDrop = _md2;

        if (_ok)
        {
            ySpeed = -chaseJumpSpeed;
            air_hspeed = chaseJumpH;
            is_on_floor = false;
            chaseJumpTimer = 45;
            return facing * chaseJumpH;
        }
    }

    // 3. Pared que no puede saltar: cancela
    if (wall_ahead) return c_enemy_chase_stop();

    return hs;
}