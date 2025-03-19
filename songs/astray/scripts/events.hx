//
import openfl.system.Capabilities;

function postCreate() {
    camGame.fade(FlxColor.BLACK, 0);
    camHUD.alpha = 0;
    camHUD.y = 2000;
}

function stepHit(_:Int) {
    switch (_) {
        case 0:
            camGame.fade(FlxColor.BLACK,  (Conductor.stepCrochet / 1000) * 90, true);
            FlxTween.num(0.1, 1, (Conductor.stepCrochet / 1000) * 120, {}, _ -> camGame.zoom = defaultCamZoom = _);
        case 112:
            // start glitching and distorting
        case 120 | 121 | 122 | 123 | 124 | 125 | 126 | 127:
            // flicker in and out
            camGame.visible = !camGame.visible;
            new FlxTimer().start((Conductor.stepCrochet / 2000), () -> camGame.visible = !camGame.visible);
            darkness -= 0.125;
        case 128:
            camGame.flash(FlxColor.WHITE, (Conductor.stepCrochet / 1000) * 8);
            camGame.visible = true;
            darkness = 0;
            // starts singing, ease hud in
            FlxEase.ELASTIC_AMPLITUDE = 4;
            FlxTween.tween(camHUD, {alpha: 1, y: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.elasticOut});
        case 252:
            camGame.zoom = defaultCamZoom = 1.75;
            darkness = -0.5;
            camHUD.alpha = 0;
        case 256:
            camHUD.alpha = camGame.zoom = defaultCamZoom = 1;
            darkness = 0;
        case 384 + 252:
            FlxG.resizeWindow(winWidth * 0.5, winHeight * 0.5);
            window.x = Capabilities.screenResolutionX/2 - window.width/2;
            window.y = Capabilities.screenResolutionY/2 - window.height/2;            
    }
}

function onNoteHit(e)
    e.enableCamZooming = false;