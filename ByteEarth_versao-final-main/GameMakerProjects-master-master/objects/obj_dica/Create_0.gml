/// CREATE — obj_dica

// Balão de dica só existe nas fases 1 e 2 (nunca na Fase 5)
if (room == rm_fase_5) {
    instance_destroy();
    exit;
}

depth = -10000;                 // sempre na frente de tudo

texto = "para se mover use as teclas";        // mensagem curta
teclas = ["W", "A", "S", "D"];       // teclas desenhadas como botões
escala_texto = 0.75;            // tamanho do texto e das teclas (menor = mais compacto)
fonte = -1;                     // coloque fnt_dica aqui se criou uma fonte