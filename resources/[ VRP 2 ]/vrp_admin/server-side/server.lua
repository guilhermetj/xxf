-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("vrp_admin",cnVRP)
vCLIENT = Tunnel.getInterface("vrp_admin")
vHOMES = Tunnel.getInterface("vrp_homes")

local screenshotOptions = {
	encoding = 'png',
	quality = 1
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookadmin = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookkick = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookfac = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookkeys = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookcds = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookblacklist = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookgive = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookban = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookadminwl = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookunwl = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookadmingod = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookinfernao = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhooktroxao = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"
local webhookaddcar = "https://discord.com/api/webhooks/887738710102269972/7Nwm1sysfG9Y3dAxGmmn_-9jhWHelTrdrMPMbXghPvcTxVPWEYxSoreHoaQL70L5n702"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- KICKALL
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("kickall",function(source,args,rawCommand)
-- 	if source == 0 then
-- 		local users = vRP.getUsers()
-- 	    for k,v in pairs(users) do
-- 		   local user_idk = vRP.getUserId(v)
-- 		   TriggerClientEvent("vrp_admin:KickAll",users)
		  
-- 		   vRP.kick(parseInt(user_idk),"Terremoto!")
-- 		end
-- 	end
-- end)

RegisterCommand('baguncinha',function(source,args,rawCommand)
local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.hasPermission(user_id,"baguncinha2") then
		vRPclient.giveWeapons(player,{
		["WEAPON_COMBATPISTOL"] = {ammo=250}, -- Pistola de Combate
		["WEAPON_CARBINERIFLE"] = {ammo=500},
		["WEAPON_CARBINERIFLE_MK2"] = {ammo=500},
		["WEAPON_SPECIALCARBINE"] = {ammo=500},
		["WEAPON_SNOWBALL"] = {ammo=500},
		["WEAPON_BULLPUPRIFLE"] = {ammo=500},
		["WEAPON_SMG"] = {ammo=500},
		["WEAPON_SMG_MK2"] = {ammo=500},
		["WEAPON_SPECIALCARBINE_MK2"] = {ammo=500},
		["WEAPON_RAILGUN"] = {ammo=500},
		["WEAPON_HOMINGLAUNCHER"] = {ammo=500},
		["WEAPON_RAYPISTOL"] = {ammo=500},
		["WEAPON_RAYCARBINE"] = {ammo=500},
		["WEAPON_RAYMINIGUN"] = {ammo=500},
		["WEAPON_RPG"] = {ammo=500},
		["WEAPON_MARKSMANPISTOL"] = {ammo=500},
		["WEAPON_STICKYBOMB"] = {ammo=500}
	}, true)
	end
end)

RegisterCommand('limparinv',function(source,args,rawCommand)
	local source = source
	TriggerClientEvent("clearWeapons",source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BVIDA
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterServerEvent('vrp_admin:bvida')
AddEventHandler('vrp_admin:bvida', function()
	local user_id = vRP.getUserId(source)		
	vRPclient._setCustomization(source,vRPclient.getCustomization(source))
	vRP.removeCloak(source)	
end)]]--
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("say",function(source,args,rawCommand)
	if source == 0 then
		TriggerClientEvent("Notify",-1,"vermelho",rawCommand:sub(4).."<br><b>Mensagem enviada por:</b> Governador",15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- clearinventario
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('clearinv',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)
    if vRP.hasPermission(user_id,"Owner") or vRP.hasPermission(user_id,"Admin")or vRP.hasPermission(user_id,"PolMaster") then
        if args[1] then
            local tuser_id = tonumber(args[1])
            local tplayer = vRP.getUserSource(tonumber(tuser_id))
            local tplayerID = vRP.getUserId (tonumber(tplayer))
                if tplayerID ~= nil then
                local identity = vRP.getUserIdentity(user_id)
                    vRP.clearInventory(tuser_id)
                    TriggerClientEvent("Notify",source,"verde","Limpou inventario do ID "..args[1].."</b>.",6000)
                else
                    TriggerClientEvent("Notify",source,"vermelho","O usuário não foi encontrado ou está offline.",6000)
            end
        else
            vRP.clearInventory(user_id)
            TriggerClientEvent("Notify",source,"verde","Você limpou seu inventário.",6000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local identity = vRP.getUserIdentity(user_id)
	if identity then
		vCLIENT.setDiscord(source,"#"..user_id.." "..identity.name.." "..identity.name2)
		TriggerClientEvent(source,'active:checkcam',true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('skin',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"Owner") then
		TriggerClientEvent("skinmenu",args[1],args[2])
		TriggerClientEvent("Notify",source,"vermelho","Voce setou a skin <b>"..args[2].."</b> no passaporte <b>"..parseInt(args[1]).."</b>.",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") then
			if args[1] and args[2] and vRP.itemNameList(args[1]) ~= nil then
				vRP.giveInventoryItem(user_id,args[1],parseInt(args[2]),true)
				SendWebhookMessage(webhookgive,"```prolog\n[ID]: "..user_id.."\n[PEGOU]: "..args[1].." \n[QUANTIDADE]: "..parseInt(args[2]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("debug",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			TriggerClientEvent("ToggleDebug",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("plate",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") and args[1] and args[2] and args[3] then
			vRP.execute("vRP/update_plate_vehicle",{ user_id = parseInt(args[1]), vehicle = args[2], plate = args[3] })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addcar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") or vRP.hasPermission(user_id,"Admin") and args[1] and args[2] then
			vRP.execute("vRP/add_vehicle",{ user_id = parseInt(args[1]), vehicle = args[2], plate = vRP.generatePlateNumber(), phone = vRP.getPhone(args[1]), work = tostring(false) })
			TriggerClientEvent("Notify",args[1],"roxo","Voce recebeu <b>"..args[2].."</b> em sua garagem.",5000)
			TriggerClientEvent("Notify",source,"roxo","Adicionou o veiculo: <b>"..args[2].."</b> no ID:<b>"..args[1].."</b.")
			SendWebhookMessage(webhookaddcar,"```prolog\n[ID]: "..user_id.." \n[ADICIONOU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
		end
	end
end)

RegisterCommand("capuzz",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") and args[1] then
			TriggerClientEvent("vrp_hud:toggleHood",source,args[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.enablaNoclip()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") then
			vRPclient.noClip(source)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") and parseInt(args[1]) > 0 then
			vRP.kick(parseInt(args[1]),"Você foi expulso da cidade.")
			SendWebhookMessage(webhookkick,"```prolog\n[ID]: "..user_id.."\n[KICKOU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Owner") and parseInt(args[1]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				vRP.execute("vRP/set_banned",{ steam = tostring(identity.steam), banned = 1 })
				SendWebhookMessage(webhookban,"```prolog\n[ID]: "..user_id.." \n[BANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wl",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") then
			TriggerClientEvent("Notify",source,"verde","Whitelist aplicada ao id <b>"..tostring(args[1]).."</b>",5000)
			vRP.execute("vRP/set_whitelist",{ steam = tostring(args[1]), whitelist = 1 })
			SendWebhookMessage(webhookadminwl,"```prolog\n[ID]: "..user_id.."\n[APROVOU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unwl",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") and parseInt(args[1]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				TriggerClientEvent("Notify",source,"verde","Whitelist removida do id <b>"..tostring(args[1]).."</b>",5000)
				vRP.execute("vRP/set_whitelist",{ steam = tostring(identity.steam), whitelist = 0 })
				SendWebhookMessage(webhookunwl,"```prolog\n[ID]: "..user_id.."\n[RETIROU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Gemas",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				vRP.addGmsId(args[1],args[2])
				TriggerClientEvent("Notify",source,"roxo","Gemas entregues para "..identity.name.." #"..args[1]..".",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") and parseInt(args[1]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				vRP.execute("vRP/set_banned",{ steam = tostring(identity.steam), banned = 0 })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local fcoords = vRP.prompt(source,"Coordinates:","")
			if fcoords == "" then
				return
			end

			local coords = {}
			for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
				table.insert(coords,parseInt(coord))
			end
			vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local x,y,z,h = vRPclient.getPositions(source)
			vRP.prompt(source,"Coordinates:",x..","..y..","..z..","..h)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local identitynu = vRP.getUserIdentity(args[1])
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			if not vRP.hasPermission(parseInt(args[1]),tostring(args[2])) then
				vRP.createWeebHook("https://discord.com/api/webhooks/887741914231742465/maJLzNW5gUGaKH9Pcbt1oMqufwkOEcOBwF2tV3zAnh8LhV4Z2iMEl2qZY-XDpd8I-mx-","```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[SETOU O ID]: "..args[1].." \n[DE]: "..args[2].." "..identitynu.name.." "..identitynu.name2.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				vRP.insertPermission(parseInt(args[1]),tostring(args[2]))
				vRP.execute("vRP/add_group",{ user_id = parseInt(args[1]), permiss = tostring(args[2]) })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local identitynu = vRP.getUserIdentity(args[1])
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			if vRP.hasPermission(parseInt(args[1]),tostring(args[2])) then
				vRP.createWeebHook("https://discordapp.com/api/webhooks/827757026410102784/8Vl5mTp2e0UQ7-rfBO2gJU4JsuZMPmL0nLtE0I82GcZNaKW7HZUdt8XpyjghWv6xr2Ce","```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[TIROU O SET DO ID]: "..args[1].." \n[DE]: "..args[2].." "..identitynu.name.." "..identitynu.name2.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				vRP.removePermission(parseInt(args[1]),tostring(args[2]))
				vRP.execute("vRP/del_group",{ user_id = parseInt(args[1]), permiss = tostring(args[2]) })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") and parseInt(args[1]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPclient.teleport(nplayer,vRPclient.getPositions(source))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") and parseInt(args[1]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPclient.teleport(source,vRPclient.getPositions(nplayer))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") then
			vCLIENT.teleportWay(source)
		end
	end
end)




RegisterCommand("fome", function(source, args)
	local user_id = vRP.getUserId(source)
	vRP.upgradeHunger(user_id,tonumber(args[1] or 0))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMBO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) <= 101 then
			vCLIENT.teleportLimbo(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local vehicle = vRPclient.getNearVehicle(source,7)
			if vehicle then
				vCLIENT.vehicleHash(source,vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delnpcs",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			vCLIENT.deleteNpcs(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") then
			TriggerClientEvent("vrp_admin:vehicleTuning",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local vehicle,vehNet = vRPclient.vehList(source,11)
			if vehicle then
				TriggerClientEvent("vrp_inventory:repairVehicle",-1,vehNet,true)
				vRP.createWeebHook("https://discord.com/api/webhooks/887741552611455016/wosMP3toxRhz8J03gKF3lQ8-nJa5ZBVMAf9pTsdgeSTYqChvh7G7_bbTKWGyVkDn3X9S","```prolog\n[ID]: " ..user_id.. "\n[DEU FIX]" ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparea",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local x,y,z = vRPclient.getPositions(source)
			TriggerClientEvent("syncarea",-1,x,y,z,100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") then
			local quantidade = 0
			local users = vRP.getUsers()
			for k,v in pairs(users) do
				quantidade = parseInt(quantidade) + 1
			end
			TriggerClientEvent("Notify",source,"roxo","<b>Players Onlines:</b> "..quantidade,5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand("cplayers",function(source,args,rawCommand)
	if source == 0 then
		local quantidade = 0
		local users = vRP.getUsers()
		for k,v in pairs(users) do
			quantidade = parseInt(quantidade) + 1
		end
		print("Players Conectados: "..quantidade)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pon',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") then
		local users = vRP.getUsers()
		local players = ""
		local quantidade = 0
		for k,v in pairs(users) do
			if k ~= #users then
				players = players..", "
			end
			players = players..k
			quantidade = quantidade + 1
		end
		TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{1, 136, 0},quantidade)
		TriggerClientEvent('chatMessage',source,"ID's ONLINE",{1, 136, 0},players)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.buttonTxt()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local x,y,z,h = vRPclient.getPositions(source)
			vRP.updateTxt(user_id..".txt",x..","..y..","..z..","..h)
		end
	end
end



-- RegisterCommand("bvida",function(source,args,rawCommand)
-- 	local source = source
-- 	local user_id = vRP.getUserId(source)
-- 	local data = vRP.getUserDataTable(user_id)
-- 	local vida = vRPclient.getHealth(source)

-- 	if vida > 101 then
-- 		if data then
-- 			if data.customization then
-- 				data.customization = nil
-- 			end
		
-- 			if data.skin then
-- 				vRPclient.applySkin(source,data.skin)
-- 			end

-- 			if data.inventory == nil then
-- 				data.inventory = {}
-- 			end

-- 			vRPclient.playerReady(source)
			
-- 			TriggerClientEvent("bvidaFixVida",source,vida)
-- 			Citizen.Wait(1000)

-- 			if data.weapons then
-- 				vRPclient.giveWeapons(source,data.weapons,true)
-- 			end

-- 			-- VRP_SKINSHOP
-- 			local playerData = vRP.getUData(user_id,"Clothings")
-- 			local resultData = json.decode(playerData)
-- 			if resultData == nil then
-- 				resultData = "clean"
-- 			end
-- 			TriggerClientEvent("vrp_skinshop:skinData",source,resultData)
			
-- 			TriggerClientEvent("vrp_barbershop:setCustomizationBvida",source)
-- 			TriggerClientEvent('reloadtattos',source)	

-- 		end
		
-- 		vRPclient.stopAnim(source)
-- 		TriggerClientEvent("cancelando",source,false)
-- 		vRPclient._playerStateReady(source,true)
-- 	else
-- 		TriggerClientEvent("Notify",source,"vermelho","Você esta morto",15000)
-- 	end
-- end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("adm",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local message = vRP.prompt(source,"MENSAGEM DA PREFEITURA:","")
			if message == "" then
				return
			end

			TriggerClientEvent("Notify",-1,"rosa",message.."<br><b>Mensagem da Prefeitura </b>",15000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("chatp",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") then
			local message = vRP.prompt(source,"MENSAGEM DA POLICIA:","")
			if message == "" then
				return
			end

			TriggerClientEvent("Notify",-1,"roxo",message.."<br><b>Mensagem da Policia</b>",15000)
		end
	end
end)
------------------------- MEC ------------------------------

RegisterCommand("chatmec",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Mechanic") then
			local message = vRP.prompt(source,"MENSAGEM DA MECANICA:","")
			if message == "" then
				return
			end

			TriggerClientEvent("Notify",-1,"roxo",message.."<br><b>Mensagem da Mecanica</b>",15000)
		end
	end
end)
------------------------- hp ------------------------------
RegisterCommand("chathp",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Paramedic") then
			local message = vRP.prompt(source,"MENSAGEM HOSPITAL:","")
			if message == "" then
				return
			end

			TriggerClientEvent("Notify",-1,"roxo",message.."<br><b>Mensagem do HP</b>",15000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") then
			local users = vRP.getUsers()
			for k,v in pairs(users) do
				vRP.giveInventoryItem(parseInt(k),tostring(args[1]),parseInt(args[2]),true)
			end
		end
	end
end)
 -----------------------------------------------------------------------------------------------------------------------------------------
-- kickall
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kickall',function(source,args,rawCommand)
    if source == 0 then
        local users = vRP.getUsers()
        for k,v in pairs(users) do
            local kickei = vRP.getUserId(v)
            vRP.kick(parseInt(kickei),"Aconteceu um terremoto forte na INSIDECity")
        end
        print("TODOS FORAM KIKADOS!")
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
----[Resetar Personagem  /reset "id"     
-----------------------------------------------------------------------------------------------------------------------------------------

local webhookplastica = "https://discord.com/api/webhooks/887739923082399764/H6-VbOmyve6_qRvPDFNx3_KmV5HWWXHYuy3cGRBDzmqLXE4OanqjwIsf6-wkwjkrLFRq"

RegisterCommand('plastica',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"Owner") or vRP.hasPermission(user_id,"Paramedic") then
        if user_id then
            if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            local request = vRP.request(nplayer,"Você deseja realizar a Cirurgia Plastica?",60)
                if request then
                    local identity = vRP.getUserIdentity(parseInt(args[1]))
                    local id = vRP.getUserSource(parseInt(args[1]))
                    vRP.setUData(parseInt(args[1]),"datatable",json.encode(vRP.getUserDataTable(parseInt(args[1]))))
                   	vRP.setUData(parseInt(args[1]),"spawnController",parseInt(0))
                    TriggerClientEvent("Notify",source,"importante","Você realizou a cirurgia em: <b>"..parseInt(args[1]).." "..identity.name.." "..identity.name2.."</b> Parabens !",5000)
                    DropPlayer(id, "Voce entrou na sala de cirurgia, Daqui a pouco passa o efeito do analgesico.")
					SendWebhookMessage(webhookplastica,"```prolog\n[ID]: "..user_id.."\n[FEZ A CIRURGIA EM]: "..parseInt(args[1]).." "..identity.name..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                else
                    TriggerClientEvent("Notify",source,"negado","<b>O paciente recusou a Cirurgia Plastica.</b>",5000)
                end
            end
        end
    end
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remcar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") and args[1] and args[2] then
			vRP.execute("vRP/rem_vehicle",{ user_id = parseInt(args[1]), vehicle = args[2] })
			TriggerClientEvent("Notify",args[1],"importante","Foi removido <b>"..args[2].."</b> de sua garagem.",5000)
			TriggerClientEvent("Notify",source,"importante","VOCE REMOVEU: <b>"..args[2].."</b> DO ID:<b>"..args[1].."</b.",5000)	
			SendWebhookMessage(webhookaddcar,"```prolog\n[ID]: "..user_id.." \n[REMOVEU]: "..args[2].." \n[DO ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") -- COLOCAR WEBHOOK SEU
		end
	end
end)

