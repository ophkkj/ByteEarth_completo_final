draw_set_alpha(alpha_imagem);
if (spr_cenas[cena_atual] != noone) {
    draw_sprite_stretched(spr_cenas[cena_atual], 0, 0, 0, display_get_gui_width(), display_get_gui_height());
}
draw_set_alpha(1);

if (txt_cenas[cena_atual] != "") {
    draw_set_alpha(alpha_texto);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fMenu);
    
    var espacamento_linhas = 35;
    var largura_maxima_texto = display_get_gui_width() - 100;
    
    draw_text_ext(display_get_gui_width() / 2, display_get_gui_height() / 2, txt_cenas[cena_atual], espacamento_linhas, largura_maxima_texto);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}

var x_da_caixa = 50; 
var y_da_caixa = display_get_gui_height() - 200; 
var largura_da_caixa = display_get_gui_width() - 100; 
var altura_da_caixa = 150; 
var largura_maxima_da_caixa = largura_da_caixa - 40;

draw_set_alpha(alpha_caixa);
draw_set_color(c_black);
draw_rectangle(x_da_caixa, y_da_caixa, x_da_caixa + largura_da_caixa, y_da_caixa + altura_da_caixa, false);
draw_set_color(c_white);

if (dialogo_nome[cena_atual] != "") {
    draw_set_font(fDavid);
    draw_text(x_da_caixa + 20, y_da_caixa - 30, dialogo_nome[cena_atual]);
}

var texto_exibido = string_copy(dialogo_texto[cena_atual], 1, floor(caracteres_desenhados));
draw_text_ext(x_da_caixa + 20, y_da_caixa + 20, texto_exibido, 25, largura_maxima_da_caixa);

var tamanho_texto = string_length(dialogo_texto[cena_atual]);
if (caracteres_desenhados >= tamanho_texto && dialogo_texto[cena_atual] != "") {
    
    draw_set_halign(fa_right);
    var alpha_aviso = abs(sin(current_time * 0.005)); 
    draw_set_alpha(alpha_aviso * alpha_caixa); 
    draw_text(x_da_caixa + largura_da_caixa - 20, y_da_caixa + altura_da_caixa - 30, "aperte ENTER...");
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}

draw_set_alpha(alpha_fade);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_color(c_white);