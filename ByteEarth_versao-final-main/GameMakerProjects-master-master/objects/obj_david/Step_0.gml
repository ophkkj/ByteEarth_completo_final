/// STEP — obj_david
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado

// Invencibilidade temporária
if (invencivel) {
    tempo_invencivel--;
    if (tempo_invencivel <= 0) invencivel = false;
}

// Dano: encostou em qualquer objeto perigoso (inimigo, espinho...)
if (place_meeting(x, y, obj_perigo)) levar_dano();

// Duração da animação de dano
if (tomando_dano) {
    tempo_dano--;
    if (tempo_dano <= 0) tomando_dano = false;
}

// Reinicia a fase depois de morrer
if (morrendo) {
    tempo_morte--;
    if (tempo_morte <= 0) room_restart();
}

// TESTE: H perde um coração, J recupera (apague depois de testar)
if (keyboard_check_pressed(ord("H"))) levar_dano();
if (keyboard_check_pressed(ord("J"))) curar();

var direita = keyboard_check(ord("D")) || keyboard_check(vk_right);
var esquerda = keyboard_check(ord("A")) || keyboard_check(vk_left);
var tecla_pulo = keyboard_check_pressed(ord("W"))
              || keyboard_check_pressed(vk_up);

// Controle travado (computador aberto, diálogo...) ou caminhada automática
if (controle_travado) {
    direita = false;
    esquerda = false;
    tecla_pulo = false;
    if (auto_dir != 0) {
        direita = (auto_dir > 0);
        esquerda = (auto_dir < 0);
    }
}

var movimento = direita - esquerda;

// ---------- ESQUIVA (apenas na boss fight) ----------
if (room == rm_boss) {
    if (dash_cd > 0) dash_cd--;
    if (!controle_travado && !morrendo && !tomando_dano && dash_cd <= 0 && dash_t <= 0
        && (keyboard_check_pressed(vk_shift) || keyboard_check_pressed(ord("K")))) {
        dash_t = dash_dur;
        dash_cd = 70;
        dash_dir = (movimento != 0) ? movimento : direcao;
        var _snd_d = audio_play_sound(snd_david_pulo, 1, false);
        audio_sound_pitch(_snd_d, 1.6);
    }
    if (dash_t > 0) {
        dash_t--;
        direcao = dash_dir;
        invencivel = true;                              // invencível durante a esquiva (e mais um instante)
        tempo_invencivel = max(tempo_invencivel, 8);
        repeat (dash_vel) {
            if (!place_meeting(x + dash_dir, y, obj_solido)) x += dash_dir; else break;
        }
        movimento = 0;                                  // o deslize já andou
    }
}

// Chão
no_chao = place_meeting(x, y + 1, obj_solido);

// Movimento horizontal (pixel a pixel)
var _x_antes = x;
if (movimento != 0) {
    direcao = movimento;

    repeat (abs(velocidade_x)) {
        if (!place_meeting(x + movimento, y, obj_solido)) {
            x += movimento;
        } else {
            break;
        }
    }
}

// Empurrão do dano: desliza para trás e vai perdendo força
if (knock_x != 0) {
    var _k = sign(knock_x);
    repeat (ceil(abs(knock_x))) {
        if (!place_meeting(x + _k, y, obj_solido)) {
            x += _k;
        } else {
            knock_x = 0;
            break;
        }
    }
    knock_x *= 0.85;
    if (abs(knock_x) < 0.5) knock_x = 0;
}

// Pulo
if (tecla_pulo && no_chao) {
    velocidade_y = forca_pulo;
    no_chao = false;
    var _som_pulo = audio_play_sound(snd_david_pulo, 1, false);
    audio_sound_pitch(_som_pulo, random_range(0.96, 1.04));
}

// Gravidade
if (no_chao && velocidade_y > 0) {
    velocidade_y = 0;
}
velocidade_y += gravidade;
velocidade_y = clamp(velocidade_y, -10, 12);

// Movimento vertical (pixel a pixel)
var sinal_y = sign(velocidade_y);
repeat (ceil(abs(velocidade_y))) {
    if (!place_meeting(x, y + sinal_y, obj_solido)) {
        y += sinal_y;
    } else {
        velocidade_y = 0;
        break;
    }
}

// Atualizar estado do chão
no_chao = place_meeting(x, y + 1, obj_solido);

// Pouso: ao tocar o chão depois de estar no ar, segura o quadro "amassado" por um instante
if (!no_chao) {
    estava_no_ar = true;
} else if (estava_no_ar) {
    estava_no_ar = false;
    tempo_pouso = 6;
}
if (tempo_pouso > 0) tempo_pouso--;

// Som de passos: em loop só enquanto ele realmente anda no chão
if (x != _x_antes && no_chao && !morrendo) {
    if (!audio_is_playing(snd_david_andando)) audio_play_sound(snd_david_andando, 1, true);
} else {
    audio_stop_sound(snd_david_andando);
}

// ---------- TIRO ----------
// COOLDOWN: tempo_tiro conta para baixo todo frame; só dá para atirar quando chega a 0.
// Ao atirar, ele volta para cadencia_tiro (definida no Create).
if (tempo_tiro > 0) tempo_tiro--;
if (tempo_canhao > 0) tempo_canhao--;

