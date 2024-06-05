function create() if (curSong == "coop") grass.loadGraphic(Paths.image("stages/yard/Grass_WithBamber"));

var danced = false;
function beatHit() bopper.playAnim((danced = !danced) ? "danceLeft" : "danceRight", "DANCE");

function onCameraMove(e){
	e.position.y -= (strumLines.members[curCameraTarget].characters[0].idleSuffix == "-alt" ? 200 : 0);
	defaultCamZoom = (strumLines.members[curCameraTarget].characters[0].idleSuffix == "-alt" ? 0.45 : 0.6);
}

