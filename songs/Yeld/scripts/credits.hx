public function creditSetup() {
	for (catIcons in songIcons) {
		for (icon in catIcons) {
			icon.destroy();
		}
	}
	songIcons = [];
	songBG.destroy();
	songTitle.destroy();

	for (catText in songTexts) {
		for (i in 0...catText.length) {
			if (i == 0) {
				catText[i].angle = 0;
				catText[i].scale.x = 1;
				catText[i].updateHitbox();
				catText[i].y = 100 + 100 * songTexts.indexOf(catText);
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
	for (catText in songTexts) {
		creditTweens.push(FlxTween.tween(catText[0], {alpha: 1}, 1, {ease: FlxEase.quartOut}));
	}

	return 4;
}

public function creditEnding() {
	for (catText in songTexts) {
		creditTweens.push(FlxTween.tween(catText[0], {alpha: 0}, 1, {ease: FlxEase.quartIn, onComplete: function(tween) {
			creditsDestroy();
		}}));
	}
}