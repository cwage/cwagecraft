# EnderIO Recipe Additions

This datapack adds missing recipes to EnderIO machines to provide better integration with other mods in the pack.

## Problem
EnderIO machines (SAG Mill and Alloy Smelter) were missing many common processing recipes that other mod machines could handle, creating gaps in automation and forcing players to use multiple machine types for basic operations.

## Solution
Adds comprehensive recipe support to EnderIO machines with 30 total recipes:

### SAG Mill Additions (16 recipes)
- **Metal Ingot Grinding**: copper, tin, nickel, silver, lead, aluminum, uranium, iron, gold
- **Fuel Processing**: coal and charcoal → dust
- **Gem Processing**: diamond, emerald, lapis lazuli → dust
- Consistent with other mod grinding machines like Thermal Pulverizers

### Alloy Smelter Additions (14 recipes)
- **Raw Ore Smelting**: copper, iron, gold, tin, lead, nickel, aluminum, uranium, silver
- **Basic Block Smelting**: cobblestone→stone, stone→smooth stone, sandstone→smooth sandstone  
- **Food Cooking**: beef, pork, chicken (vanilla furnace parity)
- Ensures recipe parity for common materials and processing tasks

## Recipe Coverage
- Addresses all major processing gaps mentioned in the original issue
- Provides consistency with vanilla furnaces and other mod machines
- Enables EnderIO machines to serve as primary processing solution
- Supports early to late-game automation workflows

## Files
- `data/enderio/recipes/sagmill/` - 16 SAG Mill grinding recipes
- `data/enderio/recipes/alloy_smelter/` - 14 Alloy Smelter recipes
- `pack.mcmeta` - Data pack metadata (pack format 15)

## Technical Details
- Uses standard EnderIO recipe format for compatibility
- Energy costs: 2400 RF for SAG Mill, 1600-3200 RF for Alloy Smelter
- Follows Minecraft 1.20.1 data pack conventions
- Integrates with OpenLoader for seamless loading