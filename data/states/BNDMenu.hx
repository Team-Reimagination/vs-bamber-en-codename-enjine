import funkin.backend.FunkinSprite;
import funkin.backend.system.Conductor;
import flixel.sound.FlxSound;
import flixel.util.FlxGradient;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;
import openfl.Assets;
import flixel.util.FlxAxes;
import flixel.group.FlxTypedSpriteGroup;
import flixel.FlxCamera;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.geom.Matrix;
import funkin.savedata.FunkinSave;
import flixel.FlxObject;
import Date;
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;

public static var initialized = false; //post-intro sequence check
public static var isInMenu = false; //if the player is on the main menu or the title screen

var skippableTweens = []; //Tweens that will be stored here will be skipped when you restart the state, or if you go into it from somewhere else

var earth, cloudEmitter, windEmitter, fallingBF, fallingGF, birdFlock, preTitleTextGroup, parachute; //they all don't get assigned anything if the state was initialized beforehand
var logo, foreground, background, clouds, mainCharacterDiffs, mainCharacters, characterGroup, logoHitbox, holeEasterEgg, teamText, startBar, startText; //THESE on the other hand...

//MENU STUFF
public static var menuGroupDrags = [-250, 250]; //I'm doing it like this cuz I want you to be able to drag them for secret messages out of bounds
var topMenuGroup, bottomMenuGroup;
var topBar, bottomBar;
var buttonGroup;
var buttonSubgroup;
var buttonText;

var menuOptions = ['Play', 'Gallery', 'Achievements', 'Options', 'Credits'];
var submenuOptions = ['Story Mode', 'Freeplay'];

public static var menuSelection = 0;
public static var menuSubmenuSelection = 0;
public static var submenuOpened = false;

//SFX
var windAmbience, vinylSound;

public static var logoLerping = [FlxG.width/2, FlxG.height/2, 1]; //This will adjust the position of the logo
public static var barLerping = 0; //Bar Scale

var skybox = new FlxGradient().createGradientFlxSprite(1, 66, [0xFF272BC2, 0xFF007DE7, 0xFF74E9FF, 0xFFDBF9FF]); skybox.scale.set(FlxG.width,FlxG.height/64); skybox.screenCenter(); //Skybox

//TEXT GROUPS
var curWacky = [];
var usedTexts = [];

//POST-PROCESSING
var blurFilter:BitmapFilter;
var menuCamera;

var conditionProcess = false; //When you can progress

var currentlyUsedObjects = []; //For clickable objects, where they are going through a something

//Week Score Checker Per Character
function checkDifficultyDiscover(weekName, ?doCheckDifficulty = true) {
    var found = null;

    if (FlxG.save.data.gameStats.discoveries[weekName]) {
        found = (doCheckDifficulty == true ? 'Easy' : true);

        if (doCheckDifficulty) {
            for (diff in ['Hard', 'Normal']) {if (FunkinSave.getWeekHighscore(weekName, diff).score != 0) {found = diff; break;}}
        }
    } else {
        found = (doCheckDifficulty == true ? 'Locked' : false);
    }

    return found;
}

function getName(char, index) {
    return char + '_' + mainCharacterDiffs[index];
}

var easterEggs = [FlxG.random.int(1,100) == 50, FlxG.random.int(1,10) == 5, FlxG.random.int(1,50) == 25]; //Replace Screen With Hole, Fire In The Hole, Isaac Alt Animations

if (!easterEggs[0]) {
    characterGroup = new FlxTypedSpriteGroup(FlxG.width/2 + 220, FlxG.height*2.5);

    //TITLE SCREEN CHARACTER DEFINITIONS
    mainCharacterDiffs = [checkDifficultyDiscover("Bamber's Farm", true), checkDifficultyDiscover("Davey's Yard", true), checkDifficultyDiscover("Romania Outskirts", true)];
    mainCharacters = [
        {
            "sheet": getName("Davey", 1),
            "isLocked": (mainCharacterDiffs[1] == "Locked"),
            "isLocked": true,
            "isClicked": false,
            "loopCount": 0,
            "left": 0,
            "bounds": switch (mainCharacterDiffs[1]) {case "Easy": [400,322,304]; case "Normal": [360,357,349]; case "Hard": [430,240,390];},
            "anims": {
                "idleIndexes": [[for (i in 1...14) i],[for (i in 14...28) i]],
                "clickIndexes": switch (mainCharacterDiffs[1]) {case "Easy": [for (i in 29...41) i]; case "Normal": [for (i in 29...37) i]; case "Hard": [for (i in 29...55) i];},
                "extraIndexes": switch (mainCharacterDiffs[1]) {case "Easy": [for (i in 41...53) i]; case "Normal": [36,36,36,36,36,36,36,36,36,36,36,36,36,36,36]; case "Hard": [for (i in 70...91) i];},
                "returnIndexes": switch (mainCharacterDiffs[1]) {case "Easy": [for (i in 53...65) i]; case "Normal": [36,35,34,33,32,31,30,29]; case "Hard": [for (i in 91...98) i];},
            }
        },
        {
            "sheet": getName("RnB", 2),
            "isLocked": (mainCharacterDiffs[2] == "Locked"),
            "isLocked": true,
            "isClicked": false,
            "loopCount": 0,
            "left": 0,
            "bounds": switch (mainCharacterDiffs[2]) {case "Easy": [-470,214,364]; case "Normal": [-460,261,382]; case "Hard": [-420,343,503];},
            "anims": {
                "idleIndexes": [[for (i in 1...15) i]],
                "clickIndexes": switch (mainCharacterDiffs[2]) {case "Easy": [for (i in 15...23) i]; case "Normal": [for (i in 15...26) i]; case "Hard": [for (i in 15...24) i];},
                "extraIndexes": switch (mainCharacterDiffs[2]) {case "Easy": [for (i in 23...31) i]; case "Normal": [25,25,25,25,25,25,25,25,25,25]; case "Hard": [22,22,22,22,22,22,22,22,22,22];},
                "returnIndexes": switch (mainCharacterDiffs[2]) {case "Easy": [22,21,20,19,18,17,16,15]; case "Normal": [25,24,23,22,21,20,19,18,17,16,15]; case "Hard": [22,21,20,19,18,17,16,15];},
            }
        },
        {
            "sheet": easterEggs[2] ? 'Isaac_Alt' : 'Isaac',
            "isLocked": false,
            "isClicked": false,
            "loopCount": 0,
            "left": 0,
            "bounds": [-140,302,388],
            "anims": {
                "idleIndexes": [[for(i in 1...15) i]],
                "clickIndexes": [for(i in 15...24) i],
                "extraIndexes": [for(i in 24...32) i],
                "returnIndexes": [for(i in 32...41) i],
            }
        },
        {
            "sheet": "Gwen",
            "isLocked": false,
            "isClicked": false,
            "loopCount": 0,
            "left": 0,
            "bounds": [120,200,368],
            "anims": {
                "idleIndexes": [[for(i in 1...14) i], [for(i in 15...28) i]],
                "clickIndexes": [for(i in 29...38) i],
                "extraIndexes": [for(i in 38...45) i],
                "returnIndexes": [37,36,35,34,33,32,31,30,29],
            }
        },
        {
            "sheet": getName("Bamber", 0),
            "isLocked": (mainCharacterDiffs[0] == "Locked"),
            "isClicked": false,
            "loopCount": 0,
            "left": 0,
            "bounds": switch (mainCharacterDiffs[0]) {case "Easy": [420,136,175]; case "Normal": [330,170,220]; case "Hard": [270,205,269];},
            "anims": {
                "idleIndexes": [[for (i in 1...15) i]],
                "clickIndexes": switch (mainCharacterDiffs[0]) {case "Easy": [for (i in 15...24) i]; case "Normal": [for (i in 15...24) i]; case "Hard": [for (i in 15...22) i];},
                "extraIndexes": switch (mainCharacterDiffs[0]) {case "Easy": [23,23,23,23,23,23,23,23,23,23]; case "Normal": [23,23,23,23,23,23,23,23]; case "Hard": [for (i in 22...40) i];},
                "returnIndexes": switch (mainCharacterDiffs[0]) {case "Easy": [23,22,21,20,19,18,17,16,15]; case "Normal": [23,22,21,20,19,18,17,16,15]; case "Hard": [for (i in 40...50) i];},
            }
        }
    ];
}

