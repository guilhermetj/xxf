Config_server = {}

RegisterServerEvent("comprar:roupaDpn")
AddEventHandler("comprar:roupaDpn", function(preco)
    local user_id = vRP.getUserId(source)
    if preco then
        if vRP.tryPayment(user_id, preco) then
			TriggerClientEvent("Notify",source,"importante","Você fez um pagamento de R$ "..preco..".") 
            TriggerClientEvent('ComprarTudo', source, true)
        else
            TriggerClientEvent("Notify",source,"importante","Você não tem dinheiro suficiente",10000)
            TriggerClientEvent('ComprarTudo', source, false)
        end
    end
end)
