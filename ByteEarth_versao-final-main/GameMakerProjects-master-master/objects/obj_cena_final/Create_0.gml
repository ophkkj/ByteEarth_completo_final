/// CREATE — obj_cena_final (cena final: tela preta + pensamentos do David)
/// Fica na room rm_cutscene_final (o David chega aqui pelo portal da Fase 5).
/// No fim, segue para a luta contra o Paul (rm_boss). Ao vencer, o jogo volta para a tela inicial.

depth = -25000;

// A room já é preta: 0 = silêncio inicial   1 = pensamentos   2 = fim -> menu
fase = 0;
fin_alpha = 1;
fin_timer = 0;
fin_musica = -1;

// Tira qualquer som que veio da fase e começa a música da cutscene, bem devagar
audio_stop_all();
fin_musica = audio_play_sound(snd_musica_cutscene_final, 3, true);
audio_sound_gain(fin_musica, 0, 0);
audio_sound_gain(fin_musica, 0.8, 3000);

// Cada pensamento: texto, frames de silêncio antes, velocidade de digitação
// (letras por frame), frames parado na tela e cor.
var _cinza = make_color_rgb(200, 200, 200);
var _verm  = make_color_rgb(190, 20, 20);
fin_linhas = [
    { txt: "Eu vim até esse lugar...",                              espera: 60,  vel: 0.30, seg: 100, cor: _cinza },
    { txt: "Demorei anos-luz para chegar até você novamente...",    espera: 50,  vel: 0.30, seg: 110, cor: _cinza },
    { txt: "Eu não posso desistir agora.",                          espera: 70,  vel: 0.35, seg: 90,  cor: _cinza },
    { txt: "Eu não posso deixar você continuar com essa loucura.",  espera: 60,  vel: 0.35, seg: 110, cor: _cinza },
    { txt: "Isso acaba aqui e agora...",                            espera: 80,  vel: 0.25, seg: 130, cor: _cinza },
    { txt: "Irmão.",                                                espera: 220, vel: 0.06, seg: 260, cor: _verm  }
];
fin_idx = 0;
fin_sub = 0;          // 0 = silêncio, 1 = digitando, 2 = parado, 3 = some
fin_chars = 0;
fin_txt_alpha = 0;
fin_t = 0;
