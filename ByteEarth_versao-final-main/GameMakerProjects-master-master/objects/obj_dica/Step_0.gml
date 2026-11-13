/// STEP — obj_dica
if (variable_global_exists("pausado") && global.pausado) exit;   // jogo pausado

// Fica sempre acima da cabeça do David, balançando de leve
if (instance_exists(obj_david)) {
    x = obj_david.x;
    y = obj_david.bbox_top - 14 + sin(current_time / 350) * 2;
}