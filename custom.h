#include <exec/types.h>
#include "sprites.h"

//destinationtypes
#define SCREEN 1
#define BACKDROP 2

void CstBlankScreen( int width, int height);
UWORD * CstCreateCopperlist( int width);
void CstDrawBackdrop();
void CstFreeBuffer();
void CstLoadBackdrop( BPTR fp, int x, int y);
BOOL CstReserveBackdrop(int width, int height);
void CstRestoreScreen();
void CstScaleSprite( struct sprite *single, WORD x, WORD y, UWORD destinationtype);
void CstSetCl(UWORD *copperlist);
void CstSwapBuffer();