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
Tunnel.bindInterface("tablet",cRP)
vCLIENT = Tunnel.getInterface("tablet")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local twitter = {}
local anonimo = {}
local lockReq = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE RACES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_race","SELECT * FROM vrp_races WHERE raceid = @raceid")
vRP.prepare("vRP/update_race","UPDATE vrp_races SET vehicle = @vehicle WHERE user_id = @user_id and raceid = @raceid")
vRP.prepare("vRP/insert_race","INSERT INTO vrp_races(user_id,vehicle,raceid ) VALUES(@user_id,@vehicle,@raceid)")
vRP.prepare("vRP/show_race","SELECT * FROM vrp_races WHERE raceid = @raceid ORDER BY date2 ASC LIMIT 13")
vRP.prepare("vRP/show_conce","SELECT * FROM vehicles")
vRP.prepare("vRP/get_stock","SELECT stock FROM vehicles WHERE name = @name")
vRP.prepare("vRP/update_conce","UPDATE vehicles SET stock = stock - 1 WHERE name = @name")
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTWITTER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestMedia(media)
	if media == "Twitter" then
		return twitter
	elseif media == "Anonimo" then
		return anonimo
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTWITTER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.messageMedia(message,page)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local text = ""
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			if page == "Anonimo" then
				text = "<b>Anônimo</b> <i>("..os.date("%H")..":"..os.date("%M")..")</i><b>:</b> "..message
			else
				text = "<i><b>@"..identity.name..""..identity.name2.."</b><br>"..message
			end

			if page == "Twitter" then
				if vRP.getPremium(user_id) then
					table.insert(twitter,{ text = text, back = true })
					TriggerClientEvent("tablet:updateMedia", -1, page, text, true )
				else
					table.insert(twitter,{ text = text })
					TriggerClientEvent("tablet:updateMedia", -1, page, text, false )
				end
				TriggerClientEvent("Notify",-1,"amarelo","<b>@"..identity.name.."</b> Tweetou.",3000)
			elseif page == "Anonimo" then
				table.insert(anonimo,{ text = text })
				TriggerClientEvent("tablet:updateMedia", -1, page, text, false )
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local twitterFile = LoadResourceFile("logsystem","twitter.json")
	local anonimoFile = LoadResourceFile("logsystem","anonimo.json")

	twitter = json.decode(twitterFile)
	anonimo = json.decode(anonimoFile)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:KickAll")
