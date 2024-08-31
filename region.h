#include "objtypes.h"

struct screenRegion {
	int x1, y1, x2, y2, sX, sY, di;
	struct objectType * thisType;
	struct screenRegion * next;
};

BOOL addScreenRegion(int x1, int y1, int x2, int y2, int sX, int sY, int di, int objectNum);
void getOverRegion ();
struct screenRegion * getRegionForObject (int obj);
void killAllRegions ();
void loadRegions (BPTR fp);
void removeScreenRegion (int objectNum);
void saveRegions (BPTR fp);
void showBoxes ();