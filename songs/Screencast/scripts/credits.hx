
var creditHeaders = [];

function postCreate() {
	for(i in [scoreTxt,missesTxt,accuracyTxt])
	i.font=Paths.font('goodbyeDespair.ttf');
}

public function creditSetup() {
	songBG.destroy();
	songTitle.destroy();
	
	for (i in songIcons) {
		for (icon in i) {
			icon.destroy();
		}
	}
	songIcons=[];

	songTexts[0][0].angle = songTexts[0][1].angle = 0;

	for (catText in songTexts) {
		if (songTexts.indexOf(catText) != 0) songTexts[0][0].text += songTexts[songTexts.indexOf(catText)][0].text;

		for (i in 0...catText.length) {
			if (i == 0) {
				songTexts[0][0].text += " by";
			} else {
				songTexts[0][0].text += " " + catText[i].text + (i < catText.length - 2 ? ',' : i == catText.length - 2 ? ' &' : ' ');
			}
		}
		songTexts[0][0].text += "\n";
	}
	songTexts[0][1].text = songTexts[0][0].text;
	songTexts[0][1].scale.x = 1;
	songTexts[0][1].updateHitbox();

	songTexts[0][0].text = 'SCREENCAST';
	songTexts[0][0].size = 40;
	songTexts[0][1].size = 20;
	songTexts[0][0].font = Paths.font('Coco-Sharp-Heavy-Italic-trial.ttf');

	songTexts[0][0].y = 190;
	songTexts[0][1].y = songTexts[0][0].y + songTexts[0][0].height + 15;

	songTexts[0][0].x = songTexts[0][1].x = 20;

	songTexts = [songTexts[0]];

	for (i in 0...songTexts[0].length) {
		var creditHead = new FlxSprite(0, songTexts[0][i].y - 10).makeGraphic(songTexts[0][i].width + 80,songTexts[0][i].height + 15,0x88000000);
		creditHead.cameras = [camHUD];
		insert(members.indexOf(songTexts[0][i]), creditHead);

		creditHead.x -= creditHead.width;
		songTexts[0][i].x -= creditHead.width;

		creditHeaders.push(creditHead);
	}

	songTexts[0][1].y += 15;

	songTexts=songTexts;
}

public function creditBehavior() {
	for (i in 0...songTexts[0].length) {
		creditTweens.push(FlxTween.tween(creditHeaders[i], {x: 0}, 1, {ease: FlxEase.quartOut}));
		creditTweens.push(FlxTween.tween(songTexts[0][i], {x: songTexts[0][i].x + creditHeaders[i].width}, 1, {ease: FlxEase.quartOut}));
	}
	creditTweens=creditTweens;
	return 4;
}

public function creditEnding() {
	for (i in 0...songTexts[0].length) {
		creditTweens.push(FlxTween.tween(creditHeaders[i], {x: creditHeaders[i].x - creditHeaders[i].width}, 1, {ease: FlxEase.quartIn}));
		creditTweens.push(FlxTween.tween(songTexts[0][i], {x: songTexts[0][i].x - creditHeaders[i].width}, 1, {ease: FlxEase.quartIn, onComplete: function(tween) {
			creditsDestroy();
			creditHeaders[i].destroy();
		}}));
	}
	creditTweens=creditTweens;
}