import flixel.util.FlxGradient;
import StringTools;
var gradientSprite;
//GameOverSubstate.script = 'data/scripts/gameovers/meta';
//Thought having this script would be better then having charater scripts
function onGameOver(e) {
    if(StringTools.startsWith(curSong, "Judgement")){
        trace("Chris_pratt.");
        e.gameOverSong = "death/ut";
        GameOverSubstate.script = 'data/scripts/gameovers/judgemental-failure';
    }
    switch(curSong){
        case"Generations"|"Yeld":
        e.lossSFX="death/gen-bf-dead";
        e.gameOverSong = "death/funkin";
        e.retrySFX = 'death/ends/funkin-end';
        FlxG.camera.zoom = 0.8;
        FlxG.camera.bgColor = FlxColor.BLACK;
    }
}