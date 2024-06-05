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

void clearStatusBar ();
void initStatusBar ();
BOOL loadStatusBars (BPTR fp);
void positionStatus (int x, int y);
void saveStatusBars (BPTR fp);
const char * statusBarText ();