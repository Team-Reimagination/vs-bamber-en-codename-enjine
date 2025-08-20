import StringTools;

var countdownSprite = new FlxSprite();


if(stage != null && stage.stageXML != null){
	// COUNTDOWN
	/*
		idk its the stage name
			if there's a folder in `game/countdown/` with the curStage name, it'll play the countdowns from there
				if there's a PNG and XML in `game/countdown/`, it'll play that instead
	*/
	function postCreate() {
	if(Assets.exists(Paths.image("game/countdown/" + stage.stageXML.get("countdown") + "/countdown"))){
	countdownSprite.frames = Paths.getSparrowAtlas("game/countdown/" + stage.stageXML.get("countdown") + "/countdown");
	countdownSprite.animation.addByPrefix("0", "Three", 24, false);
	countdownSprite.animation.addByPrefix("1", "Two", 24, false);
	countdownSprite.animation.addByPrefix("2", "One", 24, false);
	countdownSprite.animation.addByPrefix("3", "Go", 24, false);

	countdownSprite.cameras = [camHUD];
	//countdownSprite.scale.set(coutndownScale, coutndownScale);
	countdownSprite.updateHitbox();
	countdownSprite.screenCenter();
	insert(9, countdownSprite);
	countdownSprite.alpha = 0;
	}
	}
	var countingDown = [
		0 => "get",
		1 => "ready",
		2 => "set",
		3 => "go"
	];
	function onCountdown(e){
		e.scale *= 2;
		if(countingDown[e.swagCounter] != null){
			if(Assets.exists(Paths.image("game/countdown/" + stage.stageXML.get("countdown") + "/countdown"))){
			countdownSprite.alpha = 1;
				countdownSprite.animation.play(Std.string(e.swagCounter), true);}
			else
			e.spritePath = "game/countdown/" + (Assets.exists(Paths.image("game/countdown/" + SONG.stage + "/" + countingDown[e.swagCounter])) ? SONG.stage : "default") + "/" + countingDown[e.swagCounter];
			e.soundPath ="countdowns/" + (Assets.exists(Paths.sound("countdowns/"+PlayState.instance.SONG.meta.countdownsound  + "/" +countingDown[e.swagCounter]))? PlayState.instance.SONG.meta.countdownsound : "funkin") + "/" + countingDown[e.swagCounter];
			
		}
	}
	function onPostCountdown(e){
		if(countingDown[e.swagCounter] != null){
			if(!Assets.exists(Paths.image("game/countdown/" + stage.stageXML.get("countdown") + "/countdown"))){
				e.sprite.camera=camHUD;
			e.spriteTween = FlxTween.tween(e.sprite, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.elasticInOut});
			}else if(e.swagCounter <=3&&e.swagCounter >=1){e.sprite.visible=false;}}else{
				FlxTween.tween(countdownSprite, {alpha: 0}, 1, {
				ease: FlxEase.cubeInOut});}
	}
				
	// NOTESKINS
	/*
		The name of the noteskin .PNG and .XML in `images/game/notes/`.
	*/
	function onStrumCreation(e)
		e.sprite = "game/notes/" + (stage.stageXML.get("noteSkin") != null ? stage.stageXML.get("noteSkin") : "default");

	function onNoteCreation(e)
		if(!StringTools.startsWith(e.noteType, "special/") && stage.stageXML.get("noteSkin") != null) e.noteSprite = "game/notes/" + stage.stageXML.get("noteSkin");
	
	// SCORE
	/*
		Folder path for the score images in `images/game/score/`.
		Must end with a / in the stage XML attribute.
	*/
	function onNoteHit(e){
		//trace(e.rating);
		e.ratingPrefix = "game/score/" + (stage.stageXML.get("scorePath")!= null ? stage.stageXML.get("scorePath") : "default/");
	}
}