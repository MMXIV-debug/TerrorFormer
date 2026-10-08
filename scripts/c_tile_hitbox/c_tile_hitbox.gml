function c_tile_hitbox(_idx)
{
    // [izq, arriba, der, abajo, daño]
    switch (_idx)
    {
        case 34:  return [4, 8, 28, 32, 2];    // pincho hacia arriba
        case 36:  return [4, 0, 28, 24, 2];    // pincho hacia abajo
        case 96:  return [8, 4, 32, 28, 2];    // pincho hacia la izquierda
        case 98:  return [0, 4, 24, 28, 2];    // pincho hacia la derecha
        case 38:
        case 40:  return [0, 6, 32, 32, 1];    // ácido (superficie)
        case 100:
        case 102: return [0, 0, 32, 32, 1];    // ácido lleno
    }
    return -1;
}