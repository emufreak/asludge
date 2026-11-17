/* Hardware sprites for persons (A6, E13): a person whose animation comes from a type 1 sprite bank is drawn by Denise, not by the
   blitter. The bank's frames are ready-made sprite blocks (two control words, one pair of words a row, two zero words), 16 pixels wide
   and two colours: the values 1 and 2 of the palette of whichever pair of sprites the person gets.

   Channels: sprite 0 is the mouse pointer (CstDisplayCursor) and sprite 1 is left free, sprites 2 to 7 are for persons, one for each
   person that is drawn in a pass, in the order they are drawn. A person that finds no channel free is not shown.

   A person's block is copied into a buffer of the channel, because the frames of a bank are shared by every person that uses the bank
   (the six wisps of the Graves play one clip) and each has its own position in the control words; the copy also cuts the sprite to the
   picture (the frame below it is not for a sprite). There are two sets of buffers and the Copper list's pointers are switched to the
   finished set at the buffer swap (CstSwapBuffer, where the bitplane pointers change), so that a sprite is shown with the picture it
   was drawn for and a buffer is never written while the beam reads it. */

#include <exec/types.h>
#include <proto/exec.h>

#include "custom.h"
#include "zbuffer.h"
#include "support/gcc8_c_support.h"

#define CSTHWFIRST 2                    /* the first sprite for persons */
#define CSTHWCHANNELS 6                 /* sprites 2 to 7 */
#define CSTHWMAXROWS 64                 /* a frame taller than this is cut */
#define CSTHWWORDS (2 + 2 * CSTHWMAXROWS + 2)
#define CSTHWX0 128                     /* the horizontal start of the picture's first column (as the pointer, custom_input / CstDisplayCursor) */
#define CSTHWY0 44                      /* the vertical start of its first line (DIWSTRT) */
#define CSTHWBOTTOM 168                 /* the first picture line that sprites do not draw: the top of the picture frame */
#define CSTHWWIDTH 16
#define CSTSCREENWIDTH 320

extern UWORD *CstClCursor;

extern struct zBufferData *zBuffer;
extern unsigned int winWidth;
#define CSTFRONTPANEL 1000              /* custom.c: a panel with this cut-off or more is the frame, the toolbar or a text box, which hide what is behind them */

static UWORD *CstHwSpriteBuffer[2][CSTHWCHANNELS];
static UWORD *CstHwSpriteNull = NULL;         /* a sprite that ends at once, for the channels that are not used */
static int CstHwSpriteUsed[2];                /* the channels a set holds */
static int CstHwSpriteBack = 0;               /* the set that drawPeople fills; the other one is on the screen */
static BOOL CstHwSpriteReady = FALSE;
static int CstHwSpriteLogged = -1;            /* the number of sprites the last swap showed: a change is logged */

static BOOL CstHwSpriteInit() {
  if( CstHwSpriteReady) return TRUE;
  CstHwSpriteNull = CstAllocVec( 8, MEMF_CHIP | MEMF_CLEAR);
  if( !CstHwSpriteNull) return FALSE;
  for(int set=0; set<2; set++) {
    for(int k=0; k<CSTHWCHANNELS; k++) {
      CstHwSpriteBuffer[set][k] = CstAllocVec( CSTHWWORDS * 2, MEMF_CHIP | MEMF_CLEAR);
      if( !CstHwSpriteBuffer[set][k]) return FALSE;
    }
    CstHwSpriteUsed[set] = 0;
  }
  CstHwSpriteReady = TRUE;
  return TRUE;
}

/* Is the pixel (x, y) of the picture on a front panel that a script added (addZBufferLayer: a text box, the dialog panel)? */
static BOOL CstHwSpriteOnFrontPanel( int x, int y) {
  if( x < 0 || x >= (int) winWidth) return FALSE;
  for(struct zBufferData *panel = zBuffer; panel; panel = panel->nextPanel) {
    if( panel->layerId == 0 || panel->yz < CSTFRONTPANEL || panel->width != (int) winWidth || panel->topx != 0) continue;   /* (layer 0: the room's own panels, the foliage: a sprite is in front of them) */
    if( y < panel->topy || y >= panel->topy + panel->height) continue;
    if( panel->bitplane[(y - panel->topy) * (panel->width >> 3) + (x >> 3)] & (0x80 >> (x & 7))) return TRUE;
  }
  return FALSE;
}

