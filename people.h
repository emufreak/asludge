#ifndef __SLUDGE_PEOPLE_H__
#define __SLUDGE_PEOPLE_H__

#include <proto/exec.h>
#include <proto/dos.h>

struct animFrame {
	int frameNum, howMany;
	int noise;
};

#define EXTRA_FRONT			1
#define EXTRA_FIXEDSIZE		2
#define EXTRA_NOSCALE		2	// Alternative name
#define EXTRA_NOZB			4
#define EXTRA_FIXTOSCREEN	8
#define EXTRA_NOLITE		16
#define EXTRA_NOREMOVE		32
#define EXTRA_RECTANGULAR	64

struct personaAnimation {
	struct loadedSpriteBank * theSprites;
	struct animFrame * frames;
	int numFrames;
};

struct persona {
	struct personaAnimation * * animation;
	int numDirections;
};

struct onScreenPerson {
	float x, y;
	int height, floaty, walkSpeed;
	float scale;
	struct onScreenPerson * next;
	int walkToX, walkToY, thisStepX, thisStepY, inPoly, walkToPoly;
	BOOL walking, spinning;
	struct loadedFunction * continueAfterWalking;
	struct personaAnimation * myAnim;
	struct personaAnimation * lastUsedAnim;
	struct persona * myPersona;
	int frameNum, frameTick, angle, wantAngle, angleOffset;
	BOOL show;
	int direction, directionWhenDoneWalking;
	struct objectType * thisType;
	int extra, spinSpeed;
	unsigned char r,g,b,colourmix,transparency;
};

struct personaAnimation * makeNullAnim ();

struct personaAnimation * copyAnim (struct personaAnimation * orig);
void deleteAnim (struct personaAnimation * orig);
BOOL initPeople ();
void killAllPeople ();
BOOL loadAnim (struct personaAnimation * p, BPTR fp);
BOOL loadCostume (struct persona * cossy, BPTR fp);
BOOL loadPeople (BPTR fp);
void makeSilent (struct onScreenPerson me);
BOOL saveAnim (struct personaAnimation * p, BPTR fp);
BOOL saveCostume (struct persona * cossy, BPTR fp);
BOOL savePeople (BPTR fp);

#endif