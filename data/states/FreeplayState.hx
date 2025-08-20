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

function onChangeSelection(){
    //Still_don't_know_why_i_have_to_add_this_junk_to_just_have_it_do_this_ON_change_select.
    FlxTween.tween(scoreText,{y: 0},0.00000000000000001,{onComplete:function(twn:FlxTween){
    WindowUtils.set_winTitle("Freeplay Menu | Currently Selecting: " + songs[curSelected].name);
    }});
}