fx_version 'cerulean'
game 'gta5'

author "!Jan1Ke2"
description "A Visum system that shows Visum Level and playtime"
version "1.0"


client_script 'client.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}