AddEventHandler("admin:KickAll",function()
	SaveResourceFile("logsystem","twitter.json",json.encode(twitter),-1)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestBuy(name,form)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local getInvoice = vRP.getInvoice(user_id)
		if getInvoice[1] ~= nil then
			TriggerClientEvent("Notify",source,"vermelho","Encontramos faturas pendentes.",3000)
			return
		end
		local vehName = tostring(name)
		local query = vRP.query("vRP/get_stock",{ name = vehName })
		local maxVehs = vRP.query("vRP/con_maxvehs",{ user_id = parseInt(user_id) })
		local myGarages = vRP.getInformation(user_id)
		if vRP.getPremium(user_id) then
			if parseInt(maxVehs[1].qtd) >= parseInt(myGarages[1].garage) + 2 then
				TriggerClientEvent("Notify",source,"amarelo","Você atingiu o máximo de veículos em sua garagem.",3000)
				return
			end
		else
			if parseInt(maxVehs[1].qtd) >= parseInt(myGarages[1].garage) then
				TriggerClientEvent("Notify",source,"amarelo","Você atingiu o máximo de veículos em sua garagem.",3000)
				return
			end
		end


		for k,v in pairs(query) do
			if v.stock <= 0 then
				TriggerClientEvent("Notify",source,"amarelo","Esse veículo não tem mais estoque.",1000)
				return
			end
		end

		local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..vRP.vehicleName(vehName).."</b>.",3000)
			return
		else
			if vRP.paymentBank(user_id,parseInt(vRP.vehiclePrice(vehName))) then
				vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlateNumber(), phone = vRP.getPhone(user_id), work = tostring(false) })
				vRP.execute("vRP/update_conce",{ name = vehName })
				TriggerClientEvent("Notify",source,"verde","A compra foi concluída com sucesso.",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente na sua conta bancária.",5000)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestBuyAlugel(name,form)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local getInvoice = vRP.getInvoice(user_id)
		if getInvoice[1] ~= nil then
			TriggerClientEvent("Notify",source,"vermelho","Encontramos faturas pendentes.",3000)
			return
		end

		local vehName = tostring(name)
		local query = vRP.query("vRP/get_stock",{ name = vehName })
		local maxVehs = vRP.query("vRP/con_maxvehs",{ user_id = parseInt(user_id) })
		local myGarages = vRP.getInformation(user_id)
		if vRP.getPremium(user_id) then
			if parseInt(maxVehs[1].qtd) >= parseInt(myGarages[1].garage) + 2 then
				TriggerClientEvent("Notify",source,"amarelo","Você atingiu o máximo de veículos em sua garagem.",3000)
				return
			end
		else
			if parseInt(maxVehs[1].qtd) >= parseInt(myGarages[1].garage) then
				TriggerClientEvent("Notify",source,"amarelo","Você atingiu o máximo de veículos em sua garagem.",3000)
				return
			end
		end

		for k,v in pairs(query) do
			if v.stock <= 0 then
				TriggerClientEvent("Notify",source,"amarelo","Esse veículo não tem mais estoque.",1000)
				return
			end
		end

		local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..vRP.vehicleName(vehName).."</b>.",3000)
			return
		else
			if vRP.remGmsId(user_id,parseInt(vRP.vehiclePrice(vehName))) then
				vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = vehName, plate = vRP.generatePlateNumber(), phone = vRP.getPhone(user_id), work = tostring(false) })
				vRP.execute("vRP/set_rental_time",{ user_id = parseInt(user_id), vehicle = vehName, premiumtime = parseInt(os.time()+30*24*60*60) })
				vRP.execute("vRP/update_conce",{ name = vehName })
				TriggerClientEvent("Notify",source,"verde","A compra foi concluída com sucesso.",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho","Coins insuficiente na sua conta bancária.",5000)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestSell(name)
	local source = source
	local user_id = vRP.getUserId(source)	
	if user_id then
		if vRP.vehicleType(name) ~= nil then
			if not lockReq[user_id] or lockReq[user_id] <= os.time() then
				lockReq[user_id] = os.time() + 300
				local vehName = tostring(name)
				if vRP.vehicleType(tostring(name)) == "donate" then
					TriggerClientEvent("Notify",source,"vermelho","Voce nao pode vender este veiculo.",7000)
					return
				end

				if vRP.vehicleType(tostring(name)) == "work" then
					TriggerClientEvent("Notify",source,"vermelho","Voce nao pode vender este veiculo.",7000)
					return
				end

				local getInvoice = vRP.getInvoice(user_id)
				if getInvoice[1] ~= nil then
					TriggerClientEvent("Notify",source,"vermelho","Encontramos faturas pendentes.",3000)
					return
				end

				local getFines = vRP.getFines(user_id)
				if getFines[1] ~= nil then
					TriggerClientEvent("Notify",source,"vermelho","Encontramos multas pendentes.",3000)
					return
				end
				
				vRP.execute("vRP/rem_srv_data",{ dkey = "custom:"..parseInt(user_id)..":"..vehName })
				vRP.execute("vRP/rem_srv_data",{ dkey = "chest:"..parseInt(user_id)..":"..vehName })
				vRP.execute("vRP/rem_vehicle",{ user_id = parseInt(user_id), vehicle = vehName })
				vRP.addBank(user_id,parseInt(vRP.vehiclePrice(name)*0.75))
				TriggerClientEvent("Notify",source,"verde","Venda concluida com sucesso.",7000)
			else
				TriggerClientEvent("Notify",source,"vermelho","Aguarde 5 minutos para vender novamente.",7000)
				TriggerClientEvent("tablet:Update",-1)
			end
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------
function cRP.checktax(user_id,name)
    if user_id and name then

		local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = name })

		if vehicle[1] ~= nil then
			if parseInt(vehicle[1].arrest) >= 1 then
				return""..vRP.format(parseInt(vRP.vehiclePrice(name)*0.5))..""
			else
				return"0"
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------
function cRP.nametax(user_id,name)
    if user_id and name then

		local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = name })

		if vehicle[1] ~= nil then
			if parseInt(vehicle[1].arrest) >= 1 then
				return"Detido"
			else
				return"Liberado"
			end
		end
	end
