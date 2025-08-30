#!/usr/bin/env bash
set -euo pipefail

PACK_NAME="cwagecraft"
MC_VERSION="1.20.1"
FORGE_VERSION="47.3.22"
AUTHOR="cwage"
OUT_DIR="$PWD"
PACK_DIR="$OUT_DIR/$PACK_NAME"
MRPACK="$OUT_DIR/${PACK_NAME}.mrpack"
PW="packwiz -y"

echo "==> Reset"
rm -rf "$MRPACK"
mkdir -p "$PACK_DIR"
cd "$PACK_DIR"

if [[ ! -f "$PACK_DIR/pack.toml" ]]; then
    echo "==> Init pack ($MC_VERSION Forge $FORGE_VERSION)"
    # Retry packwiz init on network failures (TLS handshake timeouts, etc.)
    init_success=false
    for attempt in 1 2; do
        if [[ $attempt -gt 1 ]]; then
            echo "    Init attempt $attempt/2 (network error, retrying...)"
            sleep 2
        fi
        
        if $PW init \
          --name "$PACK_NAME" \
          --author "$AUTHOR" \
          --version "1.0.0" \
          --mc-version "$MC_VERSION" \
          --modloader forge \
          --forge-version "$FORGE_VERSION"; then
            init_success=true
            break
        fi
    done

    if [[ "$init_success" != "true" ]]; then
        echo "ERROR: Failed to initialize pack after 2 attempts"
        exit 1
    fi

    echo "==> Accept MC $MC_VERSION family"
    $PW settings acceptable-versions --add 1.20
    $PW settings acceptable-versions --add 1.20.1
else
    echo "==> Pack already exists, skipping init"
fi

# Helper function - prefer Modrinth with CurseForge fallback with retry logic
# Usage: add_mod "display-name" "slug" "modrinth-id" ["curseforge-id"]
add_mod() {
    local display_name="$1"
    local slug="$2"
    local modrinth_id="$3"
    local curseforge_id="${4:-}"
    local max_attempts=2
    local attempt=1
    
    echo "Adding: $display_name ($slug)"
    
    # Helper function to attempt adding a mod with retry logic
    try_add_with_retry() {
        local add_command="$1"
        local source_name="$2"
        
        for ((attempt=1; attempt<=max_attempts; attempt++)); do
            if [[ $attempt -gt 1 ]]; then
                local backoff_time=$((attempt - 1))
                echo "    Retry attempt $attempt/$max_attempts (waiting ${backoff_time}s)..."
                sleep $backoff_time
            fi
            
            # Capture output and exit code, suppress output
            local output
            local exit_code
            output=$(eval "$add_command" 2>&1)
            exit_code=$?
            
            if [[ $exit_code -eq 0 ]]; then
                echo "    ✓ $source_name"
                return 0
            fi
            
            # Only retry on network/connection errors, not "mod not found" errors
            if [[ $output == *"network"* ]] || [[ $output == *"connection"* ]] || [[ $output == *"TLS"* ]] || [[ $output == *"timeout"* ]] || [[ $output == *"SSL"* ]]; then
                if [[ $attempt -lt $max_attempts ]]; then
                    echo "    $source_name network error, retrying..."
                else
                    echo "    ✗ $source_name (network error)"
                fi
            else
                # For non-network errors, fail silently since export may still work
                return 1
            fi
        done
        
        return 1
    }
    
    # Try Modrinth first (preferred)
    if [[ -n "$modrinth_id" ]]; then
        if try_add_with_retry "$PW modrinth add '$modrinth_id'" "MR"; then
            return 0
        fi
    fi
    
    # Fallback to CurseForge
    if [[ -n "$curseforge_id" ]]; then
        # Try as project ID first, then as slug if that fails
        if try_add_with_retry "$PW curseforge add '$curseforge_id'" "CF" || \
           try_add_with_retry "$PW curseforge add '$slug'" "CF"; then
            return 0
        fi
    fi
    
    # Always return success so script continues
    return 0
}

echo "==> Core compute / storage / power"
add_mod "OpenComputers 2 Reimagined" "oc2r" "F1gm4RsH" "864686"           # Programmable computers with Lua
add_mod "Refined Storage" "refined-storage" "KDvYkUg3" "243076"             # Digital storage system
add_mod "Extra Storage" "extrastorage" "T34cBZKl" "404074"                 # RS addon for larger disks
add_mod "Storage Drawers" "storagedrawers" "guitPqEi" "223852"              # Compact item storage blocks
add_mod "Iron Chests" "iron-chests" "P3iIrPH3" "228756"                     # Upgraded chest variants
add_mod "Mekanism" "mekanism" "Ce6I4WUE" "268560"                           # Tech mod with ore processing
add_mod "Mekanism Generators" "mekanism-generators" "OFVYKsAk" "268566"   # Power generation for Mekanism
add_mod "Ender IO" "ender-io" "enderio" "64578"                          # Conduits and advanced machines (beta but functional)
add_mod "Industrial Foregoing" "industrial-foregoing" "industrial-foregoing" "266515"         # Automation and mob farming

