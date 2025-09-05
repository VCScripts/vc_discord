local Framework = {}
Framework.Name = nil
Framework.Handler = nil

local pcall = pcall

local function GetFrameworkConfig()
    local config = {}

    config.forcedFramework = GetConvar('vc_discord_framework', '')

    return config
end

function Framework.Detect()
    local config = GetFrameworkConfig()

    print("^3[Framework Detection] ^7Checking convar: vc_discord_framework = '" .. config.forcedFramework .. "'")

    if config.forcedFramework ~= '' then
        print("^3[Framework Detection] ^7Framework override detected: " .. config.forcedFramework)

        if config.forcedFramework == 'qbox' then
            local QBox = LoadResourceFile(GetCurrentResourceName(), 'server/frameworks/qbox.lua')
            if QBox then
                local func = load(QBox)
                if func then
                    local success, result = pcall(func)
                    if success and result and result.Detect() then
                        Framework.Name = "QBox (Forced)"
                        Framework.Handler = result
                        print("^2[Framework Detection] ^7QBox framework forced!")
                        return true
                    else
                        print("^1[Framework Detection] ^7QBox framework forced but detection failed")
                    end
                else
                    print("^1[Framework Detection] ^7QBox framework forced but function load failed")
                end
            else
                print("^1[Framework Detection] ^7QBox framework forced but file load failed")
            end
        elseif config.forcedFramework == 'qbcore' then
            local QBCore = LoadResourceFile(GetCurrentResourceName(), 'server/frameworks/qbcore.lua')
            if QBCore then
                local func = load(QBCore)
                if func then
                    local success, result = pcall(func)
                    if success and result and result.Detect() then
                        Framework.Name = "QBCore (Forced)"
                        Framework.Handler = result
                        print("^2[Framework Detection] ^7QBCore framework forced!")
                        return true
                    else
                        print("^1[Framework Detection] ^7QBCore framework forced but detection failed")
                    end
                else
                    print("^1[Framework Detection] ^7QBCore framework forced but function load failed")
                end
            else
                print("^1[Framework Detection] ^7QBCore framework forced but file load failed")
            end
        elseif config.forcedFramework == 'esx' then
            local ESX = LoadResourceFile(GetCurrentResourceName(), 'server/frameworks/esx.lua')
            if ESX then
                local func = load(ESX)
                if func then
                    local success, result = pcall(func)
                    if success and result and result.Detect() then
                        Framework.Name = "ESX (Forced)"
                        Framework.Handler = result
                        print("^2[Framework Detection] ^7ESX framework forced!")
                        return true
                    else
                        print("^1[Framework Detection] ^7ESX framework forced but detection failed")
                    end
                else
                    print("^1[Framework Detection] ^7ESX framework forced but function load failed")
                end
            else
                print("^1[Framework Detection] ^7ESX framework forced but file load failed")
            end
        end

        print("^1[Framework Detection] ^7Forced framework failed, stopping detection")
        return false
    end

    print("^3[Framework Detection] ^7No framework override, running automatic detection...")

    local QBox = LoadResourceFile(GetCurrentResourceName(), 'server/frameworks/qbox.lua')
    if QBox then
        local func = load(QBox)
        if func then
            local success, result = pcall(func)
            if success and result and result.Detect() then
                Framework.Name = "QBox"
                Framework.Handler = result
                print("^2[Framework Detection] ^7QBox framework detected!")
                return true
            end
        end
    end

    local QBCore = LoadResourceFile(GetCurrentResourceName(), 'server/frameworks/qbcore.lua')
    if QBCore then
        local func = load(QBCore)
        if func then
            local success, result = pcall(func)
            if success and result and result.Detect() then
                Framework.Name = "QBCore"
                Framework.Handler = result
                print("^2[Framework Detection] ^7QBCore framework detected!")
                return true
            end
        end
    end

    local ESX = LoadResourceFile(GetCurrentResourceName(), 'server/frameworks/esx.lua')
    if ESX then
        local func = load(ESX)
        if func then
            local success, result = pcall(func)
            if success and result and result.Detect() then
                Framework.Name = "ESX"
                Framework.Handler = result
                print("^2[Framework Detection] ^7ESX framework detected!")
                return true
            end
        end
    end

    print("^1[Framework Detection] ^7No supported framework detected!")
    return false
end

function Framework.GetPlayerData(source)
    if not Framework.Handler then
        return nil
    end
    return Framework.Handler.GetPlayerData(source)
end

RegisterNetEvent('vc_discord:getPlayerData')
AddEventHandler('vc_discord:getPlayerData', function()
    local source = source

    if not Framework.Handler then
        TriggerClientEvent('vc_discord:receivePlayerData', source, nil)
        return
    end

    local playerData = Framework.GetPlayerData(source)

    if Config and Config.showPlayerCount then
        local playerCount = #GetPlayers()
        local maxPlayers = GetConvarInt('sv_maxclients', Config.MaxPlayers)

        if not playerData then
            playerData = {}
        end

        playerData.playerCount = playerCount
        playerData.maxPlayers = maxPlayers
    end

    TriggerClientEvent('vc_discord:receivePlayerData', source, playerData)
end)

RegisterNetEvent('vc_discord:getPlayerCount')
AddEventHandler('vc_discord:getPlayerCount', function()
    local source = source

    if Config and Config.showPlayerCount then
        local playerCount = #GetPlayers()
        local maxPlayers = GetConvarInt('sv_maxclients', Config.MaxPlayers)

        TriggerClientEvent('vc_discord:receivePlayerCount', source, playerCount, maxPlayers)
    end
end)

CreateThread(function()
    Wait(1000)
    Framework.Detect()
end)

exports('GetFramework', function()
    return Framework
end)

return Framework