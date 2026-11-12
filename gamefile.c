/* The game file read through a block cache, see gamefile.h. */
#include <exec/memory.h>
#include <proto/exec.h>
#include <proto/dos.h>

#include "custom.h"
#include "gamefile.h"
#include "profile.h"
#include "support/gcc8_c_support.h"

#define GF_SHIFT 12                      /* a block is 4 KB: one Read costs the same for 64 bytes and for 8 KB (the packet is the cost) */
#define GF_BLOCK (1UL << GF_SHIFT)
#define GF_BLOCKS 12                     /* 48 KB; taken from the heap when the first block is needed */

struct GfBlock
{
  ULONG number;                          /* the block's place in the file: offset >> GF_SHIFT; ~0 when the slot is empty */
  ULONG stamp;                           /* the use counter at the block's last use: the smallest is the one to replace */
  ULONG length;                          /* bytes in the block, less than GF_BLOCK only at the end of the file */
  UBYTE *data;
};

static BPTR gfFile;
static struct GfBlock gfBlocks[GF_BLOCKS];
static ULONG gfClock;

static const UBYTE *gfData;              /* the data of the block the position is in, NULL when the position is only known as gfLazy */
static ULONG gfBase;                     /* the file offset of gfData[0] */
static ULONG gfLazy;                     /* the position after a direct read or a seek that did not load its block yet */

const UBYTE *GfCur, *GfEnd;              /* the next byte and the end of the block's data: the inline GfGetC reads between them */

ULONG gfHits, gfMisses, gfBulk;

void GfInit( BPTR file)
{
  gfFile = file;
  gfData = NULL;
  GfCur = GfEnd = NULL;
  gfLazy = 0;
  for( int i = 0; i < GF_BLOCKS; i++) gfBlocks[i].number = ~0UL;
}

void GfStats( ULONG *hits, ULONG *misses, ULONG *bulk)
{
  *hits = gfHits; *misses = gfMisses; *bulk = gfBulk;
}

/* The file offset of the next byte. */
ULONG GfTell( void)
{
  return gfData ? gfBase + (ULONG) (GfCur - gfData) : gfLazy;
}

/* To find block `number`, reading it when it is not in memory. NULL at or beyond the end of the file. */
static struct GfBlock *gfFind( ULONG number)
{
  struct GfBlock *victim = NULL;
  for( int i = 0; i < GF_BLOCKS; i++) {
    if( gfBlocks[i].number == number) {
      gfBlocks[i].stamp = ++gfClock;
      gfHits++;
      return &gfBlocks[i];
    }
  }
  for( int i = 0; i < GF_BLOCKS; i++) {                 /* an empty slot, or the one used longest ago */
    if( gfBlocks[i].number == ~0UL) { victim = &gfBlocks[i]; break; }
    if( !victim || gfBlocks[i].stamp < victim->stamp) victim = &gfBlocks[i];
  }
  if( !victim->data) {
    victim->data = AllocVec( GF_BLOCK, MEMF_ANY);
    if( !victim->data) { KPrintF( "GfFind: cannot allocate a block\n"); return NULL; }
  }
  gfMisses++;
  victim->number = ~0UL;
  Seek( gfFile, number << GF_SHIFT, OFFSET_BEGINNING);
  LONG got = Read( gfFile, victim->data, GF_BLOCK);
  if( got <= 0) return NULL;
  victim->number = number;
  victim->length = (ULONG) got;
  victim->stamp = ++gfClock;
  return victim;
}

/* To make the byte at `position` the next one. Returns FALSE at or beyond the end of the file (nothing to read there). */
static BOOL gfSelect( ULONG position)
{
  struct GfBlock *block = gfFind( position >> GF_SHIFT);
  if( !block) {
    gfData = NULL;
    GfCur = GfEnd = NULL;
    gfLazy = position;
    return FALSE;
  }
  gfData = block->data;
  gfBase = (position >> GF_SHIFT) << GF_SHIFT;
  GfCur = gfData + (position & (GF_BLOCK - 1));
  GfEnd = gfData + block->length;
  return GfCur < GfEnd;
}

/* A seek loads nothing: the block comes when the first byte is wanted, and a position inside the block in hand costs nothing. */
void GfSeek( ULONG position)
{
  if( gfData && position >= gfBase && position <= gfBase + (ULONG) (GfEnd - gfData)) {
    GfCur = gfData + (position - gfBase);
    return;
  }
  gfData = NULL;
  GfCur = GfEnd = NULL;
  gfLazy = position;
}

/* The slow side of GfGetC: the block is used up (or was never loaded). */
int GfFillGetC( void)
{
  if( !gfSelect( GfTell())) return -1;
  return *GfCur++;
}

ULONG GfGet4( void)
{
  ULONG f1 = GfGetC(), f2 = GfGetC(), f3 = GfGetC(), f4 = GfGetC();
  return f1 + f2 * 256 + f3 * 65536 + f4 * 16777216;
}

/* To copy `count` bytes from the file to `destination`, from the blocks while they last, and a piece of a block or more straight
   from the file with one Read. Returns the bytes read (less than count only at the end of the file). */
ULONG GfRead( void *destination, ULONG count)
{
  UBYTE *to = destination;
  ULONG total = 0;
  while( count) {
    ULONG available = (GfCur && GfEnd > GfCur) ? (ULONG) (GfEnd - GfCur) : 0;
    if( available) {
      ULONG piece = available < count ? available : count;
      if( piece >= 32) CopyMem( (APTR) GfCur, to, piece);
      else for( ULONG i = 0; i < piece; i++) to[i] = GfCur[i];
      GfCur += piece; to += piece; count -= piece; total += piece;
    } else if( count >= GF_BLOCK) {
      ULONG position = GfTell();
      Seek( gfFile, position, OFFSET_BEGINNING);
      LONG got = Read( gfFile, to, count);
      gfBulk++;
      if( got < 0) got = 0;
      total += (ULONG) got;
      gfData = NULL;
      GfCur = GfEnd = NULL;
      gfLazy = position + (ULONG) got;
      return total;
    } else if( !gfSelect( GfTell())) {
      break;
    }
  }
  return total;
}
