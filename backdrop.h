#include <proto/exec.h>

struct parallaxLayer {
	UBYTE * texture;
	unsigned int textureName;
	int width, height, speedX, speedY;
	BOOL wrapS, wrapT;
	unsigned short fileNum, fractionX, fractionY;
	int cameraX, cameraY;
	struct parallaxLayer * next;
	struct parallaxLayer * prev;
};

void killBackDrop ();
void killParallax ();
BOOL resizeBackdrop (int x, int y);
BOOL reserveBackdrop ();
void saveSnapshot(BPTR fp);
void saveParallaxRecursive (struct parallaxLayer * me, BPTR fp);