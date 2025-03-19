//
var shader:CustomShader = new CustomShader("monitorEffect");
var vignette:CustomShader = new CustomShader("vignette");
var grain:CustomShader = new CustomShader("grain");
var bloom:CustomShader = new CustomShader("bloom");

public var darkness:Float = 0.0;

function postCreate() {
    doIconBop = false;
    FlxG.camera.bgColor = 0xFF191919;
    // shaders
    if(Options.gameplayShaders)
        for (a in FlxG.cameras.list)
            for(b in [grain, vignette, bloom, shader])
                a.addShader(b);
    // shader vars
    bloom.hDRthingy = 1.5;
    bloom.chromatic = 0.5;
    shader.strength = 35;
    vignette.size = 1.2;
    shader.uScanlineEffect = 1.0;
}

function update() {
	bloom.hDRthingy = darkness + 1.5 - (misses / 20);
}

function destroy()
    FlxG.camera.bgColor = FlxColor.TRANSPARENT;

function onNoteHit(e) { // joke model alt poses randomization
    if (e.character.curCharacter == "joke_model_obj" && FlxG.random.bool(10) && !e.note.isSustainNote)
        e.animSuffix = e.note.animSuffix = "-alt";
    if (e.note.isSustanNote)
        e.animSuffix = e.note.prevNote.animSuffix;
}