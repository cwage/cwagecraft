// Ensure Draconic Evolution's Fusion Crafting category is visible in JEI
// and log the available category ids once so we can sanity-check in logs/kubejs/client.txt
JEIEvents.removeCategories(event => {
  // Just logging – DON'T remove anything here
  console.log('[cwagecraft] JEI categories:', event.categoryIds)
  // If some other mod hides fusion crafting, you could unhide by NOT removing it.
  // Category id we care about is typically 'draconicevolution:fusion_crafting'.
})

// Optional: add a tiny "info" blurb to Chaotic gear entries so players know it's fusion-only.
// (Safe no-op if DA renames anything; wrap in try blocks to avoid startup hard-fails.)
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
    try { event.add(id, lines) } catch (_) {}
  })
})