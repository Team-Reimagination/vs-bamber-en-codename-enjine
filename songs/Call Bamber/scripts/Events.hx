var leftWarning = new FlxSprite(-170, !PlayState.downscroll ? 1220 : 0).loadGraphic(Paths.image('HUD/callstage/playing as bamber'+(PlayState.downscroll ? ' - downscroll' : '')));

function postCreate(){
    leftWarning.camera = camHUD;
    leftWarning.scale.set(0.5, 0.5);
    leftWarning.angle = 180;
    add(leftWarning);
    FlxTween.tween(leftWarning, {y: PlayState.downscroll ? 320 : 120, angle: 0}, 1.0, {startDelay: 0.5, ease: FlxEase.backOut, onComplete: function(twn:FlxTween) {
        FlxTween.tween(leftWarning, {alpha: 0}, 1.5, {startDelay: 3.5});
    }});
   healthBar.flipX= iconP1.flipX = iconP2.flipX = true;
   healthBarBG2.flipX = healthBarBG1.flipX = true;
}

function postUpdate(elapsed){	
	var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 100, 0, 1, 0);

	iconP1.x = center - (iconP1.width - 26);
	iconP2.x = center - 26;
}