import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.scripting.ModState;
import Type;
import openfl.display.BitmapData;
import openfl.utils.Assets;

var stateQuotes:Map<String, String> = [
    "SplashScreen" => "Team Reimagination Splash Screen",
    "FirstTimeState" => "First Time Setup",
    "BNDMenu" => "In The Menus"
];

var idleCursorGraphic;
var clickCursorGraphic;
var cursorName = 'default';
public var clickableObjects = [];
var isHovering = false;
var switched = false;

function new() {
    WindowUtils.set_prefix('Bamber & Davey Vol. 2.5 | ');
    FlxG.save.bind('BamberAndDavey', 'TeamReimagination'); //I found out that mod options use regular saves instead of a save in the Options class for example

    if (FlxG.save.data.options == null) FlxG.save.data.options = {};

    //MOD SPECIFIC OPTIONS, DEFAULT ONES SHOULD BE INCLUDED TOO
    //Video Options
    if (FlxG.save.data.options.resolution == null) FlxG.save.data.options.resolution = [1280, 720];
    if (FlxG.save.data.options.fullscreen == null) FlxG.save.data.options.fullscreen = false; 
    if (FlxG.save.data.options.borderless == null) FlxG.save.data.options.borderless = false;
    if (FlxG.save.data.options.brightness == null) FlxG.save.data.options.brightness = 50;
    if (FlxG.save.data.options.gamma == null) FlxG.save.data.options.gamma = 50;

    //Sound options
    //Master Volume - FlxG.volume
    if (FlxG.save.data.options.musicVolume == null) FlxG.save.data.options.musicVolume = 1; 
    if (FlxG.save.data.options.sfxVolume == null) FlxG.save.data.options.sfxVolume = 1;
    if (FlxG.save.data.options.voiceVolume == null) FlxG.save.data.options.voiceVolume = 1;
    if (FlxG.save.data.options.missSounds == null) FlxG.save.data.options.missSounds = true;
    if (FlxG.save.data.options.copyrightBypass == null) FlxG.save.data.options.copyrightBypass = false;
    if (FlxG.save.data.options.subtitles == null) FlxG.save.data.options.subtitles = true;

    //Appearance Options
    if (FlxG.save.data.options.flashingLights == null) FlxG.save.data.options.flashingLights = true;
    if (FlxG.save.data.options.shaders == null) FlxG.save.data.options.shaders = 'all';
    if (FlxG.save.data.options.botplayUI == null) FlxG.save.data.options.botplayUI = true;
    if (FlxG.save.data.options.bgBlur == null) FlxG.save.data.options.bgBlur = 0;
    if (FlxG.save.data.options.bgDim == null) FlxG.save.data.options.bgDim = 0;
    if (FlxG.save.data.options.rapidCam == null) FlxG.save.data.options.rapidCam = true;
    if (FlxG.save.data.options.breakTime == null) FlxG.save.data.options.breakTime = true;
    if (FlxG.save.data.options.timeBar == null) FlxG.save.data.options.timeBar = true;
    if (FlxG.save.data.options.comboPosPercent == 0) FlxG.save.data.options.comboPosPercent = 0;
    if (FlxG.save.data.options.cinematicBars == null) FlxG.save.data.options.cinematicBars = true;
    if (FlxG.save.data.options.healthIcons == null) FlxG.save.data.options.healthIcons = true;
    if (FlxG.save.data.options.songCredits == null) FlxG.save.data.options.songCredits = true;
    if (FlxG.save.data.options.stampKeybinds == null) FlxG.save.data.options.stampKeybinds = false;

    //Notes Options
    if (FlxG.save.data.options.noteskin == null) FlxG.save.data.options.noteskin = 'arrows';
    if (FlxG.save.data.options.noteScale == null) FlxG.save.data.options.noteScale = 1;
    if (FlxG.save.data.options.noteColors == null) FlxG.save.data.options.noteColors = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];

    //Control Options
    //will have to be reserved elsewhere

    //Gameplay Options
    if (FlxG.save.data.options.modcharts == null) FlxG.save.data.options.modcharts = 'always';
    if (FlxG.save.data.options.dialogue == null) FlxG.save.data.options.dialogue = [true, true, false]; //Story Mode, Playlists, Freeplay
    if (FlxG.save.data.options.scrollSpeed == null) FlxG.save.data.options.scrollSpeed = false;
    if (FlxG.save.data.options.scrollSpeed_Speed == null) FlxG.save.data.options.scrollSpeed_Speed = 3;
    if (FlxG.save.data.options.pauseCountdown == null) FlxG.save.data.options.pauseCountdown = true;
    if (FlxG.save.data.options.skipGameOver == null) FlxG.save.data.options.skipGameOver = 'off';
    if (FlxG.save.data.options.skipSongIntro == null) FlxG.save.data.options.skipSongIntro = false;
    if (FlxG.save.data.options.middlescroll == null) FlxG.save.data.options.middlescroll = false;

    //Game Statistics
    if (FlxG.save.data.gameStats == null) FlxG.save.data.gameStats = {};
    if (FlxG.save.data.gameStats.discoveries == null) FlxG.save.data.gameStats.discoveries = {
        "Bamber's Farm": false,
        "Davey's Yard": false,
        "Romania Outskirts": false
    };

    FlxG.save.flush();
}

