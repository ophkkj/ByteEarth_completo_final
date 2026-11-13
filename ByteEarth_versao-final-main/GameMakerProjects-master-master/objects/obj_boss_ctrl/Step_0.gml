/// STEP — obj_boss_ctrl
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado

t++;

switch (estado) {

    // ---------- entrada: o Paul fica parado, imponente ----------
    case 0:
        if (t > 30) { estado = 1; t = 0; }
    break;

    // ---------- diálogos (ENTER, ESPAÇO ou clique avança): 1 = antes da luta, 6 = depois ----------
    case 1:
    case 6:
        var _lista = (estado == 1) ? falas : falas_f;
        var _f = _lista[fala_i];
        chars = min(string_length(_f.txt), chars + 1.1);
        var _avanca = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left);
        if (_avanca) {
            if (chars < string_length(_f.txt)) {
                chars = string_length(_f.txt);
            } else {
                fala_i++;
                chars = 0;
                if (fala_i >= array_length(_lista)) {
                    if (estado == 1) { estado = 2; t = 0; }
                    else { estado = 7; t = 0; fala_i = 0; }
                }
            }
        }
    break;

    // ---------- banner "PAUL" e a barra de vida enchendo; depois a luta começa ----------
    case 2:
        if (instance_exists(boss)) {
            boss.barra_ativa = true;
            boss.barra_vis = min(1, t / 40);
        }
        if (t > 75) {
            estado = 3;
            t = 0;
            global.boss_intro_visto = true;
            if (instance_exists(boss)) {
                boss.barra_vis = 1;
                boss.estado = "andar";
                boss.vulneravel = true;
                boss.pausa = 25;
            }
            with (obj_david) controle_travado = false;
        }
    break;

    // ---------- LUTA ----------
    case 3:
        if (instance_exists(boss) && boss.estado == "morrendo") {
            with (obj_david) { controle_travado = true; auto_dir = 0; dash_t = 0; }
            estado = 4;
            t = 0;
        }
    break;

    // ---------- o Paul termina de cair e fica sentado, derrotado ----------
    case 4:
        if (instance_exists(boss) && boss.terminou && instance_exists(obj_david)) {
            boss.estado = "derrotado";
            boss.t = 0;
            var _dv = instance_find(obj_david, 0);
            var _dir = sign(_dv.x - boss.x);
            if (_dir == 0) _dir = -1;
            alvo_x = clamp(boss.x + _dir * 290, 120, room_width - 120);
            chegou_t = 0;
            estado = 5;
            t = 0;
        }
    break;

    // ---------- o David anda até ficar de frente para o Paul ----------
    case 5:
        var _dv2 = instance_find(obj_david, 0);
        if (abs(_dv2.x - alvo_x) > 6 && t < 600) {
            _dv2.auto_dir = sign(alvo_x - _dv2.x);
        } else {
            _dv2.auto_dir = 0;
            _dv2.direcao = sign(boss.x - _dv2.x);
            chegou_t++;
            if (chegou_t > 70) { estado = 6; t = 0; fala_i = 0; chars = 0; }
        }
    break;

    // ---------- o Paul aperta o botão da armadura: contagem (a armadura pisca) ----------
    case 7:
        if (t == 1) { boss.estado = "bomba"; boss.t = 0; }
        if (t >= 200) { estado = 8; ex_t = 0; }
    break;

    // ---------- EXPLOSÃO: clarão que vai escurecendo até ficar tudo preto ----------
    case 8:
        ex_t++;
        if (ex_t == 1) {
            boss.estado = "explodiu";
            with (obj_david) alfa_david = 0;
            var _s1 = audio_play_sound(snd_tiro_arma, 1, false);
            audio_sound_pitch(_s1, 0.18);
            var _s2 = audio_play_sound(snd_zumbi_morrendo, 1, false);
            audio_sound_pitch(_s2, 0.3);
            if (musica != -1) audio_sound_gain(musica, 0, 600);
        }
        branco = clamp(ex_t / 12, 0, 1);
        escuro = clamp((ex_t - 40) / 160, 0, 1);
        if (ex_t > 240) { estado = 9; t = 0; chars = 0; }
    break;

    // ---------- "continua..." e, depois de um tempo, volta para a tela inicial ----------
    case 9:
        chars = min(11, chars + 0.2);
        if (t > 420 && !saida) {
            saida = true;
            var _fade = instance_create_depth(0, 0, -30000, obj_fade);
            _fade.destino = rm_lobby;
        }
    break;
}
