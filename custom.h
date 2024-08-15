#include <exec/types.h>
#include "sprites.h"

void CstBlankScreen( int width, int height);
UWORD * CstCreateCopperlist( int width);
void CstDrawBackdrop();
void CstFreeBuffer();
void CstLoadBackdrop( BPTR fp, int x, int y);
BOOL CstReserveBackdrop(int width, int height);
void CstRestoreScreen();
void CstScaleSprite( struct sprite *single, WORD x, WORD y);
void CstSetCl(UWORD *copperlist);
void CstSwapBuffer();