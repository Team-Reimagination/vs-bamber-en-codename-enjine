import funkin.game.cutscenes.VideoCutscene;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.WindowUtils;

WindowUtils.set_prefix('Bamber & Davey Vol. 2.5 | ');
FlxG.save.bind('BamberAndDavey', 'TeamReimagination'); //I found out that mod options use regular saves instead of a save in the Options class for example

var splashScreen;

function create() {
    Framerate.offset.y = -999; //we do not need to see fps for this state

    if (FlxG.save.data.options == null) FlxG.save.data.options = {}; //will be rewritten ONCE the mod is finished
    if (FlxG.save.data.options.musicVolume == null) FlxG.save.data.options.musicVolume = 1; 
    if (FlxG.save.data.options.sfxVolume == null) FlxG.save.data.options.sfxVolume = 1;
    if (FlxG.save.data.options.voiceVolume == null) FlxG.save.data.options.voiceVolume = 1;

    if (FlxG.save.data.gameStats == null) FlxG.save.data.gameStats = {};
    if (FlxG.save.data.gameStats.discoveries == null) FlxG.save.data.gameStats.discoveries = {
        "Bamber's Farm": false,
        "Davey's Yard": false,
        "Romania Outskirts": false
    };

    FlxG.save.flush();

    persistentDraw = false;
    //@Frakits this only plays once,,, I want it to again if you switch mods and then back into this one,,,
    openSubState(splashScreen = new VideoCutscene(Paths.file('videos/TR_SplashScreen.webm'), function() { //First Time Setup Function
        callBack();
    }));
}

function callBack() {
    skipTransIn = skipTransOut = true;

    FlxG.switchState(FlxG.save.data.notFirstLaunch != true ? new ModState("FirstTimeState") : new ModState('BNDMenu'));
}

function update(elapsed) {
    FlxG.mouse.visible = false;

    if (FlxG.mouse.justPressed && splashScreen.video.isPlaying) splashScreen.video.onEndReached.dispatch();
}