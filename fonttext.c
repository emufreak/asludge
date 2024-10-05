
#include <proto/exec.h>

#include "stringy.h"
#include "fonttext.h"
#include "sprites.h"
#include "sprbanks.h"
#include "support/gcc8_c_support.h"

int fontHeight = 0, numFontColours, loadedFontNum;
char * fontOrderString = NULL;
short fontSpace = -1;

ULONG * fontTable = NULL;
unsigned int fontTableSize = 0;
struct loadedSpriteBank *theFont;

BOOL isInFont (char * theText) {
	KPrintF("isInFont: Not implemented yet on Amiga"); //Todo: Implement on Amiga
	return FALSE;
}

BOOL loadFont (int filenum, char * charOrder, int h) {
	unsigned int a = 0;
	ULONG c;

	if( fontOrderString) FreeVec(fontOrderString);
	fontOrderString = copyString(charOrder);
	if( theFont) forgetSpriteBank(theFont);
	theFont = AllocVec( sizeof(struct loadedSpriteBank), MEMF_ANY );

	loadedFontNum = filenum;

	fontTableSize = 0;
	char *tmp = charOrder;
	while (*tmp) {        
		if (*tmp > (UBYTE) fontTableSize) fontTableSize = *tmp;
		*tmp++;
	}
	fontTableSize++;

	if( fontTable) FreeVec(fontTable);
	fontTable = AllocVec(sizeof(ULONG) * fontTableSize, MEMF_ANY);
	if (!fontTable) return FALSE;

	for (a = 0;  a < fontTableSize; a++) {
		fontTable[a] = 0;
	}
	a = 0;
	int i = 0;
	tmp = charOrder;
	while (*tmp) {
		fontTable[*tmp++] = i;
		i++;
	}

	if (!loadSpriteBank(filenum, &theFont->bank, TRUE)) {
		KPrintF("loadFont: Can't load font");
		return FALSE;
	}
	fontHeight = h;
	return TRUE;
}

void pasteStringToBackdrop (char * theText, int xOff, int y) {
	/*struct sprite * mySprite;
	int a=0;
	ULONG c;

	if (! fontTableSize) return;

	xOff += fontSpace >> 1;
	while (theText[a]) {
		mySprite = & theFont->sprites[fontInTable(*theText++)];
		//pasteSpriteToBackDrop (xOff, y, * mySprite);
		xOff += mySprite -> width + fontSpace;

	}*/
}

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

