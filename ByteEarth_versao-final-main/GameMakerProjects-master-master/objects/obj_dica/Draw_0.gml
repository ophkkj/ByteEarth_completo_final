/// DRAW — obj_dica

if (!instance_exists(obj_david)) exit;

if (fonte != -1) draw_set_font(fonte);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var sc = escala_texto;
var pad = 6;
var esp = 4;
var alt_tecla = 22;
var n = array_length(teclas);

// Largura de cada tecla
var larguras = [];
var larg_teclas = 0;
for (var i = 0; i < n; i++) {
    larguras[i] = max(22, string_width(teclas[i]) * sc + 12);
    larg_teclas += larguras[i] + (i > 0 ? esp : 0);
}

var larg_texto = string_width(texto) * sc;
var alt_texto = string_height(texto) * sc;
var larg = max(larg_teclas, larg_texto) + pad * 2;
var alt = pad * 2 + alt_texto + (n > 0 ? alt_tecla + 3 : 0);

// O (x, y) é o centro da borda de baixo do painel
var x1 = x - larg / 2;
var x2 = x + larg / 2;
var y2 = y;
var y1 = y2 - alt;

// Painel
draw_set_alpha(0.9);
draw_set_color(make_color_rgb(18, 22, 38));
draw_roundrect_ext(x1, y1, x2, y2, 8, 8, false);
draw_triangle(x - 5, y2 - 1, x + 5, y2 - 1, x, y2 + 6, false); // setinha apontando pro David
draw_set_alpha(1);
draw_set_color(make_color_rgb(129, 246, 22));
draw_roundrect_ext(x1, y1, x2, y2, 8, 8, true);

// Teclas
var ty = y1 + pad;
if (n > 0) {
    var tx = x - larg_teclas / 2;
    for (var i = 0; i < n; i++) {
        var lw = larguras[i];

        draw_set_color(make_color_rgb(40, 46, 74));
        draw_roundrect_ext(tx, ty + 2, tx + lw, ty + alt_tecla + 2, 5, 5, false);   // base da tecla

        draw_set_color(make_color_rgb(236, 232, 255));
        draw_roundrect_ext(tx, ty, tx + lw, ty + alt_tecla, 5, 5, false);           // tecla

        draw_set_color(make_color_rgb(30, 34, 60));
        draw_text_transformed(tx + lw / 2, ty + alt_tecla / 2, teclas[i], sc, sc, 0);

        tx += lw + esp;
    }
    ty += alt_tecla + 3;
}

// Texto
draw_set_color(c_white);
draw_text_transformed(x, ty + alt_texto / 2, texto, sc, sc, 0);

// Volta ao normal
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
if (fonte != -1) draw_set_font(-1);