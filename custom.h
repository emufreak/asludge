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
void CstFadeIn();
void CstFrameStats( BOOL overran);
void CstLeakDump( void);        /* LEAKTRACK builds only: printConsole ("LEAKS") */
void CstCountFrame();
void CstFadeOut();
void CstStartFadeIn( int count);
void CstScaleChanged( int horizon, int divide);
void CstBuildScaledSprites();
void CstForgetScaledSprites( struct loadedSpriteBank *bank);
struct sprite *CstSpriteForPerson( struct sprite *single, struct onScreenPerson *person);
void CstStartFadeOut( int count, int r, int g, int b);
void CstSetFadeMask( int mask);
BOOL CstSetCopperSplit( int y1, int y2, int reg, int r, int g, int b);
void CstClearCopperSplits();
void CstRefreshSplits();
void CstApplySplits();
BOOL CstFillArea( int x1, int y1, int x2, int y2, int colour);
int CstSaveArea( int x1, int y1, int x2, int y2);
BOOL CstRestoreArea( int number);
void CstFreeBuffer();
void CstFreeVec( APTR memptr);
void CstFreeze();
void CstLoadBackdrop( BPTR fp, int x, int y, int loadpalette);
void CstPasteChar( struct sprite *single, WORD x, WORD y);
BOOL CstReserveBackdrop(int width, int height);
void CstRestoreScreen();
void CstPeopleBegin();          /* A7.1: a pass starts to record the persons it draws */
void CstDrawPeople();           /* A7.1: the persons are blitted after the restore, unless nothing changed since the buffer was drawn */
void CstPictureChanged();       /* A7.1: a z-buffer panel or a sprite bank was made or freed: the persons are drawn again */
void CstSaveSnapshot(BPTR fp);
BOOL CstRestoreSnapshot(BPTR fp);
void CstScaleSprite( struct sprite *single, struct onScreenPerson *person, WORD x, WORD y, UWORD destinationtype);
void CstSetCl(UWORD *copperlist);
void CstSwapBuffer();
void CstHwSpriteBegin();
BOOL CstHwSprite( UWORD *block, int height, int x, int y);
void CstHwSpriteSwap();
void CstUnfreeze();
void CstInitVBlankHandler();
void CstVBlankHandler();
