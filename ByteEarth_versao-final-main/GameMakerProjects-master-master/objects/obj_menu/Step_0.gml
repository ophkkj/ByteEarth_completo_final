if (instance_exists(obj_transicao_zoom) && obj_transicao_zoom.fase == 0) {
    exit;
}

if (aba_atual == "principal") {
    if (mouse_check_button_pressed(mb_left)) {
        if (hover_index != -1) {
            switch (hover_index) {
                case 0:
                    audio_stop_sound(snd_musica_menu);
                    if (!instance_exists(obj_transicao_zoom)) {
                        var _transicao = instance_create_layer(0, 0, "Instances", obj_transicao_zoom);
                        _transicao.destino_room = rm_cutscene;
                    }
                    break;
                case 1:
                    if (!instance_exists(obj_transicao_zoom)) {
                        var _transicao = instance_create_layer(0, 0, "Instances", obj_transicao_zoom);
                        _transicao.destino_aba = "opcoes";
                    }
                    break;
                case 2:
                    break;
                case 3:
                    game_end();
                    break;
            }
        }
    }
} else if (aba_atual == "opcoes") {
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        opcao_sel = (opcao_sel == 0) ? 1 : 0;
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        opcao_sel = (opcao_sel == 1) ? 0 : 1;
    }

    var _dir = 0;
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) _dir = 0.01;
    if (keyboard_check(vk_left) || keyboard_check(ord("A")))  _dir = -0.01;

    if (_dir != 0) {
        if (opcao_sel == 0) {
            volume_jogo = clamp(volume_jogo + _dir, 0, 1);
            audio_master_gain(volume_jogo);
        } else if (opcao_sel == 1) {
            brilho_jogo = clamp(brilho_jogo + _dir, 0.2, 1.0);
        }
    }

    if (keyboard_check_pressed(vk_escape)) {
        if (!instance_exists(obj_transicao_zoom)) {
            var _transicao = instance_create_layer(0, 0, "Instances", obj_transicao_zoom);
            _transicao.destino_aba = "principal";
        }
    }
}