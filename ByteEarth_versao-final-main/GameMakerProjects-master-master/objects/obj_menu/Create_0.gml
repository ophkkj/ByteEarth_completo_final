aba_atual = "principal";

opcoes_menu = ["Jogar", "Opções", "Créditos", "Sair"];
espacamento = 40;
hover_index = -1;
timer_alternancia = 0;
delay_troca = 60;
estado_icone = false;
pulsar_velocidade = 0.005;
pulsar_amplitude = 0.1;
icon_padding = 8;
offset_y_icone = 0;

opcao_sel = 0;
volume_jogo = 1.0;
brilho_jogo = 1.0;
audio_master_gain(volume_jogo);

if (!audio_is_playing(snd_musica_menu)) {
    audio_play_sound(snd_musica_menu, 1, true);
}