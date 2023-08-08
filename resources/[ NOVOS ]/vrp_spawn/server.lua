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
Tunnel.bindInterface("vrp_spawn",cnVRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUPCHARS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.setupChars()
	local source = source
	local steam = vRP.getSteam(source)
	
	Citizen.Wait(1000)

	return getPlayerCharacters(steam)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.deleteChar(id)
	local source = source
	local steam = vRP.getSteam(source)

	vRP.execute("vRP/remove_characters",{ id = parseInt(id) })
  
	Citizen.Wait(1000)

	return getPlayerCharacters(steam)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnLogin = {}
RegisterServerEvent("vrp_spawn:charChosen")
AddEventHandler("vrp_spawn:charChosen",function(id)
	local source = source
	TriggerClientEvent("hudActived",source,true)
	TriggerEvent("baseModule:idLoaded",source,id,nil)

	-- if spawnLogin[parseInt(id)] then
	-- 	-- TriggerClientEvent("vrp_spawn:spawnChar",source,false)
	-- else
	-- 	spawnLogin[parseInt(id)] = true
	-- 	-- TriggerClientEvent("vrp_spawn:spawnChar",source,true)
	-- end
	TriggerEvent("dpn:playerSpawn", source, id)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_spawn:createChar")
AddEventHandler("vrp_spawn:createChar",function()
	local source = source
	local steam = vRP.getSteam(source)
	local persons = getPlayerCharacters(steam)

	if not vRP.getPremium2(steam) and parseInt(#persons) >= 1 then
		TriggerClientEvent("Notify",source,"roxo","Você atingiu o limite de personagens.",5000)
		TriggerClientEvent("vrp_spawn:maxChars",source)
		return
	end

	vRP.execute("vRP/create_characters",{ steam = steam, name = "name", name2 = "name2" })

	local newId = 0
	local chars = getPlayerCharacters(steam)
	for k,v in pairs(chars) do
		if v.id > newId then
			newId = tonumber(v.id)
		end
	end

	Citizen.Wait(1000)

	spawnLogin[parseInt(newId)] = true
	--TriggerClientEvent("hudActived",source,true)
	-- TriggerClientEvent("vrp_spawn:spawnChar",source,true)
	TriggerEvent("baseModule:idLoaded",source,newId)
	TriggerEvent("dpn:playerSpawn", source, newId)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function getPlayerCharacters(steam)
	print(steam)
	return vRP.query("vRP/get_characters",{ steam = steam })
end