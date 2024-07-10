#include <proto/exec.h>
#include "graphics.h"
#include "support/gcc8_c_support.h"

unsigned int winWidth, winHeight;
extern int specialSettings;
struct textureList *firstTexture = NULL;
BOOL NPOT_textures = TRUE;

void deleteTextures(unsigned int n,  unsigned int * textures)
{
	if (firstTexture == NULL) {
		//debugOut("Deleting texture while list is already empty.\n");
	} else {
		for (unsigned int i = 0; i < n; i++) {
			BOOL found = FALSE;
			struct textureList *list = firstTexture;
			if (list->name == textures[i]) {
				found = TRUE;
				firstTexture = list->next;
				FreeVec(list);
				continue;
			}

			while (list->next) {
				if (list->next->name == textures[i]) {
					found = TRUE;
					struct textureList *deleteMe = list->next;
					list->next = list->next->next;
					FreeVec(deleteMe);
					break;
				}
				list = list->next;
			}
		}
	}
}

void setGraphicsWindow(BOOL fullscreen) {
	KPrintF("setGraphicsWindow: Not implemented on Amiga yet"); //TODO
}
