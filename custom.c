#define CSTCOPSIZE 512
#define CSTBPL1HIGH 28*2+1
#define CSTBPL1LOW 29*2+1
#define CSTBPL2HIGH 30*2+1
#define CSTBPL2LOW 31*2+1
#define CSTBPL3HIGH 32*2+1
#define CSTBPL3LOW 33*2+1
#define CSTBPL4HIGH 34*2+1
#define CSTBPL4LOW 35*2+1
#define CSTBPL5HIGH 36*2+1
#define CSTBPL5LOW 37*2+1
#define CSTMAXWIDTHSPRITE 208
#define CSTMAXHEIGHTSPRITE 200
//#define EMULATOR

#include <exec/execbase.h>
#include <exec/types.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <hardware/custom.h>
#include <hardware/intbits.h>

#include "custom.h"
#include "moreio.h"
#include "gamefile.h"
#include "support/gcc8_c_support.h"
#include "zbuffer.h"
#include "profile.h"

void CstRefreshSplits();
static UWORD CstClampChannel( int level);
static int CstSplitsInList = 0;      /* splits written into the Copper list at the moment */

extern int varfadeOut;
extern int varfadeIn;
extern int numColorsAdapt;
extern struct zBufferData *zBuffer;
extern unsigned int winWidth, winHeight;


UWORD textPaletteIndex = 0;
struct Interrupt *CstVbint;
UWORD CstLoadPalette = 0;
UWORD CstBackdropSize;
UWORD CstBackdropSizePlane;
UWORD *CstBackDrop;
UWORD *CstBackDropBackup;
UWORD *CstCopperList;
ULONG *CstViewBuffer;
ULONG *CstDrawBuffer;
struct CleanupQueue *CstCleanupQueueViewBuffer = NULL;
struct CleanupQueue *CstCleanupQueueDrawBuffer = NULL;
UWORD *CstClColor;
UWORD CstFrameCounter = 0;
UWORD *CstPalette;
UWORD *CstClCursor;
UBYTE *CstZBufferResult;
UBYTE *CstZBufferWork;


ULONG CstClSprites[] = { 0x001200000, 0x001220000,0x001240000,0x001260000, 0x001280000,
        0x0012a0000, 0x0012c0000, 0x0012e0000, 0x001300000, 0x001320000, 0x001340000,
                 0x001360000, 0x001380000, 0x0013a0000, 0x0013c0000, 0x0013e0000  };

ULONG CstClScreen[] = { 0x001fc0000, 0x001060000, 0x0009687ff,
        0x0008e2c81, 0x00090f4c1,0x000920038, 0x0009400d0,   /* DIWSTRT $2C81, DIWSTOP $F4C1: line 44 to line 244 */
        0x001020000, 0x001040009, 0x001080000, 0x0010a0000, 0x001005200 };

ULONG CstClBitplanes[] = { 0x0e00000, 0x0e20000, 0x0e40000, 0x0e60000,
    0x0e80000, 0x0ea0000, 0x0ec0000, 0x0ee0000,
    0x0f00000, 0x0f20000 };

ULONG CstClColorTemplate[] = {
    0x1800000, 0x1820000, 0x1840000, 0x1860000, 0x1880000, 0x18a0000, 0x18c0000, 0x18e0000,
    0x1900000, 0x1920000, 0x1940000, 0x1960000, 0x1980000, 0x19a0000, 0x19c0000, 0x19e0000,
    0x1a00000, 0x1a20000, 0x1a40000, 0x1a60000, 0x1a80000, 0x1aa0000, 0x1ac0000, 0x1ae0000,
    0x1b00000, 0x1b20000, 0x1b40000, 0x1b60000, 0x1b80000, 0x1ba0000, 0x1bc0000, 0x1be0000
};

/* ---- Fades ---------------------------------------------------------------------------------------------------------------- */

/* A fade moves the first `numColorsAdapt` colour registers one level on every pass of the game loop (a level is a sixteenth of a
   channel, so a fade takes 15 passes at most): fadeOut towards one colour, fadeIn towards the palette of the last backdrop that
   loaded one. The registers after them are not touched, so what is drawn in registers 16 to 31 stays as it is. The fade is over
   when no register changes any more; a script waits for it by counting passes. */

UWORD CstFadeColour = 0;        /* the colour fadeOut moves towards, as a colour word (0RGB) */
UWORD CstFadedRegisters = 0;    /* the registers a fade has taken from the palette: a palette that is loaded leaves them as they
                                   are, and fadeIn brings them to it (a room is loaded while the screen is black, then faded in) */

static UWORD CstStepChannel( UWORD value, UWORD target) {
  if( value < target) return value + 1;
  if( value > target) return value - 1;
  return value;
}

static UWORD CstStepColour( UWORD colour, UWORD target) {
  UWORD r = CstStepChannel( (colour >> 8) & 15, (target >> 8) & 15);
  UWORD g = CstStepChannel( (colour >> 4) & 15, (target >> 4) & 15);
  UWORD b = CstStepChannel( colour & 15, target & 15);
  return (r << 8) | (g << 4) | b;
}

/* To fade the first `count` registers one level: each moves towards its entry in the palette, or towards the one colour when
   there is no palette. Says whether anything changed. */
static BOOL CstFadeRegisters( int count, UWORD colour, UWORD *palette) {
  UWORD *register_ = CstClColor + 1;   /* the Copper list holds a MOVE per register: its opcode, then the colour */
  BOOL changed = FALSE;
  for(int i=0; i<count; i++) {
    UWORD target = palette ? palette[i] : colour;
    if( *register_ != target) {
      *register_ = CstStepColour( *register_, target);
      changed = TRUE;
    }
    register_ += 2;
  }
  return changed;
}

static int CstClampRegisters( int count) {
  return count < 0 ? 0 : count > 32 ? 32 : count;
}

static UWORD CstClampChannel( int level) {
  return level < 0 ? 0 : level > 15 ? 15 : level;
}

/* fadeOut (count, r, g, b): the first `count` registers fade to the colour, each channel 0 to 15. */
void CstStartFadeOut( int count, int r, int g, int b) {
  CstFadeColour = (CstClampChannel( r) << 8) | (CstClampChannel( g) << 4) | CstClampChannel( b);
  numColorsAdapt = CstClampRegisters( count);
  if( numColorsAdapt > CstFadedRegisters) CstFadedRegisters = numColorsAdapt;
  varfadeIn = 0;
  varfadeOut = 1;
}

/* fadeIn (count): the first `count` registers fade to their palette. */
void CstStartFadeIn( int count) {
  numColorsAdapt = CstClampRegisters( count);
  varfadeOut = 0;
  varfadeIn = 1;
}

void CstFadeOut() {
  if( !CstFadeRegisters( numColorsAdapt, CstFadeColour, NULL)) {
    varfadeOut = 0;
    KPrintF("FADE: out finished");
  }
  CstRefreshSplits();
}

void CstFadeIn() {
  if( !CstPalette || !CstFadeRegisters( numColorsAdapt, 0, CstPalette)) {
    varfadeIn = 0;
    if( numColorsAdapt >= CstFadedRegisters) CstFadedRegisters = 0;
    KPrintF("FADE: in finished");
  }
  CstRefreshSplits();
}

/* To load the palette of a backdrop into the Copper list: the registers a fade has taken keep their colour. */
static void CstLoadPaletteIntoCopper() {
  if( !CstPalette) return;
  UWORD *register_ = CstClColor + 1;
  for(int i=0; i<32; i++) { //ToDo Support other number of bitplanes
    if( i >= CstFadedRegisters) *register_ = CstPalette[i];
    register_ += 2;
  }
  CstLoadPalette = 0;
  CstRefreshSplits();
}

/* The interpreter makes a small object for nearly everything it does (a stack entry for every value it pushes, strings, stacks),
   and Exec's AllocVec and FreeVec are slow next to what a script instruction needs. Requests for ordinary memory of up to 52 bytes
   are served from blocks of 32 and 64 bytes cut out of chunks of 16 KB, kept on free lists and never given back to Exec. A pooled
   block starts with a marker word 0xD00D0000 | block size << 8 | requested size, which is how CstFreeVec knows it; four bytes
   after the requested size hold an end marker that CstFreeVec checks. */

/* Switched off (CST_POOL is not defined): a script instruction costs about 220 microseconds on an A1200, and the pool gained 15 to
   30 % in a benchmark, but with it AvailMem hung after the first 100 passes (not understood). Define CST_POOL to try it again. */
#ifdef CST_POOL
#define CST_POOL_CHUNK 16384
#define CST_POOL_MAGIC 0xD00D0000UL
#define CST_POOL_SMALL 32
#define CST_POOL_LARGE 64

static UBYTE *CstPoolFreeSmall = NULL;
static UBYTE *CstPoolFreeLarge = NULL;

static BOOL CstPoolRefill( ULONG block, UBYTE **list) {
    UBYTE *chunk = AllocVec( CST_POOL_CHUNK, MEMF_ANY);
    if( !chunk) return FALSE;
    for( ULONG offset = 0; offset + block <= CST_POOL_CHUNK; offset += block) {
        UBYTE *b = chunk + offset;
        *(ULONG *) (b + 4) = (ULONG) *list;
        *list = b;
    }
    return TRUE;
}

static APTR CstPoolAlloc( ULONG bytesize) {
    ULONG block = bytesize <= CST_POOL_SMALL - 8 ? CST_POOL_SMALL : CST_POOL_LARGE;
    UBYTE **list = block == CST_POOL_SMALL ? &CstPoolFreeSmall : &CstPoolFreeLarge;
    if( !*list && !CstPoolRefill( block, list)) {
        KPrintF("CstAllocVec: Allocation of ram failed. Reboot recommended\n", 40);
        Exit(1);
    }
    UBYTE *b = *list;
    *list = (UBYTE *) *(ULONG *) (b + 4);
    *(ULONG *) b = CST_POOL_MAGIC | (block << 8) | bytesize;
    *(ULONG *) (b + 4 + bytesize) = 0xBEEFDEADUL;
    return b + 4;
}

