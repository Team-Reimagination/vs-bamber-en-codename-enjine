if (PlayState.instance != null) {
    function onPlayAnim(e) {
        if (!PlayState.canDadDie && lastAnimContext == 'SING') PlayState.instance.health -= (PlayState.instance.health > 0.02 ? 0.02 : 0);
    }

    function postUpdate(elapsed) {
        y += Math.sin(Conductor.songPosition/1000) * 3.5;
    }
}