public function creditSetup() {
	songBG.alpha = 1;
	songBG.screenCenter();
	songBG.scale.set(1,0);
	remove(songBG); insert(9, songBG);

	songTitle.destroy();

	for (catText in songTexts) {
		for (i in catText) {
			i.destroy();
		}
	}

	for (catIcons in songIcons) {
		for (i in catIcons) {
			i.destroy();
		}
	}

	songIcons=[];
	songTexts=[];
}

public function creditBehavior() {
	creditTweens.push(FlxTween.tween(songBG.scale, {y: 1}, 0.5, {ease: FlxEase.backOut}));

	return 4;
}

public function creditEnding() {
	creditTweens.push(FlxTween.tween(songBG.scale, {y: 0}, 0.5, {ease: FlxEase.backIn}));
}