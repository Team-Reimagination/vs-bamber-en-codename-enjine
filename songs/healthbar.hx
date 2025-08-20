//This is placeholder til i code something myself.
import flixel.math.FlxRect;
import flixel.ui.FlxBar;

public var healthBarBG1:FlxSprite;
public var healthBarBG2:FlxSprite;
public var healthBar1:FlxBar;

var barTypes = [
    //STAGE-BASED
    'default' => ['default'],
    'bfdifield' => [null,0,false],
    'cheater' => ['multiversus',20],
    'battlegrounds' => [null,0,null,null],
    'undertalestage' => ['undertale',0,false],
    'judgement hall' => ['undertale',0,false],
    'paintvoid' => ['paintvoid/astray'],
    'oldFarm' => [null,0,false],
    'oldFarm_night' => [null,0,false],
    'hot farm' => [null,0,false],
    'exchangetown' => ['exchangetown',0,false],
    //SONG SPECIFIC
    'Generations' => ['genstage',0,null,false],
    'Facsimile' => ['paintvoid/facsimile'],
    'Placeholder' => ['paintvoid/placeholder'],
    'test footage' => ['paintvoid/placeholder'],
    'h2o' => [null,0,false],
    'Multiversus' => ['multiversus',20],
];

var curBarType = (barTypes[PlayState.instance.SONG.meta.name] != null ? barTypes[PlayState.instance.SONG.meta.name] : (barTypes[SONG.stage] != null ? barTypes[SONG.stage] : barTypes['default']));

var barType_directory = curBarType[0] != null ? curBarType[0] : SONG.stage;
var barType_Y = curBarType[1];
var bar_COLOR = curBarType[2];
var bar_Noteshader = curBarType[3];

function create() {
    healthBarBG1 = new FlxSprite().loadGraphic(Paths.image('game/healthbars/'+barType_directory));
    healthBarBG2 = new FlxSprite().loadGraphic(Paths.image('game/healthbars/'+barType_directory));
    for(i in [healthBarBG1,healthBarBG2]){
        i.screenCenter(FlxAxes.X);
        i.y = FlxG.height * 0.87+barType_Y;
    }
    healthBar1 = new FlxBar(healthBarBG1.x + 4, healthBarBG1.y + 4, '', Std.int(healthBarBG1.width - 8), Std.int(healthBarBG1.height - 8), health, 0, 2);
}
function postUpdate(elapsed:Float) {
    healthBarBG1.clipRect = new FlxRect((2-health)/2*healthBarBG1.width,0,health/2*healthBarBG1.width,healthBarBG1.height);
    healthBarBG2.clipRect = new FlxRect(0,0,(2-health)/2*healthBarBG2.width,healthBarBG2.height);
    PlayState.instance.comboGroup.cameras = [camHUD];
    add(PlayState.instance.comboGroup);
    comboGroup.setPosition(900,500);
    comboGroup.scale.set(0.5,0.5);
}
function postCreate() {
    if(bar_COLOR!=null){
        trace("shgrhguir");
    }else{
    healthBarBG.alpha = healthBar.alpha=0.0001;
    
    insert(1,healthBarBG1);
    insert(1,healthBarBG2);

    if(bar_Noteshader!=null){healthBarBG1.color = boyfriend.iconColor;
        healthBarBG2.color = dad.iconColor;}else{
    var color = boyfriend.iconColor;
    var colorShader = new CustomShader("ColoredNoteShader");
    colorShader.r = ((color >> 16) & 0xFF);
    colorShader.g = ((color >> 8) & 0xFF);
    colorShader.b = ((color) & 0xFF);

    //REMINDER_RE-WRITE_THIS_TO_NOT_BE_ASS--ear.
    var color_2 = dad.iconColor;
    var colorShader_2 = new CustomShader("ColoredNoteShader");
    colorShader_2.r = ((color_2 >> 16) & 0xFF);
    colorShader_2.g = ((color_2 >> 8) & 0xFF);
    colorShader_2.b = ((color_2) & 0xFF);

    healthBarBG1.shader = colorShader;
    healthBarBG2.shader = colorShader_2;
    }
     for(i in [healthBarBG1,healthBarBG2]) i.camera = camHUD;
}
}