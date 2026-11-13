/// STEP — obj_avanca
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado

// Destranca: Fase 2 quando o zumbi do tutorial morre; Fase 4 quando todos os zumbis morrem
if (trancada) {
    if (abrir_ao_limpar) {
        if (instance_number(obj_zumbi) == 0) trancada = false;
    }
    else if (variable_global_exists("tutorial_zumbi_morto") && global.tutorial_zumbi_morto) {
        trancada = false;
    }
}

// Liberado: abre o caminho tirando a parede invisível da direita
if (!trancada && !parede_removida) {
    with (obj_solido) {
        if (x >= 1300) instance_destroy();
    }
    parede_removida = true;
}

// O David chegou na borda direita da fase: escurece a tela e vai para a próxima
if (!trancada && !saindo && destino != noone && instance_exists(obj_david)) {
    if (obj_david.bbox_right >= room_width - 10) {
        saindo = true;
        var f = instance_create_depth(0, 0, -30000, obj_fade);
        f.destino = destino;
    }
}
