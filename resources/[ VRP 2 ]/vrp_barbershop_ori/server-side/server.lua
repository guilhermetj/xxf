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
Tunnel.bindInterface("vrp_barbershop",cnVRP)
vCLIENT = Tunnel.getInterface("vrp_barbershop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBER
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.checkOpen()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.updateSkin(myClothes)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/updateSkin",{ user_id = parseInt(user_id), fathers = parseInt(myClothes[1]), kinship = parseInt(myClothes[2]), eyecolor = parseInt(myClothes[3]), skincolor = parseInt(myClothes[4]), acne = parseInt(myClothes[5]), stains = parseInt(myClothes[6]), freckles = parseInt(myClothes[7]), aging = parseInt(myClothes[8]), hair = parseInt(myClothes[9]), haircolor = parseInt(myClothes[10]), haircolor2 = parseInt(myClothes[11]), makeup = parseInt(myClothes[12]), makeupintensity = parseInt(myClothes[13]), makeupcolor = parseInt(myClothes[14]), lipstick = parseInt(myClothes[15]), lipstickintensity = parseInt(myClothes[16]), lipstickcolor = parseInt(myClothes[17]), eyebrow = parseInt(myClothes[18]), eyebrowintensity = parseInt(myClothes[19]), eyebrowcolor = parseInt(myClothes[20]), beard = parseInt(myClothes[21]), beardintentisy = parseInt(myClothes[22]), beardcolor = parseInt(myClothes[23]), blush = parseInt(myClothes[24]), blushintentisy = parseInt(myClothes[25]), blushcolor = parseInt(myClothes[26]) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKINLOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local barberData = vRP.query("vRP/selectSkin",{ user_id = parseInt(user_id) })
	if barberData[1] then
		TriggerClientEvent("vrp_barbershop:setCustomization",source,{ parseInt(barberData[1].fathers),parseInt(barberData[1].kinship),parseInt(barberData[1].eyecolor),parseInt(barberData[1].skincolor),parseInt(barberData[1].acne),parseInt(barberData[1].stains),parseInt(barberData[1].freckles),parseInt(barberData[1].aging),parseInt(barberData[1].hair),parseInt(barberData[1].haircolor),parseInt(barberData[1].haircolor2),parseInt(barberData[1].makeup),parseInt(barberData[1].makeupintensity),parseInt(barberData[1].makeupcolor),parseInt(barberData[1].lipstick),parseInt(barberData[1].lipstickintensity),parseInt(barberData[1].lipstickcolor),parseInt(barberData[1].eyebrow),parseInt(barberData[1].eyebrowintensity),parseInt(barberData[1].eyebrowcolor),parseInt(barberData[1].beard),parseInt(barberData[1].beardintentisy),parseInt(barberData[1].beardcolor),parseInt(barberData[1].blush),parseInt(barberData[1].blushintentisy),parseInt(barberData[1].blushcolor) })
	else
		vRP.execute("vRP/insertSkin",{ user_id = parseInt(user_id) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("desbugar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRPclient.inVehicle(source) then
			local x,y,z = vRPclient.getPositions(source)
			local data = vRP.getUserDataTable(user_id)
			if data then
				TriggerClientEvent("syncarea",-1,x,y,z,2)
				vRPclient._setCustomization(source,data.customization)
				local consult = vRP.query("vRP/selectSkin",{ user_id = parseInt(user_id) })
				if consult[1] then
					Citizen.Wait(1000)
					TriggerClientEvent("vrp_barbershop:setCustomization",source,{ parseInt(consult[1].fathers),parseInt(consult[1].kinship),parseInt(consult[1].eyecolor),parseInt(consult[1].skincolor),parseInt(consult[1].acne),parseInt(consult[1].stains),parseInt(consult[1].freckles),parseInt(consult[1].aging),parseInt(consult[1].hair),parseInt(consult[1].haircolor),parseInt(consult[1].haircolor2),parseInt(consult[1].makeup),parseInt(consult[1].makeupintensity),parseInt(consult[1].makeupcolor),parseInt(consult[1].lipstick),parseInt(consult[1].lipstickintensity),parseInt(consult[1].lipstickcolor),parseInt(consult[1].eyebrow),parseInt(consult[1].eyebrowintensity),parseInt(consult[1].eyebrowcolor),parseInt(consult[1].beard),parseInt(consult[1].beardintentisy),parseInt(consult[1].beardcolor),parseInt(consult[1].blush),parseInt(consult[1].blushintentisy),parseInt(consult[1].blushcolor) })
				end
			end
		end
	end
end)