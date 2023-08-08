local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_hospital")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local macas = {
	{ ['x'] = 1137.2, ['y'] = -1585.3, ['z'] = 35.39, ['x2'] = 1136.19066040039, ['y2'] = -1585.39036865234, ['z2'] = 36.298081359863, ['h'] = 167.17 }, --  1136.19,-1585.39,36.29,0.13  OK
	{ ['x'] = 1141.11, ['y'] = -1585.2, ['z'] = 35.39, ['x2'] = 1140.16223876953, ['y2'] = -1585.41364135742, ['z2'] = 36.295056304932, ['h'] = 169.05 }, -- 1140.16,-1585.41,36.29,0.13  OK
	{ ['x'] = 1145.58, ['y'] = -1585.34, ['z'] = 35.39, ['x2'] = 1144.5418359375, ['y2'] = -1585.41545654297, ['z2'] = 36.295094451904, ['h'] = 169.03 }, -- 1144.54,-1585.41,36.29,0.13  OK
	{ ['x'] = 1149.89, ['y'] = -1585.33, ['z'] = 35.39, ['x2'] = 1148.8612097168, ['y2'] = -1585.41326293945, ['z2'] = 36.295067749023, ['h'] = 165.02 }, -- 1149.89,-1585.33,35.39,93.48 OK
	{ ['x'] = 1148.3, ['y'] = -1565.78, ['z'] = 35.39, ['x2'] = 1148.9380859375, ['y2'] = -1566.22529541016, ['z2'] = 36.135056304932, ['h'] = 354.21 },  -- 1148.3,-1565.78,35.39,269.13 OK

	{ ['x'] = 1141.54, ['y'] = -1566.76, ['z'] = 35.39, ['x2'] = 1140.71765014648, ['y2'] = -1566.58486083984, ['z2'] = 36.363225250244, ['h'] = 356.78 },  -- 1141.54,-1566.91,35.39,82.59 OK
	{ ['x'] = 1131.14, ['y'] = -1564.86, ['z'] = 35.39, ['x2'] = 1130.91868286133, ['y2'] = -1565.75246704102, ['z2'] = 36.42321762085, ['h'] = 80.41 }, -- 1131.14,-1565.03,35.39,135.06 OK
	{ ['x'] = 1130.87, ['y'] = -1556.97, ['z'] = 35.39, ['x2'] = 1130.45259643555, ['y2'] = -1556.29092529297, ['z2'] = 36.4271925354, ['h'] = 292.96 }, -- 1130.45,-1556.29,36.42,292.96 OK
	{ ['x'] = 1120.97, ['y'] = -1557.05, ['z'] = 35.39, ['x2'] = 1120.84208496094, ['y2'] = -1556.29083251953, ['z2'] = 36.421299285889, ['h'] = 257.75 }, -- 1120.84,-1556.29,36.42,257.75
	{ ['x'] = -462.83804321289, ['y'] = -289.67166137695, ['z'] = 34.91145324707, ['x2'] = -463.66763305664, ['y2'] = -289.97613525391, ['z2'] = 34.83321762085, ['h'] = 195.0 }, -- -463.66763305664,-289.97613525391,35.83321762085
	{ ['x'] = -466.10382080078, ['y'] = -291.07232666016, ['z'] = 34.911407470703, ['x2'] = -467.15826416016, ['y2'] = -291.02270507813, ['z2'] = 34.835056304932, ['h'] = 195.0 }, -- -467.15826416016,-291.02270507813,35.835056304932
	{ ['x'] = -464.42858886719, ['y'] = -295.99578857422, ['z'] = 34.910808563232, ['x2'] = -464.64932250977, ['y2'] = -295.31695556641, ['z2'] = 34.57364654541, ['h'] = 280.0 }, -- -464.64932250977,-295.31695556641,35.57364654541
	{ ['x'] = -447.15432739258, ['y'] = -290.48095703125, ['z'] = 34.910781860352, ['x2'] = -446.85586547852, ['y2'] = -291.11590576172, ['z2'] = 34.811901092529, ['h'] = 280.0 } -- -446.85586547852,-291.11590576172,35.811901092529
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEITANDO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local hospital = 1000
		for k,v in pairs(macas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 1.1 then
				hospital = 5
				DrawText3Ds(v.x,v.y,v.z,"~g~E~w~   DEITAR")
				if IsControlJustPressed(0,38) then
					SetEntityCoords(ped,v.x2,v.y2,v.z2)
					SetEntityHeading(ped,v.h)
					TriggerEvent("emotes","deitar3")
				end
				--[[if IsControlJustPressed(0,47) then
					if emP.checkServices() then
						TriggerEvent('tratamento-macas')
						SetEntityCoords(ped,v.x2,v.y2,v.z2)
						SetEntityHeading(ped,v.h)
						vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
					else
						TriggerEvent("Notify","amarelo","Existem paramédicos em serviço.")
					end
				end]]
			end
		end
		Citizen.Wait(hospital)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
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
function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 400
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end

RegisterNetEvent('tratamento-macas')
AddEventHandler('tratamento-macas',function()
	TriggerEvent("cancelando",true)
	repeat
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+1)
		Citizen.Wait(2000)
	until GetEntityHealth(PlayerPedId()) >= 300 or GetEntityHealth(PlayerPedId()) <= 100
		TriggerEvent("Notify","roxo","Tratamento concluido.")
		TriggerEvent("cancelando",false)
end)