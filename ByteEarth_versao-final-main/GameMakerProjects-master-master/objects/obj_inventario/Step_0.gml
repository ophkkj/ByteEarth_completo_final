/// STEP — obj_inventario

t++;

// textos "+1 Engrenagem" subindo
for (var i = array_length(popups) - 1; i >= 0; i--) {
    var _p = popups[i];
    _p.t++;
    _p.y -= 0.6;
    if (_p.t > 70) array_delete(popups, i, 1);
}
if (flash_craft > 0) flash_craft--;

// atalho de TESTE (apague depois): F8 dá peças e libera a bancada
if (keyboard_check_pressed(vk_f8)) {
    global.inv = [9, 9, 9];
    global.jogos_concluidos = true;
}

var _trav = true;
if (instance_exists(obj_david)) _trav = instance_find(obj_david, 0).controle_travado;

// ---------- fechado: TAB abre (menos em pause, cutscene ou computador) ----------
if (!aberto) {
    if (keyboard_check_pressed(vk_tab) && !global.pausado && !global.pc_aberto && !_trav && instance_exists(obj_david)) abrir();
    exit;
}

// ---------- animação ----------
if (fechando) {
    anim = max(0, anim - 0.15);
    if (anim <= 0) terminar();
    exit;
}
anim = min(1, anim + 0.1);

if (keyboard_check_pressed(vk_tab) || keyboard_check_pressed(vk_escape)) {
    if (keyboard_check_pressed(vk_escape)) global.bloqueio_pause = 3;
    fechando = true;
    exit;
}

// ---------- teclado ----------
if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))  foco = max(0, foco - 1);
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) foco = min(2, foco + 1);

// ---------- mouse ----------
var _mx = mouse_x;
var _my = mouse_y;
var _moveu = (_mx != mx_ant || _my != my_ant);
mx_ant = _mx;
my_ant = _my;
var _hover = -1;
for (var j = 0; j < 3; j++) {
    var _r = ret(j);
    if (_mx > _r[0] && _mx < _r[2] && _my > _r[1] && _my < _r[3]) _hover = j;
}
if (_hover != -1 && _moveu) foco = _hover;

var _ok = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || (mouse_check_button_pressed(mb_left) && _hover != -1);
if (_ok) {
    if (foco == 0) equipar(0);
    else if (foco == 1) equipar(1);
    else criar_canhao();
}

if (keyboard_check_pressed(ord("1"))) equipar(0);
if (keyboard_check_pressed(ord("2"))) equipar(1);
