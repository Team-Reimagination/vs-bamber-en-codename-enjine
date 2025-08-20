var songColors = [
	['Yield','Cornaholic','Harvest'] => 0xFF66F951,
	['Synthwheel','Yard','Coop'] => 0xFF5173F9,
	['Ron Be Like','Bob Be Like','Fortnite Duos'] => 0xFFF9EB51,
];
var songDialogueColor;
for (song in songColors.keys()) {
	if (song.contains(PlayState.instance.SONG.meta.name)) {
		songDialogueColor = songColors[song];
	}
}

function postCreate() {
	FlxTween.tween(dialogueBox, {"scale.y": 1 , "scale.x": 1}, 0.15, {ease: FlxEase.quartIn});

    var color = songDialogueColor;
    var colorShader = new CustomShader("ColoredNoteShader");
    colorShader.r = ((color >> 16) & 0xFF);
    colorShader.g = ((color >> 8) & 0xFF);
    colorShader.b = ((color) & 0xFF);

    dialogueBox.shader = colorShader;
}
/*
function update(elapsed:Float) {
	trace(curLine.char);
	bmaber.playAnim();
}
*/