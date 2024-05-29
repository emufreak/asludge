#include "zbuffer.h"
#include "backdrop.h"
#include "fileset.h"
#include "graphics.h"
#include "support/gcc8_c_support.h"

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

BOOL setZBuffer (unsigned int y) {
	int x, n;
	ULONG stillToGo = 0;
	int yPalette[16], sorted[16], sortback[16];

	killZBuffer ();

	zBuffer.originalNum = y;
	if (! openFileFromNum (y)) return FALSE;
	if (FGetC (bigDataFile) != 'S' && FGetC (bigDataFile) != 'z' && FGetC (bigDataFile) != 'b') 
	{
		 KPrintF("Not a Z-buffer file");
		 return FALSE;
	}

	switch (FGetC (bigDataFile)) {
		case 0:
		zBuffer.width = 640;
		zBuffer.height = 480;
		break;
		
		case 1:
		zBuffer.width = get2bytes (bigDataFile);
		zBuffer.height = get2bytes (bigDataFile);
		break;
		
		default:
		KPrintF("Extended Z-buffer format not supported in this version of the SLUDGE engine");
		return FALSE;
	}
	if (zBuffer.width != sceneWidth || zBuffer.height != sceneHeight) {
		char tmp[256];
		sprintf (tmp, "Z-w: %d Z-h:%d w: %d, h:%d", zBuffer.width, zBuffer.height, sceneWidth, sceneHeight);
		KPrintF("Z-buffer width and height don't match scene width and height", tmp);
		return FALSE;
	}
		
	zBuffer.numPanels = FGetC (bigDataFile);
	for (y = 0; y < zBuffer.numPanels; y ++) {
		yPalette[y] = get2bytes (bigDataFile);
	}
	sortZPal (yPalette, sorted, zBuffer.numPanels);
	for (y = 0; y < zBuffer.numPanels; y ++) {
		zBuffer.panel[y] = yPalette[sorted[y]];
		sortback[sorted[y]] = y; 
	}
	
	int picWidth = sceneWidth;
	int picHeight = sceneHeight;

	zBuffer.tex = AllocVec(picHeight*picWidth,MEMF_ANY);
	if (!zBuffer.tex) {
		KPrintF("setZBuffer: Cannot allocate memory");
		return FALSE;
	}

	for (y = 0; y < sceneHeight; y ++) {
		for (x = 0; x < sceneWidth; x ++) {
			if (stillToGo == 0) {
				n = FgetC (bigDataFile);
				stillToGo = n >> 4;
				if (stillToGo == 15) stillToGo = get2bytes (bigDataFile) + 16l;
				else stillToGo ++;
				n &= 15;
			}
			zBuffer.tex[y*picWidth + x] = sortback[n]*16;
			stillToGo --;
		}
	}

	finishAccess ();
	
	return TRUE;
}

void sortZPal (int *oldpal, int *newpal, int size) {
	int i, tmp;

	for (i = 0; i < size; i ++) {
		newpal[i] = i;
	}

	if (size < 2) return;		
		
	for (i = 1; i < size; i ++) {
		if (oldpal[newpal[i]] < oldpal[newpal[i-1]]) {
			tmp = newpal[i];
			newpal[i] = newpal[i-1];
			newpal[i-1] = tmp;
			i = 0;
		}
	}
}