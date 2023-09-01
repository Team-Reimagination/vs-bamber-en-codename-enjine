import FlxMath;

var shader = new CustomShader('grain');
var bloom = new CustomShader('bloom');
var scanline = new CustomShader('scanLines');
var vignette = new CustomShader('vignette');
var cooler = new CustomShader('sketchShader');

var elapsedShader:Float = 0;
var grainStrength:Float = 16;
var actualGrainStrength:Float = 16;
var chromaticaAbber:Float = 0.001;
var tempBeat:Int = 0;
var oppositeHealth:Float = 1;
var hdr:Float = 1.5;
var time:Float;

if(["astray", "facsimile", "placeholder", "test footage"].contains(curSong)){
    function postCreate(){
        for(a in [cooler, bloom, shader, scanline]){camHUD.addShader(a);}
        for(b in [cooler, bloom, vignette]){camGame.addShader(b);}
        bloom.data.hDRthingy.value = [1.5];
        shader.data.strength.value = [35];
        vignette.data.size.value = [1.2];
        scanline.data.opacity.value = [misses/6];
        for(a in [boyfriend, iconP2, healthBar, healthBarBG]){
           a.alpha = 0;
        }
        FlxG.state.forEachOfType(FlxText, text -> text.visible = false);
    }

    function postUpdate(elapsed){
        camFollow.y = dad.getMidpoint().y + 50;
        camFollow.x = dad.getMidpoint().x + 20;

        oppositeHealth = (2.2 - health);

        chromaticaAbber = FlxMath.lerp(chromaticaAbber, 0.1, 0.02);
        bloom.data.chromatic.value = [chromaticaAbber];
        if (curBeat != tempBeat)
            {
                chromaticaAbber = 1;
                tempBeat = PcurBeat;
            }
        hdr = 1.5 - (misses / 20);
        bloom.data.hDRthingy.value = [hdr];
        elapsedShader += Std.parseFloat(elapsed);
        shader.data.iTime.value = [elapsedShader];
        grainStrength = oppositeHealth * 47;
        actualGrainStrength = FlxMath.lerp(actualGrainStrength, grainStrength, 0.01);
        shader.data.strength.value = [actualGrainStrength];

        scanline.data.opacity.value = [oppositeHealth/6];
    }
}