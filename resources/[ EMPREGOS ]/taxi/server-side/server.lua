-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("taxi",cRP)
vCLIENT = Tunnel.getInterface("taxi")

-----------------------------------------------------------------------------------------------------------------------------------------
-- INITSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.initService(bolean)
    local src = source
    local user_id = vRP.getUserId(src)
    if bolean then
        TriggerClientEvent("Notify",src,"verde","Você entrou em serviço.",1000)
        vRP.execute("vRP/add_group",{ user_id = parseInt(user_id), permiss = "Taxi" })
        return true
    else
        TriggerClientEvent("Notify",src,"vermelho","Você saiu de serviço.",1000)
        vRP.execute("vRP/del_group",{ user_id = parseInt(user_id), permiss = "Taxi" })
        return true
    end
    return 
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentService()
    local src = source
    local user_id = vRP.getUserId(src)
    local value = math.random(300,500)
    if user_id then
        vRP.giveInventoryItem(user_id,"dollars",value,true)
    end
end