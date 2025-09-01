# cwagecraft

A comprehensive Minecraft 1.20.1 Forge modpack focused on technology, magic, exploration, and quality of life improvements.

## Features

- **Technology**: Create, Applied Energistics 2, Mekanism, RFTools suite, Thermal series
- **Magic**: Botania, Tinkers' Construct, Draconic Evolution, Mystical Agriculture
- **Exploration**: Biomes O' Plenty, Advanced Mining Dimension, Iron Jetpacks
- **Storage & Automation**: Refined Storage, Industrial Foregoing, Pipez
- **Quality of Life**: JEI, Waystones, Sophisticated Backpacks, FTB suite

## Included Shader Pack

This modpack includes **Complementary Unbound r5.5.1** shader pack by Complementary Development.

- **Website**: https://www.complementary.dev/shaders/
- **License**: Custom license allowing redistribution in modpacks with attribution
- **Compatibility**: Works with Oculus + Embeddium (included in this pack)

## Installation

1. Download the `.mrpack` file from releases
2. Import into Prism Launcher, MultiMC, or similar launcher
3. Launch and enjoy!

## Development / Building

- Source of truth: run `./setup.sh` to build/export the pack. Do not use `packwiz add/remove` directly.
- Mods list lives in `mods.yaml`. By default, running `./setup.sh` will:
  - Ensure each mod listed in `mods.yaml` is present.
  - Keep existing, pinned versions (no automatic upgrades).
- To upgrade all mods to latest tracked versions, run: `./setup.sh --upgrade`.
- To bootstrap `mods.yaml` from the current pack state, run: `./setup.sh --export-mods`.

Pinning behavior: versions are effectively pinned by the generated `cwagecraft/mods/*.pw.toml` files. The `--upgrade` flag will re-resolve versions and update those pins.

## Custom Configurations

### Tinkers' Construct Early Levelling
This modpack includes a custom datapack that provides an early-game recipe for making tools improvable:
- **Recipe**: 5 Flint + Tinker Anvil → Improvable modifier
- **Purpose**: Allows tool levelling progression without requiring expensive materials
- **Location**: `config/openloader/data/tla_early_leveling/`

## Attribution

- **Complementary Unbound Shaders**: Created by Complementary Development (https://www.complementary.dev/shaders/)
- **Tinkers' Construct Slime Island Configuration**: Modified generation frequency via datapack

## License

This modpack is distributed for non-profit use only. Individual mods retain their respective licenses.
