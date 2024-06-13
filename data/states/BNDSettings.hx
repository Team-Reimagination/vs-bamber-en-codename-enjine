import funkin.editors.ui.UISliceSprite;
import funkin.options.Options;
import hxvlc.flixel.FlxVideoSprite;
import flixel.group.FlxTypedSpriteGroup;

// OPTIONS file
var optionsFile:Array<Dynamic> = [ // god help me
    [ // VIDEO
        // [name, desc, ["params", "leave blank if checkbox"], save name],
        ["Framerate", "", [30, 60, 90, 120, 150, 180, 210, 240]],
        ["Anti-aliasing", "Toggles smoothing jagged edges on curves and diagonal lines", []],
        ["Pixel Perfect", "", []],
        ["Resolution", "How many pixels the game renders at", ["1280x720"]],
        ["Fullscreen", "Toggles the game filling your screen", []],
        ["Borderless", "Toggles the game window border", []],
        ["Brightness", "How bright the game is", []],
        ["Gamma", "", []]
    ],
    [ // SOUND
        ["Music Volume", "How loud the music is", []],
        ["SFX Volume", "How loud sound effects are", []],
        ["Voice Volume","How loud the character voices are while playing a song", []], 
        ["Miss Sounds", "Toggles playing a sound effect on miss", []],
        ["Copyrighted Bypass", "Toggles replacing copyrighted audio with MIDI covers", []],
        ["Subtitles", "Toggles words appearing on screen when spoken lyrics are heard", []], // can someone refine this description please
    ],
    [ // VISUAL
        ["Low Memory Mode", "", []],
        ["VRAM Only Sprites", "", []],
        ["Flashing Lights", "Toggles flashes on the screen", []],
        ["Shaders", "What shaders should be shown", ["All", "Some", "None"]],
        ["Botplay UI", "", []],
        ["Background Blur", "", []],
        ["Background Dim", "", []],
        ["Rapid Camera", "", []],
        ["Timebar", "Toggles the bar that shows how long of the song is left until the end", []],
        ["Combo Pos Percent", "",[]],
        ["Cinematic Bars", "Toggles the bars seen at the top and bottom of the screen during a song", []],
        ["Health Icons", "Toggles health bar icons", []],
        ["Song Credits", "Toggles the credits popup at the beginning of a song", []],
        ["Stamp Keybinds", "", []]
    ],
    [ // NOTE OPTIONS
        ["Noteskin", "What the notes appear as", ["Arrows"]],
        ["Note Scale", "How big the notes appear in-game (Default is \"1\")",[]], //#
        ["Note Colors", "What color notes appear as", []]
    ],
    [ // Controls
        ["Placeholder", "Placeholder",[]]
    ],
    [ // GAMEPLAY
        ["Coloured Healthbar", "", []],
        ["Modcharts", "Toggles the notes moving around during a song", ["Always", "Sometimes", "Never"]],
        ["Custom Scroll Speed", "Toggles using your custom scroll speed", []],
        ["Scroll Speed Speed", "How fast the scroll speed should be for a song", []], // 1 - 10?
        ["Pause Countdown", "Toggles the countdown after unpausing", []],
        ["Skip Game Over", "", []],
        ["Skip Song Intro", "", []],
        ["Scroll Mode", "Where the notes appear on your screen", ["Top", "Bottom"]],
        ["Middle Scroll", "Toggles your strum being centered", []],
        ["Story Mode Dialogue", "Toggles story mode dialogue", []],
        ["Freeplay Dialogue", "Toggles freeplay dialogue", []]
    ],
    [ // MISC
	["Reset Scores", "Erases ALL song & week scores/achievements", ["Delete"]],
	["Reset Options", "Restores all settings to their default", ["Delete"]]
    ]
];
// bg stuff, not used later
var box = new UISliceSprite(0, 0, FlxG.width/2 * 1.6, FlxG.height/3 * 2.25, 'menus/options/optionsBox');
// stuff you can't interact with
add(vid = new FlxVideoSprite());
vid.load(Assets.getPath(Paths.file('videos/menuSubState.webm')));
vid.play();
//vid.bitmap.onEndReached.add(function(ass){vid.play();});
var explainText = new FlxText(0, FlxG.height/3 * 2.72, 0, "Placeholder Message").setFormat(Paths.font("vcr.ttf"), 37.5);
// menu shiz
var checkbox = new FlxSprite();
var buttons = new FlxTypedGroup();
var daOptions = new FlxTypedGroup();
var daParams = new FlxGroup();
// curselects
var curMenu:Int = 0;
var curSelect:Int = 0;
var curParam:Int = 0;

