/* The game file (the .slg, held open as bigDataFile) is read through this layer instead of dos.library's FGetC, FRead and Seek.
   Measured on the emulated A1200 (wiki/queries/a3e-speed-2.md): every packet to the file system costs about 3 ms whatever its size,
   FGetC about 28 microseconds a byte, and FRead as much a byte (8 KB in 234 ms) where Read gives 8 KB in 2.6 ms. So the layer
     - keeps a few blocks of the file in memory (a miss reads one block with one Read, a hit costs a copy),
     - answers a byte, a word or a longword from the block that holds it (the fast path is the two inline functions below),
     - reads large pieces straight into the caller's buffer with one Read.
   The file is never written, so the blocks need no invalidation. All offsets are absolute file offsets.
   The layer owns the file's position: once GfInit has been called nothing else may Seek, Read or FGetC the handle. */
#ifndef GAMEFILE_H
#define GAMEFILE_H

#include <exec/types.h>
#include <dos/dos.h>

void GfInit( BPTR file);
void GfSeek( ULONG position);
ULONG GfTell( void);
int GfFillGetC( void);
ULONG GfRead( void *destination, ULONG count);
ULONG GfGet4( void);
void GfStats( ULONG *hits, ULONG *misses, ULONG *bulk);

extern const UBYTE *GfCur, *GfEnd;

/* The next byte, or -1 at the end of the file. */
static inline int GfGetC( void)
{
  if( GfCur < GfEnd) return *GfCur++;
  return GfFillGetC();
}

/* The two bytes the SLUDGE file formats store high byte first. */
static inline int GfGet2( void)
{
  int high = GfGetC();
  int low = GfGetC();
  return high * 256 + low;
}

#endif
