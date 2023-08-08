-- NLCore = nil
-- TriggerEvent('NLCore:GetObject', function(obj) NLCore = obj end)

-- RegisterServerEvent('getMinimapPos')
-- AddEventHandler('getMinimapPos', function()
--     local src = source
--     local Player = NLCore.Functions.GetPlayer(src)
--     local cid = Player.PlayerData.citizenid

--     NLCore.Functions.ExecuteSql(true, "SELECT hudpos FROM `players` WHERE `citizenid` = '"..cid.."'", function(result)
--         if result ~= nil then
--             local pos = result[1].hudpos
--             if pos == 'left' then
--                 TriggerClientEvent('refreshMinimap', src, pos, 5000)
--                 TriggerClientEvent('NLCore:Notify', src, "Posição atual do minimapa é: " .. pos)
--             elseif pos == 'right' then
--                 TriggerClientEvent('refreshMinimap', src, pos, 5000)
--                 TriggerClientEvent('NLCore:Notify', src, "Posição atual do minimapa é: " .. pos)
--             end
--         else
-- 			return
-- 		end
-- 	end)
-- end)


-- RegisterServerEvent('updatePos')
-- AddEventHandler('updatePos', function(type) 

--     local src = source
-- 	local Player = NLCore.Functions.GetPlayer(src)
-- 	local citizenid = Player.PlayerData.citizenid

--     if Player ~= nil then
--         NLCore.Functions.ExecuteSql(true, "UPDATE `players` SET `hudpos` = '"..type.."'".." WHERE citizenid = '"..citizenid.."'")
-- 	end


-- end)