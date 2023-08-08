local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP") 

dPN = {}
Tunnel.bindInterface("nh_loja",dPN)
Proxy.addInterface("nh_loja",dPN)
dPNserver = Tunnel.getInterface("nh_loja")

local parts = {  
    mascara = 1, 
    mao = 3,
    calca = 4,
    mochila = 5,
    sapato = 6,
    gravata = 7,
    camisa = 8,
colete = 9,
    jaqueta = 11,
    bone = "p0",
    oculos = "p1",
    brinco = "p2",
    relogio = "p6",
    bracelete = "p7"
}

Camera = {}
Camera.entity       = nil
Camera.position     = vector3(0.0, 0.0, 0.0)
Camera.currentView  = 'corpo'
Camera.active       = false
Camera.radius       = 1.25
Camera.angleX       = 30.0
Camera.angleY       = 0.0
Camera.mouseX       = 0
Camera.mouseY       = 0

Camera.radiusMin    = 1.0
Camera.radiusMax    = 2.25
Camera.angleYMin    = -30.0
Camera.angleYMax    = 80.0

local carroCompras = {
    mascara = false,
    mao = false,
    calca = false,
    mochila = false,
    sapato = false,
    gravata = false,
    camisa = false,
colete = false,
    jaqueta = false,
    bone = false,
    oculos = false,
    brinco = false,
    relogio = false,
    bracelete = false
}

local old_custom = {}

local valor = 0
local precoTotal = 0

local in_loja = false
local atLoja = false

Citizen.CreateThread(function()
    local ped = PlayerPedId()
TransitionFromBlurred(1000)
    SetNuiFocus(false,false)
    FreezeEntityPosition(ped, false)

end)

function deixarInivisivel()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, false)
            SetEntityNoCollisionEntity(ped, otherPlayer, true)
        end
    end
end

Citizen.CreateThread(function()
    SetNuiFocus(false,false)
    while true do
        local sleep = 500
        for k, v in pairs(Config_client['lojaderoupa']) do
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped, true)
            local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v['x'], v['y'], v['z'], true )
            if distance < 3 then
                sleep = 5
                if Config_client['textoConfirm'] == true then
                    DrawText3D(v['x'], v['y'], v['z']-0.1,Config_client['texto'],0.5,3)
                end
                if Config_client['blipConfirm'] == true then
                    DrawMarker(Config_client['blip'],v['x'], v['y'], v['z']-1,0,0,0,0.0,0,0,0.7,0.7,0.4,255,0,0,70,0,0,0,1)
                end
                if IsControlJustPressed(0,38) then
                    SetNuiFocus(true, true)
                    SendNUIMessage({ action = "showMenu"})
                    valor = 0
                    precoTotal = 0
                    ClearPedTasks(PlayerPedId())
                    noProvador = true
                    old_custom = vRP.getCustomization()
                    old = {}
                    cor = 0
                    dados, tipo = nil
                    naroupas = true
                end
            end
        end
        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    criarBlip()
    if Config_client['invisivel'] == true then
        while true do
            if naroupas then
                deixarInivisivel()
                DisableControlAction(1, 1, true)
                DisableControlAction(1, 2, true)
                DisableControlAction(1, 24, true)
                DisablePlayerFiring(PlayerPedId(), true)
                DisableControlAction(1, 142, true)
                DisableControlAction(1, 106, true)
                DisableControlAction(1, 37, true)
            end
            Wait(1)
        end
    end
end)

function criarBlip()
    for _, item in pairs(Config_client['lojaderoupa']) do
        if Config_client['markerConfirmation'] == true then 
            item.blip = AddBlipForCoord(item.x, item.y, item.z)
            SetBlipSprite(item.blip, Config_client['markerId'])
            SetBlipColour(item.blip, Config_client['markerColor'])
            SetBlipScale(item.blip, 0.5)
            SetBlipAsShortRange(item.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config_client['markerName'])
            EndTextCommandSetBlipName(item.blip)
        end       
    end
end


