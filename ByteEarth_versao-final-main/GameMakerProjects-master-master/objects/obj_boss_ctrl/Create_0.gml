/// CREATE — obj_boss_ctrl (introdução, luta e cutscene final com o Paul)

if (!variable_global_exists("boss_intro_visto")) global.boss_intro_visto = false;

depth = -20000;

// Música da luta: se existir um som chamado snd_musica_boss ele toca; senão usa a música das fases
audio_stop_all();
var _snd = asset_get_index("snd_musica_boss");
if (_snd == -1) _snd = asset_get_index("snd_musica_fases");
musica = -1;
if (_snd != -1) {
    musica = audio_play_sound(_snd, 1, true);
    audio_sound_pitch(musica, 1.12);
    audio_sound_gain(musica, 0, 0);
    audio_sound_gain(musica, 0.7, 1500);
}

// 0 entrada | 1 diálogo inicial | 2 banner | 3 LUTA | 4 Paul cai | 5 David se aproxima
// 6 diálogo final | 7 botão da armadura | 8 EXPLOSÃO | 9 "continua..."
// Se o David morreu e a room reiniciou, pula o diálogo inicial
estado = global.boss_intro_visto ? 2 : 0;
t = 0;

boss = instance_create_depth(room_width - 320, 705, 250, obj_boss);
boss.facing = -1;
with (obj_david) controle_travado = true;

falas = [
    { quem: "PAUL",  txt: "Você veio mesmo até aqui... irmão." },
    { quem: "DAVID", txt: "Acabou, Paul. Eu vim te trazer de volta." },
    { quem: "PAUL",  txt: "De volta pra quê? Eu cansei de ser pequeno." },
    { quem: "PAUL",  txt: "Se quer me levar, vai ter que passar por mim." }
];
falas_f = [
    { quem: "DAVID", txt: "Acabou, Paul." },
    { quem: "DAVID", txt: "Eu te perdoo. Por tudo o que você fez." },
    { quem: "DAVID", txt: "Mas você precisa voltar para a nossa terra natal e pagar pelo seu erro." },
    { quem: "PAUL",  txt: "Voltar? Pra aquele lugar? Eu nunca gostei dele." },
    { quem: "PAUL",  txt: "E muito menos de você, David." },
    { quem: "PAUL",  txt: "Eu nunca vou me arrepender de nada do que eu fiz." },
    { quem: "PAUL",  txt: "Se é pra cair... então esse lugar cai comigo." }
];
fala_i = 0;
chars = 0;

alvo_x = 0;       // onde o David para, de frente para o Paul
chegou_t = 0;
ex_t = 0;         // tempo da explosão
branco = 0;       // 0..1: clarão
escuro = 0;       // 0..1: do branco para o preto
saida = false;

// caixa de diálogo com o ícone de quem fala
desenhar_caixa = function(_quem, _txt, _prompt) {
    var gw = room_width;
    var gh = room_height;
    var k = 1;
    var _x1 = gw * 0.10;
    var _x2 = gw * 0.90;
    var _y2 = gh - 36 * k;
    var _y1 = _y2 - 170 * k;
    var _corn = (_quem == "PAUL") ? make_colour_rgb(120, 230, 90) : make_colour_rgb(120, 200, 255);

    draw_set_alpha(0.85);
    draw_set_color(make_colour_rgb(6, 8, 18));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1);
    draw_set_color(_corn);
    draw_rectangle(_x1, _y1, _x2, _y2, true);

    // ícone (retrato) de quem está falando
    var _ic = (_quem == "PAUL") ? spr_icone_paul : spr_icone_david;
    var _is = 1.35 * k;
    draw_sprite_ext(_ic, 0, _x1 + 18 * k, _y1 + (170 * k - 96 * _is) / 2, _is, _is, 0, c_white, 1);
    var _tx = _x1 + 18 * k + 96 * _is + 24 * k;

    draw_set_font(fMenu);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_corn);
    draw_text_transformed(_tx, _y1 + 14 * k, _quem, k * 1.0, k * 1.0, 0);
    draw_set_color(c_white);
    draw_text_ext_transformed(_tx, _y1 + 58 * k, _txt, 40 * k, (_x2 - _tx - 24 * k) / (k * 0.9), k * 0.9, k * 0.9, 0);
    if (_prompt && (current_time div 400) mod 2 == 0) {
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(make_colour_rgb(200, 200, 210));
        draw_text_transformed(_x2 - 18 * k, _y2 - 10 * k, "[ENTER]", k * 0.6, k * 0.6, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
};
