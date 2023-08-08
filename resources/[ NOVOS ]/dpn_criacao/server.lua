vRP = module("vrp", "lib/Proxy").getInterface("vRP")
vRPclient = module("vrp", "lib/Tunnel").getInterface("vRP")
dPN = {}
module("vrp", "lib/Tunnel").bindInterface("dpn_criacao", dPN)
module("vrp", "lib/Proxy").addInterface("dpn_criacao", dPN)
dPNclient = module("vrp", "lib/Tunnel").getInterface("dpn_criacao")
local userlogin = {}

function SendWebhookMessage(a, b)
  a = a
  if a ~= nil and a ~= "" then
    PerformHttpRequest(a, function(a, b, c)
      a = a
    end, "POST", json.encode({content = b}), {
      ["Content-Type"] = "application/json"
    })
  end
end

RegisterServerEvent("dpn:playerSpawn")
AddEventHandler("dpn:playerSpawn",function(source,user_id)
  if user_id then
    local data = vRP.getUData(user_id,"spawnController")
    local sdata = json.decode(data) or 0
    if sdata then
      Citizen.Wait(1000)
      processSpawnController(source,sdata,user_id)
    end
end
end)
function processSpawnController(source,statusSent,user_id)
  print(user_id)
	if statusSent == 2 then
    if not userlogin[user_id] then
      userlogin[user_id] = true
      doSpawnPlayer(source,user_id,true)
    else
      doSpawnPlayer(source,user_id,false)
    end
  elseif statusSent == 1 or statusSent == 0 then
    userlogin[user_id] = true
    local data = vRP.getUserDataTable(user_id)
    if data then
      TriggerClientEvent('iniciarTelaCriacao',source)
    end
  end
end

function doSpawnPlayer(source,user_id,firstspawn)
	TriggerClientEvent("dpn:normalSpawn",source,firstspawn)
	TriggerEvent("vrp_barbershop:init",user_id)	
end

function dPN.updateFirstInformation(a, b, c, d)
  local source = source
  local user_id = vRP.getUserId(source)
  if vRP.getSteam(source) then
    -- vRP.execute("vRP/create_characters",{ steam = vRP.getSteam(source), name = a, name2 = b })
    vRP.execute("vRP/rename_characters",{ id = parseInt(user_id), name = a , name2 = b})
    print(user_id)
  end
end

function dPN.finalizarPersonagem(a)
  local source = source
  local user_id = vRP.getUserId(source)
  a = a
  if a then
    vRP.setUData(user_id, "currentCharacterMode", json.encode(a))
    vRP.setUData(user_id, "spawnController", json.encode(2))  
    doSpawnPlayer(source,user_id,true)
    TriggerClientEvent("hudActived",source,true)
    -- vRP.updateCustomization((vRPclient.getCustomization(source)))
  end
end
function dPN.resetPerson(a)
  a = a
  if a and vRP.getUserSource(a) and vRP.request(vRP.getUserSource(a), "Um admin deseja resetar seu personagem, voc\234 deseja proseguir?", 1000) then
    vRP.setUData(a, "currentCharacterMode", "")
    vRP.setUData(a, "spawnController", json.encode(1))
    dPNclient.createNewPerson((vRP.getUserSource(a)))
  end
end

function dPN.checkPermission()
  if vRP.hasPermission(vRP.getUserId(source), Config_server.permission) then
    return true
  else
    return false
  end
end
function dPN.giveItem()
  if vRP.getUserId(source) then
    giveItensCharacterFinish(source, (vRP.getUserId(source)))
  end
end
for fs = 1, 62 do
end
function TakeBestBucket()
  for fe = 1, TableLen(userlogin) do
    ValueLen = TableLen(userlogin[tostring(fe)])
    if ValueLen == 0 then
      return (tostring(fe))
    end
  end
  return {
    section = nil,
    quantity = nil,
    section = tostring(fe),
    quantity = ValueLen,
    quantity = ValueLen,
    section = tostring(fe)
  }
end
function InsertIdIntoBuckets(a, b)
  a = a
  userlogin[tostring(b)][a] = true
end
function RemoveIdFromAnyBuckets(a)
  a = a
  userlogin[tostring((GetBucketIdIsIn(a)))][a] = nil
  SetPlayerRoutingBucket(a, 0)
end
function GetBucketIdIsIn(a)
  a = a
  for fe, fg in pairs(userlogin) do
    if fg[a] then
      return fe
    end
  end
end
function TableLen(a)
  a = a
  for fg, fh in pairs(a) do
  end
  return 0 + 1
end
function SetIdIntoTheBestBucket(a)
  a = a
  InsertIdIntoBuckets(a, (TakeBestBucket()))
  SetPlayerRoutingBucket(a, tonumber((TakeBestBucket())))
end
function RemoveIdFromHisBucket(a)
  a = a
  if a then
  end
  RemoveIdFromAnyBuckets(a)
end
function SetBucket(a)
  a = a
  if a then
  end
  SetIdIntoTheBestBucket(a)
end
RegisterServerEvent("dope:session:on")
AddEventHandler("dope:session:on", function()

  local _source = source 
  SetPlayerRoutingBucket(_source, _source)
end)

RegisterServerEvent("dope:session:off")
AddEventHandler("dope:session:off", function()
  local _source = source 
  SetPlayerRoutingBucket(_source, 0)
end)


