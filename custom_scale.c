/* Scaled copies of character sprites (plan E7, wiki/plan-amiga.md).

   CstScaleSprite draws a sprite at its own size only. A room that scales its characters (setScale with a divide other than 0:
   Road) gets copies of the sprites of those characters at sizes in steps of 10 percent, made once by the CPU; the sprite that is
   drawn is the copy nearest to the character's scale. The sizes are the ones the room's floor can produce, so Road, whose scale
   is 0.82 to 1.13 on its floor, has 0.8, 0.9 and 1.1 besides the original, which is 1.0.

   A copy is a sprite like any other (five planes and a mask, the width a multiple of 16) with a hotspot of its own. It is made
   by taking, for every pixel of the copy, the pixel of the original that lies at the same distance from the hotspot divided by
   the scale (nearest pixel, the distance cut towards the hotspot), so the feet stay where the character stands at every size
   and the same rows are taken in every frame of an animation. */

#include <exec/types.h>
#include <proto/exec.h>

#include "custom.h"
#include "floor.h"
#include "people.h"
#include "sprbanks.h"
#include "sprites.h"
#include "support/gcc8_c_support.h"

extern struct flor * currentFloor;
extern struct onScreenPerson * allPeople;

#define CSTSTEPNORMAL 10        /* the original, in tenths */
#define CSTSTEPLOWEST 5         /* no copy is smaller than 0.5 or bigger than 1.5 */
#define CSTSTEPHIGHEST 15

static int CstHorizon = 0, CstDivide = 0;       /* the room's setScale */
static BOOL CstBuildArmed = FALSE;              /* setScale asked for copies and they are not made yet */
static int CstFirstStep = CSTSTEPNORMAL, CstLastStep = CSTSTEPNORMAL;    /* the sizes there are copies of, in tenths */

#pragma GCC push_options
#pragma GCC optimize ("Ofast")

/* The distance from the hotspot in the original that a distance in the copy stands for: scaled back, cut towards the hotspot. */
static inline int CstSourceOffset( int offset, int step) {
  return offset * CSTSTEPNORMAL / step;
}

/* The distances in the copy (from the hotspot) whose source lies in the original's range from `first` to `last`: from the one
   that reaches `first` to the one that reaches `last`. The range includes the hotspot (0) so that the copy's hotspot lies in it. */
static void CstCopyRange( int first, int last, int step, int *from, int *to) {
  int low = first * step / CSTSTEPNORMAL - 2;
  int high = last * step / CSTSTEPNORMAL + 2;
  while( CstSourceOffset( low, step) < first) low++;
  while( CstSourceOffset( high, step) > last) high--;
  *from = low;
  *to = high;
}

/* To find the rectangle of an original that has pixels in it (set bits of its mask), as columns and rows. */
static BOOL CstInk( struct sprite *original, int *x0, int *y0, int *x1, int *y1) {
  int rowbytes = original->width >> 3;
  UBYTE *mask = (UBYTE *) original->data + rowbytes * original->height * 5;
  BOOL found = FALSE;
  *x0 = original->width;
  *x1 = -1;
  *y0 = original->height;
  *y1 = -1;
  for(int y=0; y<original->height; y++) {
    for(int byte=0; byte<rowbytes; byte++) {
      UBYTE bits = mask[y * rowbytes + byte];
      if( !bits) continue;
      found = TRUE;
      int leftmost = byte * 8, rightmost = byte * 8 + 7;
      while( !(bits & (0x80 >> (leftmost - byte * 8)))) leftmost++;
      while( !(bits & (0x80 >> (rightmost - byte * 8)))) rightmost--;
      if( leftmost < *x0) *x0 = leftmost;
      if( rightmost > *x1) *x1 = rightmost;
      if( y < *y0) *y0 = y;
      if( y > *y1) *y1 = y;
    }
  }
  return found;
}

/* The columns and rows of the original that the columns and rows of a copy take their pixels from (-1: none), found once for the
   copy: the division that finds them is a library call on a 68000, far too slow to repeat for every pixel. */
#define CSTMAXCOPYSIDE 512
static short CstColumnMap[CSTMAXCOPYSIDE], CstRowMap[CSTMAXCOPYSIDE];

static void CstMapAxis( short *map, int count, int from, int hotspot, int size, int step) {
  for(int i=0; i<count; i++) {
    int source = hotspot + CstSourceOffset( from + i, step);
    map[i] = source < 0 || source >= size ? -1 : source;
  }
}

/* To fill a copy: its pixel in a column and a row is the original's pixel in the column and the row that the maps say, all six
   planes (the sixth is the mask). The copy starts out empty (transparent), so only pixels with ink are copied. */
