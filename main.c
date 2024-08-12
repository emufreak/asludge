#include "support/gcc8_c_support.h"
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <graphics/gfxbase.h>
#include <graphics/view.h>
#include <exec/execbase.h>
#include <graphics/gfxmacros.h>
#include <hardware/custom.h>
#include <hardware/dmabits.h>
#include <hardware/intbits.h>
#include <proto/exec.h>
#include <proto/mathieeesingbas.h>
#include <proto/mathieeedoubbas.h>
#include <proto/mathieeesingtrans.h>
#include <libraries/mathieeesp.h>
#include "main_sludge.h"

#define EMULATOR

//config

struct ExecBase *SysBase;
volatile struct Custom *custom;
struct DosLibrary *DOSBase;
struct GfxBase *GfxBase;
struct MathIEEEBase *MathIeeeSingBasBase;
struct MathIEEEBase *MathIeeeSingTransBase;
struct MathIEEEBase *MathIeeeDoubBasBase;
struct MathIEEEBase *MathIeeeDoubTransBase;

//backup
static UWORD SystemInts;
static UWORD SystemDMA;
static UWORD SystemADKCON;
static volatile APTR VBR=0;
static APTR SystemIrq;
 
struct View *ActiView;

static APTR GetVBR(void) {
	APTR vbr = 0;
	UWORD getvbr[] = { 0x4e7a, 0x0801, 0x4e73 }; // MOVEC.L VBR,D0 RTE

	if (SysBase->AttnFlags & AFF_68010) 
		vbr = (APTR)Supervisor((ULONG (*)())getvbr);

	return vbr;
}

void SetInterruptHandler(APTR interrupt) {
	*(volatile APTR*)(((UBYTE*)VBR)+0x6c) = interrupt;
}

APTR GetInterruptHandler() {
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
}

void WaitLine(USHORT line) {
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
		if(((vpos >> 8) & 511) == line)
			break;
	}
}

__attribute__((always_inline)) inline void WaitBlt() {
	UWORD tst=*(volatile UWORD*)&custom->dmaconr; //for compatiblity a1000
	(void)tst;
	while (*(volatile UWORD*)&custom->dmaconr&(1<<14)) {} //blitter busy wait
}

void TakeSystem() {
	KPrintF("TakeSystem: Run Forbid\n");
	Forbid();
	//Save current interrupts and DMA settings so we can restore them upon exit. 
	KPrintF("TakeSystem: Saving Registers\n");
	SystemADKCON=custom->adkconr;
	SystemInts=custom->intenar;
	SystemDMA=custom->dmaconr;
	ActiView=GfxBase->ActiView; //store current view

	KPrintF("TakeSystem: LoadView\n");
	LoadView(0);
	KPrintF("TakeSystem: WaitTof\n");
	WaitTOF();
	WaitTOF();

	KPrintF("TakeSystem: WaitVBL\n");
	WaitVbl();
	WaitVbl();

	KPrintF("TakeSystem: Doing Blitter Stuff\n");
	OwnBlitter();
	WaitBlit();	
	Disable();
	
	//custom->intena=0x7fff;//disable all interrupts
	//custom->intreq=0x7fff;//Clear any interrupts that were pending
	
	KPrintF("TakeSystem: Clear DMA\n");
	custom->dmacon=0x7fff;//Clear all DMA channels

	KPrintF("TakeSystem: Set all colors to black\n");
	//set all colors black
	for(int a=0;a<32;a++)
		custom->color[a]=0;

	WaitVbl();
	WaitVbl();

	KPrintF("TakeSystem: Save System interrupts\n");
	VBR=GetVBR();
	SystemIrq=GetInterruptHandler(); //store interrupt register*/
}

void FreeSystem() { 
	WaitVbl();
	WaitBlit();
	custom->intena=0x7fff;//disable all interrupts
	custom->intreq=0x7fff;//Clear any interrupts that were pending
	custom->dmacon=0x7fff;//Clear all DMA channels

	//restore interrupts
	SetInterruptHandler(SystemIrq);

	/*Restore system copper list(s). */
	custom->cop1lc=(ULONG)GfxBase->copinit;
	custom->cop2lc=(ULONG)GfxBase->LOFlist;
	custom->copjmp1=0x7fff; //start coppper

	/*Restore all interrupts and DMA settings. */
	//custom->intena=SystemInts|0x8000;
	custom->dmacon=SystemDMA|0x8000;
	custom->adkcon=SystemADKCON|0x8000;

	WaitBlit();	
	DisownBlitter();
	Enable();

	LoadView(ActiView);
	WaitTOF();
	WaitTOF();

	Permit();
}

__attribute__((always_inline)) inline short MouseLeft(){return !((*(volatile UBYTE*)0xbfe001)&64);}	
__attribute__((always_inline)) inline short MouseRight(){return !((*(volatile UWORD*)0xdff016)&(1<<10));}

