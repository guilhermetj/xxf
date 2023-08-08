local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
func = Tunnel.getInterface("vrp_chuveiro")

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        print(true)

    end
end)]]

local chuveiros = {
    ["chuveiro"] = { ["text"] = "CHUVEIRO", ["text2"] = "PRESSIONE ~b~E~w~ PARA LIMPAR O SANGUE", ['x'] = -435.56, ['y'] = -305.28, ['z'] = 35.08 },  
    ["chuveiro"] = { ["text"] = "CHUVEIRO", ["text2"] = "PRESSIONE ~b~E~w~ PARA LIMPAR O SANGUE", ['x'] = 2529.07, ['y'] = -329.2, ['z'] = 94.1 },

}
local chuveiros_otmz = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        chuveiros_otmz = {}
        for k,v in pairs(chuveiros) do
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
            local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
            if distance < 2.5 then  
                chuveiros_otmz[k] = chuveiros[k]
            end
        end    
    end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
        for k,v in pairs(chuveiros_otmz) do
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
            local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
            if distance < 2.5 then  
                DrawText3D(v.x,v.y,v.z, v.text, 1.2, 4, 100)
                DrawText3D(v.x,v.y,v.z-0.2, v.text2, 1.0, 4, 100)
                if distance < 4 and IsControlPressed(0,38) then
                    DoScreenFadeOut(1000)
                    Citizen.Wait(2000)
                    ClearPedBloodDamage(ped)
                    Citizen.Wait(500)
                    DoScreenFadeIn(1000)
                end    
            end     

        end    
    end
end)

RegisterCommand("chuveiro",function()
    local ped = GetPlayerPed(-1)
    ClearPedBloodDamage(ped)
    --print("limpado")
end)

function DrawText3D(x,y,z, text, scl, font, opacity) 
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
	local scale = (1/dist)*scl
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov
   
	if onScreen then
		SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, opacity)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
	end
end
