/// DRAW — obj_boss_pilar
var _ciano = make_colour_rgb(80, 220, 255);
if (t < aviso) {
    var _a = 0.2 + 0.3 * (0.5 + 0.5 * sin(t * 0.6));
    draw_set_alpha(_a);
    draw_rectangle_color(x - 3, 0, x + 3, chao, _ciano, _ciano, _ciano, _ciano, false);
    draw_ellipse_color(x - larg / 2, chao - 6, x + larg / 2, chao + 6, _ciano, _ciano, false);
    draw_set_alpha(1);
} else {
    var _f = 1 - (t - aviso) / golpe;
    gpu_set_blendmode(bm_add);
    var _c1 = merge_colour(c_black, make_colour_rgb(40, 150, 200), _f);
    var _c2 = merge_colour(c_black, c_white, _f);
    draw_rectangle_color(x - larg / 2, 0, x + larg / 2, chao, _c1, _c1, _c1, _c1, false);
    draw_rectangle_color(x - larg / 5, 0, x + larg / 5, chao, _c2, _c2, _c2, _c2, false);
    gpu_set_blendmode(bm_normal);
}
