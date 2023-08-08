-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("trucker",cRP)
vSERVER = Tunnel.getInterface("trucker")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT METHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
    local src = source
    local user_id = vRP.getUserId(src)
    local value = math.random(2300,4000)
    if user_id then
        vRP.giveInventoryItem(user_id,"dollars",value,true)
    end
end

local timer = {}


function cRP.sdka(timer2)
    local src = source
    local user_id = vRP.getUserId(src)
    timer[user_id] = timer2
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMER SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.timersevice()
    local src = source
    local user_id = vRP.getUserId(src)
    if timer[user_id] ~= nil then
        xtimer = timer[user_id]
        horas = 0
        minutos = 0
        segundos = 0
        if xtimer/3600 >= 1 then
            horas = (xtimer-(xtimer%3600))/3600
            xtimer = xtimer - (xtimer-(xtimer%3600) )
            if horas < 10 then
                horas = "0" .. tostring(horas)
            end
        end

        if xtimer/60 >= 1 then
            minutos = (xtimer-(xtimer%60))/60
            xtimer = xtimer - (xtimer-(xtimer%60) )
            if minutos < 10 then
                minutos = "0" .. tostring(minutos)
            end
        end

        segundos = xtimer

        if segundos < 10 then
            segundos = "0" .. tostring(segundos)
            
        end
        TriggerClientEvent("Notify",src,"vermelho","Aguarde <b>".. string.sub(horas, 1, 2) .. ":" .. string.sub(minutos, 1, 2) .. ":" .. string.sub(segundos, 1, 2),5000)
        return false
    else 
        return true
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------

    Citizen.CreateThread(function()
        while true do
                if timer[k] ~= nil then
                    timer[k] = timer[k] - 1
                    if time[k] <= 0 then
                        timer[k] = 0
                    end
                end
            Citizen.Wait(1000)
        end
    end)