function create() {
    FlxG.cameras.add(menuCamera = new FlxCamera(), false);
    menuCamera.bgColor = 0;

    if (FlxG.save.data.options.shaders == 'all') {
        blurFilter = new BlurFilter(0.0001, 0.0001, 3);
        if (FlxG.camera._filters == null) FlxG.camera._filters = [];
        FlxG.camera._filters.push(blurFilter);
    }

    skybox.antialiasing = true; add(skybox);

    if (!initialized) setupPreTitleStuff();

    setupTitleStuff();

    CoolUtil.playMenuSong(false);
    Conductor.changeBPM(150);
    FlxG.sound.music.volume = getVolume(0.3, 'music');

    beatHit(0);

    if (initialized) skipIntro();
}

function setupPreTitleStuff() {
    earth = new FlxSprite(0, FlxG.height - 250).loadGraphic(Paths.image('menus/titleScreen/Earth')); earth.antialiasing = true; add(earth);
    earth.velocity.y = -21;

    //Background Birds
    birdFlock = new FunkinSprite();
    birdFlock.loadSprite(Paths.image('menus/titleScreen/BirdFlock'));
    birdFlock.animateAtlas.anim.addBySymbol("Flock", "BirdFlock", 24, true); birdFlock.playAnim("Flock");
    birdFlock.antialiasing = true;
    birdFlock.screenCenter(); birdFlock.y = 800;
    add(birdFlock);

    birdFlock.moves = true;
    birdFlock.velocity.set(0, -60);

    //Partivle Emiters
    windEmitter = new FlxTypedEmitter(0, FlxG.height + 1000, 30);
    windEmitter.setSize(FlxG.width, 10); 
    windEmitter.launchAngle.set(-90, -90);
    windEmitter.speed.set(2500, 4000);
    windEmitter.lifespan.set(1);
    windEmitter.start(false, 0.05);

    cloudEmitter = new FlxTypedEmitter(0, FlxG.height + 1000);
    cloudEmitter.setSize(FlxG.width, 10);
    cloudEmitter.launchAngle.set(-88, -88);
    cloudEmitter.speed.set(900, 2500);
    cloudEmitter.lifespan.set(3);
    
    for (i in 0 ... 35) {
        var p = new FlxParticle();
        p.frames = Paths.getSparrowAtlas('menus/titleScreen/clouds');
        p.animation.addByPrefix('cloud', FlxG.random.int(1,9)+'_Cloud', 0, false); p.animation.play("cloud"); 
        p.scale.x = p.scale.y = FlxG.random.float(0.8, 1.6);
        p.antialiasing = true;
        p.alpha = 0.7;
        cloudEmitter.add(p);
    }
    add(cloudEmitter);
    cloudEmitter.start(false, 0.4);
    skippableTweens.push(FlxTween.tween(cloudEmitter, {frequency: 0.1}, 9));

    //Falling Chaaracters
    fallingBF = new FlxSprite(100, 100); fallingBF.frames = Paths.getSparrowAtlas('menus/titleScreen/Falling_BF'); fallingBF.animation.addByPrefix('falling', 'Falling_BF', 24, true); fallingBF.animation.play('falling'); fallingBF.antialiasing = true; add(fallingBF);
    fallingGF = new FlxSprite(230, -350); fallingGF.frames = Paths.getSparrowAtlas('menus/titleScreen/Falling_GF'); fallingGF.animation.addByPrefix('falling', 'Falling_GF', 24, true); fallingGF.animation.play('falling'); fallingGF.antialiasing = true; add(fallingGF);
    skippableTweens.push(FlxTween.tween(fallingBF, {y: 350}, 12, {ease: FlxEase.elasticOut}));
    fallingGF.velocity.y = 27;

    windEmitter.makeParticles(2, 230, 0xFFFFFFFF, 100);
    add(windEmitter);

    windAmbience = FlxG.sound.play(Paths.sound('titleScreen/WindAmbience'), getVolume(0.25, 'sfx'));

    parachute = new FlxSprite(); parachute.antialiasing = true; add(parachute); parachute.alpha = 0.001;

    preTitleTextGroup = new FlxTypedSpriteGroup(240); add(preTitleTextGroup);

    //SOME COLOR TRANSFORM BS
    var colorTransform = FlxG.camera.canvas.transform.colorTransform;
    colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 0;
    skybox.colorTransform = earth.colorTransform = colorTransform;

    skippableTweens.push(FlxTween.tween(colorTransform, {greenMultiplier: 1}, 4, {ease: FlxEase.quintInOut}));
    skippableTweens.push(FlxTween.tween(colorTransform, {redMultiplier: 1}, 2, {ease: FlxEase.quartInout}));
    skippableTweens.push(FlxTween.tween(colorTransform, {blueMultiplier: 1}, 5, {ease: FlxEase.sineInOut, onUpdate: function(tween) {
        skybox.colorTransform = earth.colorTransform = colorTransform;
    }}));

    cloudEmitter.forEach(function (cloud) {
        cloud.colorTransform.redMultiplier = cloud.colorTransform.greenMultiplier = cloud.colorTransform.blueMultiplier = 0;
        skippableTweens.push(FlxTween.tween(cloud.colorTransform, {greenMultiplier: 1}, 4, {ease: FlxEase.quintInOut}));
        skippableTweens.push(FlxTween.tween(cloud.colorTransform, {redMultiplier: 1}, 2, {ease: FlxEase.quartInout}));
        skippableTweens.push(FlxTween.tween(cloud.colorTransform, {blueMultiplier: 1}, 5, {ease: FlxEase.sineInOut}));
    });
}

