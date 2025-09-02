// Hide Platinum jetpack and related platinum placeholders from JEI
// Helps avoid showing broken recipes/items due to missing platinum

JEIEvents.hideItems(event => {
  // Hide any Iron Jetpacks item that references platinum by id
  event.hide(/ironjetpacks:.*platinum.*/);

  // Also hide the empty platinum ingot tag placeholder if it shows up
  event.hide('#forge:ingots/platinum');
});

