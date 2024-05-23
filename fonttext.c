#include <proto/exec.h>

int fontHeight = 0, numFontColours, loadedFontNum;
char * fontOrderString = NULL;
short fontSpace = -1;

ULONG * fontTable = NULL;
unsigned int fontTableSize = 0;