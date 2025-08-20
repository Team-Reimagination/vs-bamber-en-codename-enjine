import funkin.backend.utils.AudioAnalyzer;
//Wave_form_stuff_coming_once_i_figure_HOW_they_work.

var fisheye = new CustomShader('fisheye');

function create() {
	FlxG.camera.addShader(fisheye);
	fisheye.MAX_POWER = .15;

	for (i in members) 
		if (i != null && Std.isOfType(i, Character)) {
			i.colorTransform.redMultiplier = 0.65*0.8;
			i.colorTransform.greenMultiplier = 0.4*0.8;
			i.colorTransform.blueMultiplier = 0.8;
			i.colorTransform.blueOffset -= 10;
	}
}
var fisheyePower:Float = 0.15;

function update() {
	fisheyePower = FlxMath.lerp(fisheyePower, 0.15, 0.07);
	fisheye.MAX_POWER = fisheyePower;
}