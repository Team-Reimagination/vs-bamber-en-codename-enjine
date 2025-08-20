import flixel.util.FlxGradient;

var bf = PlayState.instance.boyfriend;

var gradientSprite;

//Memeing.

var expungo = new FlxSprite();
var gameover = new FunkinSprite();
var retry = new FlxSprite();
var goTWEENS = [];

function create() {
	FlxG.camera.zoom = 0.8;
	PlayState.instance.camFollow.setPosition(bf.getMidpoint().x - 100 + bf.camxoffset, bf.getMidpoint().y - 100 + bf.camyoffset);
    FlxG.camera.follow(camFollow);
    bf.antialiasing = false;
	expungo.frames = Paths.getSparrowAtlas('game/deathShit/cheater/expunged');
   	expungo.animation.addByPrefix('idle', 'Expunged', 8, true);
    expungo.animation.play('idle');
    expungo.scrollFactor.set();
    expungo.screenCenter();
    expungo.x += 120;
    expungo.y += 1500;
    expungo.antialiasing = false;
    insert(0, expungo);

	expungo.alpha = 0;
    goTWEENS.push(FlxTween.tween(expungo, {alpha:1, y: expungo.y - 1500, x: expungo.x - 80}, 2, {ease: FlxEase.quartInOut, startDelay: 2}));

	expungo.scale.x = expungo.scale.y = 45;
    goTWEENS.push(FlxTween.tween(expungo.scale, {x:1.2, y: 1.2}, 2, {ease: FlxEase.quartInOut, startDelay: 2}));

	gradientSprite = FlxGradient.createGradientFlxSprite(FlxG.width * 5, 900, [0x00000000, 0x00000000, 0xFF008C00, 0x00000000], 1, 90, true);
    gradientSprite.scrollFactor.set();
	gradientSprite.screenCenter();
    gradientSprite.y += 100;
    insert(0, gradientSprite);

	gradientSprite.alpha = 0;
   	goTWEENS.push(FlxTween.tween(gradientSprite, {alpha: 1}, 3, {ease: FlxEase.quartInOut, startDelay: 2}));

    gameover.frames = Paths.getSparrowAtlas('game/deathShit/cheater/gameover');
    gameover.animation.addByPrefix('trans', 'GameOver_Transition', 24, false);
    gameover.animation.addByPrefix('loop', 'GameOver_Loop', 24, false);
    gameover.animation.addByPrefix('end', 'GameOver_End', 24, false);
    gameover.scrollFactor.set();
    gameover.screenCenter();
    gameover.antialiasing = false;
    gameover.visible = false;
    gameover.y = FlxG.height - 300;
    add(gameover);

	retry.frames = Paths.getSparrowAtlas('game/deathShit/cheater/retry');
    retry.animation.addByPrefix('trans', 'Retry_Transition', 24, false);
	retry.animation.addByPrefix('loop', 'Retry_Loop', 24, false);
	retry.animation.addByPrefix('end', 'Retry_End', 24, false);
    retry.scrollFactor.set();
    retry.screenCenter();
	retry.antialiasing = false;
    retry.visible = false;
    retry.y -= 470;
	add(retry);
}

function update(elapsed:Float) {
	if (character.getAnimName()== 'firstDeath' && character.isAnimFinished() && !isEnding) { gameover.animation.play('loop', true); retry.animation.play('loop', true);}
	if (character.getAnimName() == 'firstDeath' && !character.isAnimFinished()) {
    //if (!character.animation.curAnim.finished) FlxG.camera.follow(camFollow);

    if (character.animation.curAnim.curFrame == 54 && !isEnding) { gameover.visible = true; retry.visible = true; gameover.animation.play('trans', true); retry.animation.play('trans', true); }
	}
}

function beatHit(beat) {
    if (beat % 2 == 0 && !isEnding && gameover.getAnimName() == 'loop') { gameover.animation.play('loop', true); retry.animation.play('loop', true);}
}