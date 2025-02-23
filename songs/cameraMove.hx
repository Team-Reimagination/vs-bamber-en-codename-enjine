import flixel.math.FlxPoint;
import flixel.FlxObject;
var driftAmount:Int = 10;
var otherCamFollow:FlxObject = new FlxObject();
var whichStrumline:Int = 0;
var oldCamTarget;

public var cameraEasing:FlxEase = FlxEase.quartInOut;
public var cameraTime:Float = 1;
public var cameraTween;

function onCameraMove(e) {
    if (curCameraTarget != oldCamTarget && (cameraTween == null || (cameraTween != null && !cameraTween.active))) {
        FlxTween.cancelTweensOf(camFollow);
        cameraTween = FlxTween.tween(camFollow, {x: e.position.x, y: e.position.y}, cameraTime, {ease: cameraEasing});
        trace(cameraEasing);
    }

    if (cameraTween != null && cameraTween.active) {
        e.cancel();

        cameraTween._propertyInfos[0].range = e.position.x - cameraTween._propertyInfos[0].startValue; //editing the x field of a tween in real time
        cameraTween._propertyInfos[1].range = e.position.y - cameraTween._propertyInfos[1].startValue; //editing the y field of a tween in real time
    }

    oldCamTarget = curCameraTarget;
}

function postCreate() {
    FlxG.camera.follow(otherCamFollow);
    FlxG.camera.followLerp = 0.2;
}

function update(elapsed:Float) {
    otherCamFollow.setPosition(camFollow.x, camFollow.y);
    for (i in strumLines.members[whichStrumline].characters) {
        otherCamFollow.x += driftAmount * [0, 1, -1][["singRIGHT", "singLEFT"].indexOf(i=i.getAnimName())+1];
        otherCamFollow.y += driftAmount * [0, 1, -1][["singDOWN", "singUP"].indexOf(i)+1];
        FlxG.camera.angle = lerp(FlxG.camera.angle, i == "singLEFT" ? 1.3 : i == "singRIGHT" ? -1.3 : 0, 0.04);
    }
}

function onNoteHit(e) {
    if (!e.note.isSustainNote)
        whichStrumline = strumLines.members.indexOf(e.note.strumLine);
}