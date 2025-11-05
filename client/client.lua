local GetPlayerName = GetPlayerName
local GetPlayerServerId = GetPlayerServerId
local GetPlayerPed = GetPlayerPed
local GetEntityCoords = GetEntityCoords
local GetStreetNameFromHashKey = GetStreetNameFromHashKey
local GetStreetNameAtCoord = GetStreetNameAtCoord
local GetEntitySpeed = GetEntitySpeed
local IsPedInAnyVehicle = IsPedInAnyVehicle
local SetRichPresence = SetRichPresence
local SetDiscordAppId = SetDiscordAppId
local SetDiscordRichPresenceAsset = SetDiscordRichPresenceAsset
local SetDiscordRichPresenceAssetText = SetDiscordRichPresenceAssetText
local SetDiscordRichPresenceAction = SetDiscordRichPresenceAction
local PlayerId = PlayerId
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetVehicleClass = GetVehicleClass
local tostring = tostring
local pairs = pairs
local type = type

local playerId = nil
local playerName = nil
local playerData = nil
local lastUpdate = 0
local lastCoords = vector3(0, 0, 0)
local lastActivity = ""
local lastStreet = ""
local dataRequested = false
local dataRequestTime = 0
local lastPresenceText = ""

local vehicleNames = {
    [0] = "a car",
    [1] = "a motorcycle",
    [2] = "a truck",
    [3] = "a car",
    [4] = "a car",
    [5] = "a car",
    [6] = "a car",
    [7] = "a motorcycle",
    [8] = "a motorcycle",
    [9] = "a boat",
    [10] = "a boat",
    [11] = "a helicopter",
    [12] = "a plane",
    [13] = "a bike",
    [14] = "a boat",
    [15] = "a train",
    [16] = "a submarine"
}

local function InitializeDiscord()
    SetDiscordAppId(tostring(Config.appId))
    SetDiscordRichPresenceAsset(Config.largeImage)
    SetDiscordRichPresenceAssetText(Config.largeImageText or Config.richPresenceText)

    if Config.buttons and Config.buttons[1] and Config.buttons[1].enabled then
        SetDiscordRichPresenceAction(0, Config.buttons[1].label, Config.buttons[1].url)
    end
    if Config.buttons and Config.buttons[2] and Config.buttons[2].enabled then
        SetDiscordRichPresenceAction(1, Config.buttons[2].label, Config.buttons[2].url)
    end
end

local function GetPlayerActivity(player, speed, inVehicle)
    if inVehicle then
        if Config.enableDetailedVehicles then
            local vehicle = GetVehiclePedIsIn(player, false)
            if vehicle ~= 0 then
                local vehicleType = vehicleNames[GetVehicleClass(vehicle)] or "a vehicle"
                return "Driving " .. vehicleType
            end
        end
        return "Driving"
    end

    if Config.showActivity then
        if speed > 2.0 then
            return "Running"
        elseif speed > 0.5 then
            return "Walking"
        elseif speed > 0.1 then
            return "Strolling"
        else
            return "Standing"
        end
    else
        return "Exploring"
    end
end

local function GetStreetName(coords)
    if not coords or (coords.x == 0 and coords.y == 0 and coords.z == 0) then
        return Config.fallbackTexts.unknownLocation or "Unknown Location"
    end

    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    if streetHash == 0 then
        return Config.fallbackTexts.unknownStreet or "Unknown Street"
    end

    local streetName = GetStreetNameFromHashKey(streetHash)
    return streetName ~= "" and streetName or (Config.fallbackTexts.unknownStreet or "Unknown Street")
end

local function RequestPlayerData()
    if not dataRequested then
        TriggerServerEvent('vc_discord:getPlayerData')
        dataRequested = true
        dataRequestTime = GetGameTimer()
    end
end

local function RequestPlayerCount()
    if Config.showPlayerCount then
        TriggerServerEvent('vc_discord:getPlayerCount')
    end
end

RegisterNetEvent('vc_discord:receivePlayerData')
AddEventHandler('vc_discord:receivePlayerData', function(data)
    playerData = data
    dataRequested = false
end)

RegisterNetEvent('vc_discord:receivePlayerCount')
AddEventHandler('vc_discord:receivePlayerCount', function(count, max)
    if playerData then
        playerData.playerCount = count
        playerData.maxPlayers = max
    end
end)

