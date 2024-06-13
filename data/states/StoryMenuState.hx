// WHY IS SWITCHING WEEKS SO LAGGY BY DEFAULT WTF
function onChangeWeek(e)
    FlxTween.color(weekBG, 0.5, weekBG.color, [0xFF66F951, 0xFF5173F9, 0xFFF9EB51][e.value]);