

-- this script puts certain large weapons on a player's back when it is not currently selected but still in there weapon wheel
-- by: minipunch
-- originally made for USA Realism RP (https://usarrp.net)

-- Add weapons to the 'compatable_weapon_hashes' table below to make them show up on a player's back (can use GetHashKey(...) if you don't know the hash) --

local usandoRoupasJohnJohn = false

local SETTINGS = {
  back_bone = 24818,
  x = 0.12,
  y = -0.15,
  z = -0.08,
  x_rotation = 180.0,
  y_rotation = 140.0,
  z_rotation = 0.0,
  compatable_weapon_hashes = {
    -- melee:
    --["prop_golf_iron_01"] = 1141786504, -- positioning still needs work
    ["w_me_bat"] = -1786099057,
    ["prop_ld_jerrycan_01"] = 883325847,
    -- assault rifles:
    ["w_ar_carbinerifle"] = -2084633992,
    --[[ ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_Mk2"), ]]
    ["w_ar_assaultrifle"] = -1074790547,
    ["w_ar_specialcarbine"] = -1063057011,
    ["w_ar_advancedrifle"] = -1357824103,
    -- sniper rifles:
    ["w_sr_sniperrifle"] = 100416529,
    -- shotguns:
    ["w_sg_assaultshotgun"] = -494615257,
    ["w_sg_bullpupshotgun"] = -1654528753,
    ["w_sg_pumpshotgun"] = 487013001,
    ["w_ar_musket"] = -1466123874,
    ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
    -- ["w_sg_sawnoff"] = 2017895192 don't show, maybe too small?
    -- launchers:
    ["w_lr_firework"] = 2138347493
  }
}

local attached_weapons = {}
local isInSafezone = false



Citizen.CreateThread(function()
while true do
    local me = PlayerPedId()
    ---------------------------------------
    -- attach if player has large weapon --
    ---------------------------------------

    for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
        if HasPedGotWeapon(me, wep_hash, false) and not isInSafezone and not podeUsar then
            if not attached_weapons[wep_name] then
                AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
            end
        end
    end
    --------------------------------------------
    -- remove from back if equipped / dropped --
    --------------------------------------------
    for name, attached_object in pairs(attached_weapons) do
        -- equipped? delete it from back:
        if (GetSelectedPedWeapon(me) == attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) or isInSafezone) or podeUsar then -- equipped or not in weapon wheel
          DeleteObject(attached_object.handle)
          attached_weapons[name] = nil
        end
    end
  Wait(1000)
end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
RequestModel(attachModel)
while not HasModelLoaded(attachModel) do
  Wait(100)
end

attached_weapons[attachModel] = {
  hash = modelHash,
  handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
}

if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end
AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
  if wep_name == "prop_golf_iron_01" then
      return true
  elseif wep_name == "w_me_bat" then
      return true
  elseif wep_name == "prop_ld_jerrycan_01" then
    return true
  else
      return false
  end
end

--[[ 
local fields = {
  { name = "Praça", edges = {
      { name = "1_1", x = 268.47964477539, y = -868.12677001953, z = 29.128894805908 },
      { name = "1_2", x = 200.52359008789, y = -1055.7015380859, z = 29.22047996521 },
      { name = "1_3", x = 113.17356872559, y = -1023.3862304688, z = 29.344791412354 },
      { name = "1_4", x = 180.10263061523, y = -835.65991210938, z = 31.095739364624},
    }
  },
  { name = "LojaJoalheria", edges = {
      { name = "1_1", x = -747.86, y = -315.25, z = 36.58 },
      { name = "1_2", x = -603.09, y = -354.36, z = 35.05 },
      { name = "1_3", x = -617.77, y = -467.83, z = 34.68 },
      { name = "1_4", x = -782.65, y = -439.17, z = 36.14},
    }
  },
  { name = "LojaBancoCentral", edges = {
      { name = "1_1", x = 92.1, y = -152.57, z = 58.26 },
      { name = "1_2", x = 61.49, y = -228.27, z = 51.19 },
      { name = "1_3", x = 192.76, y = -276.99, z = 48.96 },
      { name = "1_4", x = 223.48, y = -198.16, z = 53.99},
    }
  },
    { name = "Fabrica", edges = {  
      { name = "1_1", x = 3676.03, y = 3831.65, z = 43.4 },
      { name = "1_2", x = 3617.13, y = 3594.19, z = 47.56 },
      { name = "1_3", x = 3401.68, y = 3630.56, z = 52.09 },
      { name = "1_4", x = 3468.45, y = 3841.32, z = 35.28},
    }
  },
}

function isPointInTriangle(p, p0, p1, p2)
  local A = 1/2 * (-p1.y * p2.x + p0.y * (-p1.x + p2.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y)
  local sign = 1
  if A < 0 then sign = -1 end
  local s = (p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y) * sign
  local t = (p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y) * sign
  return s > 0 and t > 0 and (s + t) < 2 * A * sign
end

function runOnFieldTriangles(field, cb)
  local edges = field.edges
  local num = #edges - 2
  local c = 1
  repeat 
      cb(edges[1], edges[c+1], edges[c+2])
      c = c + 1
  until c > num
end

function isPointInField(p, field)
  local edges = field.edges
  local within = false
  runOnFieldTriangles(field, function(p0,p1,p2)
      if isPointInTriangle(p, p0, p1, p2) then within = true end
  end)
  return within
end

function GetAreaOfField(field)
  local edges = field.edges
  return math.floor(getAreaOfTriangle(edges[1], edges[2], edges[3]) + getAreaOfTriangle(edges[1], edges[4], edges[3]))
end

function getAreaOfTriangle(p0, p1, p2)
  local b = GetDistanceBetweenCoords(p0.x, p0.y, 0, p1.x, p1.y, 0)
  local h = GetDistanceBetweenCoords(p2.x, p2.y, 0, p1.x, p1.y, 0)
  return (b * h) / 2
end

function debugDrawFieldMarkers(field, r, g, b, a)
  local v = field
  runOnFieldTriangles(v, function(p0,p1,p2) 
      DrawLine(p0.x, p0.y, p0.z + 3.0,p1.x, p1.y, p1.z + 3.0,r or 255, g or 0, b or 0, a or 105)
      DrawLine(p2.x, p2.y, p2.z + 3.0,p1.x, p1.y, p1.z + 3.0,r or 255, g or 0, b or 0, a or 105)
      DrawLine(p2.x, p2.y, p2.z + 3.0,p0.x, p0.y, p0.z + 3.0,r or 255, g or 0, b or 0, a or 105)
  end)
end


Citizen.CreateThread(function()
while true do
  local sleep = 700
  local ply = PlayerPedId()
  local pos = GetEntityCoords(ply)
  if IsPedInAnyVehicle(ply) then
          pos = GetEntityCoords(GetVehiclePedIsIn(ply, false))
      end

        for k,v in next, fields do
          if (GetDistanceBetweenCoords(v.edges[1].x, v.edges[1].y,0,pos.x,pos.y,0) <= 500.0) or usandoRoupasJohnJohn then
              if (isPointInField(pos, v))  or usandoRoupasJohnJohn then
                  if IsEntityPlayingAnim(PlayerPedId(),"anim@mp_player_intupperfinger","idle_a_fp",3) then
                   ClearPedTasks(PlayerPedId())
                  end
                  sleep = 0
                  isInSafezone = true
                  ClearPlayerWantedLevel(PlayerId())
                  SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                  --NetworkSetFriendlyFireOption(false)
                  DisableControlAction(2, 37,  true)
                  DisableControlAction(1, 45,  true)
                  DisableControlAction(2, 80,  true)
                  DisableControlAction(2, 140, true)
                  DisableControlAction(2, 250, true) 
                  DisableControlAction(2, 263, true)
                  DisableControlAction(2, 310, true)
                  DisableControlAction(1, 140, true)
                  DisableControlAction(1, 141, true)
                  DisableControlAction(1, 142, true)
                  DisableControlAction(1, 143, true)
                  DisableControlAction(0, 24,  true) 
                  DisableControlAction(0, 25,  true)
          
                  DisablePlayerFiring(PlayerPedId(), true) 
                  DisableControlAction(0, 106, true) 
                  
              else
                  isInSafezone = false
                
                  break
              end
          end
      end

     

      Citizen.Wait(sleep)
  end
end)



Citizen.CreateThread(function()
  while true do
    local sleep = 1000
		-- DEDO DO MEIO (F3)
    local i = 0
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 then
      sleep = 5
      if IsControlJustPressed(0,170) then
        if not isInSafezone and not usandoRoupasJohnJohn then
					if IsEntityPlayingAnim(ped,"anim@mp_player_intupperfinger","idle_a_fp",3) then
            ClearPedTasks(PlayerPedId())
					else
            RequestAnimDict("anim@mp_player_intupperfinger")
						while not HasAnimDictLoaded("anim@mp_player_intupperfinger") and i < 1000 do
              Citizen.Wait(10)
              RequestAnimDict("anim@mp_player_intupperfinger")
              i = i + 1
            end
            TaskPlayAnim(ped,"anim@mp_player_intupperfinger","idle_a_fp",3.0,-3.0,-1,48,0,0,0,0)
					end
				end
			end
		end
    Citizen.Wait(sleep)
  end
end)


local user_id = 0
local podeUsarMathias = false

RegisterNetEvent("mathiasUrgencia")
AddEventHandler("mathiasUrgencia", function(_user_id2,bool2)
  user_id = _user_id2
  podeUsarMathias = bool2
end)

RegisterNetEvent("sendUserId")
AddEventHandler("sendUserId", function(_user_id)
  user_id = _user_id
end)

Citizen.CreateThread(function()
  TriggerServerEvent("getUserId")
end)



-- NADA ILEGAL UTILIZANDO A ROUPA
local podeUsar = false
local idsPermitidos = {2295,2291,2289,65,109,9,14,3,512,99,5,1,65,7,476,82,502,2157,2297,2298,2289,2291,2294} -- Ids que podem usar as roupas

local jaquetaM = {309,310,311,312,313,314,315} -- 11
local blusaM = {145} -- 8
local calcaM = {118,119,120,121,122,123,124} -- 4
local boneM = {} -- p0
local sapatosM = {9} -- 6

local jaquetaF = {355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370} -- 11
local blusaF = {191,192,193,194,195} -- 8
local calcaF = {128,129,130,131,132,133,134} -- 4
local boneF = {} -- p0
local sapatosF = {6,7} -- 6

local sexo = ""

local outfit = {}

local jaqueta,blusa,calca,bone,sapatos


Citizen.CreateThread(function()
  while true do
    local jaquetaNova = 0
    local blusaNova = 0
    local calcaNova = 0
    local boneNova = 0
    local sapatosNova = 0
    usandoRoupasJohnJohn = false
    local ped = PlayerPedId()
    local naoPodeUsar = false

    local pedModel = GetEntityModel(ped)
    podeUsar = false
    TriggerServerEvent("JJ:getUserCustomization")
    if pedModel == GetHashKey("mp_m_freemode_01") then
      sexo = "homem"
    elseif pedModel == GetHashKey("mp_f_freemode_01") then
      sexo = "mulher"
    end

    for k,v in pairs(outfit) do
      if not tonumber(v) then
        if tonumber(k) == 11 then
          jaqueta = json.encode(v[1])
        end
        if tonumber(k) == 8 then
          blusa = json.encode(v[1])
        end
        if tonumber(k) == 4 then
          calca = json.encode(v[1])
        end
        if tostring(k) == "p0" then
          bone = json.encode(v[1])
        end
        if tonumber(k) == 6 then
          sapatos = json.encode(v[1])
        end
      end
    end

    if sexo == "homem" then
      -- JAQUETA
      if jaqueta ~= 0 and podeUsar == false then
        for k,v in pairs(jaquetaM) do
          if tonumber(jaqueta) == tonumber(v) then
            usandoRoupasJohnJohn = true
            
            for m,t in pairs(idsPermitidos) do
              if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                jaquetaNova = -1
                podeUsar = false
              else
                podeUsar = true
                break
              end
            end
          end
        end
      end
      -- BLUSA
      if blusa ~= 0 and podeUsar == false then
        for k,v in pairs(blusaM) do
          if tonumber(blusa) == tonumber(v) then
            usandoRoupasJohnJohn = true
            
            for m,t in pairs(idsPermitidos) do
             if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                blusaNova = -1
                podeUsar = false
              else
                podeUsar = true
                
                break
              end
            end
          end
        end
      end
      -- CALCA
      if calca ~= 0 and podeUsar == false then
        for k,v in pairs(calcaM) do
          if tonumber(calca) == tonumber(v) then
            usandoRoupasJohnJohn = true
            
            for m,t in pairs(idsPermitidos) do
             if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                calcaNova = -1
                podeUsar = false
              else
                podeUsar = true
               
                break
              end
            end
          end
        end
      end
      -- BONE
      if bone ~= 0 and podeUsar == false then
        for k,v in pairs(boneM) do
          if tonumber(bone) == tonumber(v) then
            usandoRoupasJohnJohn = true
           
            for m,t in pairs(idsPermitidos) do
             if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                boneNova = -1
                podeUsar = false
              else
                podeUsar = true
                
                break
              end
            end
          end
        end
      end
      -- SAPATOS
      if sapatos ~= 0 and podeUsar == false then
        for k,v in pairs(sapatosM) do
          if tonumber(sapatos) == tonumber(v) then
            usandoRoupasJohnJohn = true
            
            for m,t in pairs(idsPermitidos) do
            if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                sapatosNova = -1
                podeUsar = false
              else
                podeUsar = true
                
                break
              end
            end
          end
        end
      end
    
    elseif sexo == "mulher" then
      -- JAQUETA
      if jaqueta ~= 0 and podeUsar == false then
        for k,v in pairs(jaquetaF) do
          if tonumber(jaqueta) == tonumber(v) then
            usandoRoupasJohnJohn = true
            
            for m,t in pairs(idsPermitidos) do
             if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                jaquetaNova = -1
                podeUsar = false
              else
                podeUsar = true
                
                break
              end
            end
          end
        end
      end
      -- BLUSA
      if blusa ~= 0 and podeUsar == false then
        for k,v in pairs(blusaF) do
          if tonumber(blusa) == tonumber(v) then
            usandoRoupasJohnJohn = true
            
            for m,t in pairs(idsPermitidos) do
            if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                blusaNova = -1
                podeUsar = false
              else
                podeUsar = true
               
                break
              end
            end
          end
        end
      end
      -- CALCA
      if calca ~= 0 and podeUsar == false then
        for k,v in pairs(calcaF) do
          if tonumber(calca) == tonumber(v) then
            usandoRoupasJohnJohn = true
            
            for m,t in pairs(idsPermitidos) do
             if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                calcaNova = -1
                podeUsar = false
              else
                podeUsar = true
                
                break
              end
            end
          end
        end
      end
      -- BONE
      if bone ~= 0 and podeUsar == false then
        for k,v in pairs(boneF) do
          if tonumber(bone) == tonumber(v) then
            usandoRoupasJohnJohn = true
            
            for m,t in pairs(idsPermitidos) do
             if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                boneNova = -1
                podeUsar = false
              else
                podeUsar = true
                break
              end
            end
          end
        end
      end
      -- SAPATOS
      if sapatos ~= 0 and podeUsar == false then
        for k,v in pairs(sapatosF) do
          if tonumber(sapatos) == tonumber(v) then
            usandoRoupasJohnJohn = true
           
            for m,t in pairs(idsPermitidos) do
             if (tonumber(user_id) == tonumber(t)) or podeUsarMathias then
                sapatosNova = -1
                podeUsar = false
              else
                podeUsar = true

                break
              end
            end
          end
        end
      end
      end 

      local ped = PlayerPedId()
      
      if podeUsar then
      elseif podeUsar == false and (jaquetaNova == -1 or calcaNova == -1 or blusaNova == -1 or boneNova == -1 or sapatosNova == -1) then
        
        if jaquetaNova == -1 then
          SetPedComponentVariation(ped,11,0,0,0)
          jaquetaNova = 0
        end
        if calcaNova == -1 then
          SetPedComponentVariation(ped,4,0,0,0)
          calcaNova = 0
        end
        if blusaNova == -1 then
          SetPedComponentVariation(ped,8,0,0,0)
          blusaNova = 0
        end
        if boneNova == -1 then
          ClearPedProp(ped,0)
          boneNova = 0
        end
        
        if sapatosNova == -1 then
          SetPedComponentVariation(ped,6,0,0,0)
          sapatosNova = 0
        end
    end
    Citizen.Wait(1500)
  end
end)

local proximoAoVeiculo = false

Citizen.CreateThread(function()
  while true do
    local vehicles = getNearestVehicles(25)
    for k,v in pairs(vehicles) do
      if GetEntityModel(v) == 1475773103 or GetEntityModel(v) == 904750859 then
        proximoAoVeiculo = true
      else
        proximoAoVeiculo = false
      end
    end
    local a = false
    for k,v in pairs(vehicles) do
      a = true
    end
    if not a then
      proximoAoVeiculo = false
    end
    Citizen.Wait(2000)
  end
end)

Citizen.CreateThread(function()
  while true do
    local ped = PlayerPedId()
    local sleep = 2000
    local vehicles = getNearestVehicles(25)
    if proximoAoVeiculo then
      if IsEntityPlayingAnim(ped,"anim@mp_player_intupperfinger","idle_a_fp",3) then
        ClearPedTasks(ped)
      end
      sleep = 0
      isInSafezone = true
      SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
      DisableControlAction(2, 37,  true)
      DisableControlAction(1, 45,  true)
      DisableControlAction(2, 80,  true)
      DisableControlAction(2, 140, true)
      DisableControlAction(2, 250, true) 
      DisableControlAction(2, 263, true)
      DisableControlAction(2, 310, true)
      DisableControlAction(1, 140, true)
      DisableControlAction(1, 141, true)
      DisableControlAction(1, 142, true)
      DisableControlAction(1, 143, true)
      DisableControlAction(0, 24,  true) 
      DisableControlAction(0, 25,  true)
      DisablePlayerFiring(ped, true) 
      DisableControlAction(0, 106, true) 
    else
      isInSafezone = false
    end
    Citizen.Wait(sleep)
  end
end)

function getNearestVehicles(radius)
	local r = {}
	local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId()))

	local vehs = {}
	local it,veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
	EndFindVehicle(it)

	for _,veh in pairs(vehs) do
		local x,y,z = table.unpack(GetEntityCoords(veh))
		local distance = Vdist(x,y,z,px,py,pz)
		if distance <= radius then
			r[veh] = veh
		end
	end
	return r
end ]]



local desbloqueado = true
-- USANDO ROUPA DA JJ
--[[ Citizen.CreateThread(function()
  while true do
  if podeUsar then
    TriggerEvent("JJ:usandoRoupas", true)
    desbloqueado = false
  elseif desbloqueado == false then
    TriggerEvent("JJ:usandoRoupas", false)
    desbloqueado = true
  end
  Citizen.Wait(3000)
end
end)

RegisterNetEvent("JJ:checaRoupasJJ")
AddEventHandler("JJ:checaRoupasJJ",function()
TriggerEvent("JJ:checaRoupasJJReturn",podeUsar)
end)

RegisterNetEvent("JJ:attCustomization")
AddEventHandler("JJ:attCustomization",function(custom)
outfit = custom
end) ]]
-- NADA ILEGAL UTILIZANDO A ROUPA 