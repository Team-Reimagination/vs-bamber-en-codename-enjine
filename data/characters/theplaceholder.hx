if (PlayState.instance != null) {
    function update(elapsed) {
        if (animation.curAnim != null && animation.curAnim.name == 'idle' && animation.curAnim.finished) playAnim('idleLOOP', true, 'DANCE');
    }
}