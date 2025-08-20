var colorizer = new CustomShader('colorizer');

camZooming = true;

function postCreate() {// second opponent offset
	if(strumLines.members[1].characters[0].curCharacter.toLowerCase() == "boris"){
		strumLines.members[1].characters[0].x -= 200;
		strumLines.members[1].characters[0].y += 100;
	}
	colorizer.data.colors.value = [0.064,0.127,0.292]; //https://airtightinteractive.com/util/hex-to-glsl/
	FlxG.camera.addShader(colorizer);
	camHUD.addShader(colorizer);
}
function beatHit(curBeat) {
	if (curBeat % 4 == 0)
		FlxG.camera.zoom += 0.0125;
	if ((curBeat % 2 == 0) && !(curBeat % 4 == 0) && (curBeat >= 16) && (curBeat <= 160))
	{
		FlxG.camera.zoom += 0.05;
		camHUD.zoom += 0.025;
	}
	if (curBeat >= 96) camHUD.zoom += 0.0625;
}


var freindlydead;
var justDIED = false;
var concluded = false;
function postUpdate(elapsed:Float) {
	if(FlxG.keys.justPressed.J){ health=health-0.1;
		/*var camPos = boyfriend.getCameraPosition();
		camFollow.setPosition(camPos.x, camPos.y);
		executeEvent({name: "Camera Movement", params: ["1",true]});*/
	}
	if (justDIED) {
		camZooming=false;
		Conductor.songPosition = -5000;
		if (concluded && controls.ACCEPT) {
			concluded = false;

			FlxG.sound.music.fadeOut(0.5,0);

			FlxTween.tween(freindlydead.colorTransform, {redMultiplier:0, greenMultiplier:0, blueMultiplier:0.7}, 0.25, {onComplete: function(tween) {
				FlxTween.tween(freindlydead.colorTransform, {blueMultiplier:0.0}, 0.25, {onComplete: function(tween) {
					FlxG.camera.zoom = defaultCamZoom = (curSong == 'Blusterous Day') ? 1 : 0.5;

					justDIED = false;

					paused = false;
					boyfriend.stunned = false;

					FlxG.sound.music.stop();
					//inst = null;
					FlxG.switchState(new PlayState());
					loadSong(curSong,PlayState.difficulty);
					//startCountdown();
	
				}});
			}});
		}
		if (concluded && controls.BACK) {
			FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
		}
	}
}
function onGameOver(e) {
	var camPos = boyfriend.getCameraPosition();
	if(strumLines.members[2].characters[0].curCharacter.toLowerCase() == "cubefreind"){
	camPos.x=strumLines.members[2].characters[0].x;
	camPos.y=strumLines.members[2].characters[0].y;
    }
	camFollow.setPosition(camPos.x, camPos.y);
	FlxG.camera.target = camFollow;
	//executeEvent({name: "Camera Movement", params: ["1",true]});
	PlayState.deathCounter++;
	e.cancel();
	health = 0.001;

	for (i in FlxG.sound.list) {
		i.stop();
	}
	inst.stop();
	vocals.volume = 1;

	//if (Settings.engineSettings.stageQuality != "medium" || Settings.engineSettings.stageQuality != "low") initializeShaders();
	//pixelSize = 0.01;

	FlxTween.globalManager._tweens = [];
	FlxTimer.globalManager._timers = [];

	defaultCamZoom=0.9;
	executeEvent({name: "HScript Call", params: ["reset","null"]});

	FlxTween.tween(FlxG.camera, {zoom: 0.9}, 1, {ease: FlxEase.quartInOut});
		
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
		
	var freindly = new FlxSprite(-500,-1000).loadGraphic(Paths.image('game/deathShit/freindly'));
	freindly.updateHitbox();
	freindly.antialiasing = false;
	add(freindly);

	FlxTween.tween(freindly, {x: camPos.x, y: camPos.y}, 2, {onComplete: function (tween) {
		FlxG.sound.play(Paths.sound('death/heisveryfreindly'));
		FlxG.sound.play(Paths.sound('sonic/death moment'));
			
		freindlydead = new FlxSprite().loadGraphic(Paths.image('game/deathShit/freindlyscreen'));
		freindlydead.cameras = [PlayState.instance.camHUD];
		freindlydead.antialiasing = false;
		add(freindlydead);

		freindlydead.scale.x = freindlydead.scale.y = FlxG.height / freindlydead.height;
		freindlydead.updateHitbox();
		freindlydead.screenCenter();

		camHUD._filters = [];
		FlxG.camera._filters = [];
			
		freindly.destroy();

		var freindlySub = new FlxSprite(0,0).loadGraphic(Paths.image('game/deathShit/freindlysub'));
		freindlySub.scale.set(2,2);
		freindlySub.updateHitbox();
		freindlySub.antialiasing = false;
		freindlySub.cameras = [PlayState.instance.camHUD];
		add(freindlySub);

		freindlySub.y = FlxG.height * 0.85;
		freindlySub.x = FlxG.width - freindlySub.width;

		FlxTween.tween(freindlySub, {y : freindlySub.y - 30}, 0.25, {ease: FlxEase.elasticOut, onComplete: function(twn) {
			FlxTween.tween(freindlySub, {alpha : 0}, 0.25, {onComplete: function(twn) {
				freindlySub.destroy();
			}, startDelay: 2});
		}});

		for (i in PlayState.instance.members) {
			if (i != null && i.exists && i.camera == FlxG.camera && i.colorTransform != null) {
				i.colorTransform.redMultiplier = i.colorTransform.greenMultiplier = i.colorTransform.blueMultiplier = 0;
			}
		}

		new FlxTimer().start(2.25, function(timer) {
			FlxG.sound.playMusic(Paths.music('death/freindly'));
			Conductor.changeBPM(0);

			paused = true;

			FlxG.sound.music.volume = 1;
			FlxG.sound.music.onComplete = null;

			concluded = true;
		});
	}});
	return false;
}