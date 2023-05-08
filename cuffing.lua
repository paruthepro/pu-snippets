RegisterNetEvent("police:client:impounded", function()
    TriggerClientEvent("police:client:ImpoundVehicle", false, Config.ImpoundFee)
end)

RegisterNetEvent("police:client:breakout", function()
    exports['ps-ui']:Circle(function(success)
        if success then
            TriggerServerEvent("police:server:SetHandcuffStatus", false)
        else
            QBCore.Functions.Notify("You failed to help!")
        end
    end, math.random(1, 3), 30)
end)

RegisterNetEvent("police:client:uncuffed", function()
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
end)

CreateThread(function()
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
            items = Config.LockpickItems,
            distance = 2.0,
        },
        { -- Police Cuff removal
            name = 'uncuff:player',
            event = 'police:client:uncuffed',
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
        {
            name = 'vehicle:depot',
            event = 'police:client:impounded',
            icon = 'fa-sharp fa-solid fa-car-side',
            label = 'Depot Vehicle',
            groups = Config.Policejobs,
            distance = 2.0,
        },
    }
    exports.ox_target:addGlobalPlayer(Cuffs)
    exports.ox_target:addGlobalVehicle(CarOptions)
    if exports["rrp-policejob"]:IsHandcuffed() then
        exports.ox_target:removeGlobalPlayer(Cuffs)
        exports.ox_target:addGlobalPlayer(Uncuff)
    end
end)