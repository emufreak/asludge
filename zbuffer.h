#include <proto/dos.h>
#include <proto/exec.h>

#ifndef _ZBUFFER_H_
#define _ZBUFFER_H_

struct zBufferData {
	int width, height, topx, topy, yz;
	BYTE *bitplane;	
	struct zBufferData *nextPanel;
};

void addZBufferLayer (int x, int y, int width, int height, int yz);
void killZBuffer();
BOOL setZBuffer (unsigned int y);
void sortZPal (int *oldpal, int *newpal, int size);


#endif