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
};

BOOL initObjectTypes ();
void removeObjectType (struct objectType * oT);
struct objectType * loadObjectRef (BPTR fp);
void saveObjectRef (struct objectType * r, BPTR fp);


#endif