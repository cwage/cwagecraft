// Tinkers' Construct Automation Visual Helper Script
// This script provides better visual feedback for casting automation

console.info('Loading Tinkers Automation Visual Helper Script...')

// Add tooltip information for casting tables and basins
ClientEvents.blockHighlight((event) => {
    let block = event.block
    
    // Add helpful tooltips for casting blocks
    if (block.id.includes('casting_table') || block.id.includes('casting_basin')) {
        let lines = []
        
        lines.push('§6Tinkers Casting Block')
        lines.push('§7Right-click while sneaking with empty hand to clear stuck casts')
        lines.push('§7Use buffer tanks and timing delays in automation')
        lines.push('§7Check pack documentation for automation setup guide')
        
        event.tooltip.add(lines)
    }
    
    // Add tooltips for smeltery components
    if (block.id.includes('smeltery_controller')) {
        let lines = []
        
        lines.push('§6Smeltery Controller')
        lines.push('§7For reliable automation:')
        lines.push('§7• Use conservative extraction rates')
        lines.push('§7• Add buffer tanks between smeltery and casting')
        lines.push('§7• Use comparator outputs for timing')
        
        event.tooltip.add(lines)
    }
    
    if (block.id.includes('smeltery_drain')) {
        let lines = []
        
        lines.push('§6Smeltery Drain')
        lines.push('§7Automation tips:')
        lines.push('§7• Extract at 1000mB/tick or less')
        lines.push('§7• Use servo/retriever controls')
        lines.push('§7• Add delays to prevent partial extraction')
        
        event.tooltip.add(lines)
    }
})

// Visual indicators for automation-related items in JEI
ClientEvents.jeiInformationEvent((event) => {
    // Add JEI information for casting-related items
    event.addInformation('tconstruct:casting_table', [
        'Automated Casting Tips:',
        '• Use buffer tanks to prevent partial ingots',
        '• Add 2-tick delays in item extraction',
        '• Use comparator outputs for timing control',
        '• Right-click while sneaking to clear stuck casts',
        '',
        'See pack documentation for full automation guide'
    ])
    
    event.addInformation('tconstruct:casting_basin', [
        'Automated Casting Tips:',
        '• Use buffer tanks to prevent partial blocks',
        '• Add 2-tick delays in item extraction',
        '• Use comparator outputs for timing control',
        '• Right-click while sneaking to clear stuck casts',
        '',
        'See pack documentation for full automation guide'
    ])
    
    event.addInformation('tconstruct:smeltery_controller', [
        'Automation Setup Guide:',
        '• Build 3x3 or 5x5 smeltery for stability',
        '• Use multiple drains for better throughput',
        '• Add buffer tanks after drains',
        '• Set conservative pipe extraction rates',
        '• Use overflow protection',
        '',
        'Check pack docs for detailed automation setups'
    ])
    
    // Add information for common automation items
    event.addInformation('pipez:item_pipe', [
        'Tinkers Automation Settings:',
        '• Set extraction delay to 2 ticks',
        '• Limit stack size to 64',
        '• Use filtering to prevent unwanted items'
    ])
    
    event.addInformation('pipez:fluid_pipe', [
        'Tinkers Automation Settings:',
        '• Set extraction rate to 1000mB/tick or less',
        '• Use buffer tanks to smooth flow',
        '• Avoid extracting partial amounts'
    ])
    
    // Add information for thermal dynamics
    event.addInformation('thermal:fluid_duct', [
        'Tinkers Integration:',
        '• Use servos with stack size limiting',
        '• Configure round-robin mode for multiple outputs',
        '• Add retriever controls on output side'
    ])
    
    event.addInformation('thermal:item_duct', [
        'Tinkers Integration:',
        '• Use retrievers with whitelist filtering',
        '• Set stack size limits appropriately',
        '• Use intelligent insertion mode'
    ])
})

console.info('Tinkers Automation Visual Helper Script loaded successfully!')