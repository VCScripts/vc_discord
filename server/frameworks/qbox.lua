local QBox = {}

function QBox.Detect()
    local success, result = pcall(function()
        if GetResourceState('qbx_core') == 'started' then
            if exports['qbx_core'] then
                return true
            end
        end
        return false
    end)
    return success and result
end

function QBox.GetPlayerData(source)
    local success, result = pcall(function()
        if exports['qbx_core'] then
            local player = exports['qbx_core']:GetPlayer(source)
            
            if player then
                if player.PlayerData then
                    if player.PlayerData.charinfo then
                        return player.PlayerData
                    end
                elseif player.charinfo then
                    return player
                end
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

return QBox