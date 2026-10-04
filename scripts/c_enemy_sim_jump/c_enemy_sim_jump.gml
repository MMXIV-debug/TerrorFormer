/// Simula un salto/caída sin mover al enemigo.
/// _dir: -1 o 1 | _vy0: velocidad vertical inicial (-jumpSpeed = salto, 0 = solo caminar y caer)
/// _hs: velocidad horizontal en el aire
/// Devuelve true si aterriza en un sitio razonable.
function c_enemy_sim_jump(_dir, _vy0, _hs)
{
    var sx = x;
    var sy = y;
    var vy = _vy0;
    var airborne = false;

    for (var f = 0; f < 150; f++)
    {
        // 1. Suelo / gravedad (igual que en el Step real)
        if (c_collision(sx, sy + 1) && vy >= 0)
        {
            vy = 0;
            if (airborne)
            {
                // Aterrizó: ¿vale la pena?
                var progress = (sx - x) * _dir;
                var okProgress = (_vy0 >= 0) || (progress >= minProgress);
                var okDrop = (sy - y) <= maxDrop;
                return (okProgress && okDrop);
            }
        }
        else
        {
            vy = min(vy + grav, fallMax);
            airborne = true;
        }

        // 2. Mover en X
        var d = abs(_hs);
        while (d > 0)
        {
            var st = min(1, d);
            if (!c_collision(sx + _dir * st, sy)) sx += _dir * st;
            else break;
            d -= st;
        }

        // 3. Mover en Y
        d = abs(vy);
        var vdir = sign(vy);
        while (d > 0)
        {
            var st2 = min(1, d);
            if (!c_collision(sx, sy + vdir * st2)) sy += vdir * st2;
            else
            {
                if (vdir < 0) vy = 0;   // golpeó el techo
                break;
            }
            d -= st2;
        }

        // 4. Cayó demasiado: no lo intenta
        if (sy - y > maxDrop) return false;
    }

    return false;
}