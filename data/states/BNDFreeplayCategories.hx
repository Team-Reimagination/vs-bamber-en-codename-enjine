var data = [ // Image, Title, [Song1, Song2, etc], color, font
	["Bamber", "Week Bamber", ["Yield", "Cornaholic", "Harvest"], 0xB6FF00],
	["Davey", "Week Davey", ["Synthwheel", "Yard", "Coop"], 0x0066FF],
	["Ronnie And Boris", "Week Ronnie & Boris", ["Ron Be Like", "Bob Be Like", "Fortnite Duos"], 0xFED73E],
	["Bonuses", "Bonus Songs", ["Blusterous Day", "Swindled","Trade", "Multiversus"], 0x00FFA6],
	["Jokes", "Joke Songs", ["Generations","Memeing","Judgement Farm","Judgement Farm 2","Yield - OST"], 0x038703],
	["Collabs", "Collab Songs", ["Call (Bamber Mix)","Deathbattle","H2O"], 0xA5CEE3],
	["Crossovers", "Crossover Songs", ["Corn N Roll","Screencast"], 0xFE3455],
	["Legacy", "Legacy/Old Content", ["Yield V1", "Cornaholic V1", "Harvest V1", "Yield Seezee Remix", "Cornaholic Erect Remix V1", "Harvest Chill Remix"], 0x16AD01],
];
var vinylGroup:FlxTypedGroup = new FlxTypedGroup();
var curSelected:Int = 0;
function create() {
    for (id=>i in data) {
        var sprite = new FlxSprite().loadGraphic(Paths.image("menus/vinyls/" + i[0]));
        sprite.shader = new CustomShader("vinylDistortion");
        sprite.shader.distortion = 1.0;
        sprite.ID = id;
        sprite.scale.set(0.5, 0.5);
        vinylGroup.add(sprite);
    }
    add(vinylGroup);
}

function update() {
    if (controls.LEFT_P) change(-1);
    if (controls.RIGHT_P) change(1);
    for (i in vinylGroup.members) {
        i.x = lerp(i.x, -400 * (curSelected - i.ID), 0.04);
    }
}

function change(a) {
    curSelected = FlxMath.wrap(curSelected + a, 0, vinylGroup.length - 1);
    for (i in vinylGroup.members) {
        var targetNumber = curSelected == i.ID ? 1 : 0;
        FlxTween.num(i.shader.distortion, targetNumber, 0.6, {ease: FlxEase.sineOut}, function(num) {
            i.shader.distortion = num;
        });
    }
}