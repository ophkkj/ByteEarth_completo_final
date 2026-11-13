/// STEP — obj_ambiente
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado
for (var i = 0; i < n; i++) {
    if (metro) {
        py[i] -= 0.15 * pv[i];                 // poeira subindo devagar
        px[i] += 0.25 * pv[i];
    } else {
        py[i] += 0.7 * pv[i];                  // cinzas caindo
        px[i] -= 0.5 * pv[i];
    }
    if (py[i] > room_height + 4) py[i] = -4;
    if (py[i] < -4) py[i] = room_height + 4;
    if (px[i] > room_width + 4) px[i] = -4;
    if (px[i] < -4) px[i] = room_width + 4;
}
if (metro) {
    if (irandom(170) == 0) luz = 0.09;
    luz = max(0, luz - 0.004);
}
