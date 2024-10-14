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