persistent = true;

fase = 0;
zoom_fator = 1.0;
zoom_min = 0.1;
velocidade = 0.15;

cam = view_camera[0];
largura_orig = camera_get_view_width(cam);
altura_orig = camera_get_view_height(cam);

gui_w_orig = display_get_gui_width();
gui_h_orig = display_get_gui_height();

destino_aba = "opcoes";
destino_room = -1;