function setupTitleStuff() {
    //BACKGROUND
    if (!easterEggs[0]) {
        clouds = new FlxSprite().loadGraphic(Paths.image('menus/TitleScreen/SpinningClouds'));
        clouds.antialiasing = true;
        clouds.alpha = 0.001; clouds.scale.x = clouds.scale.y = 3*5.6;
        clouds.screenCenter(); add(clouds);
        clouds.shader = new CustomShader('smoothRotate');

        vinylSound = FlxG.sound.load(Paths.sound('titleScreen/vinyl'), getVolume(0.5, 'sfx'), true); vinylSound.pitch = 0;
        
        background = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/titleScreen/Background')); background.screenCenter(); background.y = FlxG.height + 20;
        background.antialiasing = true; add(background); background.scale.x = background.scale.y = 1.1;
        foreground = new FlxSprite(-60, FlxG.height + 80).loadGraphic(Paths.image('menus/titleScreen/Foreground')); foreground.antialiasing = true; add(foreground); foreground.scale.x = foreground.scale.y = 1.5;

        add(characterGroup);
        characterGroup.alpha = 0;
        characterGroup.scale.x = characterGroup.scale.y = 5;

        mainCharacters = mainCharacters.filter(x -> !x.isLocked);

        for (char in 0...mainCharacters.length) {
            var charSprite = new FunkinSprite();
            charSprite.loadSprite(Paths.image('menus/titleScreen/characters/'+mainCharacters[char].sheet));

            var charAnims = mainCharacters[char].anims;
            for (anim in 0...charAnims.idleIndexes.length) {
                charSprite.animateAtlas.anim.addBySymbolIndices("Idle"+anim, "CharsExport", charAnims.idleIndexes[anim], 24, mainCharacters[char].isLocked);
            }
            charSprite.animateAtlas.anim.addBySymbolIndices("Click", "CharsExport", charAnims.clickIndexes, 24, false);
            charSprite.animateAtlas.anim.addBySymbolIndices("Extra", "CharsExport", charAnims.extraIndexes, 24, false);
            charSprite.animateAtlas.anim.addBySymbolIndices("Return", "CharsExport", charAnims.returnIndexes, 24, false);

            charSprite.ID = char;
            charSprite.antialiasing = true;
            characterGroup.add(charSprite);

            charSprite.width = mainCharacters[char].bounds[1];
            charSprite.height = mainCharacters[char].bounds[2];

            charSprite.offset.x = -charSprite.width/2 - mainCharacters[char].bounds[0];
            charSprite.offset.y = -charSprite.height;

            charSprite.x -= charSprite.width/2 + mainCharacters[char].bounds[0];
            charSprite.y -= charSprite.height;
        }
    } else {
        background = new FlxSprite(0,0).loadGraphic(Paths.image('menus/titleScreen/'+ (easterEggs[1] ? 'FIREINTHEHOLE' : 'ImpactSilhouette')));
        background.antialiasing = true; add(background); background.visible = false;

        clouds = 0; //I'll reuse this as a loop counter

        holeEasterEgg = new FunkinSprite(87,289);
        holeEasterEgg.loadSprite(Paths.image('menus/titleScreen/Bubble_'+ (easterEggs[1] ? 'FireInTheHole' : 'Regular'))); holeEasterEgg.antialiasing = true;
        holeEasterEgg.animation.addByIndices("Click", 'Bubble_'+ (easterEggs[1] ? 'FireInTheHole' : 'Regular'), [0,1,2,3], '', 24, false);
        holeEasterEgg.animation.addByIndices("Extra", 'Bubble_'+ (easterEggs[1] ? 'FireInTheHole' : 'Regular'), [4,5,6,7,8,9,10,11], '', 24, false);
        holeEasterEgg.animation.addByIndices("Return", 'Bubble_'+ (easterEggs[1] ? 'FireInTheHole' : 'Regular'), [3,2,1,0], '', 24, false);
    }

    setupMenuStuff();

    teamText = new FlxText(FlxG.width/5*3,FlxG.height,FlxG.width/5*2-12, "Team Reimagination 2022 - "+Date.now().getFullYear()).setFormat(Paths.font('TW Cen MT B.ttf'), 24, 0xFFFFB6B6, 'right', FlxTextBorderStyle.OUTLINE, 0xff210038);
    teamText.updateHitbox(); teamText.borderSize = 2;

    startBar = new FlxBackdrop(Paths.image('menus/titleScreen/StartBar'), FlxAxes.X); startBar.velocity.x = -40; startBar.y = 620; startBar.antialiasing = true; add(startBar); startBar.alpha = 0.6; startBar.scale.y = barLerping;
    startBar.width = Math.pow(2,24); //it's rather extreme but I had to manipulate the hitbox since it doesn't repeat for every tile in FlxBackdrop.

    startText = new Alphabet(0, 0, "PRESS "+CoolUtil.keyToString(Reflect.field(Options, 'P1_ACCEPT')[0])+" OR CLICK HERE", true, false); startText.antialiasing = true; add(startText); startText.scale.x = startText.scale.y = 0.7;

    for (i in 0...startText.members.length) {
        startText.members[i].updateHitbox();
        if (i > 0) startText.members[i].x = startText.members[i-1].x + startText.members[i-1].width + 2 + (startText.members[i-1].visible ? 0 : 25);
    }

    if (startText.width >= 1000) {
        var textWidth = startText.width;

        startText.scale.x = startText.scale.x * (1000 / textWidth);

        for (i in 0...startText.members.length) {
            startText.members[i].updateHitbox();

            if (i == 0) startText.members[i].x = 0;
            else startText.members[i].x = startText.members[i-1].x + startText.members[i-1].width + 2 + (startText.members[i-1].visible ? 0 : 25 * (1000 / textWidth));
        }
    }

    startText.scale.y = barLerping;
    startText.screenCenter();
    startText.y = startBar.y - 13;

    logo = new FunkinSprite(logoLerping[0],logoLerping[1]);
    logo.loadSprite(Paths.image('menus/titleScreen/logo'));
    logo.animateAtlas.anim.addBySymbol("Appearing", "_PARTS/Scenes/TitleScreen/Logo_Appearing", 24, false);
    for (i in 0...4) {
        logo.animateAtlas.anim.addBySymbolIndices("Idle"+i, "_PARTS/Scenes/TitleScreen/Logo_Idle", [i], 24, false);
    }
    logo.antialiasing = true; logo.cameras = [menuCamera]; add(logo); logo.alpha = 0.0001; 
    logo.scale.x = logo.scale.y = logoLerping[2];

    logoHitbox = new FlxObject(logoLerping[0],logoLerping[1],564,335); logoHitbox.width = 564 * logoLerping[2]; logoHitbox.height = 335 * logoLerping[2]; logoHitbox.x -= logoHitbox.width/2; logoHitbox.y -= logoHitbox.height/2;
}

