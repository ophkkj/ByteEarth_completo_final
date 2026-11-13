if (instance_exists(obj_transicao_zoom) && obj_transicao_zoom.fase == 0) {
    exit;
}

draw_set_font(fMenu);
draw_set_valign(fa_middle);

var _wgui = display_get_gui_width();
var _hgui = display_get_gui_height();

var _desenhar_texto_borda = function(_x, _y, _txt, _cor) {
    draw_set_color(c_black);
    draw_text(_x - 2, _y, _txt);
    draw_text(_x + 2, _y, _txt);
    draw_text(_x, _y - 2, _txt);
    draw_text(_x, _y + 2, _txt);
    draw_text(_x - 2, _y - 2, _txt);
    draw_text(_x + 2, _y - 2, _txt);
    draw_text(_x - 2, _y + 2, _txt);
    draw_text(_x + 2, _y + 2, _txt);
    draw_set_color(_cor);
    draw_text(_x, _y, _txt);
};

if (aba_atual == "principal") {
    var tam_menu = array_length(opcoes_menu);
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _novo_hover = -1;
    for(var i = 0; i < tam_menu; i++) {
        var posicao_y = (_hgui / 2) + (i * espacamento);
        var _str_w = string_width(opcoes_menu[i]);
        var _str_h = string_height(opcoes_menu[i]);
        var _x1 = (_wgui / 2) - (_str_w / 2);
        var _x2 = (_wgui / 2) + (_str_w / 2);
        var _y1 = posicao_y - (_str_h / 2);
        var _y2 = posicao_y + (_str_h / 2);
        if (point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2)) {
            _novo_hover = i;
        }
    }

    if (_novo_hover != -1) {
        if (_novo_hover != hover_index) {
            hover_index = _novo_hover;
            timer_alternancia = 0;
            estado_icone = false;
        }
        timer_alternancia++;
        if (timer_alternancia >= delay_troca) {
            estado_icone = !estado_icone;
            timer_alternancia = 0;
        }
    } else {
        hover_index = -1;
        timer_alternancia = 0;
    }

    var _sprite_desenhar = (estado_icone == false) ? spr_nave : spr_cerebro;
    var _pulsacao = 1 + pulsar_amplitude * sin(current_time * pulsar_velocidade);

    var _onda_cor = (sin(current_time * pulsar_velocidade) + 1) / 2;
    var _cor_texto_hover = merge_color(c_lime, c_red, _onda_cor);

    for(var i = 0; i < tam_menu; i++) {
        var posicao_y = (_hgui / 2) + (i * espacamento);

        if (i != hover_index) {
            draw_set_halign(fa_center);
            _desenhar_texto_borda(_wgui / 2, posicao_y, opcoes_menu[i], c_white);
        } else {
            var _str_w = string_width(opcoes_menu[i]);
            var _str_h = string_height(opcoes_menu[i]);
            
            var _spr_w_real = sprite_get_width(_sprite_desenhar);
            var _spr_h_real = sprite_get_height(_sprite_desenhar);
            var _escala_base = _str_h / max(_spr_w_real, _spr_h_real);
            var _final_scale = _escala_base * _pulsacao;
            
            var _icon_w = _spr_w_real * _final_scale;
            var _total_w = (_icon_w * 2) + (_str_w) + (icon_padding * 2);
            var _start_x = (_wgui / 2) - (_total_w / 2);
            
            draw_set_halign(fa_left);
            
            var _icon_lx = _start_x + (_icon_w / 2);
            draw_sprite_ext(_sprite_desenhar, 0, _icon_lx, posicao_y + offset_y_icone, _final_scale, _final_scale, 0, c_white, 1);
            
            var _text_x = _start_x + _icon_w + icon_padding;
            _desenhar_texto_borda(_text_x, posicao_y, opcoes_menu[i], _cor_texto_hover);
            
            var _icon_rx = _text_x + _str_w + icon_padding + (_icon_w / 2);
            draw_sprite_ext(_sprite_desenhar, 0, _icon_rx, posicao_y + offset_y_icone, _final_scale, _final_scale, 0, c_white, 1);
        }
    }
} else if (aba_atual == "opcoes") {
    draw_set_halign(fa_center);
    _desenhar_texto_borda(_wgui / 2, (_hgui / 2) - 100, "MENU DE OPÇÕES", c_yellow);

    var _cor_vol = (opcao_sel == 0) ? c_lime : c_white;
    _desenhar_texto_borda(_wgui / 2, (_hgui / 2) - 20, "Volume: " + string(round(volume_jogo * 100)) + "%", _cor_vol);
    
    draw_set_color(c_white);
    draw_rectangle((_wgui / 2) - 100, (_hgui / 2) + 5, (_wgui / 2) + 100, (_hgui / 2) + 15, true);
    draw_set_color(_cor_vol);
    draw_rectangle((_wgui / 2) - 100, (_hgui / 2) + 5, (_wgui / 2) - 100 + (200 * volume_jogo), (_hgui / 2) + 15, false);

    var _cor_bri = (opcao_sel == 1) ? c_lime : c_white;
    _desenhar_texto_borda(_wgui / 2, (_hgui / 2) + 50, "Brilho: " + string(round(brilho_jogo * 100)) + "%", _cor_bri);
    
    draw_set_color(c_white);
    draw_rectangle((_wgui / 2) - 100, (_hgui / 2) + 75, (_wgui / 2) + 100, (_hgui / 2) + 85, true);
    draw_set_color(_cor_bri);
    draw_rectangle((_wgui / 2) - 100, (_hgui / 2) + 75, (_wgui / 2) - 100 + (200 * brilho_jogo), (_hgui / 2) + 85, false);

    _desenhar_texto_borda(_wgui / 2, _hgui - 60, "[ ESC ] = Voltar / Sair", c_white);
}

if (brilho_jogo < 1.0) {
    draw_set_alpha(1.0 - brilho_jogo);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _wgui, _hgui, false);
    draw_set_alpha(1.0);
}