echo "==> World / magic / QoL"
add_mod "Botania" "botania" "pfjLUfGv" "225643"                             # Nature magic mod
add_mod "Biomes O' Plenty" "biomes-o-plenty" "HXF82T3G" "220318"           # Additional biomes
add_mod "Flat Bedrock" "flat-bedrock" "" "398623"                           # Flat bedrock generation for easier Grains of Infinity
add_mod "Waystones" "waystones" "LOpKHB2A" "245755"                         # Fast travel waypoints
add_mod "Nature's Compass" "natures-compass" "fPetb5Kh" "252848"            # Biome locator
add_mod "Explorer's Compass" "explorers-compass" "RV1qfVQ8" "313536"       # Structure locator
add_mod "Just Enough Items" "jei" "u6dRKJwZ" "238222"                       # Recipe viewer
add_mod "Just Enough Resources" "just-enough-resources-jer" "just-enough-resources-jer" "240630"    # JEI addon for ore info
add_mod "Just Enough Resources Profiler (JEARGH)" "just-enough-resources-profiler-jeargh" "UL1ioLJO" "865827"    # JER profiling command
add_mod "Rhino" "rhino" "rhino" "416294"                                     # JavaScript engine for KubeJS
add_mod "KubeJS" "kubejs" "umyGSfug" "238086"                               # Server scripting for automation
add_mod "Jade" "jade" "nvQzSEkH" "324717"                                   # Block/entity info overlay
add_mod "Mouse Tweaks" "mouse-tweaks" "aC3cM3Vq" "60089"                   # Inventory mouse improvements
add_mod "JourneyMap" "journeymap" "lfHFW1mp" "32274"                       # Minimap and waypoints
add_mod "Fast Leaf Decay" "fast-leaf-decay" "fld" "230976"                   # Faster tree cleanup

echo "==> Immersive Engineering"
add_mod "Immersive Engineering" "immersive-engineering" "immersiveengineering" "231951"        # Multiblock machines and tech

echo "==> Mystical Agriculture"
add_mod "Cucumber Library" "cucumber" "cucumber" "272335"                           # Required library
add_mod "Mystical Agriculture" "mystical-agriculture" "C95ReXie" "246640"  # Grow resources with crops
add_mod "Mystical Agradditions" "mystical-agradditions" "pl0jGXIx" "256247" # Extra high-tier seeds

echo "==> Inventory QoL: Dank-like storage & magnets"
add_mod "Dank Storage" "dank-storage" "" "225469"                          # Portable filtered storage
add_mod "Sophisticated Backpacks" "sophisticated-backpacks" "TyCTlI4b" "422301" # Advanced backpacks with upgrades
add_mod "Item Collectors" "item-collectors" "y9vDr4Th" "330482"            # Vacuum blocks for automation

echo "==> Mob farming utilities"
add_mod "Mob Grinding Utils" "mob-grinding-utils" "" "314906"             # Mob farm blocks and tools

echo "==> RFTools"
add_mod "RFTools Base" "rftools-base" "rftools-base" "326041"                          # Core RFTools library
add_mod "RFTools Builder" "rftools-builder" "rftools-builder" "275376"                    # Quarry and building tools
add_mod "RFTools Control" "rftools-control" "rftools-control" "385194"                   # Computer control systems
add_mod "RFTools Dimensions" "rftools-dimensions" "rftools-dimensions" "343887"              # Custom dimension creation
add_mod "RFTools Power" "rftools-power" "rftools-power" "326043"                       # Power generation
add_mod "RFTools Storage" "rftools-storage" "" "326045"                   # Modular storage system
add_mod "RFTools Utility" "rftools-utility" "rftools-utility" "326044"                   # Utility blocks

echo "==> Exploration / adventure"
add_mod "Cucumber Library" "cucumber" "cucumber" "272335"                           # Library (duplicate but needed)
add_mod "Iron Jetpacks" "iron-jetpacks" "iron-jetpacks" "253560"                       # Tiered flight packs

