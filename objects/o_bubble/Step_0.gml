fase += 4;

// Sube
y -= vel_sube;

// Balanceo lateral leve mientras sube
x += sin(fase * 0.05) * 0.3;

// Progreso del recorrido: 0 = abajo, 1 = arriba
var prog = clamp((base_y - y) / max_altura, 0, 1);

// Aparece rápido, se desvanece al llegar arriba
image_alpha = sin(prog * pi);

// Crece un poco mientras sube
image_xscale = escala_base * (0.7 + prog * 0.5);
image_yscale = image_xscale;

// Al llegar arriba, reaparece abajo
if (prog >= 1) {
    reiniciar_burbuja();
}