#include <proto/exec.h>
#include <proto/dos.h>

#include "custom.h"
#include "objtypes.h"
#include "fileset.h"
#include "gamefile.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"

struct objectType * allObjectTypes = NULL;

/* The hit boxes that setHitBox gave to objects. They are kept by object number, not in the object types: the type of a person
   goes with the person (removeCharacter), and the box has to be there again when the person is made again. loadObjectType copies the
   box into the new type, so the test in sprites.c reads the person's own type and searches nothing. */
#define HITBOXMAX 16
static struct {
	int objectNum;
	short x1, y1, x2, y2;
} hitBoxes[HITBOXMAX];
static int hitBoxCount = 0;

static void applyHitBox (struct objectType * t) {
	int i;
	t -> hasHitBox = FALSE;
	for (i = 0; i < hitBoxCount; i ++) {
		if (hitBoxes[i].objectNum == t -> objectNum) {
			t -> hasHitBox = TRUE;
			t -> hitX1 = hitBoxes[i].x1;
			t -> hitY1 = hitBoxes[i].y1;
			t -> hitX2 = hitBoxes[i].x2;
			t -> hitY2 = hitBoxes[i].y2;
			return;
		}
	}
}

/* setHitBox (object, x1, y1, x2, y2): a box around the position of every person of the object, besides the frame of the picture, in which
   the mouse counts as over the person. An empty box (x2 < x1 or y2 < y1) takes the object's box away again. */
void setObjectHitBox (int objectNum, int x1, int y1, int x2, int y2) {
	struct objectType * t;
	int i;
	for (i = 0; i < hitBoxCount; i ++) {
		if (hitBoxes[i].objectNum == objectNum) break;
	}
	if (i == hitBoxCount) {
		if (i == HITBOXMAX) {
			KPrintF ("setHitBox: too many objects with a hit box");
			return;
		}
		hitBoxCount ++;
	}
	hitBoxes[i].objectNum = objectNum;
	hitBoxes[i].x1 = x1;
	hitBoxes[i].y1 = y1;
	hitBoxes[i].x2 = x2;
	hitBoxes[i].y2 = y2;
	if (x2 < x1 || y2 < y1) {
		hitBoxes[i] = hitBoxes[-- hitBoxCount];		// (the last entry takes its place)
	}
	for (t = allObjectTypes; t; t = t -> next) {
		if (t -> objectNum == objectNum) applyHitBox (t);		// the persons and regions that exist already
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
            applyHitBox (newType);
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