static void CstFillCopy( struct sprite *copy, struct sprite *original, int step, int fromx, int fromy) {
  int destrow = copy->width >> 3, sourcerow = original->width >> 3;
  ULONG destplane = destrow * copy->height, sourceplane = sourcerow * original->height;
  UBYTE *dest = (UBYTE *) copy->data;
  UBYTE *source = (UBYTE *) original->data;
  UBYTE *sourcemask = source + 5 * sourceplane;

  CstMapAxis( CstColumnMap, copy->width, fromx, original->xhot, original->width, step);
  CstMapAxis( CstRowMap, copy->height, fromy, original->yhot, original->height, step);
  for(int row=0; row<copy->height; row++) {
    int sy = CstRowMap[row];
    if( sy < 0) continue;
    for(int column=0; column<copy->width; column++) {
      int sx = CstColumnMap[column];
      if( sx < 0) continue;
      int sourcebyte = sy * sourcerow + (sx >> 3);
      UBYTE sourcebit = 0x80 >> (sx & 7);
      if( !(sourcemask[sourcebyte - 0] & sourcebit)) continue;
      int destbyte = row * destrow + (column >> 3);
      UBYTE destbit = 0x80 >> (column & 7);
      dest[5 * destplane + destbyte] |= destbit;
      for(int plane=0; plane<5; plane++) {      //ToDo other numbers of Bitplanes
        if( source[plane * sourceplane + sourcebyte] & sourcebit) dest[plane * destplane + destbyte] |= destbit;
      }
    }
  }
}

/* To make the copy of a sprite at a size (in tenths). The copy covers the original's ink and its hotspot. */
static BOOL CstMakeCopy( struct sprite *copy, struct sprite *original, int step) {
  int inkx0, inky0, inkx1, inky1;
  if( !CstInk( original, &inkx0, &inky0, &inkx1, &inky1)) {
    inkx0 = inkx1 = original->xhot;     /* nothing in it: a copy of one pixel's width, which is empty */
    inky0 = inky1 = original->yhot;
  }
  int fromx, tox, fromy, toy;
  int left = inkx0 - original->xhot, right = inkx1 - original->xhot;
  int top = inky0 - original->yhot, bottom = inky1 - original->yhot;
  CstCopyRange( left < 0 ? left : 0, right > 0 ? right : 0, step, &fromx, &tox);
  CstCopyRange( top < 0 ? top : 0, bottom > 0 ? bottom : 0, step, &fromy, &toy);

  copy->width = (tox - fromx + 1 + 15) & ~15;
  copy->height = toy - fromy + 1;
  if( copy->width > CSTMAXCOPYSIDE || copy->height > CSTMAXCOPYSIDE) {
    KPrintF("SCALE: a copy of %ld x %ld is over the limit, left out", (long) copy->width, (long) copy->height);
    copy->width = copy->height = 0;
    copy->data = NULL;
    return FALSE;
  }
  copy->xhot = -fromx;
  copy->yhot = -fromy;
  copy->tex_x = 0;
  copy->texNum = 0;
  copy->steps = NULL;
  ULONG size = (copy->width >> 3) * copy->height * 6;
  copy->data = CstAllocVec( size, MEMF_CHIP | MEMF_CLEAR);
  CstFillCopy( copy, original, step, fromx, fromy);
  return TRUE;
}

#pragma GCC pop_options

/* ---- The copies of a bank ------------------------------------------------------------------------------------------------ */

static int CstStepCount() {
  return CstLastStep - CstFirstStep + 1;
}

/* To free the copies of a sprite. */
static void CstForgetCopies( struct sprite *original) {
  if( !original->steps) return;
  for(int i=0; i<CstStepCount(); i++) {
    if( original->steps[i].data) CstFreeVec( original->steps[i].data);
  }
  CstFreeVec( original->steps);
  original->steps = NULL;
}

void CstForgetScaledSprites( struct loadedSpriteBank *bank) {
  for(int i=0; i<bank->bank.total; i++) {
    CstForgetCopies( &bank->bank.sprites[i]);
  }
  bank->scaled = FALSE;
}

static void CstForgetAllCopies() {
  for(struct loadedSpriteBank *bank = allLoadedBanks; bank; bank = bank->next) {
    if( bank->scaled) CstForgetScaledSprites( bank);
  }
}

static void CstMakeCopies( struct loadedSpriteBank *bank) {
  for(int i=0; i<bank->bank.total; i++) {
    struct sprite *original = &bank->bank.sprites[i];
    original->steps = CstAllocVec( sizeof(struct sprite) * CstStepCount(), MEMF_ANY);
    for(int step=CstFirstStep; step<=CstLastStep; step++) {
      struct sprite *copy = &original->steps[step - CstFirstStep];
      if( step == CSTSTEPNORMAL) {
        copy->data = NULL;       /* the original is the copy of size 1.0 */
      } else {
        CstMakeCopy( copy, original, step);
      }
    }
  }
  bank->scaled = TRUE;
}

/* ---- Which sizes, which banks, and when ------------------------------------------------------------------------------------ */

