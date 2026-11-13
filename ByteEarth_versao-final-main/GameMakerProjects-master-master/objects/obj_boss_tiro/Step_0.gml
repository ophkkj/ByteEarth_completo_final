/// STEP — obj_boss_tiro
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado
vida++;
if (vida > 420 || x < -40 || x > room_width + 40 || y < -80 || y > room_height + 40) {
    instance_destroy();
    exit;
}
if (place_meeting(x, y, obj_solido)) {
    instance_create_depth(x, y, -10002, obj_bala_impacto);
    instance_destroy();
    exit;
}
if (place_meeting(x, y, obj_david)) {
    with (obj_david) levar_dano(false, other.x);
    instance_create_depth(x, y, -10002, obj_bala_impacto);
    instance_destroy();
}
