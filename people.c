#include <proto/exec.h>

#include "loadsave.h"
#include "moreio.h"
#include "people.h"
#include "sprbanks.h"
#include "sludger.h"
#include "support/gcc8_c_support.h"
#include "region.h"

#define ANGLEFIX (180.0 / 3.14157)
#define ANI_STAND 0
#define ANI_WALK 1
#define ANI_TALK 2

struct screenRegion personRegion;
extern struct screenRegion * allScreenRegions;
struct onScreenPerson * allPeople = NULL;

short int scaleHorizon = 75;
short int scaleDivide = 150;

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

void killAllPeople () {
	struct onScreenPerson * killPeople;
	while (allPeople) {
		if (allPeople -> continueAfterWalking) abortFunction (allPeople -> continueAfterWalking);
		allPeople -> continueAfterWalking = NULL;
		killPeople = allPeople;
		allPeople = allPeople -> next;
		removeObjectType (killPeople -> thisType);
		FreeVec(killPeople);
	}
}

BOOL loadAnim (struct personaAnimation * p, BPTR fp) {
	p -> numFrames = get2bytes (fp);

	if (p -> numFrames) {
		int a = get4bytes (fp);
		p -> frames = AllocVec( sizeof(struct animFrame) * p -> numFrames,MEMF_ANY);
		if( !p->frames) {
			KPrintF("loadAnim: Cannot allocate memory");
			return FALSE;
		}
		p -> theSprites = loadBankForAnim (a);

		for (a = 0; a < p -> numFrames; a ++) {
			p -> frames[a].frameNum = get4bytes (fp);
			p -> frames[a].howMany = get4bytes (fp);			
			p -> frames[a].noise = get4bytes (fp);			
		}
	} else {
		p -> theSprites = NULL;
		p -> frames = NULL;
	}
	return TRUE;
}

BOOL loadCostume (struct persona * cossy, BPTR fp) {
	int a;
	cossy -> numDirections = get2bytes (fp);
	cossy -> animation = AllocVec(sizeof( struct personaAnimation) * cossy -> numDirections * 3,MEMF_ANY);
	if (!(cossy -> animation)) {
		KPrintF("loadcostume: Cannot allocate memory");
		return FALSE;
	}
	for (a = 0; a < cossy -> numDirections * 3; a ++) {
		cossy -> animation[a] = AllocVec( sizeof( struct personaAnimation), MEMF_ANY);
		if (!(cossy -> animation[a])) {
			KPrintF("loadcostume: Cannot allocate memory");
			return FALSE;
		}

		if (! loadAnim (cossy -> animation[a], fp)) return FALSE;
	}
//	debugCostume ("Loaded", cossy);
	return TRUE;
}

