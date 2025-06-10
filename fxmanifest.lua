fx_version 'cerulean'
game 'gta5'

description 'Weather Anomaly Device - Cross Framework & Target Compatible'
author 'Smokey'
version '1.3.0'

shared_script '@ox_lib/init.lua'
shared_script 'config.lua'
shared_script 'utils.lua'
shared_script 'version_check.lua'

client_scripts { 'client.lua' }
server_script 'server.lua'

lua54 'yes'
