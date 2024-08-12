function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Flash stupid fucking image") {
        var sprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image("gallery/" + params[0]));
        sprite.camera = camHUD;
        sprite.setGraphicSize(1280, 720);
        sprite.screenCenter();
        insert(0, sprite);
        FlxTween.tween(sprite, {alpha: 0}, 1, {onComplete: function() {
            remove(sprite);
            sprite.destroy();
        }});
    }
}