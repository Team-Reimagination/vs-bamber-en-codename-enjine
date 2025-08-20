var specialCamera:HudCamera = new HudCamera();

var motionBlures:CustomShader = new CustomShader("motions");
motionBlures.Direction = [0, 1];
motionBlures.Intensity = 0.2;

var motionBluresHUD:CustomShader = new CustomShader("motions");
motionBluresHUD.Direction = [0, 1];
motionBluresHUD.Intensity = 0.2;

specialCamera.addShader(motionBluresHUD);
//specialCamera.addShader(new CustomShader("bloom"));
specialCamera.bgColor = 0;

//Fyi this is the thing that is fucking up the notes and offsetting them.
/*
function onNoteCreation(e) {
    e.note.camera = specialCamera;
}
*/
function postCreate() {
    FlxG.cameras.add(specialCamera, false);
    FlxG.camera.addShader(motionBlures);
    specialCamera.downscroll = camHUD.downscroll;
}

var camDir = FlxPoint.get(0,0);
var intensitylerp = 0.0;
function update() {
    motionBluresHUD.iTime = Conductor.songPosition;
    motionBlures.iTime = Conductor.songPosition;
    if (camDir.x != FlxG.camera.scroll.x || camDir.y != FlxG.camera.scroll.y) {
        motionBlures.Direction = [FlxG.camera.scroll.x-camDir.x, FlxG.camera.scroll.y-camDir.y];
        intensitylerp = lerp(intensitylerp, Math.abs((FlxG.camera.scroll.x - camDir.x) / 40), 0.5);
        motionBlures.Intensity = intensitylerp;
        camDir = FlxPoint.get(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
    }
}
