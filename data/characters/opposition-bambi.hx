danceInterval = 2;

if (PlayState.instance != null) {
    function onPlayAnim(e) {
        if (!PlayState.canDadDie && lastAnimContext == 'SING') PlayState.instance.health -= (PlayState.instance.health > 0.02 ? 0.02 : 0);
        if (lastAnimContext == 'DANCE' && animation.curAnim != null) animation.curAnim.frameRate = ((PlayState.startTimer != null && !PlayState.startTimer.finished) ? PlayState.startTimer.time * 120 * 2 : Conductor.bpm) / 48 * 5;
    }

    function update(elasped) {
        y += Math.sin(Conductor.songPosition/1000) * 3.5;
    }
}