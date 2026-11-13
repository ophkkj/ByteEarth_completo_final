/// STEP — obj_fase5_ctrl
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado

if (alerta > 0) alerta--;

var px = instance_exists(portal) ? portal.x : 0;

switch (estado) {

    // ---------- Mensagem na tela ----------
    case 2:
        timer++;
        if (timer < 230) msg_alpha = min(1, msg_alpha + 0.04);
        else msg_alpha = max(0, msg_alpha - 0.04);
        if (timer > 25) msg_chars = min(string_length(msg_texto), msg_chars + 0.5);

        // Mensagem sumiu: a fase volta e a emboscada começa
        if (timer >= 230 && msg_alpha <= 0) {
            criar_emboscada();
            estado = 3;
        }
    break;

    // ---------- Emboscada: só depois de matar TODOS os zumbis o portal aparece ----------
    case 3:
        if (emboscada_criada && instance_number(obj_zumbi) == 0) {
            criar_portal();
            estado = 4;
            timer = 0;
        }
    break;

    // ---------- Portal surgindo ----------
    case 4:
        timer++;
        with (obj_david) { controle_travado = true; auto_dir = 0; }
        if (timer >= 50) {
            estado = 5;
            timer = 0;
            dlg_chars = 0;
            dlg_espera = 0;
        }
    break;

    // ---------- Caixa de diálogo do David ----------
    case 5:
        dlg_alpha = min(1, dlg_alpha + 0.1);
        var tam = string_length(dialogo_texto);
        if (dlg_chars < tam) {
            dlg_chars = min(tam, dlg_chars + 0.6);
            if (keyboard_check_pressed(vk_enter)) dlg_chars = tam;
        } else {
            dlg_espera++;
            // Logo depois da fala (ou ENTER), o David começa a andar
            if (dlg_espera > 90 || keyboard_check_pressed(vk_enter)) {
                estado = 6;
                walk_timer = 0;
            }
        }
    break;

    // ---------- David caminha até o portal ----------
    case 6:
        walk_timer++;
        dlg_alpha = max(0, dlg_alpha - 0.1);
        if (instance_exists(obj_david) && instance_exists(portal)) {
            if (abs(obj_david.x - px) > 8 && walk_timer < 900) {
                obj_david.controle_travado = true;
                obj_david.auto_dir = sign(px - obj_david.x);
            } else {
                obj_david.auto_dir = 0;
                estado = 7;
                timer = 0;
            }
        } else {
            estado = 7;
            timer = 0;
        }
    break;

    // ---------- David entra no portal e some ----------
    case 7:
        timer++;
        if (instance_exists(portal)) portal.engolindo = true;
        if (instance_exists(obj_david)) {
            obj_david.auto_dir = 0;
            obj_david.x = lerp(obj_david.x, px, 0.15);
            obj_david.alfa_david = max(0, obj_david.alfa_david - 0.04);
        }

        // Entrou no portal: começa a cena final (tela preta + pensamentos do David)
        // e, no fim dela, o jogo volta para a tela inicial
        if ((!instance_exists(obj_david) || obj_david.alfa_david <= 0 || timer > 90) && !saindo) {
            iniciar_final();
        }
    break;

    // Estado 8: a cena final está rodando no obj_cena_final
    case 8:
    break;
}
