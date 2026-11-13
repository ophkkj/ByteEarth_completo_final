/// COLLISION com obj_bala — obj_boss
var _dano = other.dano;                 // pistola = 1 | canhão de plasma = 10
var _esc = other.escala_impacto;
with (other) {
    var _im = instance_create_depth(x, y, -10002, obj_bala_impacto);
    _im.image_xscale = _esc;
    _im.image_yscale = _esc;
    instance_destroy();
}
levar_tiro(_dano);
