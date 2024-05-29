#include "floor.h"
#include "fileset.h"
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

void killFloor () {
	for (int i = 0; i < currentFloor -> numPolygons; i ++) {
		FreeVec(currentFloor -> polygon[i].vertexID);
		FreeVec(currentFloor -> matrix[i]);
	}
	FreeVec(currentFloor -> polygon);
	currentFloor -> polygon = NULL;
	FreeVec(currentFloor -> vertex);
	currentFloor -> vertex = NULL;
	FreeVec(currentFloor -> matrix);
	currentFloor -> matrix = NULL;
}

BOOL polysShareSide (struct floorPolygon a, struct floorPolygon b) {
	int sharedVertices = 0;
	int i, j;

	for (i = 0; i < a.numVertices; i ++) {
		for (j = 0; j < b.numVertices; j ++) {
			if (a.vertexID[i] == b.vertexID[j]) {
				if (sharedVertices ++) return TRUE;
			}
		}
	}

	return FALSE;
}

BOOL setFloor (int fileNum) {
	int i, j;

	killFloor ();

	if (! openFileFromNum (fileNum)) return FALSE;

	// Find out how many polygons there are and reserve memory

	currentFloor -> originalNum = fileNum;
	currentFloor -> numPolygons = FGetC (bigDataFile);
	currentFloor -> polygon = AllocVec(  sizeof( struct floorPolygon) * currentFloor -> numPolygons, MEMF_ANY);
	if (!(currentFloor -> polygon)) {
		KPrintF("setFloor: Cannot allocate memory");
		return FALSE;
	}

	// Read in each polygon

	for (i = 0; i < currentFloor -> numPolygons; i ++) {

		// Find out how many vertex IDs there are and reserve memory

		currentFloor -> polygon[i].numVertices = FGetC (bigDataFile);
		currentFloor -> polygon[i].vertexID = AllocVec(sizeof (int) * currentFloor -> polygon[i].numVertices, MEMF_ANY);
		if (!(currentFloor -> polygon[i].vertexID)) {
			KPrintF("setFloor: Cannot allocate memory");
			return FALSE;
		}

		// Read in each vertex ID

		for (j = 0; j < currentFloor -> polygon[i].numVertices; j ++) {
			currentFloor -> polygon[i].vertexID[j] = get2bytes (bigDataFile);
		}
	}

	// Find out how many vertices there are and reserve memory

	i = get2bytes (bigDataFile);
	currentFloor -> vertex = AllocVec( sizeof(struct POINT)*i,MEMF_ANY);

	if (!(currentFloor -> vertex)) {
		KPrintF("setFloor: Cannot allocate memory");
		return FALSE;
	}

	for (j = 0; j < i; j ++) {
		currentFloor -> vertex[j].x = get2bytes (bigDataFile);
		currentFloor -> vertex[j].y = get2bytes (bigDataFile);
	}

	finishAccess ();

	// Now build the movement martix

	currentFloor -> matrix = AllocVec( sizeof(int) * currentFloor -> numPolygons, MEMF_ANY);
	int * * distanceMatrix = AllocVec( sizeof(int) * currentFloor -> numPolygons, MEMF_ANY);


	if (!(currentFloor -> matrix)) {
		KPrintF("setFloor: Cannot allocate memory");
		return FALSE;
	}

	for (i = 0; i < currentFloor -> numPolygons; i ++) {
		currentFloor -> matrix[i] = AllocVec( sizeof(int) * currentFloor -> numPolygons,MEMF_ANY);
		distanceMatrix        [i] = AllocVec( sizeof(int) * currentFloor -> numPolygons,MEMF_ANY);
		if (!(currentFloor -> matrix[i])) { 
			KPrintF("setFloor: Cannot allocate memory");
			return FALSE;
		}
		for (j = 0; j < currentFloor -> numPolygons; j ++) {
			currentFloor -> matrix[i][j] = -1;
			distanceMatrix        [i][j] = 10000;
		}
	}

	for (i = 0; i < currentFloor -> numPolygons; i ++) {
		for (j = 0; j < currentFloor -> numPolygons; j ++) {
			if (i != j) {
				if (polysShareSide (currentFloor -> polygon[i], currentFloor -> polygon[j])) {
					currentFloor -> matrix[i][j] = j;
					distanceMatrix        [i][j] = 1;
				}
			} else {
				currentFloor -> matrix[i][j] = -2;
				distanceMatrix        [i][j] = 0;
			}
		}
	}

	BOOL madeChange;
	int lookForDistance = 0;

	do {
		lookForDistance ++;
//		debugMatrix ();
		madeChange = FALSE;
		for (i = 0; i < currentFloor -> numPolygons; i ++) {
			for (j = 0; j < currentFloor -> numPolygons; j ++) {
				if (currentFloor -> matrix[i][j] == -1) {

					// OK, so we don't know how to get from i to j...
					for (int d = 0; d < currentFloor -> numPolygons; d ++) {
						if (d != i && d != j) {
							if (currentFloor -> matrix[i][d] == d &&
								currentFloor -> matrix[d][j] >= 0 &&
								distanceMatrix        [d][j] <= lookForDistance) {

								 currentFloor -> matrix[i][j] = d;
								 distanceMatrix		  [i][j] = lookForDistance + 1;
								 madeChange = TRUE;
							}
						}
					}
				}
			}
		}
	} while (madeChange);

	for (i = 0; i < currentFloor -> numPolygons; i ++) {
		FreeVec(distanceMatrix [i]);
	}

	FreeVec(distanceMatrix);
	distanceMatrix = NULL;	

	return TRUE;
}

void setFloorNull () {
	killFloor ();
	noFloor ();
}