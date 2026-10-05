// Punto de origen (donde colocas la burbuja en la room)
base_x = x;
base_y = y;

// Valores aleatorios por burbuja
function reiniciar_burbuja() {
    x = base_x + random_range(-6, 6);
    y = base_y;
    vel_sube    = random_range(0.3, 0.8);
    max_altura  = random_range(20, 48);
    escala_base = random_range(0.6, 1.1);
    fase        = random(360);
    image_alpha = 0;
}

reiniciar_burbuja();

// Para que no salgan todas a la vez, cada una empieza en un punto distinto de su recorrido
y -= random(max_altura);