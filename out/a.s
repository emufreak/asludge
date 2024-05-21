
out/a.elf:     file format elf32-m68k


Disassembly of section .text:

00000000 <_start>:
extern void (*__init_array_start[])() __attribute__((weak));
extern void (*__init_array_end[])() __attribute__((weak));
extern void (*__fini_array_start[])() __attribute__((weak));
extern void (*__fini_array_end[])() __attribute__((weak));

__attribute__((used)) __attribute__((section(".text.unlikely"))) void _start() {
       0:	       subq.l #8,sp
	// initialize globals, ctors etc.
	unsigned long count;
	unsigned long i;

	count = __preinit_array_end - __preinit_array_start;
       2:	       move.l #24576,d0
       8:	       subi.l #24576,d0
       e:	       asr.l #2,d0
      10:	       move.l d0,(sp)
	for (i = 0; i < count; i++)
      12:	       clr.l 4(sp)
      16:	   /-- bra.s 32 <_start+0x32>
		__preinit_array_start[i]();
      18:	/--|-> move.l 4(sp),d0
      1c:	|  |   add.l d0,d0
      1e:	|  |   movea.l d0,a1
      20:	|  |   adda.l d0,a1
      22:	|  |   lea 6000 <desiredfps>,a0
      28:	|  |   movea.l (0,a1,a0.l),a0
      2c:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      2e:	|  |   addq.l #1,4(sp)
      32:	|  \-> move.l 4(sp),d0
      36:	|      cmp.l (sp),d0
      38:	\----- bcs.s 18 <_start+0x18>

	count = __init_array_end - __init_array_start;
      3a:	       move.l #24576,d0
      40:	       subi.l #24576,d0
      46:	       asr.l #2,d0
      48:	       move.l d0,(sp)
	for (i = 0; i < count; i++)
      4a:	       clr.l 4(sp)
      4e:	   /-- bra.s 6a <_start+0x6a>
		__init_array_start[i]();
      50:	/--|-> move.l 4(sp),d0
      54:	|  |   add.l d0,d0
      56:	|  |   movea.l d0,a1
      58:	|  |   adda.l d0,a1
      5a:	|  |   lea 6000 <desiredfps>,a0
      60:	|  |   movea.l (0,a1,a0.l),a0
      64:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      66:	|  |   addq.l #1,4(sp)
      6a:	|  \-> move.l 4(sp),d0
      6e:	|      cmp.l (sp),d0
      70:	\----- bcs.s 50 <_start+0x50>

	main();
      72:	       jsr 164e <main>

	// call dtors
	count = __fini_array_end - __fini_array_start;
      78:	       move.l #24576,d0
      7e:	       subi.l #24576,d0
      84:	       asr.l #2,d0
      86:	       move.l d0,(sp)
	for (i = count; i > 0; i--)
      88:	       move.l (sp),4(sp)
      8c:	   /-- bra.s aa <_start+0xaa>
		__fini_array_start[i - 1]();
      8e:	/--|-> move.l 4(sp),d0
      92:	|  |   subq.l #1,d0
      94:	|  |   add.l d0,d0
      96:	|  |   movea.l d0,a1
      98:	|  |   adda.l d0,a1
      9a:	|  |   lea 6000 <desiredfps>,a0
      a0:	|  |   movea.l (0,a1,a0.l),a0
      a4:	|  |   jsr (a0)
	for (i = count; i > 0; i--)
      a6:	|  |   subq.l #1,4(sp)
      aa:	|  \-> tst.l 4(sp)
      ae:	\----- bne.s 8e <_start+0x8e>
}
      b0:	       nop
      b2:	       nop
      b4:	       addq.l #8,sp
      b6:	       rts

000000b8 <noFloor>:
#include "support/gcc8_c_support.h"

struct flor * currentFloor = NULL;

void noFloor () {
	currentFloor -> numPolygons = 0;
      b8:	movea.l 7496 <currentFloor>,a0
      be:	clr.l 8(a0)
	currentFloor -> polygon = NULL;
      c2:	movea.l 7496 <currentFloor>,a0
      c8:	clr.l 12(a0)
	currentFloor -> vertex = NULL;
      cc:	movea.l 7496 <currentFloor>,a0
      d2:	clr.l 4(a0)
	currentFloor -> matrix = NULL;
      d6:	movea.l 7496 <currentFloor>,a0
      dc:	clr.l 16(a0)
}
      e0:	nop
      e2:	rts

000000e4 <initFloor>:

