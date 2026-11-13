/// DRAW — obj_ambiente

// névoa baixa: faixas cada vez mais densas perto do chão
var _nev = metro ? make_colour_rgb(30, 34, 52) : make_colour_rgb(46, 42, 50);
for (var s = 0; s < 8; s++) {
    draw_set_alpha(0.018 * (s + 1));
    draw_rectangle_color(0, 590 + s * 22, room_width, room_height, _nev, _nev, _nev, _nev, false);
}

// partículas
var _cp = metro ? make_colour_rgb(190, 205, 230) : make_colour_rgb(200, 190, 180);
for (var i = 0; i < n; i++) {
    draw_set_alpha(pa[i]);
    draw_circle_color(px[i], py[i], pr[i], _cp, _cp, false);
}

// piscada de luz do metrô
if (luz > 0) {
    draw_set_alpha(luz);
    draw_rectangle_color(0, 0, room_width, room_height, c_white, c_white, c_white, c_white, false);
}
draw_set_alpha(1);
