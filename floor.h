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

void noFloor();
BOOL polysShareSide (struct floorPolygon a, struct floorPolygon b);
void killFloor ();
BOOL setFloor (int fileNum);
void setFloorNull();
BOOL initFloor ();
