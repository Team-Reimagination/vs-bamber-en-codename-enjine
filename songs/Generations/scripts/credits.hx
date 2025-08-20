public function creditSetup() {
	for (catIcons in songIcons) {
		for (icon in catIcons) {
			icon.destroy();
		}
	}
	songIcons = [];
	songTitle.angle = 0;
	songBG.destroy();

	songTitle.scale.set(0.3, 0.3);
	songTitle.updateHitbox();
	songTitle.x = 80;
	songTitle.y = 20;
	songTitle.alpha = 0;

	for (catText in songTexts) {
		for (i in 0...catText.length) {
			if (i == 0) {
				catText[i].angle = 0;
				catText[i].scale.x = 1;
				catText[i].updateHitbox();
				catText[i].y = songTitle.y + songTitle.height + 20 + 100 * songTexts.indexOf(catText);
				catText[i].x = 100;
				catText[0].text += ":";
				catText[0].size = 30;
				catText[0].borderSize = 4;
				catText[0].alpha = 0;
			} else { 
				catText[0].text += " " + catText[i].text + (i < catText.length - 1 ? ',' : '');
			}
		}

		catText = [catText[0]];
	}
}

public function creditBehavior() {
	creditTweens.push(FlxTween.tween(songTitle, {alpha: 1}, 1, {ease: FlxEase.quartOut}));

	for (catText in songTexts) {
		creditTweens.push(FlxTween.tween(catText[0], {alpha: 1}, 1, {ease: FlxEase.quartOut}));
	}
	creditTweens=creditTweens;

	return 4;
}

function creditEnding() {
	creditTweens.push(FlxTween.tween(songTitle, {alpha: 0}, 1, {ease: FlxEase.quartIn}));

	for (catText in songTexts) {
		creditTweens.push(FlxTween.tween(catText[0], {alpha: 0}, 1, {ease: FlxEase.quartIn, onComplete: function(tween) {
			creditsDestroy();
		}}));
	}
	creditTweens=creditTweens;
}

function onNoteHit(e){
	e.ratingPrefix = "game/score/genstage/";
	switch(e.rating){
		case"sick": e.rating = "keep yourself safe";
		default: e.rating = "kill yourself";
	}
}