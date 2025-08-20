var freindlydead;
var justDIED = true;
var concluded = true;
/*
function update(elapsed) {
	if (justDIED) {
		Conductor.songPosition = -5000;
		Conductor.songPositionOld = -5000;
		
		if (concluded && controls.ACCEPT) {
			concluded = false;

			FlxG.sound.music.fadeOut(0.5,0);

			FlxTween.tween(freindlydead.colorTransform, {redMultiplier:0, greenMultiplier:0, blueMultiplier:0.7}, 0.25, {onComplete: function(tween) {
				FlxTween.tween(freindlydead.colorTransform, {blueMultiplier:0.0}, 0.25, {onComplete: function(tween) {
					pixelSize = (PlayState.SONG.song == "Fortnite Duos" ? 22 : (PlayState.SONG.song == "Blusterous Day" ? 10 : 0.1));
					if (Settings.engineSettings.stageQuality != "medium" || Settings.engineSettings.stageQuality != "low")
						initializeShaders();

					FlxG.camera.zoom = PlayState.defaultCamZoom = (PlayState.SONG.song == 'Blusterous Day') ? 1 : 0.5;

					unspawnNotes = [];

					hits['Sick'] = hits['Good'] =  hits['Bad'] = hits['Shit'] = combo = misses = songScore = accuracy = numberOfNotes = numberOfArrowNotes = delayTotal = 0;

					pressedArray = [];

					for (i in [boyfriend, dad, borisSecondary, gf]) { //Makes all characters go into idle. Makes the winner screens look consistent.
						if (i != null) {
							i.lastNoteHitTime = -100000;
							i.dance(true);
						}
					}

					justDIED = false;

					paused = false;
					blockPlayerInput = false;
					engineSettings.resetButton = wasResetButton;
					boyfriend.stunned = false;
	
					strumLineNotes.clear();
					playerStrums.clear();
					cpuStrums.clear();
	
					FlxG.sound.music.stop();
					inst = null;
					PlayState.scripts.executeFunc('songEvents', []);
					generateSong(PlayState.SONG.song);
					startCountdown();

					PlayState.scripts.executeFunc('setSplashes', []);
	
					health = 1;
	
					remove(strumLineNotes);
					insert(PlayState.members.indexOf(iconGroup), strumLineNotes);
					remove(notes);
					insert(PlayState.members.indexOf(strumLineNotes)+1, notes);
	
					if (engineSettings.watermark) {
						FlxTween.cancelTweensOf(watermark);
					}
	
					for (elem in [
						iconP1, iconP2, scoreText, healthBarBG, timerBG, hitCounter, timerNow, timerFinal, timerText, timerBar, healthBar, watermark
					])
					{
						if (elem != null)
						{
							elem.alpha = 0;
							FlxTween.tween(elem, {alpha: 1}, 0.75, {ease: FlxEase.quartOut});
						}
					}
					FlxTween.tween(healthBar, {alpha: 1}, 0.75, {ease: FlxEase.quartOut});

					for (i in PlayState.members) {
						if (i != null && i.exists && i.colorTransform != null) {
							i.colorTransform.redMultiplier = i.colorTransform.greenMultiplier = i.colorTransform.blueMultiplier = 0;

							FlxTween.tween(i.colorTransform, {blueMultiplier:0.7}, 0.3, {onComplete: function(tween) {
								FlxTween.tween(i.colorTransform, {redMultiplier:1, greenMultiplier:1, blueMultiplier:1}, 0.3);
							}});
						}
					}
				}});

				freindlydead.destroy();
			}});
		}

		if (concluded && controls.BACK) {
			FlxG.save.data.vs_bamber_hasDiedInThisSong = null;
			FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
		}
	}
}
*/

function postCreate() {
	if (PlayState.instance.health <= 2) {
		PlayState.instance.health = 0.001;

		//vocals.volume = 1;

		/*if (Settings.engineSettings.stageQuality != "medium" || Settings.engineSettings.stageQuality != "low") initializeShaders();
		pixelSize = 0.01;

		FlxTween.globalManager._tweens = [];
		FlxTimer.globalManager._timers = [];

		PlayState.scripts.executeFunc('onPsychEvent', ['Change Default Zoom', 0.9]);
		PlayState.scripts.executeFunc('reset', []);

		*/

		FlxTween.tween(FlxG.camera, {zoom: 0.9}, 1, {ease: FlxEase.quartInOut});
		
		for (strumLine in PlayState.instance.strumLines)
        for (note in strumLine.notes) {
            remove(note);
        }

		//for (e in events) events.remove(e);

		justDIED = true;
		blockPlayerInput = true;
		currentSustains = [];
		generatedMusic = false;
		persistentUpdate = true;
		persistentDraw = true;
		startingSong = true;
		startedCountdown = false;
		guiElemsPopped = false;
		startTimer = null;

		FlxTween.tween(PlayState.instance.iconP1, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});
		FlxTween.tween(PlayState.instance.iconP2, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});

		for (strumLine in PlayState.instance.strumLines)
        for (i in strumLine.notes) {
			FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.quartInOut, onComplete: function(tween) {
				i.destroy();
				//playerStrums.clear();
				//cpuStrums.clear();
			}});
		}
		
		var freindly = new FlxSprite(-500,-1000).loadGraphic(Paths.image('deathShit/freindly'));
		freindly.updateHitbox();
		freindly.antialiasing = false;
		add(freindly);

		FlxTween.tween(freindly, {x: PlayState.instance.boyfriend.x, y: PlayState.instance.boyfriend.y}, 2, {onComplete: function (tween) {
			/*FlxG.sound.play(Paths.sound('death/heisveryfreindly', 'mods/'+mod));
			FlxG.sound.play(Paths.sound('sonic/death moment', 'mods/'+mod));
			*/
			freindlydead = new FlxSprite().loadGraphic(Paths.image('game/deathShit/freindlyscreen'));
			freindlydead.cameras = [PlayState.instance.camHUD];
			freindlydead.antialiasing = false;
			add(freindlydead);

			freindlydead.scale.x = freindlydead.scale.y = FlxG.height / freindlydead.height;
			freindlydead.updateHitbox();
			freindlydead.screenCenter();

			/*camHUD._filters = [];
			FlxG.camera._filters = [];
			*/
			freindly.destroy();

			var freindlySub = new FlxSprite(0,0).loadGraphic(Paths.image('deathShit/freindlysub'));
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
				//FlxG.sound.playMusic(Paths.music('death/freindly', 'mods/'+mod));

				FlxG.sound.music.volume = 1;
				FlxG.sound.music.onComplete = null;

				concluded = true;
			});
		}});

		return false;
	}
}