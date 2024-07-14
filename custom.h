#include <exec/types.h>

void CstBlankScreen( int width, int height);
UWORD * CstCreateCopperlist( int width);
void CstFreeBuffer();
void CstSludgeDisplay();
BOOL CstReserveBackdrop(int width, int height);
void CstSetCl(UWORD *copperlist);
void CstSwapGraphics();