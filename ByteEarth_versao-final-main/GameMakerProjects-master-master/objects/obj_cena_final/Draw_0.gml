/// DRAW — obj_cena_final (desenha em coordenadas da room: 1366 x 768)

var W = room_width;
var H = room_height;

// Fundo preto
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(-10, -10, W + 10, H + 10, false);

// Pensamento atual
if (fase == 1 && fin_sub != 0 && fin_idx < array_length(fin_linhas)) {
    var _fl = fin_linhas[fin_idx];
    var _ftxt = string_copy(_fl.txt, 1, floor(fin_chars));
    var _ult = (fin_idx == array_length(fin_linhas) - 1);
    var _esc = _ult ? 1.6 : 1;   // só "Irmão." é maior
    var _tx = W / 2;
    var _ty = H / 2;
    if (_ult) {                  // e treme de leve
        _tx += random_range(-1.2, 1.2);
        _ty += random_range(-1.2, 1.2);
    }

    draw_set_font(fMenu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(fin_txt_alpha);
    draw_set_color(_fl.cor);
    draw_text_ext_transformed(_tx, _ty, _ftxt, 44, (W - 200) / _esc, _esc, _esc, 0);
}

// Volta ao normal
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
