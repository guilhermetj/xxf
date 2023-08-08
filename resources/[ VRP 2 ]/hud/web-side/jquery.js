var tickInterval = undefined;
var lastHealth = 999;
var lastArmour = 999;
var lastStress = 999;
var lastHunger = 999;
var lastOxigen = 999;
var lastWater = 999;

$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["progress"] == true){
			var timeSlamp = event["data"]["progressTimer"];

			if($("#progressBackground").css("display") === "block"){
				$("#progressDisplay").css("stroke-dashoffset","100");
				$("#progressBackground").css("display","none");
				clearInterval(tickInterval);
				tickInterval = undefined;

				return
			} else {
				$("#progressBackground").css("display","block");
				$("#progressDisplay").css("stroke-dashoffset","100");
			}

			var tickPerc = 100;
			var tickTimer = (timeSlamp / 100);
			tickInterval = setInterval(tickFrame,tickTimer);

			function tickFrame(){
				tickPerc--;

				if (tickPerc <= 0){
					clearInterval(tickInterval);
					tickInterval = undefined;
					$("#progressBackground").css("display","none");
				} else {
					timeSlamp = timeSlamp - (timeSlamp / tickPerc);
				}

				$("#textProgress").html(parseInt(timeSlamp / 1000));
				$("#progressDisplay").css("stroke-dashoffset",tickPerc);
			}

			return
		}

		if (event["data"]["hud"] !== undefined){
			if (event["data"]["hud"] == true){
				$("#displayHud").fadeIn(500);
				$(".huds").fadeIn(500);
			} else {
				$("#displayHud").fadeOut(500);
				$(".huds").fadeOut(500);
			}
			return
		}

		if (event["data"]["movie"] !== undefined){
			if (event["data"]["movie"] == true){
				$("#movieTop").fadeIn(500);
				$("#movieBottom").fadeIn(500);
			} else {
				$("#movieTop").fadeOut(500);
				$("#movieBottom").fadeOut(500);
			}

			return
		}

		if (event["data"]["hood"] !== undefined){
			if (event["data"]["hood"] == true){
				$("#hoodDisplay").fadeIn(500);
			} else {
				$("#hoodDisplay").fadeOut(500);
			}
		}

		if (event["data"]["talking"] == true){
			$("#voice").css("background","#333 url(images/micOn.png)");
		} else {
			$("#voice").css("background","#222 url(images/micOff.png)");

			if (event["data"]["voice"] == 1){
				$(".voiceDisplay").css("stroke-dashoffset","75");
			} else if (event["data"]["voice"] == 2){
				$(".voiceDisplay").css("stroke-dashoffset","50");
			} else if (event["data"]["voice"] == 3){
				$(".voiceDisplay").css("stroke-dashoffset","25");
			} else if (event["data"]["voice"] == 4){
				$(".voiceDisplay").css("stroke-dashoffset","0");
			}
		}

		if (lastHealth !== event["data"]["health"]){
			lastHealth = event["data"]["health"];

			if (event["data"]["health"] <= 1){
				$(".healthDisplay").css("stroke-dashoffset","100");
			} else {
				$(".healthDisplay").css("stroke-dashoffset",100 - event["data"]["health"]);
			}
		}

		if (lastArmour !== event["data"]["armour"]){
			lastArmour = event["data"]["armour"];

			if (event["data"]["armour"] <= 0){
				if($(".armourBackground").css("display") === "block"){
					$(".armourBackground").css("display","none");
				}
			} else {
				if($(".armourBackground").css("display") === "none"){
					$(".armourBackground").css("display","block");
				}
			}

			$(".armourDisplay").css("stroke-dashoffset",100 - event["data"]["armour"]);
		}

		if (lastStress !== event["data"]["stress"]){
			lastStress = event["data"]["stress"];

			if (event["data"]["stress"] <= 0){
				if($(".stressBackground").css("display") === "block"){
					$(".stressBackground").css("display","none");
				}
			} else {
				if($(".stressBackground").css("display") === "none"){
					$(".stressBackground").css("display","block");
				}
			}

			$(".stressDisplay").css("stroke-dashoffset",100 - event["data"]["stress"]);
		}

		if (lastWater !== event["data"]["thirst"]){
			lastWater = event["data"]["thirst"];

			$(".waterDisplay").css("stroke-dashoffset",100 - event["data"]["thirst"]);
		}

		if (lastHunger !== event["data"]["hunger"]){
			lastHunger = event["data"]["hunger"];

			$(".foodDisplay").css("stroke-dashoffset",100 - event["data"]["hunger"]);
		}

		if (lastOxigen !== event["data"]["oxigen"]){
			lastOxigen = event["data"]["oxigen"];

			if (event["data"]["oxigen"] == 10){
				if($(".oxigenBackground").css("display") === "block"){
					$(".oxigenBackground").css("display","none");
				}
			} else {
				if($(".oxigenBackground").css("display") === "none"){
					$(".oxigenBackground").css("display","block");
				}
			}

			if (event["data"]["oxigen"] <= 0)
				event["data"]["oxigen"] = 0;

			if (event["data"]["oxigen"] <= 10){
				$(".oxigenDisplay").css("stroke-dashoffset",100 - (event["data"]["oxigen"] * 10));
			} else {
				$(".oxigenDisplay").css("stroke-dashoffset",100 - (event["data"]["oxigen"] / 12));
			}
		}
		
		if (event.data.hours <= 9) {
			event.data.hours = "0" + event.data.hours
		}

		if (event.data.minutes <= 9) {
			event.data.minutes = "0" + event.data.minutes
		}
		
		if (event["data"]["vehicle"] !== undefined){
			if (event["data"]["vehicle"] == true){
				if($("#displayTop").css("display") === "none"){
					$("#displayTop").css("display","block");
				}

				if (event["data"]["showbelt"] == false){
					if($("#hardBelt").css("display") === "block"){
						$("#seatBelt").css("display","none");
					}
				} else {
					if($("#hardBelt").css("display") === "none"){
						$("#seatBelt").css("display","block");
					}

					if (event["data"]["hardness"] == 1){
						$("#hardBelt").html("<img src='images/beltOn.png'>");
					} else {
						$("#hardBelt").html("<img src='images/beltOff.png'>");
					}

					if (event["data"]["seatbelt"] == 1){
						$("#seatBelt").html("<img src='images/beltOn.png'>");
					} else {
						$("#seatBelt").html("<img src='images/beltOff.png'>");
					}
				}

				$("#gasoline").html("GAS <s>" + parseInt(event["data"]["fuel"]) + "</s>");
				$("#mph").html("MPH <s>" + parseInt(event["data"]["speed"]) + "</s>");

				$('.huds').fadeIn();
				setProgressSpeed(event.data.speed,'.progress-speed');
	
				setProgressFuel(event.data.fuel,'.progress-fuel');
				if(event.data.fuel <= 20){
					$('.progress-fuel').addClass('orangeStroke');
				}
				if(event.data.fuel <= 10){
					$('.progress-fuel').removeClass('orangeStroke');
					$('.progress-fuel').addClass('redStroke');
				}
			} else {
				if($("#displayTop").css("display") === "block"){
					$("#displayTop").css("display","none");
				}
				$('.huds').fadeOut();
			}
		}

		$("#displayMiddle").html("<text>" + event["data"]["radio"] + event["data"]["direction"] + "<s>:</s>" + event["data"]["street"] + "<s>:</s>" + event["data"]["hours"] + ":" + event["data"]["minutes"] + "</text>");
	});
});

function setProgressFuel(percent, element){

	var circle = document.querySelector(element);
	var radius = circle.r.baseVal.value;
	var circumference = radius * 2 * Math.PI;
	var html = $(element).parent().parent().find('span');

	circle.style.strokeDasharray = `${circumference} ${circumference}`;
	circle.style.strokeDashoffset = `${circumference}`;

	const offset = circumference - ((-percent*73)/100) / 100 * circumference;
	circle.style.strokeDashoffset = -offset;

	html.text(Math.round(percent));
}

function setProgressSpeed(value, element){

	var circle = document.querySelector(element);
	var radius = circle.r.baseVal.value;
	var circumference = radius * 2 * Math.PI;
	var html = $(element).parent().parent().find('span');
	var percent = value*100/220;

	circle.style.strokeDasharray = `${circumference} ${circumference}`;
	circle.style.strokeDashoffset = `${circumference}`;

	const offset = circumference - ((-percent*73)/100) / 100 * circumference;
	circle.style.strokeDashoffset = -offset;

	html.text(value);
}
