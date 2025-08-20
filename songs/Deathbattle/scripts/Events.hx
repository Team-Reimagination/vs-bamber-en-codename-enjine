import flixel.text.FlxTextBorderStyle;
import openfl.display.BlendMode;
import flixel.math.FlxRect;
import Main;

importScript("data/scripts/secondCharHandler");

var oppName = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/Descriptor_G'));
var plaName = new FlxSprite().loadGraphic(Paths.image('HUD/battlegrounds/Descriptor_B'));

var opponentBarBG;
var opponentBarFill;

var opponentHealth = 2;

function postCreate(){ // second opponent offset
	if(strumLines.members[3].characters[0].curCharacter.toLowerCase() == "yr-davey"){
		strumLines.members[3].characters[0].x = 1100;
		strumLines.members[3].characters[0].y -= 270;
	}
    if(strumLines.members[2].characters[0].curCharacter.toLowerCase() == "grug"){
		strumLines.members[2].characters[0].x = -100;
		strumLines.members[2].characters[0].y += 100;
	}
	oppName.y=600;
	plaName.y=600;
	plaName.x=1000;
	plaName.cameras = oppName.cameras = [camHUD];
	add(plaName);
	add(oppName);
	scoreTxt.x += 720 / 4;
	scoreTxt.y = healthBarBG.y + healthBarBG.height + 20;

	for(i in [scoreTxt,missesTxt,accuracyTxt])
	i.font=Paths.font('Impact.ttf');

	opponentBarFill = new FlxSprite(healthBarBG.x, healthBarBG.y).loadGraphic(Paths.image('game/healthbars/battlegrounds/HealthBar'));
	opponentBarBG = new FlxSprite(healthBarBG.x, healthBarBG.y).loadGraphic(Paths.image('game/healthbars/battlegrounds/HealthFill'));

	opponentBarBG.x = opponentBarFill.x -= FlxG.width / 2;

	opponentBarBG.cameras = opponentBarFill.cameras = [camHUD];

	opponentBarBG.flipX = opponentBarFill.flipX = true;

	var color_2 = dad.iconColor;
    var colorShader_2 = new CustomShader("ColoredNoteShader");
    colorShader_2.r = ((color_2 >> 16) & 0xFF);
    colorShader_2.g = ((color_2 >> 8) & 0xFF);
    colorShader_2.b = ((color_2) & 0xFF);
    opponentBarFill.shader = colorShader_2;

	insert(members.indexOf(healthBarBG),opponentBarBG);
    insert(members.indexOf(healthBarBG)+1,opponentBarFill);

	opponentBarBG.alpha = 0;
	FlxTween.tween(opponentBarBG, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
	opponentBarFill.alpha = 0;
	FlxTween.tween(opponentBarFill, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});

	//healthBarBG1.loadGraphic(Paths.image('HUD/'+barType_directory+'/HealthBar'));

	healthBarBG1.cameras = [camHUD];

	healthBarBG1.setPosition(healthBarBG.x, healthBarBG.y);

	var color = boyfriend.iconColor;
    var colorShader = new CustomShader("ColoredNoteShader");
    colorShader.r = ((color >> 16) & 0xFF);
    colorShader.g = ((color >> 8) & 0xFF);
    colorShader.b = ((color) & 0xFF);
	healthBarBG1.shader = colorShader;

	healthBarBG.x = healthBarBG1.x += FlxG.width / 4;

	insert(members.indexOf(iconP1),healthBarBG1);

	healthBarBG1.loadGraphic(Paths.image('game/healthbars/battlegrounds/HealthFill'));
}

function postUpdate(elapsed:Float) {
	if (creditTimer != null) creditTimer.active = !paused;
	opponentBarBG.clipRect = new FlxRect(0, 0, (opponentBarBG.frameWidth - (opponentBarBG.frameWidth / 2 * opponentHealth)), opponentBarBG.frameHeight);
    opponentBarFill.clipRect = new FlxRect(opponentBarBG.frameWidth - (opponentBarBG.frameWidth / 2 * opponentHealth), 0, opponentBarBG.frameWidth - (opponentBarBG.frameWidth - (opponentBarBG.frameWidth / 2 * opponentHealth)), opponentBarBG.frameHeight);

	var healthBarBG1=healthBarBG1;
	healthBarBG1.clipRect = new FlxRect(0, 0, (healthBarBG1.frameWidth - (healthBarBG1.frameWidth / 2 * health)), healthBarBG1.frameHeight);
    healthBarBG.clipRect = new FlxRect(healthBarBG.frameWidth - (healthBarBG.frameWidth / 2 * health), 0, healthBarBG.frameWidth - (healthBarBG.frameWidth - (healthBarBG.frameWidth / 2 * health)), healthBarBG.frameHeight);

	if (iconP1) {
			iconP1.x = FlxG.width- 10 - iconP1.width;
			iconP1.health = (healthBar.percent / 100);
		} else {
			iconP2.x = 10;
			iconP2.health = (opponentHealth / 2);
		}
		iconP1.y = healthBar.y + (healthBar.height / 2) - (iconP1.height / 2);
}

