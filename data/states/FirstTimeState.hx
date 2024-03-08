import flixel.util.FlxGradient;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.addons.display.FlxBackdrop;
import funkin.editors.ui.UISliceSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import funkin.backend.system.framerate.Framerate;
import flixel.group.FlxTypedSpriteGroup;
import funkin.backend.FunkinSprite;
import funkin.backend.utils.CoolUtil;
import flixel.math.FlxMath;

var gradient = new FlxGradient().createGradientFlxSprite(FlxG.width, 117, [0x0066FFFF, 0xFFFFFFFF]);

var marqueeText = new FlxTypedSpriteGroup();

var walkProgress = new FlxSprite();
var progressGroup = new FlxTypedSpriteGroup();

var background = new UISliceSprite(0, 0, 70, 70, 'menus/firstTime/warningBox');
var header = new FlxSprite();
var textObj = new FlxText(0, 0, FlxG.width, "FIRST TIME LAUNCH");

var buttonGroup = new FlxTypedSpriteGroup();

var warningTweens = [];

var canMove = false;
var scaleButtons = true;

var pages = [ //header type, warning text, buttons, save options, save variable
    [
        'Warning',
        "\"Bamber & Davey\" contains flashing lights which may trigger people\nwith photosensitivity and/or epilepsy.\n\nDo you wish to disable them for the time being? You can always change\nyour mind later.",
        ['Yes', 'No'],
        [true, false],
        'flashingLights'
    ],
    [
        'Warning',
        "\"Bamber & Davey\" is not meant to be taken as an attack on\n\"Vs. Dave and Bambi\" of any sort. It's a project made out of passion and fun\nprimarly.\n\nBoth can coexist in peace.",
        ['Proceed'],
        null,
        null
    ],
    [
        'Note',
        "Difficulties in the mod scale differently than one might be used to.\nFor the average \"Friday Night Funkin'\" hard difficulty experience, please\nrefer to the normal difficulty.\n\nThis is important, as hard difficulty here is more mania-based.",
        ['Proceed'],
        null,
        null
    ],
    [
        'Note',
        "Some songs contain modcharts which may disorient or frustrate you.\nThey're on by default but can be disabled on a per-song basis at pause.\n\nWhat do you wish to do with them? You can always change\nyour mind later.",
        ['AlwaysYes', 'PerSong', 'AlwaysNo'],
        ['always', 'perSong', 'never'],
        'modcharts'
    ],
    [
        'Note',
        "Shaders are utilized to make the overall visual look better, but we\nunderstand that not everyone can run them reliably.\n\nHow many shaders do you wish to utilize? You can always change\nyour mind later. Do note that it will affect the visuals.",
        ['All', 'Some', 'None'],
        ['all', 'some', 'none'],
        'shaders'
    ],
    [
        'Copyright',
        "Some songs in \"Bamber & Davey\" contain copyrighted material which will be\nmarked with © where plausible.\n\nDo you wish to replace these with MIDI covers? You can always change\nyour mind later.",
        ['Yes', 'No'],
        [true, false],
        'copyrightBypass'
    ]
];

var curPageNum = 0;
var curPage = pages[curPageNum];
var oldPage = [];

var curSelected = 0;

