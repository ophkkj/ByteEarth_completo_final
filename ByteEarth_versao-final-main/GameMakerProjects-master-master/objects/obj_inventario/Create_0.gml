/// CREATE — obj_inventario (TAB abre o inventário; também desenha o HUD de peças e armas)

depth = -24000;

if (!variable_global_exists("inv")) global.inv = [0, 0, 0];
if (!variable_global_exists("canhao_criado")) global.canhao_criado = false;
if (!variable_global_exists("arma_atual")) global.arma_atual = 0;               // 0 = pistola | 1 = canhão de plasma
if (!variable_global_exists("jogos_concluidos")) global.jogos_concluidos = false; // vira true quando os 3 jogos do computador terminam
if (!variable_global_exists("bloqueio_pause")) global.bloqueio_pause = 0;
if (!variable_global_exists("pausado")) global.pausado = false;
if (!variable_global_exists("pc_aberto")) global.pc_aberto = false;

// Partida nova (Fase 1): zera inventário e armas
if (room == rm_fase_1) {
    global.inv = [0, 0, 0];
    global.canhao_criado = false;
    global.arma_atual = 0;
    global.jogos_concluidos = false;
}
global.inv_aberto = false;

nomes = ["Engrenagem", "Chip", "Núcleo"];
cores = [make_colour_rgb(170, 185, 210), make_colour_rgb(110, 230, 120), make_colour_rgb(80, 220, 255)];
receita = [4, 3, 2];          // peças para criar o Canhão de Plasma

aberto = false;
fechando = false;
anim = 0;
foco = 0;                     // 0 = pistola | 1 = canhão | 2 = botão criar
t = 0;
flash_craft = 0;
popups = [];
mx_ant = -1;
my_ant = -1;

// retângulos clicáveis (coordenadas da room)
ret = function(_i) {
    if (_i == 0) return [700, 190, 920, 340];
    if (_i == 1) return [940, 190, 1160, 340];
    return [900, 560, 1140, 624];
};

novo_popup = function(_txt, _x, _y, _cor) {
    array_push(popups, { txt: _txt, x: _x, y: _y, t: 0, cor: _cor });
};

tem_receita = function() {
    for (var i = 0; i < 3; i++) if (global.inv[i] < receita[i]) return false;
    return true;
};

abrir = function() {
    aberto = true;
    fechando = false;
    anim = 0;
    foco = 2;
    global.inv_aberto = true;
    global.pausado = true;
    with (obj_pause) congelar();
};

terminar = function() {
    with (obj_pause) descongelar();
    aberto = false;
    fechando = false;
    anim = 0;
    global.inv_aberto = false;
    global.pausado = false;
    global.bloqueio_tiro = 8;
};

criar_canhao = function() {
    if (!global.jogos_concluidos || global.canhao_criado || !tem_receita()) return;
    for (var i = 0; i < 3; i++) global.inv[i] -= receita[i];
    global.canhao_criado = true;
    global.arma_atual = 1;
    flash_craft = 70;
    var _s = audio_play_sound(snd_tiro_arma, 1, false);
    audio_sound_pitch(_s, 0.5);
};

equipar = function(_a) {
    if (_a == 0 || global.canhao_criado) global.arma_atual = _a;
};
