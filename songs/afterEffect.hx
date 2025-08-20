/*This is laggy as shit on low end devices for some reason.
Broken , don't want to waste an extra day fixing it.- Earframe.*/
var songDisable = ['generations', 'Astray', 'Facsimile', 'Placeholder', 'test footage', 'yield v1', 'cornaholic v1', 'harvest v1', 'yield seezee remix', 'cornaholic erect remix v1', 'harvest chill remix'];

var ghosts = [];
var ghostTweens = [];

var num:Int;

var notesForStrum= [
    "Coop" => [1,2,4],
    "Deathbattle" => [2],
    "Corn N Roll" => [2],
    "Fortnite Duos" => [1],
    "Blusterous Day" => [1]
];
var girlfriendStrums= [
	"Deathbattle" => [3],
	"Fortnite Duos" => [3]
];

if (!songDisable.contains(curSong)) {
	function onNoteHit(e) {
		if(e.note.isSustainNote) return;
		if(e.noteType!=null){
		if(e.noteType == "opponent2"||e.noteType == "player2"){
			createGhost(strumLines.members[e.noteType == "opponent2" ? 1 : 3].characters[0],e.note,e.strumLine);
			num = e.noteType == "opponent2" ? 1 : 3;
		}
		}else {
			num = e.player ? 1 : 0;
			createGhost(e.character,e.note,num);
		}
		trace(num);
	}

	function createGhost(char:Character,notee,NUMBER) {
		for (i in strumLines.members[NUMBER].notes)
		if (i.mustPress == notee.mustPress && notee.strumTime == i.strumTime && notee.noteData != i.noteData) {
			var ghost:Character = new Character(0,0, char.curCharacter, char.isPlayer);
			ghost.scrollFactor.set(char.scrollFactor.x, char.scrollFactor.y);
			ghost.updateHitbox();
			ghost.setPosition(char.x, char.y);
			ghost.alpha = 0.8;
			ghost.color = char.color;
			ghost.angle = char.angle;
			ghost.visible = char.visible;
			ghost.colorTransform = char.colorTransform.__clone();
			insert(members.indexOf(char), ghost);
			ghosts.push(ghost);
			ghost.playAnim(char.getAnimName());
			ghostTweens.push(FlxTween.tween(ghost, {alpha:0}, Conductor.stepCrochet/1000 * 8, {ease:FlxEase.quartOut,onComplete:function() {
				remove(ghost);
				ghost.destroy();
			}}));
		}
	}

	function onDeath() {
		for (i in ghosts) { if (i != null) {
			remove(i);
			i.destroy();
		}}
	
		ghosts = [];
		ghostTweens = [];
	}
}
