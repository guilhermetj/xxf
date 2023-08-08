
    item = null
    valorCarrinho = 0
    

    $('.itemroupa').click(function(){
        $('.'+item).fadeOut() //Remove o escolhido
        var itemEscolhido = $(this).data('item-title') // Pegar data do titulo do item clicado
        item = $(this).data('item') // Pegar data do item clicado
        if (item){
            $('.itemroupa').removeClass('acdicional') //Remove blur
            $(this).addClass('acdicional') // Add o blur
            $('.titleroupa').html(itemEscolhido) //Seta o titlo
            $('.inicio-criacaoroupa').fadeOut() //Tira a entrada
            setTimeout(() => {
                $('.'+item).fadeIn() //Aparece o escolhido
            }, 500);
            $.post('http://nh_loja/trocarClasse', JSON.stringify({ part: item }))

            $('#todas-as-roupasroupa').fadeIn()
        }
     
    })


    $(document).ready(function(){    
        window.addEventListener("message",function(event){
            var item = event.data
            if (event.data.action === "showMenu"){
                $('#preto-backroupa').fadeIn()
                $('.zoom-escolharoupa').fadeIn()
            }
            if (event.data.action === "hideMenu"){
                $('#preto-backroupa').fadeOut()
                $('.zoom-escolharoupa').fadeOut()
                $('.confirmacaoroupa').fadeOut()

            }
            if (item.changeCategory) {
                dataPart = item.category
                $('#todas-as-roupasroupa').html('')
                for (var i = 0; i <= item.drawa; i++) {
                    $("#todas-as-roupasroupa").append(`
                        <div class="item-clothe" data-roupa="${i}">
                            <div class="img-clothe" style="background-image: url('${item.url}/${item.category}/${item.sexo}/${item.prefix}(${i}).jpg')">  
                                <div class="overlay">
                                <span>${i}</span>
                                </div>
                            </div>
                        </div>
                    `);
                   
                };
                $('.item-clothe').click(function(){
                    roupa = $(this).data('roupa')
                    $.post('http://nh_loja/changeCustom', JSON.stringify({ type: dataPart, id: roupa }));
                })
            }
            if (item.value){
                valorCarrinho = item.value
                $('.carrinhodecompraroupa').html(`R$: ${valorCarrinho},00`)
            }
        })
        document.onkeyup = function(data){
            if (data.which == 27){
                $.post("http://nh_loja/roupasClose",JSON.stringify({}),function(datab){});
                $('.zoom-escolharoupa').fadeOut()
            }
        };
    })

 

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
        $.post('http://nh_loja/payament', JSON.stringify({ price: valorCarrinho }));
        $('.confirmacaoroupa').fadeOut()
    })

    $(".cor-roupa").click(function() {
        if ($(this).hasClass('maisroupa')){
            $.post('http://nh_loja/changeColor', JSON.stringify({ type: dataPart, id: roupa, action: "mais" }));
        }
        if ($(this).hasClass('menosroupa')){
            $.post('http://nh_loja/changeColor', JSON.stringify({ type: dataPart, id: roupa, action: "menos" }));
        }
    })

    function onRangeChange(tipo,value) { 
        $.post('https://nh_loja/updateRotate', JSON.stringify({
            tipo: tipo,
            valor: value
        }));
    }
    