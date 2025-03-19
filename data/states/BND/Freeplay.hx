//
import flixel.group.FlxGroup;

var songList:Array<Array<String>> = [
    ["yield", "cornaholic", "harvest"], // Bamber's Farm
    ["synthwheel", "yard", "coop"], // Davey's Yard
    ["ron be like", "bob be like", "fortnite duos"], // Romania Outskirts
    ["blusterous day", "swindled", "trade", "multiversus"], // Bonus Songs
    ["generations", "memeing", "judgement farm", "judgement farm 2", "yeld", "squeaky clean"], // Joke Songs
    ["call bamber", "deathbattle", "h2o"], // Collab Songs
    ["corn n roll", "screencast"], // Crossover Songs
    ["astray", "facsimile", "placeholder", "test footage"] // Davey's Nightmare
];

var curCat:Int = 0;
var curSel:Int = 1;

// stuff for the cassette menu
var arrows:Array<FunkinSprite> = [];
var arrowTimer:FlxTimer = new FlxTimer();
var cassettes:Array<FunkinSprite> = [];
var cassLerpY:Float = 150.0;
var cassTimer:FlxTimer = new FlxTimer();

var freeplayButtons:Array<FlxGroup> = []; // = new FlxTypedSpriteGroup(0, 0);

function create() {
    add(new FunkinSprite().loadGraphic(Paths.image("menus/menuBG"))).screenCenter();

    for (a in 0...songList.length) {
        cassettes.push(new FunkinSprite().loadGraphic(Paths.image("menus/freeplay/cassettes/" + (Assets.exists(Paths.image("menus/freeplay/cassettes/" + a)) ? a : "PLACEHOLDER"))));
        add(cassettes[a]).antialiasing = Options.antialiasing;
    }

    for (a in 0...2) {
        arrows.push(new FunkinSprite(0, 525));
        arrows[a].frames = Paths.getSparrowAtlas("menus/freeplay/selectArrows");
        for(z in ["Select", "Idle"]) arrows[a].animation.addByPrefix(z, ["l", "r"][a] + z, 24, false);
        arrows[a].animation.play("Idle");
        arrows[a].y = FlxG.height / 1.625 - cassettes[a].height / 2 + arrows[a].height;
        arrows[a].x = [FlxG.width / 2 - cassettes[a].width/2 - arrows[a].width/2 - 5, FlxG.width / 2 + cassettes[a].width/3 - 5][a]; // what the fuck
        add(arrows[a]).antialiasing = Options.antialiasing;
    }
}

function update() {
    if (controls.UP_P || controls.DOWN_P || FlxG.mouse.wheel != 0)
        changeSel((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

    if (controls.LEFT_P || controls.RIGHT_P)
        changeCat(controls.LEFT_P ? -1 : 1);

    for (a in 0...2)
        arrows[a].y = lerp(arrows[a].y, cassettes[curCat].y + cassettes[curCat].height / 2 - arrows[a].height / 2, 0.33);

    for (a in 0...cassettes.length) {
        cassettes[a].x = lerp(cassettes[a].x, FlxG.width / 3 * (a - curCat + 1.5) - cassettes[a].width/2, 0.2);
        cassettes[a].y = lerp(cassettes[a].y, cassLerpY + (FlxG.height / 1.625 - cassettes[a].height / 2 * -Math.abs(a - curCat)), 0.2);
    }

}

function generateFreeplayButton(idk:String):FlxGroup {
    var grp:FlxGroup = new FlxGroup();
    grp.add(new FunkinSprite().loadGraphic(Paths.image(idk)));
    grp.add(new Alphabet(0, 0, idk, true, false));
    return grp;
}

function changeSel(_:Int) {
}

function changeCat(_:Int) {
    FlxG.sound.play(Paths.sound("menu/freeplay/cassetteScroll"));

    curCat = FlxMath.wrap(curCat + _, 0, songList.length - 1);
    arrows[_ == -1 ? 0 : 1].animation.play("Select");
    arrows[_ == -1 ? 1 : 0].animation.play("Idle");
    freeplayButtons = [];

    if (cassLerpY != 0)
        FlxG.sound.play(Paths.sound("menu/freeplay/cassetteAppear"));
    arrowTimer.time = cassTimer.time = cassLerpY = 0;
    cassTimer.start(1.0, () -> {
        cassLerpY = 150.0;
        FlxG.sound.play(Paths.sound("menu/freeplay/cassetteDisappear"));
    });
    arrowTimer.start(0.375, () -> arrows[_ == -1 ? 0 : 1].animation.play("Idle"));

    freeplayButtons.push(generateFreeplayButton("Play All"));
    for (a in songList[curCat])
        freeplayButtons.push(generateFreeplayButton(a));
}