function create() {
    Framerate.offset.y = -999;

    new FlxTimer().start(0.5, function(timer) { //this timer will be used to ease into states in case you skip the splash screen
        Framerate.offset.y = 0;

        gradient.y = 623; add(gradient); gradient.antialiasing = true;

        //updateHitbox is important for some reason because otherwise the FlxBackdrop won't recognize its graphic.
        textObj.setFormat(Paths.font('TW Cen MT B.ttf'), 140, 0xFF555555); textObj.updateHitbox();
    
        //regenGraphic is necessary for readdjusting all the stuff once it's scaled. And X adjusting is so that F in FIRST is seen first.
        marqueeText = new FlxBackdrop(textObj.graphic, FlxAxes.X); marqueeText.velocity.x = -40; marqueeText.scale.x = 1.5; marqueeText.regenGraphic(FlxG.camera); marqueeText.x += 400; marqueeText.y -= 5; add(marqueeText); marqueeText.antialiasing = true;
    
        //Incorporeal makes it uninteractable, which not only is intentional, but also prevents it from crashing on a state that does not extend UIState.
        //Rounding placement changes is important too since it prevents visual artifacts.
        //reducing half of a corner tile's width to the placement change centers it better.
        background.incorporeal = true; centerBackground(); add(background); background.antialiasing = true;
    
        FlxTween.tween(background, {bWidth: 1008}, 0.4, {ease: FlxEase.backOut});
        FlxTween.tween(background, {bHeight: 447}, 0.5, {ease: FlxEase.backOut, onUpdate: function(tween) {
            centerBackground();
        }, onComplete: function(tween) {generatePage();}});

        FlxG.sound.play(Paths.sound('firstTime/background'), getVolume(0.6, 'sfx'));
    
        gradient.alpha = marqueeText.alpha = textObj.alpha = header.alpha = walkProgress.alpha = 0.001;
        FlxTween.tween(gradient, {alpha: 0.7}, 1, {ease: FlxEase.quartInOut});
        FlxTween.tween(marqueeText, {alpha: 0.7}, 1, {ease: FlxEase.quartInOut});

        //convert text template used for marquee text into something useful.
        textObj.setFormat(Paths.font('TW Cen MT N.ttf'), 30, 0xFF511863, 'center'); textObj.fieldWidth = 1000; textObj.screenCenter(); textObj.y -= 70; add(textObj); textObj.antialiasing = true;

        add(header);

        var manX = 0;
        for (i in 0...21) {
            var prog:FlxSprite = new FlxSprite(manX, 0);
            prog.frames = Paths.getFrames('menus/firstTime/progress');

            if (i % 4 == 0) {
                prog.animation.addByPrefix('empty', "Circle_Empty", 24, false);
                prog.animation.addByPrefix('full', "Circle_Full", 24, false);

                prog.animation.play('empty');
            } else {
                prog.animation.addByPrefix('dot', "Dot", 24);

                prog.animation.play('dot');

                prog.y += progressGroup.members[0].height / 2.75;
            }

			prog.ID = i;
            progressGroup.add(prog);

            prog.scale.x = prog.scale.y = 0;
            FlxTween.tween(prog.scale, {x:1, y:1}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.03 * i});

            manX += prog.width * (i % 4 == 0 ? 0.85 : 0.4 * (i % 4 == 3 ? 0.15 : 1));
            prog.antialiasing = true;
        }

        add(buttonGroup);
        progressGroup.screenCenter(); progressGroup.y = FlxG.height + 10 - progressGroup.height; add(progressGroup);

        walkProgress.frames = Paths.getFrames('menus/firstTime/progress'); walkProgress.animation.addByPrefix('walk', "Progress_Walk", 24, true); walkProgress.animation.play('walk'); walkProgress.x = progressGroup.x - walkProgress.width - 30; walkProgress.y = progressGroup.y - walkProgress.height / 2 - 7; add(walkProgress); walkProgress.antialiasing = true;
        warningTweens.push(FlxTween.tween(walkProgress, {alpha: 1, x: walkProgress.width/8 + progressGroup.members[curPageNum * 4].x}, 1, {ease: FlxEase.quartOut}));
    }, 1);
}

function processSelection() {
    FlxG.sound.play(Paths.sound('firstTime/'+(curPageNum+1 != pages.length ? 'firstTimeAccept' : 'firstTimeFinalPage')), getVolume(1, 'sfx'));

    if (curPage[4] != null) Reflect.setField(FlxG.save.data.options, curPage[4], curPage[3][curSelected]);

    clearClickables();

    transitionPage();
}

function update(elapsed) {
    if (canMove) {
        if ((controls.LEFT_P || controls.RIGHT_P) && curPage[2].length != 1) {
            FlxG.sound.play(Paths.sound('firstTime/firstButtonScroll'), getVolume(0.8, 'sfx'));
            changeSelection(controls.LEFT_P ? -1 : 1);
        }

        if (controls.ACCEPT) {
            processSelection();
        }
    }
}

function postUpdate(elapsed) {
    buttonGroup.forEach(function (button) {
        button.scale.x = button.scale.y = CoolUtil.fpsLerp(button.scale.x, !scaleButtons ? (button.ID == curSelected ? 1 : 0.7) : 0, 0.3);

        if (canMove && FlxG.mouse.visible && FlxG.mouse.overlaps(button.animateAtlas)) {
            if (curSelected != button.ID) {
                FlxG.sound.play(Paths.sound('firstTime/firstButtonScroll'), getVolume(0.8, 'sfx'));
                changeSelection(button.ID - curSelected);
            }

            if (FlxG.mouse.justReleased && curSelected == button.ID) processSelection();
        }
    });
}

