#include <proto/dos.h>
#include <proto/exec.h>

#ifndef _ZBUFFER_H_
#define _ZBUFFER_H_

struct zBufferData {
	int width, height, topx, topy, yz;
	int layerId;		// 0: a panel of the room's z-buffer file; else the number addZBufferLayer gave it
	BYTE *bitplane;	
	struct zBufferData *nextPanel;
};

int addZBufferLayer (int x, int y, int width, int height, int yz);
BOOL removeZBufferLayer (int layerId);
void killZBuffer();
BOOL setZBuffer (unsigned int y);
void sortZPal (int *oldpal, int *newpal, int size);
void saveZBuffer(BPTR fp);
BOOL restoreZBuffer(BPTR fp);

#endif