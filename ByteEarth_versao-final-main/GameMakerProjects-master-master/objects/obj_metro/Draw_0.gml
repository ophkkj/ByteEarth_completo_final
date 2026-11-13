/// DRAW — obj_metro

var x1 = x - larg / 2;
var x2 = x + larg / 2;
var y1 = y - alt;
var y2 = y;

// Moldura de concreto
draw_set_color(make_color_rgb(70, 76, 96));
draw_rectangle(x1 - 10, y1 - 10, x2 + 10, y2, false);

// Boca escura da escada
draw_set_color(make_color_rgb(6, 8, 16));
draw_rectangle(x1, y1, x2, y2, false);

// Degraus descendo (cada degrau mais fundo e mais escuro)
var n = 7;
for (var i = 0; i < n; i++) {
    var t = i / n;
    var sy = y2 - alt * 0.08 - t * alt * 0.8;       // degraus sobem na tela = descem no túnel
    var sx = x1 + 8 + t * 14;
    var c = 90 - t * 70;
    draw_set_color(make_color_rgb(c, c + 6, c + 20));
    draw_rectangle(sx, sy, x2 - 8 - t * 14, sy + 5, false);
}

// Luz no fundo do túnel
draw_set_alpha(0.25 + 0.1 * sin(current_time / 220));
draw_set_color(make_color_rgb(255, 200, 90));
draw_ellipse(x - larg * 0.22, y1 + 6, x + larg * 0.22, y1 + alt * 0.35, false);
draw_set_alpha(1);

// Placa "M" em cima da entrada
var px1 = x - 26;
var py1 = y1 - 52;
draw_set_color(make_color_rgb(230, 60, 70));
draw_roundrect_ext(px1, py1, px1 + 52, py1 + 38, 8, 8, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(x, py1 + 19, "M", 1.4, 1.4, 0);

// Postes da placa
draw_set_color(make_color_rgb(70, 76, 96));
draw_rectangle(px1 + 8, py1 + 38, px1 + 12, y1 - 10, false);
draw_rectangle(px1 + 40, py1 + 38, px1 + 44, y1 - 10, false);

// Volta ao normal
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
