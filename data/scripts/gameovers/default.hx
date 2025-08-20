import flixel.util.FlxGradient;

var bf = PlayState.instance.boyfriend;

var gradientSprite;

function create() {
	gradientSprite = FlxGradient.createGradientFlxSprite(FlxG.width * 2, 900, [0x00000000, PlayState.instance.boyfriend.iconColor], 1, 90, true);
    gradientSprite.scrollFactor.set();
	gradientSprite.screenCenter();
    gradientSprite.y += 100;
    insert(members.indexOf(PlayState.instance.boyfriend)+1,gradientSprite);

	gradientSprite.alpha = 0;
    FlxTween.tween(gradientSprite, {alpha: 1}, 3, {ease: FlxEase.quartInOut});
}
