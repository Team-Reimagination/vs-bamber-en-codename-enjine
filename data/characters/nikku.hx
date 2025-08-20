if (PlayState.instance != null) {function update(elapsed) y += Math.sin(Conductor.songPosition/1000) * 0.4; 
function onGameOver(e) {
    GameOverSubstate.script = 'data/scripts/gameovers/hotline';
    e.gameOverSong = "death/hotline";
    e.retrySFX = 'death/ends/hotline-end';
    }}