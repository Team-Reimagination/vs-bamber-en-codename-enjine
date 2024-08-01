camZooming = true;

function postCreate() // second opponent offset
	if(strumLines.members[1].characters[0].curCharacter.toLowerCase() == "boris"){
		strumLines.members[1].characters[0].x -= 200;
		strumLines.members[1].characters[0].y += 100;
	}