echo "==> Mining dimension"
add_mod "Advanced Mining Dimension" "advanced-mining-dimension" "advanced-mining-dimension" "384976" # Separate mining world

add_mod "Chipped" "chipped" "BAscRYKm" "456956"                             # Decorative block variants
add_mod "CodeChicken Lib 1.8" "codechicken-lib-1-8" "codechicken-lib" "242818"          # Legacy library
add_mod "EnderStorage 1.8" "ender-storage-1-8" "ender-storage" "245174"               # Cross-dimensional storage
add_mod "Flux Networks" "flux-networks" "" "248020"                       # Wireless power networks

echo "==> Core food/cooking"
add_mod "Croptopia" "croptopia" "" "415438"                                 # Expanded food system
add_mod "Farmer's Delight" "farmers-delight" "farmers-delight" "398521"                   # Enhanced farming and cooking
add_mod "Cooking for Blockheads" "cooking-for-blockheads" "cooking-for-blockheads" "231484"     # Kitchen multiblocks
add_mod "AppleSkin" "appleskin" "appleskin" "248787"                                # Food/hunger info overlay
add_mod "Nether's Delight" "nethers-delight" "" "624489"                  # Nether-themed foods
add_mod "End's Delight" "ends-delight" "" "638577"                         # End-themed foods

add_mod "Reap Mod" "reap" "NYHbcKK1" "225833"                               # Right-click crop harvesting
add_mod "Snad" "snad" "" "319121"                                           # Faster cactus/sugarcane growth

echo "==> Thermal Series"
add_mod "CoFH Core" "cofh-core" "cofh-core" "69162"                                  # Thermal foundation
add_mod "Thermal Foundation" "thermal-foundation" "thermal-foundation" "222880"              # Base thermal mod
add_mod "Thermal Expansion" "thermal-expansion" "thermal-expansion" "69163"                 # Machines and processing
add_mod "Thermal Dynamics" "thermal-dynamics" "thermal-dynamics" "227443"                  # Ducts for items/energy/fluids
add_mod "Thermal Integration" "thermal-integration" "thermal-integration" "291737"            # Cross-mod integration



echo "==> Builder wands"
add_mod "Construction Wand" "construction-wand" "construction-wand" "284074"                 # Multi-block building tool

echo "==> Tinkers"
add_mod "Tinkers' Construct" "tinkers-construct" "rxIIYO6c" "74072"         # Tool crafting and customization
add_mod "Tinkers Levelling Addon" "tinkers-levelling-addon" "" "644662"    # XP progression for tools

add_mod "Torchmaster" "torchmaster" "torchmaster" "269849"                             # Torch placement and mob spawning control

echo "==> Mob synthesis (Hostile Neural Networks)"
add_mod "Placebo" "placebo" "placebo" "283644"                                     # Required library
add_mod "Hostile Neural Networks" "hostile-neural-networks" "" "377196"   # Mob data and simulation

echo "==> Draconic Evolution"
add_mod "Draconic Evolution" "draconic-evolution" "nBqivi8H" "223565"       # End-game power and tools
add_mod "Brandon's Core" "brandons-core" "brandons-core" "231382"                       # Required library

echo "==> Forestry & bee genetics"
add_mod "Forestry Community Edition" "forestry-community-edition" "2oORTOi2" "882938" # Trees and bees
add_mod "Gendustry Community Edition" "gendustry-community-edition" "2zkSGMyK" "882940" # Advanced bee breeding

echo "==> Quality of life additions"
add_mod "Default Options" "default-options" "IWe7P9UP" "232131"            # Ship default options and keybindings
add_mod "OpenLoader" "open-loader" "dWV6rGSH" "226447"                      # Automatic datapack/resource pack loading
add_mod "Paragliders" "paragliders" "esqWA0aQ" "328301"                     # Hang gliders for exploration
add_mod "mmmmmmmmmmmm" "mmmmmmmmmmmm" "mmmmmmmmmmmm" ""                   # Target dummy for combat testing
add_mod "Clean Swing Through Grass" "clean-swing-through-grass" "" "386549" # Attack through plants
add_mod "Cobble For Days" "cobblefordays" "hi71AUZ0" "351748"              # Tiered cobblestone generators
add_mod "Compact Machines" "compact-machines" "" "224218"                  # Pocket dimension rooms
add_mod "Easy Villagers" "easy-villagers" "easy-villagers" "400514"                     # Portable villager management
add_mod "Easy Piglins" "easy-piglins" "easy-piglins" "398578"                          # Portable piglin bartering
add_mod "FindMe" "findme" "rEuzehyH" "291936"                               # Highlight items in chests
add_mod "FTB Backups 2" "ftb-backups-2" "" "309674"                        # Automatic world backups

