-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("vrp_shops",cnVRP)
vCLIENT = Tunnel.getInterface("vrp_shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local shops = {
	["departamentStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["postit"] = 100,
			["energetic"] = 800,
			["emptybottle"] = 200,
			["cigarette"] = 200,
			["lighter"] = 600,
			["chocolate"] = 150,
			["absolut"] = 90,
			["chandon"] = 90,
			["dewars"] = 300,
			["hennessy"] = 190,
			["backpackp"] = 10000,
			["backpackm"] = 15000,
			["backpackg"] = 20000,
			["backpackx"] = 30000,
			["divingsuit"] = 10000
		}
	},
	["pharmacyStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["gauze"] = 1000,
			["bandage"] = 3500,
			["analgesic"] = 200,
			["warfarin"] = 2500,
			["sinkalmy"] = 2000,
			["ritmoneury"] = 3000,
			["adrenaline"] = 4000
		}
	},
	["foodGrill"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Restaurante",
		["list"] = {
			["tacos"] = 300,
			["hamburger"] = 300,
			["hotdog"] = 300,
			["soda"] = 300,
			["cola"] = 300,
			["chocolate"] = 250,
			["sandwich"] = 300,
			["fries"] = 300,
			["absolut"] = 300,
			["chandon"] = 300,
			["dewars"] = 300,
			["donut"] = 300,
			["hennessy"] = 300
		}
	},
	["ammunationStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["GADGET_PARACHUTE"] = 5000,
			["WEAPON_KNIFE"] = 8000,
			["WEAPON_HATCHET"] = 8000,
			["WEAPON_BAT"] = 8000,
			["WEAPON_BATTLEAXE"] = 8000,
			["WEAPON_BOTTLE"] = 8000,
			["WEAPON_CROWBAR"] = 8000,
			["WEAPON_DAGGER"] = 8000,
			["WEAPON_GOLFCLUB"] = 8000,
			["WEAPON_HAMMER"] = 8000,
			["WEAPON_MACHETE"] = 8000,
			["WEAPON_POOLCUE"] = 8000,
			["WEAPON_STONE_HATCHET"] = 8000,
			["WEAPON_SWITCHBLADE"] = 8000,
			["WEAPON_WRENCH"] = 8000,
			["WEAPON_KNUCKLE"] = 8000
		}
	},
	["premiumStore"] = {
		["mode"] = "Buy",
		["type"] = "Premium",
		["list"] = {
			["premium01"] = 1,
			["premium02"] = 2,
			["premium03"] = 6,
			["premium04"] = 5,
			["premium05"] = 10,
			["premium06"] = 28,
			["premiumplate"] = 1,
			["premiumped"] = 1,
			["premiumname"] = 1,
			["premiumgarage"] = 1,
			["bonusDelivery"] = 2,
			["bonusPostOp"] = 2
		}
	},
	["fishingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["shrimp"] = 80,
			["octopus"] = 100,
			["carp"] = 90
		}
	},
	["recyclingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["plastic"] = 35,
			["glass"] = 15,
			["rubber"] = 25,
			["aluminum"] = 55,
			["copper"] = 45,
			["eletronics"] = 20,
			["emptybottle"] = 20,
			["lighter"] = 300,
			["divingsuit"] = 2500,
			["teddy"] = 250,
			["fishingrod"] = 2500,
			["identity"] = 500,
			["radio"] = 1000,
			["cellphone"] = 1000,
			["binoculars"] = 500,
			["camera"] = 1000,
			["vape"] = 15000,
			["pager"] = 3000,
			["keyboard"] = 250,
			["mouse"] = 225,
			["ring"] = 500,
			["watch"] = 650,
			["goldbar"] = 800,
			["playstation"] = 400,
			["xbox"] = 400,
			["legos"] = 200,
			["ominitrix"] = 350,
			["bracelet"] = 400,
			["dildo"] = 250,
			["postit"] = 10
		}
	},
	["fishingStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["bait"] = 10,
			["fishingrod"] = 5000
		}
	},
	["registryStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["identity"] = 900
		}
	},
	["digitalDen"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["radio"] = 2000,
			["cellphone"] = 2000,
			["binoculars"] = 1000,
			["camera"] = 2000,
			["vape"] = 30000
		}
	},
	["megaMallStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["energetic"] = 1000,
			["emptybottle"] = 300,
			["cigarette"] = 300,
			["lighter"] = 300,
			["chocolate"] = 300,
			["cola"] = 300,
			["teddy"] = 300,
			["rose"] = 300,
		--	["bucket"] = 200, -- BALDE DE MACONHA 
		--	["compost"] = 10,  ADUBO
			--["cannabisseed"] = 10,  -- SEMENTE DE MACONHA
		--	["silk"] = 3,  ---  SEDA
			["coffee"] = 300,
			["paperbag"] = 300,
		--	["raceticket"] = 500,  TICKET DE CORRIDA
			["firecracker"] = 1000
		}
	},
	["comedyBar"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["energetic"] = 1000,
			["cola"] = 250,
			["soda"] = 250,
			["absolut"] = 300,
			["chandon"] = 300,
			["dewars"] = 300,
			["hennessy"] = 300,
		}
	},
	["coffeeMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["coffee"] = 250
		}
	},
	["sodaMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["soda"] = 250
		}
	},
	["colaMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["cola"] = 250
		}
	},
	["waterMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["water"] = 150
		}
	},
	["policeStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Police",
		["list"] = {
			["vest"] = 1000,
			["gsrkit"] = 400,
			["gdtkit"] = 400,
			["WEAPON_SMG"] = 5500,
			["WEAPON_PUMPSHOTGUN"] = 6000,
			["WEAPON_CARBINERIFLE"] = 9000,
			["WEAPON_SPECIALCARBINE"] = 17000,
			["WEAPON_FIREEXTINGUISHER"] = 600,
			["WEAPON_STUNGUN"] = 200,
			["WEAPON_NIGHTSTICK"] = 60,
			["WEAPON_COMBATPISTOL"] = 2000,
			["WEAPON_SMG_AMMO"] = 20,
			["WEAPON_SHOTGUN_AMMO"] = 25,
			["WEAPON_RIFLE_AMMO"] = 25,
			["WEAPON_FLASHLIGHT"] = 5000,
			["WEAPON_PISTOL_AMMO"] = 10
		}
	},
	["ilegalStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "ilegal",
		["list"] = {
			["bucket"] = 200, -- BALDE DE MACONHA 
			["compost"] = 5,  --ADUBOr
			["cannabisseed"] = 5,  -- SEMENTE DE MACONHA
			["silk"] = 10  ---  SEDA
		}
	},
	["drugsSelling"] = {
		["mode"] = "Buy",
		["type"] = "Consume",
		["item"] = "dollars2",
		["list"] = {
			["meth"] = 500,
			["lean"] = 500,
			["ecstasy"] = 500
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.requestPerm(shopType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.wantedReturn(user_id) then
			return false
		end

		if shops[shopType]["perm"] ~= nil then
			if not vRP.hasPermission(user_id,shops[shopType]["perm"]) then
				return false
			end
		end
		
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.requestShop(name)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local inventoryShop = {}
		for k,v in pairs(shops[name]["list"]) do
			table.insert(inventoryShop,{ price = parseInt(v), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, weight = vRP.itemWeightList(k) })
		end

		local inventoryUser = {}
		local inv = vRP.getInventory(user_id)
		if inv then
			for k,v in pairs(inv) do
				if string.sub(v.item,1,9) == "toolboxes" then
					local advFile = LoadResourceFile("logsystem","toolboxes.json")
					local advDecode = json.decode(advFile)

					v.durability = advDecode[v.item]
				end

				v.amount = parseInt(v.amount)
				v.name = vRP.itemNameList(v.item)
				v.peso = vRP.itemWeightList(v.item)
				v.index = vRP.itemIndexList(v.item)
				v.key = v.item
				v.slot = k

				inventoryUser[k] = v
			end
		end

		return inventoryShop,inventoryUser,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),{ identity.name.." "..identity.name2,parseInt(user_id),parseInt(identity.bank),parseInt(vRP.getGmsId(user_id)),identity.phone,identity.registration }
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.getShopType(name)
    return shops[name].mode
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.functionShops(shopType,shopItem,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end
		local inv = vRP.getInventory(user_id)
		if inv then
			if shops[shopType]["mode"] == "Buy" then
				if vRP.computeInvWeight(parseInt(user_id)) + vRP.itemWeightList(shopItem) * parseInt(shopAmount) <= vRP.getBackpack(parseInt(user_id)) then
					if shops[shopType]["type"] == "Cash" then
						if shops[shopType]["list"][shopItem] then
							if vRP.paymentBank(parseInt(user_id),parseInt(shops[shopType]["list"][shopItem]*shopAmount)) then

								if inv[tostring(slot)] then
									vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false)
								else
									vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false,slot)
								end							else
								TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
							end
						end
					elseif shops[shopType]["type"] == "Consume" then
						if vRP.tryGetInventoryItem(parseInt(user_id),shops[shopType]["item"],parseInt(shops[shopType]["list"][shopItem]*shopAmount)) then
							if inv[tostring(slot)] then
								vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false)
							else
								vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false,slot)
							end
						else
							TriggerClientEvent("Notify",source,"vermelho","Insuficiente "..vRP.itemNameList(shops[shopType]["item"])..".",5000)
						end
					elseif shops[shopType]["type"] == "Premium" then
						local identity = vRP.getUserIdentity(parseInt(user_id))
						local consult = vRP.getInfos(identity.steam)
						if parseInt(consult[1].gems) >= parseInt(shops[shopType]["list"][shopItem]*shopAmount) then
							if inv[tostring(slot)] then
								vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false)
							else
								vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false,slot)
							end							vRP.remGmsId(user_id,parseInt(shops[shopType]["list"][shopItem]*shopAmount))
							TriggerClientEvent("Notify",source,"verde","Você comprou <b>"..vRP.format(parseInt(shopAmount)).."x "..vRP.itemNameList(shopItem).."</b> por <b>"..vRP.format(parseInt(shops[shopType]["list"][shopItem]*shopAmount)).." coins</b>.",5000)
						else
							TriggerClientEvent("Notify",source,"vermelho","Gemas Insuficientes.",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
				end
			elseif shops[shopType]["mode"] == "Sell" then
				if shops[shopType]["list"][shopItem] then
					if shops[shopType]["type"] == "Cash" then
						if vRP.tryGetInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),true,slot) then	
							vRP.giveInventoryItem(parseInt(user_id),"dollars",parseInt(shops[shopType]["list"][shopItem]*shopAmount),false)
							TriggerClientEvent("Notify",source,"amarelo","Voce recebeu $"..shops[shopType]["list"][shopItem]*shopAmount.." dolares.",5000)
						end
					elseif shops[shopType]["type"] == "Consume" then
						if vRP.tryGetInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),true,slot) then

							vRP.giveInventoryItem(parseInt(user_id),shops[shopType]["item"],parseInt(shops[shopType]["list"][shopItem]*shopAmount),false)
						end
					end
				end
			end
		end

		TriggerClientEvent("vrp_shops:Update",source,"requestShop")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_shops:populateSlot")
AddEventHandler("vrp_shops:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
			vRP.giveInventoryItem(user_id,itemName,amount,false,target)
			TriggerClientEvent("vrp_shops:Update",source,"requestShop")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_shops:updateSlot")
AddEventHandler("vrp_shops:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
					vRP.giveInventoryItem(user_id,itemName,amount,false,target)
				end
			else
				vRP.swapSlot(user_id,slot,target)
			end
		end

		TriggerClientEvent("vrp_shops:Update",source,"requestShop")
	end
end)