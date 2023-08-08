fx_version 'adamant'
game 'gta5'

dependencies 'vrp'

ui_page 'nui/ui.html'
files {
    'nui/ui.html',
    'nui/ui.css',
    'nui/ui.js',
    'nui/fonts/big_noodle_titling-webfont.woff',
    'nui/fonts/big_noodle_titling-webfont.woff2',
    'nui/fonts/pricedown.ttf',
    'mpheist3/shop_tattoo.meta',
    'mpheist3/mpheist3_overlays.xml',
    'mpvinewood/shop_tattoo.meta',
    'mpvinewood/mpvinewood_overlays.xml',
    'mpheist4/shop_tattoo.meta',
    'mpheist4/mpheist4_overlays.xml',
}
 
server_scripts{
    "@vrp/lib/utils.lua",
    "nyo_tattoo_cfg.lua",
    "nyo_tattoo_sv.lua"
}

client_script {
    "@vrp/lib/utils.lua",
    "nyo_tattoo_cl.lua"
}

data_file 'TATTOO_SHOP_DLC_FILE' 'mpheist3/shop_tattoo.meta'
data_file 'PED_OVERLAY_FILE' 'mpheist3/mpheist3_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'mpvinewood/shop_tattoo.meta'
data_file 'PED_OVERLAY_FILE' 'mpvinewood/mpvinewood_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'mpheist4/shop_tattoo.meta'
data_file 'PED_OVERLAY_FILE' 'mpheist4/mpheist4_overlays.xml'



