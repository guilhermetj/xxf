local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
local idgens = Tools.newIDGenerator()
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
func2 = Tunnel.getInterface("jewelry")
func = {}
Tunnel.bindInterface("jewelry",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local jewelryStatus = false
local blips = {}
local timers = 0
local andamento = false
local roubando = false
local segundos = 0
local jewlryItem = "blackcard"

-----------------------------------------------------------------------------------------------------------------------------------------
-- JEWELRYUPDATESTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function func.jewelryUpdateStatus(status)
	TriggerClientEvent("jewelry:jewelryFunctionStart",-1,status)
	jewelryStatus = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- JEWELRYCHECKITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function func.jewelryCheckItens()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"c4") >= 1 then
			vRP.removeInventoryItem(user_id,"c4",1)
			jewelryCooldown = 7200
			jewelryTimer = 2700

			return true
		else
			TriggerClientEvent("Notify",source,"amarelo","Voce nao possui <b>c4</b>.",5000)
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKJEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkJewelry(x,y,z,h,sec,tipo)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local copAmount = vRP.numPermission("Police")
		if parseInt(#copAmount) < 3 then
			TriggerClientEvent("Notify",source,"amarelo","Número insuficiente de <b>Policiais no momento</b>.")
		elseif (os.time()-timers) <= 3600 then
			TriggerClientEvent("Notify",source,"amarelo","A <b>joalheria</b> não se recuperou do ultimo <b>roubo</b>, aguarde <b>"..vRP.format(parseInt((3600-(os.time()-timers)))).." segundos</b> até que o sistema seja <b>restaurado</b>.")
		else
			if vRP.tryGetInventoryItem(user_id,jewlryItem,1,true) then
				vRPclient._playAnim(source,false,{"missheist_jewel@hacking","hack_loop"},true)
				TriggerClientEvent('iniciandojewelry',source,x,y,z,h,sec,tipo,true)
				roubando = true
				SetTimeout(sec*1000,function()
					segundos = 600
					TriggerClientEvent('iniciandojewelrystart',source)
				end)
			else
				TriggerClientEvent("Notify",source,"amarelo","Precisa de um <b>Blackcard</b> para hackear as <b>câmeras</b> de <b>segurança</b>.")
			end
		 end
	end
end

RegisterNetEvent("jewelrystart")
AddEventHandler("jewelrystart",function()
	timers = os.time()
	andamento = true
	TriggerClientEvent('iniciandojewelry',source,x,y,z,h,sec,tipo,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function func.callPolice(x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	TriggerClientEvent("sounds:fixed",-1,source,x,y,z,100,'alarm',0.1)
	TriggerClientEvent("jewelry:bankNews",-1, 15)
	local copAmount = vRP.numPermission("Police")
	for k,v in pairs(copAmount) do
		local player = vRP.getUserSource(parseInt(w))
		if player then
			async(function()
				local ids = idgens:gen()
				vRPclient.playSound(player,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
				blips[ids] = vRPclient.addBlip(player,x,y,z,1,59,"Roubo a Joalheria",0.5,true)
				TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), text = "Me ajuda esta tento um roubo a joalheria nesta area escuto muitos tiros socorrooooo!", code = 31, title = "Roubo a joalheria", x = x, y = y, z = z, rgba = {105,52,136} })
				SetTimeout(60000,function() vRPclient.removeBlip(player,blips[ids]) idgens:free(ids) end)
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNJEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.returnJewelry()
	return andamento
end

function func.returnJewelry2()
	return roubando
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(timers) do
			if v > 0 then
				timers[k] = v - 1
			end
		end
		if andamento then
			segundos = segundos - 1
			if segundos <= 0 then
				timers = {}
				andamento = false
				roubando = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("jewelrysetmodel")
AddEventHandler("jewelrysetmodel",function(x,y,z,prop1,prop2)
	TriggerClientEvent("jewelrysetmodel",-1,x,y,z,prop1,prop2)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKJEWELS
-----------------------------------------------------------------------------------------------------------------------------------------
local jewels = {
	[1] = { item = "watch", nome = "Relogio(s) Roubado(s)" },
	[2] = { item = "bracelet", nome = "Pulseira(s) Roubada(s)" },
	[3] = { item = "ring", nome = "Anel(s) Roubado(s)" },
	[4] = { item = "goldbar", nome = "Colar(s) Roubado(s)" }

}

function func.checkJewels(id,x,y,z,xplayer,yplayer,zplayer,heading,prop1,prop2,tipo)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if timers[id] == 0 or not timers[id] then
			timers[id] = 600
			TriggerClientEvent('jewelryroubo',source,6,tipo,true,x,y,z,prop1,prop2,id)
			func2.setCoord(source,xplayer,yplayer,zplayer,heading)
			local quantidade = math.random(1,3)
			local joia = jewels[math.random(4)]
			if id == 4 or id == 13 or id == 14 or id == 17 then
			    SetTimeout(2000,function()
				    vRPclient.setStandBY(source,parseInt(60))
				    vRP.giveInventoryItem(user_id,joia.item,quantidade, true)
			    end)
			else
				SetTimeout(3100,function()
				    vRPclient.setStandBY(source,parseInt(60))
				    vRP.giveInventoryItem(user_id,joia.item,quantidade, true)
			    end)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","O balcão está vazio, aguarde <b>"..vRP.format(parseInt(timers[id])).." segundos</b> até que a loja se recupera do ultimo <b>roubo</b>.")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETOLDMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function func.returnJewels(id,x,y,z,prop1,prop2)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if timers[id] == 0 or not timers[id] and contagem == 0 then
			func2.setModel(-1,x,y,z,prop1,prop2)
			TriggerEvent("doors:doorsStatistics",17,true)
			contagem = 600
	    end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMECONTAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
local contagem = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if contagem >= 1 then
			contagem = contagem - 1
			if contagem <= 0 then
				contagem = false
			end
		end
	end
end)
