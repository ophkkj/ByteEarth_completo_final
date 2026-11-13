/// STEP — obj_peca
if (variable_global_exists("pausado") && global.pausado) exit;

t++;

// cai e quica uma vez no chão
if (estado == "caindo") {
    vsp += grav;
    if (!place_meeting(x + hsp, y, obj_solido)) x += hsp; else hsp = -hsp * 0.5;
    if (place_meeting(x, y + vsp, obj_solido)) {
        var _s = sign(vsp);
        var _n = 0;
        while (_s != 0 && !place_meeting(x, y + _s, obj_solido) && _n < 30) { y += _s; _n++; }
        if (vsp > 2) {
            vsp = -vsp * 0.35;
            hsp *= 0.6;
        } else {
            vsp = 0;
            hsp = 0;
            estado = "parada";
        }
    } else {
        y += vsp;
    }
}

// o David chega perto: a peça é puxada até ele e vai para o inventário
if (instance_exists(obj_david) && t > 20) {
    var _d = instance_find(obj_david, 0);
    var _dist = point_distance(x, y, _d.x, _d.y - 40);
    if (estado == "parada" && _dist < 150) { imanta = true; estado = "voando"; }
    if (imanta) {
        var _dir = point_direction(x, y, _d.x, _d.y - 40);
        var _v = clamp(300 / max(_dist, 1), 3, 12);
        x += lengthdir_x(_v, _dir);
        y += lengthdir_y(_v, _dir);
    }
    if (_dist < 34) {
        global.inv[tipo] += 1;
        var _snd = audio_play_sound(snd_david_pulo, 1, false);
        audio_sound_pitch(_snd, 2.2 + tipo * 0.2);
        with (obj_inventario) novo_popup("+1 " + nomes[other.tipo], other.x, other.y - 20, cores[other.tipo]);
        instance_destroy();
    }
}
