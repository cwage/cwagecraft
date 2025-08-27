# FTB Ultimine Configuration

## Overview
FTB Ultimine has been configured to only work on ore blocks, preventing exploitation for tree harvesting, farming, and other non-mining activities.

## Configuration Files
Multiple configuration formats have been provided to ensure compatibility:

### JSON Configurations
- `config/ftb-ultimine/common.json` - Common settings for all sides
- `config/ftb-ultimine/server.json` - Server-specific configuration  
- `config/ftb-ultimine/client.json` - Client-specific configuration
- `defaultconfigs/ftb-ultimine/server.json` - Default configuration for new worlds

### TOML Configurations  
- `config/ftb-ultimine.toml` - Main TOML configuration
- `defaultconfigs/ftb-ultimine.toml` - Default TOML configuration

## Allowed Blocks (Whitelist Mode)
FTB Ultimine will ONLY work on these block categories:

### Vanilla Ores
- Coal ores (`minecraft:coal_ores`)
- Iron ores (`minecraft:iron_ores`) 
- Gold ores (`minecraft:gold_ores`)
- Diamond ores (`minecraft:diamond_ores`)
- Emerald ores (`minecraft:emerald_ores`)
- Lapis ores (`minecraft:lapis_ores`)
- Redstone ores (`minecraft:redstone_ores`)
- Copper ores (`minecraft:copper_ores`)

### Modded Ores
- All Forge-tagged ores (`forge:ores/*`)
- Mekanism ores (`mekanism:ores`)
- Thermal ores (`thermal:ores`) 
- Immersive Engineering ores (`immersiveengineering:ores`)
- Tinker's Construct ores
- Other modpack ores

### Specific Ore Blocks
- All deepslate variants
- Nether gold ore
- Nether quartz ore
- Ancient debris

## Blocked Activities
FTB Ultimine will NOT work on:

### Wood & Plants
- Logs (`minecraft:logs`)
- Leaves (`minecraft:leaves`)
- Planks (`minecraft:planks`)
- Saplings (`minecraft:saplings`)
- Flowers (`minecraft:flowers`)

### Crops & Farming
- All crops (`minecraft:crops`)
- Wheat, carrots, potatoes, beetroots
- Melons, pumpkins
- Sugar cane, bamboo

### Terrain Blocks
- Dirt (`forge:dirt`)
- Stone (`forge:stone`)
- Sand (`forge:sand`)
- Gravel (`forge:gravel`)
- Cobblestone (`forge:cobblestone`)

## Settings
- **Mode**: Whitelist (only allowed blocks work)
- **Max Blocks**: 64 per operation
- **Tool Requirement**: None (works with any tool)
- **Shape**: Tunnel mining
- **Hunger Cost**: 0.005 exhaustion per block

## Balance Impact
This configuration preserves FTB Ultimine's intended use for efficient ore mining while preventing exploitation of:
- Tree farming (maintains wood gathering effort)
- Crop harvesting (preserves farming progression)
- Terrain modification (prevents landscape clearing exploits)
- Building material collection (maintains construction effort)

## Testing
To verify the configuration works:
1. Try FTB Ultimine on ore blocks (should work)
2. Try FTB Ultimine on logs/leaves (should not work)  
3. Try FTB Ultimine on crops (should not work)
4. Try FTB Ultimine on dirt/stone (should not work)

The configuration uses both whitelist and blacklist approaches to ensure comprehensive coverage and prevent edge cases.