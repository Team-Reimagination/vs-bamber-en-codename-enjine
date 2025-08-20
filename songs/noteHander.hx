import StringTools;

function onNoteCreation(e)
	if (e.note.extra["charId"] != null) trace(e.note.extra);

function onNoteHit(e){
	switch(e.noteType){
		case "special/beatbox" | "special/guitar" | "alt-anim":
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
		case "special/strike":
			//commited_out_cuz_it_breaks.
			/*charX = e.character.x;
			e.character.x += 750;
			FlxTween.tween(e.character, {x: charX}, 0.5, {ease: FlxEase.backIn});
			//FlxTween.tween(camFollow, {x: boyfriend.x + boyfriend.width/2}, 0.1, {ease: FlxEase.quartOut});
			*/
			
		case "special/shield":
			FlxG.sound.play(Paths.sound('battlefx/dodge'), 1);
			//commited_out_cuz_it_breaks.
			/*static var chosenDad = FlxG.random.bool(0,2);
			//strumLines.members[chosenDad ? 1 : 3].characters[0];
			trace(chosenDad);
			charX2 = strumLines.members[chosenDad ? 1 : 3].characters[0].x;
       		strumLines.members[chosenDad ? 1 : 3].characters[0].x += 200;
			FlxTween.tween(strumLines.members[chosenDad ? 1 : 3].characters[0], {x: charX2}, 0.5, {ease: FlxEase.backIn});
			*/
			
	}
}

function onPlayerMiss(e)
	if(e.noteType == "special/shield")
		health /= 3;