// Log JEI categories during registration for debugging purposes
JEIEvents.registerCategories(event => {
  console.log('[cwagecraft] JEI categories:', event.categoryIds)
  // Category id we care about is typically 'draconicevolution:fusion_crafting'.
})

// Add informative tooltips to Chaotic gear entries so players know it's fusion-only.
JEIEvents.information(event => {
  const lines = [
    'Crafted via Draconic Evolution **Fusion Crafting**.',
    'Expect Awakened/Chaotic components and high RF cost.',
  ]
  ;[
    'draconicadditions:chaotic_helmet',
    'draconicadditions:chaotic_chestplate',
    'draconicadditions:chaotic_leggings',
    'draconicadditions:chaotic_boots',
  ].forEach(id => {
    try { 
      event.add(id, lines) 
    } catch (err) {
      console.warn(`[cwagecraft] Failed to add JEI info for ${id}:`, err)
    }
  })
})