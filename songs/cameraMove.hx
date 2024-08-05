import flixel.math.FlxPoint;
import flixel.FlxObject;
var oldPosition:FlxPoint = FlxPoint.get();
var driftAmount:Int = 30;
var otherCamFollow:FlxObject = new FlxObject();
var whichStrumline:Int = 0;

public var cameraEasing:FlxEase = FlxEase.quartInOut;
public var cameraTime:Float = 1;
function onCameraMove(e) {
    e.cancel();
    if (oldPosition.x != e.position.x || oldPosition.y != e.position.y) {
       FlxTween.cancelTweensOf(camFollow);
       FlxTween.tween(camFollow, {x: e.position.x, y: e.position.y}, cameraTime, {ease: cameraEasing});
       oldPosition = FlxPoint.get(e.position.x, e.position.y);
       trace(cameraEasing);
    }
}

function postCreate() {
    FlxG.camera.follow(otherCamFollow);
    FlxG.camera.followLerp = 0.1;
}

function update(elapsed:Float) {
    otherCamFollow.setPosition(camFollow.x, camFollow.y);
    for (i in strumLines.members[whichStrumline].characters) {
        otherCamFollow.x += driftAmount * [0, 1, -1][["singRIGHT", "singLEFT"].indexOf(i=i.getAnimName())+1];
        otherCamFollow.y += driftAmount * [0, 1, -1][["singDOWN", "singUP"].indexOf(i)+1];
        FlxG.camera.angle = lerp(FlxG.camera.angle, i == "singLEFT" ? 2 : i == "singRIGHT" ? -2 : 0, 0.04);
    }
}

function onNoteHit(e) {
    if (!e.note.isSustainNote)
        whichStrumline = strumLines.members.indexOf(e.note.strumLine);
}
