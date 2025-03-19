import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.ShaderResizeFix;
import openfl.system.Capabilities;
import funkin.backend.utils.WindowUtils;
import openfl.text.TextFormat;
import openfl.text.TextField;
import lime.graphics.Image;
import haxe.io.Path;

import funkin.options.OptionsMenu;

var redirectStates:Map<FlxState, String> = [
	FreeplayState => "BND/Freeplay"
	OptionsMenu => "BND/Options"
];

public static var customText:TextField; // VECHETT WORKED OUT ALL THE CUSTOM FPS SHIT I JUST ADJUSTED/RECODED IT
public static var customSubText:TextField;
var customFormat:TextFormat = new TextFormat(Paths.getFontName(Paths.font('vcr.ttf')), 15, FlxColor.WHITE);

public static var myfourtothreesongs:Array<String> = ["astray", "facsimile", "placeholder", "test footage"];

function new() {
	// window shit
	WindowUtils.set_prefix('Bamber & Davey Vol. 2.5 | ');
    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('appIcon/icon512'))));
	// save data stuff
    FlxG.save.bind('BamberAndDavey', 'TeamReimagination');
	// custom fps shit
	Main.instance.addChild(customText = new TextField()).defaultTextFormat = customFormat;
	Main.instance.addChild(customSubText = new TextField()).defaultTextFormat = customFormat;
	customSubText.text = "\n\nVs B&D Volume. 2.5";
	customSubText.width = customSubText.textWidth + 10;
	customSubText.alpha = 0.3;
	customText.x = customText.y = customSubText.x = customSubText.y = 5;
	Options.fpsCounter = true;
}

function update() {
    customText.text = "FPS: " + Framerate.fpsCounter.fpsNum.text + "\nMEM: " + Framerate.memoryCounter.memoryText.text + Framerate.memoryCounter.memoryPeakText.text;
    customText.width = customText.textWidth;

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

function preStateSwitch() {
	if ((FlxG.width != 1280 || FlxG.height != 720) && !Std.isOfType(FlxG.game._requestedState, PlayState)) windowShit(1280, 720);
    customText.defaultTextFormat = customSubText.defaultTextFormat = customFormat;
    Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = false;
		for (redirectState in redirectStates.keys()) 
			if (Std.isOfType(FlxG.game._requestedState, redirectState)) 
				FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function destroy() {
    Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = true;
    Main.instance.removeChild(customText);
    Main.instance.removeChild(customSubText);
}

function onHealthIconAnimChange(e) {
    if (e.healthIcon.animation.exists("normal")) {
        e.cancel();
        e.healthIcon.animation.play(e.amount == 0 ? "normal" : "losing", true);  
    }
}

// WINDOW RESIZE CODE

public static var winWidth:Int;
public static var winHeight:Int;

public static function windowShit(newWidth:Int, newHeight:Int){
 	if(newWidth != 1280 || newHeight != 720) {
		aspectShit(newWidth, newHeight);
		FlxG.resizeWindow(winWidth * 0.9, winHeight * 0.9);
	} else
		FlxG.resizeWindow(newWidth, newHeight);
	FlxG.resizeGame(newWidth, newHeight);
	FlxG.width = FlxG.initialWidth = newWidth;
	FlxG.height = FlxG.initialHeight = newHeight;
	ShaderResizeFix.doResizeFix = true;
	ShaderResizeFix.fixSpritesShadersSizes();
	window.x = Capabilities.screenResolutionX/2 - window.width/2;
	window.y = Capabilities.screenResolutionY/2 - window.height/2;
}

function aspectShit(width:Int, height:Int):String {
	var idk1:Int = height;
	var idk2:Int = width;
	while (idk1 != 0) {
		idk1 = idk2 % idk1;
		idk2 = height;
	}
	winWidth = Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2))) > Capabilities.screenResolutionY ? Math.floor(Capabilities.screenResolutionY * ((width / idk2) / (height / idk2))) : Capabilities.screenResolutionX;
	winHeight = Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2))) > Capabilities.screenResolutionY ? Capabilities.screenResolutionY : Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2)));
}