#!/usr/bin/env bash
set -euo pipefail

PACK_NAME="Revelationish-OC2R-Forge-1.20.1"
MC_VERSION="1.20.1"
FORGE_VERSION="47.3.22"
AUTHOR="cwage"
OUT_DIR="$PWD"
PACK_DIR="$OUT_DIR/$PACK_NAME"
MRPACK="$OUT_DIR/${PACK_NAME}.mrpack"
PW="packwiz -y"

echo "==> Reset"
rm -rf "$PACK_DIR" "$MRPACK"
mkdir -p "$PACK_DIR"
cd "$PACK_DIR"

echo "==> Init pack ($MC_VERSION Forge $FORGE_VERSION)"
$PW init \
  --name "$PACK_NAME" \
  --author "$AUTHOR" \
  --version "1.0.0" \
  --mc-version "$MC_VERSION" \
  --modloader forge \
  --forge-version "$FORGE_VERSION"

echo "==> Accept MC $MC_VERSION family"
$PW settings acceptable-versions --add 1.20
$PW settings acceptable-versions --add 1.20.1

mr_add() { echo "MR  $1"; $PW modrinth add "$1"; }
cf_add() { echo "CF  $1"; $PW curseforge add "$1"; }

echo "==> Core compute / storage / power"
mr_add oc2r                         # OpenComputers 2: Reimagined (adds Markdown Manual dep)
mr_add refined-storage              # Refined Storage
mr_add extrastorage                 # RS addon
mr_add storagedrawers               # correct MR slug (not storage-drawers)
mr_add iron-chests
mr_add mekanism
mr_add mekanism-generators
# cf_add laserio
cf_add "ender-io" 6911764
cf_add industrial-foregoing         # pulls Titanium dep

echo "==> World / magic / QoL"
mr_add botania                      # pulls Curios + Patchouli
mr_add biomes-o-plenty              # pulls TerraBlender + GlitchCore
mr_add waystones                    # pulls Balm
mr_add natures-compass
# Locate structures (pair with Nature's Compass)
mr_add "explorers-compass" || cf_add "explorers-compass"
mr_add jei
mr_add jade
mr_add mouse-tweaks
mr_add journeymap
cf_add fast-leaf-decay

echo "==> Immersive Engineering"
cf_add immersive-engineering

echo "==> Mystical Agriculture"
mr_add cucumber                 # required library
mr_add mystical-agriculture     # core mod
# Optional late-game add-on:
mr_add mystical-agradditions    # extra high-tier seeds

echo "==> Inventory QoL: Dank-like storage & magnets"
# Dank Null–style portable filtered storage:
cf_add dank-storage

# Backpack-based alternative with pickup/void/filter/magnet upgrades:
mr_add sophisticated-backpacks

# Simple vacuum block for early automation:
mr_add item-collectors

echo "==> Mob farming utilities"
cf_add mob-grinding-utils

echo "==> RFTools"
cf_add rftools-base
cf_add rftools-builder
cf_add rftools-control
cf_add rftools-dimensions
cf_add rftools-power
cf_add rftools-storage
cf_add rftools-utility

echo "==> Exploration / adventure"
cf_add cucumber         # library
cf_add iron-jetpacks    # tiered jetpacks

echo "==> Mining dimension"
cf_add advanced-mining-dimension

# Chisel-style decorative variants
mr_add chipped || cf_add chipped

# EnderStorage (ender chests/tanks) + dependency
cf_add codechicken-lib-1-8
cf_add ender-storage-1-8

# Wireless FE power networks (cross-dimension)
cf_add flux-networks

# Core food/cooking
cf_add croptopia
cf_add farmers-delight
cf_add cooking-for-blockheads
cf_add appleskin
cf_add nethers-delight
cf_add ends-delight

# Right-click harvesting (Serilum) + required library
mr_add reap || cf_add reap

# Faster sugar cane/cactus growth
cf_add snad

# --- Thermal Series (1.20.1 Forge) ---
# Required base
cf_add cofh-core
cf_add thermal-foundation

# Machines (Magma Crucible, Fluid Transposer, Pulverizer, etc.)
cf_add thermal-expansion

# Nice-to-haves (optional)
cf_add thermal-dynamics     # item/energy/fluid ducts
cf_add thermal-integration  # extra recipes & cross-mod hooks



echo "==> Builder wands"
cf_add construction-wand


echo "==> Tinkers"
mr_add tinkers-construct            # pulls Mantle

# XP leveling for Tinkers tools (Forge 1.20.1)
cf_add tinkers-levelling-addon

cf_add torchmaster

# === Mob synthesis (Hostile Neural Networks) ===
cf_add placebo
cf_add hostile-neural-networks

# Draconic Evolution + required library
mr_add draconic-evolution
cf_add brandons-core

# Forestry & bee genetics
mr_add forestry-community-edition
mr_add gendustry-community-edition

mr_add paragliders

mr_add "target-dummy"

# Clean Swing Through Grass (hit through plants)
mr_add "clean-swing-through-grass" || cf_add "clean-swing-through-grass"

# Cobblegen alternative (tiers up to Netherite)
mr_add "cobble-for-days" || cf_add "cobble-for-days"

# Pocket dimensions for machines
cf_add "compact-machines"

# Pick-up/trade/breed villagers in item form
cf_add "easy-villagers"
# Barter piglins the same way
cf_add "easy-piglins"

# Highlight matching items in nearby chests
mr_add "findme" || cf_add "findme"

# Automatic world backups (1.20.1)
mr_add "ftb-backups-2" || cf_add "ftb-backups-2"

# --- FTB Teams + Chunkloading ---
cf_add architectury-api         # dep (safe to add even if already present)
cf_add ftb-library-forge        # core FTB library
cf_add ftb-teams-forge          # required by Chunks (and AdminShop if it appears)
cf_add ftb-chunks-forge         # claims + chunkloading UI


# Infinite cave layer below bedrock
mr_add infinity-cave

mr_add light-overlay

mr_add modular-routers

mr_add elevatormod

cf_add pylons

# --- Powah (Forge 1.20.1) + deps ---
cf_add powah-rearchitected
cf_add cloth-config
cf_add guideme

# Trash cans (items / fluids / energy)
mr_add supermartijn642s-core-lib
mr_add trash-cans

mr_add the-afterdark

echo "==> Reactors"
cf_add zerocore                     # correct CF slug for “ZeroCore 2”
cf_add extreme-reactors

echo "==> Mining QoL"
cf_add ftb-library-forge
cf_add ftb-ultimine-forge

echo "==> Shaders / renderer"
cf_add oculus
cf_add embeddium                    # Do NOT add Rubidium

echo "==> Refresh index"
$PW refresh

echo "==> Export Modrinth pack (.mrpack)"
$PW modrinth export --output "$MRPACK" --restrictDomains=false

echo
echo "==> Done."
echo "Import '$MRPACK' in PolyMC/Prism: Add Instance -> Import from zip (select the .mrpack)."
