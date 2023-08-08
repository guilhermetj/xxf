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
Tunnel.bindInterface("vrp_player",cnVRP)
vSERVER = Tunnel.getInterface("vrp_player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMADEATH
-----------------------------------------------------------------------------------------------------------------------------------------
local dX,dY,dZ = 294.78,-1351.17,24.54
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(dX,dY,dZ))
			if distance <= 2.5 then
				timeDistance = 4
				DrawText3D(dX,dY,dZ,"~g~E~w~   MORTE PERMANENTE")
				DrawMarker(23,dX,dY,dZ-0.98,0,0,0,0,0,0,5.0,5.0,1.0,255,0,0,25,0,0,0,0)
				if IsControlJustPressed(1,38) then
					vSERVER.deleteChar()
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,100)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 450
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30*30000)
		TriggerServerEvent("vrp_player:salary")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO
-----------------------------------------------------------------------------------------------------------------------------------------
local cancelando = false
RegisterNetEvent("cancelando")
AddEventHandler("cancelando",function(status)
	cancelando = status
end)

-- DRIFT------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        if IsPedInAnyVehicle(ped) then
            local speed = GetEntitySpeed(vehicle)*2.236936
            if GetPedInVehicleSeat(vehicle,-1) == ped 
                and (GetEntityModel(vehicle) ~= GetHashKey("coach") 
                    and GetEntityModel(vehicle) ~= GetHashKey("bus") 
                    and GetEntityModel(vehicle) ~= GetHashKey("youga2") 
                    and GetEntityModel(vehicle) ~= GetHashKey("ratloader") 
                    and GetEntityModel(vehicle) ~= GetHashKey("taxi") 
                    and GetEntityModel(vehicle) ~= GetHashKey("boxville4") 
                    and GetEntityModel(vehicle) ~= GetHashKey("trash2") 
                    and GetEntityModel(vehicle) ~= GetHashKey("tiptruck") 
                    and GetEntityModel(vehicle) ~= GetHashKey("rebel") 
                    and GetEntityModel(vehicle) ~= GetHashKey("speedo") 
                    and GetEntityModel(vehicle) ~= GetHashKey("phantom") 
                    and GetEntityModel(vehicle) ~= GetHashKey("packer") 
                    and GetEntityModel(vehicle) ~= GetHashKey("paramedicoambu")) then
                    if speed <= 100.0 then
                    if IsControlPressed(1,21) then
                        SetVehicleReduceGrip(vehicle,true)
                    else
                        SetVehicleReduceGrip(vehicle,false)
                    end
                end
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCANCELANDO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if cancelando then
			timeDistance = 4
			DisableControlAction(1,73,true)
			DisableControlAction(1,29,true)
			DisableControlAction(1,47,true)
			DisableControlAction(1,187,true)
			DisableControlAction(1,189,true)
			DisableControlAction(1,190,true)
			DisableControlAction(1,188,true)
			DisableControlAction(1,311,true)
			DisableControlAction(1,245,true)
			DisableControlAction(1,257,true)
			DisableControlAction(1,167,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,137,true)
			DisableControlAction(1,37,true)
			DisableControlAction(1,38,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end
		Citizen.Wait(timeDistance)
	end
end)

