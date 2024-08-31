#include <proto/dos.h>

#include "backdrop.h"
#include "colours.h"
#include "custom.h"
#include "fileset.h"
#include "graphics.h"
#include "line.h"
#include "moreio.h"
#include "people.h"
#include "region.h"
#include "sludger.h"
#include "support/gcc8_c_support.h"
#include "tga.h"
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
int viewportHeight = 256;
int viewportWidth = 320;
int viewportOffsetX = 0, viewportOffsetY = 0;
unsigned int snapshotTextureName = 0;

void blankScreen(int x1, int y1, int x2, int y2) {
	CstBlankScreen(x2, y2);
}

void darkScreen () {
	KPrintF("darkScreen: Amiga: Graphics Display not implemented yet."); //Todo: Amigize this
}

void drawBackDrop () {

	//setPrimaryColor(1.0, 1.0, 1.0, 1.0);

	//if (parallaxStuff) {
	//Amiga todo: Maybe some parallaxstuff here?
	//}
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
	CstFreeBuffer();
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
	if (! openFileFromNum (fileNum)) {
		KPrintF("Can't load overlay image");
		return;
	}
	CstLoadBackdrop( bigDataFile, x, y);
	finishAccess ();
	
}

BOOL loadHSI (BPTR fp, int x, int y, BOOL reserve) 
{

	unsigned int t1, t2, n;
	unsigned short c;
	UBYTE * target;
	ULONG transCol = reserve ? -1 : 63519;
	unsigned int picWidth;
	unsigned int picHeight;
	unsigned int realPicWidth, realPicHeight;
	long file_pointer = Seek(fp, 0, OFFSET_CURRENT);

	int fileIsPNG = TRUE;

	// Is this a PNG file?

	unsigned char tmp[10];
	ULONG bytes_read = FRead( fp, tmp, 1, 8); //Get Current position

	if (bytes_read != 8) {
		KPrintF("Reading error in loadHSI.\n");
	}	

    if ( tmp[0] == 0x89 && tmp[1] == 0x50 && tmp[2] == 0x4E && tmp[3] == 0x47 && tmp[4] == 0x0D && tmp[5] == 0x0A && tmp[6] == 0x1A && tmp[7] == 0x0A ) {
		// PNG not supported
		KPrintF("loadHSI: Png not supported");
		return FALSE;
	} else {
		// No, it's old-school HSI
		fileIsPNG = FALSE;
		Seek( fp, file_pointer, OFFSET_BEGINNING);

		picWidth = realPicWidth = get2bytes (fp);
		picHeight = realPicHeight = get2bytes (fp);
	}

	if (x < 0 || x + realPicWidth > sceneWidth || y < 0 || y + realPicHeight > sceneHeight) {
		return FALSE;
	}		

	
	for (t2 = 0; t2 < realPicHeight; t2 ++) {
		t1 = 0;
		while (t1 < realPicWidth) {
			c = (unsigned short) get2bytes (fp);
			if (c & 32) {
				n = FGetC (fp) + 1;
				c -= 32;
			} else {
				n = 1;
			}
			while (n --) {
				target = backdropTexture + 4*picWidth*t2 + t1*4;
				if (c == transCol || c == 2015) {
					target[0] = 0;
					target[1] = 0;
					target[2] = 0;
					target[3] = 0;
				} else {
					target[0] = redValue(c);
					target[1] = greenValue(c);
					target[2] = blueValue(c);
					target[3] = 255;
				}
				t1++;
			}
		}
	}

	
	backdropExists = TRUE;
	return TRUE;
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

BOOL reserveBackdrop () {	
	cameraX = 0;
	cameraY = 0;
	
	return CstReserveBackdrop(sceneWidth, sceneHeight);
}

BOOL resizeBackdrop (int x, int y) {
    killBackDrop ();
	killParallax ();
	killZBuffer ();
	sceneWidth = x;
	sceneHeight = y;
	KPrintF("resizeBackdrop: Reserving new Backdrop");
	return reserveBackdrop();
	KPrintF("resizeBackdrop: Backdrop reserved");	
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