end

function cRP.paymentTax(name,use)
	local source = source
    local user_id = vRP.getUserId(source)
    if user_id and name then
        if not vCLIENT.returnVehicle(source,name) then
			local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = name })
    		if parseInt(os.time()) <= parseInt(vehicle[1].time+24*60*60) then
				if vRP.paymentBank(user_id,parseInt(vRP.vehiclePrice(name)*0.5)) then
					vRP.execute("vRP/set_arrest",{ user_id = parseInt(user_id), vehicle = name, arrest = 0, time = 0 })
					TriggerClientEvent("Notify",source,"verde","Seu veiculo foi liberado.",5000)
				else
					TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
				end
			elseif parseInt(vehicle[1].arrest) >= 1 then
				if vRP.paymentBank(user_id,parseInt(vRP.vehiclePrice(name)*0.5)) then
					vRP.execute("vRP/set_arrest",{ user_id = parseInt(user_id), vehicle = name, arrest = 0, time = 0 })
					TriggerClientEvent("Notify",source,"verde","Seu veiculo foi liberado.",5000)
				else
					TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
				end
			end
		end
	end
end
-------------------------------------------------------------- PAYMENT DRIVE ----------------------------------------------------------
function cRP.paymentDrive()
	local source = source
    local user_id = vRP.getUserId(source)
	local valor = math.random(0,0)
    if user_id then
		if vRP.paymentBank(user_id,valor) then
			TriggerClientEvent("Notify",source,"verde","Voce pagou $"..valor.."pelo test drive.",5000)
		else
			TriggerClientEvent("Notify",source,"vermelho","Voce nao tem dinheiro.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETOWNED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPossuidos()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehList = {}
		local vehicles = vRP.query("vRP/get_vehicle",{ user_id = user_id })
		for k,v in pairs(vehicles) do
			table.insert(vehList,{ k = v.vehicle, name = vRP.vehicleName(v.vehicle), price = parseInt(vRP.vehiclePrice(v.vehicle)*0.7), chest = parseInt(vRP.vehicleChest(v.vehicle)), tax = cRP.checktax(user_id,v.vehicle), veiculo = cRP.nametax(user_id,v.vehicle) })
		end
		return vehList
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRANKING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestRanking(id)
    local query = vRP.query("vRP/show_race",{ raceid = id })
    local dados = {}
    for k,v in pairs(query) do
		local user_id = v.user_id
		local identity = vRP.getUserIdentity(user_id)
		local lastname = identity.name.." "..identity.name2
		local date = v.date
		local date2 = v.date2

        table.insert(dados,{ k = k, vehicle = vRP.vehicleName(v.vehicle), raceid = id, lastname = lastname, date = date, date2 = date2 })
    end
    return dados
end

-- CARROS 

function cRP.requestCarros()
	local vehicles = vRP.query("vRP/show_conce",{})
	local typeCars = {}
	for k,v in pairs(vehicles) do
		if vRP.vehicleType(v.name) == "cars" then
			table.insert(typeCars,{ k = v.name, name = vRP.vehicleName(v.name), price = vRP.vehiclePrice(v.name), chest = vRP.vehicleChest(v.name), stock = v.stock })
		end
	end
	return typeCars
end

-- MOTOS

function cRP.requestBikes()
	local vehicles = vRP.query("vRP/show_conce",{})
	local typeBikes = {}
	for k,v in pairs(vehicles) do
		if vRP.vehicleType(v.name) == "bikes" then
			table.insert(typeBikes,{ k = v.name, name = vRP.vehicleName(v.name), price = vRP.vehiclePrice(v.name), chest = vRP.vehicleChest(v.name), stock = v.stock })
		end
	end
	return typeBikes
end

-- VIP

function cRP.requestAluguel()
	local vehicles = vRP.query("vRP/show_conce",{})
	local typeAlugel = {}
	for k,v in pairs(vehicles) do
		if vRP.vehicleType(v.name) == "donate" then
			table.insert(typeAlugel,{ k = v.name, name = vRP.vehicleName(v.name), price = vRP.vehiclePrice(v.name), chest = vRP.vehicleChest(v.name), stock = v.stock })
		end
	end
	return typeAlugel
end


