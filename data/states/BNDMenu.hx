import funkin.backend.FunkinSprite;
import funkin.options.Options;
import funkin.backend.system.Conductor;
import flixel.sound.FlxSound;
import flixel.util.FlxGradient;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxEmitterMode;
import flixel.util.helpers.FlxBounds;
import flixel.util.helpers.FlxRangeBounds;
import flixel.effects.particles.FlxParticle;
import funkin.editors.ui.UISliceSprite;
import flixel.group.FlxGroup;
import openfl.Assets;
import flixel.util.FlxAxes;
import flixel.group.FlxTypedSpriteGroup;
import flixel.FlxCamera;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

public static var initialized = false;
public static var preIntro = true;

var skippableTweens = [];

var earth, cloudEmitter, windEmitter, fallingBF, fallingGF, birdFlock, constellation, constellationSound, preTitleTextGroup, parachute, windAmbience; //they all don't get assigned anything if the state was initialized beforehand
var logo, foreground, background, clouds; //THESE on the other hand...

public static var logoLerping = [FlxG.width/2, FlxG.height/2, 1];

var skybox = new FlxGradient().createGradientFlxSprite(FlxG.width, FlxG.height, [0xFF272BC2, 0xFF007DE7, 0xFF74E9FF, 0xFFDBF9FF]);
var curWacky = [];
var usedTexts = [];

var blurFilter:BitmapFilter;
var menuCamera;

function create() {
    FlxG.cameras.add(menuCamera = new FlxCamera(), false);
    menuCamera.bgColor = 0;

    if (FlxG.save.data.shaders == 'all') {
        blurFilter = new BlurFilter(0.0001, 0.0001, 3);
        if (FlxG.camera._filters == null) FlxG.camera._filters = [];
        FlxG.camera._filters.push(blurFilter);
    }

    skybox.antialiasing = Options.antialiasing; add(skybox);

    if (preIntro) setupPreTitleStuff();

    setupTitleStuff();

    if (initialized) skipIntro();
}

function setupPreTitleStuff() {
    skybox.alpha = 0.0001;

    earth = new FlxSprite(0, FlxG.height - 250).loadGraphic(Paths.image('menus/titleScreen/Earth')); earth.antialiasing = Options.antialiasing; add(earth); earth.alpha = 0.0001;

    birdFlock = new FunkinSprite();
    birdFlock.loadSprite(Paths.image('menus/titleScreen/BirdFlock'));
    birdFlock.animateAtlas.anim.addBySymbol("Flock", "BirdFlock", 24, true); birdFlock.animateAtlas.anim.play("Flock");
    birdFlock.antialiasing = Options.antialiasing;
    birdFlock.screenCenter(); birdFlock.y = 800;
    add(birdFlock);

    windEmitter = new FlxTypedEmitter(0, FlxG.height + 1000, 30);
    windEmitter.setSize(FlxG.width, 10); 
    windEmitter.launchAngle = new FlxBounds(-90, -90);
    windEmitter.speed = new FlxRangeBounds(2500, 4000);
    windEmitter.lifespan = new FlxBounds(1);

    cloudEmitter = new FlxTypedEmitter(0, FlxG.height + 1000);
    cloudEmitter.setSize(FlxG.width, 10);
    cloudEmitter.launchAngle = new FlxBounds(-88, -88);
    cloudEmitter.speed = new FlxRangeBounds(900, 2500);
    cloudEmitter.lifespan = new FlxBounds(3);
    
    for (i in 0 ... 35) {
        var p = new FlxParticle();
        p.loadGraphic(Paths.image('menus/titleScreen/Cloud'+(FlxG.random.int(1,9))));
        p.scale.x = p.scale.y = FlxG.random.float(0.8, 1.6);
        p.antialiasing = Options.antialiasing;
        p.alpha = 0.7;
        cloudEmitter.add(p);
    }
    add(cloudEmitter);

    fallingBF = new FlxSprite(100, 100); fallingBF.frames = Paths.getSparrowAtlas('menus/titleScreen/Falling_BF'); fallingBF.animation.addByPrefix('falling', 'Falling_BF', 24, true); fallingBF.animation.play('falling'); fallingBF.antialiasing = Options.antialiasing; add(fallingBF);
    fallingGF = new FlxSprite(230, -350); fallingGF.frames = Paths.getSparrowAtlas('menus/titleScreen/Falling_GF'); fallingGF.animation.addByPrefix('falling', 'Falling_GF', 24, true); fallingGF.animation.play('falling'); fallingGF.antialiasing = Options.antialiasing; add(fallingGF);

    windEmitter.makeParticles(2, 230, 0xFFFFFFFF, 100);
    add(windEmitter);

    constellation = new FunkinSprite();
    constellation.loadSprite(Paths.image('menus/titleScreen/constellation'));

    constellation.animateAtlas.anim.addBySymbol("Constellation", "Monolith", 24, false);
    constellation.animateAtlas.anim.play("Constellation");

    constellation.antialiasing = Options.antialiasing;
    constellation.scale.set(0.9, 0.9); constellation.updateHitbox(); constellation.screenCenter();
    add(constellation);

    constellationSound = new FlxSound(); constellationSound = FlxG.sound.play(Paths.sound('titleScreen/MonolithTeaser'), getVolume(1, 'sfx'));

    parachute = new FlxSprite(); parachute.antialiasing = Options.antialiasing; add(parachute); parachute.alpha = 0.001;

    preTitleTextGroup = new FlxTypedSpriteGroup(240); add(preTitleTextGroup);
}