function create() {
    // Initialisation
    CoolUtil.playMenuSong();
    box.incorporeal = true;
    box.screenCenter();
    box.x -= Math.round(box.bWidth/2) - 16;
    box.y -= Math.round(box.bHeight/2) - 16;
    //
    checkbox.frames = Paths.getSparrowAtlas('menus/options/checkbox');
    checkbox.animation.addByPrefix("Checkbox", "Checkbox", 24);
    checkbox.animation.play("Checkbox", true);
    var numArray:Array<Int> = [];
    for(c in 0...101)
        numArray.push(c);
    for(num => a in optionsFile){
        for(num2 => b in a){
            if(["Brightness", "Gamma", "Music Volume", "SFX Volume"].contains(b[0]))
                    b[2] = numArray;
            //trace("Name: " + b[0] + " | Desc: " + b[1], " | Params: " + b[2]);
            if(num == 0){
                daOptions.add(new Alphabet(box.x + 25, 90 + (90 * num2), b[0], true));
                if(b[2].length != 0){
                    daParams.add(new Alphabet(0, 90 + (90 * num2), "<" + b[2][0] + ">", true));
                    daParams.members[num2].x = box.x + box.bWidth - daParams.members[num2].width - 50;
                    recolorText(daParams.members[num2]);
                } else {
                    daParams.add(new Alphabet(0, 90 + (90 * num2), "", true));
                }
            }
        }
    }
    // the menu	
	for(num => a in ["Video", "Sound", "Visual", "Notes", "Controls", "Gameplay", "Misc"]){
	    var button = new FunkinSprite(130 + (num * 146), 25);
		button.loadSprite(Paths.image('menus/options/pages'));
		button.antialiasing = Options.antialiasing;
		button.animateAtlas.anim.addBySymbolIndices("Select", "Scenes/Options/Buttons/Button_" + a, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 24, false);
		//button.updateHitbox();
		buttons.add(button);

	}
    for(num => b in [
        buttons,
        box,
        new FlxSprite().loadGraphic(Paths.image('menus/options/menuGraphic')).screenCenter(),
        new FlxSprite(FlxG.width/3 * 2.6).loadGraphic(Paths.image('menus/options/scrollbarBG')).screenCenter(FlxAxes.Y),
        daOptions,
        daParams,
        new FlxSprite(0, FlxG.height/3 * 2.7).makeGraphic(FlxG.width, 60, FlxColor.BLACK),
        explainText.screenCenter(FlxAxes.X)
    ]){
        add(b);
	    if([2, 6].contains(num)) b.alpha = 0.5;
        //if(num != 0 || num != 2) b.antialiasing = Options.antialiasing;
    }
	
	changeOption(0);
}

function update(){
	if (FlxG.mouse.wheel != 0)
		changeOption(FlxG.mouse.wheel);
	/*if(FlxG.keys.justPressed.Q || FlxG.keys.justPressed.E)
		changeOption(FlxG.keys.justPressed.Q ? -1 : 1);*/
}

function recolorText(laText:Alphabet) {
    laText.members[0].color = laText.members[laText.text.length - 1].color = FlxColor.fromRGB(255, 100, 19);
}

function changeOption(a:Int){
	curMenu = FlxMath.wrap(curMenu + a, 0, buttons.length - 1);
	FlxG.sound.play(Paths.sound('firstTime/firstButtonScroll'), getVolume(0.8, 'sfx'));
	for(z in buttons){
		FlxTween.cancelTweensOf(z);
		z.animateAtlas.anim.finished = true;
		z.playAnim('Select', true, null, buttons.members.indexOf(z) != curMenu, z.animateAtlas.anim.curFrame);
		FlxTween.tween(z, {y: buttons.members.indexOf(z) == curMenu ? 7.5 : 25}, 0.25);
	}
	regenMenu();
}

function changeSelected(){}

function changeCurSelected(){}

function regenMenu(){}