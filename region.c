#include <proto/exec.h>
#include <proto/dos.h>
#include "moreio.h"
#include "objtypes.h"
#include "region.h"

struct screenRegion * allScreenRegions = NULL;
struct screenRegion * overRegion = NULL;


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
	while (allScreenRegions) {
		killRegion = allScreenRegions;
		allScreenRegions = allScreenRegions -> next;
		removeObjectType (killRegion -> thisType);
		FreeVec(killRegion);
	}
	overRegion = NULL;
}

void loadRegions (BPTR fp) {
	int numRegions = get2bytes (fp);

	struct screenRegion * newRegion;
	struct screenRegion * * pointy = & allScreenRegions;

	while (numRegions --) {
		newRegion = AllocVec( sizeof(struct screenRegion),MEMF_ANY);
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
            FreeVec(killMe);
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