local function UpdateDiscordPresence()
    local currentTime = GetGameTimer()

    if currentTime - lastUpdate < 10000 then
        return
    end

    if dataRequested and (currentTime - dataRequestTime) > 10000 then
        dataRequested = false
        RequestPlayerData()
        return
    end

    if not playerData then
        local loadingText = Config.fallbackTexts.loading or "Loading..."
        if Config.showPlayerId and Config.showPlayerName then
            loadingText = loadingText .. " [ID: " .. (playerId or "Unknown") .. " | User: " .. (playerName or "Unknown") .. "]"
        elseif Config.showPlayerId then
            loadingText = loadingText .. " [ID: " .. (playerId or "Unknown") .. "]"
        elseif Config.showPlayerName then
            loadingText = loadingText .. " [User: " .. (playerName or "Unknown") .. "]"
        end



        if loadingText ~= lastPresenceText then
            SetRichPresence(loadingText)
            lastPresenceText = loadingText
        end

        if not dataRequested then
            RequestPlayerData()
        end
        return
    end

    local char = ""
    if Config.showCharacterName then
        if playerData.charinfo and playerData.charinfo.firstname and playerData.charinfo.lastname then
            char = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname
        elseif playerData.name then
            char = playerData.name
        else
            char = Config.fallbackTexts.unknownPlayer or "Unknown Player"
        end
    end

    local player = GetPlayerPed(PlayerId())
    local coords = GetEntityCoords(player)
    local speed = GetEntitySpeed(player)
    local inVehicle = IsPedInAnyVehicle(player, false)

    local activity = GetPlayerActivity(player, speed, inVehicle)
    local streetName = GetStreetName(coords)

    local shouldUpdate = false

    if Config.showActivity and activity ~= lastActivity then
        shouldUpdate = true
    end
    if Config.showStreetName and streetName ~= lastStreet then
        shouldUpdate = true
    end
    if #(coords - lastCoords) > (Config.movementThreshold or 50.0) then
        shouldUpdate = true
    end

    if shouldUpdate then
        local statusText = ""
        if Config.showCharacterName and char ~= "" then
            statusText = char
            if Config.showActivity or Config.showStreetName then
                statusText = statusText .. " is "
            end
        end
        if Config.showActivity then
            statusText = statusText .. activity
        end
        if Config.showStreetName then
            if Config.showActivity then
                statusText = statusText .. " on "
            elseif Config.showCharacterName and char ~= "" then
                statusText = statusText .. " on "
            end
            statusText = statusText .. streetName
        end

        local presenceText = ""
        if Config.showPlayerId and Config.showPlayerName then
            presenceText = "[ID: " .. playerId .. " | User: " .. playerName .. "]"
        elseif Config.showPlayerId then
            presenceText = "[ID: " .. playerId .. "]"
        elseif Config.showPlayerName then
            presenceText = "[" .. playerName .. "]"
        end

        if presenceText ~= "" then
            presenceText = presenceText .. " " .. statusText
        else
            presenceText = statusText or ""
        end

        if presenceText ~= lastPresenceText then
            local detailsText = presenceText
            local stateText = ""

            if Config.showPlayerCount and playerData and playerData.playerCount then
                stateText = "Players: " .. playerData.playerCount .. "/" .. (playerData.maxPlayers or Config.MaxPlayers)
            end

            local finalPresenceText = ""
            if stateText ~= "" then
                finalPresenceText = stateText .. " \n " .. detailsText
            else
                finalPresenceText = detailsText
            end

            SetRichPresence(finalPresenceText)
            lastPresenceText = presenceText
        end

        lastActivity = activity
        lastStreet = streetName
        lastCoords = coords
        lastUpdate = currentTime
    end
end

Citizen.CreateThread(function()
    InitializeDiscord()

    playerId = GetPlayerServerId(PlayerId())
    playerName = GetPlayerName(PlayerId())

    while true do
        local currentPlayerId = GetPlayerServerId(PlayerId())
        if currentPlayerId ~= playerId then
            playerId = currentPlayerId
            playerName = GetPlayerName(PlayerId())
            dataRequested = false
            RequestPlayerData()
        end

        if Config.showPlayerCount then
            RequestPlayerCount()
        end

        UpdateDiscordPresence()
        Citizen.Wait(Config.updateInterval or 5000)
    end
end)