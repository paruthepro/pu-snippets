Config.LockpickItems = {'advancedlockpick'} -- Items needed for players to "lockpick" the handcuffs and free their friends
Config.ImpoundFee = 500 -- Impound Fee for release of the vehicle by the owner (Default = 500)
-- These options go in your policejob config file
RegisterNetEvent("police:client:impounded", function()
    local source = QBCore.Functions.GetPlayer(source)
    if Config.ImpoundFee == nil then
        TriggerClientEvent("police:client:ImpoundVehicle", source, false, 500)
    elseif Config.ImpoundFee > nil then
    TriggerClientEvent("police:client:ImpoundVehicle", source, false, Config.ImpoundFee)
    end
end)

RegisterNetEvent("police:client:breakout", function()
    local chance = math.random(1, 100)
    local player = QBCore.Functions.GetPlayer(source)
    local playerId = GetPlayerServerId(player)
    local CuffedPlayer = QBCore.Functions.GetPlayer(playerId)
    exports['ps-ui']:Circle(function(success)
        if success then
            TriggerServerEvent("police:server:SetHandcuffStatus", CuffedPlayer, false)
            if chance <= 50 then
                exports.ox_inventory:RemoveItem(source, 'advancedlockpick', 1)
                QBCore.Functions.Notify("Lockpick broke!")
            else end
        else
            QBCore.Functions.Notify("You failed to help!")
        end
    end, math.random(1, 3), 30)
end)
local Cuffs = {
    {
        name = 'handcuff:player',
        event = 'police:client:CuffPlayerSoft',
        icon = 'fa-solid fa-handcuffs',
        label = 'Handcuff',
        distance = 2.0,
        items = {Config.HandCuffItem},
    }
}
local Uncuff = {
    { -- Lockpicks Player Cuffs
        name = 'uncuff:player',
        event = 'police:client:breakout',
        icon = 'fa-solid fa-handcuffs',
        label = 'Uncuff',
        items = Config.LockpickItem,
        distance = 2.0,
    },
    { -- Police Cuff removal
        name = 'uncuff:player',
        event = 'police:client:CuffPlayerSoft',
        icon = 'fa-solid fa-handcuffs',
        label = 'Uncuff',
        groups = Config.Policejobs,
        distance = 2.0,
    },
}
local CarOptions = {
    {
        name = 'vehicle:impound',
        event = 'police:client:impounded',
        icon = 'fa-sharp fa-solid fa-car-side',
        label = 'Impound Vehicle',
        groups = Config.Policejobs,
        distance = 2.0,
    },
}
    exports.ox_target:addGlobalPlayer(Cuffs)
    exports.ox_target:addGlobalVehicle(CarOptions)
    if PlayerId == exports["qb-policejob"]:IsHandcuffed() then
        exports.ox_target:removeGlobalPlayer(Cuffs)
        exports.ox_target:addGlobalPlayer(Uncuff)
    end
