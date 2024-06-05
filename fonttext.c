#include <proto/exec.h>

int fontHeight = 0, numFontColours, loadedFontNum;
char * fontOrderString = NULL;
short fontSpace = -1;

ULONG * fontTable = NULL;
unsigned int fontTableSize = 0;

int stringWidth (char * theText) {
	int a = 0;
    ULONG c;
	int xOff = 0;

	if (! fontTableSize) return 0;

	/*while (theText[a]) {
        c = u8_nextchar(theText, &a);
		xOff += theFont.sprites[fontInTable(c)].width + fontSpace;
	}Todo: Amigize this*/
	
	return xOff;
}