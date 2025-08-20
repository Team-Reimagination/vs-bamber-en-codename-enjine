import flixel.text.FlxTextBorderStyle;
var allStrums = [];
var allStrumsX = [];
var middscrolldoenotexist:Bool = false;

function postCreate() {
    if (!middscrolldoenotexist) {for (i in cpuStrums.members) {allStrums.push(i); allStrumsX.push(i.x);} }
    for (i in playerStrums.members) {allStrums.push(i); allStrumsX.push(i.x);}
}
function update(elapsed:Float) {
    var i = 0;
    for (strum in allStrums) {
        strum.x = FlxMath.lerp(strum.x, 
            (PlayState.difficulty.toLowerCase() == 'normal') ? allStrumsX[i] - ((Math.sin(Conductor.songPosition/1000) * 1.5)) * 125 * ((strum.isCpu && !middscrolldoenotexist) || (i < 2 && middscrolldoenotexist) ? -1 : 1) - ((Math.sin(Conductor.songPosition/1000) * 100 * (i % 2 == 0 ? 1 : -1))) : allStrumsX[i],
            0.5);
        i++;
    }
}

public function creditSetup() {
	songBG.destroy();
	songTitle.destroy();

		for (catText in songTexts) {
		for (i in 0...catText.length) {
			if (i == 0) {
				catText[i].angle = 0;
				catText[i].scale.x = 1;
				catText[i].updateHitbox();
				catText[i].y = 200 + 50 * songTexts.indexOf(catText);
				catText[i].x = 1;
				catText[0].text += " by";
				catText[0].size = 30;
				catText[0].borderSize = 2;
				catText[0].alpha = 0;
			} else { 
				catText[0].text += " " + catText[i].text + (i < catText.length - 2 ? '   ,' : i == catText.length - 2 ? '    &' : ( ['Itchgø'].contains(catText[i].text) ? ' ' : '    '));
			}

			if (i == catText.length - 1) {
				var creditHead = new FlxSprite(0, catText[0].y);
				creditHead.frames = Paths.getSparrowAtlas('HUD/cheater/cheatingHeading');
				creditHead.animation.addByPrefix('cheating', 'Cheating', 24, true, [false, false]);
				creditHead.animation.play('cheating');
				creditHead.cameras = [camHUD];
				creditHead.scale.x = 1 / creditHead.width * catText[0].width;
				creditHead.updateHitbox();
				creditHead.alpha = 0;
				insert(members.indexOf(songBG), creditHead);
				creditHeaders.push(creditHead);

				var parts = catText[0].text.split("   ");
				var xPos = 0;

				creditHead.x -= creditHead.width;
				catText[0].x -= creditHead.width;

				for (catIcon in songIcons[songTexts.indexOf(catText)]) {
					catIcon.setGraphicSize(30); catIcon.updateHitbox();
					catIcon.y = catText[0].y + 10;
					catIcon.angle = 0;
					catIcon.alpha = 0;

					var partText = new FlxText(0, 0, 0, parts[songIcons[songTexts.indexOf(catText)].indexOf(catIcon)]);
					partText.setFormat(scoreTxt.font, 30, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
            		partText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);

					xPos += partText.width + 10 + (songIcons[songTexts.indexOf(catText)].indexOf(catIcon) > 0 ? 22 : 0);
					catIcon.x = xPos;

					catIcon.x -= creditHead.width;
				}
			}
		}

		catText = [catText[0]];
	}

}

var creditHeaders = [];

public function creditBehavior() {
	for (i in 0...creditHeaders.length) {
		creditHeaders[i].alpha = 1;
		songTexts[i][0].alpha = 1;

		creditTweens.push(FlxTween.tween(creditHeaders[i], {x: 0}, 0.5, {ease: FlxEase.backOut}));

		creditTweens.push(FlxTween.tween(songTexts[i][0], {x: 1}, 0.5, {ease: FlxEase.backOut}));

		for (a in songIcons[i]) {
			a.alpha = 1;
			creditTweens.push(FlxTween.tween(a, {x: a.x + creditHeaders[i].width}, 0.5, {ease: FlxEase.backOut}));
		}
	}
	return 3.5;
}

public function creditEnding() {
	for (i in 0...creditHeaders.length) {
		creditTweens.push(FlxTween.tween(creditHeaders[i], {x: 0 - creditHeaders[i].width}, 1, {ease: FlxEase.backIn}));

		creditTweens.push(FlxTween.tween(songTexts[i][0], {x: 0 - creditHeaders[i].width}, 1, {ease: FlxEase.backIn, onComplete: function(tween) {
			creditsDestroy();
			creditHeaders[i].destroy();
		}}));

		for (a in songIcons[i]) {
			creditTweens.push(FlxTween.tween(a, {x: a.x - creditHeaders[i].width}, 1, {ease: FlxEase.backIn}));
		}
	}
	creditTweens=creditTweens;
}