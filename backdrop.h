#include <proto/exec.h>

extern unsigned int winWidth, winHeight, sceneWidth, sceneHeight;

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

void blankScreen(int x1, int y1, int x2, int y2);
void darkScreen ();
void killBackDrop ();
void killParallax ();
void loadBackDrop (int fileNum, int x, int y);
void mixBackDrop (int fileNum, int x, int y);
void nosnapshot ();
BOOL resizeBackdrop (int x, int y);
BOOL reserveBackdrop ();
BOOL restoreSnapshot (BPTR fp);
void saveSnapshot(BPTR fp);
void saveParallaxRecursive (struct parallaxLayer * me, BPTR fp);