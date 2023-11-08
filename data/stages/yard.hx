function create() if (curSong == "coop") grass.loadGraphic(Paths.image("stages/yard/Grass_WithBamber"));

var danced = false;
function beatHit() bopper.playAnim((danced = !danced) ? "danceLeft" : "danceRight", "DANCE");