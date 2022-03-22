--[[
    This is a part of vStorage
    Copyright (©) 2022 - ${RevengeBack_}#4235
    All rights is reserved.
]]

RageUI = (RageUI);

---@public
---@class vStorageClient_menus
vStorageClient_menus = {};

---@public
---@type boolean isStorageMenuOpened
isStorageMenuOpened = false;

vStorageClient_menus.mainStorageMenu = RageUI.CreateMenu("Coffre", "MENU PRINCIPAL");

---@public
---@type function openStorageMenu
function vStorageClient_menus:openStorageMenu()
    if (isStorageMenuOpened) then
        isStorageMenuOpened = false;
        return (self:openStorageMenu());
    end

    CreateThread(function()
        isStorageMenuOpened = true;
        RageUI.Visible(vStorageClient_menus.mainStorageMenu); -- TODO → ADD A MENU

        while (isStorageMenuOpened) do


            Wait(2.0)
        end
        
        isStorageMenuOpened = false;
    end)
end