function setupMenuStuff() {
    topMenuGroup = new FlxTypedSpriteGroup(0, menuGroupDrags[0]);
    bottomMenuGroup = new FlxTypedSpriteGroup(0, menuGroupDrags[1]);
    topMenuGroup.cameras = bottomMenuGroup.cameras = [menuCamera];
    add(topMenuGroup); add(bottomMenuGroup);

    topBar = new FlxSprite().loadGraphic(Paths.image('menus/mainMenu/topBar')); topBar.antialiasing = true;
    topBar.angle = 17; topBar.updateHitbox();
    topBar.x = 47; topBar.y = -topBar.height + 50;
    topMenuGroup.add(topBar);

    bottomBar = new FlxSprite().loadGraphic(Paths.image('menus/mainMenu/bottomBar')); bottomBar.antialiasing = true;
    bottomBar.angle = 17; bottomBar.updateHitbox();
    bottomBar.x -= 130; bottomBar.y = FlxG.height - 50;
    bottomMenuGroup.add(bottomBar);

    buttonSubgroup = new FlxTypedSpriteGroup(0, menuGroupDrags[1]); buttonSubgroup.cameras = [menuCamera]; add(buttonSubgroup);
    buttonGroup = new FlxTypedSpriteGroup(0, menuGroupDrags[1]); buttonGroup.cameras = [menuCamera]; add(buttonGroup);

    for (i in 0...menuOptions.length) {
        var buttonSpr = new FunkinSprite();
        buttonSpr.loadSprite(Paths.image('menus/mainMenu/buttons'));

        buttonSpr.animateAtlas.anim.addBySymbol("Button", "Scenes/MainMenu/Buttons/Button_"+menuOptions[i]+'\\', 24, false); //the \ makes sure it chooses what we want instead of the closest thing it thinks of (i.g. no instead of none)
        buttonSpr.animateAtlas.anim.play("Button", true, true);

		buttonSpr.ID = i;
        buttonSpr.antialiasing = true;

        buttonSpr.scale.x = buttonSpr.scale.y = (menuSelection == i ? 1 : 0.6); buttonSpr.updateHitbox();
        buttonSpr.x = (i == 0 ? 100 * buttonSpr.scale.x : (buttonGroup.members[i - 1].x + 50 * buttonGroup.members[i - 1].scale.x) + 100 + (85 * (buttonSpr.scale.x - buttonGroup.members[i - 1].scale.x)));
        buttonSpr.y = bottomBar.y;

        buttonGroup.add(buttonSpr);
    }
}

function getIntroTextShit() {
	var fullText:String = Assets.getText(Paths.txt('titlescreen/introText'));

	var firstArray = fullText.split('\n');
	var swagGoodArray = [];

	for (i in firstArray)
	{
		swagGoodArray.push(i.split('--'));
	}

	return swagGoodArray;
}

var allTexts = getIntroTextShit();

