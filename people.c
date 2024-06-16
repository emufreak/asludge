#include <proto/exec.h>

#include "floor.h"
#include "loadsave.h"
#include "moreio.h"
#include "people.h"
#include "sprbanks.h"
#include "sludger.h"
#include "support/gcc8_c_support.h"
#include "region.h"
#include "talk.h"

#define ANGLEFIX (180.0 / 3.14157)
#define ANI_STAND 0
#define ANI_WALK 1
#define ANI_TALK 2


extern struct screenRegion * allScreenRegions;
extern struct flor * currentFloor;
extern struct screenRegion * overRegion;
extern struct speechStruct * speech;

struct onScreenPerson * allPeople = NULL;
struct screenRegion personRegion;




short int scaleHorizon = 75;
short int scaleDivide = 150;

int TF_abs (int a) {
	return (a > 0) ? a : -a;
}


BOOL addPerson(int x, int y, int objNum, struct persona *p) {
    struct onScreenPerson *newPerson = AllocVec(sizeof(struct onScreenPerson), MEMF_ANY);
    if (!newPerson) return FALSE;

    // EASY STUFF
    newPerson->thisType = loadObjectType(objNum);
    newPerson->scale = 1;
    newPerson->extra = 0;
    newPerson->continueAfterWalking = NULL;
    moveAndScale(newPerson, x, y);
    newPerson->frameNum = 0;
    newPerson->walkToX = x;
    newPerson->walkToY = y;
    newPerson->walking = FALSE;
    newPerson->spinning = FALSE;
    newPerson->show = TRUE;
    newPerson->direction = 0;
    newPerson->angle = 180;
    newPerson->wantAngle = 180;
    newPerson->angleOffset = 0;
    newPerson->floaty = 0;
    newPerson->walkSpeed = newPerson->thisType->walkSpeed;
    newPerson->myAnim = NULL;
    newPerson->spinSpeed = newPerson->thisType->spinSpeed;
    newPerson->r = 0;
    newPerson->g = 0;
    newPerson->b = 0;
    newPerson->colourmix = 0;
    newPerson->transparency = 0;
    newPerson->myPersona = p;

    setFrames(newPerson, ANI_STAND);

    // HEIGHT (BASED ON 1st FRAME OF 1st ANIMATION... INC. SPECIAL CASES)
    int fNumSigned = p->animation[0]->frames[0].frameNum;
    int fNum = fNumSigned < 0 ? fNumSigned * - 1 : 1;
    if (fNum >= p->animation[0]->theSprites->bank.total) {
        if (fNumSigned < 0) {
            newPerson->height = 5;
        } else {
            newPerson->height = p->animation[0]->theSprites->bank.sprites[0].yhot + 5;
        }
    } else {
        newPerson->height = p->animation[0]->theSprites->bank.sprites[fNum].yhot + 5;
    }

    // NOW ADD IT IN THE RIGHT PLACE
    struct onScreenPerson **changethat = &allPeople;

    while (((*changethat) != NULL) && ((*changethat)->y < y)) {
        changethat = &((*changethat)->next);
    }

    newPerson->next = (*changethat);
    (*changethat) = newPerson;

    return (BOOL) (newPerson->thisType != NULL);
}

void animatePerson (int obj, struct personaAnimation * fram) { // Set a new SINGLE animation
    struct onScreenPerson * moveMe = findPerson(obj);
    if (moveMe) {
        if (moveMe -> continueAfterWalking) abortFunction(moveMe -> continueAfterWalking);
        moveMe -> continueAfterWalking = NULL;
        moveMe -> walking = FALSE;
        moveMe -> spinning = FALSE;
        moveMe -> myAnim = fram;
    }
}

void animatePersonUsingPersona (int obj, struct persona * per) { // Set a new costume
    struct onScreenPerson * moveMe = findPerson(obj);
    if (moveMe) {
        // if (moveMe -> continueAfterWalking) abortFunction (moveMe -> continueAfterWalking);
        // moveMe -> continueAfterWalking = NULL;
        // moveMe -> walking = false;
        moveMe -> spinning = FALSE;
        moveMe -> myPersona = per;
        rethinkAngle(moveMe);
        if (moveMe->walking) {
            setFrames(moveMe, ANI_WALK);
        } else {
            setFrames(moveMe, ANI_STAND);
        }
    }
}


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

