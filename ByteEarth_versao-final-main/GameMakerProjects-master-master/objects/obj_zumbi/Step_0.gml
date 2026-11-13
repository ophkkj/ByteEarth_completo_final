if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado
if (dano_timer > 0) dano_timer--;
var hsp = 0;

// Segurança: se por qualquer motivo estiver dentro de um sólido, sai dele
if (place_meeting(x, y, obj_solido)) desencravar();
var _x_ini = x;

if (estado == "vivo") {
    if (instance_exists(obj_david)) {
        var dist = obj_david.x - x;
        if (abs(dist) > 4) facing = sign(dist);
        if (dano_timer <= 0) hsp = facing * vel;

        // Gemido de tempos em tempos (mais alto quanto mais perto do David)
        gemido_timer--;
        if (gemido_timer <= 0) {
            gemido_timer = irandom_range(150, 360);
            if (!audio_is_playing(snd_zumbi_gemido)) {
                var _gemido = audio_play_sound(snd_zumbi_gemido, 1, false);
                audio_sound_gain(_gemido, clamp(1 - abs(dist) / 700, 0.1, 0.6), 0);
            }
        }

        if (place_meeting(x, y, obj_david)) {
            with (obj_david) levar_dano(false, other.x);
        }
    }
    if (hp <= 0) {
        estado = "morrendo";
        audio_play_sound(snd_zumbi_morrendo, 1, false);
        global.tutorial_zumbi_morto = true;
        soltar_pecas();   // drop de peças
    }
}

// gravidade
vsp = min(vsp + grav, 12);

// movimento horizontal, de pixel em pixel (testa antes de andar)
if (hsp != 0) {
    var _dir = sign(hsp);
    var _resta = abs(hsp);
    while (_resta > 0) {
        var _passo = _dir * min(1, _resta);
        if (!place_meeting(x + _passo, y, obj_solido)) {
            x += _passo;
        } else if (!place_meeting(x + _passo, y - 3, obj_solido)) {
            // degrau pequeno / arredondamento do chão: sobe 3 px e segue andando
            x += _passo;
            y -= 3;
        } else {
            break; // parede de verdade
        }
        _resta -= 1;
    }
}

// movimento vertical + chão
if (place_meeting(x, y + vsp, obj_solido)) {
    var _s = sign(vsp);
    var _n = 0;
    while (_s != 0 && !place_meeting(x, y + _s, obj_solido) && _n < 20) { y += _s; _n++; }
    vsp = 0;
} else {
    y += vsp;
}

// Anti-trava: quer andar mas não saiu do lugar por 20 frames? Dá uma "soltada".
if (estado == "vivo" && hsp != 0) {
    if (abs(x - _x_ini) < 0.01) travado_timer++; else travado_timer = 0;
    if (travado_timer >= 20) {
        travado_timer = 0;
        if (desencravar() == 0) y -= 2;
    }
} else {
    travado_timer = 0;
}

// morte: some aos poucos (depois trocamos pela animação de morte)
if (estado == "morrendo") {
    morte_timer++;
    image_alpha = clamp(1 - (morte_timer - 55) / 25, 0, 1);   // cai, fica no chão um instante e some
    if (morte_timer >= 80) instance_destroy();
}

// visual
// ---- animação: correr / atacar / sentir o tiro / cair ----
var _spr = spr_zumbi_andar;
var _vel = 0.2;
if (estado == "morrendo") {
    _spr = spr_zumbi_morte; _vel = 0;
} else if (dano_timer > 0) {
    _spr = spr_zumbi_dano; _vel = 0.25;
} else if (instance_exists(obj_david) && abs(obj_david.x - x) < 150 && abs(obj_david.y - y) < 80) {
    _spr = spr_zumbi_atacar; _vel = 0.2;
}
if (sprite_index != _spr) { sprite_index = _spr; image_index = 0; }
image_speed = _vel;
if (estado == "morrendo") image_index = min(9, floor(morte_timer / 5));   // cai para trás e fica no chão

image_blend = cor_ambiente;
image_xscale = facing * lado_original * escala;
image_yscale = escala;