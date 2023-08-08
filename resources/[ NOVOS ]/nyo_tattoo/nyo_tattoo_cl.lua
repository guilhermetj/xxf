local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
nyoTattooC = {}
Tunnel.bindInterface("nyo_tattoo", nyoTattooC)
Proxy.addInterface("nyo_tattoo", nyoTattooC)
nyoTattooS = Tunnel.getInterface("nyo_tattoo")


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local tattooShops = {}
local oldTattoo = nil
local atualTattoo = {}
atualShop = {}
local oldCustom = {}

local totalPrice = 0
local cam = nil

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function nyoTattooC.setTattoos(data)
    atualTattoo = data
end

function nyoTattooC.payment(r)    
    SetNuiFocus(false, false)   
    if r then 

    else 
        resetTattoo()
    end
    oldTattoo = nil
    closeGuiLojaTattoo()
end

function openTattooShop(id)
    local ped = PlayerPedId()
    SetNuiFocus(true, true)
    SetCameraCoords()
    if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
        atualShop = tattooShops[id]['partsM']
        SendNUIMessage({
            openNui = true,
            shop = atualShop,
            tattoo = oldTattoo
        })
    elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then 
        atualShop = tattooShops[id]['partsF']    
        SendNUIMessage({
            openNui = true,
            shop = atualShop,
            tattoo = oldTattoo
        })    
    end
end

function closeGuiLojaTattoo()
    local ped = PlayerPedId()
    nyoTattooC.applyTatto()
    SetNuiFocus(false, false)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    in_loja = false
    oldTattoo = nil
    totalPrice = 0
    DeleteCam()
end

function resetTattoo()
    atualTattoo = oldTattoo
    if oldTattoo then
		ClearPedDecorations(PlayerPedId())
		for k,v in pairs(oldTattoo) do
			AddPedDecorationFromHashes(PlayerPedId(),GetHashKey(v[1]),GetHashKey(k))
        end
    else 
        ClearPedDecorations(PlayerPedId())
	end
end

function atualizarTattoo()
    ClearPedDecorations(PlayerPedId())
    for k,v in pairs(atualTattoo) do
        AddPedDecorationFromHashes(PlayerPedId(),GetHashKey(v[1]),GetHashKey(k))
    end
    SendNUIMessage({
        atualizaPrice = true, 
        price = totalPrice
    })
end

function nyoTattooC.applyTatto()
    ClearPedDecorations(PlayerPedId())
    for k,v in pairs(atualTattoo) do
        AddPedDecorationFromHashes(PlayerPedId(),GetHashKey(v[1]),GetHashKey(k))
    end
end



function criarBlip()
    for k,v in pairs(tattooShops) do 
        for k2, v2 in pairs(v.coord) do
            if v2.exibeBlip then 
                v2.blip = AddBlipForCoord(v2[1], v2[2], v2[3])
                SetBlipSprite(v2.blip, 75)
                SetBlipColour(v2.blip, 39)
                SetBlipScale(v2.blip, 0.5)
                SetBlipAsShortRange(v2.blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Tatto Shop')
                EndTextCommandSetBlipName(v2.blip)
            end            
        end
    end
end

function SetCameraCoords()
    local ped = PlayerPedId()
	RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    
	if not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        pos = GetEntityCoords(PlayerPedId())
        camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
        SetCamCoord(cam, camPos.x, camPos.y, camPos.z+0.75)
        PointCamAtCoord(cam, pos.x, pos.y, pos.z+0.15)
    end
end

function DeleteCam()
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 0, true, true)
	cam = nil
end


RegisterCommand('tt', function(source, args, rawCommand)
    local ped = PlayerPedId()
	RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    
	if not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        pos = GetEntityCoords(PlayerPedId())
        camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
        SetCamCoord(cam, camPos.x, camPos.y - 1, camPos.z+0.45)
        PointCamAtCoord(cam, pos.x, pos.y, pos.z+0.45)
    end
end)

RegisterCommand('tt3', function(source, args, rawCommand)
    local ped = PlayerPedId()
	RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    
	if not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        pos = GetEntityCoords(PlayerPedId())
        camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
        SetCamCoord(cam, camPos.x, camPos.y - 1, camPos.z+1.3)
        PointCamAtCoord(cam, pos.x, pos.y, pos.z+0.25)
    end
end)

