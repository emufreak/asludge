#ifndef __SLUDGE_STATUSBA_H__
#define __SLUDGE_STATUSBA_H__

struct statusBar {
	char * text;
	struct statusBar * next;
};

struct statusStuff {
	struct statusBar * firstStatusBar;
	unsigned short alignStatus;
	int litStatus;
	int statusX, statusY;
	int statusR, statusG, statusB;
	int statusLR, statusLG, statusLB;
};

void addStatusBar ();
void clearStatusBar ();
void initStatusBar ();
void killLastStatus ();
BOOL loadStatusBars (BPTR fp);
void positionStatus (int x, int y);
void saveStatusBars (BPTR fp);
void setLitStatus (int i);
void setStatusBar (char * txt);
const char * statusBarText ();

#endif 