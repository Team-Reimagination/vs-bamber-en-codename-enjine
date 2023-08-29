if(["swindled", "corn n roll", "astray", "facsimile"].contains(curSong)){
    function postCreate(){
        if(["swindled", "corn n roll", "astray", "facsimile"].contains(curSong)){
            iconP2.visible = false;
            custIcon1 = new FlxSprite();
            custIcon1.frames = Paths.getSparrowAtlas("icons/animated/" + curSong + "-dad");
            custIcon1.antialiasing = true;
            for(a in ['losing', 'normal']){
                custIcon1.animation.addByPrefix(a, a, 24, true);
            }
            custIcon1.cameras = [camHUD];
            add(custIcon1);
        }
        if(["corn n roll"].contains(curSong)){
            iconP1.visible = false;
            custIcon2 = new FlxSprite();
            custIcon2.frames = Paths.getSparrowAtlas("icons/animated/" + curSong + "-bf");
            custIcon2.antialiasing = true;
            for(a in ['losing', 'normal']){
                custIcon2.animation.addByPrefix(a, a, 24, true);
            }
            custIcon2.cameras = [camHUD];
            add(custIcon2);
            custIcon2.flipX = true;
        }
    }
    function update(){
        if(["swindled", "corn n roll", "astray", "facsimile"].contains(curSong)){
            custIcon1.x = iconP2.x;
            custIcon1.y = iconP2.y;
        }
        if(["corn n roll"].contains(curSong)){
            custIcon2.x = iconP1.x;
            custIcon2.y = iconP1.y;}
        if(health <= 1.5){custIcon1.animation.play('normal');} else {custIcon1.animation.play('losing');}
        if(health <= 0.5){custIcon2.animation.play('losing');} else {custIcon2.animation.play('normal');}
    }
}