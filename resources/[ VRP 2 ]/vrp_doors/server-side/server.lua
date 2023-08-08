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
Tunnel.bindInterface("vrp_doors",cnVRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
local doors = {
 
	-- DEPARTAMENT POLICE ANTIGA   
	 [1] = { ["x"] = 441.01, ["y"] = -993.95, ["z"] = 30.69, ["hash"] = 165994623, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true},
	 [2] = { ["x"] = 440.09, ["y"] = -998.73, ["z"] = 30.73, ["hash"] = 1388858739, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true},
	 [3] = { ["x"] = 442.86, ["y"] = -998.86, ["z"] = 30.73, ["hash"] = -165604314, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true},
	 [4] = { ["x"] = 468.97, ["y"] = -1014.46, ["z"] = 26.39, ["hash"] = 2271212864, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["other"] = 5, ["sound"] = true },
	 [5] = { ["x"] = 468.35, ["y"] = -1014.44, ["z"] = 26.39, ["hash"] = 2271212864, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["other"] = 4, ["sound"] = true },
	 [6] = { ["x"] = 442.48, ["y"] = -998.73, ["z"] = 30.73, ["hash"] = 1388858739, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [7] = { ["x"] = 467.34, ["y"] = -991.98, ["z"] = 25.74, ["hash"] = 165994623, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [8] = { ["x"] =  440.43, ["y"] = -998.78, ["z"] = 30.73, ["hash"] = -165604314, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [9] = { ["x"] = 464.44, ["y"] = -983.99, ["z"] = 43.7, ["hash"] = -340230128, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [10] = { ["x"] = 461.82, ["y"] = -984.61, ["z"] = 34.22, ["hash"] = -1988553564, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [11] = { ["x"] = 455.98, ["y"] = -984.71, ["z"] = 34.22, ["hash"] = -884718443, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [12] = { ["x"] = 449.94, ["y"] = -984.6, ["z"] = 34.22, ["hash"] = -884718443, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [13] = { ["x"] = 477.09, ["y"] = -997.92, ["z"] = 24.9, ["hash"] = -1033001619, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [14] = { ["x"] = 479.98, ["y"] = -997.95, ["z"] = 24.9, ["hash"] = -1033001619, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },
	 [15] = { ["x"] = 435.93, ["y"] = -979.45, ["z"] = 26.67, ["hash"] = -1033001619, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true }, 
	 [16] = { ['x'] = 464.97, ['y'] = -988.41, ['z'] = 25.79, ["hash"] = -165994623, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true }, --Portas do estacionamento
	 [17] = { ['x'] = 461.22, ['y'] = -989.14, ['z'] = 34.19, ["hash"] = -1988553564, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true }, -- Portas 1
	 [18] = { ['x'] = 455.36, ['y'] = -989.15, ['z'] = 34.19, ["hash"] = -1988553564, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["other"] = 4, ["sound"] = true }, -- Portas 2
	 [19] = { ['x'] = 449.25, ['y'] = -989.11, ['z'] = 34.19, ["hash"] = -1988553564, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["other"] = 3, ["sound"] = true }, -- Portas 3
	 [20] = { ['x'] = 449.89, ['y'] = -984.63, ['z'] = 34.22, ["hash"] = -884718443, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["other"] = 6, ["sound"] = true }, -- Portas 4
	 [21] = { ['x'] = 455.99, ['y'] = -984.52, ['z'] = 34.22, ["hash"] = -884718443, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["other"] = 5, ["sound"] = true }, -- Portas 5
	 [22] = { ['x'] = 461.79, ['y'] = -984.62, ['z'] = 34.22, ["hash"] = -1988553564, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["other"] = 8, ["sound"] = true },  -- Portas 6 
	 [47] = { ['x'] = 2507.59, ['y'] = -354.29, ['z'] = 105.7, ["hash"] = 395979613, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["other"] = 7, ["sound"] = true }, -- SELAS CIVIL
	 [48] = { ['x'] = 2510.26, ['y'] = -351.81, ['z'] = 105.7, ["hash"] = 395979613, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },-- Cela
	--[[[10] = { ['x'] = 483.39, ['y'] = -1012.36, ['z'] = 26.28, ["hash"] = -53345114, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },-- Cela
	[11] = { ['x'] = 480.23, ['y'] = -1012.33, ['z'] = 26.28, ["hash"] = -53345114, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },-- Cela
	[12] = { ['x'] = 477.10, ['y'] = -1012.30, ['z'] = 26.32, ["hash"] = -53345114, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },-- Cela
	[13] = { ['x'] = 484.86, ['y'] = -1007.73, ['z'] = 26.32, ["hash"] = -53345114, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },-- Cela
	[14] = { ['x'] = 476.47, ['y'] = -1008.10, ['z'] = 26.30, ["hash"] = -53345114, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },-- Cela
	[15] = { ['x'] = 481.76, ['y'] = -1004.02, ['z'] = 26.31, ["hash"] = -53345114, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },-- Cela
	[16] = { ['x'] = 464.24, ['y'] = -975.42, ['z'] = 26.38, ["hash"] = 1830360419, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },--Porta garagem
	[17] = { ['x'] = 464.09, ['y'] = -996.75, ['z'] = 26.38, ["hash"] = 1830360419, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },--Porta garagem
	[18] = { ['x'] = 464.35, ['y'] = -983.75, ['z'] = 43.78, ["hash"] = -692649124, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true }, -- porta teto 
	[19] = { ['x'] = 458.89, ['y'] = -989.94, ['z'] = 30.79, ["hash"] = -96679321, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Police", ["sound"] = true },-- porta capitao]]--

	[20] = { ["x"] = -630.81, ["y"] = -237.96, ["z"] = 38.1, ["hash"] = 9467943, ["lock"] = true, ["text"] = false, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Admin", ["other"] = 21 },
	[21] = { ["x"] = -631.62, ["y"] = -236.92, ["z"] = 38.06, ["hash"] = 1425919976, ["lock"] = true, ["text"] = false, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Admin", ["other"] = 20 },
	[22] = { ["x"] = -14.14, ["y"] = -1441.17, ["z"] = 31.11, ["hash"] = 520341586, ["lock"] = true, ["text"] = false, ["distance"] = 10, ["press"] = 1.5, ["perm"] = "Admin" },
	[23] = { ["x"] = 981.72, ["y"] = -102.78, ["z"] = 74.85, ["hash"] = 190770132, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "TheLost" },
	[24] = { ["x"] = 1846.049, ["y"] = 2604.733, ["z"] = 45.579, ["hash"] = 741314661, ["lock"] = true, ["text"] = true, ["distance"] = 30, ["press"] = 10.0, ["perm"] = "Police" },
	[25] = { ["x"] = 1819.475, ["y"] = 2604.743, ["z"] = 45.577, ["hash"] = 741314661, ["lock"] = true, ["text"] = true, ["distance"] = 30, ["press"] = 10.0, ["perm"] = "Police" },
	[26] = { ["x"] = 488.89, ["y"] = -1017.49, ["z"] = 28.15, ["hash"] = 2691149580, ["lock"] = true, ["text"] = true, ["distance"] = 30, ["press"] = 7.5, ["perm"] = "Police" },
	[27] = { ["x"] = 950.04, ["y"] = 8.75, ["z"] = 75.75, ["hash"] = -88942360, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Mafia", ["sound"] = true },
	[28] = { ["x"] = 952.86, ["y"] = 13.21, ["z"] = 75.75, ["hash"] = -88942360, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Mafia", ["sound"] = true },
	[29] = { ["x"] = 940.76, ["y"] = 5.15, ["z"] = 75.5, ["hash"] = -264728216, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Mafia", ["sound"] = true },
	[30] = { ["x"] = 735.0, ["y"] = -815.54, ["z"] = 22.67, ["hash"] = 855881614, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Bratva", ["sound"] = true },
	[31] = { ["x"] = 717.55, ["y"] = -767.78, ["z"] = 24.91, ["hash"] = 346272656, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Bratva", ["sound"] = true },
	[32] = { ["x"] = 186.93, ["y"] = -1272.7, ["z"] = 29.2, ["hash"] = 1219405180, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Dolls", ["sound"] = true },
	[33] = { ["x"] = 95.32, ["y"] = -1285.29, ["z"] = 29.29, ["hash"] = 1695461688, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Vanilla", ["sound"] = true },
	[34] = { ["x"] = 99.73, ["y"] = -1293.4, ["z"] = 29.27, ["hash"] = 390840000, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Vanilla", ["sound"] = true }, 
	[35] = { ["x"] = 377.66, ["y"] = 268.3, ["z"] = 95.0, ["hash"] = -1555108147, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Galaxy", ["sound"] = true },
	[36] = { ["x"] = 377.84, ["y"] = 268.49, ["z"] = 91.19, ["hash"] = -1989765534, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Galaxy", ["sound"] = true },	
	[37] = { ["x"] = 970.45, ["y"] = -1849.49, ["z"] = 31.27, ["hash"] = -710818483, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Hell", ["sound"] = true },
	[38] = { ["x"] = 982.6, ["y"] = -125.27, ["z"] = 74.06, ["hash"] = -197537718, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Thelost", ["sound"] = true },
	[39] = { ["x"] = -2667.54, ["y"] = 1325.92, ["z"] = 147.45, ["hash"] = 1901183774, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Fazendeiros", ["sound"] = true },
	[40] = { ["x"] = -1864.82, ["y"] = 2058.38, ["z"] = 135.45, ["hash"] = -710818483, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Bratva", ["sound"] = true },
	--[[[41] = { ["x"] = 925.96, ["y"] = 45.3, ["z"] = 81.11, ["hash"] = -548272800, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Admin", ["sound"] = true },
	[42] = { ["x"] = 926.68, ["y"] = 46.09, ["z"] = 81.10, ["hash"] = -548272800, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Admin", ["sound"] = true },
	[43] = { ["x"] = 927.07, ["y"] = 47.94, ["z"] = 81.38, ["hash"] = -548272800, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Admin", ["sound"] = true },
	[44] = { ["x"] = 927.60, ["y"] = 48.81, ["z"] = 81.10, ["hash"] = -548272800, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Admin", ["sound"] = true },]]--
	
	[41] = { ["x"] = -62.16,  ["y"] = 998.48,    ["z"] = 234.69, ["hash"] =  1901183774,  ["lock"] = true, ["text"] = true,  ["distance"] = 40, ["press"] = 6.5,  ["perm"] = "Green",    ["sound"] = true},
	[42] = { ["x"] = -112.58, ["y"] = 986.16,    ["z"] = 235.79, ["hash"] =  1901183774,  ["lock"] = true, ["text"] = true,  ["distance"] = 40, ["press"] = 6.5,  ["perm"] = "Green",    ["sound"] = true},

	[45] = { ["x"] = 967.82, ["y"] = -1829.591, ["z"] = 31.3, ["hash"] = -710818483, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Hell", ["sound"] = true },
	[46] = { ["x"] = 976.34, ["y"] = -1831, ["z"] = 31.28, ["hash"] = -190780785, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Hell", ["sound"] = true },
	[49] = { ["x"] = -62.06, ["y"] = 991.2, ["z"] = 234.58, ["hash"] = 736699661, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "Green", ["sound"] = true },
	--[[50] = { ["x"] = 2440.26, ["y"] = 4982.36 ["z"] = 46.81, ["hash"] = 1413743677, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "fazendeiros", ["sound"] = true }, 
	[51] = { ["x"] = 2449.1, ["y"] = 4989.41, ["z"] = 46.82, ["hash"] = 1413743677, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "fazendeiros", ["sound"] = true },
	[52] = { ["x"] = 2452.7, ["y"] = 4970.11, ["z"] = 46.82, ["hash"] = 1413743677, ["lock"] = true, ["text"] = true, ["distance"] = 5, ["press"] = 1.5, ["perm"] = "fazendeiros", ["sound"] = true }, ]]--
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSSTATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.doorsStatistics(doorNumber,doorStatus)
	local source = source

	doors[parseInt(doorNumber)].lock = doorStatus

	if doors[parseInt(doorNumber)].other ~= nil then
		local doorSecond = doors[parseInt(doorNumber)].other
		doors[doorSecond].lock = doorStatus
	end

	TriggerClientEvent("vrp_doors:doorsUpdate",-1,doors)

	if doors[parseInt(doorNumber)].sound then
		TriggerClientEvent("vrp_sound:source",source,"doorlock",0.1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSSTATISTICS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_doors:doorsStatistics")
AddEventHandler("vrp_doors:doorsStatistics",function(doorNumber,doorStatus)
	doors[parseInt(doorNumber)].lock = doorStatus

	if doors[parseInt(doorNumber)].other ~= nil then
		local doorSecond = doors[parseInt(doorNumber)].other
		doors[doorSecond].lock = doorStatus
	end

	TriggerClientEvent("vrp_doors:doorsUpdate",-1,doors)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORSPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.doorsPermission(doorNumber)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if doors[parseInt(doorNumber)].perm ~= nil then
			if vRP.hasPermission(user_id,doors[parseInt(doorNumber)].perm) then
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_doors:doorsUpdate",source,doors)
end)

