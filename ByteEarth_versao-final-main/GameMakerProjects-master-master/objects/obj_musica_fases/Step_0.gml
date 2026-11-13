/// STEP — obj_musica_fases

var _nome_room = room_get_name(room);

// Fora das fases (lobby, cutscene...): para a música e se remove
if (string_pos("rm_fase_", _nome_room) != 1) {
    if (instancia_som != -1) audio_stop_sound(instancia_som);
    instance_destroy();
    exit;
}

var _n = string_delete(_nome_room, 1, 8);   // "rm_fase_3" -> "3"
var _snd = asset_get_index("snd_musica_fase_" + _n);
if (_snd == -1) _snd = asset_get_index("snd_musica_fases");

// Só troca se for uma música diferente da que já está tocando
if (_snd != musica_atual) {
    if (instancia_som != -1) audio_stop_sound(instancia_som);
    musica_atual = _snd;
    instancia_som = -1;

    if (_snd != -1) {
        instancia_som = audio_play_sound(_snd, 1, true);
        audio_sound_gain(instancia_som, 0, 0);
        audio_sound_gain(instancia_som, volume_musica, tempo_fade_ms);
    }
}
