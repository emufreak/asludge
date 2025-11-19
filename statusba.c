#include <proto/exec.h>
#include <proto/dos.h>

#include "allfiles.h"
#include "custom.h"
#include "graphics.h"
#include "moreio.h"
#include "statusba.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"

struct statusStuff mainStatus;
struct statusStuff * nowStatus = & mainStatus;

void addStatusBar () {
	struct statusBar * newStat = CstAllocVec(sizeof(struct statusBar), MEMF_ANY);
	if (!newStat) {
		newStat -> next = nowStatus -> firstStatusBar;
		newStat -> text = copyString ("");
		nowStatus -> firstStatusBar = newStat;
	}
}

void clearStatusBar () {
	struct statusBar * stat = nowStatus -> firstStatusBar;
	struct statusBar * kill;
	nowStatus -> litStatus = -1;
	while (stat) {
		kill = stat;
		stat = stat -> next;
		CstFreeVec(kill -> text);
		CstFreeVec(kill);
	}
	nowStatus -> firstStatusBar = NULL;
}

void initStatusBar () {
	mainStatus.firstStatusBar = NULL;
	mainStatus.alignStatus = IN_THE_CENTRE;
	mainStatus.litStatus = -1;
	mainStatus.statusX = 10;
	mainStatus.statusY = winHeight - 15;
	//statusBarColour (255, 255, 255); Amiga Todo: Amigize this
	//statusBarLitColour (255, 255, 128); Amiga Todo: Amigize this
}

void killLastStatus () {
	if (nowStatus -> firstStatusBar) {
		struct statusBar * kill = nowStatus -> firstStatusBar;
		nowStatus -> firstStatusBar = kill -> next;
		CstFreeVec(kill -> text);
		CstFreeVec(kill);
	}
}


BOOL loadStatusBars (BPTR fp) {
	clearStatusBar ();

	nowStatus -> alignStatus = get2bytes (fp);
	nowStatus -> litStatus = getSigned (fp);
	nowStatus -> statusX = get2bytes (fp);
	nowStatus -> statusY = get2bytes (fp);

	nowStatus -> statusR = FGetC (fp);
	nowStatus -> statusG = FGetC (fp);
	nowStatus -> statusB = FGetC (fp);
	nowStatus -> statusLR = FGetC (fp);
	nowStatus -> statusLG = FGetC (fp);
	nowStatus -> statusLB = FGetC (fp);

	//setFontColour (verbLinePalette, nowStatus -> statusR, nowStatus -> statusG, nowStatus -> statusB); Amiga Todo: Amigize this
	//setFontColour (litVerbLinePalette, nowStatus -> statusLR, nowStatus -> statusLG, nowStatus -> statusLB); Amiga Todo: Amigize this
	// Read what's being said
	struct statusBar * * viewLine = & (nowStatus -> firstStatusBar);
	struct statusBar * newOne;
	while (FGetC (fp)) {
		newOne = CstAllocVec( sizeof( struct statusBar),MEMF_ANY);
		if (!newOne) {
			KPrintF("loadStatusBars: Cannot allocate memory");
			return FALSE;
		}
		newOne -> text = readString (fp);
		newOne -> next = NULL;
		(* viewLine) = newOne;
		viewLine = & (newOne -> next);
	}
	return TRUE;
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

void setLitStatus (int i) {
	nowStatus -> litStatus = i;
}

void setStatusBar (char * txt) {
	if (nowStatus -> firstStatusBar) {
		CstFreeVec(nowStatus -> firstStatusBar -> text);
		nowStatus -> firstStatusBar -> text = copyString (txt);
	}
}

const char * statusBarText () {
	if (nowStatus -> firstStatusBar) {
		return nowStatus -> firstStatusBar -> text;
	} else {
		return "";
	}
}