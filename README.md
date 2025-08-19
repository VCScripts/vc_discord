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

### Performance Settings
- Update intervals and movement thresholds
- Vehicle detection and speed-based activity options