BOOL initFloor () {
      e4:	       lea -12(sp),sp
      e8:	       move.l a6,-(sp)
	currentFloor = AllocVec(sizeof(struct flor), MEMF_ANY);
      ea:	       moveq #20,d0
      ec:	       move.l d0,12(sp)
      f0:	       clr.l 8(sp)
      f4:	       move.l 7552 <SysBase>,d0
      fa:	       movea.l d0,a6
      fc:	       move.l 12(sp),d0
     100:	       move.l 8(sp),d1
     104:	       jsr -684(a6)
     108:	       move.l d0,4(sp)
     10c:	       move.l 4(sp),d0
     110:	       move.l d0,7496 <currentFloor>

    if(currentFloor == 0) {
     116:	       move.l 7496 <currentFloor>,d0
     11c:	/----- bne.s 130 <initFloor+0x4c>
        KPrintF("initFloor: Could not initialize Mem");
     11e:	|      pea 2a92 <PutChar+0x4>
     124:	|      jsr 27ec <KPrintF>
     12a:	|      addq.l #4,sp
        return FALSE;
     12c:	|      clr.w d0
     12e:	|  /-- bra.s 138 <initFloor+0x54>
    }

	noFloor ();
     130:	\--|-> jsr b8 <noFloor>
	return TRUE;
     136:	   |   moveq #1,d0
     138:	   \-> movea.l (sp)+,a6
     13a:	       lea 12(sp),sp
     13e:	       rts

00000140 <deleteTextures>:
extern int specialSettings;
struct textureList *firstTexture = NULL;
BOOL NPOT_textures = TRUE;

void deleteTextures(unsigned int n,  unsigned int * textures)
{
     140:	                      lea -24(sp),sp
     144:	                      move.l a6,-(sp)
	if (firstTexture == NULL) {
     146:	                      move.l 74a6 <firstTexture>,d0
     14c:	/-------------------- beq.w 22a <deleteTextures+0xea>
		//debugOut("Deleting texture while list is already empty.\n");
	} else {
		for (unsigned int i = 0; i < n; i++) {
     150:	|                     clr.l 24(sp)
     154:	|     /-------------- bra.w 21e <deleteTextures+0xde>
			BOOL found = FALSE;
     158:	|  /--|-------------> clr.w 18(sp)
			struct textureList *list = firstTexture;
     15c:	|  |  |               move.l 74a6 <firstTexture>,20(sp)
			if (list->name == textures[i]) {
     164:	|  |  |               movea.l 20(sp),a0
     168:	|  |  |               move.l (a0),d1
     16a:	|  |  |               move.l 24(sp),d0
     16e:	|  |  |               add.l d0,d0
     170:	|  |  |               add.l d0,d0
     172:	|  |  |               movea.l 36(sp),a0
     176:	|  |  |               adda.l d0,a0
     178:	|  |  |               move.l (a0),d0
     17a:	|  |  |               cmp.l d1,d0
     17c:	|  |  |  /----------- bne.w 210 <deleteTextures+0xd0>
				found = TRUE;
     180:	|  |  |  |            move.w #1,18(sp)
				firstTexture = list->next;
     186:	|  |  |  |            movea.l 20(sp),a0
     18a:	|  |  |  |            move.l 12(a0),d0
     18e:	|  |  |  |            move.l d0,74a6 <firstTexture>
				FreeVec(list);
     194:	|  |  |  |            move.l 20(sp),6(sp)
     19a:	|  |  |  |            move.l 7552 <SysBase>,d0
     1a0:	|  |  |  |            movea.l d0,a6
     1a2:	|  |  |  |            movea.l 6(sp),a1
     1a6:	|  |  |  |            jsr -690(a6)
				continue;
     1aa:	|  |  |  |  /-------- bra.s 21a <deleteTextures+0xda>
			}

			while (list->next) {
				if (list->next->name == textures[i]) {
     1ac:	|  |  |  |  |  /----> movea.l 20(sp),a0
     1b0:	|  |  |  |  |  |      movea.l 12(a0),a0
     1b4:	|  |  |  |  |  |      move.l (a0),d1
     1b6:	|  |  |  |  |  |      move.l 24(sp),d0
     1ba:	|  |  |  |  |  |      add.l d0,d0
     1bc:	|  |  |  |  |  |      add.l d0,d0
     1be:	|  |  |  |  |  |      movea.l 36(sp),a0
     1c2:	|  |  |  |  |  |      adda.l d0,a0
     1c4:	|  |  |  |  |  |      move.l (a0),d0
     1c6:	|  |  |  |  |  |      cmp.l d1,d0
     1c8:	|  |  |  |  |  |  /-- bne.s 206 <deleteTextures+0xc6>
					found = TRUE;
     1ca:	|  |  |  |  |  |  |   move.w #1,18(sp)
					struct textureList *deleteMe = list->next;
     1d0:	|  |  |  |  |  |  |   movea.l 20(sp),a0
     1d4:	|  |  |  |  |  |  |   move.l 12(a0),14(sp)
					list->next = list->next->next;
     1da:	|  |  |  |  |  |  |   movea.l 20(sp),a0
     1de:	|  |  |  |  |  |  |   movea.l 12(a0),a0
     1e2:	|  |  |  |  |  |  |   move.l 12(a0),d0
     1e6:	|  |  |  |  |  |  |   movea.l 20(sp),a0
     1ea:	|  |  |  |  |  |  |   move.l d0,12(a0)
					FreeVec(deleteMe);
     1ee:	|  |  |  |  |  |  |   move.l 14(sp),10(sp)
     1f4:	|  |  |  |  |  |  |   move.l 7552 <SysBase>,d0
     1fa:	|  |  |  |  |  |  |   movea.l d0,a6
     1fc:	|  |  |  |  |  |  |   movea.l 10(sp),a1
     200:	|  |  |  |  |  |  |   jsr -690(a6)
					break;
     204:	|  |  |  |  +--|--|-- bra.s 21a <deleteTextures+0xda>
				}
				list = list->next;
     206:	|  |  |  |  |  |  \-> movea.l 20(sp),a0
     20a:	|  |  |  |  |  |      move.l 12(a0),20(sp)
			while (list->next) {
     210:	|  |  |  \--|--|----> movea.l 20(sp),a0
     214:	|  |  |     |  |      move.l 12(a0),d0
     218:	|  |  |     |  \----- bne.s 1ac <deleteTextures+0x6c>
		for (unsigned int i = 0; i < n; i++) {
     21a:	|  |  |     \-------> addq.l #1,24(sp)
     21e:	|  |  \-------------> move.l 24(sp),d0
     222:	|  |                  cmp.l 32(sp),d0
     226:	|  \----------------- bcs.w 158 <deleteTextures+0x18>
			}
		}
	}
     22a:	\-------------------> nop
     22c:	                      movea.l (sp)+,a6
     22e:	                      lea 24(sp),sp
     232:	                      rts

00000234 <initSludge>:
FILETIME fileTime;

struct variable * globalVars;
int numGlobals;

BOOL initSludge (char * filename) {
     234:	             lea -296(sp),sp
     238:	             movem.l d2-d4/a2/a6,-(sp)
	int a = 0;
     23c:	             clr.l 312(sp)
	mouseCursorAnim = makeNullAnim ();
     240:	             jsr 183c <makeNullAnim>
     246:	             move.l d0,7492 <mouseCursorAnim>

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, &gameVersion);
     24c:	             pea 74aa <gameVersion>
     252:	             pea 2ab6 <PutChar+0x28>
     258:	             pea 45 <_start+0x45>
     25c:	             pea 47 <_start+0x47>
     260:	             move.l 336(sp),-(sp)
     264:	             jsr 9a2 <openAndVerify>
     26a:	             lea 20(sp),sp
     26e:	             move.l d0,292(sp)
	if (! fp) return FALSE;
     272:	         /-- bne.s 27a <initSludge+0x46>
     274:	         |   clr.w d0
     276:	/--------|-- bra.w 998 <initSludge+0x764>
	if (FGetC (fp)) {
     27a:	|        \-> move.l 292(sp),288(sp)
     280:	|            move.l 755a <DOSBase>,d0
     286:	|            movea.l d0,a6
     288:	|            move.l 288(sp),d1
     28c:	|            jsr -306(a6)
     290:	|            move.l d0,284(sp)
     294:	|            move.l 284(sp),d0
     298:	|  /-------- beq.w 43e <initSludge+0x20a>
		numBIFNames = get2bytes (fp);
     29c:	|  |         move.l 292(sp),-(sp)
     2a0:	|  |         jsr 1d32 <get2bytes>
     2a6:	|  |         addq.l #4,sp
     2a8:	|  |         move.l d0,74b2 <numBIFNames>
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
     2ae:	|  |         move.l 74b2 <numBIFNames>,d0
     2b4:	|  |         move.l d0,280(sp)
     2b8:	|  |         clr.l 276(sp)
     2bc:	|  |         move.l 7552 <SysBase>,d0
     2c2:	|  |         movea.l d0,a6
     2c4:	|  |         move.l 280(sp),d0
     2c8:	|  |         move.l 276(sp),d1
     2cc:	|  |         jsr -684(a6)
     2d0:	|  |         move.l d0,272(sp)
     2d4:	|  |         move.l 272(sp),d0
     2d8:	|  |         move.l d0,74b6 <allBIFNames>
		if(allBIFNames == 0) return FALSE;
     2de:	|  |         move.l 74b6 <allBIFNames>,d0
     2e4:	|  |     /-- bne.s 2ec <initSludge+0xb8>
     2e6:	|  |     |   clr.w d0
     2e8:	+--|-----|-- bra.w 998 <initSludge+0x764>
		for (int fn = 0; fn < numBIFNames; fn ++) {
     2ec:	|  |     \-> clr.l 308(sp)
     2f0:	|  |     /-- bra.s 316 <initSludge+0xe2>
			allBIFNames[fn] = (char *) readString (fp);
     2f2:	|  |  /--|-> move.l 74b6 <allBIFNames>,d1
     2f8:	|  |  |  |   move.l 308(sp),d0
     2fc:	|  |  |  |   add.l d0,d0
     2fe:	|  |  |  |   add.l d0,d0
     300:	|  |  |  |   movea.l d1,a2
     302:	|  |  |  |   adda.l d0,a2
     304:	|  |  |  |   move.l 292(sp),-(sp)
     308:	|  |  |  |   jsr 1eca <readString>
     30e:	|  |  |  |   addq.l #4,sp
     310:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numBIFNames; fn ++) {
     312:	|  |  |  |   addq.l #1,308(sp)
     316:	|  |  |  \-> move.l 74b2 <numBIFNames>,d0
     31c:	|  |  |      cmp.l 308(sp),d0
     320:	|  |  \----- bgt.s 2f2 <initSludge+0xbe>
		}
		numUserFunc = get2bytes (fp);
     322:	|  |         move.l 292(sp),-(sp)
     326:	|  |         jsr 1d32 <get2bytes>
     32c:	|  |         addq.l #4,sp
     32e:	|  |         move.l d0,74ba <numUserFunc>
		allUserFunc = AllocVec(numUserFunc,MEMF_ANY);
     334:	|  |         move.l 74ba <numUserFunc>,d0
     33a:	|  |         move.l d0,268(sp)
     33e:	|  |         clr.l 264(sp)
     342:	|  |         move.l 7552 <SysBase>,d0
     348:	|  |         movea.l d0,a6
     34a:	|  |         move.l 268(sp),d0
     34e:	|  |         move.l 264(sp),d1
     352:	|  |         jsr -684(a6)
     356:	|  |         move.l d0,260(sp)
     35a:	|  |         move.l 260(sp),d0
     35e:	|  |         move.l d0,74be <allUserFunc>
		if( allUserFunc == 0) return FALSE;
     364:	|  |         move.l 74be <allUserFunc>,d0
     36a:	|  |     /-- bne.s 372 <initSludge+0x13e>
     36c:	|  |     |   clr.w d0
     36e:	+--|-----|-- bra.w 998 <initSludge+0x764>

		for (int fn = 0; fn < numUserFunc; fn ++) {
     372:	|  |     \-> clr.l 304(sp)
     376:	|  |     /-- bra.s 39c <initSludge+0x168>
			allUserFunc[fn] =   (char *) readString (fp);
     378:	|  |  /--|-> move.l 74be <allUserFunc>,d1
     37e:	|  |  |  |   move.l 304(sp),d0
     382:	|  |  |  |   add.l d0,d0
     384:	|  |  |  |   add.l d0,d0
     386:	|  |  |  |   movea.l d1,a2
     388:	|  |  |  |   adda.l d0,a2
     38a:	|  |  |  |   move.l 292(sp),-(sp)
     38e:	|  |  |  |   jsr 1eca <readString>
     394:	|  |  |  |   addq.l #4,sp
     396:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numUserFunc; fn ++) {
     398:	|  |  |  |   addq.l #1,304(sp)
     39c:	|  |  |  \-> move.l 74ba <numUserFunc>,d0
     3a2:	|  |  |      cmp.l 304(sp),d0
     3a6:	|  |  \----- bgt.s 378 <initSludge+0x144>
		}
		if (gameVersion >= VERSION(1,3)) {
     3a8:	|  |         move.l 74aa <gameVersion>,d0
     3ae:	|  |         cmpi.l #258,d0
     3b4:	|  +-------- ble.w 43e <initSludge+0x20a>
			numResourceNames = get2bytes (fp);
     3b8:	|  |         move.l 292(sp),-(sp)
     3bc:	|  |         jsr 1d32 <get2bytes>
     3c2:	|  |         addq.l #4,sp
     3c4:	|  |         move.l d0,74c2 <numResourceNames>
			allResourceNames = AllocVec(numResourceNames,MEMF_ANY);
     3ca:	|  |         move.l 74c2 <numResourceNames>,d0
     3d0:	|  |         move.l d0,256(sp)
     3d4:	|  |         clr.l 252(sp)
     3d8:	|  |         move.l 7552 <SysBase>,d0
     3de:	|  |         movea.l d0,a6
     3e0:	|  |         move.l 256(sp),d0
     3e4:	|  |         move.l 252(sp),d1
     3e8:	|  |         jsr -684(a6)
     3ec:	|  |         move.l d0,248(sp)
     3f0:	|  |         move.l 248(sp),d0
     3f4:	|  |         move.l d0,74c6 <allResourceNames>
			if(allResourceNames == 0) return FALSE;
     3fa:	|  |         move.l 74c6 <allResourceNames>,d0
     400:	|  |     /-- bne.s 408 <initSludge+0x1d4>
     402:	|  |     |   clr.w d0
     404:	+--|-----|-- bra.w 998 <initSludge+0x764>

			for (int fn = 0; fn < numResourceNames; fn ++) {
     408:	|  |     \-> clr.l 300(sp)
     40c:	|  |     /-- bra.s 432 <initSludge+0x1fe>
				allResourceNames[fn] =  (char *) readString (fp);
     40e:	|  |  /--|-> move.l 74c6 <allResourceNames>,d1
     414:	|  |  |  |   move.l 300(sp),d0
     418:	|  |  |  |   add.l d0,d0
     41a:	|  |  |  |   add.l d0,d0
     41c:	|  |  |  |   movea.l d1,a2
     41e:	|  |  |  |   adda.l d0,a2
     420:	|  |  |  |   move.l 292(sp),-(sp)
     424:	|  |  |  |   jsr 1eca <readString>
     42a:	|  |  |  |   addq.l #4,sp
     42c:	|  |  |  |   move.l d0,(a2)
			for (int fn = 0; fn < numResourceNames; fn ++) {
     42e:	|  |  |  |   addq.l #1,300(sp)
     432:	|  |  |  \-> move.l 74c2 <numResourceNames>,d0
     438:	|  |  |      cmp.l 300(sp),d0
     43c:	|  |  \----- bgt.s 40e <initSludge+0x1da>
			}
		}
	}
	winWidth = get2bytes (fp);
     43e:	|  \-------> move.l 292(sp),-(sp)
     442:	|            jsr 1d32 <get2bytes>
     448:	|            addq.l #4,sp
     44a:	|            move.l d0,749e <winWidth>
	winHeight = get2bytes (fp);
     450:	|            move.l 292(sp),-(sp)
     454:	|            jsr 1d32 <get2bytes>
     45a:	|            addq.l #4,sp
     45c:	|            move.l d0,74a2 <winHeight>
	specialSettings = FGetC (fp);
     462:	|            move.l 292(sp),244(sp)
     468:	|            move.l 755a <DOSBase>,d0
     46e:	|            movea.l d0,a6
     470:	|            move.l 244(sp),d1
     474:	|            jsr -306(a6)
     478:	|            move.l d0,240(sp)
     47c:	|            move.l 240(sp),d0
     480:	|            move.l d0,74ae <specialSettings>

	desiredfps = 1000/FGetC (fp);
     486:	|            move.l 292(sp),236(sp)
     48c:	|            move.l 755a <DOSBase>,d0
     492:	|            movea.l d0,a6
     494:	|            move.l 236(sp),d1
     498:	|            jsr -306(a6)
     49c:	|            move.l d0,232(sp)
     4a0:	|            move.l 232(sp),d0
     4a4:	|            move.l d0,-(sp)
     4a6:	|            pea 3e8 <initSludge+0x1b4>
     4aa:	|            jsr 2a52 <__divsi3>
     4b0:	|            addq.l #8,sp
     4b2:	|            move.l d0,6000 <desiredfps>

	FreeVec(readString (fp));
     4b8:	|            move.l 292(sp),-(sp)
     4bc:	|            jsr 1eca <readString>
     4c2:	|            addq.l #4,sp
     4c4:	|            move.l d0,228(sp)
     4c8:	|            move.l 7552 <SysBase>,d0
     4ce:	|            movea.l d0,a6
     4d0:	|            movea.l 228(sp),a1
     4d4:	|            jsr -690(a6)

	ULONG blocks_read = FRead( fp, &fileTime, sizeof (FILETIME), 1 ); 
     4d8:	|            move.l 292(sp),224(sp)
     4de:	|            move.l #29898,220(sp)
     4e6:	|            moveq #8,d0
     4e8:	|            move.l d0,216(sp)
     4ec:	|            moveq #1,d1
     4ee:	|            move.l d1,212(sp)
     4f2:	|            move.l 755a <DOSBase>,d0
     4f8:	|            movea.l d0,a6
     4fa:	|            move.l 224(sp),d1
     4fe:	|            move.l 220(sp),d2
     502:	|            move.l 216(sp),d3
     506:	|            move.l 212(sp),d4
     50a:	|            jsr -324(a6)
     50e:	|            move.l d0,208(sp)
     512:	|            move.l 208(sp),d0
     516:	|            move.l d0,204(sp)
	if (blocks_read != 1) {
     51a:	|            moveq #1,d0
     51c:	|            cmp.l 204(sp),d0
     520:	|        /-- beq.s 530 <initSludge+0x2fc>
		KPrintF("Reading error in initSludge.\n");
     522:	|        |   pea 2aef <PutChar+0x61>
     528:	|        |   jsr 27ec <KPrintF>
     52e:	|        |   addq.l #4,sp
	}

	char * dataFol = (gameVersion >= VERSION(1,3)) ? readString(fp) : joinStrings ("", "");
     530:	|        \-> move.l 74aa <gameVersion>,d0
     536:	|            cmpi.l #258,d0
     53c:	|        /-- ble.s 54c <initSludge+0x318>
     53e:	|        |   move.l 292(sp),-(sp)
     542:	|        |   jsr 1eca <readString>
     548:	|        |   addq.l #4,sp
     54a:	|     /--|-- bra.s 560 <initSludge+0x32c>
     54c:	|     |  \-> pea 2b0d <PutChar+0x7f>
     552:	|     |      pea 2b0d <PutChar+0x7f>
     558:	|     |      jsr 270c <joinStrings>
     55e:	|     |      addq.l #8,sp
     560:	|     \----> move.l d0,200(sp)

	gameSettings.numLanguages = (gameVersion >= VERSION(1,3)) ? (FGetC (fp)) : 0;
     564:	|            move.l 74aa <gameVersion>,d0
     56a:	|            cmpi.l #258,d0
     570:	|     /----- ble.s 592 <initSludge+0x35e>
     572:	|     |      move.l 292(sp),196(sp)
     578:	|     |      move.l 755a <DOSBase>,d0
     57e:	|     |      movea.l d0,a6
     580:	|     |      move.l 196(sp),d1
     584:	|     |      jsr -306(a6)
     588:	|     |      move.l d0,192(sp)
     58c:	|     |      move.l 192(sp),d0
     590:	|     |  /-- bra.s 594 <initSludge+0x360>
     592:	|     \--|-> moveq #0,d0
     594:	|        \-> move.l d0,75ce <gameSettings+0x4>
	makeLanguageTable (fp);
     59a:	|            move.l 292(sp),-(sp)
     59e:	|            jsr 2070 <makeLanguageTable>
     5a4:	|            addq.l #4,sp

	if (gameVersion >= VERSION(1,6))
     5a6:	|            move.l 74aa <gameVersion>,d0
     5ac:	|            cmpi.l #261,d0
     5b2:	|        /-- ble.s 600 <initSludge+0x3cc>
	{
		FGetC(fp);
     5b4:	|        |   move.l 292(sp),188(sp)
     5ba:	|        |   move.l 755a <DOSBase>,d0
     5c0:	|        |   movea.l d0,a6
     5c2:	|        |   move.l 188(sp),d1
     5c6:	|        |   jsr -306(a6)
     5ca:	|        |   move.l d0,184(sp)
		// aaLoad
		FGetC (fp);
     5ce:	|        |   move.l 292(sp),180(sp)
     5d4:	|        |   move.l 755a <DOSBase>,d0
     5da:	|        |   movea.l d0,a6
     5dc:	|        |   move.l 180(sp),d1
     5e0:	|        |   jsr -306(a6)
     5e4:	|        |   move.l d0,176(sp)
		getFloat (fp);
     5e8:	|        |   move.l 292(sp),-(sp)
     5ec:	|        |   jsr 1e4e <getFloat>
     5f2:	|        |   addq.l #4,sp
		getFloat (fp);
     5f4:	|        |   move.l 292(sp),-(sp)
     5f8:	|        |   jsr 1e4e <getFloat>
     5fe:	|        |   addq.l #4,sp
	}

	char * checker = readString (fp);
     600:	|        \-> move.l 292(sp),-(sp)
     604:	|            jsr 1eca <readString>
     60a:	|            addq.l #4,sp
     60c:	|            move.l d0,172(sp)

	if (strcmp (checker, "okSoFar")) {
     610:	|            pea 2b0e <PutChar+0x80>
     616:	|            move.l 176(sp),-(sp)
     61a:	|            jsr 261e <strcmp>
     620:	|            addq.l #8,sp
     622:	|            tst.l d0
     624:	|        /-- beq.s 62c <initSludge+0x3f8>
		return FALSE;
     626:	|        |   clr.w d0
     628:	+--------|-- bra.w 998 <initSludge+0x764>
	}
	FreeVec( checker);
     62c:	|        \-> move.l 172(sp),168(sp)
     632:	|            move.l 7552 <SysBase>,d0
     638:	|            movea.l d0,a6
     63a:	|            movea.l 168(sp),a1
     63e:	|            jsr -690(a6)
	checker = NULL;
     642:	|            clr.l 172(sp)

    unsigned char customIconLogo = FGetC (fp);
     646:	|            move.l 292(sp),164(sp)
     64c:	|            move.l 755a <DOSBase>,d0
     652:	|            movea.l d0,a6
     654:	|            move.l 164(sp),d1
     658:	|            jsr -306(a6)
     65c:	|            move.l d0,160(sp)
     660:	|            move.l 160(sp),d0
     664:	|            move.b d0,159(sp)

	if (customIconLogo & 1) {
     668:	|            moveq #0,d0
     66a:	|            move.b 159(sp),d0
     66e:	|            moveq #1,d1
     670:	|            and.l d1,d0
     672:	|        /-- beq.s 6ca <initSludge+0x496>
		// There is an icon - read it!
		Write(Output(), (APTR)"initsludge:Game Icon not supported on this plattform.\n", 54);
     674:	|        |   move.l 755a <DOSBase>,d0
     67a:	|        |   movea.l d0,a6
     67c:	|        |   jsr -60(a6)
     680:	|        |   move.l d0,38(sp)
     684:	|        |   move.l 38(sp),d0
     688:	|        |   move.l d0,34(sp)
     68c:	|        |   move.l #11030,30(sp)
     694:	|        |   moveq #54,d0
     696:	|        |   move.l d0,26(sp)
     69a:	|        |   move.l 755a <DOSBase>,d0
     6a0:	|        |   movea.l d0,a6
     6a2:	|        |   move.l 34(sp),d1
     6a6:	|        |   move.l 30(sp),d2
     6aa:	|        |   move.l 26(sp),d3
     6ae:	|        |   jsr -48(a6)
     6b2:	|        |   move.l d0,22(sp)
		KPrintF("initsludge: Game Icon not supported on this plattform.\n");
     6b6:	|        |   pea 2b4d <PutChar+0xbf>
     6bc:	|        |   jsr 27ec <KPrintF>
     6c2:	|        |   addq.l #4,sp
		return FALSE;
     6c4:	|        |   clr.w d0
     6c6:	+--------|-- bra.w 998 <initSludge+0x764>
	}

	numGlobals = get2bytes (fp);
     6ca:	|        \-> move.l 292(sp),-(sp)
     6ce:	|            jsr 1d32 <get2bytes>
     6d4:	|            addq.l #4,sp
     6d6:	|            move.l d0,74d6 <numGlobals>

	globalVars = AllocVec( sizeof(struct variable) * numGlobals,MEMF_ANY);
     6dc:	|            move.l 74d6 <numGlobals>,d0
     6e2:	|            lsl.l #3,d0
     6e4:	|            move.l d0,154(sp)
     6e8:	|            clr.l 150(sp)
     6ec:	|            move.l 7552 <SysBase>,d0
     6f2:	|            movea.l d0,a6
     6f4:	|            move.l 154(sp),d0
     6f8:	|            move.l 150(sp),d1
     6fc:	|            jsr -684(a6)
     700:	|            move.l d0,146(sp)
     704:	|            move.l 146(sp),d0
     708:	|            move.l d0,74d2 <globalVars>
	if(globalVars == 0) {
     70e:	|            move.l 74d2 <globalVars>,d0
     714:	|        /-- bne.s 72a <initSludge+0x4f6>
		KPrintF("initsludge: Cannot allocate memory for globalvars\n");
     716:	|        |   pea 2b85 <PutChar+0xf7>
     71c:	|        |   jsr 27ec <KPrintF>
     722:	|        |   addq.l #4,sp
		return FALSE;
     724:	|        |   clr.w d0
     726:	+--------|-- bra.w 998 <initSludge+0x764>
	}		 
	for (a = 0; a < numGlobals; a ++) initVarNew (globalVars[a]);
     72a:	|        \-> clr.l 312(sp)
     72e:	|        /-- bra.s 746 <initSludge+0x512>
     730:	|     /--|-> move.l 74d2 <globalVars>,d1
     736:	|     |  |   move.l 312(sp),d0
     73a:	|     |  |   lsl.l #3,d0
     73c:	|     |  |   movea.l d1,a0
     73e:	|     |  |   adda.l d0,a0
     740:	|     |  |   clr.l (a0)
     742:	|     |  |   addq.l #1,312(sp)
     746:	|     |  \-> move.l 74d6 <numGlobals>,d0
     74c:	|     |      cmp.l 312(sp),d0
     750:	|     \----- bgt.s 730 <initSludge+0x4fc>

	setFileIndices (fp, gameSettings.numLanguages, 0);
     752:	|            move.l 75ce <gameSettings+0x4>,d0
     758:	|            clr.l -(sp)
     75a:	|            move.l d0,-(sp)
     75c:	|            move.l 300(sp),-(sp)
     760:	|            jsr 12dc <setFileIndices>
     766:	|            lea 12(sp),sp

	char * gameNameOrig = getNumberedString(1);	
     76a:	|            pea 1 <_start+0x1>
     76e:	|            jsr 11de <getNumberedString>
     774:	|            addq.l #4,sp
     776:	|            move.l d0,142(sp)
	char * gameName = encodeFilename (gameNameOrig);
     77a:	|            move.l 142(sp),-(sp)
     77e:	|            jsr 1974 <encodeFilename>
     784:	|            addq.l #4,sp
     786:	|            move.l d0,138(sp)

	FreeVec(gameNameOrig);
     78a:	|            move.l 142(sp),134(sp)
     790:	|            move.l 7552 <SysBase>,d0
     796:	|            movea.l d0,a6
     798:	|            movea.l 134(sp),a1
     79c:	|            jsr -690(a6)

	BPTR lock = CreateDir( gameName );
     7a0:	|            move.l 138(sp),130(sp)
     7a6:	|            move.l 755a <DOSBase>,d0
     7ac:	|            movea.l d0,a6
     7ae:	|            move.l 130(sp),d1
     7b2:	|            jsr -120(a6)
     7b6:	|            move.l d0,126(sp)
     7ba:	|            move.l 126(sp),d0
     7be:	|            move.l d0,296(sp)
	if(lock == 0) {
     7c2:	|        /-- bne.s 7f0 <initSludge+0x5bc>
		//Directory does already exist
		lock = Lock(gameName, ACCESS_READ);
     7c4:	|        |   move.l 138(sp),122(sp)
     7ca:	|        |   moveq #-2,d1
     7cc:	|        |   move.l d1,118(sp)
     7d0:	|        |   move.l 755a <DOSBase>,d0
     7d6:	|        |   movea.l d0,a6
     7d8:	|        |   move.l 122(sp),d1
     7dc:	|        |   move.l 118(sp),d2
     7e0:	|        |   jsr -84(a6)
     7e4:	|        |   move.l d0,114(sp)
     7e8:	|        |   move.l 114(sp),d0
     7ec:	|        |   move.l d0,296(sp)
	}

	if (!CurrentDir(lock)) {
     7f0:	|        \-> move.l 296(sp),110(sp)
     7f6:	|            move.l 755a <DOSBase>,d0
     7fc:	|            movea.l d0,a6
     7fe:	|            move.l 110(sp),d1
     802:	|            jsr -126(a6)
     806:	|            move.l d0,106(sp)
     80a:	|            move.l 106(sp),d0
     80e:	|        /-- bne.s 86a <initSludge+0x636>
		KPrintF("initsludge: Failed changing to directory %s\n", gameName);
     810:	|        |   move.l 138(sp),-(sp)
     814:	|        |   pea 2bb8 <PutChar+0x12a>
     81a:	|        |   jsr 27ec <KPrintF>
     820:	|        |   addq.l #8,sp
		Write(Output(), (APTR)"initsludge:Failed changing to directory\n", 40);
     822:	|        |   move.l 755a <DOSBase>,d0
     828:	|        |   movea.l d0,a6
     82a:	|        |   jsr -60(a6)
     82e:	|        |   move.l d0,58(sp)
     832:	|        |   move.l 58(sp),d0
     836:	|        |   move.l d0,54(sp)
     83a:	|        |   move.l #11237,50(sp)
     842:	|        |   moveq #40,d0
     844:	|        |   move.l d0,46(sp)
     848:	|        |   move.l 755a <DOSBase>,d0
     84e:	|        |   movea.l d0,a6
     850:	|        |   move.l 54(sp),d1
     854:	|        |   move.l 50(sp),d2
     858:	|        |   move.l 46(sp),d3
     85c:	|        |   jsr -48(a6)
     860:	|        |   move.l d0,42(sp)
		return FALSE;
     864:	|        |   clr.w d0
     866:	+--------|-- bra.w 998 <initSludge+0x764>
	}

	FreeVec(gameName);
     86a:	|        \-> move.l 138(sp),102(sp)
     870:	|            move.l 7552 <SysBase>,d0
     876:	|            movea.l d0,a6
     878:	|            movea.l 102(sp),a1
     87c:	|            jsr -690(a6)

	readIniFile (filename);
     880:	|            move.l 320(sp),-(sp)
     884:	|            jsr 21a4 <readIniFile>
     88a:	|            addq.l #4,sp

	// Now set file indices properly to the chosen language.
	languageNum = getLanguageForFileB ();
     88c:	|            jsr 1f76 <getLanguageForFileB>
     892:	|            move.l d0,6004 <languageNum>
	if (languageNum < 0) KPrintF("Can't find the translation data specified!");
     898:	|            move.l 6004 <languageNum>,d0
     89e:	|        /-- bpl.s 8ae <initSludge+0x67a>
     8a0:	|        |   pea 2c0e <PutChar+0x180>
     8a6:	|        |   jsr 27ec <KPrintF>
     8ac:	|        |   addq.l #4,sp
	setFileIndices (NULL, gameSettings.numLanguages, languageNum);
     8ae:	|        \-> move.l 6004 <languageNum>,d0
     8b4:	|            move.l d0,d1
     8b6:	|            move.l 75ce <gameSettings+0x4>,d0
     8bc:	|            move.l d1,-(sp)
     8be:	|            move.l d0,-(sp)
     8c0:	|            clr.l -(sp)
     8c2:	|            jsr 12dc <setFileIndices>
     8c8:	|            lea 12(sp),sp

	if (dataFol[0]) {
     8cc:	|            movea.l 200(sp),a0
     8d0:	|            move.b (a0),d0
     8d2:	|     /----- beq.w 97c <initSludge+0x748>
		char *dataFolder = encodeFilename(dataFol);
     8d6:	|     |      move.l 200(sp),-(sp)
     8da:	|     |      jsr 1974 <encodeFilename>
     8e0:	|     |      addq.l #4,sp
     8e2:	|     |      move.l d0,98(sp)
		lock = CreateDir( dataFolder );
     8e6:	|     |      move.l 98(sp),94(sp)
     8ec:	|     |      move.l 755a <DOSBase>,d0
     8f2:	|     |      movea.l d0,a6
     8f4:	|     |      move.l 94(sp),d1
     8f8:	|     |      jsr -120(a6)
     8fc:	|     |      move.l d0,90(sp)
     900:	|     |      move.l 90(sp),d0
     904:	|     |      move.l d0,296(sp)
		if(lock == 0) {
     908:	|     |  /-- bne.s 936 <initSludge+0x702>
			//Directory does already exist
			lock = Lock(dataFolder, ACCESS_READ);		
     90a:	|     |  |   move.l 98(sp),86(sp)
     910:	|     |  |   moveq #-2,d1
     912:	|     |  |   move.l d1,82(sp)
     916:	|     |  |   move.l 755a <DOSBase>,d0
     91c:	|     |  |   movea.l d0,a6
     91e:	|     |  |   move.l 86(sp),d1
     922:	|     |  |   move.l 82(sp),d2
     926:	|     |  |   jsr -84(a6)
     92a:	|     |  |   move.l d0,78(sp)
     92e:	|     |  |   move.l 78(sp),d0
     932:	|     |  |   move.l d0,296(sp)
		}


		if (!CurrentDir(lock)) {
     936:	|     |  \-> move.l 296(sp),74(sp)
     93c:	|     |      move.l 755a <DOSBase>,d0
     942:	|     |      movea.l d0,a6
     944:	|     |      move.l 74(sp),d1
     948:	|     |      jsr -126(a6)
     94c:	|     |      move.l d0,70(sp)
     950:	|     |      move.l 70(sp),d0
     954:	|     |  /-- bne.s 966 <initSludge+0x732>
			(Output(), (APTR)"initsludge:This game's data folder is inaccessible!\n", 52);
     956:	|     |  |   move.l 755a <DOSBase>,d0
     95c:	|     |  |   movea.l d0,a6
     95e:	|     |  |   jsr -60(a6)
     962:	|     |  |   move.l d0,66(sp)
		}
		FreeVec(dataFolder);
     966:	|     |  \-> move.l 98(sp),62(sp)
     96c:	|     |      move.l 7552 <SysBase>,d0
     972:	|     |      movea.l d0,a6
     974:	|     |      movea.l 62(sp),a1
     978:	|     |      jsr -690(a6)
	}

 	positionStatus (10, winHeight - 15);
     97c:	|     \----> movea.l 74a2 <winHeight>,a0
     982:	|            lea -15(a0),a0
     986:	|            move.l a0,d0
     988:	|            move.l d0,-(sp)
     98a:	|            pea a <_start+0xa>
     98e:	|            jsr 1802 <positionStatus>
     994:	|            addq.l #8,sp

	return TRUE;
     996:	|            moveq #1,d0
}
     998:	\----------> movem.l (sp)+,d2-d4/a2/a6
     99c:	             lea 296(sp),sp
     9a0:	             rts

000009a2 <openAndVerify>:

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion) {
     9a2:	       lea -312(sp),sp
     9a6:	       movem.l d2-d3/a6,-(sp)
     9aa:	       move.l 332(sp),d1
     9ae:	       move.l 336(sp),d0
     9b2:	       move.b d1,d1
     9b4:	       move.b d1,16(sp)
     9b8:	       move.b d0,d0
     9ba:	       move.b d0,14(sp)
	BPTR fp = Open(filename,MODE_OLDFILE);
     9be:	       move.l 328(sp),318(sp)
     9c4:	       move.l #1005,314(sp)
     9cc:	       move.l 755a <DOSBase>,d0
     9d2:	       movea.l d0,a6
     9d4:	       move.l 318(sp),d1
     9d8:	       move.l 314(sp),d2
     9dc:	       jsr -30(a6)
     9e0:	       move.l d0,310(sp)
     9e4:	       move.l 310(sp),d0
     9e8:	       move.l d0,306(sp)

	if (! fp) {
     9ec:	   /-- bne.s a48 <openAndVerify+0xa6>
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
     9ee:	   |   move.l 755a <DOSBase>,d0
     9f4:	   |   movea.l d0,a6
     9f6:	   |   jsr -60(a6)
     9fa:	   |   move.l d0,154(sp)
     9fe:	   |   move.l 154(sp),d0
     a02:	   |   move.l d0,150(sp)
     a06:	   |   move.l #11321,146(sp)
     a0e:	   |   moveq #31,d0
     a10:	   |   move.l d0,142(sp)
     a14:	   |   move.l 755a <DOSBase>,d0
     a1a:	   |   movea.l d0,a6
     a1c:	   |   move.l 150(sp),d1
     a20:	   |   move.l 146(sp),d2
     a24:	   |   move.l 142(sp),d3
     a28:	   |   jsr -48(a6)
     a2c:	   |   move.l d0,138(sp)
		KPrintF("openAndVerify: Can't open file", filename);
     a30:	   |   move.l 328(sp),-(sp)
     a34:	   |   pea 2c59 <PutChar+0x1cb>
     a3a:	   |   jsr 27ec <KPrintF>
     a40:	   |   addq.l #8,sp
		return NULL;
     a42:	   |   moveq #0,d0
     a44:	/--|-- bra.w d08 <openAndVerify+0x366>
	}
	BOOL headerBad = FALSE;
     a48:	|  \-> clr.w 322(sp)
	if (FGetC (fp) != 'S') headerBad = TRUE;
     a4c:	|      move.l 306(sp),302(sp)
     a52:	|      move.l 755a <DOSBase>,d0
     a58:	|      movea.l d0,a6
     a5a:	|      move.l 302(sp),d1
     a5e:	|      jsr -306(a6)
     a62:	|      move.l d0,298(sp)
     a66:	|      move.l 298(sp),d0
     a6a:	|      moveq #83,d1
     a6c:	|      cmp.l d0,d1
     a6e:	|  /-- beq.s a76 <openAndVerify+0xd4>
     a70:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'L') headerBad = TRUE;
     a76:	|  \-> move.l 306(sp),294(sp)
     a7c:	|      move.l 755a <DOSBase>,d0
     a82:	|      movea.l d0,a6
     a84:	|      move.l 294(sp),d1
     a88:	|      jsr -306(a6)
     a8c:	|      move.l d0,290(sp)
     a90:	|      move.l 290(sp),d0
     a94:	|      moveq #76,d1
     a96:	|      cmp.l d0,d1
     a98:	|  /-- beq.s aa0 <openAndVerify+0xfe>
     a9a:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'U') headerBad = TRUE;
     aa0:	|  \-> move.l 306(sp),286(sp)
     aa6:	|      move.l 755a <DOSBase>,d0
     aac:	|      movea.l d0,a6
     aae:	|      move.l 286(sp),d1
     ab2:	|      jsr -306(a6)
     ab6:	|      move.l d0,282(sp)
     aba:	|      move.l 282(sp),d0
     abe:	|      moveq #85,d1
     ac0:	|      cmp.l d0,d1
     ac2:	|  /-- beq.s aca <openAndVerify+0x128>
     ac4:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'D') headerBad = TRUE;
     aca:	|  \-> move.l 306(sp),278(sp)
     ad0:	|      move.l 755a <DOSBase>,d0
     ad6:	|      movea.l d0,a6
     ad8:	|      move.l 278(sp),d1
     adc:	|      jsr -306(a6)
     ae0:	|      move.l d0,274(sp)
     ae4:	|      move.l 274(sp),d0
     ae8:	|      moveq #68,d1
     aea:	|      cmp.l d0,d1
     aec:	|  /-- beq.s af4 <openAndVerify+0x152>
     aee:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra1) headerBad = TRUE;
     af4:	|  \-> move.l 306(sp),270(sp)
     afa:	|      move.l 755a <DOSBase>,d0
     b00:	|      movea.l d0,a6
     b02:	|      move.l 270(sp),d1
     b06:	|      jsr -306(a6)
     b0a:	|      move.l d0,266(sp)
     b0e:	|      move.l 266(sp),d1
     b12:	|      move.b 16(sp),d0
     b16:	|      ext.w d0
     b18:	|      movea.w d0,a0
     b1a:	|      cmpa.l d1,a0
     b1c:	|  /-- beq.s b24 <openAndVerify+0x182>
     b1e:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra2) headerBad = TRUE;
     b24:	|  \-> move.l 306(sp),262(sp)
     b2a:	|      move.l 755a <DOSBase>,d0
     b30:	|      movea.l d0,a6
     b32:	|      move.l 262(sp),d1
     b36:	|      jsr -306(a6)
     b3a:	|      move.l d0,258(sp)
     b3e:	|      move.l 258(sp),d1
     b42:	|      move.b 14(sp),d0
     b46:	|      ext.w d0
     b48:	|      movea.w d0,a0
     b4a:	|      cmpa.l d1,a0
     b4c:	|  /-- beq.s b54 <openAndVerify+0x1b2>
     b4e:	|  |   move.w #1,322(sp)
	if (headerBad) {
     b54:	|  \-> tst.w 322(sp)
     b58:	|  /-- beq.s bb0 <openAndVerify+0x20e>
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
     b5a:	|  |   move.l 755a <DOSBase>,d0
     b60:	|  |   movea.l d0,a6
     b62:	|  |   jsr -60(a6)
     b66:	|  |   move.l d0,174(sp)
     b6a:	|  |   move.l 174(sp),d0
     b6e:	|  |   move.l d0,170(sp)
     b72:	|  |   move.l #11384,166(sp)
     b7a:	|  |   moveq #31,d0
     b7c:	|  |   move.l d0,162(sp)
     b80:	|  |   move.l 755a <DOSBase>,d0
     b86:	|  |   movea.l d0,a6
     b88:	|  |   move.l 170(sp),d1
     b8c:	|  |   move.l 166(sp),d2
     b90:	|  |   move.l 162(sp),d3
     b94:	|  |   jsr -48(a6)
     b98:	|  |   move.l d0,158(sp)
		KPrintF("openAndVerify: Bad Header\n");
     b9c:	|  |   pea 2c78 <PutChar+0x1ea>
     ba2:	|  |   jsr 27ec <KPrintF>
     ba8:	|  |   addq.l #4,sp
		return NULL;
     baa:	|  |   moveq #0,d0
     bac:	+--|-- bra.w d08 <openAndVerify+0x366>
	}
	FGetC (fp);
     bb0:	|  \-> move.l 306(sp),254(sp)
     bb6:	|      move.l 755a <DOSBase>,d0
     bbc:	|      movea.l d0,a6
     bbe:	|      move.l 254(sp),d1
     bc2:	|      jsr -306(a6)
     bc6:	|      move.l d0,250(sp)
	while (FGetC(fp)) {;}
     bca:	|      nop
     bcc:	|  /-> move.l 306(sp),246(sp)
     bd2:	|  |   move.l 755a <DOSBase>,d0
     bd8:	|  |   movea.l d0,a6
     bda:	|  |   move.l 246(sp),d1
     bde:	|  |   jsr -306(a6)
     be2:	|  |   move.l d0,242(sp)
     be6:	|  |   move.l 242(sp),d0
     bea:	|  \-- bne.s bcc <openAndVerify+0x22a>

	int majVersion = FGetC (fp);
     bec:	|      move.l 306(sp),238(sp)
     bf2:	|      move.l 755a <DOSBase>,d0
     bf8:	|      movea.l d0,a6
     bfa:	|      move.l 238(sp),d1
     bfe:	|      jsr -306(a6)
     c02:	|      move.l d0,234(sp)
     c06:	|      move.l 234(sp),d0
     c0a:	|      move.l d0,230(sp)
	int minVersion = FGetC (fp);
     c0e:	|      move.l 306(sp),226(sp)
     c14:	|      move.l 755a <DOSBase>,d0
     c1a:	|      movea.l d0,a6
     c1c:	|      move.l 226(sp),d1
     c20:	|      jsr -306(a6)
     c24:	|      move.l d0,222(sp)
     c28:	|      move.l 222(sp),d0
     c2c:	|      move.l d0,218(sp)
	*fileVersion = majVersion * 256 + minVersion;
     c30:	|      move.l 230(sp),d0
     c34:	|      lsl.l #8,d0
     c36:	|      add.l 218(sp),d0
     c3a:	|      movea.l 344(sp),a0
     c3e:	|      move.l d0,(a0)

	char txtVer[120];

	if (*fileVersion > WHOLE_VERSION) {
     c40:	|      movea.l 344(sp),a0
     c44:	|      move.l (a0),d0
     c46:	|      cmpi.l #514,d0
     c4c:	|  /-- ble.s ca2 <openAndVerify+0x300>
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
     c4e:	|  |   move.l 755a <DOSBase>,d0
     c54:	|  |   movea.l d0,a6
     c56:	|  |   jsr -60(a6)
     c5a:	|  |   move.l d0,194(sp)
     c5e:	|  |   move.l 194(sp),d0
     c62:	|  |   move.l d0,190(sp)
     c66:	|  |   move.l #11411,186(sp)
     c6e:	|  |   moveq #100,d1
     c70:	|  |   move.l d1,182(sp)
     c74:	|  |   move.l 755a <DOSBase>,d0
     c7a:	|  |   movea.l d0,a6
     c7c:	|  |   move.l 190(sp),d1
     c80:	|  |   move.l 186(sp),d2
     c84:	|  |   move.l 182(sp),d3
     c88:	|  |   jsr -48(a6)
     c8c:	|  |   move.l d0,178(sp)
		KPrintF(ERROR_VERSION_TOO_LOW_1);
     c90:	|  |   pea 2c93 <PutChar+0x205>
     c96:	|  |   jsr 27ec <KPrintF>
     c9c:	|  |   addq.l #4,sp
		return NULL;
     c9e:	|  |   moveq #0,d0
     ca0:	+--|-- bra.s d08 <openAndVerify+0x366>
	} else if (*fileVersion < MINIM_VERSION) {
     ca2:	|  \-> movea.l 344(sp),a0
     ca6:	|      move.l (a0),d0
     ca8:	|      cmpi.l #257,d0
     cae:	|  /-- bgt.s d04 <openAndVerify+0x362>
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
     cb0:	|  |   move.l 755a <DOSBase>,d0
     cb6:	|  |   movea.l d0,a6
     cb8:	|  |   jsr -60(a6)
     cbc:	|  |   move.l d0,214(sp)
     cc0:	|  |   move.l 214(sp),d0
     cc4:	|  |   move.l d0,210(sp)
     cc8:	|  |   move.l #11480,206(sp)
     cd0:	|  |   moveq #100,d0
     cd2:	|  |   move.l d0,202(sp)
     cd6:	|  |   move.l 755a <DOSBase>,d0
     cdc:	|  |   movea.l d0,a6
     cde:	|  |   move.l 210(sp),d1
     ce2:	|  |   move.l 206(sp),d2
     ce6:	|  |   move.l 202(sp),d3
     cea:	|  |   jsr -48(a6)
     cee:	|  |   move.l d0,198(sp)
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
     cf2:	|  |   pea 2cd8 <PutChar+0x24a>
     cf8:	|  |   jsr 27ec <KPrintF>
     cfe:	|  |   addq.l #4,sp
		return NULL;
     d00:	|  |   moveq #0,d0
     d02:	+--|-- bra.s d08 <openAndVerify+0x366>
	}
	return fp;
     d04:	|  \-> move.l 306(sp),d0
     d08:	\----> movem.l (sp)+,d2-d3/a6
     d0c:	       lea 312(sp),sp
     d10:	       rts

