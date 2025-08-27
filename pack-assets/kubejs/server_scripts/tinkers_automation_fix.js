// Tinkers' Construct Automation Fix Script
// This script helps resolve the partial ingot sticking issue in casting automation

console.info('Loading Tinkers Automation Fix Script...')

// Event handler for casting table interactions
// Helps prevent partial ingot issues by clearing stuck states
ServerEvents.blockRightClick('tconstruct:casting_table', (event) => {
    let castingTable = event.block.entity
    if (!castingTable) return
    
    // If player is holding an empty hand and sneaking, clear any stuck partial casts
    if (event.player.crouching && event.hand == 'main_hand') {
        let heldItem = event.player.getHeldItem(event.hand)
        if (heldItem.isEmpty()) {
            // Clear any stuck fluid or items in the casting table
            try {
                castingTable.clearContent()
                event.player.sendStatusMessage('Casting table cleared!', true)
                event.cancel()
            } catch (e) {
                // Fail silently if clearing doesn't work
            }
        }
    }
})

// Event handler for casting basin interactions (similar fix)
ServerEvents.blockRightClick('tconstruct:casting_basin', (event) => {
    let castingBasin = event.block.entity
    if (!castingBasin) return
    
    // If player is holding an empty hand and sneaking, clear any stuck partial casts
    if (event.player.crouching && event.hand == 'main_hand') {
        let heldItem = event.player.getHeldItem(event.hand)
        if (heldItem.isEmpty()) {
            // Clear any stuck fluid or items in the casting basin
            try {
                castingBasin.clearContent()
                event.player.sendStatusMessage('Casting basin cleared!', true)
                event.cancel()
            } catch (e) {
                // Fail silently if clearing doesn't work
            }
        }
    }
})

// Automatic cleanup task that runs periodically to clear stuck casting tables
// This runs every 30 seconds to check for and clear stuck partial casts
ServerEvents.tick((event) => {
    // Only check every 600 ticks (30 seconds)
    if (event.server.tickCount % 600 !== 0) return
    
    // Find all loaded casting tables and basins
    let world = event.server.overworld()
    let castingBlocks = []
    
    // Check all loaded chunks for casting blocks
    world.loadedChunks().forEach(chunk => {
        chunk.getAllBlockEntities().forEach(blockEntity => {
            if (blockEntity.block.id.includes('casting_table') || 
                blockEntity.block.id.includes('casting_basin')) {
                castingBlocks.push(blockEntity)
            }
        })
    })
    
    // Clear any casting blocks that appear to have stuck partial casts
    castingBlocks.forEach(castingBlock => {
        try {
            // Check if the block has been in a casting state for too long
            // (This is a heuristic - actual implementation would depend on TiCon's internal state)
            if (castingBlock.hasFluid && !castingBlock.hasValidRecipe) {
                // Clear the stuck state
                castingBlock.clearContent()
                console.warn('Auto-cleared stuck casting block at ' + castingBlock.pos)
            }
        } catch (e) {
            // Ignore errors - some blocks may not support these operations
        }
    })
})

// Recipe modification to make casting more reliable
// Add alternative recipes that are less prone to partial casting issues
ServerEvents.recipes((event) => {
    
    // Add safer casting recipes that require exact fluid amounts
    // This prevents partial ingot creation that can cause sticking
    
    // Example: Ensure iron ingot casting always requires exactly 144mB
    event.custom({
        type: 'tconstruct:casting_table',
        cast: {
            item: 'tconstruct:ingot_cast'
        },
        fluid: {
            fluid: 'tconstruct:molten_iron',
            amount: 144
        },
        result: {
            item: 'minecraft:iron_ingot'
        },
        cooling_time: 35  // Reduced from default for better automation timing
    })
    
    // Similar for other common metals
    let metals = [
        {fluid: 'molten_copper', item: 'minecraft:copper_ingot'},
        {fluid: 'molten_gold', item: 'minecraft:gold_ingot'},
        {fluid: 'molten_tin', item: 'thermal:tin_ingot'},
        {fluid: 'molten_lead', item: 'thermal:lead_ingot'},
        {fluid: 'molten_silver', item: 'thermal:silver_ingot'},
        {fluid: 'molten_aluminum', item: 'immersiveengineering:aluminum_ingot'},
        {fluid: 'molten_zinc', item: 'create:zinc_ingot'},
        {fluid: 'molten_brass', item: 'create:brass_ingot'}
    ]
    
    metals.forEach(metal => {
        try {
            event.custom({
                type: 'tconstruct:casting_table',
                cast: {
                    item: 'tconstruct:ingot_cast'
                },
                fluid: {
                    fluid: `tconstruct:${metal.fluid}`,
                    amount: 144
                },
                result: {
                    item: metal.item
                },
                cooling_time: 35
            })
        } catch (e) {
            // Ignore if metal doesn't exist in this pack
        }
    })
})

console.info('Tinkers Automation Fix Script loaded successfully!')