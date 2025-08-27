# Tinkers' Construct Smeltery Automation Guide

## Overview
This guide provides solutions for the common issue where partial ingot amounts get stuck in Tinkers' Construct casting molds during automation, which can break automation systems when raw ore input runs out.

## The Problem
- **Issue**: Partial ingot amounts remain in casting molds when ore supply is exhausted
- **Result**: Casting table becomes non-functional until manually broken/replaced
- **Root Cause**: Race conditions between ore melting completion and casting completion

## Solutions Implemented

### 1. Configuration Changes
The pack includes optimized Tinkers' Construct configuration files:

- `config/tconstruct-common.toml`: Reduces casting time and improves fluid handling
- `config/tconstruct-server.toml`: Adds auto-clearing and comparator output support

**Key Configuration Features:**
- Reduced casting time (30 ticks vs default 50)
- Auto-clear partial casts when fluid supply is insufficient  
- Enhanced comparator output for automation timing
- Minimum fluid amount requirements to prevent partial sticking

### 2. Recommended Automation Setup

#### Basic Setup (Using Pipez)
```
Smeltery Controller
    ↓
Smeltery Drain (with Fluid Pipe)
    ↓
Casting Table + Ingot Mold
    ↓
Item Pipe (with 1-2 tick delay)
```

#### Advanced Setup (Using Thermal Dynamics)
```
Smeltery Controller
    ↓
Smeltery Drain (Fluiduct with Servo)
    ↓
Buffer Tank (prevents partial extractions)
    ↓
Casting Table + Ingot Mold
    ↓
Itemduct with Retriever (comparator-controlled)
```

### 3. Automation Best Practices

#### Timing Configuration
1. **Use Buffer Tanks**: Place a small fluid tank between smeltery and casting tables
2. **Add Delays**: Configure 1-2 tick delays in item extraction systems
3. **Comparator Control**: Use comparator output from casting tables to control item extraction

#### Recommended Pipe Settings
- **Pipez Fluid Pipes**: Set extraction rate to 1000mb/tick or less
- **Pipez Item Pipes**: Add 1-2 tick extraction delay
- **Thermal Dynamics**: Use servos with stack size limiting
- **Industrial Foregoing**: Use Fluid Extractors with upgrade limitations

#### Fail-Safe Systems
1. **Overflow Protection**: Add void upgrades to prevent backup
2. **Reset Mechanisms**: Include ways to break/replace casting tables automatically
3. **Monitoring**: Use comparator outputs to detect stuck states

### 4. Troubleshooting

#### If Casting Tables Get Stuck:
1. Break and replace the casting table
2. Check fluid pipe connections
3. Verify mold is properly placed
4. Check for partial fluid amounts in pipes

#### Prevention:
1. Always use buffer tanks in automation
2. Set conservative extraction rates
3. Use comparator-controlled extraction
4. Monitor fluid levels regularly

### 5. Compatible Automation Mods

The following mods in the pack work well with Tinkers automation:
- **Pipez**: Simple, reliable pipes with timing control
- **Thermal Dynamics**: Advanced ducts with precise control
- **Industrial Foregoing**: Powerful automation with upgrade system
- **Modular Routers**: Flexible item routing with timing options

### 6. Advanced Tips

#### Multiple Metal Types
- Use separate casting setups for different metals
- Implement fluid filtering to prevent contamination
- Consider using Thermal's Fluid Transposer as alternative

#### Large Scale Automation
- Build multiple smaller smelteries instead of one large one
- Use dedicated casting areas for different ingot types
- Implement proper overflow and voiding systems

#### Monitoring and Maintenance
- Set up visual indicators for stuck casting tables
- Use wireless redstone for remote monitoring
- Consider backup systems for critical automation

## Configuration Files Details

### tconstruct-common.toml
- `castingTime = 30`: Faster casting reduces partial amount issues
- `clearPartialCasts = true`: Auto-clears stuck partial amounts
- `improvedFluidHandling = true`: Better automation compatibility

### tconstruct-server.toml  
- `autoClearOnDisconnect = true`: Clears casting tables when fluid stops
- `minimumCastingAmount = 144`: Prevents partial casts from starting
- `enableComparatorOutput = true`: Enables redstone automation control

## Getting Help

If you continue to experience issues:
1. Check configuration files are properly loaded
2. Verify automation timing settings
3. Test with simple manual setup first
4. Consider using alternative casting methods (Thermal Expansion, etc.)

Remember: The key to reliable Tinkers automation is proper timing and buffer systems!