BOOL doBorderStuff (struct onScreenPerson * moveMe) {
    if (moveMe -> inPoly == moveMe -> walkToPoly) {
        moveMe -> inPoly = -1;
        moveMe -> thisStepX = moveMe -> walkToX;
        moveMe -> thisStepY = moveMe -> walkToY;
    } else {
        // The section in which we need to be next...
        int newPoly = currentFloor -> matrix[moveMe -> inPoly][moveMe -> walkToPoly];
        if (newPoly == -1) return FALSE;

        // Grab the index of the second matching corner...
        int ID, ID2;
        if (! getMatchingCorners (&(currentFloor -> polygon[moveMe -> inPoly]), &(currentFloor -> polygon[newPoly]), &ID, &ID2))
		{
			KPrintF ("Not a valid floor plan!");
            return FALSE;
		}

        // Remember that we're walking to the new polygon...
        moveMe -> inPoly = newPoly;

        // Calculate the destination position on the coincidental line...
        int x1 = moveMe -> x, y1 = moveMe -> y;
        int x2 = moveMe -> walkToX, y2 = moveMe -> walkToY;
        int x3 = currentFloor -> vertex[ID].x, y3 = currentFloor -> vertex[ID].y;
        int x4 = currentFloor -> vertex[ID2].x, y4 = currentFloor -> vertex[ID2].y;

        int xAB = x1 - x2;
        int yAB = y1 - y2;
        int xCD = x4 - x3;
        int yCD = y4 - y3;

        double m = (yAB * (x3 - x1) - xAB * (y3 - y1));
        m /= ((xAB * yCD) - (yAB * xCD));

        if (m > 0 && m < 1) {
            moveMe -> thisStepX = x3 + m * xCD;
            moveMe -> thisStepY = y3 + m * yCD;
        } else {
            int dx13 = x1 - x3, dx14 = x1 - x4, dx23 = x2 - x3, dx24 = x2 - x4;
            int dy13 = y1 - y3, dy14 = y1 - y4, dy23 = y2 - y3, dy24 = y2 - y4;

            dx13 *= dx13; dx14 *= dx14; dx23 *= dx23; dx24 *= dx24;
            dy13 *= dy13; dy14 *= dy14; dy23 *= dy23; dy24 *= dy24;

            if (sqrt((double) dx13 + dy13) + sqrt((double) dx23 + dy23) <
                sqrt((double) dx14 + dy14) + sqrt((double) dx24 + dy24)) {
                moveMe -> thisStepX = x3;
                moveMe -> thisStepY = y3;
            } else {
                moveMe -> thisStepX = x4;
                moveMe -> thisStepY = y4;
            }
        }
    }

    float yDiff = moveMe -> thisStepY - moveMe -> y;
    float xDiff = moveMe -> x - moveMe -> thisStepX;
    if (xDiff || yDiff) {
        moveMe -> wantAngle = 180 + ANGLEFIX * atan2f(xDiff, yDiff * 2);
        moveMe -> spinning = TRUE;
    }

    setFrames (moveMe, ANI_WALK);
    return TRUE;
}


struct onScreenPerson * findPerson (int v) {
	struct onScreenPerson * thisPerson = allPeople;
	while (thisPerson) {
		if (v == thisPerson -> thisType -> objectNum) break;
		thisPerson = thisPerson -> next;
	}
	return thisPerson;
}

BOOL floatCharacter (int f, int objNum) {
	struct onScreenPerson * moveMe = findPerson (objNum);
	if (! moveMe) return FALSE;
	moveMe -> floaty = f;
	return TRUE;
}

BOOL forceWalkingPerson (int x, int y, int objNum, struct loadedFunction * func, int di) {
    if (x == 0 && y == 0) return FALSE;
    struct onScreenPerson * moveMe = findPerson(objNum);
    if (!moveMe) return FALSE;

    if (moveMe->continueAfterWalking) abortFunction(moveMe->continueAfterWalking);
    moveMe->walking = TRUE;
    moveMe->continueAfterWalking = NULL;
    moveMe->directionWhenDoneWalking = di;

    moveMe->walkToX = x;
    moveMe->walkToY = y;

    // Let's pretend the start and end points are both in the same
    // polygon (which one isn't important)
    moveMe->inPoly = 0;
    moveMe->walkToPoly = 0;

    doBorderStuff(moveMe);
    if (walkMe(moveMe, TRUE) || moveMe->spinning) {
        moveMe->continueAfterWalking = func;
        return TRUE;
    } else {
        return FALSE;
    }
}

