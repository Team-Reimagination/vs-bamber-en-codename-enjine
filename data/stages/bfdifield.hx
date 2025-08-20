//This_is_just_from_v2_right_now_i'll_edit_it_later.
var loopCount = 0;

function postCreate() {
	cast_Marker.animation.addByPrefix("idle", "Marker_Idle", 24, false);
	cast_Marker.animation.addByPrefix("gasp", "Marker_Gasp", 24, false);

	cast_Cloudy.animation.addByPrefix("idle", "Cloudy_Idle", 24, false);
	cast_Cloudy.animation.addByPrefix("gasp", "Cloudy_Gasp", 24, false);

	cast_Relaxing.animation.addByPrefix("idle", "Relaxing_Idle", 24, true);
	cast_Relaxing.animation.addByPrefix("gasp", "Relaxing_Gasp", 24, false);

	cast_Gelatin.animation.addByPrefix("idle", "Gelatin_Idle", 24, true);
	cast_Gelatin.animation.addByPrefix("gasp", "Gelatin_Gasp", 24, false);

	cast_Rhythmic.animation.addByPrefix("idle", "Rhythmic_Gang_Idle", Conductor.crochet / 24 * 2, false);
	cast_Rhythmic.animation.addByIndices("idleReversed", "Rhythmic_Gang_Idle", [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1], '', Conductor.crochet / 24 * 2, false);
	cast_Rhythmic.animation.addByPrefix("gasp", "Rhythmic_Gang_Gasp", 24, false);

	cast_TVGang.animation.addByPrefix("idle", "TV_Gang_Idle", 24, false); //It doesn't trigger the finish Callback if it's looped so I have to make one of my own to manage a special easter egg
	cast_TVGang.animation.addByPrefix("decipher", "TV_Gang_Decipher", 24, false);
	cast_TVGang.animation.addByPrefix("gasp", "TV_Gang_Gasp", 24, false);
	//Long_gross_string_of_code.
	for (i in[cast_Chatters,cast_Marker,cast_Cloudy,cast_Relaxing,cast_Gelatin,cast_Rhythmic,cast_TVGang])
		i.animation.play("idle");
	cast_TVGang.animation.finishCallback = function(name){
		loopCount++;
		cast_TVGang.animation.play("idle", true);

		if (loopCount > 51) {
			cast_TVGang.animation.play("decipher", true);
			cast_TVGang.animation.finishCallback = function(name) {
				cast_TVGang.animation.play("idle", true);
				cast_TVGang.animation.finishCallback = function(name){
					cast_TVGang.animation.play("idle", true);
				};
			}
		}
	}

	cast_Pie.animation.addByPrefix("idle", "Pie_Idle", 24, false);
	cast_Pie.animation.addByIndices("idleReversed", "Pie_Idle", [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1], '', 24, false);
	cast_Pie.animation.addByPrefix("gasp", "Pie_Gasp", 24, false);
	cast_Pie.animation.play("idle");
}

function beatHit(curBeat) {
	if (curBeat % 2) {
		cast_Marker.animation.play("idle", true);
		cast_Cloudy.animation.play("idle", true);
	}
		
	cast_Pie.animation.play("idle" + (curBeat % 2 ? 'Reversed' : ''), true);
	cast_Rhythmic.animation.play("idle" + (curBeat % 2 ? 'Reversed' : ''), true);
}