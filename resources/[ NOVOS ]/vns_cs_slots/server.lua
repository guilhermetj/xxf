local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")

vRPclient = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

func = {}
Tunnel.bindInterface("vns_cs_slots", func)

math.randomseed(os.clock()*100000000000)
math.randomseed(os.clock()*math.random())
math.randomseed(os.clock()*math.random())

local activeSlot = {}


RegisterNetEvent('server_remote:slots:taskSitDown')
AddEventHandler(
    'server_remote:slots:taskSitDown',
    function(k,index, chairData)
        local source = source
        local chairId = chairData.chairId

        if activeSlot[index] ~= nil then
            if activeSlot[index].used then
                --return r_showNotification(source, _U('chair_used'))
            else
				activeSlot[index].used = true
                TriggerClientEvent('client_callback:slots:taskSitDown', source, index, k, chairData)
            end
        else
			activeSlot[index] = {}
			activeSlot[index].used = true
            TriggerClientEvent('client_callback:slots:taskSitDown', source, index, k, chairData)
        end
    end
)


RegisterNetEvent('casino:slots:notUsing')
AddEventHandler(
	'casino:slots:notUsing',
	function(index)
		if activeSlot[index] ~= nil then
			activeSlot[index].used = false
		end
	end
)




RegisterNetEvent('casino:taskStartSlots')
AddEventHandler('casino:taskStartSlots',function(index, data)
	local xPlayer = vRP.getUserId(source)
	if vRP.getInventoryItemAmount(xPlayer,Config.ItemName) >= data.bet then
		if activeSlot[index] then
			vRP.tryGetInventoryItem(xPlayer,Config.ItemName,data.bet,true)
			local w = {a = math.random(1,16),b = math.random(1,16),c = math.random(1,16)}
			local random = math.random(1,100)
			if w.a == w.b and w.b == w.c and w.c == w.a then
				if random > 10 then
					local w = {a = w.a + 1,b = w.b,c = w.c + math.random(2,3)}
				end
			end

			
			local rnd1 = math.random(1,100)
			local rnd2 = math.random(1,100)
			local rnd3 = math.random(1,100)
			
			if Config.Offset then
				if rnd1 > 70 then w.a = w.a + 0.5 end
				if rnd2 > 70 then w.b = w.b + 0.5 end
				if rnd3 > 70 then w.c = w.c + 0.5 end
			end
			
			TriggerClientEvent('casino:slots:startSpin', source, index, w)
			activeSlot[index].win = w
		end
	end
end)



RegisterNetEvent('casino:slotsCheckWin')
AddEventHandler('casino:slotsCheckWin',function(index, data, dt)
	if activeSlot[index] then
		if activeSlot[index].win then
			if activeSlot[index].win.a == data.a
			and activeSlot[index].win.b == data.b
			and activeSlot[index].win.c == data.c then
				CheckForWin(activeSlot[index].win, dt)
			end
		end
	end
end)



function CheckForWin(w, data)
	local xPlayer = vRP.getUserId(source)
	local a = Config.Wins[w.a]
	local b = Config.Wins[w.b]
	local c = Config.Wins[w.c]
	local total = 0
	if a == b and b == c and a == c then
		if Config.Mult[a] then
			total = data.bet*Config.Mult[a]
		end		
	elseif a == b and b == a then
		total = data.bet*2
	elseif b == c and c == b then
		total = data.bet*1
	elseif b == '6' and c == '6' then
		total = data.bet*0
		
	--[[elseif a == '6' then
		total = data.bet*2
	elseif b == '6' then
		total = data.bet*2
	elseif c == '6' then
		total = data.bet*2]]--
	end 
	if total > 0 then
		TriggerClientEvent("Notify",source,"roxo","Você ganhou "..total.." de dinheiro",8000)
		---xPlayer.showNotification(_U('win')..' '..total..' '.._U('item'))
		vRP.giveInventoryItem(xPlayer,Config.ItemName,total)
	end
end