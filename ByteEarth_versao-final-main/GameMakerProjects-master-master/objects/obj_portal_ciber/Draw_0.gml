/// DRAW — obj_portal_ciber

var s = escala;
if (s < 0.02) exit;

var ciano = make_color_rgb(0, 255, 240);
var magenta = make_color_rgb(255, 0, 200);
var cx = x;
var cy = y - alt / 2;
var pulso = 1 + sin(t / 14) * 0.04;
var rx = larg / 2 * s * pulso;
var ry = alt / 2 * s * pulso;

// Brilho
draw_set_color(ciano);
draw_set_alpha(0.12);
draw_ellipse(cx - rx * 1.6, cy - ry * 1.15, cx + rx * 1.6, cy + ry * 1.15, false);
draw_set_color(magenta);
draw_set_alpha(0.14);
draw_ellipse(cx - rx * 1.3, cy - ry * 1.08, cx + rx * 1.3, cy + ry * 1.08, false);

// Buraco do portal
draw_set_alpha(1);
draw_set_color(make_color_rgb(8, 4, 24));
draw_ellipse(cx - rx, cy - ry, cx + rx, cy + ry, false);

// Linhas de varredura (efeito de monitor)
draw_set_color(ciano);
var passo = 7;
for (var yy = cy - ry + (t mod passo); yy < cy + ry; yy += passo) {
    var k = (yy - cy) / ry;
    var hw = rx * sqrt(max(0, 1 - k * k));
    draw_set_alpha(0.10 + 0.10 * abs(sin((yy + t) / 20)));
    draw_line(cx - hw, yy, cx + hw, yy);
}

// Chuva de bits
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
for (var i = 0; i < array_length(bits); i++) {
    var b = bits[i];
    var by = cy - ry + ((t * b.vel + b.off * ry * 2) mod (ry * 2));
    var bx = cx + b.fx * rx;
    var ddx = (bx - cx) / rx;
    var ddy = (by - cy) / ry;
    if (ddx * ddx + ddy * ddy < 0.8) {
        draw_set_alpha(0.35 + 0.5 * b.off);
        draw_set_color(b.cor ? ciano : magenta);
        draw_text_transformed(bx, by, b.car, 0.9 * s, 0.9 * s, 0);
    }
}

// Anéis
draw_set_alpha(1);
draw_set_color(ciano);
draw_ellipse(cx - rx, cy - ry, cx + rx, cy + ry, true);
draw_ellipse(cx - rx + 1, cy - ry + 1, cx + rx - 1, cy + ry - 1, true);
draw_ellipse(cx - rx + 2, cy - ry + 2, cx + rx - 2, cy + ry - 2, true);

var q = 0.65 + 0.08 * sin(t / 10);
draw_set_color(magenta);
draw_ellipse(cx - rx * q, cy - ry * q, cx + rx * q, cy + ry * q, true);

// Glitch: anéis deslocados de vez em quando
if ((t mod 47) < 4) {
    draw_set_alpha(0.7);
    draw_set_color(magenta);
    draw_ellipse(cx - rx + 6, cy - ry, cx + rx + 6, cy + ry, true);
    draw_set_color(ciano);
    draw_ellipse(cx - rx - 6, cy - ry, cx + rx - 6, cy + ry, true);
}

// Quadradinhos orbitando
draw_set_alpha(1);
for (var j = 0; j < 8; j++) {
    var a = t * 1.6 + j * 45;
    var ox = cx + lengthdir_x(rx * 1.18, a);
    var oy = cy + lengthdir_y(ry * 1.12, a);
    draw_set_color((j mod 2 == 0) ? ciano : magenta);
    draw_rectangle(ox - 3, oy - 3, ox + 3, oy + 3, false);
}

// David entrando: clarão no centro
if (engolindo) {
    draw_set_alpha(0.35);
    draw_set_color(c_white);
    draw_ellipse(cx - rx * 0.8, cy - ry * 0.8, cx + rx * 0.8, cy + ry * 0.8, false);
}

// Volta ao normal
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