static void CstPoolFree( UBYTE *b) {
    ULONG header = *(ULONG *) b;
    ULONG block = (header >> 8) & 0xff;
    ULONG bytesize = header & 0xff;
    static UWORD reported = 0;
    if( *(ULONG *) (b + 4 + bytesize) != 0xBEEFDEADUL && reported < 20) {
        reported++;
        KPrintF("CstFreeVec: pooled block of %ld bytes overflowed\n", (long) bytesize);
    }
    UBYTE **list = block == CST_POOL_SMALL ? &CstPoolFreeSmall : &CstPoolFreeLarge;
    *(ULONG *) b = 0x12345678;
    *(ULONG *) (b + 4) = (ULONG) *list;
    *list = b;
}

#endif

APTR CstAllocVec( ULONG bytesize, ULONG requirements ) {
#ifdef PROFILE
    profAllocs++;
#endif
#ifdef CST_POOL
    if( requirements == MEMF_ANY && bytesize <= CST_POOL_LARGE - 8) return CstPoolAlloc( bytesize);
#endif
    UBYTE *retval = AllocVec( bytesize+8, requirements );

    if( retval == 0) {
        KPrintF("CstCstAllocVec: Allocation of ram failed. Reboot recommended\n", 40);
        Exit(1);
    }
    *retval++ = 0xde;
    *retval++ = 0xad;
    *retval++ = 0xbe;
    *retval++ = 0xef;

    UBYTE *endmarker = retval + bytesize;
    *endmarker++ = 0xbe;
    *endmarker++ = 0xef;
    *endmarker++ = 0xde;
    *endmarker++ = 0xad;


    return retval;
}

void CstFreeVec( APTR memptr ) {
    if( memptr == 0) {
        KPrintF("CstFreeVec: Attempt to free NULL pointer\n", 36);
        return;
    }

#ifdef PROFILE
    profFrees++;
#endif
    UBYTE *startmarker = memptr - 4;
#ifdef CST_POOL
    if( (*(ULONG *) startmarker & 0xffff0000UL) == CST_POOL_MAGIC) {
        CstPoolFree( startmarker);
        return;
    }
#endif
    UBYTE *cursor = startmarker;
    UBYTE *endmarker = startmarker;
    ULONG *lengthdump;
    ULONG length = 0;
    if( *startmarker != 0xde || *(startmarker+1) != 0xad || *(startmarker+2) != 0xbe || *(startmarker+3) != 0xef) {
        KPrintF("CstFreeVec: Memory corruption detected\n");
        return;                         /* (not a block of ours, or one that was freed already: Exec must not see it, it would damage its free list) */
    } else {
        *cursor++ = 0x12;
        *cursor++ = 0x34;
        *cursor++ = 0x56;
        *cursor++ = 0x78;

        lengthdump = (ULONG *) endmarker - 1;
        length = *lengthdump - 4;
        endmarker += length - 4;
        if( *endmarker != 0xbe || *(endmarker+1) != 0xef || *(endmarker+2) != 0xde || *(endmarker+3) != 0xad) {
            KPrintF("CstFreeVec: Memory corruption detected\n", 52);
        } else {
            *endmarker++ = 0x87;
            *endmarker++ = 0x65;
            *endmarker++ = 0x43;
            *endmarker++ = 0x21;
        }
    }

    FreeVec( startmarker );
}


void CstBlankScreen( int x1, int y1, int x2, int y2) {

  // (quiet) KPrintF("CstBlankScreen: started\n");

  if( !CstBackDrop) {
    KPrintF("CstBlankScreen: Backdrop empty nothing to do\n");
    return;
  }

  //CstLoadPalette = 0;

  volatile struct Custom *custom = (struct Custom*)0xdff000;
  //custom->color[0] = 0xf00;


  WaitBlit();

  UWORD width = (x2 - x1)/8;
  UWORD height = (y2 - y1);

  //Both Buffers need to be done
  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltamod = 0;
  custom->bltbmod = 0;
  custom->bltcmod = 0;
  custom->bltdmod = 40 - width;
  custom->bltcon1 = 0;
  custom->bltcon0 = 0x0100;
  ULONG bltdpt = (ULONG) CstBackDrop;
  bltdpt += x1/8 + y1*40;

  UWORD bltsize = height*64+width/2;
  UWORD blitsize = width*height;

  // (quiet) KPrintF("CstBlankScreen: Starting Blits\n");

  for(int i2=0;i2<5;i2++)
  {
    custom->bltdpt = (APTR) bltdpt;
    custom->bltsize = bltsize;
    WaitBlit();
    bltdpt += 40*256;
  }

  // (quiet) KPrintF("CstBlankScreen: Finished Blits\n");

  struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
  CstCleanupQueueDrawBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  CstCleanupQueueDrawBuffer->next = next;
  CstCleanupQueueDrawBuffer->x = x1;
  CstCleanupQueueDrawBuffer->y = y1;
  CstCleanupQueueDrawBuffer->person = NULL;
  CstCleanupQueueDrawBuffer->widthinwords = width/2;
  CstCleanupQueueDrawBuffer->height = height;
  CstCleanupQueueDrawBuffer->startxinbytes = x1/8;;
  CstCleanupQueueDrawBuffer->starty = y1;

  next = CstCleanupQueueViewBuffer;
  CstCleanupQueueViewBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  CstCleanupQueueViewBuffer->next = next;
  CstCleanupQueueViewBuffer->x = x1;
  CstCleanupQueueViewBuffer->y = y1;
  CstCleanupQueueViewBuffer->person = NULL;
  CstCleanupQueueViewBuffer->widthinwords = width/2;
  CstCleanupQueueViewBuffer->height = height;
  CstCleanupQueueViewBuffer->startxinbytes = x1/8;
  CstCleanupQueueViewBuffer->starty = y1;

  // (quiet) KPrintF("CstBlankScreen: end\n");

  //custom->color[0] = 0x000;
}

/* ---- Drawing into the backdrop: fillArea, saveArea, restoreArea ----------------------------------------------------------- */

/* A rectangle of the backdrop in words of 16 pixels across, with the masks that cut its first and last word to the pixels in it. */
struct CstArea
{
  WORD firstword, words;
  WORD y, rows;
  UWORD firstmask, lastmask;
};

/* A box that is drawn into the backdrop and taken out again: its pixels before the drawing. */
struct CstSavedArea
{
  struct CstArea area;
  UWORD *planes;          /* five planes of area.words * area.rows words, one after the other; NULL: the slot is free */
};

#define CSTMAXSAVES 8
static struct CstSavedArea CstSaves[CSTMAXSAVES];

/* To find the part of a rectangle that is on the screen (x2 and y2 are the first column and row after it). */
static BOOL CstClipArea( struct CstArea *area, int x1, int y1, int x2, int y2) {
  if( x1 < 0) x1 = 0;
  if( y1 < 0) y1 = 0;
  if( x2 > (int) winWidth) x2 = winWidth;
  if( y2 > (int) winHeight) y2 = winHeight;
  if( x2 <= x1 || y2 <= y1) {
    return FALSE;
  }
  area->firstword = x1 >> 4;
  area->words = ((x2 - 1) >> 4) - area->firstword + 1;
  area->y = y1;
  area->rows = y2 - y1;
  area->firstmask = 0xffff >> (x1 & 15);
  area->lastmask = (UWORD) (0xffff << (15 - ((x2 - 1) & 15)));
  return TRUE;
}

static ULONG CstAreaOffset( struct CstArea *area) {
  return area->y * (winWidth / 8) + area->firstword * 2;
}

/* To queue the copy of a rectangle of the backdrop into one of the screen buffers (CstRestoreScreen does it before the next frame
   is drawn into that buffer). */
static void CstQueueBackdropRectangle( struct CleanupQueue **queue, struct CstArea *area) {
  struct CleanupQueue *entry = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  entry->next = *queue;
  entry->x = area->firstword * 16;
  entry->y = area->y;
  entry->person = NULL;
  entry->widthinwords = area->words;
  entry->height = area->rows;
  entry->startxinbytes = area->firstword * 2;
  entry->starty = area->y;
  *queue = entry;
}

/* A change of the backdrop reaches both screen buffers: the one that is drawn into next, and the one that is shown. */
static void CstQueueBackdropChange( struct CstArea *area) {
  CstQueueBackdropRectangle( &CstCleanupQueueDrawBuffer, area);
  CstQueueBackdropRectangle( &CstCleanupQueueViewBuffer, area);
}

/* To fill the pixels of an area with a colour: on each plane, the blitter sets them (D = A or C) or clears them (D = C and not A),
   as the colour's bit for the plane says, where A is a word of ones that the area's masks cut to its pixels. */
static void CstFillPlanes( struct CstArea *area, int colour) {
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  LONG screenrow = winWidth / 8;
  ULONG screenplane = screenrow * winHeight;
  ULONG at = (ULONG) CstBackDrop + CstAreaOffset( area);

  WaitBlit();
  custom->bltafwm = area->firstmask;
  custom->bltalwm = area->lastmask;
  custom->bltcmod = screenrow - area->words * 2;
  custom->bltdmod = screenrow - area->words * 2;
  custom->bltcon1 = 0;
  custom->bltadat = 0xffff;
  for(int plane=0; plane<5; plane++) //ToDo other numbers of Bitplanes
  {
    custom->bltcon0 = 0x300 | (((colour >> plane) & 1) ? 0xfa : 0x0a);
    custom->bltcpt = (APTR) at;
    custom->bltdpt = (APTR) at;
    custom->bltsize = (area->rows << 6) | area->words;
    at += screenplane;
    WaitBlit();
  }
}

/* fillArea (x1, y1, x2, y2, colour): colour is a register, 0 to 31; the area runs up to but not including x2 and y2. */
BOOL CstFillArea( int x1, int y1, int x2, int y2, int colour) {
  struct CstArea area;
  if( !CstBackDrop || colour < 0 || colour > 31 || !CstClipArea( &area, x1, y1, x2, y2)) {
    return FALSE;
  }
  CstFillPlanes( &area, colour);
  CstQueueBackdropChange( &area);
  return TRUE;
}