00000d12 <main_sludge>:
char * gameName = NULL;
char * gamePath = NULL;
char *bundleFolder;

int main_sludge(int argc, char *argv[])
{	
     d12:	          lea -40(sp),sp
     d16:	          movem.l d2-d3/a6,-(sp)
	/* Dimensions of our window. */
	//AMIGA TODO: Maybe remove as there will be no windowed mode
    winWidth = 320;
     d1a:	          move.l #320,749e <winWidth>
    winHeight = 256;
     d24:	          move.l #256,74a2 <winHeight>

	char * sludgeFile;

	if(argc == 0) {
     d2e:	          tst.l 56(sp)
     d32:	      /-- bne.s d4a <main_sludge+0x38>
		bundleFolder = copyString("game/");
     d34:	      |   pea 2d1f <PutChar+0x291>
     d3a:	      |   jsr 269e <copyString>
     d40:	      |   addq.l #4,sp
     d42:	      |   move.l d0,74de <bundleFolder>
     d48:	   /--|-- bra.s d60 <main_sludge+0x4e>
	} else {
		bundleFolder = copyString(argv[0]);
     d4a:	   |  \-> movea.l 60(sp),a0
     d4e:	   |      move.l (a0),d0
     d50:	   |      move.l d0,-(sp)
     d52:	   |      jsr 269e <copyString>
     d58:	   |      addq.l #4,sp
     d5a:	   |      move.l d0,74de <bundleFolder>
	}
    
	int lastSlash = -1;
     d60:	   \----> moveq #-1,d0
     d62:	          move.l d0,44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
     d66:	          clr.l 40(sp)
     d6a:	   /----- bra.s d8c <main_sludge+0x7a>
		if (bundleFolder[i] == PATHSLASH) lastSlash = i;
     d6c:	/--|----> move.l 74de <bundleFolder>,d1
     d72:	|  |      move.l 40(sp),d0
     d76:	|  |      movea.l d1,a0
     d78:	|  |      adda.l d0,a0
     d7a:	|  |      move.b (a0),d0
     d7c:	|  |      cmpi.b #47,d0
     d80:	|  |  /-- bne.s d88 <main_sludge+0x76>
     d82:	|  |  |   move.l 40(sp),44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
     d88:	|  |  \-> addq.l #1,40(sp)
     d8c:	|  \----> move.l 74de <bundleFolder>,d1
     d92:	|         move.l 40(sp),d0
     d96:	|         movea.l d1,a0
     d98:	|         adda.l d0,a0
     d9a:	|         move.b (a0),d0
     d9c:	\-------- bne.s d6c <main_sludge+0x5a>
	}
	bundleFolder[lastSlash+1] = NULL;
     d9e:	          move.l 74de <bundleFolder>,d0
     da4:	          move.l 44(sp),d1
     da8:	          addq.l #1,d1
     daa:	          movea.l d0,a0
     dac:	          adda.l d1,a0
     dae:	          clr.b (a0)

	if (argc > 1) {
     db0:	          moveq #1,d0
     db2:	          cmp.l 56(sp),d0
     db6:	      /-- bge.s dd2 <main_sludge+0xc0>
		sludgeFile = argv[argc - 1];
     db8:	      |   move.l 56(sp),d0
     dbc:	      |   addi.l #1073741823,d0
     dc2:	      |   add.l d0,d0
     dc4:	      |   add.l d0,d0
     dc6:	      |   movea.l 60(sp),a0
     dca:	      |   adda.l d0,a0
     dcc:	      |   move.l (a0),48(sp)
     dd0:	   /--|-- bra.s e2c <main_sludge+0x11a>
	} else {
		sludgeFile = joinStrings (bundleFolder, "gamedata.slg");
     dd2:	   |  \-> move.l 74de <bundleFolder>,d0
     dd8:	   |      pea 2d25 <PutChar+0x297>
     dde:	   |      move.l d0,-(sp)
     de0:	   |      jsr 270c <joinStrings>
     de6:	   |      addq.l #8,sp
     de8:	   |      move.l d0,48(sp)
		if (! ( fileExists (sludgeFile) ) ) {
     dec:	   |      move.l 48(sp),-(sp)
     df0:	   |      jsr 25b4 <fileExists>
     df6:	   |      addq.l #4,sp
     df8:	   |      tst.b d0
     dfa:	   +----- bne.s e2c <main_sludge+0x11a>
			FreeVec(sludgeFile);
     dfc:	   |      move.l 48(sp),36(sp)
     e02:	   |      move.l 7552 <SysBase>,d0
     e08:	   |      movea.l d0,a6
     e0a:	   |      movea.l 36(sp),a1
     e0e:	   |      jsr -690(a6)
			sludgeFile = joinStrings (bundleFolder, "gamedata");			
     e12:	   |      move.l 74de <bundleFolder>,d0
     e18:	   |      pea 2d32 <PutChar+0x2a4>
     e1e:	   |      move.l d0,-(sp)
     e20:	   |      jsr 270c <joinStrings>
     e26:	   |      addq.l #8,sp
     e28:	   |      move.l d0,48(sp)
	//AMIGA TODO: Show arguments
	/*if (! parseCmdlineParameters(argc, argv) && !(sludgeFile) ) {
		printCmdlineUsage();
		return 0;
	}*/
	if (! fileExists(sludgeFile) ) {	
     e2c:	   \----> move.l 48(sp),-(sp)
     e30:	          jsr 25b4 <fileExists>
     e36:	          addq.l #4,sp
     e38:	          tst.b d0
     e3a:	      /-- bne.s e84 <main_sludge+0x172>
		Write(Output(), (APTR)"Game file not found.\n", 21);
     e3c:	      |   move.l 755a <DOSBase>,d0
     e42:	      |   movea.l d0,a6
     e44:	      |   jsr -60(a6)
     e48:	      |   move.l d0,28(sp)
     e4c:	      |   move.l 28(sp),d0
     e50:	      |   move.l d0,24(sp)
     e54:	      |   move.l #11579,20(sp)
     e5c:	      |   moveq #21,d0
     e5e:	      |   move.l d0,16(sp)
     e62:	      |   move.l 755a <DOSBase>,d0
     e68:	      |   movea.l d0,a6
     e6a:	      |   move.l 24(sp),d1
     e6e:	      |   move.l 20(sp),d2
     e72:	      |   move.l 16(sp),d3
     e76:	      |   jsr -48(a6)
     e7a:	      |   move.l d0,12(sp)
		//AMIGA TODO: Show arguments
		//printCmdlineUsage();
		return 0;
     e7e:	      |   moveq #0,d0
     e80:	   /--|-- bra.w f40 <main_sludge+0x22e>
	}

	setGameFilePath (sludgeFile);
     e84:	   |  \-> move.l 48(sp),-(sp)
     e88:	   |      jsr f4a <setGameFilePath>
     e8e:	   |      addq.l #4,sp
	if (! initSludge (sludgeFile)) return 0;
     e90:	   |      move.l 48(sp),-(sp)
     e94:	   |      jsr 234 <initSludge>
     e9a:	   |      addq.l #4,sp
     e9c:	   |      tst.w d0
     e9e:	   |  /-- bne.s ea6 <main_sludge+0x194>
     ea0:	   |  |   moveq #0,d0
     ea2:	   +--|-- bra.w f40 <main_sludge+0x22e>
	
	if (! resizeBackdrop (winWidth, winHeight)) {
     ea6:	   |  \-> move.l 74a2 <winHeight>,d0
     eac:	   |      move.l d0,d1
     eae:	   |      move.l 749e <winWidth>,d0
     eb4:	   |      move.l d1,-(sp)
     eb6:	   |      move.l d0,-(sp)
     eb8:	   |      jsr 194a <resizeBackdrop>
     ebe:	   |      addq.l #8,sp
     ec0:	   |      tst.w d0
     ec2:	   |  /-- bne.s ed6 <main_sludge+0x1c4>
		KPrintF("Couldn't allocate memory for backdrop");
     ec4:	   |  |   pea 2d51 <PutChar+0x2c3>
     eca:	   |  |   jsr 27ec <KPrintF>
     ed0:	   |  |   addq.l #4,sp
		return FALSE;
     ed2:	   |  |   moveq #0,d0
     ed4:	   +--|-- bra.s f40 <main_sludge+0x22e>
	}

	if (! initPeople ())
     ed6:	   |  \-> jsr 181e <initPeople>
     edc:	   |      tst.w d0
     ede:	   |  /-- bne.s ef2 <main_sludge+0x1e0>
	{
		KPrintF("Couldn't initialise people stuff");
     ee0:	   |  |   pea 2d77 <PutChar+0x2e9>
     ee6:	   |  |   jsr 27ec <KPrintF>
     eec:	   |  |   addq.l #4,sp
		return FALSE;
     eee:	   |  |   moveq #0,d0
     ef0:	   +--|-- bra.s f40 <main_sludge+0x22e>
	}

	if (! initFloor ())
     ef2:	   |  \-> jsr e4 <initFloor>
     ef8:	   |      tst.w d0
     efa:	   |  /-- bne.s f0e <main_sludge+0x1fc>
	{
		KPrintF("Couldn't initialise floor stuff");
     efc:	   |  |   pea 2d98 <PutChar+0x30a>
     f02:	   |  |   jsr 27ec <KPrintF>
     f08:	   |  |   addq.l #4,sp
		return FALSE;
     f0a:	   |  |   moveq #0,d0
     f0c:	   +--|-- bra.s f40 <main_sludge+0x22e>
	}

	if (! initObjectTypes ())
     f0e:	   |  \-> jsr 1f72 <initObjectTypes>
     f14:	   |      tst.l d0
     f16:	   |  /-- bne.s f2a <main_sludge+0x218>
	{
		KPrintF("Couldn't initialise object type stuff");
     f18:	   |  |   pea 2db8 <PutChar+0x32a>
     f1e:	   |  |   jsr 27ec <KPrintF>
     f24:	   |  |   addq.l #4,sp
		return FALSE;
     f26:	   |  |   moveq #0,d0
     f28:	   +--|-- bra.s f40 <main_sludge+0x22e>
	}

	//Amiga Cleanup
	FreeVec(sludgeFile);
     f2a:	   |  \-> move.l 48(sp),32(sp)
     f30:	   |      move.l 7552 <SysBase>,d0
     f36:	   |      movea.l d0,a6
     f38:	   |      movea.l 32(sp),a1
     f3c:	   |      jsr -690(a6)
}
     f40:	   \----> movem.l (sp)+,d2-d3/a6
     f44:	          lea 40(sp),sp
     f48:	          rts

00000f4a <setGameFilePath>:

void setGameFilePath (char * f) {
     f4a:	          lea -1104(sp),sp
     f4e:	          move.l a6,-(sp)
     f50:	          move.l d2,-(sp)
	char currentDir[1000];

	if (!GetCurrentDirName( currentDir, 998)) {
     f52:	          move.l #1112,d0
     f58:	          add.l sp,d0
     f5a:	          addi.l #-1102,d0
     f60:	          move.l d0,1100(sp)
     f64:	          move.l #998,1096(sp)
     f6c:	          move.l 755a <DOSBase>,d0
     f72:	          movea.l d0,a6
     f74:	          move.l 1100(sp),d1
     f78:	          move.l 1096(sp),d2
     f7c:	          jsr -564(a6)
     f80:	          move.w d0,1094(sp)
     f84:	          move.w 1094(sp),d0
     f88:	      /-- bne.s f98 <setGameFilePath+0x4e>
		KPrintF("setGameFilePath: Can't get current directory.\n");
     f8a:	      |   pea 2dde <PutChar+0x350>
     f90:	      |   jsr 27ec <KPrintF>
     f96:	      |   addq.l #4,sp
	}	

	int got = -1, a;	
     f98:	      \-> moveq #-1,d0
     f9a:	          move.l d0,1108(sp)

	for (a = 0; f[a]; a ++) {
     f9e:	          clr.l 1104(sp)
     fa2:	   /----- bra.s fc0 <setGameFilePath+0x76>
		if (f[a] == PATHSLASH) got = a;
     fa4:	/--|----> move.l 1104(sp),d0
     fa8:	|  |      movea.l 1116(sp),a0
     fac:	|  |      adda.l d0,a0
     fae:	|  |      move.b (a0),d0
     fb0:	|  |      cmpi.b #47,d0
     fb4:	|  |  /-- bne.s fbc <setGameFilePath+0x72>
     fb6:	|  |  |   move.l 1104(sp),1108(sp)
	for (a = 0; f[a]; a ++) {
     fbc:	|  |  \-> addq.l #1,1104(sp)
     fc0:	|  \----> move.l 1104(sp),d0
     fc4:	|         movea.l 1116(sp),a0
     fc8:	|         adda.l d0,a0
     fca:	|         move.b (a0),d0
     fcc:	\-------- bne.s fa4 <setGameFilePath+0x5a>
	}

	if (got != -1) {
     fce:	          moveq #-1,d0
     fd0:	          cmp.l 1108(sp),d0
     fd4:	   /----- beq.s 104e <setGameFilePath+0x104>
		f[got] = 0;	
     fd6:	   |      move.l 1108(sp),d0
     fda:	   |      movea.l 1116(sp),a0
     fde:	   |      adda.l d0,a0
     fe0:	   |      clr.b (a0)
		BPTR lock = Lock(f, ACCESS_READ);	
     fe2:	   |      move.l 1116(sp),1090(sp)
     fe8:	   |      moveq #-2,d0
     fea:	   |      move.l d0,1086(sp)
     fee:	   |      move.l 755a <DOSBase>,d0
     ff4:	   |      movea.l d0,a6
     ff6:	   |      move.l 1090(sp),d1
     ffa:	   |      move.l 1086(sp),d2
     ffe:	   |      jsr -84(a6)
    1002:	   |      move.l d0,1082(sp)
    1006:	   |      move.l 1082(sp),d0
    100a:	   |      move.l d0,1078(sp)
		if (!CurrentDir(lock)) {
    100e:	   |      move.l 1078(sp),1074(sp)
    1014:	   |      move.l 755a <DOSBase>,d0
    101a:	   |      movea.l d0,a6
    101c:	   |      move.l 1074(sp),d1
    1020:	   |      jsr -126(a6)
    1024:	   |      move.l d0,1070(sp)
    1028:	   |      move.l 1070(sp),d0
    102c:	   |  /-- bne.s 1040 <setGameFilePath+0xf6>
			KPrintF("setGameFilePath:: Failed changing to directory %s\n", f);
    102e:	   |  |   move.l 1116(sp),-(sp)
    1032:	   |  |   pea 2e0d <PutChar+0x37f>
    1038:	   |  |   jsr 27ec <KPrintF>
    103e:	   |  |   addq.l #8,sp
		}
		f[got] = PATHSLASH;
    1040:	   |  \-> move.l 1108(sp),d0
    1044:	   |      movea.l 1116(sp),a0
    1048:	   |      adda.l d0,a0
    104a:	   |      move.b #47,(a0)
	}

	gamePath = AllocVec(400, MEMF_ANY);
    104e:	   \----> move.l #400,1066(sp)
    1056:	          clr.l 1062(sp)
    105a:	          move.l 7552 <SysBase>,d0
    1060:	          movea.l d0,a6
    1062:	          move.l 1066(sp),d0
    1066:	          move.l 1062(sp),d1
    106a:	          jsr -684(a6)
    106e:	          move.l d0,1058(sp)
    1072:	          move.l 1058(sp),d0
    1076:	          move.l d0,74da <gamePath>
	if (gamePath==0) {
    107c:	          move.l 74da <gamePath>,d0
    1082:	      /-- bne.s 1096 <setGameFilePath+0x14c>
		KPrintF("setGameFilePath: Can't reserve memory for game directory.\n");
    1084:	      |   pea 2e40 <PutChar+0x3b2>
    108a:	      |   jsr 27ec <KPrintF>
    1090:	      |   addq.l #4,sp
    1092:	   /--|-- bra.w 117e <setGameFilePath+0x234>
		return;
	}

	BPTR lock = Lock(gamePath, ACCESS_READ);	
    1096:	   |  \-> move.l 74da <gamePath>,1054(sp)
    109e:	   |      moveq #-2,d0
    10a0:	   |      move.l d0,1050(sp)
    10a4:	   |      move.l 755a <DOSBase>,d0
    10aa:	   |      movea.l d0,a6
    10ac:	   |      move.l 1054(sp),d1
    10b0:	   |      move.l 1050(sp),d2
    10b4:	   |      jsr -84(a6)
    10b8:	   |      move.l d0,1046(sp)
    10bc:	   |      move.l 1046(sp),d0
    10c0:	   |      move.l d0,1042(sp)
	if (! CurrentDir(lock)) {
    10c4:	   |      move.l 1042(sp),1038(sp)
    10ca:	   |      move.l 755a <DOSBase>,d0
    10d0:	   |      movea.l d0,a6
    10d2:	   |      move.l 1038(sp),d1
    10d6:	   |      jsr -126(a6)
    10da:	   |      move.l d0,1034(sp)
    10de:	   |      move.l 1034(sp),d0
    10e2:	   |  /-- bne.s 10f2 <setGameFilePath+0x1a8>
		KPrintF("setGameFilePath: Can't get game directory.\n");
    10e4:	   |  |   pea 2e7b <PutChar+0x3ed>
    10ea:	   |  |   jsr 27ec <KPrintF>
    10f0:	   |  |   addq.l #4,sp
	}
	
	lock = Lock(currentDir, ACCESS_READ);	
    10f2:	   |  \-> move.l #1112,d0
    10f8:	   |      add.l sp,d0
    10fa:	   |      addi.l #-1102,d0
    1100:	   |      move.l d0,1030(sp)
    1104:	   |      moveq #-2,d0
    1106:	   |      move.l d0,1026(sp)
    110a:	   |      move.l 755a <DOSBase>,d0
    1110:	   |      movea.l d0,a6
    1112:	   |      move.l 1030(sp),d1
    1116:	   |      move.l 1026(sp),d2
    111a:	   |      jsr -84(a6)
    111e:	   |      move.l d0,1022(sp)
    1122:	   |      move.l 1022(sp),d0
    1126:	   |      move.l d0,1042(sp)
	if (!CurrentDir(lock)) {	
    112a:	   |      move.l 1042(sp),1018(sp)
    1130:	   |      move.l 755a <DOSBase>,d0
    1136:	   |      movea.l d0,a6
    1138:	   |      move.l 1018(sp),d1
    113c:	   |      jsr -126(a6)
    1140:	   |      move.l d0,1014(sp)
    1144:	   |      move.l 1014(sp),d0
    1148:	   |  /-- bne.s 115e <setGameFilePath+0x214>
		KPrintF("setGameFilePath: Failed changing to directory %s\n", currentDir);
    114a:	   |  |   moveq #10,d0
    114c:	   |  |   add.l sp,d0
    114e:	   |  |   move.l d0,-(sp)
    1150:	   |  |   pea 2ea7 <PutChar+0x419>
    1156:	   |  |   jsr 27ec <KPrintF>
    115c:	   |  |   addq.l #8,sp
	}

	//Free Mem
	if (gamePath != 0) FreeVec(gamePath);
    115e:	   |  \-> move.l 74da <gamePath>,d0
    1164:	   +----- beq.s 117e <setGameFilePath+0x234>
    1166:	   |      move.l 74da <gamePath>,1010(sp)
    116e:	   |      move.l 7552 <SysBase>,d0
    1174:	   |      movea.l d0,a6
    1176:	   |      movea.l 1010(sp),a1
    117a:	   |      jsr -690(a6)
}
    117e:	   \----> move.l (sp)+,d2
    1180:	          movea.l (sp)+,a6
    1182:	          lea 1104(sp),sp
    1186:	          rts

00001188 <killZBuffer>:
#include "zbuffer.h"
#include "graphics.h"

struct zBufferData zBuffer;

void killZBuffer () {
    1188:	    subq.l #4,sp
    118a:	    move.l a6,-(sp)
	if (zBuffer.tex) {
    118c:	    move.l 7532 <zBuffer+0x50>,d0
    1192:	/-- beq.s 11ca <killZBuffer+0x42>
		deleteTextures (1, &zBuffer.texName);
    1194:	|   pea 7536 <zBuffer+0x54>
    119a:	|   pea 1 <_start+0x1>
    119e:	|   jsr 140 <deleteTextures>
    11a4:	|   addq.l #8,sp
		zBuffer.texName = 0;
    11a6:	|   clr.l 7536 <zBuffer+0x54>
        FreeVec(zBuffer.tex);
    11ac:	|   move.l 7532 <zBuffer+0x50>,4(sp)
    11b4:	|   move.l 7552 <SysBase>,d0
    11ba:	|   movea.l d0,a6
    11bc:	|   movea.l 4(sp),a1
    11c0:	|   jsr -690(a6)
		zBuffer.tex = NULL;
    11c4:	|   clr.l 7532 <zBuffer+0x50>
	}
	zBuffer.numPanels = 0;
    11ca:	\-> clr.l 74ea <zBuffer+0x8>
	zBuffer.originalNum =0;
    11d0:	    clr.l 752e <zBuffer+0x4c>
    11d6:	    nop
    11d8:	    movea.l (sp)+,a6
    11da:	    addq.l #4,sp
    11dc:	    rts

000011de <getNumberedString>:
// This is needed for old games.
char * convertString(char * s) {
	return NULL;
}

char * getNumberedString (int value) {
    11de:	       lea -56(sp),sp
    11e2:	       movem.l d2-d3/a6,-(sp)

	if (sliceBusy) {
    11e6:	       move.w 6008 <sliceBusy>,d0
    11ec:	   /-- beq.s 1236 <getNumberedString+0x58>
		Write(Output(), (APTR)"getNumberedString: Can't read from data file. I'm already reading something\n", 76);        
    11ee:	   |   move.l 755a <DOSBase>,d0
    11f4:	   |   movea.l d0,a6
    11f6:	   |   jsr -60(a6)
    11fa:	   |   move.l d0,28(sp)
    11fe:	   |   move.l 28(sp),d0
    1202:	   |   move.l d0,24(sp)
    1206:	   |   move.l #11993,20(sp)
    120e:	   |   moveq #76,d0
    1210:	   |   move.l d0,16(sp)
    1214:	   |   move.l 755a <DOSBase>,d0
    121a:	   |   movea.l d0,a6
    121c:	   |   move.l 24(sp),d1
    1220:	   |   move.l 20(sp),d2
    1224:	   |   move.l 16(sp),d3
    1228:	   |   jsr -48(a6)
    122c:	   |   move.l d0,12(sp)
		return NULL;
    1230:	   |   moveq #0,d0
    1232:	/--|-- bra.w 12d2 <getNumberedString+0xf4>
	}

	Seek(bigDataFile, (value << 2) + startOfTextIndex, OFFSET_BEGINNING);
    1236:	|  \-> move.l 753a <bigDataFile>,64(sp)
    123e:	|      move.l 72(sp),d0
    1242:	|      add.l d0,d0
    1244:	|      add.l d0,d0
    1246:	|      move.l d0,d1
    1248:	|      move.l 7546 <startOfTextIndex>,d0
    124e:	|      add.l d1,d0
    1250:	|      move.l d0,60(sp)
    1254:	|      moveq #-1,d0
    1256:	|      move.l d0,56(sp)
    125a:	|      move.l 755a <DOSBase>,d0
    1260:	|      movea.l d0,a6
    1262:	|      move.l 64(sp),d1
    1266:	|      move.l 60(sp),d2
    126a:	|      move.l 56(sp),d3
    126e:	|      jsr -66(a6)
    1272:	|      move.l d0,52(sp)
	value = get4bytes (bigDataFile);
    1276:	|      move.l 753a <bigDataFile>,d0
    127c:	|      move.l d0,-(sp)
    127e:	|      jsr 1d8e <get4bytes>
    1284:	|      addq.l #4,sp
    1286:	|      move.l d0,72(sp)
	Seek (bigDataFile, value, OFFSET_BEGINING);
    128a:	|      move.l 753a <bigDataFile>,48(sp)
    1292:	|      move.l 72(sp),44(sp)
    1298:	|      moveq #-1,d0
    129a:	|      move.l d0,40(sp)
    129e:	|      move.l 755a <DOSBase>,d0
    12a4:	|      movea.l d0,a6
    12a6:	|      move.l 48(sp),d1
    12aa:	|      move.l 44(sp),d2
    12ae:	|      move.l 40(sp),d3
    12b2:	|      jsr -66(a6)
    12b6:	|      move.l d0,36(sp)

	char * s = readString (bigDataFile);    
    12ba:	|      move.l 753a <bigDataFile>,d0
    12c0:	|      move.l d0,-(sp)
    12c2:	|      jsr 1eca <readString>
    12c8:	|      addq.l #4,sp
    12ca:	|      move.l d0,32(sp)
	
	return s;
    12ce:	|      move.l 32(sp),d0
}
    12d2:	\----> movem.l (sp)+,d2-d3/a6
    12d6:	       lea 56(sp),sp
    12da:	       rts

000012dc <setFileIndices>:

void setFileIndices (BPTR fp, unsigned int numLanguages, unsigned int skipBefore) {
    12dc:	       lea -180(sp),sp
    12e0:	       movem.l d2-d3/a6,-(sp)
	if (fp) {
    12e4:	       tst.l 196(sp)
    12e8:	/----- beq.s 1328 <setFileIndices+0x4c>
		// Keep hold of the file handle, and let things get at it
		bigDataFile = fp;
    12ea:	|      move.l 196(sp),753a <bigDataFile>
		startIndex = Seek( fp, 0, OFFSET_CURRENT);
    12f2:	|      move.l 196(sp),168(sp)
    12f8:	|      clr.l 164(sp)
    12fc:	|      clr.l 160(sp)
    1300:	|      move.l 755a <DOSBase>,d0
    1306:	|      movea.l d0,a6
    1308:	|      move.l 168(sp),d1
    130c:	|      move.l 164(sp),d2
    1310:	|      move.l 160(sp),d3
    1314:	|      jsr -66(a6)
    1318:	|      move.l d0,156(sp)
    131c:	|      move.l 156(sp),d0
    1320:	|      move.l d0,753e <startIndex>
    1326:	|  /-- bra.s 1362 <setFileIndices+0x86>
	} else {
		// No file pointer - this means that we reuse the bigDataFile
		fp = bigDataFile;
    1328:	\--|-> move.l 753a <bigDataFile>,196(sp)
        Seek(fp, startIndex, OFFSET_BEGINNING);
    1330:	   |   move.l 196(sp),184(sp)
    1336:	   |   move.l 753e <startIndex>,d0
    133c:	   |   move.l d0,180(sp)
    1340:	   |   moveq #-1,d0
    1342:	   |   move.l d0,176(sp)
    1346:	   |   move.l 755a <DOSBase>,d0
    134c:	   |   movea.l d0,a6
    134e:	   |   move.l 184(sp),d1
    1352:	   |   move.l 180(sp),d2
    1356:	   |   move.l 176(sp),d3
    135a:	   |   jsr -66(a6)
    135e:	   |   move.l d0,172(sp)
	}
	sliceBusy = FALSE;
    1362:	   \-> clr.w 6008 <sliceBusy>

	if (skipBefore > numLanguages) {
    1368:	       move.l 204(sp),d0
    136c:	       cmp.l 200(sp),d0
    1370:	   /-- bls.s 1384 <setFileIndices+0xa8>
		KPrintF("setFileIndices: Warning: Not a valid language ID! Using default instead.");
    1372:	   |   pea 2f26 <PutChar+0x498>
    1378:	   |   jsr 27ec <KPrintF>
    137e:	   |   addq.l #4,sp
		skipBefore = 0;
    1380:	   |   clr.l 204(sp)
	}

	// STRINGS
	int skipAfter = numLanguages - skipBefore;
    1384:	   \-> move.l 200(sp),d0
    1388:	       sub.l 204(sp),d0
    138c:	       move.l d0,188(sp)
	while (skipBefore) {
    1390:	   /-- bra.s 13cc <setFileIndices+0xf0>
        Seek(fp, get4bytes(fp),0);		
    1392:	/--|-> move.l 196(sp),24(sp)
    1398:	|  |   move.l 196(sp),-(sp)
    139c:	|  |   jsr 1d8e <get4bytes>
    13a2:	|  |   addq.l #4,sp
    13a4:	|  |   move.l d0,20(sp)
    13a8:	|  |   clr.l 16(sp)
    13ac:	|  |   move.l 755a <DOSBase>,d0
    13b2:	|  |   movea.l d0,a6
    13b4:	|  |   move.l 24(sp),d1
    13b8:	|  |   move.l 20(sp),d2
    13bc:	|  |   move.l 16(sp),d3
    13c0:	|  |   jsr -66(a6)
    13c4:	|  |   move.l d0,12(sp)
		skipBefore --;
    13c8:	|  |   subq.l #1,204(sp)
	while (skipBefore) {
    13cc:	|  \-> tst.l 204(sp)
    13d0:	\----- bne.s 1392 <setFileIndices+0xb6>
	}
	startOfTextIndex = startIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    13d2:	       move.l 196(sp),152(sp)
    13d8:	       clr.l 148(sp)
    13dc:	       clr.l 144(sp)
    13e0:	       move.l 755a <DOSBase>,d0
    13e6:	       movea.l d0,a6
    13e8:	       move.l 152(sp),d1
    13ec:	       move.l 148(sp),d2
    13f0:	       move.l 144(sp),d3
    13f4:	       jsr -66(a6)
    13f8:	       move.l d0,140(sp)
    13fc:	       move.l 140(sp),d0
    1400:	       addq.l #4,d0
    1402:	       move.l d0,753e <startIndex>
    1408:	       move.l 753e <startIndex>,d0
    140e:	       move.l d0,7546 <startOfTextIndex>

	Seek(fp, get4bytes (fp), OFFSET_BEGINNING);
    1414:	       move.l 196(sp),136(sp)
    141a:	       move.l 196(sp),-(sp)
    141e:	       jsr 1d8e <get4bytes>
    1424:	       addq.l #4,sp
    1426:	       move.l d0,132(sp)
    142a:	       moveq #-1,d0
    142c:	       move.l d0,128(sp)
    1430:	       move.l 755a <DOSBase>,d0
    1436:	       movea.l d0,a6
    1438:	       move.l 136(sp),d1
    143c:	       move.l 132(sp),d2
    1440:	       move.l 128(sp),d3
    1444:	       jsr -66(a6)
    1448:	       move.l d0,124(sp)

	while (skipAfter) {
    144c:	   /-- bra.s 148a <setFileIndices+0x1ae>
        Seek( fp, get4bytes (fp), OFFSET_BEGINING);
    144e:	/--|-> move.l 196(sp),40(sp)
    1454:	|  |   move.l 196(sp),-(sp)
    1458:	|  |   jsr 1d8e <get4bytes>
    145e:	|  |   addq.l #4,sp
    1460:	|  |   move.l d0,36(sp)
    1464:	|  |   moveq #-1,d0
    1466:	|  |   move.l d0,32(sp)
    146a:	|  |   move.l 755a <DOSBase>,d0
    1470:	|  |   movea.l d0,a6
    1472:	|  |   move.l 40(sp),d1
    1476:	|  |   move.l 36(sp),d2
    147a:	|  |   move.l 32(sp),d3
    147e:	|  |   jsr -66(a6)
    1482:	|  |   move.l d0,28(sp)
		skipAfter --;
    1486:	|  |   subq.l #1,188(sp)
	while (skipAfter) {
    148a:	|  \-> tst.l 188(sp)
    148e:	\----- bne.s 144e <setFileIndices+0x172>
	}

	startOfSubIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    1490:	       move.l 196(sp),120(sp)
    1496:	       clr.l 116(sp)
    149a:	       clr.l 112(sp)
    149e:	       move.l 755a <DOSBase>,d0
    14a4:	       movea.l d0,a6
    14a6:	       move.l 120(sp),d1
    14aa:	       move.l 116(sp),d2
    14ae:	       move.l 112(sp),d3
    14b2:	       jsr -66(a6)
    14b6:	       move.l d0,108(sp)
    14ba:	       move.l 108(sp),d0
    14be:	       addq.l #4,d0
    14c0:	       move.l d0,754a <startOfSubIndex>
    Seek( fp, get4bytes (fp), OFFSET_CURRENT);
    14c6:	       move.l 196(sp),104(sp)
    14cc:	       move.l 196(sp),-(sp)
    14d0:	       jsr 1d8e <get4bytes>
    14d6:	       addq.l #4,sp
    14d8:	       move.l d0,100(sp)
    14dc:	       clr.l 96(sp)
    14e0:	       move.l 755a <DOSBase>,d0
    14e6:	       movea.l d0,a6
    14e8:	       move.l 104(sp),d1
    14ec:	       move.l 100(sp),d2
    14f0:	       move.l 96(sp),d3
    14f4:	       jsr -66(a6)
    14f8:	       move.l d0,92(sp)

	startOfObjectIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    14fc:	       move.l 196(sp),88(sp)
    1502:	       clr.l 84(sp)
    1506:	       clr.l 80(sp)
    150a:	       move.l 755a <DOSBase>,d0
    1510:	       movea.l d0,a6
    1512:	       move.l 88(sp),d1
    1516:	       move.l 84(sp),d2
    151a:	       move.l 80(sp),d3
    151e:	       jsr -66(a6)
    1522:	       move.l d0,76(sp)
    1526:	       move.l 76(sp),d0
    152a:	       addq.l #4,d0
    152c:	       move.l d0,754e <startOfObjectIndex>
	Seek (fp, get4bytes (fp), OFFSET_CURRENT);
    1532:	       move.l 196(sp),72(sp)
    1538:	       move.l 196(sp),-(sp)
    153c:	       jsr 1d8e <get4bytes>
    1542:	       addq.l #4,sp
    1544:	       move.l d0,68(sp)
    1548:	       clr.l 64(sp)
    154c:	       move.l 755a <DOSBase>,d0
    1552:	       movea.l d0,a6
    1554:	       move.l 72(sp),d1
    1558:	       move.l 68(sp),d2
    155c:	       move.l 64(sp),d3
    1560:	       jsr -66(a6)
    1564:	       move.l d0,60(sp)

	// Remember that the data section starts here
	startOfDataIndex =  Seek( fp, 0, OFFSET_CURRENT);
    1568:	       move.l 196(sp),56(sp)
    156e:	       clr.l 52(sp)
    1572:	       clr.l 48(sp)
    1576:	       move.l 755a <DOSBase>,d0
    157c:	       movea.l d0,a6
    157e:	       move.l 56(sp),d1
    1582:	       move.l 52(sp),d2
    1586:	       move.l 48(sp),d3
    158a:	       jsr -66(a6)
    158e:	       move.l d0,44(sp)
    1592:	       move.l 44(sp),d0
    1596:	       move.l d0,7542 <startOfDataIndex>
    159c:	       nop
    159e:	       movem.l (sp)+,d2-d3/a6
    15a2:	       lea 180(sp),sp
    15a6:	       rts

000015a8 <WaitVbl>:
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
}

//vblank begins at vpos 312 hpos 1 and ends at vpos 25 hpos 1
//vsync begins at line 2 hpos 132 and ends at vpos 5 hpos 18 
void WaitVbl() {
    15a8:	       subq.l #8,sp
	debug_start_idle();
    15aa:	       jsr 29c4 <debug_start_idle>
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    15b0:	   /-> movea.l #14675972,a0
    15b6:	   |   move.l (a0),d0
    15b8:	   |   move.l d0,(sp)
		vpos&=0x1ff00;
    15ba:	   |   move.l (sp),d0
    15bc:	   |   andi.l #130816,d0
    15c2:	   |   move.l d0,(sp)
		if (vpos!=(311<<8))
    15c4:	   |   move.l (sp),d0
    15c6:	   |   cmpi.l #79616,d0
    15cc:	   \-- beq.s 15b0 <WaitVbl+0x8>
			break;
	}
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    15ce:	/----> movea.l #14675972,a0
    15d4:	|      move.l (a0),d0
    15d6:	|      move.l d0,4(sp)
		vpos&=0x1ff00;
    15da:	|      move.l 4(sp),d0
    15de:	|      andi.l #130816,d0
    15e4:	|      move.l d0,4(sp)
		if (vpos==(311<<8))
    15e8:	|      move.l 4(sp),d0
    15ec:	|      cmpi.l #79616,d0
    15f2:	|  /-- beq.s 15f6 <WaitVbl+0x4e>
	while (1) {
    15f4:	\--|-- bra.s 15ce <WaitVbl+0x26>
			break;
    15f6:	   \-> nop
	}
	debug_stop_idle();
    15f8:	       jsr 29de <debug_stop_idle>
}
    15fe:	       nop
    1600:	       addq.l #8,sp
    1602:	       rts

00001604 <p61Init>:
	// The Player® 6.1A: Copyright © 1992-95 Jarno Paananen
	// P61.testmod - Module by Skylord/Sector 7 
	INCBIN(player, "player610.6.no_cia.bin")
	INCBIN_CHIP(module, "testmod.p61")

	int p61Init(const void* module) { // returns 0 if success, non-zero otherwise
    1604:	move.l a3,-(sp)
    1606:	move.l a2,-(sp)
		register volatile const void* _a0 ASM("a0") = module;
    1608:	movea.l 12(sp),a0
		register volatile const void* _a1 ASM("a1") = NULL;
    160c:	suba.l a1,a1
		register volatile const void* _a2 ASM("a2") = NULL;
    160e:	suba.l a2,a2
		register volatile const void* _a3 ASM("a3") = player;
    1610:	move.l 600a <player>,d0
    1616:	movea.l d0,a3
		register                int   _d0 ASM("d0"); // return value
		__asm volatile (
    1618:	movem.l d1-d7/a4-a6,-(sp)
    161c:	jsr (a3)
    161e:	movem.l (sp)+,d1-d7/a4-a6
			"movem.l (%%sp)+,%%d1-%%d7/%%a4-%%a6"
		: "=r" (_d0), "+rf"(_a0), "+rf"(_a1), "+rf"(_a2), "+rf"(_a3)
		:
		: "cc", "memory");
		return _d0;
	}
    1622:	movea.l (sp)+,a2
    1624:	movea.l (sp)+,a3
    1626:	rts

00001628 <p61End>:
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}

	void p61End() {
    1628:	move.l a6,-(sp)
    162a:	move.l a3,-(sp)
		register volatile const void* _a3 ASM("a3") = player;
    162c:	move.l 600a <player>,d0
    1632:	movea.l d0,a3
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
    1634:	movea.l #14675968,a6
		__asm volatile (
    163a:	movem.l d0-d1/a0-a1,-(sp)
    163e:	jsr 8(a3)
    1642:	movem.l (sp)+,d0-d1/a0-a1
			"jsr 8(%%a3)\n"
			"movem.l (%%sp)+,%%d0-%%d1/%%a0-%%a1"
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}
    1646:	nop
    1648:	movea.l (sp)+,a3
    164a:	movea.l (sp)+,a6
    164c:	rts

0000164e <main>:
static void Wait10() { WaitLine(0x10); }
static void Wait11() { WaitLine(0x11); }
static void Wait12() { WaitLine(0x12); }
static void Wait13() { WaitLine(0x13); }

int main(int argc, char *argv[]) {
    164e:	    lea -64(sp),sp
    1652:	    movem.l d2-d3/a6,-(sp)
	SysBase = *((struct ExecBase**)4UL);
    1656:	    movea.w #4,a0
    165a:	    move.l (a0),d0
    165c:	    move.l d0,7552 <SysBase>
	custom = (struct Custom*)0xdff000;
    1662:	    move.l #14675968,7556 <custom>

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR)"graphics.library",0);
    166c:	    move.l #18647,72(sp)
    1674:	    clr.l 68(sp)
    1678:	    move.l 7552 <SysBase>,d0
    167e:	    movea.l d0,a6
    1680:	    movea.l 72(sp),a1
    1684:	    move.l 68(sp),d0
    1688:	    jsr -552(a6)
    168c:	    move.l d0,64(sp)
    1690:	    move.l 64(sp),d0
    1694:	    move.l d0,755e <GfxBase>
	if (!GfxBase)
    169a:	    move.l 755e <GfxBase>,d0
    16a0:	/-- bne.s 16b6 <main+0x68>
		Exit(0);
    16a2:	|   clr.l 60(sp)
    16a6:	|   move.l 755a <DOSBase>,d0
    16ac:	|   movea.l d0,a6
    16ae:	|   move.l 60(sp),d1
    16b2:	|   jsr -144(a6)

	// used for printing
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
    16b6:	\-> move.l #18664,56(sp)
    16be:	    clr.l 52(sp)
    16c2:	    move.l 7552 <SysBase>,d0
    16c8:	    movea.l d0,a6
    16ca:	    movea.l 56(sp),a1
    16ce:	    move.l 52(sp),d0
    16d2:	    jsr -552(a6)
    16d6:	    move.l d0,48(sp)
    16da:	    move.l 48(sp),d0
    16de:	    move.l d0,755a <DOSBase>
	if (!DOSBase)
    16e4:	    move.l 755a <DOSBase>,d0
    16ea:	/-- bne.s 1700 <main+0xb2>
		Exit(0);
    16ec:	|   clr.l 44(sp)
    16f0:	|   move.l 755a <DOSBase>,d0
    16f6:	|   movea.l d0,a6
    16f8:	|   move.l 44(sp),d1
    16fc:	|   jsr -144(a6)

	KPrintF("Hello debugger from Amiga!\n");
    1700:	\-> pea 48f4 <incbin_player_end+0x1e>
    1706:	    jsr 27ec <KPrintF>
    170c:	    addq.l #4,sp

	Write(Output(), (APTR)"Hello console!\n", 15);
    170e:	    move.l 755a <DOSBase>,d0
    1714:	    movea.l d0,a6
    1716:	    jsr -60(a6)
    171a:	    move.l d0,40(sp)
    171e:	    move.l 40(sp),d0
    1722:	    move.l d0,36(sp)
    1726:	    move.l #18704,32(sp)
    172e:	    moveq #15,d0
    1730:	    move.l d0,28(sp)
    1734:	    move.l 755a <DOSBase>,d0
    173a:	    movea.l d0,a6
    173c:	    move.l 36(sp),d1
    1740:	    move.l 32(sp),d2
    1744:	    move.l 28(sp),d3
    1748:	    jsr -48(a6)
    174c:	    move.l d0,24(sp)
	Delay(50);
    1750:	    moveq #50,d0
    1752:	    move.l d0,20(sp)
    1756:	    move.l 755a <DOSBase>,d0
    175c:	    movea.l d0,a6
    175e:	    move.l 20(sp),d1
    1762:	    jsr -198(a6)

	warpmode(1);
    1766:	    pea 1 <_start+0x1>
    176a:	    jsr 2856 <warpmode>
    1770:	    addq.l #4,sp
	// TODO: precalc stuff here
#ifdef MUSIC
	if(p61Init(module) != 0)
    1772:	    move.l 600e <module>,d0
    1778:	    move.l d0,-(sp)
    177a:	    jsr 1604 <p61Init>
    1780:	    addq.l #4,sp
    1782:	    tst.l d0
    1784:	/-- beq.s 1794 <main+0x146>
		KPrintF("p61Init failed!\n");
    1786:	|   pea 4920 <incbin_player_end+0x4a>
    178c:	|   jsr 27ec <KPrintF>
    1792:	|   addq.l #4,sp
#endif
	warpmode(0);
    1794:	\-> clr.l -(sp)
    1796:	    jsr 2856 <warpmode>
    179c:	    addq.l #4,sp

	//TakeSystem();
	custom->dmacon = 0x87ff;
    179e:	    movea.l 7556 <custom>,a0
    17a4:	    move.w #-30721,150(a0)
	WaitVbl();
    17aa:	    jsr 15a8 <WaitVbl>

	main_sludge(argc, argv);
    17b0:	    move.l 84(sp),-(sp)
    17b4:	    move.l 84(sp),-(sp)
    17b8:	    jsr d12 <main_sludge>
    17be:	    addq.l #8,sp
	debug_register_copperlist(copper2, "copper2", sizeof(copper2), 0);*/



#ifdef MUSIC
	p61End();
    17c0:	    jsr 1628 <p61End>
#endif

	// END
	//FreeSystem();

	CloseLibrary((struct Library*)DOSBase);
    17c6:	    move.l 755a <DOSBase>,16(sp)
    17ce:	    move.l 7552 <SysBase>,d0
    17d4:	    movea.l d0,a6
    17d6:	    movea.l 16(sp),a1
    17da:	    jsr -414(a6)
	CloseLibrary((struct Library*)GfxBase);
    17de:	    move.l 755e <GfxBase>,12(sp)
    17e6:	    move.l 7552 <SysBase>,d0
    17ec:	    movea.l d0,a6
    17ee:	    movea.l 12(sp),a1
    17f2:	    jsr -414(a6)
    17f6:	    moveq #0,d0
}
    17f8:	    movem.l (sp)+,d2-d3/a6
    17fc:	    lea 64(sp),sp
    1800:	    rts

00001802 <positionStatus>:

struct statusStuff mainStatus;
struct statusStuff * nowStatus = & mainStatus;

void positionStatus (int x, int y) {
	nowStatus -> statusX = x;
    1802:	movea.l 6012 <nowStatus>,a0
    1808:	move.l 4(sp),10(a0)
	nowStatus -> statusY = y;
    180e:	movea.l 6012 <nowStatus>,a0
    1814:	move.l 8(sp),14(a0)
    181a:	nop
    181c:	rts

0000181e <initPeople>:
struct screenRegion personRegion;

extern struct screenRegion * allScreenRegions;

BOOL initPeople () {
	personRegion.sX = 0;
    181e:	clr.l 759c <personRegion+0x10>
	personRegion.sY = 0;
    1824:	clr.l 75a0 <personRegion+0x14>
	personRegion.di = -1;
    182a:	moveq #-1,d0
    182c:	move.l d0,75a4 <personRegion+0x18>
	allScreenRegions = NULL;
    1832:	clr.l 749a <allScreenRegions>

	return TRUE;
    1838:	moveq #1,d0
}
    183a:	rts

0000183c <makeNullAnim>:

struct personaAnimation * makeNullAnim () {
    183c:	       lea -16(sp),sp
    1840:	       move.l a6,-(sp)

	struct personaAnimation * newAnim	= AllocVec(sizeof(struct personaAnimation),MEMF_ANY);
    1842:	       moveq #12,d0
    1844:	       move.l d0,16(sp)
    1848:	       clr.l 12(sp)
    184c:	       move.l 7552 <SysBase>,d0
    1852:	       movea.l d0,a6
    1854:	       move.l 16(sp),d0
    1858:	       move.l 12(sp),d1
    185c:	       jsr -684(a6)
    1860:	       move.l d0,8(sp)
    1864:	       move.l 8(sp),d0
    1868:	       move.l d0,4(sp)
    if(newAnim == 0) {
    186c:	   /-- bne.s 1880 <makeNullAnim+0x44>
     	KPrintF("makeNullAnim: Can't reserve Memory\n");
    186e:	   |   pea 4931 <incbin_player_end+0x5b>
    1874:	   |   jsr 27ec <KPrintF>
    187a:	   |   addq.l #4,sp
        return NULL;    
    187c:	   |   moveq #0,d0
    187e:	/--|-- bra.s 189a <makeNullAnim+0x5e>
    }  

	newAnim -> theSprites		= NULL;
    1880:	|  \-> movea.l 4(sp),a0
    1884:	|      clr.l (a0)
	newAnim -> numFrames		= 0;
    1886:	|      movea.l 4(sp),a0
    188a:	|      clr.l 8(a0)
	newAnim -> frames			= NULL;
    188e:	|      movea.l 4(sp),a0
    1892:	|      clr.l 4(a0)
	return newAnim;
    1896:	|      move.l 4(sp),d0
}
    189a:	\----> movea.l (sp)+,a6
    189c:	       lea 16(sp),sp
    18a0:	       rts

000018a2 <killBackDrop>:
struct parallaxLayer * parallaxStuff = NULL;
extern int cameraX, cameraY;
extern float cameraZoom;

void killBackDrop () {
	deleteTextures (1, &backdropTextureName);
    18a2:	pea 75b8 <backdropTextureName>
    18a8:	pea 1 <_start+0x1>
    18ac:	jsr 140 <deleteTextures>
    18b2:	addq.l #8,sp
	backdropTextureName = 0;
    18b4:	clr.l 75b8 <backdropTextureName>
	backdropExists = FALSE;
    18ba:	clr.w 75bc <backdropExists>
}
    18c0:	nop
    18c2:	rts

000018c4 <killParallax>:

void killParallax () {
    18c4:	          lea -12(sp),sp
    18c8:	          move.l a6,-(sp)
	while (parallaxStuff) {
    18ca:	   /----- bra.s 1936 <killParallax+0x72>

		struct parallaxLayer * k = parallaxStuff;
    18cc:	/--|----> move.l 75be <parallaxStuff>,12(sp)
		parallaxStuff = k->next;
    18d4:	|  |      movea.l 12(sp),a0
    18d8:	|  |      move.l 42(a0),d0
    18dc:	|  |      move.l d0,75be <parallaxStuff>

		// Now kill the image
		deleteTextures (1, &k->textureName);
    18e2:	|  |      move.l 12(sp),d0
    18e6:	|  |      addq.l #4,d0
    18e8:	|  |      move.l d0,-(sp)
    18ea:	|  |      pea 1 <_start+0x1>
    18ee:	|  |      jsr 140 <deleteTextures>
    18f4:	|  |      addq.l #8,sp
		if( k->texture) FreeVec(k->texture);
    18f6:	|  |      movea.l 12(sp),a0
    18fa:	|  |      move.l (a0),d0
    18fc:	|  |  /-- beq.s 1916 <killParallax+0x52>
    18fe:	|  |  |   movea.l 12(sp),a0
    1902:	|  |  |   move.l (a0),8(sp)
    1906:	|  |  |   move.l 7552 <SysBase>,d0
    190c:	|  |  |   movea.l d0,a6
    190e:	|  |  |   movea.l 8(sp),a1
    1912:	|  |  |   jsr -690(a6)
		if( k) FreeVec(k);
    1916:	|  |  \-> tst.l 12(sp)
    191a:	|  |  /-- beq.s 1932 <killParallax+0x6e>
    191c:	|  |  |   move.l 12(sp),4(sp)
    1922:	|  |  |   move.l 7552 <SysBase>,d0
    1928:	|  |  |   movea.l d0,a6
    192a:	|  |  |   movea.l 4(sp),a1
    192e:	|  |  |   jsr -690(a6)
		k = NULL;
    1932:	|  |  \-> clr.l 12(sp)
	while (parallaxStuff) {
    1936:	|  \----> move.l 75be <parallaxStuff>,d0
    193c:	\-------- bne.s 18cc <killParallax+0x8>
	}
}
    193e:	          nop
    1940:	          nop
    1942:	          movea.l (sp)+,a6
    1944:	          lea 12(sp),sp
    1948:	          rts

0000194a <resizeBackdrop>:

BOOL resizeBackdrop (int x, int y) {
    killBackDrop ();
    194a:	jsr 18a2 <killBackDrop>
	killParallax ();
    1950:	jsr 18c4 <killParallax>
	killZBuffer ();
    1956:	jsr 1188 <killZBuffer>
	sceneWidth = x;
    195c:	move.l 4(sp),d0
    1960:	move.l d0,75b0 <sceneWidth>
	sceneHeight = y;
    1966:	move.l 8(sp),d0
    196a:	move.l d0,75b4 <sceneHeight>
	return TRUE;
    1970:	moveq #1,d0
    1972:	rts

00001974 <encodeFilename>:
#include "support/gcc8_c_support.h"
#include "moreio.h"

BOOL allowAnyFilename = TRUE;

char * encodeFilename (char * nameIn) {
    1974:	                      lea -24(sp),sp
    1978:	                      move.l a6,-(sp)
	if (! nameIn) return NULL;
    197a:	                      tst.l 32(sp)
    197e:	                  /-- bne.s 1986 <encodeFilename+0x12>
    1980:	                  |   moveq #0,d0
    1982:	/-----------------|-- bra.w 1cfe <encodeFilename+0x38a>
	if (allowAnyFilename) {
    1986:	|                 \-> move.w 6016 <allowAnyFilename>,d0
    198c:	|  /----------------- beq.w 1cba <encodeFilename+0x346>
		char * newName = AllocVec( strlen(nameIn)*2+1,MEMF_ANY);
    1990:	|  |                  move.l 32(sp),-(sp)
    1994:	|  |                  jsr 265e <strlen>
    199a:	|  |                  addq.l #4,sp
    199c:	|  |                  add.l d0,d0
    199e:	|  |                  move.l d0,d1
    19a0:	|  |                  addq.l #1,d1
    19a2:	|  |                  move.l d1,16(sp)
    19a6:	|  |                  clr.l 12(sp)
    19aa:	|  |                  move.l 7552 <SysBase>,d0
    19b0:	|  |                  movea.l d0,a6
    19b2:	|  |                  move.l 16(sp),d0
    19b6:	|  |                  move.l 12(sp),d1
    19ba:	|  |                  jsr -684(a6)
    19be:	|  |                  move.l d0,8(sp)
    19c2:	|  |                  move.l 8(sp),d0
    19c6:	|  |                  move.l d0,4(sp)
		if(newName == 0) {
    19ca:	|  |              /-- bne.s 19e0 <encodeFilename+0x6c>
			KPrintF( "encodefilename: Could not allocate Memory");
    19cc:	|  |              |   pea 4955 <incbin_player_end+0x7f>
    19d2:	|  |              |   jsr 27ec <KPrintF>
    19d8:	|  |              |   addq.l #4,sp
			return NULL;
    19da:	|  |              |   moveq #0,d0
    19dc:	+--|--------------|-- bra.w 1cfe <encodeFilename+0x38a>
		}

		int i = 0;
    19e0:	|  |              \-> clr.l 24(sp)
		while (*nameIn) {
    19e4:	|  |     /----------- bra.w 1caa <encodeFilename+0x336>
			switch (*nameIn) {
    19e8:	|  |  /--|----------> movea.l 32(sp),a0
    19ec:	|  |  |  |            move.b (a0),d0
    19ee:	|  |  |  |            ext.w d0
    19f0:	|  |  |  |            movea.w d0,a0
    19f2:	|  |  |  |            moveq #95,d0
    19f4:	|  |  |  |            cmp.l a0,d0
    19f6:	|  |  |  |        /-- blt.w 1a9a <encodeFilename+0x126>
    19fa:	|  |  |  |        |   moveq #34,d1
    19fc:	|  |  |  |        |   cmp.l a0,d1
    19fe:	|  |  |  |  /-----|-- bgt.w 1c7e <encodeFilename+0x30a>
    1a02:	|  |  |  |  |     |   moveq #-34,d0
    1a04:	|  |  |  |  |     |   add.l a0,d0
    1a06:	|  |  |  |  |     |   moveq #61,d1
    1a08:	|  |  |  |  |     |   cmp.l d0,d1
    1a0a:	|  |  |  |  +-----|-- bcs.w 1c7e <encodeFilename+0x30a>
    1a0e:	|  |  |  |  |     |   add.l d0,d0
    1a10:	|  |  |  |  |     |   movea.l d0,a0
    1a12:	|  |  |  |  |     |   adda.l #6686,a0
    1a18:	|  |  |  |  |     |   move.w (a0),d0
    1a1a:	|  |  |  |  |     |   jmp (1a1e <encodeFilename+0xaa>,pc,d0.w)
    1a1e:	|  |  |  |  |     |   bchg d0,d6
    1a20:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a24:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a28:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a2c:	|  |  |  |  |     |   andi.w #516,-(a0)
    1a30:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a34:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a38:	|  |  |  |  |     |   bclr d0,-(a6)
    1a3a:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a3e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a42:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a46:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a4a:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a4e:	|  |  |  |  |     |   bset d0,(a6)
    1a50:	|  |  |  |  |     |   andi.w #134,-(a0)
    1a54:	|  |  |  |  |     |   andi.w #182,-(a0)
    1a58:	|  |  |  |  |     |   andi.b #96,(96,a2,d0.w:2)
    1a5e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a62:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a66:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a6a:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a6e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a72:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a76:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a7a:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a7e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a82:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a86:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a8a:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a8e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1a92:	|  |  |  |  |     |   bchg d0,(96,a6,d0.w:2)
    1a96:	|  |  |  |  |     |   andi.w #278,-(a0)
    1a9a:	|  |  |  |  |     \-> moveq #124,d0
    1a9c:	|  |  |  |  |         cmp.l a0,d0
    1a9e:	|  |  |  |  |     /-- beq.s 1b04 <encodeFilename+0x190>
    1aa0:	|  |  |  |  +-----|-- bra.w 1c7e <encodeFilename+0x30a>
				case '<':	newName[i++] = '_';		newName[i++] = 'L';		break;
    1aa4:	|  |  |  |  |     |   move.l 24(sp),d0
    1aa8:	|  |  |  |  |     |   move.l d0,d1
    1aaa:	|  |  |  |  |     |   addq.l #1,d1
    1aac:	|  |  |  |  |     |   move.l d1,24(sp)
    1ab0:	|  |  |  |  |     |   movea.l 4(sp),a0
    1ab4:	|  |  |  |  |     |   adda.l d0,a0
    1ab6:	|  |  |  |  |     |   move.b #95,(a0)
    1aba:	|  |  |  |  |     |   move.l 24(sp),d0
    1abe:	|  |  |  |  |     |   move.l d0,d1
    1ac0:	|  |  |  |  |     |   addq.l #1,d1
    1ac2:	|  |  |  |  |     |   move.l d1,24(sp)
    1ac6:	|  |  |  |  |     |   movea.l 4(sp),a0
    1aca:	|  |  |  |  |     |   adda.l d0,a0
    1acc:	|  |  |  |  |     |   move.b #76,(a0)
    1ad0:	|  |  |  |  |  /--|-- bra.w 1c9a <encodeFilename+0x326>
				case '>':	newName[i++] = '_';		newName[i++] = 'G';		break;
    1ad4:	|  |  |  |  |  |  |   move.l 24(sp),d0
    1ad8:	|  |  |  |  |  |  |   move.l d0,d1
    1ada:	|  |  |  |  |  |  |   addq.l #1,d1
    1adc:	|  |  |  |  |  |  |   move.l d1,24(sp)
    1ae0:	|  |  |  |  |  |  |   movea.l 4(sp),a0
    1ae4:	|  |  |  |  |  |  |   adda.l d0,a0
    1ae6:	|  |  |  |  |  |  |   move.b #95,(a0)
    1aea:	|  |  |  |  |  |  |   move.l 24(sp),d0
    1aee:	|  |  |  |  |  |  |   move.l d0,d1
    1af0:	|  |  |  |  |  |  |   addq.l #1,d1
    1af2:	|  |  |  |  |  |  |   move.l d1,24(sp)
    1af6:	|  |  |  |  |  |  |   movea.l 4(sp),a0
    1afa:	|  |  |  |  |  |  |   adda.l d0,a0
    1afc:	|  |  |  |  |  |  |   move.b #71,(a0)
    1b00:	|  |  |  |  |  +--|-- bra.w 1c9a <encodeFilename+0x326>
				case '|':	newName[i++] = '_';		newName[i++] = 'P';		break;
    1b04:	|  |  |  |  |  |  \-> move.l 24(sp),d0
    1b08:	|  |  |  |  |  |      move.l d0,d1
    1b0a:	|  |  |  |  |  |      addq.l #1,d1
    1b0c:	|  |  |  |  |  |      move.l d1,24(sp)
    1b10:	|  |  |  |  |  |      movea.l 4(sp),a0
    1b14:	|  |  |  |  |  |      adda.l d0,a0
    1b16:	|  |  |  |  |  |      move.b #95,(a0)
    1b1a:	|  |  |  |  |  |      move.l 24(sp),d0
    1b1e:	|  |  |  |  |  |      move.l d0,d1
    1b20:	|  |  |  |  |  |      addq.l #1,d1
    1b22:	|  |  |  |  |  |      move.l d1,24(sp)
    1b26:	|  |  |  |  |  |      movea.l 4(sp),a0
    1b2a:	|  |  |  |  |  |      adda.l d0,a0
    1b2c:	|  |  |  |  |  |      move.b #80,(a0)
    1b30:	|  |  |  |  |  +----- bra.w 1c9a <encodeFilename+0x326>
				case '_':	newName[i++] = '_';		newName[i++] = 'U';		break;
    1b34:	|  |  |  |  |  |      move.l 24(sp),d0
    1b38:	|  |  |  |  |  |      move.l d0,d1
    1b3a:	|  |  |  |  |  |      addq.l #1,d1
    1b3c:	|  |  |  |  |  |      move.l d1,24(sp)
    1b40:	|  |  |  |  |  |      movea.l 4(sp),a0
    1b44:	|  |  |  |  |  |      adda.l d0,a0
    1b46:	|  |  |  |  |  |      move.b #95,(a0)
    1b4a:	|  |  |  |  |  |      move.l 24(sp),d0
    1b4e:	|  |  |  |  |  |      move.l d0,d1
    1b50:	|  |  |  |  |  |      addq.l #1,d1
    1b52:	|  |  |  |  |  |      move.l d1,24(sp)
    1b56:	|  |  |  |  |  |      movea.l 4(sp),a0
    1b5a:	|  |  |  |  |  |      adda.l d0,a0
    1b5c:	|  |  |  |  |  |      move.b #85,(a0)
    1b60:	|  |  |  |  |  +----- bra.w 1c9a <encodeFilename+0x326>
				case '\"':	newName[i++] = '_';		newName[i++] = 'S';		break;
    1b64:	|  |  |  |  |  |      move.l 24(sp),d0
    1b68:	|  |  |  |  |  |      move.l d0,d1
    1b6a:	|  |  |  |  |  |      addq.l #1,d1
    1b6c:	|  |  |  |  |  |      move.l d1,24(sp)
    1b70:	|  |  |  |  |  |      movea.l 4(sp),a0
    1b74:	|  |  |  |  |  |      adda.l d0,a0
    1b76:	|  |  |  |  |  |      move.b #95,(a0)
    1b7a:	|  |  |  |  |  |      move.l 24(sp),d0
    1b7e:	|  |  |  |  |  |      move.l d0,d1
    1b80:	|  |  |  |  |  |      addq.l #1,d1
    1b82:	|  |  |  |  |  |      move.l d1,24(sp)
    1b86:	|  |  |  |  |  |      movea.l 4(sp),a0
    1b8a:	|  |  |  |  |  |      adda.l d0,a0
    1b8c:	|  |  |  |  |  |      move.b #83,(a0)
    1b90:	|  |  |  |  |  +----- bra.w 1c9a <encodeFilename+0x326>
				case '\\':	newName[i++] = '_';		newName[i++] = 'B';		break;
    1b94:	|  |  |  |  |  |      move.l 24(sp),d0
    1b98:	|  |  |  |  |  |      move.l d0,d1
    1b9a:	|  |  |  |  |  |      addq.l #1,d1
    1b9c:	|  |  |  |  |  |      move.l d1,24(sp)
    1ba0:	|  |  |  |  |  |      movea.l 4(sp),a0
    1ba4:	|  |  |  |  |  |      adda.l d0,a0
    1ba6:	|  |  |  |  |  |      move.b #95,(a0)
    1baa:	|  |  |  |  |  |      move.l 24(sp),d0
    1bae:	|  |  |  |  |  |      move.l d0,d1
    1bb0:	|  |  |  |  |  |      addq.l #1,d1
    1bb2:	|  |  |  |  |  |      move.l d1,24(sp)
    1bb6:	|  |  |  |  |  |      movea.l 4(sp),a0
    1bba:	|  |  |  |  |  |      adda.l d0,a0
    1bbc:	|  |  |  |  |  |      move.b #66,(a0)
    1bc0:	|  |  |  |  |  +----- bra.w 1c9a <encodeFilename+0x326>
				case '/':	newName[i++] = '_';		newName[i++] = 'F';		break;
    1bc4:	|  |  |  |  |  |      move.l 24(sp),d0
    1bc8:	|  |  |  |  |  |      move.l d0,d1
    1bca:	|  |  |  |  |  |      addq.l #1,d1
    1bcc:	|  |  |  |  |  |      move.l d1,24(sp)
    1bd0:	|  |  |  |  |  |      movea.l 4(sp),a0
    1bd4:	|  |  |  |  |  |      adda.l d0,a0
    1bd6:	|  |  |  |  |  |      move.b #95,(a0)
    1bda:	|  |  |  |  |  |      move.l 24(sp),d0
    1bde:	|  |  |  |  |  |      move.l d0,d1
    1be0:	|  |  |  |  |  |      addq.l #1,d1
    1be2:	|  |  |  |  |  |      move.l d1,24(sp)
    1be6:	|  |  |  |  |  |      movea.l 4(sp),a0
    1bea:	|  |  |  |  |  |      adda.l d0,a0
    1bec:	|  |  |  |  |  |      move.b #70,(a0)
    1bf0:	|  |  |  |  |  +----- bra.w 1c9a <encodeFilename+0x326>
				case ':':	newName[i++] = '_';		newName[i++] = 'C';		break;
    1bf4:	|  |  |  |  |  |      move.l 24(sp),d0
    1bf8:	|  |  |  |  |  |      move.l d0,d1
    1bfa:	|  |  |  |  |  |      addq.l #1,d1
    1bfc:	|  |  |  |  |  |      move.l d1,24(sp)
    1c00:	|  |  |  |  |  |      movea.l 4(sp),a0
    1c04:	|  |  |  |  |  |      adda.l d0,a0
    1c06:	|  |  |  |  |  |      move.b #95,(a0)
    1c0a:	|  |  |  |  |  |      move.l 24(sp),d0
    1c0e:	|  |  |  |  |  |      move.l d0,d1
    1c10:	|  |  |  |  |  |      addq.l #1,d1
    1c12:	|  |  |  |  |  |      move.l d1,24(sp)
    1c16:	|  |  |  |  |  |      movea.l 4(sp),a0
    1c1a:	|  |  |  |  |  |      adda.l d0,a0
    1c1c:	|  |  |  |  |  |      move.b #67,(a0)
    1c20:	|  |  |  |  |  +----- bra.s 1c9a <encodeFilename+0x326>
				case '*':	newName[i++] = '_';		newName[i++] = 'A';		break;
    1c22:	|  |  |  |  |  |      move.l 24(sp),d0
    1c26:	|  |  |  |  |  |      move.l d0,d1
    1c28:	|  |  |  |  |  |      addq.l #1,d1
    1c2a:	|  |  |  |  |  |      move.l d1,24(sp)
    1c2e:	|  |  |  |  |  |      movea.l 4(sp),a0
    1c32:	|  |  |  |  |  |      adda.l d0,a0
    1c34:	|  |  |  |  |  |      move.b #95,(a0)
    1c38:	|  |  |  |  |  |      move.l 24(sp),d0
    1c3c:	|  |  |  |  |  |      move.l d0,d1
    1c3e:	|  |  |  |  |  |      addq.l #1,d1
    1c40:	|  |  |  |  |  |      move.l d1,24(sp)
    1c44:	|  |  |  |  |  |      movea.l 4(sp),a0
    1c48:	|  |  |  |  |  |      adda.l d0,a0
    1c4a:	|  |  |  |  |  |      move.b #65,(a0)
    1c4e:	|  |  |  |  |  +----- bra.s 1c9a <encodeFilename+0x326>
				case '?':	newName[i++] = '_';		newName[i++] = 'Q';		break;
    1c50:	|  |  |  |  |  |      move.l 24(sp),d0
    1c54:	|  |  |  |  |  |      move.l d0,d1
    1c56:	|  |  |  |  |  |      addq.l #1,d1
    1c58:	|  |  |  |  |  |      move.l d1,24(sp)
    1c5c:	|  |  |  |  |  |      movea.l 4(sp),a0
    1c60:	|  |  |  |  |  |      adda.l d0,a0
    1c62:	|  |  |  |  |  |      move.b #95,(a0)
    1c66:	|  |  |  |  |  |      move.l 24(sp),d0
    1c6a:	|  |  |  |  |  |      move.l d0,d1
    1c6c:	|  |  |  |  |  |      addq.l #1,d1
    1c6e:	|  |  |  |  |  |      move.l d1,24(sp)
    1c72:	|  |  |  |  |  |      movea.l 4(sp),a0
    1c76:	|  |  |  |  |  |      adda.l d0,a0
    1c78:	|  |  |  |  |  |      move.b #81,(a0)
    1c7c:	|  |  |  |  |  +----- bra.s 1c9a <encodeFilename+0x326>

				default:	newName[i++] = *nameIn;							break;
    1c7e:	|  |  |  |  \--|----> move.l 24(sp),d0
    1c82:	|  |  |  |     |      move.l d0,d1
    1c84:	|  |  |  |     |      addq.l #1,d1
    1c86:	|  |  |  |     |      move.l d1,24(sp)
    1c8a:	|  |  |  |     |      movea.l 4(sp),a0
    1c8e:	|  |  |  |     |      adda.l d0,a0
    1c90:	|  |  |  |     |      movea.l 32(sp),a1
    1c94:	|  |  |  |     |      move.b (a1),d0
    1c96:	|  |  |  |     |      move.b d0,(a0)
    1c98:	|  |  |  |     |      nop
			}
			newName[i] = 0;
    1c9a:	|  |  |  |     \----> move.l 24(sp),d0
    1c9e:	|  |  |  |            movea.l 4(sp),a0
    1ca2:	|  |  |  |            adda.l d0,a0
    1ca4:	|  |  |  |            clr.b (a0)
			nameIn ++;
    1ca6:	|  |  |  |            addq.l #1,32(sp)
		while (*nameIn) {
    1caa:	|  |  |  \----------> movea.l 32(sp),a0
    1cae:	|  |  |               move.b (a0),d0
    1cb0:	|  |  \-------------- bne.w 19e8 <encodeFilename+0x74>
		}
		return newName;
    1cb4:	|  |                  move.l 4(sp),d0
    1cb8:	+--|----------------- bra.s 1cfe <encodeFilename+0x38a>
	} else {
		int a;
		for (a = 0; nameIn[a]; a ++) {
    1cba:	|  \----------------> clr.l 20(sp)
    1cbe:	|              /----- bra.s 1ce4 <encodeFilename+0x370>
			if (nameIn[a] == '\\') nameIn[a] ='/';
    1cc0:	|           /--|----> move.l 20(sp),d0
    1cc4:	|           |  |      movea.l 32(sp),a0
    1cc8:	|           |  |      adda.l d0,a0
    1cca:	|           |  |      move.b (a0),d0
    1ccc:	|           |  |      cmpi.b #92,d0
    1cd0:	|           |  |  /-- bne.s 1ce0 <encodeFilename+0x36c>
    1cd2:	|           |  |  |   move.l 20(sp),d0
    1cd6:	|           |  |  |   movea.l 32(sp),a0
    1cda:	|           |  |  |   adda.l d0,a0
    1cdc:	|           |  |  |   move.b #47,(a0)
		for (a = 0; nameIn[a]; a ++) {
    1ce0:	|           |  |  \-> addq.l #1,20(sp)
    1ce4:	|           |  \----> move.l 20(sp),d0
    1ce8:	|           |         movea.l 32(sp),a0
    1cec:	|           |         adda.l d0,a0
    1cee:	|           |         move.b (a0),d0
    1cf0:	|           \-------- bne.s 1cc0 <encodeFilename+0x34c>
		}

		return copyString (nameIn);
    1cf2:	|                     move.l 32(sp),-(sp)
    1cf6:	|                     jsr 269e <copyString>
    1cfc:	|                     addq.l #4,sp
	}
}
    1cfe:	\-------------------> movea.l (sp)+,a6
    1d00:	                      lea 24(sp),sp
    1d04:	                      rts

00001d06 <floatSwap>:

float floatSwap( float f )
{
    1d06:	subq.l #8,sp
	{
		float f;
		unsigned char b[4];
	} dat1, dat2;

	dat1.f = f;
    1d08:	move.l 12(sp),4(sp)
	dat2.b[0] = dat1.b[3];
    1d0e:	move.b 7(sp),d0
    1d12:	move.b d0,(sp)
	dat2.b[1] = dat1.b[2];
    1d14:	move.b 6(sp),d0
    1d18:	move.b d0,1(sp)
	dat2.b[2] = dat1.b[1];
    1d1c:	move.b 5(sp),d0
    1d20:	move.b d0,2(sp)
	dat2.b[3] = dat1.b[0];
    1d24:	move.b 4(sp),d0
    1d28:	move.b d0,3(sp)
	return dat2.f;
    1d2c:	move.l (sp),d0
}
    1d2e:	addq.l #8,sp
    1d30:	rts

00001d32 <get2bytes>:

int get2bytes (BPTR fp) {
    1d32:	lea -24(sp),sp
    1d36:	move.l a6,-(sp)
	int f1, f2;

	f1 = FGetC (fp);
    1d38:	move.l 32(sp),24(sp)
    1d3e:	move.l 755a <DOSBase>,d0
    1d44:	movea.l d0,a6
    1d46:	move.l 24(sp),d1
    1d4a:	jsr -306(a6)
    1d4e:	move.l d0,20(sp)
    1d52:	move.l 20(sp),d0
    1d56:	move.l d0,16(sp)
	f2 = FGetC (fp);
    1d5a:	move.l 32(sp),12(sp)
    1d60:	move.l 755a <DOSBase>,d0
    1d66:	movea.l d0,a6
    1d68:	move.l 12(sp),d1
    1d6c:	jsr -306(a6)
    1d70:	move.l d0,8(sp)
    1d74:	move.l 8(sp),d0
    1d78:	move.l d0,4(sp)

	return (f1 * 256 + f2);
    1d7c:	move.l 16(sp),d0
    1d80:	lsl.l #8,d0
    1d82:	add.l 4(sp),d0
}
    1d86:	movea.l (sp)+,a6
    1d88:	lea 24(sp),sp
    1d8c:	rts

00001d8e <get4bytes>:

ULONG get4bytes (BPTR fp) {
    1d8e:	lea -52(sp),sp
    1d92:	move.l a6,-(sp)
	int f1, f2, f3, f4;

	f1 = FGetC (fp);
    1d94:	move.l 60(sp),52(sp)
    1d9a:	move.l 755a <DOSBase>,d0
    1da0:	movea.l d0,a6
    1da2:	move.l 52(sp),d1
    1da6:	jsr -306(a6)
    1daa:	move.l d0,48(sp)
    1dae:	move.l 48(sp),d0
    1db2:	move.l d0,44(sp)
	f2 = FGetC (fp);
    1db6:	move.l 60(sp),40(sp)
    1dbc:	move.l 755a <DOSBase>,d0
    1dc2:	movea.l d0,a6
    1dc4:	move.l 40(sp),d1
    1dc8:	jsr -306(a6)
    1dcc:	move.l d0,36(sp)
    1dd0:	move.l 36(sp),d0
    1dd4:	move.l d0,32(sp)
	f3 = FGetC (fp);
    1dd8:	move.l 60(sp),28(sp)
    1dde:	move.l 755a <DOSBase>,d0
    1de4:	movea.l d0,a6
    1de6:	move.l 28(sp),d1
    1dea:	jsr -306(a6)
    1dee:	move.l d0,24(sp)
    1df2:	move.l 24(sp),d0
    1df6:	move.l d0,20(sp)
	f4 = FGetC (fp);
    1dfa:	move.l 60(sp),16(sp)
    1e00:	move.l 755a <DOSBase>,d0
    1e06:	movea.l d0,a6
    1e08:	move.l 16(sp),d1
    1e0c:	jsr -306(a6)
    1e10:	move.l d0,12(sp)
    1e14:	move.l 12(sp),d0
    1e18:	move.l d0,8(sp)

	ULONG x = f1 + f2*256 + f3*256*256 + f4*256*256*256;
    1e1c:	move.l 32(sp),d0
    1e20:	lsl.l #8,d0
    1e22:	move.l d0,d1
    1e24:	add.l 44(sp),d1
    1e28:	move.l 20(sp),d0
    1e2c:	swap d0
    1e2e:	clr.w d0
    1e30:	add.l d0,d1
    1e32:	move.l 8(sp),d0
    1e36:	lsl.w #8,d0
    1e38:	swap d0
    1e3a:	clr.w d0
    1e3c:	add.l d1,d0
    1e3e:	move.l d0,4(sp)

	return x;
    1e42:	move.l 4(sp),d0
}
    1e46:	movea.l (sp)+,a6
    1e48:	lea 52(sp),sp
    1e4c:	rts

00001e4e <getFloat>:

float getFloat (BPTR fp) {
    1e4e:	    lea -28(sp),sp
    1e52:	    movem.l d2-d4/a6,-(sp)
	float f;
	LONG blocks_read = FRead( fp, &f, sizeof (float), 1 ); 
    1e56:	    move.l 48(sp),40(sp)
    1e5c:	    lea 44(sp),a0
    1e60:	    lea -28(a0),a0
    1e64:	    move.l a0,36(sp)
    1e68:	    moveq #4,d0
    1e6a:	    move.l d0,32(sp)
    1e6e:	    moveq #1,d0
    1e70:	    move.l d0,28(sp)
    1e74:	    move.l 755a <DOSBase>,d0
    1e7a:	    movea.l d0,a6
    1e7c:	    move.l 40(sp),d1
    1e80:	    move.l 36(sp),d2
    1e84:	    move.l 32(sp),d3
    1e88:	    move.l 28(sp),d4
    1e8c:	    jsr -324(a6)
    1e90:	    move.l d0,24(sp)
    1e94:	    move.l 24(sp),d0
    1e98:	    move.l d0,20(sp)
	if (blocks_read != 1) {
    1e9c:	    moveq #1,d0
    1e9e:	    cmp.l 20(sp),d0
    1ea2:	/-- beq.s 1eb2 <getFloat+0x64>
		KPrintF("Reading error in getFloat.\n");
    1ea4:	|   pea 497f <incbin_player_end+0xa9>
    1eaa:	|   jsr 27ec <KPrintF>
    1eb0:	|   addq.l #4,sp
	}
	return floatSwap(f);
    1eb2:	\-> move.l 16(sp),d0
    1eb6:	    move.l d0,-(sp)
    1eb8:	    jsr 1d06 <floatSwap>
    1ebe:	    addq.l #4,sp
	return f;
}
    1ec0:	    movem.l (sp)+,d2-d4/a6
    1ec4:	    lea 28(sp),sp
    1ec8:	    rts

00001eca <readString>:

char * readString (BPTR fp) {
    1eca:	          lea -32(sp),sp
    1ece:	          move.l a6,-(sp)

	int a, len = get2bytes (fp);
    1ed0:	          move.l 40(sp),-(sp)
    1ed4:	          jsr 1d32 <get2bytes>
    1eda:	          addq.l #4,sp
    1edc:	          move.l d0,28(sp)
	//debugOut ("MOREIO: readString - len %i\n", len);
	char * s = AllocVec(len+1,MEMF_ANY);
    1ee0:	          move.l 28(sp),d0
    1ee4:	          addq.l #1,d0
    1ee6:	          move.l d0,24(sp)
    1eea:	          clr.l 20(sp)
    1eee:	          move.l 7552 <SysBase>,d0
    1ef4:	          movea.l d0,a6
    1ef6:	          move.l 24(sp),d0
    1efa:	          move.l 20(sp),d1
    1efe:	          jsr -684(a6)
    1f02:	          move.l d0,16(sp)
    1f06:	          move.l 16(sp),d0
    1f0a:	          move.l d0,12(sp)
	if(s == 0) return NULL;
    1f0e:	      /-- bne.s 1f14 <readString+0x4a>
    1f10:	      |   moveq #0,d0
    1f12:	/-----|-- bra.s 1f6a <readString+0xa0>
	for (a = 0; a < len; a ++) {
    1f14:	|     \-> clr.l 32(sp)
    1f18:	|     /-- bra.s 1f50 <readString+0x86>
		s[a] = (char) (FGetC (fp) - 1);
    1f1a:	|  /--|-> move.l 40(sp),8(sp)
    1f20:	|  |  |   move.l 755a <DOSBase>,d0
    1f26:	|  |  |   movea.l d0,a6
    1f28:	|  |  |   move.l 8(sp),d1
    1f2c:	|  |  |   jsr -306(a6)
    1f30:	|  |  |   move.l d0,4(sp)
    1f34:	|  |  |   move.l 4(sp),d0
    1f38:	|  |  |   move.l d0,d0
    1f3a:	|  |  |   move.b d0,d1
    1f3c:	|  |  |   subq.b #1,d1
    1f3e:	|  |  |   move.l 32(sp),d0
    1f42:	|  |  |   movea.l 12(sp),a0
    1f46:	|  |  |   adda.l d0,a0
    1f48:	|  |  |   move.b d1,d0
    1f4a:	|  |  |   move.b d0,(a0)
	for (a = 0; a < len; a ++) {
    1f4c:	|  |  |   addq.l #1,32(sp)
    1f50:	|  |  \-> move.l 32(sp),d0
    1f54:	|  |      cmp.l 28(sp),d0
    1f58:	|  \----- blt.s 1f1a <readString+0x50>
	}
	s[len] = 0;
    1f5a:	|         move.l 28(sp),d0
    1f5e:	|         movea.l 12(sp),a0
    1f62:	|         adda.l d0,a0
    1f64:	|         clr.b (a0)
	//debugOut ("MOREIO: readString: %s\n", s);
	return s;
    1f66:	|         move.l 12(sp),d0
    1f6a:	\-------> movea.l (sp)+,a6
    1f6c:	          lea 32(sp),sp
    1f70:	          rts

00001f72 <initObjectTypes>:
#include <proto/exec.h>

#include "objtypes.h"

BOOL initObjectTypes () {
	return TRUE;
    1f72:	moveq #1,d0
    1f74:	rts

00001f76 <getLanguageForFileB>:
int *languageTable;
char **languageName;
struct settingsStruct gameSettings;

int getLanguageForFileB ()
{
    1f76:	          subq.l #8,sp
	int indexNum = -1;
    1f78:	          moveq #-1,d0
    1f7a:	          move.l d0,4(sp)

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    1f7e:	          clr.l (sp)
    1f80:	   /----- bra.s 1fa6 <getLanguageForFileB+0x30>
		if (languageTable[i] == gameSettings.languageID) indexNum = i;
    1f82:	/--|----> move.l 75c2 <languageTable>,d1
    1f88:	|  |      move.l (sp),d0
    1f8a:	|  |      add.l d0,d0
    1f8c:	|  |      add.l d0,d0
    1f8e:	|  |      movea.l d1,a0
    1f90:	|  |      adda.l d0,a0
    1f92:	|  |      move.l (a0),d0
    1f94:	|  |      move.l d0,d1
    1f96:	|  |      move.l 75ca <gameSettings>,d0
    1f9c:	|  |      cmp.l d1,d0
    1f9e:	|  |  /-- bne.s 1fa4 <getLanguageForFileB+0x2e>
    1fa0:	|  |  |   move.l (sp),4(sp)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    1fa4:	|  |  \-> addq.l #1,(sp)
    1fa6:	|  \----> move.l 75ce <gameSettings+0x4>,d0
    1fac:	|         cmp.l (sp),d0
    1fae:	\-------- bcc.s 1f82 <getLanguageForFileB+0xc>
	}

	return indexNum;
    1fb0:	          move.l 4(sp),d0
}
    1fb4:	          addq.l #8,sp
    1fb6:	          rts

00001fb8 <getPrefsFilename>:

char * getPrefsFilename (char * filename) {
    1fb8:	          lea -20(sp),sp
    1fbc:	          move.l a6,-(sp)
	// Yes, this trashes the original string, but
	// we also free it at the end (warning!)...

	int n, i;

	n = strlen (filename);
    1fbe:	          move.l 28(sp),-(sp)
    1fc2:	          jsr 265e <strlen>
    1fc8:	          addq.l #4,sp
    1fca:	          move.l d0,12(sp)


	if (n > 4 && filename[n-4] == '.') {
    1fce:	          moveq #4,d0
    1fd0:	          cmp.l 12(sp),d0
    1fd4:	      /-- bge.s 1ff8 <getPrefsFilename+0x40>
    1fd6:	      |   move.l 12(sp),d0
    1fda:	      |   subq.l #4,d0
    1fdc:	      |   movea.l 28(sp),a0
    1fe0:	      |   adda.l d0,a0
    1fe2:	      |   move.b (a0),d0
    1fe4:	      |   cmpi.b #46,d0
    1fe8:	      +-- bne.s 1ff8 <getPrefsFilename+0x40>
		filename[n-4] = 0;
    1fea:	      |   move.l 12(sp),d0
    1fee:	      |   subq.l #4,d0
    1ff0:	      |   movea.l 28(sp),a0
    1ff4:	      |   adda.l d0,a0
    1ff6:	      |   clr.b (a0)
	}

	char * f = filename;
    1ff8:	      \-> move.l 28(sp),16(sp)
	for (i = 0; i<n; i++) {
    1ffe:	          clr.l 20(sp)
    2002:	   /----- bra.s 202a <getPrefsFilename+0x72>
		if (filename[i] == '/') f = filename + i + 1;
    2004:	/--|----> move.l 20(sp),d0
    2008:	|  |      movea.l 28(sp),a0
    200c:	|  |      adda.l d0,a0
    200e:	|  |      move.b (a0),d0
    2010:	|  |      cmpi.b #47,d0
    2014:	|  |  /-- bne.s 2026 <getPrefsFilename+0x6e>
    2016:	|  |  |   move.l 20(sp),d0
    201a:	|  |  |   addq.l #1,d0
    201c:	|  |  |   move.l 28(sp),d1
    2020:	|  |  |   add.l d0,d1
    2022:	|  |  |   move.l d1,16(sp)
	for (i = 0; i<n; i++) {
    2026:	|  |  \-> addq.l #1,20(sp)
    202a:	|  \----> move.l 20(sp),d0
    202e:	|         cmp.l 12(sp),d0
    2032:	\-------- blt.s 2004 <getPrefsFilename+0x4c>
	}

	char * joined = joinStrings (f, ".ini");
    2034:	          pea 499b <incbin_player_end+0xc5>
    203a:	          move.l 20(sp),-(sp)
    203e:	          jsr 270c <joinStrings>
    2044:	          addq.l #8,sp
    2046:	          move.l d0,8(sp)

	FreeVec(filename);
    204a:	          move.l 28(sp),4(sp)
    2050:	          move.l 7552 <SysBase>,d0
    2056:	          movea.l d0,a6
    2058:	          movea.l 4(sp),a1
    205c:	          jsr -690(a6)
	filename = NULL;
    2060:	          clr.l 28(sp)
	return joined;
    2064:	          move.l 8(sp),d0
}
    2068:	          movea.l (sp)+,a6
    206a:	          lea 20(sp),sp
    206e:	          rts

00002070 <makeLanguageTable>:

void makeLanguageTable (BPTR table)
{
    2070:	             lea -28(sp),sp
    2074:	             move.l a6,-(sp)
    2076:	             move.l a2,-(sp)
	languageTable = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    2078:	             move.l 75ce <gameSettings+0x4>,d0
    207e:	             move.l d0,d1
    2080:	             addq.l #1,d1
    2082:	             move.l d1,28(sp)
    2086:	             clr.l 24(sp)
    208a:	             move.l 7552 <SysBase>,d0
    2090:	             movea.l d0,a6
    2092:	             move.l 28(sp),d0
    2096:	             move.l 24(sp),d1
    209a:	             jsr -684(a6)
    209e:	             move.l d0,20(sp)
    20a2:	             move.l 20(sp),d0
    20a6:	             move.l d0,75c2 <languageTable>
    if( languageTable == 0) {
    20ac:	             move.l 75c2 <languageTable>,d0
    20b2:	         /-- bne.s 20c2 <makeLanguageTable+0x52>
        KPrintF("makeLanguageTable: Cannot Alloc Mem for languageTable");
    20b4:	         |   pea 49a0 <incbin_player_end+0xca>
    20ba:	         |   jsr 27ec <KPrintF>
    20c0:	         |   addq.l #4,sp
    }

	languageName = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    20c2:	         \-> move.l 75ce <gameSettings+0x4>,d0
    20c8:	             move.l d0,d1
    20ca:	             addq.l #1,d1
    20cc:	             move.l d1,16(sp)
    20d0:	             clr.l 12(sp)
    20d4:	             move.l 7552 <SysBase>,d0
    20da:	             movea.l d0,a6
    20dc:	             move.l 16(sp),d0
    20e0:	             move.l 12(sp),d1
    20e4:	             jsr -684(a6)
    20e8:	             move.l d0,8(sp)
    20ec:	             move.l 8(sp),d0
    20f0:	             move.l d0,75c6 <languageName>
	if( languageName == 0) {
    20f6:	             move.l 75c6 <languageName>,d0
    20fc:	         /-- bne.s 210c <makeLanguageTable+0x9c>
        KPrintF("makeLanguageName: Cannot Alloc Mem for languageName");
    20fe:	         |   pea 49d6 <incbin_player_end+0x100>
    2104:	         |   jsr 27ec <KPrintF>
    210a:	         |   addq.l #4,sp
    }

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    210c:	         \-> clr.l 32(sp)
    2110:	   /-------- bra.s 2188 <makeLanguageTable+0x118>
		languageTable[i] = i ? get2bytes (table) : 0;
    2112:	/--|-------> tst.l 32(sp)
    2116:	|  |  /----- beq.s 2126 <makeLanguageTable+0xb6>
    2118:	|  |  |      move.l 40(sp),-(sp)
    211c:	|  |  |      jsr 1d32 <get2bytes>
    2122:	|  |  |      addq.l #4,sp
    2124:	|  |  |  /-- bra.s 2128 <makeLanguageTable+0xb8>
    2126:	|  |  \--|-> moveq #0,d0
    2128:	|  |     \-> movea.l 75c2 <languageTable>,a0
    212e:	|  |         move.l 32(sp),d1
    2132:	|  |         add.l d1,d1
    2134:	|  |         add.l d1,d1
    2136:	|  |         adda.l d1,a0
    2138:	|  |         move.l d0,(a0)
		languageName[i] = 0;
    213a:	|  |         move.l 75c6 <languageName>,d1
    2140:	|  |         move.l 32(sp),d0
    2144:	|  |         add.l d0,d0
    2146:	|  |         add.l d0,d0
    2148:	|  |         movea.l d1,a0
    214a:	|  |         adda.l d0,a0
    214c:	|  |         clr.l (a0)
		if (gameVersion >= VERSION(2,0)) {
    214e:	|  |         move.l 74aa <gameVersion>,d0
    2154:	|  |         cmpi.l #511,d0
    215a:	|  |     /-- ble.s 2184 <makeLanguageTable+0x114>
			if (gameSettings.numLanguages)
    215c:	|  |     |   move.l 75ce <gameSettings+0x4>,d0
    2162:	|  |     +-- beq.s 2184 <makeLanguageTable+0x114>
				languageName[i] = readString (table);
    2164:	|  |     |   move.l 75c6 <languageName>,d1
    216a:	|  |     |   move.l 32(sp),d0
    216e:	|  |     |   add.l d0,d0
    2170:	|  |     |   add.l d0,d0
    2172:	|  |     |   movea.l d1,a2
    2174:	|  |     |   adda.l d0,a2
    2176:	|  |     |   move.l 40(sp),-(sp)
    217a:	|  |     |   jsr 1eca <readString>
    2180:	|  |     |   addq.l #4,sp
    2182:	|  |     |   move.l d0,(a2)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    2184:	|  |     \-> addq.l #1,32(sp)
    2188:	|  \-------> move.l 75ce <gameSettings+0x4>,d0
    218e:	|            cmp.l 32(sp),d0
    2192:	\----------- bcc.w 2112 <makeLanguageTable+0xa2>
		}
	}
}
    2196:	             nop
    2198:	             nop
    219a:	             movea.l (sp)+,a2
    219c:	             movea.l (sp)+,a6
    219e:	             lea 28(sp),sp
    21a2:	             rts

000021a4 <readIniFile>:

void readIniFile (char * filename) {
    21a4:	                      lea -564(sp),sp
    21a8:	                      move.l a6,-(sp)
    21aa:	                      move.l d2,-(sp)
	char * langName = getPrefsFilename (copyString (filename));
    21ac:	                      move.l 576(sp),-(sp)
    21b0:	                      jsr 269e <copyString>
    21b6:	                      addq.l #4,sp
    21b8:	                      move.l d0,-(sp)
    21ba:	                      jsr 1fb8 <getPrefsFilename>
    21c0:	                      addq.l #4,sp
    21c2:	                      move.l d0,562(sp)

	BPTR fp = Open(langName,MODE_OLDFILE);	
    21c6:	                      move.l 562(sp),558(sp)
    21cc:	                      move.l #1005,554(sp)
    21d4:	                      move.l 755a <DOSBase>,d0
    21da:	                      movea.l d0,a6
    21dc:	                      move.l 558(sp),d1
    21e0:	                      move.l 554(sp),d2
    21e4:	                      jsr -30(a6)
    21e8:	                      move.l d0,550(sp)
    21ec:	                      move.l 550(sp),d0
    21f0:	                      move.l d0,546(sp)

	gameSettings.languageID = 0;
    21f4:	                      clr.l 75ca <gameSettings>
	gameSettings.userFullScreen = TRUE; //Always fullscreen on AMIGA
    21fa:	                      move.w #1,75d2 <gameSettings+0x8>
	gameSettings.refreshRate = 0;
    2202:	                      clr.l 75d4 <gameSettings+0xa>
	gameSettings.antiAlias = 1;
    2208:	                      moveq #1,d0
    220a:	                      move.l d0,75d8 <gameSettings+0xe>
	gameSettings.fixedPixels = FALSE;
    2210:	                      clr.w 75dc <gameSettings+0x12>
	gameSettings.noStartWindow = FALSE;
    2216:	                      clr.w 75de <gameSettings+0x14>
	gameSettings.debugMode = FALSE;
    221c:	                      clr.w 75e0 <gameSettings+0x16>

	FreeVec(langName);
    2222:	                      move.l 562(sp),542(sp)
    2228:	                      move.l 7552 <SysBase>,d0
    222e:	                      movea.l d0,a6
    2230:	                      movea.l 542(sp),a1
    2234:	                      jsr -690(a6)
	langName = NULL;
    2238:	                      clr.l 562(sp)

	if (fp) {
    223c:	                      tst.l 546(sp)
    2240:	/-------------------- beq.w 251e <readIniFile+0x37a>
		char lineSoFar[257] = "";
    2244:	|                     move.l sp,d0
    2246:	|                     addi.l #265,d0
    224c:	|                     move.l #257,d1
    2252:	|                     move.l d1,-(sp)
    2254:	|                     clr.l -(sp)
    2256:	|                     move.l d0,-(sp)
    2258:	|                     jsr 27bc <memset>
    225e:	|                     lea 12(sp),sp
		char secondSoFar[257] = "";
    2262:	|                     move.l sp,d0
    2264:	|                     addq.l #8,d0
    2266:	|                     move.l #257,d1
    226c:	|                     move.l d1,-(sp)
    226e:	|                     clr.l -(sp)
    2270:	|                     move.l d0,-(sp)
    2272:	|                     jsr 27bc <memset>
    2278:	|                     lea 12(sp),sp
		unsigned char here = 0;
    227c:	|                     clr.b 571(sp)
		char readChar = ' ';
    2280:	|                     move.b #32,570(sp)
		BOOL keepGoing = TRUE;
    2286:	|                     move.w #1,568(sp)
		BOOL doingSecond = FALSE;
    228c:	|                     clr.w 566(sp)
		LONG tmp = 0;
    2290:	|                     clr.l 538(sp)

		do {

			tmp = FGetC (fp);
    2294:	|  /----------------> move.l 546(sp),534(sp)
    229a:	|  |                  move.l 755a <DOSBase>,d0
    22a0:	|  |                  movea.l d0,a6
    22a2:	|  |                  move.l 534(sp),d1
    22a6:	|  |                  jsr -306(a6)
    22aa:	|  |                  move.l d0,530(sp)
    22ae:	|  |                  move.l 530(sp),d0
    22b2:	|  |                  move.l d0,538(sp)
			if (tmp == - 1) {
    22b6:	|  |                  moveq #-1,d1
    22b8:	|  |                  cmp.l 538(sp),d1
    22bc:	|  |           /----- bne.s 22ca <readIniFile+0x126>
				readChar = '\n';
    22be:	|  |           |      move.b #10,570(sp)
				keepGoing = FALSE;
    22c4:	|  |           |      clr.w 568(sp)
    22c8:	|  |           |  /-- bra.s 22d0 <readIniFile+0x12c>
			} else {
				readChar = (char) tmp;
    22ca:	|  |           \--|-> move.b 541(sp),570(sp)
			}

			switch (readChar) {
    22d0:	|  |              \-> move.b 570(sp),d0
    22d4:	|  |                  ext.w d0
    22d6:	|  |                  movea.w d0,a0
    22d8:	|  |                  moveq #61,d0
    22da:	|  |                  cmp.l a0,d0
    22dc:	|  |     /----------- beq.w 2486 <readIniFile+0x2e2>
    22e0:	|  |     |            moveq #61,d1
    22e2:	|  |     |            cmp.l a0,d1
    22e4:	|  |  /--|----------- blt.w 2492 <readIniFile+0x2ee>
    22e8:	|  |  |  |            moveq #10,d0
    22ea:	|  |  |  |            cmp.l a0,d0
    22ec:	|  |  |  |        /-- beq.s 22f6 <readIniFile+0x152>
    22ee:	|  |  |  |        |   moveq #13,d1
    22f0:	|  |  |  |        |   cmp.l a0,d1
    22f2:	|  |  +--|--------|-- bne.w 2492 <readIniFile+0x2ee>
				case '\n':
				case '\r':
				if (doingSecond) {
    22f6:	|  |  |  |        \-> tst.w 566(sp)
    22fa:	|  |  |  |     /----- beq.w 2474 <readIniFile+0x2d0>
					if (strcmp (lineSoFar, "LANGUAGE") == 0)
    22fe:	|  |  |  |     |      pea 4a0a <incbin_player_end+0x134>
    2304:	|  |  |  |     |      move.l sp,d0
    2306:	|  |  |  |     |      addi.l #269,d0
    230c:	|  |  |  |     |      move.l d0,-(sp)
    230e:	|  |  |  |     |      jsr 261e <strcmp>
    2314:	|  |  |  |     |      addq.l #8,sp
    2316:	|  |  |  |     |      tst.l d0
    2318:	|  |  |  |     |  /-- bne.s 2332 <readIniFile+0x18e>
					{
						gameSettings.languageID = stringToInt (secondSoFar);
    231a:	|  |  |  |     |  |   move.l sp,d0
    231c:	|  |  |  |     |  |   addq.l #8,d0
    231e:	|  |  |  |     |  |   move.l d0,-(sp)
    2320:	|  |  |  |     |  |   jsr 252a <stringToInt>
    2326:	|  |  |  |     |  |   addq.l #4,sp
    2328:	|  |  |  |     |  |   move.l d0,75ca <gameSettings>
    232e:	|  |  |  |     +--|-- bra.w 2474 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "WINDOW") == 0)
    2332:	|  |  |  |     |  \-> pea 4a13 <incbin_player_end+0x13d>
    2338:	|  |  |  |     |      move.l sp,d0
    233a:	|  |  |  |     |      addi.l #269,d0
    2340:	|  |  |  |     |      move.l d0,-(sp)
    2342:	|  |  |  |     |      jsr 261e <strcmp>
    2348:	|  |  |  |     |      addq.l #8,sp
    234a:	|  |  |  |     |      tst.l d0
    234c:	|  |  |  |     |  /-- bne.s 2372 <readIniFile+0x1ce>
					{
						gameSettings.userFullScreen = ! stringToInt (secondSoFar);
    234e:	|  |  |  |     |  |   move.l sp,d0
    2350:	|  |  |  |     |  |   addq.l #8,d0
    2352:	|  |  |  |     |  |   move.l d0,-(sp)
    2354:	|  |  |  |     |  |   jsr 252a <stringToInt>
    235a:	|  |  |  |     |  |   addq.l #4,sp
    235c:	|  |  |  |     |  |   tst.l d0
    235e:	|  |  |  |     |  |   seq d0
    2360:	|  |  |  |     |  |   neg.b d0
    2362:	|  |  |  |     |  |   move.b d0,d0
    2364:	|  |  |  |     |  |   andi.w #255,d0
    2368:	|  |  |  |     |  |   move.w d0,75d2 <gameSettings+0x8>
    236e:	|  |  |  |     +--|-- bra.w 2474 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "REFRESH") == 0)
    2372:	|  |  |  |     |  \-> pea 4a1a <incbin_player_end+0x144>
    2378:	|  |  |  |     |      move.l sp,d0
    237a:	|  |  |  |     |      addi.l #269,d0
    2380:	|  |  |  |     |      move.l d0,-(sp)
    2382:	|  |  |  |     |      jsr 261e <strcmp>
    2388:	|  |  |  |     |      addq.l #8,sp
    238a:	|  |  |  |     |      tst.l d0
    238c:	|  |  |  |     |  /-- bne.s 23a6 <readIniFile+0x202>
					{
						gameSettings.refreshRate = stringToInt (secondSoFar);
    238e:	|  |  |  |     |  |   move.l sp,d0
    2390:	|  |  |  |     |  |   addq.l #8,d0
    2392:	|  |  |  |     |  |   move.l d0,-(sp)
    2394:	|  |  |  |     |  |   jsr 252a <stringToInt>
    239a:	|  |  |  |     |  |   addq.l #4,sp
    239c:	|  |  |  |     |  |   move.l d0,75d4 <gameSettings+0xa>
    23a2:	|  |  |  |     +--|-- bra.w 2474 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "ANTIALIAS") == 0)
    23a6:	|  |  |  |     |  \-> pea 4a22 <incbin_player_end+0x14c>
    23ac:	|  |  |  |     |      move.l sp,d0
    23ae:	|  |  |  |     |      addi.l #269,d0
    23b4:	|  |  |  |     |      move.l d0,-(sp)
    23b6:	|  |  |  |     |      jsr 261e <strcmp>
    23bc:	|  |  |  |     |      addq.l #8,sp
    23be:	|  |  |  |     |      tst.l d0
    23c0:	|  |  |  |     |  /-- bne.s 23da <readIniFile+0x236>
					{
						gameSettings.antiAlias = stringToInt (secondSoFar);
    23c2:	|  |  |  |     |  |   move.l sp,d0
    23c4:	|  |  |  |     |  |   addq.l #8,d0
    23c6:	|  |  |  |     |  |   move.l d0,-(sp)
    23c8:	|  |  |  |     |  |   jsr 252a <stringToInt>
    23ce:	|  |  |  |     |  |   addq.l #4,sp
    23d0:	|  |  |  |     |  |   move.l d0,75d8 <gameSettings+0xe>
    23d6:	|  |  |  |     +--|-- bra.w 2474 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "FIXEDPIXELS") == 0)
    23da:	|  |  |  |     |  \-> pea 4a2c <incbin_player_end+0x156>
    23e0:	|  |  |  |     |      move.l sp,d0
    23e2:	|  |  |  |     |      addi.l #269,d0
    23e8:	|  |  |  |     |      move.l d0,-(sp)
    23ea:	|  |  |  |     |      jsr 261e <strcmp>
    23f0:	|  |  |  |     |      addq.l #8,sp
    23f2:	|  |  |  |     |      tst.l d0
    23f4:	|  |  |  |     |  /-- bne.s 240e <readIniFile+0x26a>
					{
						gameSettings.fixedPixels = stringToInt (secondSoFar);
    23f6:	|  |  |  |     |  |   move.l sp,d0
    23f8:	|  |  |  |     |  |   addq.l #8,d0
    23fa:	|  |  |  |     |  |   move.l d0,-(sp)
    23fc:	|  |  |  |     |  |   jsr 252a <stringToInt>
    2402:	|  |  |  |     |  |   addq.l #4,sp
    2404:	|  |  |  |     |  |   move.l d0,d0
    2406:	|  |  |  |     |  |   move.w d0,75dc <gameSettings+0x12>
    240c:	|  |  |  |     +--|-- bra.s 2474 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "NOSTARTWINDOW") == 0)
    240e:	|  |  |  |     |  \-> pea 4a38 <incbin_player_end+0x162>
    2414:	|  |  |  |     |      move.l sp,d0
    2416:	|  |  |  |     |      addi.l #269,d0
    241c:	|  |  |  |     |      move.l d0,-(sp)
    241e:	|  |  |  |     |      jsr 261e <strcmp>
    2424:	|  |  |  |     |      addq.l #8,sp
    2426:	|  |  |  |     |      tst.l d0
    2428:	|  |  |  |     |  /-- bne.s 2442 <readIniFile+0x29e>
					{
						gameSettings.noStartWindow = stringToInt (secondSoFar);
    242a:	|  |  |  |     |  |   move.l sp,d0
    242c:	|  |  |  |     |  |   addq.l #8,d0
    242e:	|  |  |  |     |  |   move.l d0,-(sp)
    2430:	|  |  |  |     |  |   jsr 252a <stringToInt>
    2436:	|  |  |  |     |  |   addq.l #4,sp
    2438:	|  |  |  |     |  |   move.l d0,d0
    243a:	|  |  |  |     |  |   move.w d0,75de <gameSettings+0x14>
    2440:	|  |  |  |     +--|-- bra.s 2474 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "DEBUGMODE") == 0)
    2442:	|  |  |  |     |  \-> pea 4a46 <incbin_player_end+0x170>
    2448:	|  |  |  |     |      move.l sp,d0
    244a:	|  |  |  |     |      addi.l #269,d0
    2450:	|  |  |  |     |      move.l d0,-(sp)
    2452:	|  |  |  |     |      jsr 261e <strcmp>
    2458:	|  |  |  |     |      addq.l #8,sp
    245a:	|  |  |  |     |      tst.l d0
    245c:	|  |  |  |     +----- bne.s 2474 <readIniFile+0x2d0>
					{
						gameSettings.debugMode = stringToInt (secondSoFar);
    245e:	|  |  |  |     |      move.l sp,d0
    2460:	|  |  |  |     |      addq.l #8,d0
    2462:	|  |  |  |     |      move.l d0,-(sp)
    2464:	|  |  |  |     |      jsr 252a <stringToInt>
    246a:	|  |  |  |     |      addq.l #4,sp
    246c:	|  |  |  |     |      move.l d0,d0
    246e:	|  |  |  |     |      move.w d0,75e0 <gameSettings+0x16>
					}
				}
				here = 0;
    2474:	|  |  |  |     \----> clr.b 571(sp)
				doingSecond = FALSE;
    2478:	|  |  |  |            clr.w 566(sp)
				lineSoFar[0] = 0;
    247c:	|  |  |  |            clr.b 265(sp)
				secondSoFar[0] = 0;
    2480:	|  |  |  |            clr.b 8(sp)
				break;
    2484:	|  |  |  |  /-------- bra.s 24fc <readIniFile+0x358>

				case '=':
				doingSecond = TRUE;
    2486:	|  |  |  \--|-------> move.w #1,566(sp)
				here = 0;
    248c:	|  |  |     |         clr.b 571(sp)
				break;
    2490:	|  |  |     +-------- bra.s 24fc <readIniFile+0x358>

				default:
				if (doingSecond) {
    2492:	|  |  \-----|-------> tst.w 566(sp)
    2496:	|  |        |  /----- beq.s 24ca <readIniFile+0x326>
					secondSoFar[here ++] = readChar;
    2498:	|  |        |  |      move.b 571(sp),d0
    249c:	|  |        |  |      move.b d0,d1
    249e:	|  |        |  |      addq.b #1,d1
    24a0:	|  |        |  |      move.b d1,571(sp)
    24a4:	|  |        |  |      move.b d0,d0
    24a6:	|  |        |  |      andi.l #255,d0
    24ac:	|  |        |  |      lea 572(sp),a0
    24b0:	|  |        |  |      adda.l d0,a0
    24b2:	|  |        |  |      move.b 570(sp),-564(a0)
					secondSoFar[here] = 0;
    24b8:	|  |        |  |      moveq #0,d0
    24ba:	|  |        |  |      move.b 571(sp),d0
    24be:	|  |        |  |      lea 572(sp),a0
    24c2:	|  |        |  |      adda.l d0,a0
    24c4:	|  |        |  |      clr.b -564(a0)
				} else {
					lineSoFar[here ++] = readChar;
					lineSoFar[here] = 0;
				}
				break;
    24c8:	|  |        |  |  /-- bra.s 24fa <readIniFile+0x356>
					lineSoFar[here ++] = readChar;
    24ca:	|  |        |  \--|-> move.b 571(sp),d0
    24ce:	|  |        |     |   move.b d0,d1
    24d0:	|  |        |     |   addq.b #1,d1
    24d2:	|  |        |     |   move.b d1,571(sp)
    24d6:	|  |        |     |   move.b d0,d0
    24d8:	|  |        |     |   andi.l #255,d0
    24de:	|  |        |     |   lea 572(sp),a0
    24e2:	|  |        |     |   adda.l d0,a0
    24e4:	|  |        |     |   move.b 570(sp),-307(a0)
					lineSoFar[here] = 0;
    24ea:	|  |        |     |   moveq #0,d0
    24ec:	|  |        |     |   move.b 571(sp),d0
    24f0:	|  |        |     |   lea 572(sp),a0
    24f4:	|  |        |     |   adda.l d0,a0
    24f6:	|  |        |     |   clr.b -307(a0)
				break;
    24fa:	|  |        |     \-> nop
			}
		} while (keepGoing);
    24fc:	|  |        \-------> tst.w 568(sp)
    2500:	|  \----------------- bne.w 2294 <readIniFile+0xf0>

		Close(fp);
    2504:	|                     move.l 546(sp),526(sp)
    250a:	|                     move.l 755a <DOSBase>,d0
    2510:	|                     movea.l d0,a6
    2512:	|                     move.l 526(sp),d1
    2516:	|                     jsr -36(a6)
    251a:	|                     move.l d0,522(sp)
	}
}
    251e:	\-------------------> nop
    2520:	                      move.l (sp)+,d2
    2522:	                      movea.l (sp)+,a6
    2524:	                      lea 564(sp),sp
    2528:	                      rts

0000252a <stringToInt>:

unsigned int stringToInt (char * s) {
    252a:	             subq.l #8,sp
	int i = 0;
    252c:	             clr.l 4(sp)
	BOOL negative = FALSE;
    2530:	             clr.w 2(sp)
	for (;;) {
		if (*s >= '0' && *s <= '9') {
    2534:	/----------> movea.l 12(sp),a0
    2538:	|            move.b (a0),d0
    253a:	|            cmpi.b #47,d0
    253e:	|        /-- ble.s 2576 <stringToInt+0x4c>
    2540:	|        |   movea.l 12(sp),a0
    2544:	|        |   move.b (a0),d0
    2546:	|        |   cmpi.b #57,d0
    254a:	|        +-- bgt.s 2576 <stringToInt+0x4c>
			i *= 10;
    254c:	|        |   move.l 4(sp),d1
    2550:	|        |   move.l d1,d0
    2552:	|        |   add.l d0,d0
    2554:	|        |   add.l d0,d0
    2556:	|        |   add.l d1,d0
    2558:	|        |   add.l d0,d0
    255a:	|        |   move.l d0,4(sp)
			i += *s - '0';
    255e:	|        |   movea.l 12(sp),a0
    2562:	|        |   move.b (a0),d0
    2564:	|        |   ext.w d0
    2566:	|        |   movea.w d0,a0
    2568:	|        |   moveq #-48,d0
    256a:	|        |   add.l a0,d0
    256c:	|        |   add.l d0,4(sp)
			s ++;
    2570:	|        |   addq.l #1,12(sp)
    2574:	|  /-----|-- bra.s 25ae <stringToInt+0x84>
		} else if (*s == '-') {
    2576:	|  |     \-> movea.l 12(sp),a0
    257a:	|  |         move.b (a0),d0
    257c:	|  |         cmpi.b #45,d0
    2580:	|  |     /-- bne.s 259a <stringToInt+0x70>
			negative = ! negative;
    2582:	|  |     |   tst.w 2(sp)
    2586:	|  |     |   seq d0
    2588:	|  |     |   neg.b d0
    258a:	|  |     |   move.b d0,d0
    258c:	|  |     |   andi.w #255,d0
    2590:	|  |     |   move.w d0,2(sp)
			s++;
    2594:	|  |     |   addq.l #1,12(sp)
    2598:	+--|-----|-- bra.s 2534 <stringToInt+0xa>
		} else {
			if (negative)
    259a:	|  |     \-> tst.w 2(sp)
    259e:	|  |     /-- beq.s 25a8 <stringToInt+0x7e>
				return -i;
    25a0:	|  |     |   move.l 4(sp),d0
    25a4:	|  |     |   neg.l d0
    25a6:	|  |  /--|-- bra.s 25b0 <stringToInt+0x86>
			return i;
    25a8:	|  |  |  \-> move.l 4(sp),d0
    25ac:	|  |  +----- bra.s 25b0 <stringToInt+0x86>
		if (*s >= '0' && *s <= '9') {
    25ae:	\--\--|----X bra.s 2534 <stringToInt+0xa>
		}
	}
    25b0:	      \----> addq.l #8,sp
    25b2:	             rts

000025b4 <fileExists>:
 *  Helper functions that don't depend on other source files.
 */
#include <proto/dos.h>
#include "helpers.h"

BYTE fileExists(const char * file) {
    25b4:	    lea -28(sp),sp
    25b8:	    move.l a6,-(sp)
    25ba:	    move.l d2,-(sp)
	BPTR tester;
	BYTE retval = 0;
    25bc:	    clr.b 35(sp)
	tester = Open(file, MODE_OLDFILE);
    25c0:	    move.l 40(sp),30(sp)
    25c6:	    move.l #1005,26(sp)
    25ce:	    move.l 755a <DOSBase>,d0
    25d4:	    movea.l d0,a6
    25d6:	    move.l 30(sp),d1
    25da:	    move.l 26(sp),d2
    25de:	    jsr -30(a6)
    25e2:	    move.l d0,22(sp)
    25e6:	    move.l 22(sp),d0
    25ea:	    move.l d0,18(sp)
	if (tester) {
    25ee:	/-- beq.s 2610 <fileExists+0x5c>
		retval = 1;
    25f0:	|   move.b #1,35(sp)
		Close(tester);
    25f6:	|   move.l 18(sp),14(sp)
    25fc:	|   move.l 755a <DOSBase>,d0
    2602:	|   movea.l d0,a6
    2604:	|   move.l 14(sp),d1
    2608:	|   jsr -36(a6)
    260c:	|   move.l d0,10(sp)
	}
	return retval;
    2610:	\-> move.b 35(sp),d0
    2614:	    move.l (sp)+,d2
    2616:	    movea.l (sp)+,a6
    2618:	    lea 28(sp),sp
    261c:	    rts

0000261e <strcmp>:
#include "support/gcc8_c_support.h"


int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1 == *s2))
    261e:	   /-- bra.s 2628 <strcmp+0xa>
    {
        s1++;
    2620:	/--|-> addq.l #1,4(sp)
        s2++;
    2624:	|  |   addq.l #1,8(sp)
    while(*s1 && (*s1 == *s2))
    2628:	|  \-> movea.l 4(sp),a0
    262c:	|      move.b (a0),d0
    262e:	|  /-- beq.s 2640 <strcmp+0x22>
    2630:	|  |   movea.l 4(sp),a0
    2634:	|  |   move.b (a0),d1
    2636:	|  |   movea.l 8(sp),a0
    263a:	|  |   move.b (a0),d0
    263c:	|  |   cmp.b d1,d0
    263e:	\--|-- beq.s 2620 <strcmp+0x2>
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
    2640:	   \-> movea.l 4(sp),a0
    2644:	       move.b (a0),d0
    2646:	       moveq #0,d1
    2648:	       move.b d0,d1
    264a:	       movea.l 8(sp),a0
    264e:	       move.b (a0),d0
    2650:	       move.b d0,d0
    2652:	       andi.l #255,d0
    2658:	       sub.l d0,d1
    265a:	       move.l d1,d0
}
    265c:	       rts

0000265e <strlen>:

long unsigned int strlen (const char *s) 
{  
    265e:	       subq.l #4,sp
	long unsigned int i = 0;
    2660:	       clr.l (sp)
	while(s[i]) i++; 
    2662:	   /-- bra.s 2666 <strlen+0x8>
    2664:	/--|-> addq.l #1,(sp)
    2666:	|  \-> movea.l 8(sp),a0
    266a:	|      adda.l (sp),a0
    266c:	|      move.b (a0),d0
    266e:	\----- bne.s 2664 <strlen+0x6>
	return(i);
    2670:	       move.l (sp),d0
}
    2672:	       addq.l #4,sp
    2674:	       rts

00002676 <strcpy>:

char *strcpy(char *t, const char *s) 
{
	while(*t++ = *s++);
    2676:	    nop
    2678:	/-> move.l 8(sp),d0
    267c:	|   move.l d0,d1
    267e:	|   addq.l #1,d1
    2680:	|   move.l d1,8(sp)
    2684:	|   movea.l 4(sp),a0
    2688:	|   lea 1(a0),a1
    268c:	|   move.l a1,4(sp)
    2690:	|   movea.l d0,a1
    2692:	|   move.b (a1),d0
    2694:	|   move.b d0,(a0)
    2696:	|   move.b (a0),d0
    2698:	\-- bne.s 2678 <strcpy+0x2>
}
    269a:	    nop
    269c:	    rts

0000269e <copyString>:

char * copyString (const char * copyMe) {
    269e:	       lea -16(sp),sp
    26a2:	       move.l a6,-(sp)
	
	char * newString = AllocVec(strlen(copyMe)+1, MEMF_ANY); 
    26a4:	       move.l 24(sp),-(sp)
    26a8:	       jsr 265e <strlen>
    26ae:	       addq.l #4,sp
    26b0:	       move.l d0,d1
    26b2:	       addq.l #1,d1
    26b4:	       move.l d1,16(sp)
    26b8:	       clr.l 12(sp)
    26bc:	       move.l 7552 <SysBase>,d0
    26c2:	       movea.l d0,a6
    26c4:	       move.l 16(sp),d0
    26c8:	       move.l 12(sp),d1
    26cc:	       jsr -684(a6)
    26d0:	       move.l d0,8(sp)
    26d4:	       move.l 8(sp),d0
    26d8:	       move.l d0,4(sp)
	if(newString == 0) {
    26dc:	   /-- bne.s 26f0 <copyString+0x52>
		KPrintF("copystring: Can't reserve memory for newString\n");
    26de:	   |   pea 4a50 <incbin_player_end+0x17a>
    26e4:	   |   jsr 27ec <KPrintF>
    26ea:	   |   addq.l #4,sp
		return NULL;	
    26ec:	   |   moveq #0,d0
    26ee:	/--|-- bra.s 2704 <copyString+0x66>
	}
	strcpy (newString, copyMe);
    26f0:	|  \-> move.l 24(sp),-(sp)
    26f4:	|      move.l 8(sp),-(sp)
    26f8:	|      jsr 2676 <strcpy>
    26fe:	|      addq.l #8,sp
	return newString;
    2700:	|      move.l 4(sp),d0
}
    2704:	\----> movea.l (sp)+,a6
    2706:	       lea 16(sp),sp
    270a:	       rts

0000270c <joinStrings>:

char * joinStrings (const char * s1, const char * s2) {
    270c:	    lea -20(sp),sp
    2710:	    move.l a6,-(sp)
    2712:	    move.l d2,-(sp)
	char * newString = AllocVec(strlen (s1) + strlen (s2) + 1, MEMF_ANY); 
    2714:	    move.l 32(sp),-(sp)
    2718:	    jsr 265e <strlen>
    271e:	    addq.l #4,sp
    2720:	    move.l d0,d2
    2722:	    move.l 36(sp),-(sp)
    2726:	    jsr 265e <strlen>
    272c:	    addq.l #4,sp
    272e:	    add.l d2,d0
    2730:	    move.l d0,d1
    2732:	    addq.l #1,d1
    2734:	    move.l d1,20(sp)
    2738:	    clr.l 16(sp)
    273c:	    move.l 7552 <SysBase>,d0
    2742:	    movea.l d0,a6
    2744:	    move.l 20(sp),d0
    2748:	    move.l 16(sp),d1
    274c:	    jsr -684(a6)
    2750:	    move.l d0,12(sp)
    2754:	    move.l 12(sp),d0
    2758:	    move.l d0,8(sp)
	char * t = newString;
    275c:	    move.l 8(sp),24(sp)

	while(*t++ = *s1++);
    2762:	    nop
    2764:	/-> move.l 32(sp),d0
    2768:	|   move.l d0,d1
    276a:	|   addq.l #1,d1
    276c:	|   move.l d1,32(sp)
    2770:	|   movea.l 24(sp),a0
    2774:	|   lea 1(a0),a1
    2778:	|   move.l a1,24(sp)
    277c:	|   movea.l d0,a1
    277e:	|   move.b (a1),d0
    2780:	|   move.b d0,(a0)
    2782:	|   move.b (a0),d0
    2784:	\-- bne.s 2764 <joinStrings+0x58>
	t--;
    2786:	    subq.l #1,24(sp)
	while(*t++ = *s2++);
    278a:	    nop
    278c:	/-> move.l 36(sp),d0
    2790:	|   move.l d0,d1
    2792:	|   addq.l #1,d1
    2794:	|   move.l d1,36(sp)
    2798:	|   movea.l 24(sp),a0
    279c:	|   lea 1(a0),a1
    27a0:	|   move.l a1,24(sp)
    27a4:	|   movea.l d0,a1
    27a6:	|   move.b (a1),d0
    27a8:	|   move.b d0,(a0)
    27aa:	|   move.b (a0),d0
    27ac:	\-- bne.s 278c <joinStrings+0x80>

	return newString;
    27ae:	    move.l 8(sp),d0
}
    27b2:	    move.l (sp)+,d2
    27b4:	    movea.l (sp)+,a6
    27b6:	    lea 20(sp),sp
    27ba:	    rts

000027bc <memset>:
void* memset(void *dest, int val, unsigned long len) {
    27bc:	       subq.l #4,sp
	unsigned char *ptr = (unsigned char *)dest;
    27be:	       move.l 8(sp),(sp)
	while(len-- > 0)
    27c2:	   /-- bra.s 27d4 <memset+0x18>
		*ptr++ = val;
    27c4:	/--|-> move.l (sp),d0
    27c6:	|  |   move.l d0,d1
    27c8:	|  |   addq.l #1,d1
    27ca:	|  |   move.l d1,(sp)
    27cc:	|  |   move.l 12(sp),d1
    27d0:	|  |   movea.l d0,a0
    27d2:	|  |   move.b d1,(a0)
	while(len-- > 0)
    27d4:	|  \-> move.l 16(sp),d0
    27d8:	|      move.l d0,d1
    27da:	|      subq.l #1,d1
    27dc:	|      move.l d1,16(sp)
    27e0:	|      tst.l d0
    27e2:	\----- bne.s 27c4 <memset+0x8>
	return dest;
    27e4:	       move.l 8(sp),d0
}
    27e8:	       addq.l #4,sp
    27ea:	       rts

000027ec <KPrintF>:
void KPrintF(const char* fmt, ...) {
    27ec:	       lea -128(sp),sp
    27f0:	       movem.l a2-a3/a6,-(sp)
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    27f4:	       move.w f0ff60 <gcc8_c_support.c.af0a41ba+0xefe34d>,d0
    27fa:	       cmpi.w #20153,d0
    27fe:	   /-- beq.s 2822 <KPrintF+0x36>
    2800:	   |   cmpi.w #-24562,d0
    2804:	   +-- beq.s 2822 <KPrintF+0x36>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
    2806:	   |   movea.l 7552 <SysBase>,a6
    280c:	   |   movea.l 144(sp),a0
    2810:	   |   lea 148(sp),a1
    2814:	   |   lea 2a80 <KPutCharX>,a2
    281a:	   |   suba.l a3,a3
    281c:	   |   jsr -522(a6)
}
    2820:	/--|-- bra.s 284c <KPrintF+0x60>
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
    2822:	|  \-> movea.l 7552 <SysBase>,a6
    2828:	|      movea.l 144(sp),a0
    282c:	|      lea 148(sp),a1
    2830:	|      lea 2a8e <PutChar>,a2
    2836:	|      lea 12(sp),a3
    283a:	|      jsr -522(a6)
		UaeDbgLog(86, temp);
    283e:	|      move.l a3,-(sp)
    2840:	|      pea 56 <_start+0x56>
    2844:	|      jsr f0ff60 <gcc8_c_support.c.af0a41ba+0xefe34d>
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    284a:	|      addq.l #8,sp
}
    284c:	\----> movem.l (sp)+,a2-a3/a6
    2850:	       lea 128(sp),sp
    2854:	       rts

00002856 <warpmode>:

void warpmode(int on) { // bool
    2856:	          subq.l #8,sp
	long(*UaeConf)(long mode, int index, const char* param, int param_len, char* outbuf, int outbuf_len);
	UaeConf = (long(*)(long, int, const char*, int, char*, int))0xf0ff60;
    2858:	          move.l #15794016,4(sp)
	if(*((UWORD *)UaeConf) == 0x4eb9 || *((UWORD *)UaeConf) == 0xa00e) {
    2860:	          movea.l 4(sp),a0
    2864:	          move.w (a0),d0
    2866:	          cmpi.w #20153,d0
    286a:	      /-- beq.s 287a <warpmode+0x24>
    286c:	      |   movea.l 4(sp),a0
    2870:	      |   move.w (a0),d0
    2872:	      |   cmpi.w #-24562,d0
    2876:	/-----|-- bne.w 297e <warpmode+0x128>
		char outbuf;
		UaeConf(82, -1, on ? "cpu_speed max" : "cpu_speed real", 0, &outbuf, 1);
    287a:	|     \-> tst.l 12(sp)
    287e:	|  /----- beq.s 2888 <warpmode+0x32>
    2880:	|  |      move.l #19072,d0
    2886:	|  |  /-- bra.s 288e <warpmode+0x38>
    2888:	|  \--|-> move.l #19086,d0
    288e:	|     \-> pea 1 <_start+0x1>
    2892:	|         move.l sp,d1
    2894:	|         addq.l #7,d1
    2896:	|         move.l d1,-(sp)
    2898:	|         clr.l -(sp)
    289a:	|         move.l d0,-(sp)
    289c:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffee3ec>
    28a0:	|         pea 52 <_start+0x52>
    28a4:	|         movea.l 28(sp),a0
    28a8:	|         jsr (a0)
    28aa:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_cycle_exact false" : "cpu_cycle_exact true", 0, &outbuf, 1);
    28ae:	|         tst.l 12(sp)
    28b2:	|  /----- beq.s 28bc <warpmode+0x66>
    28b4:	|  |      move.l #19101,d0
    28ba:	|  |  /-- bra.s 28c2 <warpmode+0x6c>
    28bc:	|  \--|-> move.l #19123,d0
    28c2:	|     \-> pea 1 <_start+0x1>
    28c6:	|         move.l sp,d1
    28c8:	|         addq.l #7,d1
    28ca:	|         move.l d1,-(sp)
    28cc:	|         clr.l -(sp)
    28ce:	|         move.l d0,-(sp)
    28d0:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffee3ec>
    28d4:	|         pea 52 <_start+0x52>
    28d8:	|         movea.l 28(sp),a0
    28dc:	|         jsr (a0)
    28de:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_memory_cycle_exact false" : "cpu_memory_cycle_exact true", 0, &outbuf, 1);
    28e2:	|         tst.l 12(sp)
    28e6:	|  /----- beq.s 28f0 <warpmode+0x9a>
    28e8:	|  |      move.l #19144,d0
    28ee:	|  |  /-- bra.s 28f6 <warpmode+0xa0>
    28f0:	|  \--|-> move.l #19173,d0
    28f6:	|     \-> pea 1 <_start+0x1>
    28fa:	|         move.l sp,d1
    28fc:	|         addq.l #7,d1
    28fe:	|         move.l d1,-(sp)
    2900:	|         clr.l -(sp)
    2902:	|         move.l d0,-(sp)
    2904:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffee3ec>
    2908:	|         pea 52 <_start+0x52>
    290c:	|         movea.l 28(sp),a0
    2910:	|         jsr (a0)
    2912:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
    2916:	|         tst.l 12(sp)
    291a:	|  /----- beq.s 2924 <warpmode+0xce>
    291c:	|  |      move.l #19201,d0
    2922:	|  |  /-- bra.s 292a <warpmode+0xd4>
    2924:	|  \--|-> move.l #19227,d0
    292a:	|     \-> pea 1 <_start+0x1>
    292e:	|         move.l sp,d1
    2930:	|         addq.l #7,d1
    2932:	|         move.l d1,-(sp)
    2934:	|         clr.l -(sp)
    2936:	|         move.l d0,-(sp)
    2938:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffee3ec>
    293c:	|         pea 52 <_start+0x52>
    2940:	|         movea.l 28(sp),a0
    2944:	|         jsr (a0)
    2946:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
    294a:	|         tst.l 12(sp)
    294e:	|  /----- beq.s 2958 <warpmode+0x102>
    2950:	|  |      move.l #19252,d0
    2956:	|  |  /-- bra.s 295e <warpmode+0x108>
    2958:	|  \--|-> move.l #19262,d0
    295e:	|     \-> pea 1 <_start+0x1>
    2962:	|         move.l sp,d1
    2964:	|         addq.l #7,d1
    2966:	|         move.l d1,-(sp)
    2968:	|         clr.l -(sp)
    296a:	|         move.l d0,-(sp)
    296c:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffee3ec>
    2970:	|         pea 52 <_start+0x52>
    2974:	|         movea.l 28(sp),a0
    2978:	|         jsr (a0)
    297a:	|         lea 24(sp),sp
	}
}
    297e:	\-------> nop
    2980:	          addq.l #8,sp
    2982:	          rts

00002984 <debug_cmd>:

static void debug_cmd(unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4) {
    2984:	       subq.l #4,sp
	long(*UaeLib)(unsigned int arg0, unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4);
	UaeLib = (long(*)(unsigned int, unsigned int, unsigned int, unsigned int, unsigned int))0xf0ff60;
    2986:	       move.l #15794016,(sp)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
    298c:	       movea.l (sp),a0
    298e:	       move.w (a0),d0
    2990:	       cmpi.w #20153,d0
    2994:	   /-- beq.s 29a0 <debug_cmd+0x1c>
    2996:	   |   movea.l (sp),a0
    2998:	   |   move.w (a0),d0
    299a:	   |   cmpi.w #-24562,d0
    299e:	/--|-- bne.s 29be <debug_cmd+0x3a>
		UaeLib(88, arg1, arg2, arg3, arg4);
    29a0:	|  \-> move.l 20(sp),-(sp)
    29a4:	|      move.l 20(sp),-(sp)
    29a8:	|      move.l 20(sp),-(sp)
    29ac:	|      move.l 20(sp),-(sp)
    29b0:	|      pea 58 <_start+0x58>
    29b4:	|      movea.l 20(sp),a0
    29b8:	|      jsr (a0)
    29ba:	|      lea 20(sp),sp
	}
}
    29be:	\----> nop
    29c0:	       addq.l #4,sp
    29c2:	       rts

000029c4 <debug_start_idle>:
	debug_cmd(barto_cmd_text, (((unsigned int)left) << 16) | ((unsigned int)top), (unsigned int)text, color);
}

// profiler
void debug_start_idle() {
	debug_cmd(barto_cmd_set_idle, 1, 0, 0);
    29c4:	clr.l -(sp)
    29c6:	clr.l -(sp)
    29c8:	pea 1 <_start+0x1>
    29cc:	pea 5 <_start+0x5>
    29d0:	jsr 2984 <debug_cmd>
    29d6:	lea 16(sp),sp
}
    29da:	nop
    29dc:	rts

000029de <debug_stop_idle>:

void debug_stop_idle() {
	debug_cmd(barto_cmd_set_idle, 0, 0, 0);
    29de:	clr.l -(sp)
    29e0:	clr.l -(sp)
    29e2:	clr.l -(sp)
    29e4:	pea 5 <_start+0x5>
    29e8:	jsr 2984 <debug_cmd>
    29ee:	lea 16(sp),sp
}
    29f2:	nop
    29f4:	rts

000029f6 <__udivsi3>:
	.section .text.__udivsi3,"ax",@progbits
	.type __udivsi3, function
	.globl	__udivsi3
__udivsi3:
	.cfi_startproc
	movel	d2, sp@-
    29f6:	       move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
    29f8:	       move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
    29fc:	       move.l 8(sp),d0

	cmpl	#0x10000, d1 /* divisor >= 2 ^ 16 ?   */
    2a00:	       cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
    2a06:	   /-- bcc.s 2a1e <__udivsi3+0x28>
	movel	d0, d2
    2a08:	   |   move.l d0,d2
	clrw	d2
    2a0a:	   |   clr.w d2
	swap	d2
    2a0c:	   |   swap d2
	divu	d1, d2          /* high quotient in lower word */
    2a0e:	   |   divu.w d1,d2
	movew	d2, d0		/* save high quotient */
    2a10:	   |   move.w d2,d0
	swap	d0
    2a12:	   |   swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
    2a14:	   |   move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
    2a18:	   |   divu.w d1,d2
	movew	d2, d0
    2a1a:	   |   move.w d2,d0
	jra	6f
    2a1c:	/--|-- bra.s 2a4e <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
    2a1e:	|  \-> move.l d1,d2
4:	lsrl	#1, d1	/* shift divisor */
    2a20:	|  /-> lsr.l #1,d1
	lsrl	#1, d0	/* shift dividend */
    2a22:	|  |   lsr.l #1,d0
	cmpl	#0x10000, d1 /* still divisor >= 2 ^ 16 ?  */
    2a24:	|  |   cmpi.l #65536,d1
	jcc	4b
    2a2a:	|  \-- bcc.s 2a20 <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
    2a2c:	|      divu.w d1,d0
	andl	#0xffff, d0 /* mask out divisor, ignore remainder */
    2a2e:	|      andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
    2a34:	|      move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
    2a36:	|      mulu.w d0,d1
	swap	d2
    2a38:	|      swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
    2a3a:	|      mulu.w d0,d2
	swap	d2		/* align high part with low part */
    2a3c:	|      swap d2
	tstw	d2		/* high part 17 bits? */
    2a3e:	|      tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
    2a40:	|  /-- bne.s 2a4c <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
    2a42:	|  |   add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
    2a44:	|  +-- bcs.s 2a4c <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
    2a46:	|  |   cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
    2a4a:	+--|-- bls.s 2a4e <__udivsi3+0x58>
5:	subql	#1, d0	/* adjust quotient */
    2a4c:	|  \-> subq.l #1,d0

6:	movel	sp@+, d2
    2a4e:	\----> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    2a50:	       rts

00002a52 <__divsi3>:
	.section .text.__divsi3,"ax",@progbits
	.type __divsi3, function
	.globl	__divsi3
 __divsi3:
 	.cfi_startproc
	movel	d2, sp@-
    2a52:	    move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	#1, d2	/* sign of result stored in d2 (=1 or =-1) */
    2a54:	    moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
    2a56:	    move.l 12(sp),d1
	jpl	1f
    2a5a:	/-- bpl.s 2a60 <__divsi3+0xe>
	negl	d1
    2a5c:	|   neg.l d1
	negb	d2		/* change sign because divisor <0  */
    2a5e:	|   neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
    2a60:	\-> move.l 8(sp),d0
	jpl	2f
    2a64:	/-- bpl.s 2a6a <__divsi3+0x18>
	negl	d0
    2a66:	|   neg.l d0
	negb	d2
    2a68:	|   neg.b d2

2:	movel	d1, sp@-
    2a6a:	\-> move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    2a6c:	    move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__udivsi3	/* divide abs(dividend) by abs(divisor) */
    2a6e:	    jsr 29f6 <__udivsi3>
	addql	#8, sp
    2a74:	    addq.l #8,sp
	.cfi_adjust_cfa_offset -8

	tstb	d2
    2a76:	    tst.b d2
	jpl	3f
    2a78:	/-- bpl.s 2a7c <__divsi3+0x2a>
	negl	d0
    2a7a:	|   neg.l d0

3:	movel	sp@+, d2
    2a7c:	\-> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    2a7e:	    rts

00002a80 <KPutCharX>:
	.type KPutCharX, function
	.globl	KPutCharX

KPutCharX:
	.cfi_startproc
    move.l  a6, -(sp)
    2a80:	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
    2a82:	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
    2a86:	jsr -516(a6)
    move.l (sp)+, a6
    2a8a:	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
    2a8c:	rts

00002a8e <PutChar>:
	.type PutChar, function
	.globl	PutChar

PutChar:
	.cfi_startproc
	move.b d0, (a3)+
    2a8e:	move.b d0,(a3)+
	rts
    2a90:	rts
