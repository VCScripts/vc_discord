fx_version 'cerulean'
game 'gta5'

name 'vc_discord'
author 'Voci'
description 'Enhanced Discord Rich Presence for FiveM servers with real-time player activity and location tracking'
version '1.0.0'

dependencies {
    'qb-core'
}

server_scripts {
    'server/version_check.lua'
}

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/client.lua'
}
