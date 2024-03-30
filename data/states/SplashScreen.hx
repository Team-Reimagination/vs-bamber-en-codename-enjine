import funkin.game.cutscenes.VideoCutscene;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.WindowUtils;
import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.MusicBeatState;

var splashVideo;
var constellation, constellationSound;

function create() {
    Framerate.offset.y = -999; //we do not need to see fps for this state

    splashVideo = new FlxVideoSprite();
    splashVideo.load(Assets.getPath(Paths.file('videos/TR_SplashScreen.webm')));
    splashVideo.play();
    add(splashVideo);
    splashVideo.bitmap.onEndReached.add(function() {callBack();});

    constellation = new FunkinSprite();
    constellation.loadSprite(Paths.image('menus/titleScreen/constellation'));

    constellation.animateAtlas.anim.addBySymbol("Constellation", "Monolith", 24, false);

    constellation.antialiasing = true;
    constellation.scale.set(0.9, 0.9); constellation.updateHitbox(); constellation.screenCenter();
    constellation.alpha = 0.0001;
    add(constellation);

    constellationSound = FlxG.sound.load(Paths.sound('titleScreen/MonolithTeaser'), getVolume(1, 'sfx'), false);

    MusicBeatState.skipTransIn = true;
	MusicBeatState.skipTransOut = true;
}

function callBack() {
    if (constellation.alpha == 0.0001) {
        splashVideo.destroy();

        constellationSound.play();
        constellation.alpha = 1;
        constellation.playAnim("Constellation", true);
    } else {
        constellationSound.stop();
        constellation.destroy();

        FlxG.switchState(FlxG.save.data.notFirstLaunch != true ? new ModState("FirstTimeState") : new ModState('BNDMenu'));
    }
}

function update(elapsed) {
    FlxG.mouse.visible = false;

    if (constellation.isAnimFinished()) callBack();

    if ((FlxG.mouse.justPressed || controls.ACCEPT)) {
        if (constellation.alpha == 0.0001) splashVideo.bitmap.onEndReached.dispatch();
        else callBack();
    }
}