/* To copy the five planes of an area between the backdrop and a saved block (A to D, no logic). */
static void CstCopyArea( struct CstArea *area, UWORD *saved, BOOL fromBackdrop) {
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  LONG screenrow = winWidth / 8;
  ULONG screenplane = screenrow * winHeight;
  ULONG blockplane = area->words * 2 * area->rows;
  ULONG backdrop = (ULONG) CstBackDrop + CstAreaOffset( area);
  ULONG block = (ULONG) saved;

  WaitBlit();
  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltcon0 = 0x9f0;
  custom->bltcon1 = 0;
  custom->bltamod = fromBackdrop ? screenrow - area->words * 2 : 0;
  custom->bltdmod = fromBackdrop ? 0 : screenrow - area->words * 2;
  for(int plane=0; plane<5; plane++) //ToDo other numbers of Bitplanes
  {
    custom->bltapt = (APTR) (fromBackdrop ? backdrop : block);
    custom->bltdpt = (APTR) (fromBackdrop ? block : backdrop);
    custom->bltsize = (area->rows << 6) | area->words;
    backdrop += screenplane;
    block += blockplane;
    WaitBlit();
  }
}

static int CstFreeSaveSlot() {
  for(int slot=0; slot<CSTMAXSAVES; slot++) {
    if( !CstSaves[slot].planes) return slot;
  }
  return -1;
}

/* saveArea (x1, y1, x2, y2): keep the pixels of the backdrop under the area (whole words of 16 pixels: x1 rounds down and x2
   up). Returns a number to give restoreArea, or 0 when there is no room. */
int CstSaveArea( int x1, int y1, int x2, int y2) {
  struct CstArea area;
  int slot = CstFreeSaveSlot();
  if( !CstBackDrop || slot < 0 || !CstClipArea( &area, x1 & ~15, y1, (x2 + 15) & ~15, y2)) {
    return 0;
  }
  UWORD *block = CstAllocVec( 5 * area.words * 2 * area.rows, MEMF_CHIP);
  CstCopyArea( &area, block, TRUE);
  CstSaves[slot].area = area;
  CstSaves[slot].planes = block;
  return slot + 1;
}

/* restoreArea (number): put the saved pixels back into the backdrop and let the number go. */
BOOL CstRestoreArea( int number) {
  if( number < 1 || number > CSTMAXSAVES || !CstSaves[number - 1].planes || !CstBackDrop) {
    return FALSE;
  }
  struct CstSavedArea *saved = &CstSaves[number - 1];
  CstCopyArea( &saved->area, saved->planes, FALSE);
  CstQueueBackdropChange( &saved->area);
  CstFreeVec( saved->planes);
  saved->planes = NULL;
  return TRUE;
}

/* To let go of every saved area (the backdrop they belong to is gone). */
static void CstForgetSavedAreas() {
  for(int slot=0; slot<CSTMAXSAVES; slot++) {
    if( CstSaves[slot].planes) CstFreeVec( CstSaves[slot].planes);
    CstSaves[slot].planes = NULL;
  }
}

/* ---- Frame statistics ------------------------------------------------------------------------------------------------- */

#define CSTSTATPASSES 100
#define CSTFRAMELINES 313        /* raster lines in a PAL frame */
#define CSTFRAMESTART 301        /* the game loop starts a pass at the Copper interrupt on this line */

/* To measure the game loop: after the work of a pass, note the raster line it ended on, and every 100 passes write one line to
   the log: the lines the work took on average and at most (a frame is 313 lines, 64 microseconds each) and the number of
   passes that ran over a frame, which the loop then waits one more frame for. `overran` says that the frame interrupt came while
   the pass was working. */
void CstFrameStats( BOOL overran)
{
  static UWORD passes, overruns, longest;
  static ULONG total;

  UWORD line = (*(volatile ULONG *) 0xDFF004 >> 8) & 0x1ff;
  UWORD used = line >= CSTFRAMESTART ? line - CSTFRAMESTART : line + CSTFRAMELINES - CSTFRAMESTART;   /* before or after the next start line */
  if( overran) {
    overruns++;
  } else {
    total += used;
    if( used > longest) longest = used;
  }
  if( ++passes == CSTSTATPASSES) {
    KPrintF("FRAME: %ld passes, the work took %ld lines on average and %ld at most (of 313), %ld ran over a frame\n",
            (long) CSTSTATPASSES, (long) (total / (CSTSTATPASSES - overruns > 0 ? CSTSTATPASSES - overruns : 1)), (long) longest, (long) overruns);
    KPrintF("CHIP: %ld bytes free, the largest block %ld", (long) AvailMem( MEMF_CHIP), (long) AvailMem( MEMF_CHIP | MEMF_LARGEST));
    passes = overruns = longest = 0;
    total = 0;
  }
}

/* ---- The Copper list ------------------------------------------------------------------------------------------------ */

/* The picture is 200 lines of the 256 the screen has; it starts on raster line 44 (DIWSTRT), so line 244 is the first below it. */
#define CSTPICTURETOP 44
#define CSTPICTUREHEIGHT 200
#define CSTBELOWPICTURE (CSTPICTURETOP + CSTPICTUREHEIGHT)
#define CSTWAIT(line) ((((ULONG) (line)) << 24) | 0x00010000 | 0xFFFE)
#define CSTMOVE(reg, value) ((((ULONG) 0x180 + 2 * (reg)) << 16) | (value))

#define CSTMAXSPLITS 4          /* a split is two events in the list, each a WAIT and a MOVE: 4 splits take 16 of its longs */

/* A Copper split gives a colour register another colour for the lines y1 to y2 - 1 of the picture; the lines before and after
   have the register's colour of the moment. */
struct CstSplit
{
  WORD y1, y2;
  UWORD reg, colour;
};

/* One change of a register by the Copper: at a line, set it to a colour. */
struct CstSplitEvent
{
  WORD line;
  UWORD reg, colour;
  BOOL sets;    /* the start of a split (the end of one is sorted before a start on the same line) */
};

static struct CstSplit CstSplits[CSTMAXSPLITS];
static int CstSplitCount = 0;
static ULONG *CstCopperTail = NULL;     /* where the part of the list starts that depends on the splits (after the colours) */
static int CstCopperWidth = 0;          /* the screen's width in bytes, which the tail needs for the modulos */

static ULONG *CstBlankBelowPicture( ULONG *cl);
static ULONG *CstCopyLongs( ULONG *to, ULONG *from, int count);
static ULONG *CstSetModulo( ULONG *cl, int width);
static ULONG *CstCopperSplits( ULONG *cl);
static ULONG *CstEndFrame( ULONG *cl);
static void CstBuildCopperTail( ULONG *cl, int width);

/* To make the Copper list: set the sprite pointers, the screen and the bitplane pointers, load the 32 colours, and end it with the
   part that can change while the game runs (the splits), the switch-off of the bitplanes below the picture and the interrupt that
   the game loop waits for. */
UWORD * CstCreateCopperlist( int width) {
  /* From CstAllocVec like the screen buffers: the markers around the list are checked when CstFreeBuffer frees it (a list that
     grows past CSTCOPSIZE shows up as memory corruption), and a failed allocation is reported there and ends the program. */
  ULONG *list = CstAllocVec( CSTCOPSIZE, MEMF_CHIP);
  ULONG *cl = list;

  CstClCursor = (UWORD *) cl;
  cl = CstCopyLongs( cl, CstClSprites, 16);
  cl = CstCopyLongs( cl, CstClScreen, 12);
  cl = CstCopyLongs( cl, CstClBitplanes, 10);
  CstClColor = (UWORD *) cl;
  cl = CstCopyLongs( cl, CstClColorTemplate, 32);
  CstCopperTail = cl;
  CstCopperWidth = width;
  CstSplitCount = 0;
  CstSplitsInList = 0;
  CstBuildCopperTail( cl, width);
  return (UWORD *) list;
}

static void CstBuildCopperTail( ULONG *cl, int width) {
  cl = CstSetModulo( cl, width);
  cl = CstCopperSplits( cl);
  cl = CstBlankBelowPicture( cl);
  cl = CstEndFrame( cl);
}

static ULONG *CstCopyLongs( ULONG *to, ULONG *from, int count) {
  for(int i=0; i<count; i++)
    *to++ = *from++;
  return to;
}

/* A screen that is wider than the 40 bytes the display fetches needs the bitplane modulos. */
static ULONG *CstSetModulo( ULONG *cl, int width) {
  if(width > 40) {
    UWORD *cw = (UWORD *) cl;
    *cw++ = 0x108;
    *cw++ = width - 40;
    *cw++ = 0x10a;
    *cw++ = width - 40;
    cl = (ULONG *) cw;
  }
  return cl;
}

/* Below the picture the display fetches no bitplanes and shows black, whatever colour 0 is at that moment (a white flash
   would otherwise light the band up). The list sets BPLCON0 and COLOR00 again at the top of the next frame. */
static ULONG *CstBlankBelowPicture( ULONG *cl) {
  *cl++ = CSTWAIT( CSTBELOWPICTURE);
  *cl++ = 0x01000200;   /* BPLCON0: no bitplanes */
  *cl++ = 0x01800000;   /* COLOR00: black */
  return cl;
}

static ULONG *CstEndFrame( ULONG *cl) {
  *cl++ = 0xffdffffe;   /* wait for the end of line 255, so that the waits that follow may be below it */
  *cl++ = 0x2d01ff00;   /* wait for line 301 ... */
  *cl++ = 0x9c8010;     /* ... and raise the Copper interrupt */
  *cl++ = 0xfffffffe;
  return cl;
}

/* ---- Copper splits (setCopperSplit, clearCopperSplits) ---- */

