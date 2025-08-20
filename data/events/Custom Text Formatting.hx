import flixel.text.FlxTextFormat;
//I plan to re-code this when i feel like it --ear.
function onEvent(_) {
	if (_.event.name == 'Custom Text Formatting') {
		var value1 = _.event.params[0];
		var value2 = _.event.params[1];
		var value3 = _.event.params[2];
		var value4 = _.event.params[3];
		var value5 = _.event.params[4];
		var value6 = _.event.params[5];
		var value7 = _.event.params[6];
		for (i in [value1, value2, value3, value4, value5, value6, value7]) {
			if (i == null) break;
		
			if (i == 'clear') {
				eventText.clearFormats();
			} else {
				var formats = Std.string(i).split('.');
				for (f in 0...formats.length) {
					if (f % 3 == 2) {
						var colorFormat = Std.string(formats[f]).split('-');
						var formatColor = Std.parseInt(colorFormat[0]);
						eventText.addFormat(new FlxTextFormat(formatColor, colorFormat.contains('bold'), colorFormat.contains('italic'), (isColorDark(formatColor) ? 0xFFFFFFFF : 0xFF000000)), formats[f - 2], formats[f - 1]);
					}
				}
			}
		}
	}
}
function isColorDark(color:Int):Bool {
    var r = (color >> 16) & 0xFF;
    var g = (color >> 8) & 0xFF;
    var b = color & 0xFF;

    var max = Math.max(r, Math.max(g, b));
    var min = Math.min(r, Math.min(g, b));

    // Calculate lightness
    var l = (max + min) / 2.0 / 255.0;

    return l < 0.5;
}