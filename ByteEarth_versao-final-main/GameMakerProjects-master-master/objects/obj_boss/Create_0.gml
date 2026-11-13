/// CREATE — obj_boss (Paul, o chefe final)

hp_max = 90;                 // vida total (a pistola tira 1; o Canhão de Plasma tira 10)
hp = hp_max;
fase = 1;                    // 1 = normal | 2 = fúria (abaixo de 2/3 da vida) | 3 = frenesi (abaixo de 1/3)
fase_alvo = 2;               // fase para a qual ele vai quando terminar a transição
combo = false;               // fase 3: o salto vem em dupla
estado = "dormindo";         // o obj_boss_ctrl acorda ele depois da introdução
t = 0;                       // contador de frames do estado atual
facing = -1;                 // 1 = olha para a direita, -1 = esquerda
vsp = 0;
hsp = 0;
chao_y = 705;                // y dos pés quando está no chão
vulneravel = false;          // só leva dano depois que a luta começa
terminou = false;            // true quando a animação de morte acabou
flash = 0;                   // frames de flash branco ao levar tiro
tremor = 0;
pausa = 90;                  // frames andando atrás do David antes do próximo ataque
ultimo_ataque = "";
particulas = [];
core_dx = 17;   // posição do núcleo de energia do peito (em relação aos pés)
core_dy = -164;

sprite_index = spr_paul_idle;
mask_index = spr_paul_idle;  // a colisão usa sempre o corpo parado
image_speed = 0.15;

// troca de animação só quando muda
trocar = function(_spr, _vel) {
    if (sprite_index != _spr) { sprite_index = _spr; image_index = 0; }
    image_speed = _vel;
};

tocar_grave = function(_pitch) {
    var _s = audio_play_sound(snd_tiro_arma, 1, false);
    audio_sound_pitch(_s, _pitch);
};

faisca = function(_x, _y, _cor) {
    array_push(particulas, { x: _x, y: _y, vx: random_range(-3, 3), vy: random_range(-5, 0), vida: irandom_range(20, 45), cor: _cor });
};

// onda de choque que corre pelo chão (o David precisa pular)
criar_onda = function(_x, _dir) {
    var _o = instance_create_depth(_x, chao_y - 2, 100, obj_boss_onda);
    _o.dir = _dir;
    _o.vel = (fase == 3) ? 9.5 : ((fase == 2) ? 8 : 6);
};

// rajada de plasma saindo do núcleo do peito, mirando no David
atirar = function(_n, _abertura) {
    var _ox = x + core_dx * facing;
    var _oy = y + core_dy;
    var _ang = (facing == 1) ? 0 : 180;
    if (instance_exists(obj_david)) {
        var _d = instance_find(obj_david, 0);
        _ang = point_direction(_ox, _oy, _d.x, _d.y - 40);
    }
    for (var i = 0; i < _n; i++) {
        var _b = instance_create_depth(_ox, _oy, 100, obj_boss_tiro);
        _b.direction = _ang + (i - (_n - 1) / 2) * _abertura;
        _b.speed = (fase == 3) ? 8 : ((fase == 2) ? 7 : 5.5);
    }
    tocar_grave(0.55);
};

voltar = function() {
    estado = "andar";
    t = 0;
    pausa = (fase == 1) ? irandom_range(70, 110) : ((fase == 2) ? irandom_range(35, 65) : irandom_range(18, 42));
};

escolher_ataque = function() {
    var _opcoes = (fase == 1) ? ["soco", "tiro", "salto"] : ((fase == 2) ? ["soco", "tiro", "salto", "pilares"] : ["soco", "tiro", "salto", "pilares", "chuva"]);
    var _e = _opcoes[irandom(array_length(_opcoes) - 1)];
    var _tent = 0;
    while (_e == ultimo_ataque && _tent < 10) { _e = _opcoes[irandom(array_length(_opcoes) - 1)]; _tent++; }
    // perto do David: soco no chão; muito longe: tiro ou salto
    if (instance_exists(obj_david)) {
        var _dist = abs(instance_find(obj_david, 0).x - x);
        if (_dist < 160 && irandom(1) == 0) _e = "soco";
    }
    ultimo_ataque = _e;
    estado = _e;
    t = 0;
};

// chamado quando uma bala do David acerta
levar_tiro = function(_dano) {
    if (!vulneravel || estado == "morrendo" || estado == "furia" || estado == "dormindo") return;
    hp = max(0, hp - _dano);
    flash = (_dano >= 10) ? 12 : 4;
    if (_dano >= 10) tremor = 12;      // o canhão sacode o chefe
    if (hp <= 0) {
        estado = "morrendo";
        t = 0;
        with (obj_boss_tiro) instance_destroy();
        with (obj_boss_onda) instance_destroy();
        with (obj_boss_pilar) instance_destroy();
    } else if (fase == 1 && hp <= hp_max * (2 / 3)) {
        estado = "furia";
        fase_alvo = 2;
        t = 0;
    } else if (fase == 2 && hp <= hp_max * (1 / 3)) {
        estado = "furia";
        fase_alvo = 3;
        t = 0;
    }
};

// Barra de vida (o obj_boss_ctrl liga depois da introdução)
barra_ativa = false;
barra_vis = 0;
hp_vis = 1;
