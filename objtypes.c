#include <proto/exec.h>
#include <proto/dos.h>

#include "custom.h"
#include "objtypes.h"
#include "fileset.h"
#include "gamefile.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"

struct objectType * allObjectTypes = NULL;

/* The extra click size that setHitMargin gave to objects. It is kept by object number, not in the object types: the type of a person
   goes with the person (removeCharacter), and the margin has to be there again when the person is made again. loadObjectType copies
   the margin into the new type, so the test in sprites.c reads the person's own type and searches nothing. */
#define HITMARGINMAX 16
static struct {
	int objectNum;
	short x, y;
} hitMargins[HITMARGINMAX];
static int hitMarginCount = 0;

static void applyHitMargin (struct objectType * t) {
	int i;
	t -> hitMarginX = 0;
	t -> hitMarginY = 0;
	for (i = 0; i < hitMarginCount; i ++) {
		if (hitMargins[i].objectNum == t -> objectNum) {
			t -> hitMarginX = hitMargins[i].x;
			t -> hitMarginY = hitMargins[i].y;
			return;
		}
	}
}

/* setHitMargin (object, x, y): the mouse counts as over a person of the object when it is within x pixels left or right and y pixels above
   or below the frame of the person's picture (the frame grown by that much on every side). Both 0 (a negative number counts as 0) takes
   the object's margin away again. */
void setObjectHitMargin (int objectNum, int x, int y) {
	struct objectType * t;
	int i;
	if (x < 0) x = 0;
	if (y < 0) y = 0;
	for (i = 0; i < hitMarginCount; i ++) {
		if (hitMargins[i].objectNum == objectNum) break;
	}
	if (i == hitMarginCount) {
		if (x == 0 && y == 0) return;		// (no margin before, none now)
		if (i == HITMARGINMAX) {
			KPrintF ("setHitMargin: too many objects with a margin");
			return;
		}
		hitMarginCount ++;
	}
	hitMargins[i].objectNum = objectNum;
	hitMargins[i].x = x;
	hitMargins[i].y = y;
	if (x == 0 && y == 0) {
		hitMargins[i] = hitMargins[-- hitMarginCount];		// (the last entry takes its place)
	}
	for (t = allObjectTypes; t; t = t -> next) {
		if (t -> objectNum == objectNum) applyHitMargin (t);		// the persons and regions that exist already
	}
}

struct objectType * findObjectType (int i) {
	struct objectType * huntType = allObjectTypes;

	while (huntType) {
		if (huntType -> objectNum == i) return huntType;
		huntType = huntType -> next;
	}

	return loadObjectType (i);
}

int getCombinationFunction (int withThis, int thisObject) {
	int i, num = 0;
	struct objectType * obj = findObjectType (thisObject);

	for (i = 0; i < obj -> numCom; i ++) {
		if (obj -> allCombis[i].withObj == withThis)
		{
			num = obj -> allCombis[i].funcNum;
			break;
		}
	}

	return num;
}

BOOL initObjectTypes () {
	return TRUE;
}

struct objectType * loadObjectRef (BPTR fp) {
	struct objectType * r = loadObjectType (get2bytes (fp));
	CstFreeVec(r -> screenName);
	r -> screenName = readString (fp);
	return r;
}

struct objectType * loadObjectType (int i) {
    int a, nameNum;
    struct objectType * newType = CstAllocVec(sizeof(struct objectType), MEMF_ANY);

    if (newType) {
        if (openObjectSlice(i)) {
            nameNum = get2bytes(bigDataFile);
            newType->r = (BYTE) GfGetC();
            newType->g = (BYTE) GfGetC();
            newType->b = (BYTE) GfGetC();
            newType->speechGap = GfGetC();
            newType->walkSpeed = GfGetC();
            newType->wrapSpeech = get4bytes(bigDataFile);
            newType->spinSpeed = get2bytes(bigDataFile);

            GfGetC();
            getFloat(bigDataFile);
            getFloat(bigDataFile);

            newType->flags = get2bytes(bigDataFile);

            newType->numCom = get2bytes(bigDataFile);
            newType->allCombis = (newType->numCom) ? CstAllocVec(sizeof(struct combination) * newType->numCom, MEMF_ANY) : NULL;

            for (a = 0; a < newType->numCom; a++) {
                newType->allCombis[a].withObj = get2bytes(bigDataFile);
                newType->allCombis[a].funcNum = get2bytes(bigDataFile);
            }
            finishAccess();
            newType->screenName = getNumberedString(nameNum);
            newType->objectNum = i;
            applyHitMargin (newType);
            newType->next = allObjectTypes;
            allObjectTypes = newType;
            return newType;
        }
    }
    return NULL;
}


void removeObjectType (struct objectType * oT) {
	struct objectType * * huntRegion = &allObjectTypes;

	while (* huntRegion) {
		if ((* huntRegion) == oT) {
//			FILE * debuggy2 = fopen ("debug.txt", "at");
//			fprintf (debuggy2, "DELETING OBJECT TYPE: %p %s\n", oT, oT -> screenName);
//			fclose (debuggy2);

			* huntRegion = oT -> next;
			if (oT -> allCombis) CstFreeVec(oT -> allCombis);		// (NULL for an object with no combinations: every region removed logged a line, which costs frames)
			if (oT -> screenName) CstFreeVec(oT -> screenName);
			CstFreeVec(oT);
			return;
		} else {
			huntRegion = & ((* huntRegion) -> next);
		}
	}
	KPrintF("Can't delete object type: bad pointer");
}

void saveObjectRef (struct objectType * r, BPTR fp) {
	put2bytes (r -> objectNum, fp);
	writeString (r -> screenName, fp);
}