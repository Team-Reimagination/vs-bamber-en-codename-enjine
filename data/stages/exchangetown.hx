import flixel.addons.util.FlxSimplex;
var matrixShader = new CustomShader('colorMatrix');

var bar = new FlxSprite().loadGraphic(Paths.image('HUD/exchangetown/wastedBar'));
var vignette = new FlxSprite().loadGraphic(Paths.image('HUD/exchangetown/pixelVignette'));
function postCreate() {
	ogBFY = boyfriend.y;
}

var deathTimer;
var ogBFY;

function postUpdate(elapsed:Float) {
	if (justDIED) {
		Conductor.songPosition = -5000;
		Conductor.songPositionOld = -5000;

		var camPos = boyfriend.getCameraPosition();

		FlxG.camera.angle = 20 * 0.5 * FlxSimplex.simplex(deathTimer.elapsedTime/90 * 25.5, deathTimer.elapsedTime/90 * 25.5);
		camPos.x += 100 * FlxSimplex.simplex(deathTimer.elapsedTime/190 * 100, deathTimer.elapsedTime/190 * 100);
		camPos.y += 100 * FlxSimplex.simplex(deathTimer.elapsedTime/220 * 100, deathTimer.elapsedTime/220 * 100);

		camFollow.setPosition(camPos.x, camPos.y);
		
		if (concluded && controls.ACCEPT) {
			concluded = false;

			FlxG.sound.playMusic(Paths.sound("death/ends/default-end"));
			camHUD.fade(0xFF000000, 2, false, function() {
				justDIED = false;
				deathTimer = null;

				defaultCamZoom -= 0.3;
				FlxG.camera.zoom -= 0.3;

				var camPos = dad.getCamPos();
				camFollow.setPosition(camPos.x, camPos.y);

				FlxG.camera.angle = 0;

				remove(bar);
				remove(vignette);
				FlxG.camera.removeShader(matrixShader);

				for (i in PlayState.members) {
					if (i != null && i.exists && i.camera == FlxG.camera && i.colorTransform != null) {
						i.colorTransform.redMultiplier = 1;
						i.colorTransform.greenMultiplier = 1;
						i.colorTransform.blueMultiplier = 1;
						i.colorTransform.redOffset = 0;
						i.colorTransform.greenOffset = 0;
						i.colorTransform.blueOffset = 0;
					}
				}

				boyfriend.y = ogBFY;

				for (i in [boyfriend, dad]) { //Makes all characters go into idle. Makes the winner screens look consistent.
					i.lastNoteHitTime = -100000;
					i.dance(true);
				}

				camHUD.fade(0xFF000000, 1, true, function() {
					paused = false;
					blockPlayerInput = false;
					boyfriend.stunned = false;
	
					FlxG.sound.music.stop();
					inst = null;
					FlxG.switchState(new PlayState());
					loadSong(curSong,PlayState.difficulty);
				});
			});
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

	FlxTween.globalManager._tweens = [];
	FlxTimer.globalManager._timers = [];

	deathTimer = new FlxTimer().start(1000000);

	executeEvent({name: "HScript Call", params: ["reset","null"]});

	boyfriend.idleSuffix=null;
	boyfriend.playAnim('firstDeath',true);

	for (strumLine in PlayState.instance.strumLines)
    for (note in strumLine.notes) {
        remove(note);
    }
	for (strum in playerStrums.members) {
        strum.visible = false;
    }
        
    for (strum in cpuStrums.members) {
        strum.visible = false;
    }
	for (e in events) events.remove(e);

	justDIED = true;
	generatedMusic = false;
	persistentUpdate = true;
	persistentDraw = true;
	startingSong = true;
	startedCountdown = false;
	startTimer = null;
	paused = true;

	for (i in members) {
		if (i != null && i.exists && i.camera == camHUD && i.alpha != null) {
			i.alpha = 0;
		}
	}
	iconP1.alpha = iconP2.alpha = 0;

	for (strumLine in PlayState.instance.strumLines)
       for (i in strumLine.notes) {
		FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.quartInOut, onComplete: function(tween) {
			i.destroy();
			//playerStrums.clear();
			//cpuStrums.clear();
		}});
	}

	//PlayState.scripts.executeFunc('setCamType', ['snap']);

	var camPos = boyfriend.getCameraPosition();
	camFollow.setPosition(camPos.x, camPos.y);
	FlxG.camera.target = camFollow;

	FlxG.camera.zoom += 0.4;
	defaultCamZoom += 0.3;

	FlxG.sound.play(Paths.sound('death/trade-wasted'));

	for (i in members) {
		if (i != null && i.exists && i.camera == FlxG.camera && i.colorTransform != null) {
			i.colorTransform.blueMultiplier = 0.9;
			i.colorTransform.redOffset = 80;
			i.colorTransform.greenOffset = 80;
			i.colorTransform.blueOffset = -100;

			FlxTween.tween(i.colorTransform, {blueMultiplier: 1, redOffset: -50, greenOffset: -50, blueOffset: -50}, 2.76, {onComplete: function(tween) {
				i.colorTransform.redMultiplier = 2;
				i.colorTransform.greenMultiplier = 2;
				i.colorTransform.blueMultiplier = 2;
				i.colorTransform.redOffset = 0;
				i.colorTransform.greenOffset = 0;
				i.colorTransform.blueOffset = 0;
				FlxTween.tween(i.colorTransform, {redMultiplier: 0.7, greenMultiplier: 0.7, blueMultiplier: 0.7,}, 2);
			}});
		}
	}

	new FlxTimer().start(2.76, function(timer) {
		FlxG.camera.zoom += 0.6;

		var t = 1/3;

		FlxG.camera.addShader(matrixShader);
		matrixShader.data.uOffsets.value = [0,0,0,0];
		matrixShader.data.uMultipliers.value = [t, t, t, 0, t, t, t, 0, t, t, t, 0, 0, 0, 0, 1];

		bar.cameras = vignette.cameras = [camHUD];
		bar.screenCenter();
		vignette.screenCenter();

		vignette.scale.set(0.8, 0.8);
		FlxTween.tween(vignette.scale, {x: 0.9, y: 0.9}, 2, {ease: FlxEase.quartOut});
		add(bar); add(vignette);
	});

	new FlxTimer().start(7, function(timer) {
		concluded = true;

		FlxG.sound.playMusic(Paths.music("death/default"));
		Conductor.changeBPM(0);

		FlxG.sound.music.volume = 1;
		FlxG.sound.music.onComplete = null;
	});

	return false;
}