#ifdef MUSIC
	// Demo - Module Player - ThePlayer 6.1a: https://www.pouet.net/prod.php?which=19922
	// The Player® 6.1A: Copyright © 1992-95 Jarno Paananen
	// P61.testmod - Module by Skylord/Sector 7 
	INCBIN(player, "player610.6.no_cia.bin")
	INCBIN_CHIP(module, "testmod.p61")

	int p61Init(const void* module) { // returns 0 if success, non-zero otherwise
		register volatile const void* _a0 ASM("a0") = module;
		register volatile const void* _a1 ASM("a1") = NULL;
		register volatile const void* _a2 ASM("a2") = NULL;
		register volatile const void* _a3 ASM("a3") = player;
		register                int   _d0 ASM("d0"); // return value
		__asm volatile (
			"movem.l %%d1-%%d7/%%a4-%%a6,-(%%sp)\n"
			"jsr 0(%%a3)\n"
			"movem.l (%%sp)+,%%d1-%%d7/%%a4-%%a6"
		: "=r" (_d0), "+rf"(_a0), "+rf"(_a1), "+rf"(_a2), "+rf"(_a3)
		:
		: "cc", "memory");
		return _d0;
	}

	void p61Music() {
		register volatile const void* _a3 ASM("a3") = player;
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
		__asm volatile (
			"movem.l %%d0-%%d7/%%a0-%%a2/%%a4-%%a5,-(%%sp)\n"
			"jsr 4(%%a3)\n"
			"movem.l (%%sp)+,%%d0-%%d7/%%a0-%%a2/%%a4-%%a5"
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}

	void p61End() {
		register volatile const void* _a3 ASM("a3") = player;
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
		__asm volatile (
			"movem.l %%d0-%%d1/%%a0-%%a1,-(%%sp)\n"
			"jsr 8(%%a3)\n"
			"movem.l (%%sp)+,%%d0-%%d1/%%a0-%%a1"
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}
#endif //MUSIC

// set up a 320x256 lowres display
__attribute__((always_inline)) inline USHORT* screenScanDefault(USHORT* copListEnd) {
	const USHORT x=129;
	const USHORT width=320;
	const USHORT height=256;
	const USHORT y=44;
	const USHORT RES=8; //8=lowres,4=hires
	USHORT xstop = x+width;
	USHORT ystop = y+height;
	USHORT fw=(x>>1)-RES;

	*copListEnd++ = offsetof(struct Custom, ddfstrt);
	*copListEnd++ = fw;
	*copListEnd++ = offsetof(struct Custom, ddfstop);
	*copListEnd++ = fw+(((width>>4)-1)<<3);
	*copListEnd++ = offsetof(struct Custom, diwstrt);
	*copListEnd++ = x+(y<<8);
	*copListEnd++ = offsetof(struct Custom, diwstop);
	*copListEnd++ = (xstop-256)+((ystop-256)<<8);
	return copListEnd;
}

static void Wait10() { WaitLine(0x10); }
static void Wait11() { WaitLine(0x11); }
static void Wait12() { WaitLine(0x12); }
static void Wait13() { WaitLine(0x13); }

int main(int argc, char *argv[]) {
	SysBase = *((struct ExecBase**)4UL);
	custom = (struct Custom*)0xdff000;	


	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR)"graphics.library",0);
	if (!GfxBase)
		Exit(0);

	// used for printing
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
	if (!DOSBase)
		Exit(0);

	MathIeeeSingBasBase = (struct MathIEEEBase *) OpenLibrary("mathieeesingbas.library", 0);	
	if (!MathIeeeSingBasBase)
		Exit(0);	

	MathIeeeSingTransBase = (struct MathIEEEBase *) OpenLibrary("mathieeesingtrans.library",0);													
	if (!MathIeeeSingTransBase)
		Exit(0);

	MathIeeeDoubTransBase =  (struct MathIEEEBase *) OpenLibrary("mathieeedoubtrans.library",0);
	if (!MathIeeeDoubTransBase)		
		Exit(0);

	MathIeeeDoubBasBase = (struct MathIEEEBase *) OpenLibrary("mathieeedoubbas.library",0);
	if( !MathIeeeDoubBasBase) 
		Exit(0);
	

	KPrintF("Hello debugger from Amiga!\n");

	Write(Output(), (APTR)"Hello console!\n", 15);
	Delay(50);

	/*warpmode(1);
	// TODO: precalc stuff here
#ifdef MUSIC
	if(p61Init(module) != 0)
		KPrintF("p61Init failed!\n");
#endif
	warpmode(0);*/

	KPrintF("Taking System\n");
	TakeSystem();
	KPrintF("System Taken\n");

	custom->dmacon = 0x87ff;
	WaitVbl();

	KPrintF("Starting main_sludge\n");
	main_sludge(argc, argv);	

#ifdef MUSIC
	p61End();
#endif

	// END
	FreeSystem();

	CloseLibrary((struct Library*)DOSBase);
	CloseLibrary((struct Library*)GfxBase);
}
