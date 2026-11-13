/// COLLISION com obj_bala — dá para destruir a plasma do Paul atirando nela
with (other) {
    instance_create_depth(x, y, -10002, obj_bala_impacto);
    instance_destroy();
}
instance_create_depth(x, y, -10002, obj_bala_impacto);
instance_destroy();
