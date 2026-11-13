/// DRAW — obj_boss_ctrl (explosão + banner + diálogos + tela final, tudo em coordenadas da room)
if (estado == 8 && instance_exists(boss)) {
    var _bx = boss.x;
    var _by = boss.y - 110;
    var _r = ex_t * 30;
    gpu_set_blendmode(bm_add);
    draw_circle_color(_bx, _by, _r, make_colour_rgb(255, 200, 90), make_colour_rgb(120, 30, 0), false);
    draw_circle_color(_bx, _by, _r * 0.6, c_white, make_colour_rgb(255, 160, 60), false);
    draw_circle_color(_bx, _by, _r * 1.2, c_black, make_colour_rgb(255, 120, 40), true);
    gpu_set_blendmode(bm_normal);
}


var gw = room_width;
var gh = room_height;
var k = 1;

// ---------------- banner de início ----------------
if (estado == 2 && t < 75) {
    var _a = (t < 15) ? t / 15 : ((t > 55) ? (75 - t) / 20 : 1);
    draw_set_font(fMenu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_a);
    draw_set_color(make_colour_rgb(120, 230, 90));
    draw_text_transformed(gw / 2, gh * 0.32, "PAUL", k * 3.2, k * 3.2, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw / 2, gh * 0.32 + 70 * k, "Atire com o mouse  -  pule as ondas  -  SHIFT = esquiva (atravessa o Paul)", k * 0.8, k * 0.8, 0);
    draw_text_transformed(gw / 2, gh * 0.32 + 108 * k, "TAB = inventário (criar o Canhão de Plasma)  -  1 / 2 = trocar de arma", k * 0.6, k * 0.6, 0);
    draw_set_alpha(1);
}

// ---------------- recarga da esquiva ----------------
if (estado == 3 && instance_exists(obj_david)) {
    var _dd = instance_find(obj_david, 0);
    var _pr = 1 - clamp(_dd.dash_cd / 70, 0, 1);
    var _x = 30 * k;
    var _y = gh - 60 * k;
    draw_set_font(fMenu);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_color((_pr >= 1) ? make_colour_rgb(120, 230, 255) : make_colour_rgb(140, 140, 150));
    draw_text_transformed(_x, _y - 6 * k, "ESQUIVA [SHIFT]", k * 0.6, k * 0.6, 0);
    draw_set_color(make_colour_rgb(30, 34, 50));
    draw_rectangle(_x, _y, _x + 170 * k, _y + 10 * k, false);
    draw_set_color((_pr >= 1) ? make_colour_rgb(120, 230, 255) : make_colour_rgb(90, 130, 160));
    draw_rectangle(_x, _y, _x + 170 * k * _pr, _y + 10 * k, false);
    draw_set_color(c_white);
}

// ---------------- diálogos com ícone ----------------
if (estado == 1 && fala_i < array_length(falas)) {
    var _f1 = falas[fala_i];
    desenhar_caixa(_f1.quem, string_copy(_f1.txt, 1, floor(chars)), chars >= string_length(_f1.txt));
}
if (estado == 6 && fala_i < array_length(falas_f)) {
    var _f2 = falas_f[fala_i];
    desenhar_caixa(_f2.quem, string_copy(_f2.txt, 1, floor(chars)), chars >= string_length(_f2.txt));
}
// o David reage quando a armadura começa a piscar
if (estado == 7 && t > 70 && t < 190) {
    desenhar_caixa("DAVID", "PAUL, NÃO!", false);
}

// ---------------- explosão: clarão branco que escurece até o preto ----------------
if (estado == 8 || estado == 9) {
    var _cor = merge_colour(c_white, c_black, (estado == 9) ? 1 : escuro);
    draw_set_alpha((estado == 9) ? 1 : branco);
    draw_set_color(_cor);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}

// ---------------- "continua..." ----------------
if (estado == 9) {
    var _txt = string_copy("continua...", 1, floor(chars));
    draw_set_font(fMenu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text_transformed(gw / 2, gh / 2, _txt, k * 2.2, k * 2.2, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
