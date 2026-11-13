/// CREATE — obj_peca (peça que um zumbi derrubou)

tipo = 0;                  // 0 = Engrenagem | 1 = Chip | 2 = Núcleo (quem cria define)
hsp = random_range(-1.5, 1.5);
vsp = -4;
grav = 0.4;
estado = "caindo";         // caindo -> parada -> (imã) voando
t = 0;
imanta = false;
image_speed = 0;
image_xscale = 0.8;
image_yscale = 0.8;
