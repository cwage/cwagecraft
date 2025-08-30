// Auto-profile JER ore gen once per world using JEARGH.
// Writes config/jeresources/world-gen.json, then never runs again.

const GEN_PATH = 'config/jeresources/world-gen.json';

// Fires when the server (SP world) finishes loading data.
ServerEvents.loaded(event => {
  // Only run once per world (persists across reloads/sessions).
  if (event.server.persistentData.jerProfiled) return;

  // Delay a tick so everything is ready, then run the profiler.
  event.server.scheduleInTicks(20, () => {
    // Generate distributions around spawn; tweak sample size as needed.
    event.server.runCommandSilent('jeargh start 10');

    // Mark as done and notify the player.
    event.server.persistentData.jerProfiled = true;
    event.server.runCommandSilent(
      `tellraw @a {"text":"[JER] Profiling ore gen... graphs appear after /reload or rejoin.","color":"yellow"}`
    );
  });
});