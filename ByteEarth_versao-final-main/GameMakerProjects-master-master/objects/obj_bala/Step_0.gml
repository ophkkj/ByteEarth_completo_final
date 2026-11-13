/// STEP — obj_bala
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado

vida++;

// Mantém o sprite de cabeça pra cima quando a bala vai para a esquerda
image_yscale = (direction > 90 && direction < 270) ? -abs(image_yscale) : abs(image_yscale);

// Bateu em parede ou chão (ignora os 2 primeiros frames, para não morrer ao nascer)
if (vida > 2 && collision_line(xprevious, yprevious, x, y, obj_solido, true, true) != noone) {
    // Bateu: faz o impacto no ponto onde a bala tocou o sólido
    var _im = instance_create_depth(x, y, -10002, obj_bala_impacto);
    _im.image_xscale = escala_impacto;
    _im.image_yscale = escala_impacto;
    instance_destroy();
}

// Saiu da room
if (!point_in_rectangle(x, y, -50, -50, room_width + 50, room_height + 50)) {
    instance_destroy();
}