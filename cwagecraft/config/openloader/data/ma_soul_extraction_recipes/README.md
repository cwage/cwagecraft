# Mystical Agriculture Soul Extraction Recipes

This datapack adds missing soul extraction recipes to fix the Soul Extractor machine not processing Soul Jars with mob drops.

## Problem
The Mystical Agriculture Soul Extractor was not accepting Soul Jars + mob drops (like Blaze Rods) despite having power and JEI showing recipes. This blocked the core MA gameplay loop of accumulating souls for crop growth.

## Solution
Adds explicit `mysticalagriculture:soul_extraction` recipes for key vanilla mobs commonly used in Mystical Agriculture automation:

### Nether Mobs
- **Blaze**: Blaze Rod (0.5 souls), Blaze Powder (0.125 souls)
- **Wither Skeleton**: Wither Skeleton Skull (1.0 souls), Coal (0.1 souls)  
- **Magma Cube**: Magma Cream (0.25 souls)

### Overworld Hostile Mobs
- **Skeleton**: Bone (0.25 souls)
- **Zombie**: Rotten Flesh (0.25 souls)
- **Creeper**: Gunpowder (0.5 souls)
- **Spider**: Spider Eye (0.25 souls), String (0.125 souls)
- **Cave Spider**: Spider Eye (0.25 souls), String (0.125 souls)

### Overworld Neutral/Passive Mobs
- **Slime**: Slime Ball (0.25 souls)
- **Enderman**: Ender Pearl (0.75 souls)

### End Mobs
- **Enderman**: Ender Pearl (0.75 souls)

## Files
- `data/mysticalagriculture/recipes/soul_extraction/` - Soul extraction recipe JSON files
- `pack.mcmeta` - Data pack metadata (pack format 15)

## Technical Details
- Uses standard Mystical Agriculture `soul_extraction` recipe format
- Soul values balanced: rare items = more souls, common items = fewer souls
- Integrates with OpenLoader for seamless loading
- Compatible with Minecraft 1.20.1 and Mystical Agriculture 7.0.23+