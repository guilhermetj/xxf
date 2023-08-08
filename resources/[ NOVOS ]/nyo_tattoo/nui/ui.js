let tattooShop = null
let applyTattoo = null
let atualPart = 'head'


$(document).ready(function() {
    document.onkeydown = function(data) {
        if (data.keyCode == 27) {
            $("#container").fadeOut();
            $.post('http://nyo_tattoo/reset', JSON.stringify({}));
        }
    }

    window.addEventListener('message', function(event) {

        let item = event.data;
        if (item.openNui) {
            tattooShop = item.shop;
            applyTattoo = item.tattoo;
            $("#container").fadeIn();
            $('#totalDireita').html(0);
            $('#listagem').html('')

            if (tattooShop[atualPart]){
                if (tattooShop[atualPart].active){
                    for (var i = 0; i <= (tattooShop[atualPart].tattoo.length - 1); i++) {
                        let partName = tattooShop[atualPart].tattoo[i].name; 
                        let dlcName = tattooShop[atualPart].tattoo[i].part; 
                        let customname = tattooShop[atualPart].tattoo[i].cname;
                        let price = tattooShop[atualPart].tattoo[i].price;
                            $("#listagem").append(`
                                <div class="lista" data-partname="${partName}" data-partid="${i}" data-parttype="${atualPart}" onclick="select(this)" id="${atualPart}${i}" style="background-image: url('http://189.127.164.139/nyotattos/${atualPart}/${dlcName}/${partName}.jpg'); background-size: 160px 160px;">
                                    <div class="valorItem">R$${price} </div>
                                    <div class="idItem">${i} ${customname}</div>
                                </div>
                            `);

                        if(applyTattoo[partName]){
                            select2(i);
                        }
                    }
                }                
            }
        }

        if (item.atualizaPrice) {
            $('#totalDireita').html(item.price) 
        }  
    });
});

function updateLoja(atualPart) {
    $('#listagem').html('')
    if (tattooShop[atualPart]){
        if (tattooShop[atualPart].active){
            for (var i = 0; i <= (tattooShop[atualPart].tattoo.length - 1); i++) {
                let partName = tattooShop[atualPart].tattoo[i].name; 
                let dlcName = tattooShop[atualPart].tattoo[i].part; 
                let customname = tattooShop[atualPart].tattoo[i].cname;
                let price = tattooShop[atualPart].tattoo[i].price;
                    $("#listagem").append(`
                        <div class="lista" data-partname="${partName}" data-partid="${i}" data-parttype="${atualPart}" onclick="select(this)" id="${atualPart}${i}" style="background-image: url('http://192.168.1.3/nyotattos/${atualPart}/${dlcName}/${partName}.jpg'); background-size: 160px 160px;">
                            <div class="valorItem">R$${price} </div>
                            <div class="idItem">${i} ${customname}</div>
                        </div>
                    `);

                    if(applyTattoo[partName]){
                        select2(i);
                    }
            }
        }       
    }
}


function update_valor() {
    const formatter = new Intl.NumberFormat('pt-BR', { minimumFractionDigits: 2 })
    let total = 0
    for (let key in change) { if (!change[key] == 0) { total += 40 } }
    $('#totalDireita').html(formatter.format(total))
}


function selectPart(element) {
    if (element.dataset.idpart == 'reset'){
        applyTattoo = [];
        updateLoja(atualPart);
        $.post('http://nyo_tattoo/limpaTattoo');    
    }else{
        atualPart = element.dataset.idpart
        let dataPart = element.dataset.title
        $('header h1').html(dataPart)
        $('.submenu-item').find('img').css('filter', 'brightness(100%)')
        $('.submenu-item').removeClass('subActive')
        $(element).addClass('subActive')
        updateLoja(atualPart)
    }
    
}

function select(element) {
    partId = element.dataset.partid;
    partName = element.dataset.partname;
    partType = element.dataset.parttype;

    if(applyTattoo[partName]){
        applyTattoo[partName] = null;
    }else{
        applyTattoo[partName] = true;
    }
    
    if($(element).hasClass('activeLista')){
        $(element).removeClass('activeLista');
    }else{
        $(element).addClass('activeLista'); 
    }

    $.post('http://nyo_tattoo/changeTattoo', JSON.stringify({ type: partName, id: partId, type: partType }));    
}

function select2(id) {
    if($(`#${atualPart}${id}`).hasClass('activeLista')){
        $(`#${atualPart}${id}`).removeClass('activeLista');
    }else{
        $(`#${atualPart}${id}`).addClass('activeLista'); 
    }
}



$("#esquerda").click(function() {
    $.post('http://nyo_tattoo/leftHeading', JSON.stringify({ value: 10 }));
})

$("#direita").click(function() {
    $.post('http://nyo_tattoo/rightHeading', JSON.stringify({ value: 10 }));
})

$("#erguermaos").click(function() {
    $.post('http://nyo_tattoo/handsUp', JSON.stringify({}));
})



$("#cart").click(function() {
    $("#container").fadeOut()
    $.post('http://nyo_tattoo/payament', JSON.stringify({ price: $('#totalDireita').text() }));
    $('#totalDireita').html('0');
    applyTattoo = null;
    tattooShop = null
}) 
