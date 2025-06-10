local guards = {}
local deviceUnlocked = false

CreateThread(function()
    spawnDevice()
    if Config.Security.enabled then spawnGuards() end

    Utils.AddInteractionZone(function()
        if not deviceUnlocked then
            Utils.Notify('Clear the security guards first!', 'error')
            return
        end
        TriggerServerEvent('weatheranomaly:tryTrigger')
    end)
end)

RegisterNetEvent('weatheranomaly:notifyCooldown', function(remaining)
    Utils.Notify('Device cooling down (' .. remaining .. 's)', 'error')
end)

RegisterNetEvent('weatheranomaly:startAnomaly', function(anomaly, duration)
    local ped = PlayerPedId()
    Utils.Notify(anomaly.label .. ' initiated!', 'inform')

    SetWeatherTypeNow(anomaly.weather)
    if anomaly.effect then anomaly.effect() end

    Wait(duration * 1000)

    ClearTimecycleModifier()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    ResetPedMovementClipset(ped, 0.0)

    Utils.Notify('Anomaly ended.', 'success')
end)

function spawnDevice()
    local model = `prop_laptop_01a`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local obj = CreateObject(model, Config.DeviceLocation.x, Config.DeviceLocation.y, Config.DeviceLocation.z - 1.0, false, false, false)
    SetEntityHeading(obj, Config.DeviceHeading)
    FreezeEntityPosition(obj, true)
end

function spawnGuards()
    local model = joaat(Config.Security.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    for _, pos in pairs(Config.Security.positions) do
        local ped = CreatePed(4, model, pos.xyz, pos.w, true, false)
        GiveWeaponToPed(ped, Config.Security.weapon, 200, false, true)
        SetPedArmour(ped, 100)
        SetPedAsEnemy(ped, true)
        TaskCombatHatedTargetsAroundPed(ped, 50.0)
        SetEntityAsMissionEntity(ped, true, true)
        table.insert(guards, ped)
    end

    CreateThread(function()
        while true do
            Wait(2000)
            local alive = 0
            for _, ped in pairs(guards) do
                if DoesEntityExist(ped) and not IsEntityDead(ped) then
                    alive = alive + 1
                end
            end
            if alive == 0 then
                deviceUnlocked = true
                Utils.Notify('Access to the device granted.', 'success')
                return
            end
        end
    end)
end
