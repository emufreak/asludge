#include <proto/dos.h>

#include "backdrop.h"
#include "graphics.h"
#include "moreio.h"
#include "sludger.h"
#include "zbuffer.h"

extern struct inputType input;

UBYTE * backdropTexture = NULL;

unsigned int sceneWidth, sceneHeight;

unsigned int backdropTextureName = 0;
BOOL backdropExists = FALSE;
struct parallaxLayer * parallaxStuff = NULL;
extern int cameraX, cameraY;
extern float cameraZoom;
int lightMapNumber;
unsigned int snapshotTextureName = 0;

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
