-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cnVRP = {}
Tunnel.bindInterface("vrp_barbershop", cnVRP)
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
        vRP.setUData(user_id, "currentCharacterMode", json.encode(myClothes))
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("desbugar", function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if not vRPclient.inVehicle(source) then
            local x, y, z = vRPclient.getPositions(source)
            local data = vRP.getUserDataTable(user_id)
            if data then
                TriggerClientEvent("syncarea", -1, x, y, z, 2)
                vRPclient._setCustomization(source, data.customization)
                local value = vRP.getUData(user_id, "currentCharacterMode")
                if value ~= "" then
                    local custom = json.decode(value) or {}            
                    TriggerClientEvent("vrp_barbershop:setCustomization", player, custom)
                end
            end
        end
    end
end)

function Dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. Dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
  end

AddEventHandler("vrp_barbershop:init", function(user_id)
    local player = vRP.getUserSource(user_id)
    if player then
        local value = vRP.getUData(user_id, "currentCharacterMode")
        if value ~= "" then
            local custom = json.decode(value) or {}            
            TriggerClientEvent("vrp_barbershop:setCustomization", player, custom)
        end
    end
end)
