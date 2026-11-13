/// CREATE — obj_portal_ciber (portal de visual cibernético da Fase 5)
/// O (x, y) da instância é o centro da base.

depth = 250;               // atrás do David: ele "entra" no portal
larg = 90;
alt = 160;
escala = 0;                // 0 -> 1: o portal se materializa crescendo
engolindo = false;         // true quando o David está entrando
t = 0;

// "Chuva" de bits dentro do portal
bits = [];
for (var i = 0; i < 26; i++) {
    bits[i] = {
        fx: random_range(-0.8, 0.8),
        vel: random_range(0.6, 1.8),
        off: random(1),
        car: choose("0", "1"),
        cor: choose(true, false)
    };
}
