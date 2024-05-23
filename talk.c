#include <proto/exec.h>

#include "talk.h"
#include "support/gcc8_c_support.h"

struct speechStruct * speech;

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