fx_version 'bodacious'
game 'gta5'


ui_page 'html/index.html'

files {
	'html/index.html',
	'html/static/css/app.css',
	'html/static/js/app.js',
	'html/static/js/manifest.js',
	'html/static/js/vendor.js',

	'html/static/config/config.json',
	
	-- Coque
	'html/static/img/coque/*.png',

	
	-- Background
	'html/static/img/background/*.jpg',
	
	'html/static/img/icons_app/*.png',
	
	'html/static/img/app_bank/*.png',
	'html/static/img/app_bank/*.png',

	'html/static/img/app_tchat/*.png',

	'html/static/img/twitter/*.png',
	'html/static/img/twitter/*.png',
	'html/static/sound/*.ogg',

	'html/static/img/*.png',
	'html/static/fonts/fontawesome-webfont.eot',
	'html/static/fonts/fontawesome-webfont.ttf',
	'html/static/fonts/fontawesome-webfont.woff',
	'html/static/fonts/fontawesome-webfont.woff2',

	'html/static/sound/ring.ogg',
	'html/static/sound/ring2.ogg',
	'html/static/sound/bella_ciao.ogg',
	'html/static/sound/casa_papel.ogg',
	'html/static/sound/iphone11.ogg',
	'html/static/sound/safaera.ogg',
	'html/static/sound/tusa.ogg',
	'html/static/sound/xtentacion.ogg',
	'html/static/sound/tchatNotification.ogg',
	'html/static/sound/Phone_Call_Sound_Effect.ogg',

}

client_script {
	"@vrp/lib/utils.lua",
	"config.lua",
	"client/animation.lua",
	"client/client.lua",

	"client/photo.lua",
	"client/app_tchat.lua",
	"client/bank.lua",
	"client/twitter.lua"
}

server_script {
	"@vrp/lib/utils.lua",
	'@mysql-async/lib/MySQL.lua',
	"config.lua",
	"server/server.lua",

	"server/app_tchat.lua",
	"server/twitter.lua"
}

--[e4vYCxZLgrfcyfPwSaS96ckauNj3KRftO]--