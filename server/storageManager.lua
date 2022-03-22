--[[
    This is a part of vStorage
    Copyright (©) 2022 - ${RevengeBack_}#4235
    All rights is reserved.
]]

local ESX = (exports["es_extended"]:getSharedObject() or nil);

---@public
---@class vStorageServer_societyStorages
vStorageServer_societyStorages = {};

CreateThread(function()
    if (not ESX) then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    loadSocietyStorages();
end)

---@public
---@type function loadSocietyStorages
function loadSocietyStorages()
    MySQL.Async.fetchAll("SELECT * FROM society_storages", {}, function(data)
        if (data) then
            vStorageServer_societyStorages = data;
        end
    end)
end

RegisterServerEvent("_vStorage:manageSocietyStorage")
AddEventHandler("_vStorage:manageSocietyStorage", function(itemData, addState)
    local _source = source
    local player = ESX.GetPlayerFromId(_source);
    if (player) then
        if (player.getJob().name ~= 'unemployed') then
            if (addState) then
                vStorageServer_functions:addSocietyItem(itemData);
            end
        else
            return;
        end
    end
end)