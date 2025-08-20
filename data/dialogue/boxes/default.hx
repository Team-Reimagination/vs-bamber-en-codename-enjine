var defaultCamZoomer;
public var grayBG = new FlxSprite(-500).makeGraphic(1, 1, 0x6FFFFFFF);
grayBG.scale.set(3000,3000); grayBG.updateHitbox();

function popupChar(event) {
	switch(event.char.positionName){
		case"right":
		cutscene.dialogueBox.text.x=500;
		cutscene.dialogueBox.x=350;
		case"left":
		cutscene.dialogueBox.x=10;
		cutscene.dialogueBox.text.x=140;
		case"middle":
		cutscene.dialogueBox.x=200;
		cutscene.dialogueBox.text.x=340;
	}
}
var finished:Bool = false;
var __cameras:Array<FlxCamera>;
function postCreate() {
	trace(text.text);
	defaultCamZoomer = PlayState.instance.defaultCamZoom;
	for(c in cutscene.charMap) c.alpha = 0.2;

	grayBG.alpha = 0;
	grayBG.cameras = [PlayState.instance.camHUD];
	cutscene.add(grayBG);

	FlxTween.tween(grayBG, {alpha: 1}, 0.5, {startDelay: 0.5});

	//cutscene.parentDisabler.reset();
	//cutscene.parentDisabler.destroy();
	PlayState.instance.camGame.paused=false;
	FlxTween.tween(PlayState.instance.camGame, {zoom: defaultCamZoomer+0.3},1, {ease: FlxEase.backInOut});
}
function close(event) {
	if(finished) return;
    else event.cancelled = true;
    cutscene.canProceed = false;
    FlxTween.tween(grayBG, {alpha: 0}, 0.3, {startDelay: 0.2, onComplete: function (twn:FlxTween) {finished = true;
        cutscene.close();
	}});
	FlxTween.tween(PlayState.instance.camGame, {zoom: defaultCamZoomer}, 1, {ease: FlxEase.backInOut});
}
/*
function update(elapsed:Float) {
	if(dialogueEnded){trace("fjnj");}
	//trace(cutscene.curLine.char);
}
*/