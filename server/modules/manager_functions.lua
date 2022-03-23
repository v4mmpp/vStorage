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
    for _,v in pairs(vStorageServer_societyStorages) do
        if (v.society == player.getJob().name) then
            if (v.name == itemName) then
                itemExists = (true);
            end
        end
    end
    callback(itemExists);
end

---@public
---@type function doesSocietyItemHaveMoreThanOne
function vStorageServer_functions:doesSocietyItemHaveMoreThanOne(itemName, callback)
    local player = ESX.GetPlayerFromId(source)
    local itemHaveMoreThanOne = false;
    for _,v in pairs(vStorageServer_societyStorages) do
        if (v.society == player.getJob().name) then
            if (v.name == itemName) then
                if (v.count > 1) then
                    itemHaveMoreThanOne = (true);
                end
            end
        end
    end
    callback(itemHaveMoreThanOne);
end

---@public
---@type function addSocietyItem
---@param itemData table
function vStorageServer_functions:addSocietyItem(itemData)
    local player = ESX.GetPlayerFromId(source)
    local canRefresh = false;
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
                            canRefresh = true;
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
                canRefresh = true;
            end

            if (canRefresh) then
                TriggerClientEvent("_vStorage:getSocietyStoragesFromServer", -1, vStorageServer_societyStorages);
            end
        end)
    end
end

---@public
---@type function removeSocietyItem
---@param itemData table
function vStorageServer_functions:removeSocietyItem(itemData)
    local player = ESX.GetPlayerFromId(source)
    local canRefresh = false;
    if (itemData.wantedCount > 0) then
        vStorageServer_functions:doesSocietyItemHaveMoreThanOne(itemData.name, function(itemHaveMoreThanOne)
            if (itemHaveMoreThanOne) then
                for _, storage in pairs(vStorageServer_societyStorages) do
                    if (storage.society == player.getJob().name) then
                        if (storage.name == itemData.name) then
                            player.addInventoryItem(itemData.name, itemData.wantedCount);
                            storage.count = (vStorageShared_utilities.Math_Round( storage.count - itemData.wantedCount ));

                            MySQL.Async.fetchAll("UPDATE society_storages SET count=@count WHERE name=@name AND society=@society", {
                                ["@name"] = itemData.name,
                                ["@society"] = player.getJob().name,
                                ["@count"] = storage.count;
                            })
                            canRefresh = true;
                        end
                    end
                end
            else
                player.addInventoryItem(itemData.name, itemData.wantedCount);
                for _key, storage in pairs(vStorageServer_societyStorages) do
                    if (storage.society == player.getJob().name) then
                        if (storage.name == itemData.name) then
                            table.remove(vStorageServer_societyStorages, (_key));
                        end
                    end
                end

                MySQL.Async.execute("DELETE FROM society_storages WHERE society=@society AND name=@name", {
                    ["@society"] = player.getJob().name,
                    ["@name"] = itemData.name;
                })
                canRefresh = true;
            end

            if (canRefresh) then
                TriggerClientEvent("_vStorage:getSocietyStoragesFromServer", -1, vStorageServer_societyStorages);
            end
        end)
    end
end