var bf = PlayState.instance.boyfriend;

var matzu = new FunkinSprite();

function postCreate() {
	character.visible = false;
	FlxG.camera.zoom = 0.8;

    matzu.frames = Paths.getSparrowAtlas('game/deathShit/hotline/MATZURETRY');
    matzu.animation.addByPrefix('deathLoop', 'dead loop', 24, true);
    matzu.animation.addByPrefix('deathConfirm', 'dead confirm', 24, false);
    matzu.animation.play('deathLoop');
    matzu.scrollFactor.set();
    matzu.screenCenter();
    matzu.alpha = 0.001;
    add(matzu);
}

function update(elapsed:Float) {
    if (matzu.getAnimName() == 'deathLoop' && matzu.alpha == 0.001) {
        FlxTween.tween(matzu, {alpha: 1}, 1);
    }
	if (controls.ACCEPT && !isEnding) {
        matzu.alpha = 1;
        FlxTween.globalManager.completeTweensOf(matzu);
        matzu.animation.play('deathConfirm');
    }
}

function beatHit(curBeat) {
    if (!isEnding) matzu.animation.play('deathLoop');
}