/* The Copper runs the list top to bottom once a frame and a WAIT for a line that has gone by does not wait, so the changes of the
   registers must be in the order of their lines. Every split gives two events (set the colour at y1, put the register back at
   y2); they are sorted by line, and by "put back" before "set" on the same line, so that a split may start where another one
   ends. Two splits on the same register must not overlap. The colour a register goes back to is the one it has in the list. */

/* To add a split to the list. Says no if it is not on the picture or the table is full. */
BOOL CstSetCopperSplit( int y1, int y2, int reg, int r, int g, int b) {
  if( reg < 0 || reg > 31) return FALSE;
  if( y1 < 0) y1 = 0;
  if( y2 > CSTPICTUREHEIGHT) y2 = CSTPICTUREHEIGHT;
  if( y2 <= y1 || CstSplitCount == CSTMAXSPLITS) return FALSE;

  struct CstSplit *split = &CstSplits[CstSplitCount++];
  split->y1 = y1;
  split->y2 = y2;
  split->reg = reg;
  split->colour = (CstClampChannel( r) << 8) | (CstClampChannel( g) << 4) | CstClampChannel( b);
  CstRefreshSplits();
  return TRUE;
}

void CstClearCopperSplits() {
  CstSplitCount = 0;
  CstRefreshSplits();
}

/* To write the splits into the list again (they changed, or the colour a register goes back to did). */
void CstRefreshSplits() {
  if( CstCopperTail && (CstSplitCount > 0 || CstSplitsInList > 0)) {
    CstBuildCopperTail( CstCopperTail, CstCopperWidth);
  }
}

static int CstEventsOf( struct CstSplitEvent *events) {
  int count = 0;
  for(int i=0; i<CstSplitCount; i++) {
    struct CstSplit *split = &CstSplits[i];
    events[count].line = CSTPICTURETOP + split->y1;
    events[count].reg = split->reg;
    events[count].colour = split->colour;
    events[count++].sets = TRUE;
    events[count].line = CSTPICTURETOP + split->y2;
    events[count].reg = split->reg;
    events[count].colour = CstClColor[2 * split->reg + 1];
    events[count++].sets = FALSE;
  }
  return count;
}

/* An insertion sort: there are at most eight events, and equal ones stay in the order they were made in. */
static void CstSortEvents( struct CstSplitEvent *events, int count) {
  for(int i=1; i<count; i++) {
    struct CstSplitEvent moving = events[i];
    int j = i;
    while( j > 0 && (events[j - 1].line > moving.line || (events[j - 1].line == moving.line && events[j - 1].sets && !moving.sets))) {
      events[j] = events[j - 1];
      j--;
    }
    events[j] = moving;
  }
}

static ULONG *CstCopperSplits( ULONG *cl) {
  struct CstSplitEvent events[2 * CSTMAXSPLITS];
  int count = CstEventsOf( events);
  CstSortEvents( events, count);
  for(int i=0; i<count; i++) {
    *cl++ = CSTWAIT( events[i].line);
    *cl++ = CSTMOVE( events[i].reg, events[i].colour);
  }
  CstSplitsInList = count / 2;
  return cl;
}

/* To make the picture of a z-buffer layer: the plane is cleared, then the rectangle of the layer (any x and width) is set to ones.
   The blitter writes a word of ones through the masks of the first and the last word of the rectangle. */
void CstCreateZBufferLayer (BYTE *zbufferdata, UWORD x, UWORD y, UWORD width, UWORD height)
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;

  #ifdef EMULATOR
    debug_register_bitmap(zbufferdata, "extrazbufferlayer", 320, 250, 1, 0);
  #endif

  WaitBlit();
  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltdmod = 0;
  custom->bltcon0 =  0x1f0;
  custom->bltcon1 = 0x0;
  custom->bltdpt = zbufferdata;
  custom->bltadat = 0;
  custom->bltsize = 256 * 64 + 20;

  struct CstArea area;
  if( !CstClipArea( &area, x, y, x + width, y + height)) {
    return;
  }
  WaitBlit();
  custom->bltafwm = area.firstmask;
  custom->bltalwm = area.lastmask;
  custom->bltdmod = winWidth / 8 - area.words * 2;
  custom->bltcon0 =  0x1f0;
  custom->bltcon1 = 0x0;
  custom->bltdpt = zbufferdata + (area.y * (winWidth / 8)) + area.firstword * 2;
  custom->bltadat = 0xffff;
  custom->bltsize = (area.rows << 6) | area.words;
}

void CstDisplayCursor(UWORD x, UWORD y, UWORD height, UBYTE *spritedata)
{
  spritedata[0] = (UBYTE) (y & 0xff); //Low 8 Bits of y
  spritedata[1] = (UBYTE) (x >> 1); //High 8 Bits of x
  spritedata[2] = (UBYTE) (y+height & 0xff); //Sprite Stop Low 8 Bits

  UWORD lowbitx = x & 0x1;
  UWORD vstophighbit = ((y+height) & 0x100) >> 7;
  UWORD vstarthighbit = (y & 0x100) >> 6;

  spritedata[3] = lowbitx + vstophighbit + vstarthighbit; //Low Bit X, Sprite Stop High Bit

  ULONG ptr = (ULONG) spritedata;
  UWORD loptr = (UWORD) ptr & 0xffff;
  UWORD hiptr = ptr >> 16;

  CstClCursor[1] = hiptr;
  CstClCursor[3] = loptr;

}

void CstFreeBuffer( ) {
  CstForgetSavedAreas();
  if( CstDrawBuffer) CstFreeVec(CstDrawBuffer);
  if( CstViewBuffer) CstFreeVec(CstViewBuffer);
  if( CstCopperList) CstFreeVec(CstCopperList);
  if( CstBackDrop) CstFreeVec(CstBackDrop);
  if( CstBackDropBackup) CstFreeVec(CstBackDropBackup);
  CstDrawBuffer = NULL;
  CstViewBuffer = NULL;
  CstCopperList = NULL;
  CstBackDrop = NULL;
  CstBackDropBackup = NULL;

}



void CstFreeze( ) {

  KPrintF("CstFreeze: Freezing Background Started");

  UWORD size = winWidth/8*winHeight*5;

  //Writing to Framebuffer
  volatile struct Custom *custom = (struct Custom*)0xdff000;

  //Backup Existing Backdrop to save location
  CstBackDropBackup = CstAllocVec(size, MEMF_ANY);
  if( !CstBackDropBackup)
  {
    KPrintF("CstFreeze: Cannot allocate Memory for CstBackDropBackup");
  }

  if( !CstBackDrop)
  {
    KPrintF("CstFreeze: Error - CstBackDrop is empty - this should not happen\n");
  }

#ifdef EMULATOR
  debug_register_bitmap(CstBackDropBackup, "BackDropBackup", winWidth, winHeight, 5, 0);
#endif

  ULONG *src = (ULONG *) CstBackDrop;
  ULONG *dst = (ULONG *) CstBackDropBackup;
  for(int i=0;i<size/4;i++)
  {
    *dst++ = *src++;
  }

  //Replace existing Backdrop with ViewBuffer
  src = (ULONG *) CstViewBuffer;
  dst = (ULONG *) CstBackDrop;

  for(int i=0;i<size/4;i++)
  {
    *dst++ = *src++;
  }

  struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
  CstCleanupQueueDrawBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  CstCleanupQueueDrawBuffer->next = next;
  CstCleanupQueueDrawBuffer->x = 0;
  CstCleanupQueueDrawBuffer->y = 0;
  CstCleanupQueueDrawBuffer->person = NULL;
  CstCleanupQueueDrawBuffer->widthinwords = winWidth/16;
  CstCleanupQueueDrawBuffer->height = winHeight;
  CstCleanupQueueDrawBuffer->startxinbytes = 0;
  CstCleanupQueueDrawBuffer->starty = 0;

  next = CstCleanupQueueViewBuffer;
  CstCleanupQueueViewBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  CstCleanupQueueViewBuffer->next = next;
  CstCleanupQueueViewBuffer->x = 0;
  CstCleanupQueueViewBuffer->y = 0;
  CstCleanupQueueViewBuffer->person = NULL;
  CstCleanupQueueViewBuffer->widthinwords = winWidth/16;
  CstCleanupQueueViewBuffer->height = winHeight;
  CstCleanupQueueViewBuffer->startxinbytes = 0;
  CstCleanupQueueViewBuffer->starty = 0;

  //KPrintF("CstFreeze: Finished");

}

void CstInitVBlankHandler( ) {
  if ((CstVbint = AllocMem(sizeof(struct Interrupt),
                         MEMF_PUBLIC|MEMF_CLEAR))) {
    CstVbint->is_Node.ln_Type = NT_INTERRUPT;
    CstVbint->is_Node.ln_Pri = -60;
    CstVbint->is_Node.ln_Name = "VertB-Example";
    CstVbint->is_Data = NULL;
    CstVbint->is_Code = CstVBlankHandler;
  }

  AddIntServer( INTB_COPER, CstVbint);

}

