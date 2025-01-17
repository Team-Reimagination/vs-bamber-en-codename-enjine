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
        //var oldOrigin = FlxPoint.get(origin.x, origin.y);
        animateAtlas.origin.set(fakeOrigin.x, fakeOrigin.y);

        super.draw();

        //origin.set(oldOrigin.x, oldOrigin.y);
        //oldOrigin.put();

        x -= fakePosition.x;
        y -= fakePosition.y;
        angle -= fakeAngle;
        scale.x -= fakeScale.x;
        scale.y -= fakeScale.y;
    }

    // looks best with time = idk actually
    public function triggerQuirkyAnimation(time:Float) {
        FlxTween.cancelTweensOf(this);
        fakeOrigin = FlxPoint.get(width, height);
        FlxTween.tween(this, {fakeAngle: 15}, time / 5, {ease: FlxEase.sineOut})
        .then(FlxTween.tween(this, {fakeAngle: -12.5}, time / 5, {ease: FlxEase.sineInOut}))
        .then(FlxTween.tween(this, {fakeAngle: 5}, time / 5, {ease: FlxEase.sineInOut}))
        .then(FlxTween.tween(this, {fakeAngle: -2.5}, time / 5, {ease: FlxEase.sineInOut}))
        .then(FlxTween.tween(this, {fakeAngle: 0}, time / 5, {ease: FlxEase.sineInOut}));
    }

    // looks best with time = 0.3
    public function triggerQuirkyAnimation2(time:Float) {
        FlxTween.cancelTweensOf(this);
        FlxTween.cancelTweensOf(this.fakeScale);
        fakeOrigin = FlxPoint.get(width, height);
        fakeAngle = 15;
        fakeScale.set(0.1, 0.1);
        FlxTween.tween(this, {fakeAngle: -5}, (time / 2), {ease: FlxEase.sineInOut})
        .then(FlxTween.tween(this, {fakeAngle: 0}, (time / 2), {ease: FlxEase.backOut}));
        FlxTween.tween(this.fakeScale, {x: 0, y: 0}, (time / 2) - (time / 6), {ease: FlxEase.sineInOut, startDelay: (time / 6)});
    }

    // looks best with time = 0.4
    public function triggerBounceAnimation(time:Float) {
        FlxTween.cancelTweensOf(this.fakePosition);
        FlxTween.cancelTweensOf(this.fakeScale);
        fakeOrigin = FlxPoint.get(width, height);
        fakeScale.set(-0.05, 0.05);
        FlxTween.tween(this.fakePosition, {y: -30}, (time / 4), {ease: FlxEase.sineOut})
        .then(FlxTween.tween(this.fakePosition, {y: 0}, (time / 4), {ease: FlxEase.sineIn}))
        .then(FlxTween.tween(this.fakeScale, {x: 0.05, y: -0.05}, 0.000001), {ease: FlxEase.sineOut, startDelay: (time / 4) * 2})
        .then(FlxTween.tween(this.fakeScale, {x: 0, y: 0}, (time / 4) * 2, {ease: FlxEase.backOut}));
        //FlxTween.tween(this.fakeScale, {x: 0, y: 0}, (time / 2) - (time / 4), {ease: FlxEase.sineIn, startDelay: (time / 4)});
    }
}