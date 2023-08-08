-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator() 

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
func = {}
Tunnel.bindInterface("vrp_inventory",func)
vCLIENT = Tunnel.getInterface("vrp_inventory")
vRPRAGE = Tunnel.getInterface("vrp_garages")
vSURVIVAL = Tunnel.getInterface("vrp_survival")
vPLAYER = Tunnel.getInterface("vrp_player")
vWEPLANTS = Tunnel.getInterface("vrp_weplants")
vWEPLANTSS = Tunnel.getInterface("vrp_weplants")
vHOMES = Tunnel.getInterface("vrp_homes")
vTASKBAR = Tunnel.getInterface("vrp_taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local active = {}
local weaponrechenger = {}
local firecracker = {}
local registerTimers = {}
local chanceDeQuebrarKitReparo = 10 -- % de chance para quebrar o Kit Reparo
local chanceDeQuebrarLockPickAcertar = 5 -- % de chance para quebrar a Lockpick acertando
local chanceDeQuebrarLockPickErrar = 5 -- % de chance para quebrar a Lockpick errando
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookdropar = ""
local webhookregistradora = ""
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(registerTimers) do
			if registerTimers[k][4] > 0 then
				registerTimers[k][4] = registerTimers[k][4] - 1

				if registerTimers[k][4] <= 0 then
					registerTimers[k] = nil
					TriggerClientEvent("vrp_inventory:updateRegister",-1,registerTimers)
				end
			end
		end
		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRECRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(firecracker) do
			if firecracker[k] > 0 then
				firecracker[k] = firecracker[k] - 30
				if firecracker[k] <= 0 then
					firecracker[k] = nil
				end
			end
		end
		Citizen.Wait(30000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(active) do
			if active[k] > 0 then
				active[k] = active[k] - 1
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
function func.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			local inventory = {}
			for k,v in pairs(inv) do
				if (parseInt(v.amount) <= 0 or vRP.itemBodyList(v.item) == nil) then
					vRP.removeInventoryItem(user_id,v.item,parseInt(v.amount),false)
				else
					if string.sub(v.item,1,9) == v.item then
						local advFile = LoadResourceFile("logsystem","toolboxes.json")
						local advDecode = json.decode(advFile)

						v.durability = advDecode[v.item]
					end

					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.peso = vRP.itemWeightList(v.item)
					v.description = vRP.itemDescList(v.item)
					v.tipo = vRP.itemTipoList(v.item)
					v.economy = vRP.itemEconomyList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.key = v.item
					v.slot = k

					inventory[k] = v
				end
			end

			local identity = vRP.getUserIdentity(user_id)
			return inventory,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),{ identity.name.." "..identity.name2,parseInt(user_id),parseInt(identity.bank),parseInt(vRP.getGmsId(user_id)),identity.phone,identity.registration }
		end
	end
end

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
  end
  -----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPON_AMMOS
-----------------------------------------------------------------------------------------------------------------------------------------
local weapon_ammos = {
	["WEAPON_PISTOL_AMMO"] = {
		"WEAPON_PISTOL",
		"WEAPON_PISTOL_MK2",
		"WEAPON_APPISTOL",
		"WEAPON_HEAVYPISTOL",
		"WEAPON_SNSPISTOL",
		"WEAPON_SNSPISTOL_MK2",
		"WEAPON_VINTAGEPISTOL",
		"WEAPON_PISTOL50",
		"WEAPON_REVOLVER",
		"WEAPON_COMBATPISTOL"
	},
	["WEAPON_SMG_AMMO"] = {
		"WEAPON_COMPACTRIFLE",
		"WEAPON_MICROSMG",
		"WEAPON_MINISMG",
		"WEAPON_SMG",
		"WEAPON_ASSAULTSMG",
		"WEAPON_GUSENBERG",
		"WEAPON_MACHINEPISTOL"
	},
	["WEAPON_RIFLE_AMMO"] = {
		"WEAPON_CARBINERIFLE",
		"WEAPON_SPECIALCARBINE",
		"WEAPON_ASSAULTRIFLE",
		"WEAPON_ASSAULTRIFLE_MK2"
	},
	["WEAPON_SHOTGUN_AMMO"] = {
		"WEAPON_PUMPSHOTGUN",
		"WEAPON_SAWNOFFSHOTGUN"
	},
	["WEAPON_PETROLCAN_AMMO"] = {
		"WEAPON_PETROLCAN"
	}
}

local function checkWeaponByAmmo(ammo, weapon)
	local is_w = weapon_ammos[ammo]
	if is_w then
		for k, v in pairs(is_w) do
			if v == weapon then
				return true
			end
		end
	end
	return false
end
local function getAmmoTypeByWeapon(wea)
	for ammo, weapons in pairs(weapon_ammos) do
		for _, weapon in pairs(weapons) do
			if weapon  == wea then
				return ammo
			end
		end
	end
	return ""
end

local webwookgarmas = ''

RegisterCommand('garmas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local rtime = math.random(3,8)
    local munni = ''

    local logweapons = ''
    local logammos = ''
    if checkpolice(user_id) then
        TriggerClientEvent("Notify",source,"amarelo","<b>Aguarde!</b> Suas armas estão sendo desequipadas.",9500)
        TriggerEvent("Progress",10000,"Guardando")
        SetTimeout(1000*rtime,function()
            if user_id then
                local weapons = vRPclient.replaceWeapons(source,{})
                for k,v in pairs(weapons) do
                    vRP.giveInventoryItem(user_id,k,1)
                    logweapons = logweapons.." | "..k
                    if v.ammo > 0 then
                        for m,n in pairs(weapon_ammos) do
                            for t,j in pairs(n) do
                                if j == k then
                                    munni = m
                                    break
                                end
                            end
                        end
                        logammos = logammos.." | "..munni.." [QNT] "..v.ammo
                        vRP.giveInventoryItem(user_id,munni,v.ammo)
                    end
                end

                SendWebhookMessage(webwookgarmas,"```prolog\n[USOU GARMAS][PLAYER ID]: » "..user_id.."\n[ARMA] "..logweapons.."\n[MUNICAO]: "..logammos.. ""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                TriggerClientEvent("Notify",source,"verde","Guardou seu armamento na mochila.")
            end
        end)
    end
end)

function checkpolice(userr)
    if vRP.hasPermission(userr,"police.perm") then
        return false
    elseif vRP.hasPermission(userr,"whitepolice.perm") then
        return false
    end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:updateSlot")
AddEventHandler("vrp_inventory:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	

	if user_id then
		TriggerClientEvent("vrp_sound:source",source,"slot",0.1)
			if amount == nil then amount = 1 end
			if amount <= 0 then amount = 1 end
			local inv = vRP.getInventory(user_id)
			if inv then
				if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then

					--print("==================")
					--print(slot)
					--print("--")
					--print(target)
					--print("==================")

					if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
						vRP.giveInventoryItem(user_id,itemName,amount,false,target)
					end
				else
					local weapons = vRP.getWeaponsId(user_id)
					for k, v in pairs(weapons) do
						local ammoType = getAmmoTypeByWeapon(itemName)
						if v.weapon == ammoType then
							vRP.execute("vRP/del_weapon", { user_id = user_id, weapon = ammoType })
							vRP.giveInventoryItem(user_id,ammoType,v.ammo,false) -- ??
							TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
							break														
						end
					end
					vRP.swapSlot(user_id,slot,target)
				end
			end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:populateSlot")
AddEventHandler("vrp_inventory:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
			vRP.giveInventoryItem(user_id,itemName,amount,false,target)
			TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
		end
	end
	TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:useItem")
AddEventHandler("vrp_inventory:useItem",function(slot,rAmount)
	local source = source
    local user_id = vRP.getUserId(source)
	if user_id then
		if rAmount == nil then rAmount = 1 end
		if rAmount <= 0 then rAmount = 1 end

		if active[user_id] == nil then
			local inv = vRP.getInventory(user_id)
			if inv then
				if not inv[tostring(slot)] or inv[tostring(slot)].item == nil then
					return
				end

				local itemName = inv[tostring(slot)].item
				
				if vRP.itemTypeList(itemName) == "use" then
					vCLIENT.removeWeaponInHand(source)
					if itemName == "bandage" then
						if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 200 then
							active[user_id] = 40
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,40000,"Utilizando...")
							vRPclient._playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._stopAnim(source,false)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRP.upgradeStress(user_id,2)
										vRPclient.updateHealth(source,15)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "analgesic" then
						if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 200 then
							active[user_id] = 6
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,6000,"Utilizando...")
							vRPclient._playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._stopAnim(source,false)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRP.upgradeStress(user_id,1)
										vRPclient.updateHealth(source,2)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "weed" then
						if vRP.getInventoryItemAmount(user_id,"weed") >= parseInt(rAmount) and vRP.getInventoryItemAmount(user_id,"silk") >= parseInt(rAmount) then
						active[user_id] = parseInt(rAmount*3)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,parseInt(rAmount*3000),"Utilizando...")

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,"weed",parseInt(rAmount),true,slot) and vRP.tryGetInventoryItem(user_id,"silk",parseInt(rAmount),true) then
										vRP.giveInventoryItem(user_id,"joint",parseInt(rAmount),true)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não tem uma seda.",5000)
						end
					end

					if itemName == "joint" then
						if vRP.getInventoryItemAmount(user_id,"lighter") <= 0 then
							TriggerClientEvent("Notify",source,"amarelo","Você não tem um isqueiro.",5000)
							return
						end
						
						active[user_id] = 60
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,60000,"Fumando...")
						vRPclient._createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._removeObjects(source)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.weedTimer(user_id,2)
									vRP.downgradeHunger(user_id,10)
									vRP.downgradeThirst(user_id,10)
									vRP.downgradeStress(user_id,15)
									vPLAYER.movementClip(source,"move_m@shadyped@a")
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "lean" then
						active[user_id] = 6
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,6000,"Utilizando...")
						vRPclient._playAnim(source,true,{"mp_suicide","pill"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._stopAnim(source,false)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									vRP.downgradeStress(user_id,50)
									--TriggerClientEvent("cleanEffectDrugs",source)
									TriggerClientEvent("setMeth",source)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "ecstasy" then
						active[user_id] = 6
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,6000,"Utilizando...")
						vRPclient._playAnim(source,true,{"mp_suicide","pill"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._stopAnim(source,false)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									TriggerClientEvent("setEcstasy",source)
									TriggerClientEvent("setEnergetic",source,10,1.45)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "meth" then
						active[user_id] = 6
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,6000,"Utilizando...")
						vRPclient._playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._stopAnim(source)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									vRPclient.setArmour(source,20)
									TriggerClientEvent("setMeth",source)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cigarette" then
						if vRP.getInventoryItemAmount(user_id,"lighter") <= 0 then
							TriggerClientEvent("Notify",source,"amarelo","Você não tem um isqueiro.",5000)
							return
						end

						active[user_id] = 60
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,60000,"Fumando...")
						vRPclient._createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._removeObjects(source)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.downgradeStress(user_id,15)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "vape" then
						active[user_id] = 60
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,60000,"Fumando...")
						vRPclient._createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","ba_prop_battle_vape_01",49,18905,0.08,-0.00,0.03,-150.0,90.0,-10.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRP.downgradeStress(user_id,10)
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "warfarin" then
						if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 200 then
							active[user_id] = 60
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,60000,"Utilizando...")
							vRPclient._createObjects(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._removeObjects(source)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRPclient.updateHealth(source,45)
										TriggerClientEvent("resetBleeding",source)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "gauze" then
						if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 200 then
							active[user_id] = 3
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,3000,"Utilizando...")
							vRPclient._playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._stopAnim(source,false)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										TriggerClientEvent("resetBleeding",source)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "premiumgarage" then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
						    vRP.execute("vRP/update_garages",{ id = parseInt(user_id) })
						    TriggerClientEvent("Notify",source,"vermelho","Voce adicionou uma vaga na garagem.",5000)
						end
					end

					if itemName == "binoculars" then
						active[user_id] = 2
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,2000,"Utilizando...")

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._createObjects(source,"amb@world_human_binoculars@male@enter","enter","prop_binoc_01",50,28422)
								Citizen.Wait(750)
								TriggerClientEvent("useBinoculos",source)
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "camera" then
						active[user_id] = 2
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,2000,"Utilizando...")

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._createObjects(source,"amb@world_human_paparazzi@male@base","base","prop_pap_camera_01",49,28422)
								Citizen.Wait(100)
								TriggerClientEvent("useCamera",source)
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cellphone" then
						TriggerClientEvent("gcPhone:activePhone",source)
					end

					if itemName == "adrenaline" then
						local distance = vCLIENT.adrenalineDistance(source)
						local parAmount = vRP.numPermission("")
						if parseInt(#parAmount) > 0 and not distance then
							return
						end

						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								if vSURVIVAL.deadPlayer(nplayer) then
									active[user_id] = 10
									vRPclient.stopActived(source)
									vCLIENT.closeInventory(source)
									vCLIENT.blockButtons(source,true)
									TriggerClientEvent("Progress",source,10000,"Utilizando...")
									vRPclient._playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											vSURVIVAL._reverseRevive(source)
											vCLIENT.blockButtons(source,false)

											if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
												vRP.upgradeStress(user_id,10)
												vRP.upgradeStress(nuser_id,10)
												vRP.upgradeThirst(nuser_id,10)
												vRP.upgradeHunger(nuser_id,10)
												vRP.chemicalTimer(nuser_id,1)
												vSURVIVAL._revivePlayer(nplayer,110)
												TriggerClientEvent("resetBleeding",nplayer)
											end
										end
										Citizen.Wait(0)
									until active[user_id] == nil
								end
							end
						end
					end

					if itemName == "teddy" then
						vCLIENT.closeInventory(source)
						vRPclient._createObjects(source,"impexp_int-0","mp_m_waremech_01_dual-0","v_ilev_mr_rasberryclean",49,24817,-0.20,0.46,-0.016,-180.0,-90.0,0.0)
					end

					if itemName == "rose" then
						vCLIENT.closeInventory(source)
						vRPclient._createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","prop_single_rose",49,18905,0.13,0.15,0.0,-100.0,0.0,-20.0)
					end

					if itemName == "identity" then
						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer then
							local identity = vRP.getUserIdentity(user_id)
							if identity then
								TriggerClientEvent("Notify",nplayer,"roxo","<b>Passaporte:</b> "..vRP.format(parseInt(identity.id)).."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone,10000)
							end
						end
					end

					if itemName == "bonusDelivery" then
						local myBonus = vRP.bonusDelivery(user_id)
						if parseInt(myBonus) >= 100 then
							return
						end

						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vRP.setBonusDelivery(user_id,1)
							TriggerClientEvent("Notify",source,"roxo","O nível de experiência no <b>Delivery</b> aumentou.",5000)
						end
					end

					if itemName == "bonusPostOp" then
						local myBonus = vRP.bonusPostOp(user_id)
						if parseInt(myBonus) >= 100 then
							return
						end

						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vRP.setbonusPostOp(user_id,1)
							TriggerClientEvent("Notify",source,"roxo","O nível de experiência no <b>Entregador</b> aumentou.",5000)
						end
					end

					if itemName == "firecracker" then
						if firecracker[user_id] == nil then
							active[user_id] = 3
							firecracker[user_id] = 250
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,3000,"Utilizando...")
							vRPclient._playAnim(source,false,{"anim@mp_fireworks","place_firework_3_box"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._stopAnim(source,false)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										TriggerClientEvent("vrp_inventory:Firecracker",source)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "gsrkit" then
						local nplayer = vRPclient.nearestPlayer(source,5)
						if nplayer then
							if vPLAYER.getHandcuff(nplayer) then
								active[user_id] = 10
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								TriggerClientEvent("Progress",source,10000,"Utilizando...")

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										vCLIENT.blockButtons(source,false)

										if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
											local check = vPLAYER.gsrCheck(nplayer)
											if parseInt(check) > 0 then
												TriggerClientEvent("Notify",source,"verde","Resultado positivo.",5000)
											else
												TriggerClientEvent("Notify",source,"vermelho","Resultado negativo.",3000)
											end
										end
									end
									Citizen.Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "gdtkit" then
						local nplayer = vRPclient.nearestPlayer(source,5)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								active[user_id] = 10
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								TriggerClientEvent("Progress",source,10000,"Utilizando...")

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										vCLIENT.blockButtons(source,false)

										if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
											local weed = vRP.weedReturn(nuser_id)
											local chemical = vRP.chemicalReturn(nuser_id)
											local alcohol = vRP.alcoholReturn(nuser_id)
											local chemStr = ""
											local alcoholStr = ""
											local weedStr = ""

											if chemical == 0 then
												chemStr = "Nenhum"
											elseif chemical == 1 then
												chemStr = "Baixo"
											elseif chemical == 2 then
												chemStr = "Médio"
											elseif chemical >= 3 then
												chemStr = "Alto"
											end

											if alcohol == 0 then
												alcoholStr = "Nenhum"
											elseif alcohol == 1 then
												alcoholStr = "Baixo"
											elseif alcohol == 2 then
												alcoholStr = "Médio"
											elseif alcohol >= 3 then
												alcoholStr = "Alto"
											end

											if weed == 0 then
												weedStr = "Nenhum"
											elseif weed == 1 then
												weedStr = "Baixo"
											elseif weed == 2 then
												weedStr = "Médio"
											elseif weed >= 3 then
												weedStr = "Alto"
											end

											TriggerClientEvent("Notify",source,"roxo","<b>Químicos:</b> "..chemStr.."<br><b>Álcool:</b> "..alcoholStr.."<br><b>Drogas:</b> "..weedStr,8000)
										end
									end
									Citizen.Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "vest" then
						active[user_id] = 10
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._playAnim(source,true,{"clothingtie","try_tie_negative_a"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._stopAnim(source,false)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRPclient.setArmour(source,100)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "GADGET_PARACHUTE" then
						active[user_id] = 10
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")

						repeat	
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vCLIENT.parachuteColors(source)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "skate" then
						active[user_id] = 3
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,3000,"Utilizando...")

						repeat	
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								TriggerClientEvent("skate",source)
								
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "toolbox" then
						if not vRPclient.inVehicle(source) then
							local vehicle,vehNet = vRPclient.vehList(source,3)
							if vehicle then
								active[user_id] = 10
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vRPclient._playAnim(source,false,{"mini@repair","fixing_a_player"},true)
								vRP.createDurability(itemName)
								if math.random(100) <= chanceDeQuebrarKitReparo then
									TriggerClientEvent("Notify",source,"amarelo","Seu kit reparo quebrou.",7000)
									vRP.tryGetInventoryItem(user_id,"toolbox",1)
								end
								local taskResult = vTASKBAR.taskThree(source)
								if taskResult then
									vRP.upgradeStress(user_id,2)
									TriggerClientEvent("vrp_inventory:repairVehicle",-1,vehNet,true)
									TriggerClientEvent("Notify",source,"amarelo","Carro arrumado com sucesso.",7000)
								else
									TriggerClientEvent("Notify",source,"amarelo","Voce falhou.",7000)
								end

								vRPclient._stopAnim(source,false)
								active[user_id] = nil
							end
						end
					end

					if itemName == "militec" then
						if not vRPclient.inVehicle(source) then
							local vehicle,vehNet = vRPclient.vehList(source,3)
							if vehicle then
								active[user_id] = 30
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vRPclient._playAnim(source,false,{"mini@repair","fixing_a_player"},true)
								vRP.createDurability(itemName)
								TriggerClientEvent("Notify",source,"amarelo","Você gastou uma militec",7000)
								vRP.tryGetInventoryItem(user_id,"militec",1)
								local taskResult = vTASKBAR.taskThree(source)
								if taskResult then
									vRP.upgradeStress(user_id,2)
									TriggerClientEvent("vrp_inventory:repararMotor",-1,vehNet,true)
									TriggerClientEvent("Notify",source,"amarelo","Motor arrumado com sucesso.",7000)
								else
									TriggerClientEvent("Notify",source,"amarelo","Voce falhou.",7000)
								end

								vRPclient._stopAnim(source,false)
								active[user_id] = nil
							end
						end
					end

					if itemName == "lockpick" then
						local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock,vehHealth,vehModel,vehClass = vRPclient.vehList(source,3)
						if vehicle and vehClass ~= 15 and vehClass ~= 16 then
							if vRPclient.inVehicle(source) then
								active[user_id] = 100
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								vRPRAGE.startAnimHotwired(source)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									if math.random(100) <= chanceDeQuebrarLockPickAcertar then
										TriggerClientEvent("Notify",source,"amarelo","Sua Lockpick quebrou",7000)
										vRP.tryGetInventoryItem(user_id,"lockpick",1)
									end
									vRP.upgradeStress(user_id,4)
									local iddoroubado = vRP.getVehiclePlate(vehPlate)
									if iddoroubado and math.random(100) >= 50 then
										TriggerClientEvent("Notify",source,"amarelo","O alarme do seu veículo <b>"..vRP.vehicleName(vehName).."</b> foi acionado.",7000)
									end
									if math.random(100) >= 20 then
										TriggerEvent("setPlateEveryone",vehPlate)
										TriggerEvent("setPlatePlayers",vehPlate,user_id)
									end

									if math.random(100) >= 75 then
										local x,y,z = vRPclient.getPositions(source)
										local copAmount = vRP.numPermission("Police")
										for k,v in pairs(copAmount) do
											async(function()
												TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), text = "Opa tem um cara aqui no bairro querendo roubar um carro!", code = 31, title = "Roubo de Veículo", x = x, y = y, z = z, vehicle = vRP.vehicleName(vehName).." - "..vehPlate, rgba = {15,110,110} })
											end)
										end
									end
								else
									if math.random(100) <= chanceDeQuebrarLockPickErrar then
										TriggerClientEvent("Notify",source,"amarelo","Sua Lockpick quebrou e você falhou",7000)
										vRP.tryGetInventoryItem(user_id,"lockpick",1)
									else
										TriggerClientEvent("Notify",source,"amarelo","Voce falhou, tente novamente.",7000)
									end
								end

								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end

								vCLIENT.blockButtons(source,false)
								vRPRAGE.stopAnimHotwired(source,vehicle)
								active[user_id] = nil
							else
								active[user_id] = 100
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								vRPclient._playAnim(source,false,{"missfbi_s4mop","clean_mop_back_player"},true)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									if math.random(100) <= chanceDeQuebrarLockPickAcertar then
										TriggerClientEvent("Notify",source,"amarelo","Sua Lockpick quebrou",7000)
										vRP.tryGetInventoryItem(user_id,"lockpick",1)
									end
									vRP.upgradeStress(user_id,4)
									local iddoroubado = vRP.getVehiclePlate(vehPlate)
									if iddoroubado then
										TriggerClientEvent("Notify",source,"amarelo","Veículo <b>"..vRP.vehicleName(vehName).."</b> foi roubado.",7000)
									end
									if math.random(100) >= 50 then
										TriggerEvent("setPlateEveryone",vehPlate)
										TriggerClientEvent("vrp_inventory:lockpickVehicle",-1,vehNet)
									end

									if math.random(100) >= 75 then
										local x,y,z = vRPclient.getPositions(source)
										local copAmount = vRP.numPermission("Police")
										for k,v in pairs(copAmount) do
											async(function()
												TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), text = "Opa tem um cara aqui no bairro querendo roubar um carro!", code = 31, title = "Roubo de Veículo", x = x, y = y, z = z, vehicle = vRP.vehicleName(vehName).." - "..vehPlate, rgba = {15,110,110} })
											end)
										end
									end
								else
									if math.random(100) <= chanceDeQuebrarLockPickErrar then
										TriggerClientEvent("Notify",source,"amarelo","Sua Lockpick quebrou e você falhou",7000)
										vRP.tryGetInventoryItem(user_id,"lockpick",1)
									else
										TriggerClientEvent("Notify",source,"amarelo","Voce falhou, tente novamente.",7000)
									end
								end

								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end

								vCLIENT.blockButtons(source,false)
								vRPclient._stopAnim(source,false)
								active[user_id] = nil
							end
						else
							local checkHomes,homeName = vHOMES.checkHomesTheft(source)
							if checkHomes then
								active[user_id] = 100
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								vRPclient.playAnim(source,false,{"missheistfbi3b_ig7","lift_fibagent_loop"},false)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									vRP.upgradeStress(user_id,4)
									vHOMES.enterHomesTheft(source,homeName)
									TriggerEvent("vrp:homes:ApplyTime",homeName)
								else
									if math.random(100) <= chanceDeQuebrarLockPickErrar then
										TriggerClientEvent("Notify",source,"amarelo","Sua Lockpick quebrou e você falhou",7000)
										vRP.tryGetInventoryItem(user_id,"lockpick",1)
									else
										TriggerClientEvent("Notify",source,"amarelo","Voce falhou, tente novamente.",7000)
									end
								end

								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end

								vRPclient._stopAnim(source,false)
								vCLIENT.blockButtons(source,false)
								active[user_id] = nil
							else
								local status,x,y,z = vCLIENT.cashRegister(source)
								local amountCops = vRP.numPermission("Police")
								if parseInt(#amountCops) <= 3 then
									TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento, tente mais tarde.",5000)
									return false
								end
								if status then
									active[user_id] = 10
									vRPclient.stopActived(source)
									vCLIENT.closeInventory(source)
									vCLIENT.blockButtons(source,true)
									table.insert(registerTimers,{ x,y,z,360 })
									
									TriggerClientEvent("Progress",source,10000,"Utilizando...")
									TriggerClientEvent("vrp_inventory:updateRegister",-1,registerTimers)
									SendWebhookMessage(webhookregistradora,"```prolog\n[ID ROUBOU A REGISTRADORA]: "..user_id.."  "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									vRPclient._playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											vRP.upgradeStress(user_id,1)
											vRPclient._removeObjects(source)
											vCLIENT.blockButtons(source,false)
											vRP.giveInventoryItem(user_id,"dollars2",math.random(500,1200),true)

											if math.random(100) >= 75 then
												vRP.wantedTimer(user_id,15)
												local copAmount = vRP.numPermission("Police")
												for k,v in pairs(copAmount) do
													async(function()
														TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), text = "Me ajude tem um cara querendo roubar minha loja!!!!", code = 20, title = "Roubo a Caixa Registradora", x = x, y = y, z = z, rgba = {170,80,25} })
													end)
												end
											end
										end
										Citizen.Wait(0)
									until active[user_id] == nil
								else
									if x ~= nil and y ~= nil and z ~= nil then
										for k,v in pairs(registerTimers) do
											if v[1] == x and v[2] == y and v[3] == z then
												TriggerClientEvent("Notify",source,"roxo","Aguarde "..vRP.getTimers(parseInt(v[4]*4))..".",5000)
											end
											Citizen.Wait(1)
										end
									end
								end
							end
						end
					end

					if itemName == "energetic" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","prop_energy_drink",49,60309,0.0,0.0,0.0,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeStress(user_id,4)
									TriggerClientEvent("setEnergetic",source,90,1.10)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "absolut" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.alcoholTimer(user_id,1)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setDrunkTime",source,300)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "hennessy" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.alcoholTimer(user_id,1)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setDrunkTime",source,300)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "chandon" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.alcoholTimer(user_id,1)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setDrunkTime",source,300)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "dewars" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.alcoholTimer(user_id,1)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setDrunkTime",source,300)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "water" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309,0.0,0.0,0.02,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,25)
									vRP.giveInventoryItem(user_id,"emptybottle",1)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "sinkalmy" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_ld_flow_bottle",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,5)
									vRP.chemicalTimer(user_id,1)
									vRP.downgradeStress(user_id,25)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "ritmoneury" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_ld_flow_bottle",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,5)
									vRP.chemicalTimer(user_id,1)
									vRP.downgradeStress(user_id,50)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "dirtywater" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeStress(user_id,4)
									vRP.upgradeThirst(user_id,25)
									vRPclient.downHealth(source,10)
									vRP.giveInventoryItem(user_id,"emptybottle",1)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cola" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ecola_can",49,60309,0.0,0.0,0.04,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "soda" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","ng_proc_sodacan_01b",49,60309,0.0,0.0,-0.04,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "fishingrod" then
						if vCLIENT.fishingStatus(source) then
							active[user_id] = 30
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)

							if not vCLIENT.fishingAnim(source) then
								vRPclient.stopActived(source)
								vRPclient._createObjects(source,"amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",49,60309)
							end

							if vTASKBAR.taskFishing(source) then
								local rand = parseInt(math.random(3))
								local fishs = { "octopus","shrimp","carp" }

								if vRP.computeInvWeight(user_id) + vRP.itemWeightList(fishs[rand]) * rand <= vRP.getBackpack(user_id) then
									if vRP.tryGetInventoryItem(user_id,"bait",rand,true) then
										vRP.giveInventoryItem(user_id,fishs[rand],rand,true)
									else
										TriggerClientEvent("Notify",source,"amarelo","Você precisa de <b>"..vRP.format(rand).."x "..vRP.itemNameList("bait").."</b>.",5000)
									end
								else
									TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
								end
							end

							vCLIENT.blockButtons(source,false)
							active[user_id] = nil
						end
					end

					if itemName == "emptybottle" then
						local status,style = vCLIENT.checkFountain(source)
						if status then
							vRPclient.stopActived(source)
							vCLIENT.blockButtons(source,true)

							if style == "fountain" then
								vCLIENT.closeInventory(source)
								vRPclient._playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
							elseif style == "floor" then
								vCLIENT.closeInventory(source)
								vRPclient._playAnim(source,false,{"amb@world_human_bum_wash@male@high@base","base"},true)
							end

							active[user_id] = parseInt(rAmount*3)

							TriggerClientEvent("Progress",source,parseInt(rAmount*3000),"Utilizando...")

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._removeObjects(source)
									vCLIENT.blockButtons(source,false)

									if vRP.computeInvWeight(user_id)+vRP.itemWeightList(itemName) * parseInt(rAmount) <= vRP.getBackpack(user_id) then
										if vRP.tryGetInventoryItem(user_id,itemName,parseInt(rAmount),true,slot) then
											if style == "floor" then
												vRP.giveInventoryItem(user_id,"dirtywater",parseInt(rAmount))
											else
												vRP.giveInventoryItem(user_id,"water",parseInt(rAmount))
											end
										end
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "coffee" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"amb@world_human_aa_coffee@idle_a", "idle_a","p_amb_coffeecup_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeStress(user_id,2)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setEnergetic",source,30,1.15)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "hamburger" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,30)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "hotdog" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_hotdog_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "sandwich" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_sandwich_01",49,18905,0.13,0.05,0.02,-50.0,16.0,60.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "tacos" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_taco_01",49,18905,0.16,0.06,0.02,-50.0,220.0,60.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,30)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "fries" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_bs_chips",49,18905,0.10,0.0,0.08,150.0,320.0,160.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "chocolate" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,10)
									vRP.downgradeStress(user_id,10)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "donut" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000,"Utilizando...")
	                    vRPclient._createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_amb_donut",49,28422)

						repeat
							if active[user_id] == 0 then
	                            active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.downgradeStress(user_id,8)
									vRP.upgradeHunger(user_id,10)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "postit" then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vCLIENT.closeInventory(source)
							TriggerClientEvent("vrp_notepad:createNotepad",source)
						end
					end

					if itemName == "backpackp" then
						local exp = vRP.getBackpack(user_id)
						if exp < 25 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,25)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "backpackm" then
						local exp = vRP.getBackpack(user_id)
						if exp >= 25 and exp < 50 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,50)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "backpackg" then
						local exp = vRP.getBackpack(user_id)
						if exp >= 50 and exp < 75 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,75)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "backpackx" then
						local exp = vRP.getBackpack(user_id)
						if exp >= 75 and exp < 100 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,100)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "compost" or itemName == "bucket" or itemName == "cannabisseed" then
						local homeEnter = vHOMES.getHomeStatistics(source)
						if homeEnter == "" then
							local weWater = vWEPLANTS.checkWater(source)
							if weWater then
								TriggerClientEvent("Notify",source,"vermelho","Só pode ser plantado em terra firme.",3000)
								return
							end

							--local weCounts = vWEPLANTSS.getAmount(user_id)
							--if parseInt(weCounts) >= 50 then
								--TriggerClientEvent("Notify",source,"vermelho","O limite máximo de plantações foi atingido.",3000)
								--return
							--else
								local status,x,y,z = vWEPLANTS.entityInWorldCoords(source)
								if status and vRP.getInventoryItemAmount(user_id,"compost") >= 1 and vRP.getInventoryItemAmount(user_id,"bucket") >= 1 and vRP.getInventoryItemAmount(user_id,"cannabisseed") >= 1 then
									active[user_id] = 7
									vRPclient.stopActived(source)
									vCLIENT.closeInventory(source)
									vCLIENT.blockButtons(source,true)
									TriggerClientEvent("Progress",source,7000,"Utilizando...")
									vRPclient._playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											vRPclient._stopAnim(source,false)
											vCLIENT.blockButtons(source,false)

											if vRP.tryGetInventoryItem(user_id,"compost",1,true) and vRP.tryGetInventoryItem(user_id,"bucket",1,true) and vRP.tryGetInventoryItem(user_id,"cannabisseed",1,true) then
												vRP.weedTimer(user_id,1)
												vRP.upgradeStress(user_id,1)
												vWEPLANTS.pressPlants(source,x,y,z)
											end
										end
										Citizen.Wait(0)
									until active[user_id] == nil
								else
									TriggerClientEvent("Notify",source,"vermelho","Voce nao possui todos os itens.",6000)
								end
							--end
						end
					end

					if itemName == "tires" then
						if not vRPclient.inVehicle(source) then
							local vehicle,vehNet = vRPclient.vehList(source,3)
							if vehicle then
								active[user_id] = 30
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								vRPclient._playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

								local taskResult = vTASKBAR.taskTwo(source)
								if taskResult then
									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										TriggerClientEvent("vrp_inventory:repairTires",source,vehNet)
									end
								end

								vCLIENT.blockButtons(source,false)
								vRPclient._stopAnim(source,false)
								active[user_id] = nil
							end
						end
					end

					if itemName == "premiumplate" then
						vCLIENT.closeInventory(source)

						local vehModel = vRP.prompt(source,"Nome de spawn do veiculo:","")
						if vehModel == "" then
							return
						end

						local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehModel) })
						if vehicle[1] then
							local vehPlate = vRP.prompt(source,"NOVA PLACA:","")
							if vehPlate == "" or string.upper(vehPlate) == "CNVRP - RP" then
								return
							end

							local plateUserId = vRP.getVehiclePlate(vehPlate)
							if plateUserId then
								TriggerClientEvent("Notify",source,"vermelho","A placa escolhida já está sendo usada por outro veículo.",5000)
								return
							end

							local plateCheck = sanitizeString(vehPlate,"abcdefghijklmnopqrstuvwxyz0123456789",true)
							if plateCheck and string.len(plateCheck) == 8 then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.execute("vRP/update_plate_vehicle",{ user_id = parseInt(user_id), vehicle = tostring(vehModel), plate = string.upper(tostring(vehPlate)) })
									TriggerClientEvent("Notify",source,"verde","Placa atualizada com sucesso.",5000)
								end
							else
								TriggerClientEvent("Notify",source,"roxo","O nome da definição para placas deve conter no máximo 8 caracteres e podem ser usados números e letras minúsculas.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"vermelho","Modelo de veículo não encontrado em sua garagem.",5000)
						end
					end

					
					if itemName == "premiumname" then
						vCLIENT.closeInventory(source)
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then

						local newName = vRP.prompt(source,"Primeiro Nome (NOVO):","")
						if newName == "" then
							return
						end

						local newLastName = vRP.prompt(source,"Sobre Nome (NOVO):","")
						if newLastName == "" then
							return
						end
						
						vRP.execute("vRP/rename_characters",{ id = user_id, name = newName, name2 = newLastName })
					end
					end

					if itemName == "plate" then
						active[user_id] = 10
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									local plate = vRP.genPlate()
									vCLIENT.plateApply(source,plate)
									TriggerEvent("setPlateEveryone",plate)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "premiumped" then
						vCLIENT.closeInventory(source)
						local pedModel = vRP.prompt(source,"Ped:","")
						if pedModel == "" then
							TriggerClientEvent("Notify",source,"vermelho","Digite um ped valido .",1000)
							return
						end

						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vRPclient.applySkin(source,GetHashKey(pedModel))
							vRP.updateSelectSkin(parseInt(user_id),GetHashKey(pedModel))
							TriggerClientEvent("Notify",source,"verde","Skin colocada com sucesso .",1000)
						end
					end

					if itemName == "fueltech" then
						if vRPclient.inVehicle(source) then
							if vCLIENT.techDistance(source) then
								local vehPlate = vRPclient.vehiclePlate(source)
								local plateUsers = vRP.getVehiclePlate(vehPlate)
								if not plateUsers then
									active[user_id] = 30
									vCLIENT.closeInventory(source)
									vCLIENT.blockButtons(source,true)
									TriggerClientEvent("Progress",source,30000,"Utilizando...")
									vRPclient._playAnim(source,true,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											vRPclient._stopAnim(source,false)
											vCLIENT.blockButtons(source,false)

											if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
												TriggerClientEvent("vrp_admin:vehicleTuning",source)
											end
										end
										Citizen.Wait(0)
									until active[user_id] == nil
								end
							end
						end
					end

					if itemName == "radio" then
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						TriggerClientEvent("radio:openSystem",source)
					end

					if itemName == "divingsuit" then
                        if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
                            vPLAYER.setDiving(source)
                            TriggerClientEvent("Notify",source,"roxo","Você usou sua roupa de mergulho",7000)
                            vRP.tryGetInventoryItem(user_id,"divingsuit",1)
                        end
                    end

					if itemName == "handcuff" then
						if not vRPclient.inVehicle(source) then
							local nplayer = vRPclient.nearestPlayer(source,1)
							if nplayer then
								if vPLAYER.getHandcuff(nplayer) then
									vPLAYER.toggleHandcuff(nplayer)
									vRPclient._stopAnim(nplayer,false)
									TriggerClientEvent("vrp_sound:source",source,"uncuff",0.5)
									TriggerClientEvent("vrp_sound:source",nplayer,"uncuff",0.5)
								else
									active[user_id] = 30
									local taskResult = vTASKBAR.taskHandcuff(nplayer)
									if not taskResult then
										vPLAYER.toggleHandcuff(nplayer)
										TriggerClientEvent("vrp_sound:source",source,"cuff",0.5)
										TriggerClientEvent("vrp_sound:source",nplayer,"cuff",0.5)
										vRPclient._playAnim(nplayer,true,{"mp_arresting","idle"},true)
									else
										TriggerClientEvent("Notify",source,"roxo","O cidadao resistiu de ser algemado.",5000)
									end
									active[user_id] = nil
								end
							end
						end
					end

					if itemName == "hood" then
						local nplayer = vRPclient.nearestPlayer(source,1)
						if nplayer and vPLAYER.getHandcuff(nplayer) then
							TriggerClientEvent("hud:toggleHood",nplayer)
						end
					end

					if itemName == "rope" then
						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer and not vRPclient.inVehicle(source) then
							local taskResult = vTASKBAR.taskHandcuff(nplayer)
							if not taskResult then
								TriggerClientEvent("vrp_rope:toggleRope",source,nplayer)
							else
								TriggerClientEvent("Notify",source,"roxo","O cidadao resistiu de ser carregado.",5000)
							end
						end
						
					end

					if itemName == "c4" then
						TriggerClientEvent("vrp_cashmachine:machineRobbery",source)
					end
						-------------------------------------------------------------------
						------------- VIPS
						-------------------------------------------------------------------
						if itemName == "premium01" then
							local identity = vRP.getUserIdentity(user_id)
							if identity then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									if not vRP.getPremium(user_id) then
										func.RemoveVipSets(source)
										vRP.execute("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), chars = 2, predays = 30, priority = 30 })
										vRP.insertPermission(parseInt(user,id),"PRATA")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "PRATA" })
									else
										func.RemoveVipSets(source)
										vRP.execute("vRP/update_premium",{ steam = identity.steam, predays = 30 })
										vRP.insertPermission(parseInt(user,id),"PRATA")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "PRATA" })
									end
								end
							end
						end

						if itemName == "premium02" then
							local identity = vRP.getUserIdentity(user_id)
							if identity then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									if not vRP.getPremium(user_id) then
										func.RemoveVipSets(source)
										vRP.execute("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), chars = 2, predays = 30, priority = 40 })
										vRP.insertPermission(parseInt(user,id),"OURO")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "OURO" })
									else
										func.RemoveVipSets(source)
										vRP.execute("vRP/update_premium",{ steam = identity.steam, predays = 30 })
										vRP.insertPermission(parseInt(user,id),"OURO")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "OURO" })
									end
								end
							end
						end

						if itemName == "premium03" then
							local identity = vRP.getUserIdentity(user_id)
							if identity then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									if not vRP.getPremium(user_id) then
										func.RemoveVipSets(source)
										vRP.execute("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), chars = 3, predays = 30, priority = 50 })
										vRP.insertPermission(parseInt(user,id),"PLATINA")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "PLATINA" })
									else
										func.RemoveVipSets(source)
										vRP.execute("vRP/update_premium",{ steam = identity.steam, predays = 30 })
										vRP.insertPermission(parseInt(user,id),"PLATINA")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "PLATINA" })
									end
								end
							end
						end

						if itemName == "premium04" then
							local identity = vRP.getUserIdentity(user_id)
							if identity then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									if not vRP.getPremium(user_id) then
										func.RemoveVipSets(source)
										vRP.execute("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), chars = 2, predays = 30, priority = 60 })
										vRP.insertPermission(parseInt(user,id),"DIAMANTE")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "DIAMANTE" })
									else
										func.RemoveVipSets(source)
										vRP.execute("vRP/update_premium",{ steam = identity.steam, predays = 30 })
										vRP.insertPermission(parseInt(user,id),"DIAMANTE")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "DIAMANTE" })
									end
								end
							end
						end

						if itemName == "premium05" then
							local identity = vRP.getUserIdentity(user_id)
							if identity then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									if not vRP.getPremium(user_id) then
										func.RemoveVipSets(source)
										vRP.execute("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), chars = 3, predays = 30, priority = 85 })
										vRP.insertPermission(parseInt(user,id),"EXTREME")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "EXTREME" })
									else
										func.RemoveVipSets(source)
										vRP.execute("vRP/update_premium",{ steam = identity.steam, predays = 30 })
										vRP.insertPermission(parseInt(user,id),"EXTREME")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "EXTREME" })
									end
								end
							end
						end

						if itemName == "premium06" then
							local identity = vRP.getUserIdentity(user_id)
							if identity then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									if not vRP.getPremium(user_id) then
										func.RemoveVipSets(source)
										vRP.execute("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), chars = 3, predays = 90, priority = 100 })
										vRP.insertPermission(parseInt(user,id),"MASTER")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "MASTER" })
									else
										func.RemoveVipSets(source)
										vRP.execute("vRP/update_premium",{ steam = identity.steam, predays = 90 })
										vRP.insertPermission(parseInt(user,id),"MASTER")
										vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "MASTER" })
									end
								end
							end
						end

						function func.RemoveVipSets(source)
							local user_id = vRP.getUserId(source)
							if user_id then
								TriggerClientEvent("Notify",source,"verde","Agora você é um vip.",5000)
								vRP.removePermission(parseInt(user_id),"PRATA")
								vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "PRATA" })
								vRP.removePermission(parseInt(user_id),"OURO")
								vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "OURO" })
								vRP.removePermission(parseInt(user_id),"DIAMANTE")
								vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "DIAMANTE" })
								vRP.removePermission(parseInt(user_id),"PLATINA")
								vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "PLATINA" })
								vRP.removePermission(parseInt(user_id),"SUPREMO")
								vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "SUPREMO" })
								vRP.removePermission(parseInt(user_id),"MASTER")
								vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "MASTER" })
							end
						end

					if itemName == "pager" then
						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								if vRP.hasPermission(nuser_id,"Police") then
									TriggerClientEvent("radio:outServers",nplayer)
									TriggerEvent("vrp_blipsystem:serviceExit",nplayer)
									vRP.removePermission(vRP.getUserSource(nuser_id),"Police")
									vRP.execute("vRP/upd_group",{ user_id = nuser_id, permiss = "Police", newpermiss = "waitPolice" })
									TriggerClientEvent("Notify",source,"roxo","Todas as comunicações da polícia foram retiradas.",5000)
								end
							end
						end
					end
				end


				
				if vRP.itemTypeList(itemName) == "equip" then
                    if vRP.tryGetInventoryItem(user_id,itemName,1) then
                        local weapons = {}
                        weapons[itemName] = { ammo = 0 }
                        vRPclient._giveWeapons(source,weapons)
        
                        TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                    end
                end


                if vRP.itemTypeList(itemName) == "recharge" then

                    local uweapons = vRPclient.getWeapons(source)
                    local identity = vRP.getUserIdentity(user_id)
                    
                    for k,v in pairs(weapon_ammos) do
                        if k == itemName then
                            for m,n in pairs(v) do
                                if uweapons[n] then
                                    local itemAmount = 0
                                    local data = vRP.getUserDataTable(user_id)
                                    if vRP.tryGetInventoryItem(user_id, itemName, rAmount) then
                                        local weapons = {}
                                        weapons[n] = { ammo = rAmount }
                                        itemAmount = rAmount
                                        vRPclient._giveWeapons(source,weapons,false)
                                        
                                        TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                                    end
                                    break
                                end
                            end
                        end
                    end
                end



