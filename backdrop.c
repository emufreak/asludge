#include "backdrop.h"
#include "graphics.h"
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

BOOL resizeBackdrop (int x, int y) {
    killBackDrop ();
	killParallax ();
	killZBuffer ();
	sceneWidth = x;
	sceneHeight = y;
	return TRUE;
}