function postStateSwitch() {
    if (stateQuotes[ModState.lastName] != null && Type.getClassName(Type.getClass(FlxG.state)) == 'funkin.backend.scripting.ModState') {
        WindowUtils.set_winTitle(stateQuotes[ModState.lastName]);
        DiscordUtil.changePresence(stateQuotes[ModState.lastName], null);
    }
}

function postStateSwitch() {
    idleCursorGraphic = Assets.getBitmapData(Paths.image('cursors/'+cursorName));
    clickCursorGraphic = Assets.getBitmapData(Paths.image('cursors/'+cursorName+'_waiting'));
    FlxG.mouse.load(idleCursorGraphic,1,1,1);
}

function postUpdate(elapsed) {
    if (FlxG.mouse.visible) {
        isHovering = false;

        for (i in clickableObjects) {
            if (FlxG.mouse.overlaps(i)) {
                isHovering = true;
                break;
            }
        }

        if (isHovering && !switched) {
            FlxG.mouse.load(clickCursorGraphic,1,1,1);
            switched = true;
        } else if (!isHovering && switched) {
            FlxG.mouse.load(idleCursorGraphic,1,1,1);
            switched = false;
        }
    }
}

function preStateCreate() {
    clickableObjects = [];
    isHovering = false;
    switched = false;
}

function preStateSwitch() { //Switch to where it was meant to be
    if (Type.getClassName(Type.getClass(FlxG.game._requestedState)) == "funkin.menus.TitleState") FlxG.game._requestedState = new ModState("SplashScreen");

    FlxG.mouse.useSystemCursor = false;
}

function update(elapsed) {
    if (FlxG.keys.justPressed.F5) //DEV: Restarting states
        FlxG.resetState();

    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.R) //DEV: Restarting game
        FlxG.resetGame();

    if (FlxG.keys.justPressed.ANY) {FlxG.mouse.visible = false;} //i wish there was a Controls version so that the gamepad is supported
    if (FlxG.mouse.justMoved || FlxG.mouse.justPressed || FlxG.mouse.justPressedMiddle ||FlxG.mouse.justPressedRight) {FlxG.mouse.visible = true;}
}

public static function getVolume(initValue = 1, type = 'sfx') {
    return initValue * switch (type) { case 'music': FlxG.save.data.options.musicVolume; case 'sfx': FlxG.save.data.options.sfxVolume; default: FlxG.save.data.options.voiceVolume;};
}

public static function pushToClickables(obj) {
    clickableObjects.push(obj);
    return;
}

public static function removeFromClickables(obj) {
    clickableObjects.remove(obj);
    return; //apparently returns are what makes global functions actually global, i think
}

public static function clearClickables() {
    clickableObjects = [];
    return;
}

public static function getClickables() {
    return clickableObjects;
}

public static function playBamberMenuSound(type) {
    return FlxG.sound.play(Paths.sound('menuSounds/'+type), getVolume(1, 'sfx'));
}