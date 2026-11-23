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
	short hitMarginX, hitMarginY;			// setHitMargin: the mouse is over a person of this object this many pixels outside the frame of its picture (0: only inside it)
};

int getCombinationFunction (int withThis, int thisObject);
void setObjectHitMargin (int objectNum, int x, int y);
struct objectType * findObjectType (int i);
BOOL initObjectTypes ();
struct objectType * loadObjectType (int i);
void removeObjectType (struct objectType * oT);
struct objectType * loadObjectRef (BPTR fp);
void saveObjectRef (struct objectType * r, BPTR fp);


#endif