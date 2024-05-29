#include "objtypes.h"

struct screenRegion {
	int x1, y1, x2, y2, sX, sY, di;
	struct objectType * thisType;
	struct screenRegion * next;
};

void loadRegions (BPTR fp);
void saveRegions (BPTR fp);
void killAllRegions ();