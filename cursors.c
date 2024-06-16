#include "people.h"
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
	KPrintF("pasteCursor: Amiga Graphics Display not implemented yet."); //Todo: Amigize this	
}