void CstLoadBackdrop( BPTR fp, int x, int y, int loadpalette) {


	// (quiet) KPrintF("CstLoadBackDrop: Loading of Background started");

    UWORD width = get2bytes(fp);
    UWORD height = get2bytes(fp);

    UWORD widthbyteslayer = width/8;
    UWORD widthwordslayer = widthbyteslayer/2;
    UWORD widthbytesbackdrop = winWidth / 8;
    UWORD sizeplane =  widthbyteslayer*height;
    UWORD size = sizeplane * 5; //Todo other number of bitplanes

  //Load Palette to Copper

    UWORD reg = 0x180;

    if(loadpalette)
    {
        if(CstPalette) {
            CstFreeVec(CstPalette);
            CstPalette = NULL;
        }

        CstPalette = CstAllocVec(32*2,MEMF_ANY); //ToDo other number of bitplanes
        CstLoadPalette = 1;
        UWORD *tmp = CstPalette;
        for(int i=0;i<32;i++) { //ToDo Support other number of bitplanes
            *tmp++ = get2bytes(fp);
        }
    }
    else
    {
        for(int i=0;i<32;i++)
        {
            get2bytes(fp); //Skip Palette Data in Stream
        }
    }


  //Load Picture From Disk
  UWORD *tmpbuffer = CstAllocVec(size, MEMF_CHIP); //Todo other number of bitplanes
  if( !tmpbuffer)
  {
    KPrintF("CstLoadBackDrop: Cannot allocate Memory for tmpbuffer");
  }
  UWORD *tmpmask = CstAllocVec(sizeplane, MEMF_CHIP);
  if( !tmpmask)
  {
    KPrintF("CstLoadBackDrop: Cannot allocate Memory for tmpmask");
  }

#ifdef EMULATOR
  debug_register_bitmap(tmpbuffer, "tmpbuffer.bpl", width, height, 5, 0);
  debug_register_bitmap(tmpbuffer, "tmpmask.bpl", width, height, 1, 0);
#endif

  UWORD count = readBytes( fp, tmpbuffer, size & ~1) / 2;
  if(!count) {
    KPrintF("Error while reading stream");
    return;
  }
  count = readBytes( fp, tmpmask, sizeplane & ~1) / 2;


  if(!count) {
    KPrintF("Error while reading stream");
    return;
  }

  //Writing to Framebuffer
  volatile struct Custom *custom = (struct Custom*)0xdff000;

  ULONG backdropcursor = (ULONG) CstBackDrop;
  UWORD offset = widthbytesbackdrop*y + x / 8;
  backdropcursor += offset;

 	// (quiet) KPrintF("CstLoadBackDrop: Starting Blit");


  WaitBlit();

  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltamod = 0;
  custom->bltbmod = 0;
  custom->bltcmod = widthbytesbackdrop - widthbyteslayer;
  custom->bltdmod = widthbytesbackdrop - widthbyteslayer;
  custom->bltcon0 = 0xfca;
  custom->bltcon1 = 0;

  ULONG tmpbuffercursor = (ULONG) tmpbuffer;
  for(int i=0;i<5;i++) //Todo other number of bitplanes
  {
    WaitBlit();
    custom->bltapt = (APTR) tmpmask;
    custom->bltbpt = (APTR) tmpbuffercursor;
    custom->bltcpt = (APTR)backdropcursor;
    custom->bltdpt = (APTR) backdropcursor;
    custom->bltsize = (height<<6)+widthwordslayer;
    tmpbuffercursor += sizeplane;
    backdropcursor += CstBackdropSizePlane;
  }

  WaitBlit();

 	// (quiet) KPrintF("CstLoadBackDrop: Freeing Memory");


  CstFreeVec(tmpbuffer);
  CstFreeVec(tmpmask);

  tmpbuffer = NULL;
  tmpmask = NULL;

  struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
  CstCleanupQueueDrawBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  CstCleanupQueueDrawBuffer->next = next;
  CstCleanupQueueDrawBuffer->x = 0;
  CstCleanupQueueDrawBuffer->y = 0;
  CstCleanupQueueDrawBuffer->person = NULL;
  CstCleanupQueueDrawBuffer->widthinwords = winWidth/16;
  CstCleanupQueueDrawBuffer->height = winHeight;
  CstCleanupQueueDrawBuffer->startxinbytes = 0;
  CstCleanupQueueDrawBuffer->starty = 0;

  next = CstCleanupQueueViewBuffer;
  CstCleanupQueueViewBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  CstCleanupQueueViewBuffer->next = next;
  CstCleanupQueueViewBuffer->x = 0;
  CstCleanupQueueViewBuffer->y = 0;
  CstCleanupQueueViewBuffer->person = NULL;
  CstCleanupQueueViewBuffer->widthinwords = winWidth/16;
  CstCleanupQueueViewBuffer->height = winHeight;
  CstCleanupQueueViewBuffer->startxinbytes = 0;
  CstCleanupQueueViewBuffer->starty = 0;

  // (quiet) KPrintF("CstLoadBackDrop: Finished");

}

ULONG test = 0;

void CstPasteChar( struct sprite *single, WORD x, WORD y)
{

  volatile struct Custom *custom = (struct Custom*)0xdff000;
  //custom->color[0] = 0x0f0;
  UWORD *destination = 0;
  destination = (UWORD *) CstBackDrop;

  if( !destination) {
    KPrintF("FATAL CstPasteChar: Destination Backdrop is empty\n");
    return;
  }

  UWORD extrawords; //When Input is shifted sometimes an extra word has to be written to cover the whole sprite
  UWORD cutwordssource; //If some words are completely outside of screen
  UWORD cutmaskpixel; //Single pixels outside of Screen need to be masked out to prevent corruption of background
  UWORD bltalwm; //Mask out all or part of last word as out of range of source.
  ULONG bltapt; //Start Position Source Mask
  ULONG bltbpt; //Start Position Source
  ULONG bltcpt; //Start Position Background
  ULONG bltdpt; //Start Position DrawBuffer
  ULONG bltcon0; //Channel configuration and shift mask
  ULONG bltcon1; //Shift Source
  ULONG ystartdst;
  ULONG ystartsrc;
  ULONG blitheight;
  ULONG blitwidth;

  bltcon0 = 0;

  blitwidth = single->width/16;
  if(blitwidth == 0) blitwidth = 1;

  if( y < 0) {
    if(y + single->height < 0) {
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;
    }
    ystartdst = 0;
    ystartsrc = y*-1;
    blitheight = single->height+y;
  } else if(y+single->height > (int) winHeight) {
    if(y  > (int) winHeight) {
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;
    }
    ystartdst = y;
    ystartsrc = 0;
    blitheight = winHeight-y;
  } else {
    ystartdst = y;
    ystartsrc = 0;
    blitheight = single->height;
  }


   if( x < 0) { //Leftmost part outside screen
    if(x + single->width < 0) {
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;

    }

    extrawords = 1;

    cutwordssource = (x*-1)/16;
    cutmaskpixel = (x*-1)%16;
    bltalwm = 0; //Last Word of this channel almost masked out
    bltapt = ((ULONG) single->data)+cutwordssource*2+ystartsrc*single->width/8;
    bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 - 2;
    bltdpt = ((ULONG) destination) + ystartdst*winWidth/8 - 2;
    bltcon0 = ((16-cutmaskpixel) << 12);

    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
    CstCleanupQueueDrawBuffer->next = next;
    CstCleanupQueueDrawBuffer->x = 0;
    CstCleanupQueueDrawBuffer->y = 0;
    CstCleanupQueueDrawBuffer->person = NULL;
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource+extrawords;
    CstCleanupQueueDrawBuffer->height = blitheight;
    CstCleanupQueueDrawBuffer->startxinbytes = 0;
    CstCleanupQueueDrawBuffer->starty = ystartdst;

    next = CstCleanupQueueViewBuffer;
    CstCleanupQueueViewBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
    CstCleanupQueueViewBuffer->next = next;
    CstCleanupQueueViewBuffer->x = 0;
    CstCleanupQueueViewBuffer->y = 0;
    CstCleanupQueueViewBuffer->person = NULL;
    CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource+extrawords;
    CstCleanupQueueViewBuffer->height = blitheight;
    CstCleanupQueueViewBuffer->startxinbytes = 0;
    CstCleanupQueueViewBuffer->starty = ystartdst;
  } else if(x + single->width > (int) winWidth) { //Rightmost part outside screen

    if(x - single->width > (int) winWidth)
    {
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;
    }
    extrawords = 0; //Shifted out part of source outside screen. No need to blit this
    cutwordssource = (x+single->width - winWidth)/16;
    cutmaskpixel = 0;
    bltalwm = 0xffff; //Last word contains source data to be blit
    bltapt = (ULONG) single->data+ystartsrc*single->width/8;
    bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltdpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltcon0 = ((single->width%16) << 12);

    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
    CstCleanupQueueDrawBuffer->next = next;
    CstCleanupQueueDrawBuffer->x = x;
    CstCleanupQueueDrawBuffer->y = ystartdst;
    CstCleanupQueueDrawBuffer->person = NULL;
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource;
    CstCleanupQueueDrawBuffer->height = blitheight;
    CstCleanupQueueDrawBuffer->startxinbytes = (x/16)*2;
    CstCleanupQueueDrawBuffer->starty = ystartdst;

    next = CstCleanupQueueViewBuffer;
    CstCleanupQueueViewBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
    CstCleanupQueueViewBuffer->next = next;
    CstCleanupQueueViewBuffer->x = x;
    CstCleanupQueueViewBuffer->y = ystartdst;
    CstCleanupQueueViewBuffer->person = NULL;
    CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource;
    CstCleanupQueueViewBuffer->height = blitheight;
    CstCleanupQueueViewBuffer->startxinbytes = (x/16)*2;
    CstCleanupQueueViewBuffer->starty = ystartdst;
  } else { //Whole Sprite on Screen

    extrawords = 1;
    cutwordssource = 0;
    cutmaskpixel = 0;
    bltalwm = 0; //Last Word of this channel almost masked out
    bltapt = (ULONG) single->data+ystartsrc*(single->width/16)*2;
    bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltdpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltcon0 = ((x%16) << 12);

    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
    CstCleanupQueueDrawBuffer->next = next;
    CstCleanupQueueDrawBuffer->x = x;
    CstCleanupQueueDrawBuffer->y = ystartdst;
    CstCleanupQueueDrawBuffer->person = NULL;
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource+extrawords;
    CstCleanupQueueDrawBuffer->height = blitheight;
    CstCleanupQueueDrawBuffer->startxinbytes = (x/16)*2;
    CstCleanupQueueDrawBuffer->starty = ystartdst;

    next = CstCleanupQueueViewBuffer;
    CstCleanupQueueViewBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
    CstCleanupQueueViewBuffer->next = next;
    CstCleanupQueueViewBuffer->x = x;
    CstCleanupQueueViewBuffer->y = ystartdst;
    CstCleanupQueueViewBuffer->person = NULL;
    CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource+extrawords;
    CstCleanupQueueViewBuffer->height = blitheight;
    CstCleanupQueueViewBuffer->startxinbytes = (x/16)*2;
    CstCleanupQueueViewBuffer->starty = ystartdst;

  }

  UWORD bltafwm = 0xffff >> cutmaskpixel;
  WORD bltamod = cutwordssource*2-(extrawords*2); //Jump to next line
  WORD bltcmod = winWidth/8-blitwidth*2-extrawords*2+cutwordssource*2;
  WORD bltdmod = winWidth/8-blitwidth*2-extrawords*2+cutwordssource*2;

  WaitBlit();

  custom->bltafwm = bltafwm;
  custom->bltalwm = bltalwm;
  custom->bltamod = bltamod;
  custom->bltcmod = bltcmod;
  custom->bltdmod = bltdmod;

  UWORD bltcptplus = winWidth/8*winHeight;
  UWORD tmp = textPaletteIndex;

  UWORD minterm;
  //Apply palette color to planeblit
  //Ugly double code in the name of performance
  UWORD tmp2 = tmp & 0x01;
  if(tmp2) {
    minterm = 0xbfa;
  } else {
    minterm = 0xb0a;
  }

  for(int i=0;i<5;i++) //ToDo other numbers of Bitplanes
  {

    custom->bltcon0 = bltcon0 + minterm;
    custom->bltapt = (APTR) bltapt;
    custom->bltcpt = (APTR) bltcpt;
    custom->bltdpt = (APTR) bltdpt;
    custom->bltsize = (blitheight << 6) + blitwidth-cutwordssource+extrawords;
    bltcpt += bltcptplus;
    bltdpt += bltcptplus;

    //Apply palette color to planeblit
    //Ugly double code in the name of performance
    tmp = tmp >> 1;
    tmp2 = tmp & 0x01;
    if(tmp2) {
      minterm = 0xbfa;
    } else {
      minterm = 0xb0a;
    }

    WaitBlit();
  }
  //custom->color[0] = 0x000;
}