BOOL handleClosestPoint (int * setX, int * setY, int * setPoly) {
	int gotX = 320, gotY = 200, gotPoly = -1, i, j, xTest1, yTest1,
		xTest2, yTest2, closestX, closestY, oldJ, currentDistance = 0xFFFFF,
		thisDistance;

	for (i = 0; i < currentFloor -> numPolygons; i ++) {
		oldJ = currentFloor -> polygon[i].numVertices - 1;
		for (j = 0; j < currentFloor -> polygon[i].numVertices; j ++) {
			xTest1 = currentFloor -> vertex[currentFloor -> polygon[i].vertexID[j]].x;
			yTest1 = currentFloor -> vertex[currentFloor -> polygon[i].vertexID[j]].y;
			xTest2 = currentFloor -> vertex[currentFloor -> polygon[i].vertexID[oldJ]].x;
			yTest2 = currentFloor -> vertex[currentFloor -> polygon[i].vertexID[oldJ]].y;
			closestPointOnLine (&closestX, &closestY, xTest1, yTest1, xTest2, yTest2, *setX, *setY);

			xTest1 = *setX - closestX;
			yTest1 = *setY - closestY;
			thisDistance = xTest1 * xTest1 + yTest1 * yTest1;


			if (thisDistance < currentDistance) {

				currentDistance = thisDistance;
				gotX = closestX;
				gotY = closestY;
				gotPoly = i;
			}
			oldJ = j;
		}
	}

	if (gotPoly == -1) return FALSE;
	*setX = gotX;
	*setY = gotY;
	*setPoly = gotPoly;

	return TRUE;
}


BOOL initPeople () {
	personRegion.sX = 0;
	personRegion.sY = 0;
	personRegion.di = -1;
	allScreenRegions = NULL;

	return TRUE;
}

