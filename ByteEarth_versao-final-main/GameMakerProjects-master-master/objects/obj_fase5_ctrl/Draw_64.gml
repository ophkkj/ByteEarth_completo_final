 /// DRAW GUI — obj_fase5_ctrl (alerta, mensagem e caixa de diálogo)

var gx = display_get_gui_width() / room_width;
var gy = display_get_gui_height() / room_height;
matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, gx, gy, 1));

var W = room_width;
var H = room_height;
var verde = make_color_rgb(129, 246, 22);
var ciano = make_color_rgb(60, 180, 255);

// ---------- Alerta de emboscada ----------
if (alerta > 0) {
    draw_set_alpha((alerta / 90) * 0.25 * (0.6 + 0.4 * sin(current_time / 60)));
    draw_set_color(c_red);
    draw_rectangle(0, 0, W, H, false);

    draw_set_alpha(min(1, alerta / 30));
    draw_set_font(fMenu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(W / 2, 130, "EMBOSCADA!", 1.4, 1.4, 0);
}

// ---------- Mensagem: "Não achou que seria tão fácil, certo?" ----------
if (msg_alpha > 0) {
    draw_set_alpha(msg_alpha * 0.85);
    draw_set_color(c_black);
    draw_rectangle(0, 0, W, H, false);

    draw_set_alpha(msg_alpha);
    draw_set_color(verde);
    draw_set_font(fMenu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_ext(W / 2, H / 2, string_copy(msg_texto, 1, floor(msg_chars)), 44, W - 200);
}

// ---------- Caixa de diálogo do David ----------
if (dlg_alpha > 0) {
    var bx = 50;
    var by = H - 200;
    var bw = W - 100;
    var bh = 150;

    draw_set_alpha(dlg_alpha);
    draw_set_color(c_black);
    draw_rectangle(bx, by, bx + bw, by + bh, false);
    draw_set_color(ciano);
    draw_rectangle(bx, by, bx + bw, by + bh, true);

    draw_set_font(fDavid);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(verde);
    draw_text_transformed(bx + 20, by - 36, dialogo_nome, 1.5, 1.5, 0);
    draw_set_color(c_white);
    draw_text_transformed(bx + 20, by + 35, string_copy(dialogo_texto, 1, floor(dlg_chars)), 1.7, 1.7, 0);

    if (dlg_chars >= string_length(dialogo_texto)) {
        draw_set_halign(fa_right);
        draw_set_alpha(abs(sin(current_time * 0.005)) * dlg_alpha);
        draw_text(bx + bw - 20, by + bh - 30, "aperte ENTER...");
    }
}

// Volta ao normal
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
matrix_set(matrix_world, matrix_build_identity());
