--[[
    This is a part of vStorage
    Copyright (©) 2022 - ${RevengeBack_}#4235
    All rights is reserved.
]]

local ESX = (exports["es_extended"]:getSharedObject() or nil);

CreateThread(function()
    if (not ESX) then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

---@public
---@class vStorageServer_functions
vStorageServer_functions = {};

---@public
---@type function doesSocietyHaveThisObject
function vStorageServer_functions:doesSocietyHaveThisObject(itemName)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT (society, name, count) FROM society_storages WHERE society=@society", {
        ["@society"] = player.getJob();
    }, function(receivedData)
        if (receivedData[1]) then
            return (true);
        end
        return (false);
    end)
end

---@public
---@type function addSocietyItem
---@param itemData table
function vStorageServer_functions:addSocietyItem(itemData)
    if (itemData.wantedCount > 0) then
        if (vStorageServer_functions:doesSocietyHaveThisObject(itemData.name)) then
            print("Item exists")
        else
            print("item doesn't exists")
        end
    end
end