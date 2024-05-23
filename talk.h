#include "people.h"

struct speechLine {
	char * textLine;
	struct speechLine * next;
	int x;
};

struct speechStruct {
	struct onScreenPerson * currentTalker;
	struct speechLine * allSpeech;
	int speechY, lastFile, lookWhosTalking;	
};

void initSpeech ();
void killAllSpeech ();