--[[ 				if vRP.itemTypeList(itemName) == "equip" then
					local data = vRP.getWeaponsId(user_id)					
					vCLIENT.putWeaponHands(source,itemName)
					for k, v in pairs(data) do
						if checkWeaponByAmmo(v.weapon, itemName) then
							Wait(100)
							break
						end
					end
				end ]]

--[[ 				if vRP.itemTypeList(itemName) == "recharge" then
					local checkWeapon = vCLIENT.rechargeCheck(source,itemName)
					if checkWeapon then
						if weapon_ammos[itemName] then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(rAmount),true,slot) then							
								
							-- for k,v in pairs(weapon_ammos[itemName]) do
								local ok = vRP.addWeaponId(user_id,itemName,rAmount)
								
							-- end
								if ok then
									vCLIENT.closeInventory(source)
									
									vCLIENT.rechargeWeapon(source,itemName,rAmount)
								end
							end
						end
					end
				end ]]

			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function func.updateWeaponAmmo(weapon,ammo)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ammoType = getAmmoTypeByWeapon(weapon)
		if ammoType ~= "" then
			vRP.remAmmoWeaponId(user_id,ammoType,ammo)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:sendItem")
AddEventHandler("vrp_inventory:sendItem",function(itemName,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] == nil and not vPLAYER.getHandcuff(source) then
			if amount == nil then amount = 1 end
			if amount <= 0 then amount = 1 end

			if not vRP.wantedReturn(user_id) then
				local nplayer = vRPclient.nearestPlayer(source,3)
				if nplayer then
					local nuser_id = vRP.getUserId(nplayer)
					if nuser_id then
						if vRP.computeInvWeight(nuser_id) + vRP.itemWeightList(itemName) * parseInt(amount) <= vRP.getBackpack(nuser_id) then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(amount),true) then
								vRP.giveInventoryItem(nuser_id,itemName,parseInt(amount),true)
								TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
								vRPclient._playAnim(source,true,{"pickup_object","putdown_low"},false)
								vRPclient._playAnim(nplayer,true,{"pickup_object","putdown_low"},false)
								Citizen.Wait(750)
								vRPclient._removeObjects(source)
							end
						end
					end
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:dropItem")
AddEventHandler("vrp_inventory:dropItem",function(itemName,amount,bole)
	local source = source
	local user_id = vRP.getUserId(source)
	weaponrechenger[itemName] = false

	--??????
	--if user_id then
		local x,y,z = vRPclient.getPosition(source)
		if parseInt(amount) > 0 then
			vCLIENT.removeWeaponInHand(source)
			if bole == true then
	    		if vRP.tryGetInventoryItem(user_id,itemName,parseInt(amount)) then
	    			TriggerEvent("itemdrop:Create",itemName,parseInt(amount),source)
					vRPclient._playAnim(source,true,{"pickup_object","pickup_low"},false)
					SendWebhookMessage(webhookdropar,"```prolog\n[ID]: "..user_id.." \n[DROPOU O ITEM]: "..vRP.itemNameList(itemName).." \n[QUANTIDADE]: "..parseInt(amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					vCLIENT.closeInventory(source)
				end
			else
				TriggerEvent("itemdrop:Create",itemName,parseInt(amount),source)
				vRPclient._playAnim(source,true,{"pickup_object","pickup_low"},false)
				vCLIENT.closeInventory(source)
			end
			
		end
		local nplayer = vRPclient.nearestPlayer(source,5)
		if nplayer then
			TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
		end
	--end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local droplist = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDROP:CREATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("itemdrop:Create")
AddEventHandler("itemdrop:Create",function(item,count,source)
    local id = idgens:gen()
    local x,y,z = vRPclient.getPositions(source)
    droplist[id] = { item = item, count = count, x = x, y = y, z = z, name = vRP.itemNameList(item),  index = vRP.itemIndexList(item), desc = vRP.itemDescList(item), peso = vRP.itemWeightList(item) }
    TriggerClientEvent("itemdrop:Players",-1,id,droplist[id])
	local nplayer = vRPclient.nearestPlayer(source,5)
		if nplayer then
			TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
		end
end)

-- ROUBO
RegisterServerEvent("vrp_itemdrop:Create")
AddEventHandler("vrp_itemdrop:Create",function(item,count,x,y,z,source)
    local id = idgens:gen()
    droplist[id] = { item = item, count = count, x = x, y = y, z = z, name = vRP.itemNameList(item),  index = vRP.itemIndexList(item), desc = vRP.itemDescList(item), peso = vRP.itemWeightList(item) }
    TriggerClientEvent("itemdrop:Players",-1,id,droplist[id])
	local nplayer = vRPclient.nearestPlayer(source,5)
	if nplayer then
		TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
	end
end)

------------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDROP:PICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("itemdrop:Pickup")
AddEventHandler("itemdrop:Pickup",function(id,slot,amount)
    local source = source
    local user_id = vRP.getUserId(source)
    local inv = vRP.getInventory(user_id)
    local x,y,z = vRPclient.getPosition(source)
    if droplist[id] == nil then
        return
    else
    if vRP.computeInvWeight(user_id) + vRP.itemWeightList(tostring(droplist[id].item)) * parseInt(droplist[id].count) <= vRP.getBackpack(user_id) then
        if droplist[id].count - amount >= 1 then 
            TriggerClientEvent("itemdrop:Remove",-1,id)
            vRP.giveInventoryItem(user_id,tostring(droplist[id].item),parseInt(amount),true,slot)
            local newamount = droplist[id].count - amount
            vCLIENT.dropItem(source,droplist[id].item)
            vCLIENT.closeInventory(source)
            droplist[id] = nil
            idgens:free(id)
            return
        else

        TriggerClientEvent("itemdrop:Remove",-1,id)
        vCLIENT.closeInventory(source)
		SendWebhookMessage(webhookdropar,"```ini\n[ID]: "..user_id.."\n[PEGOU]: "..droplist[id].item.. "\n[QTD]: "..droplist[id].count.." "..os.date("\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S").." \r```")

        vRP.giveInventoryItem(user_id,tostring(droplist[id].item),parseInt(droplist[id].count),true,slot)

        droplist[id] = nil
        idgens:free(id)
        end
    else
        TriggerClientEvent("Notify",source,"vermelho","Sua <b>Mochila</b> Cheia.",5000)
        end
    end

    local nplayer = vRPclient.nearestPlayer(source,5)
    if nplayer then
        TriggerClientEvent("vga_inventory:Update",nplayer,"updateMochila")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("itemdrop:Update",source,droplist)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if not vRP.getPremium(user_id) then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.execute("vRP/update_priority",{ steam = identity.steam })
		end
	end

	if not vRP.getPremium(user_id) then
		local user_id = vRP.getUserId(source)
		if user_id then
			func.RemoveVipSets(source)
		end
	end

	if active[user_id] then
		active[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_INVENTORY:CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_inventory:Cancel")
AddEventHandler("vrp_inventory:Cancel",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] ~= nil and active[user_id] > 0 then
			active[user_id] = nil
			TriggerClientEvent("Progress",source,1500,"Cancelando...")

			SetTimeout(1000,function()
				vRPclient._removeObjects(source)
				vCLIENT.blockButtons(source,false)
				vRPRAGE.updateHotwired(source,false)
			end)
		else
			vRPclient._removeObjects(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkInventory()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] ~= nil and active[user_id] > 0 then
			return false
		end
		return true
	end
end


function func.hasWeapon(arma)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.getInventoryItemAmount(user_id,arma) >= 1 then
		return true
	else
		return false
	end
end

RegisterServerEvent("vrp_inventory:giveTireBack")
AddEventHandler("vrp_inventory:giveTireBack",function()
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.giveInventoryItem(user_id,"tires",1)
end)

RegisterServerEvent("vrp_inventory:syncPneuConcertarS")
AddEventHandler("vrp_inventory:syncPneuConcertarS",function(vehicle,tireIndex)
	TriggerClientEvent("vrp_inventory:syncPneuConcertarC",-1,vehicle,tireIndex)
end)