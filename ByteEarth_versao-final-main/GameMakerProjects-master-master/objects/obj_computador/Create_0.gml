/// CREATE — obj_computador (computador gigante da rm_fase_5)
/// O (x, y) da instância é o centro da base, no chão.

depth = 250;               // atrás do David
larg = 380;                // largura do monitor
alt = 320;                 // altura do monitor
distancia_uso = 230;       // distância horizontal para aparecer "Pressione E para usar"
perto = false;
usado = false;             // vira true quando os 3 minijogos terminam

// 0 = fechado | 1 = menu | 2 = jogando | 3 = jogo concluído | 4 = tudo concluído
ui = 0;
jogo_atual = -1;
jogos_ok = [false, false, false];
hover = -1;
timer_ui = 0;
erro_timer = 0;
ok_timer = 0;
idx = 0;
perguntas = [];
tentado = [false, false, false, false];

nomes_jogos = ["MATEMÁTICA", "ACRE", "IFDS"];
icones = ["f(x)", "NET", "</>"];
descricoes = [
    "Jogo de Matemática",
    "Jogo de Arquitetura de Redes e Computadores",
    "Jogo de Informática e Ferramentas de Desenvolvimento"
];

// ---------- Layout da tela (em coordenadas da room: 1366 x 768) ----------
tela_x1 = 160;
tela_y1 = 60;
tela_x2 = room_width - 160;
tela_y2 = room_height - 60;

cartoes = [];
var cw = 280, ch = 280, gap = 50;
var x0 = (room_width - (3 * cw + 2 * gap)) / 2;
for (var i = 0; i < 3; i++) {
    cartoes[i] = { x1: x0 + i * (cw + gap), y1: 270, x2: x0 + i * (cw + gap) + cw, y2: 270 + ch };
}

botoes = [];
var bw = 440, bh = 84, bg = 24;
var bx0 = (room_width - (2 * bw + bg)) / 2;
for (var i = 0; i < 4; i++) {
    botoes[i] = {
        x1: bx0 + (i mod 2) * (bw + bg),
        y1: 410 + (i div 2) * (bh + bg),
        x2: bx0 + (i mod 2) * (bw + bg) + bw,
        y2: 410 + (i div 2) * (bh + bg) + bh
    };
}

// ---------- Bancos de perguntas (a 1ª opção é sempre a correta; elas são embaralhadas) ----------
banco_acre = [
    { q: "Qual componente da CPU executa as operações lógicas e aritméticas?", o: ["ULA (unidade lógica e aritmética)", "Memória ROM", "Placa de vídeo", "Fonte de alimentação"] },
    { q: "Qual camada do modelo OSI cuida do roteamento dos pacotes (endereços IP)?", o: ["Rede (camada 3)", "Enlace (camada 2)", "Transporte (camada 4)", "Aplicação (camada 7)"] },
    { q: "Qual é a porta padrão do protocolo HTTPS?", o: ["443", "80", "21", "25"] },
    { q: "Para que serve o protocolo DNS?", o: ["Traduzir nomes de domínio em endereços IP", "Criptografar os dados da rede", "Atribuir endereços MAC", "Dividir a rede em sub-redes"] },
    { q: "Entre estas memórias, qual é a mais rápida?", o: ["Cache", "HD", "SSD", "Pen drive"] },
    { q: "Quantos bits tem um endereço IPv4?", o: ["32", "64", "128", "16"] },
    { q: "Qual dispositivo interliga redes diferentes e encaminha pacotes entre elas?", o: ["Roteador", "Teclado", "Monitor", "Caixa de som"] }
];

banco_ifds = [
    { q: "Qual comando do Git cria uma cópia local de um repositório remoto?", o: ["git clone", "git commit", "git push", "git init"] },
    { q: "Qual comando do Git registra as mudanças no histórico local?", o: ["git commit", "git clone", "git pull", "git remote"] },
    { q: "Qual extensão é usada em arquivos de código-fonte C++?", o: [".cpp", ".java", ".py", ".html"] },
    { q: "O que uma IDE oferece ao desenvolvedor?", o: ["Editor, depurador e compilador integrados", "Apenas um navegador web", "Somente um antivírus", "Um sistema operacional completo"] },
    { q: "Qual comando do Git envia seus commits para o repositório remoto?", o: ["git push", "git add", "git status", "git branch"] },
    { q: "Qual linguagem é usada para estruturar páginas web?", o: ["HTML", "SQL", "C++", "Bash"] },
    { q: "O que é um \"bug\" em software?", o: ["Um erro ou defeito no programa", "Um tipo de vírus de rede", "Um backup automático", "Uma extensão de arquivo"] }
];

