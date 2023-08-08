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
Tunnel.bindInterface("DiamondBlackjack",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blackjackTables = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = false,
    [10] = false,
    [11] = false,
    [12] = false,
    [13] = false,
    [14] = false,
    [15] = false,
}

local blackjackGameInProgress = {}
local blackjackGameData = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRY TAKE CHIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function tryTakeChips(source,amount)
	local xPlayer = vRP.getUserId(source)
	local item = vRP.getInventoryItemAmount(xPlayer,'ficha')
    if item >= amount then
        if vRP.tryGetInventoryItem(xPlayer, 'ficha', amount, true) then
            return true
        end
    else 
        TriggerClientEvent('Notify', source, "vermelho", 'Você não tem fichas.',1000)
        return false
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVE CHIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function giveChips(source,amount)
	local xPlayer = vRP.getUserId(source)
    vRP.giveInventoryItem(xPlayer,'ficha', amount, true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER DROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('playerDropped', function (reason)
    local source = source
    for k,v in pairs(blackjackTables) do
        if v == source then
            blackjackTables[k] = false
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST BLACKJACK TABLE DATA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:requestBlackjackTableData")
AddEventHandler("Blackjack:requestBlackjackTableData", function()
    local source = source
    TriggerClientEvent("Blackjack:sendBlackjackTableData",source,blackjackTables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST SIT AT BLACKJACK TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:requestSitAtBlackjackTable")
AddEventHandler("Blackjack:requestSitAtBlackjackTable", function(chairId)
    local source = source

    if source ~= nil then
        for k,v in pairs(blackjackTables) do 
            if v == source then 
                blackjackTables[k] = false
                return
            end
        end
        blackjackTables[chairId] = source
        TriggerClientEvent("Blackjack:sendBlackjackTableData",-1,blackjackTables)
        TriggerClientEvent("Blackjack:sitAtBlackjackTable",source,chairId)
    else
        TriggerClientEvent("blackjack:notify",source,"Você não pode sentar na mesa.","vermelho",1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LEAVE BLACKJACK TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:leaveBlackjackTable")
AddEventHandler("Blackjack:leaveBlackjackTable", function(chairId)
    local source = source

    if source ~= nil then 
        for k,v in pairs(blackjackTables) do 
            if v == source then 
                blackjackTables[k] = false
            end
        end
        TriggerClientEvent("Blackjack:sendBlackjackTableData",-1,blackjackTables)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET BLACKJACK BET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:setBlackjackBet")
AddEventHandler("Blackjack:setBlackjackBet",function(gameId,betAmount,chairId)
    local source = source

    if gameId ~= nil and betAmount ~= nil and chairId ~= nil then 
        if blackjackGameData[gameId] == nil then
            blackjackGameData[gameId] = {}
        end
        if not blackjackGameInProgress[gameId] then
            if tonumber(betAmount) then
                if betAmount > 0 then
                    if tryTakeChips(source,betAmount) then
                        if blackjackGameData[gameId][source] == nil then
                            blackjackGameData[gameId][source] = {}
                        end
                        blackjackGameData[gameId][source][1] = betAmount
                        TriggerClientEvent("Blackjack:successBlackjackBet",source)
                        TriggerClientEvent("Blackjack:syncChipsPropBlackjack",-1,betAmount,chairId)
                    else 
                        TriggerClientEvent('Notify', source, "vermelho", 'Você não tem fichas suficientes.',1000)
                    end
                end
            end
        end
    else
        TriggerClientEvent("blackjack:notify",source,"Aposta não colocada!","vermelho",1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIT BLACKJACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:hitBlackjack")
AddEventHandler("Blackjack:hitBlackjack",function(gameId,nextCardCount)
    local source = source
    blackjackGameData[gameId][source][2][nextCardCount] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STAND BLACKJACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Blackjack:standBlackjack")
AddEventHandler("Blackjack:standBlackjack",function(gameId,nextCardCount)
    local source = source
    blackjackGameData[gameId][source][2][nextCardCount] = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
for i=0,3,1 do
    Citizen.CreateThread(function()
        math.randomseed(os.clock()*100000000000)
        while true do  --blackjack game management thread
            math.random() 
            math.random()
            math.random()
            local game_ready = false
            local players_ready = {}
            local tableId = i
            local chairIdInitial = i*4 --0-3,4-7,8-11,12-15
            local chairIdFinal = (i*4)+3
            for chairID=chairIdInitial,chairIdFinal do
                if blackjackTables[chairID] ~= false then   
                    table.insert(players_ready,blackjackTables[chairID])
                    game_ready = true
                end
            end
            if game_ready then
                local gameId = math.random(1000,10000000)
                blackjackGameData[gameId] = {} --init game data
                blackjackGameInProgress[gameId] = false
                for k,v in pairs(players_ready) do 
                    local source = v
                    blackjackGameData[gameId][v] = {}
                    if source ~= nil then 
                        TriggerClientEvent("Blackjack:beginBetsBlackjack",source,gameId,tableId)
                    end
                end
                Wait(21000)
                if blackjackGameData[gameId] ~= nil then
                    for k,v in pairs(blackjackGameData[gameId]) do
                        if v ~= nil then
                            local playerBetted = false 
                            betAmount = v[1]

                            if betAmount ~= nil and betAmount > 0 then 
                                playerBetted = true
                            end
                            if not playerBetted then
                                blackjackGameData[gameId][k] = nil
                            end
                        end
                    end
                    if not isTableEmpty(blackjackGameData[gameId]) then
                        blackjackGameInProgress[gameId] = true
                        for cardIndex=0,1,1 do
                            for chairID=chairIdInitial,chairIdFinal do
                                if blackjackTables[chairID] ~= false then
                                    local source = blackjackTables[chairID]
                                    if blackjackGameData[gameId] == nil then
                                        blackjackGameData[gameId] = {}
                                    end
                                    if blackjackGameData[gameId][source] == nil then
                                        blackjackGameData[gameId][source] = {}
                                    end
                                    if blackjackGameData[gameId][source][1] ~= nil then 
                                        if blackjackGameData[gameId][source][1] > 0 then     
                                            if blackjackGameData[gameId][source]["cardData"] == nil then 
                                                blackjackGameData[gameId][source]["cardData"] = {}
                                            end
                                            local randomCard = math.random(1,52)
                                            table.insert(blackjackGameData[gameId][source]["cardData"], randomCard)
                                            TriggerClientEvent("Blackjack:beginCardGiveOut",-1,gameId,blackjackGameData[gameId][source]["cardData"],chairID,cardIndex,getCurrentHand(gameId,source),tableId)
                                            Wait(3500)
                                        else 
                                            blackjackGameData[gameId][source] = nil
                                        end
                                    else 
                                        blackjackGameData[gameId][source] = nil
                                    end
                                end
                            end
                            if blackjackGameData[gameId]["dealer"] == nil then 
                                blackjackGameData[gameId]["dealer"] = {}
                            end
                            if blackjackGameData[gameId]["dealer"]["cardData"] == nil then 
                                blackjackGameData[gameId]["dealer"]["cardData"] = {}
                            end
                            if cardIndex == 0 then
                                local randomCard = math.random(1,52)
                                table.insert(blackjackGameData[gameId]["dealer"]["cardData"], randomCard) 
                                TriggerClientEvent("Blackjack:beginCardGiveOut",-1,gameId,blackjackGameData[gameId]["dealer"]["cardData"],gameId,cardIndex,getCurrentHand(gameId,"dealer"),tableId)
                            end
                            Wait(1500) 
                        end
                        for chairID=chairIdInitial,chairIdFinal do
                            if blackjackTables[chairID] ~= false then
                                local source = blackjackTables[chairID]
                                if blackjackGameData[gameId][source] ~= nil then 
                                    local nextCardCount = 1
                                    local currentHand = getCurrentHand(gameId,source)
                                    if currentHand < 21 then
                                        TriggerClientEvent("Blackjack:standOrHit",-1,gameId,chairID,nextCardCount,tableId)                            
                                        blackjackGameData[gameId][source][2] = {}
                                        while nextCardCount >= 1 do
                                            secondsWaited = 0
                                            while blackjackGameData[gameId][source][2][nextCardCount] == nil and secondsWaited < 20 do 
                                                Wait(100)
                                                secondsWaited = secondsWaited + 0.1
                                            end
                                            if blackjackGameData[gameId][source][2][nextCardCount] == true then --if hit 
                                                nextCardCount = nextCardCount + 1
                                                local randomCard = math.random(1,52)
                                                table.insert(blackjackGameData[gameId][source]["cardData"], randomCard)
                                                TriggerClientEvent("Blackjack:singleCard",-1,gameId,randomCard,chairID,nextCardCount,getCurrentHand(gameId,source),tableId) 
                                                Wait(2000)
                                                local currentHand = getCurrentHand(gameId,source)
                                                if currentHand > 21 then
                                                    TriggerClientEvent("Blackjack:bustBlackjack",-1,chairID,tableId)
                                                    nextCardCount = 0
                                                    blackjackGameData[gameId][source]["status"] = "bust"
                                                    local lostAmount = blackjackGameData[gameId][source][1]
                                                    TriggerClientEvent("blackjack:notify",source," - "..tostring(lostAmount).." fichas.","vermelho",2000)
                                                    if lostAmount > 10000000 then

                                                    end
                                                elseif currentHand < 21 then
                                                    TriggerClientEvent("Blackjack:standOrHit",-1,gameId,chairID,nextCardCount,tableId)  
                                                else
                                                    nextCardCount = 0
                                                    blackjackGameData[gameId][source]["status"] = "stand"
                                                end
                                            elseif blackjackGameData[gameId][source][2][nextCardCount] == false then --if stand
                                                nextCardCount = 0
                                                blackjackGameData[gameId][source]["status"] = "stand"
                                            else 
                                                nextCardCount = 0
                                                blackjackGameData[gameId][source]["status"] = "stand"
                                            end
                                        end
                                    else 
                                        blackjackGameData[gameId][source]["status"] = "stand"
                                    end
                                end
                                TriggerClientEvent("Blackjack:endStandOrHitPhase",-1,chairID,tableId) 
                            end
                        end
                        local randomCard = math.random(1,52)
                        table.insert(blackjackGameData[gameId]["dealer"]["cardData"], randomCard) 
                        TriggerClientEvent("Blackjack:beginCardGiveOut",-1,gameId,blackjackGameData[gameId]["dealer"]["cardData"],gameId,1,getCurrentHand(gameId,"dealer"),tableId)
                        Wait(2800)
                        dealerHand = getCurrentHand(gameId,"dealer")
                        TriggerClientEvent("Blackjack:flipDealerCard",-1,dealerHand,tableId,gameId)
                        Wait(2800)
                        local allPlayersHaveBusted = true
                        for k,v in pairs(blackjackGameData[gameId]) do 
                            local betStatus = v["status"]
                            if betStatus ~= nil then 
                                if betStatus == "stand" then 
                                    allPlayersHaveBusted = false
                                end
                            end
                        end
                        dealerHand = getCurrentHand(gameId,"dealer")
                        if not allPlayersHaveBusted then
                            if dealerHand >= 17 then
                            else
                                local nextCardCount = 2
                                local highestPlayerHand = 0
                                for k,v in pairs(blackjackGameData[gameId]) do 
                                    if k ~= "dealer" then 
                                        playerHand = getCurrentHand(gameId,k)
                                        if playerHand ~= nil then
                                            if playerHand > highestPlayerHand and playerHand <= 21 then
                                                highestPlayerHand = playerHand
                                            end
                                        end
                                    end
                                end
                                if highestPlayerHand < dealerHand then
                                else
                                    while dealerHand < 17 do 
                                        local randomCard = math.random(1,52)
                                        table.insert(blackjackGameData[gameId]["dealer"]["cardData"], randomCard)
                                        TriggerClientEvent("Blackjack:singleDealerCard",-1,gameId,randomCard,nextCardCount,getCurrentHand(gameId,"dealer"),tableId)
                                        Wait(2800)
                                        nextCardCount = nextCardCount + 1
                                        dealerHand = getCurrentHand(gameId,"dealer")
                                    end
                                end
                            end
                        end
                        for k,v in pairs(blackjackGameData[gameId]) do
                            if k ~= "dealer" then
                                local source = k
                                if blackjackGameData[gameId][source] ~= nil then
                                    if blackjackGameData[gameId][source]["status"] ~= "bust" then 
                                        local currentHand = getCurrentHand(gameId,source)
                                        if currentHand ~= nil then
                                            if currentHand <= 21 then
                                                local potentialWinAmount = blackjackGameData[gameId][source][1] * 2.0
                                                local potentialPushAmount = blackjackGameData[gameId][source][1]
                                                local playerPing = GetPlayerPing(source)
                                                if dealerHand > 21 then
                                                    giveChips(source,potentialWinAmount)
                                                    if playerPing ~= nil then
                                                        if playerPing > 0 then
                                                            TriggerClientEvent("Blackjack:blackjackWin",source,tableId)
                                                        end
                                                    end
                                                    TriggerClientEvent("Blackjack:dealerBusts",-1,tableId) 
                                                elseif currentHand > dealerHand and currentHand <= 21 then
                                                    giveChips(source,potentialWinAmount)
                                                    if playerPing ~= nil then
                                                        if playerPing > 0 then
                                                            TriggerClientEvent("Blackjack:blackjackWin",source,tableId)
                                                        end
                                                    end
                                                elseif currentHand == dealerHand then
                                                    giveChips(source,potentialPushAmount)
                                                    if playerPing ~= nil then
                                                        if playerPing > 0 then
                                                            TriggerClientEvent("Blackjack:blackjackPush",source,tableId)
                                                        end
                                                    end
                                                else
                                                    if playerPing ~= nil then
                                                        if playerPing > 0 then
                                                            TriggerClientEvent("Blackjack:blackjackLose",source,tableId)
                                                            TriggerClientEvent("blackjack:notify",source," - "..tostring(potentialPushAmount).." fichas.","vermelho",1000)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        for chairID=chairIdInitial,chairIdFinal do
                            if blackjackTables[chairID] ~= false then
                                local source = blackjackTables[chairID]
                                if blackjackGameData[gameId][source] ~= nil then 
                                    TriggerClientEvent("Blackjack:chipsCleanup",-1,chairID,tableId) 
                                    TriggerClientEvent("Blackjack:chipsCleanup",-1,tostring(chairID).."chips",tableId)
                                    Wait(3500)
                                end
                            end
                        end
                        TriggerClientEvent("Blackjack:chipsCleanup",-1,gameId,tableId)
                        for chairID=chairIdInitial,chairIdFinal do
                            TriggerClientEvent("Blackjack:chipsCleanupNoAnim",-1,chairID,tableId) 
                            TriggerClientEvent("Blackjack:chipsCleanupNoAnim",-1,tostring(chairID).."chips",tableId)
                        end
                        blackjackGameInProgress[gameId] = false
                    else 
                    end
                else 
                end
            else 
                Wait(1000)
            end
            Wait(1000) --Check ever second if anyones sitting at the table
        end
    end)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CURRENT HAND
-----------------------------------------------------------------------------------------------------------------------------------------
function getCurrentHand(gameId,userId)
    if blackjackGameData[gameId][userId]["cardData"] ~= nil then 
        local hand = 0
        local numberOfAces = 0
        for k,v in pairs(blackjackGameData[gameId][userId]["cardData"]) do
            local nextCard = getCardNumberFromCardId(v)
            if nextCard == 11 then
                numberOfAces = numberOfAces + 1
            else
                hand = hand + nextCard
            end
        end
        for i=1,numberOfAces,1 do 
            if i == 1 then 
                if hand + 11 > 21 then
                    nextCard = 1
                else
                    nextCard = 11
                end
            else
                nextCard = 1
            end
            hand = hand + nextCard
        end
        return hand
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAR ID TO TABLE ID
-----------------------------------------------------------------------------------------------------------------------------------------
function chairIdToTableId(chairId)
    if chairId <= 3 then return 0 end 
    if chairId <= 7 then return 1 end 
    if chairId <= 11 then return 2 end 
    if chairId <= 15 then return 3 end  
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CARD NUMBER FROM CARD ID
-----------------------------------------------------------------------------------------------------------------------------------------
function getCardNumberFromCardId(cardId)
    if cardId == 1 then
        return 11
    elseif cardId == 2 then
        return 2
    elseif cardId == 3 then
        return 3
    elseif cardId == 4 then
        return 4
    elseif cardId == 5 then
        return 5
    elseif cardId == 6 then
        return 6
    elseif cardId == 7 then
        return 7
    elseif cardId == 8 then
        return 8
    elseif cardId == 9 then
        return 9
    elseif cardId == 10 then
        return 10
    elseif cardId == 11 then
        return 10
    elseif cardId == 12 then
        return 10
    elseif cardId == 13 then
        return 10
    elseif cardId == 14 then
        return 11
    elseif cardId == 15 then
        return 2
    elseif cardId == 16 then
        return 3
    elseif cardId == 17 then
        return 4        
    elseif cardId == 18 then
        return 5
    elseif cardId == 19 then
        return 6
    elseif cardId == 20  then
        return 7
    elseif cardId == 21 then
        return 8
    elseif cardId == 22 then
        return 9
    elseif cardId == 23 then
        return 10
    elseif cardId == 24 then
        return 10
    elseif cardId == 25 then
        return 10
    elseif cardId == 26 then
        return 10
    elseif cardId == 27 then
        return 11
    elseif cardId == 28 then
        return 2
    elseif cardId == 29 then
        return 3
    elseif cardId == 30 then
        return 4
    elseif cardId == 31 then
        return 5
    elseif cardId == 32 then
        return 6
    elseif cardId == 33 then
        return 7
    elseif cardId == 34 then
        return 8
    elseif cardId == 35 then
        return 9
    elseif cardId == 36 then
        return 10
    elseif cardId == 37 then
        return 10
    elseif cardId == 38 then
        return 10
    elseif cardId == 39 then
        return 10
    elseif cardId == 40 then
        return 11
    elseif cardId == 41 then
        return 2
    elseif cardId == 42 then
        return 3
    elseif cardId == 43 then
        return 4
    elseif cardId == 44 then
        return 5
    elseif cardId == 45 then
        return 6
    elseif cardId == 46 then
        return 7
    elseif cardId == 47 then
        return 8
    elseif cardId == 48 then
        return 9
    elseif cardId == 49 then
        return 10
    elseif cardId == 50 then
        return 10
    elseif cardId == 51 then
        return 10
    elseif cardId == 52 then
        return 10
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IS TABLE EMPYT
-----------------------------------------------------------------------------------------------------------------------------------------
function isTableEmpty(self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET MONEY STRING FORMATTED
-----------------------------------------------------------------------------------------------------------------------------------------
function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')

	int = int:reverse():gsub("(%d%d%d)", "%1,")
  
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DUMP 
-----------------------------------------------------------------------------------------------------------------------------------------
function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
