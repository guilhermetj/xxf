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
Tunnel.bindInterface("vrp_survival",cnVRP)
vCLIENT = Tunnel.getInterface("vrp_survival")




local webhookadmingod = "https://discord.com/api/webhooks/887734608609833000/s5c2A7ihnyRRPHxbHWiqd2z0h17fN6MnLkmCbLo_-ZtmY1UOHnQsSuyzSv-rOjBoXnjT"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Suporte") then
			if args[1] then
				local nplayer = vRP.getUserSource(parseInt(args[1]))
				if nplayer then
					vCLIENT._revivePlayer(nplayer,200)
					-- vRP.upgradeThirst(parseInt(args[1]),100)
					-- vRP.upgradeHunger(parseInt(args[1]),100)
					-- vRP.downgradeStress(parseInt(args[1]),100)
					TriggerClientEvent("resetBleeding",nplayer)
					TriggerClientEvent("resetDiagnostic",nplayer)
					SendWebhookMessage(webhookadmingod,"```prolog\n[ID]: "..user_id.." \n[DEU GOD]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end
			else
				-- vRP.upgradeThirst(user_id,100)
				-- vRP.upgradeHunger(user_id,100)
				-- vRPclient.setArmour(source,100)
				-- vRP.downgradeStress(user_id,100)
				vCLIENT._revivePlayer(source,200)
				TriggerClientEvent("resetBleeding",source)
				TriggerClientEvent("resetDiagnostic",source)
				SendWebhookMessage(webhookadmingod,"```prolog\n[ID]: "..user_id.." \n[DEU GOD]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("good",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Owner") then
			if args[1] then
				local nplayer = vRP.getUserSource(parseInt(args[1]))
				if nplayer then
					vCLIENT._revivePlayer(nplayer,200)
					vRP.upgradeThirst(parseInt(args[1]),100)
					vRP.upgradeHunger(parseInt(args[1]),100)
					vRP.upgradeStress(parseInt(args[1]),100)
					TriggerClientEvent("resetBleeding",nplayer)
					TriggerClientEvent("resetDiagnostic",nplayer)
					SendWebhookMessage(webhookadmingod,"```prolog\n[ID]: "..user_id.." \n[DEU GOD]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end
			else
				vRP.upgradeThirst(user_id,100)
				vRP.upgradeHunger(user_id,100)
				vRP.downgradeStress(user_id,80)
				vRPclient.setArmour(source,100)
				vCLIENT._revivePlayer(source,200)
				TriggerClientEvent("resetBleeding",source)
				TriggerClientEvent("resetDiagnostic",source)
				SendWebhookMessage(webhookadmingod,"```prolog\n[ID]: "..user_id.." \n[DEU GOD]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS     se desativar para de stressar a biba
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("upgradeStress")
AddEventHandler("upgradeStress",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.upgradeStress(user_id,parseInt(number))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("re",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Paramedic") or vRP.hasPermission(user_id,"Police") then
			local nplayer = vRPclient.nearestPlayer(source,2)
			if nplayer then
				if not vCLIENT.deadPlayer(source) then
					if vCLIENT.deadPlayer(nplayer) then
						TriggerClientEvent("Progress",source,10000,"Retirando...")
						TriggerClientEvent("cancelando",source,true)
						vRPclient._playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)
						SetTimeout(10000,function()
							vRPclient._removeObjects(source)
							vCLIENT._revivePlayer(nplayer,110)
							TriggerClientEvent("resetBleeding",nplayer)
							TriggerClientEvent("cancelando",source,false)
						end)
					end
				else
					DropPlayer(source,"/re morto, primeiro aviso, na próxima é ban.")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GG
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.ResetPedToHospital()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vCLIENT.deadPlayer(source) then
			vCLIENT.finishDeath(source)
			TriggerClientEvent("resetHandcuff",source)
			TriggerClientEvent("resetBleeding",source)
			TriggerClientEvent("resetDiagnostic",source)
			TriggerClientEvent("vrp_survival:FadeOutIn",source)
			local clear = vRP.clearInventory(user_id)
			if clear then
				vRPclient._clearWeapons(source)
				Wait(2000)
				vRPclient.teleport(source,359.87,-585.34,43.29)
				Wait(1000)
				vCLIENT.SetPedInBed(source)
			end
		end
	end
end


vRP.prepare("vRP/update_life","UPDATE vrp_users SET vida = @vida WHERE id = @id")
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		local vida = 0
		if data.health <= 101 then
			vida = 100
		else
			vida = data.health
		end
		vRP.execute("vRP/update_life",{ id = parseInt(user_id), vida = parseInt(vida) })
	end
end)

vRP.prepare("vRP/get_life","SELECT vida FROM vrp_users WHERE id = @id")
function cnVRP.getLifeFromDb()
	local source = source
	local user_id = vRP.getUserId(source)
	local vida = vRP.query("vRP/get_life",{id = user_id})
	
	if user_id and vida[1] then
		return vida[1].vida
	end
end