if (!iniciou && !instance_exists(obj_transicao_zoom)) {
    iniciou = true;
    alarm[0] = room_speed * 0.5; 
}

if (estado == 1) {
    alpha_texto = lerp(alpha_texto, 1, 0.04);
} else if (estado >= 2) {
    alpha_texto = lerp(alpha_texto, 0, 0.02);
}

if (estado >= 3 && estado <= 5) {
    alpha_imagem = lerp(alpha_imagem, 1, 0.04); 
} 
else if (estado == 6) {
    alpha_fade = lerp(alpha_fade, 1, 0.08);
    
    if (alpha_fade >= 0.98) {
        cena_atual += 1;
        
        if (cena_atual >= max_cenas) {
            audio_stop_all();
            room_goto(rm_fase_1); 
        } else {
            estado = 0;
            alpha_texto = 0;
            alpha_imagem = 0;
            alpha_fade = 0;
            alpha_caixa = 0;
            caracteres_desenhados = 0;
            alarm[0] = 1;
        }
    }
}

if (estado == 4 && dialogo_texto[cena_atual] != "") {
    alpha_caixa = lerp(alpha_caixa, 1, 0.1);
    
    var tamanho_texto = string_length(dialogo_texto[cena_atual]);
    if (caracteres_desenhados < tamanho_texto) {
        caracteres_desenhados += 0.6;
    }
} else {
    alpha_caixa = 0;
    if (estado != 5) { 
        caracteres_desenhados = 0;
    }
}

if (keyboard_check_pressed(vk_enter)) {
    var tamanho_texto = string_length(dialogo_texto[cena_atual]);

    if (estado > 0 && estado < 4) {
        alpha_texto = 0;
        alpha_imagem = 1;
        
        if (dialogo_texto[cena_atual] != "") {
            estado = 4;
            caracteres_desenhados = 0;
            alarm[0] = -1;
        } else {
            estado = 6;
            alarm[0] = -1;
        }
    } 
    else if (estado == 4 && dialogo_texto[cena_atual] != "") {
        if (caracteres_desenhados < tamanho_texto) {
            caracteres_desenhados = tamanho_texto;
        } else {
            estado = 5;
            alarm[0] = room_speed * 0.8;
        }
    }
}