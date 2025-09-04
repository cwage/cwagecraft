// Ensure Cyclic recipes accept AllTheCompressed compressed cobblestone
// Covers multiple historical Cyclic item IDs and swaps them to a shared tag.

ServerEvents.tags('item', event => {
  // Canonical tags for 1x compressed cobblestone used by mods
  const TAG_COMPRESSED = (global && global.CW_TAGS && global.CW_TAGS.COMPRESSED_COBBLE_1X) || 'forge:compressed/cobblestone_1x'
  const TAG_STORAGE = (global && global.CW_TAGS && global.CW_TAGS.STORAGE_COBBLE) || 'forge:storage_blocks/cobblestone'

  // Add the ATC 1x compressed cobblestone to both tags
  event.add(TAG_COMPRESSED, 'allthecompressed:cobblestone_1x')
  event.add(TAG_STORAGE, 'allthecompressed:cobblestone_1x')

  // Include likely Cyclic item IDs (safe even if missing)
  const CYCLIC_IDS = [
    'cyclic:compressed_cobblestone',
    'cyclic:compressed_cobble',
    'cyclic:cobblestone_1x',
  ]
  CYCLIC_IDS.forEach(id => {
    event.add(TAG_COMPRESSED, id)
    event.add(TAG_STORAGE, id)
  })
})

ServerEvents.recipes(event => {
  const TAG = '#forge:compressed/cobblestone_1x'

  // Replace any recipe input that expects Cyclic's compressed cobblestone variants
  // with the shared tag that includes AllTheCompressed equivalent.
  const CYCLIC_IDS = [
    'cyclic:compressed_cobblestone',
    'cyclic:compressed_cobble',
    'cyclic:cobblestone_1x',
  ]

  CYCLIC_IDS.forEach(id => {
    // Broadly replace everywhere to catch both Cyclic machine recipes
    // and any third-party recipes that reference the Cyclic item.
    event.replaceInput({}, id, TAG)
  })

  // Be explicit for Cyclic machines just in case
  const CYCLIC_TYPES = ['cyclic:solidifier', 'cyclic:melter', 'cyclic:crusher', 'cyclic:generator_fluid', 'cyclic:generator_item']
  CYCLIC_TYPES.forEach(t => CYCLIC_IDS.forEach(id => event.replaceInput({ type: t }, id, TAG)))

  // Bridging recipe: allow crafting Cyclic compressed cobblestone from ATC 1x
  // This ensures any hardcoded Cyclic input can be satisfied by converting ATC → Cyclic.
  event.shapeless('cyclic:compressed_cobblestone', [
    'allthecompressed:cobblestone_1x'
  ]).id('cwagecraft:bridge/atc_to_cyclic_compressed_cobble')
})
