/// DRAW — obj_boss_onda
draw_self();
gpu_set_blendmode(bm_add);
draw_ellipse_color(x - 34, y - 12, x + 34, y + 8, make_colour_rgb(20, 90, 120), c_black, false);
gpu_set_blendmode(bm_normal);
