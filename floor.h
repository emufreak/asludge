#include <proto/exec.h>

struct floorPolygon {
	int numVertices;
	int * vertexID;
};

struct POINT {
	int x; int y;
};

struct flor {
	int originalNum;
	struct POINT * vertex;
	int numPolygons;
	struct floorPolygon * polygon;
	int * * matrix;
};

BOOL closestPointOnLine (int * closestX, int * closestY, int x1, int y1, int x2, int y2, int xP, int yP);
void drawFloor();
BOOL getMatchingCorners(struct floorPolygon *a, struct floorPolygon *b, int *cornerA, int *cornerB);
void noFloor();
BOOL pointInFloorPolygon (struct floorPolygon * floorPoly, int x, int y);
BOOL polysShareSide (struct floorPolygon a, struct floorPolygon b);
void killFloor ();
int inFloor (int x, int y);
BOOL setFloor (int fileNum);
void setFloorNull();
BOOL initFloor ();
