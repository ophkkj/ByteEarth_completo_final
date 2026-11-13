/// DRAW — obj_computador (o computador gigante no cenário)

var verde = make_color_rgb(129, 246, 22);
var mx1 = x - larg / 2;
var mx2 = x + larg / 2;
var my2 = y - 70;
var my1 = my2 - alt;

// Base e pescoço
draw_set_alpha(1);
draw_set_color(make_color_rgb(44, 50, 72));
draw_roundrect_ext(x - 100, y - 16, x + 100, y, 8, 8, false);
draw_rectangle(x - 28, my2 - 2, x + 28, y - 12, false);

// Carcaça do monitor
draw_set_color(make_color_rgb(70, 78, 112));
draw_roundrect_ext(mx1, my1, mx2, my2, 18, 18, false);
draw_set_color(make_color_rgb(28, 32, 52));
draw_roundrect_ext(mx1 + 10, my1 + 10, mx2 - 10, my2 - 10, 10, 10, false);

// Tela
var sx1 = mx1 + 22, sy1 = my1 + 22, sx2 = mx2 - 22, sy2 = my2 - 22;
var cor_tela = usado ? make_color_rgb(40, 8, 12) : make_color_rgb(6, 14, 34);
var cor_linha = usado ? c_red : make_color_rgb(60, 180, 255);
draw_set_color(cor_tela);
draw_rectangle(sx1, sy1, sx2, sy2, false);

// "Código" piscando na tela
for (var i = 0; i < 12; i++) {
    var ly = sy1 + 16 + i * 21;
    var recuo = ((i * 7) mod 4) * 14;
    var comp = 50 + ((i * 53) mod 170);
    draw_set_alpha(0.30 + 0.20 * sin(current_time / 400 + i));
    draw_set_color(cor_linha);
    draw_rectangle(sx1 + 16 + recuo, ly, sx1 + 16 + recuo + comp, ly + 8, false);
}

// Texto central
var cy_tela = (sy1 + sy2) / 2;
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(x - 130, cy_tela - 24, x + 130, cy_tela + 24, false);
draw_set_alpha(1);
draw_set_color(usado ? c_red : verde);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(x, cy_tela, usado ? "ACESSO CONCLUIDO" : "> BYTE-OS_", 1.6, 1.6, 0);

// Contorno brilhante quando o David está perto
if (perto && !usado) {
    draw_set_alpha(0.5 + 0.4 * sin(current_time / 200));
    draw_set_color(verde);
    draw_roundrect_ext(mx1 - 3, my1 - 3, mx2 + 3, my2 + 3, 20, 20, true);
    draw_roundrect_ext(mx1 - 4, my1 - 4, mx2 + 4, my2 + 4, 20, 20, true);
}

// Volta ao normal
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
