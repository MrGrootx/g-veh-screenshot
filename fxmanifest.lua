fx_version "cerulean"

description "test"
author "justgroot"
version '1.0.0'

lua54 'yes'

games {
  "gta5"
}

shared_scripts {
 -- '@ox_lib/init.lua',
  'shared/*.lua',
}


client_script "client/**/*"
server_script "server/**/*"

