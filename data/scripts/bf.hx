import flixel.util.FlxGradient;
var gradientSprite;
function onPostGameOver(e) {
    switch(PlayState.instance.SONG.meta.name){
        case"Memeing":
            FlxG.camera.zoom = 0.8;
            e.lossSFX="death/bf-dead-cheater";
            e.gameOverSong = "death/cheater";
            e.retrySFX = 'death/ends/cheater-end';
        default:
            e.lossSFX="death/bf-dead";
            e.gameOverSong = "death/default";
            e.retrySFX = 'death/ends/default-end';

            gradientSprite = FlxGradient.createGradientFlxSprite(FlxG.width * 2, 900, [0x00000000, PlayState.instance.boyfriend.iconColor], 1, 90, true);
            gradientSprite.scrollFactor.set();
	        gradientSprite.screenCenter();
            gradientSprite.y += 100;
            PlayState.instance.insert(99,gradientSprite);
            //insert(members.indexOf(bf), gradientSprite);
    }
}