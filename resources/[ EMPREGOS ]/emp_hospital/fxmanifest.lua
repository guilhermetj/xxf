fx_version 'adamant'
game 'gta5'

client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}
client_script "c_gcninject.lua"
server_script "s_gcninject.lua"