#include <exec/types.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include "custom.h"
#include "sprbanks.h"
#include "sprites.h"
#include "fileset.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"


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
	int i, tex_num, total, picwidth, picheight, spriteBankVersion = 0, howmany = 0, startIndex = 0;
	int *totalwidth, *maxheight;
	int numTextures = 0;
	UBYTE *data;

	if (!openFileFromNum(fileNum)) {
		KPrintF("loadSpriteBank: Can't open sprite bank / font");
		return FALSE;
	}

	loadhere->isFont = isFont;

	get2bytes(bigDataFile); // Ignore first 2 bytes
	spriteBankVersion = FGetC(bigDataFile);
	total = get2bytes(bigDataFile);

	if (total <= 0) {
		KPrintF("loadSpriteBank: No sprites in bank or invalid sprite bank file\n");
		return FALSE;
	}
	if (spriteBankVersion > 3) {
		KPrintF("loadSpriteBank: Unsupported sprite bank file format\n");
		return FALSE;
	}

	loadhere->total = total;
	loadhere->sprites = AllocVec(sizeof(struct sprite) * total, MEMF_ANY);
	if (!loadhere->sprites) return FALSE;	
	
	startIndex = 1;

	for (i = 0; i < total; i++) {
		loadhere->sprites[i].width = get2bytes(bigDataFile);
		loadhere->sprites[i].height = get2bytes(bigDataFile);
		loadhere->sprites[i].xhot = get2bytes(bigDataFile);
		loadhere->sprites[i].yhot = get2bytes(bigDataFile);

		// ToDo Load Data
		UWORD size = loadhere->sprites[i].width / 8 * loadhere->sprites[i].height * 6;
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

	CstScaleSprite( single, (WORD) thisPerson->x, (WORD) thisPerson->y,SCREEN);
	//KPrintF("scaleSprite: This function is not implemented yet");
}