#include "zbuffer.h"
#include "backdrop.h"
#include "custom.h"
#include "fileset.h"
#include "graphics.h"
#include "moreio.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"

#define EMULATOR

struct zBufferData *zBuffer;

void addZBufferLayer (int x, int y, int width, int height, int yz) {

	struct zBufferData *createthis = AllocVec(sizeof(struct zBufferData), MEMF_ANY);
	createthis->width = sceneWidth;
	createthis->height = sceneHeight;
	createthis->topx = 0;
	createthis->topy = 0;
	createthis->yz = yz;
	createthis->nextPanel = zBuffer;

	zBuffer = createthis;

	UWORD size = sceneWidth * sceneHeight / 8;	
	createthis->bitplane = AllocVec( size, MEMF_CHIP);
	CstCreateZBufferLayer (createthis->bitplane, x, y, width, height);

}

void killZBuffer () {
	struct zBufferData *zbuffercursor =  zBuffer;

	while(zbuffercursor) {
		struct zBufferData *deleteme = zbuffercursor;
		zbuffercursor = zbuffercursor->nextPanel;
		FreeVec(deleteme->bitplane);
		FreeVec(deleteme);
	}
	zBuffer = NULL;
}

BOOL setZBuffer (unsigned int y) {
	int x, n;
	ULONG stillToGo = 0;
	int yPalette[16], sorted[16], sortback[16];

	killZBuffer ();	
	
	if (! openFileFromNum (y)) return FALSE;
	
	if (FGetC (bigDataFile) != 'a' || FGetC (bigDataFile) != 's' || FGetC (bigDataFile) != 'z' || FGetC (bigDataFile) != 'b') 
	{ 
		 KPrintF("Not a Z-buffer file");
		 return FALSE;
	}

	UWORD numelements = FGetC(bigDataFile);

	UWORD size;
	UWORD count;

	zBuffer = AllocVec(sizeof(struct zBufferData), MEMF_ANY);

	struct zBufferData *currentitem;
	currentitem = zBuffer;

	while(numelements--)
	{		
		currentitem->width = get2bytes (bigDataFile);
		currentitem->height = get2bytes (bigDataFile);

		currentitem->topx = get2bytes (bigDataFile);
		currentitem->topy = get2bytes (bigDataFile);
		currentitem->yz = get2bytes (bigDataFile);

		UWORD size = currentitem->width * currentitem->height / 8;
		currentitem->bitplane = AllocVec( size, MEMF_CHIP);
		count = FRead( bigDataFile, currentitem->bitplane, 1, size);				

		if(numelements > 0) {
			currentitem->nextPanel = AllocVec(sizeof(struct zBufferData), MEMF_ANY);
			currentitem = currentitem->nextPanel;
		} else {
			currentitem->nextPanel = NULL;
		}
		#ifdef EMULATOR  
  			debug_register_bitmap(currentitem->bitplane, "zBuffer.bpl", currentitem->width, currentitem->height , 1, 0);
		#endif  
		
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