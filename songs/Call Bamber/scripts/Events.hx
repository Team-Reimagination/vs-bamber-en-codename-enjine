function postCreate(){
    healthBar.flipX = iconP1.flipX = iconP2.flipX = true;
    //disclaimer = new FlxSprite().loadGraphic(Paths.images("stages/Call Bamber/playing as bamber " + ))
}

function postUpdate(elapsed){	
	var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 100, 0, 1, 0);

	iconP1.x = center - (iconP1.width - 26);
	iconP2.x = center - 26;
}