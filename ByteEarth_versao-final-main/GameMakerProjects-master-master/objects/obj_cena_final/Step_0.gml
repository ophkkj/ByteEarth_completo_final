/// STEP — obj_cena_final

switch (fase) {

    // ---------- 2 segundos de preto e silêncio antes do primeiro pensamento ----------
    case 0:
        fin_timer++;
        if (fin_timer > 120) {
            fase = 1;
            fin_sub = 0;
            fin_t = 0;
        }
    break;

    // ---------- Pensamentos do David ----------
    case 1:
        var _l = fin_linhas[fin_idx];
        fin_t++;

        if (fin_sub == 0) {                       // silêncio antes da frase
            if (fin_t >= _l.espera) { fin_sub = 1; fin_t = 0; fin_chars = 0; fin_txt_alpha = 0; }
        }
        else if (fin_sub == 1) {                  // aparece digitando
            fin_txt_alpha = min(1, fin_txt_alpha + 0.05);
            fin_chars = min(string_length(_l.txt), fin_chars + _l.vel);
            if (fin_chars >= string_length(_l.txt)) { fin_sub = 2; fin_t = 0; }
        }
        else if (fin_sub == 2) {                  // fica parada na tela
            if (fin_t >= _l.seg) { fin_sub = 3; fin_t = 0; }
        }
        else if (fin_sub == 3) {                  // some devagar
            fin_txt_alpha = max(0, fin_txt_alpha - 0.025);
            if (fin_txt_alpha <= 0) {
                fin_idx++;
                fin_sub = 0;
                fin_t = 0;
                if (fin_idx >= array_length(fin_linhas)) {
                    fase = 2;
                    fin_timer = 0;
                    audio_sound_gain(fin_musica, 0, 2500);   // música some
                }
            }
        }
    break;

    // ---------- Fim da cena: segue para a BOSS FIGHT contra o Paul ----------
    case 2:
        fin_timer++;
        if (fin_timer > 180) {
            audio_stop_all();
            global.boss_intro_visto = false;   // a luta começa pelo diálogo
            room_goto(rm_boss);
        }
    break;
}