var activateCreaits = false;
public function creditUpdate(songBG, songTitle, songTexts, songIcons, elapsed) {
	if (activateCreaits) {
		for (catText in songTexts) {
			for (i in catText) {
				i.updateMotion(elapsed); //for some reason you have to call it, it doesn't work without it on YCE
			}
		}
	}
}

public function creditSetup() {
	songBG.blend = 0;
	songTitle.angle = -20;

	songTitle.frames = Paths.getSparrowAtlas("game/titles/Deathbattle");
	for (i in 1...11) {
		songTitle.animation.addByPrefix(i, i+'Title', 24, true);
	}

	songTitle.scale.set(1.01,1.01); songTitle.updateHitbox();

	var chance = FlxG.random.int(0,100);
	if (chance > 95) {
		songTitle.frames = Paths.getSparrowAtlas("HUD/battlegrounds/Horse Plinko");
		songTitle.animation.addByPrefix("Horse Plinko", 'Horse Plinko', 24, true);
		songTitle.animation.play("Horse Plinko");

		songTitle.scale.set(3,3); songTitle.updateHitbox(); songTitle.y += 40;
	} else if (chance > 70) {
		songTitle.animation.play(FlxG.random.int(2,10));
	} else {
		songTitle.animation.play("1");
	}

	songTitle.screenCenter(); songBG.screenCenter();
	songTitle.visible = false;
	songTitle.x = 0 - songTitle.width/2;

	songBG.x = 0;
	songBG.y += 180;
	songBG.scale.set(0,0); songBG.updateHitbox();

	remove(songBG); insert(18, songBG);
	remove(songTitle); insert(18, songTitle);
	//remove(songBG); insert(members.indexOf(strumLineNotes), songBG);
	//remove(songTitle); insert(members.indexOf(strumLineNotes), songTitle);

	for (catText in songTexts) {
		for (i in catText) {
			i.visible = false;
			i.y -= 720;
			i.angle = [10,5,-20,0,10][songTexts.indexOf(catText)] + FlxG.random.int(-2, 2);
			i.x = 0 - i.width/2 + FlxG.random(-15, 15);

			remove(i); insert(18, i);
			//remove(i); insert(members.indexOf(strumLineNotes), i);
		}
	}

	for (catIcons in songIcons) {
		for (i in catIcons) {
			i.visible = false;
			i.y -= 720;
			i.angle = songTexts[songIcons.indexOf(catIcons)][catIcons.indexOf(i)].angle + FlxG.random.int(-20, 20);
			i.x = songTexts[songIcons.indexOf(catIcons)][catIcons.indexOf(i)].x - i.width/2 - 30 + FlxG.random(-15, 15);

			remove(i); insert(18, i);
			//remove(i); insert(PlayState.members.indexOf(strumLineNotes), i);
		}
	}
}