RegisterNUICallback("roupasClose",function(data)
    local ped = PlayerPedId()
    SetNuiFocus(false, false)
    SendNUIMessage({ openLojaRoupa = false })
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityInvincible(ped, false)
    Deactivate()
    SendNUIMessage({ action = "hideMenu",value = 0 })
    vRP.setCustomization(old_custom)
    ClearPedTasks(PlayerPedId())
    in_loja = false
    noProvador = false
    chegou = false
    naroupas = false
    old_custom = {}
    deixarVisivel()
    TriggerServerEvent('dpn_barber:setPedClient')

end)

function deixarVisivel()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, true)
SetEntityVisible(ped, true)
            SetEntityCollision(ped, true)
        end
    end
end

RegisterNUICallback("changeCustom", function(data, cb)
    changeClothe(data.type, data.id)
end)

function changeClothe(type, id)
    dados = type
    tipo = tonumber(parseInt(id))
cor = 0
    setRoupa(dados, tipo, cor)
end

function setRoupa(dados, tipo, cor)
    local ped = PlayerPedId()

if type(dados) == "number" then
SetPedComponentVariation(ped, dados, tipo, cor, 1)
    elseif type(dados) == "string" then
        SetPedPropIndex(ped, parse_part(dados), tipo, cor, 1)
        dados = "p" .. (parse_part(dados))
end
  
  custom = vRP.getCustomization()
  custom.modelhash = nil

aux = old_custom[dados]
v = custom[dados]

    if v[1] ~= aux[1] and old[dados] ~= "custom" then
        carroCompras[dados] = true
        price = updateCarroCompras()
        SendNUIMessage({ action = "setPrice", price = price, typeaction = "add" })
    old[dados] = "custom"
    end
    if v[1] == aux[1] and old[dados] == "custom" then
        carroCompras[dados] = false
        price = updateCarroCompras()
        SendNUIMessage({ action = "setPrice", price = price, typeaction = "remove" })
    old[dados] = "0"
end

SendNUIMessage({ value = price })
end

function DrawText3D(x,y,z, text, scl, font) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
local px,py,pz=table.unpack(GetGameplayCamCoords())
 
    if onScreen then
SetTextScale(0.35, 0.35)
SetTextFont(4)
SetTextProportional(1)
SetTextColour(255, 255, 255, 215)
SetTextEntry("STRING")
SetTextCentre(1)
AddTextComponentString(text)
DrawText(_x,_y)
    end
end

function updateCarroCompras()
    valor = 0
    for k, v in pairs(carroCompras) do
        if carroCompras[k] == true then
            valor = valor + Config_client['price']
        end
    end
    precoTotal = valor
    return valor
end

function parse_part(key)
    if type(key) == "string" and string.sub(key, 1, 1) == "p" then
        return tonumber(string.sub(key, 2))
    else
        return false, tonumber(key)
    end
end

RegisterNUICallback("trocarClasse", function(data, cb)
    dataPart = parts[data.part]
    local ped = PlayerPedId()
    if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
        SendNUIMessage({ 
            changeCategory = true, 
            sexo = "Male", prefix = "M", 
            drawa = vRP.getDrawables(dataPart), category = dataPart , url = Config_client['url'] 
        })
    elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then 
        SendNUIMessage({ 
            changeCategory = true, 
            sexo = "Female", prefix = "F", 
            drawa = vRP.getDrawables(dataPart), category = dataPart , url = Config_client['url'] 
        })
    end
end)

RegisterNUICallback("changeColor", function(data, cb)
    if type(dados) == "number" then
        max = GetNumberOfPedTextureVariations(PlayerPedId(), dados, tipo)
    elseif type(dados) == "string" then
        max = GetNumberOfPedPropTextureVariations(PlayerPedId(), parse_part(dados), tipo)
    end

    if data.action == "menos" then
        if cor > 0 then cor = cor - 1 else cor = max end
    elseif data.action == "mais" then
        if cor < max then cor = cor + 1 else cor = 0 end
    end
    if dados and tipo then setRoupa(dados, tipo, cor) end
end)

