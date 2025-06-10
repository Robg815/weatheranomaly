Config = {}

Config.DeviceLocation = vector3(1691.5, 3240.6, 41.0)
Config.DeviceHeading = 25.0

Config.Cooldown = 300

Config.Anomalies = {
    { label = "Thunderstorm", weather = "THUNDER" },
    { label = "Fog Burst", weather = "FOGGY" },
    { label = "Radiation Storm", weather = "OVERCAST", effect = function()
        SetTimecycleModifier("NG_first")
        ShakeGameplayCam("DRUNK_SHAKE", 1.0)
    end }
}

Config.Security = {
    enabled = true,
    model = "s_m_m_security_01",
    weapon = "WEAPON_CARBINERIFLE",
    positions = {
        vector4(1695.5, 3243.8, 41.1, 120.0),
        vector4(1687.4, 3237.5, 41.1, 280.0)
    }
}
