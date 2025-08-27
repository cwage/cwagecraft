# Tinkers' Construct Automation Testing Guide

This guide helps you test the automation fixes included in this modpack to ensure they work correctly.

## Quick Manual Test

### Setup
1. Build a small 3x3x4 smeltery with one drain and controller
2. Place a casting table next to the drain with an ingot mold
3. Put some raw iron ore into the smeltery
4. Connect a simple fluid pipe from drain to casting table
5. Connect an item pipe from casting table to a chest

### Test Procedure
1. **Normal Operation Test**:
   - Add fuel and raw iron ore to smeltery
   - Verify that iron ingots are produced and extracted properly
   - Confirm no partial ingots get stuck

2. **Partial Ingot Test** (reproducing the original issue):
   - Start with ore melting in progress
   - Quickly remove the fluid pipe connection while casting is happening
   - Check if partial ingot gets stuck (should auto-clear with our fixes)

3. **Manual Clear Test**:
   - If any partial ingots do get stuck, try sneak-right-clicking the casting table with empty hand
   - Should clear the stuck state immediately

4. **Automation Reliability Test**:
   - Set up continuous ore feeding
   - Let automation run for 10+ minutes
   - Verify no manual intervention is needed

## Automated Test Setup

### Buffer Tank Configuration
1. Place a small buffer tank between smeltery drain and casting table
2. Configure pipes with recommended settings:
   - Pipez fluid pipe: 1000mB/tick extraction rate
   - Pipez item pipe: 2-tick extraction delay
3. Test with various ore types (iron, copper, gold, etc.)

### Comparator Control Setup
1. Place comparator next to casting table
2. Use redstone to control item extraction based on comparator output
3. Verify timing prevents partial extraction

## Expected Results

### With Fixes Applied
- ✅ Casting tables auto-clear when fluid supply stops
- ✅ No partial ingots get permanently stuck
- ✅ Manual clearing works with sneak+right-click
- ✅ Buffer tanks prevent timing issues
- ✅ Comparator output works for timing control

### Configuration Verification
Check that these config files exist and have correct settings:
- `config/tconstruct-common.toml` (baseCastingTime = 35)
- `config/tconstruct-server.toml` (clearOnFluidDisconnect = true)
- `config/tconstruct-client.toml` (visual improvements)
- `config/automation-integration.toml` (mod-specific settings)

### KubeJS Script Verification
Check that these scripts are loaded:
- `kubejs/server_scripts/tinkers_automation_fix.js`
- `kubejs/client_scripts/tinkers_automation_visual.js`
- `kubejs/startup_scripts/tinkers_automation_startup.js`

Check the logs for "Tinkers Automation" messages confirming scripts loaded.

## Troubleshooting

If tests fail:
1. Check configuration files are present and correct
2. Verify KubeJS is installed and scripts are loading
3. Check game logs for any errors
4. Try manual clearing with sneak+right-click
5. Ensure buffer tanks are properly sized (≥1000mB)

## Performance Test

For large-scale automation:
1. Build multiple smelteries with automation
2. Process large quantities of different ore types simultaneously
3. Monitor for any performance issues or stuck states
4. Verify overflow protection works correctly

## Reporting Issues

If you find issues with the automation fixes:
1. Note your exact setup (pipe types, configurations, etc.)
2. Describe the specific behavior observed
3. Check if manual clearing works
4. Provide screenshots or video if possible
5. Include relevant log excerpts

The fixes should handle 99%+ of automation scenarios without manual intervention.