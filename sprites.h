#ifndef CSPRITES_H
#define CSPRITES_H

#include <proto/dos.h>
#include "people.h"
#include "sprbanks.h"

struct sprite {
	int width, height, xhot, yhot;
	int tex_x;
	int texNum;
	UWORD *data;
	//unsigned char * data;
};

void forgetSpriteBank (struct loadedSpriteBank * forgetme);
BOOL scaleSprite (struct sprite *single, struct onScreenPerson * thisPerson, BOOL mirror);

#endif