public function creditBehavior() {
	activateCreaits = true;

	creditTweens.push(FlxTween.tween(songBG.scale, {x: 1, y: 1}, 2, {ease: FlxEase.backOut}));
	songBG.angularVelocity = 40;

	songTitle.visible = true;
	songTitle.velocity.set(FlxG.random.int(1900,2500), FlxG.random.int(-800,-700));
	songTitle.acceleration.set(20, 1500);
	songTitle.angularVelocity = FlxG.random.int(10,50);

	creditTweens.push(FlxTween.tween(songTitle.velocity, {x: songTitle.velocity.x * 0.03, y: songTitle.velocity.y * 0.03}, 1, {ease: FlxEase.quartOut}));
	creditTweens.push(FlxTween.tween(songTitle.acceleration, {x: songTitle.acceleration.x * 0.003, y: songTitle.acceleration.y * 0.003}, 1, {ease: FlxEase.quartOut}));
	creditTweens.push(FlxTween.tween(songTitle, {angularVelocity: songTitle.angularVelocity * 0.03}, 1, {ease: FlxEase.quartOut}));

	creditTweens.push(FlxTween.tween(songBG, {angularVelocity: songTitle.angularVelocity * 0.03}, 1, {ease: FlxEase.quartOut}));

	for (catText in songTexts) {
		for (i in catText) {
			i.visible = true;
			i.velocity.set([500,1000,1600,2200,3000][songTexts.indexOf(catText)] + FlxG.random.int(-100,100), [-200 + FlxG.random.int(-100,200),40 + FlxG.random.int(-200,100),-300 + FlxG.random.int(-100,400),-50 + FlxG.random.int(-100,100),-500 + FlxG.random.int(-100,600)][songTexts.indexOf(catText)] + 20 * (catText.indexOf(i)));
			i.acceleration.set(20, 1500);
			i.angularVelocity = FlxG.random.int(100,200);

			creditTweens.push(FlxTween.tween(i.velocity, {x: i.velocity.x * 0.03, y: i.velocity.y * 0.03}, 1, {ease: FlxEase.quartOut}));
			creditTweens.push(FlxTween.tween(i.acceleration, {x: i.acceleration.x * 0.003, y: i.acceleration.y * 0.003}, 1, {ease: FlxEase.quartOut}));
			creditTweens.push(FlxTween.tween(i, {angularVelocity: i.angularVelocity * 0.03}, 1, {ease: FlxEase.quartOut}));
		}
	}

	for (catIcons in songIcons) {
		for (i in catIcons) {
			i.visible = true;
			i.velocity.set(songTexts[songIcons.indexOf(catIcons)][catIcons.indexOf(i)].velocity.x, songTexts[songIcons.indexOf(catIcons)][catIcons.indexOf(i)].velocity.y);
			i.acceleration.set(20, 1500);
			i.angularVelocity = FlxG.random.int(-3000,5000);
			
			creditTweens.push(FlxTween.tween(i.velocity, {x: i.velocity.x * 0.03, y: i.velocity.y * 0.03}, 1, {ease: FlxEase.quartOut}));
			creditTweens.push(FlxTween.tween(i.acceleration, {x: i.acceleration.x * 0.003, y: i.acceleration.y * 0.003}, 1, {ease: FlxEase.quartOut}));
			creditTweens.push(FlxTween.tween(i, {angularVelocity: i.angularVelocity * 0.03}, 1, {ease: FlxEase.quartOut}));
		}
	}

	return 4;
}

var creditTimer;

public function creditEnding() {
	creditTweens.push(FlxTween.tween(songTitle.velocity, {x: songTitle.velocity.x * 30, y: songTitle.velocity.y * 30}, 1, {ease: FlxEase.quartIn}));
	creditTweens.push(FlxTween.tween(songTitle.acceleration, {x: songTitle.acceleration.x * 300, y: songTitle.acceleration.y * 300}, 1, {ease: FlxEase.quartIn}));
	creditTweens.push(FlxTween.tween(songTitle, {angularVelocity: songTitle.angularVelocity * 30}, 1, {ease: FlxEase.quartIn}));

	creditTweens.push(FlxTween.tween(songBG, {angularVelocity: songTitle.angularVelocity * 30}, 1, {ease: FlxEase.quartOut}));
	creditTweens.push(FlxTween.tween(songBG.scale, {x: 0, y: 0}, 1, {ease: FlxEase.backIn}));

	for (catText in songTexts) {
		for (i in catText) {
			creditTweens.push(FlxTween.tween(i.velocity, {x: i.velocity.x * 30, y: i.velocity.y * 30}, 1, {ease: FlxEase.quartIn}));
			creditTweens.push(FlxTween.tween(i.acceleration, {x: i.acceleration.x * 300, y: i.acceleration.y * 300}, 1, {ease: FlxEase.quartIn}));
			creditTweens.push(FlxTween.tween(i, {angularVelocity: i.angularVelocity * 30}, 1, {ease: FlxEase.quartIn}));
		}
	}

	for (catIcons in songIcons) {
		for (i in catIcons) {
			creditTweens.push(FlxTween.tween(i.velocity, {x: i.velocity.x * 30, y: i.velocity.y * 30}, 1, {ease: FlxEase.quartIn}));
			creditTweens.push(FlxTween.tween(i.acceleration, {x: i.acceleration.x * 300, y: i.acceleration.y * 300}, 1, {ease: FlxEase.quartIn}));
			creditTweens.push(FlxTween.tween(i, {angularVelocity: i.angularVelocity * 30}, 1, {ease: FlxEase.quartIn}));
		}
	}

	creditTimer = new FlxTimer().start(2, function(timer) {
		activateCreaits = false;
		creditsDestroy();
	});
}