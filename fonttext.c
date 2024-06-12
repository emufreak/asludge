
#include <proto/exec.h>

#include "stringy.h"
#include "fonttext.h"
#include "support/gcc8_c_support.h"

int fontHeight = 0, numFontColours, loadedFontNum;
char * fontOrderString = NULL;
short fontSpace = -1;

ULONG * fontTable = NULL;
unsigned int fontTableSize = 0;

BOOL isInFont (char * theText) {
	KPrintF("isInFont: Not implemented yet on Amiga"); //Todo: Implement on Amiga
	return FALSE;
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

BOOL loadFont (int filenum, const char * charOrder, int h) {
	/*-int a = 0;
	ULONG c;

	FreeVec(fontOrderString);
	fontOrderString = copyString(charOrder);*/

	//forgetSpriteBank(theFont);
	KPrintF("loadFont: Not implemented on Amiga");	

	/*loadedFontNum = filenum;

	fontTableSize = 0;
	while (charOrder[a]) {
        c = u8_nextchar(charOrder, &a);
		if (c > fontTableSize) fontTableSize = c;
	}
	fontTableSize++;

	FreeVec(fontTable);
	fontTable = AllocVec(sizeof(ULONG) * fontTableSize, MEMF_ANY);
	if (!fontTable) return FALSE;

	for (a = 0; a < fontTableSize; a++) {
		fontTable[a] = 0;
	}
	a = 0;
	int i = 0;
	while (charOrder[a]) {
        c = u8_nextchar(charOrder, &a);
		fontTable[c] = i;
		i++;
	}

	/*if (!loadSpriteBank(filenum, theFont, TRUE)) {
		fatal("Can't load font");
		return FALSE;
	}*/

	//numFontColours = theFont.myPalette.total;*/
	//fontHeight = h;
	return TRUE;
}
