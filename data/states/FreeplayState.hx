import flixel.FlxCamera;
import flixel.tweens.FlxTween;
var newCam = new FlxCamera(-150, 0);
var prevchar:String;
function postCreate(){
    // Text rescaling
    newCam.bgColor = 0;
    for (a in [grpSongs.members, iconArray]){
        for(b in a) b.cameras = [newCam];
    }
    FlxG.cameras.add(newCam, false);
    newCam.zoom = 0.8;
    // Portraits
    add(portrait = new FlxSprite(0, -50));
    portrait.scale.set(0.8, 0.8);
    portrait.antialiasing = true;
}
function postUpdate(elapsed){
    FlxG.stage.window.title = "Vs Bamber And Davey V3 | Freeplay Menu | Currently Selecting: " + songs[curSelected].name;
}