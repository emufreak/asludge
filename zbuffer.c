#include "zbuffer.h"
#include "graphics.h"

struct zBufferData zBuffer;

void killZBuffer () {
	if (zBuffer.tex) {
		deleteTextures (1, &zBuffer.texName);
		zBuffer.texName = 0;
        FreeVec(zBuffer.tex);
		zBuffer.tex = NULL;
	}
	zBuffer.numPanels = 0;
	zBuffer.originalNum =0;
}