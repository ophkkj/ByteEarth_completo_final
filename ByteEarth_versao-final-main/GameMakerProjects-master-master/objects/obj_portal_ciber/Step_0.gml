/// STEP — obj_portal_ciber
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado
t++;
escala = lerp(escala, 1, 0.07);

// O David encostou no portal já formado: vai para a room da cutscene final
if (escala > 0.9 && instance_exists(obj_david) && !instance_exists(obj_fade)) {
    if (abs(obj_david.x - x) < 40 && abs(obj_david.y - y) < 120) {
        engolindo = true;
        audio_stop_sound(snd_david_andando);
        with (obj_david) { controle_travado = true; auto_dir = 0; }
        if (instance_exists(obj_fase5_ctrl)) {
            with (obj_fase5_ctrl) { saindo = true; estado = 8; }
        }
        var f = instance_create_depth(0, 0, -30000, obj_fade);
        f.destino = rm_cutscene_final;
    }
}
