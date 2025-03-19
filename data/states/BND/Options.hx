import funkin.backend.utils.WindowUtils;
import funkin.editors.ui.UISliceSprite;
import hxvlc.flixel.FlxVideoSprite;

var box = new UISliceSprite(0, 0, FlxG.width/2 * 1.6, FlxG.height/3 * 2.25, 'menus/options/optionsBox');

var buttons:FlxTypedGroup = new FlxTypedGroup();

var curMenu:Int = 0;
var curSelect:Int = 0;
var curParam:Int = 0;

function create() {
    // Initialisation
    WindowUtils.set_winTitle("Options Menu");
    CoolUtil.playMenuSong();
    // Static assets
    var vid:FlxVideoSprite = new FlxVideoSprite();
    vid.load(Assets.getPath(Paths.file('videos/menuSubState.webm')), ['input-repeat=65535']);
    add(vid).play();
    box.incorporeal = true;
    box.screenCenter();
    box.x -= Math.round(box.bWidth/2) - 16;
    box.y -= Math.round(box.bHeight/2) - 16;
    // add(box);
    // Buttons
    for(num => a in ["Video", "Sound", "Visual", "Notes", "Controls", "Gameplay", "Misc"]){
	    var button:FunkinSprite = new FunkinSprite(130 + (num * 146), 25);
		button.loadSprite(Paths.image('menus/options/pages'));
		button.antialiasing = Options.antialiasing;
		button.animateAtlas.anim.addBySymbolIndices("Select", "Scenes/Options/Buttons/Button_" + a, CoolUtil.numberArray(0, 25), 24, false);
		// button.playAnim("Select", true);
        button.forceIsOnScreen = true;
		buttons.add(button);
        // pushToClickables(buttons.members[num]);
	}
    add(buttons);
    FlxG.camera.zoom -= 0.5;

    changeOption(0);
}

function update(){
	if (FlxG.mouse.wheel != 0)
		changeOption(FlxG.mouse.wheel);
	if (FlxG.keys.justPressed.Q || FlxG.keys.justPressed.E)
		changeOption(FlxG.keys.justPressed.Q ? -1 : 1);

    if (controls.BACK)
        FlxG.switchState(new MainMenuState());
}

function recolorText(laText:Alphabet) {
    laText.members[0].color = laText.members[laText.text.length - 1].color = FlxColor.fromRGB(255, 100, 19);
}

function changeOption(a:Int){
	curMenu = FlxMath.wrap(curMenu + a, 0, buttons.length - 1);
	// FlxG.sound.play(Paths.sound('firstTime/firstButtonScroll'), getVolume(0.8, 'sfx'));
	for(z in buttons){
		FlxTween.cancelTweensOf(z);
		// z.animateAtlas.anim.finished = true;
		z.playAnim('Select', true, null, buttons.members.indexOf(z) != curMenu, z.animateAtlas.anim.curFrame);
		// FlxTween.tween(z, {y: buttons.members.indexOf(z) == curMenu ? 7.5 : 25}, 0.25);
        z.screenCenter();
	}
	// regenMenu();
}