echo "==> FTB Teams + Chunkloading"
add_mod "Architectury API" "architectury-api" "architectury-api" "419699"                   # Cross-platform mod library
add_mod "FTB Library" "ftb-library-forge" "" "404465"                      # Core FTB functionality
add_mod "FTB Teams" "ftb-teams-forge" "" "404468"                          # Team management system
add_mod "FTB Chunks" "ftb-chunks-forge" "" "314906"                        # Chunk claiming and loading
add_mod "FTB Essentials" "ftb-essentials" "" "386134"                      # Home/TPA commands

echo "==> Additional utilities"
add_mod "Light Overlay" "light-overlay" "YfOlc91N" "325492"                 # Mob spawn light level overlay
add_mod "Modular Routers" "modular-routers" "EuTS81Z3" "250294"            # Item routing and automation
add_mod "Elevator Mod" "elevatormod" "hi2dSXTu" "250832"                   # Multi-floor elevators
add_mod "Pylons" "pylons" "pylons" "219758"                                       # Wireless item transfer

echo "==> Powah (Power system)"
add_mod "Powah Rearchitected" "powah-rearchitected" "powah" "440979"             # Energy generation and storage
add_mod "Cloth Config API" "cloth-config" "cloth-config" "348521"                      # Configuration library
add_mod "GuideMe" "guideme" "Ck4E7v7R" "457134"                             # In-game guide system

echo "==> Utility systems"
add_mod "SuperMartijn642's Core Lib" "supermartijn642s-core-lib" "rOUBggPv" "454372" # Library
add_mod "Trash Cans" "trash-cans" "4QrnfueM" "283995"                       # Disposal for items/fluids/energy
add_mod "The Afterdark" "the-afterdark" "EjqfdsbN" "502372"                # Night-focused content
add_mod "Controlling" "controlling" "xv94TkTM" "250398"                    # Keybind conflict management

echo "==> Core technology mods"
add_mod "Crafting Station" "crafting-station" "25IAE8wS" "272407"           # Extended crafting table
add_mod "Applied Energistics 2" "ae2" "XxWD5pD3" "223794"                 # Digital storage and autocrafting
add_mod "Cyclic" "cyclic" "cyclic" "239286"                                       # Utility blocks and tools

echo "==> Botany and Create"
add_mod "Botany Pots" "botany-pots" "U6BUTZ7K" "400975"                     # Compact crop growing
add_mod "Botany Trees" "botany-trees" "mvs7RoIW" "577420"                  # Tree growing in pots
add_mod "Create" "create" "create" "328085"                                         # Mechanical contraptions
add_mod "Create Ore Excavation" "create-ore-excavation" "" "724426"       # Large-scale mining

echo "==> Specialized crops and storage"
add_mod "Ender Crop" "ender-crop" "" "455826"                              # Teleporting crop items
add_mod "Spice of Life: Carrot Edition" "spice-of-life-carrot-edition" "" "277616" # Food variety rewards
add_mod "Inventory Sorter" "inventory-sorter" "" "327266"                 # Auto-sorting inventory
add_mod "Pipez" "pipez" "iRmWy6ga" "443900"                                 # Simple item/fluid/energy pipes
add_mod "AllTheCompressed" "allthecompressed" "" "317269"                 # Compressed storage blocks

echo "==> Gravestones"
add_mod "Gravestone Mod" "gravestone" "RYtXKJPr" "238551"                   # Death recovery system

echo "==> Reactors"
add_mod "ZeroCore 2" "zerocore" "" "267602"                                # Multiblock reactor library
add_mod "Extreme Reactors" "extreme-reactors" "" "250277"                  # Big Reactors successor

echo "==> Mining QoL"
add_mod "FTB Library" "ftb-library-forge" "" "404465"                      # Library (duplicate)
add_mod "FTB Ultimine" "ftb-ultimine-forge" "" "386135"                   # Veinmining functionality

echo "==> Shaders / renderer"
add_mod "Oculus" "oculus" "oculus" "581495"                                       # Shader support for Forge
add_mod "Embeddium" "embeddium" "embeddium" "908741"                                # Performance renderer (NOT Rubidium)

echo "==> Refresh index"
$PW refresh

echo "==> Export Modrinth pack (.mrpack)"
$PW modrinth export --output "$MRPACK" --restrictDomains=false

echo
echo "==> Done."
echo "Import '$MRPACK' in PolyMC/Prism: Add Instance -> Import from zip (select the .mrpack)."