void CstRestoreScreen()
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  //custom->color[0] = 0xf00;
  //struct CleanupQueue *cursor  = CstCleanupQueueDrawBuffer;
  if(!CstCleanupQueueDrawBuffer || !CstDrawBuffer) {
    return;
  }

  if( CstLoadPalette && CstPalette)
  {
    CstLoadPaletteIntoCopper();
  }

  WaitBlit();

  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltcon0 = 0x9f0;

  while(CstCleanupQueueDrawBuffer)
  {

    /*if( CstCleanupQueueDrawBuffer->person && CstCleanupQueueDrawBuffer->person->samePosCount < 3
      || CstCleanupQueueDrawBuffer->person == NULL)
    {*/
      custom->bltamod = winWidth/8-CstCleanupQueueDrawBuffer->widthinwords*2;
      custom->bltdmod = winWidth/8-CstCleanupQueueDrawBuffer->widthinwords*2;
      ULONG bltapt = ((ULONG) CstBackDrop) + CstCleanupQueueDrawBuffer->starty*winWidth/8 + CstCleanupQueueDrawBuffer->startxinbytes;
      ULONG bltdpt = ((ULONG) CstDrawBuffer) + CstCleanupQueueDrawBuffer->starty*winWidth/8 + CstCleanupQueueDrawBuffer->startxinbytes;
      for(int i=0;i<5;i++) //ToDo other numbers of Bitplanes
      {
        custom->bltapt = (APTR) bltapt;
        custom->bltdpt = (APTR) bltdpt;
        custom->bltsize = (CstCleanupQueueDrawBuffer->height << 6) + CstCleanupQueueDrawBuffer->widthinwords;
        bltapt += winWidth/8*winHeight;
        bltdpt += winWidth/8*winHeight;
        WaitBlit();
      }
    //}
    struct CleanupQueue *todelete = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = CstCleanupQueueDrawBuffer->next;
    CstFreeVec(todelete);
    todelete = NULL;
  }
  //custom->color[0] = 0x000;
}

/* ---- Drawing a sprite ----------------------------------------------------------------------------------------------- */

/* The Makefile has no optimisation flag (-Ofast is commented out), so the engine is compiled without optimising, except for
   what asks for it. The drawing is what runs for every sprite on every frame: it is compiled with -Ofast, and its helpers are
   inlined into CstScaleSprite, so that splitting it into small functions costs nothing. */
#pragma GCC push_options
#pragma GCC optimize ("Ofast")
#define CSTINLINE static inline __attribute__((always_inline))

#define CSTSCREENWORDS 20   /* winWidth / 16 */

/* Where a sprite lands on the screen, clipped: the part of it that has a pixel on the screen. A sprite is `words` words wide
   (a multiple of 16 pixels), and x, y, its top left corner on the screen, may lie off the screen on every side. */
struct CstPlacement
{
  WORD x, y;
  WORD words;
  WORD firstword, lastword;   /* the words of a row that have a pixel on the screen */
  WORD firstrow, endrow;      /* the rows that have one: first, and the one after the last */
};

CSTINLINE BOOL CstPlaceSprite( struct CstPlacement *place, struct sprite *single, WORD x, WORD y);
CSTINLINE UBYTE *CstSpriteMask( struct sprite *single, struct onScreenPerson *person, struct CstPlacement *place);
CSTINLINE void CstBlitSprite( struct sprite *single, UBYTE *mask, struct CstPlacement *place, UWORD *destination);
CSTINLINE void CstQueueCleanup( struct onScreenPerson *person, struct CstPlacement *place, BOOL bothbuffers);
CSTINLINE void CstQueueCleanupRectangle( struct CleanupQueue **queue, struct onScreenPerson *person, struct CstPlacement *place, int firstscreenword, int lastscreenword);
CSTINLINE int CstCharacterDepth( struct onScreenPerson *person);
CSTINLINE BOOL CstBehindPanel( struct sprite *single, struct onScreenPerson *person, int depth, struct CstPlacement *place, struct zBufferData *panel);
CSTINLINE UBYTE *CstTakePanelOut( struct CstPlacement *place, struct zBufferData *panel, int firstrow, int endrow, UBYTE *own, UBYTE *mask);
CSTINLINE void CstCopyMask( UBYTE *from, UBYTE *to, LONG offset, LONG row, int words, int rows);

/* To draw a sprite: place it on the screen, find the mask that its pixels are drawn through (its own, less what the z-buffer
   puts in front of it), blit its five planes through that mask, and queue the clean-up that puts the background back. */
void CstScaleSprite( struct sprite *single, struct onScreenPerson *person, WORD x, WORD y, UWORD destinationtype)
{
  struct CstPlacement place;
  if( !CstPlaceSprite( &place, single, x, y)) {
    return;
  }
  UBYTE *mask = CstSpriteMask( single, person, &place);
  UWORD *destination = destinationtype == SCREEN ? (UWORD *) CstDrawBuffer : (UWORD *) CstBackDrop;
  CstBlitSprite( single, mask, &place, destination);
  CstQueueCleanup( person, &place, destinationtype != SCREEN);
}

/* To place a sprite: find the first and the last column and row of it that are on the screen, if there are any. */
CSTINLINE BOOL CstPlaceSprite( struct CstPlacement *place, struct sprite *single, WORD x, WORD y)
{
  int firstcolumn = x < 0 ? -x : 0;
  int lastcolumn = (int) winWidth - x - 1;
  if( lastcolumn > single->width - 1) lastcolumn = single->width - 1;
  int firstrow = y < 0 ? -y : 0;
  int endrow = (int) winHeight - y;
  if( endrow > single->height) endrow = single->height;
  if( lastcolumn < firstcolumn || endrow <= firstrow) {
    return FALSE;   /* nothing of it is on the screen */
  }

  place->x = x;
  place->y = y;
  place->words = single->width >> 4;
  place->firstword = firstcolumn >> 4;
  place->lastword = lastcolumn >> 4;
  place->firstrow = firstrow;
  place->endrow = endrow;
  return TRUE;
}

/* To blit a sprite: for each of the five bitplanes, copy the sprite's pixels to the screen where the mask is set and keep the
   screen where it isn't (D = A and B, or C and not A; A the mask, B the plane, C the screen). The blitter shifts both A and B
   right by x mod 16 and writes one word more than the sprite has, for what the shift pushes out of the last word. That word is
   left out when the sprite ends at the right edge of the screen (those pixels are off it), and the first word is written one
   word to the left of the screen when the sprite starts off the left edge (the mask keeps it from changing anything there). */
CSTINLINE void CstBlitSprite( struct sprite *single, UBYTE *mask, struct CstPlacement *place, UWORD *destination)
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  int shift = place->x & 15;
  int firstscreenword = (place->x >> 4) + place->firstword;   /* -1 when the first word starts off the left edge */
  int words = place->lastword - place->firstword + 1;
  int written = words + (shift ? 1 : 0);
  if( firstscreenword + written > CSTSCREENWORDS) written = CSTSCREENWORDS - firstscreenword;

  UWORD firstwordmask = firstscreenword < 0 ? 0xffff >> (16 - shift) : 0xffff;   /* the pixels left of the screen */
  UWORD lastwordmask = written > words ? 0 : 0xffff << shift;   /* the extra word has no pixels of its own; if it is left out, the bits
                                                                   the shift would push out of the last word are cleared, or they would
                                                                   come in at the start of the next row */
  LONG sourcerow = place->words * 2;
  LONG sourceoffset = place->firstrow * sourcerow + place->firstword * 2;
  LONG screenrow = winWidth / 8;
  LONG screenoffset = (place->y + place->firstrow) * screenrow + firstscreenword * 2;
  ULONG sourceplane = sourcerow * single->height;
  ULONG screenplane = screenrow * winHeight;
  UWORD size = ((place->endrow - place->firstrow) << 6) | written;

  ULONG bltapt = (ULONG) mask + sourceoffset;
  ULONG bltbpt = (ULONG) single->data + sourceoffset;
  ULONG bltcpt = (ULONG) destination + screenoffset;

  WaitBlit();
  custom->bltafwm = firstwordmask;
  custom->bltalwm = lastwordmask;
  custom->bltamod = sourcerow - written * 2;
  custom->bltbmod = sourcerow - written * 2;
  custom->bltcmod = screenrow - written * 2;
  custom->bltdmod = screenrow - written * 2;
  custom->bltcon0 = 0xfca + (shift << 12);
  custom->bltcon1 = shift << 12;
  for(int plane=0; plane<5; plane++) //ToDo other numbers of Bitplanes
  {
    custom->bltapt = (APTR) bltapt;
    custom->bltbpt = (APTR) bltbpt;
    custom->bltcpt = (APTR) bltcpt;
    custom->bltdpt = (APTR) bltcpt;
    custom->bltsize = size;
    bltbpt += sourceplane;
    bltcpt += screenplane;
    WaitBlit();
  }
}

