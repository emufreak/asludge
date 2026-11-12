/* The engine's profiler, see profile.h. Compiled only with -DPROFILE. */
#ifdef PROFILE

#include <exec/memory.h>
#include <exec/io.h>
#include <exec/ports.h>
#include <dos/dos.h>
#include <dos/stdio.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <inline/timer.h>
#include <devices/timer.h>

#include "custom.h"
#include "fileset.h"
#include "profile.h"
#include "support/gcc8_c_support.h"

#define PROF_STACK 12
#define PROF_BUILTINS 256
#define PROF_TOP_FUNCTIONS 48

extern BPTR bigDataFile;
extern BOOL sliceBusy;
extern ULONG gfHits, gfMisses, gfBulk;
extern ULONG fnHits, fnMisses, fnEvictions, fnCapacity;
extern int numCachedFunctions;

int profFunction = -1;
ULONG profOps[64];
ULONG profAllocs, profFrees, profInstructions;

static struct Device *TimerBase;
static struct IORequest *profRequest;
static struct MsgPort *profPort;
static ULONG profHz;

static int profCurrent = PFC_SCRIPT;
static int profStack[PROF_STACK];
static int profDepth;
static ULONG profLast;
static ULONG profCategory[PFC_COUNT];
static ULONG profCategoryEntries[PFC_COUNT];

static int profNumFunctions;
static ULONG *profFunctionTicks;
static ULONG *profFunctionCalls;
static UWORD *profFunctionLoads;
static ULONG profBuiltinTicks[PROF_BUILTINS];
static ULONG profBuiltinCalls[PROF_BUILTINS];

static const char *profCategoryName[PFC_COUNT] = { "script", "funcload", "string", "objtype", "data", "builtin", "display", "wait" };

static ULONG profNow( void)
{
  struct EClockVal clock;
  ReadEClock( &clock);
  return clock.ev_lo;
}

/* The stack the program runs on: AmigaDOS gives a program started from a shell the shell's stack (4096 bytes unless the startup
   sequence says otherwise). ProfStackFill marks the unused part with a pattern; the dump reports how deep the stack has gone. */
static UBYTE *profStackLower;
static ULONG profStackSize;

void ProfStackFill( void)
{
  struct Task *task = FindTask( NULL);
  UBYTE here;
  profStackLower = (UBYTE *) task->tc_SPLower;
  profStackSize = (ULONG) task->tc_SPUpper - (ULONG) task->tc_SPLower;
  if( &here > profStackLower + 256) {
    for( UBYTE *p = profStackLower; p < &here - 128; p++) *p = 0xA5;
  }
  KPrintF( "PROF: stack %ld bytes, %ld free at the start\n",(long) profStackSize, (long) (&here - profStackLower));
}

static ULONG profStackDeepest( void)
{
  UBYTE *p = profStackLower;
  if( !p) return 0;
  while( p < profStackLower + profStackSize && *p == 0xA5) p++;
  return profStackSize - (ULONG) (p - profStackLower);
}

void ProfInit( int numFunctions)
{
  struct EClockVal clock;
  profPort = CreateMsgPort();
  profRequest = profPort ? CreateIORequest( profPort, sizeof (struct timerequest)) : NULL;
  if( !profRequest || OpenDevice( TIMERNAME, UNIT_MICROHZ, profRequest, 0)) {
    KPrintF( "PROF: cannot open timer.device\n");
    profRequest = NULL;
    return;
  }
  TimerBase = profRequest->io_Device;
  profHz = ReadEClock( &clock);
  profNumFunctions = numFunctions;
  profFunctionTicks = AllocVec( numFunctions * sizeof (ULONG), MEMF_ANY | MEMF_CLEAR);
  profFunctionCalls = AllocVec( numFunctions * sizeof (ULONG), MEMF_ANY | MEMF_CLEAR);
  profFunctionLoads = AllocVec( numFunctions * sizeof (UWORD), MEMF_ANY | MEMF_CLEAR);
  profLast = clock.ev_lo;
  KPrintF( "PROF: ready, %ld functions, %ld Hz\n", (long) numFunctions, (long) profHz);
}

static void profAccount( ULONG now)
{
  ULONG delta = now - profLast;
  profLast = now;
  profCategory[profCurrent] += delta;
  if( profCurrent != PFC_DISPLAY && profCurrent != PFC_WAIT && profFunction >= 0 && profFunction < profNumFunctions)
    profFunctionTicks[profFunction] += delta;
}

void ProfEnter( int category)
{
  if( !profRequest) return;
  profAccount( profNow());
  if( profDepth < PROF_STACK) profStack[profDepth] = profCurrent;
  profDepth++;
  profCurrent = category;
  profCategoryEntries[category]++;
}

void ProfLeave( void)
{
  if( !profRequest || profDepth == 0) return;
  profAccount( profNow());
  profDepth--;
  profCurrent = profDepth < PROF_STACK ? profStack[profDepth] : PFC_SCRIPT;
}

void ProfFunction( int number)
{
  if( !profRequest) return;
  profAccount( profNow());
  profFunction = number;
}

