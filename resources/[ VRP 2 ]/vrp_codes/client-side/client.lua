-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for i = 1,12 do
		EnableDispatchService(i,false)
	end
end)

local localPeds = {}

local pedList = {

	{ -- Taxista
		coords = { 894.9,-179.15,74.7,240.95 },
		model = { 0x24604B2B,"u_m_y_chip" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Minerador
		coords = { 1054.12,-1952.91,32.1,272.81 },
		model = { 0x1536D95A,"a_m_o_ktown_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mergulhador
		coords = { -1586.81,5199.17,3.99,300.39 },
		model = { 0x51C03FA4,"a_f_y_eastsa_03" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Motorista
		coords = { 1239.87,-3257.16,7.09,266.46 },
		model = { 0x2A797197,"u_m_m_edtoh" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
    }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(pedList) do
			local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
			if distance <= 50 then
				if not IsPedInAnyVehicle(ped) then
					if localPeds[k] == nil then
						local mHash = GetHashKey(v["model"][2])

						RequestModel(mHash)
						while not HasModelLoaded(mHash) do
							Citizen.Wait(1)
						end

						if HasModelLoaded(mHash) then
							localPeds[k] = CreatePed(4,v["model"][1],v["coords"][1],v["coords"][2],v["coords"][3] - 1,v["coords"][4],false,true)
							SetPedArmour(localPeds[k],100)
							SetEntityInvincible(localPeds[k],true)
							FreezeEntityPosition(localPeds[k],true)
							SetBlockingOfNonTemporaryEvents(localPeds[k],true)

							SetModelAsNoLongerNeeded(mHash)

							if v["anim"][1] ~= nil then
								RequestAnimDict(v["anim"][1])
								while not HasAnimDictLoaded(v["anim"][1]) do
									Citizen.Wait(1)
								end

								TaskPlayAnim(localPeds[k],v["anim"][1],v["anim"][2],8.0,0.0,-1,1,0,0,0,0)
							end
						end
					end
				end
			else
				if localPeds[k] then
					DeleteEntity(localPeds[k])
					localPeds[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
local oldSpeed = 0
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			timeDistance = 4
			SetPedHelmet(ped,false)
			DisableControlAction(0,345,true)
			local veh = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(veh,-1) == ped then
				local speed = GetEntitySpeed(veh) * 2.236936
				if speed ~= oldSpeed then
					if (oldSpeed - speed) >= 60 then
						TriggerServerEvent("upgradeStress",10)
						if GetVehicleClass(veh) ~= 8 then
							vehicleTyreBurst(veh)
						end
					end
					oldSpeed = speed
				end
			end
		else
			oldSpeed = 0
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
function vehicleTyreBurst(vehicle)
	local tyre = math.random(4)
	if tyre == 1 then
		if not IsVehicleTyreBurst(vehicle,0,false) then
			SetVehicleTyreBurst(vehicle,0,true,1000.0)
		end
	elseif tyre == 2 then
		if not IsVehicleTyreBurst(vehicle,1,false) then
			SetVehicleTyreBurst(vehicle,1,true,1000.0)
		end
	elseif tyre == 3 then
		if not IsVehicleTyreBurst(vehicle,4,false) then
			SetVehicleTyreBurst(vehicle,4,true,1000.0)
		end
	elseif tyre == 4 then
		if not IsVehicleTyreBurst(vehicle,5,false) then
			SetVehicleTyreBurst(vehicle,5,true,1000.0)
		end
	end

	if math.random(100) < 30 then
		Citizen.Wait(10)
		vehicleTyreBurst(vehicle)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ 827.06,-983.55,26.59,402,4,"Mecanica",0.7 },    
	{ -1234.21,-275.3,43.3,120,7,"ScarllyFood",0.7 },    
	{ 265.05,-1262.65,29.3,361,4,"Posto de Gasolina",0.4 },
	{ 819.02,-1027.96,26.41,361,4,"Posto de Gasolina",0.4 },
	{ 1208.61,-1402.43,35.23,361,4,"Posto de Gasolina",0.4 },
	{ 1181.48,-330.26,69.32,361,4,"Posto de Gasolina",0.4 },
	{ 621.01,268.68,103.09,361,4,"Posto de Gasolina",0.4 },
	{ 2581.09,361.79,108.47,361,4,"Posto de Gasolina",0.4 },
	{ 175.08,-1562.12,29.27,361,4,"Posto de Gasolina",0.4 },
	{ -319.76,-1471.63,30.55,361,4,"Posto de Gasolina",0.4 },
	{ 1782.33,3328.46,41.26,361,4,"Posto de Gasolina",0.4 },
	{ 49.42,2778.8,58.05,361,4,"Posto de Gasolina",0.4 },
	{ 264.09,2606.56,44.99,361,4,"Posto de Gasolina",0.4 },
	{ 1039.38,2671.28,39.56,361,4,"Posto de Gasolina",0.4 },
	{1207.4,2659.93,37.9,361,4,"Posto de Gasolina",0.4 },
	{ 2539.19,2594.47,37.95,361,4,"Posto de Gasolina",0.4 },
	{ 2679.95,3264.18,55.25,361,4,"Posto de Gasolina",0.4 },
	{ 2005.03,3774.43,32.41,361,4,"Posto de Gasolina",0.4 },
	{ 1687.07,4929.53,42.08,361,4,"Posto de Gasolina",0.4 },
	{ 1701.53,6415.99,32.77,361,4,"Posto de Gasolina",0.4 },
	{ 180.1,6602.88,31.87,361,4,"Posto de Gasolina",0.4 },
	{ -94.46,6419.59,31.48,361,4,"Posto de Gasolina",0.4 },
	{ -2555.17,2334.23,33.08,361,4,"Posto de Gasolina",0.4 },
	{ -1800.09,803.54,138.72,361,4,"Posto de Gasolina",0.4 },
	{ -1437.0,-276.8,46.21,361,4,"Posto de Gasolina",0.4 },
	{ -2096.3,-320.17,13.17,361,4,"Posto de Gasolina",0.4 },
	{ -724.56,-935.97,19.22,361,4,"Posto de Gasolina",0.4 },
	{ -525.26,-1211.19,18.19,361,4,"Posto de Gasolina",0.4 },
	{ -70.96,-1762.21,29.54,361,4,"Posto de Gasolina",0.4 },
   { 1152.52,-1527.28,34.85,80,35,"Hospital",0.5 },
   { 55.43,-876.19,30.66,357,14,"Garagem",0.6 },
   { 317.25,2623.14,44.46,357,14,"Garagem",0.6 },
   { -773.34,5598.15,33.60,357,14,"Garagem",0.6 },
   { 275.23,-345.54,45.17,357,14,"Garagem",0.6 },
   { 596.40,90.65,93.12,357,14,"Garagem",0.6 },
   { -340.76,265.97,85.67,357,14,"Garagem",0.6 },
   { -2030.01,-465.97,11.60,357,14,"Garagem",0.6 },
   { -1184.92,-1510.00,4.64,357,14,"Garagem",0.6 },
   { -73.44,-2004.99,18.27,357,14,"Garagem",0.6 },
   { 214.02,-808.44,31.01,357,14,"Garagem",0.6 },
   { -348.88,-874.02,31.31,357,14,"Garagem",0.6 },
   { 67.74,12.27,69.21,357,14,"Garagem",0.6 },
   { 361.90,297.81,103.88,357,14,"Garagem",0.6 },
   { 1035.89,-763.89,57.99,357,14,"Garagem",0.6 },
   { -796.63,-2022.77,9.16,357,14,"Garagem",0.6 },
   { 453.27,-1146.76,29.52,357,14,"Garagem",0.6 },
   { 528.66,-146.3,58.38,357,14,"Garagem",0.6 },
   { -1159.48,-739.32,19.89,357,14,"Garagem",0.6 },
   { 29.29,-1770.35,29.61,357,14,"Garagem",0.6 },
   { 101.22,-1073.68,29.38,357,14,"Garagem",0.6 },
   { -1078.09,-844.31,4.5,60,4,"Departamento Policial",0.6 },
   { -448.18,6011.68,31.71,60,4,"Departamento Policial",0.6 },
   { 25.68,-1346.6,29.5,52,36,"Loja de Departamento",0.5 },
   { 2556.47,382.05,108.63,52,36,"Loja de Departamento",0.5 },
   { 1163.55,-323.02,69.21,52,36,"Loja de Departamento",0.5 },
   { -707.31,-913.75,19.22,52,36,"Loja de Departamento",0.5 },
   { -47.72,-1757.23,29.43,52,36,"Loja de Departamento",0.5 },
   { 373.89,326.86,103.57,52,36,"Loja de Departamento",0.5 },
   { -3242.95,1001.28,12.84,52,36,"Loja de Departamento",0.5 },
   { 1729.3,6415.48,35.04,52,36,"Loja de Departamento",0.5 },
   { 548.0,2670.35,42.16,52,36,"Loja de Departamento",0.5 },
   { 1960.69,3741.34,32.35,52,36,"Loja de Departamento",0.5 },
   { 2677.92,3280.85,55.25,52,36,"Loja de Departamento",0.5 },
   { 1698.5,4924.09,42.07,52,36,"Loja de Departamento",0.5 },
   { -1820.82,793.21,138.12,52,36,"Loja de Departamento",0.5 },
   { 1393.21,3605.26,34.99,52,36,"Loja de Departamento",0.5 },
   { -2967.78,390.92,15.05,52,36,"Loja de Departamento",0.5 },
   { -3040.14,585.44,7.91,52,36,"Loja de Departamento",0.5 },
   { 1135.56,-982.24,46.42,52,36,"Loja de Departamento",0.5 },
   { 1166.0,2709.45,38.16,52,36,"Loja de Departamento",0.5 },
   { -1487.21,-378.99,40.17,52,36,"Loja de Departamento",0.5 },
   { -1222.76,-907.21,12.33,52,36,"Loja de Departamento",0.5 },
   { 1692.62,3759.50,34.70,76,6,"Loja de Armas",0.4 },
   { 252.89,-49.25,69.94,76,6,"Loja de Armas",0.4 },
   { 843.28,-1034.02,28.19,76,6,"Loja de Armas",0.4 },
   { -331.35,6083.45,31.45,76,6,"Loja de Armas",0.4 },
   { -663.15,-934.92,21.82,76,6,"Loja de Armas",0.4 },
   { -1305.18,-393.48,36.69,76,6,"Loja de Armas",0.4 },
   { -1118.80,2698.22,18.55,76,6,"Loja de Armas",0.4 },
   { 2568.83,293.89,108.73,76,6,"Loja de Armas",0.4 },
   { -3172.68,1087.10,20.83,76,6,"Loja de Armas",0.4 },
   { 21.32,-1106.44,29.79,76,6,"Loja de Armas",0.4 },
   { 811.19,-2157.67,29.61,76,6,"Loja de Armas",0.4 },
   { -1213.44,-331.02,37.78,207,2,"Banco",0.5 },
   { -351.59,-49.68,49.04,207,2,"Banco",0.5 },
   { 313.47,-278.81,54.17,207,2,"Banco",0.5 },
   { 149.35,-1040.53,29.37,207,2,"Banco",0.5 },
   { -2962.60,482.17,15.70,207,2,"Banco",0.5 },
   { -112.81,6469.91,31.62,207,2,"Banco",0.5 },
   { 1175.74,2706.80,38.09,207,2,"Banco",0.5 },
   { -51.82,-1111.38,26.44,225,4,"Concessionaria",0.5 },
   { -1586.26,5199.44,3.99,617,3,"Mergulhador",0.4 },  
   { -815.12,-184.15,37.57,71,4,"Barbearia",0.5 },
   { 138.13,-1706.46,29.3,71,4,"Barbearia",0.5 },
   { -1280.92,-1117.07,7.0,71,4,"Barbearia",0.5 },
   { 1930.54,3732.06,32.85,71,4,"Barbearia",0.5 },
   { 1214.2,-473.18,66.21,71,4,"Barbearia",0.5 },
   { -33.61,-154.52,57.08,71,4,"Barbearia",0.5 },
   { -276.65,6226.76,31.7,71,4,"Barbearia",0.5 },
   { 75.35,-1392.92,29.38,73,4,"Loja de Roupas",0.5 },
   { -710.15,-152.36,37.42,73,4,"Loja de Roupas",0.5 },
   { -163.73,-303.62,39.74,73,4,"Loja de Roupas",0.5 },
   { -822.38,-1073.52,11.33,73,4,"Loja de Roupas",0.5 },
   { -1193.13,-767.93,17.32,73,4,"Loja de Roupas",0.5 },
   { -1449.83,-237.01,49.82,73,4,"Loja de Roupas",0.5 },
   { 4.83,6512.44,31.88,73,4,"Loja de Roupas",0.5 },
   { 1693.95,4822.78,42.07,73,4,"Loja de Roupas",0.5 },
   { 125.82,-223.82,54.56,73,4,"Loja de Roupas",0.5 },
   { 614.2,2762.83,42.09,73,4,"Loja de Roupas",0.5 },
   { 1196.72,2710.26,38.23,73,4,"Loja de Roupas",0.5 },
   { -3170.53,1043.68,20.87,73,4,"Loja de Roupas",0.5 },
   { -1101.42,2710.63,19.11,73,4,"Loja de Roupas",0.5 },
   { 425.6,-806.25,29.5,73,4,"Loja de Roupas",0.5 },
   { -1082.22,-247.54,37.77,617,2,"Loja VIP",0.7 },
   { -1728.06,-1050.69,1.71,266,4,"Embarcações",0.5 },
   { 1966.36,3975.86,31.51,266,4,"Embarcações",0.5 },
   { -776.72,-1495.02,2.29,266,4,"Embarcações",0.5 },
   --{ -893.97,5687.78,3.29,266,4,"Embarcações",0.5 },
   { 468.11,-585.95,28.5,513,4,"Motorista",0.5 },
   { 355.67,273.37,103.11,67,4,"Transportador",0.5 },
   { -837.97,5406.55,34.59,285,4,"Lenhador",0.5 },
   { -1563.32,-975.79,13.02,68,4,"Pescador",0.5 },
   { -913.36,5733.09,3.71,68,4,"Pescador",0.5 },
   { 132.6,-1305.06,29.2,93,4,"Bar",0.5 },
   { -565.14,271.56,83.02,93,4,"Bar",0.5 },
   { -581.84,-1644.79,19.47,318,4,"Lixeiro",0.7 },
   { 1126.26,-1532.45,34.87,403,3,"Farmácia",0.7 },
   { 325.7,-1074.38,29.48,403,3,"Farmácia",0.7 },
   { 237.81,-413.08,48.12,498,8,"Cartório",0.6 },
   { 46.66,-1749.79,29.64,78,11,"Mega Mall",0.5 },
   { 11.12,-1605.65,29.4,79,4,"Tacos",0.4 },
   { -443.67,-1684.05,19.79,467,11,"Reciclagem",0.6 },
   { -741.56,5594.94,41.66,36,4,"Teleférico",0.6 },
   { 454.46,5571.95,781.19,36,4,"Teleférico",0.6 },
   { -653.38,-852.87,24.51,459,11,"Eletrônicos",0.6 },
   { 408.17,-1635.57,29.3,515,4,"Reboque",0.7 },
   { 1706.07,4791.75,41.98,515,4,"Reboque",0.7 },
   { 909.8,-176.49,74.23,56,4,"Taxista",0.6 },
   { 2955.89,2787.45,41.37,124,4,"Minerador",0.7 },
   { 1056.54,-1953.99,31.02,124,4,"Minerador",0.5 },  
   { 1247.7,-3256.05,6.03,67,4,"Caminhoneiro",0.5 }, 
   { -331.2,-1094.45,22.36,315,4,"Corrida Explosiva",0.5 },
   { 843.99,-1985.63,29.31,315,4,"Corrida Explosiva",0.5 },
   { 136.03,-2820.08,6.01,315,4,"Corrida Explosiva",0.5 },
   { 698.73,-1555.81,9.71,315,4,"Corrida Explosiva",0.5 },
   { -352.54,-691.86,32.56,315,4,"Corrida Explosiva",0.5 },
   { 1657.69,3236.9,40.57,315,4,"Corrida Explosiva",0.5 },
   { 36.08,-605.51,31.63,315,4,"Corrida Explosiva",0.5 }
   

}


Citizen.CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v[1],v[2],v[3])
		SetBlipSprite(blip,v[4])
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v[5])
		SetBlipScale(blip,v[7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v[6])
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECOIL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if IsPedArmed(ped,6) then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
			Citizen.Wait(1)
		else
			Citizen.Wait(1000)
		end

		if IsPedShooting(ped) then
			local cam = GetFollowPedCamViewMode()
			local veh = IsPedInAnyVehicle(ped)
			
			local speed = math.ceil(GetEntitySpeed(ped))
			if speed > 70 then
				speed = 70
			end

			local _,wep = GetCurrentPedWeapon(ped)
			local class = GetWeapontypeGroup(wep)
			local p = GetGameplayCamRelativePitch()
			local camDist = #(GetGameplayCamCoord() - GetEntityCoords(ped))

			local recoil = math.random(110,120+(math.ceil(speed*0.5)))/100
			local rifle = false

			if class == 970310034 or class == 1159398588 then
				rifle = true
			end

			if camDist < 5.3 then
				camDist = 1.5
			else
				if camDist < 8.0 then
					camDist = 4.0
				else
					camDist =  7.0
				end
			end

			if veh then
				recoil = recoil + (recoil * camDist)
			else
				recoil = recoil * 0.1
			end

			if cam == 4 then
				recoil = recoil * 0.6
				if rifle then
					recoil = recoil * 0.1
				end
			end

			if rifle then
				recoil = recoil * 0.6
			end

			local spread = math.random(4)
			local h = GetGameplayCamRelativeHeading()
			local hf = math.random(10,40+speed) / 100

			if veh then
				hf = hf * 2.0
			end

			if spread == 1 then
				SetGameplayCamRelativeHeading(h+hf)
			elseif spread == 2 then
				SetGameplayCamRelativeHeading(h-hf)
			end

			local set = p + recoil
			SetGameplayCamRelativePitch(set,0.8)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 1000
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		N_0xf4f2c0d4ee209e20()
		DistantCopCarSirens(false)

		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL50"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_REVOLVER"),0.4)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL"),0.8)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPISTOL"),0.8)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HATCHET"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BATTLEAXE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BOTTLE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CROWBAR"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DAGGER"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GOLFCLUB"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_POOLCUE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_STONE_HATCHET"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SWITCHBLADE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_WRENCH"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNUCKLE"),0.1)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMPACTRIFLE"),0.4)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_APPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHINEPISTOL"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MICROSMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MINISMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_VINTAGEPISTOL"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),0.6)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSMG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GUSENBERG"),0.7)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SAWNOFFSHOTGUN"),1.3)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN"),2.0)
		
		--ClearAreaOfPeds(GetEntityCoords(PlayerPedId()),1000.0,1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 5
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(10)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(20)
		--[[ HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22) ]]
		DisableControlAction(1,37,true)
		DisableControlAction(1,192,true)