/* A box is in front of a wisp as it is in front of a person (the z-buffer layer of the box): a sprite cannot be hidden by pixels, so it
   is hidden as a whole when the middle or a corner of its ink's rectangle (the window less 3 pixels all round) is under a box. The room's
   own panels (the foliage, the frame) do not count: the wisp is in front of the foliage (the user accepted it) and is cut at the frame's top. */
static BOOL CstHwSpriteCovered( int x, int y, int rows) {
  return CstHwSpriteOnFrontPanel( x + 8, y + rows / 2) || CstHwSpriteOnFrontPanel( x + 3, y + 3) || CstHwSpriteOnFrontPanel( x + 12, y + 3)
      || CstHwSpriteOnFrontPanel( x + 3, y + rows - 4) || CstHwSpriteOnFrontPanel( x + 12, y + rows - 4);
}

/* The pass begins: nobody has a channel in the set that is filled now. */
void CstHwSpriteBegin() {
  if( CstHwSpriteReady) CstHwSpriteUsed[CstHwSpriteBack] = 0;
}

/* To give the person with the sprite `single`, whose top left corner is at (x, y) on the picture, a channel: the control words for its
   place and its rows that lie on the picture. Says whether it has a channel or has nothing to show (off the picture); FALSE means that
   there was no channel for it. */
BOOL CstHwSprite( UWORD *block, int height, int x, int y) {
  if( !CstHwSpriteInit()) return FALSE;
  int channel = CstHwSpriteUsed[CstHwSpriteBack];
  if( channel >= CSTHWCHANNELS) return FALSE;
  if( height > CSTHWMAXROWS) height = CSTHWMAXROWS;

  int first = y < 0 ? -y : 0;                                       /* the rows that lie on the picture */
  int last = height;
  if( y + last > CSTHWBOTTOM) last = CSTHWBOTTOM - y;
  if( first >= last || x + CSTHWWIDTH <= 0 || x >= CSTSCREENWIDTH) return TRUE;
  int rows = last - first;
  if( CstHwSpriteCovered( x, y + first, rows)) return TRUE;                /* a text box (or the frame) covers it: it is not shown */

  int vstart = y + first + CSTHWY0;
  int vstop = vstart + rows;
  int hstart = x + CSTHWX0;
  UWORD *to = CstHwSpriteBuffer[CstHwSpriteBack][channel];
  UWORD *from = block + 2 + 2 * first;
  to[0] = (UWORD) (((vstart & 0xff) << 8) | ((hstart >> 1) & 0xff));
  to[1] = (UWORD) (((vstop & 0xff) << 8) | (((vstart >> 8) & 1) << 2) | (((vstop >> 8) & 1) << 1) | (hstart & 1));
  ULONG *dest = (ULONG *) (to + 2);
  ULONG *source = (ULONG *) from;
  for(int i=0; i<rows; i++) *dest++ = *source++;                   /* (a block is longword aligned: chip RAM from CstAllocVec, 4 + 4 * row bytes in) */
  *dest = 0;                                                        /* the end of the sprite */
  CstHwSpriteUsed[CstHwSpriteBack] = channel + 1;
  return TRUE;
}

/* The buffer swap: the set that was filled in the last pass goes to the screen with the picture that was drawn with it. */
void CstHwSpriteSwap() {
  if( !CstHwSpriteReady) return;
  int shown = CstHwSpriteBack;
  CstHwSpriteBack ^= 1;
  if( CstHwSpriteUsed[shown] != CstHwSpriteLogged) {
    CstHwSpriteLogged = CstHwSpriteUsed[shown];
    KPrintF("HW: %ld sprites on the screen", (long) CstHwSpriteLogged);
  }
  for(int k=0; k<CSTHWCHANNELS; k++) {
    ULONG ptr = (ULONG) (k < CstHwSpriteUsed[shown] ? CstHwSpriteBuffer[shown][k] : CstHwSpriteNull);
    UWORD *entry = CstClCursor + 4 * (CSTHWFIRST + k);
    entry[1] = (UWORD) (ptr >> 16);
    entry[3] = (UWORD) (ptr & 0xffff);
  }
}
