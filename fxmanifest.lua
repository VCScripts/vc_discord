fx_version 'cerulean'
game 'gta5'

name 'vc_discord'
author 'Voci'
description 'Enhanced Discord Rich Presence for FiveM servers with real-time player activity and location tracking'
version '1.1.0'

server_scripts {
    'server/version_check.lua',
    'server/frameworks/qbox.lua',
    'server/frameworks/qbcore.lua',
    'server/frameworks/esx.lua',
    'server/framework_detection.lua'
}

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/client.lua'
}