--[[ 		DisableControlAction(1,204,true) ]]
		EnableControlAction(0,37)
	--[[ 	ShowHudComponentThisFrame(20) ]]
		ShowHudComponentThisFrame(21)
		ShowHudComponentThisFrame(22)
		ShowHudComponentThisFrame(19)
		DisableControlAction(1,211,true)
		DisableControlAction(1,349,true)
		DisableControlAction(1,157,false)
		DisableControlAction(1,158,false)
		DisableControlAction(1,160,false)
		DisableControlAction(1,164,false)
		DisableControlAction(1,165,false)
		DisableControlAction(1,159,false)
		DisableControlAction(1,161,false)
		DisableControlAction(1,162,false)
		DisableControlAction(1,163,false)
		
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_KNIFE"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_PISTOL"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_MINISMG"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_SMG"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_PUMPSHOTGUN"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_CARBINERIFLE"))
		RemoveAllPickupsOfType(GetHashKey("PICKUP_WEAPON_COMBATPISTOL"))

		DisablePlayerVehicleRewards(PlayerId())

		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			SetPedInfiniteAmmo(ped,true,"WEAPON_FIREEXTINGUISHER")
		end
		Citizen.Wait(5)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 0
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
	SetAudioFlag("PoliceScannerDisabled",true)

	while true do
		Citizen.Wait(0)

		SetRandomBoats(false)
		SetGarbageTrucks(false)
		SetCreateRandomCops(false)
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		DisableVehicleDistantlights(true)
		-- SetPedDensityMultiplierThisFrame(0.0)
		SetVehicleDensityMultiplierThisFrame(0.75)
		SetParkedVehicleDensityMultiplierThisFrame(0.75)
		-- SetScenarioPedDensityMultiplierThisFrame(0.0,0.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADGLOBAL - 10
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		RemoveVehiclesFromGeneratorsInArea(65.95 - 5.0,-1719.34 - 5.0,29.32 - 5.0,65.95 + 5.0,-1719.34 + 5.0,29.32 + 5.0)
		RemoveVehiclesFromGeneratorsInArea(115.57 - 5.0,-1758.6 - 5.0,29.34 - 5.0,115.57 + 5.0,-1758.6 + 5.0,29.34 + 5.0)
		RemoveVehiclesFromGeneratorsInArea(-4.02 - 5.0,-1533.7 - 5.0,29.63 - 5.0,-4.02 + 5.0,-1533.7 + 5.0,29.63 + 5.0)
		RemoveVehiclesFromGeneratorsInArea(100.79 - 5.0,-1605.9 - 5.0,29.52 - 5.0,100.79 + 5.0,-1605.9 + 5.0,29.52 + 5.0)
		RemoveVehiclesFromGeneratorsInArea(43.77 - 5.0,-1288.61 - 5.0,29.15 - 5.0,43.77 + 5.0,-1288.61 + 5.0,29.15 + 5.0)


		------ agachar
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
-- IPLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	LoadInterior(GetInteriorAtCoords(313.36,-591.02,43.29))
-- 	LoadInterior(GetInteriorAtCoords(440.84,-983.14,30.69))
-- 	LoadInterior(GetInteriorAtCoords(1768.09,3327.09,41.45))
	
	
-- 	-- Ilha
-- 	Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', true)

-- 	-- misc natives
-- 	Citizen.InvokeNative(0xF74B1FFA4A15FBEA, true)
-- 	Citizen.InvokeNative(0x53797676AD34A9AA, false)    
-- 	SetScenarioGroupEnabled('Heist_Island_Peds', true)

-- 	-- audio stuff
-- 	SetAudioFlag('PlayerOnDLCHeist4Island', true)
-- 	SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
-- 	SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)



