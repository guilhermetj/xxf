var selectPage = "rules";
var reversePage = "rules";
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){
	rulesPage();

	window.addEventListener("message",function(event){
		switch (event["data"]["action"]){
			case "openSystem":
				$("#mainPage").css("display","block");
			break;

			case "closeSystem":
				$("#mainPage").css("display","none");
			break;

			case "requestPossuidos":
				benefactor("Possuidos");
			break;
		};
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://tablet/closeSystem");
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).on("click","#mainMenu li",function(){
	if (selectPage != reversePage){
		let isActive = $(this).hasClass("active");
		$("#mainMenu li").removeClass("active");
		if (!isActive){
			$(this).addClass("active");
			reversePage = selectPage;
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
const commandsPage = () => {
	selectPage = "commands";

	$("#content").html(`
		<div id="titleContent">PRINCIPAIS</div>
		<div id="pageDiv">
			<b>/vehs</b> - Lista de seus veículos<br>
			<b>/andar x</b> - Modifica o modo de andar<br>
			<b>/cam</b> - Mudar uma câmera de segurança
		</div>
		<div id="pageDiv">
			<b>/me</b> - Efetuar uma animação não existente<br>
			<b>/chat</b> - Ativa/Desativa o chat<br>
			<b>/setrepose x</b> - X é o número de minutos de repouso
		</div>
		<div id="pageDiv">
			<b>/debug</b> - Recarrega os dados do personagem<br>
			<b>/limbo</b> - Utilizado quando cair no limbo e morrer<br>
			<b>/911</b> - Chat de conversa dos policiais<br>
			<b>/112</b> - Chat de conversa dos paramédicos
		</div>

		<div id="divContent"></div>

		<div id="titleContent">BOTÕES DE ATALHO</div>
		<div id="pageDiv">
			<b>F1</b> - Abrir tablet<br>
			<b>F3</b> - Abrir registro de chamados<br>
			<b>F5</b> - Abrir código 10 policial<br>
			<b>F4</b> - Abrir console do veículo<br>
			<b>F6</b> - Cancela função ativa
		</div>
		<div id="pageDiv">
			<b>ARROW UP</b> - Saudação<br>
			<b>ARROW DOWN</b> - Assobiar<br>
			<b>ARROW LEFT</b> - Joia<br>
			<b>ARROW RIGHT</b> - Facepalm<br>
			<b>F10</b> - Central de Funções de ermegência
		</div>
		<div id="pageDiv">
			<b>HOME</b> - Muda a distancia de falar<br>
			<b>B</b> - Apontar com o dedo<br>
			<b>Z</b> - Ligar/Desligar motor e Agachar-se<br>
			<b>X</b> - Levanta as mãos<br>
			<b>F9</b> - Central de Funções
		</div>

		<div id="divContent"></div>

		<div id="titleContent">ANIMAÇÕES ANDANDO</div>
		<div id="pageDiv">
			<b>/e caixa</b> - Segurar uma caixa na mão<br>
			<b>/e cafe</b> - Segurar um copo de café<br>
			<b>/e cafe2</b> - Segurar e beber um copo de café<br>
			<b>/e anotar</b> - Anotações em uma caderneta<br>
			<b>/e binoculos</b> - Para usar um binóculo<br>
			<b>/e camera</b> - Para pegar uma câmera fotográfica<br>
			<b>/e camera2</b> - Para pegar uma filmadora<br>
			<b>/e mapa</b> - Olhar para o mapa da cidade<br>
			<b>/e selfie</b> - Pegar o celular para tirar uma selfie<br>
			<b>/e selfie2</b> - Pegar o celular para tirar uma selfie<br>
			<b>/e chuva</b> - Usar guarda-chuva<br>
			<b>/e chuva2</b> - Usar guarda-chuva<br>
			<b>/e peace</b> - Saudar a pessoa com um paz e amor<br>
			<b>/e lero</b> - Balaçar as mãos<br>
			<b>/e beijo</b> - Mandar um beijo<br>
			<b>/e pano</b> - Limpa o veículo mais próximo<br>
			<b>/e limpar</b> - Limpar a roupa<br>
			<b>/e alongar2</b> - Alongar-se<br>
			<b>/e cuidar2</b> - Cuidar do paciente<br>
			<b>/e verificar</b> - Verificar corpo<br>
			<b>/e prebeber3</b> - Segurar bebida<br>
			<b>/e bolsa</b> - Segurar bolsa na mão<br>
			<b>/e bolsa4</b> - Segurar bolsa na mão<br>
			<b>/e nervoso</b> - Ficar nervoso<br>
			<b>/e argue</b> - Breve uma descrição do mesmo<br>
			<b>/e bird</b> - Breve uma descrição do mesmo<br>
			<b>/e blowkiss</b> - Breve uma descrição do mesmo
		</div>
		<div id="pageDiv">
			<b>/e digitar</b> - Digitar no computador de uma mesa<br>
			<b>/e postura</b> - Postura com mãos no cinto<br>
			<b>/e postura2</b> - Postura com mãos no cinto<br>
			<b>/e palmas</b> - Bater palmas<br>
			<b>/e palmas2</b> - Bater palmas com entusiasmo<br>
			<b>/e palmas3</b> - Bater palmas com entusiasmo<br>
			<b>/e palmas4</b> - Bater palmas de forma discreta<br>
			<b>/e comer</b> - Comer um hambúrguer<br>
			<b>/e comer2</b> - Comer um cachorro-quente<br>
			<b>/e comer3</b> - Comer uma rosquinha<br>
			<b>/e beber</b> - Consumir bebida alcoólica<br>
			<b>/e beber2</b> - Consumir bebida energética<br>
			<b>/e malicia</b> - Ato provocativo<br>
			<b>/e radio</b> - Usar o rádio da policia<br>
			<b>/e placa</b> - Segurar uma placa<br>
			<b>/e pano2</b> - Limpa o veículo mais próximo<br>
			<b>/e galinha</b> - Bater os braços igual galinha<br>
			<b>/e bora</b> - Chamar uma pessoa<br>
			<b>/e cansado</b> - Estar cansado<br>
			<b>/e cuidar3</b> - Cuidar do paciente<br>
			<b>/e prebeber</b> - Segurar bebida<br>
			<b>/e lixo</b> - Segurar saco de lixo<br>
			<b>/e bolsa2</b> - Segurar bolsa na mão<br>
			<b>/e clapangry</b> - Breve uma descrição do mesmo<br>
			<b>/e comeatmebro</b> - Breve uma descrição do mesmo<br>
			<b>/e peace2</b> - Breve uma descrição do mesmo<br>
			<b>/e bringiton</b> - Breve uma descrição do mesmo
		</div>
		<div id="pageDiv">
			<b>/e continencia</b> - Prestar continência<br>
			<b>/e prancheta</b> - Anotações em uma prancheta<br>
			<b>/e ligar</b> - Realizar uma ligação<br>
			<b>/e musica</b> - Tocar guitarra<br>
			<b>/e musica2</b> - Tocar guitarra<br>
			<b>/e musica3</b> - Tocar violão<br>
			<b>/e musica4</b> - Tocar violão<br>
			<b>/e beber3</b> - Consumir cerveja<br>
			<b>/e beber4</b> - Consumir whisky<br>
			<b>/e beber5</b> - Consumir cerveja<br>
			<b>/e beber6</b> - Consumir cerveja<br>
			<b>/e beber7</b> - Consumir água<br>
			<b>/e varrer</b> - Varrer o chão<br>
			<b>/e placa2</b> - Segurar uma placa<br>
			<b>/e placa3</b> - Segurar uma placa<br>
			<b>/e amem</b> - Agradecer a deus<br>
			<b>/e meleca</b> - Retirar meleca do nariz<br>
			<b>/e cuidar</b> - Cuidar do paciente<br>
			<b>/e mexer</b> - Mexer no objeto<br>
			<b>/e prebeber2</b> - Segurar bebida<br>
			<b>/e caixa2</b> - Segurar uma caixa na mão<br>
			<b>/e bolsa3</b> - Segurar bolsa na mão<br>
			<b>/e radio2</b> - Segurar rádio na mão<br>
			<b>/e superhero</b> - Breve uma descrição do mesmo<br>
			<b>/e type</b> - Breve uma descrição do mesmo<br>
			<b>/e yeah</b> - Breve uma descrição do mesmo
		</div>

		<div id="divContent"></div>

		<div id="titleContent">ANIMAÇÕES PARADAS</div>
		<div id="pageDiv">
			<b>/e deitar</b> - Deitar com o braço na frente do rostoo<br>
			<b>/e deitar2</b> - Deitar de bruços<br>
			<b>/e deitar3</b> - Deitar de barriga pra cima<br>
			<b>/e deitar4</b> - Deitar de barriga para baixo<br>
			<b>/e debrucar</b> - Debruçar num parapeito<br>
			<b>/e sexo</b> - Ato sexual<br>
			<b>/e sexo2</b> - Ato sexual<br>
			<b>/e sexo3</b> - Ato sexual<br>
			<b>/e sexo4</b> - Ato sexual<br>
			<b>/e sexo5</b> - Ato sexual<br>
			<b>/e sexo6</b> - Ato sexual<br>
			<b>/e dancar</b> - Dançar ( total de 258 )<br>
			<b>/e trotar</b> - Performar um trote parado<br>
			<b>/e sentar</b> - Sentar em uma cadeira/banco<br>
			<b>/e sentar2</b> - Sentar no chão<br>
			<b>/e sentar3</b> - Sentar no chão<br>
			<b>/e fumar4</b> - Fumar<br>
			<b>/e tragar</b> - Tragar cigarro não convencional<br>
			<b>/e malhar</b> - Performar musculação com uma barra<br>
			<b>/e malhar2</b> - Performar musculação com uma barra alta<br>
			<b>/e martelo</b> - Martelar<br>
			<b>/e pescar</b> - Usar uma vara de pesca<br>
			<b>/e chill</b> - Breve uma descrição do mesmo<br>
			<b>/e crawl</b> - Breve uma descrição do mesmo<br>
			<b>/e flip</b> - Breve uma descrição do mesmo<br>
			<b>/e flip2</b> - Breve uma descrição do mesmo<br>
			<b>/e inspect</b> - Breve uma descrição do mesmo
		</div>
		<div id="pageDiv">
			<b>/e sentar4</b> - Sentar no chão<br>
			<b>/e striper</b> - Posar como uma striper<br>
			<b>/e escutar</b> - Escutar através da parede/porta<br>
			<b>/e alongar</b> - Alongar-se<br>
			<b>/e dj</b> - Agir como um DJ<br>
			<b>/e rock</b> - Tocar um guitarra invisível<br>
			<b>/e rock2</b> - Fazer o símbolo do rock com as mãos<br>
			<b>/e abracar</b> - Abraçar<br>
			<b>/e abracar2</b> - Abraçar<br>
			<b>/e peitos</b> - Realçar os peitos<br>
			<b>/e espernear</b> - Espernear no chão<br>
			<b>/e arrumar</b> - Pegar e arrumar coisas do chão<br>
			<b>/e bebado</b> - Cair e levantar algumas vezes no chão<br>
			<b>/e bebado2</b> - Levantar do chão<br>
			<b>/e bebado3</b> - Levantar do chão<br>
			<b>/e yoga</b> - Performar yoga<br>
			<b>/e pescar2</b> - Usar uma vara de pesca<br>
			<b>/e procurar</b> - Agachar-se no chão para procurar<br>
			<b>/e sinalizar</b> - Usar um sinalizador<br>
			<b>/e soprador</b> - Usar um soprador<br>
			<b>/e mecanico</b> - Deitar-se no chão e mexer no motor<br>
			<b>/e morrer</b> - Fingir de morto<br>
			<b>/e passout</b> - Breve uma descrição do mesmo<br>
			<b>/e prone</b> - Breve uma descrição do mesmo<br>
			<b>/e sentar7</b> - Breve uma descrição do mesmo<br>
			<b>/e sitchair</b> - Breve uma descrição do mesmo
		</div>
		<div id="pageDiv">
			<b>/e abdominal</b> - Performar abdominais<br>
			<b>/e bixa</b> - Posar como uma striper<br>
			<b>/e britadeira</b> - Usar um britadeira<br>
			<b>/e cerveja</b> - Beber cerveja<br>
			<b>/e churrasco</b> - Usar uma churrasqueira<br>
			<b>/e consertar</b> - Pega o massarico na mão<br>
			<b>/e dormir</b> - Deitar para dormir<br>
			<b>/e ajoelhar</b> - Ajoelha no chão<br>
			<b>/e dormir2</b> - Deitar para dormir<br>
			<b>/e dormir2</b> - Deitar para dormir<br>
			<b>/e flexao</b> - Performar flexões<br>
			<b>/e esquentar</b> - Esquentar as mãos<br>
			<b>/e fumar</b> - Fumar (masculino)<br>
			<b>/e fumar2</b> - Fumar (feminino)<br>
			<b>/e fumar3</b> - Fumar<br>
			<b>/e mecanico3</b> - Apoiar-se na frente do veículo<br>
			<b>/e beijar</b> - Beijar<br>
			<b>/e estatua</b> - Performar uma estátua<br>
			<b>/e encostar</b> - Encostar-se<br>
			<b>/e plantar</b> - Agachar-se no chão<br>
			<b>/e mecanico2</b> - Apoiar-se na frente do veículo<br>
			<b>/e sitchair2</b> - Breve uma descrição do mesmo<br>
			<b>/e sitchair3</b> - Breve uma descrição do mesmo<br>
			<b>/e sitchair4</b> - Breve uma descrição do mesmo<br>
			<b>/e sitchair5</b> - Breve uma descrição do mesmo<br>
			<b>/e meditate</b> - Breve uma descrição do mesmo
		</div>
	`);
};
/* ---------------------------------------------------------------------------------------------------------------- */
const rulesPage = () => {
	selectPage = "rules";

	$("#content").html(`
		<div id="titleContent">ANTI-ROLEPLAY</div>
		<div id="pageContent">
			<b>1:</b> Proibido chamar um serviço no celular e efetuar qualquer atividade ilegal contra o mesmo.<br>
			<b>2:</b> Reféns não podem ter envolvimento com os sequestradores, pense bem antes de iniciar um sequestro.<br>
			<b>3:</b> Após ser reanimado não volte para ação, efetue sua retirada do local imediatamente.<br>
			<b>4:</b> O <s>voip</s> não pode ser utilizado para dialogar assuntos que não tem coerência com o roleplay.<br>
			<b>5:</b> Durante uma ação caso ocorra do seu jogo crashar, é <s>obrigatório</s> voltar e dar continuidade na história.<br>
			<b>6:</b> Não é permitido sequestrar uma pessoa e obriga-lá a efetuar transferências bancárias e afins em troca de sua vida.<br>
			<b>7:</b> Na utilização de máscaras <s>não é possível</s> efetuar o reconhecimento por voz.<br>
			<b>8:</b> Nocauteado você só pode dar <s>/gg</s> após a finalização do roleplay ou com a confirmação de todas as partes.<br>
			<b>9:</b> Proibido pegar uma pessoa nocauteada, reanima-lá e obriga-lá a passar informação, rouba-lá ou qualquer tipo de atividade.<br>
			<b>10:</b> Ao adentrar em um cenário de suicídio tenha a absoluta certeza que ao cometer o mesmo seu personagem é excluído.<br>
			<b>11:</b> Veículos de serviço não podem ser utilizados para efetuar atividades ilegais.<br>
			<b>12:</b> Policiais e sequestradores não podem abrir fogo até que o refém esteja em segurança.<br>
			<b>13:</b> Após ganhar ações contra policiais, você não pode chamar os paramédicos, utilize o <s>Hospital Clandestino</s>.<br>
			<b>14:</b> Após ser nocauteado propositalmente por outra pessoa, você esquece de todo o ocorrido automaticamente.<br>
			<b>15:</b> Roubo de viaturas policiais só podem ser feitas em roubos automatizados como <s>bancos</s> e afins.<br>
			<b>16:</b> Proibido assalto a civís, isso não quer dizer que a mesma não possa ser incluida em qualquer tipo de roleplay.<br>
			<b>17:</b> Após nocautear a vitima, conclua o roleplay e se retire do local.<br>
			<b>18:</b> Proibido qualquer atividade criminal na ilha de <s>Cayo Perico</s>.<br>
			<b>19:</b> Atividades criminais de rua são limitadas a <s>5 Bandidos</s> e <s>8 Policiais</s>.<br>
			      <s>O limite foi imposto para controle situacional, não passe do limite de pessoas do mesmo grupo.</s><br>
			<b>20:</b> Proibido a utilização de arma de fogo durante as <s>Corridas Clandestinas</s> por parte dos corredores.<br>
			<b>21:</b> Proibido a utilização da arma <s>Winchester 1892</s> para qualquer atividade criminal onde o cenário possui vitimas.<br>
			<b>22:</b> Animais domésticos não podem ser incluídos em ações programadas como bancos e afins.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">POLÍCIA / PARAMÉDICO</div>
		<div id="pageContent">
			<b>1:</b> Qualquer tipo de corrupção dentro da corporação é <s>extremamente proibido</s>.<br>
			<b>2:</b> Viaturas não podem ser utilizadas fora de serviço ou dar carona aos civís.<br>
			<b>3:</b> Em caso de resgates a polícia está apta a efetuar disparos contra os mesmos.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">LOJA DE DEPARTAMENTO</div>
		<div id="pageContent">
			<b>1:</b> Máximo <s>4</s> assaltantes e <s>5</s> policiais.<br>
			<b>2:</b> Obrigatório cada integrante do roubo utilizar uma arma de fogo.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">LOJA DE ARMAS</div>
		<div id="pageContent">
			<b>1:</b> Máximo <s>3</s> assaltantes e <s>4</s> policiais.<br>
			<b>2:</b> Obrigatório cada integrante do roubo utilizar uma arma de fogo.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">BANCO FLEECA</div>
		<div id="pageContent">
			<b>1:</b> Máximo <s>4</s> assaltantes e <s>6</s> policiais.<br>
			<b>2:</b> Obrigatório cada integrante do roubo utilizar uma arma de fogo.<br>
			<b>3:</b> Obrigação mínima de <s>1</s> e máximo <s>2</s> reféns.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">REGISTRADORA</div>
		<div id="pageContent">
			<b>1:</b> Máximo <s>2</s> assaltantes e <s>4</s> policiais.<br>
			<b>2:</b> Durante o ocorrido só pode a utilização de arma branca.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">BARBEARIA / CAIXA ELETRÔNICO</div>
		<div id="pageContent">
			<b>1:</b> Máximo <s>4</s> assaltantes e <s>4</s> policiais.<br>
			<b>2:</b> Durante o ocorrido só pode a utilização de arma branca.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">VINEWOOD VAULT / SAVINGS BANK</div>
		<div id="pageContent">
			<b>1:</b> Máximo <s>6</s> assaltantes e <s>8</s> policiais.<br>
			<b>2:</b> Obrigatório cada integrante do roubo utilizar uma arma de fogo.<br>
			<b>3:</b> Obrigação mínima de <s>1</s> e máximo <s>4</s> reféns.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">CARRO FORTE</div>
		<div id="pageContent">
			<b>1:</b> Obrigatório cada integrante do roubo utilizar uma arma de fogo.<br>
			<b>2:</b> Cada grupo só pode efetuar o roubo de 1 veículo por vez.<br>
			<b>3:</b> Proibido reféns, a mesma é uma ação de confronto direto.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">HUMANE LABS</div>
		<div id="pageContent">
			<b>1:</b> Máximo <s>6</s> assaltantes e <s>8</s> policiais.<br>
			<b>2:</b> Obrigatório cada integrante do roubo utilizar no mínimo uma submetralhadora.<br>
			<b>3:</b> Obrigação mínima de <s>1</s> e máximo <s>2</s> reféns.
		</div>

		<div id="divContent"></div>

		<div id="titleContent">PERSONAGEM SECUNDÁRIO</div>
		<div id="pageContent">
			<b>1:</b> Nenhuma informação pode ser compartilhada entre personagens.<br>
			<b>2:</b> Nenhum parentesco é permitido entre os personagens de sua conta.<br>
			<b>3:</b> Nenhum tipo de transferência dos bens entre seus personagens é permitido.<br>
			<b>4:</b> Não pode participar de grupos/gangs que os demais personagens já participam.
		</div>
	`);
};
/* ---------------------------------------------------------------------------------------------------------------- */
const racesPage = (raceId) => {
	selectPage = "races";

	if (raceId == undefined){
		raceId = 1;
	}

	$("#content").html(`
		<div id="raceBar">
			<li id="circuits" data-id="1" ${raceId == 1 ? "class=active":""}>01</li>
			<li id="circuits" data-id="2" ${raceId == 2 ? "class=active":""}>02</li>
			<li id="circuits" data-id="3" ${raceId == 3 ? "class=active":""}>03</li>
			<li id="circuits" data-id="4" ${raceId == 4 ? "class=active":""}>04</li>
			<li id="circuits" data-id="5" ${raceId == 5 ? "class=active":""}>05</li>
			<li id="circuits" data-id="6" ${raceId == 6 ? "class=active":""}>06</li>
			<li id="circuits" data-id="7" ${raceId == 7 ? "class=active":""}>07</li>
			<li id="circuits" data-id="8" ${raceId == 8 ? "class=active":""}>08</li>
			<li id="circuits" data-id="9" ${raceId == 9 ? "class=active":""}>09</li>
			<li id="circuits" data-id="10" ${raceId == 10 ? "class=active":""}>10</li>
			<li id="circuits" data-id="11" ${raceId == 11 ? "class=active":""}>11</li>
			<li id="circuits" data-id="12" ${raceId == 12 ? "class=active":""}>12</li>
			<li id="circuits" data-id="13" ${raceId == 13 ? "class=active":""}>13</li>
		</div>

		<div id="raceContent"></div>
	`);

	$.post("http://tablet/requestRanking",JSON.stringify({ id: raceId }),(data) => {
		let position = 0;

		$.each(data,(k,v) => {
			$('#raceContent').append(`
				<div id="raceLine">
					<div class="racePosition">${position = position + 1}</div>
					<div class="raceName">${v["lastname"]} ${(position == 1 || position == 2 || position == 3) ? "<img src=\"images/"+position+".png\">":""}</div>
					<div class="raceVehicle">${v["vehicle"]}</div>
					<div class="racePoints">${v["date2"]}</div>
					<div class="raceDate">${v["date"]}</div>
				</div>
			`);
		});
	});
};
/* ----------CLICKRACES---------- */
$(document).on("click","#circuits",function(e){
	racesPage(e["target"]["dataset"]["id"]);
});
/* ---------------------------------------------------------------------------------------------------------------- */
var benMode = "Carros"
var benSearch = "alphabetic"

const searchTypePage = (mode) => {
	benSearch = mode;
	benefactor(benMode);
}
/* ---------------------------------------------------------------------------------------------------------------- */
const benefactor = (mode) => {
	benMode = mode;
	selectPage = "benefactor";

	$("#content").html(`
		<div id="raceBar">
			<li id="benefactor" data-id="Carros" ${mode == "Carros" ? "class=active":""}>CARROS</li>
			<li id="benefactor" data-id="Motos" ${mode == "Motos" ? "class=active":""}>MOTOS</li>
			<li id="benefactor" data-id="Aluguel" ${mode == "Aluguel" ? "class=active":""}>ALUGUEL</li>
			<li id="benefactor" data-id="Possuidos" ${mode == "Possuidos" ? "class=active":""}>POSSUÍDOS</li>
		</div>

		<div id="contentVehicles">
			<div id="titleVehicles">${mode}</div>
			<div id="typeSearch"><span onclick="searchTypePage('alphabetic');">Ordem Alfabética</span> / <span onclick="searchTypePage('crescent');">Valor Crescente</span></div>
			<div id="pageVehicles"></div>
		</div>
	`);

	$.post("http://tablet/request"+ mode,JSON.stringify({}),(data) => {
		if (benSearch == "alphabetic"){
			var nameList = data["result"].sort((a,b) => (a["name"] > b["name"]) ? 1: -1);
		} else {
			var nameList = data["result"].sort((a,b) => (a["price"] > b["price"]) ? 1: -1);
		}

		if (mode !== "Possuidos"){
			$("#pageVehicles").html(`
				${nameList.map((item) => (`<span>
					<left>
						${item["name"]}<br>
						<b>Valor:</b> ${mode == "Aluguel" ? item["price"]+" Gemas":"$"+item["price"]}
						<br><b>Porta-Malas:</b> ${item["chest"]}Kg
						<br><b>Estoque:</b> ${item["stock"]}
					</left>
					<right>
						${mode == "Aluguel" ? "<div id=\"benefactorRental\" data-name="+item["k"]+">ALUGAR</div>":"<div id=\"benefactorBuy\" data-name="+item["k"]+">COMPRAR</div>"}
						<div id="benefactorDrive" data-name="${item["k"]}">TESTAR</div>
					</right>
				</span>`)).join('')}
			`);
		} else {
			$("#pageVehicles").html(`
				${nameList.map((item) => (`<span>
					<left>
						${item["name"]}<br>
						<b>Valor:</b> $${item["price"]}<br>
						<b>Veiculo:</b> ${item["veiculo"]}<br>
						<b>Taxa:</b> ${item["tax"]}
					</left>
					<right>
						<div id="benefactorSell" data-name="${item["k"]}">VENDER</div>
						<div id="benefactorTax" data-name="${item["k"]}">PAGAR</div>
					</right>
				</span>`)).join('')}
			`);
		}
	});
};
/* ----------BENEFACTOR---------- */
$(document).on("click","#benefactor",function(e){
	benefactor(e["target"]["dataset"]["id"]);
});
/* ----------BENEFACTORBUY---------- */
$(document).on("click","#benefactorBuy",function(e){
	$.post("http://tablet/requestBuy",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------BENEFACTORRENTAL---------- */
$(document).on("click","#benefactorRental",function(e){
	$.post("http://tablet/requestRental",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------BENEFACTORSELL---------- */
$(document).on("click","#benefactorSell",function(e){
	$.post("http://tablet/requestSell",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------BENEFACTORTAX---------- */
$(document).on("click","#benefactorTax",function(e){
	$.post("http://tablet/requestTax",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------BENEFACTORDRIVE---------- */
$(document).on("click","#benefactorDrive",function(e){
	$.post("http://tablet/requestDrive",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------FORMAT---------- */
const format = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}