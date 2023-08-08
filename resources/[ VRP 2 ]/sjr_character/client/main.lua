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
Tunnel.bindInterface("sjr_character",cnVRP)
vSERVER = Tunnel.getInterface("sjr_character")


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------

local charPed = nil
local createdChars = {}
local currentChar = nil
local choosingCharacter = false
local currentMarker = nil
local cam = nil
local cid = 0

-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINDATA
-----------------------------------------------------------------------------------------------------------------------------------------
local skinData = {
	["pants"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	["arms"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	["t-shirt"] = { item = 1, texture = 0, defaultItem = 1, defaultTexture = 0 },
	["torso2"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	["shoes"] = { item = 0, texture = 0, defaultItem = 1, defaultTexture = 0 },
	["mask"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
	["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
	["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
	["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
	["accessory"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------

Config = {
    PedCoords = {x = -813.97, y = 176.22, z = 76.74, h = -7.5, r = 1.0}, 
    HiddenCoords = {x = -812.23, y = 182.54, z = 76.74, h = 156.5, r = 1.0}, 
    CamCoords = {x = -814.02, y = 179.56, z = 76.74, h = 198.5, r = 1.0}, 

    spawns = {
        [1] = {
            coords = vector3(-1035.691, -2738.945, 20.169267),
            heading = 12.683959
        },

        [2] = {
            coords = vector3(-1037.3, -2739.961, 20.169281),
            heading = 6.0901341
        },

        [3] = {
            coords = vector3(-1038.816, -2739.806, 20.169281),
            heading = 330.1156
        },

        [4] = {
            coords = vector3(-1039.881, -2738.181, 20.169267),
            heading = 307.3962
        },

        [5] = {
            coords = vector3(-1039.538, -2736.306, 20.169267),
            heading = 284.73489
        }
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD DE INIT
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            TriggerEvent('sjr-character:client:chooseChar')
            TriggerServerEvent('mumble:infinity:server:mutePlayer')
			return
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR + NO PERSONAGEM
-----------------------------------------------------------------------------------------------------------------------------------------

function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    choosingCharacter = bool

    if bool == true then
        DoScreenFadeIn(3000)
        createCamera('create')
        Wait(1500)

        local html = ""
        for k, v in ipairs(createdChars) do
            local pedCoords = GetPedBoneCoords(v.ped, 0x2e28, 0.0, 0.0, 0.0)
            local onScreen, xxx, yyy = GetHudScreenPositionFromWorldPosition(pedCoords.x, pedCoords.y, pedCoords.z + 0.3)
            if v.isreg then
                html = html .. "<div id=\"" .. v.key .. "\" onmouseover=\"update_char_marker(this.id)\" onClick=\"select_character(this.id)\"><p style=\"left: ".. xxx * 100 .."%;top: ".. yyy * 90 .."%;-webkit-transform: translate(-50%, 0%);max-width: 100%; position: absolute; padding-top: 170px; padding-right: 30px; padding-bottom: 100px; padding-left: 80px;;\"></p></div>"
            else
                html = html .. "<div id=\"" .. v.key .. "\" onmouseover=\"update_char_marker(this.id)\" onClick=\"create_character(this.id)\"><p style=\"left: ".. xxx * 100 .."%;top: ".. yyy * 90 .."%;-webkit-transform: translate(-50%, 0%);max-width: 100%; position: absolute; padding-top: 170px; padding-right: 30px; padding-bottom: 100px; padding-left: 80px;;\"></p><p style=\"left: ".. xxx * 100 .."%;top: ".. yyy * 100 .."%;;text-shadow: 1px 0px 5px #000000FF, -1px 0px 0px #000000FF, 0px -1px 0px #000000FF, 0px 1px 5px #000000FF;-webkit-transform: translate(-50%, 0%);max-width: 100%;position: fixed;text-align: center;color: #FFFFFF; font-family:Heebo;font-size: 20px;\"><img \" width=\"30px\" height=\"30px\" src=\"plus.png\"></img></span></p></div>"
            end
        end

        SendNUIMessage({
            action = "setinfo",
            data = html,
        })
    else
        createCamera('exit')
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FECHAR NUI EVENTO
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('sjr-character:client:closeNUI')
AddEventHandler('sjr-character:client:closeNUI', function()
    SetNuiFocus(false, false)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETAR PEDS
-----------------------------------------------------------------------------------------------------------------------------------------

function deletePeds()
    for _, v in pairs(createdChars) do
        SetEntityAsMissionEntity(v.ped, true, true)
        DeleteEntity(v.ped)
    end
    createdChars = {}
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR PEDS
-----------------------------------------------------------------------------------------------------------------------------------------

function CreatePeds()
    local result = vSERVER.getUserCharacters()
    local html = ""
    local dontHasStuff = {}
    
    for i = 1, 5, 1 do
        local has = false
        for k, v in ipairs(result) do
            if k == i then
                has = true
                break
            end
        end
        if not has then
            table.insert(dontHasStuff, i)
        end
    end

    for k, v in ipairs(dontHasStuff) do
        Citizen.CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            local charPed = CreatePed(3, model, Config.spawns[v].coords.x, Config.spawns[v].coords.y, Config.spawns[v].coords.z - 0.98, Config.spawns[v].heading, false, true)
            SetEntityAlpha(charPed, 100)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
            table.insert(createdChars, {key = v, ped = charPed, isreg = false})
        end)
    end

    for k, v in ipairs(result) do
            local model, data, inf, custom = vSERVER.getSkin(v.id, {v.id, v.id, v.name .. ' ' .. v.name2})
        --QBCore.Functions.TriggerCallback('sjr-character:server:getSkin', function(model, data, inf)
            Wait(500)
            local citizenid, name = v.id, v.name
            cid = cid + 1
            if model ~= nil then
                CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    local charPed = CreatePed(3, model, Config.spawns[cid].coords.x, Config.spawns[cid].coords.y, Config.spawns[cid].coords.z - 0.98, Config.spawns[cid].heading, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                  --  data = json.decode(data)
                    TriggerEvent('sjr-character:setCustomization', custom, charPed, data)
                    table.insert(createdChars, {key = v.id, ped = charPed, dat = inf,isreg = true})
                end)
            else
                Citizen.CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    local charPed = CreatePed(3, model, Config.spawns[cid].coords.x, Config.spawns[cid].coords.y, Config.spawns[cid].coords.z - 0.98, Config.spawns[cid].heading, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    table.insert(createdChars, {key = v.id, ped = charPed, dat = inf,isreg = true})
                end)
            end
        --end, v.citizenid, {v.citizenid, v.cid, json.decode(v.charinfo).firstname .. ' ' .. json.decode(v.charinfo).lastname})
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECIONAR
-----------------------------------------------------------------------------------------------------------------------------------------

-- function selectChar()
--     openCharMenu(true)
-- end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGAR PED PELO ID
-----------------------------------------------------------------------------------------------------------------------------------------

function getPedFromCharID(id)
    for k, v in pairs(createdChars) do
        if v.key == id then
            if not v.isreg then
                SetEntityAlpha(v.ped, 255)
            end
            return v
        end
    end
    return nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ENVIAR PERSONAGENS PRA NUI
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('setupCharacters', function()
    local result = vSERVER.getPersonagens()
    SendNUIMessage({
        action = "setupCharacters",
        characters = result
    })
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE UI
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('closeUI', function()
    openCharMenu(false)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('disconnectButton', function()
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('sjr-character:server:disconnect')
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECIONAR PERSONAGEM E SPAWNAR
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('selectCharacter', function()
    deletePeds()
    DoScreenFadeOut(10)
    TriggerServerEvent('sjr-character:server:loadUserData', currentChar)
    openCharMenu(false)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETA CAMERA NO PLAYER E ABRE NUI COM INFOS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('getCloserToCharacter', function(data)
    local pedData = getPedFromCharID(tonumber(data.charid))
    currentChar = pedData
    createCamera('char', pedData.ped)

    if currentChar.isreg then
        SendNUIMessage({
            action = "setCharData",
            name = currentChar.dat[3],
            cid = currentChar.dat[1],
        })
    end
    currentMarker = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETA O PED SELECIONADO
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('updateCharMarker', function(data)
    if data.charid ~= false then
        local pedData = getPedFromCharID(tonumber(data.charid))
        currentMarker = GetEntityCoords(pedData.ped)
        if not pedData.isreg then
            SetEntityAlpha(pedData.ped, 100)
        end
    else
        currentMarker = nil
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD MARKER
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function ()
    while true do
        local sjr = 1000
        if currentMarker ~= nil then
            sjr = 5
            DrawMarker(0, currentMarker.x, currentMarker.y, currentMarker.z + 1.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 255, 3, 53, 255, 0, 0, 0, 1, 0, 0, 0)
        end
        Wait(sjr)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGA O CHAR OF
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('getOffChar', function()
    createCamera('create')
    if not currentChar.isreg then
        SetEntityAlpha(currentChar.ped, 100)
    end
    currentChar = nil
    currentMarker = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CRIA NOVO PERSONAGEM
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('createNewCharacter', function(data)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "man" then
        cData.gender = 0
    elseif cData.gender == "woman" then
        cData.gender = 1
    end

    TriggerServerEvent('sjr-character:server:createCharacter', cData, currentChar.key)
    -- TriggerServerEvent('sjr-character:server:GiveStarterItems')
    deletePeds()
    openCharMenu(false)
    Citizen.Wait(500)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ATUALIZA OS PERSONAGENS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('sjr-character:refreshPeds')
AddEventHandler('sjr-character:refreshPeds', function()
    
    deletePeds()
    currentChar = nil
    openCharMenu(false)
    cid = 0
    CreatePeds()
    openCharMenu(true)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- APAGA PERSONAGEM
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('removeCharacter', function()
    TriggerServerEvent('sjr-character:server:deleteCharacter', currentChar.dat[1])
    DoScreenFadeOut(750)
    Wait(1500)
    TriggerEvent('sjr-character:refreshPeds')
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE O BLUR
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('removeBlur', function()
    SetTimecycleModifier('default')
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETA O BLUR
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('setBlur', function()
    SetTimecycleModifier('hud_def_blur')
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CRIA A CAMERA
-----------------------------------------------------------------------------------------------------------------------------------------

function createCamera(typ, pedData)
    SetRainFxIntensity(0.0)
    TriggerEvent('sa-weathersync:client:DisableSync')
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(12, 0, 0)

    if typ == 'create' then
        DoScreenFadeIn(1000)
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1035.697, -2734.057, 21.482341, -10.0, 0.0, 150.0, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    elseif typ == 'exit' then
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    elseif typ == 'char' then
        local coords = GetOffsetFromEntityInWorldCoords(pedData, 0, 2.0, 0)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        if(not DoesCamExist(cam)) then
            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
            SetCamRot(cam, 0.0, 0.0, GetEntityHeading(pedData) + 180)
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GTA SWITCHS
-----------------------------------------------------------------------------------------------------------------------------------------

-- Gta V Switch
local cloudOpacity = 0.01
local muteSound = true

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

function InitialSetup()
    ToggleSound(muteSound)
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 1, 1)
    end
end

function ClearScreen()
    SetCloudHatOpacity(cloudOpacity)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIA TODO O SCRIPT
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('sjr-character:client:chooseChar')
AddEventHandler('sjr-character:client:chooseChar', function()
    SetNuiFocus(false, false)
    DoScreenFadeOut(0)

    ToggleSound(muteSound)
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 1, 1)
    end
    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScreen()
    end

    ClearScreen()
    Citizen.Wait(0)
    
    local timer = GetGameTimer()
    ToggleSound(false)

    CreatePeds()
    ShutdownLoadingScreenNui()
    SetEntityCoords(GetPlayerPed(-1), vector3(-1049.942, -2724.759, 20.169294))
    SetEntityVisible(GetPlayerPed(-1), false, false)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    Citizen.CreateThread(function()
        RequestCollisionAtCoord(Config.spawns[1].coords)
        while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
          --  print('[sjr-character] Carregando Spawn Colisão.')
            Wait(0)
        end
    end)

    DoScreenFadeIn(250)
    while true do
        ClearScreen()
        Citizen.Wait(0)
        if GetGameTimer() - timer > 5000 then
            SwitchInPlayer(PlayerPedId())
            ClearScreen()
            CreateThread(function()
                Wait(4000)
                DoScreenFadeOut(350)
            end)

            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
                ClearScreen()
            end
            
            break
        end
    end

    NetworkSetTalkerProximity(0.0)
    openCharMenu(true)
end)


----------------------------------------------------------------------------------------------------------------------------------------
------------------- SET CLOTHES/BARBERSHOP
----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("sjr-character:setCustomization")
AddEventHandler("sjr-character:setCustomization", function(dbCharacter,skin,data)
    custom = dbCharacter
    if custom then
        TaskUpdateSkinOptions(skin)
        TaskUpdateFaceOptions(skin)
        TaskUpdateHeadOptions(skin)
    end
    if data then
        resetClothing(data,skin)
    end
end)


----------------------------------------------------------------------------------------------------------------------------------------
------------------- CLOTHES
----------------------------------------------------------------------------------------------------------------------------------------

function resetClothing(data,charPed)
	local ped = charPed

	SetPedComponentVariation(ped,4,data["pants"].item,data["pants"].texture,2)
	SetPedComponentVariation(ped,3,data["arms"].item,data["arms"].texture,2)
	SetPedComponentVariation(ped,8,data["t-shirt"].item,data["t-shirt"].texture,2)
	SetPedComponentVariation(ped,9,data["vest"].item,data["vest"].texture,2)
	SetPedComponentVariation(ped,11,data["torso2"].item,data["torso2"].texture,2)
	SetPedComponentVariation(ped,6,data["shoes"].item,data["shoes"].texture,2)
	SetPedComponentVariation(ped,1,data["mask"].item,data["mask"].texture,2)
	SetPedComponentVariation(ped,10,data["decals"].item,data["decals"].texture,2)
	SetPedComponentVariation(ped,7,data["accessory"].item,data["accessory"].texture,2)
	SetPedComponentVariation(ped,5,data["bag"].item,data["bag"].texture,2)

	if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
		SetPedPropIndex(ped,0,data["hat"].item,data["hat"].texture,2)
	else
		ClearPedProp(ped,0)
	end

	if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
		SetPedPropIndex(ped,1,data["glass"].item,data["glass"].texture,2)
	else
		ClearPedProp(ped,1)
	end

	if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
		SetPedPropIndex(ped,2,data["ear"].item,data["ear"].texture,2)
	else
		ClearPedProp(ped,2)
	end

	if data["watch"].item ~= -1 and data["watch"].item ~= 0 then
		SetPedPropIndex(ped,6,data["watch"].item,data["watch"].texture,2)
	else
		ClearPedProp(ped,6)
	end

	if data["bracelet"].item ~= -1 and data["bracelet"].item ~= 0 then
		SetPedPropIndex(ped,7,data["bracelet"].item,data["bracelet"].texture,2)
	else
		ClearPedProp(ped,7)
	end
end



----------------------------------------------------------------------------------------------------------------------------------------
------------------- BARBERSHOP
----------------------------------------------------------------------------------------------------------------------------------------

function TaskUpdateSkinOptions(skin)
	local data = custom
	if data.shapeMix == nil then
		data.shapeMix = 0.0
	end
	SetPedHeadBlendData(skin,data.fathersID,data.mothersID,0,data.skinColor,0,0,f(data.shapeMix),0,0,false)
end

function TaskUpdateFaceOptions(skin)
	local ped = skin
	local data = custom	
	-- Olhos
	SetPedEyeColor(ped,data.eyesColor)
	-- Sobrancelha
	SetPedFaceFeature(ped,6,data.eyebrowsHeight)
	SetPedFaceFeature(ped,7,data.eyebrowsWidth)
	-- Nariz
	SetPedFaceFeature(ped,0,data.noseWidth)
	SetPedFaceFeature(ped,1,data.noseHeight)
	SetPedFaceFeature(ped,2,data.noseLength)
	SetPedFaceFeature(ped,3,data.noseBridge)
	SetPedFaceFeature(ped,4,data.noseTip)
	SetPedFaceFeature(ped,5,data.noseShift)
	-- Bochechas
	SetPedFaceFeature(ped,8,data.cheekboneHeight)
	SetPedFaceFeature(ped,9,data.cheekboneWidth)
	SetPedFaceFeature(ped,10,data.cheeksWidth)
	-- Boca/Mandibula
	SetPedFaceFeature(ped,12,data.lips)
	SetPedFaceFeature(ped,13,data.jawWidth)
	SetPedFaceFeature(ped,14,data.jawHeight)
	-- Queixo
	SetPedFaceFeature(ped,15,data.chinLength)
	SetPedFaceFeature(ped,16,data.chinPosition)
	SetPedFaceFeature(ped,17,data.chinWidth)
	SetPedFaceFeature(ped,18,data.chinShape)
	-- Pescoço
	SetPedFaceFeature(ped,19,data.neckWidth)
end

function TaskUpdateHeadOptions(skin)
	local ped = skin
	local data = custom

	-- Cabelo
	SetPedComponentVariation(ped,2,data.hairModel,0,0)
	SetPedHairColor(ped,data.firstHairColor,data.secondHairColor)

	-- Sobrancelha 
	SetPedHeadOverlay(ped,2,data.eyebrowsModel, 0.99)
	SetPedHeadOverlayColor(ped,2,1,data.eyebrowsColor,data.eyebrowsColor)

	-- Barba
	SetPedHeadOverlay(ped,1,data.beardModel,0.99)
	SetPedHeadOverlayColor(ped,1,1,data.beardColor,data.beardColor)

	-- Pelo Corporal
	SetPedHeadOverlay(ped,10,data.chestModel,0.99)
	SetPedHeadOverlayColor(ped,10,1,data.chestColor,data.chestColor)

	-- Blush
	SetPedHeadOverlay(ped,5,data.blushModel,0.4)
	SetPedHeadOverlayColor(ped,5,1,data.blushColor,data.blushColor)

	-- Battom
	SetPedHeadOverlay(ped,8,data.lipstickModel,0.99)
	SetPedHeadOverlayColor(ped,8,1,data.lipstickColor,data.lipstickColor)

	-- Manchas
	SetPedHeadOverlay(ped,0,data.blemishesModel,0.99)
	SetPedHeadOverlayColor(ped,0,0,0,0)

	-- Envelhecimento
	SetPedHeadOverlay(ped,3,data.ageingModel,0.99)
	SetPedHeadOverlayColor(ped,3,0,0,0)

	-- Aspecto
	SetPedHeadOverlay(ped,6,data.complexionModel,0.99)
	SetPedHeadOverlayColor(ped,6,0,0,0)

	-- Pele
	SetPedHeadOverlay(ped,7,data.sundamageModel,0.99)
	SetPedHeadOverlayColor(ped,7,0,0,0)

	-- Sardas
	SetPedHeadOverlay(ped,9,data.frecklesModel,0.99)
	SetPedHeadOverlayColor(ped,9,0,0,0)
	-- Maquiagem
	SetPedHeadOverlay(ped,4,data.makeupModel,0.99)
	SetPedHeadOverlayColor(ped,4,0,0,0)
end


function f(n)
	n = n + 0.00000
	return n
end