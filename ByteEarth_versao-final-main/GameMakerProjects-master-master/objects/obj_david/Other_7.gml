
/// ANIMATION END — obj_david

// Terminou a animação de espera (bate o pé): volta para o idle e espera um tempo
// (um pouco aleatório) antes de repetir
if (sprite_index == spr_david_espera) {
    esperando = false;
    tempo_parado = -irandom(120);
    sprite_index = spr_david_idle;
    image_index = 0;
    image_speed = 0.12;
}

if (sprite_index == spr_alien_arma) {
    sprite_index = spr_alien_olhar_arma;
    image_index = 0;
    image_speed = 0.15;
}
else if (sprite_index == spr_alien_olhar_arma) {
    sprite_index = spr_alien_guardar_arma;
    image_index = 0;
    image_speed = 0.15;
}
else if (sprite_index == spr_alien_guardar_arma) {
    usando_arma = false;

    sprite_index = spr_alien_idle;
    image_index = 0;
    image_speed = 0.12;

    alarm[0] = room_speed * 45;
}
