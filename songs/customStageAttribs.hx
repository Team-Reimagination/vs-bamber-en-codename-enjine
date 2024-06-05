import StringTools;

if(stage != null && stage.stageXML != null){
	// COUNTDOWN
	/*
		idk its the stage name
			if there's a folder in `game/countdown/` with the curStage name, it'll play the countdowns from there
				if there's a PNG and XML in `game/countdown/`, it'll play that instead
	*/
	var countingDown = [
		1 => "get",
		2 => "ready",
		3 => "set",
		4 => "go"
	];
	function onCountdown(e){
		e.scale *= 2;
		if(countingDown[e.swagCounter] != null)
			e.spritePath = "game/countdown/" + (Assets.exists(Paths.image("game/countdown/" + SONG.stage + "/" + countingDown[e.swagCounter])) ? SONG.stage : "default") + "/" + countingDown[e.swagCounter];
	}
	function onPostCountdown(e){
		if(countingDown[e.swagCounter] != null)
			e.spriteTween = FlxTween.tween(e.sprite, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.elasticInOut,
				onComplete: function(twn:FlxTween) {
					e.sprite.destroy();
					remove(e.sprite, true);
				}
			});
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
	function onNoteHit(e)
		e.ratingPrefix = "game/score/" + (stage.stageXML.get("scorePath") != null ? stage.stageXML.get("scorePath") : "default/");
}