/// CREATE — obj_david

// Música das fases (controlador persistente; só cria se ainda não existir)
if (!instance_exists(obj_musica_fases)) instance_create_depth(0, 0, 0, obj_musica_fases);

// Animação inicial (sprites novos: todos na mesma tela 192x224, com a origem nos pés)
sprite_index = spr_david_idle;
image_speed = 0.12;
image_index = 0;

// Estado do alien
tempo_espera = 0;
estado_alien = 0;

// Movimento
velocidade_x = 4;
velocidade_y = 0;
gravidade = 0.5;
forca_pulo = -10;
no_chao = false;
direcao = 1; // 1 = direita, -1 = esquerda

// Controle das animações
andando = false;
pulando = false;
usando_arma = false;

// Escala do David (todas as animações novas têm o mesmo tamanho, então é uma escala só)
escala_idle = 0.5;

// Animação de espera (bate o pé): toca depois de ficar parado um tempo
esperando = false;
tempo_parado = 0;
tempo_ate_espera = 240;   // frames parado até começar (240 = 4 s a 60 fps)

// Pouso: segura o quadro "amassado" por alguns frames ao tocar o chão
estava_no_ar = false;
tempo_pouso = 0;

// Dano: animação + empurrãozinho para trás
tomando_dano = false;
tempo_dano = 0;
knock_x = 0;

// Tiro
// COOLDOWN: intervalo mínimo entre dois tiros, em frames (o jogo roda a 60 fps).
//   30 = 2 tiros por segundo | 40 = 1,5 por segundo | 60 = 1 por segundo
// Era 15 (4 tiros por segundo). Para deixar mais lento/rápido, mude só este número.
cadencia_tiro = 30;
tempo_tiro = 0;                // contador regressivo até poder atirar de novo
atirando = false;
tempo_atirando = 0;            // frames restantes da animação de tiro
// A animação de tiro dura exatamente o cooldown: acaba quando ele pode atirar de novo
velocidade_anim_tiro = sprite_get_number(spr_david_tiro) / cadencia_tiro;
velocidade_bala = 12;

// Ponto de saída da bala, em pixels a partir do (x, y) do alien
// (calculado na ponta da arma do spr_david_tiro; inverte sozinho quando ele olha para a esquerda)
saida_dx = 33;    // para a frente
saida_dy = -47;   // negativo = para cima, positivo = para baixo

// Colisão fixa: não muda quando a animação troca
mask_index = spr_alien_idle;
image_xscale = escala_idle;
image_yscale = escala_idle;

// Vida
vida_max = 3;
vida = vida_max;
invencivel = false;
tempo_invencivel = 0;
duracao_invencivel = 90; // frames sem levar dano depois de ser atingido (1,5 s)

// Morte
morrendo = false;
tempo_morte = 0;

// Controle por script (computador, diálogos, caminhada até o portal)
controle_travado = false;   // true = ignora teclado e mouse
auto_dir = 0;               // 1 / -1 = anda sozinho para a direita / esquerda
alfa_david = 1;             // transparência extra (usada ao entrar no portal)
global.pc_aberto = false;   // true enquanto a tela do computador está aberta

// Perde sempre 1 coração por dano
// forcar = true ignora a invencibilidade (usado na penalidade do puzzle de C++)
// origem_x (opcional) = x de quem causou o dano; o David é empurrado para longe dele
levar_dano = function(forcar = false, origem_x = undefined) {
    if (morrendo) return;
    if (invencivel && !forcar) return;

    vida = max(0, vida - 1);
    invencivel = true;
    tempo_invencivel = duracao_invencivel;

    // Animação de dano + empurrãozinho
    tomando_dano = true;
    tempo_dano = ceil(sprite_get_number(spr_david_dano) / 0.3);
    esperando = false;
    tempo_parado = 0;
    var _lado = is_undefined(origem_x) ? -direcao : sign(x - origem_x);
    if (_lado == 0) _lado = -direcao;
    knock_x = _lado * 3;

    if (vida <= 0) {
        morrendo = true;
        tempo_morte = 60; // 1 segundo antes de reiniciar a fase
        audio_stop_sound(snd_david_andando);
        audio_play_sound(snd_david_morte, 2, false);
    }
};