RegisterCommand('tt2', function(source, args, rawCommand)
    local ped = PlayerPedId()
	RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    
	if not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        pos = GetEntityCoords(PlayerPedId())
        camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
        SetCamCoord(cam, camPos.x, camPos.y-1, camPos.z-0.5)
        PointCamAtCoord(cam, pos.x, pos.y-1, pos.z-0.5)
    end
end)


RegisterCommand('rtt', function(source, args, rawCommand)
    DeleteCam()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    SetNuiFocus(false, false)
    tattooShops = nyoTattooS.getTattooShops()    
    nyoTattooS.getTattoo()
    criarBlip()
end)

-- Deixar comentado depois da ultima att do Fivem as tatuagens pararam de piscar! Caso ocorra, descomentar esta funçao
-- CreateThread(function()
--     while true do 
--         Wait(300)
--         if not in_loja then 
--             ClearPedDecorations(PlayerPedId())
--             for k,v in pairs(atualTattoo) do
--                  AddPedDecorationFromHashes(PlayerPedId(),GetHashKey(v[1]),GetHashKey(k))
--             end
--         end      
--     end
-- end)

CreateThread(function()
    while true do 
        local nyoSleep = 500
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if not in_loja then 
            for k,v in pairs(tattooShops) do 
                for k2, v2 in pairs(v['coord']) do 
                    local distance = GetDistanceBetweenCoords(x,y,z,v2[1], v2[2], v2[3], true)
                    if distance < 10 then 
                        nyoSleep = 4
                        DrawMarker(27,v2[1],v2[2],v2[3]-0.95,0,0,0,0,180.0,130.0,1.0,1.0,1.0,255,0,0,75,0,0,0,1)
                        if distance <=1 then 
                            if IsControlJustPressed(0, 38) then 
                                in_loja = true
                                oldTattoo = atualTattoo
                                openTattooShop(k)
                            end
                        end
                    end
                end                
            end
        end        
        Wait(nyoSleep)
    end
end)




-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("reset", function(data, cb)
    resetTattoo()
    ClearPedTasks(PlayerPedId())
    closeGuiLojaTattoo()
end)

RegisterNUICallback("changeTattoo", function(data, cb)
    local pId = data.id + 1
    local pType = data.type
    local tattooData = atualShop[pType]['tattoo'][pId]
        if atualTattoo[tattooData['name']] ~= nil then 
            local newAtualTattoo = {}
            for k,v in pairs(atualTattoo) do 
                if k ~= tattooData['name'] then 
                    newAtualTattoo[k] = v
                end
            end
            atualTattoo = newAtualTattoo

                if oldTattoo[tattooData['name']] == nil then 
                    totalPrice = totalPrice - tattooData['price']
                end
            atualizarTattoo()
        else 
            local newAtualTattoo = {}
            for k,v in pairs(atualTattoo) do 
                if k ~= tattooData['name'] then 
                    newAtualTattoo[k] = v
                end
            end
            newAtualTattoo[tattooData['name']] = {tattooData['part']}
            atualTattoo = newAtualTattoo
            if oldTattoo[tattooData['name']] == nil then 
                totalPrice = totalPrice + tattooData['price']
            end
            atualizarTattoo()
        end    
end)

RegisterNUICallback("limpaTattoo", function(data, cb)
    atualTattoo = {}
    atualizarTattoo()
end)



RegisterNUICallback("payament", function(data, cb)
    nyoTattooS.payment(data.price, totalPrice, atualTattoo)
end)

RegisterNUICallback("leftHeading", function(data, cb)
    local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading-tonumber(data.value)
    SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback("handsUp", function(data, cb)
    local dict = "missminuteman_1ig_2"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
    end
    
    if not handsup then
        TaskPlayAnim(PlayerPedId(), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
        handsup = true
    else
        handsup = false
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNUICallback("rightHeading", function(data, cb)
    local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading+tonumber(data.value)
    SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNetEvent('reloadtattos')
AddEventHandler('reloadtattos',function()
    local TattooAQ = nyoTattooS.getTattoos()
	if TattooAQ then
		ClearPedDecorations(PlayerPedId())
		for k,v in pairs(TattooAQ) do
			AddPedDecorationFromHashes(PlayerPedId(),GetHashKey(v[1]),GetHashKey(k))
		end
	end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        closeGuiLojaTattoo()
    end
end)