var selectCraft = "selectCraft";

$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch (event.data.action){
			case "showNUI":
				selectCraft = event.data.name;
				$(".inventory").css("display","flex");
				requestCrafting();
			break;

			case "hideNUI":
				$(".inventory").css("display","none");
				$(".ui-tooltip").hide();
			break;

			case "requestCrafting":
				requestCrafting();
			break;
		}
	});

	document.onkeyup = (data) => {
		if (data["key"] === "Escape"){
			$.post("http://vrp_crafting/close");
		}
	};
});

const updateDrag = () => {
	$('.populated').draggable({
		helper: 'clone'
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',	
		drop: function (event, ui) {
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;

			const tInv = $(this).parent()[0].className;
			if (tInv === "invLeft") {

				if (origin === "invLeft") {
					itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
					const target = $(this).data('slot');

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://vrp_crafting/populateSlot", JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				} else if (origin === "invRight") {
					itemData = { key: ui.draggable.data('item-key') };
					const target = $(this).data('slot');

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://vrp_crafting/functionCraft", JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: target,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				}
			} else if (tInv === "invRight") {
				if (origin === "invLeft") {
					itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') }

					if (itemData.key === undefined) return;

					$.post("http://vrp_crafting/functionDestroy", JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: itemData.slot,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				}
			}
		}
	});

	$(".populated").droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			const origin = ui.draggable.parent()[0].id;
			if (origin === undefined) return;

			const tInv = $(this).parent()[0].id;

			if (tInv === "invLeft") {
				if (origin === "invLeft") {
					itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
					const target = $(this).data('slot');

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://vrp_crafting/updateSlot", JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				} else if (origin === "invRight") {
					itemData = { key: ui.draggable.data('item-key') };
					const target = $(this).data('slot');

					if (itemData.key === undefined || target === undefined || itemData.key !== $(this).data('item-key')) return;

					$.post("http://vrp_crafting/functionCraft", JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: target,
						amount: parseInt($(".amount").val())
					}))

					$('.amount').val("")
				}
			} else if (tInv === "invRight") {
				if (origin === "invLeft") {
					itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') }

					if (itemData.key === undefined) return;

					$.post("http://vrp_crafting/functionDestroy", JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
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
			const desc = $(this).attr("data-description");
			const name = $(this).attr("data-name-key");
			const recipe = $(this).attr("data-list");
			var myLeg = "center top-176";

			if (desc !== "undefined"){
				myLeg = "center top-196";
			}

			$(this).tooltip({
				content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${recipe}</legenda>`,
				position: { my: myLeg, at: "center" },
				show: { duration: 10 },
				hide: { duration: 10 }
			})
		}
	});
}

const requestCrafting = () => {
	const inSlots = 40;
	const mySlots = 50;

	$.post("http://vrp_crafting/requestCrafting",JSON.stringify({ craft: selectCraft }),(data) => {
		$("#weightTextLeft").html(`${(data["weight"]).toFixed(2)}   /   ${(data["maxweight"]).toFixed(2)}`);
		$("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["weight"] / data["maxweight"] * 100}%"></div>`);
		
		$(".invLeft").html("");
		$(".invRight").html("");

		const nameList2 = data.inventoryCraft.sort((a,b) => a.name > b.name ? 1 : -1);

		for (let x = 1; x <= mySlots; x++){
            const slot = x.toString();

			if (data.inventoryUser[slot] !== undefined){
				const v = data.inventoryUser[slot];
				const item = `<div class="item populated" style="background-image: url('http://192.168.1.3/itens/${v.index}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
					<div class="top">
						<div class="itemWeight">${(v.peso * v.amount).toFixed(2)}</div>
						<div class="itemAmount">${formatarNumero(v.amount)}x</div>
					</div>

					<div class="nameItem">${v.name}</div>
				</div>`;

				$(".invLeft").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invLeft").append(item);
			}
		}

		for (let x=1; x <= inSlots; x++){
			const slot = x.toString();

			if (nameList2[x-1] !== undefined){
				const v = nameList2[x-1];
				let list = "";

				for (let i in v.list){
					list = `${list} ${v.list[i].amount}x ${v.list[i].name},`
				}

				list = list.substring(0,list.length - 1);

				const item = `<div class="item populated" title="" style="background-image: url('http://192.168.1.3/itens/${v.index}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-list="${list}" data-slot="${slot}" data-description="${v["desc"]}">
					<div class="top">
						<div class="itemWeight">${(v.weight).toFixed(2)}</div>
						<div class="itemAmount">1x</div>
					</div>

					

					<div class="nameItem">${v.name}</div>
				</div>`;

				$(".invRight").append(item);
			} else {
				const item = `<div class="item2 empty" data-slot="${slot}"></div>`;

				$(".invRight").append(item);
			}
		}
		updateDrag();
	});
}

const formatarNumero = (n) => {
	var n = n.toString();
	var r = "";
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? "." : "");
		x = x == 2 ? 0 : x + 1;
	}

	return r.split("").reverse().join("");
};