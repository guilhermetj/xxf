$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showMenu":
				updateChest();
				$(".inventory").css("display","flex");
			break;

			case "hideMenu":
				$(".inventory").css("display","none");
				$(".ui-tooltip").hide();
			break;

			case "updateChest":
				updateChest();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_chest/chestClose");
		}
	};
});

const updateDrag = () => {
	$('.populated').draggable({
		helper: 'clone'
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			const origin = ui.draggable.parent()[0].id;
			if (origin === undefined) return;

			const tInv = $(this).parent()[0].id;

			if ( tInv === "invleft" ) {
				if (origin === "invleft"){
					itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
					const target = $(this).data('slot');

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://vrp_chest/populateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				} else if (origin === "invright"){
					itemData = { key: ui.draggable.data('item-key') };
					const target = $(this).data('slot');

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://vrp_chest/takeItem",JSON.stringify({
						item: itemData.key,
						slot: target,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				}
			} else if ( tInv === "invright" ) {
				if ( origin === "invleft" ) {
					itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };

					if (itemData.key === undefined) return;

					$.post("http://vrp_chest/storeItem",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				}
			}
		}
	});

	$('.populated').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			const origin = ui.draggable.parent()[0].id;
			if (origin === undefined) return;

			const tInv = $(this).parent()[0].id;

			if ( tInv === "invleft" ) {
				if (origin === "invleft"){
					itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
					const target = $(this).data('slot');

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://vrp_chest/updateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				} else if (origin === "invright"){
					itemData = { key: ui.draggable.data('item-key') };
					const target = $(this).data('slot');

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://vrp_chest/sumSlot",JSON.stringify({
						item: itemData.key,
						slot: target,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				}
			} else if ( tInv === "invright" ) {
				if ( origin === "invleft" ) {
					itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };

					if (itemData.key === undefined) return;

					$.post("http://vrp_chest/storeItem",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				}
			}
		}
	});

	$(".populated").tooltip({
		create: function(event,ui){
			var economy = $(this).attr("data-economy");
			var desc = $(this).attr("data-description");
			var amounts = $(this).attr("data-amount");
			var name = $(this).attr("data-name-key");
			var weight = $(this).attr("data-peso");
			var type = $(this).attr("data-type");
			var max = $(this).attr("data-max");
			var myLeg = "center top-196";

			if (desc !== "undefined"){
				myLeg = "center top-219";
			}

			$(this).tooltip({
				content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>Tipo: <r>${type}</r> <s>|</s> Quantidade: <r>${max !== "undefined" ? max:"S/L"}</r><br>Peso: <r>${(weight * amounts).toFixed(2)}</r> <s>|</s> Economia: <r>${economy !== "S/V" ? "$"+formatarNumero(economy):economy}</r></legenda>`,
				position: { my: myLeg, at: "center" },
				show: { duration: 10 },
				hide: { duration: 10 }
			})
		}
	});
}

const updateChest = () => {
	const inSlots = 70;

	$.post("http://vrp_chest/requestChest",JSON.stringify({}),(data) => {
		$("#weightTextLeft").html(`${(data["peso"]).toFixed(2)}   /   ${(data["maxpeso"]).toFixed(2)}`);
		$("#weightTextRight").html(`${(data["peso2"]).toFixed(2)}   /   ${(data["maxpeso2"]).toFixed(2)}`);

		$("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["peso"] / data["maxpeso"] * 100}%"></div>`);
		$("#weightBarRight").html(`<div id="weightContent" style="width: ${data["peso2"] / data["maxpeso2"] * 100}%"></div>`);

		const nameList2 = data.inventario2.sort((a,b) => (a.name > b.name) ? 1: -1);

		$("#invleft").html("");
		$("#invright").html("");

		for (let x = 1; x <= data["maxpeso"]; x++){
			const slot = x.toString();

			if (data.inventario[slot] !== undefined) {
				const v = data.inventario[slot];
				const item = `<div class="item populated" title="" data-max="${formatarNumero(v["amount"])}" data-type="${v["type"]}" style="background-image: url('http://192.168.1.3/itens/${v["index"]}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-id="${v["id"]}" data-amount="${v["amount"]}" data-peso="${v["peso"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}">
					<div class="top">
						<div class="itemWeight"></div>
						<div class="itemAmount">${formatarNumero(v.amount)}x   |   ${(v.peso * v.amount).toFixed(2)}</div>
					</div>

					<div class="nameItem">${v.name}</div>
				</div>`;

				document.getElementById("invleft").innerHTML = `${document.getElementById("invleft").innerHTML} ${item}`;
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				document.getElementById("invleft").innerHTML = `${document.getElementById("invleft").innerHTML} ${item}`;
			}
		}

		for (let x=1; x <= inSlots; x++) {
			const slot = x.toString();

			if (nameList2[x-1] !== undefined) {
				const v = nameList2[x-1];

				const item = `<div class="item populated" title="" data-max="${formatarNumero(v["amount"])}" data-type="${v["type"]}" style="background-image: url('http://192.168.1.3/itens/${v["index"]}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-id="${v["id"]}" data-amount="${v["amount"]}" data-peso="${v["peso"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}">
					<div class="top">
						<div class="itemWeight"></div>
						<div class="itemAmount">${formatarNumero(v.amount)}x   |   ${(v.peso * v.amount).toFixed(2)}</div>
					</div>

					<div class="nameItem">${v.name}</div>
				</div>`;

				document.getElementById("invright").innerHTML = `${document.getElementById("invright").innerHTML} ${item}`;
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				document.getElementById("invright").innerHTML = `${document.getElementById("invright").innerHTML} ${item}`;
			}
		}
		updateDrag();
	});
}
const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}
function somenteNumeros(e){
	var charCode = e.charCode ? e.charCode : e.keyCode;
	if (charCode != 8 && charCode != 9){
		var max = 9;
		var num = $(".amount").val();

		if ((charCode < 48 || charCode > 57)||(num.length >= max)){
			return false;
		}
	}
}