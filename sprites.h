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
	struct sprite *steps;		// copies at other sizes, one per step of the room's range (custom_scale.c), or NULL
};

void forgetSpriteBank (struct loadedSpriteBank * forgetme);
BOOL scaleSprite (struct sprite *single, struct onScreenPerson * thisPerson, BOOL mirror);

#endif