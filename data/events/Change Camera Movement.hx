function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Change Camera Movement") {
        cameraTime = params[0];
        var flxease:String = params[1] + (params[1] == "linear" ? "" : params[2]);
        cameraEasing = Reflect.field(FlxEase, flxease);
        FlxG.camera.followLerp = params[3];
    }
}