#include <proto/exec.h>

BOOL isInFont (char * theText);
void pasteStringToBackdrop(char *theText, int xOff, int y);
int stringWidth (char * theText);
BOOL loadFont (int filenum, char * charOrder, int h);