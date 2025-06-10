local scriptName = 'weatheranomaly'
local repoOwner = 'Robg815'

local function fetchLatestVersion()
    PerformHttpRequest('https://api.github.com/repos/' .. repoOwner .. '/' .. scriptName .. '/releases/latest', function(statusCode, response)
        if statusCode == 200 then
            local release = json.decode(response)
            local latestVersion = release.tag_name
            local currentVersion = GetResourceMetadata(scriptName, 'version', 0)

            if currentVersion and latestVersion and currentVersion ~= latestVersion then
                print(('[%s] ^1Outdated version detected!^0 Latest: ^2%s^0 Current: ^3%s^0'):format(scriptName, latestVersion, currentVersion))
            end
        else
            print(('[%s] ^1Failed to fetch latest version.^0'):format(scriptName))
        end
    end, 'GET', '', { ['User-Agent'] = 'FiveM' })
end

Citizen.CreateThread(function()
    fetchLatestVersion()
end)
