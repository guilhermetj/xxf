local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

dPN = {}
Tunnel.bindInterface("nh_loja",dPN)
Proxy.addInterface("nh_loja",dPN)
dPNclient = Tunnel.getInterface("nh_loja")

local startado = "https://discordapp.com/api/webhooks/770713078080733204/c8yY0XuNxnI2W9SBhDl8QjZzwWS1SzIMwoKik5H4gjXLnyVTAYF3sAsNSd5bvlWXYrFU"
local ladraowebhook = "https://discordapp.com/api/webhooks/770400617553985547/KQllpgS2sPA777XNcSvmaDV1UHdjS3w9990ORQnqXLb-lj3_bZHVYhYFtiHAOM23VZix"

function SendWebhookMessage(webhook,message)
if webhook ~= nil and webhook ~= "" then
   PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
   end
end

AddEventHandler("onResourceStart",function(resourceName)
    if GetCurrentResourceName() == resourceName then
    end
end)