function onPlayAnim(e) {
    if (!PlayState.canDadDie && this.lastAnimContext == 'SING') PlayState.instance.health -= (PlayState.instance.health > 0.02 ? 0.02 : 0);
}

function update(elasped) {
    this.y += Math.sin(Conductor.songPosition/1000) * 3.5;
}