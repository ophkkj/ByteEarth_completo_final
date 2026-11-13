/// STEP — obj_boss (Paul)
if (variable_global_exists("pausado") && global.pausado) exit;

if (flash > 0) flash--;
if (tremor > 0) tremor--;

var _d = instance_exists(obj_david) ? instance_find(obj_david, 0) : noone;
var _dx = (_d != noone) ? (_d.x - x) : 0;
var _i = 0;

// olha para o David (menos no ar, dormindo e morrendo)
if (_d != noone && estado != "morrendo" && estado != "salto_ar" && estado != "dormindo") {
    if (abs(_dx) > 10) facing = sign(_dx);
}

t++;

switch (estado) {

    // ---------------- esperando a luta começar ----------------
    case "dormindo":
        trocar(spr_paul_idle, 0.15);
    break;

    // ---------------- anda atrás do David (mais rápido a cada fase) ----------------
    case "andar":
        trocar(spr_paul_andar, (fase == 3) ? 0.4 : ((fase == 2) ? 0.3 : 0.2));
        if (abs(_dx) > 130) {
            x += facing * ((fase == 3) ? 3.1 : ((fase == 2) ? 2.4 : 1.6));    // se aproxima
        } else {
            pausa = min(pausa, 20);                                           // já está perto: ataca logo
        }
        pausa--;
        if (pausa <= 0) escolher_ataque();
    break;

    // ---------------- SOCO NO CHÃO: ondas de choque (fase 2: 2 ondas | fase 3: 3 ondas) ----------------
    case "soco":
        trocar(spr_paul_soco, 0);
        if (t < 8) _i = 0; else if (t < 14) _i = 1; else if (t < 22) _i = 2; else if (t < 36) _i = 3;
        else if (t < 40) _i = 4; else if (t < 50) _i = 5; else if (t < 62) _i = 6; else if (t < 72) _i = 7;
        else if (t < 80) _i = 8; else _i = 9;
        image_index = _i;
        if (t == 36) {
            criar_onda(x - 80, -1);
            criar_onda(x + 80, 1);
            tremor = 14;
            tocar_grave(0.3);
        }
        if (fase >= 2 && t == 58) {
            criar_onda(x - 80, -1);
            criar_onda(x + 80, 1);
            tremor = 10;
        }
        if (fase == 3 && t == 80) {
            criar_onda(x - 80, -1);
            criar_onda(x + 80, 1);
            tremor = 10;
        }
        if (t >= ((fase == 3) ? 104 : 82)) voltar();
    break;

    // ---------------- RAJADA DE PLASMA do núcleo do peito ----------------
    case "tiro":
        trocar(spr_paul_tiro, 0);
        if (t < 10) _i = 0; else if (t < 20) _i = 1; else if (t < 30) _i = 2; else if (t < 40) _i = 3;
        else if (t < 46) _i = 4; else if (t < 52) _i = 5; else if (t < 58) _i = 6; else _i = 7;
        if (fase >= 2 && t >= 60 && t < 70) _i = (t > 66) ? 4 : 3;
        if (fase == 3 && t >= 84 && t < 94) _i = (t > 90) ? 4 : 3;
        image_index = _i;
        if (t == 40) atirar((fase == 3) ? 5 : 3, (fase == 3) ? 13 : 16);
        if (fase >= 2 && t == 66) atirar((fase == 3) ? 7 : 5, 13);
        if (fase == 3 && t == 90) atirar(5, 13);
        if (t >= ((fase == 3) ? 118 : ((fase == 2) ? 96 : 66))) voltar();
    break;

    // ---------------- SALTO: voa até o David e cai com um impacto (fase 3: salto duplo) ----------------
    case "salto":
        trocar(spr_paul_soco, 0);
        image_index = (t < 22) ? 0 : 1;
        if (t >= 22) {
            vsp = -17;
            hsp = clamp(_dx / 42, -9, 9);
            estado = "salto_ar";
            t = 0;
        }
    break;

    case "salto_ar":
        trocar(spr_paul_soco, 0);
        image_index = (vsp < 0) ? 2 : 3;
        x += hsp;
        vsp += 0.8;
        y += vsp;
        if (y >= chao_y) {
            y = chao_y;
            vsp = 0;
            hsp = 0;
            criar_onda(x - 80, -1);
            criar_onda(x + 80, 1);
            tremor = 20;
            tocar_grave(0.25);
            if (_d != noone && abs(_d.x - x) < 110 && _d.y > chao_y - 50) {
                with (_d) levar_dano(false, other.x);
            }
            estado = "salto_fim";
            t = 0;
        }
    break;

    case "salto_fim":
        trocar(spr_paul_soco, 0);
        image_index = (t < 12) ? 5 : ((t < 26) ? 6 : ((t < 36) ? 7 : 8));
        if (t >= 44) {
            if (fase == 3 && !combo) {        // fase 3: pula de novo, sem dar tempo
                combo = true;
                estado = "salto";
                t = 6;
            } else {
                combo = false;
                voltar();
            }
        }
    break;

    // ---------------- PILARES DE ENERGIA (fase 3: dois por vez, um deles ao lado) ----------------
    case "pilares":
        trocar(spr_paul_tiro, 0);
        image_index = (t < 12) ? 1 : ((t < 24) ? 2 : 3);
        tremor = max(tremor, 2);
        var _quando = (fase == 3) ? [24, 42, 60, 78, 96] : ((fase == 2) ? [30, 52, 74, 96] : [30, 58, 86]);
        for (var k = 0; k < array_length(_quando); k++) {
            if (t == _quando[k] && _d != noone) {
                instance_create_depth(_d.x, 0, 120, obj_boss_pilar);
                if (fase == 3) instance_create_depth(clamp(_d.x + choose(-170, 170), 100, room_width - 100), 0, 120, obj_boss_pilar);
            }
        }
        if (t >= ((fase == 3) ? 170 : ((fase == 2) ? 150 : 130))) voltar();
    break;

    // ---------------- CHUVA DE PLASMA (só fase 3): bolas caem do céu perto do David ----------------
    case "chuva":
        trocar(spr_paul_tiro, 0);
        image_index = (t < 12) ? 1 : ((t < 24) ? 2 : 3);
        tremor = max(tremor, 2);
        if (t >= 24 && t <= 150 && t mod 8 == 0 && _d != noone) {
            var _cx = clamp(_d.x + irandom_range(-300, 300), 90, room_width - 90);
            var _gota = instance_create_depth(_cx, -30, 100, obj_boss_tiro);
            _gota.direction = 270;
            _gota.speed = 6.5;
        }
        if (t >= 185) voltar();
    break;

    // ---------------- FÚRIA: muda de fase (invulnerável por um instante) ----------------
    case "furia":
        trocar(spr_paul_tiro, 0);
        image_index = 3 + ((t mod 12 < 6) ? 1 : 0);
        tremor = 4;
        if (t == 1) {
            with (obj_boss_tiro) instance_destroy();
            with (obj_boss_onda) instance_destroy();
            with (obj_boss_pilar) instance_destroy();
            tocar_grave(0.2);
        }
        if (t mod 3 == 0) {
            faisca(x + irandom_range(-40, 40), y - irandom_range(40, 200), (fase_alvo == 3) ? make_colour_rgb(220, 80, 255) : make_colour_rgb(255, 80, 60));
        }
        if (t >= 110) { fase = fase_alvo; voltar(); }
    break;

    // ---------------- MORRENDO ----------------
    case "morrendo":
        trocar(spr_paul_morte, 0);
        image_index = clamp(floor(t / 14), 0, 9);
        tremor = (t < 130) ? 3 : 0;
        if (t < 150 && t mod 2 == 0) {
            faisca(x + irandom_range(-70, 70), y - irandom_range(10, 230), choose(c_white, make_colour_rgb(80, 220, 255), make_colour_rgb(255, 140, 40)));
        }
        if (t > 160) terminou = true;
    break;

    // ---------------- cena final: derrotado, sentado no chão ----------------
    case "derrotado":
        trocar(spr_paul_derrotado, 0.08);
        if (t mod 50 == 0) faisca(x + irandom_range(-50, 50), y - irandom_range(60, 150), make_colour_rgb(80, 220, 255));
    break;

    // ---------------- aperta o botão da armadura: ela pisca cada vez mais rápido ----------------
    case "bomba":
        trocar(spr_paul_bomba, 0.2 + t / 900);
        if (t mod max(8, 34 - floor(t / 8)) == 0) {
            var _sb = audio_play_sound(snd_tiro_arma, 1, false);
            audio_sound_pitch(_sb, 2.4);
        }
    break;

    case "explodiu":
        visible = false;
    break;
}

