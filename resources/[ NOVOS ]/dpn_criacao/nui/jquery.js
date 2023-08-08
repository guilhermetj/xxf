genero = null
aberto = false
item = null
item2 = null
corDePele = null
corDoOlho = null
corDaSobrancelha = null
corDoCaebloPrimaria = null
secundariaCabelo = null
cordobigode = null
cordopelo = null
cordobatom = null
nomepersonagem = null
sobrenomepersonagem = null
idadepersonagem = null
abreviacao = null
cordoblush = null
corDoPelo = null
roupa = null

$(".dad").click(function(){
    genero = "male"
    $('.selecionado-dad').fadeIn()
    $('.selecionado-mom').fadeOut() /*Aparecer a bolinha*/
    $('.mom').css('background-color','rgba(0, 0, 0, 0.411)')
    $('.dad').css('background-color','rgba(255, 255, 255, 0.377)')
    $('.mom').css('background-image','url("imagem/girl.svg")')
    $('.dad').css('background-image','url("imagem/homemwhite.svg")')
    $('.mom').css('box-shadow','')
    $('.mom').css('border','')
    $('.dad').css('box-shadow','0px 0px 6px -1px #FFFFFF')
    $('.dad').css('border','solid 0.1px #FFFFFF')

})

$(".mom").click(function(){
    genero = "female"
    $('.selecionado-mom').fadeIn()
    $('.selecionado-dad').fadeOut() /*Aparecer a bolinha*/
    $('.dad').css('background-color','rgba(0, 0, 0, 0.411)')
    $('.mom').css('background-color','rgba(255, 255, 255, 0.377)')
    $('.mom').css('background-image','url("imagem/girlwhite.svg")')
    $('.dad').css('background-image','url("imagem/homem.svg")')
    $('.dad').css('box-shadow','')
    $('.mom').css('box-shadow','0px 0px 6px -1px #FFFFFF')    
    $('.dad').css('border','')
    $('.mom').css('border','solid 0.1px #FFFFFF')

})

$('.seta-passar img').click(function(){
    var nome = document.getElementById('nome').value
    var sobrenome = document.getElementById('sobrenome').value
    var idade = document.getElementById('idade').value
    if (nome === "" || sobrenome === "" || idade === "" || genero === null){
        $('.entrada').css('animation','1s shakeX infinite')
       
        setTimeout(() => {
            $('.entrada').css('animation','')
        }, 1000);  
    }else if(Number(idade) <= 80 && Number(idade) >= 21 ){
        $('.entrada').css('top','-34vw')
        nomepersonagem = nome
        sobrenomepersonagem = sobrenome
        idadepersonagem = idade
        if (genero === "male"){
            abreviacao = "o"
        }else if (genero === "female"){
            abreviacao = "a"
        }
        $.post("http://dpn_criacao/updateFirstInformation", JSON.stringify({
            nome: nomepersonagem,
            sobrenome: sobrenomepersonagem,
            idade: idadepersonagem,
            genero: genero
        }))
        setTimeout(() => {
            $('#preto-back').fadeIn()
            $('.title').html(`Bem-vind${abreviacao} à Criação`)
            var HairId = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 
                10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
                20, 21, 22, 24, 25, 26, 27, 28, 29, 
                30, 31, 32, 33, 34, 35, 36, 72, 73];
            $('#caixa-preset').html(`
                <div class="transorm-preset">
                    <div class="title-preset">Mais Frequentes</div>
                    <div class="box-preset">
                        <div class="preset" data-number="1">
                            <div class="nome-preset">1</div>
                            <div class="imagem"><img src="imagem/${genero}1.png"></div>
                        </div>
                        <div class="preset" data-number="2">
                            <div class="nome-preset">2</div>
                            <div class="imagem"><img src="imagem/${genero}2.png"></div>
                        </div>
                        <div class="preset" data-number="3">
                            <div class="nome-preset">3</div>
                            <div class="imagem"><img src="imagem/${genero}3.png"></div>
                        </div>
                        <div class="preset" data-number="4">
                            <div class="nome-preset">4</div>
                            <div class="imagem"><img src="imagem/${genero}4.png"></div>
                        </div>
                    </div>
                </div>
                <div class="volta"><img src="imagem/right-arrow.png" style="transform: rotate(180deg);"></div>
            `)

            $('.volta').click(function(){
                $('.clickPreset').css('transform','scale(1)')
                $('#caixa-preset').fadeOut()
                $('#caixa-preset').css('left','-17vw')
            })
        
            $('.voltar').click(function(){
                if ($(this).hasClass('parainicial')){
                    $('#preto-back').fadeOut()
                    $.post("http://dpn_criacao/voltarCriacao", JSON.stringify({}))
                    setTimeout(() => {
                        $('.background-black').fadeIn()
                        $('.entrada').css('top','14.2vw')
                    }, 2000);
                }else if ($(this).hasClass('paracaracterisitacas')){
                    $('#preto-backroupa').fadeOut()
                    $('.zoom-escolharoupa').fadeOut()
                    setTimeout(() => {
                        $('#preto-back').fadeIn()
                    }, 500);

                }

            })

            $('.preset').click(function(){
                $('.preset').removeClass("active");
                $(this).addClass("active");
                var preset = $(this).data('number')
                $.post("http://dpn_criacao/setPreset", JSON.stringify({
                    preset: preset,
                    genero: genero
                }))

            })

            $('.box-cabelo').html('')
            for (var i in HairId) {
                $('.box-cabelo').append(`
                    <div class="cabelo-do-ped" data-item-cabelo="${HairId[i]}" style="background-image:url('cabelos/${genero}hair${HairId[i]}.png')"></div>
                `)
            }
            
  

            $('.cabelo-do-ped').click(function(){
                $('.cabelo-do-ped').html('')
                var cabeloEscolhido = $(this).data('item-cabelo')
                $(this).empty().append('<div class="check"><img src="imagem/check-white.png"></div>')
                $.post('https://dpn_criacao/updateHair', JSON.stringify({
                    cabelo: cabeloEscolhido
                }));
            })

            updatePortrait('mom');
            updatePortrait('dad');
          
        }, 5000);
  
    
    }else if(Number(idade) > 80 || Number(idade) < 21 ){
        $('.entrada').css('animation','1s shakeX infinite')
        setTimeout(() => {
            $('.entrada').css('animation','')
        }, 1000);  
    }
})



