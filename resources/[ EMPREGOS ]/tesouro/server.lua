local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("tesouro",cRP)
vCLIENT = Tunnel.getInterface("tesouro")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS TESOURO
-----------------------------------------------------------------------------------------------------------------------------------------
local tesouros = {
	[1] = { item = "watch", nome = "Relogio(s) Roubado(s)" },
	[2] = { item = "bracelet", nome = "Pulseira(s) Roubada(s)" },
	[3] = { item = "ring", nome = "Anel(s) Roubado(s)" },
	[4] = { item = "copper", nome = "Placa(s) Copper(s)" }
}

function cRP.checkPayment()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
    local quantidade = math.random(5,13)
    local tesouro = tesouros[math.random(4)]
        if vRP.computeInvWeight(user_id) + 1 > vRP.getBackpack(user_id) then
            TriggerClientEvent("Notify",source,"vermelho","A sua Mochila está cheia.",5000)
            return
        end
        vRP.giveInventoryItem(user_id,tesouro.item,quantidade, true)
    end
end

RegisterCommand("mergulhador",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vCLIENT.toggleService(source)
	end
end)