// troca de arma: 1 = pistola | 2 = canhão (se já foi criado)
if (!controle_travado && !morrendo && !global.pausado) {
    if (keyboard_check_pressed(ord("1"))) global.arma_atual = 0;
    if (keyboard_check_pressed(ord("2")) && global.canhao_criado) global.arma_atual = 1;
}
if (!global.canhao_criado) global.arma_atual = 0;

if (global.bloqueio_tiro > 0) global.bloqueio_tiro--;   // logo depois do pause não atira
var _pode_atirar = ((global.arma_atual == 1) ? (tempo_canhao <= 0) : (tempo_tiro <= 0)) && !morrendo && !controle_travado && (global.bloqueio_tiro <= 0);

if (mouse_check_button_pressed(mb_left) && _pode_atirar) {
    var _canhao = (global.arma_atual == 1);
    if (_canhao) { tempo_canhao = cadencia_canhao; tempo_tiro = 20; } else { tempo_tiro = cadencia_tiro; }
    var _som_tiro = audio_play_sound(snd_tiro_arma, 1, false);
    audio_sound_pitch(_som_tiro, _canhao ? 0.55 : random_range(0.95, 1.05));

    // Vira o alien para o lado onde ele atirou
    if (mouse_x != x) direcao = sign(mouse_x - x);

    // Ponto de saída: posição do alien + deslocamento manual
    var origem_x = x + direcao * saida_dx;
    var origem_y = y + saida_dy;

    var angulo = point_direction(origem_x, origem_y, mouse_x, mouse_y);

    // Profundidade -10000 deixa a bala na frente de tudo
    var bala = instance_create_depth(origem_x, origem_y, -10000, obj_bala);
    bala.direction = angulo;
    bala.speed = velocidade_bala;
    bala.image_angle = angulo;
    if (_canhao) {                      // projétil do canhão: grande, rápido e com 10 de dano
        bala.dano = 10;
        bala.speed = 15;
        bala.sprite_index = spr_bala_canhao;
        bala.image_xscale = 1.1;
        bala.image_yscale = 1.1;
        bala.escala_impacto = 2.4;
    }

    // Liga a animação de tiro e reinicia do primeiro frame
    atirando = true;
    tempo_atirando = ceil(sprite_get_number(spr_david_tiro) / velocidade_anim_tiro);
    esperando = false;
    tempo_parado = 0;
    if (sprite_index == spr_david_tiro) image_index = 0;
}

// Duração da animação de tiro
if (atirando) {
    tempo_atirando--;
    if (tempo_atirando <= 0) atirando = false;
}

// ---------- ESPERA (bate o pé) ----------
// Ficou parado, no chão, sem fazer nada por um tempo? Toca a animação de espera.
var _parado = no_chao && movimento == 0 && !atirando && !tomando_dano
           && !morrendo && !controle_travado && !mouse_check_button(mb_left);
if (_parado) {
    if (!esperando) {
        tempo_parado++;
        if (tempo_parado >= tempo_ate_espera) {
            esperando = true;
            tempo_parado = 0;
        }
    }
} else {
    tempo_parado = 0;
    esperando = false;
}

// ---------- ANIMAÇÕES ----------
// Prioridade: dano > tiro > pulo > pouso > andar > espera > parado
var novo_sprite;
var nova_velocidade;

if (morrendo || tomando_dano) {
    novo_sprite = spr_david_dano;
    nova_velocidade = 0.3;
} else if (dash_t > 0) {
    novo_sprite = spr_david_andar;
    nova_velocidade = 0.5;
} else if (atirando) {
    novo_sprite = spr_david_tiro;
    nova_velocidade = velocidade_anim_tiro;
} else if (!no_chao) {
    novo_sprite = spr_david_pulo;
    nova_velocidade = 0;
} else if (tempo_pouso > 0 && movimento == 0) {
    novo_sprite = spr_david_pulo;
    nova_velocidade = 0;
} else if (movimento != 0) {
    novo_sprite = spr_david_andar;
    nova_velocidade = 0.2;
} else if (esperando) {
    novo_sprite = spr_david_espera;
    nova_velocidade = 0.2;
} else {
    novo_sprite = spr_david_idle;
    nova_velocidade = 0.12;
}

// Só mexe quando o sprite muda
if (sprite_index != novo_sprite) {
    sprite_index = novo_sprite;
    image_index = 0;
    image_speed = nova_velocidade;
}

// Pulo: o quadro depende da velocidade vertical (sobe, topo, desce) e não do tempo
if (sprite_index == spr_david_pulo) {
    image_speed = 0;
    if (!no_chao) {
        if (velocidade_y < -8)      image_index = 1;   // impulso (esticado)
        else if (velocidade_y < -4) image_index = 2;   // subindo
        else if (velocidade_y < -1) image_index = 3;   // subindo devagar
        else if (velocidade_y <= 1) image_index = 4;   // topo
        else if (velocidade_y < 5)  image_index = 5;   // começando a cair
        else                        image_index = 6;   // caindo
    } else {
        image_index = 7;                               // pouso (amassado)
    }
}

// Morrendo: congela no meio da animação de dano
if (morrendo && sprite_index == spr_david_dano && image_index >= 4) {
    image_index = 4;
    image_speed = 0;
}
