var glassthing:FlxSprite = new FlxSprite();
function postCreate() {
    glassthing.frames = Paths.getFrames("gallery/official/glass");
    glassthing.animation.addByPrefix("idle", "frame_", 30, false);
    glassthing.camera = camHUD;
    glassthing.setGraphicSize(1280, 720);
    glassthing.screenCenter();
    glassthing.animation.play("idle");
    glassthing.visible = false;
    insert(0, glassthing);
}

function beatHit(curBeat:Int){
    switch(curBeat){
        case -4:
            defaultCamZoom = 0.5;
        case 8 | 24:
            defaultCamZoom += 0.1;
        case 40 | 67:
            defaultCamZoom -= 0.1;
        case 72 | 168 | 352: 
            bop = !bop;
        case 416:
            bop = false;
            defaultCamZoom -= 0.2;
    }
}

function playGlassThing() {
    glassthing.animation.play("idle", true);
}
function toggleGlassVisibility() glassthing.visible = !glassthing.visible;