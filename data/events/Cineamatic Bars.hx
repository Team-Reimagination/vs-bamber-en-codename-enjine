var cinematicBar1:FunkinSprite = null;
var cinematicBar2:FunkinSprite = null;

var cinematicAngle:Float = 0;
var cinematicLength:Float = 0;

function postCreate() {
    cinematicBar1 = new FunkinSprite(0, -360).makeGraphic(1280, 360, 0xFF000000);
    cinematicBar1.zoomFactor = 0;
    cinematicBar1.scrollFactor.set(0, 0);
    add(cinematicBar1);

    cinematicBar2 = new FunkinSprite(0, 720).makeGraphic(1280, 360, 0xFF000000);
    cinematicBar2.zoomFactor = 0;
    cinematicBar2.scrollFactor.set(0, 0);
    add(cinematicBar2);
}

function update() {
    cinematicBar1.origin.y = 720 - cinematicLength;
    cinematicBar1.angle = cinematicAngle;
    //cinematicBar1.y = cinematicLength - 360;

    cinematicBar2.origin.y = -360 + cinematicLength;
    cinematicBar2.angle = cinematicAngle;
    //cinematicBar2.y = -cinematicLength + 720;
}

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Cineamatic Bars") {
        if (params[0] == false)
            cinematicLength = (FlxG.height/2) * params[1];
        else {
            var flxease:String = params[4] + (params[4] == "linear" ? "" : params[5]);
            FlxTween.num(cinematicLength, (FlxG.height/2) * params[1], ((Conductor.crochet / 4) / 1000) * params[3], {ease: Reflect.field(FlxEase, flxease)}, function(num) cinematicLength = num);
            FlxTween.num(cinematicAngle, params[2], ((Conductor.crochet / 4) / 1000) * params[3], {ease: Reflect.field(FlxEase, flxease)}, function(num) cinematicAngle = num);
        }
    }
}