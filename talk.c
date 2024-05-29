#include <proto/dos.h>

#include "moreio.h"
#include "objtypes.h"
#include "talk.h"
#include "support/gcc8_c_support.h"

struct speechStruct * speech;
float speechSpeed = 1;

void initSpeech () {
	speech = AllocVec(sizeof(struct speechStruct), MEMF_ANY);
	if (speech) {
		speech -> currentTalker = NULL;
		speech -> allSpeech = NULL;
		speech -> speechY = 0;
		speech -> lastFile = -1;
	} else
    {
        KPrintF("Could not allocate memory");
    }
}

void killAllSpeech () {
	if (speech -> lastFile != -1) {
		//huntKillSound (speech -> lastFile); Amiga Todo: Replace?
		speech -> lastFile = -1;
	}

	if (speech -> currentTalker) {
		makeSilent (* (speech -> currentTalker));
		speech -> currentTalker = NULL;
	}
	
	struct speechLine * killMe;
	
	while (speech -> allSpeech) {
		killMe = speech -> allSpeech;
		speech -> allSpeech = speech -> allSpeech -> next;
		FreeVec(killMe -> textLine);
		FreeVec(killMe);
	}
}

BOOL loadSpeech (struct speechStruct * sS, BPTR fp) {
	speech -> currentTalker = NULL;
	killAllSpeech ();

	speechSpeed = getFloat (fp);
	
	// Read y co-ordinate
	sS -> speechY = get2bytes (fp);

	// Read which character's talking
	sS -> lookWhosTalking = get2bytes (fp);

	if (FGetC (fp)) {
		sS -> currentTalker = findPerson (get2bytes (fp));
	} else {
		sS -> currentTalker = NULL;
	}
		
	// Read what's being said
	struct speechLine * * viewLine = & sS -> allSpeech;
	struct speechLine * newOne;
	speech -> lastFile = -1;
	while (FGetC (fp)) {
		newOne = AllocVec( sizeof(struct speechLine),MEMF_ANY);
		if (!newOne) { 
			KPrintF("loadSpeech: Cannot allocate memory");
			return FALSE;
		}
		newOne -> textLine = readString (fp);
		newOne -> x	= get2bytes (fp);
		newOne -> next = NULL;
		(* viewLine) = newOne;
		viewLine = & (newOne -> next);
	}

	return TRUE;
}

void saveSpeech (struct speechStruct * sS, BPTR fp) {
	struct speechLine * viewLine = sS -> allSpeech;
	
	putFloat (speechSpeed, fp);
	
		// Write y co-ordinate
		put2bytes (sS -> speechY, fp);
		
		// Write which character's talking
		put2bytes (sS -> lookWhosTalking, fp);		
		if (sS -> currentTalker) {
			FPutC (fp, 1);
			put2bytes (sS->currentTalker->thisType->objectNum, fp);
		} else {
			FPutC (fp, 0);
		}
		
		// Write what's being said
		while (viewLine) {
			FPutC (fp, 1);
			writeString (viewLine -> textLine, fp);
			put2bytes (viewLine -> x, fp);
			viewLine = viewLine -> next;
		}
		FPutC (fp, 0);
}