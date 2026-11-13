// Garante que a cena final exista na room
if (!instance_exists(obj_cena_final)) {
    instance_create_depth(0, 0, -100, obj_cena_final);
}