------------------------------------------------------------------------------------------
-- HUD COLOR
------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    ReplaceHudColour(116, 151)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIVING
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.setDiving()
	local ped = PlayerPedId()
	if IsPedSwimming(ped) then
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,8,123,0,2)
			SetPedPropIndex(ped,1,26,0,2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,8,153,0,2)
			SetPedPropIndex(ped,1,28,0,2)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATSHUFFLE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) and not IsPedOnAnyBike(ped) then
			local veh = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(veh,0) == ped then
				timeDistance = 4
				if not GetIsTaskActive(ped,164) and GetIsTaskActive(ped,165) then
					SetPedIntoVehicle(ped,veh,0)
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
local energetic = 0
RegisterNetEvent("setEnergetic")
AddEventHandler("setEnergetic",function(timers,number)
	energetic = timers
	SetRunSprintMultiplierForPlayer(PlayerId(),number)
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if energetic > 0 then
			timeDistance = 4
			RestorePlayerStamina(PlayerId(),1.0)
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		if energetic > 0 then
			energetic = energetic - 1

			if energetic <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				energetic = 0
				SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETECSTASY
-----------------------------------------------------------------------------------------------------------------------------------------
local ecstasy = 0
RegisterNetEvent("setEcstasy")
AddEventHandler("setEcstasy",function()
	ecstasy = ecstasy + 10

	if not GetScreenEffectIsActive("MinigameTransitionIn") then
		StartScreenEffect("MinigameTransitionIn",0,true)
	end
end)

Citizen.CreateThread(function()
	while true do
		if ecstasy > 0 then
			ecstasy = ecstasy - 1
			ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.05)

			if ecstasy <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				ecstasy = 0

				TriggerServerEvent("upgradeStress",100)
				if GetScreenEffectIsActive("MinigameTransitionIn") then
					StopScreenEffect("MinigameTransitionIn")
				end
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMETH
-----------------------------------------------------------------------------------------------------------------------------------------
local meth = 0
RegisterNetEvent("setMeth")
AddEventHandler("setMeth",function()
	meth = meth + 60

	if not GetScreenEffectIsActive("DMT_flight") then
		StartScreenEffect("DMT_flight",0,true)
	end
end)

Citizen.CreateThread(function()
	while true do
		if meth > 0 then
			meth = meth - 1

			if meth <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				meth = 0

				if GetScreenEffectIsActive("DMT_flight") then
					StopScreenEffect("DMT_flight")
				end
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANEFFECTDRUGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cleanEffectDrugs")
AddEventHandler("cleanEffectDrugs",function()
	if GetScreenEffectIsActive("MinigameTransitionIn") then
		StopScreenEffect("MinigameTransitionIn")
	end

	if GetScreenEffectIsActive("DMT_flight") then
		StopScreenEffect("DMT_flight")
	end
end)

----------------------------------------------------------------------------------------------------------------
-- PLACA 
----------------------------------------------------------------------------------------------------------------
local imageUrl = "https://cdn.discordapp.com/attachments/847281734210027591/932902251058577458/mercosul.png" 

local textureDic = CreateRuntimeTxd('duiTxd')
local object = CreateDui(imageUrl, 540, 300)
local handle = GetDuiHandle(object)
CreateRuntimeTextureFromDuiHandle(textureDic, "duiTex", handle)
AddReplaceTexture('vehshare', 'plate01', 'duiTxd', 'duiTex')
AddReplaceTexture('vehshare', 'plate02', 'duiTxd', 'duiTex')
AddReplaceTexture('vehshare', 'plate03', 'duiTxd', 'duiTex') 
AddReplaceTexture('vehshare', 'plate04', 'duiTxd', 'duiTex')
AddReplaceTexture('vehshare', 'plate05', 'duiTxd', 'duiTex') 

local object = CreateDui('https://i.imgur.com/Q3uw6V7.png', 540, 300) 
local handle = GetDuiHandle(object)
CreateRuntimeTextureFromDuiHandle(textureDic, "duiTex2", handle) 
AddReplaceTexture('vehshare', 'plate01_n', 'duiTxd', 'duiTex2')
AddReplaceTexture('vehshare', 'plate02_n', 'duiTxd', 'duiTex2')
AddReplaceTexture('vehshare', 'plate03_n', 'duiTxd', 'duiTex2') 
AddReplaceTexture('vehshare', 'plate04_n', 'duiTxd', 'duiTex2')
AddReplaceTexture('vehshare', 'plate05_n', 'duiTxd', 'duiTex2')


-----------------------------------------------------------------------------------------------------------------------------------------
-- SETDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local drunkTime = 0
RegisterNetEvent("setDrunkTime")
AddEventHandler("setDrunkTime",function(timers)
	drunkTime = timers

	TriggerEvent("vrp:blockDrunk",true)
	RequestAnimSet("move_m@drunk@verydrunk")
	while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
		Citizen.Wait(10)
	end
	SetPedMovementClipset(PlayerPedId(),"move_m@drunk@verydrunk",0.25)
end)

Citizen.CreateThread(function()
	while true do
		if drunkTime > 0 then
			drunkTime = drunkTime - 1
			if drunkTime <= 0 or GetEntityHealth(PlayerPedId()) <= 101 then
				ResetPedMovementClipset(PlayerPedId(),0.25)
				TriggerEvent("vrp:blockDrunk",false)
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:syncHood")
AddEventHandler("vrp_player:syncHood",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			if GetVehicleDoorAngleRatio(v,4) == 0 then
				SetVehicleDoorOpen(v,4,0,1)
			else
				SetVehicleDoorShut(v,4,1)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCWINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:syncWins")
AddEventHandler("vrp_player:syncWins",function(index,status)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			if status == "true" then
				RollUpWindow(v,0)
				RollUpWindow(v,1)
				RollUpWindow(v,2)
				RollUpWindow(v,3)
			else
				RollDownWindow(v,0)
				RollDownWindow(v,1)
				RollDownWindow(v,2)
				RollDownWindow(v,3)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:syncDoors")
AddEventHandler("vrp_player:syncDoors",function(index,door)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			if door == "1" then
				if GetVehicleDoorAngleRatio(v,0) == 0 then
					SetVehicleDoorOpen(v,0,0,0)
				else
					SetVehicleDoorShut(v,0,0)
				end
			elseif door == "2" then
				if GetVehicleDoorAngleRatio(v,1) == 0 then
					SetVehicleDoorOpen(v,1,0,0)
				else
					SetVehicleDoorShut(v,1,0)
				end
			elseif door == "3" then
				if GetVehicleDoorAngleRatio(v,2) == 0 then
					SetVehicleDoorOpen(v,2,0,0)
				else
					SetVehicleDoorShut(v,2,0)
				end
			elseif door == "4" then
				if GetVehicleDoorAngleRatio(v,3) == 0 then
					SetVehicleDoorOpen(v,3,0,0)
				else
					SetVehicleDoorShut(v,3,0)
				end
			elseif door == "5" then
				if GetVehicleDoorAngleRatio(v,5) == 0 then
					SetVehicleDoorOpen(v,5,0,1)
				else
					SetVehicleDoorShut(v,5,1)
				end
			elseif door == nil then
				if GetVehicleDoorAngleRatio(v,0) == 0 and GetVehicleDoorAngleRatio(v,1) == 0 then
					SetVehicleDoorOpen(v,0,0,0)
					SetVehicleDoorOpen(v,1,0,0)
					SetVehicleDoorOpen(v,2,0,0)
					SetVehicleDoorOpen(v,3,0,0)
				else
					SetVehicleDoorShut(v,0,0)
					SetVehicleDoorShut(v,1,0)
					SetVehicleDoorShut(v,2,0)
					SetVehicleDoorShut(v,3,0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybindcuff",function(source,args)
	vSERVER.cuffToggle()
end)
RegisterKeyMapping("keybindcuff","Algemar o Cidadao","keyboard","g")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("seat",function(source,args,rawCommand)
    if args[1] then
                if IsPedInAnyVehicle(PlayerPedId()) then          
                        SetPedIntoVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId()), parseInt(args[1])-2)            
                    return
                end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- desativar Q
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health >= 101 then
        DisableControlAction(0,44,true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("keybindcarry",function(source,args)
	vSERVER.carryToggle()
end)
RegisterKeyMapping("keybindcarry","Carregar o Cidadao","keyboard","h")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VTUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vtuning",function(source,args)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) then
		local motor = GetVehicleMod(vehicle,11)
		local freio = GetVehicleMod(vehicle,12)
		local transmissao = GetVehicleMod(vehicle,13)
		local suspensao = GetVehicleMod(vehicle,15)
		local blindagem = GetVehicleMod(vehicle,16)
		local body = GetVehicleBodyHealth(vehicle)
		local engine = GetVehicleEngineHealth(vehicle)
		local fuel = GetVehicleFuelLevel(vehicle)

		if motor == -1 then
			motor = "Disabled"
		elseif motor == 0 then
			motor = "Nível 1 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 1 then
			motor = "Nível 2 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 2 then
			motor = "Nível 3 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 3 then
			motor = "Nível 4 / "..GetNumVehicleMods(vehicle,11)
		elseif motor == 4 then
			motor = "Nível 5 / "..GetNumVehicleMods(vehicle,11)
		end

		if freio == -1 then
			freio = "Disabled"
		elseif freio == 0 then
			freio = "Nível 1 / "..GetNumVehicleMods(vehicle,12)
		elseif freio == 1 then
			freio = "Nível 2 / "..GetNumVehicleMods(vehicle,12)
		elseif freio == 2 then
			freio = "Nível 3 / "..GetNumVehicleMods(vehicle,12)
		end

		if transmissao == -1 then
			transmissao = "Disabled"
		elseif transmissao == 0 then
			transmissao = "Nível 1 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 1 then
			transmissao = "Nível 2 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 2 then
			transmissao = "Nível 3 / "..GetNumVehicleMods(vehicle,13)
		elseif transmissao == 3 then
			transmissao = "Nível 4 / "..GetNumVehicleMods(vehicle,13)
		end

		if suspensao == -1 then
			suspensao = "Disabled"
		elseif suspensao == 0 then
			suspensao = "Nível 1 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 1 then
			suspensao = "Nível 2 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 2 then
			suspensao = "Nível 3 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 3 then
			suspensao = "Nível 4 / "..GetNumVehicleMods(vehicle,15)
		elseif suspensao == 4 then
			suspensao = "Nível 5 / "..GetNumVehicleMods(vehicle,15)
		end

		if blindagem == -1 then
			blindagem = "Disabled"
		elseif blindagem == 0 then
			blindagem = "Nível 1 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 1 then
			blindagem = "Nível 2 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 2 then
			blindagem = "Nível 3 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 3 then
			blindagem = "Nível 4 / "..GetNumVehicleMods(vehicle,16)
		elseif blindagem == 4 then
			blindagem = "Nível 5 / "..GetNumVehicleMods(vehicle,16)
		end

		TriggerEvent("Notify","roxo","<b>Motor:</b> "..motor.."<br><b>Freio:</b> "..freio.."<br><b>Transmissão:</b> "..transmissao.."<br><b>Suspensão:</b> "..suspensao.."<br><b>Blindagem:</b> "..blindagem.."<br><b>Lataria:</b> "..parseInt(body/10).."%<br><b>Motor:</b> "..parseInt(engine/10).."%<br><b>Gasolina:</b> "..parseInt(fuel).."%",10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:SeatPlayer")
AddEventHandler("vrp_player:SeatPlayer",function(index)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(vehicle) and IsPedInAnyVehicle(ped) then
		if parseInt(index) <= 1 or index == nil then
			seat = -1
		elseif parseInt(index) == 2 then
			seat = 0
		elseif parseInt(index) == 3 then
			seat = 1
		elseif parseInt(index) == 4 then
			seat = 2
		elseif parseInt(index) == 5 then
			seat = 3
		elseif parseInt(index) == 6 then
			seat = 4
		elseif parseInt(index) == 7 then
			seat = 5
		elseif parseInt(index) >= 8 then
			seat = 6
		end

		if IsVehicleSeatFree(vehicle,seat) then
			SetPedIntoVehicle(ped,vehicle,seat)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
local handcuff = false
function cnVRP.toggleHandcuff()
	local ped = PlayerPedId()
	if not handcuff then
		handcuff = true
		TriggerEvent("gcPhone:handcuff")
		TriggerEvent("radio:outServers")

		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,7,41,0,2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,7,25,0,2)
		end
	else
		handcuff = false
		SetPedComponentVariation(ped,7,0,0,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getHandcuff()
	return handcuff
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetHandcuff")
AddEventHandler("resetHandcuff",function()
	local ped = PlayerPedId()
	if handcuff then
		handcuff = false
		vRP.stopAnim(false)
		SetPedComponentVariation(ped,7,0,0,2)
	end
end)


RegisterCommand("teste",function(source,args)
   TriggerEvent("Notify","roxo","acabou de testa a notify", 10000)
   TriggerEvent("Notify","verde","acabou de testa a notify", 10000)
   TriggerEvent("Notify","vermelho","Lorem ipsum dolor sit amet consectetur adipisicing elit. Rerum similique illo dolorem cupiditate sint unde debitis, officia aliquam excepturi qui?", 10000)
   TriggerEvent("Notify","blood","acabou de testa a notify", 10000)
   TriggerEvent("Notify","azul","acabou de testa a notify", 10000)
   TriggerEvent("Notify","amarelo","acabou de testa a notify", 10000)
   TriggerEvent("Notify","rosa","acabou de testa a notify", 10000)
   TriggerEvent("Notify","locked","acabou de testa a notify", 10000)
   TriggerEvent("Notify","money","acabou de testa a notify", 10000)
   TriggerEvent("Notify","unlocked","acabou de testa a notify", 10000)
end)

-- /FPS ON/OFF
--------------------------------------------------------------
RegisterCommand("fps",function(source,args)
    if args[1] == "on" then
        SetTimecycleModifier("cinema")
        TriggerEvent("Notify","verde","Sucesso","FPS ligado!")
    elseif args[1] == "off" then
        SetTimecycleModifier("default")
        TriggerEvent("Notify","verde","Sucesso"," FPS desligado!")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOVEMENTCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.movementClip(dict)
	RequestAnimSet(dict)
	while not HasAnimSetLoaded(dict) do
		Citizen.Wait(10)
	end
	SetPedMovementClipset(PlayerPedId(),dict,0.25)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if handcuff then
			timeDistance = 4
			DisableControlAction(1,21,true)
			DisableControlAction(1,23,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,75,true)
			DisableControlAction(1,22,true)
			DisableControlAction(1,73,true)
			DisableControlAction(1,167,true)
			DisableControlAction(1,311,true)
			DisableControlAction(1,29,true)
			DisableControlAction(1,182,true)
			DisableControlAction(1,187,true)
			DisableControlAction(1,189,true)
			DisableControlAction(1,190,true)
			DisableControlAction(1,188,true)
			DisableControlAction(1,245,true)
			DisableControlAction(1,243,true)
			DisableControlAction(1,105,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end
		Citizen.Wait(timeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADWHILEHANDCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if handcuff and GetEntityHealth(ped) > 101 then
			vRP.playAnim(true,{"mp_arresting","idle"},true)
		end
		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
local blackWeapons = {
	"WEAPON_UNARMED",
	"WEAPON_FLASHLIGHT",
	"WEAPON_NIGHTSTICK",
	"WEAPON_STUNGUN",
	"GADGET_PARACHUTE",
	"WEAPON_PETROLCAN",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_BAT",
	"WEAPON_BATTLEAXE",
	"WEAPON_BOTTLE",
	"WEAPON_CROWBAR",
	"WEAPON_DAGGER",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_MACHETE",
	"WEAPON_POOLCUE",
	"WEAPON_STONE_HATCHET",
	"WEAPON_SWITCHBLADE",
	"WEAPON_WRENCH",
	"WEAPON_KNUCKLE"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
local gsrTime = 0
local bWeapons = false
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if GetSelectedPedWeapon(ped) ~= GetHashKey("WEAPON_UNARMED") and GetSelectedPedWeapon(ped) ~= GetHashKey("WEAPON_PETROLCAN") then
			timeDistance = 4
			if IsPedShooting(ped) then
				for k,v in ipairs(blackWeapons) do
					if GetSelectedPedWeapon(ped) == GetHashKey(v) then
						bWeapons = true
					end
				end

				if not bWeapons then
					vSERVER.shotsFired()
					gsrTime = 60
				end

				bWeapons = false
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GSRTIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if gsrTime > 0 then
			gsrTime = gsrTime - 1
		end
		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GSRCHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.gsrCheck()
	return gsrTime
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
local shotDistance = {
	{ -186.1,-893.5,29.3,2500 },
	{ 1389.7,3237.2,37.6,1300 },
	{ -137.4,6228.4,31.2,1000 }
}

function cnVRP.shotDistance(x,y,z)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	for k,v in pairs(shotDistance) do
		local distance = #(coords - vector3(v[1],v[2],v[3]))
		if distance <= v[4] then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local uCarry = nil
local iCarry = false
local sCarry = false
function cnVRP.toggleCarry(source)
	uCarry = source
	iCarry = not iCarry

	local ped = PlayerPedId()
	if iCarry and uCarry then
		AttachEntityToEntity(ped,GetPlayerPed(GetPlayerFromServerId(uCarry)),11816,0.6,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		sCarry = true
	else
		if sCarry then
			DetachEntity(ped,false,false)
			sCarry = false
		end
	end	
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.removeVehicle()
	local ped = PlayerPedId()
	if IsPedSittingInAnyVehicle(ped) then
		iCarry = false
		DetachEntity(GetPlayerPed(GetPlayerFromServerId(uCarry)),false,false)
		TaskLeaveVehicle(ped,GetVehiclePedIsUsing(ped),4160)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXTRAS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.extraVehicle(data)
	local vehicle = vRP.getNearVehicle(11)
	if data == "1" then
		if DoesExtraExist(vehicle,1) then
			if IsVehicleExtraTurnedOn(vehicle,1) then
				SetVehicleExtra(vehicle,1,true)
			else
				SetVehicleExtra(vehicle,1,false)
			end
		end
	elseif data == "2" then
		if DoesExtraExist(vehicle,2) then
			if IsVehicleExtraTurnedOn(vehicle,2) then
				SetVehicleExtra(vehicle,2,true)
			else
				SetVehicleExtra(vehicle,2,false)
			end
		end
	elseif data == "3" then
		if DoesExtraExist(vehicle,3) then
			if IsVehicleExtraTurnedOn(vehicle,3) then
				SetVehicleExtra(vehicle,3,true)
			else
				SetVehicleExtra(vehicle,3,false)
			end
		end
	elseif data == "4" then
		if DoesExtraExist(vehicle,4) then
			if IsVehicleExtraTurnedOn(vehicle,4) then
				SetVehicleExtra(vehicle,4,true)
			else
				SetVehicleExtra(vehicle,4,false)
			end
		end
	elseif data == "5" then
		if DoesExtraExist(vehicle,5) then
			if IsVehicleExtraTurnedOn(vehicle,5) then
				SetVehicleExtra(vehicle,5,true)
			else
				SetVehicleExtra(vehicle,5,false)
			end
		end
	elseif data == "6" then
		if DoesExtraExist(vehicle,6) then
			if IsVehicleExtraTurnedOn(vehicle,6) then
				SetVehicleExtra(vehicle,6,true)
			else
				SetVehicleExtra(vehicle,6,false)
			end
		end
	elseif data == "7" then
		if DoesExtraExist(vehicle,7) then
			if IsVehicleExtraTurnedOn(vehicle,7) then
				SetVehicleExtra(vehicle,7,true)
			else
				SetVehicleExtra(vehicle,7,false)
			end
		end
	elseif data == "8" then
		if DoesExtraExist(vehicle,8) then
			if IsVehicleExtraTurnedOn(vehicle,8) then
				SetVehicleExtra(vehicle,8,true)
			else
				SetVehicleExtra(vehicle,8,false)
			end
		end
	elseif data == "9" then
		if DoesExtraExist(vehicle,9) then
			if IsVehicleExtraTurnedOn(vehicle,9) then
				SetVehicleExtra(vehicle,9,true)
			else
				SetVehicleExtra(vehicle,9,false)
			end
		end
	elseif data == "10" then
		if DoesExtraExist(vehicle,10) then
			if IsVehicleExtraTurnedOn(vehicle,10) then
				SetVehicleExtra(vehicle,10,true)
			else
				SetVehicleExtra(vehicle,10,false)
			end
		end
	elseif data == "11" then
		if DoesExtraExist(vehicle,11) then
			if IsVehicleExtraTurnedOn(vehicle,11) then
				SetVehicleExtra(vehicle,11,true)
			else
				SetVehicleExtra(vehicle,11,false)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.putVehicle(seat)
	local veh = vRP.getNearVehicle(11)
	if IsEntityAVehicle(veh) then
		if parseInt(seat) <= 1 or seat == nil then
			seat = -1
		elseif parseInt(seat) == 2 then
			seat = 0
		elseif parseInt(seat) == 3 then
			seat = 1
		elseif parseInt(seat) == 4 then
			seat = 2
		elseif parseInt(seat) == 5 then
			seat = 3
		elseif parseInt(seat) == 6 then
			seat = 4
		elseif parseInt(seat) == 7 then
			seat = 5
		elseif parseInt(seat) >= 8 then
			seat = 6
		end

		local ped = PlayerPedId()
		if IsVehicleSeatFree(veh,seat) then
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			SetPedIntoVehicle(ped,veh,seat)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOLSTER
-----------------------------------------------------------------------------------------------------------------------------------------
local weapons = {
	"WEAPON_KNIFE",
	"WEAPON_HATCHET",
	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_PISTOL50",
	"WEAPON_REVOLVER",
	"WEAPON_COMBATPISTOL",
	"WEAPON_FLASHLIGHT",
	"WEAPON_NIGHTSTICK",
	"WEAPON_STUNGUN",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_APPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_MICROSMG",
	"WEAPON_MINISMG",
	"WEAPON_SNSPISTOL",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_CARBINERIFLE",
	"WEAPON_SMG",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_GUSENBERG"
}

local holster = false
Citizen.CreateThread(function()
	while true do
		local timeDistance = 100
		local ped = PlayerPedId()
		if DoesEntityExist(ped) and GetEntityHealth(ped) > 101 and not IsPedInAnyVehicle(ped) then
			if CheckWeapon(ped) then
				if not holster then
					timeDistance = 4
					if not IsEntityPlayingAnim(ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then
						loadAnimDict("rcmjosh4")
						TaskPlayAnim(ped,"rcmjosh4","josh_leadout_cop2",3.0,2.0,-1,48,10,0,0,0)
						Citizen.Wait(450)
						ClearPedTasks(ped)
					end
					holster = true
				end
			elseif not CheckWeapon(ped) then
				if holster then
					timeDistance = 4
					if not IsEntityPlayingAnim(ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then
						loadAnimDict("weapons@pistol@")
						TaskPlayAnim(ped,"weapons@pistol@","aim_2_holster",3.0,2.0,-1,48,10,0,0,0)
						Citizen.Wait(450)
						ClearPedTasks(ped)
					end
					holster = false
				end
			end
		end

		if GetEntityHealth(ped) <= 101 and holster then
			holster = false
			SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
		end
		Citizen.Wait(timeDistance)
	end
end)

function CheckWeapon(ped)
	for i = 1,#weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(10)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.toggleLivery(number)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		SetVehicleLivery(GetVehiclePedIsUsing(ped),number)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISTANCESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
local disService = {
	{ 1146.36,-1545.09,35.39,"Paramedic" }, -- HP CENTRO
	{ 811.77,-984.99,26.64,"Mechanic" }, -- BENNYS       
	{ -1098.88,-826.14,14.29,"Police" } -- DP CENTRO 
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISTANCESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.distanceService()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	for k,v in pairs(disService) do
		local distance = #(coords - vector3(v[1],v[2],v[3]))
		if distance <= 15 then
			return true,v[4]
		end
	end
	return false,nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WECOLORS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.weColors(number)
	local ped = PlayerPedId()
	local weapon = GetSelectedPedWeapon(ped)
	SetPedWeaponTintIndex(ped,weapon,parseInt(number))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WELUX
-----------------------------------------------------------------------------------------------------------------------------------------
local wLux = {
	["WEAPON_PISTOL"] = {
		"COMPONENT_PISTOL_VARMOD_LUXE"
	},
	["WEAPON_APPISTOL"] = {
		"COMPONENT_APPISTOL_VARMOD_LUXE"
	},
	["WEAPON_HEAVYPISTOL"] = {
		"COMPONENT_HEAVYPISTOL_VARMOD_LUXE"
	},
	["WEAPON_MICROSMG"] = {
		"COMPONENT_MICROSMG_VARMOD_LUXE"
	},
	["WEAPON_SNSPISTOL"] = {
		"COMPONENT_SNSPISTOL_VARMOD_LOWRIDER"
	},
	["WEAPON_PISTOL50"] = {
		"COMPONENT_PISTOL50_VARMOD_LUXE"
	},
	["WEAPON_COMBATPISTOL"] = {
		"COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER"
	},
	["WEAPON_CARBINERIFLE"] = {
		"COMPONENT_CARBINERIFLE_VARMOD_LUXE"
	},
	["WEAPON_PUMPSHOTGUN"] = {
		"COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER"
	},
	["WEAPON_SAWNOFFSHOTGUN"] = {
		"COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE"
	},
	["WEAPON_SMG"] = {
		"COMPONENT_SMG_VARMOD_LUXE"
	},
	["WEAPON_ASSAULTRIFLE"] = {
		"COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		"COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01"
	},
	["WEAPON_ASSAULTSMG"] = {
		"COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WELUX
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.weLux()
	local ped = PlayerPedId()
	for k,v in pairs(wLux) do
		if GetSelectedPedWeapon(ped) == GetHashKey(k) then
			for k2,v2 in pairs(v) do
				GiveWeaponComponentToPed(ped,GetHashKey(k),GetHashKey(v2))
			end
		end
	end
end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- CAMVIEWMODE
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	while true do
-- 		if GetFollowPedCamViewMode() == 1 or GetFollowPedCamViewMode() == 2 then
-- 			SetFollowPedCamViewMode(4)
-- 		end
-- 		Citizen.Wait(100)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIDETRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local inTrunk = false
RegisterNetEvent("vrp_player:EnterTrunk")
AddEventHandler("vrp_player:EnterTrunk",function()
	local ped = PlayerPedId()

	if not inTrunk then
		local vehicle = vRP.vehList(11)
		if DoesEntityExist(vehicle) then
			local trunk = GetEntityBoneIndexByName(vehicle,"boot")
			if trunk ~= -1 then
				local coords = GetEntityCoords(ped)
				local coordsEnt = GetWorldPositionOfEntityBone(vehicle,trunk)
				local distance = #(coords - coordsEnt)
				if distance <= 3.0 then
					timeDistance = 4
					if GetVehicleDoorAngleRatio(vehicle,5) < 0.9 and GetVehicleDoorsLockedForPlayer(vehicle,PlayerId()) ~= 1 then
						SetCarBootOpen(vehicle)
						SetEntityVisible(ped,false,false)
						Citizen.Wait(750)
						AttachEntityToEntity(ped,vehicle,-1,0.0,-2.2,0.5,0.0,0.0,0.0,false,false,false,false,20,true)
						inTrunk = true
						Citizen.Wait(500)
						SetVehicleDoorShut(vehicle,5)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("vrp_player:CheckTrunk")
AddEventHandler("vrp_player:CheckTrunk",function()
	local ped = PlayerPedId()

	if inTrunk then
		local vehicle = GetEntityAttachedTo(ped)
		if DoesEntityExist(vehicle) then
			SetCarBootOpen(vehicle)
			Citizen.Wait(750)
			inTrunk = false
			DetachEntity(ped,false,false)
			SetEntityVisible(ped,true,false)
			SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.5,-0.75))
			Citizen.Wait(500)
			SetVehicleDoorShut(vehicle,5)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500

		if inTrunk then
			local ped = PlayerPedId()
			local vehicle = GetEntityAttachedTo(ped)
			if DoesEntityExist(vehicle) then
				timeDistance = 4

				DisableControlAction(1,73,true)
				DisableControlAction(1,29,true)
				DisableControlAction(1,47,true)
				DisableControlAction(1,187,true)
				DisableControlAction(1,189,true)
				DisableControlAction(1,190,true)
				DisableControlAction(1,188,true)
				DisableControlAction(1,311,true)
				DisableControlAction(1,245,true)
				DisableControlAction(1,257,true)
				DisableControlAction(1,167,true)
				DisableControlAction(1,140,true)
				DisableControlAction(1,141,true)
				DisableControlAction(1,142,true)
				DisableControlAction(1,137,true)
				DisableControlAction(1,37,true)
				DisablePlayerFiring(ped,true)

				if IsEntityVisible(ped) then
					SetEntityVisible(ped,false,false)
				end

				if IsControlJustPressed(1,38) then
					SetCarBootOpen(vehicle)
					Citizen.Wait(750)
					inTrunk = false
					DetachEntity(ped,false,false)
					SetEntityVisible(ped,true,false)
					SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.5,-0.75))
					Citizen.Wait(500)
					SetVehicleDoorShut(vehicle,5)
				end
			else
				inTrunk = false
				DetachEntity(ped,false,false)
				SetEntityVisible(ped,true,false)
				SetEntityCoords(ped,GetOffsetFromEntityInWorldCoords(ped,0.0,-1.5,-0.75))
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAM
-----------------------------------------------------------------------------------------------------------------------------------------
local inCamera = false
local camSelect = nil
local cameras = {
	["1"] = { 433.93,-978.23,34.72,104.89 },
	["2"] = { 424.59,-996.6,34.72,119.06 },
	["3"] = { 438.16,-999.32,33.72,192.76 },
	["4"] = { 148.99,-1036.29,32.34,306.15 },
	["5"] = { 300.97,-582.22,45.29,218.27 },
	["6"] = { 227.4,-577.62,46.86,269.3 },
	["7"] = { 22.0,-1602.84,32.37,153.08 }
}

RegisterNetEvent("vrp_player:serviceCamera")
AddEventHandler("vrp_player:serviceCamera",function(num)
	local ped = PlayerPedId()

	if inCamera then
		ClearTimecycleModifier()
		DestroyCam(camSelect,false)
		TriggerEvent("hudActived",true)
		RenderScriptCams(false,false,0,1,0)
		PlaySoundFrontend(-1,"HACKING_SUCCESS",false)
        TriggerEvent('active:checkcam',true)
		inCamera = false
		camSelect = nil
	else
		if cameras[num] then
			TriggerEvent('active:checkcam',false)
			inCamera = true
			TriggerEvent("hudActived",false)
			SetTimecycleModifier("heliGunCam")
			PlaySoundFrontend(-1,"HACKING_SUCCESS",false)
			camSelect = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
			SetCamCoord(camSelect,cameras[num][1],cameras[num][2],cameras[num][3])
			SetCamRot(camSelect,-20.0,0.0,cameras[num][4])
			RenderScriptCams(true,false,0,1,0)
		end
	end
end)
-------------- FIX PROPTS CELULAR ----------------------------------
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        local obj = GetClosestObjectOfType(coords,15.0,GetHashKey("prop_amb_phone",false,0,0))
        if obj ~= 0 and obj ~= nil and obj ~= false then
            sleep = 100
            if not IsEntityAttached(obj) then
                TriggerServerEvent("trydeleteobj",ObjToNet(obj))
            end
        end
        Citizen.Wait(sleep)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EMPURRAR
-----------------------------------------------------------------------------------------------------------------------------------------
local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc,moveFunc,disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = { handle = iter, destructor = disposeFunc }
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next,id = moveFunc(iter)
		until not next

		enum.destructor,enum.handle = nil,nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle,FindNextVehicle,EndFindVehicle)
end

function GetVeh()
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        table.insert(vehicles,vehicle)
    end
    return vehicles
end

function GetClosestVeh(coords)
	local vehicles = GetVeh()
	local closestDistance = -1
	local closestVehicle = -1
	local coords = coords

	if coords == nil then
		local ped = PlayerPedId()
		coords = GetEntityCoords(ped)
	end

	for i=1,#vehicles,1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = GetDistanceBetweenCoords(vehicleCoords,coords.x,coords.y,coords.z,true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end
	return closestVehicle,closestDistance
end

local First = vector3(0.0,0.0,0.0)
local Second = vector3(5.0,5.0,5.0)
local Vehicle = { Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil }

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local closestVehicle,Distance = GetClosestVeh()
		if Distance < 6.1 and not IsPedInAnyVehicle(ped) then
			Vehicle.Coords = GetEntityCoords(closestVehicle)
			Vehicle.Dimensions = GetModelDimensions(GetEntityModel(closestVehicle),First,Second)
			Vehicle.Vehicle = closestVehicle
			Vehicle.Distance = Distance
			if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
				Vehicle.IsInFront = false
			else
				Vehicle.IsInFront = true
			end
		else
			Vehicle = { Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil }
		end
		Citizen.Wait(500)
	end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(500)
		if Vehicle.Vehicle ~= nil then
			local ped = PlayerPedId()
			if IsControlPressed(0,244) and GetEntityHealth(ped) > 100 and IsVehicleSeatFree(Vehicle.Vehicle,-1) and not IsEntityInAir(ped) and not IsPedBeingStunned(ped) and not IsEntityAttachedToEntity(ped,Vehicle.Vehicle) and not (GetEntityRoll(Vehicle.Vehicle) > 75.0 or GetEntityRoll(Vehicle.Vehicle) < -75.0) then
				RequestAnimDict('missfinale_c2ig_11')
				TaskPlayAnim(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0,-8.0,-1,35,0,0,0,0)
				NetworkRequestControlOfEntity(Vehicle.Vehicle)

				if Vehicle.IsInFront then
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y*-1+0.1,Vehicle.Dimensions.z+1.0,0.0,0.0,180.0,0.0,false,false,true,false,true)
				else
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y-0.3,Vehicle.Dimensions.z+1.0,0.0,0.0,0.0,0.0,false,false,true,false,true)
				end

				while true do
					Citizen.Wait(5)
					if IsDisabledControlPressed(0,34) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,11,100)
					end

					if IsDisabledControlPressed(0,9) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,10,100)
					end

					if Vehicle.IsInFront then
						SetVehicleForwardSpeed(Vehicle.Vehicle,-1.0)
					else
						SetVehicleForwardSpeed(Vehicle.Vehicle,1.0)
					end

					if not IsDisabledControlPressed(0,244) then
						DetachEntity(ped,false,false)
						StopAnimTask(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0)
						break
					end
				end
			end
		end
	end
end)
---------------------------------------------------- 
------( NÃO ATIRAR AGACHADO  ) -------------
----------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local player = PlayerId()
        if agachar then 
            DisablePlayerFiring(player, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        DisableControlAction(0,36,true)
        if not IsPedInAnyVehicle(ped) then
            RequestAnimSet("move_ped_crouched")
            RequestAnimSet("move_ped_crouched_strafing")
            if IsDisabledControlJustPressed(0,36) then
                if agachar then
                    ResetPedStrafeClipset(ped)
                    ResetPedMovementClipset(ped,0.25)
                    agachar = false
                else
                    SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
                    SetPedMovementClipset(ped,"move_ped_crouched",0.25)
                    agachar = true
                end
            end
        end
    end
end) 
 -----------------------------------------------------------------------------------------------------------------------------------------
-- PROP TELEFONE
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        local object = GetClosestObjectOfType(coords,15.0,GetHashKey("prop_amb_phone",false,0,0))
        if object ~= 0 and object ~= nil and object ~= false then
            sleep = 100
            if not IsEntityAttached(object) then
                TriggerServerEvent("tryDeleteEntity",ObjToNet(object))
            end
        end
        Citizen.Wait(sleep)
    end
end) 
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBAR NPC APONTANDO ARMA
-----------------------------------------------------------------------------------------------------------------------------------------
local actionRobbery = false
Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()

        if not actionRobbery then
            if not IsPedInAnyVehicle(ped) and IsPedArmed(ped,6) then
                local aim,target = GetEntityPlayerIsFreeAimingAt(PlayerId())

                if aim and IsPedInAnyVehicle(target) and not IsPedAPlayer(target) then
                    timeDistance = 4

                    local coords = GetEntityCoords(ped)
                    local vehicle = GetVehiclePedIsUsing(target)
                    local speed = GetEntitySpeed(vehicle) * 2.236936
                    local plate = GetVehicleNumberPlateText(vehicle)
                    local distance = #(coords - GetEntityCoords(vehicle))
                    local modelName = vRP.getVehiclePlate(GetEntityModel(vehicle))

                    if distance <= 10 and IsPedFacingPed(target,ped,180.0) and speed <= 5 then
                        actionRobbery = true

                        SetVehicleForwardSpeed(vehicle,0)
                        TaskLeaveVehicle(target,vehicle,256)
                        SetEntityAsMissionEntity(target,true,true)

                        while IsPedInAnyVehicle(target) do
                            Citizen.Wait(1)
                        end

                        Citizen.Wait(500)

                        ClearPedTasks(target)
                        TaskTurnPedToFaceEntity(target,ped,3.0)
                        SetPedSuffersCriticalHits(target,false)
                        SetPedDropsWeaponsWhenDead(target,false)
                        SetBlockingOfNonTemporaryEvents(target,true)
                        TaskSetBlockingOfNonTemporaryEvents(target,true)

                        RequestAnimDict("missfbi5ig_22")
                        TaskPlayAnim(target,"missfbi5ig_22","hands_up_anxious_scientist",8.0,-8,-1,12,1,0,0,0)

                        Citizen.Wait(3000)

                        if not IsEntityDead(target) and distance <= 15 then
                            RequestAnimDict("mp_common")
                            TriggerServerEvent("setPlateEveryone",plate,modelName)
                            TaskPlayAnim(target,"mp_common","givetake1_a",8.0,-8,-1,12,1,0,0,0)
                            TriggerEvent("Notify","roxo","Você recebeu a Chave!",5000)

                            Citizen.Wait(750)

                            TaskWanderStandard(target,10.0,10)
                            TaskReactAndFleePed(target,ped)
                            SetPedKeepTask(target,true)

                        actionRobbery = false
                        end
                    end
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
