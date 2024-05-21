#include "floor.h"
#include "support/gcc8_c_support.h"

struct flor * currentFloor = NULL;

void noFloor () {
	currentFloor -> numPolygons = 0;
	currentFloor -> polygon = NULL;
	currentFloor -> vertex = NULL;
	currentFloor -> matrix = NULL;
}

BOOL initFloor () {
	currentFloor = AllocVec(sizeof(struct flor), MEMF_ANY);

    if(currentFloor == 0) {
        KPrintF("initFloor: Could not initialize Mem");
        return FALSE;
    }

	noFloor ();
	return TRUE;
}