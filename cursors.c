#include "people.h"

struct personaAnimation * mouseCursorAnim;
int mouseCursorFrameNum = 0;
int mouseCursorCountUp = 0;

void pickAnimCursor (struct personaAnimation * pp) {
	deleteAnim (mouseCursorAnim);
	mouseCursorAnim = pp;
	mouseCursorFrameNum = 0;
	mouseCursorCountUp = 0;
}