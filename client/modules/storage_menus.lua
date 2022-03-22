--[[
    This is a part of vStorage
    Copyright (©) 2022 - ${RevengeBack_}#4235
    All rights is reserved.
]]

local ESX = (exports["es_extended"]:getSharedObject() or nil);

RageUI = (RageUI);

---@public
---@class vStorageClient_menus
vStorageClient_menus = {};

---@public
---@type boolean isStorageMenuOpened
isStorageMenuOpened = false;

local menuSettings = { nil, nil, "zebilamouche", "zebilamouche" };
vStorageClient_menus.mainStorageMenu = RageUI.CreateMenu("Coffre", "MENU PRINCIPAL", table.unpack(menuSettings));
vStorageClient_menus.playerInventory = RageUI.CreateSubMenu(vStorageClient_menus.mainStorageMenu, "Coffre", "MENU INVENTAIRE", table.unpack(menuSettings));

CreateThread(function()
    if (not ESX) then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end

    ESX.PlayerData = ESX.GetPlayerData();
end)

---@public
---@type function openStorageMenu
function openStorageMenu()
    local doesContainsObject = true;
    Wait(30.0)
    
    if (isStorageMenuOpened) then
        isStorageMenuOpened = false;
        return (openStorageMenu());
    end

    CreateThread(function()
        isStorageMenuOpened = true;
        RageUI.Visible(vStorageClient_menus.mainStorageMenu, true);

        ESX.PlayerData = ESX.GetPlayerData();
        while (isStorageMenuOpened) do
            if (not ESX.PlayerData.job) then break end

            RageUI.IsVisible(vStorageClient_menus.mainStorageMenu, function()
                RageUI.Separator(("~b~→~s~ Societé: ~b~%s~s~"):format((ESX.PlayerData.job.label or "Introuvable")))
                RageUI.Button("Déposer objets", nil, {RightLabel = "→"}, true, {}, vStorageClient_menus.playerInventory)
            end)

            RageUI.IsVisible(vStorageClient_menus.playerInventory, function()
                if (ESX.PlayerData.inventory) then
                    for _,v in pairs(ESX.PlayerData.inventory) do
                        if (v.count > 0) then
                            doesContainsObject = true;
                            RageUI.Button(("%s - (~b~x%s~s~)"):format(v.label, v.count), nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {
                                onSelected = function()
                                    local wantedAmount = vStorageClient_utilities.createKeyboard(("Nombre d'objets a retirer (~r~%s max~s~):"):format(v.count), "", string.len(v.count));
                                    if (tonumber(wantedAmount) <= v.count and tonumber(wantedAmount) ~= 0 and wantedAmount ~= nil) then
                                        TriggerServerEvent("_vStorage:manageSocietyStorage", { name = v.name, label = v.label, wantedCount = tonumber(wantedAmount) }, true);
                                    end
                                end
                            })
                        end
                    end
                else
                    RageUI.Separator("~r~Un problème est survenu");
                end
            end)
            Wait(2.0)
        end
        
        isStorageMenuOpened = false;
    end)
end