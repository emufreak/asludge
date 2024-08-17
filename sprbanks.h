#ifndef __SLUDGE_LOADESPRITEBANK_H__
#define __SLUDGE_LOADESPRITEBANK_H__

#include "sprites.h"

struct spriteBank {
	int total;
	int type;
	struct sprite * sprites;
	BOOL isFont;
};

struct loadedSpriteBank {
	int ID, timesUsed;
	struct spriteBank bank;
	struct loadedSpriteBank * next;
};

extern struct loadedSpriteBank * allLoadedBanks;
struct loadedSpriteBank * loadBankForAnim (int ID);

#endif 