// ---------- Funções auxiliares ----------
embaralhar = function(arr) {
    for (var i = array_length(arr) - 1; i > 0; i--) {
        var j = irandom(i);
        var tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }
    return arr;
};

// Cria uma pergunta embaralhando as opções e descobrindo onde a certa foi parar
criar_pergunta = function(_texto, _opcoes, _certa) {
    var correta = _opcoes[_certa];
    var o = [];
    for (var i = 0; i < array_length(_opcoes); i++) o[i] = _opcoes[i];
    embaralhar(o);
    var pos = 0;
    for (var k = 0; k < array_length(o); k++) {
        if (o[k] == correta) pos = k;
    }
    return { q: _texto, opts: o, certa: pos };
};

// 4 opções numéricas (a primeira é a correta)
num_opcoes = function(r) {
    var vals = [r];
    var tent = 0;
    while (array_length(vals) < 4 && tent < 200) {
        tent++;
        var d = r + choose(-1, 1) * irandom_range(1, 9);
        var dup = false;
        for (var i = 0; i < array_length(vals); i++) {
            if (vals[i] == d) dup = true;
        }
        if (!dup && d > 0) array_push(vals, d);
    }
    while (array_length(vals) < 4) array_push(vals, r + array_length(vals) * 11);
    var s = [];
    for (var j = 0; j < 4; j++) s[j] = string(vals[j]);
    return s;
};

para_bin = function(n) {
    if (n <= 0) return "0";
    var s = "";
    while (n > 0) {
        s = string(n mod 2) + s;
        n = n div 2;
    }
    return s;
};

gerar_matematica = function() {
    var lista = [];

    // 1) conta simples
    var a = irandom_range(3, 9), b = irandom_range(3, 9), c = irandom_range(5, 30);
    array_push(lista, criar_pergunta(string(a) + " x " + string(b) + " + " + string(c) + " = ?", num_opcoes(a * b + c), 0));

    // 2) equação do 1º grau
    var xv = irandom_range(2, 9), m = irandom_range(2, 6), k = irandom_range(1, 15);
    array_push(lista, criar_pergunta(string(m) + "x + " + string(k) + " = " + string(m * xv + k) + "\nQuanto vale x?", num_opcoes(xv), 0));

    // 3) números em binário
    var n = irandom_range(5, 15);
    array_push(lista, criar_pergunta("Qual é o número " + string(n) + " escrito em binário?",
        [para_bin(n), para_bin(n + 1), para_bin(n - 1), para_bin(n + 2)], 0));

    // 4) potência de 2
    var e = irandom_range(4, 9);
    array_push(lista, criar_pergunta("Quanto é 2 elevado a " + string(e) + "?", num_opcoes(power(2, e)), 0));

    return lista;
};

sortear = function(banco, n) {
    var ids = [];
    for (var i = 0; i < array_length(banco); i++) ids[i] = i;
    embaralhar(ids);
    var lista = [];
    for (var k = 0; k < n; k++) {
        var b = banco[ids[k]];
        array_push(lista, criar_pergunta(b.q, b.o, 0));
    }
    return lista;
};

montar_jogo = function(i) {
    jogo_atual = i;
    idx = 0;
    tentado = [false, false, false, false];
    erro_timer = 0;
    ok_timer = 0;
    if (i == 0) perguntas = gerar_matematica();
    else if (i == 1) perguntas = sortear(banco_acre, 4);
    else perguntas = sortear(banco_ifds, 4);
};

// ---------- Abrir / fechar a tela do computador ----------
abrir = function() {
    ui = 1;
    global.pc_aberto = true;
    with (obj_david) { controle_travado = true; auto_dir = 0; }
    with (obj_fase5_ctrl) estado = 1;
};

fechar = function() {
    ui = 0;
    global.pc_aberto = false;
    with (obj_david) { controle_travado = false; }
    with (obj_fase5_ctrl) estado = 0;
};

responder = function(i) {
    var p = perguntas[idx];
    if (i == p.certa) {
        ok_timer = 25;
        tentado = [false, false, false, false];
        idx++;
        if (idx >= array_length(perguntas)) {
            jogos_ok[jogo_atual] = true;
            ui = 3;
            timer_ui = 100;
        }
    } else {
        tentado[i] = true;
        erro_timer = 45;
    }
};

// Os 3 jogos terminaram: fecha o computador e a fase 5 mostra a mensagem
concluir = function() {
    ui = 0;
    global.pc_aberto = false;
    usado = true;
    global.jogos_concluidos = true;   // libera a criação do Canhão de Plasma no inventário (TAB)
    with (obj_fase5_ctrl) iniciar_mensagem();
};
