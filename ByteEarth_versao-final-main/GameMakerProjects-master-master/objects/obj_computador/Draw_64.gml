/// DRAW GUI — obj_computador (aviso "Pressione E" + tela do computador com os minijogos)

// Trabalha em coordenadas da room (1366 x 768), qualquer que seja o tamanho da GUI
var gx = display_get_gui_width() / room_width;
var gy = display_get_gui_height() / room_height;
matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, gx, gy, 1));

var verde = make_color_rgb(129, 246, 22);
var ciano = make_color_rgb(60, 180, 255);
var W = room_width;
var H = room_height;

if (ui == 0) {
    // ---------- Aviso ----------
    if (perto && !usado) {
        var txt = "Pressione E para usar";
        var sc = 1.5;
        draw_set_font(fDavid);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var tw = string_width(txt) * sc;
        var th = string_height(txt) * sc;
        var py = y - alt - 70 - 40 + sin(current_time / 300) * 3;

        draw_set_alpha(0.92);
        draw_set_color(make_color_rgb(18, 22, 38));
        draw_roundrect_ext(x - tw / 2 - 18, py - th / 2 - 10, x + tw / 2 + 18, py + th / 2 + 10, 10, 10, false);
        draw_set_alpha(1);
        draw_set_color(verde);
        draw_roundrect_ext(x - tw / 2 - 18, py - th / 2 - 10, x + tw / 2 + 18, py + th / 2 + 10, 10, 10, true);
        draw_set_color(c_white);
        draw_text_transformed(x, py, txt, sc, sc, 0);
    }
} else {
    // ---------- Tela do computador ----------
    var x1 = tela_x1, y1 = tela_y1, x2 = tela_x2, y2 = tela_y2;

    // Escurece a fase
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, W, H, false);

    // Janela
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(8, 12, 28));
    draw_roundrect_ext(x1, y1, x2, y2, 16, 16, false);
    draw_set_color(ciano);
    draw_roundrect_ext(x1, y1, x2, y2, 16, 16, true);
    draw_roundrect_ext(x1 + 1, y1 + 1, x2 - 1, y2 - 1, 16, 16, true);

    // Barra de título
    draw_set_color(make_color_rgb(18, 28, 56));
    draw_rectangle(x1 + 3, y1 + 3, x2 - 3, y1 + 50, false);
    var feitos = 0;
    for (var f = 0; f < 3; f++) {
        if (jogos_ok[f]) feitos++;
    }
    draw_set_font(fMenu);
    draw_set_valign(fa_middle);
    draw_set_halign(fa_left);
    draw_set_color(ciano);
    draw_text_transformed(x1 + 24, y1 + 27, "BYTE-OS  //  TERMINAL", 0.7, 0.7, 0);
    draw_set_halign(fa_right);
    draw_set_color(verde);
    draw_text_transformed(x2 - 24, y1 + 27, string(feitos) + " / 3 concluídos", 0.7, 0.7, 0);

    draw_set_halign(fa_center);

    if (ui == 1) {
        // ---------- Menu: 3 minijogos ----------
        draw_set_font(fMenu);
        draw_set_color(c_white);
        draw_text_transformed(W / 2, y1 + 120, "ESCOLHA UM MINIJOGO", 0.9, 0.9, 0);

        for (var i = 0; i < 3; i++) {
            var c = cartoes[i];
            var feito = jogos_ok[i];
            var sobre = (hover == i) && !feito;
            var cx = (c.x1 + c.x2) / 2;

            draw_set_alpha(1);
            if (feito) draw_set_color(make_color_rgb(14, 56, 20));
            else if (sobre) draw_set_color(make_color_rgb(24, 40, 78));
            else draw_set_color(make_color_rgb(14, 20, 44));
            draw_roundrect_ext(c.x1, c.y1, c.x2, c.y2, 14, 14, false);

            draw_set_color((feito || sobre) ? verde : ciano);
            draw_roundrect_ext(c.x1, c.y1, c.x2, c.y2, 14, 14, true);
            draw_roundrect_ext(c.x1 + 1, c.y1 + 1, c.x2 - 1, c.y2 - 1, 14, 14, true);

            draw_set_font(fMenu);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(feito ? verde : c_white);
            draw_text_transformed(cx, c.y1 + 65, icones[i], 1.5, 1.5, 0);
            draw_text_transformed(cx, c.y1 + 130, string(i + 1) + ". " + nomes_jogos[i], 0.8, 0.8, 0);

            draw_set_font(fDavid);
            draw_set_color(make_color_rgb(190, 200, 230));
            draw_text_ext_transformed(cx, c.y1 + 195, descricoes[i], -1, (c.x2 - c.x1 - 30) / 1.1, 1.1, 1.1, 0);

            draw_set_font(fMenu);
            draw_set_color(feito ? verde : (sobre ? verde : ciano));
            draw_text_transformed(cx, c.y2 - 24, feito ? "CONCLUÍDO" : "JOGAR", 0.7, 0.7, 0);
        }

        draw_set_font(fDavid);
        draw_set_color(make_color_rgb(150, 160, 190));
        draw_text_transformed(W / 2, y2 - 36, "Clique em um jogo (ou aperte 1, 2 ou 3)   |   ESC = fechar o computador", 1.1, 1.1, 0);
    }
    else if (ui == 2) {
        // ---------- Jogo ----------
        var p = perguntas[idx];

        draw_set_font(fMenu);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(ciano);
        draw_text_transformed(W / 2, y1 + 95, nomes_jogos[jogo_atual] + "  -  PERGUNTA " + string(idx + 1) + " / " + string(array_length(perguntas)), 0.7, 0.7, 0);

        draw_set_font(fDavid);
        draw_set_color(c_white);
        draw_text_ext_transformed(W / 2, 270, p.q, -1, 900 / 1.9, 1.9, 1.9, 0);

        for (var i = 0; i < 4; i++) {
            var b = botoes[i];
            var meio = (b.y1 + b.y2) / 2;
            var cor_f = make_color_rgb(14, 20, 44);
            var cor_b = ciano;
            if (tentado[i]) { cor_f = make_color_rgb(70, 16, 16); cor_b = c_red; }
            else if (hover == i) { cor_f = make_color_rgb(24, 40, 78); cor_b = verde; }

            draw_set_alpha(1);
            draw_set_color(cor_f);
            draw_roundrect_ext(b.x1, b.y1, b.x2, b.y2, 12, 12, false);
            draw_set_color(cor_b);
            draw_roundrect_ext(b.x1, b.y1, b.x2, b.y2, 12, 12, true);
            draw_roundrect_ext(b.x1 + 1, b.y1 + 1, b.x2 - 1, b.y2 - 1, 12, 12, true);

            // número da tecla
            draw_circle(b.x1 + 40, meio, 20, false);
            draw_set_font(fMenu);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_black);
            draw_text_transformed(b.x1 + 40, meio, string(i + 1), 0.7, 0.7, 0);

            draw_set_font(fDavid);
            draw_set_halign(fa_left);
            draw_set_color(c_white);
            draw_text_ext_transformed(b.x1 + 76, meio, p.opts[i], -1, (b.x2 - b.x1 - 96) / 1.3, 1.3, 1.3, 0);
        }

        // Feedback
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(fDavid);
        if (erro_timer > 0) {
            draw_set_color(c_red);
            draw_text_transformed(W / 2, 640, "Resposta incorreta. Tente outra opção!", 1.5, 1.5, 0);
        } else if (ok_timer > 0) {
            draw_set_color(verde);
            draw_text_transformed(W / 2, 640, "Correto!", 1.5, 1.5, 0);
        }
        draw_set_color(make_color_rgb(150, 160, 190));
        draw_text_transformed(W / 2, y2 - 22, "Clique em uma resposta (ou aperte 1-4)   |   ESC = voltar ao menu", 1.1, 1.1, 0);
    }
    else if (ui == 3) {
        // ---------- Um jogo concluído ----------
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(fMenu);
        draw_set_color(verde);
        draw_text_transformed(W / 2, H / 2 - 30, "JOGO CONCLUÍDO!", 1.3, 1.3, 0);
        draw_set_font(fDavid);
        draw_set_color(c_white);
        draw_text_transformed(W / 2, H / 2 + 40, "Voltando ao menu...", 1.4, 1.4, 0);
    }
    else if (ui == 4) {
        // ---------- Tudo concluído ----------
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(fMenu);
        draw_set_color((current_time div 120) mod 2 == 0 ? verde : ciano);
        draw_text_transformed(W / 2, H / 2 - 30, "TODOS OS JOGOS CONCLUÍDOS", 1.1, 1.1, 0);
        draw_set_font(fDavid);
        draw_set_color(c_white);
        draw_text_transformed(W / 2, H / 2 + 40, "Acesso concedido...", 1.4, 1.4, 0);
    }
}

// Volta ao normal
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
matrix_set(matrix_world, matrix_build_identity());
