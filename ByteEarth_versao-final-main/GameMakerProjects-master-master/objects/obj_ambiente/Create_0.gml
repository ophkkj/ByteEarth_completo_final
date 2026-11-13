/// CREATE — obj_ambiente: poeira/cinzas e névoa baixa para o David "entrar" no cenário (fases 2 a 5)
depth = -50;                                   // na frente dos personagens, bem sutil
metro = (room == rm_fase_4 || room == rm_fase_5);
n = 60;
px = []; py = []; pv = []; pr = []; pa = [];
for (var i = 0; i < n; i++) {
    px[i] = random(room_width);
    py[i] = random(room_height);
    pv[i] = random_range(0.2, 0.9);
    pr[i] = random_range(1, 2.4);
    pa[i] = random_range(0.15, 0.5);
}
luz = 0;      // piscada das lâmpadas no metrô
