cena_atual = 0;
max_cenas = 8;
caracteres_desenhados = 0;

spr_cenas = [
    spr_cena_nave, 
    spr_cena_cockpit, 
    spr_cena_erro, 
    spr_emp, 
    spr_emp, 
    spr_cena_gravidade, 
    noone,
    spr_cena_capsula_terra
];

txt_cenas = [
    "em algum lugar no espaço...", 
    "", 
    "", 
    "", 
    "", 
    "", 
    "David foi arremessado contra a porta, entrando acidentalmente em uma cápsula de escape.",
    ""
];

dialogo_nome = [
    "", 
    "David (Pensamento)", 
    "David (Pensamento)", 
    "David (Pensamento)", 
    "David (Pensamento)",
    "David (Desespero)",
    "",
    ""
];

dialogo_texto = [
    "", 
    "Essa será a última tentativa, eu vou te encontrar custe o que custar...", 
    "O quê...?! Como assim Humanidade não encontrada?! Isso é impossível!",
    "Que droga, o que é isso que está acontecendo nesse lugar?",
    "Essa coisa verde com certeza está relacionada com esse erro, talvez isso tenha algo relacionado a ele também...",
    "FALHA NA GRAVIDADE!? NÃO PODE SER!",
    "",
    ""
];

estado = 0; 
alpha_texto = 0;
alpha_imagem = 0;
alpha_fade = 0;
alpha_caixa = 0;
iniciou = false;