this.danceInterval = 2;

function onPlayAnim(e) {
    if (!PlayState.canDadDie && this.lastAnimContext == 'SING') PlayState.instance.health -= (PlayState.instance.health > 0.02 ? 0.02 : 0);
    if (this.lastAnimContext == 'DANCE' && this.animation.curAnim != null) this.animation.curAnim.frameRate = ((PlayState.startTimer != null && !PlayState.startTimer.finished) ? PlayState.startTimer.time * 120 * 2 : Conductor.bpm) / 48 * 5;
}

function update(elasped) {
    this.y += Math.sin(Conductor.songPosition/1000) * 3.5;
}