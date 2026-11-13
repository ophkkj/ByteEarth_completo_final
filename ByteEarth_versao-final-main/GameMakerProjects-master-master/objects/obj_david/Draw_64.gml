/// DRAW GUI — obj_david

// Esconde o HUD enquanto a tela do computador está aberta
if (global.pc_aberto) exit;

var esc = 4;       // ampliação do HUD (76x24 vira 304x96)
var hud_x = 20;    // distância da borda esquerda
var hud_y = 20;    // distância do topo

// 0 = 3 corações, 1 = 2 corações, 2 = 1 coração, 3 = 0 corações
var frame_hud = clamp(vida_max - vida, 0, 3);

draw_sprite_ext(spr_hud_vida, frame_hud, hud_x, hud_y, esc, esc, 0, c_white, 1);