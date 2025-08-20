var strums = [];

function create(){
	very = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
	very.scale.set(1280 * 3, 720 * 3);
	very.updateHitbox();
	very.screenCenter();
	very.scrollFactor.set();
	very.visible = false;
	add(very);
	dead = new FlxSprite(boyfriend.x + 90, boyfriend.y + 30).loadGraphic(Paths.image('stages/romania outskirts night/hesdead'));
	dead.antialiasing = true;
	dead.visible = false;
	add(dead);
	camZooming = true;
	for(a in [pixel = new CustomShader("JPG"), colorizer = new CustomShader("colorizer")]) camHUD.addShader(a);
	camGame.addShader(pixel);
	colorizer.data.colors.value = [0.064,0.127,0.392];
	pixel.pixel_size = 10.0;
	defaultCamZoom += 0.5;
}

function postCreate() {
	iconP2.setIcon("ronnieandboris");
	for(i in 0...strumLines.members[3].members.length) {
        var strum = strumLines.members[3].members[i];
        strums.push(strum);
		strum.visible = false;
    }
	strumLines.members[3].characters[0].x -= 200;
	strumLines.members[3].characters[0].y += 100;
}
function beatHit(curBeat:Int){
	if(curBeat % 4 == 0)
		camGame.zoom += 0.0125;
	if (curBeat % 2 == 0 && !(curBeat % 4 == 0) && curBeat >= 16 && curBeat <= 160) {
		FlxG.camera.zoom += 0.05;
		camHUD.zoom += 0.025;
	}
	if (curBeat >= 96)
		camHUD.zoom += 0.0625;
	switch(curBeat){
		case 31:
			FlxTween.num(10.0, 0.1, 1, {ease: FlxEase.quartInOut}, function(b) pixel.pixel_size = b);
		case 32:
			for(a in [camGame, camHUD]) a.removeShader(pixel);
			camHUD.flash(FlxColor.WHITE, 0.5);
	}
}

function death(){
	very.visible = !very.visible;
	dead.visible = !dead.visible;
}
//A_lot_of_this_needs_tweaks...
function giveBirthToThe3rd() {
	//offsets_the_notes_and_strums_if_i_scale_them_for_some_reason.
	for(e in playerStrums.members)
    FlxTween.tween(e, {x: (FlxG.width - ((FlxG.width - e.x - 65) * 0.87)), "scale.x": e.scale.x * 0.9,"scale.y": e.scale.y * 0.9}, 0.5, {ease: FlxEase.backOut});

    for(e in cpuStrums.members)
	FlxTween.tween(e, {x: (e.x * 0.87) - 65, "scale.x": e.scale.x * 0.9,"scale.y": e.scale.y * 0.9}, 0.5, {ease: FlxEase.backOut});

	for (i in 0...strums.length){
		strums[i].visible = true;
	FlxTween.tween(strums[i], {x: ((FlxG.width / 2) + ((i - 2) * (Note.swagWidth * 0.87))), "scale.x": strums[i].scale.x * 0.9,"scale.y": strums[i].scale.y * 0.9}, 1.0, {ease: FlxEase.elasticOut});
	}
}