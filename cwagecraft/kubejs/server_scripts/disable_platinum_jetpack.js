// Disable Platinum jetpack recipes from Iron Jetpacks to avoid confusion
// Removes any recipe whose ID or output contains "platinum" in the ironjetpacks namespace.

ServerEvents.recipes(event => {
  // Remove by explicit recipe id pattern
  event.remove({ id: /ironjetpacks:.*platinum.*/ });

  // Remove by output pattern as a fallback (covers potential naming differences)
  event.remove({ output: /ironjetpacks:.*platinum.*/ });

  // Remove any recipe that uses the platinum ingot tag
  // This ensures broken platinum-dependent recipes do not appear in JEI
  event.remove({ input: '#forge:ingots/platinum' });
});