void jumpPerson (int x, int y, int objNum) {
    if (x == 0 && y == 0) return;
    struct onScreenPerson * moveMe = findPerson(objNum);
    if (!moveMe) return;
    if (moveMe->continueAfterWalking) abortFunction(moveMe->continueAfterWalking);
    moveMe->continueAfterWalking = NULL;
    moveMe->walking = FALSE;
    moveMe->spinning = FALSE;
    moveAndScale(moveMe, x, y);
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

void killMostPeople() {
    struct onScreenPerson *killPeople;
    struct onScreenPerson **lookyHere = &allPeople;

    while (*lookyHere) {
        if ((*lookyHere)->extra & EXTRA_NOREMOVE) {
            lookyHere = &(*lookyHere)->next;
        } else {
            killPeople = (*lookyHere);

            // Change last pointer to NEXT in the list instead
            (*lookyHere) = killPeople->next;

            // Gone from the list... now free some memory
            if (killPeople->continueAfterWalking) abortFunction(killPeople->continueAfterWalking);
            killPeople->continueAfterWalking = NULL;
            removeObjectType(killPeople->thisType);
            FreeVec(killPeople);
        }
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
		me -> y = getSigned (fp);
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
	setFrames (&me, ANI_STAND);
}

BOOL makeWalkingPerson (int x, int y, int objNum, struct loadedFunction * func, int di) {
	if (x == 0 && y == 0) return FALSE;
	if (currentFloor -> numPolygons == 0) return FALSE;
	struct onScreenPerson * moveMe = findPerson (objNum);
	if (! moveMe) return FALSE;

	if (moveMe -> continueAfterWalking) abortFunction (moveMe -> continueAfterWalking);
	moveMe -> continueAfterWalking = NULL;
	moveMe -> walking = TRUE;
	moveMe -> directionWhenDoneWalking = di;

	moveMe -> walkToX = x;
	moveMe -> walkToY = y;
	moveMe -> walkToPoly = inFloor (x, y);
	if (moveMe -> walkToPoly == -1) {
		if (! handleClosestPoint (moveMe -> walkToX, moveMe -> walkToY, moveMe -> walkToPoly)) return FALSE;
	}

	moveMe -> inPoly = inFloor (moveMe -> x, moveMe -> y);
	if (moveMe -> inPoly == -1) {
		int xxx = moveMe -> x, yyy = moveMe -> y;
		if (! handleClosestPoint (xxx, yyy, moveMe -> inPoly)) return FALSE;
	}

	doBorderStuff (moveMe);
	if (walkMe (moveMe, FALSE) || moveMe -> spinning) {
		moveMe -> continueAfterWalking = func;
		return TRUE;
	} else {
		return FALSE;
	}
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

void moveAndScale (struct onScreenPerson *me, FLOAT x, FLOAT y) {
	me->x = x;
	me->y = y;
	if (! (me->extra & EXTRA_NOSCALE) && scaleDivide) me->scale = (me->y - scaleHorizon) / scaleDivide;
}

void removeOneCharacter (int i) {
    struct onScreenPerson * p = findPerson(i);

    if (p) {
        if (overRegion == &personRegion && overRegion->thisType == p->thisType) {
            overRegion = NULL;
        }

        if (p->continueAfterWalking) abortFunction(p->continueAfterWalking);
        p->continueAfterWalking = NULL;
        struct onScreenPerson ** killPeople;

        for (killPeople = &allPeople;
            *killPeople != p;
            killPeople = &((*killPeople)->next)) {;}

        *killPeople = p->next;
        removeObjectType(p->thisType);
        FreeVec(p);
    }
}

void rethinkAngle (struct onScreenPerson * thisPerson) {
	int d = thisPerson -> myPersona -> numDirections;
	int direc = thisPerson -> angle + (180 / d) + 180 + thisPerson -> angleOffset;
	while (direc >= 360) direc -= 360;
	thisPerson -> direction = (direc * d) / 360;
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
		FPutC( fp, me -> myAnim == me -> lastUsedAnim);

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

void setDrawMode (int h, int ob) {
	struct onScreenPerson * moveMe = findPerson (ob);
	if (! moveMe) return;
		
	setMyDrawMode (moveMe, h);
}

enum drawModes {
	drawModeNormal,
	drawModeTransparent1,
	drawModeTransparent2,
	drawModeTransparent3,
	drawModeDark1,
	drawModeDark2,
	drawModeDark3,
	drawModeBlack,
	drawModeShadow1,
	drawModeShadow2,
	drawModeShadow3,
	drawModeFoggy1,
	drawModeFoggy2,
	drawModeFoggy3,
	drawModeFoggy4,
	drawModeGlow1,
	drawModeGlow2,
	drawModeGlow3,
	drawModeGlow4,
	drawModeInvisible,
	numDrawModes
};

void setMyDrawMode (struct onScreenPerson *moveMe, int h) {
	switch (h) {
		case drawModeTransparent3:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 0;
			moveMe->transparency = 64;
			break;
		case drawModeTransparent2:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 0;
			moveMe->transparency = 128;
			break;
		case drawModeTransparent1:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 0;
			moveMe->transparency = 192;
			break;
		case drawModeInvisible:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 0;
			moveMe->transparency = 254;
			break;
		case drawModeDark1:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 192;
			moveMe->transparency = 0;
			break;
		case drawModeDark2:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 128;
			moveMe->transparency = 0;
			break;
		case drawModeDark3:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 64;
			moveMe->transparency = 0;
			break;
		case drawModeBlack:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 255;
			moveMe->transparency = 0;
			break;
		case drawModeShadow1:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 255;
			moveMe->transparency = 64;
			break;
		case drawModeShadow2:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 255;
			moveMe->transparency = 128;
			break;
		case drawModeShadow3:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 255;
			moveMe->transparency = 192;
			break;
		case drawModeFoggy3:
			moveMe->r = moveMe->g = moveMe->b = 128;
			moveMe->colourmix = 192;
			moveMe->transparency = 0;
			break;
		case drawModeFoggy2:
			moveMe->r = moveMe->g = moveMe->b = 128;
			moveMe->colourmix = 128;
			moveMe->transparency = 0;
			break;
		case drawModeFoggy1:
			moveMe->r = moveMe->g = moveMe->b = 128;
			moveMe->colourmix = 64;
			moveMe->transparency = 0;
			break;
		case drawModeFoggy4:
			moveMe->r = moveMe->g = moveMe->b = 128;
			moveMe->colourmix = 255;
			moveMe->transparency = 0;
			break;
		case drawModeGlow3:
			moveMe->r = moveMe->g = moveMe->b = 255;
			moveMe->colourmix = 192;
			moveMe->transparency = 0;
			break;
		case drawModeGlow2:
			moveMe->r = moveMe->g = moveMe->b = 255;
			moveMe->colourmix = 128;
			moveMe->transparency = 0;
			break;
		case drawModeGlow1:
			moveMe->r = moveMe->g = moveMe->b = 255;
			moveMe->colourmix = 64;
			moveMe->transparency = 0;
			break;
		case drawModeGlow4:
			moveMe->r = moveMe->g = moveMe->b = 255;
			moveMe->colourmix = 255;
			moveMe->transparency = 0;
			break;
		default:
			moveMe->r = moveMe->g = moveMe->b = 0;
			moveMe->colourmix = 0;
			moveMe->transparency = 0;
			break;
	}
}



BOOL setCharacterWalkSpeed (int f, int objNum) {
	if (f <= 0) return FALSE;
	struct onScreenPerson * moveMe = findPerson (objNum);
	if (! moveMe) return FALSE;
	moveMe -> walkSpeed = f;
	return TRUE;
}

BOOL setPersonExtra (int thisNum, int extra) {
    struct onScreenPerson * thisPerson = findPerson(thisNum);
    if (thisPerson) {
        thisPerson -> extra = extra;
        if (extra & EXTRA_NOSCALE) thisPerson -> scale = 1;
        return TRUE;
    }
    return FALSE;
}


void setScale (short int h, short int d) {
	scaleHorizon = h;
	scaleDivide = d;
}

void setShown (BOOL h, int ob) {
	struct onScreenPerson * moveMe = findPerson (ob);
	if (moveMe) moveMe -> show = h;
}

void spinStep (struct onScreenPerson * thisPerson) {
	int diff = (thisPerson->angle + 360) - thisPerson->wantAngle;
	int eachSlice = thisPerson->spinSpeed ? thisPerson->spinSpeed : (360 / thisPerson->myPersona->numDirections);
	while (diff > 180) {
		diff -= 360;
	}

	if (diff >= eachSlice) {
		turnMeAngle(thisPerson, thisPerson->angle - eachSlice);
	} else if (diff <= -eachSlice) {
		turnMeAngle(thisPerson, thisPerson->angle + eachSlice);
	} else {
		turnMeAngle(thisPerson, thisPerson->wantAngle);
		thisPerson->spinning = FALSE;
	}
}


BOOL stopPerson (int o) {
    struct onScreenPerson * moveMe = findPerson(o);
    if (moveMe)
        if (moveMe -> continueAfterWalking) {
            abortFunction(moveMe -> continueAfterWalking);
            moveMe -> continueAfterWalking = NULL;
            moveMe -> walking = FALSE;
            moveMe -> spinning = FALSE;
            setFrames(moveMe, ANI_STAND);
            return TRUE;
        }
    return FALSE;
}


int timeForAnim (struct personaAnimation * fram) {
	int total = 0;
	for (int a = 0; a < fram -> numFrames; a ++) {
		total += fram -> frames[a].howMany;
	}
	return total;
}

void turnMeAngle (struct onScreenPerson * thisPerson, int direc) {
	int d = thisPerson -> myPersona -> numDirections;
	thisPerson -> angle = direc;
	direc += (180 / d) + 180 + thisPerson -> angleOffset;
	while (direc >= 360) direc -= 360;
	thisPerson -> direction = (direc * d) / 360;
}

BOOL turnPersonToFace (int thisNum, int direc) {
    struct onScreenPerson * thisPerson = findPerson(thisNum);
    if (thisPerson) {
        if (thisPerson -> continueAfterWalking) abortFunction(thisPerson -> continueAfterWalking);
        thisPerson -> continueAfterWalking = NULL;
        thisPerson -> walking = FALSE;
        thisPerson -> spinning = FALSE;
        turnMeAngle(thisPerson, direc);
        setFrames(thisPerson, (thisPerson == speech->currentTalker) ? ANI_TALK : ANI_STAND);
        return TRUE;
    }
    return FALSE;
}

BOOL walkMe (struct onScreenPerson * thisPerson, BOOL move) {
	float xDiff, yDiff, maxDiff, s;

	if (move == -1) move = TRUE;  // Initialize default value for move

	for (;;) {
		xDiff = thisPerson->thisStepX - thisPerson->x;
		yDiff = (thisPerson->thisStepY - thisPerson->y) * 2;
		s = thisPerson->scale * thisPerson->walkSpeed;
		if (s < 0.2) s = 0.2;

		maxDiff = (TF_abs(xDiff) >= TF_abs(yDiff)) ? TF_abs(xDiff) : TF_abs(yDiff);

		if (TF_abs(maxDiff) > s) {
			if (thisPerson->spinning) {
				spinStep(thisPerson);
				setFrames(thisPerson, ANI_WALK);
			}
			s = maxDiff / s;
			if (move)
				moveAndScale(thisPerson,
							 thisPerson->x + xDiff / s,
							 thisPerson->y + yDiff / (s * 2));
			return TRUE;
		}

		if (thisPerson->inPoly == -1) {
			if (thisPerson->directionWhenDoneWalking != -1) {
				thisPerson->wantAngle = thisPerson->directionWhenDoneWalking;
				thisPerson->spinning = TRUE;
				spinStep(thisPerson);
			}
			break;
		}
		if (!doBorderStuff(thisPerson)) break;
	}

	thisPerson->walking = FALSE;
	setFrames(thisPerson, ANI_STAND);
	moveAndScale(thisPerson,
				 thisPerson->walkToX,
				 thisPerson->walkToY);
	return FALSE;
}
