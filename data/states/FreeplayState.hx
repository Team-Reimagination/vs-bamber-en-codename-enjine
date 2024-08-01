import funkin.backend.utils.WindowUtils;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;

function postCreate(){
    // Text rescaling
    FlxG.cameras.add(newCam = new FlxCamera(), false);
    newCam.zoom = 0.8;
    newCam.bgColor = 0;
    newCam.x -= 150;
    for (num => a in [grpSongs.members, iconArray])
        for(b in a)
            b.cameras = [newCam];
}

function onChangeSelection()
    WindowUtils.set_winTitle("Freeplay Menu | Currently Selecting: " + songs[curSelected].name);