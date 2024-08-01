import funkin.editors.ui.UISliceSprite;
import funkin.options.Options;
import hxvlc.flixel.FlxVideoSprite;
import flixel.group.FlxTypedSpriteGroup;
import funkin.backend.utils.WindowUtils;
import flixel.FlxCamera;
import StringTools;

// OPTIONS file, in a different script to be cleaner ig
importScript("data/states/BNDSettings-Options");
// bg stuff, not used later
var box = new UISliceSprite(0, 0, FlxG.width/2 * 1.6, FlxG.height/3 * 2.25, 'menus/options/optionsBox');
// stuff you can't interact with
/*
add(vid = new FlxVideoSprite());
vid.load(Assets.getPath(Paths.file('videos/menuSubState.webm')));
vid.play();
*/
var explainText = new FlxText(0, FlxG.height/3 * 2.72, 0, "Placeholder Message").setFormat(Paths.font("vcr.ttf"), 37.5);
// menu shiz
var buttons = new FlxTypedGroup();
var daOptions = new FlxTypedGroup();
var daParams = new FlxTypedGroup();
var daCheckboxes = new FlxTypedGroup();
// curselects
var curMenu:Int = 0;
var curSelect:Int = 0;
var curParam:Int = 0;

function create() {
    // Initialisation
    WindowUtils.set_winTitle("Options Menu");
    CoolUtil.playMenuSong();
    box.incorporeal = true;
    box.screenCenter();
    box.x -= Math.round(box.bWidth/2) - 16;
    box.y -= Math.round(box.bHeight/2) - 16;
    FlxG.cameras.add(optionsCam = new FlxCamera(box.x, box.y, FlxG.width/2 * 1.6, FlxG.height/3 * 2.19), false);
    optionsCam.bgColor = FlxColor.TRANSPARENT;
    // the menu	
	for(num => a in ["Video", "Sound", "Visual", "Notes", "Controls", "Gameplay", "Misc"]){
	    var button = new FunkinSprite(130 + (num * 146), 25);
		button.loadSprite(Paths.image('menus/options/pages'));
		button.antialiasing = Options.antialiasing;
		button.animateAtlas.anim.addBySymbolIndices("Select", "Scenes/Options/Buttons/Button_" + a, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 24, false);
		//button.updateHitbox();
		buttons.add(button);
        pushToClickables(buttons.members[num]);
	}
    for(num => b in [
        buttons,
        box,
        new FlxSprite().loadGraphic(Paths.image('menus/options/menuGraphic')).screenCenter(),
        new FlxSprite(FlxG.width/3 * 2.6).loadGraphic(Paths.image('menus/options/scrollbarBG')).screenCenter(FlxAxes.Y),
        daOptions,
        daParams,
        daCheckboxes,
        new FlxSprite(0, FlxG.height/3 * 2.7).makeGraphic(FlxG.width, 60, FlxColor.BLACK),
        explainText.screenCenter(FlxAxes.X)
    ]){
        add(b);
	    if([2, 7].contains(num)) b.alpha = 0.5;
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

function changeSelected(a:Int){}

function changeCurSelected(a:Int){}

var numArray:Array<Int> = [];
for(c in 0...101)
    numArray.push(c);

function regenMenu(){
    savetheshit();
    for(z in [daParams, daOptions, daCheckboxes]) z.clear();
    for(num => a in optionsFile[curMenu]){
        if(["Brightness", "Gamma", "Music Volume", "SFX Volume", "Voice Volume"].contains(a[0]))
            a[2] = numArray;
        if(a[2].length!=0)for(b in a[2]) b = b.toLowerCase();
        //trace("Name: " + b[0] + " | Desc: " + b[1], " | Params: " + b[2]);
        daOptions.add(new Alphabet(25, (90 * num), a[0], true));
        daOptions.members[num].color = (StringTools.startsWith(daOptions.members[num].text, "Reset") ? FlxColor.fromRGB(225, 225/7.5, 225/7.5) : FlxColor.WHITE);
        if(a[2].length != 0){
            daParams.add(new Alphabet(0, (90 * num), (a[2].length != 1 ? "<" + (a[2][a[2].indexOf(Reflect.field(FlxG.save.data.options, a[3]))]) + ">" : a[2][0]), true));
            laText = daParams.members[daParams.length - 1];

            laText.camera = optionsCam;
            laText.x = optionsCam.x + optionsCam.width - laText.width - 175;
            if(a[2].length != 1) // options with only one parameter don't have the arrows
                laText.members[0].color = laText.members[laText.text.length - 1].color = FlxColor.fromRGB(255, 100, 19);
        } else {
            var checkbox = new FlxSprite(0, 90 * num);
            checkbox.frames = Paths.getSparrowAtlas("menus/options/checkbox");
            checkbox.animation.addByPrefix("ya", "Checkbox", 24, false);

            daCheckboxes.add(checkbox);
            daCheckboxes.members[daCheckboxes.length - 1].animation.play("ya", true, !Reflect.field(FlxG.save.data.options, a[3]), !Reflect.field(FlxG.save.data.options, a[3]) ? 24 : 0);
            daCheckboxes.members[daCheckboxes.length - 1].camera = optionsCam;
            daCheckboxes.members[daCheckboxes.length - 1].x = optionsCam.x + optionsCam.width - daCheckboxes.members[daCheckboxes.length - 1].width - 175;
        }
        daOptions.members[num].camera = optionsCam;
    }
}

function destroy()
    savetheshit();

function savetheshit() {
    // save it
}