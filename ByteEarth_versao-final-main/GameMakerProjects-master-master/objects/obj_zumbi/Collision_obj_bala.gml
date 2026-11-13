if (estado == "vivo") {
    var _dano = other.dano;                 // pistola = 1 | canhão = 10
    var _esc = other.escala_impacto;
    hp -= _dano;
    dano_timer = 12;
    var _im = instance_create_depth(other.x, other.y, -10002, obj_bala_impacto);
    _im.image_xscale = _esc;
    _im.image_yscale = _esc;
    with (other) instance_destroy();
}