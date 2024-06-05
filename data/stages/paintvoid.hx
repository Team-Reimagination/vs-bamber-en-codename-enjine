import funkin.backend.utils.ShaderResizeFix;
import funkin.backend.system.framerate.Framerate;

var allowLeave:Bool = true;

function create(){
    FlxG.resizeWindow(FlxG.stage.window.height/3*4,FlxG.stage.window.height);
	FlxG.resizeGame(FlxG.stage.window.height/3*4,FlxG.stage.window.height);
	FlxG.scaleMode.width = FlxG.camera.width = FlxG.stage.window.height/3*4;
	FlxG.scaleMode.height = FlxG.camera.height = FlxG.stage.window.height;
	ShaderResizeFix.doResizeFix = true;
	ShaderResizeFix.fixSpritesShadersSizes();
    FlxG.stage.window.x += (FlxG.stage.window.width - FlxG.stage.window.height/3*4) / 2;
}

function postCreate(){
    iconP1.setIcon("davey");
    window.title = "";
    Framerate.debugMode = camFollowLerp = camZoomingInterval = 0;
	health = 1.59;
    window.borderless = true;
    defaultCamZoom = 0.6;
    strumLines.members[1].characters[0].visible = window.resizable = FlxG.autoPause = healthBar.visible = healthBarBG.visible = false;
}

function destroy() {
    if(allowLeave){
        FlxG.resizeWindow(1280, 720);
        FlxG.resizeGame(1280, 720);
	FlxG.scaleMode.width = FlxG.camera.width = 1280;
	FlxG.scaleMode.height = FlxG.camera.height = 720;
        window.borderless = false;
        window.opacity = 1;
        FlxG.stage.window.x -= (FlxG.stage.window.height/9*16 - FlxG.stage.window.width) / 2;
    } else {
        FlxG.switchState(new PlayState());
        window.alert("I'M NOT DONE WITH YOU.", "");
    }
}

function postUpdate(){
	iconP2.scale.x = iconP2.scale.y = 1;
	camFollow.setPosition(dad.x, dad.y);
}

function onGameOver(e){
	e.cancel();
	if(SONG.meta.name != "Test Footage"){
		PlayState.loadSong("Test Footage", "");
		FlxG.switchState(new PlayState());
	}
}