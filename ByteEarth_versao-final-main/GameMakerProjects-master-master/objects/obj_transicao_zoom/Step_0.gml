cam = view_camera[0];

var _largura_atual = camera_get_view_width(cam);
var _altura_atual = camera_get_view_height(cam);

if (fase == 0) {
    zoom_fator = lerp(zoom_fator, zoom_min, velocidade);
    
    if (zoom_fator <= zoom_min + 0.05) {
        if (destino_room != -1) {
            room_goto(destino_room);
        } else if (instance_exists(obj_menu)) {
            obj_menu.aba_atual = destino_aba;
        }
        fase = 1;
    }
} else if (fase == 1) {
    zoom_fator = lerp(zoom_fator, 1.0, velocidade);
    
    if (zoom_fator >= 0.98) {
        camera_set_view_size(cam, largura_orig, altura_orig);
        display_set_gui_size(gui_w_orig, gui_h_orig);
        instance_destroy();
        exit;
    }
}

var _nova_largura = largura_orig * zoom_fator;
var _nova_altura = altura_orig * zoom_fator;

var _cam_x = (room_width - _nova_largura) * 0.5;
var _cam_y = (room_height - _nova_altura) * 0.5;

camera_set_view_pos(cam, _cam_x, _cam_y);
camera_set_view_size(cam, _nova_largura, _nova_altura);

display_set_gui_size(gui_w_orig * zoom_fator, gui_h_orig * zoom_fator);