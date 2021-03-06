--[[
    This is a part of vStorage
    Copyright (©) 2022 - ${RevengeBack_}#4235
    All rights is reserved.
]]

fx_version('cerulean') games({ 'gta5' });

shared_script("common/*.lua");
server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/modules/*.lua",
    "server/*.lua",
});

client_scripts({
    "libraries/RageUI/RMenu.lua",
    "libraries/RageUI/menu/RageUI.lua",
    "libraries/RageUI/menu/Menu.lua",
    "libraries/RageUI/menu/MenuController.lua",
    "libraries/RageUI/components/*.lua",
    "libraries/RageUI/menu/elements/*.lua",
    "libraries/RageUI/menu/items/*.lua",
    "libraries/RageUI/menu/panels/*.lua",
    "libraries/RageUI/menu/windows/*.lua",

    "client/modules/*.lua",
    "client/*.lua",
});

export("openStorageMenu");