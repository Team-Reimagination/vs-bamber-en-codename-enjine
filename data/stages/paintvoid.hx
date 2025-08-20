import funkin.backend.utils.ShaderResizeFix;
import funkin.backend.system.framerate.Framerate;

var allowLeave:Bool = true;
var time:Float = 0;

var chromaticaAbber:Float = 0.001;
var tempBeat:Int = 0;

var shader = new CustomShader("old tv");
var bloom = new CustomShader("bloom");

function create(){
    FlxG.resizeWindow(FlxG.stage.window.height/3*4,FlxG.stage.window.height);
	FlxG.resizeGame(1280,960);
	FlxG.scaleMode.width = FlxG.camera.width = 1280;
	FlxG.scaleMode.height = FlxG.camera.height = 960;
	ShaderResizeFix.doResizeFix = true;
	ShaderResizeFix.fixSpritesShadersSizes();
    FlxG.stage.window.x += (FlxG.stage.window.width - FlxG.stage.window.height/3*4) / 2;

    FlxG.game.addShader(shader);
    for(a in [camGame, camHUD])
        a.addShader(bloom);
    bloom.data.hDRthingy.value = [1.5];
}

function postCreate(){
    iconP1.setIcon("davey");
    window.title = "";
    Framerate.debugMode = camFollowLerp = camZoomingInterval = 0;
	health = 1.59;
    defaultCamZoom = 0.6;
    strumLines.members[1].characters[0].visible = FlxG.autoPause = healthBar.visible = healthBarBG.visible = false;
	for(i in [scoreTxt,missesTxt,accuracyTxt])
	i.font=Paths.font('vcr_osd.ttf');
}

function destroy() {
    if(allowLeave){
        FlxG.resizeWindow(1280, 720);
        FlxG.resizeGame(1280, 720);
	    FlxG.scaleMode.width = FlxG.camera.width = 1280;
	    FlxG.scaleMode.height = FlxG.camera.height = 720;
        window.opacity = 1;
        FlxG.stage.window.x -= (FlxG.stage.window.height/9*16 - FlxG.stage.window.width) / 2;
    } else {
        FlxG.switchState(new PlayState());
        window.alert("I'M NOT DONE WITH YOU.", "");
    }
    
    for(a in [shader])
        FlxG.game.removeShader(a);
}

function update(elapsed){
    shader.iTime = time += elapsed;
	chromaticaAbber = FlxMath.lerp(chromaticaAbber, 0.1, 0.02);
	bloom.data.chromatic.value = [chromaticaAbber];
	if (PlayState.curBeat != tempBeat)
		{
			chromaticaAbber = 1;
			tempBeat = PlayState.curBeat;
		}
	hdr = 1.5 - (misses / 40);
	bloom.data.hDRthingy.value = [hdr];
}

function postUpdate(elapsed){
	iconP2.scale.x = iconP2.scale.y = 1;
	camFollow.setPosition(strumLines.members[0].characters[0].getMidpoint().x, strumLines.members[0].characters[0].getMidpoint().y);
}

function onGameOver(e){
	e.cancel();
	if(SONG.meta.name != "Test Footage"){
		PlayState.loadSong("Test Footage", "null");
		FlxG.switchState(new PlayState());
	}
}
function onNoteHit(e){
	switch(curSong){
		case"Astray":
		e.ratingPrefix = "game/score/paintvoid/astray/";
		switch(e.rating){
			case"sick": e.rating = "sick";
			case"good": e.rating = "good";
			default: e.rating = "Bad";
		}
		case"Facsimile":
		e.ratingPrefix = "game/score/paintvoid/facsimile/";
		switch(e.rating){
			case"sick": e.rating = "Good";
			default: e.rating = "Bad";
		}
		default:
		e.ratingPrefix = "game/score/paintvoid/placeholder/";
		switch(e.rating){
			default: e.rating = "TimeBar";
			separatedScore=0;
		}
	}
}

var progressList = ['Astray', 'Facsimile', 'Placeholder', 'test footage'];
var progressindex = progressList.indexOf(PlayState.instance.SONG.meta.name);

public function creditSetup() {
	if (progressindex >= 1) {
		for (catIcons in songIcons) {
			for (icon in catIcons) {
				icon.destroy();
			}
		}
		songIcons = [];
		songTitle.angle = 0;
		songBG.alpha = 1;
	}

	if (progressindex == 1) {
		for (catText in songTexts) {
			for (i in 0...catText.length) {
				if (i == 0) {
					catText[i].angle = 0;
					catText[i].y = songTexts[0][0].y;
					catText[i].x -= 25;
					catText[0].text += "\n";
					catText[0].size -= 10;
				} else { 
					catText[0].text += catText[i].text + "\n";
				}
			}

			catText = [catText[0]];
		}
	} else if (progressindex == 2) {
		for (catText in songTexts) {
			for (field in catText) {
				field.destroy();
			}
		}
		songTexts = [];
	}
}

public function creditBehavior() {
	if (progressindex == 1) {
		creditTweens.push(FlxTween.tween(songBG, {y: songBG.y - FlxG.height}, 1));

		creditTweens.push(FlxTween.tween(songTitle, {y: songTitle.y - FlxG.height}, 1));

		for (catText in songTexts) {
			creditTweens.push(FlxTween.tween(catText[0], {y: catText[0].y - FlxG.height}, 1));
		}
		creditTweens=creditTweens;
	} else if (progressindex == 2) {
		songTitle.y -= FlxG.height;
	}

	return (progressindex == 0 ? true : 4);
}

public function creditEnding() {
	if (progressindex == 1) {
		creditTweens.push(FlxTween.tween(songBG, {y: songBG.y - FlxG.height}, 1));

		creditTweens.push(FlxTween.tween(songTitle, {y: songTitle.y - FlxG.height}, 1, {onComplete: function(tween) {
			creditsDestroy();
		}}));

		for (catText in songTexts) {
			creditTweens.push(FlxTween.tween(catText[0], {y: catText[0].y - FlxG.height}, 1));
		}
		//PlayState.scripts.setVariable('creditTweens', creditTweens);
	} else if (progressindex == 2) {
		songTitle.y -= FlxG.height;
	}
}
