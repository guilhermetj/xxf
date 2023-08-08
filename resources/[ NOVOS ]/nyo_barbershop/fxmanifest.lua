fx_version 'bodacious'
game 'gta5'

author 'Nyo ! Nyo#6969'
description 'BarberShop com NUI By Nyo'
version '1.0.1'

ui_page 'nui/ui.html'


files {
    'nui/ui.html',
    'nui/ui.css',
    'nui/ui.js',
    'nui/fonts/big_noodle_titling-webfont.woff',
    'nui/fonts/big_noodle_titling-webfont.woff2',
    'nui/fonts/pricedown.ttf',
}

client_scripts {
	'@vrp/lib/utils.lua',
	'nyo_barbershop_cl.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'nyo_barbershop_sv.lua'
}

