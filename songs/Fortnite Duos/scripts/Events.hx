importScript("data/scripts/secondCharHandler");

var pixel = new CustomShader("JPG");

var pixelSize:Float = 22;

function postCreate(){
	FlxG.camera.addShader(pixel);

    FlxTween.num(pixelSize, 0.1, 15, {ease: FlxEase.quartInOut}, function(v) {pixelSize = v;});
    for(num => a in [iconP1, iconP2]) a.setIcon(["bf-fortniteduos", "ronnieandboris"][num]);
}

function update(elapsed:Float)  pixel.pixel_size = pixelSize;
function onPostStrumCreation(e){
    PlayState.opponentMode ? 
    if(e.player == 2){
        e.strum.camera = camGame;
        e.strum.scrollFactor.x = e.strum.scrollFactor.y = 1;
    }
    : 
    if(e.player == 0){
        e.strum.camera = camGame;
        e.strum.scrollFactor.x = e.strum.scrollFactor.y = 1;
    };
}
PlayState.opponentMode ?
function onCameraMove(e)
    if(curCameraTarget == 2 || curCameraTarget == 3)
        for(a in strumLines.members[2]){
            FlxTween.tween(a, {
                x: strumLines.members[curCameraTarget].characters[0].x + ((a.width) * a.ID) + (curCameraTarget == 2 ? 70 : 750),
                y: strumLines.members[curCameraTarget].characters[0].y - a.height - (curCameraTarget == 2 ? -50 : -200)
            }, 0.5);
        }
        :
function onCameraMove(e)
    if(curCameraTarget == 0 || curCameraTarget == 1)
        for(a in strumLines.members[0]){
            FlxTween.tween(a, {
                x: strumLines.members[curCameraTarget].characters[0].x + ((a.width) * a.ID) + (curCameraTarget == 0 ? 1 : -40),
                y: strumLines.members[curCameraTarget].characters[0].y - a.height - (curCameraTarget == 0 ? 225 : 0)
            }, 0.5);
        };