function setupTitleStuff() {
    clouds = new FlxSprite().loadGraphic(Paths.image('menus/TitleScreen/SpinningClouds'));
    clouds.antialiasing = Options.antialiasing; clouds.screenCenter(); add(clouds);
    clouds.alpha = 0.001; clouds.scale.x = clouds.scale.y = 3*5.6;

    background = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/titleScreen/Background')); background.screenCenter(); background.y = FlxG.height + 20;
    background.antialiasing = Options.antialiasing; add(background); background.scale.x = background.scale.y = 1.1;
    foreground = new FlxSprite(-60, FlxG.height + 80).loadGraphic(Paths.image('menus/titleScreen/Foreground')); foreground.antialiasing = Options.antialiasing; add(foreground); foreground.scale.x = foreground.scale.y = 1.5;

    logo = new FunkinSprite(logoLerping[0],logoLerping[1]);
    logo.loadSprite(Paths.image('menus/titleScreen/logo'));
    logo.animateAtlas.anim.addBySymbol("Appearing", "_PARTS/Scenes/TitleScreen/Logo_Appearing", 24, false);
    for (i in 0...4) {
        logo.animateAtlas.anim.addBySymbolIndices("Idle"+i, "_PARTS/Scenes/TitleScreen/Logo_Idle", [i], 24, false);
    }
    logo.antialiasing = Options.antialiasing; logo.cameras = [menuCamera]; add(logo); logo.alpha = 0.0001; logo.scale.x = logo.scale.y = logoLerping[2];
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

function addMoreText(text:String, offset = 0, offLoad = 0){
	var coolText:Alphabet = new Alphabet(0, ((preTitleTextGroup.length - offLoad) * 60), text, true, false);
    coolText.scale.set(0.65, 0.65);

    coolText.y = -300 + ((preTitleTextGroup.length - offLoad) * 60);
    skippableTweens.push(FlxTween.tween(coolText, {y: FlxG.height/3 + ((preTitleTextGroup.length - offLoad) * 60) + offset}, 0.4, {ease: FlxEase.quartOut}));

    for (i in 0...coolText.members.length) {
        coolText.members[i].x -= 15 * i;
    }

    if (coolText.width >= 680) {
        var textWidth = coolText.width;
        for (i in 0...coolText.members.length) {
            coolText.members[i].scale.x *= 680 / textWidth;
            coolText.members[i].x += -coolText.members[i].x + 680 / coolText.members.length * i;
        }
    }

	coolText.screenCenter(FlxAxes.X);

	preTitleTextGroup.add(coolText);
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

    FlxG.sound.play(Paths.sound('titleScreen/ParachuteOpen'), getVolume(0.5, 'sfx'));

    parachute.x = preTitleTextGroup.members[whichLine].x;
    parachute.y = preTitleTextGroup.members[whichLine].y - parachute.height/2 + 30;

    parachute.setGraphicSize(preTitleTextGroup.members[whichLine].width, parachute.height);
    parachute.updateHitbox();

    var pHeight = parachute.height;

    parachute.scale.y = 0;
    skippableTweens.push(FlxTween.tween(parachute.scale, {y: 1}, 0.3, {ease: FlxEase.backOut}));
    skippableTweens.push(FlxTween.tween(parachute, {y: parachute.y - pHeight/2}, 0.3, {ease: FlxEase.backOut}));
}

var initYMatrixes = [];
var curYMatrixes = [];

function update(elapsed) {
    if (preIntro && constellation.animateAtlas.anim.finished) {
        skipTeaser();
    }

    if (controls.ACCEPT) {
        (preIntro == true) ? skipTeaser() : ((initialized == false) ? skipIntro() : FlxG.switchState(new MainMenuState())); //the switchstate is a placeholder thing
    }

    if (FlxG.keys.justPressed.F9) { //DEV, REMOVE ONCE DONE!
        preIntro = true;
        initialized = false;
        FlxG.sound.music.stop();
        logoLerping = [FlxG.width/2, FlxG.height/2, 1];
        FlxG.resetState();
    }

    if (!preIntro && !initialized) {
        earth.scale.x = earth.scale.y += 0.04 * elapsed;
        birdFlock.scale.x = birdFlock.scale.y += 0.06 * elapsed;
    }

    if (initialized) {
        logo.x = CoolUtil.fpsLerp(logo.x, logoLerping[0], 0.1);
        logo.y = CoolUtil.fpsLerp(logo.y, logoLerping[1], 0.1);
        logo.scale.x = logo.scale.y = CoolUtil.fpsLerp(logo.scale.y, logoLerping[2], 0.1);

        if (cloudBitmap != null) {
            cloudMatrix.translate(-cloudBitmap.width/2, -cloudBitmap.height/2);
            cloudMatrix.rotate(0.001);
            cloudMatrix.translate(cloudBitmap.width/2, cloudBitmap.height/2);
            clouds.pixels.fillRect(new Rectangle(0,0,clouds.pixels.width,clouds.pixels.height), 0x00000000);
            clouds.pixels.draw(cloudBitmap, cloudMatrix, null, null, null, Options.antialiasing);
        }
    }
}

var cloudBitmap;
var cloudMatrix = new Matrix();

function draw(event) {
    if (!preIntro && !initialized) {
        for (layer in birdFlock.animateAtlas.anim.curSymbol.timeline.getList()) { //there may be only one layer but iterating is okay enough
            var keyframe = layer.get(birdFlock.animateAtlas.anim.curSymbol.curFrame); //this goes through the current animation frame
            var birdElements = keyframe.getList(); //this gets all the objects inside of the frame

            if (initYMatrixes.length == 0) { //every frame changes the ty matrix so it's best to have something to keep track of them
                for (e in birdElements) {
                    initYMatrixes.push(e.matrix.ty);
                }
                curYMatrixes = initYMatrixes.copy();
            }

            var matIndex = 0;

            for (e in birdElements) {
                e.matrix.ty = curYMatrixes[matIndex] += -0.12 + -initYMatrixes[matIndex] * 0.22 * FlxG.elapsed; //ty is responsible for where it's placed on the Y axis
                matIndex++;
            }
        }
    }
}

function skipTeaser() {
    if (preIntro) {
        preIntro = false;

        constellation.destroy();
        constellationSound.stop();

        CoolUtil.playMenuSong(false);
        Conductor.changeBPM(150);
        FlxG.sound.music.volume = getVolume(1, 'music');

        skybox.alpha = earth.alpha = 1;
        earth.velocity.y = -21;

        windEmitter.start(false, 0.05);
        cloudEmitter.start(false, 0.4);

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
        skippableTweens.push(FlxTween.tween(cloudEmitter, {frequency: 0.1}, 9));

        skippableTweens.push(FlxTween.tween(fallingBF, {y: 350}, 12, {ease: FlxEase.elasticOut}));
        fallingGF.velocity.y = 27;

        birdFlock.moves = true;
        birdFlock.velocity.set(0, -45);

        for (layer in birdFlock.animateAtlas.anim.curSymbol.timeline.getList()) {
            var keyframe = layer.get(0);
            birdElements = keyframe.getList();
        }

        windAmbience = FlxG.sound.play(Paths.sound('titleScreen/WindAmbience'), getVolume(0.5, 'sfx'));

        beatHit(0);
    }
}

function beatHit(curBeat) {
    if (!initialized) {
        switch curBeat {
            case 0:
                addMoreText("Team Reimagination");
            case 2:
                addMoreText("and the rest of");
            case 3:
                addMoreText("The BND Team");
            case 4:
                addMoreText("present");

            case 6:
                spawnParachute(0);
            case 7:
                removeText();

            case 8:
                addMoreText("An interpretation", 30, 4);
            case 10:
                addMoreText("of", 30, 4);
            case 12:
                addMoreText("Vs. Dave & Bambi", 30, 4);

            case 14:
                spawnParachute(4);
            case 15:
                removeText();

            case 24:
                logo.alpha = 1;
                logo.animateAtlas.anim.play('Appearing', true);

            case 28:
                if (FlxG.save.data.shaders == 'all') skippableTweens.push(FlxTween.tween(blurFilter, {blurX: 16, blurY: 16}, 1, {ease: FlxEase.quartInOut}));
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
                addMoreText(curWacky[0], 60, 7 + (curBeat == 20 ? 2 : 0));
            } else if (curBeat % 4 == 1) {
                addMoreText(curWacky[1], 60, 7 + (curBeat == 21 ? 2 : 0));
            } else if (curBeat % 4 == 2) {
                spawnParachute(7 + (curBeat == 22 ? 2 : 0));
            } else if (curBeat % 4 == 3) {
                removeText();
            }
        }
    } else {
        logo.animateAtlas.anim.play('Idle'+curBeat % 4, true);
    }
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
        if (FlxG.save.data.shaders == 'all') blurFilter.blurX = blurFilter.blurY = 0.0001;

        logoLerping = [FlxG.width/2, FlxG.height/3.9, 0.95];
    }

    logo.animateAtlas.anim.play('Idle0', true);
    logo.alpha = 1;

    clouds.alpha = 1;
    cloudBitmap = clouds.pixels.clone();

    skippableTweens.push(FlxTween.tween(foreground.scale, {x: 1, y: 1}, 1., {ease: FlxEase.quartOut, startDelay: 0.85}));
    skippableTweens.push(FlxTween.tween(foreground, {y: foreground.y - 610}, 1., {ease: FlxEase.quartOut, startDelay: 0.85}));

    skippableTweens.push(FlxTween.tween(background.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quartOut, startDelay: 0.75}));
    skippableTweens.push(FlxTween.tween(background, {y: background.y - background.height + 20}, 1, {ease: FlxEase.quartOut, startDelay: 0.75}));

    skippableTweens.push(FlxTween.tween(clouds.scale, {x: 0.9*5.6, y: 0.6*5.6}, 2, {ease: FlxEase.quartOut}));
    skippableTweens.push(FlxTween.tween(clouds, {y: clouds.y - 210}, 1.5, {ease: FlxEase.quartOut}));
    
    if (initialized) {
        for (tween in skippableTweens) {
            tween.percent = 1;
        }
    } else initialized = true;
}

function processSelection() {

}