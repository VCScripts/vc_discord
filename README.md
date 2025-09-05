# vc_discord

A Discord Rich Presence script for FiveM servers that displays player information and activity status.

## Supported Frameworks

This script automatically detects and supports the following FiveM frameworks:

- **QBox** (`qbx_core`) - Primary support with automatic detection
- **QBCore** (`qb-core`) - Full compatibility with automatic detection  
- **ESX** (`es_extended`) - Full compatibility with automatic detection

The framework detection runs automatically in the order: QBox → QBCore → ESX

## Framework Override

You can force a specific framework using the convar:

# Force QBox framework
`set vc_discord_framework qbox`

# Force QBCore framework  
`set vc_discord_framework qbcore`

# Force ESX framework
`set vc_discord_framework esx`


## Installation

1. Place the `vc_discord` folder in your servers directory
2. Ensure the resource is started in your `server.cfg`
3. Configure the `config.lua` file with your Discord application details
4. Restart your server

## Discord Setup

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Create a new application
3. Copy the Application ID to your config
4. Upload your server icon as an asset
5. Configure the asset name in your config

## Configuration

Edit the `config.lua` file to customize:

### Basic Settings
- Discord Application ID
- Server icon and text
- Button labels and URLs

### Display Options
- **Player ID**: Show/hide player server ID
- **Player Name**: Show/hide player's Steam/Discord name
- **Character Name**: Show/hide character's first and last name
- **Activity**: Show/hide player activity (driving, walking, etc.)
- **Street Name**: Show/hide current street location
- **Player Count**: Show/hide current player count and maximum players

### Performance Settings
- Update intervals and movement thresholds
- Vehicle detection and speed-based activity options

## Player Count Feature

The script includes a real-time player count display that shows current players vs. maximum capacity:

- **Format**: `Players: X/Y` (e.g., "Players: 15/32")
- **Update Frequency**: Updates every 30 seconds for real-time accuracy
- **Configuration**: Enable/disable via `showPlayerCount` in config
- **Max Players**: Uses `MaxPlayers` from config or server convar `sv_maxclients`
- **Display**: Player count appears on a separate line below player activity and location

### Player Count Configuration

```lua
-- In config.lua
showPlayerCount = true,      -- Enable player count display
MaxPlayers = 32,            -- Fallback max players (only used if sv_maxclients is not set)
```

**Max Players Priority:**
1. **Server Convar**: `sv_maxclients` (highest priority)
2. **Config Fallback**: `Config.MaxPlayers` (only used if server convar is not set)

**Example Server Configuration:**
```cfg
# In your server.cfg
sv_maxclients 64
```

## Screenshots  

- Player ID and CFX Name + Player Count:

<img width="436" height="151" alt="image" src="https://github.com/user-attachments/assets/d0b13266-ada8-44f5-8f5c-eac6ba195fb8" />

- Player ID and CFX Name and Character Name + Player Count

<img width="440" height="163" alt="image" src="https://github.com/user-attachments/assets/336ec04f-d4cc-41e7-8786-aa11a71c943c" />

- Player ID and CFX Name and Character Name and Street Name + Player Count

<img width="447" height="161" alt="image" src="https://github.com/user-attachments/assets/00e22821-3ef1-467a-a965-889cec3f4855" />

- All options enabled (Standing)
  
<img width="456" height="159" alt="image" src="https://github.com/user-attachments/assets/4c3d43a5-e70f-4df5-9cc9-1a02fd9c66cf" />

- All options enabled (Driving)
  
<img width="454" height="161" alt="image" src="https://github.com/user-attachments/assets/ba42e3eb-206f-4cfb-9529-d085028e1759" />
