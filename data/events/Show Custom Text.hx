import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
public var eventText = new FlxText(0, 0, 0, "", 30);
var eventStep = [0, 0];
function postCreate() {
	add(eventText);
}
function onEvent(_) {
	if (_.event.name == 'Show Custom Text') {
		var string = _.event.params[0];
		var value2 = _.event.params[1];
		var value3 = _.event.params[2];
		var font = _.event.params[3];
		var value5 = _.event.params[4];
		var value6 = _.event.params[5];
		var value7 = _.event.params[6];
	eventText.alpha = 1;
	eventText.camera = camHUD;
	eventText.text = string;
	eventText.setFormat(Paths.font(font), value5, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
	eventText.borderSize = value5 / 25;
		if(value2 == "Center"){eventText.screenCenter(FlxAxes.X);} else {eventText.x = value2;}
		if(value3 == "Center"){eventText.screenCenter(FlxAxes.Y);} else if(value3 == "Strums") {eventText.y = playerStrums.members[0].y + (PlayState.downscroll ? 0 : playerStrums.members[0].height - eventText.height) - ((40 + Std.int(value5)) * (PlayState.downscroll ? 1 : -1));} else {eventText.y = value3;}
		eventStep = [Std.int(value6), Std.parseFloat(value7)];
	}
}
function stepHit(curStep) {
	if (curStep == eventStep[0]) {FlxTween.tween(eventText, {alpha: 0}, eventStep[1]);}
}