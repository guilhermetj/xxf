local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("jewelry")
func2 = {}
Tunnel.bindInterface("jewelry",func2)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local andamento = false
local tipo = 0
local segundos = 0
local c4 = nil
local bag = nil
local coordenadaX = -631.39
local coordenadaY = -230.25
local coordenadaZ = 38.05
local statuses = false

local bombLocs = {
	{ -631.29,-237.43,38.08,305.32 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DO ROUBO
-----------------------------------------------------------------------------------------------------------------------------------------
local locais = {
	{ ['id'] = 1 , ['x'] = -626.3253 , ['y'] = -239.0511 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab2_end" , ['prop1'] = "des_jewel_cab2_start", ['xplayer'] = -626.80908203125, ['yplayer'] = -238.34339904785, ['zplayer'] = 38.057006835938, ['heading'] = 221.73 },
	{ ['id'] = 2 , ['x'] = -625.2751 , ['y'] = -238.2881 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab3_end" , ['prop1'] = "des_jewel_cab3_start", ['xplayer'] = -625.80285644531, ['yplayer'] = -237.60856628418, ['zplayer'] = 38.056999206543, ['heading'] = 221.73 },
	{ ['id'] = 3 , ['x'] = -626.5439 , ['y'] = -233.6047 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab_end" , ['prop1'] = "des_jewel_cab_start", ['xplayer'] = -627.08929443359, ['yplayer'] = -232.89517211914, ['zplayer'] = 38.057006835938, ['heading'] = 221.73 }, 
	{ ['id'] = 4 , ['x'] = -626.1613 , ['y'] = -234.1315 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab4_end" , ['prop1'] = "des_jewel_cab4_start", ['xplayer'] = -625.57720947266, ['yplayer'] = -234.80921936035, ['zplayer'] = 38.057010650635, ['heading'] = 31.56 },
	{ ['id'] = 5 , ['x'] = -627.2115 , ['y'] = -234.8942 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab3_end" , ['prop1'] = "des_jewel_cab3_start", ['xplayer'] = -626.64904785156, ['yplayer'] = -235.61465454102, ['zplayer'] = 38.05700302124, ['heading'] = 31.56 },
	{ ['id'] = 6 , ['x'] = -619.8483 , ['y'] = -234.9137 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab_end" , ['prop1'] = "des_jewel_cab_start", ['xplayer'] = -620.44061279297, ['yplayer'] = -234.19891357422, ['zplayer'] = 38.056999206543, ['heading'] = 221.73 },
	{ ['id'] = 7 , ['x'] = -617.0856 , ['y'] = -230.1627 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab2_end" , ['prop1'] = "des_jewel_cab2_start", ['xplayer'] = -617.83697509766, ['yplayer'] = -230.68539428711, ['zplayer'] = 38.057006835938, ['heading'] = 306.23 },
	{ ['id'] = 8 , ['x'] = -617.8492 , ['y'] = -229.1128 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab3_end" , ['prop1'] = "des_jewel_cab3_start", ['xplayer'] = -618.51141357422, ['yplayer'] = -229.69427490234, ['zplayer'] = 38.056999206543, ['heading'] = 306.23 },
	{ ['id'] = 9 , ['x'] = -621.5175 , ['y'] = -228.9474 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab3_end" , ['prop1'] = "des_jewel_cab3_start", ['xplayer'] = -620.89727783203, ['yplayer'] = -228.3892364502, ['zplayer'] = 38.057006835938, ['heading'] = 127.12 },
	{ ['id'] = 10 , ['x'] = -619.9662 , ['y'] = -226.198 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab_end" , ['prop1'] = "des_jewel_cab_start", ['xplayer'] = -620.61871337891, ['yplayer'] = -226.81732177734, ['zplayer'] = 38.057006835938, ['heading'] = 306.23 },
	{ ['id'] = 11 , ['x'] = -625.3300 , ['y'] = -227.3697 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab3_end" , ['prop1'] = "des_jewel_cab3_start", ['xplayer'] = -624.95703125, ['yplayer'] = -228.04200744629, ['zplayer'] = 38.057010650635, ['heading'] = 31.56 },
	{ ['id'] = 12 , ['x'] = -623.6147 , ['y'] = -228.6247 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab2_end" , ['prop1'] = "des_jewel_cab2_start", ['xplayer'] = -624.16003417969, ['yplayer'] = -227.90766906738, ['zplayer'] = 38.057006835938, ['heading'] = 221.73 },
	{ ['id'] = 13 , ['x'] = -623.9558 , ['y'] = -230.7263 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab4_end" , ['prop1'] = "des_jewel_cab4_start", ['xplayer'] = -624.64788818359, ['yplayer'] = -231.24926757813, ['zplayer'] = 38.057006835938, ['heading'] = 306.23 },
	{ ['id'] = 14 , ['x'] = -624.2796 , ['y'] = -226.6066 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab4_end" , ['prop1'] = "des_jewel_cab4_start", ['xplayer'] = -623.79742431641, ['yplayer'] = -227.30368041992, ['zplayer'] = 38.05700302124, ['heading'] = 31.56 },
	{ ['id'] = 15 , ['x'] = -619.2031 , ['y'] = -227.2482 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab2_end" , ['prop1'] = "des_jewel_cab2_start", ['xplayer'] = -619.91357421875, ['yplayer'] = -227.81005859375, ['zplayer'] = 38.057006835938, ['heading'] = 306.23 },
	{ ['id'] = 16 , ['x'] = -620.1764 , ['y'] = -230.7865 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab_end" , ['prop1'] = "des_jewel_cab_start", ['xplayer'] = -619.44543457031, ['yplayer'] = -230.30876159668, ['zplayer'] = 38.057022094727, ['heading'] = 127.12 },
	{ ['id'] = 17 , ['x'] = -620.5214 , ['y'] = -232.8823 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab4_end" , ['prop1'] = "des_jewel_cab4_start", ['xplayer'] = -620.04870605469, ['yplayer'] = -233.48422241211, ['zplayer'] = 38.057006835938, ['heading'] = 31.56 },
	{ ['id'] = 18 , ['x'] = -622.6159 , ['y'] = -232.5636 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab_end" , ['prop1'] = "des_jewel_cab_start", ['xplayer'] = -623.3056640625, ['yplayer'] = -233.11682128906, ['zplayer'] = 38.057010650635, ['heading'] = 306.23 },
	{ ['id'] = 19 , ['x'] = -627.5945 , ['y'] = -234.3678 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab_end" , ['prop1'] = "des_jewel_cab_start", ['xplayer'] = -628.11602783203, ['yplayer'] = -233.64642333984, ['zplayer'] = 38.057010650635, ['heading'] = 221.73 },
	{ ['id'] = 20 , ['x'] = -618.7984 , ['y'] = -234.1509 , ['z'] = 37.64523 , ['prop2'] = "des_jewel_cab3_end" , ['prop1'] = "des_jewel_cab3_start", ['xplayer'] = -619.36053466797, ['yplayer'] = -233.41262817383, ['zplayer'] = 38.057014465332, ['heading'] = 221.73 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETORNAR
-----------------------------------------------------------------------------------------------------------------------------------------
function func2.setCoord(xplayer,yplayer,zplayer,heading)
	SetEntityCoords(PlayerPedId(),xplayer,yplayer,zplayer-1)
	SetEntityHeading(PlayerPedId(),heading)
end

function func2.setModel(x,y,z,prop1,prop2)
	RemoveModelSwap(x,y,z,0.2,GetHashKey(prop1),GetHashKey(prop2),false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK MODEL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		if GetDistanceBetweenCoords(-622.18,-230.92,38.05,x,y,z,true) <= 20 and not func.returnJewelry2() then
			for _,v in pairs(locais) do
				func.returnJewels(v.id,v.x,v.y,v.z,v.prop1,v.prop2)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		if not jewelryStart then

			for k,v in pairs(bombLocs) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 4
					if IsControlJustPressed(1,47) and func.jewelryCheckItens() then
						SetEntityHeading(ped,v[4])
						TriggerEvent("cancelando",true)
						SetEntityCoords(ped,v[1]-0.45,v[2]-0.45,v[3]-1)
						startC4()
					end
				end
			end
        end
		Citizen.Wait(timeDistance)
	end
end)

function startC4()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		plantando = true
		local c4_hash = GetHashKey("prop_c4_final_green")
		local bag_hash = GetHashKey('p_ld_heist_bag_s_pro_o')
		RequestModel(c4_hash)
		while not HasModelLoaded(c4_hash) do
			RequestModel(c4_hash)
			Citizen.Wait(10)
		end
		Wait(20)
		RequestModel(bag_hash)
		while not HasModelLoaded(bag_hash) do
			RequestModel(bag_hash)
			Citizen.Wait(100)
		end
		Wait(10)
		if HasModelLoaded(c4_hash) and HasModelLoaded(bag_hash) then
			local c4 = CreateObject(c4_hash,coords,true,false,false)
			local bag = CreateObject(bag_hash, coords-20, true, false)
			SetEntityAsMissionEntity(c4, true, true)
			SetEntityAsMissionEntity(bag, true, true)
			local boneIndexf1 = GetPedBoneIndex(PlayerPedId(), 28422)
			local bagIndex1 = GetPedBoneIndex(PlayerPedId(), 57005)
			vRP._playAnim(false,{'anim@heists@ornate_bank@thermal_charge','thermal_charge'},false)
		Citizen.Wait(500)
			SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
			AttachEntityToEntity(c4, PlayerPedId(), boneIndexf1, 0.0,0.0,0.1,0.0,85.0,-90.0, 0, 1, 1, 0, 1, 1, 1)
			AttachEntityToEntity(bag, PlayerPedId(), bagIndex1, 0.3, -0.25, -0.3, 300.0, 200.0, 300.0, true, true, false, true, 1, true)
		Wait(1700)
			DetachEntity(bag, 1, 1)
			FreezeEntityPosition(bag, true)
		Wait(2600)
			FreezeEntityPosition(bag, false)
			AttachEntityToEntity(bag, PlayerPedId(), bagIndex1, 0.3, -0.25, -0.3, 300.0, 200.0, 300.0, true, true, false, true, 1, true)
		Wait(1100)
			DetachEntity(c4, 1, 1)
			FreezeEntityPosition(c4, true)
		Wait(150)
			TriggerServerEvent("tryDeleteEntity",ObjToNet(bag))
			SetPedComponentVariation(PlayerPedId(), 5, 40, 0, 0)
			vRP._stopAnim(false)
		Wait(100)
			TriggerEvent('cancelando',false,false)
			local particleDictionary = "scr_adversary"
			local particleName = "scr_emp_prop_light"		
			RequestNamedPtfxAsset(particleDictionary)
			while not HasNamedPtfxAssetLoaded(particleDictionary) do
				Citizen.Wait(100)
			end			
			SetPtfxAssetNextCall(particleDictionary)
			effect = StartParticleFxLoopedOnEntity(particleName, c4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.20, 0, 0, 0)
			beepSound = GetSoundId()
			PlaySoundFromEntity(beepSound, "Timer_10s", c4, "DLC_HALLOWEEN_FVJ_Sounds", 1, 0)
			TriggerEvent("Notify","amarelo","Você plantou a C4. <b>Afaste-se!</b><br>A C4 será acionada em <b>10 segundos</b>",8000)						
		SetTimeout(10000,function()
			FreezeEntityPosition(c4, false)

			TriggerServerEvent("doors:doorsStatistics",17,false)
			TriggerServerEvent("tryDeleteEntity",ObjToNet(c4))
			AddExplosion(coords,2,100.0,true,false,true)
			func.jewelryUpdateStatus(true)
			bag = nil
			c4 = nil
		end)
		end
	end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HACKEAR O SISTEMA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		local timeDistance = 500
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local distance = GetDistanceBetweenCoords(coordenadaX,coordenadaY,coordenadaZ,x,y,z,true)
		if distance <= 1.1 and not andamento then
			timeDistance = 4
			if not UsingComputer then
			    DrawText3Ds(coordenadaX,coordenadaY,coordenadaZ+0.4,"~b~[E] ~w~HACKEAR")
			    if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) and not func.returnJewelry2() then
				    func.checkJewelry(coordenadaX,coordenadaY,coordenadaZ,213.52,10,1)
			    end
			end
		end
		if andamento and tipo == 1 then
		    if statuses then	
				statuses = not statuses
			else
			    if segundos == 1 then
			        DrawText3Ds(coordenadaX,coordenadaY,coordenadaZ+0.4,"~b~"..segundos.." SEGUNDO ~w~PARA HACKEAR")
			    else
			        DrawText3Ds(coordenadaX,coordenadaY,coordenadaZ+0.4,"~b~"..segundos.." SEGUNDOS ~w~PARA HACKEAR")
			    end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUBANDO AS JOIAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		local timeDistance = 500
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local distance = GetDistanceBetweenCoords(-622.18,-230.92,38.05,x,y,z,true)
		if distance <= 20 then
		    for _,v in pairs(locais) do
		    	local distance2 = GetDistanceBetweenCoords(v.x,v.y,v.z,x,y,z,true)
			    if distance2 <= 1.3 and not andamento then
					timeDistance = 4
				    if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
				    	if func.returnJewelry() then
						    if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_ASSAULTRIFLE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SMG") then
					            func.checkJewels(v.id,v.x,v.y,v.z,v.xplayer,v.yplayer,v.zplayer,v.heading,v.prop1,v.prop2,2)
					        else
					            TriggerEvent("Notify","vermelho","Voce precisa estar com uma <b>AK-103</b> ou uma <b>SMG</b> em suas maos.",5000)
				            end
				        else
						    TriggerEvent("Notify","vermelho","Hackeie as <b>cameras</b> para roubar as <b>joias</b>.",5000)
					    end
				    end
			    end
		    end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIANDO O ROUBO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iniciandojewelry")
AddEventHandler("iniciandojewelry",function(x,y,z,h,sec,mod,status)
	andamento = status
	if status then
		tipo = mod
		segundos = sec
		ClearPedTasks(PlayerPedId())
		SetEntityHeading(PlayerPedId(),h)
		SetEntityCoords(PlayerPedId(),x,y,z-1,false,false,false,false)
		SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
		TriggerEvent('cancelando',true)
	else
		TriggerEvent('cancelando',false)
		ClearPedTasks(PlayerPedId())
	end
end)

RegisterNetEvent("jewelryroubo")
AddEventHandler("jewelryroubo",function(sec,mod,status,x,y,z,prop1,prop2,id)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	andamento = status
	if status then
        if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
	        RequestNamedPtfxAsset("scr_jewelheist")
        end
        while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
	        Citizen.Wait(0)
        end
        Wait(300)
		tipo = mod
		segundos = sec
		ClearPedTasks(PlayerPedId())
		TriggerEvent('cancelando',true)
        SetPtfxAssetNextCall("scr_jewelheist")
		StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", x,y,z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
		loadAnimDict( "missheist_jewel" ) 
		if id == 4 or id == 13 or id == 14 or id == 17 then
			local random = math.random(1,2)
			if random == 1 then
		        TaskPlayAnim(ped, "missheist_jewel", "smash_case_tray_b", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		        TriggerEvent("progress",1700,"roubando")
		        SetTimeout(1700,function()
		    	    PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		            StopAnimTask(ped,"missheist_jewel","smash_case_tray_b",1.0)
		            TriggerEvent('cancelando',false)
		        end)
		    else
		    	TaskPlayAnim(ped, "missheist_jewel", "smash_case_necklace_skull", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
		    	TriggerEvent("progress",2000,"roubando")
			    SetTimeout(2000,function()
			    	PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		            StopAnimTask(ped,"missheist_jewel","smash_case_necklace_skull",1.0)
		            TriggerEvent('cancelando',false)
		        end)
		    end
		    Wait(350)
		    TriggerEvent("sounds:source",'vidroquebrado',0.8)
	        TriggerServerEvent("jewelrysetmodel",x,y,z,prop1,prop2)
		else
			local random = math.random(1,2)
			if random == 1 then
			    TaskPlayAnim(ped, "missheist_jewel", "smash_case_b", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			    TriggerEvent("progress",3800,"roubando")
			    SetTimeout(3800,function()
		            StopAnimTask(ped,"missheist_jewel","smash_case_b",1.0)
		            TriggerEvent('cancelando',false)
		        end)
		        SetTimeout(3200,function()
		            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		        end)
			else
				TaskPlayAnim(ped, "missheist_jewel", "smash_case_f", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			    TriggerEvent("progress",2700,"roubando")
			    SetTimeout(2700,function()
		            StopAnimTask(ped,"missheist_jewel","smash_case_f",1.0)
		            TriggerEvent('cancelando',false)
		        end)
		        SetTimeout(1800,function()
		            PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		        end)
			end
			Wait(350)
		    TriggerEvent("sounds:source",'vidroquebrado',0.8)
	        TriggerServerEvent("jewelrysetmodel",x,y,z,prop1,prop2)
		end 
	end
end)

RegisterNetEvent("jewelrysetmodel")
AddEventHandler("jewelrysetmodel",function(x,y,z,prop1,prop2)
	CreateModelSwap(x,y,z,0.2,GetHashKey(prop1),GetHashKey(prop2),false)

end)

RegisterNetEvent("iniciandojewelrystart")
AddEventHandler("iniciandojewelrystart",function()
	FreezeEntityPosition(PlayerPedId(),true)
	scaleform = Initialize("HACKING_PC")
    UsingComputer = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if andamento then
			segundos = segundos - 1
			if segundos <= 0 then
				tipo = 0
				andamento = false
				ClearPedTasks(PlayerPedId())
				TriggerEvent('cancelando',false)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/400
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

local newsScaleFormCounter = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		if newsScaleFormCounter > 0 then
			newsScaleFormCounter = newsScaleFormCounter - 1
		end
	end
end)

RegisterNetEvent("jewelry:bankNews")
AddEventHandler("jewelry:bankNews", function(counter)
	newsScaleFormCounter = counter
	PlaySound(-1, "RANK_UP", "HUD_AWARDS", 0, 0, 1)
end)

local PalavrasSenha = "TRANCADO"
local Ipfinished = false

Citizen.CreateThread(function()
	local scaleform2 = RequestScaleformMovie("BREAKING_NEWS")
	while not HasScaleformMovieLoaded(scaleform2) do
		Citizen.Wait(100)
	end
	if HasScaleformMovieLoaded(scaleform2) then

		PushScaleformMovieFunction(scaleform2, "SET_DISPLAY_CONFIG")
		PushScaleformMovieFunctionParameterInt(1920)
		PushScaleformMovieFunctionParameterInt(1080)
		PushScaleformMovieFunctionParameterFloat(0.5)
		PushScaleformMovieFunctionParameterFloat(0.5)
		PushScaleformMovieFunctionParameterFloat(0.5)
		PushScaleformMovieFunctionParameterFloat(0.5)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PopScaleformMovieFunctionVoid()
		
		PushScaleformMovieFunction(scaleform2, "SET_TEXT")
		PushScaleformMovieFunctionParameterString("Assalto a Joalheria!")
		PushScaleformMovieFunctionParameterString("<b>Policiais</b> a ~r~Caminho!</b>")
		PopScaleformMovieFunctionVoid()
		
		PushScaleformMovieFunction(scaleform2, "SET_SCROLL_TEXT")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterString("~r~Noticia de Última Hora")
		PopScaleformMovieFunctionVoid()
	
		PushScaleformMovieFunction(scaleform2, "DISPLAY_SCROLL_TEXT")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(100)
		PopScaleformMovieFunctionVoid()	
		while true do
			Citizen.Wait(1)
			if newsScaleFormCounter > 0 then
				DrawScaleformMovieFullscreen(scaleform2, 255, 255, 255, 255)
			end
        end
	end
end)

Citizen.CreateThread(function()
    function Initialize(scaleform)
        local scaleform = RequestScaleformMovieInteractive(scaleform)
        while not HasScaleformMovieLoaded(scaleform) do
            Citizen.Wait(0)
        end
        
        local CAT = 'hack'
        local CurrentSlot = 0
        while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
            Citizen.Wait(0)
            CurrentSlot = CurrentSlot + 1
        end
        
        if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
            ClearAdditionalText(CurrentSlot, true)
            RequestAdditionalText(CAT, CurrentSlot)
            while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
                Citizen.Wait(0)
            end
        end

        PushScaleformMovieFunction(scaleform, "SET_LABELS")
        ScaleformLabel("H_ICON_1")
        ScaleformLabel("H_ICON_2")
        ScaleformLabel("H_ICON_3")
        ScaleformLabel("H_ICON_4")
        ScaleformLabel("H_ICON_5")
        ScaleformLabel("H_ICON_6")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_BACKGROUND")
        PushScaleformMovieFunctionParameterInt(1)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
        PushScaleformMovieFunctionParameterFloat(1.0)
        PushScaleformMovieFunctionParameterFloat(4.0)
        PushScaleformMovieFunctionParameterString("Meu Computador")
        PopScaleformMovieFunctionVoid()
        
        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
        PushScaleformMovieFunctionParameterFloat(6.0)
        PushScaleformMovieFunctionParameterFloat(6.0)
        PushScaleformMovieFunctionParameterString("Desligar")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_LIVES")
        PushScaleformMovieFunctionParameterInt(lives)
        PushScaleformMovieFunctionParameterInt(5)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_LIVES")
        PushScaleformMovieFunctionParameterInt(lives)
        PushScaleformMovieFunctionParameterInt(5)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(1)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(2)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(3)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(4)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(5)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(6)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(7)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()
        

        return scaleform
    end
    scaleform = Initialize("HACKING_PC")
    while true do
        Citizen.Wait(0)
        if UsingComputer then
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            PushScaleformMovieFunction(scaleform, "SET_CURSOR")
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
            PopScaleformMovieFunctionVoid()
            if IsDisabledControlJustPressed(0,24) and not SorF then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                ClickReturn = PopScaleformMovieFunction()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 176) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                ClickReturn = PopScaleformMovieFunction()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 25) and not Hacking and not SorF then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_BACK")
                PopScaleformMovieFunctionVoid()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 172) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(8)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 173) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(9)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 174) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(10)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 175) and Hacking then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
                PushScaleformMovieFunctionParameterInt(11)
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
		    end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if HasScaleformMovieLoaded(scaleform) and UsingComputer then
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            if GetScaleformMovieFunctionReturnBool(ClickReturn) then
                ProgramID = GetScaleformMovieFunctionReturnInt(ClickReturn)
                if ProgramID == 83 and not Hacking and Ipfinished then
                    chanceshack = 5
                    
                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(chanceshack)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(1.0)
                    PopScaleformMovieFunctionVoid()
                    
                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_WORD")
                    PushScaleformMovieFunctionParameterString(PalavrasSenha)
                    PopScaleformMovieFunctionVoid()

                    Hacking = true
                elseif ProgramID == 82 and not Hacking and not Ipfinished then
                    chanceshack = 5

                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(chanceshack)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(0.0)
                    PopScaleformMovieFunctionVoid()

                    Hacking = true
                elseif Hacking and ProgramID == 87 then
                    chanceshack = chanceshack - 1
                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(chanceshack)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                elseif Hacking and ProgramID == 84 then
                	Ipfinished = true
                    PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
                    PushScaleformMovieFunction(scaleform, "SET_IP_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    ScaleformLabel(0x18EBB648)
                    PopScaleformMovieFunctionVoid()
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                elseif Hacking and ProgramID == 85 then
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                    SorF = false
                elseif Hacking and ProgramID == 92 then
                    PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
                elseif Hacking and ProgramID == 86 then
                    SorF = true
                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    ScaleformLabel("WINBRUTE")
                    PopScaleformMovieFunctionVoid()
                    Wait(0)
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                    SorF = false    
                    mHacking = false
                    Ipfinished = false
                    TriggerEvent("Notify","verde","A proteção das <b>câmeras</b> de <b>segurança</b> foi comprometida, vá até os balcoes e <b>roube</b> as <b>joias</b>, voce ganhara <b>90</b> segundos de vantagem até que a <b>polícia</b> seja acionada.")
                    TriggerServerEvent("jewelrystart")
                    SetTimeout(90000,function()
                        vRP.setStandBY(parseInt(300))
		                func.callPolice(-631.39,-230.25,38.05)
		            end)
                    TriggerEvent('cancelando',false)
                    Wait(1000)
                elseif ProgramID == 6 then
                    UsingComputer = false
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                    FreezeEntityPosition(PlayerPedId(), false)
                    Ipfinished = false
                    Hacking = false
                    SorF = false    
                    mHacking = false
                    TriggerEvent('cancelando',false)
                end
                
                if Hacking then
                    PushScaleformMovieFunction(scaleform, "SHOW_LIVES")
                    PushScaleformMovieFunctionParameterBool(true)
                    PopScaleformMovieFunctionVoid()
                    if chanceshack <= 0 then
                        SorF = true
                        PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                        PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(false)
                        ScaleformLabel("LOSEBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Wait(5000)
                        ClearPedTasks(PlayerPedId())
                        PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        SetScaleformMovieAsNoLongerNeeded(scaleform)
                        Hacking = false
                        SorF = false
                        mHacking = false
                        Ipfinished = false
                        TriggerEvent('cancelando',false)
                        TriggerEvent("Notify","amarelo","Voce falhou em <b>hackear</b> as cameras de segurança, sua conexão foi <b>bloqueada</b> e chamou a <b>polícia</b>.")
                        FreezeEntityPosition(PlayerPedId(),false)
                        func.callPolice(-631.39,-230.25,38.0)
                        vRP.setStandBY(parseInt(300))
                    end
                end
            end
        else
            Wait(250)
        end
    end
end)

function ScaleformLabel(label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString()
end