void ProfCall( int number, int loaded)
{
  if( !profRequest || number < 0 || number >= profNumFunctions) return;
  profFunctionCalls[number]++;
  if( loaded) profFunctionLoads[number]++;
}

ULONG ProfBuiltinBegin( void)
{
  if( !profRequest) return 0;
  ProfEnter( PFC_BUILTIN);
  return profLast;
}

void ProfBuiltinEnd( int number, ULONG start)
{
  if( !profRequest) return;
  ProfLeave();
  if( number >= 0 && number < PROF_BUILTINS) {
    profBuiltinTicks[number] += profLast - start;
    profBuiltinCalls[number]++;
  }
}

static void profReset( void)
{
  for( int i = 0; i < PFC_COUNT; i++) profCategory[i] = profCategoryEntries[i] = 0;
  for( int i = 0; i < profNumFunctions; i++) profFunctionTicks[i] = profFunctionCalls[i] = profFunctionLoads[i] = 0;
  for( int i = 0; i < PROF_BUILTINS; i++) profBuiltinTicks[i] = profBuiltinCalls[i] = 0;
  for( int i = 0; i < 64; i++) profOps[i] = 0;
  profAllocs = profFrees = profInstructions = 0;
  gfHits = gfMisses = gfBulk = 0;
  fnHits = fnMisses = fnEvictions = 0;
  profLast = profNow();
}

static void profDump( const char *label)
{
  ULONG total = 0;
  profAccount( profNow());
  for( int i = 0; i < PFC_COUNT; i++) total += profCategory[i];
  KPrintF( "PROF: begin %s total %ld hz %ld\n", label, (long) total, (long) profHz);
  for( int i = 0; i < PFC_COUNT; i++)
    KPrintF( "PROF: cat %s %ld %ld\n", profCategoryName[i], (long) profCategory[i], (long) profCategoryEntries[i]);
  KPrintF( "PROF: stack deepest %ld of %ld\n", (long) profStackDeepest(), (long) profStackSize);
  KPrintF( "PROF: mem allocs %ld frees %ld instructions %ld\n", (long) profAllocs, (long) profFrees, (long) profInstructions);
  KPrintF( "PROF: gf hits %ld misses %ld bulk %ld\n", (long) gfHits, (long) gfMisses, (long) gfBulk);
  KPrintF( "PROF: fnc hits %ld misses %ld evictions %ld cached %ld of %ld\n", (long) fnHits, (long) fnMisses, (long) fnEvictions, (long) numCachedFunctions, (long) fnCapacity);
  for( int i = 0; i < 64; i++)
    if( profOps[i]) KPrintF( "PROF: op %ld %ld\n", (long) i, (long) profOps[i]);
  for( int i = 0; i < PROF_BUILTINS; i++)
    if( profBuiltinCalls[i]) KPrintF( "PROF: bi %ld %ld %ld\n", (long) i, (long) profBuiltinTicks[i], (long) profBuiltinCalls[i]);
  for( int n = 0; n < PROF_TOP_FUNCTIONS; n++) {
    int best = -1;
    for( int i = 0; i < profNumFunctions; i++)
      if( profFunctionTicks[i] && (best < 0 || profFunctionTicks[i] > profFunctionTicks[best])) best = i;
    if( best < 0) break;
    KPrintF( "PROF: fn %ld %ld %ld %ld\n", (long) best, (long) profFunctionTicks[best], (long) profFunctionCalls[best], (long) profFunctionLoads[best]);
    profFunctionTicks[best] = 0;
  }
  KPrintF( "PROF: end %s\n", label);
}

static void profUnit( const char *name, ULONG t0, ULONG t1, long repeats)
{
  KPrintF( "PROF: unit %s %ld per %ld\n", name, (long) (t1 - t0), repeats);
}