/* To queue the clean-up of a sprite: remember the rectangle that it covers, so that the background is copied back over it before
   the next frame is drawn into this buffer. A paste into the backdrop changes both buffers, so it is queued for both. */
CSTINLINE void CstQueueCleanup( struct onScreenPerson *person, struct CstPlacement *place, BOOL bothbuffers)
{
  int firstscreenword = (place->x >> 4) + place->firstword;
  int lastscreenword = firstscreenword + place->lastword - place->firstword + ((place->x & 15) ? 1 : 0);
  if( firstscreenword < 0) firstscreenword = 0;
  if( lastscreenword > CSTSCREENWORDS - 1) lastscreenword = CSTSCREENWORDS - 1;

  CstQueueCleanupRectangle( &CstCleanupQueueDrawBuffer, person, place, firstscreenword, lastscreenword);
  if( bothbuffers) {
    CstQueueCleanupRectangle( &CstCleanupQueueViewBuffer, person, place, firstscreenword, lastscreenword);
  }
}

CSTINLINE void CstQueueCleanupRectangle( struct CleanupQueue **queue, struct onScreenPerson *person, struct CstPlacement *place, int firstscreenword, int lastscreenword)
{
  struct CleanupQueue *entry = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  entry->next = *queue;
  entry->x = place->x;
  entry->y = place->y;
  entry->person = person;
  entry->widthinwords = lastscreenword - firstscreenword + 1;
  entry->height = place->endrow - place->firstrow;
  entry->startxinbytes = firstscreenword * 2;
  entry->starty = place->y + place->firstrow;
  *queue = entry;
}

/* ---- The mask of a sprite, and the z-buffer -------------------------------------------------------------------------- */

/* The z-buffer is a list of panels, each a one-bit picture of what is in front of a character that stands behind it: the panel
   hides a sprite wherever its bit is set. A panel has a cut-off line: a character is in front of it if its y is greater than the
   cut-off, behind it if it isn't. */

/* To find the mask of a sprite: take its own, and for every panel that the sprite is behind and that overlaps it, take the panel's
   pixels out of it. A character with NOZBUFFER ignores the panels. The mask is the sprite's own if no panel touches it, and
   CstZBufferResult if one does. */
CSTINLINE UBYTE *CstSpriteMask( struct sprite *single, struct onScreenPerson *person, struct CstPlacement *place)
{
  UBYTE *own = (UBYTE *) single->data + (single->width >> 3) * single->height * 5;
  if( person && (person->extra & EXTRA_NOZB)) {
    return own;
  }

  if( !zBuffer) {
    return own;
  }
  int depth = person ? CstCharacterDepth( person) : 0;
  UBYTE *mask = own;
  for(struct zBufferData *panel = zBuffer; panel; panel = panel->nextPanel) {
    if( !CstBehindPanel( single, person, depth, place, panel)) continue;
    int firstrow = place->firstrow;
    int endrow = place->endrow;
    if( firstrow < panel->topy - place->y) firstrow = panel->topy - place->y;
    if( endrow > panel->topy + panel->height - place->y) endrow = panel->topy + panel->height - place->y;
    if( endrow <= firstrow) continue;
    mask = CstTakePanelOut( place, panel, firstrow, endrow, own, mask);
  }
  return mask;
}

/* The line that a character's depth is judged by: its y, rounded up (it is in front of a panel if y is greater than the cut-off). */
CSTINLINE int CstCharacterDepth( struct onScreenPerson *person)
{
  int depth = (int) person->y;
  if( person->y > depth) depth++;
  return depth;
}

/* A character is behind a panel unless its y is greater than the cut-off. A sprite pasted into the backdrop has no character;
   it is behind a panel if its bottom edge is above the cut-off, except for a front panel (cut-off CSTFRONTPANEL or more: the frame,
   the toolbar and the text boxes of the game): pictures pasted into the backdrop are the game's own interface, drawn on that
   panel's ground (the toolbar's buttons, a box's corners), and the panel must not hide them. Only panels as wide as the screen are
   supported. */
#define CSTFRONTPANEL 1000
CSTINLINE BOOL CstBehindPanel( struct sprite *single, struct onScreenPerson *person, int depth, struct CstPlacement *place, struct zBufferData *panel)
{
  if( panel->width != (int) winWidth || panel->topx != 0) return FALSE;
  if( person) return depth <= panel->yz;
  if( panel->yz >= CSTFRONTPANEL) return FALSE;
  return place->y + single->height < panel->yz;
}

/* To take a panel out of a mask, in two blits. The first moves the panel's bits into the sprite's own column grid, which is
   shifted by x mod 16 against the screen's: it reads one word more than the sprite has, and the first word it writes is
   the one that has no word before it (the panel may lack one before the first, so what it reads there is not the panel's;
   those bits are off the screen anyway) and is skipped. The second clears the mask where the panel has a bit: D = B and not A.
   Only the words and rows of the sprite that are on the screen are touched. The first panel that touches a sprite copies the
   sprite's mask into CstZBufferResult, unless it covers all of what is on the screen. */
CSTINLINE UBYTE *CstTakePanelOut( struct CstPlacement *place, struct zBufferData *panel, int firstrow, int endrow, UBYTE *own, UBYTE *mask)
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  int shift = place->x & 15;
  int words = place->lastword - place->firstword + 1;
  int read = shift ? words + 1 : words;
  int rows = endrow - firstrow;
  LONG spriterow = place->words * 2;
  LONG spriteoffset = firstrow * spriterow + place->firstword * 2;
  LONG panelrow = panel->width / 8;
  LONG paneloffset = (place->y + firstrow - panel->topy) * panelrow + ((place->x >> 4) + place->firstword) * 2;

  if( mask == own && (firstrow != place->firstrow || endrow != place->endrow)) {
    CstCopyMask( own, CstZBufferResult, place->firstrow * spriterow + place->firstword * 2, spriterow, words, place->endrow - place->firstrow);
    mask = CstZBufferResult;
  }

  WaitBlit();
  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltcon0 = 0x9f0 + ((shift ? 16 - shift : 0) << 12);
  custom->bltcon1 = 0;
  custom->bltamod = panelrow - read * 2;
  custom->bltdmod = 0;
  custom->bltapt = (APTR) ((ULONG) panel->bitplane + paneloffset);
  custom->bltdpt = (APTR) CstZBufferWork;
  custom->bltsize = (rows << 6) | read;

  WaitBlit();
  custom->bltcon0 = 0xd0c;
  custom->bltamod = (read - words) * 2;
  custom->bltbmod = spriterow - words * 2;
  custom->bltdmod = spriterow - words * 2;
  custom->bltapt = (APTR) ((ULONG) CstZBufferWork + (shift ? 2 : 0));
  custom->bltbpt = (APTR) ((ULONG) mask + spriteoffset);
  custom->bltdpt = (APTR) ((ULONG) CstZBufferResult + spriteoffset);
  custom->bltsize = (rows << 6) | words;
  return CstZBufferResult;
}

/* To copy a rectangle of a sprite's mask. */
CSTINLINE void CstCopyMask( UBYTE *from, UBYTE *to, LONG offset, LONG row, int words, int rows)
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  WaitBlit();
  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltcon0 = 0x9f0;
  custom->bltcon1 = 0;
  custom->bltamod = row - words * 2;
  custom->bltdmod = row - words * 2;
  custom->bltapt = (APTR) ((ULONG) from + offset);
  custom->bltdpt = (APTR) ((ULONG) to + offset);
  custom->bltsize = (rows << 6) | words;
}

#pragma GCC pop_options

void CstSetCl(UWORD *copperlist)
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  custom->cop1lc = (ULONG) copperlist;
}

void CstSwapBuffer( ) {
  ULONG *tmp;
  tmp = CstViewBuffer;
  CstViewBuffer = CstDrawBuffer;
  CstDrawBuffer = tmp;

  struct CleanupQueue *tmp2 = CstCleanupQueueViewBuffer;
  CstCleanupQueueViewBuffer = CstCleanupQueueDrawBuffer;
  CstCleanupQueueDrawBuffer = tmp2;

  UWORD *copword = CstCopperList;
  ULONG ptr = (ULONG) CstViewBuffer;
  UWORD highword = ptr >> 16;
  UWORD lowword = ptr & 0xffff;

  copword[CSTBPL1LOW] = lowword;
  copword[CSTBPL1HIGH] = highword;

  ptr +=  40*256;
  highword = ptr >> 16;
  lowword = ptr & 0xffff;

  copword[CSTBPL2LOW] = lowword;
  copword[CSTBPL2HIGH] = highword;

  ptr +=  40*256;
  highword = ptr >> 16;
  lowword = ptr & 0xffff;

  copword[CSTBPL3LOW] = lowword;
  copword[CSTBPL3HIGH] = highword;

  ptr +=  40*256;
  highword = ptr >> 16;
  lowword = ptr & 0xffff;

  copword[CSTBPL4LOW] = lowword;
  copword[CSTBPL4HIGH] = highword;

  ptr +=  40*256;
  highword = ptr >> 16;
  lowword = ptr & 0xffff;

  copword[CSTBPL5LOW] = lowword;
  copword[CSTBPL5HIGH] = highword;

}

