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
	plaName.setPosition(healthBarBG.x, healthBarBG.y - plaName.height + 5);
	oppName.setPosition(opponentBarBG.x + opponentBarBG.width - oppName.width, plaName.y);
	plaName.cameras = oppName.cameras = [camHUD];
	add(plaName);
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