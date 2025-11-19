#include "custom.h"
#include "floor.h"
#include "fileset.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"
#include "line.h"

struct flor * currentFloor = NULL;

BOOL closestPointOnLine (int * closestX, int * closestY, int x1, int y1, int x2, int y2, int xP, int yP) {
 	DOUBLE xDiff = x2 - x1;
	int yDiff = y2 - y1;

	DOUBLE m = xDiff * (xP - x1) + yDiff * (yP - y1);
	m /= (xDiff * xDiff) + (yDiff * yDiff);

	if (m < 0) {
		*closestX = x1;
		*closestY = y1;
	} else if (m > 1) {
		*closestX = x2;
		*closestY = y2;
	} else {
		DOUBLE tmp = m * xDiff;
		*closestX = (int) tmp;
		*closestX += x1;
		*closestY = m * yDiff;
		*closestY += y1;
		return TRUE;
	}
	return FALSE;
}

void drawFloor() {
    int i, j, nV;
    for (i = 0; i < currentFloor->numPolygons; i++) {
        nV = currentFloor->polygon[i].numVertices;
        if (nV > 1) {
            for (j = 1; j < nV; j++) {
                drawLine(currentFloor->vertex[currentFloor->polygon[i].vertexID[j - 1]].x,
                         currentFloor->vertex[currentFloor->polygon[i].vertexID[j - 1]].y,
                         currentFloor->vertex[currentFloor->polygon[i].vertexID[j]].x,
                         currentFloor->vertex[currentFloor->polygon[i].vertexID[j]].y);
            }
            drawLine(currentFloor->vertex[currentFloor->polygon[i].vertexID[0]].x,
                     currentFloor->vertex[currentFloor->polygon[i].vertexID[0]].y,
                     currentFloor->vertex[currentFloor->polygon[i].vertexID[nV - 1]].x,
                     currentFloor->vertex[currentFloor->polygon[i].vertexID[nV - 1]].y);
        }
    }
}

BOOL getMatchingCorners(struct floorPolygon *a, struct floorPolygon *b, int *cornerA, int *cornerB) {
    int sharedVertices = 0;
    int i, j;

    for (i = 0; i < a->numVertices; i++) {
        for (j = 0; j < b->numVertices; j++) {
            if (a->vertexID[i] == b->vertexID[j]) {
                if (sharedVertices++) {
                    *cornerB = a->vertexID[i];
                    return TRUE;
                } else {
                    *cornerA = a->vertexID[i];
                }
            }
        }
    }

    return FALSE;
}



void noFloor () {
	currentFloor -> numPolygons = 0;
	currentFloor -> polygon = NULL;
	currentFloor -> vertex = NULL;
	currentFloor -> matrix = NULL;
}

int inFloor (int x, int y) {
	KPrintF("inFloor started\n");
	int i, r = -1;

	for (i = 0; i < currentFloor -> numPolygons; i ++)
		if (pointInFloorPolygon (&currentFloor -> polygon[i], x, y))
			r = i;

	KPrintF("infloor finished\n");
	return r;
}

BOOL initFloor () {
	currentFloor = CstAllocVec(sizeof(struct flor), MEMF_ANY);

    if(currentFloor == 0) {
        KPrintF("initFloor: Could not initialize Mem");
        return FALSE;
    }

	noFloor ();
	return TRUE;
}

void killFloor () {
	for (int i = 0; i < currentFloor -> numPolygons; i ++) {
		CstFreeVec(currentFloor -> polygon[i].vertexID);
		CstFreeVec(currentFloor -> matrix[i]);
	}
	CstFreeVec(currentFloor -> polygon);
	currentFloor -> polygon = NULL;
	CstFreeVec(currentFloor -> vertex);
	currentFloor -> vertex = NULL;
	CstFreeVec(currentFloor -> matrix);
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

BOOL pointInFloorPolygon (struct floorPolygon * floorPoly, int x, int y) {
	int i = 0, j, c = 0;
	float xp_i, yp_i;
	float xp_j, yp_j;

	for (j = floorPoly->numVertices - 1; i < floorPoly->numVertices; j = i++) {

		xp_i = currentFloor->vertex[floorPoly->vertexID[i]].x;
		yp_i = currentFloor->vertex[floorPoly->vertexID[i]].y;
		xp_j = currentFloor->vertex[floorPoly->vertexID[j]].x;
		yp_j = currentFloor->vertex[floorPoly->vertexID[j]].y;

		if ((((yp_i <= y) && (y < yp_j)) || ((yp_j <= y) && (y < yp_i))) &&
			(x < (xp_j - xp_i) * (y - yp_i) / (yp_j - yp_i) + xp_i)) {

			c = !c;
		}
	}
	return c ? TRUE : FALSE;
}

BOOL setFloor (int fileNum) {
	int i, j;

	killFloor ();

	if (! openFileFromNum (fileNum)) return FALSE;

	// Find out how many polygons there are and reserve memory

	currentFloor -> originalNum = fileNum;
	currentFloor -> numPolygons = FGetC (bigDataFile);
	currentFloor -> polygon = CstAllocVec(  sizeof( struct floorPolygon) * currentFloor -> numPolygons, MEMF_ANY);
	if (!(currentFloor -> polygon)) {
		KPrintF("setFloor: Cannot allocate memory");
		return FALSE;
	}

	// Read in each polygon

	for (i = 0; i < currentFloor -> numPolygons; i ++) {

		// Find out how many vertex IDs there are and reserve memory

		currentFloor -> polygon[i].numVertices = FGetC (bigDataFile);
		currentFloor -> polygon[i].vertexID = CstAllocVec(sizeof (int) * currentFloor -> polygon[i].numVertices, MEMF_ANY);
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
	currentFloor -> vertex = CstAllocVec( sizeof(struct POINT)*i,MEMF_ANY);

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

	currentFloor -> matrix = CstAllocVec( sizeof(int) * currentFloor -> numPolygons, MEMF_ANY);
	int * * distanceMatrix = CstAllocVec( sizeof(int) * currentFloor -> numPolygons, MEMF_ANY);


	if (!(currentFloor -> matrix)) {
		KPrintF("setFloor: Cannot allocate memory");
		return FALSE;
	}

	for (i = 0; i < currentFloor -> numPolygons; i ++) {
		currentFloor -> matrix[i] = CstAllocVec( sizeof(int) * currentFloor -> numPolygons,MEMF_ANY);
		distanceMatrix        [i] = CstAllocVec( sizeof(int) * currentFloor -> numPolygons,MEMF_ANY);
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
		CstFreeVec(distanceMatrix [i]);
	}

	CstFreeVec(distanceMatrix);
	distanceMatrix = NULL;

	return TRUE;
}

void setFloorNull () {
	killFloor ();
	noFloor ();
}