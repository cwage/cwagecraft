# KubeJS Scripts for CwageCraft

This directory contains server-side KubeJS scripts that enhance the modpack experience.

## Auto-Profiling Script (jeargh_autoprofile.js)

This script automatically generates JER (Just Enough Resources) ore distribution graphs on first world load.

### How it works:
1. When a new world loads for the first time, the script detects this via server persistent data
2. It runs the JEARGH profiling command (`jeargh start 10`) after a 1-second delay
3. JEARGH generates `config/jeresources/world-gen.json` with ore distribution data
4. The script marks the world as profiled to prevent re-running
5. Players are notified via chat that profiling is complete

### Result:
- JER ore graphs will automatically appear for all modded ores without manual intervention
- Graphs appear after `/reload` or rejoining the world
- No repeated profiling on subsequent loads

### Files created:
- `config/jeresources/world-gen.json` - Contains ore distribution data for JER

### Testing:
1. Create a new world
2. Wait for the yellow chat message: "[JER] Profiling ore gen... graphs appear after /reload or rejoin."
3. Run `/reload` or rejoin the world
4. Open JEI on any ore (e.g., Immersive Engineering Silver) and check for the ore distribution graph tab