var strums = [];
//Rushing the fuck out of this , this healthbar code is god-awful.
var heelthbar:FlxSprite;

function create() {
	heelthbar = new FlxSprite().loadGraphic(Paths.image('game/healthbars/bfdifield'));
    heelthbar.screenCenter(FlxAxes.X);
    heelthbar.y = FlxG.height * 0.89;
    heelthbar.scale.set(1,.85);
}

function postCreate() {
	iconP2.setIcon("bfdi-bnd");
	for(i in 0...strumLines.members[3].members.length) {
        var strum = strumLines.members[3].members[i];
        strums.push(strum);
		strum.visible = false;
    }
	strumLines.members[3].characters[0].x -= 240;
	strumLines.members[3].characters[0].y += 100;
	insert(29,heelthbar);
	heelthbar.camera = camHUD;
	healthBarBG.alpha = healthBar.alpha=1;
}
//A_lot_of_this_needs_tweaks...
function giveBirthToThe3rd() {
	for(e in playerStrums.members)
    FlxTween.tween(e, {x: (FlxG.width - ((FlxG.width - e.x - 65) * 0.87))}, 0.5, {ease: FlxEase.backOut});

	//I_didn't_scale_them_down_cuz_it_offsets_the_notes_and_strums_SOMEHOW

    for(e in cpuStrums.members)
    FlxTween.tween(e, {x: (e.x * 0.87) - 65}, 0.5, {ease: FlxEase.backOut});

	for (i in 0...strums.length){
		strums[i].visible = true;
	FlxTween.tween(strums[i], {x: ((FlxG.width / 2) + ((i - 2) * (Note.swagWidth * 0.87)))}, 1.0, {ease: FlxEase.elasticOut});
	}
}