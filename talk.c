#include <proto/dos.h>

#include "backdrop.h"
#include "custom.h"
#include "fonttext.h"
#include "moreio.h"
#include "objtypes.h"
#include "region.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"
#include "sound_nosound.h"
#include "talk.h"


#define ANGLEFIX (180.0 / 3.14157)
#define ANI_STAND 0
#define ANI_WALK 1
#define ANI_TALK 2

extern FLOAT cameraZoom;
extern int fontHeight, cameraX, cameraY, speechMode;

struct speechStruct * speech;
FLOAT speechSpeed = 1;


void addSpeechLine (char * theLine, int x, int *offset) {
	int halfWidth = (stringWidth (theLine) >> 1)/cameraZoom;
	int xx1 = x - (halfWidth);
	int xx2 = x + (halfWidth);
	struct speechLine * newLine = CstAllocVec(sizeof(struct speechLine),MEMF_ANY);

	newLine -> next = speech -> allSpeech;
	newLine -> textLine = copyString (theLine);
	newLine -> x = xx1;
	speech -> allSpeech = newLine;
	if ((xx1 < 5) && (*offset < (5 - xx1))) {
		*offset = 5 - xx1;
	} else if (((FLOAT) xx2 >= ((FLOAT)winWidth/cameraZoom) - 5) && ((FLOAT) *offset > (((FLOAT)winWidth/cameraZoom) - 5.0 - xx2))) {
		*offset = (int) ((FLOAT)winWidth/cameraZoom) - 5 - xx2;
	}
}


void initSpeech () {
	speech = CstAllocVec(sizeof(struct speechStruct), MEMF_ANY);
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

int isThereAnySpeechGoingOn () {
	return speech -> allSpeech ? speech -> lookWhosTalking : -1;
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
		CstFreeVec(killMe -> textLine);
		CstFreeVec(killMe);
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
		newOne = CstAllocVec( sizeof(struct speechLine),MEMF_ANY);
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

void makeTalker (struct onScreenPerson *me) {
	setFrames (me, ANI_TALK);
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

void setFrames (struct onScreenPerson *m, int a) {
	m->myAnim = m->myPersona -> animation[(a * m->myPersona -> numDirections) + m->direction];
}

int wrapSpeech(char * theText, int objT, int sampleFile, BOOL animPerson) {
    int i;

    speech->lookWhosTalking = objT;
    struct onScreenPerson * thisPerson = findPerson(objT);
    if (thisPerson) {
        //setObjFontColour(thisPerson->thisType); Todo Amigize this
        i = wrapSpeechPerson(theText, thisPerson, sampleFile, animPerson);
    } else {
        struct screenRegion * thisRegion = getRegionForObject(objT);
        if (thisRegion) {
            //setObjFontColour(thisRegion->thisType); Todo Amigize this
            i = wrapSpeechXY(theText, ((thisRegion->x1 + thisRegion->x2) >> 1) - cameraX, thisRegion->y1 - thisRegion->thisType->speechGap - cameraY, thisRegion->thisType->wrapSpeech, sampleFile);
        } else {
            struct objectType * temp = findObjectType(objT);
            //setObjFontColour(temp); Todo: Amigize this
            i = wrapSpeechXY(theText, winWidth >> 1, 10, temp->wrapSpeech, sampleFile);
        }
    }
    return i;
}

int wrapSpeechPerson (char * theText, struct onScreenPerson *thePerson, int sampleFile, BOOL animPerson) {
	int i = wrapSpeechXY (theText, thePerson->x - cameraX, thePerson->y - cameraY - (thePerson->scale * (thePerson->height - thePerson->floaty)) - thePerson->thisType -> speechGap, thePerson->thisType -> wrapSpeech, sampleFile);
	if (animPerson) {
		makeTalker (thePerson);
		speech -> currentTalker = thePerson;
	}
	return i;
}

int wrapSpeechXY(char * theText, int x, int y, int wrap, int sampleFile) {
    int a, offset = 0;
    killAllSpeech();

    int speechTime = (strlen(theText) + 20) * speechSpeed;
    if (speechTime < 1) speechTime = 1;

    if (sampleFile != -1) {
        if (speechMode >= 1) {
            if (startSound(sampleFile, FALSE)) {
                speechTime = -10;
                speech->lastFile = sampleFile;
                if (speechMode == 2) return -10;
            }
        }
    }
    speech->speechY = y;

    while (strlen(theText) > (unsigned long) wrap) {
        a = wrap;
        while (theText[a] != ' ') {
            a--;
            if (a == 0) {
                a = wrap;
                break;
            }
        }
        theText[a] = 0;
        addSpeechLine(theText, x, &offset);
        theText[a] = ' ';
        theText += a + 1;
        y -= fontHeight / cameraZoom;
    }
    addSpeechLine(theText, x, &offset);
    y -= fontHeight / cameraZoom;

    if (y < 0) speech->speechY -= y;
    else if (speech->speechY > cameraY + (FLOAT)(winHeight - fontHeight / 3) / cameraZoom) speech->speechY = cameraY + (FLOAT)(winHeight - fontHeight / 3) / cameraZoom;

    if (offset) {
        struct speechLine * viewLine = speech->allSpeech;
        while (viewLine) {
            viewLine->x += offset;
            viewLine = viewLine->next;
        }
    }

    return speechTime;
}
