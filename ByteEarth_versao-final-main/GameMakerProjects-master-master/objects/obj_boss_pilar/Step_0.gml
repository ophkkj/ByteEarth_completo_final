/// STEP — obj_boss_pilar
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado
t++;
if (t == aviso) {
    var _s = audio_play_sound(snd_tiro_arma, 1, false);
    audio_sound_pitch(_s, 0.4);
}
if (t >= aviso && t < aviso + golpe) {
    if (collision_rectangle(x - larg / 2, 0, x + larg / 2, chao, obj_david, false, true) != noone) {
        with (obj_david) levar_dano(false, other.x);
    }
}
if (t >= aviso + golpe) instance_destroy();
