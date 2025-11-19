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

APTR CstAllocVec( ULONG bytesize, ULONG requirements );
void CstBlankScreen( int x1, int y1, int x2, int y2);
UWORD * CstCreateCopperlist( int width);
void CstCreateZBufferLayer (BYTE *zbufferdata, UWORD x, UWORD y, UWORD width, UWORD height);
void CstDisplayCursor(UWORD x, UWORD y, UWORD height, UBYTE *spritedata);
void CstDrawBackdrop();
void CstFreeBuffer();
void CstFreeVec( APTR memptr);
void CstFreeze();
void CstLoadBackdrop( BPTR fp, int x, int y);
void CstPasteChar( struct sprite *single, WORD x, WORD y);
BOOL CstReserveBackdrop(int width, int height);
void CstRestoreScreen();
void CstScaleSprite( struct sprite *single, struct onScreenPerson *person, WORD x, WORD y, UWORD destinationtype);
void CstSetCl(UWORD *copperlist);
void CstSwapBuffer();
void CstUnfreeze();
void CstInitVBlankHandler();
void CstVBlankHandler();
