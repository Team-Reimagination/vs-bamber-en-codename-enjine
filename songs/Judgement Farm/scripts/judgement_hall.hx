import flixel.ui.FlxBar;

var hptexter;
var hepertexter;
import flixel.math.FlxRect;

function postCreate() {
    for(i in [scoreTxt,missesTxt,accuracyTxt])
	i.font=Paths.font('Mars_Needs_Cunnilingus.ttf');

    GameOverSubstate.firstDeathSFX = "death/starts/ut-death";
	iconP1.visible = iconP2.visible = false;
	healthBarBG.visible = false;
	remove(healthBar);
	healthBar = new FlxBar(0, 640, null, 92 * 2, 35, healthBar.parent, healthBar.parentVariable,0,2);
	healthBar.screenCenter(FlxAxes.X);
	healthBar.createFilledBar(0xFFFF0000, 0xFFfffd03);
	add(healthBar);
	var thing = new FlxSprite(-2000, PlayState.downscroll ? -10 : 600).makeGraphic(1, 1, 0xFF000000);
    thing.scale.set(5000,130); thing.updateHitbox();
	insert(0, thing);
	var nametexter = new FlxText(healthBar.x - 350, healthBarBG.y - 16, 0, "BAMBER", 30);
	add(nametexter);
	var leveltexter = new FlxText(healthBar.x - 200, healthBarBG.y - 16, 0, "LV 19", 30);
	add(leveltexter);
	hptexter = new FlxText(healthBar.x - 40, healthBarBG.y - 12, 0, "HP", 15);
	hepertexter = new FlxText(healthBar.x + (healthBar.width + 20), healthBarBG.y - 16, 0, "FHOSIOJFHSDJ", 30);
	add(hepertexter);
	thing.cameras = healthBar.cameras = nametexter.cameras = leveltexter.cameras = hptexter.cameras = hepertexter.cameras = [camHUD];
	hptexter.font = Paths.font("8bit_wonder.ttf");
	add(hptexter);
}

function update(elapsed:Float) {
    hepertexter.text = Math.min(Math.floor(health * 46), 92)  + " / 92";
}

public function creditSetup() {
	for (catIcons in songIcons) {
		for (icon in catIcons) {
			icon.destroy();
		}
	}
	songIcons = [];
	songTitle.angle = 0;

	songTitle.scale.set(1, 1); //Clipping rectangles are finicky when scale is modified so I gotta revert them to normal size for them to work seamlessly.
	songTitle.updateHitbox();
	songTitle.screenCenter();
    songTitle.y -= 50;

    remove(songTitle); insert(9, songTitle);

    //remove(songTitle); insert(PlayState.members.indexOf(strumLineNotes), songTitle);
    songTitle.antialiasing = songBG.antialiasing = false;

	for (catText in songTexts) {
		for (i in catText) {
            i.size = (catText.indexOf(i) == 0 ? 40 : 20);
            i.y = 380 + ((i.height + 10) * catText.indexOf(i));
            i.angle = 0;
            i.x = 400 - (25 * (songTexts.length/4)) + ((FlxG.width - 700) / songTexts.length * songTexts.indexOf(catText));

            if (catText.indexOf(i) == 0) i.x += (songTexts[1][0].width - i.width) / 3;
            if (catText.indexOf(i) > 0) i.y = catText[0].y + catText[0].height - 5 + (i.height - 2) * (catText.indexOf(i) - 1);
			
            remove(i); insert(9, i);

            //remove(i); insert(PlayState.members.indexOf(strumLineNotes), i);
            i.antialiasing = false;
		}
	}

    songBG.alpha = 1;
    songBG.screenCenter();
    remove(songBG); insert(9, songBG);
    //remove(songBG); insert(PlayState.members.indexOf(strumLineNotes), songBG);

    songBG.x = FlxG.width + 1000;
    
    adjustCreditClippingRects(songBG, songTitle, songTexts);
}

function adjustCreditClippingRects(masker, songTitle, songTexts) {
    songTitle.clipRect = new FlxRect((masker.x + masker.width/2 - songTitle.x), 0, songTitle.frameWidth + (masker.x + masker.width/2 - songTitle.x) * -1, songTitle.frameHeight);
    for (catText in songTexts) {
		for (i in catText) {
            i.clipRect = new FlxRect((masker.x + masker.width/2 - i.x), 0, i.frameWidth + (masker.x + masker.width/2 - i.x) * -1, i.frameHeight);
		}
	}
}

public function creditBehavior() {
	creditTweens.push(FlxTween.tween(songBG, {x: 200}, 1, {ease: FlxEase.quartOut, onUpdate: function(twn:FlxTween) {
        adjustCreditClippingRects(songBG, songTitle, songTexts);
    }}));

	return 4;
}

function creditEnding() {
	creditTweens.push(FlxTween.tween(songBG, {x: FlxG.width + 1000}, 1, {ease: FlxEase.quartIn, onUpdate: function(twn:FlxTween) {
        adjustCreditClippingRects(songBG, songTitle, songTexts);
    }, onComplete: function(tween) {
        creditsDestroy();
    }}));
}