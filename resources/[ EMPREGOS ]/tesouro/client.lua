local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("tesouro")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("tesouro",cRP)
vSERVER = Tunnel.getInterface("tesouro")
-----------------------------------------------------------------------------------------------------------------------------------------
--- VARIAVEL
-----------------------------------------------------------------------------------------------------------------------------------------
local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false
local nveh = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local procurar = {
	[1] = { ['x'] = -1604.61, ['y'] = 5994.69, ['z'] = -37.84 },
	[2] = { ['x'] = -1259.34, ['y'] = 5895.85, ['z'] = -27.32 },
	[3] = { ['x'] = -1178.66, ['y'] = 5758.52, ['z'] = -13.19 },
	[4] = { ['x'] = -1121.98, ['y'] = 6030.18, ['z'] = -6.23 },
	[5] = { ['x'] = -1533.73, ['y'] = 5624.68, ['z'] = -28.54 },
	[6] = { ['x'] = -2461.21, ['y'] = 4633.18, ['z'] = -46.34 },
	[7] = { ['x'] = -2674.85, ['y'] = 4432.83, ['z'] = -37.71 },
	[8] = { ['x'] = -2790.61, ['y'] = 4130.84, ['z'] = -32.6 },
	[9] = { ['x'] = -3360.37, ['y'] = 3254.71, ['z'] = -45.39 },
	[10] = { ['x'] = -2956.38, ['y'] = 2627.42, ['z'] = -25.15 },
	[11] = { ['x'] = -3146.69, ['y'] = 2144.21, ['z'] = -18.13 },
	[12] = { ['x'] = -3599.96, ['y'] = 3071.24, ['z'] = -163.71 },
	[13] = { ['x'] = -3372.95, ['y'] = 2000.89, ['z'] = -49.82 },
	[14] = { ['x'] = -3348.53, ['y'] = 1962.04, ['z'] = -44.6 },
	[15] = { ['x'] = -1216.76, ['y'] = 6182.4, ['z'] = -10.94 },
	[16] = { ['x'] = -859.45, ['y'] = 6584.66, ['z'] = -31.26 },
	[17] = { ['x'] = -879.72, ['y'] = 6628.38, ['z'] = -34.01 },
	[18] = { ['x'] = 527.52, ['y'] = 7171.91, ['z'] = -13.41 },
	[19] = { ['x'] = 593.87, ['y'] = 7164.03, ['z'] = -39.77 },
	[20] = { ['x'] = 1784.46, ['y'] = 7046.37, ['z'] = -89.59 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.toggleService()
	if servico then
		servico = false
		emP.thread222(servico)
		if DoesBlipExist(blips) then
			RemoveBlip(blips)
			collectBlip = nil
			TriggerEvent("Notify","verde","Você saiu do emprego de <b>Mergulhador</b>.",3000)
		end
	else
		tesouro()
		TriggerEvent("Notify","verde","Você iniciou o emprego de <b>Mergulhador</b> vá até o final do pier pegue seu barco e vai até local marcado no mapa.",5000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGAR TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
function tesouro()
	local x,y,z = -1586.51,5199.35,3.99
	local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
	local ped = PlayerPedId()
	if distance < 5 then
		if not servico then
			if distance < 1 then
				parte = 1
				servico = true
				locais = 1
				CriandoBlip(procurar,locais)
				emP.thread222(servico)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.thread222(servico222)
	if servico222 then
		Citizen.CreateThread(function()
			while true do
				local gustasleep = 500
				if servico and parte == 1 then
					local ped = PlayerPedId()
					local x,y,z = table.unpack(GetEntityCoords(ped))
					local bowz,cdz = GetGroundZFor_3dCoord(procurar[locais].x,procurar[locais].y,procurar[locais].z)
					local distance = GetDistanceBetweenCoords(procurar[locais].x,procurar[locais].y,cdz,x,y,z,true)
						if distance < 5 then
							gustasleep = 5
							DrawText3Ds(x,y,z + 1.2,"~w~PRESSIONE ~g~E ~w~PARA PROCURAR TESOURO")
							DrawMarker(20,x,y,z-1.0,0,0,0,0,0.0,130.0,0.6,0.8,0.50,0, 129, 254,100,0,0,0,1)
							if IsControlJustPressed(0, 38) then
								RemoveBlip(blips)
								animacao = true
								if animacao then
									vRP._playAnim(false,{"amb@world_human_gardener_plant@female@idle_a","idle_a_female"},true)							Desabilitar()
									Citizen.Wait(10000)
									vRP.stopAnim(false)
									emP.checkPayment()
									animacao = false
									if locais == #procurar then
										locais = 1
									else
										locais = math.random(1,19)
									end
									CriandoBlip(procurar,locais)
							end
						end
					end
				end
			Citizen.Wait(gustasleep)
			end
		end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(procurar,locais)
	blips = AddBlipForCoord(procurar[locais].x,procurar[locais].y,procurar[locais].z)
	SetBlipSprite(blips,181)
	SetBlipColour(blips,30)
	SetBlipScale(blips,0.8)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Tesouro")
	EndTextCommandSetBlipName(blips)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function Desabilitar()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if animacao then
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,57,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,170,true)				
				DisableControlAction(0,182,true)	
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,344,true)		
			end	
		end
	end)
end