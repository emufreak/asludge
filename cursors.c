#include "custom.h"
#include "people.h"
#include "sludger.h"
#include "sprites.h"
#include "support/gcc8_c_support.h"

struct personaAnimation * mouseCursorAnim;
int mouseCursorFrameNum = 0;
int mouseCursorCountUp = 0;

extern struct inputType input;

void displayCursor () {

	
	if( mouseCursorAnim->theSprites)
	{		
		CstDisplayCursor( input.mouseX + 128 - mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].xhot,
			input.mouseY + 44 - mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].yhot,
			mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].height,
			(UBYTE *) mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].data);
	}
}

void pickAnimCursor (struct personaAnimation * pp) {
	deleteAnim (mouseCursorAnim);
	mouseCursorAnim = pp;
	mouseCursorFrameNum = 0;
	mouseCursorCountUp = 0;
}

void pasteCursor (int x, int y, struct personaAnimation * c) {

				//int fNumSign = myAnim -> frames[thisPerson -> frameNum].frameNum;
	
	struct sprite *spritetouse = &c->theSprites->bank.sprites[c->frames[0].frameNum];

	UWORD absx =  x - spritetouse->xhot;
	UWORD absy =  y - spritetouse->yhot;

	CstScaleSprite( spritetouse, (struct onScreenPerson *) NULL, absx, absy, BACKDROP);
}