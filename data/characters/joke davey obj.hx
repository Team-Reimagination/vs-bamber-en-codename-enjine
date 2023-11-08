var alt:Bool;
function onPlayAnim(e) {
    if(FlxG.random.int(1, 13) == 7){alt = true;} else {alt = false;}
    if(e.animName != "idle" && alt == true) e.animName = e.animName + "-ALT";
}