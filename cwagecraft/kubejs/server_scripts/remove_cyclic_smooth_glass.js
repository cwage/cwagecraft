// Remove Cyclic smelting recipes that convert vanilla glass <-> Cyclic smooth/connected glass
// Rationale: These override EnderIO clear glass visibility/balance in JEI.

ServerEvents.recipes(event => {
  // Forward: minecraft:glass -> cyclic:glass_connected
  event.remove({ id: 'cyclic:smelting/glass' });

  // Reverse: cyclic:glass_connected -> minecraft:glass (remove to keep parity)
  event.remove({ id: 'cyclic:smelting/glass_reverse' });

  // Also remove any EnderIO Alloy Smelter recipes that output Cyclic connected glass
  // EnderIO may wrap furnace recipes as `enderio:alloy_smelting` in "Alloys & Smelting" mode
  event.remove({ type: 'enderio:alloy_smelting', output: 'cyclic:glass_connected' });

  // Belt-and-suspenders: remove any remaining recipes producing Cyclic connected glass
  event.remove({ output: 'cyclic:glass_connected' });
});
