import flixel.addons.text.FlxTypeText;
import flixel.text.FlxTextBorderStyle;
var mahar = new FlxSprite(FlxG.width-650,FlxG.height-330);
var gameover = new FlxSprite().loadGraphic(Paths.image("game/deathShit/ut/gameover"));
var maharParts = [];
var partsPositions = [];
var recordPositions = false;
var STOPYOUFUCKINGPIECEOFSHIT = false;
var dialogueOptions = ['You cannot give up just yet...', 'come on stop being so swindled', 'kys'];
var typingtextofashore:FlxTypeText;
function postCreate() {
	character.alpha = 0;
	CoolUtil.playMusic(Paths.music("death/ut"), false, 1, true, 594);
	isEnding = true;
	FlxG.camera.zoom = 0.75;
	FlxG.camera.follow();
	gameover.screenCenter();
	gameover.scale.set(2.5,2.5);
	gameover.y -= 200;
	gameover.scrollFactor.set();
	gameover.alpha = 0;
	add(gameover);
	typingtextofashore = new FlxTypeText(gameover.x - 200, gameover.y + 500, 500, "", 64);
	typingtextofashore.scrollFactor.set();
	typingtextofashore.font = Paths.font("Undertale.ttf");
	typingtextofashore.sounds = [new FlxSound().loadEmbedded(Paths.sound("asgore"))];
	typingtextofashore.textField.defaultTextFormat.letterSpacing = 100;
	add(typingtextofashore);
	typingtextofashore.resetText(dialogueOptions[FlxG.random.int(0, dialogueOptions.length - 1)]);
	mahar.frames = Paths.getSparrowAtlas("game/deathShit/ut/canyouphilmahar");
	mahar.animation.addByPrefix("normal", "normal");
	mahar.animation.addByPrefix("broke", "broke");
	mahar.animation.play("normal");
	mahar.scale.set(2,2);
	mahar.scrollFactor.set();
	add(mahar);
	new FlxTimer().start(0.27, function() {
		mahar.animation.play("broke");
		new FlxTimer().start(1.23, function() {
			mahar.visible = false;
			recordPositions = true;
			for (i in 0...7) {
				var part = new FlxSprite(mahar.x, mahar.y);
				part.frames = Paths.getSparrowAtlas("game/deathShit/ut/icantphilyouhar");
				part.animation.addByPrefix("idle");
				part.animation.play("idle");
				part.scrollFactor.set();
				part.animation.curAnim.frameRate = 14;
				part.x += mahar.width/2 - part.width/2;
				part.y += mahar.height/2 - part.height/2;
				var velocitus = FlxG.random.float(0, 500);
				part.velocity.set(velocitus * (FlxG.random.bool() ? -1 : 1), (500-velocitus) * (FlxG.random.bool() ? -1 : 1));
				part.acceleration.y = 700;
				part.scale.set(2,2);
				add(part);
				maharParts.push(part);
			} 
			new FlxTimer().start(2.3, function() {
				recordPositions = false;
				partsPositions.reverse();
				for (i in maharParts) {
					i.velocity.set();
					i.acceleration.y = 0;
				}
			});
		});
	});
}
var isGoingBackwards = false;
var indexPos = 0;
function update(elapsed) {
	if (/*character.getAnimName() == 'firstDeath' && */character.isAnimFinished()) {
		FlxTween.tween(gameover, {alpha: 1}, 2);
		new FlxTimer().start(3, function() typingtextofashore.start(0.08));
	}
	if (recordPositions) {
		var positionates = [];
		for (i in maharParts)
			positionates.push([i.x, i.y]);
		partsPositions.push(positionates);
	}
	if (!STOPYOUFUCKINGPIECEOFSHIT && controls.ACCEPT && character.getAnimName() != "firstDeath" && !recordPositions) {
		isGoingBackwards = true;
		STOPYOUFUCKINGPIECEOFSHIT = true;

		FlxTimer.globalManager._timers = []; //finish the text in case you pressed accept early enough
		typingtextofashore.resetText('* But it refused.');
		typingtextofashore.sounds = null;
		FlxTween.globalManager._tweens = []; //resets the game over tween in case you press early enough

		if (FlxG.sound.music != null) FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.sound("death/ends/ut-end"), 1.0, false);
		new FlxTimer().start(2.7, function() typingtextofashore.start(0.08));
		new FlxTimer().start(5, function() {FlxG.switchState(new PlayState());
			PlayState.loadSong(PlayState.instance.SONG.meta.name,PlayState.difficulty);});
		gameover.alpha = 0.2;
	}
	if (isGoingBackwards) {
		var it = -1;
		for (i in maharParts) {
			i.setPosition(partsPositions[indexPos][++it][0], partsPositions[indexPos][it][1]);
		}
		if (indexPos + 2 < partsPositions.length) indexPos += 2;
		else {
			mahar.visible = true;
			for (i in maharParts)
				i.visible = false;
			new FlxTimer().start(1.07, function() mahar.animation.play("normal"));
			isGoingBackwards = false;
		}
	}
	FlxG.camera.followLerp = 0.1;
}