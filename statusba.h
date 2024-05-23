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

void initStatusBar ();
void positionStatus (int x, int y);