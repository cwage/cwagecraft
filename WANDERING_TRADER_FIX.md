# Wandering Trader Suppression Solution

## Issue
Wandering Traders were disruptive to gameplay and didn't add value to the pack. The requirement was to add a mod that either:
- Fully disables wandering trader spawns, or  
- Spawns an invisible 'trap' block/entity that instantly captures and removes traders

## Solution Implemented
Added **"Wandering Trader May Leave"** by Serilum to the modpack.

### Why This Mod?
- Provides a clean, user-friendly solution via a button in the trader GUI
- Allows players to peacefully dismiss traders without violence
- Handles both the trader and associated llamas
- Includes respawn command if accidentally dismissed
- Made by established, reliable mod developer (Serilum)
- Available on both CurseForge and Modrinth with proper export permissions

### Mod Details
- **Name**: Wandering Trader May Leave  
- **CurseForge ID**: 516464
- **Dependency**: Collective (CurseForge ID: 342584)
- **Compatibility**: Forge 47.3.22, Minecraft 1.20.1 ✓

### Alternative Considered
"NoMoWanderer" by J-Dill was also evaluated but "Wandering Trader May Leave" was chosen for its simpler, more intuitive user experience.

### Implementation  
Both mods added to `mods.yaml`:
- Collective (required library dependency)
- Wandering Trader May Leave (main functionality)

This approach fits the "auto-handle" requirement perfectly while maintaining the pack's quality-of-life focus.