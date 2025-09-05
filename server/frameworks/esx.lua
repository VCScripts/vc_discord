local ESX = {}

function ESX.Detect()
    local success, result = pcall(function()
        return GetResourceState('es_extended') == 'started'
    end)
    return success and result
end

function ESX.GetPlayerData(source)
    local success, result = pcall(function()
        local ESXCore = exports['es_extended']:getSharedObject()
        if ESXCore then
            local player = ESXCore.GetPlayerFromId(source)
            if player then
                return {
                    charinfo = {
                        firstname = player.variables.firstName or player.getName(),
                        lastname = player.variables.lastName or ""
                    }
                }
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

return ESX