function changeSelection(change = 0) {
    curSelected = FlxMath.wrap(curSelected+change, 0, curPage[2].length - 1);
    for (i in buttonGroup.members) {
        i.animateAtlas.anim.play("Button", true, curSelected == i.ID ? false : true, curSelected == i.ID ? i.animateAtlas.anim.curFrame - i.animateAtlas.anim.length : i.animateAtlas.anim.curFrame + i.animateAtlas.anim.length );
    }
}

function centerBackground() {
    background.screenCenter(); background.x -= Math.round(background.bWidth/2) - 16; background.y -= Math.round(background.bHeight/2) - 16;
}

function generatePage() {
    if (curPage[0] != oldPage[0]) header.loadGraphic(Paths.image('menus/firstTime/header_'+curPage[0])); header.screenCenter(); header.y -= 150; header.antialiasing = true;
    textObj.text = curPage[1];

    warningTweens.push(FlxTween.tween(header, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut, startDelay: 0.2}));
    warningTweens.push(FlxTween.tween(textObj, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut, startDelay: 0.2}));

    if (oldPage[2] == null || curPage[2][0] != oldPage[2][0]) {
        for (i in buttonGroup.members) {
            i.destroy();
        }
        buttonGroup.clear();

        for (i in 0...curPage[2].length) {
            var buttonSpr = new FunkinSprite(i * 300, 0);
            buttonSpr.loadSprite(Paths.image('menus/firstTime/buttons'));

            buttonSpr.animateAtlas.anim.addBySymbol("Button", "Button_"+curPage[2][i]+'\\', 24, false); //the \ makes sure it chooses what we want instead of the closest thing it thinks of (i.g. no instead of none)
            buttonSpr.animateAtlas.anim.play("Button", true, true);

			buttonSpr.ID = i;
            buttonSpr.antialiasing = true;
            buttonSpr.scale.x = buttonSpr.scale.y = 0;
            buttonGroup.add(buttonSpr);
            pushToClickables(buttonSpr);
        }

        buttonGroup.screenCenter(); buttonGroup.x -= 113; buttonGroup.y += 100;
        changeSelection();
    }

    new FlxTimer().start(0.2, function(timer) {
        scaleButtons = false;
        canMove = true;
    });
}

function transitionPage() {
    curPageNum++; oldPage = curPage; curPage = pages[curPageNum];
    canMove = false;
    scaleButtons = (curPage == null || curPage[2][0] != oldPage[2][0]);

    for (tween in warningTweens) {
        tween.cancel();
    }

    progressGroup.members[(curPageNum-1) * 4].animation.play('full');

    if (curPageNum != pages.length) warningTweens.push(FlxTween.tween(walkProgress, {x: walkProgress.width/8 + progressGroup.members[curPageNum * 4].x}, 1, {ease: FlxEase.quartOut}));
    else {
        warningTweens.push(FlxTween.tween(walkProgress, {alpha: 0, x: walkProgress.width/8 + progressGroup.members[(curPageNum-1) * 4].x + 300}, 1, {ease: FlxEase.quartIn}));

        for (i in 0...progressGroup.members.length) {
            FlxTween.tween(progressGroup.members[i].scale, {x: 0, y: 0}, 0.4, {ease: FlxEase.quartIn, startDelay: 0.03 * i});
        }

        FlxG.save.data.notFirstLaunch = true;
        FlxG.save.flush();

        new FlxTimer().start(0.5, function(timer) {
            FlxG.sound.play(Paths.sound('firstTime/backgroundR'), getVolume(0.6, 'sfx'));

            FlxTween.tween(background, {bWidth: 70}, 0.5, {ease: FlxEase.backIn});
            FlxTween.tween(background, {bHeight: 70}, 0.4, {ease: FlxEase.backIn, onUpdate: function(tween) {
                centerBackground();
            }, onComplete: function(tween) {background.destroy();}});
    
            FlxTween.tween(gradient, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
            FlxTween.tween(marqueeText, {alpha: 0}, 1, {ease: FlxEase.quartInOut, onComplete: function(tween) {
                skipTransIn = skipTransOut = true;
                FlxG.switchState(new ModState('BNDMenu'));
            }});
        }, 1);
    }

    if (curPage == null || curPage[0] != oldPage[0]) warningTweens.push(FlxTween.tween(header, {alpha: 0.001}, 0.5, {ease: FlxEase.quartInOut, startDelay: 0.2}));
    warningTweens.push(FlxTween.tween(textObj, {alpha: 0.001}, 0.5, {ease: FlxEase.quartInOut, startDelay: 0.2, onComplete: function(tween) {
        if (curPageNum != pages.length) {
            if (curPage[2].length != 1) { curSelected = 0; changeSelection(0); }

            generatePage();
        }
    }}));
}