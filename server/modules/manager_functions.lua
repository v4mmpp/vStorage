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
function vStorageServer_functions:doesSocietyHaveThisObject(itemName, callback)
    local player = ESX.GetPlayerFromId(source)
    local itemExists = false;
    MySQL.Async.fetchAll("SELECT 1 FROM society_storages WHERE society=@society AND name=@name", {
        ["@society"] = player.getJob().name,
        ["@name"] = itemName;
    }, function(receivedData)
        if (receivedData[1]) then
            itemExists = true
        end
        callback(itemExists);
    end)
end

---@public
---@type function addSocietyItem
---@param itemData table
function vStorageServer_functions:addSocietyItem(itemData)
    local player = ESX.GetPlayerFromId(source)
    if (itemData.wantedCount > 0) then
        vStorageServer_functions:doesSocietyHaveThisObject(itemData.name, function(itemExists)
            if (itemExists) then
                for _, storage in pairs(vStorageServer_societyStorages) do
                    if (storage.society == player.getJob().name) then
                        if (storage.name == itemData.name) then
                            player.removeInventoryItem(itemData.name, itemData.wantedCount);
                            storage.count = (vStorageShared_utilities.Math_Round( storage.count + itemData.wantedCount ));

                            MySQL.Async.fetchAll("UPDATE society_storages SET count=@count WHERE name=@name AND society=@society", {
                                ["@name"] = itemData.name,
                                ["@society"] = player.getJob().name,
                                ["@count"] = storage.count;
                            })
                        end
                    end
                end
            else
                player.removeInventoryItem(itemData.name, itemData.wantedCount);
                table.insert(vStorageServer_societyStorages, { 
                    society = player.getJob().name,
                    name = itemData.name,
                    label = itemData.label,
                    count = itemData.wantedCount;
                });

                MySQL.Async.execute("INSERT INTO society_storages (society, name, label, count) VALUES (@society, @name, @label, @count)", {
                    ["@society"] = player.getJob().name,
                    ["@name"] = itemData.name,
                    ["@label"] = itemData.label,
                    ["@count"] = itemData.wantedCount;
                })
            end
        end)
    end
end