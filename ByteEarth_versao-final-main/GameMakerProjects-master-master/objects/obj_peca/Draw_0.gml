/// DRAW — obj_peca
var _bob = (estado == "parada") ? sin((t + tipo * 20) * 0.08) * 3 : 0;

if (estado == "parada") {
    draw_set_alpha(0.35);
    draw_ellipse_color(x - 12, y + 14, x + 12, y + 20, c_black, c_black, false);
    draw_set_alpha(1);
}

// brilho suave na cor da peça
var _cg = (tipo == 0) ? make_colour_rgb(55, 65, 90) : ((tipo == 1) ? make_colour_rgb(25, 85, 40) : make_colour_rgb(20, 95, 125));
gpu_set_blendmode(bm_add);
draw_circle_color(x, y + _bob, 26, _cg, c_black, false);
gpu_set_blendmode(bm_normal);

draw_sprite_ext(spr_peca, tipo, x, y + _bob, image_xscale, image_yscale, 0, c_white, 1);
