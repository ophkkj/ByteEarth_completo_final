var _wgui = display_get_gui_width();
var _hgui = display_get_gui_height();

var _alpha = clamp((1.0 - zoom_fator) / (1.0 - zoom_min), 0, 1);

draw_set_alpha(_alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, _wgui, _hgui, false);
draw_set_alpha(1);