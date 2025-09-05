local QBCore = {}

function QBCore.Detect()
    local success, result = pcall(function()
        return GetResourceState('qb-core') == 'started'
    end)
    return success and result
end

function QBCore.GetPlayerData(source)
    local success, result = pcall(function()
        local core = exports['qb-core']:GetCoreObject()
        if core and core.Functions then
            local player = core.Functions.GetPlayer(source)
            if player and player.PlayerData then
                return player.PlayerData
            end
        end
        return nil
    end)

    if success then
        return result
    else
        return nil
    end
end

return QBCore