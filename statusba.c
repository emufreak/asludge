#include <proto/exec.h>

#include "allfiles.h"
#include "graphics.h"
#include "statusba.h"


struct statusStuff mainStatus;
struct statusStuff * nowStatus = & mainStatus;

void initStatusBar () {
	mainStatus.firstStatusBar = NULL;
	mainStatus.alignStatus = IN_THE_CENTRE;
	mainStatus.litStatus = -1;
	mainStatus.statusX = 10;
	mainStatus.statusY = winHeight - 15;
	//statusBarColour (255, 255, 255); Amiga Todo: Amigize this
	//statusBarLitColour (255, 255, 128); Amiga Todo: Amigize this
}

void positionStatus (int x, int y) {
	nowStatus -> statusX = x;
	nowStatus -> statusY = y;
}