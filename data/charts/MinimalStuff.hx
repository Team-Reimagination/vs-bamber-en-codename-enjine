var songNoteSkins = [ // For player AND opponent skins
    "trade" => "game/ui/trade/NOTE_assets",
    "deathbattle" => "game/ui/deathbattle/NOTE_assets"
];
var charNoteSkins = [ // For individual character skins
    "bambi" => "game/notes/funkin"
];
var songFonts = [
	"corn n roll" => "adelon-serial-bold.ttf"
	"deathbattle" => "Impact.ttf"
	"judgement farm" => "Mars_Needs_Cunnilingus.ttf"
	"judgement farm 2" => "Mars_Needs_Cunnilingus.ttf"
	"screencast" => "goodbyeDespair.ttf"
	"astray" => "vcr_osd.ttf"
	"facsimile" => "vcr_osd.ttf"
	"placeholder" => "vcr_osd.ttf"
];
var barColors = [
    "bf" => 0xFF00CCFF
    "bamber" => 0xFF71C419
    "davey" => 0xFF4087CE
    "davey-shred" => 0xFF4087CE
    "ronnie" => 0xFFFFF600
    "swindled" => 0xFFEE0000
    "bambi" => 0xFF25BF37
    "trade-bamber" => 0xFF71C419
    "trade-davey" => 0xFF4087CE
    "null" => 0xFFB9CEB9
];
function postCreate() {
    if(songFonts[curSong] != null){
        FlxG.state.forEachOfType(FlxText, text -> text.font = Paths.font(songFonts[curSong]));
    }
    if(barColors[dad.getIcon().toLowerCase()] != null){p1color = barColors[dad.getIcon().toLowerCase()];}
    if(barColors[boyfriend.getIcon().toLowerCase()] != null){p2color = barColors[boyfriend.getIcon().toLowerCase()];}
    healthBar.createFilledBar(p1color, p2color);
    FlxG.state.forEachOfType(FlxText, text -> text.color = p1color);
}
function onPostGenerateStrums() {
    if(songNoteSkins[curSong] != null){
        for(a in [cpuStrums, playerStrums]){
            skin = songNoteSkins[curSong];
            frames = Paths.getSparrowAtlas(skin);
                for (strum in a) {
                    strum.frames = frames;
                    strum.animation.addByPrefix("static", "arrowUP");
                    strum.animation.addByPrefix("blue", "arrowDOWN");
                    strum.animation.addByPrefix("purple", "arrowLEFT");
                    strum.animation.addByPrefix("red", "arrowRIGHT");

                    strum.antialiasing = true;
                    strum.setGraphicSize(Std.int(frames.width * 0.7));
                    var animPrefix = a.strumAnimPrefix[strum.ID % a.strumAnimPrefix.length];
                    strum.animation.addByPrefix("static", "arrow" + animPrefix.toUpperCase());
                    strum.animation.addByPrefix("pressed", animPrefix + " press", 24, false);
                    strum.animation.addByPrefix("confirm", animPrefix + " confirm", 24, false);

                    strum.updateHitbox();
                    strum.playAnim("static");
                }
                for (note in a.notes) {
                    note.frames = frames;

                    switch (note.noteData % 4) {
                        case 0:
                            note.animation.addByPrefix("scroll", "purple0");
                            note.animation.addByPrefix("hold", "purple hold piece");
                            note.animation.addByPrefix("holdend", "pruple end hold");
                        case 1:
                            note.animation.addByPrefix("scroll", "blue0");
                            note.animation.addByPrefix("hold", "blue hold piece");
                            note.animation.addByPrefix("holdend", "blue hold end");
                        case 2:
                            note.animation.addByPrefix("scroll", "green0");
                            note.animation.addByPrefix("hold", "green hold piece");
                            note.animation.addByPrefix("holdend", "green hold end");
                        case 3:
                            note.animation.addByPrefix("scroll", "red0");
                            note.animation.addByPrefix("hold", "red hold piece");
                            note.animation.addByPrefix("holdend", "red hold end");
                    }
                    note.scale.set(0.7, 0.7);
                    note.antialiasing = true;
                    note.updateHitbox();
                    if (note.isSustainNote) {
                        note.animation.play("holdend");
                        note.updateHitbox();

                        if (note.nextSustain != null)
                            note.animation.play('hold');
                    } else
                        note.animation.play("scroll");
                }
        }
    }
}
if(!["astray", "facsimile", "placeholder", "test footage"].contains(curSong)){
    function postUpdate() {
        switch(strumLines.members[curCameraTarget].characters[0].getAnimName()) {
            case "singLEFT": camFollow.x -= 20;
            case "singDOWN": camFollow.y += 20;
            case "singUP": camFollow.y -= 20;
            case "singRIGHT": camFollow.x += 20;
        }
    }
}