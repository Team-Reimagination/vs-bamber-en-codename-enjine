public static var bop = false;

function beatHit(curBeat:Int) {
    if(curBeat == -4) bop = false;
    camZoomingInterval = bop ? 1 : 4;
    if(bop){
        for(a in [iconP1, iconP2]){
			a.angle = curBeat % 2 == 0 ? 25 : -25;
			FlxTween.cancelTweensOf(a);
			FlxTween.tween(a, {angle: 0}, 0.5, {ease: FlxEase.circOut});
        }
        if(PlayState.difficulty.toLowerCase() == "hard")
            for(b in strumLines)
                for(c in b){
                    c.angle = curBeat % 2 == 0 ? (c.strumID % 2 == 0 ? 5 : -5) : (c.strumID % 2 == 0 ? -5 : 5);
                    FlxTween.cancelTweensOf(c);
                    FlxTween.tween(c, {angle: 0}, 0.5, {ease: FlxEase.circOut});
                }
    }
}