if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado
// Destranca o portal
if (trancada) {
    if (abrir_ao_limpar) {
        // modo "rua": abre quando não sobrar nenhum zumbi
        if (instance_number(obj_zumbi) == 0) trancada = false;
    }
    else if (variable_global_exists("tutorial_zumbi_morto") && global.tutorial_zumbi_morto) {
        // modo tutorial: abre quando o zumbi do tutorial morrer
        trancada = false;
    }
}

// O David encostou no portal aberto
if (!trancada && !saindo && destino != noone && instance_exists(obj_david)) {
    var d = obj_david;
    if (rectangle_in_rectangle(d.bbox_left, d.bbox_top, d.bbox_right, d.bbox_bottom,
                               x - larg / 2, y - alt, x + larg / 2, y) != 0) {
        saindo = true;
        var f = instance_create_depth(0, 0, -30000, obj_fade);
        f.destino = destino;
    }
}