local lastUsed = 0

RegisterServerEvent('weatheranomaly:tryTrigger')
AddEventHandler('weatheranomaly:tryTrigger', function()
    local src = source
    local now = os.time()

    if now - lastUsed < Config.Cooldown then
        local remaining = Config.Cooldown - (now - lastUsed)
        TriggerClientEvent('weatheranomaly:notifyCooldown', src, remaining)
        return
    end

    lastUsed = now

    local anomaly = Config.Anomalies[math.random(#Config.Anomalies)]
    TriggerClientEvent('weatheranomaly:startAnomaly', -1, anomaly, 60)
end)
