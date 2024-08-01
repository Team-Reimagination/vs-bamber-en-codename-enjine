importScript("data/scripts/secondCharHandler");

function postCreate(){
    
strumLines.members[2].cpu = true;
    for(num => a in [iconP1, iconP2])
        a.setIcon(["bf-fortniteduos", "ronnieandboris"][num]);
}

function onPostStrumCreation(e){
    if(e.player == 0){
        e.strum.camera = camGame;
        e.strum.scrollFactor.x = e.strum.scrollFactor.y = 1;
    }
}

function onCameraMove(e)
    if(curCameraTarget == 0 || curCameraTarget == 1)
        for(a in strumLines.members[0]){
            FlxTween.tween(a, {
                x: strumLines.members[curCameraTarget].characters[0].x + ((a.width) * a.ID) + (curCameraTarget == 0 ? 175 : -175),
                y: strumLines.members[curCameraTarget].characters[0].y - a.height - (curCameraTarget == 0 ? 225 : 0)
            }, 0.5);
        }
