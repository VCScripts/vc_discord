# vc_discord

A Discord Rich Presence script for FiveM servers that displays player information and activity status.

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
