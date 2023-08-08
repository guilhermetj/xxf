resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
    "@vrp/lib/utils.lua",
    'client/main.lua',
}

server_scripts {
    "@vrp/lib/utils.lua",
    'server/main.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/script.js',
    'html/plus.png',
    'html/qbus-logo.png'
}