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
	"bamber-sans-old" => 0xFF00A1FF
];

var array = [];

function postCreate() {
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
}