function addText(text:String, offset = 0, offLoad = 0){
	var coolText:Alphabet = new Alphabet(0, ((preTitleTextGroup.length - offLoad) * 60), text, true, false);

    coolText.scale.set(0.65, 0.65); //so this adjusts the scale of every object inside but doesn't adjust their positions nor hitbox (when i updateHitbox()), so I have to do it manually for every group member
    coolText.targetY = 0;

    coolText.y = -300 + ((preTitleTextGroup.length - offLoad) * (coolText.height/5*3));
    skippableTweens.push(FlxTween.tween(coolText, {y: FlxG.height/3.5 + ((preTitleTextGroup.length - offLoad) * (coolText.height/5*3)) + offset}, 0.4, {ease: FlxEase.quartOut}));

    for (i in 0...coolText.members.length) {
        coolText.members[i].updateHitbox();
        if (i > 0) coolText.members[i].x = coolText.members[i-1].x + coolText.members[i-1].width + 2 + (coolText.members[i-1].visible ? 0 : 25);
    }

    if (coolText.width >= 680) {
        var textWidth = coolText.width;

        coolText.scale.x = coolText.scale.x * (680 / textWidth);

        for (i in 0...coolText.members.length) {
            coolText.members[i].updateHitbox();

            if (i == 0) coolText.members[i].x = 0;
            else coolText.members[i].x = coolText.members[i-1].x + coolText.members[i-1].width + 2 + (coolText.members[i-1].visible ? 0 : 25 * (680 / textWidth));
        }
    }

	coolText.screenCenter(FlxAxes.X);

	preTitleTextGroup.add(coolText);
}

function recolorText(row, indexes, newColor) {
    for (num in indexes[0]...(indexes[1]+1)) {
        var selectedLetter = preTitleTextGroup.members[row].members[num];
        if (selectedLetter != null && selectedLetter.color != null) selectedLetter.color = newColor;
    }
}

function removeText() {
    for (i in preTitleTextGroup.members) {
        if (i != null) {
            for (letter in i.members) {
                skippableTweens.push(FlxTween.tween(letter, {y: letter.y - 1200}, 1, {ease: FlxEase.quartIn, onComplete: function (tween) {letter.destroy();}}));
                skippableTweens.push(FlxTween.tween(letter, {x: letter.x + 500}, 0.8, {ease: FlxEase.sineIn, onComplete: function (tween) {letter.destroy();}}));
            }
        }
    }

    skippableTweens.push(FlxTween.tween(parachute, {y: parachute.y - 1200}, 1, {ease: FlxEase.quartIn}));
    skippableTweens.push(FlxTween.tween(parachute, {x: parachute.x + 500}, 0.8, {ease: FlxEase.sineIn}));
}

function spawnParachute(whichLine) {
    parachute.loadGraphic(Paths.image('menus/titleScreen/Parachute'+FlxG.random.int(1,13))); parachute.alpha = 1;

    FlxG.sound.play(Paths.sound('titleScreen/ParachuteOpen'), getVolume(0.25, 'sfx'));

    parachute.x = preTitleTextGroup.members[whichLine].x;
    parachute.y = preTitleTextGroup.members[whichLine].y - parachute.height/2 + 50;

    parachute.setGraphicSize(preTitleTextGroup.members[whichLine].width, parachute.height);
    parachute.updateHitbox();

    skippableTweens.push(FlxTween.tween(parachute, {y: parachute.y - parachute.height/2}, 0.3, {ease: FlxEase.backOut}));
    parachute.scale.y = 0;
    skippableTweens.push(FlxTween.tween(parachute.scale, {y: 1}, 0.3, {ease: FlxEase.backOut}));
}

var initYMatrixes = [];
var curYMatrixes = [];

var cloudTimer = 0;