/* Unit costs of the operations the engine is built from, on this machine: the numbers that say what a change can win. */
static void profSelfTest( void)
{
  enum { REPEATS = 200 };
  ULONG t0, t1;
  APTR blocks[40];
  struct EClockVal clock;

  t0 = profNow();
  for( int i = 0; i < REPEATS; i++) ReadEClock( &clock);
  t1 = profNow();
  profUnit( "eclock-read", t0, t1, REPEATS);

  t0 = profNow();
  for( int i = 0; i < REPEATS; i++) { APTR b = CstAllocVec( 24, MEMF_ANY); CstFreeVec( b); }
  t1 = profNow();
  profUnit( "alloc+free-pair-24", t0, t1, REPEATS);

  t0 = profNow();
  for( int i = 0; i < REPEATS; i++) { APTR b = AllocVec( 32, MEMF_ANY); FreeVec( b); }
  t1 = profNow();
  profUnit( "rawalloc+free-pair-32", t0, t1, REPEATS);

  t0 = profNow();
  for( int r = 0; r < REPEATS / 40; r++) {
    for( int i = 0; i < 40; i++) blocks[i] = CstAllocVec( 24, MEMF_ANY);
    for( int i = 0; i < 40; i++) CstFreeVec( blocks[i]);
  }
  t1 = profNow();
  profUnit( "alloc+free-batch-24", t0, t1, REPEATS);

  t0 = profNow();
  for( int i = 0; i < 20; i++) { APTR b = CstAllocVec( 4000, MEMF_ANY); CstFreeVec( b); }
  t1 = profNow();
  profUnit( "alloc+free-pair-4000", t0, t1, 20);

  if( bigDataFile && !sliceBusy) {
    static UBYTE buffer[4096];
    UBYTE *big = AllocVec( 65536, MEMF_ANY);

    t0 = profNow();
    Seek( bigDataFile, 300000, OFFSET_BEGINNING);
    for( int i = 0; i < 2000; i++) FGetC( bigDataFile);
    t1 = profNow();
    profUnit( "fgetc-sequential", t0, t1, 2000);

    t0 = profNow();
    for( int i = 0; i < 100; i++) Seek( bigDataFile, 300000 + i * 7000, OFFSET_BEGINNING);
    t1 = profNow();
    profUnit( "seek-far", t0, t1, 100);

    t0 = profNow();
    for( int i = 0; i < 100; i++) { Seek( bigDataFile, 300000 + i * 7000, OFFSET_BEGINNING); FGetC( bigDataFile); }
    t1 = profNow();
    profUnit( "seek+fgetc", t0, t1, 100);

    t0 = profNow();
    for( int i = 0; i < 20; i++) { Seek( bigDataFile, 400000 + i * 5000, OFFSET_BEGINNING); Read( bigDataFile, buffer, 1024); }
    t1 = profNow();
    profUnit( "seek+read-1024", t0, t1, 20);

    t0 = profNow();
    for( int i = 0; i < 20; i++) { Seek( bigDataFile, 400000 + i * 5000, OFFSET_BEGINNING); Read( bigDataFile, buffer, 4096); }
    t1 = profNow();
    profUnit( "seek+read-4096", t0, t1, 20);

    if( big) {
      static const ULONG sizes[] = { 64, 256, 8192, 16384, 32768, 65536 };
      static const char *names[] = { "seek+read-64", "seek+read-256", "seek+read-8192", "seek+read-16384", "seek+read-32768", "seek+read-65536" };
      for( int k = 0; k < 6; k++) {
        t0 = profNow();
        for( int i = 0; i < 5; i++) { Seek( bigDataFile, 700000 + i * 70000, OFFSET_BEGINNING); Read( bigDataFile, big, sizes[k]); }
        t1 = profNow();
        profUnit( names[k], t0, t1, 5);
      }
      t0 = profNow();
      for( int i = 0; i < 5; i++) { Seek( bigDataFile, 700000 + i * 70000, OFFSET_BEGINNING); FRead( bigDataFile, big, 1, 8192); }
      t1 = profNow();
      profUnit( "seek+fread-1x8192", t0, t1, 5);
      t0 = profNow();
      for( int i = 0; i < 5; i++) { Seek( bigDataFile, 700000 + i * 70000, OFFSET_BEGINNING); FRead( bigDataFile, big, 2, 4096); }
      t1 = profNow();
      profUnit( "seek+fread-2x4096", t0, t1, 5);
      SetVBuf( bigDataFile, NULL, BUF_FULL, 8192);
      t0 = profNow();
      Seek( bigDataFile, 300000, OFFSET_BEGINNING);
      for( int i = 0; i < 2000; i++) FGetC( bigDataFile);
      t1 = profNow();
      profUnit( "fgetc-sequential-vbuf8192", t0, t1, 2000);
      t0 = profNow();
      for( int i = 0; i < 5; i++) { Seek( bigDataFile, 700000 + i * 70000, OFFSET_BEGINNING); FRead( bigDataFile, big, 1, 8192); }
      t1 = profNow();
      profUnit( "seek+fread-1x8192-vbuf8192", t0, t1, 5);
      SetVBuf( bigDataFile, NULL, BUF_FULL, 204);
      t0 = profNow();
      for( int i = 0; i < 100; i++) memcpy( big + 4096, big, 4096);
      t1 = profNow();
      profUnit( "memcpy-4096", t0, t1, 100);
      t0 = profNow();
      for( int i = 0; i < 10; i++) { APTR c = AllocVec( 40000, MEMF_CHIP); FreeVec( c); }
      t1 = profNow();
      profUnit( "chipalloc-40000+free", t0, t1, 10);
      FreeVec( big);
    }

    t0 = profNow();
    for( int i = 0; i < 20; i++) { char *s = getNumberedString( 10 + i * 37); if( s) CstFreeVec( s); }
    t1 = profNow();
    profUnit( "getNumberedString", t0, t1, 20);
  }
  profLast = profNow();
  KPrintF( "PROF: selftest done\n");
}

void ProfCommand( const char *text)
{
  while( *text == ' ') text++;
  if( text[0] == 'r') { profReset(); KPrintF( "PROF: reset\n"); }
  else if( text[0] == 'd') { text++; while( *text && *text != ' ') text++; while( *text == ' ') text++; profDump( *text ? text : "-"); profReset(); }
  else if( text[0] == 's') { profSelfTest(); }
}

#endif
