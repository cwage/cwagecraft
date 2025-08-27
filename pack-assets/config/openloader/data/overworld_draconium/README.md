# Overworld Draconium Ore Generation

This datapack adds very rare draconium ore generation to the Minecraft overworld to support early-game access to Draconic Evolution's Dislocator utility.

## Design Goals
- Enable Dislocator crafting without requiring End exploration
- Maintain Draconic Evolution's endgame identity
- Provide conservative, balanced ore generation

## Configuration Details

### Rarity: 1/48 chunks
- Still rarer than diamond ore but slightly more accessible
- Requires moderate exploration to find
- Balanced to provide Dislocator access without trivializing DE

### Depth: Y-48 to Y-16
- Deep mining required (below iron level)
- Covers both stone and deepslate variants
- Still requires dedicated deep exploration

### Vein Size: 1-2 blocks
- Very small ore clusters
- Typically 1 block, occasionally 2
- Multiple discoveries needed for crafting

### Target Blocks
- `minecraft:stone` -> `draconicevolution:draconium_ore`
- `minecraft:deepslate` -> `draconicevolution:deepslate_draconium_ore`

## Balance Considerations

**Conservative Parameters:**
- Spawn rate: ~1 ore per several chunks at target depth
- No air exposure protection (0.0 discard)
- Applied to all overworld biomes
- Single ore per generation attempt

**Expected Impact:**
- Early Dislocator access through dedicated deep mining
- Requires exploration of 20-50 chunks at depth for sufficient ore
- End dimension remains primary draconium source for bulk needs
- High-tier DE content remains endgame-locked

## Integration Notes
- Uses Forge biome modifier system
- Compatible with Biomes O' Plenty and other worldgen mods
- Loads via OpenLoader datapack system
- No conflicts with existing ore generation