RegisterNUICallback("updateRotate", function(data, cb)
    if data.tipo == "rotacao" then
        SetEntityHeading(PlayerPedId(),f(data.valor))
    elseif data.tipo == "zoom" then
        if parseInt(data.valor) == 0 then
            Camera.currentView  = 'head'
            Activate(500)
        elseif parseInt(data.valor) == 1 then
            Camera.currentView  = 'body'
            Activate(500)
        elseif parseInt(data.valor) == 2 then
            Camera.currentView  = 'legs'
            Activate(500)
        elseif parseInt(data.valor) == 3 then
            Camera.currentView  = 'corpo'
            Activate(500)
        end
    end
end)

function Deactivate()
    local playerPed = PlayerPedId()
    SetCamActive(Camera.entity, false)
    RenderScriptCams(false, true, 500, true, true)
    FreezePedCameraRotation(playerPed, false)
    Camera.active = false
end

function Activate(delay)
   
    SetEntityHeading(PlayerPedId(),125.63)
    
    if not DoesCamExist(Camera.entity) then
        Camera.entity = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local playerPed = PlayerPedId()
    FreezePedCameraRotation(playerPed, true)


    SetViewcamera(Camera.currentView)

    SetCamActive(Camera.entity, true)
    RenderScriptCams(true, true, 500, true, true)

    Camera.active = true
end

function CalculatePosition(adjustedAngle)
    if adjustedAngle then
        Camera.angleX = Camera.angleX - Camera.mouseX * 0.1
        Camera.angleY = Camera.angleY + Camera.mouseY * 0.1
    end

    if Camera.angleY > Camera.angleYMax then
        Camera.angleY = Camera.angleYMax
    elseif Camera.angleY < Camera.angleYMin then
        Camera.angleY = Camera.angleYMin
    end

    local radiusMax = CalculateMaxRadius()
    
    local offsetX = ((Cos(Camera.angleX) * Cos(Camera.angleY)) + (Cos(Camera.angleY) * Cos(Camera.angleX))) / 2 * radiusMax
    local offsetY = ((Sin(Camera.angleX) * Cos(Camera.angleY)) + (Cos(Camera.angleY) * Sin(Camera.angleX))) / 2 * radiusMax
    local offsetZ = ((Sin(Camera.angleY))) * radiusMax

    local pedCoords = GetEntityCoords(PlayerPedId())

    return vector3(pedCoords.x + offsetX, pedCoords.y + offsetY, pedCoords.z + offsetZ)
end

function CalculateMaxRadius()
    if Camera.radius < Camera.radiusMin then
        Camera.radius = Camera.radiusMin
    elseif Camera.radius > Camera.radiusMax then
        Camera.radius = Camera.radiusMax
    end

    local result = Camera.radius

    local playerPed = PlayerPedId()
    local pedCoords = GetEntityCoords(playerPed)

    local behindX = pedCoords.x + ((Cos(Camera.angleX) * Cos(Camera.angleY)) + (Cos(Camera.angleY) * Cos(Camera.angleX))) / 2 * (Camera.radius + 0.5)
    local behindY = pedCoords.x + ((Sin(Camera.angleX) * Cos(Camera.angleY)) + (Cos(Camera.angleY) * Sin(Camera.angleX))) / 2 * (Camera.radius + 0.5)
    local behindZ = ((Sin(Camera.angleY))) * (Camera.radius + 0.5)

    local testRay = StartShapeTestRay(pedCoords.x, pedCoords.y, pedCoords.z + 0.5, behindX, behindY, behindZ, -1, playerPed, 0)
    local _, hit, hitCoords = GetShapeTestResult(testRay)
    local hitDist = Vdist(pedCoords.x, pedCoords.y, pedCoords.z + 0.5, hitCoords)

    if hit and hitDist < Camera.radius + 0.5 then
        result = hitDist
    end

    return result
end


