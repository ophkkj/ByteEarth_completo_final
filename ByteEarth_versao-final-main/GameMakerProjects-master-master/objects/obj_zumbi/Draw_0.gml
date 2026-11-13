/// DRAW — obj_zumbi

// Sombra no chão (fases 2 a 5)
if (cor_ambiente != c_white) {
    var _gy = y;
    var _n = 0;
    while (!place_meeting(x, _gy + 1, obj_solido) && _n < 400) { _gy += 1; _n++; }
    var _enc = clamp((_gy - y) / 220, 0, 0.6);
    var _w = 24 * (1 - _enc);
    draw_set_alpha(0.38 * (1 - _enc) * image_alpha);
    draw_ellipse_color(x - _w, _gy - 5, x + _w, _gy + 2, c_black, c_black, false);
    draw_set_alpha(1);
}

draw_self();
