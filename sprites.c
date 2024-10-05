#include <exec/types.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include "custom.h"
#include "sludger.h"
#include "sprbanks.h"
#include "sprites.h"
#include "fileset.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"

extern int cameraX, cameraY;
extern struct inputType input;


void forgetSpriteBank (struct loadedSpriteBank * forgetme)
{			
	struct spriteBank *spritebanktoforget = &forgetme->bank;
	
	for (int i = 0; i < spritebanktoforget->total; i++) {
		struct sprite *cursprite = &spritebanktoforget->sprites[i];		
		if(cursprite->data) {		
			FreeVec(cursprite->data);			
		}
	}
	FreeVec(spritebanktoforget->sprites);
	FreeVec(spritebanktoforget);
	
	struct loadedSpriteBank *precedingbank = allLoadedBanks;
	
	while(precedingbank->next->ID != forgetme->ID && precedingbank != NULL)
	{
		precedingbank = precedingbank->next;
	}	

	if(precedingbank)
	{
		//Forget element in the middle of the chain or the last one
		precedingbank->next = forgetme->next;
		FreeVec( forgetme);
	} else
	{
		//Forget first element in the chain
		allLoadedBanks = allLoadedBanks->next;
		FreeVec( forgetme);
	}	
}

BOOL loadSpriteBank (int fileNum, struct spriteBank *loadhere, BOOL isFont) {
	int i, tex_num, total, picwidth, picheight, howmany = 0, startIndex = 0;
	int *totalwidth, *maxheight;
	int numTextures = 0;
	UBYTE *data;

	if (!openFileFromNum(fileNum)) {
		KPrintF("loadSpriteBank: Can't open sprite bank / font");
		return FALSE;
	}

	loadhere->isFont = isFont;

	get2bytes(bigDataFile); // Ignore first 2 bytes
	loadhere->type = FGetC(bigDataFile);
	total = get2bytes(bigDataFile);

	if (total <= 0) {
		KPrintF("loadSpriteBank: No sprites in bank or invalid sprite bank file\n");
		return FALSE;
	}
	if (loadhere->type > 3) {
		KPrintF("loadSpriteBank: Unsupported sprite bank file format\n");
		return FALSE;
	}

	loadhere->total = total;
	loadhere->sprites = AllocVec(sizeof(struct sprite) * total, MEMF_ANY);
	if (!loadhere->sprites) return FALSE;	
	
	startIndex = 1;

	for (i = 0; i < total; i++) {
		UWORD width = get2bytes(bigDataFile);
		loadhere->sprites[i].width = width;
		loadhere->sprites[i].height = get2bytes(bigDataFile);
		loadhere->sprites[i].xhot = get2bytes(bigDataFile);
		loadhere->sprites[i].yhot = get2bytes(bigDataFile);

		UWORD size;
		
		switch( loadhere->type) 
		{
			case 1: //Sprite
				size = 4*loadhere->sprites[i].height+8;
				break;
			case 2: //Bob
				size = loadhere->sprites[i].width / 8 * loadhere->sprites[i].height * 6;
				break;
			case 3: //Font
				UWORD widthextra = loadhere->sprites[i].width % 16 > 0 ? 2 : 0;
				size = ((loadhere->sprites[i].width  / 16) * 2 + widthextra) * loadhere->sprites[i].height;
				break;
		}

		loadhere->sprites[i].data = AllocVec(sizeof(UWORD) * size, MEMF_CHIP);
		UWORD count = FRead(bigDataFile, loadhere->sprites[i].data, 2, size / 2);
		if (!count) {
			KPrintF("loadSpriteBank: Cannot read sprite Data from File\n");
			return FALSE;
		}
	}

	finishAccess ();

	return TRUE;
}

BOOL scaleSprite (struct sprite *single, struct onScreenPerson * thisPerson, BOOL mirror) 
{
	UWORD x =  (UWORD) thisPerson->x - single->xhot;
	UWORD y =  (UWORD) thisPerson->y - single->yhot;			

	CstScaleSprite( single, thisPerson, (WORD) x, (WORD) y,SCREEN);

	UWORD x1, y1, x2, y2;

	if (thisPerson -> extra & EXTRA_FIXTOSCREEN) {
		if (single->xhot < 0)
			x1 = x - (int)(mirror ? single->width - single->xhot : single->xhot+1);
		else
			x1 = x - (int)(mirror ? single->width - (single->xhot+1) : single->xhot);
		
		y1 = y - (single->yhot - thisPerson->floaty);
		x2 = x1 + single->width;
		y2 = y1 + single->height;
	} else {
		x -= cameraX;
		y -= cameraY;
		if (single->xhot < 0)
			x1 = x - (int)(mirror ? single->width - single->xhot : single->xhot+1);
		else
			x1 = x - (int)(mirror ? single->width - (single->xhot+1) : single->xhot);
		
		y1 = y - (single->yhot - thisPerson->floaty);
		x2 = x1 + single->width;
		y2 = y1 + single->height;
	}

	if (input.mouseX >= x1 && input.mouseX <= x2 && input.mouseY >= y1 && input.mouseY <= y2) {
		return TRUE;
	}
	return FALSE;
}