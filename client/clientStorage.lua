--[[
    This is a part of vStorage
    Copyright (©) 2022 - ${RevengeBack_}#4235
    All rights is reserved.
]]

---@public
---@class vStorageClient_societyStorages
vStorageClient_societyStorages = {  };

CreateThread(function()
    TriggerServerEvent("_vStorage:sendSocietyStoragesFromServer");
end)

RegisterNetEvent("_vStorage:getSocietyStoragesFromServer")
AddEventHandler("_vStorage:getSocietyStoragesFromServer", function(storages)
    vStorageClient_societyStorages = (storages or {});
end)