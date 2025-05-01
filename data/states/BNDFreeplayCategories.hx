import funkin.backend.chart.Chart;
import flixel.text.FlxTextBorderStyle;
import funkin.savedata.FunkinSave;
import funkin.backend.FunkinText;
import flixel.group.FlxTypedSpriteGroup;
import openfl.Assets;
import Sys;

var arrows:Array<FunkinSprite> = [];
var moveTimer:FlxTimer = new FlxTimer();
var appear = true;

var data = [ // Image, Title, [Song1, Song2, etc], color, font
	["BambersFarm", "Week Bamber", 0xB6FF00],
	["DaveysYard", "Week Davey", 0x0066FF],
	["RomaniaOutskirts", "Week Ronnie & Boris", 0xFED73E],
	["BonusWIP", "Bonus Songs", 0x00FFA6],
	["Jokes", "Joke Songs", 0x038703],
	["Collabs", "Collab Songs", 0xA5CEE3],
	["Crossovers", "Crossover Songs", 0xFE3455],
	["Remixes", "Remixes", 0xFF338A9C],
	["Legacy", "Legacy/Old Content", 0x16AD01]
];

var songst = [	
	["Yield", "Cornaholic", "Harvest"],
	["Synthwheel", "Yard", "Coop"],
	["Ron Be Like", "Bob Be Like", "Fortnite Duos"],
	["Blusterous Day", "Swindled", "Trade", "Multiversus"],
	["Generations","Memeing","Judgement Farm","Judgement Farm 2","Yield - OST"],
	["Call (Bamber Mix)","Deathbattle","H2O"],
	["Corn N Roll","Screencast"],
	["Spookeez", "South", "Pico", "2Hot"],
	["Yield V1", "Cornaholic V1", "Harvest V1", "Yield Seezee Remix", "Cornaholic Erect Remix V1", "Harvest Chill Remix"]
];

var vinylGroup:FlxTypedGroup = new FlxTypedGroup();
var vinylNotVinylAssFucker = new FlxCamera();
var textCam = new FlxCamera();
var curSelected:Int = 0;
var songser = [];
var songL:FlxTypedGroup<FlxText> = [];
var songLBgs:FlxTypedGroup = new FlxTypedGroup();
var album;
var timer = 0;
var playall;
var scorText = new FlxText(24, 0);

subCurSelected = 0;
subCurSelectedLimit = songser.length - 1;

function create() {
	for (i in Paths.getFolderContent(Paths.image("menus/freeplay/albums/"))) Paths.image("menus/freeplay/albums/" + i);
	for (i in Paths.getFolderContent(Paths.image("menus/freeplay/silhouettes/"))) Paths.image("menus/freeplay/silhouettes/" + i);
	add(new FunkinSprite().loadGraphic(Paths.image("menus/menuBG"))).screenCenter();
	album = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/albums/vol2.5"));
	add(album);
	album.screenCenter();
	album.x -= 412;
	album.y -= 128;
	album.scale.set(0.175, 0.175);
	
	playall = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/silhouettes/playall"));
	playall.scale.set(0.33, 0.33);
	playall.x += 96;
	playall.y -= 116;
	add(playall);
	
	play = new FlxText(FlxG.camera.width - 456, FlxG.camera.height - 672);
	play.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "left", FlxTextBorderStyle.SHADOW, 0xFF000000);
	play.text = "PLAY ALL";
	add(play);
	
    for (id=>i in data) {
        var sprite = new FlxSprite(0, 300).loadGraphic(Paths.image("menus/freeplay/cassettes/placeholder"));
		if (Assets.exists(Paths.image("menus/freeplay/cassettes/" + i[0])))
			sprite.loadGraphic(Paths.image("menus/freeplay/cassettes/" + i[0]));
		
        sprite.ID = id;
        sprite.scale.set(0.4, 0.4);
        vinylGroup.add(sprite);
    }
    add(vinylGroup);
	FlxG.sound.music.stop();
	
	vinylNotVinylAssFucker = new FlxCamera();
	vinylNotVinylAssFucker.bgColor = 0;
	FlxG.cameras.add(vinylNotVinylAssFucker, false);
	
	textCam = new FlxCamera();
	textCam.bgColor = 0;
	FlxG.cameras.add(textCam, false);
	
	album.cameras = playall.cameras = play.cameras = vinylGroup.cameras = [vinylNotVinylAssFucker];
	
    for (a in 0...2) {
        arrows.push(new FunkinSprite(0, 525));
		arrows[a].scale.set(0.25, 0.25);
        arrows[a].frames = Paths.getSparrowAtlas("menus/freeplay/selectArrows");
        for(z in ["hit", "idle"]) {
			arrows[a].animation.addByPrefix(z, z + ["Left", "Right"][a], 4, false);
			//trace(z + ":" + z + ["Left", "Right"][a]);
		}
        arrows[a].animation.play("idle");
        add(arrows[a]).antialiasing = Options.antialiasing;
		arrows[a].y -= 128;
		arrows[a].x = (a + 1) * 128 + a * 408;
		arrows[a].cameras = [vinylNotVinylAssFucker];
    }
	
	change(0);
	add(songLBgs);
	
	scorText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "right", FlxTextBorderStyle.SHADOW, 0xFF000000);
	scorText.text = "score: 2763";
	scorText.shadowOffset.set(2, 2);
	add(scorText);
	
	changements(0);
}

