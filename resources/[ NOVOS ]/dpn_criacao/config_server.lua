local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local userlogin = {}

vRP = Proxy.getInterface("vRP")

vCLIENT = Tunnel.getInterface("dpn_criacao")

Config_server = {}

Config_server = {
	permission = "dono.permissao", -- Permissão que poderá recriar personagem
}

function barberShopPlayer(user_id,firstspawn)
	local source = vRP.getUserSource(user_id)
	TriggerClientEvent("dpn:normalSpawn",source,firstspawn)
	TriggerEvent("vrp_barbershop:init",user_id)	
	-- Coloque os eventos do seu barbershop
end

function giveItensCharacterFinish(source,user_id)	
	vRP.setUData(user_id,"vRP:spawnController", json.encode(2))
	vRP.giveInventoryItem(user_id,'celular',1)
	vRP.giveInventoryItem(user_id,'agua',3)
	vRP.giveInventoryItem(user_id,'sanduiche',3)
	vRP.giveInventoryItem(user_id,'dinheiro',3000)
	vRP.addUserGroup(1,'manager')
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		local data = vRP.getUData(user_id,"vRP:spawnController")
		local sdata = json.decode(data) or 0
		if sdata then
			Citizen.Wait(1000)
			processSpawnController(source,sdata,user_id)
		end
	end
end)

function processSpawnController(source,statusSent,user_id)
	if statusSent == 2 then
		if not userlogin[user_id] then
			userlogin[user_id] = true
			doSpawnPlayer(source,user_id,false)
		else
			doSpawnPlayer(source,user_id,true)
		end
	elseif statusSent == 1 or statusSent == 0 then
		userlogin[user_id] = true
		TriggerClientEvent('iniciarTelaCriacao',source)
	end
end


function doSpawnPlayer(source,user_id,firstspawn)
	TriggerEvent("vrp_barbershop:init",user_id)	
end 