# Cyclic Recipe Fixes

This datapack disables Cyclic's compressed cobblestone recipes to prevent conflicts with AllTheCompressed mod.

## Problem
Both Cyclic and AllTheCompressed mods provide recipes for compressed cobblestone, causing conflicts in automated crafting systems (such as RFTools crafters). The crafting system would randomly pick between the two recipes, potentially breaking automation setups.

## Solution
This datapack uses the `forge:false` condition to disable all potential Cyclic compressed cobblestone recipes, ensuring that only AllTheCompressed handles compressed cobblestone variants.

## Files
- `compressed_cobblestone.json` - Most common naming pattern
- `cobblestone_compressed.json` - Alternative naming pattern  
- `compressed_cobble.json` - Shortened version
- `cobblestone_1x.json` - 1x compressed variant
- `compressed_blocks_cobblestone.json` - Namespaced variant

## Technical Details
Using `forge:false` condition ensures these recipes are never loaded, allowing AllTheCompressed to be the sole provider of compressed cobblestone recipes for consistent automation.