BOOL CstReserveBackdrop(int width, int height) {

  KPrintF("CstReserveBackdrop: Begin");
  KPrintF("CHIP: %ld bytes free at the start", (long) AvailMem( MEMF_CHIP));

  width = width / 8;

  if( width < 40)
  {
    KPrintF("CstReserveBackdrop: Screens smaller than 320px not supported.");
    return FALSE;
  }
  KPrintF("CstReserveBackdrop: Screen Okay");

  CstCopperList = CstCreateCopperlist( width);
  KPrintF("CstReserveBackdrop: Copperlist created");
  CstBackdropSizePlane = width*height;
  CstBackdropSize = CstBackdropSizePlane * 5; //Todo: Support other Bitplane Modes;


  CstBackDrop = CstAllocVec(CstBackdropSize,MEMF_CHIP);
  if( !CstBackDrop)
  {
    KPrintF("CstReserveBackdrop: Cannot allocate memory for Backdrop");
    return FALSE;
  }
  KPrintF("CstReserveBackdrop: Backdrop reserved");

  //Initialize Buffer
  ULONG *cursor = (ULONG *)CstBackDrop;
  for(int i=0;i<CstBackdropSize/4;i++)
  {
    *cursor++ = 0;
  }

  CstDrawBuffer = CstAllocVec(CstBackdropSize+width*2,MEMF_CHIP); //Some extra size for bob routine border area
  if( !CstDrawBuffer)
  {
    KPrintF("CstReserveBackdrop: Cannot allocate memory for DrawBuffer");
    return FALSE;
  }
  KPrintF("CstReserveBackdrop: DrawBuffer reserved");

  CstViewBuffer = CstAllocVec(CstBackdropSize+width*2,MEMF_CHIP); //Some extra size for bob routine border area
  if( !CstViewBuffer)
  {
    KPrintF("CstReserveBackdrop: Cannot allocate memory for ViewBuffer");
    return FALSE;
  }
  KPrintF("CstReserveBackdrop: ViewBuffer reserved");

  CstDrawBuffer += width/4; //divide with 4 because pointer is ulong
  CstViewBuffer += width/4; //divide with 4 because pointer is ulong

  CstZBufferResult = CstAllocVec( CSTMAXWIDTHSPRITE/8*CSTMAXHEIGHTSPRITE,MEMF_CHIP);
  CstZBufferWork = CstAllocVec( (CSTMAXWIDTHSPRITE/8+2)*CSTMAXHEIGHTSPRITE,MEMF_CHIP);

#ifdef EMULATOR
  debug_register_bitmap(CstBackDrop, "CstBackDrop.bpl", 320, 256, 5, 0);
  debug_register_bitmap(CstDrawBuffer, "drawbuffer.bpl", width*8, height, 5, 0);
  debug_register_bitmap(CstViewBuffer, "viewbuffer.bpl", width*8, height, 5, 0);
#endif



  if( !CstCopperList || ! CstDrawBuffer || !CstViewBuffer)
  {
    KPrintF("CstReserveBackdrop: Memory allocation failed");
    return FALSE;
  }

  KPrintF("CHIP: %ld bytes free with the screen buffers", (long) AvailMem( MEMF_CHIP));
  KPrintF("CstReserveBackdrop: Setting Copperlist");
  CstSetCl( CstCopperList);
  KPrintF("CstReserveBackdrop: Copperlist Set");
  return TRUE;

}

void CstUnfreeze() {
  KPrintF("CstUnfreeze: Unfreezing Background Started\n");

  UWORD size = winWidth/8*winHeight*5;

  //Writing to Framebuffer
  volatile struct Custom *custom = (struct Custom*)0xdff000;

#ifdef EMULATOR
  debug_register_bitmap(CstBackDropBackup, "BackDropBackup", winWidth, winHeight, 5, 0);
#endif

  if(!CstBackDrop) {
    KPrintF("CstUnfreeze: No Backdrop found, this should not happen!");
    return;
  }

  if(!CstBackDropBackup) {
    KPrintF("CstUnfreeze: No Backup Backdrop found, this should not happen!");
    return;
  }

  KPrintF("CstUnfreeze: Restoring Backdrop from Backup\n");
  ULONG *src = (ULONG *) CstBackDropBackup;
  ULONG *dst = (ULONG *) CstBackDrop;
  for(int i=0;i<size/4;i++)
  {
    *dst++ = *src++;
  }

  KPrintF("CstUnfreeze: Backdrop restored\n");

  struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
  KPrintF("CstUnfreeze: Allocating memory to CstCleanupQueueDrawBuffer\n");
  CstCleanupQueueDrawBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  if(!CstCleanupQueueDrawBuffer) {
    KPrintF("CstUnfreeze: Cannot allocate CleanupQueueDrawBuffer");
    return;
  } else
    KPrintF("CstUnfreeze: Memory allocated to CstCleanupQueueDrawBuffer\n");
  CstCleanupQueueDrawBuffer->next = next;
  CstCleanupQueueDrawBuffer->x = 0;
  CstCleanupQueueDrawBuffer->y = 0;
  CstCleanupQueueDrawBuffer->person = NULL;
  CstCleanupQueueDrawBuffer->widthinwords = winWidth/16;
  CstCleanupQueueDrawBuffer->height = winHeight;
  CstCleanupQueueDrawBuffer->startxinbytes = 0;
  CstCleanupQueueDrawBuffer->starty = 0;
  next = CstCleanupQueueViewBuffer;
  KPrintF("CstUnfreeze: Allocating memory to CstCleanupQueueViewBuffer\n");
  CstCleanupQueueViewBuffer = CstAllocVec( sizeof(struct CleanupQueue), MEMF_ANY);
  if(!CstCleanupQueueViewBuffer) {
    KPrintF("CstUnfreeze: Cannot allocate CstCleanupQueueViewBuffer");
    return;
  } else
  KPrintF("CstUnfreeze: Memory allocated to CstCleanupQueueViewBuffer\n");
  CstCleanupQueueViewBuffer->next = next;
  KPrintF("CstUnfreeze: Setting CstCleanupQueueViewBuffer x property\n");
  CstCleanupQueueViewBuffer->x = 0;
  KPrintF("CstUnfreeze: Setting CstCleanupQueueViewBuffer y property\n");
  CstCleanupQueueViewBuffer->y = 0;
  KPrintF("CstUnfreeze: Setting CstCleanupQueueViewBuffer person property\n");
  CstCleanupQueueViewBuffer->person = NULL;
  KPrintF("CstUnfreeze: Setting CstCleanupQueueViewBuffer widthinwords property\n");
  CstCleanupQueueViewBuffer->widthinwords = winWidth/16;
  KPrintF("CstUnfreeze: Setting CstCleanupQueueViewBuffer height property\n");
  CstCleanupQueueViewBuffer->height = winHeight;
  KPrintF("CstUnfreeze: Setting CstCleanupQueueViewBuffer startxinbytes property\n");
  CstCleanupQueueViewBuffer->startxinbytes = 0;
  KPrintF("CstUnfreeze: Setting CstCleanupQueueViewBuffer starty property\n");
  CstCleanupQueueViewBuffer->starty = 0;
  KPrintF("CstUnfreeze: Freeing backdrop\n");

  if( CstBackDropBackup) {
    KPrintF("CstUnfreeze: Free CstBackdropBackup");
    CstFreeVec( CstBackDropBackup);
  }

  KPrintF("CstUnfreeze: Finished\n");

}

void CstSaveSnapshot(BPTR fp) {
    KPrintF("CstSaveSnapshot: Saving snapshot\n");
    UWORD size = winWidth/8*winHeight*5;

    if (CstPalette) {
        FWrite(fp, CstPalette, 2, 32);
    } else {
        for (int i = 0; i < 32; i++) put2bytes(0, fp);
    }

    if (CstBackDrop) {
        FWrite(fp, CstBackDrop, 1, size);
    }
}

BOOL CstRestoreSnapshot(BPTR fp) {
    KPrintF("CstRestoreSnapshot: Restoring snapshot\n");
    UWORD size = winWidth/8*winHeight*5;

    if (CstPalette) {
        FRead(fp, CstPalette, 2, 32);
        CstLoadPalette = 1;
    } else {
        for (int i = 0; i < 32; i++) get2bytes(fp);
    }

    if (!CstBackDrop) return FALSE;
    FRead(fp, CstBackDrop, 1, size);

    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = CstAllocVec(sizeof(struct CleanupQueue), MEMF_ANY);
    if (!CstCleanupQueueDrawBuffer) return FALSE;
    CstCleanupQueueDrawBuffer->next = next;
    CstCleanupQueueDrawBuffer->x = 0;
    CstCleanupQueueDrawBuffer->y = 0;
    CstCleanupQueueDrawBuffer->person = NULL;
    CstCleanupQueueDrawBuffer->widthinwords = winWidth/16;
    CstCleanupQueueDrawBuffer->height = winHeight;
    CstCleanupQueueDrawBuffer->startxinbytes = 0;
    CstCleanupQueueDrawBuffer->starty = 0;

    next = CstCleanupQueueViewBuffer;
    CstCleanupQueueViewBuffer = CstAllocVec(sizeof(struct CleanupQueue), MEMF_ANY);
    if (!CstCleanupQueueViewBuffer) return FALSE;
    CstCleanupQueueViewBuffer->next = next;
    CstCleanupQueueViewBuffer->x = 0;
    CstCleanupQueueViewBuffer->y = 0;
    CstCleanupQueueViewBuffer->person = NULL;
    CstCleanupQueueViewBuffer->widthinwords = winWidth/16;
    CstCleanupQueueViewBuffer->height = winHeight;
    CstCleanupQueueViewBuffer->startxinbytes = 0;
    CstCleanupQueueViewBuffer->starty = 0;

    KPrintF("CstRestoreSnapshot: Done\n");
    return TRUE;
}