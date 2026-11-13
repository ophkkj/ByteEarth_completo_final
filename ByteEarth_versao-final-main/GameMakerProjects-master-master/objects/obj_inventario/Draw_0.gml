/// DRAW — obj_inventario (HUD das peças/arma + a tela do inventário)

var _W = room_width;
var _H = room_height;
var _ciano = make_colour_rgb(70, 220, 255);
var _verde = make_colour_rgb(120, 230, 90);
var _dav = instance_exists(obj_david) ? instance_find(obj_david, 0) : noone;

// ---------------- HUD (some em cutscene, pause e computador) ----------------
var _oculta = (_dav == noone) || _dav.controle_travado || global.pc_aberto || global.pausado;
if (!_oculta) {
    draw_set_font(fMenu);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    // peças no canto superior direito
    draw_set_alpha(0.55);
    draw_set_color(c_black);
    draw_rectangle(_W - 300, 12, _W - 14, 64, false);
    draw_set_alpha(1);
    for (var i = 0; i < 3; i++) {
        var _px = _W - 286 + i * 94;
        draw_sprite_ext(spr_peca, i, _px + 16, 38, 0.7, 0.7, 0, c_white, 1);
        draw_set_color(cores[i]);
        draw_text_transformed(_px + 36, 40, "x" + string(global.inv[i]), 0.75, 0.75, 0);
    }
    // arma atual no canto inferior direito
    if (global.canhao_criado) {
        draw_set_alpha(0.55);
        draw_set_color(c_black);
        draw_rectangle(_W - 290, _H - 92, _W - 14, _H - 14, false);
        draw_set_alpha(1);
        draw_sprite_ext(spr_arma_icone, global.arma_atual, _W - 280, _H - 84, 1.0, 1.0, 0, c_white, 1);
        draw_set_color(c_white);
        draw_text_transformed(_W - 172, _H - 70, (global.arma_atual == 1) ? "Canhão" : "Pistola", 0.65, 0.65, 0);
        if (global.arma_atual == 1) {
            var _pr = 1 - clamp(_dav.tempo_canhao / _dav.cadencia_canhao, 0, 1);
            draw_set_color(make_colour_rgb(30, 34, 50));
            draw_rectangle(_W - 172, _H - 52, _W - 28, _H - 40, false);
            draw_set_color((_pr >= 1) ? make_colour_rgb(255, 150, 60) : make_colour_rgb(140, 110, 90));
            draw_rectangle(_W - 172, _H - 52, _W - 172 + 144 * _pr, _H - 40, false);
        }
        draw_set_color(make_colour_rgb(160, 165, 180));
        draw_text_transformed(_W - 172, _H - 28, "1 / 2 trocam", 0.45, 0.45, 0);
    } else {
        draw_set_color(make_colour_rgb(150, 155, 170));
        draw_set_halign(fa_right);
        draw_text_transformed(_W - 20, _H - 24, "TAB: inventário", 0.5, 0.5, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ---------------- "+1 Engrenagem" ----------------
draw_set_font(fMenu);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
for (var i = 0; i < array_length(popups); i++) {
    var _q = popups[i];
    draw_set_alpha(clamp(1 - _q.t / 70, 0, 1));
    draw_set_color(c_black);
    draw_text_transformed(_q.x + 2, _q.y + 2, _q.txt, 0.7, 0.7, 0);
    draw_set_color(_q.cor);
    draw_text_transformed(_q.x, _q.y, _q.txt, 0.7, 0.7, 0);
}
draw_set_alpha(1);

if (!aberto) {
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// ================= TELA DO INVENTÁRIO =================
var _e = 1 - power(1 - anim, 3);

draw_set_alpha(0.7 * _e);
draw_set_color(c_black);
draw_rectangle(0, 0, _W, _H, false);

// painel principal (abre de cima para baixo)
var _py1 = 90;
var _py2 = _py1 + (678 - _py1) * _e;
draw_set_alpha(0.92 * _e);
draw_set_color(make_colour_rgb(8, 12, 26));
draw_rectangle(170, _py1, 1196, _py2, false);
draw_set_alpha(_e);
draw_set_color(_ciano);
draw_rectangle(170, _py1, 1196, _py2, true);
draw_rectangle(172, _py1 + 2, 1194, _py2 - 2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_verde);
draw_text_transformed(_W / 2, lerp(60, 128, _e), "INVENTÁRIO", 1.8, 1.8, 0);

if (_e > 0.6) {
    var _a = clamp((_e - 0.6) / 0.4, 0, 1);
    draw_set_alpha(_a);

    // ---------- PEÇAS ----------
    draw_set_halign(fa_left);
    draw_set_color(_ciano);
    draw_text_transformed(210, 168, "PEÇAS (caem dos zumbis)", 0.8, 0.8, 0);
    for (var i = 0; i < 3; i++) {
        var _x1 = 210 + i * 150;
        draw_set_alpha(0.8 * _a);
        draw_set_color(make_colour_rgb(18, 24, 44));
        draw_rectangle(_x1, 190, _x1 + 135, 340, false);
        draw_set_alpha(_a);
        draw_set_color(cores[i]);
        draw_rectangle(_x1, 190, _x1 + 135, 340, true);
        draw_sprite_ext(spr_peca, i, _x1 + 67, 244, 1.5, 1.5, 0, c_white, _a);
        draw_set_halign(fa_center);
        draw_text_transformed(_x1 + 67, 302, nomes[i], 0.6, 0.6, 0);
        draw_set_color(c_white);
        draw_text_transformed(_x1 + 67, 326, "x " + string(global.inv[i]), 0.8, 0.8, 0);
        draw_set_halign(fa_left);
    }

    // ---------- ARMAS ----------
    draw_set_color(_ciano);
    draw_text_transformed(700, 168, "ARMAS  (1 / 2 para trocar)", 0.8, 0.8, 0);
    for (var w = 0; w < 2; w++) {
        var _r = ret(w);
        var _tem = (w == 0) || global.canhao_criado;
        var _eq = (global.arma_atual == w) && _tem;
        draw_set_alpha(0.8 * _a);
        draw_set_color(make_colour_rgb(18, 24, 44));
        draw_rectangle(_r[0], _r[1], _r[2], _r[3], false);
        draw_set_alpha(_a);
        draw_set_color(_eq ? _verde : ((foco == w) ? c_white : make_colour_rgb(80, 100, 130)));
        draw_rectangle(_r[0], _r[1], _r[2], _r[3], true);
        if (foco == w) draw_rectangle(_r[0] + 2, _r[1] + 2, _r[2] - 2, _r[3] - 2, true);
        draw_sprite_ext(spr_arma_icone, w, (_r[0] + _r[2]) / 2 - 72, _r[1] + 22, 1.5, 1.5, 0, _tem ? c_white : c_dkgray, _a);
        draw_set_halign(fa_center);
        draw_set_color(_tem ? c_white : make_colour_rgb(120, 125, 140));
        draw_text_transformed((_r[0] + _r[2]) / 2, _r[1] + 108, (w == 0) ? "Pistola de Plasma" : "Canhão de Plasma", 0.6, 0.6, 0);
        draw_set_color(_eq ? _verde : make_colour_rgb(150, 155, 170));
        draw_text_transformed((_r[0] + _r[2]) / 2, _r[1] + 130, _eq ? "EQUIPADA" : (_tem ? "ENTER: equipar" : "não criado"), 0.5, 0.5, 0);
        draw_set_halign(fa_left);
    }

    // ---------- BANCADA ----------
    draw_set_color(_ciano);
    draw_text_transformed(210, 388, "BANCADA DE CRIAÇÃO", 0.8, 0.8, 0);
    draw_set_alpha(0.7 * _a);
    draw_set_color(make_colour_rgb(18, 24, 44));
    draw_rectangle(210, 410, 1160, 650, false);
    draw_set_alpha(_a);
    draw_set_color(make_colour_rgb(80, 100, 130));
    draw_rectangle(210, 410, 1160, 650, true);

    if (!global.jogos_concluidos) {
        // bancada bloqueada
        draw_set_color(make_colour_rgb(150, 155, 170));
        draw_rectangle(240, 500, 300, 560, false);
        draw_set_color(make_colour_rgb(8, 12, 26));
        draw_rectangle(256, 516, 284, 544, false);
        draw_set_color(make_colour_rgb(150, 155, 170));
        draw_rectangle(252, 476, 258, 502, false);
        draw_rectangle(282, 476, 288, 502, false);
        draw_rectangle(252, 472, 288, 480, false);
        draw_set_color(make_colour_rgb(255, 120, 90));
        draw_text_transformed(330, 470, "BANCADA BLOQUEADA", 0.9, 0.9, 0);
        draw_set_color(c_white);
        draw_text_ext_transformed(330, 510, "Conclua os 3 jogos do computador da Fase 5 (MATEMÁTICA, ACRE e IFDS) para liberar a criação de uma arma nova.", 34, 820 / 0.6, 0.6, 0.6, 0);
    } else if (!global.canhao_criado) {
        draw_set_color(_verde);
        draw_text_transformed(240, 440, "CANHÃO DE PLASMA", 0.95, 0.95, 0);
        draw_set_color(c_white);
        draw_text_transformed(240, 478, "Tira 10 de vida direto do chefe. Recarga lenta.", 0.55, 0.55, 0);
        for (var i = 0; i < 3; i++) {
            var _tem2 = global.inv[i] >= receita[i];
            var _rx = 240 + i * 215;
            draw_sprite_ext(spr_peca, i, _rx + 22, 548, 1.0, 1.0, 0, c_white, _a);
            draw_set_color(_tem2 ? _verde : make_colour_rgb(255, 120, 90));
            draw_text_transformed(_rx + 52, 536, nomes[i], 0.55, 0.55, 0);
            draw_text_transformed(_rx + 52, 562, string(global.inv[i]) + " / " + string(receita[i]), 0.75, 0.75, 0);
        }
        // botão CRIAR
        var _rb = ret(2);
        var _pode = tem_receita();
        draw_set_alpha(_a * (_pode ? 0.45 : 0.25));
        draw_set_color(_pode ? _verde : c_dkgray);
        draw_rectangle(_rb[0], _rb[1], _rb[2], _rb[3], false);
        draw_set_alpha(_a);
        draw_set_color((foco == 2) ? c_white : (_pode ? _verde : make_colour_rgb(110, 115, 125)));
        draw_rectangle(_rb[0], _rb[1], _rb[2], _rb[3], true);
        if (foco == 2) draw_rectangle(_rb[0] + 2, _rb[1] + 2, _rb[2] - 2, _rb[3] - 2, true);
        draw_set_halign(fa_center);
        draw_set_color(_pode ? c_white : make_colour_rgb(130, 135, 145));
        draw_text_transformed((_rb[0] + _rb[2]) / 2, (_rb[1] + _rb[3]) / 2, "CRIAR", 1.0, 1.0, 0);
        draw_set_halign(fa_left);
    } else {
        draw_set_color(_verde);
        draw_text_transformed(240, 470, "Canhão de Plasma criado!", 1.0, 1.0, 0);
        draw_set_color(c_white);
        draw_text_transformed(240, 520, "Pressione 2 para usar o canhão (10 de dano no chefe) e 1 para voltar à pistola.", 0.6, 0.6, 0);
        draw_text_transformed(240, 556, "Depois de atirar, ele precisa recarregar (barra no canto inferior direito).", 0.6, 0.6, 0);
    }

    // rodapé
    draw_set_alpha(0.8 * _a);
    draw_set_halign(fa_center);
    draw_set_color(make_colour_rgb(150, 155, 170));
    draw_text_transformed(_W / 2, 660, "TAB ou ESC: fechar   |   setas/A/D + ENTER ou mouse", 0.5, 0.5, 0);
}

// clarão ao criar a arma
if (flash_craft > 0) {
    draw_set_alpha(flash_craft / 70 * 0.6);
    draw_set_color(c_white);
    draw_rectangle(0, 0, _W, _H, false);
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