// Cura 1 coração
curar = function() {
    vida = min(vida_max, vida + 1);
};

// Temporizador da arma
alarm[0] = game_get_speed(gamespeed_fps) * 45;

// Zumbi do tutorial de tiro: só na rm_fase_2
if (room == rm_fase_2 && !instance_exists(obj_zumbi)) {
    var zx = (x > room_width / 2) ? x - 400 : x + 400;
    instance_create_layer(zx, y, layer, obj_zumbi);
}
// Rua com zumbis (rm_fase_3) — horda maior
if (room == rm_fase_3 && !instance_exists(obj_zumbi)) {
    var xs = [450, 600, 750, 900, 1050, 1150, 1230, 1300];
    for (var i = 0; i < array_length(xs); i++) {
        if (abs(xs[i] - x) > 250) instance_create_layer(xs[i], y, layer, obj_zumbi);
    }
}
// Zumbis do início da rm_fase_4 (matar todos faz o código em C++ aparecer)
if (room == rm_fase_4 && !instance_exists(obj_zumbi)) {
    var xs4 = [520, 720, 920, 1120];
    for (var i = 0; i < array_length(xs4); i++) {
        instance_create_layer(xs4[i], y, layer, obj_zumbi);
    }
}
// Fases 1 a 4: sem portal. Seguir em frente até a borda direita avança de fase.
if ((room == rm_fase_1 || room == rm_fase_2 || room == rm_fase_3 || room == rm_fase_4) && !instance_exists(obj_avanca)) {
    var av = instance_create_layer(0, 0, layer, obj_avanca);
    if (room == rm_fase_1) av.destino = rm_fase_2;
    if (room == rm_fase_2) { av.destino = rm_fase_3; av.trancada = true; } // só depois de matar o zumbi
    if (room == rm_fase_3) av.destino = rm_fase_4;
    if (room == rm_fase_4) { av.destino = rm_fase_5; av.trancada = true; av.abrir_ao_limpar = true; } // só depois de matar todos os zumbis
}

// Fase 5: controlador da fase + computador gigante no meio
if (room == rm_fase_5 && !instance_exists(obj_fase5_ctrl)) {
    instance_create_layer(0, 0, layer, obj_fase5_ctrl);
    instance_create_layer(room_width / 2, y, layer, obj_computador);
}


// Cor do ambiente: nas fases 2 a 5 o personagem recebe um tom frio/escuro parecido com o do cenário
cor_ambiente = c_white;
if (room == rm_fase_2 || room == rm_fase_3 || room == rm_fase_4 || room == rm_fase_5 || room == rm_boss) {
    cor_ambiente = make_colour_rgb(205, 212, 232);
}

// Poeira/cinzas e névoa baixa nas fases 2 a 5 (deixa o cenário mais vivo)
if ((room == rm_fase_2 || room == rm_fase_3 || room == rm_fase_4 || room == rm_fase_5) && !instance_exists(obj_ambiente)) {
    instance_create_depth(0, 0, -50, obj_ambiente);
}

// Esquiva (só na luta contra o Paul): SHIFT ou K. Corre rápido, fica invencível e ATRAVESSA o chefe.
dash_t = 0;
dash_cd = 0;
dash_dir = 1;

dash_dur = 18;   // duração da esquiva (frames)
dash_vel = 16;   // pixels por frame -> 18 x 16 = 288 px (antes eram 154)

// Menu de pause (ESC ou P)
if (!instance_exists(obj_pause)) instance_create_depth(0, 0, -25000, obj_pause);

// Canhão de Plasma (criado no inventário depois dos 3 jogos do computador)
tempo_canhao = 0;
cadencia_canhao = 150;    // frames de recarga (2,5 s)

// Inventário (TAB) + HUD das peças e da arma
if (!instance_exists(obj_inventario)) instance_create_depth(0, 0, -24000, obj_inventario);
