Utils = {}

function Utils.GetFramework()
    if GetResourceState('qb-core') == 'started' then
        return 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx'
    elseif GetResourceState('qbox') == 'started' then
        return 'qbox'
    end
    return 'standalone'
end

function Utils.Notify(msg, type)
    if GetResourceState('ox_lib') == 'started' then
        lib.notify({ description = msg, type = type or 'inform' })
    elseif GetResourceState('qb-core') == 'started' then
        TriggerEvent('QBCore:Notify', msg, type or 'primary')
    elseif GetResourceState('es_extended') == 'started' then
        ESX.ShowNotification(msg)
    else
        print('NOTIFY: [' .. (type or 'info') .. '] ' .. msg)
    end
end

function Utils.AddInteractionZone(callback)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addSphereZone({
            coords = Config.DeviceLocation,
            radius = 2.0,
            options = {
                {
                    icon = 'fas fa-bolt',
                    label = 'Activate Weather Device',
                    onSelect = callback
                }
            }
        })
    elseif GetResourceState('qb-target') == 'started' then
        exports['qb-target']:AddBoxZone("weather_device", Config.DeviceLocation, 1.5, 1.5, {
            name = "weather_device",
            heading = Config.DeviceHeading,
            debugPoly = false,
            minZ = Config.DeviceLocation.z - 1.0,
            maxZ = Config.DeviceLocation.z + 1.0
        }, {
            options = {
                {
                    label = "Activate Weather Device",
                    icon = "fas fa-bolt",
                    action = callback
                }
            },
            distance = 2.0
        })
    elseif GetResourceState('e-interact') == 'started' then
        exports['e-interact']:AddInteraction({
            coords = Config.DeviceLocation,
            text = "Activate Weather Device",
            event = "weatheranomaly:interact",
            distance = 2.0
        })
    else
        CreateThread(function()
            while true do
                local coords = GetEntityCoords(PlayerPedId())
                if #(coords - Config.DeviceLocation) < 2.0 then
                    DrawText3D(Config.DeviceLocation + vector3(0, 0, 1.0), '[E] Activate Weather Device')
                    if IsControlJustPressed(0, 38) then
                        callback()
                    end
                end
                Wait(0)
            end
        end)
    end
end

function DrawText3D(pos, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(pos.x, pos.y, pos.z)
end
