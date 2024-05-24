#include <proto/exec.h>
#include <proto/dos.h>

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


void saveStatusBars (BPTR fp) {
	struct statusBar * viewLine = nowStatus -> firstStatusBar;

	put2bytes (nowStatus -> alignStatus, fp);
	putSigned (nowStatus -> litStatus, fp);
	put2bytes (nowStatus -> statusX, fp);
	put2bytes (nowStatus -> statusY, fp);

	FPutC (fp, nowStatus -> statusR);
	FPutC (fp, nowStatus -> statusG);
	FPutC (fp, nowStatus -> statusB);
	FPutC (fp, nowStatus -> statusLR);
	FPutC (fp, nowStatus -> statusLG);
	FPutC (fp, nowStatus -> statusLB);

	// Write what's being said
	while (viewLine) {
		FPutC (fp,1);
		writeString (viewLine -> text, fp);
		viewLine = viewLine -> next;
	}
	FPutC (fp,0);
}
