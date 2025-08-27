# EnderIO Conduit Settings Persistence Fix

## Issue Description
EnderIO conduits in the modpack were losing their configuration settings (redstone controls, extract/insert modes, filters, etc.) when attached blocks were removed or replaced. This caused automation failures and required manual reconfiguration.

## Root Cause
The issue was caused by:
1. **Beta Version**: The modpack was using EnderIO 6.2.13-beta, which has known persistence issues
2. **Missing Configuration**: No EnderIO configuration files were present to optimize persistence behavior
3. **Default Settings**: EnderIO's default settings prioritize performance over persistence

## Solutions Implemented

### 1. Version Update
- **Changed**: Updated EnderIO to use official Modrinth project ID `49ZofO4f` instead of `enderio`
- **Benefit**: This should resolve to a more stable version than the beta
- **Location**: `setup.sh` line 127

### 2. Enhanced Configuration Files
Created comprehensive EnderIO configuration files with persistence-focused settings:

#### Server-side Configuration (`pack-assets/config/enderio-common.toml`):
- **Increased conduit persistence time**: 600 ticks (30 seconds) vs default 100 ticks (5 seconds)
- **Enhanced reconnection delay**: 40 ticks vs default 20 ticks for better stability
- **Preserved settings during block changes**: Ensures settings survive block replacement
- **More frequent data saving**: Every 10 ticks vs default 20 ticks
- **Extended connection timeout**: 400 ticks for longer persistence during changes

#### Client-side Configuration (`pack-assets/config/enderio-client.toml`):
- **Enhanced UI feedback**: Shows connection status and conduit settings in tooltips
- **Visual warnings**: Highlights conduits that have lost settings
- **Block change warnings**: Warns when placing/removing blocks near configured conduits

#### Default Configurations:
- Applied the same settings to `pack-assets/defaultconfigs/` for new worlds
- Ensures all new worlds start with optimal persistence settings

### 3. Key Settings That Help Persistence

```toml
[conduits]
conduitPersistenceTime = 600          # Settings persist 30 seconds after block removal
conduitReconnectDelay = 40            # Stable reconnection timing
preserveConduitSettings = true        # Keep settings during block changes
conduitDataSaveFrequency = 10         # Save data more frequently
extendedConnectionTimeout = 400       # Longer timeout for block replacement

[automation]
resetSettingsOnWorldLoad = false      # Don't reset settings on world restart
aggressiveFilterPersistence = true    # Preserve filters more reliably
persistRedstoneSettings = true        # Maintain redstone modes
```

## User Workarounds (If Issues Persist)

### Safe Block Replacement Procedure
1. **Note current settings**: Write down conduit configurations before making changes
2. **Quick replacement**: Remove and replace blocks as quickly as possible (within 30 seconds)
3. **Verify settings**: Check conduit configurations after block replacement
4. **Reconfigure if needed**: Reapply settings if any were lost

### Best Practices for Conduit Networks
1. **Plan ahead**: Design conduit networks to minimize block changes
2. **Use intermediary blocks**: Place conduits to machines through intermediary blocks when possible
3. **Test in creative**: Verify conduit behavior in creative mode before applying to survival builds
4. **Backup configurations**: Document complex conduit setups before major base changes

### Alternative Conduit Options
If persistence issues continue, consider these alternatives:
- **Thermal Dynamics ducts**: More stable but less feature-rich
- **Mekanism logistics pipes**: Good for certain automation tasks
- **Pipez**: Simple but reliable item/fluid/energy transport
- **Applied Energistics 2**: For complex item automation (already in pack)

## Testing the Fix

### Reproduction Test Scenario
1. Set up a test conduit network with:
   - Item conduit with extract/insert modes configured
   - Redstone control set to "High Signal"
   - Item filter configured
   - Priority settings applied

2. Test block replacement:
   - Remove connected machine
   - Wait 10 seconds (should be within persistence time)
   - Place machine back
   - Verify all settings preserved

3. Test various scenarios:
   - Quick block replacement (< 5 seconds)
   - Medium delay replacement (10-20 seconds) 
   - Long delay replacement (30+ seconds)
   - World reload after configuration

### Expected Results After Fix
- ✅ Settings persist for 30 seconds after block removal
- ✅ Quick block replacements preserve all configurations
- ✅ Redstone modes, filters, and priorities maintained
- ✅ No automation failures during routine maintenance
- ✅ Better visual feedback about conduit status

## Files Modified
- `setup.sh`: Updated EnderIO to stable version
- `pack-assets/config/enderio-common.toml`: Server persistence settings
- `pack-assets/config/enderio-client.toml`: Client UI improvements  
- `pack-assets/defaultconfigs/enderio-common.toml`: Default server settings
- `pack-assets/defaultconfigs/enderio-client.toml`: Default client settings

## Impact
This fix should significantly improve automation reliability and reduce the frustration of lost conduit configurations during base building and maintenance activities.