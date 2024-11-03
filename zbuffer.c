#include "zbuffer.h"
#include "backdrop.h"
#include "fileset.h"
#include "graphics.h"
#include "moreio.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"

struct zBufferData zBuffer;

void killZBuffer () {	
}

BOOL setZBuffer (unsigned int y) {
	int x, n;
	ULONG stillToGo = 0;
	int yPalette[16], sorted[16], sortback[16];

	killZBuffer ();

	if (! openFileFromNum (y)) return FALSE;
	if (FGetC (bigDataFile) != 'a' && FGetC (bigDataFile) != 's' && FGetC (bigDataFile) != 'z' && FGetC (bigDataFile) != 'b') 
	{
		 KPrintF("Not a Asludge Z-buffer file. Remember the Amiga Version is using its own format.");
		 return FALSE;
	}

	zBuffer.width = get2bytes (bigDataFile);
	zBuffer.height = get2bytes (bigDataFile);
	zBuffer.topx = get2bytes (bigDataFile);
	zBuffer.topx = get2bytes (bigDataFile);

	UWORD size = zBuffer.width/8*zBuffer.height;
	zBuffer.bitplane = AllocVec( size, MEMF_CHIP);

	UWORD count = FRead( bigDataFile, zBuffer.bitplane, 1, size);
	if(count == 0) {
		KPrintF("Error loading zBuffer");
		return FALSE;
	}

	finishAccess ();
	
	return TRUE;
}

void sortZPal (int *oldpal, int *newpal, int size) {
	int i, tmp;

	for (i = 0; i < size; i ++) {
		newpal[i] = i;
	}

	if (size < 2) return;		
		
	for (i = 1; i < size; i ++) {
		if (oldpal[newpal[i]] < oldpal[newpal[i-1]]) {
			tmp = newpal[i];
			newpal[i] = newpal[i-1];
			newpal[i-1] = tmp;
			i = 0;
		}
	}
}