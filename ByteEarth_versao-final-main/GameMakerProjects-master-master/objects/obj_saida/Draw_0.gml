/// DRAW — obj_saida

var cor = trancada ? make_color_rgb(230, 60, 70) : make_color_rgb(129, 246, 22);
var pulso = 1 + sin(current_time / 260) * 0.06;
var cx = x;
var cy = y - alt / 2;
var rx = larg / 2 * pulso;
var ry = alt / 2 * pulso;

// Brilho
draw_set_color(cor);
draw_set_alpha(0.18);
draw_ellipse(cx - rx * 1.5, cy - ry * 1.15, cx + rx * 1.5, cy + ry * 1.15, false);
draw_set_alpha(0.35);
draw_ellipse(cx - rx * 1.2, cy - ry * 1.07, cx + rx * 1.2, cy + ry * 1.07, false);

// Buraco do portal
draw_set_alpha(1);
draw_set_color(make_color_rgb(14, 18, 34));
draw_ellipse(cx - rx, cy - ry, cx + rx, cy + ry, false);

// Anel
draw_set_color(cor);
draw_ellipse(cx - rx, cy - ry, cx + rx, cy + ry, true);
draw_ellipse(cx - rx + 1, cy - ry + 1, cx + rx - 1, cy + ry - 1, true);
draw_ellipse(cx - rx + 2, cy - ry + 2, cx + rx - 2, cy + ry - 2, true);

// Miolo pulsando
draw_set_alpha(0.25 + 0.15 * sin(current_time / 180));
draw_ellipse(cx - rx * 0.6, cy - ry * 0.6, cx + rx * 0.6, cy + ry * 0.6, false);

// Texto acima do portal
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_text_transformed(cx, cy - ry - 8, trancada ? "BLOQUEADA" : "CONTINUAR", 0.8, 0.8, 0);

// Volta ao normal
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);