// brasas: fase 2 vermelhas, fase 3 roxas e mais frequentes
if (fase >= 2 && estado != "morrendo" && t mod ((fase == 3) ? 7 : 14) == 0) {
    faisca(x + irandom_range(-50, 50), y - irandom_range(30, 210), (fase == 3) ? make_colour_rgb(210, 80, 255) : make_colour_rgb(255, 90, 50));
}

// limites da arena
x = clamp(x, 170, room_width - 170);
image_xscale = facing;

// dano de contato (só o tronco, 140 px: os braços/ombros não machucam; a ESQUIVA atravessa de vez)
var _em_combate = (estado == "andar" || estado == "soco" || estado == "tiro" || estado == "salto" || estado == "salto_ar" || estado == "salto_fim" || estado == "pilares" || estado == "chuva");
if (_em_combate && _d != noone && collision_rectangle(x - 70, y - 210, x + 70, y, obj_david, false, true) != noone) {
    with (obj_david) levar_dano(false, other.x);
}

hp_vis = lerp(hp_vis, hp / hp_max, 0.12);

// faíscas
for (var p = array_length(particulas) - 1; p >= 0; p--) {
    var _pp = particulas[p];
    _pp.x += _pp.vx;
    _pp.y += _pp.vy;
    _pp.vy += 0.15;
    _pp.vida--;
    if (_pp.vida <= 0) array_delete(particulas, p, 1);
}
