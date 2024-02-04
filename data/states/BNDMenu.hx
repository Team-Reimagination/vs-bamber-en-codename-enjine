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

public static var initialized = false;
public static var preIntro = true;

var skippableTweens = [];

var earth, cloudEmitter, windEmitter, fallingBF, fallingGF, birdFlock, constellation, constellationSound, textBox, preTitleTextGroup; //they all don't get assigned anything if the state was initialized beforehand

var skybox = new FlxGradient().createGradientFlxSprite(FlxG.width, FlxG.height, [0xFF272BC2, 0xFF007DE7, 0xFF74E9FF, 0xFFDBF9FF]);
var curWacky = [];
var usedTexts = [];

function create() {
    skybox.antialiasing = Options.antialiasing; add(skybox);

    if (preIntro) setupPreTitleStuff();

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

    textBox = new UISliceSprite(0, 0, 70, 70, 'menus/titleScreen/textBox');
    textBox.incorporeal = true; centerBackground(); add(textBox); textBox.antialiasing = Options.antialiasing;
    textBox.bWidth = 700;
    textBox.bHeight = 300;
    textBox.alpha = 0.6;
    textBox.blend = 9; //multiply
    centerBackground();

    constellation = new FunkinSprite();
    constellation.loadSprite(Paths.image('menus/titleScreen/constellation'));

    constellation.animateAtlas.anim.addBySymbol("Constellation", "Monolith", 24, false);
    constellation.animateAtlas.anim.play("Constellation");

    constellation.antialiasing = Options.antialiasing;
    constellation.scale.set(0.9, 0.9); constellation.updateHitbox(); constellation.screenCenter();
    add(constellation);

    constellationSound = new FlxSound(); constellationSound = FlxG.sound.play(Paths.sound('titleScreen/MonolithTeaser'), getVolume(1, 'sfx'));

    preTitleTextGroup = new FlxTypedSpriteGroup(240); add(preTitleTextGroup);
}

function centerBackground() {
    textBox.screenCenter(); textBox.x = 900 - Math.round(textBox.bWidth/2) - 16; textBox.y -= Math.round(textBox.bHeight/2) - 16;
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

function addMoreText(text:String, startNew = false){
	var coolText:Alphabet = new Alphabet(0, (preTitleTextGroup.length * 60), text, true, false);
    coolText.scale.set(0.6, 0.6);

    for (i in 0...coolText.members.length) {
        coolText.members[i].x -= 18 * i;
    }

    if (coolText.width >= 650) {
        var textWidth = coolText.width;
        trace(650 / textWidth);
        for (i in 0...coolText.members.length) {
            coolText.members[i].scale.x *= 650 / textWidth;
            coolText.members[i].x += -coolText.members[i].x + 650 / coolText.members.length * i;
        }
    }

	coolText.screenCenter(FlxAxes.X);

    coolText.alpha = 0; skippableTweens.push(FlxTween.tween(coolText, {alpha: 1}, 0.3, {ease: FlxEase.quartOut}));

	preTitleTextGroup.add(coolText);
    (!startNew ? skippableTweens.push(FlxTween.tween(preTitleTextGroup, {y: FlxG.height / 2 - preTitleTextGroup.height / 2}, 0.3, {ease: FlxEase.quartInOut})) : preTitleTextGroup.y = FlxG.height / 2 - preTitleTextGroup.height / 2);
}

function removeText() {
    for (i in preTitleTextGroup.members) {
        if (i != null) {
            for (letter in i.members) {
                skippableTweens.push(FlxTween.tween(letter, {alpha: 0}, 0.3, {ease: FlxEase.quartIn, onComplete: function (tween) {letter.destroy();}}));
            }
        }
    }
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
        FlxG.resetState();
    }

    if (!preIntro && !initialized) {
        earth.scale.x = earth.scale.y += 0.04 * elapsed;
        birdFlock.scale.x = birdFlock.scale.y += 0.06 * elapsed;
    }
}

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

        beatHit(0);
    }
}

function beatHit(curBeat) {
    if (!initialized) {
        switch curBeat {
            case 0:
                addMoreText("Team Reimagination", true);
            case 2:
                addMoreText("and the rest of");
            case 3:
                addMoreText("The BND Team");
            case 4:
                addMoreText("present");

            case 7:
                removeText();

            case 8:
                preTitleTextGroup.clear();
                addMoreText("An interpretation", true);
            case 10:
                addMoreText("of");
            case 12:
                addMoreText("Vs. Dave & Bambi");

            case 15:
                removeText();

            case 24:
                preTitleTextGroup.destroy();
                
            case 32:
                skipIntro();
        }

        if (curBeat >= 16 && curBeat < 24) {
            if (curBeat % 4 == 0) {
                var picked = FlxG.random.int(0, allTexts.length-1, usedTexts);
                usedTexts.push(picked);
                curWacky = allTexts[picked];
                preTitleTextGroup.clear();
                addMoreText(curWacky[0], true);
            } else if (curBeat % 4 == 1) {
                addMoreText(curWacky[1]);
            } else if (curBeat % 4 == 3) {
                removeText();
                if (curBeat == 23) skippableTweens.push(FlxTween.tween(textBox, {alpha: 0}, 0.5, {ease: FlxEase.quartIn, onComplete: function (tween) {textBox.destroy();}}));
            }
        }
    }
}

function skipIntro() {
    if (!initialized) {
        initialized = true;

        FlxG.sound.music.time = 12800;
        Conductor.__updateSongPos(FlxG.elapsed);

        for (tween in skippableTweens) {
            tween.percent = 1;
        }

        FlxG.camera.flash();

        windEmitter.destroy(); earth.destroy(); cloudEmitter.destroy(); fallingBF.destroy(); fallingGF.destroy(); birdFlock.destroy(); 
        if (textBox != null) textBox.destroy();
        if (preTitleTextGroup != null) preTitleTextGroup.destroy();
    }
}

function processSelection() {

}