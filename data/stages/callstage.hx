import flixel.math.FlxRect;
var callTweens = [];

//BROKEN_BTW!
function dualCall() {
	defaultCamZoom=0.6;
	for (i in [dad, cray_Side]) callTweens.push(FlxTween.tween(i, {x: i.x + 350}, 1.5, {ease: FlxEase.quartOut, onComplete: function(tween){tween = null; callTweens = callTweens.filter(x -> x != null);}}));
	for (i in [boyfriend, bamber_Side]) callTweens.push(FlxTween.tween(i, {x: i.x + 700}, 1.5, {ease: FlxEase.quartOut, onComplete: function(tween){tween = null; callTweens = callTweens.filter(x -> x != null);}}));
	callTweens.push(FlxTween.tween(Barrier, {x: Barrier.x + 800}, 1, {ease: FlxEase.quartOut, onComplete: function(tween){tween = null; callTweens = callTweens.filter(x -> x != null);}, onUpdate: function() {
		stageMask(Barrier.x - cray_Side.x/2);
	}}));
}

function stageMask(difference) {
	cray_Side.clipRect = new FlxRect(difference+150, 0, cray_Side.frameWidth + difference * -1, cray_Side.frameHeight);
}

var gameOverSprite = new FlxSprite().loadGraphic(Paths.image('HUD/callstage/disconnect'));
function postCreate() {
	gameOverSprite.camera = camHUD;
	gameOverSprite.centerOrigin();
	gameOverSprite.screenCenter();
	insert(10000, gameOverSprite);

	gameOverSprite.angle = -720;
	gameOverSprite.scale.set(4,4);
	defaultPos = [boyfriend.x, dad.x];
}
var defaultPos = [];

function update(elapsed:Float) {
	if(justDIED)boyfriend.danceOnBeat = false;
}

function postUpdate(elapsed:Float) {
	for (i in callTweens) {
		if (i != null) i.active = !paused;
	}
	//trace(boyfriend.getAnimName()+"     "+boyfriend.isAnimFinished());
	if (justDIED) {
		Conductor.changeBPM(0);
		Conductor.songPosition = -5000;
		if (concluded && controls.ACCEPT) {
			concluded = false;
			boyfriend.stunned = false;

			boyfriend.animation.play('deathConfirm');
			FlxG.sound.play(Paths.sound('call'));

			FlxTween.tween(gameOverSprite, {angle: -720}, 1, {ease: FlxEase.quartIn});
			FlxTween.tween(gameOverSprite.scale, {x: 4, y: 4}, 1, {ease: FlxEase.quartIn, onComplete: function(tween:FlxTween) {
				executeEvent({name: "HScript Call", params: ["reset","null"]});

				new FlxTimer().start(1.5, function(timer:FlxTimer) {
					boyfriend.x = defaultPos[0];
					cray_Side.x = -49;
					dad.x = defaultPos[1];
					bamber_Side.x = -1195;
					Barrier.x = -295;

					justDIED = false;
					paused = false;
					boyfriend.stunned = false;

					FlxG.sound.music.stop();
					inst = null;
					FlxG.switchState(new PlayState());
					PlayState.loadSong(curSong,PlayState.difficulty);

					stageMask(Barrier.x + 50 - cray_Side.x);

					cray_Side.color = dad.color = 0xFFFFFFFF;
					cray_Side.colorTransform.redOffset = cray_Side.colorTransform.greenOffset = cray_Side.colorTransform.blueOffset = dad.colorTransform.redOffset = dad.colorTransform.greenOffset = dad.colorTransform.blueOffset = 0;
				});
			}});
		}
		if (concluded && controls.BACK) {
			FlxG.switchState(new FreeplayState());
		}
	}
}

var justDIED = false;
var concluded = false;

function onGameOver(e) {
	camZooming=false;
	health = 0.001;

	for (i in FlxG.sound.list) {
		i.stop();
	}
	inst.stop();

	e.cancel();
	vocals.volume = 1;
	paused = true;

	vocals.volume = 1;

	executeEvent({name: "HScript Call", params: ["reset","null"]});

	FlxTween.globalManager._tweens = [];
	FlxTimer.globalManager._timers = [];

	for (strumLine in PlayState.instance.strumLines)
    for (note in strumLine.notes) {
        remove(note);
    }

	for (e in events) events.remove(e);

	justDIED = true;
	generatedMusic = false;
	persistentUpdate = true;
	persistentDraw = true;
	startingSong = true;
	startedCountdown = false;
	startTimer = null;

	//PlayState.scripts.executeFunc('onPsychEvent', ['Change Bars Size', 0, 0.5]);
	//PlayState.scripts.executeFunc('onPsychEvent', ['Change Default Zoom', 0.85]);

	for (i in members) {
		if (i != null && i.exists && i.camera == camHUD && i.alpha != null) {
			FlxTween.tween(i, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});
		}
	}

	FlxTween.tween(iconP1, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});
	FlxTween.tween(iconP2, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});

	for (strumLine in PlayState.instance.strumLines){
        for (i in strumLine.notes) {
		    FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.quartInOut, onComplete: function(tween) {
			    i.destroy();
		    }});
	    }
	    strumLine.visible = false;
    }

	FlxTween.tween(bamber_Side, {x: -1395 + 1180}, 1.5, {ease: FlxEase.quartInOut});
	FlxTween.tween(boyfriend, {x: -693 + 1180}, 1.5, {ease: FlxEase.quartInOut});

	FlxTween.tween(cray_Side, {x: -49 + 1180}, 1.5, {ease: FlxEase.quartInOut});
	FlxTween.tween(dad, {x: 1200 + 1180}, 1.5, {ease: FlxEase.quartInOut});

	FlxTween.tween(Barrier, {x: 1800}, 1.5, {ease: FlxEase.quartInOut, onUpdate: function() {
		stageMask(Barrier.x + 50 - cray_Side.x);
	}});

	dad.playAnim("idle");
	FlxG.sound.play(Paths.sound('tv off'));
	FlxG.sound.play(Paths.sound('death/call interrupted'
	));
	new FlxTimer().start(0.13, function(timer:FlxTimer) {
		boyfriend.playAnim("firstDeath");
		new FlxTimer().start(4.9, function(timer:FlxTimer) {
			boyfriend.playAnim('deathLoop',true);
			FlxG.sound.playMusic(Paths.music('death/default'));
			Conductor.changeBPM(0);
			boyfriend.stunned = true;

			paused = true;

			FlxG.sound.music.volume = 1;
			FlxG.sound.music.onComplete = null;

			concluded = true;
		});
	});

	FlxTween.cancelTweensOf(gameOverSprite);
	FlxTween.tween(gameOverSprite, {angle: 0}, 1.5, {ease: FlxEase.quartOut, startDelay: 3});
	FlxTween.tween(gameOverSprite.scale, {x: 1, y: 1}, 1.5, {ease: FlxEase.quartOut, startDelay: 3});

	for (i in [dad, cray_Side]) {
		i.color = 0xFF000000;
		i.colorTransform.redOffset = i.colorTransform.greenOffset = i.colorTransform.blueOffset = 255;

		FlxTween.tween(i.colorTransform, {redOffset: 0, greenOffset: 0, blueOffset: 0}, 0.5, {ease: FlxEase.quartIn});
	}
}