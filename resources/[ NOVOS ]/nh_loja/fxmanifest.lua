fx_version 'adamant'
game 'gta5'

ui_page "nui/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"config_client.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config_server.lua",
	"server.lua"
}

files {
	"nui/*.*",
	"nui/font/*.*",
	"nui/cabelos/*.*",
	"nui/imagem/*.*",
	'nui/images/*',
    'nui/images/**/*',
    'nui/images/**/**/*',
}