#include "sprites.h"

struct loadedSpriteBank {
	int ID, timesUsed;
	struct spriteBank bank;
	struct loadedSpriteBank * next;
};