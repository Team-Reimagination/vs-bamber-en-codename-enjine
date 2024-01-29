import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.scripting.ModState;
import Type;

var stateQuotes:Map<String, String> = [
    "SplashScreen" => "Team Reimagination Splash Screen",
    "FirstTimeState" => "First Time Setup",
    "BNDMenu" => "In The Menus"
];

function postStateSwitch() {
    if (stateQuotes[ModState.lastName] != null && Type.getClassName(Type.getClass(FlxG.state)) == 'funkin.backend.scripting.ModState') {
        WindowUtils.set_winTitle(stateQuotes[ModState.lastName]);
        DiscordUtil.changePresence(stateQuotes[ModState.lastName], null);
    }
}

function preStateSwitch() { //Switch to where it was meant to be
    if (Type.getClassName(Type.getClass(FlxG.game._requestedState)) == "funkin.menus.TitleState") FlxG.game._requestedState = new ModState("SplashScreen");
}

function update(elapsed) {
    if (FlxG.keys.justPressed.F5) //DEV: Restarting states
        FlxG.resetState();
}

public static function getVolume(initValue = 1, type = 'sfx') {
    return initValue * switch (type) { case 'music': FlxG.save.data.musicVolume; case 'sfx': FlxG.save.data.sfxVolume; default: FlxG.save.data.voiceVolume;};
}