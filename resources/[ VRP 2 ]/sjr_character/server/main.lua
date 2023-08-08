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
Tunnel.bindInterface("sjr_character",cnVRP)


-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUPCHARS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getUserCharacters()
	local source = source
	local steam = vRP.getSteam(source)

	Citizen.Wait(1000)

	return getPlayerCharacters(steam)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYERCHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function getPlayerCharacters(steam)
	return vRP.query("vRP/get_characters",{ steam = steam })
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET PERSONAGENS COM INFORMAÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getPersonagens()
    local steam = vRP.getSteam(source)
    local plyChars = {}
    local result = getPlayerCharacters(steam)
    for i = 1, (#result), 1 do
        result[i].charinfo = result[i].id
        result[i].money = result[i].cash
        result[i].job = "teste"

        table.insert(plyChars, result[i])
    end
    return plyChars  
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET SKINS//ROUPA
-----------------------------------------------------------------------------------------------------------------------------------------

function cnVRP.getSkin(cid, inf)
    local src = source
    local info = inf
    local playerData = vRP.getUData(cid,"Clothings")
    local Clothes = json.decode(playerData)
    local value = vRP.getUData(cid,"currentCharacterMode")
    local custom = json.decode(value) or {}
    local playerData = vRP.getUData(parseInt(cid),"Datatable")
	local resultData = json.decode(playerData) or {}
	if resultData and resultData.skin then
        model = resultData.skin
    else
        model = 1885233650
    end
    

    ----------------------------fazer o sistema de puxar model da db direto no client ( otimizado ) ---------------------------

    if Clothes == nil then
        return model,nil,info,custom
    else
        return model,Clothes,info,custom
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent('sjr-character:server:disconnect')
AddEventHandler('sjr-character:server:disconnect', function()
    local src = source
    DropPlayer(src, "Je bent gedisconnect van Santos Roleplay")
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGAR O PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent('sjr-character:server:loadUserData')
AddEventHandler('sjr-character:server:loadUserData', function(cData)
    local source = source
    print(cData.dat[1])
    TriggerClientEvent("hudActived",source,true)
    TriggerEvent("baseModule:idLoaded",source, cData.dat[1],nil)
    TriggerEvent("ks-CharacterSpawn",source, cData.dat[1])

end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR O PERSONAGEM
-----------------------------------------------------------------------------------------------------------------------------------------


local spawnLogin = {}

RegisterServerEvent('sjr-character:server:createCharacter')
AddEventHandler('sjr-character:server:createCharacter', function(data)
    -- local newData = {}
    -- newData.charinfo = data
    -- newData.cid = cid

    local source = source
	local steam = vRP.getSteam(source)
	local persons = getPlayerCharacters(steam)

    ----------------- infos temporarias -------------------------------
    local name = data.firstname
    local name2 = data.lastname


    ------------------------------------------ arrumar essa parte pra limitar----------------------------
	if not vRP.getPremium2(steam) and parseInt(#persons) >= 2 then
		TriggerClientEvent("Notify",source,"roxo","Você atingiu o limite de personagens.",5000)
		TriggerClientEvent("vrp_spawn:maxChars",source)
		return
	end

    ------------------------------------ colocar pra criar com o sexo ( em caso de usar a criação desse script ) ---------------------------------------------
	vRP.execute("vRP/create_characters",{ steam = steam, name = name, name2 = name2 })

    ------------------------------------------------------

	local newId = 0
	local chars = getPlayerCharacters(steam)
	for k,v in pairs(chars) do
		if v.id > newId then
			newId = tonumber(v.id)
		end
	end

    -------------------------- model temporario ----------------------------------------------
	local model = ""
	if data.gender == 0 then
		model = "mp_m_freemode_01"
	elseif data.gender == 1 then
		model = "mp_f_freemode_01"
	end

    ------------------------------------------------------------------------------------------
	Citizen.Wait(1000)

	spawnLogin[parseInt(newId)] = true
    TriggerClientEvent("sjr-character:client:closeNUI", source)
	TriggerClientEvent("hudActived",source,true)
	-- TriggerClientEvent("vrp_spawn:spawnChar",source,true)
	TriggerEvent("baseModule:idLoaded",source,newId,model)
	TriggerEvent("ks-CharacterSpawn", source, newId)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETAR O PERSONAGEM
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent('sjr-character:server:deleteCharacter')
AddEventHandler('sjr-character:server:deleteCharacter', function(citizenid)
    local src = source
    vRP.execute("vRP/remove_characters",{ id = parseInt(citizenid) })
end)