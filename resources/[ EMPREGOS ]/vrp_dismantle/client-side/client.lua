-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("vrp_dismantle",cnVRP)
vSERVER = Tunnel.getInterface("vrp_dismantle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local inService = false
local timeDismantle = 0
local disX,disY,disZ = 464.87,-1313.98,29.24           
--local listX,listY,listZ = -240.5,-1318.48,18.48,202.26
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
--[[ function startthreaddesmanche() ]]
	Citizen.CreateThread(function()
		while true do
			local timeDistance = 500
			--[[ if inService then ]]
				local ped = PlayerPedId()
				if not IsPedInAnyVehicle(ped) then
					local coords = GetEntityCoords(ped)
					local distance = #(coords - vector3(disX,disY,disZ))
					if distance <= 7 then
						timeDistance = 4
						dwText("~g~~w~",0.93)
						if IsControlJustPressed(1,38) and timeDismantle <= 0 then
							if vSERVER.hasPermission() then
								timeDismantle = 3
								local status,vehicle,vehPrice = vSERVER.checkVehlist()
								--[[ vSERVER.paymentMethod(vehicle,vehPrice) ]]
								if vehicle then
									if status then
										TaskTurnPedToFaceEntity(ped,vehicle,1000)
										Citizen.Wait(2000)
										SetEntityInvincible(ped,true)
										FreezeEntityPosition(ped,true)
										TriggerEvent("cancelando",true)
										FreezeEntityPosition(vehicle,true)
										vRP._playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

										for i = 0,5 do
											Citizen.Wait(8000)
											SetVehicleDoorBroken(vehicle,i,false)
										end

										for i = 0,7 do
											Citizen.Wait(8000)
											SetVehicleTyreBurst(vehicle,i,1,1000.01)
										end

										vRP.removeObjects()
										SetEntityInvincible(ped,false)
										FreezeEntityPosition(ped,false)
										TriggerEvent("cancelando",false)
										vSERVER.paymentMethod(vehicle,vehPrice)
									end
								else
									TriggerEvent("Notify","vermelho","Não existe nenhum carro próximo",3000)
								end
							else
								TriggerEvent("Notify","vermelho","Você não tem permissão para isso",3000)
							end
						end
					end
				end
			--[[ end ]]
			Citizen.Wait(timeDistance)
		end
	end)
--[[ end ]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if timeDismantle > 0 then
			timeDismantle = timeDismantle - 1
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADLIST
-----------------------------------------------------------------------------------------------------------------------------------------
--[[ Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(listX,listY,listZ))
			if distance <= 2.5 then
				timeDistance = 4
				dwText("~g~E~w~  PARA PEGAR UMA LISTA DE CARROS",0.90)
				if IsControlJustPressed(1,38) and distance <= 1.1 then
					startthreaddesmanche()
					vSERVER.acessList()
					inService = true
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end) ]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,height)
	SetTextFont(4)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5,height)
end