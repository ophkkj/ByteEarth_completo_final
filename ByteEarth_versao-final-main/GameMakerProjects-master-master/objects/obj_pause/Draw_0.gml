/// DRAW — obj_pause (aplica o brilho da tela e desenha o menu de pause)

var _W = room_width;
var _H = room_height;
var _ciano = make_colour_rgb(70, 220, 255);
var _verde = make_colour_rgb(120, 230, 90);

// ---------------- brilho (vale o tempo todo; 0.5 = normal) ----------------
if (global.brilho < 0.5) {
    draw_set_alpha((0.5 - global.brilho) * 2 * 0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _W, _H, false);
} else if (global.brilho > 0.5) {
    draw_set_alpha((global.brilho - 0.5) * 2 * 0.35);
    draw_set_color(c_white);
    draw_rectangle(0, 0, _W, _H, false);
}
draw_set_alpha(1);

if (!pausado) exit;

var _e = 1 - power(1 - anim, 3);     // suavização da abertura

// ---------------- tela meio preta ----------------
draw_set_alpha(0.62 * _e);
draw_set_color(c_black);
draw_rectangle(0, 0, _W, _H, false);

// faixas de cinema entrando por cima e por baixo
draw_set_alpha(0.9 * _e);
draw_rectangle(0, 0, _W, 64 * _e, false);
draw_rectangle(0, _H - 64 * _e, _W, _H, false);
draw_set_alpha(_e);
draw_set_color(_ciano);
draw_line(0, 64 * _e, _W, 64 * _e);
draw_line(0, _H - 64 * _e, _W, _H - 64 * _e);

// linhas de varredura que descem devagar
draw_set_alpha(0.05 * _e);
for (var yy = (t mod 8); yy < _H; yy += 8) draw_line(0, yy, _W, yy);

// partículas flutuando
for (var i = 0; i < n_part; i++) {
    draw_set_alpha(0.35 * _e);
    draw_circle_color(pp_x[i], pp_y[i], pp_r[i], _ciano, _ciano, false);
}

// painel central
draw_set_alpha(0.55 * _e);
draw_set_color(make_colour_rgb(6, 10, 24));
draw_rectangle(_W * 0.27, 190, _W * 0.73, 190 + 400 * _e, false);
draw_set_alpha(_e);
draw_set_color(_ciano);
draw_rectangle(_W * 0.27, 190, _W * 0.73, 190 + 400 * _e, true);

draw_set_font(fMenu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// título que desce pulsando
var _ty = lerp(40, 140, _e);
var _pulso = 1 + 0.03 * sin(t * 0.12);
draw_set_alpha(_e);
draw_set_color(make_colour_rgb(0, 60, 40));
draw_text_transformed(_W / 2 + 4, _ty + 4, (tela == 0) ? "PAUSADO" : "OPÇÕES", 2.8 * _pulso, 2.8 * _pulso, 0);
draw_set_color(_verde);
draw_text_transformed(_W / 2, _ty, (tela == 0) ? "PAUSADO" : "OPÇÕES", 2.8 * _pulso, 2.8 * _pulso, 0);

var _n = (tela == 0) ? array_length(principal) : array_length(linhas_opcoes);

// barra de seleção (desliza entre as opções)
draw_set_alpha(0.35 * _e);
draw_set_color(_ciano);
draw_rectangle(_W * 0.29, sel_y - 27, _W * 0.71, sel_y + 27, false);
draw_set_alpha(_e);
draw_rectangle(_W * 0.29, sel_y - 27, _W * 0.29 + 8, sel_y + 27, false);
draw_set_alpha(0.5 * _e * (0.6 + 0.4 * sin(t * 0.2)));
draw_rectangle(_W * 0.29, sel_y - 27, _W * 0.71, sel_y + 27, true);

// opções (entram uma de cada vez, vindo da esquerda)
for (var k = 0; k < _n; k++) {
    var _ek = clamp(anim * 1.8 - k * 0.15, 0, 1);
    _ek = 1 - power(1 - _ek, 3);
    var _x = _W / 2 + (1 - _ek) * -260;
    var _y = linha_y(k);
    var _sel = (k == opcao);
    var _esc = _sel ? 1.25 + 0.04 * sin(t * 0.2) : 1.0;
    draw_set_alpha(_ek);

    if (tela == 0) {
        draw_set_color(_sel ? c_white : make_colour_rgb(185, 190, 205));
        draw_text_transformed(_x, _y, _sel ? "> " + principal[k] + " <" : principal[k], _esc, _esc, 0);
    } else {
        draw_set_halign(fa_left);
        draw_set_color(_sel ? c_white : make_colour_rgb(185, 190, 205));
        draw_text_transformed(_x - _W * 0.20, _y, linhas_opcoes[k], _esc * 0.9, _esc * 0.9, 0);
        if (k < 2) {
            var _v = (k == 0) ? global.volume : global.brilho;
            var _x0 = _W * 0.50;
            var _x1 = _W * 0.70;
            draw_set_color(make_colour_rgb(30, 34, 50));
            draw_rectangle(_x0, _y - 7, _x1, _y + 7, false);
            draw_set_color(_sel ? _ciano : make_colour_rgb(70, 130, 160));
            draw_rectangle(_x0, _y - 7, _x0 + (_x1 - _x0) * _v, _y + 7, false);
            draw_set_color(c_white);
            draw_circle(_x0 + (_x1 - _x0) * _v, _y, _sel ? 13 : 10, false);
            draw_set_halign(fa_right);
            draw_text_transformed(_x1 + _W * 0.045, _y, string(round(_v * 100)) + "%", 0.8, 0.8, 0);
        } else {
            draw_set_halign(fa_center);
            draw_text_transformed(_W / 2 + (1 - _ek) * -260, _y, _sel ? "> Voltar <" : "Voltar", _esc, _esc, 0);
        }
        draw_set_halign(fa_center);
    }
}

// dicas
draw_set_alpha(0.8 * _e);
draw_set_color(make_colour_rgb(150, 155, 170));
if (tela == 0) {
    draw_text_transformed(_W / 2, _H - 32, "W/S ou setas + ENTER   |   mouse também funciona   |   ESC ou P: voltar ao jogo", 0.55, 0.55, 0);
} else {
    draw_text_transformed(_W / 2, _H - 32, "A/D ou setas esquerda/direita ajustam   |   clique e arraste nas barras   |   brilho: 50% = normal", 0.55, 0.55, 0);
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
