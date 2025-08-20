import flixel.math.FlxRect;
import Main;
import flixel.text.FlxTextBorderStyle;

var timeNumbers = [];
var timeNote;
var timeCover;

var opponentBarBG;
var opponentBarFill;

var winnerDinnerChickenDinner = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/winner'));

var winnerText;

var oppName = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/Descriptor_G'));
var plaName = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/Descriptor_B'));

var opponentHealth = 2;

var playerTeam;

var bones = [];

var justDIED = false;
var concluded = false;

var gate1 = new FlxSprite(0,0).loadGraphic(Paths.image('HUD/battlegrounds/gate'));
var gate2 = new FlxSprite(0,0).loadGraphic(Paths.image('HUD/battlegrounds/gate'));
gate2.flipX = true;

var fight = new FlxSprite(0,0);

var defaultPoses = [];

var boyfriends = [];

var dads = [];

var grugSecondary = [];

var otherHitCounter:FlxText = new FlxText(-20, 400, 720, "Misses : 0", 16);

//engineSettings.scoreTxtSize = Math.min(engineSettings.scoreTxtSize, 15); //This is so that the text doesn't go off-course
function postCreate() { //this one was necessary since moving GF moves the camera as well, which we don't want
	preloadAssets();

	gf.x += 428;
	gf.y += -79;

	defaultPoses = [boyfriend.x, boyfriend.y, gf.x, gf.y, dad.x, dad.y, strumLines.members[2].characters[0].x, strumLines.members[2].characters[0].y];

	boyfriends.push(strumLines.members[2].characters[0]);
	boyfriends.push(boyfriend);
	dads.push(strumLines.members[3].characters[0]);
	dads.push(dad);
	grugSecondary.push(strumLines.members[3].characters[0]);

	health = 2; //What fighting game would it be if we didn't start at max HP?

	scoreTxt.x += 720 / 4;
	scoreTxt.y = healthBarBG.y + healthBarBG.height + 20;

	playerTeam = boyfriends.copy(); //Normally if everything was the boyfriends var, girlfiend wouldn't be included. Which is why this is necessary.
	playerTeam.push(gf); //I tried pushing gf to boyfriends but that wasn't the smartest idea.

	//Winner Screen Overlay, or a game over one
	winnerDinnerChickenDinner.scrollFactor.set();
	winnerDinnerChickenDinner.cameras = [camHUD];
	winnerDinnerChickenDinner.scale.set(3,3);
	winnerDinnerChickenDinner.updateHitbox();
	winnerDinnerChickenDinner.screenCenter();
	add(winnerDinnerChickenDinner);

	//Winner Text for the ending, or game over
	winnerText = new FlxText(0, 660, 720, 'You r did it!', 30);
	winnerText.alignment = 'center';
	winnerText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 4, 1);
	winnerText.cameras = [camHUD];
	winnerText.alpha = 0;
	add(winnerText);
	
	gate1.x -= gate1.width + 100;
	gate2.x = 720 + 100;
	gate1.cameras = [camHUD];
	gate2.cameras = [camHUD];
	add(gate1);
	add(gate2);
	gate1.visible = gate2.visible = false;
}

function onStartCountdown() {
	for (i in members) { if (Std.isOfType(i, Character) || Std.isOfType(i, Boyfriend) && i.animation != null) i.animation.curAnim = null; }
}

var preloadedAssets = [];

function preloadAssets() { //I always found this method of preloading to be the best for now
	var PREpunch = new FlxSprite(dad.x, dad.y);
	PREpunch.frames = Paths.getSparrowAtlas("battlevfx/punch");
	add(PREpunch);
	PREpunch.alpha = 0.0001;
	preloadedAssets.push(PREpunch);

	var PREblood = new FlxSprite(dad.x, dad.y);
	PREblood.frames = Paths.getSparrowAtlas("battlevfx/blood");
	add(PREblood);
	PREblood.alpha = 0.0001;
	preloadedAssets.push(PREblood);

	var PREko = new FlxSprite(dad.x, dad.y);
	PREko.frames = Paths.getSparrowAtlas("HUD/battlegrounds/knockout");
	add(PREko);
	PREko.alpha = 0.0001;
	preloadedAssets.push(PREko);

	fight.frames = Paths.getSparrowAtlas("HUD/battlegrounds/fight");
	fight.animation.addByPrefix("fight", "fight", 24, false);
	fight.animation.play("fight");
	fight.cameras = [camHUD];
	fight.screenCenter();
	add(fight);
	fight.alpha = 0.00001;
}

