-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_prison", cRP)
vSERVER = Tunnel.getInterface("vrp_prison")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = nil
local prison = false
local numServices = 1
local prisonTimer = 0
local prisonLocal = 1
local showHud = true
local showSkate = false
local intransport = false

local carrof_hash = GetHashKey("riot")
local seguranca = GetHashKey("s_m_m_security_01")
local carro_segurancas_hash = GetHashKey("police2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEMTREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        if prison then
            local coords = GetEntityCoords(ped)
            local distance = #(coords - vector3(Config.services[prisonLocal][numServices][1],Config.services[prisonLocal][numServices][2],Config.services[prisonLocal][numServices][3]))

            if distance <= 10 then
                timeDistance = 4
                DrawMarker(21,Config.services[prisonLocal][numServices][1],Config.services[prisonLocal][numServices][2],Config.services[prisonLocal][numServices][3] - 0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,240,202,87,50,0,0,0,1)
                if distance <= 1.5 then
                    if IsControlJustPressed(1, 38) and prisonTimer <= 0 then
                        prisonTimer = 3
                        TriggerEvent("cancelando", true)

                        SetEntityHeading(ped, Config.services[prisonLocal][numServices][4])

                        if Config.services[prisonLocal][numServices][7] == nil then
                            vRP._playAnim(false,
                                {
                                    Config.services[prisonLocal][numServices][5],
                                    Config.services[prisonLocal][numServices][6]
                                },
                                true
                            )
                        else
                            vRP.createObjects(Config.services[prisonLocal][numServices][5],Config.services[prisonLocal][numServices][6],Config.services[prisonLocal][numServices][7],49,28422)
                        end

                        SetEntityCoords(ped,Config.services[prisonLocal][numServices][1],Config.services[prisonLocal][numServices][2],Config.services[prisonLocal][numServices][3] - 1)

                        SetTimeout(15000,function()
                            vRP.removeObjects()
                            vSERVER.reducePrison()
                            TriggerEvent("cancelando", false)
                        end)
                    end
                end
            end

            if GetEntityHealth(ped) <= 101 then
                TriggerEvent("updatePrison")
            end
        end
        local coords = GetEntityCoords(ped)
        local distance = #(coords - vector3(Config.Locations["reclaim_items"]["x"],Config.Locations["reclaim_items"]["y"],Config.Locations["reclaim_items"]["z"]))
        if distance <= 2 then
            timeDistance = 4
            DrawText3D(Config.Locations["reclaim_items"]["x"],Config.Locations["reclaim_items"]["y"],Config.Locations["reclaim_items"]["z"],"[E] Pegar seus pertences")
            if IsControlJustPressed(1, 38) and not prison then
                vSERVER.reclaimItems()
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if prisonTimer > 0 then
            prisonTimer = prisonTimer - 1
        end
        Citizen.Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.startPrison(status)
    prison = true
    prisonLocal = 2
    numServices = math.random(#Config.services[prisonLocal])
    prisonBlips()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.stopPrison()
    prison = false
    intransport = false
    if DoesBlipExist(blips) then
        RemoveBlip(blips)
        blips = nil
    end
    DoScreenFadeIn(1000)
end

function cRP.stopPrison2()
    TriggerEvent("vrp_hud:toggleHood",false)
    prison = false
    intransport = false
    if DoesBlipExist(blips) then
        RemoveBlip(blips)
        blips = nil
    end
end

function cRP.goJailItem()
    DoScreenFadeOut(1000)
    Wait(1350)
    vRP.teleport(1852.43,2585.6,45.68)
    TaskGoToCoordAnyMeans(PlayerPedId(), 1845.69, 2585.83, 45.68, 1.0, 0, 0, 786603, 0xbf800000)
    DoScreenFadeIn(1000)
end
function cRP.getVehiclePed()
    local ped = PlayerPedId()
	return IsPedInAnyVehicle(ped)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISONBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function prisonBlips()
    if DoesBlipExist(blips) then
        RemoveBlip(blips)
        blips = nil
    end

    blips =
        AddBlipForCoord(
        Config.services[prisonLocal][numServices][1],
        Config.services[prisonLocal][numServices][2],
        Config.services[prisonLocal][numServices][3]
    )
    SetBlipSprite(blips, 1)
    SetBlipColour(blips, 71)
    SetBlipScale(blips, 0.6)
    SetBlipAsShortRange(blips, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Serviço")
    EndTextCommandSetBlipName(blips)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            if showSkate then
                if not IsMinimapRendering() then
                    DisplayRadar(true)
                end 
            end 
            if IsPedInAnyVehicle(ped) and showHud or prison then
                if not IsMinimapRendering() then
                    DisplayRadar(true)
                end
            else
                if IsMinimapRendering() and not showSkate then
                    DisplayRadar(false)
                end
            end
            Citizen.Wait(1000)
        end
    end
)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_PRISON:SWITCHHUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_prison:switchHud")
AddEventHandler(
    "vrp_prison:switchHud",
    function(status)
        showHud = status
    end
)

RegisterNetEvent("vrp_prison:showSkate")
AddEventHandler(
    "vrp_prison:showSkate",
    function(status)
        showSkate = status
    end
)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 100)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 350
    DrawRect(_x, _y + 0.0125, 0.01 + factor, 0.03, 0, 0, 0, 100)
end

function setupModelo(modelo)
    RequestModel(modelo)
    while not HasModelLoaded(modelo) do
        RequestModel(modelo)
        Wait(50)
    end
    SetModelAsNoLongerNeeded(modelo)
end


function cRP.startPrisonLocomove()
    TriggerEvent("Notify","amarelo","VOCE ESTA SENDO TRANSFERIDO DA DELEGACIA PARA O PRESIDIO !",7000)
    Wait(7000)
    local ped = PlayerPedId()
    disableAction()
     vRP.teleport(1677.72, 2509.68, 45.57)
     cRP.startPrison()
     vSERVER.saveItems()           
  end

function disableAction()
    Citizen.CreateThread(
        function()
            while true do
                if intransport then
                    DisableControlAction(1, 75, true)
                else
                    EnableControlAction(1, 75, true)
                end
                Citizen.Wait(5)
            end
        end
    )
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if prison then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1700.5,2605.2,45.5,true)
			if distance >= 200 then
				SetEntityCoords(PlayerPedId(),1680.1,2513.0,45.5)
				TriggerEvent("Notify","amarelo","O agente penitenciário encontrou você tentando escapar.",5000)
			end
		end
	end
end)