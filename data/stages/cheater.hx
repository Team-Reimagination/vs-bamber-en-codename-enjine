function postCreate(){
    bg.shader = shader = new CustomShader("cheatingshader");
    shader.uSpeed = 2;
	shader.uFrequency = 5;
	shader.uWaveAmplitude = 0.1;
}

function postUpdate(elapsed){
    shader.data.uTime.value = [Conductor.songPosition/1000];
    strumLines.members[0].characters[0].y += Math.sin(Conductor.songPosition/1000) * 3.5;
}

function onCameraMove(e){
    defaultCamZoom = curCameraTarget == 0 ? 0.2 : 0.8;
    strumLines.members[0].characters[0].alpha = (-5 / 3) * defaultCamZoom + (4 / 3);
}