function update(elapsed) {
	//Positions the fps counter at the bottom when we're in downscroll to not clutter the main HUD
	if (PlayState.downscroll) Main.fps.y = FlxG.stage.window.height - 10 - 14 * (Main.fps.text.split('\n').length - 1);

	//Handler for bones that will fly out
	for (i in 0...bones.length) {
		bones[i].velocity.y += 15;

		if (bones[i].y >= boyfriend.y + 500) {
			bones[i].destroy();
			bones[i] = null;
		}
	}
	bones = bones.filter(function(i) return i != null);

	//For the ending when Manny and Grug will be flown out.
	if (curBeat >= 576) {
		dad.velocity.y += 5;
		grugSecondary.velocity.y += 5;
	}

	//Game Over Input Handler
	if (concluded || justDIED) {
		Conductor.songPosition = -5000;
		Conductor.songPositionOld = -5000;
		
		if (justDIED) {
			var camPos = dad.getGraphicMidpoint();
			camFollow.setPosition(camPos.x, camPos.y);

			if (concluded && controls.ACCEPT) {
				concluded = false;

				FlxG.sound.playMusic(Paths.sound(GameOverSubstate.retrySFX, 'mods/'+mod));
				FlxG.sound.play(Paths.sound('battlefx/gateclose'), 0.6);
				gate1.visible = gate2.visible = true;
				FlxTween.tween(gate2, {x: 720 / 2}, 1.5, {ease: FlxEase.quartInOut});
				FlxTween.tween(gate1, {x: 0}, 1.5, {ease: FlxEase.quartInOut, onComplete: function(tween) {
					unspawnNotes = [];
	
					strumLineNotes.clear();
					playerStrums.clear();
					cpuStrums.clear();

					hits['Sick'] = hits['Good'] =  hits['Bad'] = hits['Shit'] = combo = misses = songScore = accuracy = numberOfNotes = numberOfArrowNotes = delayTotal = 0;

					pressedArray = [];

					for (i in [boyfriend, dad, gf, grugSecondary]) {
						i.velocity.x = i.velocity.y = 0;
						i.mass = 0;

						i.lastNoteHitTime = -60000;
						i.animation.reset();
						i.animation.finish();
					}

					boyfriend.setPosition(defaultPoses[0], defaultPoses[1]);
					gf.setPosition(defaultPoses[2], defaultPoses[3]);
					dad.setPosition(defaultPoses[4], defaultPoses[5]);
					grugSecondary.setPosition(defaultPoses[6], defaultPoses[7]);

					winnerText.alpha = 0;

					PlayState.scripts.executeFunc('reset', []);

					defaultCamZoom = 0.9;

					new FlxTimer().start(1.5, function(tmr:FlxTimer) {
						FlxG.sound.play(Paths.sound('battlefx/gateopen'), 0.6);

						FlxTween.tween(winnerDinnerChickenDinner.scale, {x: 3, y: 3}, 1, {ease: FlxEase.quartInOut, onUpdate: function() {
							winnerDinnerChickenDinner.updateHitbox();
							winnerDinnerChickenDinner.screenCenter();
						}});	

						FlxTween.tween(gate2, {x: 720 + 100}, 1.5, {ease: FlxEase.quartInOut});
						FlxTween.tween(gate1, {x: 0 - gate1.width - 100}, 1.5, {ease: FlxEase.quartInOut, onComplete: function(tween) {
							gate1.visible = gate2.visible = false;
							justDIED = false;
							paused = false;
							blockPlayerInput = false;
							boyfriend.stunned = false;

							FlxG.sound.music.stop();
							inst = null;
							generateSong(PlayState.SONG.song);
							startCountdown();

							PlayState.scripts.executeFunc('setSplashes', []);

							health = 2;
							opponentHealth = 2;

							remove(strumLineNotes);
							insert(PlayState.members.indexOf(PlayState.scripts.getVariable('bar2'))+1, strumLineNotes);
							remove(notes);
							insert(PlayState.members.indexOf(strumLineNotes)+1, notes);

							for (elem in [
								iconP1, iconP2, scoreTxt, healthBarBG, hitCounter, opponentBarBG, opponentBarFill, oppName, plaName, timeCover, timeNote, timeNumbers[0], timeNumbers[1], timeNumbers[2]
							])
							{
								if (elem != null)
								{
									FlxTween.tween(elem, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
								}
							}
						}});
					});
				}});
			}
	
			if (concluded && controls.BACK) {
				FlxG.save.data.vs_bamber_hasDiedInThisSong = null;
				FlxG.switchState(new FreeplayState());
			}
		} else {
			var camPos = gf.getGraphicMidpoint();
			camFollow.setPosition(camPos.x, camPos.y);

			if (concluded && controls.ACCEPT) endSong();
		}
	}
}

//Makes the player punch with every note hit. At least ones that warrant it.
function onPlayerHit(note) {
	if (!note.isSustainNote && Math.floor(note.noteData / (PlayState.SONG.keyNumber * 2)) != 5) {
		opponentHealth -= 0.0015;
		punch(dads, FlxG.random.int(0,dads.length-1), FlxG.random.int(0,100) > 80, FlxG.random.int(0,100) > 80);
	}
}

//An Effect for when a miss occurs, regular or ghost tapping misses.
function miss() {
	punch(playerTeam, FlxG.random.int(0,playerTeam.length-1), true, true);
	PlayState.scripts.executeFunc('shake', [0.5]);
}

//Handler for Big Hits
function beatHit(curBeat) {
	if (curBeat == 256 || curBeat == 576) {
		opponentHealth = curBeat == 256 ? 1.25 : 0; //Fakes the damage the big hit does, it's static
		var xPoses = [boyfriend.x, gf.x]; //Saves positions for later
		punch(dads, 0, true, true); //Punches to the opponent
		punch(dads, 1, true, true);

		FlxG.camera.flash(0xFFFFFFFF, 0.5);

		//Move Player Position
		dad.x = defaultPoses[4];
		grugSecondary.x = defaultPoses[6];
		gf.x = dad.x + dad.width/2;
		boyfriend.x = grugSecondary.x + grugSecondary.width/2;

		if (curBeat == 256) {
			FlxTween.tween(gf, {x: xPoses[1]}, 1.5, {ease: FlxEase.backIn});
			FlxTween.tween(boyfriend, {x: xPoses[0]}, 1.5, {ease: FlxEase.backIn});

			FlxG.sound.play(Paths.sound('battlefx/powerhit'), 0.6);
			inst.volume = vocals.volume = 0.3;
			inst.pitch = vocals.pitch = 0.1;
			FlxTween.tween(inst, {volume: 1, pitch: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 0.75});
			FlxTween.tween(vocals, {volume: 1, pitch: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 0.75});
			new FlxTimer().start(0.5, function(timer:FlxTimer) {
				fight.alpha = 1;
				fight.animation.play('fight');
				FlxG.sound.play(Paths.sound('battlefx/fight'), 0.6);
				fight.animation.finishCallback = function(name){
					FlxTween.tween(fight, {alpha: 0}, 0.5, {ease: FlxEase.quartIn});
				};
			});
		} else {
			FlxTween.globalManager._tweens = [];
			//PlayState.scripts.executeFunc('onPsychEvent', ['Change Bars Size', 20, 0.1]);
			FlxG.sound.music.onComplete = null;
			conclusion(playerTeam, dads); //ENDING
		}

		FlxG.camera.zoom += curBeat == 256 ? 0.25 : 0.5;

		//Moves the Camera to the action
		/*var camera_follow = PlayState.scripts.getVariable('cameraFollow');
		FlxTween.tween(camera_follow, {x: camera_follow.x - 600}, 0.1, {ease: FlxEase.quartOut});

		PlayState.scripts.executeFunc('shake', [20]);*/
	}
}

/* FUNCTION FOR PUNCHINES
- Target Team - Which Side To Inflict Hurt On
- ID - Individual ID of the target to hit (relies on dads and playerTeam vars. playerTeam means boyfriend, but will also include GF here.)
- Allow Blood? - Will Spawn Blood Alongside Punches
- Allow Bone Breaking? - - Will Spawn a Bone Alongside Punches
*/

function punch(targetTeam, targetID, allowBlood, allowBone) {
	var fxPosition = targetTeam[targetID].getGraphicMidpoint();
	fxPosition.x += FlxG.random.int(-targetTeam[targetID].width/3,targetTeam[targetID].width/3);
	fxPosition.y += FlxG.random.int(-targetTeam[targetID].height/3,targetTeam[targetID].height/3);

	FlxG.sound.play(Paths.sound('battlefx/punch'+FlxG.random.int(1,3)), 0.4);

	var punch = new FlxSprite(fxPosition.x, fxPosition.y);
	punch.frames = Paths.getSparrowAtlas("battlevfx/punch");
	punch.animation.addByPrefix("idle", "Punch"+Std.string(FlxG.random.int(1,5)), 24, false);
	punch.animation.play("idle");

	punch.x -= punch.width/2;
	punch.y -= punch.height/2;

	if (targetTeam == dads) punch.flipX = true;

	insert(members.indexOf(targetTeam[targetID])+1,punch);
	punch.animation.finishCallback = function(name){
		punch.destroy();
	};

	if (allowBlood) {
		FlxG.sound.play(Paths.sound('battlefx/blood'+FlxG.random.int(1,4)), 0.4);

		var blood = new FlxSprite(fxPosition.x, fxPosition.y);
		blood.frames = Paths.getSparrowAtlas("battlevfx/blood");
		blood.animation.addByPrefix("idle", "Blood"+Std.string(FlxG.random.int(1,4)), 24, false);
		blood.animation.play("idle");

		blood.scale.set(1.5, 1.5);
		blood.updateHitbox();

		blood.x -= blood.width/2;
		blood.y -= blood.height/2;

		if (targetTeam == dads) blood.flipX = true;
		
		insert(members.indexOf(targetTeam[targetID])+1,blood);
		blood.animation.finishCallback = function(name){
			blood.destroy();
		};
	}

	if (allowBone) {
		FlxG.sound.play(Paths.sound('battlefx/bone'+FlxG.random.int(1,2)), 0.4);

		var bone = new FlxSprite(fxPosition.x, fxPosition.y).loadGraphic(Paths.image('battlevfx/bone'));
		bone.x -= bone.width/2;
		bone.y -= bone.height/2;
		insert(members.indexOf(targetTeam[targetID])+1, bone);
		bones.push(bone);

		bone.velocity.y = FlxG.random.float(-750,-1250);
		bone.velocity.x = FlxG.random.float(100,1000) * (targetTeam == playerTeam ? 1 : -1);
		bone.angularVelocity = FlxG.random.float(1000,3000) * (targetTeam == playerTeam ? 1 : -1);
	}
}

function conclusion(winningTeam, losingTeam) {
	FlxG.sound.play(Paths.sound('battlefx/powerhit'), 0.6);

	winnerText.text = 'You r did it!';

	fight.alpha = 0;

	for (i in preloadedAssets) {
		i.y = 100000;
	}

	FlxG.sound.play(Paths.sound('battlefx/ko'), 1);
	var ko = new FlxSprite();
	ko.frames = Paths.getSparrowAtlas("HUD/battlegrounds/knockout");
	ko.animation.addByPrefix("idle", 'knockout', 24, false);
	ko.animation.play("idle");
	ko.cameras = [camHUD];
	ko.screenCenter();
	add(ko);
	ko.animation.finishCallback = function(name){
		FlxTween.tween(ko, {alpha: 0}, 1, {ease: FlxEase.quartIn, onComplete: function(tween) {
			ko.destroy();
		}});
	};

	inst.volume = vocals.volume = 0.3;
	inst.pitch = vocals.pitch = 0.1;
	FlxTween.tween(inst, {volume: 1, pitch: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 0.75});
	FlxTween.tween(vocals, {volume: 1, pitch: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 0.75, onComplete: function(tween) {
		winnerDinnerChickenDinner.alpha = 1;

		PlayState.scripts.executeFunc('onPsychEvent', ['Change Bars Size', 0, 2]);
	}});

	FlxG.camera.bgColor = 0xFFFFFFFF;

	for (i in members) {
		if (i != null && i.exists) {
			if (i.camera == FlxG.camera) {
				if (i.name != null && (i.name == 'vs' || i.name == 'bg')) {i.alpha = 0; FlxTween.tween(i, {alpha: 1}, 1.5, {ease: FlxEase.quartInOut, startDelay: 1.25});}
				else { 
					if (i.color != null) {i.color = 0xFF000000; FlxTween.color(i, 1.5, 0xFF000000, 0xFFFFFFFF, {ease: FlxEase.quartInOut, startDelay: 0.75});}
				}
			} /*else if (i.camera == camHUD) {
				if (i != null && i.exists && i.camera == camHUD && i.alpha != null && ![PlayState.scripts.getVariable('bar1'), PlayState.scripts.getVariable('bar2'), gate1, gate2, ko].contains(i)
					&& !comboObjects.contains(i)) {
					FlxTween.tween(i, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});
				}
			}*/
		}
	}

	/*for (i in strumLineNotes.members) {
		FlxTween.tween(i, {alpha: 0}, 5, {ease: FlxEase.quartInOut, onComplete: function(tween) {
			if (winnerText.text == 'You r did it!') {
				i.destroy();
				playerStrums.clear();
				cpuStrums.clear();
				concluded = true;

				FlxG.sound.play(Paths.sound('battlefx/winnerappear'), 1);

				FlxTween.tween(winnerDinnerChickenDinner.scale, {x: 1, y: 1}, 0.75, {ease: FlxEase.quartInOut, onUpdate: function() {
					winnerDinnerChickenDinner.updateHitbox();
					winnerDinnerChickenDinner.screenCenter();
				}});

				FlxTween.tween(winnerText, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});

				if (justDIED) {
					FlxG.sound.playMusic(Paths.music(GameOverSubstate.gameOverMusic));
					winnerText.text = 'Game Over! Press CONFIRM to try again, or BACK to leave.';
				} else {
					FlxG.sound.playMusic(Paths.music('winnerWinner'));
					winnerText.text = 'You win this deathmatch! Press CONFIRM to proceed!';
				}

				FlxG.sound.music.volume = 1;
				FlxG.sound.music.onComplete = null;
			}
		}});
	}*/

	persistentUpdate = true;
	persistentDraw = true;
	startingSong = true;
	startedCountdown = false;
	guiElemsPopped = false;
	startTimer = null;

	for (i in losingTeam) {
		i.mass = 10;
		i.velocity.y = -1000;
		i.velocity.x = (winningTeam == dads ? 150 : -150);
	}

	FlxTween.tween(iconP1, {alpha: 0}, 0.75, {ease: FlxEase.quartIn});
	FlxTween.tween(iconP2, {alpha: 0}, 0.75, {ease: FlxEase.quartIn, onComplete: function(tween) {
		for (i in [boyfriend, dad, gf, grugSecondary]) { //Makes all characters go into idle. Makes the winner screens look consistent.
			i.playAnim("idle");
			i.dance(true);
		}
	}});
}