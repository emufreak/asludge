#include "graphics.h"

#include "allfiles.h"
#include "support/gcc8_c_support.h"
#include "line.h"

extern int sceneWidth, sceneHeight;

void drawLine(int x1, int y1, int x2, int y2) {
	int x, y;
	BOOL backwards = FALSE;
	
	if (x1 < 0)  x1 = 0;
	if (y1 < 0)  y1 = 0;
	if (x2 < 0)  x2 = 0;
	if (y2 < 0)  y2 = 0;
	if (x1 > sceneWidth) x1 = sceneWidth - 1;
	if (x2 > sceneWidth) x2 = sceneWidth - 1;
	if (y1 > sceneHeight) y1 = sceneHeight - 1;
	if (y2 > sceneHeight) y2 = sceneHeight - 1;

	if (x1 > x2) {
		x = x2; 
		backwards = !backwards;
	} else x = x1;
		
	if (y1 > y2) {
		y = y2; 
		backwards = !backwards;
	} else y = y1;	
	
	int diffX = x2-x1;
    diffX = diffX < 0 ? diffX * -1 : diffX;
	int diffY = y2-y1;	
    diffY = diffY < 0 ? diffY * -1 : diffY;
	
	if (! diffX) {
		diffX = 1;
		if (x == sceneWidth - 1) x = sceneWidth -2;
	}
	if (! diffY) {
		diffY = 1;
		if (y == sceneHeight - 1) y = sceneHeight -2;
	}

    KPrintF("drawLine: Not implemented on Amiga"); //Amiga Todo: Implement 	
	
}
