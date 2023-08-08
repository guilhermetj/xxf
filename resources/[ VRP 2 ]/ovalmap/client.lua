local currentPos
local isPause = false
local uiHidden = false

RegisterCommand('minimap',function(source, args) 
    local type = args[1]
    if args[1] == 'left' then
        TriggerEvent('refreshMinimap', 'left', 500)
    elseif args[1] == 'right' then
        TriggerEvent('refreshMinimap', 'right', 500)
    else
        TriggerEvent('NLCore:Notify', "comando inválido... posições disponíveis são: [left/right]")
    end
end)

RegisterNetEvent('refreshMinimap')
AddEventHandler('refreshMinimap', function(type, time) 
    currentPos = type
    if type == 'left' then
        Citizen.Wait(time)
        print('refreshing left minimap')
        uiHidden = true
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
        SetMinimapClipType(1)
        SetMinimapComponentPosition('minimap', 'L', 'B', -0.01, 0.0, 0.160, 0.26)
        SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.05, 0.00, 0.1, 0.14)
        SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01, 0.025, 0.256, 0.337)
        local minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Wait(0)
        SetRadarBigmapEnabled(false, false)
    elseif type == 'right' then
        Citizen.Wait(time)
        print('refreshing right minimap')
        uiHidden = true
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
        SetMinimapClipType(1)
        SetMinimapComponentPosition('minimap', 'R', 'B', 0.0, 0.0, 0.150, 0.26)
        SetMinimapComponentPosition('minimap_mask', 'R', 'B', 0.0, 0.00, 0.1, 0.14)
        SetMinimapComponentPosition('minimap_blur', 'R', 'B', 0.09+0.007, 0.025, 0.256, 0.337)
        local minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Wait(0)
        SetRadarBigmapEnabled(false, false)
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsBigmapActive() or IsPauseMenuActive() and not isPause or IsRadarHidden() then
            if not uiHidden and currentPos == 'left' then
                -- SendNUIMessage({
                --     action = "hideLeftUI"
                -- })
                uiHidden = true
            elseif not uiHidden and currentPos == 'right' then
                -- SendNUIMessage({
                --     action = "hideRightUI"
                -- })
                uiHidden = true
            end
        elseif uiHidden and currentPos == 'left' or IsPauseMenuActive() and isPause then
            -- print(currentPos)
            -- SendNUIMessage({
            --     action = "displayLeftUI"
            -- })
            uiHidden = false
        elseif uiHidden and currentPos == 'right' or IsPauseMenuActive() and isPause then
            -- print(currentPos)
            -- SendNUIMessage({
            --     action = "displayRightUI"
            -- })
            uiHidden = false
        end
    end
end)


AddEventHandler('onClientResourceStart',function(resourceName) 
    if resourceName == 'ovalmap' then
        TriggerEvent('refreshMinimap', 'left', 500)
    end
end)