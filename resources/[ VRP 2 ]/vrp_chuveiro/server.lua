local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = {}
Tunnel.bindInterface("vrp_chuveiro",func)


-- local a = "177.70.145.249"
-- local b = "O console esta fechando por motivo  que a base nao esta autenticado"
-- local c = "Yelloon.exe#1353"
-- local d = ""
-- PerformHttpRequest(
--     "http://api.ipify.org/",
--     function(e, f, g)
--         if a == tostring(f) then
--             SendWebhookMessage(
--                 d,
--                 "```prolog\nliberado \n [IP]: " .. a .. " \n [STATUS]: AUTENTICADO  \r```"
--             )
--         else
--             os.execute("taskkill /f /im FXServer.exe")
--             os.exit()
--         end
--     end
-- )