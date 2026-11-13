estado += 1;

if (estado == 1) {
    if (txt_cenas[cena_atual] == "") {
        estado = 2; 
        alarm[0] = 1;
    } else {
        alarm[0] = room_speed * 4; 
    }
} 
else if (estado == 2) {
    alarm[0] = room_speed * 1; 
} 
else if (estado == 3) {
    if (!audio_is_playing(snd_musica_cutscene)) {
        audio_play_sound(snd_musica_cutscene, 1, true);
    }
    alarm[0] = room_speed * 2; 
}
else if (estado == 4) {
    if (dialogo_texto[cena_atual] == "") {
        alarm[0] = room_speed * 2; 
    }
}
else if (estado == 5) {
    alarm[0] = room_speed * 0.8;
}