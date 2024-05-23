#include <proto/exec.h>

#include "people.h"
#include "support/gcc8_c_support.h"
#include "region.h"

#define ANGLEFIX (180.0 / 3.14157)
#define ANI_STAND 0
#define ANI_WALK 1
#define ANI_TALK 2

struct screenRegion personRegion;

extern struct screenRegion * allScreenRegions;

struct personaAnimation * copyAnim (struct personaAnimation * orig) {
	int num = orig -> numFrames;

	struct personaAnimation * newAnim	= AllocVec(sizeof( struct personaAnimation), MEMF_ANY);
	if (!(newAnim)) {
		KPrintF("copyAnim: Cannot allocate memory");
		return NULL;
	}

	// Copy the easy bits...
	newAnim -> theSprites		= orig -> theSprites;
	newAnim -> numFrames		= num;

	if (num) {

		// Argh! Frames! We need a whole NEW array of animFrame structures...

		newAnim->frames = AllocVec(sizeof(struct animFrame) * num, MEMF_ANY);
		if (newAnim->frames) {
			KPrintF("copyAnim: Cannot allocate memory");
			return NULL;
		}

		for (int a = 0; a < num; a ++) {
			newAnim -> frames[a].frameNum = orig -> frames[a].frameNum;
			newAnim -> frames[a].howMany = orig -> frames[a].howMany;
			newAnim -> frames[a].noise = orig -> frames[a].noise;
		}
	} else {
		newAnim -> frames = NULL;
	}

	return newAnim;
}

void deleteAnim (struct personaAnimation * orig) {

	if (orig)
	{
		if (orig -> numFrames) {
			FreeVec( orig->frames);
		}
		FreeVec(orig);
		orig = NULL;
	}
}

BOOL initPeople () {
	personRegion.sX = 0;
	personRegion.sY = 0;
	personRegion.di = -1;
	allScreenRegions = NULL;

	return TRUE;
}

void makeSilent (struct onScreenPerson me) {
	setFrames (me, ANI_STAND);
}

struct personaAnimation * makeNullAnim () {

	struct personaAnimation * newAnim	= AllocVec(sizeof(struct personaAnimation),MEMF_ANY);
    if(newAnim == 0) {
     	KPrintF("makeNullAnim: Can't reserve Memory\n");
        return NULL;    
    }  

	newAnim -> theSprites		= NULL;
	newAnim -> numFrames		= 0;
	newAnim -> frames			= NULL;
	return newAnim;
}
