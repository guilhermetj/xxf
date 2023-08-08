client_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'bodacious'
games { 'gta5' }

author ''
description ''
version ''

dependency "vrp"

client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua"
}

server_scripts{
	"@vrp/lib/utils.lua",
	"server.lua"
}

files {
	"cfg/config.lua",
  }              