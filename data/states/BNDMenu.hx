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

public static var initialized = false;
public static var preIntro = true;

var skippableTweens = [];

var earth, cloudEmitter, windEmitter, fallingBF, fallingGF, birdFlock, constellation, constellationSound; //they all don't get assigned anything if the state was initialized beforehand

var skybox = new FlxGradient().createGradientFlxSprite(FlxG.width, FlxG.height, [0xFF272BC2, 0xFF007DE7, 0xFF74E9FF, 0xFFDBF9FF]);

function create() {
    skybox.antialiasing = Options.antialiasing; add(skybox);

    if (preIntro) {
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

        fallingBF = new FlxSprite(120, 100); fallingBF.frames = Paths.getSparrowAtlas('menus/titleScreen/Falling_BF'); fallingBF.animation.addByPrefix('falling', 'Falling_BF', 24, true); fallingBF.animation.play('falling'); fallingBF.antialiasing = Options.antialiasing; add(fallingBF);
        fallingGF = new FlxSprite(250, -350); fallingGF.frames = Paths.getSparrowAtlas('menus/titleScreen/Falling_GF'); fallingGF.animation.addByPrefix('falling', 'Falling_GF', 24, true); fallingGF.animation.play('falling'); fallingGF.antialiasing = Options.antialiasing; add(fallingGF);

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
    }

    if (initialized) skipIntro();
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
    }
}

function beatHit(curBeat) {
    if (!initialized) {
        switch curBeat {
            case 32:
                skipIntro();
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
    }
}

function processSelection() {

}