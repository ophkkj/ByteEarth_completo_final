/// STEP — obj_fade

if (estado == 0) {
    alpha = min(1, alpha + 0.05);
    if (alpha >= 1) {
        estado = 1;
        if (destino != noone) room_goto(destino);
    }
} else {
    alpha = max(0, alpha - 0.05);
    if (alpha <= 0) instance_destroy();
}