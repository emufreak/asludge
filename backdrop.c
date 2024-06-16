#include <proto/dos.h>

#include "backdrop.h"
#include "graphics.h"
#include "line.h"
#include "moreio.h"
#include "sludger.h"
#include "support/gcc8_c_support.h"
#include "zbuffer.h"

extern struct inputType input;

UBYTE * backdropTexture = NULL;

unsigned int sceneWidth, sceneHeight;

unsigned int backdropTextureName = 0;
BOOL backdropExists = FALSE;
struct parallaxLayer * parallaxStuff = NULL;
extern int cameraX, cameraY;
extern FLOAT cameraZoom;
int lightMapNumber;
int viewportHeight, viewportWidth;
int viewportOffsetX = 0, viewportOffsetY = 0;
unsigned int snapshotTextureName = 0;

void blankScreen(int x1, int y1, int x2, int y2) {
	if (y1 < 0) y1 = 0;
	if (x1 < 0) x1 = 0;
	if (x2 > (int)sceneWidth) x2 = (int)sceneWidth;
	if (y2 > (int)sceneHeight) y2 = (int)sceneHeight;

	int picWidth = x2 - x1;
	int picHeight = y2 - y1;

	//setPixelCoords(TRUE);

	int xoffset = 0;
	while (xoffset < picWidth) {
		int w = (picWidth - xoffset < viewportWidth) ? picWidth - xoffset : viewportWidth;

		int yoffset = 0;
		while (yoffset < picHeight) {
			int h = (picHeight - yoffset < viewportHeight) ? picHeight - yoffset : viewportHeight;
		
			KPrintF("Amiga: Graphics Display not implemented yet."); //Todo: Amigize this

			yoffset += viewportHeight;
		}
		xoffset += viewportWidth;
	}

	//setPixelCoords(FALSE);
}

void darkScreen () {
	KPrintF("Amiga: Graphics Display not implemented yet."); //Todo: Amigize this
}

void drawHorizontalLine (unsigned int x1, unsigned int y, unsigned int x2) {
	drawLine (x1, y, x2, y);
}

void drawVerticalLine (unsigned int x, unsigned int y1, unsigned int y2) {
	drawLine (x, y1, x, y2);
}

void hardScroll (int distance) {
   	KPrintF("Amiga: Function not implemented."); //Todo: Amigize this
}


void killBackDrop () {
	deleteTextures (1, &backdropTextureName);
	backdropTextureName = 0;
	backdropExists = FALSE;
}

void killParallax () {
	while (parallaxStuff) {

		struct parallaxLayer * k = parallaxStuff;
		parallaxStuff = k->next;

		// Now kill the image
		deleteTextures (1, &k->textureName);
		if( k->texture) FreeVec(k->texture);
		if( k) FreeVec(k);
		k = NULL;
	}
}

void loadBackDrop (int fileNum, int x, int y) {

	KPrintF("loadBackDrop: Amiga Graphics Display not implemented yet."); //Todo: Amigize this	
}

BOOL loadParallax (unsigned short v, unsigned short fracX, unsigned short fracY) {
	KPrintF("loadParallax: Not implemented yet."); //Amiga Todo: Amigize this	

}

void mixBackDrop (int fileNum, int x, int y) {
	KPrintF("mixBackdrop: Amiga Graphics Display not implemented yet."); //Todo: Amigize this	
}

void nosnapshot () {
	deleteTextures (1, &snapshotTextureName);
	snapshotTextureName = 0;
}

BOOL resizeBackdrop (int x, int y) {
    killBackDrop ();
	killParallax ();
	killZBuffer ();
	sceneWidth = x;
	sceneHeight = y;
	return TRUE;
}

BOOL restoreSnapshot (BPTR fp) {
	unsigned int picWidth = get2bytes (fp);
	unsigned int picHeight = get2bytes (fp);

	//Todo: Amigize this?

	return TRUE;
}

void saveParallaxRecursive (struct parallaxLayer * me, BPTR fp) {
	if (me) {
		saveParallaxRecursive (me -> next, fp);
		FPutC (fp, 1);
		put2bytes (me->fileNum, fp);
		put2bytes (me ->fractionX, fp);
		put2bytes (me->fractionY, fp);
	}
}

BOOL snapshot () {

	KPrintF("snapshot: Not yet implemented on Amiga"); //Todo
	return TRUE;
}