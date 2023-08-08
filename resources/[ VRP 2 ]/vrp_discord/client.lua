local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

emD = Tunnel.getInterface("vrp_discord")
----------------------------------------------------------------------------------------------------
--[ DISCORD ]---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
        SetDiscordAppId(858882838304784394)

	    local players = emD.discord()
		
	    SetDiscordRichPresenceAsset('logo')
		SetDiscordRichPresenceAssetText('B')
		SetRichPresence("https://discord.gg/Xg8cZhcPbT")
	    SetRichPresence("Jogadores conectados: "..players.." de 300")
		SetDiscordRichPresenceAction(0, "DISCORD", "https://discord.gg/Xg8cZhcPbT")
		SetDiscordRichPresenceAction(0, "VEM JOGAR", "connect 127.0.0")
		Citizen.Wait(10000)
	end
end)