static int CstStepOf( FLOAT scale) {
  int step = (int) (scale * CSTSTEPNORMAL + 0.5);
  return step < CSTSTEPLOWEST ? CSTSTEPLOWEST : step > CSTSTEPHIGHEST ? CSTSTEPHIGHEST : step;
}

/* The sizes the floor can produce: the scale of the lowest and the highest vertex of any polygon, in steps of 10 percent. */
static BOOL CstFloorSteps() {
  if( !currentFloor || !currentFloor->vertex || currentFloor->numPolygons <= 0) return FALSE;
  int lowest = 0x7fff, highest = -0x7fff;
  for(int p=0; p<currentFloor->numPolygons; p++) {
    for(int v=0; v<currentFloor->polygon[p].numVertices; v++) {
      int y = currentFloor->vertex[currentFloor->polygon[p].vertexID[v]].y;
      if( y < lowest) lowest = y;
      if( y > highest) highest = y;
    }
  }
  if( lowest > highest) return FALSE;
  CstFirstStep = CstStepOf( (FLOAT) (lowest - CstHorizon) / CstDivide);
  CstLastStep = CstStepOf( (FLOAT) (highest - CstHorizon) / CstDivide);
  if( CstFirstStep > CSTSTEPNORMAL) CstFirstStep = CSTSTEPNORMAL;     /* the original is always one of the sizes */
  if( CstLastStep < CSTSTEPNORMAL) CstLastStep = CSTSTEPNORMAL;
  return TRUE;
}

static BOOL CstScalesLikeTheRoom( struct onScreenPerson *person) {
  return !(person->extra & EXTRA_NOSCALE);
}

/* To find the banks of the characters that scale (shown or not), each once: all the animations of their costumes. */
static int CstBanksOfScalingCharacters( struct loadedSpriteBank **banks, int room) {
  int count = 0;
  for(struct onScreenPerson *person = allPeople; person; person = person->next) {
    if( !CstScalesLikeTheRoom( person) || !person->myPersona) continue;
    struct persona *costume = person->myPersona;
    for(int a=0; a<costume->numDirections * 3; a++) {      /* standing, walking and talking animations of each direction */
      struct personaAnimation *animation = costume->animation[a];
      if( !animation || !animation->theSprites || animation->theSprites->bank.type != 2) continue;
      BOOL known = FALSE;
      for(int i=0; i<count; i++) known |= banks[i] == animation->theSprites;
      if( !known && count < room) banks[count++] = animation->theSprites;
    }
  }
  return count;
}

/* setScale (horizon, divide): the copies made for another scale go; with a divide, new ones are made as soon as a character that
   scales and a floor are there. */
void CstScaleChanged( int horizon, int divide) {
  if( horizon == CstHorizon && divide == CstDivide) return;
  CstForgetAllCopies();
  CstHorizon = horizon;
  CstDivide = divide;
  CstBuildArmed = divide != 0;
}

#define CSTMAXBANKS 16

/* To make the copies, once, when a game pass finds that there is something to make them for. It runs before the pass draws, so
   a room that is entered from a black screen builds them there. */
void CstBuildScaledSprites() {
  if( !CstBuildArmed || !CstFloorSteps()) return;
  struct loadedSpriteBank *banks[CSTMAXBANKS];
  int count = CstBanksOfScalingCharacters( banks, CSTMAXBANKS);
  if( count == 0) return;

  ULONG before = AvailMem( MEMF_CHIP);
  KPrintF("SCALE: sizes %ld to %ld tenths for %ld banks", (long) CstFirstStep, (long) CstLastStep, (long) count);
  for(int i=0; i<count; i++) {
    if( !banks[i]->scaled) CstMakeCopies( banks[i]);
  }
  KPrintF("SCALE: copies made, %ld bytes of chip RAM", (long) (before - AvailMem( MEMF_CHIP)));
  CstBuildArmed = FALSE;
}

/* ---- Choosing the copy to draw -------------------------------------------------------------------------------------------- */

/* The sprite to draw for a character: the copy nearest to its scale, or the sprite itself. A new size is taken up when the animation
   frame changes (a step of 10 percent makes Pen 5 or 6 pixels taller or shorter, which is less noticeable with a new frame), or
   at once when the character is not walking. */
struct sprite *CstSpriteForPerson( struct sprite *single, struct onScreenPerson *person) {
  if( !single->steps || !CstScalesLikeTheRoom( person)) return single;

  int wanted = CstStepOf( person->scale);
  if( !person->scaleStep || !person->walking || person->frameNum != person->scaleFrame) {
    person->scaleStep = wanted;
    person->scaleFrame = person->frameNum;
  }
  int step = person->scaleStep;
  if( step < CstFirstStep) step = CstFirstStep;
  if( step > CstLastStep) step = CstLastStep;
  struct sprite *copy = &single->steps[step - CstFirstStep];
  return step == CSTSTEPNORMAL || !copy->data ? single : copy;
}
