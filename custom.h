#include <exec/types.h>

void CstBlankScreen( int width, int height);
UWORD * CstCreateCopperlist( int width);
void CstFreeBuffer();
void CstLoadBackdrop( BPTR fp, int x, int y);
void CstSludgeDisplay();
BOOL CstReserveBackdrop(int width, int height);
void CstSetCl(UWORD *copperlist);
void CstSwapBuffer();