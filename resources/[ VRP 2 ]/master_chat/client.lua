RegisterCommand("lojavip", function()
    msg("Você já viu a nossa promoção na loja ? ")
    msg("Não ? entre no site www.google.com e garanta já")
end, false)

function msg(text)
    TriggerEvent("chatMessage", "{Sua-Cidade}", {0,0,255}, text)
end


------DISPONIBILIZADO POR Midnight Community 
------https://discord.gg/Xg8cZhcPbT