function update(elapsed) {
    if (FlxG.keys.justPressed.F9) { //DEV, REMOVE ONCE DONE!
        initialized = false;
        FlxG.sound.music.stop();
        logoLerping = [FlxG.width/2, FlxG.height/2, 1];
        barLerping = 0;
        isInMenu = false;
        menuGroupDrags = [-250, 250];
        FlxG.resetState();
    }

    if (!initialized) {
        earth.scale.x = earth.scale.y += 0.04 * elapsed;
        birdFlock.scale.x = birdFlock.scale.y += 0.06 * elapsed;
    } else {
        if (!easterEggs[0]) {
            if (occupiedObject != clouds) cloudTimer += 60 * elapsed;
            clouds.shader.data.uTime.value = [-cloudTimer / 5000];
        }

        /*
        CLICK HANDLER
        */
        //for characters, and the logo, hitboxes were fucked up so I had to spoof them with FlxObjects. Too much work to readjust.
        //Activates whether the mouse is pressed or if there's an occupied object that has been clicked already. Occupied objects will make sure it still does stuff even when mouse is not hovering over it, as long as the mosue is pressec
        if (FlxG.mouse.justPressed || occupiedObject != null) {
            var selectedObject = occupiedObject;

            if (selectedObject == null) {
                for (clickObject in getClickables()) {
                    if (clickObject == null || !clickObject.exists) continue;

                    if (FlxG.mouse.overlaps(clickObject)) {
                        selectedObject = clickObject;
                        break;
                    }
                }
            }

            if (selectedObject == clouds && !occupiedObject) {
                stoppedCloudTimer = cloudTimer;
            }

            switch (selectedObject) {
                case clouds:
                    var cdx:Float = (clouds.x + clouds.width/2) - FlxG.mouse.screenX;
                    var cdy:Float = (clouds.y + clouds.height/2) - FlxG.mouse.screenY;
                    var centerDistance = Std.int(FlxMath.vectorLength(cdx, cdy));
                    //var mouseDistance = Math.sqrt(FlxG.mouse.deltaScreenX * FlxG.mouse.deltaScreenX + FlxG.mouse.deltaScreenY * FlxG.mouse.deltaScreenY);
                    
                    cloudTimer = stoppedCloudTimer + (FlxG.mouse.deltaScreenX / (centerDistance + 1) * 600) * (FlxG.mouse.screenY < clouds.y + clouds.height/2 ? 1 : -1);
                    vinylSound.pitch = Math.abs(FlxG.mouse.deltaScreenX / (centerDistance + 1) * 6);
                    if (vinylSound.time > vinylSound.length) vinylSound.time = 0;
                case background:
                    if (!FlxG.mouse.justPressed && !holeEasterEgg.visible) {
                        holeEasterEgg.visible = true;
                        holeEasterEgg.playAnim('Click');
                    }
                case foreground:
                    if (!FlxG.mouse.justPressed && !currentlyUsedObjects.contains(foreground)) {
                        currentlyUsedObjects.push(foreground);
                        foreground.y = 250+150; foreground.scale.set(1.03, 0.75);

                        FlxTween.tween(foreground.scale, {x: 1, y: 1}, 1, {ease: FlxEase.elasticOut, onComplete: function() {
                            currentlyUsedObjects.remove(foreground);
                        }});
                        FlxTween.tween(foreground, {y: 190+150}, 1, {ease: FlxEase.elasticOut});

                        FlxG.sound.play(Paths.sound('titleScreen/RustlingLeaves'), getVolume(1, 'sfx'));
                    }
                case characterGroup:
                    if (occupiedObject == null) {
                        characterGroup.forEach(function (char) {
                            if (FlxG.mouse.overlaps(char) && !mainCharacters[char.ID].isClicked) highestIndex = char.ID;
                    
                            if (char.ID == characterGroup?.members?.length - 1 && highestIndex > -1) {
                                characterGroup.members[highestIndex].playAnim('Click', true);
                                mainCharacters[highestIndex].isClicked = true;
                                highestIndex = -1;
                            }
                        });
                    }
                case logoHitbox:
                    if (occupiedObject == null) FlxG.sound.play(Paths.sound('titleScreen/zoom'), getVolume(1, 'sfx'));

                    logo.scale.x = logo.scale.y = CoolUtil.fpsLerp(logo.scale.y, logoLerping[2] * 1.1, 0.2);
                    logo.x = CoolUtil.fpsLerp(logo.x, logoLerping[0] + 6 * logoLerping[2], 0.2); //Offset's fucked up which is why
                    logo.y = CoolUtil.fpsLerp(logo.y, logoLerping[1] + 6 * logoLerping[2], 0.2);
                case startBar | teamText:
                    if (!FlxG.mouse.justPressed && !currentlyUsedObjects.contains(selectedObject)) {
                        currentlyUsedObjects.push(selectedObject);

                        var startedFlipY = selectedObject.flipY;

                        FlxTween.num(selectedObject.scale.y, selectedObject.scale.y * -1, 0.6, {ease: FlxEase.elasticOut, onComplete: function(tween) {
                            currentlyUsedObjects.remove(selectedObject);
                        }}, function(value) {
                            if (value < 0) selectedObject.flipY = !startedFlipY;
                            selectedObject.scale.y = Math.abs(value);
                        });

                        FlxG.sound.play(Paths.sound('titleScreen/WhipWoosh'), getVolume(1, 'sfx'));
                    }
                case startText:
                    if (!isInMenu) progressForwards();
                case topBar:
                    topMenuGroup.y += FlxG.mouse.deltaScreenY;
                    topMenuGroup.y = Math.max(menuGroupDrags[0], Math.min(menuGroupDrags[0] + 500, topMenuGroup.y));
                case bottomBar:
                    bottomMenuGroup.y += FlxG.mouse.deltaScreenY;
                    bottomMenuGroup.y = Math.min(menuGroupDrags[1], Math.max(menuGroupDrags[1] - 500, bottomMenuGroup.y));
            }

            if (occupiedObject == null) occupiedObject = selectedObject;
        }

        if (isInMenu) {
            logoLerping[1] = topBar.y + topBar.height + 55;
        }

        if (occupiedObject != logoHitbox) {
            logo.x = CoolUtil.fpsLerp(logo.x, logoLerping[0], 0.1);
            logo.y = CoolUtil.fpsLerp(logo.y, logoLerping[1], 0.1);
            logo.scale.x = logo.scale.y = CoolUtil.fpsLerp(logo.scale.y, logoLerping[2], 0.1);
        }
        
        startBar.scale.y = CoolUtil.fpsLerp(startBar.scale.y, barLerping, 0.3);
        startText.scale.y = startBar.scale.y * 0.7;

        logoHitbox.width = 564 * logo.scale.x; logoHitbox.height = 335 * logo.scale.y;
        logoHitbox.x = logo.x - logoHitbox.width/2;
        logoHitbox.y = logo.y - logoHitbox.height/2;

        if (occupiedObject != topBar) topMenuGroup.y = CoolUtil.fpsLerp(topMenuGroup.y, menuGroupDrags[0], 0.2);
        if (occupiedObject != bottomBar) bottomMenuGroup.y = CoolUtil.fpsLerp(bottomMenuGroup.y, menuGroupDrags[1], 0.2);
    }

    //PROGRESSION
    if (!initialized) conditionProcess = controls.ACCEPT || FlxG.mouse.justPressed;
    else conditionProcess = controls.ACCEPT;

    if (conditionProcess) {
        (initialized == false) ? skipIntro() : progressForwards(); //the switchstate is a placeholder thing
    }
    if ((controls.BACK || FlxG.mouse.justPressedRight) && isInMenu) progressBackwards();

    if (isInMenu) {
        if ((controls.LEFT_P || controls.RIGHT_P)) {
            FlxG.sound.play(Paths.sound('firstTime/firstButtonScroll'), getVolume(0.8, 'sfx'));
            changeSelection(controls.LEFT_P ? -1 : 1);
        }
    }
}

function changeSelection(change = 0) {
    menuSelection = FlxMath.wrap(menuSelection+change, 0, menuOptions.length - 1);
    for (i in buttonGroup.members) {
        i.animateAtlas.anim.play("Button", true, menuSelection == i.ID ? false : true, menuSelection == i.ID ? i.animateAtlas.anim.curFrame - i.animateAtlas.anim.length : i.animateAtlas.anim.curFrame + i.animateAtlas.anim.length );
    }
}