function update(elapsed) {
	timer += elapsed;
    if (controls.LEFT_P) change(-1);
    if (controls.RIGHT_P) change(1);
	
	if (controls.UP_P) changements(-1);
	if (controls.DOWN_P) changements(1);
	
	if (controls.BACK)
		FlxG.switchState(new ModState("BNDMenu"));
		
	if (controls.ACCEPT)
	{
		PlayState.loadSong(songser[subCurSelected].name, "hard");
		FlxG.switchState(new PlayState());
	}
	
    for (i in vinylGroup.members) {
        i.x = lerp(i.x, -460 * (curSelected - i.ID), 0.2);
    }
	
	arrows[0].angle = Math.sin(timer * 3) * 5;
	arrows[1].angle = Math.sin(timer * 3) * -5;
	
	for (i in 0...songL.length)
	{
		songL[i].x = 640+ i * 128;
		songL[i].y = 160 + i * 128;
	}
	
	textCam.scroll.y = CoolUtil.fpsLerp(textCam.scroll.y, subCurSelected * 128, 0.2);
	textCam.scroll.x = CoolUtil.fpsLerp(textCam.scroll.x, subCurSelected * 128, 0.2); 
}

function changements(a) {
	subCurSelected = FlxMath.wrap(subCurSelected + a, 0, subCurSelectedLimit);
	if (changements != 0)
		CoolUtil.playMenuSFX(0);
	
	for (i in 0...songL.length)
	{
		songL[i].alpha = 0.5;
		songL[subCurSelected].alpha = 1;
	}
	
	scorText.text = "Score: "+FunkinSave.getSongHighscore(songser[subCurSelected].name, "normal").score;
	var ver = songser[subCurSelected].album;
	if (ver == null) ver = 2;
	if (data[curSelected][0] == "Legacy") ver = 1;
	
	album.loadGraphic(Paths.image("menus/freeplay/albums/vol"+ver));
}

function change(a) {
    curSelected = FlxMath.wrap(curSelected + a, 0, vinylGroup.length - 1);
	moveTimer.cancel();
	
	if (!appear)
	{
		appear = true;
		FlxG.sound.play(Paths.sound("freeplay/cassetteAppear"));
	}

	songser = [];
	for(s in songst[curSelected])
		songser.push(Chart.loadChartMeta(s, "normal", true));

	while(songL.length > songst[curSelected].length) remove(songL.pop());
	songLBgs.maxSize = songst[curSelected].length;

	for(s in songst[curSelected])
		songser.push(Chart.loadChartMeta(s, "normal", true));
	
	for (i in vinylGroup.members) {
		var relSel = Math.abs(curSelected - i.ID);
		var targetNumber = curSelected == i.ID ? 190 : 300;
		FlxTween.globalManager.cancelTweensOf(i);
		//trace(relSel);
		FlxTween.tween(i, {y: targetNumber + relSel * 50}, 0.4, {ease: FlxEase.quartOut});
	}
		
	if (a == 0)
	{
		appear = false;
		for (i in vinylGroup.members)
		{
			FlxTween.globalManager.completeTweensOf(i);
			new FlxTimer().start(0.01, ()->{i.y += 128;});
			i.x = -460 * (curSelected - i.ID);
		}
	}
	else
	{
		trace("boi");
		//arrows[FlxMath.bound(a, 0, 1)].y += 100;
		arrows[FlxMath.bound(a, 0, 1)].animation.play("hit");
		FlxTween.globalManager.cancelTweensOf(arrows[FlxMath.bound(a, 0, 1)]);
		arrows[FlxMath.bound(a, 0, 1)].scale.set(0.1, 0.2);
		FlxTween.tween(arrows[FlxMath.bound(a, 0, 1)], {"scale.x": 0.25, "scale.y": 0.25}, 0.5, {ease: FlxEase.circOut});
		
		FlxG.sound.play(Paths.sound("freeplay/cassetteScroll"));
		moveTimer = new FlxTimer().start(0.7, ()->{
			appear = false;
			FlxG.sound.play(Paths.sound("freeplay/cassetteDisappear"));
			for (i in vinylGroup.members)
				FlxTween.tween(i, {y: i.y + 128}, 0.5, {ease: FlxEase.quartOut});
		});	
	}
	
	var offset = 128;
	for (i in 0...songst[curSelected].length)
	{
		trace(songLBgs.members);
		var kys = data[curSelected][0];
		if (!Assets.exists(Paths.image("menus/freeplay/silhouettes/"+kys)))
			kys = "placeholder";
		//if (Assets.exists(Paths.image("menus/freeplay/silhouettes/"+songser[i].displayName.toLowerCase())))
		//	kys = songser[i].displayName.toLowerCase();

		if (songL[i] != null) {
			songL[i].text = songser[i].displayName;
			songLBgs.members[i].loadGraphic(Paths.image("menus/freeplay/silhouettes/"+kys));
			songLBgs.members[i].updateHitbox();
			songLBgs.members[i].origin.set(songLBgs.members[i].width/2, songLBgs.members[i].height);	
			songLBgs.members[i].scrollFactor.set(0, 1);
		} else {
			var bg = new FlxSprite().loadGraphic(Paths.image("menus/freeplay/silhouettes/"+kys));			
			songLBgs.add(bg);

			var text = new Alphabet(0, 0, 0, true);
			text.text = songser[i].displayName;
			text.color = FlxColor.WHITE;
			songL.push(text);
			add(text);
			text.screenCenter(0x01);
			text.y = offset + 30;
			text.cameras = [textCam];

			bg.scale.set(0.33, 0.33);
			bg.updateHitbox();
			bg.origin.set(bg.width/2, bg.height);
			bg.x = FlxG.width - 48;
			bg.y = 70 + offset;		
			bg.scrollFactor.set(0, 1);
			bg.cameras = [textCam];
		}

		offset += songL[i].height;
	}
	
	subCurSelected = 0;
	subCurSelectedLimit = songst[curSelected].length - 1;
	play.text = data[curSelected][1];
	changements(0);
}