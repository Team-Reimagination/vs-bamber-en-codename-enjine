var songNoteSkins = [
	// For player AND opponent skins
	"trade" => "game/ui/trade/NOTE_assets",
	"deathbattle" => "game/ui/deathbattle/NOTE_assets"
];

var charNoteSkins = [
	// For individual character skins
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
	"bf" => 0xFF00CCFF "bamber" => 0xFF71C419 "davey" => 0xFF4087CE "davey-shred" => 0xFF4087CE "ronnie" => 0xFFFFF600 "swindled" => 0xFFEE0000
	"bambi" => 0xFF25BF37 "trade-bamber" => 0xFF71C419 "trade-davey" => 0xFF4087CE "null" => 0xFFB9CEB9
];

var array = [];

function postCreate() {
	player.cpu = true;
	if (songFonts[curSong] != null) {
		FlxG.state.forEachOfType(FlxText, text -> text.font = Paths.font(songFonts[curSong]));
	}
	if (barColors[dad.getIcon().toLowerCase()] != null) {
		p1color = barColors[dad.getIcon().toLowerCase()];
	}
	if (barColors[boyfriend.getIcon().toLowerCase()] != null) {
		p2color = barColors[boyfriend.getIcon().toLowerCase()];
	}
	healthBar.createFilledBar(p1color, p2color);
	FlxG.state.forEachOfType(FlxText, text -> text.color = p1color);
	if (curSong == "coop") {
		newIcon1 = new HealthIcon("bf-coop", true);
		newIcon2 = new HealthIcon("davey-coop", false);
	}
	for (a in [newIcon1, newIcon2]) {
		add(a);
	}
}

function postUpdate() {
	newIcon1.x = iconP1.x;
	newIcon1.y = iconP1.y;
}

if (!["astray", "facsimile", "placeholder", "test footage"].contains(curSong)) {
	function postUpdate() {
		switch (strumLines.members[curCameraTarget].characters[0].getAnimName()) {
			case "singLEFT":
				camFollow.x -= 20;
			case "singDOWN":
				camFollow.y += 20;
			case "singUP":
				camFollow.y -= 20;
			case "singRIGHT":
				camFollow.x += 20;
		}
	}
}
