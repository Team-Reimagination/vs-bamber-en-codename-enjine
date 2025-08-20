import flixel.addons.display.FlxBackdrop;

function create(){
	if (curSong == "Coop")
		grass.loadGraphic(Paths.image("stages/yard/Grass_WithBamber"));
	insert(members.indexOf(hill), balloons = new FlxBackdrop(Paths.image("stages/yard/scrollingBG"), FlxAxes.X));
	balloons.setPosition(-600, -100);
	balloons.scrollFactor.x = balloons.scrollFactor.y = 0.2;
}

var danced = false;
function beatHit()
	bopper.playAnim((danced = !danced) ? "danceLeft" : "danceRight", "DANCE");

function update(elapsed:Float)
	balloons.x = Conductor.songPosition/50;


function onCameraMove(e){
	e.position.y -= (strumLines.members[curCameraTarget].characters[0].idleSuffix == "-alt" ? 200 : 0);
	defaultCamZoom = (strumLines.members[curCameraTarget].characters[0].idleSuffix == "-alt" ? 0.45 : 0.6);
}

