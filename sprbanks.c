#include <proto/exec.h>

#include "sprbanks.h"
#include "support/gcc8_c_support.h"

struct loadedSpriteBank * allLoadedBanks = NULL;

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
	returnMe = AllocVec(sizeof(struct loadedSpriteBank), MEMF_ANY);
	// KPrintF("loadBankForAnim: No existing sprite bank with ID %d\n", ID);
	if (returnMe) {
		returnMe->ID = ID;
		if (loadSpriteBank(ID, &(returnMe->bank), FALSE)) {
			returnMe->timesUsed = 1;
			returnMe->next = allLoadedBanks;
			allLoadedBanks = returnMe;
			KPrintF("loadBankForAnim: New sprite bank created OK\n");
			return returnMe;
		} else {
			KPrintF("loadBankForAnim: I guess I couldn't load the sprites...\n");
			FreeVec(returnMe);
			return NULL;
		}
	} else return NULL;
}
