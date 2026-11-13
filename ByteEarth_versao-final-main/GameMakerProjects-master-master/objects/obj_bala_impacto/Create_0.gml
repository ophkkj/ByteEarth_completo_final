/// CREATE — obj_bala_impacto

sprite_index = spr_bala_impacto;
sprite_set_offset(spr_bala_impacto, 32, 32);   // centraliza a explosão no ponto do impacto
image_speed = 1;
image_xscale = 0.9;
image_yscale = 0.9;
image_angle = irandom(359);   // cada impacto sai um pouco diferente
