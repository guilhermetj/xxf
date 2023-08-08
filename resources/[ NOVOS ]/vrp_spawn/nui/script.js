$(document).ready(function() {
    $(document).on("click", ".empty-slot", function() {
        $.post("http://vrp_spawn/CharacterCreated");
    });

    $(document).on("click", ".entrar-btn", function() {
        const characterId = $(this).attr("data-id");
        $.post("http://vrp_spawn/CharacterChosen", JSON.stringify({ id: characterId }));
    });

    $(document).on("click", ".deletar-btn", function() {
        const characterId = $(this).attr("data-id");
        $.post("http://vrp_spawn/DeleteCharacter", JSON.stringify({ id: characterId }));
        GetCharacters(); // Recarrega os personagens após a exclusão
    });

    window.addEventListener("message", function(event) {
        switch (event.data.action) {
            // Seu código de manipulação de mensagens aqui
			case "show":
				GetCharacters();
				$(".character").show(0);
			break;

			case "hide":
				$(".character").hide(500);
			break;
        }
    });
});
const GetCharacters = () => {
    $.post("http://vrp_spawn/GetCharacters", JSON.stringify({}), (data) => {
        const chars = data;

        $(".character").empty(); // Limpa o conteúdo atual antes de preencher

        // Preenche os slots com dados do backend, se disponíveis
        for (let i = 0; i < chars.length; i++) {
            $(".character").append(`
                <div class="character-slot">
                    <div class="info">
                        <div>${chars[i].name}</div>
                        <div>${chars[i].name2}</div>
                        <div>ID: ${chars[i].id}</div>
                    </div>
                    <div class="button-info">
                        <button class="entrar-btn" data-id="${chars[i].id}">Entrar</button>
                        <button class="deletar-btn" data-id="${chars[i].id}">Deletar</button>
                    </div>
                </div>
            `);
        }

        // Preenche os slots vazios restantes
        for (let i = chars.length; i < 4; i++) {
            $(".character").append(`
                <div class="character-slot empty-slot">
                    <img src="assets/mais.png" alt="Character ${i + 1}">
                </div>
            `);
        }
    });
}