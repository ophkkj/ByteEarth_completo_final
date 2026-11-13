/// STEP — obj_metro
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado

// O David encostou na entrada: escurece a tela e teleporta para a próxima fase
if (!saindo && instance_exists(obj_david)) {
    var d = obj_david;
    if (rectangle_in_rectangle(d.bbox_left, d.bbox_top, d.bbox_right, d.bbox_bottom,
                               x - larg / 2, y - alt, x + larg / 2, y) != 0) {
        saindo = true;
        var f = instance_create_depth(0, 0, -30000, obj_fade); // fade to black
        f.destino = destino;                                    // room_goto acontece com a tela 100% preta
    }
}
