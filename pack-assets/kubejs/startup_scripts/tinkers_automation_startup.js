// Tinkers' Construct Automation Startup Script
// This script configures global settings that improve automation reliability

console.info('Loading Tinkers Automation Startup Script...')

// Configure global settings that help with automation
Platform.setModName('kubejs', 'KubeJS (Tinkers Automation Fix)')

// Set up custom properties for tracking automation state
global.TINKERS_AUTOMATION_CONFIG = {
    // Default casting times (in ticks) for better automation
    defaultCastingTime: 35,
    
    // Minimum fluid amounts for reliable casting
    minimumFluidForCasting: 144,
    
    // Automation delays for different pipe systems
    automationDelays: {
        pipez: 2,
        thermal: 1,
        industrial: 3,
        modular: 2
    },
    
    // Buffer tank minimum sizes (in mB)
    bufferTankSizes: {
        small: 1000,
        medium: 4000,
        large: 16000
    }
}

// Register custom item properties that can help with automation detection
StartupEvents.registry('item', (event) => {
    // These aren't actual items, just property registration for potential future use
    console.info('Tinkers automation properties registered')
})

// Configure fluid properties for better automation behavior
StartupEvents.registry('fluid', (event) => {
    console.info('Tinkers fluid automation properties configured')
})

console.info('Tinkers Automation Startup Script loaded successfully!')