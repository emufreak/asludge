#ifndef OBJTYPES_H
#define OBJTYPES_H

#include <proto/exec.h>

struct combination {
	int withObj, funcNum;
};

struct objectType {
	char * screenName;
	int objectNum;
	struct objectType * next;
	unsigned char r, g, b;
	int numCom;
	int speechGap, walkSpeed, wrapSpeech, spinSpeed;
	unsigned short int flags;
	struct combination * allCombis;
	BOOL hasHitBox;							// setHitBox: a person of this object also takes the mouse over the rectangle below
	short hitX1, hitY1, hitX2, hitY2;		// (offsets from the person's position, on the screen; both ends belong to the box)
};

int getCombinationFunction (int withThis, int thisObject);
void setObjectHitBox (int objectNum, int x1, int y1, int x2, int y2);
struct objectType * findObjectType (int i);
BOOL initObjectTypes ();
struct objectType * loadObjectType (int i);
void removeObjectType (struct objectType * oT);
struct objectType * loadObjectRef (BPTR fp);
void saveObjectRef (struct objectType * r, BPTR fp);


#endif