function processClickables() {
    clearClickables();

    if (!isInMenu) {
        //pushToClickables(teamText); pushToClickables(startText); pushToClickables(startBar); pushToClickables(logoHitbox); 

        if (!easterEggs[0]) { pushToClickables(characterGroup);} //pushToClickables(foreground); pushToClickables(clouds); }
        else pushToClickables(background);
    } else {
        buttonGroup.forEach(function (button) {
            pushToClickables(button);
        });

        pushToClickables(logoHitbox); pushToClickables(topBar); pushToClickables(bottomBar);
    }
}

function progressForwards() {
    if (!isInMenu) {
        isInMenu = true;

        processClickables();

        FlxTween.completeTweensOf(teamText);
        skippableTweens.push(FlxTween.tween(teamText, {y: FlxG.height}, 1, {ease: FlxEase.quartOut}));

        barLerping = 0;
        menuGroupDrags = [0, 0];
        logoLerping = [1020, null, 0.6];
    } else {
        FlxG.switchState(new MainMenuState());
    }
}

function progressBackwards() {
    isInMenu = false;

    processClickables();

    FlxTween.completeTweensOf(teamText);
    skippableTweens.push(FlxTween.tween(teamText, {y: FlxG.height - 5 - teamText.height}, 1, {ease: FlxEase.quartOut}));

    barLerping = 1;
    menuGroupDrags = [-250, 250];
    logoLerping = [FlxG.width/2, FlxG.height/3.9, 0.95];
}

var highestIndex = -1;
var occupiedObject;
var stoppedCloudTimer = 0;

function postUpdate(elapsed) {
    if (initialized) {
        //CHARACTER ANIMATION HANDLER since animation.finishCallback doesn't work on atlases, and animateAtlas.anim.onComplete prevents isPlaying from being true for some reason, causing anims to be static
        //IF ONLY ISPLAYING WASN'T READ-ONLY FUCK ME SIDEWAYS
        if (!easterEggs[0]) { characterGroup.forEach(function (char) {
            if (char.isAnimFinished()) {
                if (char.getAnimName() == 'Return') {mainCharacters[char.ID].isClicked = false; mainCharacters[char.ID].loopCount = 0; mainCharacters[char.ID].left = 0;}
                if (char.getAnimName() == 'Extra') {if (mainCharacters[char.ID].loopCount == 12) char.playAnim('Return', true); else {char.playAnim('Extra', true); mainCharacters[char.ID].loopCount++;}}
                if (char.getAnimName() == 'Click') char.playAnim('Extra', true);
            }
        });} else {
            if (holeEasterEgg.visible && holeEasterEgg.isAnimFinished()) {
                if (holeEasterEgg.getAnimName() == 'Return') {clouds = 0; holeEasterEgg.visible = false;}
                if (holeEasterEgg.getAnimName() == 'Extra') {if (clouds == 12) holeEasterEgg.playAnim('Return', true); else {holeEasterEgg.playAnim('Extra', true); clouds++;}}
                if (holeEasterEgg.getAnimName() == 'Click') holeEasterEgg.playAnim('Extra', true);
            }
        }

        if (occupiedObject != null && !FlxG.mouse.pressed) {
            occupiedObject = null;
            if (!easterEggs[0]) vinylSound.pitch = 0;
        }

        buttonGroup.forEach(function (button) {
            button.scale.x = button.scale.y = CoolUtil.fpsLerp(button.scale.y, (menuSelection == button.ID ? 1 : 0.6), 0.2); button.animateAtlas.updateHitbox();

            button.width = button.height = 161 * button.scale.x;

            button.x = CoolUtil.fpsLerp(button.x, (button.ID == 0 ? 20 : (buttonGroup.members[button.ID - 1].x + buttonGroup.members[button.ID - 1].width) + 10), 0.2);
            button.y = bottomBar.y + 20 - button.height;

            if (isInMenu && FlxG.mouse.visible && FlxG.mouse.overlaps(button)) {
                if (menuSelection != button.ID) {
                    FlxG.sound.play(Paths.sound('firstTime/firstButtonScroll'), getVolume(0.8, 'sfx'));
                    changeSelection(button.ID - menuSelection);
                }
    
                if (FlxG.mouse.justReleased && menuSelection == button.ID) progressForwards();
            }
        });
    }
}

//MATRIX MANIPULATION ON BACKGROUND BIRDS FOR PERSPECTIVE SHIFTING
function draw(event) {
    if (!initialized) {
        for (layer in birdFlock.animateAtlas.anim.curSymbol.timeline.getList()) { //this is apparently necessary
            var birdElements = layer.get(birdFlock.animateAtlas.anim.curSymbol.curFrame).getList(); //this gets all the objects inside of every animation frame

            if (initYMatrixes.length == 0) { //every frame changes the ty matrix so it's best to have something to keep track of them
                for (e in birdElements) {
                    initYMatrixes.push(e.matrix.ty);
                }
                curYMatrixes = initYMatrixes.copy();
            }

            for (e in 0...birdElements.length) {
                birdElements[e].matrix.ty = curYMatrixes[e] += (-0.12 + -initYMatrixes[e]) * 0.22 * FlxG.elapsed; //ty is responsible for where it's placed on the Y axis
            }
        }
    }
}

