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
	FLOAT x, y;
	int height, floaty, walkSpeed;
	FLOAT scale;
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

void animatePerson (int obj, struct personaAnimation * fram);
void animatePersonUsingPersona (int obj, struct persona * per);
BOOL addPerson(int x, int y, int objNum, struct persona *p);
struct personaAnimation * copyAnim (struct personaAnimation * orig);
void deleteAnim (struct personaAnimation * orig);
BOOL doBorderStuff (struct onScreenPerson * moveMe);
struct onScreenPerson * findPerson (int v);
BOOL floatCharacter (int f, int objNum);
BOOL forceWalkingPerson (int x, int y, int objNum, struct loadedFunction * func, int di);
BOOL handleClosestPoint (int * setX, int * setY, int * setPoly);
BOOL initPeople ();
void jumpPerson (int x, int y, int objNum);
void killAllPeople ();
void killMostPeople();
BOOL loadAnim (struct personaAnimation * p, BPTR fp);
BOOL loadCostume (struct persona * cossy, BPTR fp);
BOOL loadPeople (BPTR fp);
void makeSilent (struct onScreenPerson me);
BOOL makeWalkingPerson (int x, int y, int objNum, struct loadedFunction * func, int di);
void moveAndScale (struct onScreenPerson *me, FLOAT x, FLOAT y);
void removeOneCharacter (int i);
void rethinkAngle (struct onScreenPerson * thisPerson);
BOOL saveAnim (struct personaAnimation * p, BPTR fp);
BOOL saveCostume (struct persona * cossy, BPTR fp);
BOOL savePeople (BPTR fp);
BOOL setCharacterWalkSpeed (int f, int objNum);
void setMyDrawMode (struct onScreenPerson *moveMe, int h);
void setDrawMode (int h, int ob);
BOOL setPersonExtra (int thisNum, int extra);
void setScale (short int h, short int d);
void setShown (BOOL h, int ob);
void spinStep (struct onScreenPerson * thisPerson);
BOOL stopPerson (int o);
int TF_abs (int a);
int timeForAnim (struct personaAnimation * fram);
void turnMeAngle (struct onScreenPerson * thisPerson, int direc);
BOOL turnPersonToFace (int thisNum, int direc);
BOOL walkMe (struct onScreenPerson * thisPerson, BOOL move);
void moveAndScale (struct onScreenPerson *me, FLOAT x, FLOAT y);

#endif