-- 	---
-- 	for _,v in pairs(allIpls) do
-- 		loadInt(v.coords,v.interiorsProps)
-- 	end
-- end)

function loadInt(coordsTable,table)
	for _,v in pairs(coordsTable) do
		local interior = GetInteriorAtCoords(v[1],v[2],v[3])
		LoadInterior(interior)
		for _,i in pairs(table) do
			EnableInteriorProp(interior,i)
			Citizen.Wait(10)
		end
		RefreshInterior(interior)
	end
end

allIpls = {
	{
		interiorsProps = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		coords = {{ -1150.7,-1520.7,10.6 }}
	},{
		interiorsProps = {
			"csr_beforeMission",
			"csr_inMission"
		},
		coords = {{ -47.1,-1115.3,26.5 }}
	},{
		interiorsProps = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		coords = {{ -802.3,175.0,72.8 }}
	},{
		interiorsProps = {
			"meth_lab_production",
			"meth_lab_upgrade",
			"meth_lab_setup"
		},
		coords = {{ 38.49,3714.1,11.01 }}
	}--,{
		--interiorsProps = {
		--	"branded_style_set",
		--	"car_floor_hatch"
		--},
		--coords = {{ 941.00,-972.66,39.14 }}
	--}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TASERTIME
-----------------------------------------------------------------------------------------------------------------------------------------
local tasertime = false
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()

		if IsPedBeingStunned(ped) then
			timeDistance = 4
			SetPedToRagdoll(ped,7500,7500,0,0,0,0)
		end

		if IsPedBeingStunned(ped) and not tasertime then
			tasertime = true
			timeDistance = 4
			TriggerEvent("cancelando",true)
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE",1.0)
		elseif not IsPedBeingStunned(ped) and tasertime then
			tasertime = false
			Citizen.Wait(7500)
			StopGameplayCamShaking()
			TriggerEvent("cancelando",false)
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local teleport = {
	{ -435.92,-359.82,34.95,-418.62,-344.77,24.24,"DESCER" },  ----hospital garagem pro terreo
	{ -418.62,-344.77,24.24,-435.92,-359.82,34.95,"SUBIR" },

	{ -490.4,-327.33,42.31,-443.96,-332.33,78.17,"SUBIR PRO HELIPONTO" },  ---- hospital subir pro heliponto
	{ -443.96,-332.33,78.17,-490.4,-327.33,42.31,"DESCER PARA O HP" },

	{ 1132.68,-1549.99,35.39,247.06,-1371.8,24.54,"DESCER PRO NECROTERIO" },  ---- necroterio
	{ 247.06,-1371.8,24.54,1132.68,-1549.99,35.39,"SUBIR PRO HP" },

	{ 4.58,-705.95,45.98,-139.85,-627.0,168.83,"ENTRAR" },
	{ -139.85,-627.0,168.83,4.58,-705.95,45.98,"SAIR" },

	{ 234.41,-387.43,-98.78,244.04,-429.06,-98.78,"ENTRAR" },
	{ 244.04,-429.06,-98.78,234.41,-387.43,-98.78,"SAIR" },

	{ -826.9,-699.89,28.06,-1575.14,-569.15,108.53,"ENTRAR" },
	{ -1575.14,-569.15,108.53,-826.9,-699.89,28.06,"SAIR" },

	{ 4982.07,-5710.49,19.89,4989.89,-5717.69,19.89,"ENTRAR" },    ------------ ILHA
	{ 4989.89,-5717.69,19.89,4982.07,-5710.49,19.89,"SAIR" },

	{ -741.07,5593.13,41.66,446.19,5568.79,781.19,"SUBIR" },  ------ PARAQUEDAS
	{ 446.19,5568.79,781.19,-741.07,5593.13,41.66,"DESCER" },

	{ -740.78,5597.04,41.66,446.37,5575.02,781.19,"SUBIR" }, ------ PARAQUEDAS 
	{ 446.37,5575.02,781.19,-740.78,5597.04,41.66,"DESCER" },

	{ 1084.33,221.61,-49.2,980.00, 57.0, 115.0,"ENTRAR" }, -- cassino
	{ 980.00, 57.0, 115.0, 1084.33,221.61,-49.2,"SAIR" },

	{ 1085.17,214.19,-49.2,965.11,58.52,112.56,"SUBIR" },    ------- elevador cassino ------   ,85.91
	{ 965.11,58.52,112.56,1085.17,214.19,-49.2,"DESCER" },


	{ 935.87,47.27,81.1,1089.67,205.84,-48.99,"ENTRAR" },   
	{1089.67,205.84,-48.99,935.87,47.27,81.1,"SAIR" },  ------ cassino ----------
 
	{ 232.98,-411.38,48.12,224.75,-360.71,-98.78,"ENTRAR" }, ------  prefeitura     ,344.97
	{ 224.75,-360.71,-98.78,232.98,-411.38,48.12,"SAIR" }    

}

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(teleport) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2 then
					timeDistance = 4
					DrawText3D(v[1],v[2],v[3],"~g~E~w~   "..v[7])
					if IsControlJustPressed(1,38) then
						DoScreenFadeOut(1000)
						Citizen.Wait(2000)
						SetEntityCoords(ped,v[4],v[5],v[6])
						Citizen.Wait(1000)
						DoScreenFadeIn(1000)
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
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
-- VEHICLESUPPRESSED
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local SUPPRESSED_MODELS = { "SHAMAL","LUXOR","LUXOR2","JET","LAZER","TITAN","BARRACKS","BARRACKS2","CRUSADER","RHINO","AIRTUG","RIPLEY","PHANTOM","HAULER","RUBBLE","BIFF","TACO","PACKER","TRAILERS","TRAILERS2","TRAILERS3","TRAILERS4","BLIMP","POLMAV","MULE","MULE2","MULE3","MULE4" }
	while true do
		for _,model in next,SUPPRESSED_MODELS do
			SetVehicleModelIsSuppressed(GetHashKey(model),true)
		end
		Wait(10000)
	end
end)

