/// STEP — obj_pause

t++;
if (global.bloqueio_pause > 0) global.bloqueio_pause--;
for (var i = 0; i < n_part; i++) {
    pp_y[i] -= pp_v[i];
    if (pp_y[i] < -5) { pp_y[i] = room_height + 5; pp_x[i] = random(room_width); }
}

var _tecla_pause = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));

if (!pausado) {
    if (_tecla_pause && !global.inv_aberto && global.bloqueio_pause <= 0) abrir();
    exit;
}

// ---------- animação de abertura / fechamento ----------
if (fechando) {
    anim = max(0, anim - 0.14);
    if (anim <= 0) terminar();
    exit;
}
anim = min(1, anim + 0.08);

var _n = (tela == 0) ? array_length(principal) : array_length(linhas_opcoes);

// ---------- teclado ----------
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))   opcao = (opcao + _n - 1) mod _n;
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) opcao = (opcao + 1) mod _n;

// ---------- mouse (coordenadas da room) ----------
var _mx = mouse_x;
var _my = mouse_y;
var _moveu = (_mx != mx_ant || _my != my_ant);
mx_ant = _mx;
my_ant = _my;
var _hover = -1;
for (var i = 0; i < _n; i++) {
    var _cy = linha_y(i);
    if (_mx > room_width * 0.26 && _mx < room_width * 0.74 && _my > _cy - 30 && _my < _cy + 30) _hover = i;
}
if (_hover != -1 && _moveu) opcao = _hover;

var _confirma = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)
             || (mouse_check_button_pressed(mb_left) && _hover != -1);

// a barra de seleção desliza até a opção escolhida
sel_y = lerp(sel_y, linha_y(opcao), 0.3);

if (tela == 0) {
    // ---------- menu principal ----------
    if (_tecla_pause) { fechando = true; exit; }
    if (_confirma) {
        switch (opcao) {
            case 0:  fechando = true; break;                                  // continuar (com animação)
            case 1:  tela = 1; opcao = 0; sel_y = linha_y(0); break;          // opções
            case 2:  terminar(); room_restart(); break;                       // reiniciar fase
            case 3:  terminar(); audio_stop_all(); room_goto(rm_lobby); break; // menu principal
            case 4:  terminar(); game_end(); break;                           // sair do jogo
        }
    }
} else {
    // ---------- opções: volume e brilho ----------
    if (_tecla_pause) { tela = 0; opcao = 1; sel_y = linha_y(1); exit; }

    var _dir = 0;
    if (keyboard_check(vk_left) || keyboard_check(ord("A")))  _dir = -1;
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) _dir = 1;
    if (_dir != 0 && opcao <= 1) {
        hold++;
        if (hold == 1 || (hold > 12 && hold mod 3 == 0)) ajustar(opcao, _dir * 0.05);
    } else {
        hold = 0;
    }

    // sliders com o mouse: clique/arraste na barra
    var _sx0 = room_width * 0.50;
    var _sx1 = room_width * 0.70;
    if (mouse_check_button_pressed(mb_left)) {
        arrastando = -1;
        for (var j = 0; j < 2; j++) {
            if (_mx > _sx0 - 14 && _mx < _sx1 + 14 && abs(_my - linha_y(j)) < 22) arrastando = j;
        }
    }
    if (!mouse_check_button(mb_left)) arrastando = -1;
    if (arrastando >= 0) {
        var _v = clamp((_mx - _sx0) / (_sx1 - _sx0), 0, 1);
        if (arrastando == 0) { global.volume = _v; audio_master_gain(_v); }
        else global.brilho = _v;
        opcao = arrastando;
    }

    if (_confirma && opcao == 2) { tela = 0; opcao = 1; sel_y = linha_y(1); }
}