$('.btn').click(function(){
    if ($(".btn span").text() === "Escolher sua roupa"){
        $('#preto-back').fadeOut()
        setTimeout(() => {
            $('#preto-backroupa').fadeIn()
            $('.zoom-escolharoupa').fadeIn()
            
        }, 500);

    }
})

$('.btnroupa').click(function(){

    $('.sub-title-confiramtionroupa').html(`
        Você criará ${abreviacao} personagem<br><b>${nomepersonagem} ${sobrenomepersonagem}</b>, de <b>${idadepersonagem} anos</b>.
    `)
    $('.confirmacaoroupa').fadeIn()
    $('#preto-backroupa').css('opacity','0.6')
})

$('.rejeiar').click(function(){
    $('.confirmacao').fadeOut()
    $('#preto-backroupa').css('opacity','1')
})

$('.rejeiarroupa').click(function(){
    $('.confirmacaoroupa').fadeOut()
    $('#preto-backroupa').css('opacity','1')
})

$('.aceitarroupa').click(function(){
    $.post("http://dpn_criacao/terminarCriacao");
    $('.confirmacaoroupa').fadeOut()
    $('#preto-back').fadeOut()
    $('#preto-backroupa').fadeOut ()
    $('.zoom-escolharoupa').fadeOut()
    $('.todas-as-informacoes').css('opacity','1')
})

$('.clickPreset').hover(function(){
    $('.clickPreset img').css('animation','shakeX2 1.5s infinite')
}, function(){
    $('.clickPreset img').css('animation','')
});

$(document).on('click', '.arrow', function(evt) {
    let list = $(this).siblings('select').first();
    let numOpt = list.children('option').length
    let oldVal = list.find('option:selected');
    let newVal = null;

    if ($(this).hasClass('left')) {
        if (list.prop('selectedIndex') == 0) {
            newVal = list.prop('selectedIndex', numOpt - 1);

        }
        else {
            newVal = oldVal.prev();
        }
    }
    else if ($(this).hasClass('right')) {
        if (list.prop('selectedIndex') == numOpt - 1) {
            newVal = list.prop('selectedIndex', 0);
        }
        else {
            newVal = oldVal.next();
        }
    }

 
    oldVal.prop('selected', false)
    newVal.prop('selected', true)
    newVal.trigger('change')
   
});

$(document).on('change', 'select.headblend', function(evt) {
    updatePortrait($(this).attr('id'));
    updateHeadBlend($(this).attr('id'), $(this).val());
});

function updateHeadBlend(key, value) {
    if (key === "mom"){
        key = "mothersID"
    }else if (key === "dad"){
        key = "fathersID"
    }
    $.post('https://dpn_criacao/updateParents', JSON.stringify({
        key: key,
        value: value,
    }));
}

function updatePortrait(elemId) {
    let portraitImgId = '#parents' + elemId;
    let portraitName = $('select#' + elemId + '.headblend').find(':selected').data('portrait');
    $(portraitImgId).attr('src', 'https://nui-img/char_creator_portraits/' + portraitName);
}

