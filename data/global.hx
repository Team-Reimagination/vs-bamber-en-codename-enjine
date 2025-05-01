import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.scripting.ModState;
import Type;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.io.Path;
import funkin.backend.utils.DiscordUtil;

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
static var hasseen = false;

function destroy()
	hasseen = false;

function new() {
    WindowUtils.set_prefix('Bamber & Davey Vol. 2.5 | ');
    FlxG.save.bind('BamberAndDavey', 'TeamReimagination'); //I found out that mod options use regular saves instead of a save in the Options class for example

    if (FlxG.save.data.options == null) FlxG.save.data.options = {};

    //MOD SPECIFIC OPTIONS, DEFAULT ONES SHOULD BE INCLUDED TOO
    //Video Options
    FlxG.save.data.options.framerate ??= 120; // is 120 a good default idk
    FlxG.save.data.options.antialiasing ??= true;
    FlxG.save.data.options.pixelperfect ??= true;
    FlxG.save.data.options.resolution ??= [1280, 720];
    FlxG.save.data.options.fullscreen ??= false; 
    FlxG.save.data.options.borderless ??= false;
    FlxG.save.data.options.brightness ??= 50;
    FlxG.save.data.options.gamma ??= 50;

    //Sound options
    //Master Volume - FlxG.volume
    FlxG.save.data.options.musicVolume ??= 100; 
    FlxG.save.data.options.sfxVolume ??= 100;
    FlxG.save.data.options.voiceVolume ??= 100;
    FlxG.save.data.options.missSounds ??= true;
    FlxG.save.data.options.copyrightBypass ??= false;
    FlxG.save.data.options.subtitles ??= true;

    //Appearance Options
    FlxG.save.data.options.lowMemory ??= true;
    FlxG.save.data.options.vramSprites ??= true;
    FlxG.save.data.options.flashingLights ??= true;
    FlxG.save.data.options.shaders ??= 'all';
    FlxG.save.data.options.botplayUI ??= true;
    FlxG.save.data.options.bgBlur ??= 0;
    FlxG.save.data.options.bgDim ??= 0;
    FlxG.save.data.options.rapidCam ??= true;
    FlxG.save.data.options.breakTime ??= true;
    FlxG.save.data.options.timeBar ??= true;
    FlxG.save.data.options.comboPosPercent ??= 0;
    FlxG.save.data.options.cinematicBars ??= true;
    FlxG.save.data.options.healthIcons ??= true;
    FlxG.save.data.options.songCredits ??= true;
    FlxG.save.data.options.stampKeybinds ??= false;

    //Notes Options
    FlxG.save.data.options.noteskin ??= 'arrows';
    FlxG.save.data.options.noteScale ??= 1;
    FlxG.save.data.options.noteColors ??= [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];

    //Control Options
    //will have to be reserved elsewhere

    //Gameplay Options
    FlxG.save.data.options.coloredBar ??= true;
    FlxG.save.data.options.modcharts ??= 'always';
    FlxG.save.data.options.dialogue ??= [true, true, false]; //Story Mode, Playlists, Freeplay
    FlxG.save.data.options.scrollSpeed ??= false;
    FlxG.save.data.options.scrollSpeed_Speed ??= 3;
    FlxG.save.data.options.pauseCountdown ??= true;
    FlxG.save.data.options.skipGameOver ??='off';
    FlxG.save.data.options.skipSongIntro ??= false;
    FlxG.save.data.options.scrollMode ??= false;
    FlxG.save.data.options.middlescroll ??= false;
    FlxG.save.data.options.storyDialogue ??= false;
    FlxG.save.data.options.freeplayDialogue ??= false;

    //Game Statistics
    FlxG.save.data.gameStats ??= {};
    FlxG.save.data.gameStats.discoveries ??= {
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

function onHealthIconAnimChange(e) {
    if (e.healthIcon.animation.exists("normal")) {
        e.cancel();
        e.healthIcon.animation.play(e.amount == 0 ? "normal" : "losing", true);  
    }
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
    for (i in FlxG.state.members)
        if (Std.isOfType(i, HealthIcon))
            if (Assets.exists(Path.withoutExtension(Paths.image("icons/"+i.curCharacter)) + ".xml") && i.frames.frames[0].name != "losing0000") {
                i.frames = Paths.getFrames("icons/"+i.curCharacter);
                i.animation.addByPrefix("losing", "losing", 24, true);
                i.animation.addByPrefix("normal", "normal", 24, true); 
                trace("ffUck...");
                i.animation.play("normal", true);
                i.curAnimState = -1;
            }
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