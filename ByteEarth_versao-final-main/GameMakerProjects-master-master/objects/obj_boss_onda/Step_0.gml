/// STEP — obj_boss_onda
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado
image_xscale = dir;
x += dir * vel;
if (x < -70 || x > room_width + 70) { instance_destroy(); exit; }
if (place_meeting(x, y, obj_david)) {
    with (obj_david) levar_dano(false, other.x);
}
