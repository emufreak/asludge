#include <exec/types.h>
#include "people.h"
#include "sprites.h"

//destinationtypes
#define SCREEN 1
#define BACKDROP 2

struct CleanupQueue
{
    UWORD x;
    UWORD y;
    struct onScreenPerson *person;
    UWORD widthinwords;
    UWORD height;
    UWORD startxinbytes;
    UWORD starty;
    struct CleanupQueue *next;
};

void CstBlankScreen( int width, int height);
UWORD * CstCreateCopperlist( int width);
void CstDisplayCursor(UWORD x, UWORD y, UWORD height, UBYTE *spritedata);
void CstDrawBackdrop();
void CstFreeBuffer();
void CstFreeze();
void CstLoadBackdrop( BPTR fp, int x, int y);
BOOL CstReserveBackdrop(int width, int height);
void CstRestoreScreen();
void CstScaleSprite( struct sprite *single, struct onScreenPerson *person, WORD x, WORD y, UWORD destinationtype); 
void CstSetCl(UWORD *copperlist);
void CstSwapBuffer();