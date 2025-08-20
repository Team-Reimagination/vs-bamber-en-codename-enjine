function postCreate() {
	heelthbar = new FlxSprite(170,640).loadGraphic(Paths.image('game/healthbars/exchangetown'));
	for(i in [healthBarBG,healthBar]){
		i.x-=150;
		i.y+=10;
	}
	insert(19,heelthbar);
	heelthbar.camera = camHUD;
}
function helicopter()
	FlxTween.tween(boyfriend, {y: -50000}, 5, {ease: FlxEase.circIn});
function DIE() {
	FlxTween.tween(dad, {angle: 90, y: dad.y + 40, x: dad.x + 40}, 1, {ease: FlxEase.circOut});
	FlxTween.color(dad, 1, 0xFF000000, 0x71C41900, {
		onComplete: function(twn:FlxTween) {
			dad.alpha = 0;
		}
	});
	dad.cancelAnim.play('dead', true);
	defaultCamZoom=0.52;
	trace("STAY_DEAD.");
}