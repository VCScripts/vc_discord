Config = {
    -- Discord Application ID
    appId = "",
    
    -- Rich Presence Images
    largeImage = "",
    largeImageText = "",
    richPresenceText = "",
    
    -- Display Options
    showPlayerId = true,        -- Show player server ID
    showPlayerName = true,      -- Show player's Steam/Discord name
    showCharacterName = true,   -- Show character's first and last name
    showStreetName = true,      -- Show street name
    showActivity = true,         -- Show activity
    showPlayerCount = true,      -- Show player count

    -- Update Settings
    updateInterval = 5000, -- How often to check for updates (in ms)
    movementThreshold = 50.0, -- Distance threshold for location updates
    MaxPlayers = 32, -- Max players for player count display, only needed if you dont have sv_maxclients set
    
    -- Activity Detection
    enableDetailedVehicles = true, -- Show specific vehicle types
    enableSpeedBasedActivity = true, -- Show walking/running based on speed
    
    -- Buttons Configuration
    buttons = {
        {
            label = "Join Server",
            url = "",
            enabled = true
        },
        {
            label = "Join Discord",
            url = "",
            enabled = true
        }
    },

    -- Fallback Text
    fallbackTexts = {
        loading = "Loading...",
        unknownPlayer = "Unknown Player",
        unknownLocation = "Unknown Location",
        unknownStreet = "Unknown Street"
    }
}
