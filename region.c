#include <proto/exec.h>
#include <proto/dos.h>
#include "backdrop.h"
#include "custom.h"
#include "moreio.h"
#include "objtypes.h"
#include "sludger.h"
#include "region.h"
#include "support/gcc8_c_support.h"

extern struct inputType input;
extern int cameraX, cameraY;

struct screenRegion * allScreenRegions = NULL;
struct screenRegion * overRegion = NULL;



BOOL addScreenRegion(int x1, int y1, int x2, int y2, int sX, int sY, int di, int objectNum) {
    struct screenRegion *newRegion = CstAllocVec(sizeof(struct screenRegion), MEMF_ANY);
    if (!newRegion) return FALSE;
    newRegion->di = di;
    newRegion->x1 = x1;
    newRegion->y1 = y1;
    newRegion->x2 = x2;
    newRegion->y2 = y2;
    newRegion->sX = sX;
    newRegion->sY = sY;
    newRegion->thisType = loadObjectType(objectNum);
    newRegion->next = allScreenRegions;
    allScreenRegions = newRegion;
    return (BOOL) (newRegion->thisType != NULL);
}

void getOverRegion () {
	struct screenRegion * thisRegion = allScreenRegions;
	while (thisRegion) {
		if ((input.mouseX >= thisRegion -> x1 - cameraX) && (input.mouseY >= thisRegion -> y1 - cameraY) &&
			 (input.mouseX <= thisRegion -> x2 - cameraX) && (input.mouseY <= thisRegion -> y2 - cameraY)) {
			overRegion = thisRegion;
			return;
		}
		thisRegion = thisRegion -> next;
	}
	overRegion = NULL;
	return;
}


struct screenRegion * getRegionForObject (int obj) {
	struct screenRegion * thisRegion = allScreenRegions;

	while (thisRegion) {
		if (obj == thisRegion -> thisType -> objectNum) {
			return thisRegion;
		}
		thisRegion = thisRegion -> next;
	}

	return NULL;
}

void killAllRegions () {
	struct screenRegion * killRegion;
    KPrintF("killAllRegions started\n");

	while (allScreenRegions) {
		killRegion = allScreenRegions;
		allScreenRegions = allScreenRegions -> next;
		removeObjectType (killRegion -> thisType);
		CstFreeVec(killRegion);
	}
	overRegion = NULL;
    KPrintF("killAllRegions finished\n");
}

void loadRegions (BPTR fp) {
	int numRegions = get2bytes (fp);

	struct screenRegion * newRegion;
	struct screenRegion * * pointy = & allScreenRegions;

	while (numRegions --) {
		newRegion = CstAllocVec( sizeof(struct screenRegion),MEMF_ANY);
		* pointy = newRegion;
		pointy = & (newRegion -> next);

		newRegion -> x1 = get2bytes (fp);
		newRegion -> y1 = get2bytes (fp);
		newRegion -> x2 = get2bytes (fp);
		newRegion -> y2 = get2bytes (fp);
		newRegion -> sX = get2bytes (fp);
		newRegion -> sY = get2bytes (fp);
		newRegion -> di = get2bytes (fp);
		newRegion -> thisType = loadObjectRef (fp);
	}
	* pointy = NULL;
}

void removeScreenRegion (int objectNum) {
    struct screenRegion ** huntRegion = &allScreenRegions;
    struct screenRegion * killMe;

    while (*huntRegion) {
        if ((*huntRegion)->thisType->objectNum == objectNum) {
            killMe = *huntRegion;
            *huntRegion = killMe->next;
            removeObjectType(killMe->thisType);
            if (killMe == overRegion) overRegion = NULL;
            CstFreeVec(killMe);
            killMe = NULL;
        } else {
            huntRegion = &((*huntRegion)->next);
        }
    }
}

void saveRegions (BPTR fp) {
	int numRegions = 0;
	struct screenRegion * thisRegion = allScreenRegions;
	while (thisRegion) {
		thisRegion = thisRegion -> next;
		numRegions ++;
	}
	put2bytes (numRegions, fp);
	thisRegion = allScreenRegions;
	while (thisRegion) {
		put2bytes (thisRegion -> x1, fp);
		put2bytes (thisRegion -> y1, fp);
		put2bytes (thisRegion -> x2, fp);
		put2bytes (thisRegion -> y2, fp);
		put2bytes (thisRegion -> sX, fp);
		put2bytes (thisRegion -> sY, fp);
		put2bytes (thisRegion -> di, fp);
		saveObjectRef (thisRegion -> thisType, fp);

		thisRegion = thisRegion -> next;
	}
}

void showBoxes () {
	struct screenRegion * huntRegion = allScreenRegions;

	while (huntRegion) {
		drawVerticalLine (huntRegion -> x1, huntRegion -> y1, huntRegion -> y2);
		drawVerticalLine (huntRegion -> x2, huntRegion -> y1, huntRegion -> y2);
		drawHorizontalLine (huntRegion -> x1, huntRegion -> y1, huntRegion -> x2);
		drawHorizontalLine (huntRegion -> x1, huntRegion -> y2, huntRegion -> x2);
		huntRegion = huntRegion -> next;
	}
}