function beatHit(curBeat) {
    if (!initialized) {
        switch curBeat {
            case 0:
                addText("TEAM REIMAGINATION");
                recolorText(0,[0,99],0xffE394B0);
            case 2:
                addText("and the rest of");
            case 3:
                addText("THE BND TEAM");
                recolorText(2,[4,4],0xff91E11A);
                recolorText(2,[6,6],0xff4E8DE3);
            case 4:
                addText("present");

            case 6:
                spawnParachute(0);
            case 7:
                removeText();

            case 8:
                addText("An interpretation", 30, 4);
            case 10:
                addText("of", 30, 4);
            case 12:
                addText("VS. DAVE & BAMBI", 30, 4);
                recolorText(6,[4,7],0xff4E8DE3);
                recolorText(6,[11,99],0xff91E11A);

            case 14:
                spawnParachute(4);
            case 15:
                removeText();

            case 24:
                logo.alpha = 1;
                logo.playAnim('Appearing', true);

            case 28:
                if (FlxG.save.data.options.shaders == 'all') skippableTweens.push(FlxTween.tween(blurFilter, {blurX: 8, blurY: 8}, 1, {ease: FlxEase.quartInOut}));
            case 29:
                preTitleTextGroup.destroy();
                
            case 32:
                skipIntro();
        }

        if (curBeat >= 16 && curBeat < 24) {
            if (curBeat % 4 == 0) {
                var picked = FlxG.random.int(0, allTexts.length-1, usedTexts);
                usedTexts.push(picked);
                curWacky = allTexts[picked];
                addText(curWacky[0], 60, 7 + (curBeat == 20 ? 2 : 0));
            } else if (curBeat % 4 == 1) {
                addText(curWacky[1], 60, 7 + (curBeat == 21 ? 2 : 0));
            } else if (curBeat % 4 == 2) {
                spawnParachute(7 + (curBeat == 22 ? 2 : 0));
            } else if (curBeat % 4 == 3) {
                removeText();
            }
        }
    } else {
        logo.playAnim('Idle'+curBeat % 4, true);

        if (!easterEggs[0]) {
            charDance();
        }
    }
}

//CHARACTER ANIMATION PLAY HANDLER
function charDance() {
    characterGroup.forEach(function (char) {
        var danceBreak = 2 / mainCharacters[char.ID].anims.idleIndexes.length;
        if (!mainCharacters[char.ID].isClicked && !mainCharacters[char.ID].isLocked && curBeat % danceBreak == 0) {
            char.playAnim('Idle'+mainCharacters[char.ID].left, true);
            mainCharacters[char.ID].left = FlxMath.wrap(mainCharacters[char.ID].left+1, 0, mainCharacters[char.ID].anims.idleIndexes.length - 1);
        }

        if (mainCharacters[char.ID].isLocked && !char.animateAtlas.anim.isPlaying) char.playAnim('Idle0', true);
    });
}

function skipIntro() {
    if (!initialized) {
        if (FlxG.sound.music.time <= 12700) FlxG.sound.music.time = 12800; //this check is so that no stuttering happens
        Conductor.__updateSongPos(FlxG.elapsed);

        for (tween in skippableTweens) {
            tween.percent = 1;
        }

        menuCamera.flash();

        windEmitter.destroy(); earth.destroy(); cloudEmitter.destroy(); fallingBF.destroy(); fallingGF.destroy(); birdFlock.destroy(); parachute.destroy();
        if (preTitleTextGroup != null) preTitleTextGroup.destroy();
        if (windAmbience != null) windAmbience.stop();
        if (FlxG.save.data.options.shaders == 'all') blurFilter.blurX = blurFilter.blurY = 0.0001;

        logoLerping = [FlxG.width/2, FlxG.height/3.9, 0.95];
        barLerping = 1;
    }

    add(teamText); 
    if (!isInMenu) skippableTweens.push(FlxTween.tween(teamText, {y: FlxG.height - 5 - teamText.height}, 1, {ease: FlxEase.quartOut}));

    if (!initialized) {
        pushToClickables(teamText);
        pushToClickables(startText);
        pushToClickables(startBar);
        pushToClickables(logoHitbox);
    }

    logo.playAnim('Idle0', true);
    logo.alpha = 1;
    add(logoHitbox);

    if (!easterEggs[0]) {
        vinylSound.play();

        clouds.alpha = 1;

        if (!initialized) {pushToClickables(characterGroup); pushToClickables(foreground); pushToClickables(clouds);}

        skippableTweens.push(FlxTween.tween(characterGroup, {alpha: 1, y: FlxG.height, x: FlxG.width/2}, 1, {ease: FlxEase.quartOut, startDelay: 1}));
        skippableTweens.push(FlxTween.tween(characterGroup.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quartOut, startDelay: 0.9}));
        for (i in characterGroup.members) {
            skippableTweens.push(FlxTween.color(i.animateAtlas, 1.5, 0xFF000000, 0xFFFFFFFF, {ease: FlxEase.quartOut, startDelay: 0.9}));
        }

        skippableTweens.push(FlxTween.tween(foreground.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quartOut, startDelay: 0.85}));
        skippableTweens.push(FlxTween.tween(foreground, {y: foreground.y - 610}, 1, {ease: FlxEase.quartOut, startDelay: 0.85, onComplete: function(tween) {
            foreground.updateHitbox();
            foreground.height -= 300;
            foreground.offset.y = 150;
            foreground.y += 150;
        }}));

        skippableTweens.push(FlxTween.tween(background.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quartOut, startDelay: 0.75}));
        skippableTweens.push(FlxTween.tween(background, {y: background.y - background.height + 20}, 1, {ease: FlxEase.quartOut, startDelay: 0.75}));

        skippableTweens.push(FlxTween.tween(clouds.scale, {x: 0.9*5.6, y: 0.6*5.6}, 2, {ease: FlxEase.quartOut, onComplete: function(tween) {
            clouds.updateHitbox();
            clouds.screenCenter(); clouds.y = clouds.y - 210;
        }}));
        skippableTweens.push(FlxTween.tween(clouds, {y: clouds.y - 210}, 1.5, {ease: FlxEase.quartOut}));
    } else {
        background.visible = true; 
        if (!initialized) pushToClickables(background);
        add(holeEasterEgg); holeEasterEgg.visible = false;
    }
    
    if (initialized) {
        for (tween in skippableTweens) {
            tween.percent = 1;
        }

        if (isInMenu) {
            logoLerping[1] = topBar.y + topBar.height + 55;
            logo.y = logoLerping[1];
        }

        changeSelection();
        clearClickables();
        processClickables();
    } else initialized = true;

    if (!easterEggs[0]) {
        charDance();
    }
}