$(".trocarValor").click(function(){

    if ($(this).hasClass('aumenta') && $(this).hasClass('genetica')) {
        var atualValor = document.getElementById('genetica').value
        document.getElementById('genetica').value = Number(atualValor) + 0.05
        onRangeChange("shapeMix",Number(atualValor) +  0.05)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('genetica')) {
        var atualValor = document.getElementById('genetica').value
        document.getElementById('genetica').value = Number(atualValor) - 0.05 // shapeMix
        onRangeChange("shapeMix",Number(atualValor) -  0.05)
    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('sobrancelha')) {
        var atualValor = document.getElementById('sobrancelha').value
        document.getElementById('sobrancelha').value = Number(atualValor) + 1
        onRangeChange("eyebrowsModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('sobrancelha')) {
        var atualValor = document.getElementById('sobrancelha').value
        document.getElementById('sobrancelha').value = Number(atualValor) - 1 // eyebrowsModel
        onRangeChange("eyebrowsModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('formatoSobrancelha')) {
        var atualValor = document.getElementById('formatoSobrancelha').value
        document.getElementById('formatoSobrancelha').value = Number(atualValor) + 0.01
        onRangeChange("eyebrowsHeight",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('formatoSobrancelha')) {
        var atualValor = document.getElementById('formatoSobrancelha').value
        document.getElementById('formatoSobrancelha').value = Number(atualValor) - 0.01 // eyebrowsHeight
        onRangeChange("eyebrowsHeight",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('formatoTesta')) {
        var atualValor = document.getElementById('formatoTesta').value
        document.getElementById('formatoTesta').value = Number(atualValor) + 0.01
        onRangeChange("eyebrowsWidth",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('formatoTesta')) {
        var atualValor = document.getElementById('formatoTesta').value
        document.getElementById('formatoTesta').value = Number(atualValor) - 0.01 // eyebrowsWidth
        onRangeChange("eyebrowsWidth",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('larguraDoNariz')) {
        var atualValor = document.getElementById('larguraDoNariz').value
        document.getElementById('larguraDoNariz').value = Number(atualValor) + 0.01
        onRangeChange("noseWidth",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('larguraDoNariz')) {
        var atualValor = document.getElementById('larguraDoNariz').value
        document.getElementById('larguraDoNariz').value = Number(atualValor) - 0.01 // noseWidth
        onRangeChange("noseWidth",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('alturaDoNariz')) {
        var atualValor = document.getElementById('alturaDoNariz').value
        document.getElementById('alturaDoNariz').value = Number(atualValor) + 0.01
        onRangeChange("noseHeight",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('alturaDoNariz')) {
        var atualValor = document.getElementById('alturaDoNariz').value
        document.getElementById('alturaDoNariz').value = Number(atualValor) - 0.01  // noseHeight
        onRangeChange("noseHeight",Number(atualValor) -  0.01)

    }
    
    if ($(this).hasClass('aumenta') && $(this).hasClass('comprimentoDoNariz')) {
        var atualValor = document.getElementById('comprimentoDoNariz').value
        document.getElementById('comprimentoDoNariz').value = Number(atualValor) + 0.01
        onRangeChange("noseLength",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('comprimentoDoNariz')) {
        var atualValor = document.getElementById('comprimentoDoNariz').value
        document.getElementById('comprimentoDoNariz').value = Number(atualValor) - 0.01 // noseLength
        onRangeChange("noseLength",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('ponteNasal')) {
        var atualValor = document.getElementById('ponteNasal').value
        document.getElementById('ponteNasal').value = Number(atualValor) + 0.01
        onRangeChange("noseBridge",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('ponteNasal')) {
        var atualValor = document.getElementById('ponteNasal').value
        document.getElementById('ponteNasal').value = Number(atualValor) - 0.01 // noseBridge
        onRangeChange("noseBridge",Number(atualValor) -  0.01)

    }
    
    if ($(this).hasClass('aumenta') && $(this).hasClass('pontaDoNariz')) {
        var atualValor = document.getElementById('pontaDoNariz').value
        document.getElementById('pontaDoNariz').value = Number(atualValor) + 0.01
        onRangeChange("noseTip",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('pontaDoNariz')) {
        var atualValor = document.getElementById('pontaDoNariz').value
        document.getElementById('pontaDoNariz').value = Number(atualValor) - 0.01 // noseTip
        onRangeChange("noseTip",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('comprimentoDoQueixo')) {
        var atualValor = document.getElementById('comprimentoDoQueixo').value
        document.getElementById('comprimentoDoQueixo').value = Number(atualValor) + 0.01
        onRangeChange("chinLength",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('comprimentoDoQueixo')) {
        var atualValor = document.getElementById('comprimentoDoQueixo').value
        document.getElementById('comprimentoDoQueixo').value = Number(atualValor) - 0.01 // chinLength
        onRangeChange("chinLength",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('larguraDoQueixo')) {
        var atualValor = document.getElementById('larguraDoQueixo').value
        document.getElementById('larguraDoQueixo').value = Number(atualValor) + 0.01
        onRangeChange("chinWidth",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('larguraDoQueixo')) {
        var atualValor = document.getElementById('larguraDoQueixo').value
        document.getElementById('larguraDoQueixo').value = Number(atualValor) - 0.01 // chinWidth
        onRangeChange("chinWidth",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('posicaoDoQueixo')) {
        var atualValor = document.getElementById('posicaoDoQueixo').value
        document.getElementById('posicaoDoQueixo').value = Number(atualValor) + 0.01
        onRangeChange("chinPosition",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('posicaoDoQueixo')) {
        var atualValor = document.getElementById('posicaoDoQueixo').value
        document.getElementById('posicaoDoQueixo').value = Number(atualValor) - 0.01 // chinPosition
        onRangeChange("chinPosition",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('alturaDoQueixo')) {
        var atualValor = document.getElementById('alturaDoQueixo').value
        document.getElementById('alturaDoQueixo').value = Number(atualValor) + 0.01
        onRangeChange("chinShape",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('alturaDoQueixo')) {
        var atualValor = document.getElementById('alturaDoQueixo').value
        document.getElementById('alturaDoQueixo').value = Number(atualValor) - 0.01 // chinShape
        onRangeChange("chinShape",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('larguraDosLabios')) {
        var atualValor = document.getElementById('larguraDosLabios').value
        document.getElementById('larguraDosLabios').value = Number(atualValor) + 0.01
        onRangeChange("lips",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('larguraDosLabios')) {
        var atualValor = document.getElementById('larguraDosLabios').value
        document.getElementById('larguraDosLabios').value = Number(atualValor) - 0.01 // lips
        onRangeChange("lips",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('alturaDaBochecha')) {
        var atualValor = document.getElementById('alturaDaBochecha').value
        document.getElementById('alturaDaBochecha').value = Number(atualValor) + 0.01
        onRangeChange("alturaDaBochecha",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('alturaDaBochecha')) {
        var atualValor = document.getElementById('alturaDaBochecha').value
        document.getElementById('alturaDaBochecha').value = Number(atualValor) - 0.01 // cheekboneHeight
        onRangeChange("alturaDaBochecha",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('larguraDaBochecha')) {
        var atualValor = document.getElementById('larguraDaBochecha').value
        document.getElementById('larguraDaBochecha').value = Number(atualValor) + 0.01
        onRangeChange("cheekboneWidth",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('larguraDaBochecha')) {
        var atualValor = document.getElementById('larguraDaBochecha').value
        document.getElementById('larguraDaBochecha').value = Number(atualValor) - 0.01 // cheekboneWidth
        onRangeChange("cheekboneWidth",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('larguraMandibula')) {
        var atualValor = document.getElementById('larguraMandibula').value
        document.getElementById('larguraMandibula').value = Number(atualValor) + 0.01
        onRangeChange("jawHeight",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('larguraMandibula')) {
        var atualValor = document.getElementById('larguraMandibula').value
        document.getElementById('larguraMandibula').value = Number(atualValor) - 0.01 // jawHeight
        onRangeChange("jawHeight",Number(atualValor) -  0.01)

    }
    
    if ($(this).hasClass('aumenta') && $(this).hasClass('alturaDoPescoco')) {
        var atualValor = document.getElementById('alturaDoPescoco').value
        document.getElementById('alturaDoPescoco').value = Number(atualValor) + 0.01
        onRangeChange("neckWidth",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('alturaDoPescoco')) {
        var atualValor = document.getElementById('alturaDoPescoco').value
        document.getElementById('alturaDoPescoco').value = Number(atualValor) - 0.01 // neckWidth
        onRangeChange("neckWidth",Number(atualValor) -  0.01)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('alutraDaMandibula')) {
        var atualValor = document.getElementById('alutraDaMandibula').value
        document.getElementById('alutraDaMandibula').value = Number(atualValor) + 0.01
        onRangeChange("jawHeight",Number(atualValor) +  0.01)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('alutraDaMandibula')) {
        var atualValor = document.getElementById('alutraDaMandibula').value
        document.getElementById('alutraDaMandibula').value = Number(atualValor) - 0.01 // jawHeight
        onRangeChange("jawHeight",Number(atualValor) -  0.01)

    }


    if ($(this).hasClass('aumenta') && $(this).hasClass('Batom')) {
        var atualValor = document.getElementById('Batom').value
        document.getElementById('Batom').value = Number(atualValor) + 1
        onRangeChange("lipstickModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('Batom')) {
        var atualValor = document.getElementById('Batom').value
        document.getElementById('Batom').value = Number(atualValor) - 1 // lipstickModel
        onRangeChange("lipstickModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('maquiagem')) {
        var atualValor = document.getElementById('maquiagem').value
        document.getElementById('maquiagem').value = Number(atualValor) + 1
        onRangeChange("makeupModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('maquiagem')) {
        var atualValor = document.getElementById('maquiagem').value
        document.getElementById('maquiagem').value = Number(atualValor) - 1 // makeupModel
        onRangeChange("makeupModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('blush')) {
        var atualValor = document.getElementById('blush').value
        document.getElementById('blush').value = Number(atualValor) + 1
        onRangeChange("blushModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('blush')) {
        var atualValor = document.getElementById('blush').value
        document.getElementById('blush').value = Number(atualValor) - 1 // blushModel
        onRangeChange("blushModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('bigodeTipo')) {
        var atualValor = document.getElementById('bigodeTipo').value
        document.getElementById('bigodeTipo').value = Number(atualValor) + 1
        onRangeChange("beardModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('bigodeTipo')) {
        var atualValor = document.getElementById('bigodeTipo').value
        document.getElementById('bigodeTipo').value = Number(atualValor) - 1 // beardModel
        onRangeChange("beardModel",Number(atualValor) -  1)

    }
    
    if ($(this).hasClass('aumenta') && $(this).hasClass('peloCorporal')) {
        var atualValor = document.getElementById('peloCorporal').value
        document.getElementById('peloCorporal').value = Number(atualValor) + 1
        onRangeChange("chestModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('peloCorporal')) {
        var atualValor = document.getElementById('peloCorporal').value
        document.getElementById('peloCorporal').value = Number(atualValor) - 1 // chestModel
        onRangeChange("chestModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('danossolares')) {
        var atualValor = document.getElementById('danossolares').value
        document.getElementById('danossolares').value = Number(atualValor) + 1
        onRangeChange("sundamageModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('danossolares')) {
        var atualValor = document.getElementById('danossolares').value
        document.getElementById('danossolares').value = Number(atualValor) - 1 // sundamageModel
        onRangeChange("sundamageModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('envelhecimento')) {
        var atualValor = document.getElementById('envelhecimento').value
        document.getElementById('envelhecimento').value = Number(atualValor) + 1
        onRangeChange("ageingModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('envelhecimento')) {
        var atualValor = document.getElementById('envelhecimento').value
        document.getElementById('envelhecimento').value = Number(atualValor) - 1 // ageingModel
        onRangeChange("ageingModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('manchas')) {
        var atualValor = document.getElementById('manchas').value
        document.getElementById('manchas').value = Number(atualValor) + 1
        onRangeChange("blemishesModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('manchas')) {
        var atualValor = document.getElementById('manchas').value
        document.getElementById('manchas').value = Number(atualValor) - 1 // blemishesModel
        onRangeChange("blemishesModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('sardas')) {
        var atualValor = document.getElementById('sardas').value
        document.getElementById('sardas').value = Number(atualValor) + 1
        onRangeChange("blemishesModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('sardas')) {
        var atualValor = document.getElementById('sardas').value
        document.getElementById('sardas').value = Number(atualValor) - 1 // blemishesModel
        onRangeChange("blemishesModel",Number(atualValor) -  1)

    }

    if ($(this).hasClass('aumenta') && $(this).hasClass('rugas')) {
        var atualValor = document.getElementById('rugas').value
        document.getElementById('rugas').value = Number(atualValor) + 1
        onRangeChange("frecklesModel",Number(atualValor) +  1)
    }else if ($(this).hasClass('diminui') && $(this).hasClass('rugas')) {
        var atualValor = document.getElementById('rugas').value
        document.getElementById('rugas').value = Number(atualValor) - 1 // frecklesModel
        onRangeChange("frecklesModel",Number(atualValor) -  1)

    }

})


$('.clickPreset').click(function(){
    $('.clickPreset').css('transform','scale(0)')
    $('#caixa-preset').fadeIn()
    $('#caixa-preset').css('left','4vw')
})


$('.item').click(function(){
    $('.box-color').fadeOut()
    $('.box-color2').fadeOut()
    $('.buttons').fadeIn()
    $('.confirm-color').fadeOut()

    
    $('.'+item).fadeOut() //Remove o escolhido
    var itemEscolhido = $(this).data('item-title') // Pegar data do titulo do item clicado
    item = $(this).data('item') // Pegar data do item clicado
    if (item){
        $('.item').removeClass('acdicional') //Remove blur
        $(this).addClass('acdicional') // Add o blur
        $('.title').html(itemEscolhido) //Seta o titlo
        $('.inicio-criacao').fadeOut() //Tira a entrada
        setTimeout(() => {
            $('.'+item).fadeIn() //Aparece o escolhido
        }, 500);
    }
})






$('.corDaPele').click(function(){
        $('.color-frequentes').html('')
        $('.color-more').html('')
        var List = ["#E7B78E", "#442F1E", "#C79C77", "#C7BA77", "#9B7554", "#C7A777"];     
        var Value = 0;   
        for (var i in List){
            if (i < 5){
                $('.color-frequentes').append(`
                <div class="cor genetica" data-cor="${List[i]}" data-coresolhida="${Value}" style="background-color: ${List[i]}"></div>
            `)
            }else{
                $('.color-more').append(`
                <div class="cor genetica" data-cor="${List[i]}" data-coresolhida="${Value}" style="background-color: ${List[i]}"></div>
            `)
            }
            Value += 2;
        }    
       
        $('.box-color').fadeIn()
        updateColorPele()
        $('.buttons').fadeOut()
})

const updateColorPele = () => {
    $('.cor').click(function(){
        if ($(this).hasClass('genetica')){
            $('.corDaPeleEscolhida').css('background-color',$(this).data('cor'))
            $('.box-color').fadeOut()
            $('.buttons').fadeIn()
            corDePele = $(this).data('coresolhida')
            $.post('https://dpn_criacao/updateColor', JSON.stringify({
                tipo: "skinColor",
                valor: corDePele
            }));
        }
    })
}



$('.corDosOlhos').click(function(){
    $('.color-frequentes').html('')
    $('.color-more').html('')
    var List = ["#449244", "#204420", "#9ED8F3", "#5184BE", "#2E6D48", "#5E310C", "#A76F10", "#A5A5A5", "#C7C7C7", "#F299BC",
    "#C09841", "#78288C", "#181818", "#6C6C6C", "#E69102", "#DECC20", "#8C8C8C", "#C51E1E", "#E09118", "#C7C7C7", "#D3412F",
    "#77D32F", "#EE4433", "#7088A2", "#A2A270", "#F1F116", "#000000", "#EA0808", "#305B83", "#232323", "#D6D6D6", "#F7F7F7"];
    var Value = 0
    for (var i in List){
        if (i < 5){
            $('.color-frequentes').append(`
            <div class="cor olho" data-cor="${List[i]}" data-coresolhida="${Value}" style="background-color: ${List[i]}"></div>
        `)
        }else{
            $('.color-more').append(`
            <div class="cor olho" data-cor="${List[i]}" data-coresolhida="${Value}" style="background-color: ${List[i]}"></div>
        `)
        }
        Value += 1;
    }    
   
    $('.box-color').fadeIn()
    $('.box-color2').fadeOut()
    updateEyeColor()
    $('.buttons').fadeOut()
})

const updateEyeColor = () => {
$('.cor').click(function(){
    if ($(this).hasClass('olho')){
        $('.corDosOlhosEscolhida').css('background-color',$(this).data('cor'))
        $('.box-color').fadeOut()
        $('.buttons').fadeIn()
        corDoOlho = $(this).data('coresolhida')
        $.post('https://dpn_criacao/updateColor', JSON.stringify({
            tipo: "eyesColor",
            valor: corDoOlho
        }));
    }
})
}

$('.corDaSombrancelha').click(function(){
$('.color-frequentes2').html('')
$('.color-more2').html('')
var List = ["#1C1F21", "#272A2C", "#312E2C", "#35261C", "#4B321F", "#5C3B24", "#6D4C35", "#6B503B", "#765C45", "#7F684E",
"#99815D", "#A79369", "#AF9C70", "#BBA063", "#D6B97B", "#DAC38E", "#9F7F59", "#845039", "#682B1F", "#61120C", "#640F0A",
"#7C140F", "#A02E19", "#B64B28", "#A2502F", "#AA4E2B", "#626262", "#808080", "#AAAAAA", "#C5C5C5", "#463955", "#5A3F6B",
"#763C76", "#ED74E3", "#EB4B93", "#F299BC", "#04959E", "#025F86", "#023974", "#3FA16A", "#217C61", "#185C55", "#B6C034",
"#70A90B", "#439D13", "#DCB857", "#E5B103", "#E69102", "#F28831", "#FB8057", "#E28B58", "#D1593C", "#CE3120", "#AD0903",
"#880302", "#1F1814", "#291F19", "#2E221B", "#37291E", "#2E2218", "#231B15", "#020202", "#706C66", "#9D7A50"];
for (var i in List){
    if (i < 5){

        $('.color-frequentes2').append(`
        <div class="cor sobrancelha" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }else{

        $('.color-more2').append(`
        <div class="cor sobrancelha" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }
}    

$('.box-color2').fadeIn()
$('.box-color').fadeOut()
updateSobrancelhaColor()
$('.buttons').fadeOut()
})

const updateSobrancelhaColor = () => {
$('.cor').click(function(){
    if ($(this).hasClass('sobrancelha')){
        $('.corDaSombrancelhaEscolhida').css('background-color',$(this).data('cor'))
        $('.box-color2').fadeOut()
        $('.buttons').fadeIn()
        corDaSobrancelha = $(this).data('coresolhida')
        $.post('https://dpn_criacao/updateColor', JSON.stringify({
            tipo: "eyebrowsColor",
            valor: corDaSobrancelha
        }));
    }
})
}

$(document).ready(function() {
document.onkeyup = function(data){
    if (data.which == 27){
        $.post("http://dpn_criacao/personClose");
    }
};
$(".exclamacao").hover(
    function() {
      $('.exclamacao-menu').show()
      $('.exclamacao').css('opacity','1')
    }, function() {
        $('.exclamacao-menu').hide()
        $('.exclamacao').css('opacity','0.5')
    }
  );

$('.botaoZinjo').click(function(){
    if ($(this).hasClass('confirmarReset')){
        $.post('https://dpn_criacao/resetPerson', JSON.stringify({
            id: Number($("#user_id").val())
        }));
    }else if ($(this).hasClass('fecharReset')){
        $.post("http://dpn_criacao/personClose");
    }
})
window.addEventListener('message', function(event) {
    if (event.data.action === "primeiroLogin"){
        $('.background-black').fadeIn()
    }
    if (event.data.action === "resetPerson"){
        $('#menureset').fadeIn()
    }
    if (event.data.action === "clostPerson"){
        $('#menureset').fadeOut()
    }
    if (event.data.action === "passou"){
        $('.background-black').fadeOut()
        
        $('.corDoBatom').click(function(){
            var colorBatom = event.data.lipstick
            $('.color-frequentes').html('')
            $('.color-more').html('')
            $('.color-frequentes2').html('')
            $('.color-more2').html('')

            for (const color of colorBatom) {
                if (color.index < 5){
                    $('.color-frequentes').append(`
                    <div class="cor batom" data-cor="${color.hex}" data-coresolhida="${color.index}" style="background-color: ${color.hex}"></div>
                `)
                }else{

                    $('.color-more').append(`
                    <div class="cor batom" data-cor="${color.hex}" data-coresolhida="${color.index}" style="background-color: ${color.hex}"></div>
                `)
                }
            }    
            $('.box-color').fadeIn()
            $('.box-color2').fadeOut()
            updateColorBatom()
            $('.buttons').fadeOut()
        })
        $('.corDoBlush').click(function(){
            var colorBlush = event.data.blusher
            $('.color-frequentes').html('')
            $('.color-more').html('')
            $('.color-frequentes2').html('')
            $('.color-more2').html('')

            for (const colorBlushzin of colorBlush) {
                if (colorBlushzin.index < 5){
                    $('.color-frequentes2').append(`
                        <div class="cor blush" data-cor="${colorBlushzin.hex}" data-coresolhida="${colorBlushzin.index}" style="background-color: ${colorBlushzin.hex}"></div>
                    `)
                }else{
                    $('.color-more2').append(`
                        <div class="cor blush" data-cor="${colorBlushzin.hex}" data-coresolhida="${colorBlushzin.index}" style="background-color: ${colorBlushzin.hex}"></div>
                    `)
                }
            }    
            $('.box-color').fadeOut()
            $('.box-color2').fadeIn()
            updateColorBlush()
            $('.buttons').fadeOut()
        })
    
}



const updateColorBatom = () => {
    $('.cor').click(function(){
        if ($(this).hasClass('batom')){
            $('.corDoBatomEscolhida').css('background-color',$(this).data('cor'))
            cordobatom = $(this).data('coresolhida')
            $.post('https://dpn_criacao/updateColor', JSON.stringify({
                tipo: "lipstickColor",
                valor: cordobatom
            }));
            $('.box-color').fadeOut()
            $('.confirm-color').fadeOut()
            $('.buttons').fadeIn()
        }
    })
}

const updateColorBlush = () => {
    $('.cor').click(function(){
        if ($(this).hasClass('blush')){
            $('.corDoBlushEscolhido').css('background-color',$(this).data('cor'))
            cordoblush = $(this).data('coresolhida')
            $.post('https://dpn_criacao/updateColor', JSON.stringify({
                tipo: "blushColor",
                valor: cordoblush
            }));
            $('.box-color').fadeOut()
            $('.box-color2').fadeOut()
            $('.confirm-color').fadeOut()
            $('.buttons').fadeIn()
        }
    })
}

var item2 = event.data
if (item2.changeCategory) {
    dataPart = item2.category
    $('#todas-as-roupasroupa').html('')
    for (var i = 0; i <= item2.drawa; i++) {
        $("#todas-as-roupasroupa").append(`
            <div class="item-clothe" data-roupa="${i}">
                <div class="img-clothe" style="background-image: url('${item2.url}/${item2.category}/${item2.sexo}/${item2.prefix}(${i}).jpg')">  
                    <div class="overlay">
                    <span>${i}</span>
                    </div>
                </div>
            </div>
        `);
       
    };
    $('.item-clothe').click(function(){
        roupa = $(this).data('roupa')
        $.post('http://dpn_criacao/changeCustom', JSON.stringify({ type: dataPart, id: roupa }));
    })
    $(".cor-roupa").click(function() {
        if ($(this).hasClass('maisroupa')){
            $.post('http://dpn_criacao/changeColor', JSON.stringify({ type: dataPart, id: roupa, action: "mais" }));
        }
        if ($(this).hasClass('menosroupa')){
            $.post('http://dpn_criacao/changeColor', JSON.stringify({ type: dataPart, id: roupa, action: "menos" }));
        }
    })
    
}


})



})








$('.corDoCabeloPriamria').click(function(){
var List = ["#1C1F21", "#272A2C", "#312E2C", "#35261C", "#4B321F", "#5C3B24", "#6D4C35", "#6B503B", "#765C45", "#7F684E",
"#99815D", "#A79369", "#AF9C70", "#BBA063", "#D6B97B", "#DAC38E", "#9F7F59", "#845039", "#682B1F", "#61120C", "#640F0A",
"#7C140F", "#A02E19", "#B64B28", "#A2502F", "#AA4E2B", "#626262", "#808080", "#AAAAAA", "#C5C5C5", "#463955", "#5A3F6B",
"#763C76", "#ED74E3", "#EB4B93", "#F299BC", "#04959E", "#025F86", "#023974", "#3FA16A", "#217C61", "#185C55", "#B6C034",
"#70A90B", "#439D13", "#DCB857", "#E5B103", "#E69102", "#F28831", "#FB8057", "#E28B58", "#D1593C", "#CE3120", "#AD0903",
"#880302", "#1F1814", "#291F19", "#2E221B", "#37291E", "#2E2218", "#231B15", "#020202", "#706C66", "#9D7A50"];
$('.color-frequentes').html('')
$('.color-more').html('')
$('.color-frequentes2').html('')
$('.color-more2').html('')

for (var i in List){
    if (i < 5){

        $('.color-frequentes').append(`
        <div class="cor primariaCabelo" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }else{

        $('.color-more').append(`
        <div class="cor primariaCabelo" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }
}    
$('.box-color').fadeIn()
$('.box-color2').fadeOut()
$('.confirm-color').fadeIn()
$('.confirm-color2').fadeOut()
updateHairColorPrimary()
$('.buttons').fadeOut()
})

const updateHairColorPrimary = () => {
$('.cor').click(function(){
if ($(this).hasClass('primariaCabelo')){
    $('.corDoCabeloEscolhidoPrimaria').css('background-color',$(this).data('cor'))
    corDoCaebloPrimaria = $(this).data('coresolhida')
    $.post('https://dpn_criacao/updateColor', JSON.stringify({
        tipo: "firstHairColor",
        valor: corDoCaebloPrimaria
    }));
}
})
}

$('.corCabeloSecundaria').click(function(){
var List = ["#1C1F21", "#272A2C", "#312E2C", "#35261C", "#4B321F", "#5C3B24", "#6D4C35", "#6B503B", "#765C45", "#7F684E",
"#99815D", "#A79369", "#AF9C70", "#BBA063", "#D6B97B", "#DAC38E", "#9F7F59", "#845039", "#682B1F", "#61120C", "#640F0A",
"#7C140F", "#A02E19", "#B64B28", "#A2502F", "#AA4E2B", "#626262", "#808080", "#AAAAAA", "#C5C5C5", "#463955", "#5A3F6B",
"#763C76", "#ED74E3", "#EB4B93", "#F299BC", "#04959E", "#025F86", "#023974", "#3FA16A", "#217C61", "#185C55", "#B6C034",
"#70A90B", "#439D13", "#DCB857", "#E5B103", "#E69102", "#F28831", "#FB8057", "#E28B58", "#D1593C", "#CE3120", "#AD0903",
"#880302", "#1F1814", "#291F19", "#2E221B", "#37291E", "#2E2218", "#231B15", "#020202", "#706C66", "#9D7A50"];
$('.color-frequentes2').html('')
$('.color-more2').html('')
$('.color-frequentes').html('')
$('.color-more').html('')

for (var i in List){
    if (i < 5){

        $('.color-frequentes2').append(`
        <div class="cor secundariaCabelo" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }else{

        $('.color-more2').append(`
        <div class="cor secundariaCabelo" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }
}    
$('.box-color').fadeOut()
$('.box-color2').fadeIn()
$('.confirm-color').fadeOut()
$('.confirm-color2').fadeIn()
updateHairColorSecundary()
$('.buttons').fadeOut()
})

const updateHairColorSecundary = () => {
$('.cor').click(function(){
if ($(this).hasClass('secundariaCabelo')){
    $('.corSecundariaCabeloEscolhida').css('background-color',$(this).data('cor'))
    secundariaCabelo = $(this).data('coresolhida')
    $.post('https://dpn_criacao/updateColor', JSON.stringify({
        tipo: "secondHairColor",
        valor: secundariaCabelo
    }));
}
})
}

$('.caraio').click(function(){
$('.box-color').fadeOut()
$('.box-color2').fadeOut()
$('.confirm-color').fadeOut()
$('.confirm-color2').fadeOut()
$('.buttons').fadeIn()
})


$('.corDoBigode').click(function(){
var List = ["#1C1F21", "#272A2C", "#312E2C", "#35261C", "#4B321F", "#5C3B24", "#6D4C35", "#6B503B", "#765C45", "#7F684E",
"#99815D", "#A79369", "#AF9C70", "#BBA063", "#D6B97B", "#DAC38E", "#9F7F59", "#845039", "#682B1F", "#61120C", "#640F0A",
"#7C140F", "#A02E19", "#B64B28", "#A2502F", "#AA4E2B", "#626262", "#808080", "#AAAAAA", "#C5C5C5", "#463955", "#5A3F6B",
"#763C76", "#ED74E3", "#EB4B93", "#F299BC", "#04959E", "#025F86", "#023974", "#3FA16A", "#217C61", "#185C55", "#B6C034",
"#70A90B", "#439D13", "#DCB857", "#E5B103", "#E69102", "#F28831", "#FB8057", "#E28B58", "#D1593C", "#CE3120", "#AD0903",
"#880302", "#1F1814", "#291F19", "#2E221B", "#37291E", "#2E2218", "#231B15", "#020202", "#706C66", "#9D7A50"];
$('.color-frequentes').html('')
$('.color-more').html('')

for (var i in List){
    if (i < 5){

        $('.color-frequentes').append(`
        <div class="cor cordobigode" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }else{

        $('.color-more').append(`
        <div class="cor cordobigode" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }
}    
$('.box-color').fadeIn()
$('.confirm-color').fadeIn()
updateColorBigode()
$('.buttons').fadeOut()
})

const updateColorBigode = () => {
$('.cor').click(function(){
    if ($(this).hasClass('cordobigode')){
        $('.corDoBigodeEscolhido').css('background-color',$(this).data('cor'))
        cordobigode = $(this).data('coresolhida')
        $.post('https://dpn_criacao/updateColor', JSON.stringify({
            tipo: "beardColor",
            valor: cordobigode
        }));
        $('.box-color').fadeOut()
        $('.confirm-color').fadeOut()
        $('.buttons').fadeIn()
    }
})
}


$('.itemroupa').click(function(){
$('.'+item2).fadeOut() //Remove o escolhido
var item2Escolhido = $(this).data('item-title') // Pegar data do titulo do item clicado
item2 = $(this).data('item') // Pegar data do item clicado
if (item2){
    $('.itemroupa').removeClass('acdicional') //Remove blur
    $(this).addClass('acdicional') // Add o blur
    $('.titleroupa').html(item2Escolhido) //Seta o titlo
    $('.inicio-criacaoroupa').fadeOut() //Tira a entrada
    setTimeout(() => {
        $('.'+item2).fadeIn() //Aparece o escolhido
    }, 500);
    $.post('http://dpn_criacao/trocarClasse', JSON.stringify({ part: item2 }))

    $('#todas-as-roupasroupa').fadeIn()
}

})

$('.corDoPelo').click(function(){
var List = ["#1C1F21", "#272A2C", "#312E2C", "#35261C", "#4B321F", "#5C3B24", "#6D4C35", "#6B503B", "#765C45", "#7F684E",
"#99815D", "#A79369", "#AF9C70", "#BBA063", "#D6B97B", "#DAC38E", "#9F7F59", "#845039", "#682B1F", "#61120C", "#640F0A",
"#7C140F", "#A02E19", "#B64B28", "#A2502F", "#AA4E2B", "#626262", "#808080", "#AAAAAA", "#C5C5C5", "#463955", "#5A3F6B",
"#763C76", "#ED74E3", "#EB4B93", "#F299BC", "#04959E", "#025F86", "#023974", "#3FA16A", "#217C61", "#185C55", "#B6C034",
"#70A90B", "#439D13", "#DCB857", "#E5B103", "#E69102", "#F28831", "#FB8057", "#E28B58", "#D1593C", "#CE3120", "#AD0903",
"#880302", "#1F1814", "#291F19", "#2E221B", "#37291E", "#2E2218", "#231B15", "#020202", "#706C66", "#9D7A50"];
$('.color-frequentes').html('')
$('.color-more').html('')

for (var i in List){
    if (i < 5){

        $('.color-frequentes').append(`
        <div class="cor cordopelo" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }else{

        $('.color-more').append(`
        <div class="cor cordopelo" data-cor="${List[i]}" data-coresolhida="${i}" style="background-color: ${List[i]}"></div>
    `)
    }
}    
$('.box-color').fadeIn()
updateColorPelo()
$('.buttons').fadeOut()
})

const updateColorPelo = () => {
$('.cor').click(function(){
if ($(this).hasClass('cordopelo')){
    $('.corDoPeloEscolhido').css('background-color',$(this).data('cor'))
    corDoPelo = $(this).data('coresolhida')
    $.post('https://dpn_criacao/updateColor', JSON.stringify({
        tipo: "chestColor",
        valor: corDoPelo
    }));
    $('.box-color').fadeOut()
    $('.confirm-color').fadeOut()
    $('.buttons').fadeIn()
}
})
}

const allRanges = document.querySelectorAll(".input-zoom");
allRanges.forEach(wrap => {
const range = wrap.querySelector("#rotate");
const bubble = wrap.querySelector(".bubble");
range.addEventListener("input", () => {
setBubble(range, bubble);
});
setBubble(range, bubble);
});

function setBubble(range, bubble) {
const val = range.value;
const min = range.min ? range.min : 0;
const max = range.max ? range.max : 100;
const newVal = Number(((val - min) * 100) / (max - min));
bubble.innerHTML = val;

// Sorta magic numbers based on size of the native UI thumb

bubble.style.left = `calc(${newVal}% + (${0.4 - newVal * 0.01}vw))`;
}


function onRangeChange(tipo,value) { 
if (tipo === "rotacao"){
    $('.bubble').fadeIn()
    $.post('https://dpn_criacao/udpateInputCam', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}
if (tipo === "zoom"){
    $.post('https://dpn_criacao/udpateInputCam', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}
if (tipo === "shapeMix"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}
if (tipo === "eyebrowsModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}
if (tipo === "eyebrowsHeight"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}
if (tipo === "eyebrowsWidth"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}
if (tipo === "noseWidth"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "noseHeight"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "noseLength"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "noseBridge"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "noseTip"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "chinLength"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "chinWidth"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "chinShape"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "chinPosition"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "lips"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}


if (tipo === "cheekboneHeight"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "cheekboneWidth"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}


if (tipo === "jawWidth"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

    
if (tipo === "jawHeight"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}


if (tipo === "neckWidth"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "beardModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "lipstickModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "cheekboneWidth"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "makeupModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "blushModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "chestModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "sundamageModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "ageingModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "blemishesModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "frecklesModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}

if (tipo === "complexionModel"){
    $.post('https://dpn_criacao/updateInputs', JSON.stringify({
        tipo: tipo,
        valor: value
    }));
}




}

function showVal(tipo,value){
    $('.bubble').fadeOut()
}





















//Inicio roupa

function rotateInput(value) { 
$.post('https://dpn_criacao/updateRotate', JSON.stringify({
    valor: value
}));
}

$('.btnroupa').click(function(){
$('.sub-title-confiramtionroupa').html(`
    Você pagará R$: ${valorCarrinho},00 pelas roupas<br>
    Deseja aceitar?
`)
$('.confirmacaoroupa').fadeIn()
})

$('.rejeiarroupa').click(function(){
$('.confirmacaoroupa').fadeOut()

})

$('.aceitarroupa').click(function(){
$.post('http://dpn_criacao/payament', JSON.stringify({ price: valorCarrinho }));
$('.confirmacaoroupa').fadeOut()
})

