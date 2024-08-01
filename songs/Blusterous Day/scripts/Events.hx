function create(){
	camZooming = true;
	for(a in [pixel = new CustomShader("JPG"), colorizer = new CustomShader("colorizer")]) camHUD.addShader(a);
	camGame.addShader(pixel);
	colorizer.data.colors.value = [0.064,0.127,0.392];
	pixel.data.pixel_size.value = [10.0];
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
			FlxTween.num(10.0, 0.1, 1, {ease: FlxEase.quartInOut}, function(b) pixel.data.pixel_size.value = [b]);
		case 32:
			for(a in [camGame, camHUD]) a.removeShader(pixel);
			camHUD.flash(FlxColor.WHITE, 0.5);
	}
}