local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("garimpeiro")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local service = false
local selecionado = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGADOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("minerar",function(source,args,rawCommand)
	local source = source
	if not service then
		service = true
		emP.thread(service)
		TriggerEvent("Notify","amarelo","Serviço iniciado, vai até a garagem e retire o caminhão .",2000)
	else
		service = false
		emP.thread(service)
		TriggerEvent("Notify","amarelo","Serviço finalizado .",1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAMPO DE GARIMPO
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] =  { ['x'] = 2957.50, ['y'] = 2772.77, ['z'] = 40.31},
	[2] =  { ['x'] = 2952.85, ['y'] = 2767.68, ['z'] = 40.02},
	[3] =  { ['x'] = 2959.44, ['y'] = 2758.78, ['z'] = 42.58},
	[4] =  { ['x'] = 2937.51, ['y'] = 2771.71, ['z'] = 39.94},
	[5] =  { ['x'] = 2934.29, ['y'] = 2784.17, ['z'] = 40.07},
	[6] =  { ['x'] = 2928.28, ['y'] = 2789.04, ['z'] = 40.61},
	[7] =  { ['x'] = 2938.37, ['y'] = 2812.76, ['z'] = 43.45},
	[8] =  { ['x'] = 2948.19, ['y'] = 2820.86, ['z'] = 43.59},
	[9] =  { ['x'] = 2959.29, ['y'] = 2819.96, ['z'] = 43.73},
	[10] = { ['x'] = 2977.05, ['y'] = 2792.46, ['z'] = 41.43},
	[11] = { ['x'] = 2972.36, ['y'] = 2774.40, ['z'] = 39.39},
	[12] = { ['x'] = 2980.84, ['y'] = 2764.18, ['z'] = 43.21},
	[13] = { ['x'] = 2974.21, ['y'] = 2745.81, ['z'] = 43.81},
	[14] = { ['x'] = 2954.20, ['y'] = 2754.06, ['z'] = 43.96},
	[15] = { ['x'] = 2937.41, ['y'] = 2757.16, ['z'] = 44.67},
	[16] = { ['x'] = 2937.30, ['y'] = 2771.72, ['z'] = 39.93},
	[17] = { ['x'] = 2988.45, ['y'] = 2753.75, ['z'] = 43.52},
	[18] = { ['x'] = 2991.07, ['y'] = 2776.31, ['z'] = 43.78},
	[19] = { ['x'] = 2959.03, ['y'] = 2819.88, ['z'] = 43.69},
	[20] = { ['x'] = 2955.84, ['y'] = 2820.11, ['z'] = 43.20},
	[21] = { ['x'] = 2976.26, ['y'] = 2794.99, ['z'] = 41.56},
	[22] = { ['x'] = 2981.18, ['y'] = 2781.88, ['z'] = 40.19},
	[23] = { ['x'] = 2950.88, ['y'] = 2816.21, ['z'] = 42.79},
	[24] = { ['x'] = 2991.35, ['y'] = 2776.90, ['z'] = 43.70},
	[25] = { ['x'] = 2983.30, ['y'] = 2763.51, ['z'] = 43.67},
	[26] = { ['x'] = 2981.15, ['y'] = 2764.17, ['z'] = 43.22},
	[27] = { ['x'] = 2947.28, ['y'] = 2754.56, ['z'] = 43.97},
	[28] = { ['x'] = 2943.32, ['y'] = 2756.14, ['z'] = 43.64},
	[29] = { ['x'] = 2942.56, ['y'] = 2760.2, ['z'] = 42.79},  
	[30] = { ['x'] = 2939.04, ['y'] = 2768.87, ['z'] = 39.73},
	[31] = { ['x'] = 2938.41, ['y'] = 2774.27, ['z'] = 39.77},
	[32] = { ['x'] = 2934.51, ['y'] = 2784.03, ['z'] = 40.10},
	[33] = { ['x'] = 2928.21, ['y'] = 2790.61, ['z'] = 40.83},
	[34] = { ['x'] = 2925.80, ['y'] = 2796.17, ['z'] = 41.46},
	[35] = { ['x'] = 2936.73, ['y'] = 2814.07, ['z'] = 44.00},
	[36] = { ['x'] = 2944.02, ['y'] = 2818.37, ['z'] = 43.52},
	[37] = { ['x'] = 2944.65, ['y'] = 2820.05, ['z'] = 43.54}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETANDO
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.thread(service)
	if service then
		Citizen.CreateThread(function()
			while true do
				local iddle = 1000
				if service then
					local ped = PlayerPedId()
					local vehicle = GetPlayersLastVehicle()
					local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z,GetEntityCoords(ped),true)

					if distance <= 100.0 then
						iddle = 1
						DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.3,0,0,0,0,180.0,130.0,0.6,0.8,0.5,255,0,0,150,1,0,0,1)
						if distance <= 1.2 and IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) and emP.checkWeigth() then
							TriggerEvent("cancelado",true)
							SetEntityCoords(ped,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-1)
							vRP.createObjects("amb@world_human_const_drill@male@drill@base","base","prop_tool_jackham",15,28422)
							SetTimeout(10000,function()
								vRP.removeObjects()
								--vRP._DeletarObjeto()
								vRP._stopAnim(false)
								TriggerEvent("cancelando",false)
								backentrega = selecionado
								while true do
									if backentrega == selecionado then
										selecionado = math.random(16)
									else
										break
									end
									Citizen.Wait(10)
								end
								emP.checkPayment()
							end)
						end
					end
				end
				Citizen.Wait(iddle)
			end
		end)
	else 
		return
	end
end