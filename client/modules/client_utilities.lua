--[[
    This is a part of vStorage
    Copyright (©) 2022 - ${RevengeBack_}#4235
    All rights is reserved.
]]

vStorageClient_utilities = {
    createKeyboard = function(TextEntry, ExampleText, MaxStringLenght)
        AddTextEntry('FMMC_KEY_TIP1', TextEntry)
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
        blockinput = true

        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Citizen.Wait(0)
        end

        if UpdateOnscreenKeyboard() ~= 2 then
            local result = GetOnscreenKeyboardResult()
            Citizen.Wait(500)
            blockinput = false
            return result
        else
            Citizen.Wait(500)
            blockinput = false
            return nil
        end
    end,

    drawNotification = function(text, color)
        SetNotificationBackgroundColor(color)
        SetNotificationTextEntry('STRING')
        AddTextComponentSubstringPlayerName(text)
        DrawNotification(false, true)
    end,
};