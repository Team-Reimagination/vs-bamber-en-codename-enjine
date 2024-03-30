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