/// CREATE — obj_musica_fases
// Controla a música das fases. É persistente: sobrevive a room_goto e
// room_restart, então a música NÃO reinicia quando o David morre.

musica_atual = -1;     // som que está tocando agora
instancia_som = -1;    // instância retornada por audio_play_sound
volume_musica = 0.6;   // volume da música das fases (0 a 1)
tempo_fade_ms = 1000;  // duração do fade-in ao trocar de música

// Qual música toca em cada fase:
// 1) procura um som chamado "snd_musica_fase_N" (ex.: snd_musica_fase_3)
// 2) se não achar, usa o som "snd_musica_fases" (música única para todas)
// 3) se nenhum existir, fica em silêncio (sem erro)
