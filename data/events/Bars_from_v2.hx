var barSize:Float = 0;
var bar1:FlxSprite = new FlxSprite(-600, -560 + (barSize * 10)).makeGraphic(1, 1, 0xFF000000);
var bar2:FlxSprite = new FlxSprite(-600, 720 - (barSize * 10)).makeGraphic(1, 1, 0xFF000000);

bar1.scale.x = bar2.scale.x = 1600 * 2;
bar1.scale.y = bar2.scale.y = 560;

var curSong:String = PlayState.instance.SONG.meta.name;
bar1.updateHitbox(); bar2.updateHitbox(); 
var customBarSize:Array<Dynamic> = [
	['Synthwheel', 5],
	['Astray', 36],
	['Facsimile', -36],
	['Placeholder', -36],
	['Deathbattle', 10],
	['Screencast', 7],
	['Harvest', 36],
	['Yield V1', 9],
	['Cornaholic V1', 9],
	['Harvest V1', 9],
	['Yield Seezee Remix', 9],
	['Cornaholic Erect Remix V1', 9],
	['Harvest Chill Remix', 9],
	['call-bamber', 36],
];
public var camOther:HudCamera;

function postCreate() {
	for (i in 0...customBarSize.length){
		if (customBarSize[i][0] == curSong){
			barSize = customBarSize[i][1];
			trace("Chris_pratt.");
		}
	}
	FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(camOther = new HudCamera(), false);
    camOther.bgColor = 0x00000000;
    FlxG.cameras.add(camHUD, false);

	bar1.cameras=[camOther];bar2.cameras=[camOther];insert(0,bar1);insert(0,bar2);bar2.y=720-(barSize*10);bar1.y=-560+(barSize*10);
}
function onEvent(_) {
	if (_.event.name == 'Bars_from_v2') {
		var val1 = _.event.params[0];
		var val2 = _.event.params[1];
		var value3 = _.event.params[2];
		FlxTween.tween(bar1,
			 {y: -560 + (val1 * 10)}, val2, {ease:
				 (value3 == null ?
					 FlxEase.quintOut : 
					 CoolUtil.flxeaseFromString(value3))});
		FlxTween.tween(bar2, {y: 720 + -(val1 * 10)}, val2, {ease: (value3 == null ? FlxEase.quintOut : CoolUtil.flxeaseFromString(value3))});
	}
}
function update(elapsed){
	bar1.x = -bar1.width / 10;
	bar2.x = -bar1.width / 10;
}