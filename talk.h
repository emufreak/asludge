#ifndef __SLUDGE_TALK_H__
#define __SLUDGE_TALK_H__

#include <proto/exec.h>

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

void addSpeechLine (char * theLine, int x, int *offset);
void initSpeech ();
int isThereAnySpeechGoingOn ();
void killAllSpeech ();
BOOL loadSpeech (struct speechStruct * sS, BPTR fp);
void saveSpeech (struct speechStruct * sS, BPTR fp);
void setFrames (struct onScreenPerson *m, int a);
int wrapSpeech(char * theText, int objT, int sampleFile, BOOL animPerson);
int wrapSpeechPerson (char * theText, struct onScreenPerson *thePerson, int sampleFile, BOOL animPerson);
int wrapSpeechXY (char * theText, int x, int y, int wrap, int sampleFile);

#endif