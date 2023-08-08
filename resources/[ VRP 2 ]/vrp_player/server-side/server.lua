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
Tunnel.bindInterface("vrp_player",cnVRP)
vCLIENT = Tunnel.getInterface("vrp_player")
vTASKBAR = Tunnel.getInterface("vrp_taskbar")
vSKINSHOP = Tunnel.getInterface("vrp_skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WECOLOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wecolor",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(args[1]) >= 0 and parseInt(args[1]) <= 7 then
			if vRP.getPremium(user_id) then
				vCLIENT.weColors(source,parseInt(args[1]))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WELUX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("welux",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getPremium(user_id) then
			vCLIENT.weLux(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMOTES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vCLIENT.getHandcuff(source) then
			if args[2] == "friend" then
				local identity = vRP.getUserIdentity(user_id)
				local nplayer = vRPclient.nearestPlayer(source,2)
				if nplayer then
					if vRPclient.getHealth(nplayer) > 101 and not vCLIENT.getHandcuff(nplayer) then
						local request = vRP.request(nplayer,"Você aceita o pedido de <b>"..identity.name.." da animação <b>"..args[1].."</b>?",30)
						if request then
							TriggerClientEvent("emotes",nplayer,args[1])
							TriggerClientEvent("emotes",source,args[1])
						end
					end
				end
			else
				TriggerClientEvent("emotes",source,args[1])
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- /ptr /mec /ems
-----------------------------------------------------------------------------------------------------------------------------------------

-- RegisterCommand('ptr', function(source)
--     local user_id = vRP.getUserId(source)
--         copAmount = vRP.numPermission("Police")
--         TriggerClientEvent('Notify',source,'roxo','Existem ' .. #copAmount .. ' Policiais em serviço!',5000)
-- end)

-- RegisterCommand('samu', function(source)
--     local user_id = vRP.getUserId(source)
--         medic = vRP.numPermission("Paramedic")
--         TriggerClientEvent('Notify',source,'roxo','Existem ' .. #medic ..' Medicos em serviço!',5000)
-- end)

-- RegisterCommand('mec', function(source)
--     local user_id = vRP.getUserId(source)
--         mec = vRP.numPermission("Mechanic")
--         TriggerClientEvent('Notify',source,'roxo','Existem ' .. #mec ..' Mecanicos em serviço!',5000)
-- end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("premium",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			local consult = vRP.getInfos(identity.steam)
			if consult[1] and parseInt(os.time()) <= parseInt(consult[1].premium+24*consult[1].predays*60*60) then
				TriggerClientEvent("Notify",source,"roxo","Você ainda tem "..vRP.getTimers(parseInt(86400*consult[1].predays-(os.time()-consult[1].premium))).." de benefícios <b>Premium</b>.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("capo",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 then
			local vehicle,vehNet = vRPclient.vehList(source,7)
			if vehicle then
				TriggerClientEvent("vrp_player:syncHood",-1,vehNet)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("portas",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
			local vehicle,vehNet = vRPclient.vehList(source,7)
			if vehicle then
				TriggerClientEvent("vrp_player:syncDoors",-1,vehNet,args[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("janelas",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
			local vehicle,vehNet = vRPclient.vehList(source,7)
			if vehicle then
				TriggerClientEvent("vrp_player:syncWins",-1,vehNet,args[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_player:salary")
AddEventHandler("vrp_player:salary",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getPremium(parseInt(user_id)) then
		end

		if vRP.hasPermission(parseInt(user_id),"Police") then
			vRP.setSalary(parseInt(user_id),4000)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario.",5000)
		end

		if vRP.hasPermission(parseInt(user_id),"Mechanic") then
			vRP.setSalary(parseInt(user_id),1000)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario.",5000)
		end

		-- if vRP.hasPermission(parseInt(user_id),"nitroboost") then
		-- 	vRP.setSalary(parseInt(user_id),999)
		-- 	TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario.",5000)
		-- end

		-- if vRP.hasPermission(parseInt(user_id),"Taxista") then
		-- 	vRP.setSalary(parseInt(user_id),500)
		-- 	TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario.",5000)
		-- end

		if vRP.hasPermission(parseInt(user_id),"Paramedic") then
			vRP.setSalary(parseInt(user_id),5000)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario.",5000)
		end

		--------------------------------- PERMISSOES DE VIPS ## NAO SETAR NGM MANUAL!

		if vRP.hasPermission(parseInt(user_id),"PRATA") then
			vRP.setSalary(parseInt(user_id),1000)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario e obrigado por ajudar <3",5000)
		end	
		if vRP.hasPermission(parseInt(user_id),"OURO") then
			vRP.setSalary(parseInt(user_id),2500)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario e obrigado por ajudar <3",5000)
		end
		if vRP.hasPermission(parseInt(user_id),"DIAMANTE") then
			vRP.setSalary(parseInt(user_id),5000)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario e obrigado por ajudar <3",5000)
		end
		if vRP.hasPermission(parseInt(user_id),"PLATINA") then
			vRP.setSalary(parseInt(user_id),3500)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario e obrigado por ajudar <3",5000)
		end
		if vRP.hasPermission(parseInt(user_id),"SUPREMO") then
			vRP.setSalary(parseInt(user_id),9000)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario e obrigado por ajudar <3",5000)
		end
		if vRP.hasPermission(parseInt(user_id),"CIDADE") then
			vRP.setSalary(parseInt(user_id),12000)
			TriggerClientEvent("Notify",source,"verde","Voce recebeu seu salario e obrigado por ajudar <3",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.deleteChar()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/remove_characters",{ id = parseInt(user_id) })
		Citizen.Wait(1000)
		vRP.rejoinServer(source)
		Citizen.Wait(1000)
		TriggerClientEvent("vrp_spawn:setupChars",source)
	end
end
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- CALL
-- -----------------------------------------------------------------------------------------------------------------------------------------
 RegisterCommand("chamar",function(source,args,rawCommand)
 	local user_id = vRP.getUserId(source)
 	if user_id then
 		if not vCLIENT.getHandcuff(source) then
 			local service = vRP.prompt(source,"190: Polícia  |  192: Paramédico  |  515: Mecanico","")
 			if service == "" or (parseInt(service) ~= 190 and parseInt(service) ~= 192 and parseInt(service) ~= 515 and parseInt(service) ~= 777) then
 				return
 			end

 			local description = vRP.prompt(source,"Descrição do ocorrido:","")
 			if description == "" then
 				return
 			end

 			local players = {}
 			local answered = false
 			if parseInt(service) == 190 then
				players = vRP.numPermission("Police")
 			elseif parseInt(service) == 192 then
 				players = vRP.numPermission("Paramedic")
 			elseif parseInt(service) == 515 then
 				players = vRP.numPermission("Mechanic")
 			end

 			TriggerClientEvent("Notify",source,"verde","Chamado efetuado com sucesso, aguarde no local.",5000)

 			local x,y,z = vRPclient.getPositions(source)
 			local identity = vRP.getUserIdentity(user_id)

 			for k,v in pairs(players) do
 				local nuser_id = vRP.getUserId(v)
 				local identitys = vRP.getUserIdentity(nuser_id)
 				if v and v ~= source then
 					async(function()
 						TriggerClientEvent("chatMessage",v,identity.name.." "..identity.name2,{107,182,84},description)
 						local request = vRP.request(v,"Aceitar o chamado de <b>"..identity.name.."</b>?",30)
 						if request then
 							TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Chamado", x = x, y = y, z = z, name = identity.name.." "..identity.name2, phone = identity.phone, rgba = {69,115,41} })
 							if not answered then
 								answered = true
 								vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
 								TriggerClientEvent("Notify",source,"roxo","Chamado atendido por <b>"..identitys.name.." "..identitys.name2.."</b>, aguarde no local.",10000)
 							else
 								TriggerClientEvent("Notify",v,"vermelho","Chamado já foi atendido por outra pessoa.",5000)
 								vRPclient.playSound(v,"CHECKPOINT_MISSED","HUD_MINI_GAME_SOUNDSET")
 							end
 						end
 					end)
 				end
 			end
 		end
 	end
 end)
----------------------------------------------------------------------------------------------------------------------------------------
-- PR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pr",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		if vRP.hasPermission(user_id,"Police") then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				local identity = vRP.getUserIdentity(user_id)
				local police = vRP.numPermission("Police")
				for k,v in pairs(police) do
					async(function()
						TriggerClientEvent("chatMessage",v,identity.name.." "..identity.name2,{255,175,175},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXTRAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("extras",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		if vRP.hasPermission(user_id,"Police") then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				vCLIENT.extraVehicle(args[1],source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hr",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		if vRP.hasPermission(user_id,"Paramedic") then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				local identity = vRP.getUserIdentity(user_id)
				local police = vRP.numPermission("Paramedic")
				for k,v in pairs(police) do
					async(function()
						TriggerClientEvent("chatMessage",v,identity.name.." "..identity.name2,{255,175,175},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATENAME
-----------------------------------------------------------------------------------------------------------------------------------------
local plateName = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio","Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local plateName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
local plateSave = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("placa",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") then
			if vRPclient.getHealth(source) > 101 then
				if args[1] then
					local plateUser = vRP.getVehiclePlate(tostring(args[1]))
					if plateUser then
						local identity = vRP.getUserIdentity(plateUser)
						if identity then
							vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
							TriggerClientEvent("Notify",source,"roxo","<b>Passaporte:</b> "..identity.id.."<br><b>RG:</b> "..identity.registration.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>Telefone:</b> "..identity.phone,25000)
						end
					else
						if not plateSave[string.upper(args[1])] then
							plateSave[string.upper(args[1])] = { math.random(5000,9999),plateName[math.random(#plateName)].." "..plateName2[math.random(#plateName2)],vRP.generatePhoneNumber() }
						end

						vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
						TriggerClientEvent("Notify",source,"roxo","<b>Passaporte:</b> "..plateSave[args[1]][1].."<br><b>RG:</b> "..string.upper(args[1]).."<br><b>Nome:</b> "..plateSave[args[1]][2].."<br><b>Telefone:</b> "..plateSave[args[1]][3],25000)
					end
				else
					local vehicle,vehNet,vehPlate = vRPclient.vehList(source,7)
					if vehicle then
						local plateUser = vRP.getVehiclePlate(vehPlate)
						if plateUser then
							local identity = vRP.getUserIdentity(plateUser)
							if identity then
								vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
								TriggerClientEvent("Notify",source,"roxo","<b>Passaporte:</b> "..identity.id.."<br><b>RG:</b> "..identity.registration.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>Telefone:</b> "..identity.phone,25000)
							end
						else
							if not plateSave[vehPlate] then
								plateSave[vehPlate] = { math.random(5000,9999),plateName[math.random(#plateName)].." "..plateName2[math.random(#plateName2)],vRP.generatePhoneNumber() }
							end

							vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
							TriggerClientEvent("Notify",source,"roxo","<b>Passaporte:</b> "..plateSave[vehPlate][1].."<br><b>RG:</b> "..vehPlate.."<br><b>Nome:</b> "..plateSave[vehPlate][2].."<br><b>Telefone:</b> "..plateSave[vehPlate][3],25000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DETIDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("detido",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				local vehicle,vehNet,vehPlate,vehName = vRPclient.vehList(source,7)
				if vehicle then
					local plateUser = vRP.getVehiclePlate(vehPlate)
					local inVehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(plateUser), vehicle = vehName })
					if inVehicle[1] then
						if inVehicle[1].arrest <= 0 then
							vRP.execute("vRP/set_arrest",{ user_id = parseInt(plateUser), vehicle = vehName, arrest = 1, time = parseInt(os.time()) })
							TriggerClientEvent("Notify",source,"amarelo","Veículo <b>apreendido</b>.",3000)
							TriggerClientEvent("Notify",plateUser,"amarelo","Veículo <b>"..vRP.vehicleName(vehName).."</b> foi conduzido para o <b>DMV</b>.",7000)
						else
							TriggerClientEvent("Notify",source,"roxo","O veículo está no galpão da polícia.",5000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("service",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vCLIENT.getHandcuff(source) then
			local distanceService,service = vCLIENT.distanceService(source)
			if distanceService then
				if service == "Police" then
					if vRP.hasPermission(user_id,"Police") then
						vRP.removePermission(source,"Police")
						TriggerEvent("vrp_blipsystem:serviceExit",source)
						TriggerClientEvent("vrp_tencode:StatusService",source,false)
						TriggerClientEvent("police:updateService",source,false)
						TriggerClientEvent("Notify",source,"roxo","Você saiu de serviço.",5000)
						vRP.execute("vRP/upd_group",{ user_id = user_id, permiss = "Police", newpermiss = "waitPolice" })
					elseif vRP.hasPermission(user_id,"waitPolice") then
						vRP.insertPermission(source,"Police")
						TriggerClientEvent("vrp_tencode:StatusService",source,true)
						TriggerClientEvent("police:updateService",source,true)
						TriggerEvent("vrp_blipsystem:serviceEnter",source,"Policial",77)
						TriggerClientEvent("Notify",source,"roxo","Você entrou em serviço.",5000)
						vRP.execute("vRP/upd_group",{ user_id = user_id, permiss = "waitPolice", newpermiss = "Police" })
					end
				end

				if service == "Paramedic" then
					if vRP.hasPermission(user_id,"Paramedic") then
						vRP.removePermission(source,"Paramedic")
						TriggerEvent("vrp_blipsystem:serviceExit",source)
						TriggerClientEvent("Notify",source,"roxo","Você saiu de serviço.",5000)
						vRP.execute("vRP/upd_group",{ user_id = user_id, permiss = "Paramedic", newpermiss = "waitParamedic" })
					elseif vRP.hasPermission(user_id,"waitParamedic") then
						vRP.insertPermission(source,"Paramedic")
						TriggerEvent("vrp_blipsystem:serviceEnter",source,"Paramedico",83)
						TriggerClientEvent("Notify",source,"roxo","Você entrou em serviço.",5000)
						vRP.execute("vRP/upd_group",{ user_id = user_id, permiss = "waitParamedic", newpermiss = "Paramedic" })
					end
				end
			
				if service == "Mechanic" then
					if vRP.hasPermission(user_id,"Mechanic") then
						vRP.removePermission(source,"Mechanic")
						TriggerEvent("vrp_blipsystem:serviceExit",source)
						TriggerClientEvent("Notify",source,"roxo","Você saiu de serviço.",5000)
						vRP.execute("vRP/upd_group",{ user_id = user_id, permiss = "Mechanic", newpermiss = "waitMechanic" })
					elseif vRP.hasPermission(user_id,"waitMechanic") then
						vRP.insertPermission(source,"Mechanic")
						TriggerEvent("vrp_blipsystem:serviceEnter",source,"Mechanic",83)
						TriggerClientEvent("Notify",source,"roxo","Você entrou em serviço.",5000)
						vRP.execute("vRP/upd_group",{ user_id = user_id, permiss = "waitMechanic", newpermiss = "Mechanic" })
					end
				end
			else
				TriggerClientEvent("Notify",source,"roxo","Você esta lonje de sua sede.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUFF
-----------------------------------------------------------------------------------------------------------------------------------------
local poCuff = {}
function cnVRP.cuffToggle()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Suporte") then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) and poCuff[user_id] == nil then
				if not vRPclient.inVehicle(source) then
					local nplayer = vRPclient.nearestPlayer(source,2)
					if nplayer then
						if vCLIENT.getHandcuff(nplayer) then
							vCLIENT.toggleHandcuff(nplayer)
							vRPclient._stopAnim(nplayer,false)
							TriggerClientEvent("vrp_sound:source",source,"uncuff",0.5)
							TriggerClientEvent("vrp_sound:source",nplayer,"uncuff",0.5)
						else
							poCuff[user_id] = true
							local taskResult = vTASKBAR.taskHandcuff(nplayer)
							if not taskResult then
								vCLIENT.toggleHandcuff(nplayer)
								TriggerClientEvent("vrp_sound:source",source,"cuff",0.5)
								TriggerClientEvent("vrp_sound:source",nplayer,"cuff",0.5)
								vRPclient._playAnim(nplayer,true,{"mp_arresting","idle"},true)
							end
							poCuff[user_id] = nil
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
local shotFired = {}
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(shotFired) do
			if shotFired[k] > 0 then
				shotFired[k] = v - 10
				if shotFired[k] <= 0 then
					shotFired[k] = nil
				end
			end
		end
		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.shotsFired()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shotFired[user_id] == nil then
			if not vRP.hasPermission(user_id,"Police") then
				local distance = vCLIENT.shotDistance(source)

				if distance then
					shotFired[user_id] = 30
					local x,y,z = vRPclient.getPositions(source)
					local comAmount = vRP.numPermission("Police")
					for k,v in pairs(comAmount) do
						async(function()
							TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), text = "Ei esta tendo troca de tiro aqui perto de minha casa!", code = 10, title = "Confronto em andamento", x = x, y = y, z = z, criminal = "Disparos de arma de fogo", rgba = {105,52,136} })
						end)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARRY
-----------------------------------------------------------------------------------------------------------------------------------------
function cnVRP.carryToggle()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Paramedic") or vRP.hasPermission(user_id,"Suporte") then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				local nplayer = vRPclient.nearestPlayer(source,2)
				if nplayer then
					vCLIENT.toggleCarry(nplayer,source)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARRY
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterCommand("carregar2",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Paramedic") then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				local nplayer = vRPclient.nearestPlayer(source,2)
				if nplayer then
					TriggerClientEvent("vrp_rope:toggleRope",source,nplayer)
				end
			end
		end
	end
end)]]--
-----------------------------------------------------------------------------------------------------------------------------------------
-- RV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Paramedic") or vRP.getInventoryItemAmount(user_id,"rope")  or vRP.hasPermission(user_id,"Suporte") >= 1 then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) and not vRPclient.inVehicle(source) then
				local vehicle,vehNet,vehPlate,vehName,vehLock = vRPclient.vehList(source,11)
				if vehicle then
					if vehLock ~= 1 then
						local nplayer = vRPclient.nearestPlayer(source,11)
						if nplayer then
							vCLIENT.removeVehicle(nplayer)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Paramedic") or vRP.getInventoryItemAmount(user_id,"rope") or vRP.hasPermission(user_id,"Suporte")  >= 1 then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) and not vRPclient.inVehicle(source) then
				local vehicle,vehNet,vehPlate,vehName,vehLock = vRPclient.vehList(source,11)
				if vehicle then
					if vehLock ~= 1 then
						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer then
							vCLIENT.putVehicle(nplayer,args[1])
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rg",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Admin") then
			if parseInt(args[1]) > 0 then
				local nuser_id = parseInt(args[1])
				local identity = vRP.getUserIdentity(nuser_id)
				if identity then
					local fines = 0
					local consult = vRP.getFines(nuser_id)
					for k,v in pairs(consult) do
						fines = parseInt(fines) + parseInt(v.price)
					end

					TriggerClientEvent("Notify",source,"roxo","<b>Passaporte:</b> "..identity.id.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone.."<br><b>Multas Pendentes:</b> $"..vRP.format(parseInt(fines)),20000)
				end
			else
				local nplayer = vRPclient.nearestPlayer(source,2)
				if nplayer then
					local nuser_id = vRP.getUserId(nplayer)
					if nuser_id then
						local identity = vRP.getUserIdentity(nuser_id)
						if identity then
							local fines = 0
							local consult = vRP.getFines(nuser_id)
							for k,v in pairs(consult) do
								fines = parseInt(fines) + parseInt(v.price)
							end

							TriggerClientEvent("Notify",source,"roxo","<b>Passaporte:</b> "..identity.id.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone.."<br><b>Multas Pendentes:</b> $"..vRP.format(parseInt(fines)),20000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	["Police"] = {
		["1"] = {
			["homem"] = {
				["hat"] = { item = -1, texture = 1, defaultItem = -1, defaultTexture = 0 }, --chapéu     -------  ALUNO ---------
				["pants"] = { item = 14, texture = 1, defaultItem = 0, defaultTexture = 0 },  --calça
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --colete
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --pulseira
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --adesivo
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 }, --mascarar
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 }, --sapatos
				["t-shirt"] = { item = -1, texture = 0, defaultItem = 1, defaultTexture = 0 }, --camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --sacola mochila
				["torso2"] = { item = 93, texture = 0, defaultItem = 0, defaultTexture = 0 }, --tronco
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 }, --acessorios
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --chapéu
				["arms"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --braços
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --vidro
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 } --orelha
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 16, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 32, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 266, texture = 5, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["2"] = {
			["homem"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --chapéu  ------------ oficial  -----------
				["pants"] = { item = 59, texture = 9, defaultItem = 0, defaultTexture = 0 },  --calça
				["vest"] = { item = 8, texture = 0, defaultItem = 0, defaultTexture = 0 }, --colete
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --pulseira
				["decals"] = { item = 8, texture = 0, defaultItem = 0, defaultTexture = 0 }, --adesivo
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 }, --mascarar
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 }, --sapatos
				["t-shirt"] = { item = 15, texture = 0, defaultItem = 1, defaultTexture = 0 }, --camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --sacola mochila
				["torso2"] = { item = 139, texture = 0, defaultItem = 0, defaultTexture = 0 }, --tronco
				["accessory"] = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, --acessorios
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --RELOGIO
				["arms"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --braços
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --vidro
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 } --orelha
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 90, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 7, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 266, texture = 5, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["3"] = {
			["homem"] = {
				["hat"] = { item = 16, texture = 0, defaultItem = -1, defaultTexture = 0 }, --chapéu   ----------- ROMIC ----------
				["pants"] = { item = 33, texture = 0, defaultItem = 0, defaultTexture = 0 },  --calça
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --colete
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --pulseira
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --adesivo
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 }, --mascarar
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 }, --sapatos
				["t-shirt"] = { item = 39, texture = 0, defaultItem = 1, defaultTexture = 0 }, --camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --sacola mochila
				["torso2"] = { item = 220, texture = 3, defaultItem = 0, defaultTexture = 0 }, --tronco
				["accessory"] = { item = 14, texture = 0, defaultItem = 0, defaultTexture = 0 }, --acessorios
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --chapéu
				["arms"] = { item = 19, texture = 0, defaultItem = 0, defaultTexture = 0 }, --braços
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --vidro
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 } --orelha
			},
			["mulher"] = {
				["hat"] = { item = 18, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 30, texture = 2, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 35, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 266, texture = 3, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["4"] = {
			["homem"] = {
				["hat"] = { item = 19, texture = 0, defaultItem = -1, defaultTexture = 0 }, --chapéu --------- GAIC --------
				["pants"] = { item = 87, texture = 0, defaultItem = 0, defaultTexture = 0 },  --calça
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --colete
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --pulseira
				["decals"] = { item = 8, texture = 0, defaultItem = 0, defaultTexture = 0 }, --adesivo
				["mask"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --mascarar
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 }, --sapatos
				["t-shirt"] = { item = 6, texture = 1, defaultItem = 1, defaultTexture = 0 }, --camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --sacola mochila
				["torso2"] = { item = 220, texture = 4, defaultItem = 0, defaultTexture = 0 }, --tronco
				["accessory"] = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, --acessorios
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --RELOGIO
				["arms"] = { item = 17, texture = 0, defaultItem = 0, defaultTexture = 0 }, --braços
				["glass"] = { item = 5, texture = 2, defaultItem = 0, defaultTexture = 0 }, --vidro
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 } --orelha
			},
			["mulher"] = {
				["hat"] = { item = 19, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 61, texture = 8, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 24, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 6, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 266, texture = 4, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 70, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["5"] = {
			["homem"] = {
				["hat"] = { item = 19, texture = 0, defaultItem = -1, defaultTexture = 0 }, --chapéu --------- GAIC --------
				["pants"] = { item = 87, texture = 0, defaultItem = 0, defaultTexture = 0 },  --calça
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --colete
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --pulseira
				["decals"] = { item = 8, texture = 0, defaultItem = 0, defaultTexture = 0 }, --adesivo
				["mask"] = { item = 52, texture = 0, defaultItem = 0, defaultTexture = 0 }, --mascarar
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 }, --sapatos
				["t-shirt"] = { item = 6, texture = 1, defaultItem = 1, defaultTexture = 0 }, --camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --sacola mochila
				["torso2"] = { item = 220, texture = 4, defaultItem = 0, defaultTexture = 0 }, --tronco
				["accessory"] = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, --acessorios
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --RELOGIO
				["arms"] = { item = 17, texture = 0, defaultItem = 0, defaultTexture = 0 }, --braços
				["glass"] = { item = 5, texture = 2, defaultItem = 0, defaultTexture = 0 }, --vidro
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 } --orelha
			},
			["mulher"] = {
				["hat"] = { item = 19, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 61, texture = 8, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 35, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 24, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 6, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 266, texture = 4, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 70, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 11, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["6"] = {
			["homem"] = {
				["hat"] = { item = 0, texture = 0, defaultItem = -1, defaultTexture = 0 }, --chapéu --------- SPEED --------
				["pants"] = { item = 87, texture = 0, defaultItem = 0, defaultTexture = 0 },  --calça
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --colete
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --pulseira
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --adesivo
				["mask"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --mascarar
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 }, --sapatos
				["t-shirt"] = { item = 16, texture = 0, defaultItem = 1, defaultTexture = 0 }, --camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --sacola mochila
				["torso2"] = { item = 220, texture = 1, defaultItem = 0, defaultTexture = 0 }, --tronco
				["accessory"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --acessorios
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --RELOGIO
				["arms"] = { item = 17, texture = 0, defaultItem = 0, defaultTexture = 0 }, --braços
				["glass"] = { item = 5, texture = 2, defaultItem = 0, defaultTexture = 0 }, --vidro
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 } --orelha
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 61, texture = 9, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 24, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 9, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 266, texture = 1, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 70, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 11, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["7"] = {
			["homem"] = {
				["hat"] = { item = 0, texture = 0, defaultItem = -1, defaultTexture = 0 }, --chapéu --------- GOTIC --------
				["pants"] = { item = 87, texture = 0, defaultItem = 0, defaultTexture = 0 },  --calça
				["vest"] = { item = 6, texture = 0, defaultItem = 0, defaultTexture = 0 }, --colete
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --pulseira
				["decals"] = { item = 8, texture = 0, defaultItem = 0, defaultTexture = 0 }, --adesivo
				["mask"] = { item = 103, texture = 20, defaultItem = 0, defaultTexture = 0 }, --mascarar
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 }, --sapatos
				["t-shirt"] = { item = 54, texture = 0, defaultItem = 1, defaultTexture = 0 }, --camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --sacola mochila
				["torso2"] = { item = 220, texture = 0, defaultItem = 0, defaultTexture = 0 }, --tronco
				["accessory"] = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, --acessorios
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --RELOGIO
				["arms"] = { item = 17, texture = 0, defaultItem = 0, defaultTexture = 0 }, --braços
				["glass"] = { item = 15, texture = 0, defaultItem = 0, defaultTexture = 0 }, --vidro
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 } --orelha
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 61, texture = 9, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 6, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 107, texture = 13, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 24, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 7, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 230, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 34, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 9, texture = 5, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["8"] = {
			["homem"] = {
				["hat"] = { item = 106, texture = 20, defaultItem = -1, defaultTexture = 0 }, --chapéu --------- coronel --------
				["pants"] = { item = 87, texture = 0, defaultItem = 0, defaultTexture = 0 },  --calça
				["vest"] = { item = 2, texture = 0, defaultItem = 0, defaultTexture = 0 }, --colete
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --pulseira
				["decals"] = { item = 8, texture = 3, defaultItem = 0, defaultTexture = 0 }, --adesivo
				["mask"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --mascarar
				["shoes"] = { item = 25, texture = 0, defaultItem = 1, defaultTexture = 0 }, --sapatos
				["t-shirt"] = { item = 55, texture = 0, defaultItem = 1, defaultTexture = 0 }, --camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --sacola mochila
				["torso2"] = { item = 53, texture = 0, defaultItem = 0, defaultTexture = 0 }, --tronco
				["accessory"] = { item = 1, texture = 0, defaultItem = 0, defaultTexture = 0 }, --acessorios
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, --RELOGIO
				["arms"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }, --braços
				["glass"] = { item = 18, texture = 2, defaultItem = 0, defaultTexture = 0 }, --vidro
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 } --orelha
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 30, texture = 2, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 7, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 103, texture = 13, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 24, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 230, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 212, texture = 9, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = -1, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		}
	},
	["Paramedic"] = {
		["1"] = {
			["homem"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 96, texture = 1, defaultItem = 0, defaultTexture = 0 },--calca
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 42, texture = 1, defaultItem = 1, defaultTexture = 0 },--sapatos
				["t-shirt"] = { item = 15, texture = 0, defaultItem = 1, defaultTexture = 0 }, -- camiseta
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 250, texture = 1, defaultItem = 0, defaultTexture = 0 }, -- jaqueta
				["accessory"] = { item = 126, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 85, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- maos
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 99, texture = 1, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 81, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 6, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 258, texture = 1, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["2"] = {
			["homem"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 42, texture = 1, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 76, texture = 6, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 23, texture = 3, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = 126, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 88, texture = 1, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 50, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 81, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 78, texture = 1, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 57, texture = 7, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 92, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["3"] = {
			["homem"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 20, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 42, texture = 1, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 27, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 24, texture = 12, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = 30, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 88, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 23, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 81, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 101, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 58, texture = 7, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = 96, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 92, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		},
		["4"] = {
			["homem"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 10, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 10, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 33, texture = 2, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 29, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = 127, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 4, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 6, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 6, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 40, texture = 2, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 57, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = 97, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 3, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		}
	},
	["Mechanic"] = {
		["1"] = {
			["homem"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["pants"] = { item = 4, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 81, texture = 2, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 90, texture = 1, defaultItem = 1, defaultTexture = 0 },
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 18, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["accessory"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = 10, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["arms"] = { item = 19, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["glass"] = { item = 5, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			},
			["mulher"] = {
				["hat"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }, -- chapeu
				["pants"] = { item = 4, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- calca
				["vest"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["bracelet"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
				["decals"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["mask"] = { item = 121, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["shoes"] = { item = 24, texture = 0, defaultItem = 1, defaultTexture = 0 },
				["t-shirt"] = { item = 54, texture = 0, defaultItem = 1, defaultTexture = 0 }, -- camisa
				["bag"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["torso2"] = { item = 73, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- jaqueta
				["accessory"] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
				["watch"] = { item = 5, texture = 3, defaultItem = -1, defaultTexture = 0 }, -- relogio
				["arms"] = { item = 31, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- maos
				["glass"] = { item = 12, texture = 0, defaultItem = 0, defaultTexture = 0 }, -- oculos
				["ear"] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 }
			}
		}
	}	
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("preset",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(args[1]) > 0 then
			if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				local model = vRPclient.getModelPlayer(source)
				if vRP.hasPermission(user_id,"Paramedic") and preset["Paramedic"][tostring(args[1])] then
					if model == "mp_m_freemode_01" then
						TriggerClientEvent("updateRoupas",source,preset["Paramedic"][tostring(args[1])]["homem"])
					elseif model == "mp_f_freemode_01" then
						TriggerClientEvent("updateRoupas",source,preset["Paramedic"][tostring(args[1])]["mulher"])
					end
				elseif vRP.hasPermission(user_id,"Police") and preset["Police"][tostring(args[1])] then
					if model == "mp_m_freemode_01" then
						TriggerClientEvent("updateRoupas",source,preset["Police"][tostring(args[1])]["homem"])
					elseif model == "mp_f_freemode_01" then
						TriggerClientEvent("updateRoupas",source,preset["Police"][tostring(args[1])]["mulher"])
					end
				elseif vRP.hasPermission(user_id,"Mechanic") and preset["Mechanic"][tostring(args[1])] then
					if model == "mp_m_freemode_01" then
						TriggerClientEvent("updateRoupas",source,preset["Mechanic"][tostring(args[1])]["homem"])
					elseif model == "mp_f_freemode_01" then
						TriggerClientEvent("updateRoupas",source,preset["Mechanic"][tostring(args[1])]["mulher"])
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("outfit",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
			if args[1] then
				if args[1] == "save" then
					local custom = vSKINSHOP.getCustomization(source)
					if custom then
						vRP.setSData("saveClothes:"..parseInt(user_id),json.encode(custom))
						TriggerClientEvent("Notify",source,"verde","Outfit salvo com sucesso.",3000)
					end
				end
			else
				local consult = vRP.getSData("saveClothes:"..parseInt(user_id))
				local result = json.decode(consult)
				if result then
					TriggerClientEvent("updateRoupas",source,result)
					TriggerClientEvent("Notify",source,"verde","Outfit aplicado com sucesso.",3000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("premiumfit",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) and vRP.getPremium(user_id) then
			if args[1] then
				if args[1] == "save" then
					local custom = vSKINSHOP.getCustomization(source)
					if custom then
						vRP.setSData("premClothes:"..parseInt(user_id),json.encode(custom))
						TriggerClientEvent("Notify",source,"verde","Premiumfit salvo com sucesso.",3000)
					end
				end
			else
				local consult = vRP.getSData("premClothes:"..parseInt(user_id))
				local result = json.decode(consult)
				if result then
					TriggerClientEvent("updateRoupas",source,result)
					TriggerClientEvent("Notify",source,"verde","Premiumfit aplicado com sucesso.",3000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETREPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("repouso",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"Paramedic") then
		local nplayer = vRPclient.nearestPlayer(source,2)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local identity = vRP.getUserIdentity(parseInt(nuser_id))
				if vRP.request(source,"Deseja aplicar <b>"..parseInt(args[1]).." minutos</b>.",30) then
					vRP.reposeTimer(nuser_id,parseInt(args[1]))
					TriggerClientEvent("Notify",source,"verde","Você aplicou <b>"..parseInt(args[1]).." minutos</b> de repouso.",10000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WALKING
-----------------------------------------------------------------------------------------------------------------------------------------
local walking = {
	{ "move_m@alien" },
	{ "anim_group_move_ballistic" },
	{ "move_f@arrogant@a" },
	{ "move_m@brave" },
	{ "move_m@casual@a" },
	{ "move_m@casual@b" },
	{ "move_m@casual@c" },
	{ "move_m@casual@d" },
	{ "move_m@casual@e" },
	{ "move_m@casual@f" },
	{ "move_f@chichi" },
	{ "move_m@confident" },
	{ "move_m@business@a" },
	{ "move_m@business@b" },
	{ "move_m@business@c" },
	{ "move_m@drunk@a" },
	{ "move_m@drunk@slightlydrunk" },
	{ "move_m@buzzed" },
	{ "move_m@drunk@verydrunk" },
	{ "move_f@femme@" },
	{ "move_characters@franklin@fire" },
	{ "move_characters@michael@fire" },
	{ "move_m@fire" },
	{ "move_f@flee@a" },
	{ "move_p_m_one" },
	{ "move_m@gangster@generic" },
	{ "move_m@gangster@ng" },
	{ "move_m@gangster@var_e" },
	{ "move_m@gangster@var_f" },
	{ "move_m@gangster@var_i" },
	{ "anim@move_m@grooving@" },
	{ "move_f@heels@c" },
	{ "move_m@hipster@a" },
	{ "move_m@hobo@a" },
	{ "move_f@hurry@a" },
	{ "move_p_m_zero_janitor" },
	{ "move_p_m_zero_slow" },
	{ "move_m@jog@" },
	{ "anim_group_move_lemar_alley" },
	{ "move_heist_lester" },
	{ "move_f@maneater" },
	{ "move_m@money" },
	{ "move_m@posh@" },
	{ "move_f@posh@" },
	{ "move_m@quick" },
	{ "female_fast_runner" },
	{ "move_m@sad@a" },
	{ "move_m@sassy" },
	{ "move_f@sassy" },
	{ "move_f@scared" },
	{ "move_f@sexy@a" },
	{ "move_m@shadyped@a" },
	{ "move_characters@jimmy@slow@" },
	{ "move_m@swagger" },
	{ "move_m@tough_guy@" },
	{ "move_f@tough_guy@" },
	{ "move_p_m_two" },
	{ "move_m@bag" },
	{ "move_m@injured" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANDAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("andar",function(source,args,rawCommand)
	if args[1] then
		if not vCLIENT.getHandcuff(source) then
			vCLIENT.movementClip(source,walking[parseInt(args[1])][1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FATURAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fatura",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local nuser_id = vRP.prompt(source,"Passaporte:","")
		if nuser_id == "" or parseInt(nuser_id) <= 0 then
			return
		end

		local price = vRP.prompt(source,"Valor:","")
		if price == "" or parseInt(price) <= 0 then
			return
		end

		local reason = vRP.prompt(source,"Motivo:","")
		if reason == "" then
			return
		end

		local nplayer = vRP.getUserSource(parseInt(nuser_id))
		if nplayer then
			local identity = vRP.getUserIdentity(user_id)
			local answered = vRP.request(nplayer,"Deseja aceitar a fatura no valor de <b>$"..vRP.format(parseInt(price)).." dólares</b>?",30)
			if answered then
				vRP.setInvoice(parseInt(nuser_id),parseInt(price),parseInt(user_id),tostring(reason))
				TriggerClientEvent("Notify",source,"verde","Fatura aceita com sucesso.",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho","Fatura rejeitada pelo cliente.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("extras",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if (vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Paramedic")) and parseInt(args[1]) > 0 then
			vCLIENT.toggleLivery(source,parseInt(args[1]))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("add",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(args[2]) > 0 then
			if args[1] == "Policia" then
				if vRP.hasPermission(user_id,"PolMaster") then
					vRP.execute("vRP/cle_group",{ user_id = parseInt(args[2]) })
					vRP.execute("vRP/add_group",{ user_id = parseInt(args[2]), permiss = tostring("waitPolice") })
					vRP.insertPermission(parseInt(args[2]),tostring("waitPolice"))
					TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..vRP.format(parseInt(args[2])).."</b> adicionado com sucesso.",5000)
				end
			end

			if args[1] == "Mecanico" then
				if vRP.hasPermission(user_id,"MecMaster") then
					vRP.execute("vRP/cle_group",{ user_id = parseInt(args[2]) })
					vRP.execute("vRP/add_group",{ user_id = parseInt(args[2]), permiss = tostring("Mechanic") })
					vRP.insertPermission(parseInt(args[2]),tostring("Mechanic"))
					TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..vRP.format(parseInt(args[2])).."</b> adicionado com sucesso.",5000)
				end
			end

			if args[1] == "Paramedico" then
				if vRP.hasPermission(user_id,"ParMaster") then
					vRP.execute("vRP/cle_group",{ user_id = parseInt(args[2]) })
					vRP.execute("vRP/add_group",{ user_id = parseInt(args[2]), permiss = tostring("waitParamedic") })
					vRP.insertPermission(parseInt(args[2]),tostring("waitParamedic"))
					TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..vRP.format(parseInt(args[2])).."</b> adicionado com sucesso.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rem",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(args[1]) > 0 then
			if vRP.hasPermission(user_id,"PolMaster") or vRP.hasPermission(user_id,"MecMaster") or vRP.hasPermission(user_id,"ParMaster") then
				vRP.execute("vRP/cle_group",{ user_id = parseInt(args[1]) })
				TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..vRP.format(parseInt(args[1])).."</b> removido com sucesso.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("sequestro",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
			TriggerClientEvent("vrp_player:EnterTrunk",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("checktrunk",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 and not vRPclient.inVehicle(source) and not vCLIENT.getHandcuff(source) then
			local nplayer = vRPclient.nearestPlayer(source,2)
			if nplayer then
				TriggerClientEvent("vrp_player:CheckTrunk",nplayer)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("p",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
			TriggerClientEvent("vrp_player:SeatPlayer",source,args[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONDUTY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("trabalhando",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
			if vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Paramedic") or vRP.hasPermission(user_id,"Mechanic") or vRP.hasPermission(user_id,"Taxi") then
				local onDuty = ""
				local service = {}

				if vRP.hasPermission(user_id,"Police") then
					service = vRP.numPermission("Police")
				elseif vRP.hasPermission(user_id,"Paramedic") then
					service = vRP.numPermission("Paramedic")
				elseif vRP.hasPermission(user_id,"Mechanic") then
					service = vRP.numPermission("Mechanic")
				elseif vRP.hasPermission(user_id,"Taxi") then
					service = vRP.numPermission("Taxi")
				end

				for k,v in pairs(service) do
					local nuser_id = vRP.getUserId(v)
					local identity = vRP.getUserIdentity(nuser_id)

					onDuty = onDuty.."<b>Passaporte:</b> "..vRP.format(parseInt(nuser_id)).."   -   <b>Nome:</b> "..identity.name.." "..identity.name2.."<br>"
				end

				TriggerClientEvent("Notify",source,"roxo",onDuty,30000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cam",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 and vRP.hasPermission(user_id,"Police") then
			TriggerClientEvent("vrp_player:serviceCamera",source,tostring(args[1]))
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- KITAR E AUTOMATICAMENTE BATER PONTO!
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
    if vRP.hasPermission(user_id, "Police") then
        vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "Police" })
        vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "waitPolice" })
        vRP.removePermission(source, "Police")
    elseif vRP.hasPermission(user_id, "Paramedic") then
        vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "Paramedic" })
        vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "waitParamedic" })
        vRP.removePermission(source, "Paramedic")
    elseif vRP.hasPermission(user_id, "Mechanic") then
        vRP.execute("vRP/del_group",{ user_id = user_id, permiss = "Mechanic" })
        vRP.execute("vRP/add_group",{ user_id = user_id, permiss = "waitMechanic" })
        vRP.removePermission(source, "Mechanic")
    end
end)