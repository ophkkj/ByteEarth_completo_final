/// CREATE — obj_bala

// direction e speed são definidos por quem cria a bala
dano = 1;                 // pistola = 1 | canhão de plasma = 10 (o David muda ao atirar)
escala_impacto = 0.9;
vida = 0; // contador de frames
debug_bala = false;

// Projétil de plasma animado (spr_bala_plasma: origem na cabeça da bala, máscara só na cabeça)
sprite_index = spr_bala_plasma;
image_speed = 0.35;
image_xscale = 0.85;
image_yscale = 0.85;
visible = true;
