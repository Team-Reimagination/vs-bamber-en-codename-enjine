function onNoteCreation(e)
	e.noteSprite = "game/notes/test footage";
function onStrumCreation(e)
	e.sprite = "game/notes/test footage";
introLength = 1;

function postCreate(){
	camHUD.bgColor = FlxColor.BLACK;
	canPause = iconP1.visible = iconP2.visible = accuracyTxt.visible = missesTxt.visible = scoreTxt.visible = camZooming = FlxG.mouse.cursor.visible = false;
	insert(0, huh = new FlxSprite().makeGraphic(75, 75).screenCenter());
	var textThing = (FlxG.random.bool((1/4000) * 100) ? "bamber_" : "") + "test_video_" + FlxG.random.int(0, 99) + [".mp4", ".webm", ".mov"][FlxG.random.int(0, 2)];
	add(text = new FlxText(5, 690, 0, textThing).setFormat(null, 20));
	huh.camera = text.camera = camHUD;
	camHUD.addShader(jpeg = new CustomShader("scanLines"));
}

function update()
	camHUD.zoom = 1;

function onPlayerMiss(e)
	e.playMissSound = false;

function onCountdown(e)
	e.cancel();

function onNoteHit(e)
	e.showSplash = false;

function stepHit(curStep:Int){
	if(curStep == 368){
		// cool shit
	}
}