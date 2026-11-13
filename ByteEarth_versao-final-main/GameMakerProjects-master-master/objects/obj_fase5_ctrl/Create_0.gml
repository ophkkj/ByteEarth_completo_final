/// CREATE — obj_fase5_ctrl (controla a sequência da Fase 5)
///
/// 0 = explorando (computador disponível)   1 = computador aberto
/// 2 = mensagem "Não achou que seria tão fácil..."
/// 3 = emboscada (6 zumbis)   4 = portal surgindo
/// 5 = diálogo do David       6 = David anda até o portal
/// 7 = David entra no portal  8-10 = cena final (preto + pensamentos) -> tela inicial

depth = -500;
estado = 0;
timer = 0;
walk_timer = 0;
saindo = false;

// Mensagem após os 3 minijogos
msg_texto = "Não achou que seria tão fácil, certo?";
msg_alpha = 0;
msg_chars = 0;

// Emboscada
emboscada_criada = false;
alerta = 0;

// Portal cibernético
portal = noone;

// Diálogo do David
dialogo_nome = "David";
dialogo_texto = "Eu sabia que você estava aqui...";
dlg_alpha = 0;
dlg_chars = 0;
dlg_espera = 0;

// Chamado pelo computador quando os 3 minijogos terminam
iniciar_mensagem = function() {
    estado = 2;
    timer = 0;
    msg_alpha = 0;
    msg_chars = 0;
};

// 3 zumbis de cada lado da fase (total de 6)
criar_emboscada = function() {
    // Nasce 16 px ACIMA dos pés do David e cai até o chão. Nascer exatamente na altura
    // dele colocava a máscara do zumbi encostando (ou entrando) no chão sólido, e o
    // zumbi ficava travado sem se mexer.
    var yy = (instance_exists(obj_david) ? obj_david.y : 704) - 16;
    for (var i = 0; i < 3; i++) {
        instance_create_layer(110 + i * 95, yy, "Instances", obj_zumbi);                 // lado esquerdo
        instance_create_layer(room_width - 110 - i * 95, yy, "Instances", obj_zumbi);    // lado direito
    }
    emboscada_criada = true;
    alerta = 90;
    with (obj_david) { controle_travado = false; auto_dir = 0; }
};

// Portal cibernético: aparece do lado oposto ao do David
criar_portal = function() {
    var yy = instance_exists(obj_david) ? obj_david.y : 704;
    var px = 1150;
    if (instance_exists(obj_david) && obj_david.x > room_width / 2) px = 216;
    portal = instance_create_layer(px, yy, "Instances", obj_portal_ciber);

    // Trava o David e vira ele para o portal
    with (obj_david) {
        controle_travado = true;
        auto_dir = 0;
        if (px > x) direcao = 1; else direcao = -1;
    }
};


// ---------- Cena final ----------
// A cena (tela preta + pensamentos + volta ao menu) acontece na room rm_cutscene_final.
iniciar_final = function() {
    if (saindo) return;
    saindo = true;
    estado = 8;
    audio_stop_sound(snd_david_andando);
    if (!instance_exists(obj_fade)) {
        var f = instance_create_depth(0, 0, -30000, obj_fade);
        f.destino = rm_cutscene_final;
    }
};
