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
cRP = {}
Tunnel.bindInterface("raceillegal",cRP)
vCLIENT = Tunnel.getInterface("raceillegal")

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE RACES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_winrace","SELECT user_id,raceid FROM vrp_races WHERE user_id = @user_id and raceid = @raceid")
vRP.prepare("vRP/update_winrace","UPDATE vrp_races SET vehicle = @vehicle, date = @date, date2 = @date2 WHERE user_id = @user_id and raceid = @raceid")
vRP.prepare("vRP/insert_winrace","INSERT INTO vrp_races(user_id,vehicle,raceid,date,date2) VALUES(@user_id,@vehicle,@raceid,@date, @date2)")
vRP.prepare("vRP/show_winrace","SELECT * FROM vrp_races WHERE raceid = @id ORDER BY date2 DESC LIMIT 13")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKCONSUME
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkConsume()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"raceticket",1) then
			local x,y,z = vRPclient.getPositions(source)
			local copAmount = vRP.numPermission("Police")
			TriggerEvent("blipsystem:serviceEnter",source,"Corredor",75)
			vRP.upgradeStress(user_id,5)
			for k,v in pairs(copAmount) do
				async(function()
					TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), code = 20, title = "Denúncia de Corrida Ilegal", x = x, y = y, z = z, rgba = {41,76,119} })
				end)
			end
			return true
		else
			TriggerClientEvent("Notify",source,"amarelo","Você precisa de uma <b>Credencial</b> para correr.",5000)
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkwantedcorrida()
	local source = source
	local user_id = vRP.getUserId(source)
	if not vRP.wantedReturn(user_id) then
		return true
	else 
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHRACES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finishRaces()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
	local identity = vRP.getUserIdentity(user_id)
		vRP.wantedTimer(user_id,900)
		TriggerEvent("blipsystem:serviceExit",source)
		vRP.giveInventoryItem(user_id,"dollars2",math.random(6500,7500),true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHRACES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finishRacesDatabase(Selected,racetime)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local identity = vRP.getUserIdentity(user_id)
        local _,_,_,vname = vRPclient.vehList(source,7)
        Wait(5000)
        local rows = vRP.query("vRP/get_winrace",{ user_id = user_id , raceid = Selected })
        if #rows > 0 then
            vRP.execute("vRP/update_winrace", { user_id = user_id, vehicle = vname, raceid = Selected, date = os.date("%d.%m.%Y"), date2 = racetime} )
		else
            vRP.execute("vRP/insert_winrace", { user_id = user_id, vehicle = vname, raceid = Selected, date = os.date("%d.%m.%Y"), date2 = racetime} )
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACEILLEGAL:EXPLOSIVEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("raceillegal:explosivePlayers")
AddEventHandler("raceillegal:explosivePlayers",function()
	local source = source
	TriggerEvent("blipsystem:serviceExit",source)
end)
