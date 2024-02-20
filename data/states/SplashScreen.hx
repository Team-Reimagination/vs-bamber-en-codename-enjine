import funkin.game.cutscenes.VideoCutscene;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.WindowUtils;

WindowUtils.set_prefix('Bamber & Davey Vol. 2.5 | ');
FlxG.save.bind('BamberAndDavey', 'TeamReimagination'); //I found out that mod options use regular saves instead of a save in the Options class for example

function create() {
    Framerate.offset.y = -999; //we do not need to see fps for this state

    if (FlxG.save.data.musicVolume == null) { //some save shenanigans
        FlxG.save.data.musicVolume = 1;
        FlxG.save.data.sfxVolume = 1;
        FlxG.save.data.voiceVolume = 1;

        FlxG.save.flush();
    }

    persistentDraw = false;
    //@Frakits this only plays once,,, I want it to again if you switch mods and then back into this one,,,
    openSubState(new VideoCutscene(Paths.file('videos/TR_SplashScreen.webm'), function() { //First Time Setup Function
        skipTransIn = skipTransOut = true;

        FlxG.switchState(FlxG.save.data.notFirstLaunch != true ? new ModState("FirstTimeState") : new ModState('BNDMenu'));
    }));
}