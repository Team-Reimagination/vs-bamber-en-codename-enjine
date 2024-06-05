function onNoteHit(e)
	if(e.noteType == "player2" || e.noteType == "opponent2")
		e.character = strumLines.members[e.noteType == "opponent2" ? 1 : 3].characters[0];

function onPlayerMiss(e)
	if(e.noteType == "player2" || e.noteType == "opponent2")
		e.character = strumLines.members[e.noteType == "opponent2" ? 1 : 3].characters[0];