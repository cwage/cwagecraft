# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Minecraft modpack repository using Packwiz for mod management. The modpack "cwagecraft" is designed for Minecraft 1.20.1 with Forge 47.3.22 and includes a comprehensive collection of technology, magic, exploration, and quality-of-life mods.

## Commands

### Primary Command (SOURCE OF TRUTH)
- **Setup/Reset Pack**: `./setup.sh` - Completely rebuilds the modpack from scratch
  - This is the **ONLY** command that should be used to modify the modpack
  - All mod additions, removals, and changes must be made by editing setup.sh and re-running it

### Packwiz Operations (INFORMATIONAL ONLY)
- **List Mods**: `packwiz -y list` - Shows all mods in the current pack
- **View Pack Info**: `packwiz -y status` - Shows pack status and mod count
- **Export Pack**: `packwiz -y modrinth export --output cwagecraft.mrpack --restrictDomains=false`

**CRITICAL**: Never use `packwiz add`, `packwiz remove`, or `packwiz refresh` commands directly. The setup.sh script is the single source of truth and handles all pack modifications.

### Mod Management Helper Functions (from setup.sh)
- `mr_add()` - Adds mods from Modrinth with logging
- `cf_add()` - Adds mods from CurseForge with logging

## Architecture

### Directory Structure
- `cwagecraft/` - Main pack directory containing all configuration
- `cwagecraft/mods/` - Individual mod configuration files (*.pw.toml)
- `cwagecraft/pack.toml` - Main pack metadata and version info
- `cwagecraft/index.toml` - Hash-verified index of all pack files
- `cwagecraft.mrpack` - Exported modpack file for distribution

### Pack Configuration
- **MC Version**: 1.20.1 (accepts 1.20, 1.20.1)
- **Modloader**: Forge 47.3.22
- **Pack Format**: packwiz:1.1.0

### Mod Categories (as organized in setup.sh)
1. **Core compute/storage/power**: OpenComputers 2, Refined Storage, Mekanism, Ender IO, Industrial Foregoing
2. **World/magic/QoL**: Botania, Biomes O' Plenty, Waystones, JEI
3. **Food systems**: Farmer's Delight, Croptopia, cooking mods
4. **Technology**: Create, AE2, RFTools suite, Thermal series
5. **Magic/Adventure**: Tinkers' Construct, Draconic Evolution, Mystical Agriculture
6. **Exploration/Mining**: Advanced Mining Dimension, Iron Jetpacks
7. **Utilities**: FTB suite (chunks, teams, essentials), inventory management

### Mod Configuration Files
Each mod has a `.pw.toml` file containing:
- Mod metadata (name, filename)
- Download information (URL, hash verification)
- Update tracking (mod-id, version)
- Side specification (client/server/both)

## Development Notes

- **setup.sh is the SINGLE SOURCE OF TRUTH** - Never bypass it with direct packwiz commands
- To add/remove mods: Edit setup.sh, then run `./setup.sh` to rebuild the entire pack
- To change mod versions: Update the mod slug/ID in setup.sh and rebuild
- Hash verification ensures mod file integrity through SHA-512 checksums
- All mods are sourced from either Modrinth (preferred) or CurseForge
- The pack supports cross-dimensional power/item networks and advanced automation
- Focus is on providing comprehensive tech progression from early to late game
- **Important**: `grep` is aliased to `ripgrep` (rg) in this environment - use ripgrep syntax and arguments

## Workflow Rules
1. **Modify pack**: Edit setup.sh → Run `./setup.sh`
2. **Query pack**: Use `packwiz -y list` or similar informational commands
3. **Never**: Use `packwiz add/remove` or modify .pw.toml files directly
