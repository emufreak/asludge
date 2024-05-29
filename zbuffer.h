#include <proto/dos.h>
#include <proto/exec.h>

#ifndef _ZBUFFER_H_
#define _ZBUFFER_H_

struct zBufferData {
	int width, height;
//	bool loaded;
	int numPanels;
	int panel[16];
	int originalNum;

	UBYTE * tex;
	unsigned int texName;
};

void killZBuffer();
BOOL setZBuffer (unsigned int y);
void sortZPal (int *oldpal, int *newpal, int size);


#endif