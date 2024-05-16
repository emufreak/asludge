#include <proto/exec.h>

#include "people.h"

struct personaAnimation * makeNullAnim () {

	struct personaAnimation * newAnim	= AllocVec(sizeof(struct personaAnimation),MEMF_ANY);
    if(newAnim == 0) {
     	KPrintF("makeNullAnim: Can't reserve Memory\n");
        return NULL;    
    }  

	newAnim -> theSprites		= NULL;
	newAnim -> numFrames		= 0;
	newAnim -> frames			= NULL;
	return newAnim;
}
