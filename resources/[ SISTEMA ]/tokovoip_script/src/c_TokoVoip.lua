TokoVoip = {};
TokoVoip.__index = TokoVoip;
local lastTalkState = false

function TokoVoip.init(self, config)
	local self = setmetatable(config, TokoVoip);
	self.config = json.decode(json.encode(config));
	self.lastNetworkUpdate = 0;
	self.lastPlayerListUpdate = self.playerListRefreshRate;
	self.playerList = {};
	return (self);
end


function TokoVoip.loop(self)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(500)

			self:processFunction()
			self:sendDataToTS3()

			self.lastNetworkUpdate = self.lastNetworkUpdate + 500

			if self.lastNetworkUpdate >= 10000 then
				self.lastNetworkUpdate = 0
				self:updateTokoVoipInfo()
				self.playerList = GetActivePlayers();
			end
		end
	end)
end

function TokoVoip.sendDataToTS3(self) -- Send usersdata to the Javascript Websocket
	self:updatePlugin("updateTokoVoip", self.plugin_data);
end

function TokoVoip.updateTokoVoipInfo(self,forceUpdate)
	local info = self.mode

	if (info == self.screenInfo and not forceUpdate) then
		return
	end

	self.screenInfo = info
	self:updatePlugin("updateTokovoipInfo",info)
end

function TokoVoip.updatePlugin(self, event, payload)
	exports.tokovoip_script:doSendNuiMessage(event, payload);
end

function TokoVoip.updateConfig(self)
	local data = self.config;
	data.plugin_data = self.plugin_data;
	data.pluginVersion = self.pluginVersion;
	data.pluginStatus = self.pluginStatus;
	data.pluginUUID = self.pluginUUID;
	self:updatePlugin("updateConfig", data);
end

function TokoVoip.initialize(self)
	selfMode = self
	self:updateConfig()
	self:updatePlugin("initializeSocket",nil)
end

function TokoVoip.disconnect(self)
	self:updatePlugin("disconnect");
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- VOICEMODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("voiceMode",function(source,args)
	if not selfMode.mode then
		selfMode.mode = 2
	end

	selfMode.mode = selfMode.mode + 1

	if selfMode.mode > 3 then
		selfMode.mode = 1
	end

	TriggerEvent("hud:VoiceMode",selfMode.mode)
	setPlayerData(selfMode.serverId,"voip:mode",selfMode.mode,true)
	selfMode:updateTokoVoipInfo()
end)

RegisterKeyMapping("voiceMode","Modificar distância de voz.","keyboard","HOME")

-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function radioEnable()
	local ped = PlayerPedId()
	if not IsPedSwimming(ped) and not IsPlayerFreeAiming(PlayerId()) and selfMode["plugin_data"]["radioChannel"] ~= -1 then
		selfMode["plugin_data"]["radioTalking"] = true
		selfMode["plugin_data"]["localRadioClicks"] = true

		if selfMode["plugin_data"]["radioChannel"] > 1000 then
			selfMode["plugin_data"]["localRadioClicks"] = false
		end

		if not getPlayerData(selfMode["serverId"],"radio:talking") then
			setPlayerData(selfMode["serverId"],"radio:talking",true,true,false,selfMode["plugin_data"]["radioChannel"])
		end

		selfMode:updateTokoVoipInfo()

		if (not lastTalkState and selfMode["myChannels"][selfMode["plugin_data"]["radioChannel"]]) then
			if (not IsPedInAnyVehicle(ped) and selfMode["plugin_data"]["radioChannel"] < 1000) then
				RequestAnimDict("random@arrests")
				while not HasAnimDictLoaded("random@arrests") do
					Citizen.Wait(1)
				end

				TaskPlayAnim(ped,"random@arrests","generic_radio_chatter",8.0,0.0,-1,49,0,0,0,0)
			end

			lastTalkState = true

			while lastTalkState do
				DisableControlAction(1,24,true)
				DisableControlAction(1,25,true)
				DisableControlAction(1,257,true)
				DisableControlAction(1,140,true)
				DisableControlAction(1,142,true)

				Citizen.Wait(0)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIODISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function radioDisable()
	local ped = PlayerPedId()
	if selfMode["plugin_data"]["radioChannel"] ~= -1 then
		selfMode["plugin_data"]["radioTalking"] = false
		if getPlayerData(selfMode["serverId"],"radio:talking") then
			setPlayerData(selfMode["serverId"],"radio:talking",false,true,false,selfMode["plugin_data"]["radioChannel"])
		end

		selfMode:updateTokoVoipInfo()

		if lastTalkState then
			lastTalkState = false
			StopAnimTask(ped,"random@arrests","generic_radio_chatter",-4.0)
		end
	end
end

RegisterCommand("+talkRadio",radioEnable)
RegisterCommand("-talkRadio",radioDisable)
RegisterKeyMapping("+talkRadio","Comunicação no rádio.","keyboard","CAPITAL")