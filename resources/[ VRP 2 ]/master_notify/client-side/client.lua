-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css,mensagem,timer)
	SendNUIMessage({ css = css, mensagem = mensagem, timer = timer })
end)

--https://discord.gg/Xg8cZhcPbT