/// STEP — obj_computador
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado

// ---------- Fora do computador: só mostra o aviso e espera o E ----------
if (ui == 0) {
    perto = false;
    if (!usado && instance_exists(obj_david) && instance_exists(obj_fase5_ctrl) && obj_fase5_ctrl.estado == 0) {
        perto = (abs(obj_david.x - x) < distancia_uso) && !obj_david.morrendo;
        if (perto && keyboard_check_pressed(ord("E"))) abrir();
    }
    exit;
}

// ---------- Dentro do computador ----------
var gx = display_get_gui_width() / room_width;
var gy = display_get_gui_height() / room_height;
var mx = device_mouse_x_to_gui(0) / gx;
var my = device_mouse_y_to_gui(0) / gy;
var clique = mouse_check_button_pressed(mb_left);

if (erro_timer > 0) erro_timer--;
if (ok_timer > 0) ok_timer--;

if (ui == 1) {
    // Menu inicial: 3 minijogos
    hover = -1;
    for (var i = 0; i < 3; i++) {
        var c = cartoes[i];
        if (point_in_rectangle(mx, my, c.x1, c.y1, c.x2, c.y2)) hover = i;
    }
    var escolha = -1;
    if (clique && hover != -1) escolha = hover;
    if (keyboard_check_pressed(ord("1"))) escolha = 0;
    if (keyboard_check_pressed(ord("2"))) escolha = 1;
    if (keyboard_check_pressed(ord("3"))) escolha = 2;

    if (escolha != -1 && !jogos_ok[escolha]) {
        montar_jogo(escolha);
        ui = 2;
    }
    if (keyboard_check_pressed(vk_escape)) fechar();
}
else if (ui == 2) {
    // Jogo: clique (ou teclas 1-4) em uma das opções
    hover = -1;
    for (var i = 0; i < 4; i++) {
        var b = botoes[i];
        if (point_in_rectangle(mx, my, b.x1, b.y1, b.x2, b.y2)) hover = i;
    }
    var esc = -1;
    if (clique && hover != -1) esc = hover;
    for (var k = 0; k < 4; k++) {
        if (keyboard_check_pressed(ord("1") + k)) esc = k;
    }
    if (esc != -1 && !tentado[esc]) responder(esc);

    if (keyboard_check_pressed(vk_escape)) ui = 1;
}
else if (ui == 3) {
    // Um jogo terminou
    timer_ui--;
    if (timer_ui <= 0 || clique) {
        if (jogos_ok[0] && jogos_ok[1] && jogos_ok[2]) {
            ui = 4;
            timer_ui = 120;
        } else {
            ui = 1;
        }
    }
}
else if (ui == 4) {
    // Os 3 jogos terminaram
    timer_ui--;
    if (timer_ui <= 0) concluir();
}
