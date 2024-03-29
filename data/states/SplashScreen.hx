import funkin.game.cutscenes.VideoCutscene;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.WindowUtils;
import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.MusicBeatState;

WindowUtils.set_prefix('Bamber & Davey Vol. 2.5 | ');
FlxG.save.bind('BamberAndDavey', 'TeamReimagination'); //I found out that mod options use regular saves instead of a save in the Options class for example

var splashVideo;

function create() {
    Framerate.offset.y = -999; //we do not need to see fps for this state

    splashVideo = new FlxVideoSprite();
    splashVideo.load(Assets.getPath(Paths.file('videos/TR_SplashScreen.webm')));
    splashVideo.play();
    add(splashVideo);
    splashVideo.bitmap.onEndReached.add(function() {callBack();});

    MusicBeatState.skipTransIn = true;
	MusicBeatState.skipTransOut = true;
}

function callBack() {
    splashVideo.destroy();

    FlxG.switchState(FlxG.save.data.notFirstLaunch != true ? new ModState("FirstTimeState") : new ModState('BNDMenu'));
}

function update(elapsed) {
    FlxG.mouse.visible = false;

    if ((FlxG.mouse.justPressed || controls.ACCEPT) && splashVideo.bitmap.isPlaying) splashVideo.bitmap.onEndReached.dispatch();
}