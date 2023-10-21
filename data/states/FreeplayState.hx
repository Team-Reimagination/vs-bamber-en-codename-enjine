import flixel.FlxCamera;
import flixel.tweens.FlxTween;
var newCam = new FlxCamera(-150, 0);
var prevchar:String;
var time:Float;
function postCreate(){
    // Text rescaling
    newCam.bgColor = 0;
    for (a in [grpSongs.members, iconArray]){
        for(b in a) b.cameras = [newCam];
    }
    FlxG.cameras.add(newCam, false);
    newCam.zoom = 0.8;
    // Portraits
    add(portrait = new FlxSprite(700, -50));
    portrait.scale.set(0.7, 0.7);
    portrait.antialiasing = true;
    updatePortrait();
}
function postUpdate(elapsed){
    time += elapsed;
    FlxG.stage.window.title = "Vs Bamber And Davey V3 | Freeplay Menu | Currently Selecting: " + songs[curSelected].name;
    if(FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN){
        updatePortrait();
    }
    for (song in grpSongs.members) {
		if (song.text.toLowerCase() == "swindled" || song.text.toLowerCase() == "swindled old"){
			song.angle = FlxG.random.float(-13, 13);
			var sine = Math.sin(95 * time) * 2;
			var shake = FlxG.random.float(0, 45) * 0.1;
			song.x += ((shake * sine)) * (elapsed * 85);
			var sineY = Math.sin(125 * time) * 2;
			var shakeY = FlxG.random.float(0, 60) * 0.1;
			song.y += ((shakeY * sineY)) * (elapsed * 85);
		}
	}
    FlxG.camera.angle = grpSongs.members[curSelected].angle/5;
    newCam.angle = grpSongs.members[curSelected].angle/5;
}
function updatePortrait(){
    FlxTween.globalManager.cancelTweensOf(portrait);
    portrait.x = 700;
    if(Assets.exists(Paths.image("menus/Portraits/" + songs[curSelected].icon))){
        portrait.loadGraphic(Paths.image("menus/Portraits/" + songs[curSelected].icon));
    } else {
        portrait.loadGraphic(Paths.image("menus/Portraits/the_placeholder"));
    }
    FlxTween.tween(portrait, { x: 500 }, 1, {ease: FlxEase.elasticOut});
}