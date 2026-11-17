#include <proto/exec.h>

#include "custom.h"
#include "sprbanks.h"
#include "support/gcc8_c_support.h"

struct loadedSpriteBank * allLoadedBanks = NULL;

/* To log what is in chip RAM as sprite banks, one line per bank: the file number, the sprites, the bytes of their pixels and how many
   animations use it. A game asks for it with printConsole ("BANKS") (A5: which banks stay loaded after their room is left). */
void CstLogBanks (void) {
	long total = 0;
	for (struct loadedSpriteBank *bank = allLoadedBanks; bank; bank = bank->next) {
		long bytes = 0;
		for (int i = 0; i < bank->bank.total; i++) {
			struct sprite *s = &bank->bank.sprites[i];
			if (s->data) bytes += bank->bank.type == 1 ? (long) (4 * s->height + 8) : (long) (s->width >> 3) * s->height * 6;
		}
		total += bytes;
		KPrintF("BANK: file %ld, %ld sprites, %ld bytes, used by %ld%s", (long) bank->ID, (long) bank->bank.total, bytes, (long) bank->timesUsed, bank->scaled ? ", scaled" : "");
	}
	KPrintF("BANK: total %ld bytes", total);
}

struct loadedSpriteBank * loadBankForAnim (int ID) {
	// KPrintF("loadBankForAnim: Looking for sprite bank with ID %d\n", ID);
	struct loadedSpriteBank * returnMe = allLoadedBanks;
	while (returnMe) {
		if (returnMe->ID == ID) {
			// KPrintF("loadBankForAnim: Found existing sprite bank with ID %d\n", returnMe->ID);
			returnMe->timesUsed++;
			return returnMe;
		}
		returnMe = returnMe->next;
	}
	returnMe = CstAllocVec(sizeof(struct loadedSpriteBank), MEMF_ANY);
	// KPrintF("loadBankForAnim: No existing sprite bank with ID %d\n", ID);
	if (returnMe) {
		returnMe->ID = ID;
		returnMe->scaled = FALSE;
		if (loadSpriteBank(ID, (struct spriteBank *) &returnMe->bank)) {
			returnMe->timesUsed = 1;
			returnMe->next = allLoadedBanks;
			allLoadedBanks = returnMe;
			//KPrintF("loadBankForAnim: New sprite bank created OK\n");
			return returnMe;
		} else {
			//KPrintF("loadBankForAnim: I guess I couldn't load the sprites...\n");
			CstFreeVec(returnMe);
			return NULL;
		}
	} else return NULL;
}
