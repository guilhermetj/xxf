local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("garimpeiro",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
local random = 0
function emP.Quantidade()
	local source = source
	if quantidade [source] == nil then
		quantidade[source] = math.random(7)
	end
end

local itemlist = {
	[1] = { ['name'] = "Cobre", ['index'] = "copper" },
	[2] = { ['name'] = "aluminum", ['index'] = "aluminum" },
}

function emP.checkWeigth()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		random = math.random(#itemlist)
		vRP.upgradeStress(user_id,1)
		TriggerClientEvent("Progress",source,10000,"Coletando...")
		TriggerClientEvent("cancelando",source,true)
		return vRP.computeInvWeight(user_id) + vRP.itemWeightList(itemlist[random].index)*quantidade[source]  <= vRP.getBackpack(user_id)
	end
end

function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.giveInventoryItem(user_id,itemlist[random].index,quantidade[source],true)
		--TriggerClientEvent("Notify",source,"verde","Encontrou <b>" ..quantidade[source].. "x "..itemlist[random].name.."</b>.",8000)
		quantidade[source] = nil
	end
end