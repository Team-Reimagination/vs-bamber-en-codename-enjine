import funkin.backend.FunkinSprite;
import funkin.options.Options;

public static var initialized = false;
public static var preIntro = true;

var constellation = new FunkinSprite();

function create() {
    if (!initialized) {
        constellation.loadSprite(Paths.image('menus/titleScreen/constellation'));

        constellation.animateAtlas.anim.addBySymbol("Constellation", "Scenes/TitleScreen/Monolith", 24, false);
        constellation.animateAtlas.anim.play("Constellation");

        constellation.antialiasing = Options.antialiasing;
        constellation.scale.set(0.9, 0.9); constellation.updateHitbox(); constellation.screenCenter();
        add(constellation);

        FlxG.sound.play(Paths.sound('titleScreen/MonolithTeaser'), getVolume(1, 'sfx'));
    }
}

function update(elapsed) {

}