BOOL loadPeople (BPTR fp) {
	struct onScreenPerson * * pointy = & allPeople;
	struct onScreenPerson * me;

	scaleHorizon = getSigned (fp);
	scaleDivide = getSigned (fp);

	int countPeople = get2bytes (fp);
	int a;

	allPeople = NULL;
	for (a = 0; a < countPeople; a ++) {
		me = AllocVec( sizeof( struct onScreenPerson), MEMF_ANY);
		if (!me) {
			KPrintF("loadPeople: Cannot allocate memory");
			return FALSE;
		}

		me -> myPersona = AllocVec( sizeof( struct persona), MEMF_ANY);
		if (!(me -> myPersona)) {
			KPrintF("loadPeople: Cannot allocate memory");
			return FALSE;
		}

		me -> myAnim = AllocVec( sizeof( struct personaAnimation), MEMF_ANY);
		if (!(me -> myAnim)) {
			KPrintF("loadPeople: Cannot allocate memory");
			return FALSE;
		}

		me -> x = getFloat (fp);
		me -> y = getFloat (fp);

		loadCostume (me -> myPersona, fp);
		loadAnim (me -> myAnim, fp);

		me -> lastUsedAnim = FGetC (fp) ? me -> myAnim : NULL;

		me -> scale = getFloat (fp);

		me -> extra = get2bytes (fp);
		me -> height = get2bytes (fp);
		me -> walkToX = get2bytes (fp);
		me -> walkToY = get2bytes (fp);
		me -> thisStepX = get2bytes (fp);
		me -> thisStepY = get2bytes (fp);
		me -> frameNum = get2bytes (fp);
		me -> frameTick = get2bytes (fp);
		me -> walkSpeed = get2bytes (fp);
		me -> spinSpeed = get2bytes (fp);
		me -> floaty = getSigned (fp);
		me -> show = FGetC (fp);
		me -> walking = FGetC (fp);
		me -> spinning = FGetC (fp);
		if (FGetC (fp)) {
			me -> continueAfterWalking = loadFunction (fp);
			if (! me -> continueAfterWalking) return FALSE;
		} else {
			me -> continueAfterWalking = NULL;
		}
		me -> direction = get2bytes(fp);
		me -> angle = get2bytes(fp);	
		me -> angleOffset = get2bytes(fp);	
		me -> wantAngle = get2bytes(fp);
		me -> directionWhenDoneWalking = getSigned(fp);
		me -> inPoly = getSigned(fp);
		me -> walkToPoly = getSigned(fp);		
		me -> r = FGetC (fp);
		me -> g = FGetC (fp);
		me -> b = FGetC (fp);
		me -> colourmix = FGetC (fp);
		me -> transparency = FGetC (fp);		
		me -> thisType = loadObjectRef (fp);
		// aaLoad
		FGetC (fp);
		getFloat (fp);
		getFloat (fp);

		me -> next = NULL;
		* pointy = me;
		pointy = & (me -> next);
	}
//	db ("End of loadPeople");
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

BOOL saveAnim (struct personaAnimation * p, BPTR fp) {
	put2bytes (p -> numFrames, fp);
	if (p -> numFrames) {
		put4bytes (p -> theSprites -> ID, fp);

		for (int a = 0; a < p -> numFrames; a ++) {
			put4bytes (p -> frames[a].frameNum, fp);
			put4bytes (p -> frames[a].howMany, fp);
			put4bytes (p -> frames[a].noise, fp);
		}
	}
	return TRUE;
}

BOOL saveCostume (struct persona * cossy, BPTR fp) {
	int a;
	put2bytes (cossy -> numDirections, fp);
	for (a = 0; a < cossy -> numDirections * 3; a ++) {
		if (! saveAnim (cossy -> animation[a], fp)) return FALSE;
	}

	return TRUE;
}

BOOL savePeople (BPTR fp) {
	struct onScreenPerson * me = allPeople;
	int countPeople = 0, a;

	putSigned (scaleHorizon, fp);
	putSigned (scaleDivide, fp);

	while (me) {
		countPeople ++;
		me = me -> next;
	}

	put2bytes (countPeople, fp);

	me = allPeople;
	for (a = 0; a < countPeople; a ++) {

		putFloat (me -> x, fp);
		putFloat (me -> y, fp);

		saveCostume (me -> myPersona, fp);
		saveAnim (me -> myAnim, fp);
		fputc (me -> myAnim == me -> lastUsedAnim, fp);

		putFloat (me -> scale, fp);

		put2bytes (me -> extra, fp);
		put2bytes (me -> height, fp);
		put2bytes (me -> walkToX, fp);
		put2bytes (me -> walkToY, fp);
		put2bytes (me -> thisStepX, fp);
		put2bytes (me -> thisStepY, fp);
		put2bytes (me -> frameNum, fp);
		put2bytes (me -> frameTick, fp);
		put2bytes (me -> walkSpeed, fp);
		put2bytes (me -> spinSpeed, fp);
		putSigned (me -> floaty, fp);
		FPutC (fp, me -> show);
		FPutC (fp, me -> walking);
		FPutC (fp, me -> spinning);
		if (me -> continueAfterWalking) {
			FPutC (fp, 1);
			saveFunction (me -> continueAfterWalking, fp);
		} else {
			FPutC (fp, 1);
		}
		put2bytes (me -> direction, fp);
		put2bytes (me -> angle, fp);
		put2bytes (me -> angleOffset, fp);
		put2bytes (me -> wantAngle, fp);
		putSigned (me -> directionWhenDoneWalking, fp);
		putSigned (me -> inPoly, fp);
		putSigned (me -> walkToPoly, fp);

		FPutC (fp, me -> r);
		FPutC (fp, me -> g);
		FPutC (fp, me -> b);
		FPutC (fp, me -> colourmix);
		FPutC (fp, me -> transparency);
		
		saveObjectRef (fp, me -> thisType);

		me = me -> next;
	}
	return TRUE;
}