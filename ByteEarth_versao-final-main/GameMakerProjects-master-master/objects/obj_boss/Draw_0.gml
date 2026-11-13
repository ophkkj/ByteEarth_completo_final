/// DRAW — obj_boss (Paul)

var _ox = (tremor > 0) ? irandom_range(-3, 3) : 0;
var _cor = (fase == 3) ? make_colour_rgb(255, 150, 255) : ((fase == 2) ? make_colour_rgb(255, 175, 175) : c_white);

// sombra no chão (menor quando ele salta)
var _alt = clamp((chao_y - y) / 260, 0, 1);
var _lw = 95 * (1 - _alt * 0.4);
draw_set_alpha(0.5 * (1 - _alt * 0.6));
draw_ellipse_color(x - _lw, chao_y - 8, x + _lw, chao_y + 7, c_black, c_black, false);
draw_set_alpha(1);

draw_sprite_ext(sprite_index, image_index, x + _ox, y, facing, 1, 0, _cor, 1);

// barra de vida pequena sobre a cabeça do chefe (sempre visível, em coordenadas do jogo)
if (barra_ativa && estado != "derrotado" && estado != "bomba" && estado != "explodiu") {
    var _bw = 130;
    var _bx = x - _bw / 2;
    var _by = y - 272;
    draw_set_color(c_black);
    draw_rectangle(_bx - 2, _by - 2, _bx + _bw + 2, _by + 11, false);
    draw_set_color(make_colour_rgb(60, 60, 72));
    draw_rectangle(_bx, _by, _bx + _bw, _by + 9, false);
    draw_set_color((fase == 3) ? make_colour_rgb(230, 60, 255) : ((fase == 2) ? make_colour_rgb(255, 70, 60) : make_colour_rgb(70, 220, 255)));
    draw_rectangle(_bx, _by, _bx + _bw * clamp(hp / hp_max, 0, 1), _by + 9, false);
    draw_set_color(c_white);
}

// flash branco ao levar tiro
if (flash > 0) {
    gpu_set_fog(true, c_white, 0, 1);
    draw_sprite_ext(sprite_index, image_index, x + _ox, y, facing, 1, 0, c_white, 0.7);
    gpu_set_fog(false, c_white, 0, 1);
}

// halo do núcleo de energia + faíscas (brilho aditivo)
gpu_set_blendmode(bm_add);
if (estado == "bomba" && (t mod 18) < 9) {     // luz vermelha piscando no peito
    draw_circle_color(x + core_dx * facing + _ox, y + core_dy, 90, make_colour_rgb(150, 20, 10), c_black, false);
}
if (estado != "morrendo") {
    var _p = 0.5 + 0.5 * sin(current_time / 140);
    var _r = 34 + 10 * _p + ((estado == "tiro" || estado == "furia") ? 22 : 0);
    draw_circle_color(x + core_dx * facing + _ox, y + core_dy, _r, ((fase == 3) ? make_colour_rgb(110, 25, 120) : make_colour_rgb(25, 95, 120)), c_black, false);
}
for (var i = 0; i < array_length(particulas); i++) {
    var _q = particulas[i];
    draw_circle_color(_q.x, _q.y, 3 + _q.vida / 15, _q.cor, c_black, false);
}
gpu_set_blendmode(bm_normal);

// ---- barra grande no topo da tela (barra grande) ----
if (barra_ativa && estado != "derrotado" && estado != "bomba" && estado != "explodiu" && estado != "dormindo") {

var gw = room_width;
var k = 1;
var _bw = gw * 0.56;
var _bx = (gw - _bw) / 2;
var _by = 52 * k;
var _bh = 30 * k;
var _r = clamp(hp / hp_max, 0, 1) * barra_vis;
var _g = clamp(hp_vis, 0, 1) * barra_vis;
var _cor = (fase == 3) ? make_colour_rgb(230, 60, 255) : ((fase == 2) ? make_colour_rgb(255, 70, 60) : make_colour_rgb(70, 220, 255));

draw_set_alpha(0.8);
draw_set_color(make_colour_rgb(8, 10, 20));
draw_rectangle(_bx - 8 * k, _by - 40 * k, _bx + _bw + 8 * k, _by + _bh + 8 * k, false);
draw_set_alpha(1);

draw_set_color(make_colour_rgb(34, 38, 56));
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
draw_set_color(make_colour_rgb(235, 235, 245));            // "rastro" do dano
draw_rectangle(_bx, _by, _bx + _bw * _g, _by + _bh, false);
draw_set_color(_cor);                                       // vida atual
draw_rectangle(_bx, _by, _bx + _bw * _r, _by + _bh, false);
draw_set_color(c_white);
draw_rectangle(_bx, _by, _bx + _bw * _r, _by + 6 * k, false);
draw_set_color(make_colour_rgb(8, 10, 20));                 // marca dos 50% (entra a fúria)
draw_rectangle(_bx + _bw * (1 / 3) - 2 * k, _by, _bx + _bw * (1 / 3) + 2 * k, _by + _bh, false);   // marcas das fases (1/3 e 2/3)
draw_rectangle(_bx + _bw * (2 / 3) - 2 * k, _by, _bx + _bw * (2 / 3) + 2 * k, _by + _bh, false);
draw_set_color(_cor);
draw_rectangle(_bx - 1, _by - 1, _bx + _bw + 1, _by + _bh + 1, true);

draw_set_font(fMenu);
draw_set_valign(fa_bottom);
draw_set_halign(fa_left);
draw_set_color(make_colour_rgb(120, 230, 90));
draw_text_transformed(_bx, _by - 4 * k, "PAUL", k * 1.1, k * 1.1, 0);
draw_set_halign(fa_right);
draw_set_color(c_white);
draw_text_transformed(_bx + _bw, _by - 4 * k, string(hp) + " / " + string(hp_max), k * 0.8, k * 0.8, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

}
