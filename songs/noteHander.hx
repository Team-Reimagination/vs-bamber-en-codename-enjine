import StringTools;

function onNoteCreation(e)
	if (e.note.extra["charId"] != null) trace(e.note.extra);

function onNoteHit(e){
	switch(e.noteType){
		case "special/beatbox" | "special/guitar":
			e.animSuffix = "-alt";
		case "special/phone":
			e.cancelAnim();
			e.character.playAnim("break", true);
			for(num => a in [camGame, camHUD]){
				a.zoom += 0.05;
				FlxTween.cancelTweensOf(a);
				a.angle = Std.int(Conductor.songPosition) % 2 == 0 ? (a == 0 ? -1 : 1) : (a == 0 ? 1 : -1);
				FlxTween.tween(a, {angle: 0}, 0.25);
			}
	}
}

function onPlayerMiss(e)
	if(e.noteType == "special/shield")
		health /= 3;