#include "custom.h"
#include "people.h"
#include "sprites.h"
#include "support/gcc8_c_support.h"

struct personaAnimation * mouseCursorAnim;
int mouseCursorFrameNum = 0;
int mouseCursorCountUp = 0;

void pickAnimCursor (struct personaAnimation * pp) {
	deleteAnim (mouseCursorAnim);
	mouseCursorAnim = pp;
	mouseCursorFrameNum = 0;
	mouseCursorCountUp = 0;
}

void pasteCursor (int x, int y, struct personaAnimation * c) {
	
	struct sprite *spritetouse = c->theSprites->bank.sprites;

	UWORD absx =  x - spritetouse->xhot;
	UWORD absy =  y - spritetouse->yhot;

	CstScaleSprite( spritetouse, absx, absy, BACKDROP);
}