function SetViewcamera(view)
    local boneIndex = -1
    if view == 'head' then
        boneIndex = 31086
        Camera.radiusMin    = 0.8
        Camera.radiusMax    = 1.0
        Camera.angleYMin    = 40.0
        Camera.angleYMax    = 60.0
        Camera.radius = Camera.radiusMin
        Camera.angleY = Camera.angleYMin
        Camera.angleX = GetEntityHeading(PlayerPedId()) + 90.0

        Camera.position = CalculatePosition(false)
        SetCamCoord(Camera.entity, Camera.position.x, Camera.position.y, Camera.position.z)

        targetPos = GetPedBoneCoords(PlayerPedId(), boneIndex, 0.0, 0.0, 0.0)
        PointCamAtCoord(Camera.entity, targetPos.x+0.6, targetPos.y, targetPos.z)

        Camera.currentView = view
    elseif view == 'body' then
        boneIndex = 11816
        Camera.radiusMin    = 1.0
        Camera.radiusMax    = 2.0
        Camera.angleYMin    = 0.0
        Camera.angleYMax    = 35.0
        Camera.radius = Camera.radiusMin
        Camera.angleY = Camera.angleYMin
        Camera.angleX = GetEntityHeading(PlayerPedId()) + 90.0

        Camera.position = CalculatePosition(false)
        SetCamCoord(Camera.entity, Camera.position.x, Camera.position.y, Camera.position.z)

        targetPos = GetPedBoneCoords(PlayerPedId(), boneIndex, 0.0, 0.0, 0.0)
        PointCamAtCoord(Camera.entity, targetPos.x+0.6, targetPos.y, targetPos.z)

        Camera.currentView = view
    elseif view == 'legs' then 
        boneIndex = 35502
        Camera.radiusMin    = 1.1
        Camera.radiusMax    = 1.25
        Camera.angleYMin    = -30.0
        Camera.angleYMax    = 20.0
        Camera.radius = Camera.radiusMin
        Camera.angleY = Camera.angleYMin
        Camera.angleX = GetEntityHeading(PlayerPedId()) + 90.0

        Camera.position = CalculatePosition(false)
        SetCamCoord(Camera.entity, Camera.position.x, Camera.position.y, Camera.position.z)

        targetPos = GetPedBoneCoords(PlayerPedId(), boneIndex, 0.0, 0.0, 0.0)
        PointCamAtCoord(Camera.entity, targetPos.x+1.2, targetPos.y, targetPos.z)

        Camera.currentView = view
    elseif view == "corpo" then
        boneIndex = 35502
        Camera.radiusMin    = 1.1
        Camera.radiusMax    = 1.25
        Camera.angleYMin    = -30.0
        Camera.angleYMax    = 20.0
        Camera.radius = Camera.radiusMin
        Camera.angleY = Camera.angleYMin
        Camera.angleX = GetEntityHeading(PlayerPedId()) + 90.0

        Camera.position = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)

        targetPos = GetEntityCoords(PlayerPedId())
        SetCamCoord(Camera.entity, Camera.position.x, Camera.position.y, Camera.position.z+0.75)
        PointCamAtCoord(Camera.entity, targetPos.x, targetPos.y-0.5, targetPos.z+0.25)

    end

end

function f(n)
n = n + 0.00000
return n
end

RegisterNUICallback("payament", function(data, cb)
    carroCompras = {
        mascara = false,
        mao = false,
        calca = false,
        mochila = false,
        sapato = false,
        gravata = false,
        camisa = false,
        colete = false,
        jaqueta = false,
        bone = false,
        oculos = false,
        brinco = false,
        relogio = false,
        bracelete = false
    }
    TriggerServerEvent("comprar:roupaDpn", tonumber(data.price)) 
end)

RegisterNetEvent('ComprarTudo')
AddEventHandler('ComprarTudo', function(comprar)

    if comprar then
        in_loja = false
        SendNUIMessage({ action = "hideMenu",value = 0 })
        deixarVisivel()
        SetNuiFocus(false, false)
        Deactivate()
        naroupas = false

    else
        in_loja = false
        vRP.setCustomization(old_custom)
        ClearPedTasks(PlayerPedId())
        SendNUIMessage({ action = "hideMenu",value = 0 })
        Deactivate()
        deixarVisivel()
        SetNuiFocus(false, false)
        naroupas = false

    end
end)