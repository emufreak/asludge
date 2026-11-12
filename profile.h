/* The engine's profiler (A3e): built only with -DPROFILE (tools\amiga\build-engine.ps1 -Define PROFILE). It splits the time of a run
   into categories (script and engine glue, loading a function, a string, an object type, other data from the game file, built-in
   functions, the display pass, waiting for the frame), keeps the time of every script function (its own instructions plus the engine
   work done for it), of every built-in, and counts instructions, opcodes and allocations. The game switches it with
   printConsole ("PROF: reset"), ("PROF: dump label") and ("PROF: selftest"); the numbers go to the log as "PROF:" lines, which
   tools\amiga\profreport.py reads. The time unit is the E-clock (709,379 Hz on PAL, 1.41 microseconds). */
#ifndef PROFILE_H
#define PROFILE_H

#ifdef PROFILE

#include <exec/types.h>

enum ProfCategory { PFC_SCRIPT, PFC_FUNCLOAD, PFC_STRING, PFC_OBJTYPE, PFC_DATA, PFC_BUILTIN, PFC_DISPLAY, PFC_WAIT, PFC_COUNT };

void ProfInit( int numFunctions);
void ProfStackFill( void);
void ProfCommand( const char *text);
void ProfEnter( int category);
void ProfLeave( void);
void ProfFunction( int number);
void ProfCall( int number, int loaded);
ULONG ProfBuiltinBegin( void);
void ProfBuiltinEnd( int number, ULONG start);

extern int profFunction;
extern ULONG profOps[];
extern ULONG profAllocs, profFrees, profInstructions;

#define PROF_ENTER(c) ProfEnter (c)
#define PROF_LEAVE() ProfLeave ()
#define PROF_FUNCTION(f) do { if ((f) != profFunction) ProfFunction (f); } while (0)
#define PROF_OP(o) do { profInstructions++; profOps[(o) & 63]++; } while (0)

#else

#define PROF_ENTER(c) do { } while (0)
#define PROF_LEAVE() do { } while (0)
#define PROF_FUNCTION(f) do { } while (0)
#define PROF_OP(o) do { } while (0)

#endif

#endif
