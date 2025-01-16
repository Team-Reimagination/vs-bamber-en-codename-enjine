class AnimatedFunkinSprite extends FunkinSprite {
    public var realSprite:FunkinSprite = null; //use this instead of FlxSprite to be able to use this...

    public var fakeScale:FlxPoint = FlxPoint.get(0, 0);
    public var fakePosition:FlxPoint = FlxPoint.get(0, 0);
    public var fakeAngle:Float = 0;
    public var fakeOrigin:FlxPoint = FlxPoint.get(0, 0);

    public function new(?x:Float = 0, ?y:Float = 0, ?graphic:FlxGraphicAsset) {
        super(x, y, graphic);
    }

    public override function draw() {
        x += fakePosition.x;
        y += fakePosition.y;
        angle += fakeAngle;
        scale.x += fakeScale.x;
        scale.y += fakeScale.y;
        var oldOrigin = FlxPoint.get(origin.x, origin.y);
        origin.set(fakeOrigin.x, fakeOrigin.y);

        super.draw();

        //origin.set(oldOrigin.x, oldOrigin.y);
        //oldOrigin.put();

        x -= fakePosition.x;
        y -= fakePosition.y;
        angle -= fakeAngle;
        scale.x -= fakeScale.x;
        scale.y -= fakeScale.y;
    }

    public function triggerQuirkyAnimation(time:Float) {
        FlxTween.cancelTweensOf(this);
        fakeOrigin = FlxPoint.get(-width/2, -height/2);
        FlxTween.tween(this, {fakeAngle: 15}, time / 5, {ease: FlxEase.sineOut})
        .then(FlxTween.tween(this, {fakeAngle: -12.5}, time / 5, {ease: FlxEase.sineInOut}))
        .then(FlxTween.tween(this, {fakeAngle: 5}, time / 5, {ease: FlxEase.sineInOut}))
        .then(FlxTween.tween(this, {fakeAngle: -2.5}, time / 5, {ease: FlxEase.sineInOut}))
        .then(FlxTween.tween(this, {fakeAngle: 0}, time / 5, {ease: FlxEase.sineInOut}));
    }
}