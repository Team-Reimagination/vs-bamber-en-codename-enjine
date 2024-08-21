import flixel.math.FlxPoint;
import flixel.FlxObject;
var driftAmount:Int = 30;
var otherCamFollow:FlxObject = new FlxObject();
var whichStrumline:Int = 0;
var oldCamTarget;
var oldCamPos:FlxObject = new FlxObject();

public var cameraEasing:FlxEase = FlxEase.quartInOut;
public var cameraTime:Float = 1;
public var cameraTween;

//var someTween;
function onCameraMove(e) {
    if (curCameraTarget != oldCamTarget && (cameraTween == null || (cameraTween != null && !cameraTween.active))) {
        FlxTween.cancelTweensOf(camFollow);
        cameraTween = FlxTween.tween(camFollow, {x: e.position.x, y: e.position.y}, cameraTime, {ease: cameraEasing});

        //someTween = FlxTween.tween(bf.scale, {x: (curCameraTarget == 0 ? 1.5 : 0.5)}, cameraTime, {ease: cameraEasing});

        oldCamPos.setPosition(camFollow.x, camFollow.y);
        tweenTimer = tweenPercent = elapsedTimer = 0;
        trace(cameraEasing);
    }

    if (cameraTween != null && cameraTween.active) { 
        e.cancel();

        cameraTween._propertyInfos[0].range = e.position.x - oldCamPos.x; //editing the x field of a tween in real time
        cameraTween._propertyInfos[1].range = e.position.y - oldCamPos.y; //editing the y field of a tween in real time
    }

    oldCamTarget = curCameraTarget;
}

function postCreate() {
    oldCamPos.setPosition(camFollow.x, camFollow.y);
    FlxG.camera.follow(otherCamFollow);
    FlxG.camera.followLerp = 0.1;
}

var elapsedTimer = 0;
var tweenTimer = 0;
var tweenPercent = 0;
function update(elapsed:Float) {
    //elapsedTimer += elapsed;

    //if (elapsedTimer >= 1/6) {
    //    elapsedTimer -= 1/6;
    //    tweenTimer += 1/6;

    //    if (someTween != null && someTween.active) tweenPercent = someTween.percent;
    //}

    //if (someTween != null && someTween.active) {
    //    someTween.percent = tweenPercent;
    //    someTween._secondsSinceStart = tweenTimer;
    //}


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
