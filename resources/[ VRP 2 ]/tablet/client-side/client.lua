-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("tablet",cRP)
vSERVER = Tunnel.getInterface("tablet")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local typeBikes = {}
local typeWorks = {}
local typeRental = {}
local vehicle = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-- TABLET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tablet",function(source,args)
	if GetEntityHealth(PlayerPedId()) > 101 then
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "openSystem" })
	else
		return
	end
	
	if not IsPedInAnyVehicle(PlayerPedId()) and GetEntityHealth(PlayerPedId()) > 101 then
		vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("tablet","Abrir o tablet","keyboard","f9")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data)
	vRP.removeObjects()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "closeSystem" })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.closeSystem()
    vRP.removeObjects()
    SetNuiFocus(false,false)
    SetCursorLocation(0.5,0.5)
    SendNUIMessage({ action = "closeSystem" })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRANKING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestRanking",function(data,cb)
	cb(vSERVER.requestRanking(data["id"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateVehicles(Cars,Bikes,Works,Rental)
	typeCars = Cars
	typeBikes = Bikes
	typeWorks = Works
	typeRental = Rental
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCARROS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestCarros",function(data,cb)
	cb({ result = vSERVER.requestCarros() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMotos",function(data,cb)
	cb({ result = vSERVER.requestBikes() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTALUGUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestAluguel",function(data,cb)
	cb({ result = vSERVER.requestAluguel() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPOSSUIDOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestPossuidos",function(data,cb)
	cb({ result = vSERVER.requestPossuidos(data["name"]) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestBuy",function(data,cb)
	vSERVER.requestBuy(data["name"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestRental",function(data,cb)
	vSERVER.requestBuyAlugel(data["name"])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestTax",function(data,cb)
	vSERVER.paymentTax(data["name"])
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "closeSystem" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.returnVehicle(name)
	return vehicle[name]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestSell",function(data,cb)
	vSERVER.requestSell(data["name"])
	SendNUIMessage({ action = "requestPossuidos" })

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tablet:Update")
AddEventHandler("tablet:Update",function()
	SendNUIMessage({ action = "update" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVEABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehDrive = nil
local benDrive = false
local benCoords = { -56.95,-1096.52,26.42 }
RegisterNUICallback("requestDrive",function(data, cb)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = #(coords - vector3(benCoords[1],benCoords[2],benCoords[3]))
	local valor = math.random(2500,3000)

	if distance <= 3 then     

		local user_id = vRP.getUserId(source)
		local hash = GetHashKey(data["name"])
		vSERVER.paymentDrive()
		lastPlayerCoords = GetEntityCoords(PlayerPedId())
		cRP.closeSystem()
		if testDriveEntity ~= nil then
			DeleteEntity(testDriveEntity)
		end
		testDriveEntity = vehCreate(data["name"],"55DTA141",-1631.23,-2973.19,13.95, 236.85)
		SetPedIntoVehicle(ped,vehDrive,-1)
		local timeGG = GetGameTimer()
		startCountDown = true
		while startCountDown do
			local countTime
			Citizen.Wait(1)
			if GetGameTimer() < timeGG+tonumber(1000*20) then
				local secondsLeft = GetGameTimer() - timeGG
				drawTxt("TEMPO RESTANTE " .. math.ceil(20 - secondsLeft/1000),4,0.5,0.93,0.50,255,255,255,180)
			else
				DeleteEntity(vehDrive)
				SetEntityCoords(PlayerPedId(), lastPlayerCoords)
				startCountDown = false
			end      
		end
	else
		TriggerEvent("Notify","amarelo","Dirija-se ate a <b>Benefactor</b> para efetuar o teste.",4000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCREATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vehCreate(vehName,vehPlate,x,y,z,h)
	local user_id = vRP.getUserId(source)
	TriggerServerEvent("setPlateEveryone",vehPlate)
	TriggerServerEvent("setPlatePlayers",vehPlate,user_id)
	local mHash = GetHashKey(vehName)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Citizen.Wait(1)
	end

	if HasModelLoaded(mHash) then
		vehDrive = CreateVehicle(mHash,x,y,z,h,true,false)

		SetEntityInvincible(vehDrive,true)
		SetVehicleOnGroundProperly(vehDrive)
		SetVehicleNumberPlateText(vehDrive,vehPlate)
		SetEntityAsMissionEntity(vehDrive,true,true)
		SetVehicleHasBeenOwnedByPlayer(vehDrive,true)
		SetVehicleNeedsToBeHotwired(vehDrive,false)

		SetModelAsNoLongerNeeded(mHash)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        if startCountDown then
            timeDistance = 5
            DisableControlAction(1,69,false)

            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped) then
                Citizen.Wait(1000)

                startCountDown = false
                DeleteEntity(vehDrive)
                SetEntityCoords(ped,benCoords[1],benCoords[2],benCoords[3],1,0,0,0)
            end
        end

        Citizen.Wait(timeDistance)
    end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end