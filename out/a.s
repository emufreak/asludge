
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
      72:	       jsr 1a48 <main>

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

000000b8 <deleteTextures>:
extern int specialSettings;
struct textureList *firstTexture = NULL;
BOOL NPOT_textures = TRUE;

void deleteTextures(unsigned int n,  unsigned int * textures)
{
      b8:	                      lea -24(sp),sp
      bc:	                      move.l a6,-(sp)
	if (firstTexture == NULL) {
      be:	                      move.l 74a2 <firstTexture>,d0
      c4:	/-------------------- beq.w 1a2 <deleteTextures+0xea>
		//debugOut("Deleting texture while list is already empty.\n");
	} else {
		for (unsigned int i = 0; i < n; i++) {
      c8:	|                     clr.l 24(sp)
      cc:	|     /-------------- bra.w 196 <deleteTextures+0xde>
			BOOL found = FALSE;
      d0:	|  /--|-------------> clr.w 18(sp)
			struct textureList *list = firstTexture;
      d4:	|  |  |               move.l 74a2 <firstTexture>,20(sp)
			if (list->name == textures[i]) {
      dc:	|  |  |               movea.l 20(sp),a0
      e0:	|  |  |               move.l (a0),d1
      e2:	|  |  |               move.l 24(sp),d0
      e6:	|  |  |               add.l d0,d0
      e8:	|  |  |               add.l d0,d0
      ea:	|  |  |               movea.l 36(sp),a0
      ee:	|  |  |               adda.l d0,a0
      f0:	|  |  |               move.l (a0),d0
      f2:	|  |  |               cmp.l d1,d0
      f4:	|  |  |  /----------- bne.w 188 <deleteTextures+0xd0>
				found = TRUE;
      f8:	|  |  |  |            move.w #1,18(sp)
				firstTexture = list->next;
      fe:	|  |  |  |            movea.l 20(sp),a0
     102:	|  |  |  |            move.l 12(a0),d0
     106:	|  |  |  |            move.l d0,74a2 <firstTexture>
				FreeVec(list);
     10c:	|  |  |  |            move.l 20(sp),6(sp)
     112:	|  |  |  |            move.l 755e <SysBase>,d0
     118:	|  |  |  |            movea.l d0,a6
     11a:	|  |  |  |            movea.l 6(sp),a1
     11e:	|  |  |  |            jsr -690(a6)
				continue;
     122:	|  |  |  |  /-------- bra.s 192 <deleteTextures+0xda>
			}

			while (list->next) {
				if (list->next->name == textures[i]) {
     124:	|  |  |  |  |  /----> movea.l 20(sp),a0
     128:	|  |  |  |  |  |      movea.l 12(a0),a0
     12c:	|  |  |  |  |  |      move.l (a0),d1
     12e:	|  |  |  |  |  |      move.l 24(sp),d0
     132:	|  |  |  |  |  |      add.l d0,d0
     134:	|  |  |  |  |  |      add.l d0,d0
     136:	|  |  |  |  |  |      movea.l 36(sp),a0
     13a:	|  |  |  |  |  |      adda.l d0,a0
     13c:	|  |  |  |  |  |      move.l (a0),d0
     13e:	|  |  |  |  |  |      cmp.l d1,d0
     140:	|  |  |  |  |  |  /-- bne.s 17e <deleteTextures+0xc6>
					found = TRUE;
     142:	|  |  |  |  |  |  |   move.w #1,18(sp)
					struct textureList *deleteMe = list->next;
     148:	|  |  |  |  |  |  |   movea.l 20(sp),a0
     14c:	|  |  |  |  |  |  |   move.l 12(a0),14(sp)
					list->next = list->next->next;
     152:	|  |  |  |  |  |  |   movea.l 20(sp),a0
     156:	|  |  |  |  |  |  |   movea.l 12(a0),a0
     15a:	|  |  |  |  |  |  |   move.l 12(a0),d0
     15e:	|  |  |  |  |  |  |   movea.l 20(sp),a0
     162:	|  |  |  |  |  |  |   move.l d0,12(a0)
					FreeVec(deleteMe);
     166:	|  |  |  |  |  |  |   move.l 14(sp),10(sp)
     16c:	|  |  |  |  |  |  |   move.l 755e <SysBase>,d0
     172:	|  |  |  |  |  |  |   movea.l d0,a6
     174:	|  |  |  |  |  |  |   movea.l 10(sp),a1
     178:	|  |  |  |  |  |  |   jsr -690(a6)
					break;
     17c:	|  |  |  |  +--|--|-- bra.s 192 <deleteTextures+0xda>
				}
				list = list->next;
     17e:	|  |  |  |  |  |  \-> movea.l 20(sp),a0
     182:	|  |  |  |  |  |      move.l 12(a0),20(sp)
			while (list->next) {
     188:	|  |  |  \--|--|----> movea.l 20(sp),a0
     18c:	|  |  |     |  |      move.l 12(a0),d0
     190:	|  |  |     |  \----- bne.s 124 <deleteTextures+0x6c>
		for (unsigned int i = 0; i < n; i++) {
     192:	|  |  |     \-------> addq.l #1,24(sp)
     196:	|  |  \-------------> move.l 24(sp),d0
     19a:	|  |                  cmp.l 32(sp),d0
     19e:	|  \----------------- bcs.w d0 <deleteTextures+0x18>
			}
		}
	}
     1a2:	\-------------------> nop
     1a4:	                      movea.l (sp)+,a6
     1a6:	                      lea 24(sp),sp
     1aa:	                      rts

000001ac <initSludge>:
struct variableStack * noStack = NULL;
struct variable * globalVars;
int numGlobals;
struct loadedFunction * allRunningFunctions = NULL;

BOOL initSludge (char * filename) {
     1ac:	             lea -296(sp),sp
     1b0:	             movem.l d2-d4/a2/a6,-(sp)
	int a = 0;
     1b4:	             clr.l 312(sp)
	mouseCursorAnim = makeNullAnim ();
     1b8:	             jsr 1ed0 <makeNullAnim>
     1be:	             move.l d0,7492 <mouseCursorAnim>

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, &gameVersion);
     1c4:	             pea 74a6 <gameVersion>
     1ca:	             pea 340e <PutChar+0x4>
     1d0:	             pea 45 <_start+0x45>
     1d4:	             pea 47 <_start+0x47>
     1d8:	             move.l 336(sp),-(sp)
     1dc:	             jsr b04 <openAndVerify>
     1e2:	             lea 20(sp),sp
     1e6:	             move.l d0,292(sp)
	if (! fp) return FALSE;
     1ea:	         /-- bne.s 1f2 <initSludge+0x46>
     1ec:	         |   clr.w d0
     1ee:	/--------|-- bra.w 910 <initSludge+0x764>
	if (FGetC (fp)) {
     1f2:	|        \-> move.l 292(sp),288(sp)
     1f8:	|            move.l 7566 <DOSBase>,d0
     1fe:	|            movea.l d0,a6
     200:	|            move.l 288(sp),d1
     204:	|            jsr -306(a6)
     208:	|            move.l d0,284(sp)
     20c:	|            move.l 284(sp),d0
     210:	|  /-------- beq.w 3b6 <initSludge+0x20a>
		numBIFNames = get2bytes (fp);
     214:	|  |         move.l 292(sp),-(sp)
     218:	|  |         jsr 23c6 <get2bytes>
     21e:	|  |         addq.l #4,sp
     220:	|  |         move.l d0,74ae <numBIFNames>
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
     226:	|  |         move.l 74ae <numBIFNames>,d0
     22c:	|  |         move.l d0,280(sp)
     230:	|  |         clr.l 276(sp)
     234:	|  |         move.l 755e <SysBase>,d0
     23a:	|  |         movea.l d0,a6
     23c:	|  |         move.l 280(sp),d0
     240:	|  |         move.l 276(sp),d1
     244:	|  |         jsr -684(a6)
     248:	|  |         move.l d0,272(sp)
     24c:	|  |         move.l 272(sp),d0
     250:	|  |         move.l d0,74b2 <allBIFNames>
		if(allBIFNames == 0) return FALSE;
     256:	|  |         move.l 74b2 <allBIFNames>,d0
     25c:	|  |     /-- bne.s 264 <initSludge+0xb8>
     25e:	|  |     |   clr.w d0
     260:	+--|-----|-- bra.w 910 <initSludge+0x764>
		for (int fn = 0; fn < numBIFNames; fn ++) {
     264:	|  |     \-> clr.l 308(sp)
     268:	|  |     /-- bra.s 28e <initSludge+0xe2>
			allBIFNames[fn] = (char *) readString (fp);
     26a:	|  |  /--|-> move.l 74b2 <allBIFNames>,d1
     270:	|  |  |  |   move.l 308(sp),d0
     274:	|  |  |  |   add.l d0,d0
     276:	|  |  |  |   add.l d0,d0
     278:	|  |  |  |   movea.l d1,a2
     27a:	|  |  |  |   adda.l d0,a2
     27c:	|  |  |  |   move.l 292(sp),-(sp)
     280:	|  |  |  |   jsr 255e <readString>
     286:	|  |  |  |   addq.l #4,sp
     288:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numBIFNames; fn ++) {
     28a:	|  |  |  |   addq.l #1,308(sp)
     28e:	|  |  |  \-> move.l 74ae <numBIFNames>,d0
     294:	|  |  |      cmp.l 308(sp),d0
     298:	|  |  \----- bgt.s 26a <initSludge+0xbe>
		}
		numUserFunc = get2bytes (fp);
     29a:	|  |         move.l 292(sp),-(sp)
     29e:	|  |         jsr 23c6 <get2bytes>
     2a4:	|  |         addq.l #4,sp
     2a6:	|  |         move.l d0,74b6 <numUserFunc>
		allUserFunc = AllocVec(numUserFunc,MEMF_ANY);
     2ac:	|  |         move.l 74b6 <numUserFunc>,d0
     2b2:	|  |         move.l d0,268(sp)
     2b6:	|  |         clr.l 264(sp)
     2ba:	|  |         move.l 755e <SysBase>,d0
     2c0:	|  |         movea.l d0,a6
     2c2:	|  |         move.l 268(sp),d0
     2c6:	|  |         move.l 264(sp),d1
     2ca:	|  |         jsr -684(a6)
     2ce:	|  |         move.l d0,260(sp)
     2d2:	|  |         move.l 260(sp),d0
     2d6:	|  |         move.l d0,74ba <allUserFunc>
		if( allUserFunc == 0) return FALSE;
     2dc:	|  |         move.l 74ba <allUserFunc>,d0
     2e2:	|  |     /-- bne.s 2ea <initSludge+0x13e>
     2e4:	|  |     |   clr.w d0
     2e6:	+--|-----|-- bra.w 910 <initSludge+0x764>

		for (int fn = 0; fn < numUserFunc; fn ++) {
     2ea:	|  |     \-> clr.l 304(sp)
     2ee:	|  |     /-- bra.s 314 <initSludge+0x168>
			allUserFunc[fn] =   (char *) readString (fp);
     2f0:	|  |  /--|-> move.l 74ba <allUserFunc>,d1
     2f6:	|  |  |  |   move.l 304(sp),d0
     2fa:	|  |  |  |   add.l d0,d0
     2fc:	|  |  |  |   add.l d0,d0
     2fe:	|  |  |  |   movea.l d1,a2
     300:	|  |  |  |   adda.l d0,a2
     302:	|  |  |  |   move.l 292(sp),-(sp)
     306:	|  |  |  |   jsr 255e <readString>
     30c:	|  |  |  |   addq.l #4,sp
     30e:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numUserFunc; fn ++) {
     310:	|  |  |  |   addq.l #1,304(sp)
     314:	|  |  |  \-> move.l 74b6 <numUserFunc>,d0
     31a:	|  |  |      cmp.l 304(sp),d0
     31e:	|  |  \----- bgt.s 2f0 <initSludge+0x144>
		}
		if (gameVersion >= VERSION(1,3)) {
     320:	|  |         move.l 74a6 <gameVersion>,d0
     326:	|  |         cmpi.l #258,d0
     32c:	|  +-------- ble.w 3b6 <initSludge+0x20a>
			numResourceNames = get2bytes (fp);
     330:	|  |         move.l 292(sp),-(sp)
     334:	|  |         jsr 23c6 <get2bytes>
     33a:	|  |         addq.l #4,sp
     33c:	|  |         move.l d0,74be <numResourceNames>
			allResourceNames = AllocVec(numResourceNames,MEMF_ANY);
     342:	|  |         move.l 74be <numResourceNames>,d0
     348:	|  |         move.l d0,256(sp)
     34c:	|  |         clr.l 252(sp)
     350:	|  |         move.l 755e <SysBase>,d0
     356:	|  |         movea.l d0,a6
     358:	|  |         move.l 256(sp),d0
     35c:	|  |         move.l 252(sp),d1
     360:	|  |         jsr -684(a6)
     364:	|  |         move.l d0,248(sp)
     368:	|  |         move.l 248(sp),d0
     36c:	|  |         move.l d0,74c2 <allResourceNames>
			if(allResourceNames == 0) return FALSE;
     372:	|  |         move.l 74c2 <allResourceNames>,d0
     378:	|  |     /-- bne.s 380 <initSludge+0x1d4>
     37a:	|  |     |   clr.w d0
     37c:	+--|-----|-- bra.w 910 <initSludge+0x764>

			for (int fn = 0; fn < numResourceNames; fn ++) {
     380:	|  |     \-> clr.l 300(sp)
     384:	|  |     /-- bra.s 3aa <initSludge+0x1fe>
				allResourceNames[fn] =  (char *) readString (fp);
     386:	|  |  /--|-> move.l 74c2 <allResourceNames>,d1
     38c:	|  |  |  |   move.l 300(sp),d0
     390:	|  |  |  |   add.l d0,d0
     392:	|  |  |  |   add.l d0,d0
     394:	|  |  |  |   movea.l d1,a2
     396:	|  |  |  |   adda.l d0,a2
     398:	|  |  |  |   move.l 292(sp),-(sp)
     39c:	|  |  |  |   jsr 255e <readString>
     3a2:	|  |  |  |   addq.l #4,sp
     3a4:	|  |  |  |   move.l d0,(a2)
			for (int fn = 0; fn < numResourceNames; fn ++) {
     3a6:	|  |  |  |   addq.l #1,300(sp)
     3aa:	|  |  |  \-> move.l 74be <numResourceNames>,d0
     3b0:	|  |  |      cmp.l 300(sp),d0
     3b4:	|  |  \----- bgt.s 386 <initSludge+0x1da>
			}
		}
	}
	winWidth = get2bytes (fp);
     3b6:	|  \-------> move.l 292(sp),-(sp)
     3ba:	|            jsr 23c6 <get2bytes>
     3c0:	|            addq.l #4,sp
     3c2:	|            move.l d0,749a <winWidth>
	winHeight = get2bytes (fp);
     3c8:	|            move.l 292(sp),-(sp)
     3cc:	|            jsr 23c6 <get2bytes>
     3d2:	|            addq.l #4,sp
     3d4:	|            move.l d0,749e <winHeight>
	specialSettings = FGetC (fp);
     3da:	|            move.l 292(sp),244(sp)
     3e0:	|            move.l 7566 <DOSBase>,d0
     3e6:	|            movea.l d0,a6
     3e8:	|            move.l 244(sp),d1
     3ec:	|            jsr -306(a6)
     3f0:	|            move.l d0,240(sp)
     3f4:	|            move.l 240(sp),d0
     3f8:	|            move.l d0,74aa <specialSettings>

	desiredfps = 1000/FGetC (fp);
     3fe:	|            move.l 292(sp),236(sp)
     404:	|            move.l 7566 <DOSBase>,d0
     40a:	|            movea.l d0,a6
     40c:	|            move.l 236(sp),d1
     410:	|            jsr -306(a6)
     414:	|            move.l d0,232(sp)
     418:	|            move.l 232(sp),d0
     41c:	|            move.l d0,-(sp)
     41e:	|            pea 3e8 <initSludge+0x23c>
     422:	|            jsr 33ce <__divsi3>
     428:	|            addq.l #8,sp
     42a:	|            move.l d0,6000 <desiredfps>

	FreeVec(readString (fp));
     430:	|            move.l 292(sp),-(sp)
     434:	|            jsr 255e <readString>
     43a:	|            addq.l #4,sp
     43c:	|            move.l d0,228(sp)
     440:	|            move.l 755e <SysBase>,d0
     446:	|            movea.l d0,a6
     448:	|            movea.l 228(sp),a1
     44c:	|            jsr -690(a6)

	ULONG blocks_read = FRead( fp, &fileTime, sizeof (FILETIME), 1 ); 
     450:	|            move.l 292(sp),224(sp)
     456:	|            move.l #29894,220(sp)
     45e:	|            moveq #8,d0
     460:	|            move.l d0,216(sp)
     464:	|            moveq #1,d1
     466:	|            move.l d1,212(sp)
     46a:	|            move.l 7566 <DOSBase>,d0
     470:	|            movea.l d0,a6
     472:	|            move.l 224(sp),d1
     476:	|            move.l 220(sp),d2
     47a:	|            move.l 216(sp),d3
     47e:	|            move.l 212(sp),d4
     482:	|            jsr -324(a6)
     486:	|            move.l d0,208(sp)
     48a:	|            move.l 208(sp),d0
     48e:	|            move.l d0,204(sp)
	if (blocks_read != 1) {
     492:	|            moveq #1,d0
     494:	|            cmp.l 204(sp),d0
     498:	|        /-- beq.s 4a8 <initSludge+0x2fc>
		KPrintF("Reading error in initSludge.\n");
     49a:	|        |   pea 3447 <PutChar+0x3d>
     4a0:	|        |   jsr 3168 <KPrintF>
     4a6:	|        |   addq.l #4,sp
	}

	char * dataFol = (gameVersion >= VERSION(1,3)) ? readString(fp) : joinStrings ("", "");
     4a8:	|        \-> move.l 74a6 <gameVersion>,d0
     4ae:	|            cmpi.l #258,d0
     4b4:	|        /-- ble.s 4c4 <initSludge+0x318>
     4b6:	|        |   move.l 292(sp),-(sp)
     4ba:	|        |   jsr 255e <readString>
     4c0:	|        |   addq.l #4,sp
     4c2:	|     /--|-- bra.s 4d8 <initSludge+0x32c>
     4c4:	|     |  \-> pea 3465 <PutChar+0x5b>
     4ca:	|     |      pea 3465 <PutChar+0x5b>
     4d0:	|     |      jsr 2da0 <joinStrings>
     4d6:	|     |      addq.l #8,sp
     4d8:	|     \----> move.l d0,200(sp)

	gameSettings.numLanguages = (gameVersion >= VERSION(1,3)) ? (FGetC (fp)) : 0;
     4dc:	|            move.l 74a6 <gameVersion>,d0
     4e2:	|            cmpi.l #258,d0
     4e8:	|     /----- ble.s 50a <initSludge+0x35e>
     4ea:	|     |      move.l 292(sp),196(sp)
     4f0:	|     |      move.l 7566 <DOSBase>,d0
     4f6:	|     |      movea.l d0,a6
     4f8:	|     |      move.l 196(sp),d1
     4fc:	|     |      jsr -306(a6)
     500:	|     |      move.l d0,192(sp)
     504:	|     |      move.l 192(sp),d0
     508:	|     |  /-- bra.s 50c <initSludge+0x360>
     50a:	|     \--|-> moveq #0,d0
     50c:	|        \-> move.l d0,75de <gameSettings+0x4>
	makeLanguageTable (fp);
     512:	|            move.l 292(sp),-(sp)
     516:	|            jsr 2704 <makeLanguageTable>
     51c:	|            addq.l #4,sp

	if (gameVersion >= VERSION(1,6))
     51e:	|            move.l 74a6 <gameVersion>,d0
     524:	|            cmpi.l #261,d0
     52a:	|        /-- ble.s 578 <initSludge+0x3cc>
	{
		FGetC(fp);
     52c:	|        |   move.l 292(sp),188(sp)
     532:	|        |   move.l 7566 <DOSBase>,d0
     538:	|        |   movea.l d0,a6
     53a:	|        |   move.l 188(sp),d1
     53e:	|        |   jsr -306(a6)
     542:	|        |   move.l d0,184(sp)
		// aaLoad
		FGetC (fp);
     546:	|        |   move.l 292(sp),180(sp)
     54c:	|        |   move.l 7566 <DOSBase>,d0
     552:	|        |   movea.l d0,a6
     554:	|        |   move.l 180(sp),d1
     558:	|        |   jsr -306(a6)
     55c:	|        |   move.l d0,176(sp)
		getFloat (fp);
     560:	|        |   move.l 292(sp),-(sp)
     564:	|        |   jsr 24e2 <getFloat>
     56a:	|        |   addq.l #4,sp
		getFloat (fp);
     56c:	|        |   move.l 292(sp),-(sp)
     570:	|        |   jsr 24e2 <getFloat>
     576:	|        |   addq.l #4,sp
	}

	char * checker = readString (fp);
     578:	|        \-> move.l 292(sp),-(sp)
     57c:	|            jsr 255e <readString>
     582:	|            addq.l #4,sp
     584:	|            move.l d0,172(sp)

	if (strcmp (checker, "okSoFar")) {
     588:	|            pea 3466 <PutChar+0x5c>
     58e:	|            move.l 176(sp),-(sp)
     592:	|            jsr 2cb2 <strcmp>
     598:	|            addq.l #8,sp
     59a:	|            tst.l d0
     59c:	|        /-- beq.s 5a4 <initSludge+0x3f8>
		return FALSE;
     59e:	|        |   clr.w d0
     5a0:	+--------|-- bra.w 910 <initSludge+0x764>
	}
	FreeVec( checker);
     5a4:	|        \-> move.l 172(sp),168(sp)
     5aa:	|            move.l 755e <SysBase>,d0
     5b0:	|            movea.l d0,a6
     5b2:	|            movea.l 168(sp),a1
     5b6:	|            jsr -690(a6)
	checker = NULL;
     5ba:	|            clr.l 172(sp)

    unsigned char customIconLogo = FGetC (fp);
     5be:	|            move.l 292(sp),164(sp)
     5c4:	|            move.l 7566 <DOSBase>,d0
     5ca:	|            movea.l d0,a6
     5cc:	|            move.l 164(sp),d1
     5d0:	|            jsr -306(a6)
     5d4:	|            move.l d0,160(sp)
     5d8:	|            move.l 160(sp),d0
     5dc:	|            move.b d0,159(sp)

	if (customIconLogo & 1) {
     5e0:	|            moveq #0,d0
     5e2:	|            move.b 159(sp),d0
     5e6:	|            moveq #1,d1
     5e8:	|            and.l d1,d0
     5ea:	|        /-- beq.s 642 <initSludge+0x496>
		// There is an icon - read it!
		Write(Output(), (APTR)"initsludge:Game Icon not supported on this plattform.\n", 54);
     5ec:	|        |   move.l 7566 <DOSBase>,d0
     5f2:	|        |   movea.l d0,a6
     5f4:	|        |   jsr -60(a6)
     5f8:	|        |   move.l d0,38(sp)
     5fc:	|        |   move.l 38(sp),d0
     600:	|        |   move.l d0,34(sp)
     604:	|        |   move.l #13422,30(sp)
     60c:	|        |   moveq #54,d0
     60e:	|        |   move.l d0,26(sp)
     612:	|        |   move.l 7566 <DOSBase>,d0
     618:	|        |   movea.l d0,a6
     61a:	|        |   move.l 34(sp),d1
     61e:	|        |   move.l 30(sp),d2
     622:	|        |   move.l 26(sp),d3
     626:	|        |   jsr -48(a6)
     62a:	|        |   move.l d0,22(sp)
		KPrintF("initsludge: Game Icon not supported on this plattform.\n");
     62e:	|        |   pea 34a5 <PutChar+0x9b>
     634:	|        |   jsr 3168 <KPrintF>
     63a:	|        |   addq.l #4,sp
		return FALSE;
     63c:	|        |   clr.w d0
     63e:	+--------|-- bra.w 910 <initSludge+0x764>
	}

	numGlobals = get2bytes (fp);
     642:	|        \-> move.l 292(sp),-(sp)
     646:	|            jsr 23c6 <get2bytes>
     64c:	|            addq.l #4,sp
     64e:	|            move.l d0,74d6 <numGlobals>

	globalVars = AllocVec( sizeof(struct variable) * numGlobals,MEMF_ANY);
     654:	|            move.l 74d6 <numGlobals>,d0
     65a:	|            lsl.l #3,d0
     65c:	|            move.l d0,154(sp)
     660:	|            clr.l 150(sp)
     664:	|            move.l 755e <SysBase>,d0
     66a:	|            movea.l d0,a6
     66c:	|            move.l 154(sp),d0
     670:	|            move.l 150(sp),d1
     674:	|            jsr -684(a6)
     678:	|            move.l d0,146(sp)
     67c:	|            move.l 146(sp),d0
     680:	|            move.l d0,74d2 <globalVars>
	if(globalVars == 0) {
     686:	|            move.l 74d2 <globalVars>,d0
     68c:	|        /-- bne.s 6a2 <initSludge+0x4f6>
		KPrintF("initsludge: Cannot allocate memory for globalvars\n");
     68e:	|        |   pea 34dd <PutChar+0xd3>
     694:	|        |   jsr 3168 <KPrintF>
     69a:	|        |   addq.l #4,sp
		return FALSE;
     69c:	|        |   clr.w d0
     69e:	+--------|-- bra.w 910 <initSludge+0x764>
	}		 
	for (a = 0; a < numGlobals; a ++) initVarNew (globalVars[a]);
     6a2:	|        \-> clr.l 312(sp)
     6a6:	|        /-- bra.s 6be <initSludge+0x512>
     6a8:	|     /--|-> move.l 74d2 <globalVars>,d1
     6ae:	|     |  |   move.l 312(sp),d0
     6b2:	|     |  |   lsl.l #3,d0
     6b4:	|     |  |   movea.l d1,a0
     6b6:	|     |  |   adda.l d0,a0
     6b8:	|     |  |   clr.l (a0)
     6ba:	|     |  |   addq.l #1,312(sp)
     6be:	|     |  \-> move.l 74d6 <numGlobals>,d0
     6c4:	|     |      cmp.l 312(sp),d0
     6c8:	|     \----- bgt.s 6a8 <initSludge+0x4fc>

	setFileIndices (fp, gameSettings.numLanguages, 0);
     6ca:	|            move.l 75de <gameSettings+0x4>,d0
     6d0:	|            clr.l -(sp)
     6d2:	|            move.l d0,-(sp)
     6d4:	|            move.l 300(sp),-(sp)
     6d8:	|            jsr 16e2 <setFileIndices>
     6de:	|            lea 12(sp),sp

	char * gameNameOrig = getNumberedString(1);	
     6e2:	|            pea 1 <_start+0x1>
     6e6:	|            jsr 1524 <getNumberedString>
     6ec:	|            addq.l #4,sp
     6ee:	|            move.l d0,142(sp)
	char * gameName = encodeFilename (gameNameOrig);
     6f2:	|            move.l 142(sp),-(sp)
     6f6:	|            jsr 2008 <encodeFilename>
     6fc:	|            addq.l #4,sp
     6fe:	|            move.l d0,138(sp)

	FreeVec(gameNameOrig);
     702:	|            move.l 142(sp),134(sp)
     708:	|            move.l 755e <SysBase>,d0
     70e:	|            movea.l d0,a6
     710:	|            movea.l 134(sp),a1
     714:	|            jsr -690(a6)

	BPTR lock = CreateDir( gameName );
     718:	|            move.l 138(sp),130(sp)
     71e:	|            move.l 7566 <DOSBase>,d0
     724:	|            movea.l d0,a6
     726:	|            move.l 130(sp),d1
     72a:	|            jsr -120(a6)
     72e:	|            move.l d0,126(sp)
     732:	|            move.l 126(sp),d0
     736:	|            move.l d0,296(sp)
	if(lock == 0) {
     73a:	|        /-- bne.s 768 <initSludge+0x5bc>
		//Directory does already exist
		lock = Lock(gameName, ACCESS_READ);
     73c:	|        |   move.l 138(sp),122(sp)
     742:	|        |   moveq #-2,d1
     744:	|        |   move.l d1,118(sp)
     748:	|        |   move.l 7566 <DOSBase>,d0
     74e:	|        |   movea.l d0,a6
     750:	|        |   move.l 122(sp),d1
     754:	|        |   move.l 118(sp),d2
     758:	|        |   jsr -84(a6)
     75c:	|        |   move.l d0,114(sp)
     760:	|        |   move.l 114(sp),d0
     764:	|        |   move.l d0,296(sp)
	}

	if (!CurrentDir(lock)) {
     768:	|        \-> move.l 296(sp),110(sp)
     76e:	|            move.l 7566 <DOSBase>,d0
     774:	|            movea.l d0,a6
     776:	|            move.l 110(sp),d1
     77a:	|            jsr -126(a6)
     77e:	|            move.l d0,106(sp)
     782:	|            move.l 106(sp),d0
     786:	|        /-- bne.s 7e2 <initSludge+0x636>
		KPrintF("initsludge: Failed changing to directory %s\n", gameName);
     788:	|        |   move.l 138(sp),-(sp)
     78c:	|        |   pea 3510 <PutChar+0x106>
     792:	|        |   jsr 3168 <KPrintF>
     798:	|        |   addq.l #8,sp
		Write(Output(), (APTR)"initsludge:Failed changing to directory\n", 40);
     79a:	|        |   move.l 7566 <DOSBase>,d0
     7a0:	|        |   movea.l d0,a6
     7a2:	|        |   jsr -60(a6)
     7a6:	|        |   move.l d0,58(sp)
     7aa:	|        |   move.l 58(sp),d0
     7ae:	|        |   move.l d0,54(sp)
     7b2:	|        |   move.l #13629,50(sp)
     7ba:	|        |   moveq #40,d0
     7bc:	|        |   move.l d0,46(sp)
     7c0:	|        |   move.l 7566 <DOSBase>,d0
     7c6:	|        |   movea.l d0,a6
     7c8:	|        |   move.l 54(sp),d1
     7cc:	|        |   move.l 50(sp),d2
     7d0:	|        |   move.l 46(sp),d3
     7d4:	|        |   jsr -48(a6)
     7d8:	|        |   move.l d0,42(sp)
		return FALSE;
     7dc:	|        |   clr.w d0
     7de:	+--------|-- bra.w 910 <initSludge+0x764>
	}

	FreeVec(gameName);
     7e2:	|        \-> move.l 138(sp),102(sp)
     7e8:	|            move.l 755e <SysBase>,d0
     7ee:	|            movea.l d0,a6
     7f0:	|            movea.l 102(sp),a1
     7f4:	|            jsr -690(a6)

	readIniFile (filename);
     7f8:	|            move.l 320(sp),-(sp)
     7fc:	|            jsr 2838 <readIniFile>
     802:	|            addq.l #4,sp

	// Now set file indices properly to the chosen language.
	languageNum = getLanguageForFileB ();
     804:	|            jsr 260a <getLanguageForFileB>
     80a:	|            move.l d0,6004 <languageNum>
	if (languageNum < 0) KPrintF("Can't find the translation data specified!");
     810:	|            move.l 6004 <languageNum>,d0
     816:	|        /-- bpl.s 826 <initSludge+0x67a>
     818:	|        |   pea 3566 <PutChar+0x15c>
     81e:	|        |   jsr 3168 <KPrintF>
     824:	|        |   addq.l #4,sp
	setFileIndices (NULL, gameSettings.numLanguages, languageNum);
     826:	|        \-> move.l 6004 <languageNum>,d0
     82c:	|            move.l d0,d1
     82e:	|            move.l 75de <gameSettings+0x4>,d0
     834:	|            move.l d1,-(sp)
     836:	|            move.l d0,-(sp)
     838:	|            clr.l -(sp)
     83a:	|            jsr 16e2 <setFileIndices>
     840:	|            lea 12(sp),sp

	if (dataFol[0]) {
     844:	|            movea.l 200(sp),a0
     848:	|            move.b (a0),d0
     84a:	|     /----- beq.w 8f4 <initSludge+0x748>
		char *dataFolder = encodeFilename(dataFol);
     84e:	|     |      move.l 200(sp),-(sp)
     852:	|     |      jsr 2008 <encodeFilename>
     858:	|     |      addq.l #4,sp
     85a:	|     |      move.l d0,98(sp)
		lock = CreateDir( dataFolder );
     85e:	|     |      move.l 98(sp),94(sp)
     864:	|     |      move.l 7566 <DOSBase>,d0
     86a:	|     |      movea.l d0,a6
     86c:	|     |      move.l 94(sp),d1
     870:	|     |      jsr -120(a6)
     874:	|     |      move.l d0,90(sp)
     878:	|     |      move.l 90(sp),d0
     87c:	|     |      move.l d0,296(sp)
		if(lock == 0) {
     880:	|     |  /-- bne.s 8ae <initSludge+0x702>
			//Directory does already exist
			lock = Lock(dataFolder, ACCESS_READ);		
     882:	|     |  |   move.l 98(sp),86(sp)
     888:	|     |  |   moveq #-2,d1
     88a:	|     |  |   move.l d1,82(sp)
     88e:	|     |  |   move.l 7566 <DOSBase>,d0
     894:	|     |  |   movea.l d0,a6
     896:	|     |  |   move.l 86(sp),d1
     89a:	|     |  |   move.l 82(sp),d2
     89e:	|     |  |   jsr -84(a6)
     8a2:	|     |  |   move.l d0,78(sp)
     8a6:	|     |  |   move.l 78(sp),d0
     8aa:	|     |  |   move.l d0,296(sp)
		}


		if (!CurrentDir(lock)) {
     8ae:	|     |  \-> move.l 296(sp),74(sp)
     8b4:	|     |      move.l 7566 <DOSBase>,d0
     8ba:	|     |      movea.l d0,a6
     8bc:	|     |      move.l 74(sp),d1
     8c0:	|     |      jsr -126(a6)
     8c4:	|     |      move.l d0,70(sp)
     8c8:	|     |      move.l 70(sp),d0
     8cc:	|     |  /-- bne.s 8de <initSludge+0x732>
			(Output(), (APTR)"initsludge:This game's data folder is inaccessible!\n", 52);
     8ce:	|     |  |   move.l 7566 <DOSBase>,d0
     8d4:	|     |  |   movea.l d0,a6
     8d6:	|     |  |   jsr -60(a6)
     8da:	|     |  |   move.l d0,66(sp)
		}
		FreeVec(dataFolder);
     8de:	|     |  \-> move.l 98(sp),62(sp)
     8e4:	|     |      move.l 755e <SysBase>,d0
     8ea:	|     |      movea.l d0,a6
     8ec:	|     |      movea.l 62(sp),a1
     8f0:	|     |      jsr -690(a6)
	}

 	positionStatus (10, winHeight - 15);
     8f4:	|     \----> movea.l 749e <winHeight>,a0
     8fa:	|            lea -15(a0),a0
     8fe:	|            move.l a0,d0
     900:	|            move.l d0,-(sp)
     902:	|            pea a <_start+0xa>
     906:	|            jsr 1c30 <positionStatus>
     90c:	|            addq.l #8,sp

	return TRUE;
     90e:	|            moveq #1,d0
}
     910:	\----------> movem.l (sp)+,d2-d4/a2/a6
     914:	             lea 296(sp),sp
     918:	             rts

0000091a <loadFunctionCode>:

BOOL loadFunctionCode (struct loadedFunction * newFunc) {
     91a:	             lea -52(sp),sp
     91e:	             move.l a6,-(sp)
	unsigned int numLines, numLinesRead;
	int a;

	if (! openSubSlice (newFunc -> originalNumber)) return FALSE;
     920:	             movea.l 60(sp),a0
     924:	             move.l (a0),d0
     926:	             move.l d0,-(sp)
     928:	             jsr 1622 <openSubSlice>
     92e:	             addq.l #4,sp
     930:	             tst.w d0
     932:	         /-- bne.s 93a <loadFunctionCode+0x20>
     934:	         |   clr.w d0
     936:	/--------|-- bra.w afc <loadFunctionCode+0x1e2>
	

	newFunc-> unfreezable	= FGetC (bigDataFile);
     93a:	|        \-> move.l 7546 <bigDataFile>,44(sp)
     942:	|            move.l 7566 <DOSBase>,d0
     948:	|            movea.l d0,a6
     94a:	|            move.l 44(sp),d1
     94e:	|            jsr -306(a6)
     952:	|            move.l d0,40(sp)
     956:	|            move.l 40(sp),d0
     95a:	|            move.l d0,d0
     95c:	|            movea.l 60(sp),a0
     960:	|            move.w d0,48(a0)
	numLines				= get2bytes (bigDataFile);
     964:	|            move.l 7546 <bigDataFile>,d0
     96a:	|            move.l d0,-(sp)
     96c:	|            jsr 23c6 <get2bytes>
     972:	|            addq.l #4,sp
     974:	|            move.l d0,36(sp)
	newFunc -> numArgs		= get2bytes (bigDataFile);
     978:	|            move.l 7546 <bigDataFile>,d0
     97e:	|            move.l d0,-(sp)
     980:	|            jsr 23c6 <get2bytes>
     986:	|            addq.l #4,sp
     988:	|            movea.l 60(sp),a0
     98c:	|            move.l d0,16(a0)
	newFunc -> numLocals	= get2bytes (bigDataFile);
     990:	|            move.l 7546 <bigDataFile>,d0
     996:	|            move.l d0,-(sp)
     998:	|            jsr 23c6 <get2bytes>
     99e:	|            addq.l #4,sp
     9a0:	|            movea.l 60(sp),a0
     9a4:	|            move.l d0,8(a0)
	newFunc -> compiledLines = AllocVec( sizeof(struct lineOfCode) * numLines,MEMF_ANY);
     9a8:	|            move.l 36(sp),d0
     9ac:	|            lsl.l #3,d0
     9ae:	|            move.l d0,32(sp)
     9b2:	|            clr.l 28(sp)
     9b6:	|            move.l 755e <SysBase>,d0
     9bc:	|            movea.l d0,a6
     9be:	|            move.l 32(sp),d0
     9c2:	|            move.l 28(sp),d1
     9c6:	|            jsr -684(a6)
     9ca:	|            move.l d0,24(sp)
     9ce:	|            move.l 24(sp),d0
     9d2:	|            movea.l 60(sp),a0
     9d6:	|            move.l d0,4(a0)
	if (! newFunc -> compiledLines) {
     9da:	|            movea.l 60(sp),a0
     9de:	|            move.l 4(a0),d0
     9e2:	|        /-- bne.s 9f8 <loadFunctionCode+0xde>
		KPrintF("loadFunctionCode: cannot allocate memory");
     9e4:	|        |   pea 3591 <PutChar+0x187>
     9ea:	|        |   jsr 3168 <KPrintF>
     9f0:	|        |   addq.l #4,sp
		return FALSE;
     9f2:	|        |   clr.w d0
     9f4:	+--------|-- bra.w afc <loadFunctionCode+0x1e2>
	}

	for (numLinesRead = 0; numLinesRead < numLines; numLinesRead ++) {
     9f8:	|        \-> clr.l 52(sp)
     9fc:	|        /-- bra.s a5e <loadFunctionCode+0x144>
		newFunc -> compiledLines[numLinesRead].theCommand = (enum sludgeCommand) FGetC(bigDataFile);
     9fe:	|     /--|-> move.l 7546 <bigDataFile>,8(sp)
     a06:	|     |  |   move.l 7566 <DOSBase>,d0
     a0c:	|     |  |   movea.l d0,a6
     a0e:	|     |  |   move.l 8(sp),d1
     a12:	|     |  |   jsr -306(a6)
     a16:	|     |  |   move.l d0,4(sp)
     a1a:	|     |  |   move.l 4(sp),d1
     a1e:	|     |  |   movea.l 60(sp),a0
     a22:	|     |  |   movea.l 4(a0),a0
     a26:	|     |  |   move.l 52(sp),d0
     a2a:	|     |  |   lsl.l #3,d0
     a2c:	|     |  |   adda.l d0,a0
     a2e:	|     |  |   move.l d1,d0
     a30:	|     |  |   move.l d0,(a0)
		newFunc -> compiledLines[numLinesRead].param = get2bytes (bigDataFile);
     a32:	|     |  |   move.l 7546 <bigDataFile>,d0
     a38:	|     |  |   move.l d0,-(sp)
     a3a:	|     |  |   jsr 23c6 <get2bytes>
     a40:	|     |  |   addq.l #4,sp
     a42:	|     |  |   move.l d0,d1
     a44:	|     |  |   movea.l 60(sp),a0
     a48:	|     |  |   movea.l 4(a0),a0
     a4c:	|     |  |   move.l 52(sp),d0
     a50:	|     |  |   lsl.l #3,d0
     a52:	|     |  |   adda.l d0,a0
     a54:	|     |  |   move.l d1,d0
     a56:	|     |  |   move.l d0,4(a0)
	for (numLinesRead = 0; numLinesRead < numLines; numLinesRead ++) {
     a5a:	|     |  |   addq.l #1,52(sp)
     a5e:	|     |  \-> move.l 52(sp),d0
     a62:	|     |      cmp.l 36(sp),d0
     a66:	|     \----- bcs.s 9fe <loadFunctionCode+0xe4>
	}

	finishAccess ();
     a68:	|            jsr 151a <finishAccess>

	// Now we need to reserve memory for the local variables
	if(newFunc->numLocals > 1) {
     a6e:	|            movea.l 60(sp),a0
     a72:	|            move.l 8(a0),d0
     a76:	|            moveq #1,d1
     a78:	|            cmp.l d0,d1
     a7a:	|  /-------- bge.s afa <loadFunctionCode+0x1e0>
		newFunc -> localVars = AllocVec( sizeof(struct variable) * newFunc->numLocals,MEMF_ANY);
     a7c:	|  |         movea.l 60(sp),a0
     a80:	|  |         move.l 8(a0),d0
     a84:	|  |         lsl.l #3,d0
     a86:	|  |         move.l d0,20(sp)
     a8a:	|  |         clr.l 16(sp)
     a8e:	|  |         move.l 755e <SysBase>,d0
     a94:	|  |         movea.l d0,a6
     a96:	|  |         move.l 20(sp),d0
     a9a:	|  |         move.l 16(sp),d1
     a9e:	|  |         jsr -684(a6)
     aa2:	|  |         move.l d0,12(sp)
     aa6:	|  |         move.l 12(sp),d0
     aaa:	|  |         movea.l 60(sp),a0
     aae:	|  |         move.l d0,20(a0)
		if (!newFunc -> localVars) {
     ab2:	|  |         movea.l 60(sp),a0
     ab6:	|  |         move.l 20(a0),d0
     aba:	|  |     /-- bne.s ace <loadFunctionCode+0x1b4>
			KPrintF("loadFunctionCode: cannot allocate memory");
     abc:	|  |     |   pea 3591 <PutChar+0x187>
     ac2:	|  |     |   jsr 3168 <KPrintF>
     ac8:	|  |     |   addq.l #4,sp
			return FALSE;
     aca:	|  |     |   clr.w d0
     acc:	+--|-----|-- bra.s afc <loadFunctionCode+0x1e2>
		}

		for (a = 0; a < newFunc -> numLocals; a ++) {
     ace:	|  |     \-> clr.l 48(sp)
     ad2:	|  |     /-- bra.s aec <loadFunctionCode+0x1d2>
			initVarNew (newFunc -> localVars[a]);
     ad4:	|  |  /--|-> movea.l 60(sp),a0
     ad8:	|  |  |  |   move.l 20(a0),d1
     adc:	|  |  |  |   move.l 48(sp),d0
     ae0:	|  |  |  |   lsl.l #3,d0
     ae2:	|  |  |  |   movea.l d1,a0
     ae4:	|  |  |  |   adda.l d0,a0
     ae6:	|  |  |  |   clr.l (a0)
		for (a = 0; a < newFunc -> numLocals; a ++) {
     ae8:	|  |  |  |   addq.l #1,48(sp)
     aec:	|  |  |  \-> movea.l 60(sp),a0
     af0:	|  |  |      move.l 8(a0),d0
     af4:	|  |  |      cmp.l 48(sp),d0
     af8:	|  |  \----- bgt.s ad4 <loadFunctionCode+0x1ba>
		}
	}
	return TRUE;
     afa:	|  \-------> moveq #1,d0
}
     afc:	\----------> movea.l (sp)+,a6
     afe:	             lea 52(sp),sp
     b02:	             rts

00000b04 <openAndVerify>:

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion) {
     b04:	       lea -312(sp),sp
     b08:	       movem.l d2-d3/a6,-(sp)
     b0c:	       move.l 332(sp),d1
     b10:	       move.l 336(sp),d0
     b14:	       move.b d1,d1
     b16:	       move.b d1,16(sp)
     b1a:	       move.b d0,d0
     b1c:	       move.b d0,14(sp)
	BPTR fp = Open(filename,MODE_OLDFILE);
     b20:	       move.l 328(sp),318(sp)
     b26:	       move.l #1005,314(sp)
     b2e:	       move.l 7566 <DOSBase>,d0
     b34:	       movea.l d0,a6
     b36:	       move.l 318(sp),d1
     b3a:	       move.l 314(sp),d2
     b3e:	       jsr -30(a6)
     b42:	       move.l d0,310(sp)
     b46:	       move.l 310(sp),d0
     b4a:	       move.l d0,306(sp)

	if (! fp) {
     b4e:	   /-- bne.s baa <openAndVerify+0xa6>
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
     b50:	   |   move.l 7566 <DOSBase>,d0
     b56:	   |   movea.l d0,a6
     b58:	   |   jsr -60(a6)
     b5c:	   |   move.l d0,154(sp)
     b60:	   |   move.l 154(sp),d0
     b64:	   |   move.l d0,150(sp)
     b68:	   |   move.l #13754,146(sp)
     b70:	   |   moveq #31,d0
     b72:	   |   move.l d0,142(sp)
     b76:	   |   move.l 7566 <DOSBase>,d0
     b7c:	   |   movea.l d0,a6
     b7e:	   |   move.l 150(sp),d1
     b82:	   |   move.l 146(sp),d2
     b86:	   |   move.l 142(sp),d3
     b8a:	   |   jsr -48(a6)
     b8e:	   |   move.l d0,138(sp)
		KPrintF("openAndVerify: Can't open file", filename);
     b92:	   |   move.l 328(sp),-(sp)
     b96:	   |   pea 35da <PutChar+0x1d0>
     b9c:	   |   jsr 3168 <KPrintF>
     ba2:	   |   addq.l #8,sp
		return NULL;
     ba4:	   |   moveq #0,d0
     ba6:	/--|-- bra.w e6a <openAndVerify+0x366>
	}
	BOOL headerBad = FALSE;
     baa:	|  \-> clr.w 322(sp)
	if (FGetC (fp) != 'S') headerBad = TRUE;
     bae:	|      move.l 306(sp),302(sp)
     bb4:	|      move.l 7566 <DOSBase>,d0
     bba:	|      movea.l d0,a6
     bbc:	|      move.l 302(sp),d1
     bc0:	|      jsr -306(a6)
     bc4:	|      move.l d0,298(sp)
     bc8:	|      move.l 298(sp),d0
     bcc:	|      moveq #83,d1
     bce:	|      cmp.l d0,d1
     bd0:	|  /-- beq.s bd8 <openAndVerify+0xd4>
     bd2:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'L') headerBad = TRUE;
     bd8:	|  \-> move.l 306(sp),294(sp)
     bde:	|      move.l 7566 <DOSBase>,d0
     be4:	|      movea.l d0,a6
     be6:	|      move.l 294(sp),d1
     bea:	|      jsr -306(a6)
     bee:	|      move.l d0,290(sp)
     bf2:	|      move.l 290(sp),d0
     bf6:	|      moveq #76,d1
     bf8:	|      cmp.l d0,d1
     bfa:	|  /-- beq.s c02 <openAndVerify+0xfe>
     bfc:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'U') headerBad = TRUE;
     c02:	|  \-> move.l 306(sp),286(sp)
     c08:	|      move.l 7566 <DOSBase>,d0
     c0e:	|      movea.l d0,a6
     c10:	|      move.l 286(sp),d1
     c14:	|      jsr -306(a6)
     c18:	|      move.l d0,282(sp)
     c1c:	|      move.l 282(sp),d0
     c20:	|      moveq #85,d1
     c22:	|      cmp.l d0,d1
     c24:	|  /-- beq.s c2c <openAndVerify+0x128>
     c26:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'D') headerBad = TRUE;
     c2c:	|  \-> move.l 306(sp),278(sp)
     c32:	|      move.l 7566 <DOSBase>,d0
     c38:	|      movea.l d0,a6
     c3a:	|      move.l 278(sp),d1
     c3e:	|      jsr -306(a6)
     c42:	|      move.l d0,274(sp)
     c46:	|      move.l 274(sp),d0
     c4a:	|      moveq #68,d1
     c4c:	|      cmp.l d0,d1
     c4e:	|  /-- beq.s c56 <openAndVerify+0x152>
     c50:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra1) headerBad = TRUE;
     c56:	|  \-> move.l 306(sp),270(sp)
     c5c:	|      move.l 7566 <DOSBase>,d0
     c62:	|      movea.l d0,a6
     c64:	|      move.l 270(sp),d1
     c68:	|      jsr -306(a6)
     c6c:	|      move.l d0,266(sp)
     c70:	|      move.l 266(sp),d1
     c74:	|      move.b 16(sp),d0
     c78:	|      ext.w d0
     c7a:	|      movea.w d0,a0
     c7c:	|      cmpa.l d1,a0
     c7e:	|  /-- beq.s c86 <openAndVerify+0x182>
     c80:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra2) headerBad = TRUE;
     c86:	|  \-> move.l 306(sp),262(sp)
     c8c:	|      move.l 7566 <DOSBase>,d0
     c92:	|      movea.l d0,a6
     c94:	|      move.l 262(sp),d1
     c98:	|      jsr -306(a6)
     c9c:	|      move.l d0,258(sp)
     ca0:	|      move.l 258(sp),d1
     ca4:	|      move.b 14(sp),d0
     ca8:	|      ext.w d0
     caa:	|      movea.w d0,a0
     cac:	|      cmpa.l d1,a0
     cae:	|  /-- beq.s cb6 <openAndVerify+0x1b2>
     cb0:	|  |   move.w #1,322(sp)
	if (headerBad) {
     cb6:	|  \-> tst.w 322(sp)
     cba:	|  /-- beq.s d12 <openAndVerify+0x20e>
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
     cbc:	|  |   move.l 7566 <DOSBase>,d0
     cc2:	|  |   movea.l d0,a6
     cc4:	|  |   jsr -60(a6)
     cc8:	|  |   move.l d0,174(sp)
     ccc:	|  |   move.l 174(sp),d0
     cd0:	|  |   move.l d0,170(sp)
     cd4:	|  |   move.l #13817,166(sp)
     cdc:	|  |   moveq #31,d0
     cde:	|  |   move.l d0,162(sp)
     ce2:	|  |   move.l 7566 <DOSBase>,d0
     ce8:	|  |   movea.l d0,a6
     cea:	|  |   move.l 170(sp),d1
     cee:	|  |   move.l 166(sp),d2
     cf2:	|  |   move.l 162(sp),d3
     cf6:	|  |   jsr -48(a6)
     cfa:	|  |   move.l d0,158(sp)
		KPrintF("openAndVerify: Bad Header\n");
     cfe:	|  |   pea 35f9 <PutChar+0x1ef>
     d04:	|  |   jsr 3168 <KPrintF>
     d0a:	|  |   addq.l #4,sp
		return NULL;
     d0c:	|  |   moveq #0,d0
     d0e:	+--|-- bra.w e6a <openAndVerify+0x366>
	}
	FGetC (fp);
     d12:	|  \-> move.l 306(sp),254(sp)
     d18:	|      move.l 7566 <DOSBase>,d0
     d1e:	|      movea.l d0,a6
     d20:	|      move.l 254(sp),d1
     d24:	|      jsr -306(a6)
     d28:	|      move.l d0,250(sp)
	while (FGetC(fp)) {;}
     d2c:	|      nop
     d2e:	|  /-> move.l 306(sp),246(sp)
     d34:	|  |   move.l 7566 <DOSBase>,d0
     d3a:	|  |   movea.l d0,a6
     d3c:	|  |   move.l 246(sp),d1
     d40:	|  |   jsr -306(a6)
     d44:	|  |   move.l d0,242(sp)
     d48:	|  |   move.l 242(sp),d0
     d4c:	|  \-- bne.s d2e <openAndVerify+0x22a>

	int majVersion = FGetC (fp);
     d4e:	|      move.l 306(sp),238(sp)
     d54:	|      move.l 7566 <DOSBase>,d0
     d5a:	|      movea.l d0,a6
     d5c:	|      move.l 238(sp),d1
     d60:	|      jsr -306(a6)
     d64:	|      move.l d0,234(sp)
     d68:	|      move.l 234(sp),d0
     d6c:	|      move.l d0,230(sp)
	int minVersion = FGetC (fp);
     d70:	|      move.l 306(sp),226(sp)
     d76:	|      move.l 7566 <DOSBase>,d0
     d7c:	|      movea.l d0,a6
     d7e:	|      move.l 226(sp),d1
     d82:	|      jsr -306(a6)
     d86:	|      move.l d0,222(sp)
     d8a:	|      move.l 222(sp),d0
     d8e:	|      move.l d0,218(sp)
	*fileVersion = majVersion * 256 + minVersion;
     d92:	|      move.l 230(sp),d0
     d96:	|      lsl.l #8,d0
     d98:	|      add.l 218(sp),d0
     d9c:	|      movea.l 344(sp),a0
     da0:	|      move.l d0,(a0)

	char txtVer[120];

	if (*fileVersion > WHOLE_VERSION) {
     da2:	|      movea.l 344(sp),a0
     da6:	|      move.l (a0),d0
     da8:	|      cmpi.l #514,d0
     dae:	|  /-- ble.s e04 <openAndVerify+0x300>
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
     db0:	|  |   move.l 7566 <DOSBase>,d0
     db6:	|  |   movea.l d0,a6
     db8:	|  |   jsr -60(a6)
     dbc:	|  |   move.l d0,194(sp)
     dc0:	|  |   move.l 194(sp),d0
     dc4:	|  |   move.l d0,190(sp)
     dc8:	|  |   move.l #13844,186(sp)
     dd0:	|  |   moveq #100,d1
     dd2:	|  |   move.l d1,182(sp)
     dd6:	|  |   move.l 7566 <DOSBase>,d0
     ddc:	|  |   movea.l d0,a6
     dde:	|  |   move.l 190(sp),d1
     de2:	|  |   move.l 186(sp),d2
     de6:	|  |   move.l 182(sp),d3
     dea:	|  |   jsr -48(a6)
     dee:	|  |   move.l d0,178(sp)
		KPrintF(ERROR_VERSION_TOO_LOW_1);
     df2:	|  |   pea 3614 <PutChar+0x20a>
     df8:	|  |   jsr 3168 <KPrintF>
     dfe:	|  |   addq.l #4,sp
		return NULL;
     e00:	|  |   moveq #0,d0
     e02:	+--|-- bra.s e6a <openAndVerify+0x366>
	} else if (*fileVersion < MINIM_VERSION) {
     e04:	|  \-> movea.l 344(sp),a0
     e08:	|      move.l (a0),d0
     e0a:	|      cmpi.l #257,d0
     e10:	|  /-- bgt.s e66 <openAndVerify+0x362>
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
     e12:	|  |   move.l 7566 <DOSBase>,d0
     e18:	|  |   movea.l d0,a6
     e1a:	|  |   jsr -60(a6)
     e1e:	|  |   move.l d0,214(sp)
     e22:	|  |   move.l 214(sp),d0
     e26:	|  |   move.l d0,210(sp)
     e2a:	|  |   move.l #13913,206(sp)
     e32:	|  |   moveq #100,d0
     e34:	|  |   move.l d0,202(sp)
     e38:	|  |   move.l 7566 <DOSBase>,d0
     e3e:	|  |   movea.l d0,a6
     e40:	|  |   move.l 210(sp),d1
     e44:	|  |   move.l 206(sp),d2
     e48:	|  |   move.l 202(sp),d3
     e4c:	|  |   jsr -48(a6)
     e50:	|  |   move.l d0,198(sp)
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
     e54:	|  |   pea 3659 <PutChar+0x24f>
     e5a:	|  |   jsr 3168 <KPrintF>
     e60:	|  |   addq.l #4,sp
		return NULL;
     e62:	|  |   moveq #0,d0
     e64:	+--|-- bra.s e6a <openAndVerify+0x366>
	}
	return fp;
     e66:	|  \-> move.l 306(sp),d0
}
     e6a:	\----> movem.l (sp)+,d2-d3/a6
     e6e:	       lea 312(sp),sp
     e72:	       rts

00000e74 <restartFunction>:

void restartFunction (struct loadedFunction * fun) {
	fun -> next = allRunningFunctions;
     e74:	move.l 74da <allRunningFunctions>,d0
     e7a:	movea.l 4(sp),a0
     e7e:	move.l d0,40(a0)
	allRunningFunctions = fun;
     e82:	move.l 4(sp),74da <allRunningFunctions>
}
     e8a:	nop
     e8c:	rts

00000e8e <startNewFunctionNum>:

int startNewFunctionNum (unsigned int funcNum, unsigned int numParamsExpected, struct loadedFunction * calledBy, struct variableStack * vStack, BOOL returnSommet) {
     e8e:	             lea -20(sp),sp
     e92:	             move.l a6,-(sp)
     e94:	             move.l 44(sp),d0
     e98:	             move.w d0,d0
     e9a:	             move.w d0,6(sp)
	struct loadedFunction * newFunc = AllocVec(sizeof(struct loadedFunction),MEMF_ANY);
     e9e:	             moveq #54,d0
     ea0:	             move.l d0,20(sp)
     ea4:	             clr.l 16(sp)
     ea8:	             move.l 755e <SysBase>,d0
     eae:	             movea.l d0,a6
     eb0:	             move.l 20(sp),d0
     eb4:	             move.l 16(sp),d1
     eb8:	             jsr -684(a6)
     ebc:	             move.l d0,12(sp)
     ec0:	             move.l 12(sp),d0
     ec4:	             move.l d0,8(sp)
	if(!newFunc) {
     ec8:	         /-- bne.s ede <startNewFunctionNum+0x50>
		KPrintF("startNewFunction: Cannot allocate memory");
     eca:	         |   pea 36a0 <PutChar+0x296>
     ed0:	         |   jsr 3168 <KPrintF>
     ed6:	         |   addq.l #4,sp
		return 0;
     ed8:	         |   moveq #0,d0
     eda:	/--------|-- bra.w ff8 <startNewFunctionNum+0x16a>
	}
	newFunc -> originalNumber = funcNum;
     ede:	|        \-> move.l 28(sp),d0
     ee2:	|            movea.l 8(sp),a0
     ee6:	|            move.l d0,(a0)

	loadFunctionCode (newFunc);
     ee8:	|            move.l 8(sp),-(sp)
     eec:	|            jsr 91a <loadFunctionCode>
     ef2:	|            addq.l #4,sp

	if (newFunc -> numArgs != (int)numParamsExpected) {
     ef4:	|            movea.l 8(sp),a0
     ef8:	|            move.l 16(a0),d1
     efc:	|            move.l 32(sp),d0
     f00:	|            cmp.l d1,d0
     f02:	|        /-- beq.s f18 <startNewFunctionNum+0x8a>
		KPrintF("Wrong number of parameters!");
     f04:	|        |   pea 36c9 <PutChar+0x2bf>
     f0a:	|        |   jsr 3168 <KPrintF>
     f10:	|        |   addq.l #4,sp
		return NULL; 
     f12:	|        |   moveq #0,d0
     f14:	+--------|-- bra.w ff8 <startNewFunctionNum+0x16a>
	}
	if (newFunc -> numArgs > newFunc -> numLocals)  {
     f18:	|        \-> movea.l 8(sp),a0
     f1c:	|            move.l 16(a0),d1
     f20:	|            movea.l 8(sp),a0
     f24:	|            move.l 8(a0),d0
     f28:	|            cmp.l d1,d0
     f2a:	|  /-------- bge.s f96 <startNewFunctionNum+0x108>
		KPrintF ("More arguments than local variable space!");
     f2c:	|  |         pea 36e5 <PutChar+0x2db>
     f32:	|  |         jsr 3168 <KPrintF>
     f38:	|  |         addq.l #4,sp
		return NULL; 
     f3a:	|  |         moveq #0,d0
     f3c:	+--|-------- bra.w ff8 <startNewFunctionNum+0x16a>
	}
	
	// Now, lets copy the parameters from the calling function's stack...

	while (numParamsExpected) {
		numParamsExpected --;
     f40:	|  |  /----> subq.l #1,32(sp)
		if (vStack == NULL) {
     f44:	|  |  |      tst.l 40(sp)
     f48:	|  |  |  /-- bne.s f5e <startNewFunctionNum+0xd0>
			KPrintF("Corrupted file! The stack's empty and there were still parameters expected");
     f4a:	|  |  |  |   pea 370f <PutChar+0x305>
     f50:	|  |  |  |   jsr 3168 <KPrintF>
     f56:	|  |  |  |   addq.l #4,sp
			return NULL;
     f58:	|  |  |  |   moveq #0,d0
     f5a:	+--|--|--|-- bra.w ff8 <startNewFunctionNum+0x16a>
		}
		copyVariable (vStack -> thisVar, newFunc -> localVars[numParamsExpected]);
     f5e:	|  |  |  \-> movea.l 8(sp),a0
     f62:	|  |  |      move.l 20(a0),d1
     f66:	|  |  |      move.l 32(sp),d0
     f6a:	|  |  |      lsl.l #3,d0
     f6c:	|  |  |      movea.l d1,a0
     f6e:	|  |  |      adda.l d0,a0
     f70:	|  |  |      move.l 4(a0),-(sp)
     f74:	|  |  |      move.l (a0),-(sp)
     f76:	|  |  |      movea.l 48(sp),a0
     f7a:	|  |  |      move.l 4(a0),-(sp)
     f7e:	|  |  |      move.l (a0),-(sp)
     f80:	|  |  |      jsr 3040 <copyVariable>
     f86:	|  |  |      lea 16(sp),sp
		trimStack (vStack);
     f8a:	|  |  |      move.l 40(sp),-(sp)
     f8e:	|  |  |      jsr 306c <trimStack>
     f94:	|  |  |      addq.l #4,sp
	while (numParamsExpected) {
     f96:	|  \--|----> tst.l 32(sp)
     f9a:	|     \----- bne.s f40 <startNewFunctionNum+0xb2>
	}

	newFunc -> cancelMe = FALSE;
     f9c:	|            movea.l 8(sp),a0
     fa0:	|            clr.w 50(a0)
	newFunc -> timeLeft = 0;
     fa4:	|            movea.l 8(sp),a0
     fa8:	|            clr.l 12(a0)
	newFunc -> returnSomething = returnSommet;
     fac:	|            movea.l 8(sp),a0
     fb0:	|            move.w 6(sp),44(a0)
	newFunc -> calledBy = calledBy;
     fb6:	|            movea.l 8(sp),a0
     fba:	|            move.l 36(sp),36(a0)
	newFunc -> stack = NULL;
     fc0:	|            movea.l 8(sp),a0
     fc4:	|            clr.l 24(a0)
	newFunc -> freezerLevel = 0;
     fc8:	|            movea.l 8(sp),a0
     fcc:	|            clr.b 52(a0)
	newFunc -> runThisLine = 0;
     fd0:	|            movea.l 8(sp),a0
     fd4:	|            clr.l 32(a0)
	newFunc -> isSpeech = 0;
     fd8:	|            movea.l 8(sp),a0
     fdc:	|            clr.w 46(a0)
	newFunc -> reg -> varType = SVT_NULL;
     fe0:	|            movea.l 8(sp),a0
     fe4:	|            movea.l 28(a0),a0
     fe8:	|            clr.l (a0)

	restartFunction (newFunc);
     fea:	|            move.l 8(sp),-(sp)
     fee:	|            jsr e74 <restartFunction>
     ff4:	|            addq.l #4,sp
	return 1;
     ff6:	|            moveq #1,d0
}
     ff8:	\----------> movea.l (sp)+,a6
     ffa:	             lea 20(sp),sp
     ffe:	             rts

00001000 <main_sludge>:
char * gamePath = NULL;
char *bundleFolder;
int weAreDoneSoQuit;

int main_sludge(int argc, char *argv[])
{	
    1000:	          lea -40(sp),sp
    1004:	          movem.l d2-d3/a6,-(sp)
	/* Dimensions of our window. */
	//AMIGA TODO: Maybe remove as there will be no windowed mode
    winWidth = 320;
    1008:	          move.l #320,749a <winWidth>
    winHeight = 256;
    1012:	          move.l #256,749e <winHeight>

	char * sludgeFile;

	if(argc == 0) {
    101c:	          tst.l 56(sp)
    1020:	      /-- bne.s 1038 <main_sludge+0x38>
		bundleFolder = copyString("game/");
    1022:	      |   pea 375a <PutChar+0x350>
    1028:	      |   jsr 2d32 <copyString>
    102e:	      |   addq.l #4,sp
    1030:	      |   move.l d0,74e6 <bundleFolder>
    1036:	   /--|-- bra.s 104e <main_sludge+0x4e>
	} else {
		bundleFolder = copyString(argv[0]);
    1038:	   |  \-> movea.l 60(sp),a0
    103c:	   |      move.l (a0),d0
    103e:	   |      move.l d0,-(sp)
    1040:	   |      jsr 2d32 <copyString>
    1046:	   |      addq.l #4,sp
    1048:	   |      move.l d0,74e6 <bundleFolder>
	}
    
	int lastSlash = -1;
    104e:	   \----> moveq #-1,d0
    1050:	          move.l d0,44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
    1054:	          clr.l 40(sp)
    1058:	   /----- bra.s 107a <main_sludge+0x7a>
		if (bundleFolder[i] == PATHSLASH) lastSlash = i;
    105a:	/--|----> move.l 74e6 <bundleFolder>,d1
    1060:	|  |      move.l 40(sp),d0
    1064:	|  |      movea.l d1,a0
    1066:	|  |      adda.l d0,a0
    1068:	|  |      move.b (a0),d0
    106a:	|  |      cmpi.b #47,d0
    106e:	|  |  /-- bne.s 1076 <main_sludge+0x76>
    1070:	|  |  |   move.l 40(sp),44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
    1076:	|  |  \-> addq.l #1,40(sp)
    107a:	|  \----> move.l 74e6 <bundleFolder>,d1
    1080:	|         move.l 40(sp),d0
    1084:	|         movea.l d1,a0
    1086:	|         adda.l d0,a0
    1088:	|         move.b (a0),d0
    108a:	\-------- bne.s 105a <main_sludge+0x5a>
	}
	bundleFolder[lastSlash+1] = NULL;
    108c:	          move.l 74e6 <bundleFolder>,d0
    1092:	          move.l 44(sp),d1
    1096:	          addq.l #1,d1
    1098:	          movea.l d0,a0
    109a:	          adda.l d1,a0
    109c:	          clr.b (a0)

	if (argc > 1) {
    109e:	          moveq #1,d0
    10a0:	          cmp.l 56(sp),d0
    10a4:	      /-- bge.s 10c0 <main_sludge+0xc0>
		sludgeFile = argv[argc - 1];
    10a6:	      |   move.l 56(sp),d0
    10aa:	      |   addi.l #1073741823,d0
    10b0:	      |   add.l d0,d0
    10b2:	      |   add.l d0,d0
    10b4:	      |   movea.l 60(sp),a0
    10b8:	      |   adda.l d0,a0
    10ba:	      |   move.l (a0),48(sp)
    10be:	   /--|-- bra.s 111a <main_sludge+0x11a>
	} else {
		sludgeFile = joinStrings (bundleFolder, "gamedata.slg");
    10c0:	   |  \-> move.l 74e6 <bundleFolder>,d0
    10c6:	   |      pea 3760 <PutChar+0x356>
    10cc:	   |      move.l d0,-(sp)
    10ce:	   |      jsr 2da0 <joinStrings>
    10d4:	   |      addq.l #8,sp
    10d6:	   |      move.l d0,48(sp)
		if (! ( fileExists (sludgeFile) ) ) {
    10da:	   |      move.l 48(sp),-(sp)
    10de:	   |      jsr 2c48 <fileExists>
    10e4:	   |      addq.l #4,sp
    10e6:	   |      tst.b d0
    10e8:	   +----- bne.s 111a <main_sludge+0x11a>
			FreeVec(sludgeFile);
    10ea:	   |      move.l 48(sp),36(sp)
    10f0:	   |      move.l 755e <SysBase>,d0
    10f6:	   |      movea.l d0,a6
    10f8:	   |      movea.l 36(sp),a1
    10fc:	   |      jsr -690(a6)
			sludgeFile = joinStrings (bundleFolder, "gamedata");			
    1100:	   |      move.l 74e6 <bundleFolder>,d0
    1106:	   |      pea 376d <PutChar+0x363>
    110c:	   |      move.l d0,-(sp)
    110e:	   |      jsr 2da0 <joinStrings>
    1114:	   |      addq.l #8,sp
    1116:	   |      move.l d0,48(sp)
	//AMIGA TODO: Show arguments
	/*if (! parseCmdlineParameters(argc, argv) && !(sludgeFile) ) {
		printCmdlineUsage();
		return 0;
	}*/
	if (! fileExists(sludgeFile) ) {	
    111a:	   \----> move.l 48(sp),-(sp)
    111e:	          jsr 2c48 <fileExists>
    1124:	          addq.l #4,sp
    1126:	          tst.b d0
    1128:	      /-- bne.s 1172 <main_sludge+0x172>
		Write(Output(), (APTR)"Game file not found.\n", 21);
    112a:	      |   move.l 7566 <DOSBase>,d0
    1130:	      |   movea.l d0,a6
    1132:	      |   jsr -60(a6)
    1136:	      |   move.l d0,28(sp)
    113a:	      |   move.l 28(sp),d0
    113e:	      |   move.l d0,24(sp)
    1142:	      |   move.l #14198,20(sp)
    114a:	      |   moveq #21,d0
    114c:	      |   move.l d0,16(sp)
    1150:	      |   move.l 7566 <DOSBase>,d0
    1156:	      |   movea.l d0,a6
    1158:	      |   move.l 24(sp),d1
    115c:	      |   move.l 20(sp),d2
    1160:	      |   move.l 16(sp),d3
    1164:	      |   jsr -48(a6)
    1168:	      |   move.l d0,12(sp)
		//AMIGA TODO: Show arguments
		//printCmdlineUsage();
		return 0;
    116c:	      |   moveq #0,d0
    116e:	   /--|-- bra.w 127c <main_sludge+0x27c>
	}

	setGameFilePath (sludgeFile);
    1172:	   |  \-> move.l 48(sp),-(sp)
    1176:	   |      jsr 1286 <setGameFilePath>
    117c:	   |      addq.l #4,sp
	if (! initSludge (sludgeFile)) return 0;
    117e:	   |      move.l 48(sp),-(sp)
    1182:	   |      jsr 1ac <initSludge>
    1188:	   |      addq.l #4,sp
    118a:	   |      tst.w d0
    118c:	   |  /-- bne.s 1194 <main_sludge+0x194>
    118e:	   |  |   moveq #0,d0
    1190:	   +--|-- bra.w 127c <main_sludge+0x27c>
	
	if (! resizeBackdrop (winWidth, winHeight)) {
    1194:	   |  \-> move.l 749e <winHeight>,d0
    119a:	   |      move.l d0,d1
    119c:	   |      move.l 749a <winWidth>,d0
    11a2:	   |      move.l d1,-(sp)
    11a4:	   |      move.l d0,-(sp)
    11a6:	   |      jsr 1fde <resizeBackdrop>
    11ac:	   |      addq.l #8,sp
    11ae:	   |      tst.w d0
    11b0:	   |  /-- bne.s 11c6 <main_sludge+0x1c6>
		KPrintF("Couldn't allocate memory for backdrop");
    11b2:	   |  |   pea 378c <PutChar+0x382>
    11b8:	   |  |   jsr 3168 <KPrintF>
    11be:	   |  |   addq.l #4,sp
		return FALSE;
    11c0:	   |  |   moveq #0,d0
    11c2:	   +--|-- bra.w 127c <main_sludge+0x27c>
	}

	if (! initPeople ())
    11c6:	   |  \-> jsr 1eb2 <initPeople>
    11cc:	   |      tst.w d0
    11ce:	   |  /-- bne.s 11e4 <main_sludge+0x1e4>
	{
		KPrintF("Couldn't initialise people stuff");
    11d0:	   |  |   pea 37b2 <PutChar+0x3a8>
    11d6:	   |  |   jsr 3168 <KPrintF>
    11dc:	   |  |   addq.l #4,sp
		return FALSE;
    11de:	   |  |   moveq #0,d0
    11e0:	   +--|-- bra.w 127c <main_sludge+0x27c>
	}

	if (! initFloor ())
    11e4:	   |  \-> jsr 30dc <initFloor>
    11ea:	   |      tst.w d0
    11ec:	   |  /-- bne.s 1200 <main_sludge+0x200>
	{
		KPrintF("Couldn't initialise floor stuff");
    11ee:	   |  |   pea 37d3 <PutChar+0x3c9>
    11f4:	   |  |   jsr 3168 <KPrintF>
    11fa:	   |  |   addq.l #4,sp
		return FALSE;
    11fc:	   |  |   moveq #0,d0
    11fe:	   +--|-- bra.s 127c <main_sludge+0x27c>
	}

	if (! initObjectTypes ())
    1200:	   |  \-> jsr 2606 <initObjectTypes>
    1206:	   |      tst.w d0
    1208:	   |  /-- bne.s 121c <main_sludge+0x21c>
	{
		KPrintF("Couldn't initialise object type stuff");
    120a:	   |  |   pea 37f3 <PutChar+0x3e9>
    1210:	   |  |   jsr 3168 <KPrintF>
    1216:	   |  |   addq.l #4,sp
		return FALSE;
    1218:	   |  |   moveq #0,d0
    121a:	   +--|-- bra.s 127c <main_sludge+0x27c>
	}

	initSpeech ();
    121c:	   |  \-> jsr 1c4c <initSpeech>
	initStatusBar ();
    1222:	   |      jsr 1bfc <initStatusBar>

	gameName = getNumberedString(1);
    1228:	   |      pea 1 <_start+0x1>
    122c:	   |      jsr 1524 <getNumberedString>
    1232:	   |      addq.l #4,sp
    1234:	   |      move.l d0,74de <gameName>
	//initSoundStuff (hMainWindow); Todo Amiga: Maybe move soundstuff here
	startNewFunctionNum (0, 0, NULL, noStack, TRUE);
    123a:	   |      move.l 74ce <noStack>,d0
    1240:	   |      pea 1 <_start+0x1>
    1244:	   |      move.l d0,-(sp)
    1246:	   |      clr.l -(sp)
    1248:	   |      clr.l -(sp)
    124a:	   |      clr.l -(sp)
    124c:	   |      jsr e8e <startNewFunctionNum>
    1252:	   |      lea 20(sp),sp

	weAreDoneSoQuit = 0;
    1256:	   |      clr.l 74ea <weAreDoneSoQuit>
	while ( !weAreDoneSoQuit ) {
    125c:	   |      nop
    125e:	   |  /-> move.l 74ea <weAreDoneSoQuit>,d0
    1264:	   |  \-- beq.s 125e <main_sludge+0x25e>
	}
	//Amiga Cleanup
	FreeVec(sludgeFile);
    1266:	   |      move.l 48(sp),32(sp)
    126c:	   |      move.l 755e <SysBase>,d0
    1272:	   |      movea.l d0,a6
    1274:	   |      movea.l 32(sp),a1
    1278:	   |      jsr -690(a6)
}
    127c:	   \----> movem.l (sp)+,d2-d3/a6
    1280:	          lea 40(sp),sp
    1284:	          rts

00001286 <setGameFilePath>:

void setGameFilePath (char * f) {
    1286:	          lea -1104(sp),sp
    128a:	          move.l a6,-(sp)
    128c:	          move.l d2,-(sp)
	char currentDir[1000];

	if (!GetCurrentDirName( currentDir, 998)) {
    128e:	          move.l #1112,d0
    1294:	          add.l sp,d0
    1296:	          addi.l #-1102,d0
    129c:	          move.l d0,1100(sp)
    12a0:	          move.l #998,1096(sp)
    12a8:	          move.l 7566 <DOSBase>,d0
    12ae:	          movea.l d0,a6
    12b0:	          move.l 1100(sp),d1
    12b4:	          move.l 1096(sp),d2
    12b8:	          jsr -564(a6)
    12bc:	          move.w d0,1094(sp)
    12c0:	          move.w 1094(sp),d0
    12c4:	      /-- bne.s 12d4 <setGameFilePath+0x4e>
		KPrintF("setGameFilePath: Can't get current directory.\n");
    12c6:	      |   pea 3819 <PutChar+0x40f>
    12cc:	      |   jsr 3168 <KPrintF>
    12d2:	      |   addq.l #4,sp
	}	

	int got = -1, a;	
    12d4:	      \-> moveq #-1,d0
    12d6:	          move.l d0,1108(sp)

	for (a = 0; f[a]; a ++) {
    12da:	          clr.l 1104(sp)
    12de:	   /----- bra.s 12fc <setGameFilePath+0x76>
		if (f[a] == PATHSLASH) got = a;
    12e0:	/--|----> move.l 1104(sp),d0
    12e4:	|  |      movea.l 1116(sp),a0
    12e8:	|  |      adda.l d0,a0
    12ea:	|  |      move.b (a0),d0
    12ec:	|  |      cmpi.b #47,d0
    12f0:	|  |  /-- bne.s 12f8 <setGameFilePath+0x72>
    12f2:	|  |  |   move.l 1104(sp),1108(sp)
	for (a = 0; f[a]; a ++) {
    12f8:	|  |  \-> addq.l #1,1104(sp)
    12fc:	|  \----> move.l 1104(sp),d0
    1300:	|         movea.l 1116(sp),a0
    1304:	|         adda.l d0,a0
    1306:	|         move.b (a0),d0
    1308:	\-------- bne.s 12e0 <setGameFilePath+0x5a>
	}

	if (got != -1) {
    130a:	          moveq #-1,d0
    130c:	          cmp.l 1108(sp),d0
    1310:	   /----- beq.s 138a <setGameFilePath+0x104>
		f[got] = 0;	
    1312:	   |      move.l 1108(sp),d0
    1316:	   |      movea.l 1116(sp),a0
    131a:	   |      adda.l d0,a0
    131c:	   |      clr.b (a0)
		BPTR lock = Lock(f, ACCESS_READ);	
    131e:	   |      move.l 1116(sp),1090(sp)
    1324:	   |      moveq #-2,d0
    1326:	   |      move.l d0,1086(sp)
    132a:	   |      move.l 7566 <DOSBase>,d0
    1330:	   |      movea.l d0,a6
    1332:	   |      move.l 1090(sp),d1
    1336:	   |      move.l 1086(sp),d2
    133a:	   |      jsr -84(a6)
    133e:	   |      move.l d0,1082(sp)
    1342:	   |      move.l 1082(sp),d0
    1346:	   |      move.l d0,1078(sp)
		if (!CurrentDir(lock)) {
    134a:	   |      move.l 1078(sp),1074(sp)
    1350:	   |      move.l 7566 <DOSBase>,d0
    1356:	   |      movea.l d0,a6
    1358:	   |      move.l 1074(sp),d1
    135c:	   |      jsr -126(a6)
    1360:	   |      move.l d0,1070(sp)
    1364:	   |      move.l 1070(sp),d0
    1368:	   |  /-- bne.s 137c <setGameFilePath+0xf6>
			KPrintF("setGameFilePath:: Failed changing to directory %s\n", f);
    136a:	   |  |   move.l 1116(sp),-(sp)
    136e:	   |  |   pea 3848 <PutChar+0x43e>
    1374:	   |  |   jsr 3168 <KPrintF>
    137a:	   |  |   addq.l #8,sp
		}
		f[got] = PATHSLASH;
    137c:	   |  \-> move.l 1108(sp),d0
    1380:	   |      movea.l 1116(sp),a0
    1384:	   |      adda.l d0,a0
    1386:	   |      move.b #47,(a0)
	}

	gamePath = AllocVec(400, MEMF_ANY);
    138a:	   \----> move.l #400,1066(sp)
    1392:	          clr.l 1062(sp)
    1396:	          move.l 755e <SysBase>,d0
    139c:	          movea.l d0,a6
    139e:	          move.l 1066(sp),d0
    13a2:	          move.l 1062(sp),d1
    13a6:	          jsr -684(a6)
    13aa:	          move.l d0,1058(sp)
    13ae:	          move.l 1058(sp),d0
    13b2:	          move.l d0,74e2 <gamePath>
	if (gamePath==0) {
    13b8:	          move.l 74e2 <gamePath>,d0
    13be:	      /-- bne.s 13d2 <setGameFilePath+0x14c>
		KPrintF("setGameFilePath: Can't reserve memory for game directory.\n");
    13c0:	      |   pea 387b <PutChar+0x471>
    13c6:	      |   jsr 3168 <KPrintF>
    13cc:	      |   addq.l #4,sp
    13ce:	   /--|-- bra.w 14ba <setGameFilePath+0x234>
		return;
	}

	BPTR lock = Lock(gamePath, ACCESS_READ);	
    13d2:	   |  \-> move.l 74e2 <gamePath>,1054(sp)
    13da:	   |      moveq #-2,d0
    13dc:	   |      move.l d0,1050(sp)
    13e0:	   |      move.l 7566 <DOSBase>,d0
    13e6:	   |      movea.l d0,a6
    13e8:	   |      move.l 1054(sp),d1
    13ec:	   |      move.l 1050(sp),d2
    13f0:	   |      jsr -84(a6)
    13f4:	   |      move.l d0,1046(sp)
    13f8:	   |      move.l 1046(sp),d0
    13fc:	   |      move.l d0,1042(sp)
	if (! CurrentDir(lock)) {
    1400:	   |      move.l 1042(sp),1038(sp)
    1406:	   |      move.l 7566 <DOSBase>,d0
    140c:	   |      movea.l d0,a6
    140e:	   |      move.l 1038(sp),d1
    1412:	   |      jsr -126(a6)
    1416:	   |      move.l d0,1034(sp)
    141a:	   |      move.l 1034(sp),d0
    141e:	   |  /-- bne.s 142e <setGameFilePath+0x1a8>
		KPrintF("setGameFilePath: Can't get game directory.\n");
    1420:	   |  |   pea 38b6 <PutChar+0x4ac>
    1426:	   |  |   jsr 3168 <KPrintF>
    142c:	   |  |   addq.l #4,sp
	}
	
	lock = Lock(currentDir, ACCESS_READ);	
    142e:	   |  \-> move.l #1112,d0
    1434:	   |      add.l sp,d0
    1436:	   |      addi.l #-1102,d0
    143c:	   |      move.l d0,1030(sp)
    1440:	   |      moveq #-2,d0
    1442:	   |      move.l d0,1026(sp)
    1446:	   |      move.l 7566 <DOSBase>,d0
    144c:	   |      movea.l d0,a6
    144e:	   |      move.l 1030(sp),d1
    1452:	   |      move.l 1026(sp),d2
    1456:	   |      jsr -84(a6)
    145a:	   |      move.l d0,1022(sp)
    145e:	   |      move.l 1022(sp),d0
    1462:	   |      move.l d0,1042(sp)
	if (!CurrentDir(lock)) {	
    1466:	   |      move.l 1042(sp),1018(sp)
    146c:	   |      move.l 7566 <DOSBase>,d0
    1472:	   |      movea.l d0,a6
    1474:	   |      move.l 1018(sp),d1
    1478:	   |      jsr -126(a6)
    147c:	   |      move.l d0,1014(sp)
    1480:	   |      move.l 1014(sp),d0
    1484:	   |  /-- bne.s 149a <setGameFilePath+0x214>
		KPrintF("setGameFilePath: Failed changing to directory %s\n", currentDir);
    1486:	   |  |   moveq #10,d0
    1488:	   |  |   add.l sp,d0
    148a:	   |  |   move.l d0,-(sp)
    148c:	   |  |   pea 38e2 <PutChar+0x4d8>
    1492:	   |  |   jsr 3168 <KPrintF>
    1498:	   |  |   addq.l #8,sp
	}

	//Free Mem
	if (gamePath != 0) FreeVec(gamePath);
    149a:	   |  \-> move.l 74e2 <gamePath>,d0
    14a0:	   +----- beq.s 14ba <setGameFilePath+0x234>
    14a2:	   |      move.l 74e2 <gamePath>,1010(sp)
    14aa:	   |      move.l 755e <SysBase>,d0
    14b0:	   |      movea.l d0,a6
    14b2:	   |      movea.l 1010(sp),a1
    14b6:	   |      jsr -690(a6)
}
    14ba:	   \----> move.l (sp)+,d2
    14bc:	          movea.l (sp)+,a6
    14be:	          lea 1104(sp),sp
    14c2:	          rts

000014c4 <killZBuffer>:
#include "zbuffer.h"
#include "graphics.h"

struct zBufferData zBuffer;

void killZBuffer () {
    14c4:	    subq.l #4,sp
    14c6:	    move.l a6,-(sp)
	if (zBuffer.tex) {
    14c8:	    move.l 753e <zBuffer+0x50>,d0
    14ce:	/-- beq.s 1506 <killZBuffer+0x42>
		deleteTextures (1, &zBuffer.texName);
    14d0:	|   pea 7542 <zBuffer+0x54>
    14d6:	|   pea 1 <_start+0x1>
    14da:	|   jsr b8 <deleteTextures>
    14e0:	|   addq.l #8,sp
		zBuffer.texName = 0;
    14e2:	|   clr.l 7542 <zBuffer+0x54>
        FreeVec(zBuffer.tex);
    14e8:	|   move.l 753e <zBuffer+0x50>,4(sp)
    14f0:	|   move.l 755e <SysBase>,d0
    14f6:	|   movea.l d0,a6
    14f8:	|   movea.l 4(sp),a1
    14fc:	|   jsr -690(a6)
		zBuffer.tex = NULL;
    1500:	|   clr.l 753e <zBuffer+0x50>
	}
	zBuffer.numPanels = 0;
    1506:	\-> clr.l 74f6 <zBuffer+0x8>
	zBuffer.originalNum =0;
    150c:	    clr.l 753a <zBuffer+0x4c>
    1512:	    nop
    1514:	    movea.l (sp)+,a6
    1516:	    addq.l #4,sp
    1518:	    rts

0000151a <finishAccess>:
char * convertString(char * s) {
	return NULL;
}

void finishAccess () {
	sliceBusy = FALSE;
    151a:	clr.w 6008 <sliceBusy>
}
    1520:	nop
    1522:	rts

00001524 <getNumberedString>:

char * getNumberedString (int value) {
    1524:	       lea -56(sp),sp
    1528:	       movem.l d2-d3/a6,-(sp)

	if (sliceBusy) {
    152c:	       move.w 6008 <sliceBusy>,d0
    1532:	   /-- beq.s 157c <getNumberedString+0x58>
		Write(Output(), (APTR)"getNumberedString: Can't read from data file. I'm already reading something\n", 76);        
    1534:	   |   move.l 7566 <DOSBase>,d0
    153a:	   |   movea.l d0,a6
    153c:	   |   jsr -60(a6)
    1540:	   |   move.l d0,28(sp)
    1544:	   |   move.l 28(sp),d0
    1548:	   |   move.l d0,24(sp)
    154c:	   |   move.l #14612,20(sp)
    1554:	   |   moveq #76,d0
    1556:	   |   move.l d0,16(sp)
    155a:	   |   move.l 7566 <DOSBase>,d0
    1560:	   |   movea.l d0,a6
    1562:	   |   move.l 24(sp),d1
    1566:	   |   move.l 20(sp),d2
    156a:	   |   move.l 16(sp),d3
    156e:	   |   jsr -48(a6)
    1572:	   |   move.l d0,12(sp)
		return NULL;
    1576:	   |   moveq #0,d0
    1578:	/--|-- bra.w 1618 <getNumberedString+0xf4>
	}

	Seek(bigDataFile, (value << 2) + startOfTextIndex, OFFSET_BEGINNING);
    157c:	|  \-> move.l 7546 <bigDataFile>,64(sp)
    1584:	|      move.l 72(sp),d0
    1588:	|      add.l d0,d0
    158a:	|      add.l d0,d0
    158c:	|      move.l d0,d1
    158e:	|      move.l 7552 <startOfTextIndex>,d0
    1594:	|      add.l d1,d0
    1596:	|      move.l d0,60(sp)
    159a:	|      moveq #-1,d0
    159c:	|      move.l d0,56(sp)
    15a0:	|      move.l 7566 <DOSBase>,d0
    15a6:	|      movea.l d0,a6
    15a8:	|      move.l 64(sp),d1
    15ac:	|      move.l 60(sp),d2
    15b0:	|      move.l 56(sp),d3
    15b4:	|      jsr -66(a6)
    15b8:	|      move.l d0,52(sp)
	value = get4bytes (bigDataFile);
    15bc:	|      move.l 7546 <bigDataFile>,d0
    15c2:	|      move.l d0,-(sp)
    15c4:	|      jsr 2422 <get4bytes>
    15ca:	|      addq.l #4,sp
    15cc:	|      move.l d0,72(sp)
	Seek (bigDataFile, value, OFFSET_BEGINING);
    15d0:	|      move.l 7546 <bigDataFile>,48(sp)
    15d8:	|      move.l 72(sp),44(sp)
    15de:	|      moveq #-1,d0
    15e0:	|      move.l d0,40(sp)
    15e4:	|      move.l 7566 <DOSBase>,d0
    15ea:	|      movea.l d0,a6
    15ec:	|      move.l 48(sp),d1
    15f0:	|      move.l 44(sp),d2
    15f4:	|      move.l 40(sp),d3
    15f8:	|      jsr -66(a6)
    15fc:	|      move.l d0,36(sp)

	char * s = readString (bigDataFile);    
    1600:	|      move.l 7546 <bigDataFile>,d0
    1606:	|      move.l d0,-(sp)
    1608:	|      jsr 255e <readString>
    160e:	|      addq.l #4,sp
    1610:	|      move.l d0,32(sp)
	
	return s;
    1614:	|      move.l 32(sp),d0
}
    1618:	\----> movem.l (sp)+,d2-d3/a6
    161c:	       lea 56(sp),sp
    1620:	       rts

00001622 <openSubSlice>:


BOOL openSubSlice (int num) {
    1622:	       lea -32(sp),sp
    1626:	       movem.l d2-d3/a6,-(sp)
//	FILE * dbug = fopen ("debuggy.txt", "at");

//	fprintf (dbug, "\nTrying to open sub %i\n", num);

	if (sliceBusy) {
    162a:	       move.w 6008 <sliceBusy>,d0
    1630:	   /-- beq.s 164c <openSubSlice+0x2a>
		KPrintF("Can't read from data file", "I'm already reading something");
    1632:	   |   pea 3961 <PutChar+0x557>
    1638:	   |   pea 397f <PutChar+0x575>
    163e:	   |   jsr 3168 <KPrintF>
    1644:	   |   addq.l #8,sp
		return FALSE;
    1646:	   |   clr.w d0
    1648:	/--|-- bra.w 16d8 <openSubSlice+0xb6>
	}

//	fprintf (dbug, "Going to position %li\n", startOfSubIndex + (num << 2));
	Seek(bigDataFile, startOfSubIndex + (num << 2), OFFSET_BEGINNING);
    164c:	|  \-> move.l 7546 <bigDataFile>,40(sp)
    1654:	|      move.l 48(sp),d0
    1658:	|      add.l d0,d0
    165a:	|      add.l d0,d0
    165c:	|      move.l d0,d1
    165e:	|      move.l 7556 <startOfSubIndex>,d0
    1664:	|      add.l d1,d0
    1666:	|      move.l d0,36(sp)
    166a:	|      moveq #-1,d0
    166c:	|      move.l d0,32(sp)
    1670:	|      move.l 7566 <DOSBase>,d0
    1676:	|      movea.l d0,a6
    1678:	|      move.l 40(sp),d1
    167c:	|      move.l 36(sp),d2
    1680:	|      move.l 32(sp),d3
    1684:	|      jsr -66(a6)
    1688:	|      move.l d0,28(sp)
	Seek(bigDataFile, get4bytes (bigDataFile), OFFSET_BEGINNING);
    168c:	|      move.l 7546 <bigDataFile>,24(sp)
    1694:	|      move.l 7546 <bigDataFile>,d0
    169a:	|      move.l d0,-(sp)
    169c:	|      jsr 2422 <get4bytes>
    16a2:	|      addq.l #4,sp
    16a4:	|      move.l d0,20(sp)
    16a8:	|      moveq #-1,d0
    16aa:	|      move.l d0,16(sp)
    16ae:	|      move.l 7566 <DOSBase>,d0
    16b4:	|      movea.l d0,a6
    16b6:	|      move.l 24(sp),d1
    16ba:	|      move.l 20(sp),d2
    16be:	|      move.l 16(sp),d3
    16c2:	|      jsr -66(a6)
    16c6:	|      move.l d0,12(sp)
//	fprintf (dbug, "Told to skip forward to %li\n", ftell (bigDataFile));
//	fclose (dbug);
	return sliceBusy = TRUE;
    16ca:	|      move.w #1,6008 <sliceBusy>
    16d2:	|      move.w 6008 <sliceBusy>,d0
}
    16d8:	\----> movem.l (sp)+,d2-d3/a6
    16dc:	       lea 32(sp),sp
    16e0:	       rts

000016e2 <setFileIndices>:

void setFileIndices (BPTR fp, unsigned int numLanguages, unsigned int skipBefore) {
    16e2:	       lea -180(sp),sp
    16e6:	       movem.l d2-d3/a6,-(sp)
	if (fp) {
    16ea:	       tst.l 196(sp)
    16ee:	/----- beq.s 172e <setFileIndices+0x4c>
		// Keep hold of the file handle, and let things get at it
		bigDataFile = fp;
    16f0:	|      move.l 196(sp),7546 <bigDataFile>
		startIndex = Seek( fp, 0, OFFSET_CURRENT);
    16f8:	|      move.l 196(sp),168(sp)
    16fe:	|      clr.l 164(sp)
    1702:	|      clr.l 160(sp)
    1706:	|      move.l 7566 <DOSBase>,d0
    170c:	|      movea.l d0,a6
    170e:	|      move.l 168(sp),d1
    1712:	|      move.l 164(sp),d2
    1716:	|      move.l 160(sp),d3
    171a:	|      jsr -66(a6)
    171e:	|      move.l d0,156(sp)
    1722:	|      move.l 156(sp),d0
    1726:	|      move.l d0,754a <startIndex>
    172c:	|  /-- bra.s 1768 <setFileIndices+0x86>
	} else {
		// No file pointer - this means that we reuse the bigDataFile
		fp = bigDataFile;
    172e:	\--|-> move.l 7546 <bigDataFile>,196(sp)
        Seek(fp, startIndex, OFFSET_BEGINNING);
    1736:	   |   move.l 196(sp),184(sp)
    173c:	   |   move.l 754a <startIndex>,d0
    1742:	   |   move.l d0,180(sp)
    1746:	   |   moveq #-1,d0
    1748:	   |   move.l d0,176(sp)
    174c:	   |   move.l 7566 <DOSBase>,d0
    1752:	   |   movea.l d0,a6
    1754:	   |   move.l 184(sp),d1
    1758:	   |   move.l 180(sp),d2
    175c:	   |   move.l 176(sp),d3
    1760:	   |   jsr -66(a6)
    1764:	   |   move.l d0,172(sp)
	}
	sliceBusy = FALSE;
    1768:	   \-> clr.w 6008 <sliceBusy>

	if (skipBefore > numLanguages) {
    176e:	       move.l 204(sp),d0
    1772:	       cmp.l 200(sp),d0
    1776:	   /-- bls.s 178a <setFileIndices+0xa8>
		KPrintF("setFileIndices: Warning: Not a valid language ID! Using default instead.");
    1778:	   |   pea 3999 <PutChar+0x58f>
    177e:	   |   jsr 3168 <KPrintF>
    1784:	   |   addq.l #4,sp
		skipBefore = 0;
    1786:	   |   clr.l 204(sp)
	}

	// STRINGS
	int skipAfter = numLanguages - skipBefore;
    178a:	   \-> move.l 200(sp),d0
    178e:	       sub.l 204(sp),d0
    1792:	       move.l d0,188(sp)
	while (skipBefore) {
    1796:	   /-- bra.s 17d2 <setFileIndices+0xf0>
        Seek(fp, get4bytes(fp),0);		
    1798:	/--|-> move.l 196(sp),24(sp)
    179e:	|  |   move.l 196(sp),-(sp)
    17a2:	|  |   jsr 2422 <get4bytes>
    17a8:	|  |   addq.l #4,sp
    17aa:	|  |   move.l d0,20(sp)
    17ae:	|  |   clr.l 16(sp)
    17b2:	|  |   move.l 7566 <DOSBase>,d0
    17b8:	|  |   movea.l d0,a6
    17ba:	|  |   move.l 24(sp),d1
    17be:	|  |   move.l 20(sp),d2
    17c2:	|  |   move.l 16(sp),d3
    17c6:	|  |   jsr -66(a6)
    17ca:	|  |   move.l d0,12(sp)
		skipBefore --;
    17ce:	|  |   subq.l #1,204(sp)
	while (skipBefore) {
    17d2:	|  \-> tst.l 204(sp)
    17d6:	\----- bne.s 1798 <setFileIndices+0xb6>
	}
	startOfTextIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    17d8:	       move.l 196(sp),152(sp)
    17de:	       clr.l 148(sp)
    17e2:	       clr.l 144(sp)
    17e6:	       move.l 7566 <DOSBase>,d0
    17ec:	       movea.l d0,a6
    17ee:	       move.l 152(sp),d1
    17f2:	       move.l 148(sp),d2
    17f6:	       move.l 144(sp),d3
    17fa:	       jsr -66(a6)
    17fe:	       move.l d0,140(sp)
    1802:	       move.l 140(sp),d0
    1806:	       addq.l #4,d0
    1808:	       move.l d0,7552 <startOfTextIndex>

	Seek(fp, get4bytes (fp), OFFSET_BEGINNING);
    180e:	       move.l 196(sp),136(sp)
    1814:	       move.l 196(sp),-(sp)
    1818:	       jsr 2422 <get4bytes>
    181e:	       addq.l #4,sp
    1820:	       move.l d0,132(sp)
    1824:	       moveq #-1,d0
    1826:	       move.l d0,128(sp)
    182a:	       move.l 7566 <DOSBase>,d0
    1830:	       movea.l d0,a6
    1832:	       move.l 136(sp),d1
    1836:	       move.l 132(sp),d2
    183a:	       move.l 128(sp),d3
    183e:	       jsr -66(a6)
    1842:	       move.l d0,124(sp)

	while (skipAfter) {
    1846:	   /-- bra.s 1884 <setFileIndices+0x1a2>
        Seek( fp, get4bytes (fp), OFFSET_BEGINING);
    1848:	/--|-> move.l 196(sp),40(sp)
    184e:	|  |   move.l 196(sp),-(sp)
    1852:	|  |   jsr 2422 <get4bytes>
    1858:	|  |   addq.l #4,sp
    185a:	|  |   move.l d0,36(sp)
    185e:	|  |   moveq #-1,d0
    1860:	|  |   move.l d0,32(sp)
    1864:	|  |   move.l 7566 <DOSBase>,d0
    186a:	|  |   movea.l d0,a6
    186c:	|  |   move.l 40(sp),d1
    1870:	|  |   move.l 36(sp),d2
    1874:	|  |   move.l 32(sp),d3
    1878:	|  |   jsr -66(a6)
    187c:	|  |   move.l d0,28(sp)
		skipAfter --;
    1880:	|  |   subq.l #1,188(sp)
	while (skipAfter) {
    1884:	|  \-> tst.l 188(sp)
    1888:	\----- bne.s 1848 <setFileIndices+0x166>
	}

	startOfSubIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    188a:	       move.l 196(sp),120(sp)
    1890:	       clr.l 116(sp)
    1894:	       clr.l 112(sp)
    1898:	       move.l 7566 <DOSBase>,d0
    189e:	       movea.l d0,a6
    18a0:	       move.l 120(sp),d1
    18a4:	       move.l 116(sp),d2
    18a8:	       move.l 112(sp),d3
    18ac:	       jsr -66(a6)
    18b0:	       move.l d0,108(sp)
    18b4:	       move.l 108(sp),d0
    18b8:	       addq.l #4,d0
    18ba:	       move.l d0,7556 <startOfSubIndex>
    Seek( fp, get4bytes (fp), OFFSET_CURRENT);
    18c0:	       move.l 196(sp),104(sp)
    18c6:	       move.l 196(sp),-(sp)
    18ca:	       jsr 2422 <get4bytes>
    18d0:	       addq.l #4,sp
    18d2:	       move.l d0,100(sp)
    18d6:	       clr.l 96(sp)
    18da:	       move.l 7566 <DOSBase>,d0
    18e0:	       movea.l d0,a6
    18e2:	       move.l 104(sp),d1
    18e6:	       move.l 100(sp),d2
    18ea:	       move.l 96(sp),d3
    18ee:	       jsr -66(a6)
    18f2:	       move.l d0,92(sp)

	startOfObjectIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    18f6:	       move.l 196(sp),88(sp)
    18fc:	       clr.l 84(sp)
    1900:	       clr.l 80(sp)
    1904:	       move.l 7566 <DOSBase>,d0
    190a:	       movea.l d0,a6
    190c:	       move.l 88(sp),d1
    1910:	       move.l 84(sp),d2
    1914:	       move.l 80(sp),d3
    1918:	       jsr -66(a6)
    191c:	       move.l d0,76(sp)
    1920:	       move.l 76(sp),d0
    1924:	       addq.l #4,d0
    1926:	       move.l d0,755a <startOfObjectIndex>
	Seek (fp, get4bytes (fp), OFFSET_CURRENT);
    192c:	       move.l 196(sp),72(sp)
    1932:	       move.l 196(sp),-(sp)
    1936:	       jsr 2422 <get4bytes>
    193c:	       addq.l #4,sp
    193e:	       move.l d0,68(sp)
    1942:	       clr.l 64(sp)
    1946:	       move.l 7566 <DOSBase>,d0
    194c:	       movea.l d0,a6
    194e:	       move.l 72(sp),d1
    1952:	       move.l 68(sp),d2
    1956:	       move.l 64(sp),d3
    195a:	       jsr -66(a6)
    195e:	       move.l d0,60(sp)

	// Remember that the data section starts here
	startOfDataIndex =  Seek( fp, 0, OFFSET_CURRENT);
    1962:	       move.l 196(sp),56(sp)
    1968:	       clr.l 52(sp)
    196c:	       clr.l 48(sp)
    1970:	       move.l 7566 <DOSBase>,d0
    1976:	       movea.l d0,a6
    1978:	       move.l 56(sp),d1
    197c:	       move.l 52(sp),d2
    1980:	       move.l 48(sp),d3
    1984:	       jsr -66(a6)
    1988:	       move.l d0,44(sp)
    198c:	       move.l 44(sp),d0
    1990:	       move.l d0,754e <startOfDataIndex>
    1996:	       nop
    1998:	       movem.l (sp)+,d2-d3/a6
    199c:	       lea 180(sp),sp
    19a0:	       rts

000019a2 <WaitVbl>:
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
}

//vblank begins at vpos 312 hpos 1 and ends at vpos 25 hpos 1
//vsync begins at line 2 hpos 132 and ends at vpos 5 hpos 18 
void WaitVbl() {
    19a2:	       subq.l #8,sp
	debug_start_idle();
    19a4:	       jsr 3340 <debug_start_idle>
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    19aa:	   /-> movea.l #14675972,a0
    19b0:	   |   move.l (a0),d0
    19b2:	   |   move.l d0,(sp)
		vpos&=0x1ff00;
    19b4:	   |   move.l (sp),d0
    19b6:	   |   andi.l #130816,d0
    19bc:	   |   move.l d0,(sp)
		if (vpos!=(311<<8))
    19be:	   |   move.l (sp),d0
    19c0:	   |   cmpi.l #79616,d0
    19c6:	   \-- beq.s 19aa <WaitVbl+0x8>
			break;
	}
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    19c8:	/----> movea.l #14675972,a0
    19ce:	|      move.l (a0),d0
    19d0:	|      move.l d0,4(sp)
		vpos&=0x1ff00;
    19d4:	|      move.l 4(sp),d0
    19d8:	|      andi.l #130816,d0
    19de:	|      move.l d0,4(sp)
		if (vpos==(311<<8))
    19e2:	|      move.l 4(sp),d0
    19e6:	|      cmpi.l #79616,d0
    19ec:	|  /-- beq.s 19f0 <WaitVbl+0x4e>
	while (1) {
    19ee:	\--|-- bra.s 19c8 <WaitVbl+0x26>
			break;
    19f0:	   \-> nop
	}
	debug_stop_idle();
    19f2:	       jsr 335a <debug_stop_idle>
}
    19f8:	       nop
    19fa:	       addq.l #8,sp
    19fc:	       rts

000019fe <p61Init>:
	// The Player® 6.1A: Copyright © 1992-95 Jarno Paananen
	// P61.testmod - Module by Skylord/Sector 7 
	INCBIN(player, "player610.6.no_cia.bin")
	INCBIN_CHIP(module, "testmod.p61")

	int p61Init(const void* module) { // returns 0 if success, non-zero otherwise
    19fe:	move.l a3,-(sp)
    1a00:	move.l a2,-(sp)
		register volatile const void* _a0 ASM("a0") = module;
    1a02:	movea.l 12(sp),a0
		register volatile const void* _a1 ASM("a1") = NULL;
    1a06:	suba.l a1,a1
		register volatile const void* _a2 ASM("a2") = NULL;
    1a08:	suba.l a2,a2
		register volatile const void* _a3 ASM("a3") = player;
    1a0a:	move.l 600a <player>,d0
    1a10:	movea.l d0,a3
		register                int   _d0 ASM("d0"); // return value
		__asm volatile (
    1a12:	movem.l d1-d7/a4-a6,-(sp)
    1a16:	jsr (a3)
    1a18:	movem.l (sp)+,d1-d7/a4-a6
			"movem.l (%%sp)+,%%d1-%%d7/%%a4-%%a6"
		: "=r" (_d0), "+rf"(_a0), "+rf"(_a1), "+rf"(_a2), "+rf"(_a3)
		:
		: "cc", "memory");
		return _d0;
	}
    1a1c:	movea.l (sp)+,a2
    1a1e:	movea.l (sp)+,a3
    1a20:	rts

00001a22 <p61End>:
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}

	void p61End() {
    1a22:	move.l a6,-(sp)
    1a24:	move.l a3,-(sp)
		register volatile const void* _a3 ASM("a3") = player;
    1a26:	move.l 600a <player>,d0
    1a2c:	movea.l d0,a3
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
    1a2e:	movea.l #14675968,a6
		__asm volatile (
    1a34:	movem.l d0-d1/a0-a1,-(sp)
    1a38:	jsr 8(a3)
    1a3c:	movem.l (sp)+,d0-d1/a0-a1
			"jsr 8(%%a3)\n"
			"movem.l (%%sp)+,%%d0-%%d1/%%a0-%%a1"
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}
    1a40:	nop
    1a42:	movea.l (sp)+,a3
    1a44:	movea.l (sp)+,a6
    1a46:	rts

00001a48 <main>:
static void Wait10() { WaitLine(0x10); }
static void Wait11() { WaitLine(0x11); }
static void Wait12() { WaitLine(0x12); }
static void Wait13() { WaitLine(0x13); }

int main(int argc, char *argv[]) {
    1a48:	    lea -64(sp),sp
    1a4c:	    movem.l d2-d3/a6,-(sp)
	SysBase = *((struct ExecBase**)4UL);
    1a50:	    movea.w #4,a0
    1a54:	    move.l (a0),d0
    1a56:	    move.l d0,755e <SysBase>
	custom = (struct Custom*)0xdff000;
    1a5c:	    move.l #14675968,7562 <custom>

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR)"graphics.library",0);
    1a66:	    move.l #21321,72(sp)
    1a6e:	    clr.l 68(sp)
    1a72:	    move.l 755e <SysBase>,d0
    1a78:	    movea.l d0,a6
    1a7a:	    movea.l 72(sp),a1
    1a7e:	    move.l 68(sp),d0
    1a82:	    jsr -552(a6)
    1a86:	    move.l d0,64(sp)
    1a8a:	    move.l 64(sp),d0
    1a8e:	    move.l d0,756a <GfxBase>
	if (!GfxBase)
    1a94:	    move.l 756a <GfxBase>,d0
    1a9a:	/-- bne.s 1ab0 <main+0x68>
		Exit(0);
    1a9c:	|   clr.l 60(sp)
    1aa0:	|   move.l 7566 <DOSBase>,d0
    1aa6:	|   movea.l d0,a6
    1aa8:	|   move.l 60(sp),d1
    1aac:	|   jsr -144(a6)

	// used for printing
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
    1ab0:	\-> move.l #21338,56(sp)
    1ab8:	    clr.l 52(sp)
    1abc:	    move.l 755e <SysBase>,d0
    1ac2:	    movea.l d0,a6
    1ac4:	    movea.l 56(sp),a1
    1ac8:	    move.l 52(sp),d0
    1acc:	    jsr -552(a6)
    1ad0:	    move.l d0,48(sp)
    1ad4:	    move.l 48(sp),d0
    1ad8:	    move.l d0,7566 <DOSBase>
	if (!DOSBase)
    1ade:	    move.l 7566 <DOSBase>,d0
    1ae4:	/-- bne.s 1afa <main+0xb2>
		Exit(0);
    1ae6:	|   clr.l 44(sp)
    1aea:	|   move.l 7566 <DOSBase>,d0
    1af0:	|   movea.l d0,a6
    1af2:	|   move.l 44(sp),d1
    1af6:	|   jsr -144(a6)

	KPrintF("Hello debugger from Amiga!\n");
    1afa:	\-> pea 5366 <incbin_player_end+0x1e>
    1b00:	    jsr 3168 <KPrintF>
    1b06:	    addq.l #4,sp

	Write(Output(), (APTR)"Hello console!\n", 15);
    1b08:	    move.l 7566 <DOSBase>,d0
    1b0e:	    movea.l d0,a6
    1b10:	    jsr -60(a6)
    1b14:	    move.l d0,40(sp)
    1b18:	    move.l 40(sp),d0
    1b1c:	    move.l d0,36(sp)
    1b20:	    move.l #21378,32(sp)
    1b28:	    moveq #15,d0
    1b2a:	    move.l d0,28(sp)
    1b2e:	    move.l 7566 <DOSBase>,d0
    1b34:	    movea.l d0,a6
    1b36:	    move.l 36(sp),d1
    1b3a:	    move.l 32(sp),d2
    1b3e:	    move.l 28(sp),d3
    1b42:	    jsr -48(a6)
    1b46:	    move.l d0,24(sp)
	Delay(50);
    1b4a:	    moveq #50,d0
    1b4c:	    move.l d0,20(sp)
    1b50:	    move.l 7566 <DOSBase>,d0
    1b56:	    movea.l d0,a6
    1b58:	    move.l 20(sp),d1
    1b5c:	    jsr -198(a6)

	warpmode(1);
    1b60:	    pea 1 <_start+0x1>
    1b64:	    jsr 31d2 <warpmode>
    1b6a:	    addq.l #4,sp
	// TODO: precalc stuff here
#ifdef MUSIC
	if(p61Init(module) != 0)
    1b6c:	    move.l 600e <module>,d0
    1b72:	    move.l d0,-(sp)
    1b74:	    jsr 19fe <p61Init>
    1b7a:	    addq.l #4,sp
    1b7c:	    tst.l d0
    1b7e:	/-- beq.s 1b8e <main+0x146>
		KPrintF("p61Init failed!\n");
    1b80:	|   pea 5392 <sludger.c.a3710121+0x8>
    1b86:	|   jsr 3168 <KPrintF>
    1b8c:	|   addq.l #4,sp
#endif
	warpmode(0);
    1b8e:	\-> clr.l -(sp)
    1b90:	    jsr 31d2 <warpmode>
    1b96:	    addq.l #4,sp

	//TakeSystem();
	custom->dmacon = 0x87ff;
    1b98:	    movea.l 7562 <custom>,a0
    1b9e:	    move.w #-30721,150(a0)
	WaitVbl();
    1ba4:	    jsr 19a2 <WaitVbl>

	main_sludge(argc, argv);
    1baa:	    move.l 84(sp),-(sp)
    1bae:	    move.l 84(sp),-(sp)
    1bb2:	    jsr 1000 <main_sludge>
    1bb8:	    addq.l #8,sp
	debug_register_copperlist(copper2, "copper2", sizeof(copper2), 0);*/



#ifdef MUSIC
	p61End();
    1bba:	    jsr 1a22 <p61End>
#endif

	// END
	//FreeSystem();

	CloseLibrary((struct Library*)DOSBase);
    1bc0:	    move.l 7566 <DOSBase>,16(sp)
    1bc8:	    move.l 755e <SysBase>,d0
    1bce:	    movea.l d0,a6
    1bd0:	    movea.l 16(sp),a1
    1bd4:	    jsr -414(a6)
	CloseLibrary((struct Library*)GfxBase);
    1bd8:	    move.l 756a <GfxBase>,12(sp)
    1be0:	    move.l 755e <SysBase>,d0
    1be6:	    movea.l d0,a6
    1be8:	    movea.l 12(sp),a1
    1bec:	    jsr -414(a6)
    1bf0:	    moveq #0,d0
}
    1bf2:	    movem.l (sp)+,d2-d3/a6
    1bf6:	    lea 64(sp),sp
    1bfa:	    rts

00001bfc <initStatusBar>:

struct statusStuff mainStatus;
struct statusStuff * nowStatus = & mainStatus;

void initStatusBar () {
	mainStatus.firstStatusBar = NULL;
    1bfc:	clr.l 756e <mainStatus>
	mainStatus.alignStatus = IN_THE_CENTRE;
    1c02:	move.w #-1,7572 <mainStatus+0x4>
	mainStatus.litStatus = -1;
    1c0a:	moveq #-1,d0
    1c0c:	move.l d0,7574 <mainStatus+0x6>
	mainStatus.statusX = 10;
    1c12:	moveq #10,d0
    1c14:	move.l d0,7578 <mainStatus+0xa>
	mainStatus.statusY = winHeight - 15;
    1c1a:	movea.l 749e <winHeight>,a0
    1c20:	lea -15(a0),a0
    1c24:	move.l a0,d0
    1c26:	move.l d0,757c <mainStatus+0xe>
	//statusBarColour (255, 255, 255); Amiga Todo: Amigize this
	//statusBarLitColour (255, 255, 128); Amiga Todo: Amigize this
}
    1c2c:	nop
    1c2e:	rts

00001c30 <positionStatus>:

void positionStatus (int x, int y) {
	nowStatus -> statusX = x;
    1c30:	movea.l 6012 <nowStatus>,a0
    1c36:	move.l 4(sp),10(a0)
	nowStatus -> statusY = y;
    1c3c:	movea.l 6012 <nowStatus>,a0
    1c42:	move.l 8(sp),14(a0)
    1c48:	nop
    1c4a:	rts

00001c4c <initSpeech>:
#include "talk.h"
#include "support/gcc8_c_support.h"

struct speechStruct * speech;

void initSpeech () {
    1c4c:	       lea -12(sp),sp
    1c50:	       move.l a6,-(sp)
	speech = AllocVec(sizeof(struct speechStruct), MEMF_ANY);
    1c52:	       moveq #20,d0
    1c54:	       move.l d0,12(sp)
    1c58:	       clr.l 8(sp)
    1c5c:	       move.l 755e <SysBase>,d0
    1c62:	       movea.l d0,a6
    1c64:	       move.l 12(sp),d0
    1c68:	       move.l 8(sp),d1
    1c6c:	       jsr -684(a6)
    1c70:	       move.l d0,4(sp)
    1c74:	       move.l 4(sp),d0
    1c78:	       move.l d0,7598 <speech>
	if (speech) {
    1c7e:	       move.l 7598 <speech>,d0
    1c84:	/----- beq.s 1cb0 <initSpeech+0x64>
		speech -> currentTalker = NULL;
    1c86:	|      movea.l 7598 <speech>,a0
    1c8c:	|      clr.l (a0)
		speech -> allSpeech = NULL;
    1c8e:	|      movea.l 7598 <speech>,a0
    1c94:	|      clr.l 4(a0)
		speech -> speechY = 0;
    1c98:	|      movea.l 7598 <speech>,a0
    1c9e:	|      clr.l 8(a0)
		speech -> lastFile = -1;
    1ca2:	|      movea.l 7598 <speech>,a0
    1ca8:	|      moveq #-1,d0
    1caa:	|      move.l d0,12(a0)
	} else
    {
        KPrintF("Could not allocate memory");
    }
    1cae:	|  /-- bra.s 1cbe <initSpeech+0x72>
        KPrintF("Could not allocate memory");
    1cb0:	\--|-> pea 53a3 <sludger.c.a3710121+0x19>
    1cb6:	   |   jsr 3168 <KPrintF>
    1cbc:	   |   addq.l #4,sp
    1cbe:	   \-> nop
    1cc0:	       movea.l (sp)+,a6
    1cc2:	       lea 12(sp),sp
    1cc6:	       rts

00001cc8 <copyAnim>:

struct screenRegion personRegion;

extern struct screenRegion * allScreenRegions;

struct personaAnimation * copyAnim (struct personaAnimation * orig) {
    1cc8:	             lea -36(sp),sp
    1ccc:	             move.l a6,-(sp)
	int num = orig -> numFrames;
    1cce:	             movea.l 44(sp),a0
    1cd2:	             move.l 8(a0),32(sp)

	struct personaAnimation * newAnim	= AllocVec(sizeof( struct personaAnimation), MEMF_ANY);
    1cd8:	             moveq #12,d0
    1cda:	             move.l d0,28(sp)
    1cde:	             clr.l 24(sp)
    1ce2:	             move.l 755e <SysBase>,d0
    1ce8:	             movea.l d0,a6
    1cea:	             move.l 28(sp),d0
    1cee:	             move.l 24(sp),d1
    1cf2:	             jsr -684(a6)
    1cf6:	             move.l d0,20(sp)
    1cfa:	             move.l 20(sp),d0
    1cfe:	             move.l d0,16(sp)
	if (!(newAnim)) {
    1d02:	         /-- bne.s 1d18 <copyAnim+0x50>
		KPrintF("copyAnim: Cannot allocate memory");
    1d04:	         |   pea 53bd <sludger.c.a3710121+0x33>
    1d0a:	         |   jsr 3168 <KPrintF>
    1d10:	         |   addq.l #4,sp
		return NULL;
    1d12:	         |   moveq #0,d0
    1d14:	/--------|-- bra.w 1e5a <copyAnim+0x192>
	}

	// Copy the easy bits...
	newAnim -> theSprites		= orig -> theSprites;
    1d18:	|        \-> movea.l 44(sp),a0
    1d1c:	|            move.l (a0),d0
    1d1e:	|            movea.l 16(sp),a0
    1d22:	|            move.l d0,(a0)
	newAnim -> numFrames		= num;
    1d24:	|            movea.l 16(sp),a0
    1d28:	|            move.l 32(sp),8(a0)

	if (num) {
    1d2e:	|  /-------- beq.w 1e4e <copyAnim+0x186>

		// Argh! Frames! We need a whole NEW array of animFrame structures...

		newAnim->frames = AllocVec(sizeof(struct animFrame) * num, MEMF_ANY);
    1d32:	|  |         move.l 32(sp),d1
    1d36:	|  |         move.l d1,d0
    1d38:	|  |         add.l d0,d0
    1d3a:	|  |         add.l d1,d0
    1d3c:	|  |         add.l d0,d0
    1d3e:	|  |         add.l d0,d0
    1d40:	|  |         move.l d0,12(sp)
    1d44:	|  |         clr.l 8(sp)
    1d48:	|  |         move.l 755e <SysBase>,d0
    1d4e:	|  |         movea.l d0,a6
    1d50:	|  |         move.l 12(sp),d0
    1d54:	|  |         move.l 8(sp),d1
    1d58:	|  |         jsr -684(a6)
    1d5c:	|  |         move.l d0,4(sp)
    1d60:	|  |         move.l 4(sp),d0
    1d64:	|  |         movea.l 16(sp),a0
    1d68:	|  |         move.l d0,4(a0)
		if (newAnim->frames) {
    1d6c:	|  |         movea.l 16(sp),a0
    1d70:	|  |         move.l 4(a0),d0
    1d74:	|  |     /-- beq.s 1d8a <copyAnim+0xc2>
			KPrintF("copyAnim: Cannot allocate memory");
    1d76:	|  |     |   pea 53bd <sludger.c.a3710121+0x33>
    1d7c:	|  |     |   jsr 3168 <KPrintF>
    1d82:	|  |     |   addq.l #4,sp
			return NULL;
    1d84:	|  |     |   moveq #0,d0
    1d86:	+--|-----|-- bra.w 1e5a <copyAnim+0x192>
		}

		for (int a = 0; a < num; a ++) {
    1d8a:	|  |     \-> clr.l 36(sp)
    1d8e:	|  |     /-- bra.w 1e40 <copyAnim+0x178>
			newAnim -> frames[a].frameNum = orig -> frames[a].frameNum;
    1d92:	|  |  /--|-> movea.l 44(sp),a0
    1d96:	|  |  |  |   movea.l 4(a0),a0
    1d9a:	|  |  |  |   move.l 36(sp),d1
    1d9e:	|  |  |  |   move.l d1,d0
    1da0:	|  |  |  |   add.l d0,d0
    1da2:	|  |  |  |   add.l d1,d0
    1da4:	|  |  |  |   add.l d0,d0
    1da6:	|  |  |  |   add.l d0,d0
    1da8:	|  |  |  |   lea (0,a0,d0.l),a1
    1dac:	|  |  |  |   movea.l 16(sp),a0
    1db0:	|  |  |  |   movea.l 4(a0),a0
    1db4:	|  |  |  |   move.l 36(sp),d1
    1db8:	|  |  |  |   move.l d1,d0
    1dba:	|  |  |  |   add.l d0,d0
    1dbc:	|  |  |  |   add.l d1,d0
    1dbe:	|  |  |  |   add.l d0,d0
    1dc0:	|  |  |  |   add.l d0,d0
    1dc2:	|  |  |  |   adda.l d0,a0
    1dc4:	|  |  |  |   move.l (a1),d0
    1dc6:	|  |  |  |   move.l d0,(a0)
			newAnim -> frames[a].howMany = orig -> frames[a].howMany;
    1dc8:	|  |  |  |   movea.l 44(sp),a0
    1dcc:	|  |  |  |   movea.l 4(a0),a0
    1dd0:	|  |  |  |   move.l 36(sp),d1
    1dd4:	|  |  |  |   move.l d1,d0
    1dd6:	|  |  |  |   add.l d0,d0
    1dd8:	|  |  |  |   add.l d1,d0
    1dda:	|  |  |  |   add.l d0,d0
    1ddc:	|  |  |  |   add.l d0,d0
    1dde:	|  |  |  |   lea (0,a0,d0.l),a1
    1de2:	|  |  |  |   movea.l 16(sp),a0
    1de6:	|  |  |  |   movea.l 4(a0),a0
    1dea:	|  |  |  |   move.l 36(sp),d1
    1dee:	|  |  |  |   move.l d1,d0
    1df0:	|  |  |  |   add.l d0,d0
    1df2:	|  |  |  |   add.l d1,d0
    1df4:	|  |  |  |   add.l d0,d0
    1df6:	|  |  |  |   add.l d0,d0
    1df8:	|  |  |  |   adda.l d0,a0
    1dfa:	|  |  |  |   move.l 4(a1),d0
    1dfe:	|  |  |  |   move.l d0,4(a0)
			newAnim -> frames[a].noise = orig -> frames[a].noise;
    1e02:	|  |  |  |   movea.l 44(sp),a0
    1e06:	|  |  |  |   movea.l 4(a0),a0
    1e0a:	|  |  |  |   move.l 36(sp),d1
    1e0e:	|  |  |  |   move.l d1,d0
    1e10:	|  |  |  |   add.l d0,d0
    1e12:	|  |  |  |   add.l d1,d0
    1e14:	|  |  |  |   add.l d0,d0
    1e16:	|  |  |  |   add.l d0,d0
    1e18:	|  |  |  |   lea (0,a0,d0.l),a1
    1e1c:	|  |  |  |   movea.l 16(sp),a0
    1e20:	|  |  |  |   movea.l 4(a0),a0
    1e24:	|  |  |  |   move.l 36(sp),d1
    1e28:	|  |  |  |   move.l d1,d0
    1e2a:	|  |  |  |   add.l d0,d0
    1e2c:	|  |  |  |   add.l d1,d0
    1e2e:	|  |  |  |   add.l d0,d0
    1e30:	|  |  |  |   add.l d0,d0
    1e32:	|  |  |  |   adda.l d0,a0
    1e34:	|  |  |  |   move.l 8(a1),d0
    1e38:	|  |  |  |   move.l d0,8(a0)
		for (int a = 0; a < num; a ++) {
    1e3c:	|  |  |  |   addq.l #1,36(sp)
    1e40:	|  |  |  \-> move.l 36(sp),d0
    1e44:	|  |  |      cmp.l 32(sp),d0
    1e48:	|  |  \----- blt.w 1d92 <copyAnim+0xca>
    1e4c:	|  |     /-- bra.s 1e56 <copyAnim+0x18e>
		}
	} else {
		newAnim -> frames = NULL;
    1e4e:	|  \-----|-> movea.l 16(sp),a0
    1e52:	|        |   clr.l 4(a0)
	}

	return newAnim;
    1e56:	|        \-> move.l 16(sp),d0
}
    1e5a:	\----------> movea.l (sp)+,a6
    1e5c:	             lea 36(sp),sp
    1e60:	             rts

00001e62 <deleteAnim>:

void deleteAnim (struct personaAnimation * orig) {
    1e62:	       subq.l #8,sp
    1e64:	       move.l a6,-(sp)

	if (orig)
    1e66:	       tst.l 16(sp)
    1e6a:	/----- beq.s 1eaa <deleteAnim+0x48>
	{
		if (orig -> numFrames) {
    1e6c:	|      movea.l 16(sp),a0
    1e70:	|      move.l 8(a0),d0
    1e74:	|  /-- beq.s 1e90 <deleteAnim+0x2e>
			FreeVec( orig->frames);
    1e76:	|  |   movea.l 16(sp),a0
    1e7a:	|  |   move.l 4(a0),8(sp)
    1e80:	|  |   move.l 755e <SysBase>,d0
    1e86:	|  |   movea.l d0,a6
    1e88:	|  |   movea.l 8(sp),a1
    1e8c:	|  |   jsr -690(a6)
		}
		FreeVec(orig);
    1e90:	|  \-> move.l 16(sp),4(sp)
    1e96:	|      move.l 755e <SysBase>,d0
    1e9c:	|      movea.l d0,a6
    1e9e:	|      movea.l 4(sp),a1
    1ea2:	|      jsr -690(a6)
		orig = NULL;
    1ea6:	|      clr.l 16(sp)
	}
}
    1eaa:	\----> nop
    1eac:	       movea.l (sp)+,a6
    1eae:	       addq.l #8,sp
    1eb0:	       rts

00001eb2 <initPeople>:

BOOL initPeople () {
	personRegion.sX = 0;
    1eb2:	clr.l 75ac <personRegion+0x10>
	personRegion.sY = 0;
    1eb8:	clr.l 75b0 <personRegion+0x14>
	personRegion.di = -1;
    1ebe:	moveq #-1,d0
    1ec0:	move.l d0,75b4 <personRegion+0x18>
	allScreenRegions = NULL;
    1ec6:	clr.l 7496 <allScreenRegions>

	return TRUE;
    1ecc:	moveq #1,d0
}
    1ece:	rts

00001ed0 <makeNullAnim>:

struct personaAnimation * makeNullAnim () {
    1ed0:	       lea -16(sp),sp
    1ed4:	       move.l a6,-(sp)

	struct personaAnimation * newAnim	= AllocVec(sizeof(struct personaAnimation),MEMF_ANY);
    1ed6:	       moveq #12,d0
    1ed8:	       move.l d0,16(sp)
    1edc:	       clr.l 12(sp)
    1ee0:	       move.l 755e <SysBase>,d0
    1ee6:	       movea.l d0,a6
    1ee8:	       move.l 16(sp),d0
    1eec:	       move.l 12(sp),d1
    1ef0:	       jsr -684(a6)
    1ef4:	       move.l d0,8(sp)
    1ef8:	       move.l 8(sp),d0
    1efc:	       move.l d0,4(sp)
    if(newAnim == 0) {
    1f00:	   /-- bne.s 1f14 <makeNullAnim+0x44>
     	KPrintF("makeNullAnim: Can't reserve Memory\n");
    1f02:	   |   pea 53de <sludger.c.a3710121+0x54>
    1f08:	   |   jsr 3168 <KPrintF>
    1f0e:	   |   addq.l #4,sp
        return NULL;    
    1f10:	   |   moveq #0,d0
    1f12:	/--|-- bra.s 1f2e <makeNullAnim+0x5e>
    }  

	newAnim -> theSprites		= NULL;
    1f14:	|  \-> movea.l 4(sp),a0
    1f18:	|      clr.l (a0)
	newAnim -> numFrames		= 0;
    1f1a:	|      movea.l 4(sp),a0
    1f1e:	|      clr.l 8(a0)
	newAnim -> frames			= NULL;
    1f22:	|      movea.l 4(sp),a0
    1f26:	|      clr.l 4(a0)
	return newAnim;
    1f2a:	|      move.l 4(sp),d0
}
    1f2e:	\----> movea.l (sp)+,a6
    1f30:	       lea 16(sp),sp
    1f34:	       rts

00001f36 <killBackDrop>:
struct parallaxLayer * parallaxStuff = NULL;
extern int cameraX, cameraY;
extern float cameraZoom;

void killBackDrop () {
	deleteTextures (1, &backdropTextureName);
    1f36:	pea 75c8 <backdropTextureName>
    1f3c:	pea 1 <_start+0x1>
    1f40:	jsr b8 <deleteTextures>
    1f46:	addq.l #8,sp
	backdropTextureName = 0;
    1f48:	clr.l 75c8 <backdropTextureName>
	backdropExists = FALSE;
    1f4e:	clr.w 75cc <backdropExists>
}
    1f54:	nop
    1f56:	rts

00001f58 <killParallax>:

void killParallax () {
    1f58:	          lea -12(sp),sp
    1f5c:	          move.l a6,-(sp)
	while (parallaxStuff) {
    1f5e:	   /----- bra.s 1fca <killParallax+0x72>

		struct parallaxLayer * k = parallaxStuff;
    1f60:	/--|----> move.l 75ce <parallaxStuff>,12(sp)
		parallaxStuff = k->next;
    1f68:	|  |      movea.l 12(sp),a0
    1f6c:	|  |      move.l 42(a0),d0
    1f70:	|  |      move.l d0,75ce <parallaxStuff>

		// Now kill the image
		deleteTextures (1, &k->textureName);
    1f76:	|  |      move.l 12(sp),d0
    1f7a:	|  |      addq.l #4,d0
    1f7c:	|  |      move.l d0,-(sp)
    1f7e:	|  |      pea 1 <_start+0x1>
    1f82:	|  |      jsr b8 <deleteTextures>
    1f88:	|  |      addq.l #8,sp
		if( k->texture) FreeVec(k->texture);
    1f8a:	|  |      movea.l 12(sp),a0
    1f8e:	|  |      move.l (a0),d0
    1f90:	|  |  /-- beq.s 1faa <killParallax+0x52>
    1f92:	|  |  |   movea.l 12(sp),a0
    1f96:	|  |  |   move.l (a0),8(sp)
    1f9a:	|  |  |   move.l 755e <SysBase>,d0
    1fa0:	|  |  |   movea.l d0,a6
    1fa2:	|  |  |   movea.l 8(sp),a1
    1fa6:	|  |  |   jsr -690(a6)
		if( k) FreeVec(k);
    1faa:	|  |  \-> tst.l 12(sp)
    1fae:	|  |  /-- beq.s 1fc6 <killParallax+0x6e>
    1fb0:	|  |  |   move.l 12(sp),4(sp)
    1fb6:	|  |  |   move.l 755e <SysBase>,d0
    1fbc:	|  |  |   movea.l d0,a6
    1fbe:	|  |  |   movea.l 4(sp),a1
    1fc2:	|  |  |   jsr -690(a6)
		k = NULL;
    1fc6:	|  |  \-> clr.l 12(sp)
	while (parallaxStuff) {
    1fca:	|  \----> move.l 75ce <parallaxStuff>,d0
    1fd0:	\-------- bne.s 1f60 <killParallax+0x8>
	}
}
    1fd2:	          nop
    1fd4:	          nop
    1fd6:	          movea.l (sp)+,a6
    1fd8:	          lea 12(sp),sp
    1fdc:	          rts

00001fde <resizeBackdrop>:

BOOL resizeBackdrop (int x, int y) {
    killBackDrop ();
    1fde:	jsr 1f36 <killBackDrop>
	killParallax ();
    1fe4:	jsr 1f58 <killParallax>
	killZBuffer ();
    1fea:	jsr 14c4 <killZBuffer>
	sceneWidth = x;
    1ff0:	move.l 4(sp),d0
    1ff4:	move.l d0,75c0 <sceneWidth>
	sceneHeight = y;
    1ffa:	move.l 8(sp),d0
    1ffe:	move.l d0,75c4 <sceneHeight>
	return TRUE;
    2004:	moveq #1,d0
    2006:	rts

00002008 <encodeFilename>:
#include "support/gcc8_c_support.h"
#include "moreio.h"

BOOL allowAnyFilename = TRUE;

char * encodeFilename (char * nameIn) {
    2008:	                      lea -24(sp),sp
    200c:	                      move.l a6,-(sp)
	if (! nameIn) return NULL;
    200e:	                      tst.l 32(sp)
    2012:	                  /-- bne.s 201a <encodeFilename+0x12>
    2014:	                  |   moveq #0,d0
    2016:	/-----------------|-- bra.w 2392 <encodeFilename+0x38a>
	if (allowAnyFilename) {
    201a:	|                 \-> move.w 6016 <allowAnyFilename>,d0
    2020:	|  /----------------- beq.w 234e <encodeFilename+0x346>
		char * newName = AllocVec( strlen(nameIn)*2+1,MEMF_ANY);
    2024:	|  |                  move.l 32(sp),-(sp)
    2028:	|  |                  jsr 2cf2 <strlen>
    202e:	|  |                  addq.l #4,sp
    2030:	|  |                  add.l d0,d0
    2032:	|  |                  move.l d0,d1
    2034:	|  |                  addq.l #1,d1
    2036:	|  |                  move.l d1,16(sp)
    203a:	|  |                  clr.l 12(sp)
    203e:	|  |                  move.l 755e <SysBase>,d0
    2044:	|  |                  movea.l d0,a6
    2046:	|  |                  move.l 16(sp),d0
    204a:	|  |                  move.l 12(sp),d1
    204e:	|  |                  jsr -684(a6)
    2052:	|  |                  move.l d0,8(sp)
    2056:	|  |                  move.l 8(sp),d0
    205a:	|  |                  move.l d0,4(sp)
		if(newName == 0) {
    205e:	|  |              /-- bne.s 2074 <encodeFilename+0x6c>
			KPrintF( "encodefilename: Could not allocate Memory");
    2060:	|  |              |   pea 5402 <sludger.c.a3710121+0x78>
    2066:	|  |              |   jsr 3168 <KPrintF>
    206c:	|  |              |   addq.l #4,sp
			return NULL;
    206e:	|  |              |   moveq #0,d0
    2070:	+--|--------------|-- bra.w 2392 <encodeFilename+0x38a>
		}

		int i = 0;
    2074:	|  |              \-> clr.l 24(sp)
		while (*nameIn) {
    2078:	|  |     /----------- bra.w 233e <encodeFilename+0x336>
			switch (*nameIn) {
    207c:	|  |  /--|----------> movea.l 32(sp),a0
    2080:	|  |  |  |            move.b (a0),d0
    2082:	|  |  |  |            ext.w d0
    2084:	|  |  |  |            movea.w d0,a0
    2086:	|  |  |  |            moveq #95,d0
    2088:	|  |  |  |            cmp.l a0,d0
    208a:	|  |  |  |        /-- blt.w 212e <encodeFilename+0x126>
    208e:	|  |  |  |        |   moveq #34,d1
    2090:	|  |  |  |        |   cmp.l a0,d1
    2092:	|  |  |  |  /-----|-- bgt.w 2312 <encodeFilename+0x30a>
    2096:	|  |  |  |  |     |   moveq #-34,d0
    2098:	|  |  |  |  |     |   add.l a0,d0
    209a:	|  |  |  |  |     |   moveq #61,d1
    209c:	|  |  |  |  |     |   cmp.l d0,d1
    209e:	|  |  |  |  +-----|-- bcs.w 2312 <encodeFilename+0x30a>
    20a2:	|  |  |  |  |     |   add.l d0,d0
    20a4:	|  |  |  |  |     |   movea.l d0,a0
    20a6:	|  |  |  |  |     |   adda.l #8370,a0
    20ac:	|  |  |  |  |     |   move.w (a0),d0
    20ae:	|  |  |  |  |     |   jmp (20b2 <encodeFilename+0xaa>,pc,d0.w)
    20b2:	|  |  |  |  |     |   bchg d0,d6
    20b4:	|  |  |  |  |     |   andi.w #608,-(a0)
    20b8:	|  |  |  |  |     |   andi.w #608,-(a0)
    20bc:	|  |  |  |  |     |   andi.w #608,-(a0)
    20c0:	|  |  |  |  |     |   andi.w #516,-(a0)
    20c4:	|  |  |  |  |     |   andi.w #608,-(a0)
    20c8:	|  |  |  |  |     |   andi.w #608,-(a0)
    20cc:	|  |  |  |  |     |   bclr d0,-(a6)
    20ce:	|  |  |  |  |     |   andi.w #608,-(a0)
    20d2:	|  |  |  |  |     |   andi.w #608,-(a0)
    20d6:	|  |  |  |  |     |   andi.w #608,-(a0)
    20da:	|  |  |  |  |     |   andi.w #608,-(a0)
    20de:	|  |  |  |  |     |   andi.w #608,-(a0)
    20e2:	|  |  |  |  |     |   bset d0,(a6)
    20e4:	|  |  |  |  |     |   andi.w #134,-(a0)
    20e8:	|  |  |  |  |     |   andi.w #182,-(a0)
    20ec:	|  |  |  |  |     |   andi.b #96,(96,a2,d0.w:2)
    20f2:	|  |  |  |  |     |   andi.w #608,-(a0)
    20f6:	|  |  |  |  |     |   andi.w #608,-(a0)
    20fa:	|  |  |  |  |     |   andi.w #608,-(a0)
    20fe:	|  |  |  |  |     |   andi.w #608,-(a0)
    2102:	|  |  |  |  |     |   andi.w #608,-(a0)
    2106:	|  |  |  |  |     |   andi.w #608,-(a0)
    210a:	|  |  |  |  |     |   andi.w #608,-(a0)
    210e:	|  |  |  |  |     |   andi.w #608,-(a0)
    2112:	|  |  |  |  |     |   andi.w #608,-(a0)
    2116:	|  |  |  |  |     |   andi.w #608,-(a0)
    211a:	|  |  |  |  |     |   andi.w #608,-(a0)
    211e:	|  |  |  |  |     |   andi.w #608,-(a0)
    2122:	|  |  |  |  |     |   andi.w #608,-(a0)
    2126:	|  |  |  |  |     |   bchg d0,(96,a6,d0.w:2)
    212a:	|  |  |  |  |     |   andi.w #278,-(a0)
    212e:	|  |  |  |  |     \-> moveq #124,d0
    2130:	|  |  |  |  |         cmp.l a0,d0
    2132:	|  |  |  |  |     /-- beq.s 2198 <encodeFilename+0x190>
    2134:	|  |  |  |  +-----|-- bra.w 2312 <encodeFilename+0x30a>
				case '<':	newName[i++] = '_';		newName[i++] = 'L';		break;
    2138:	|  |  |  |  |     |   move.l 24(sp),d0
    213c:	|  |  |  |  |     |   move.l d0,d1
    213e:	|  |  |  |  |     |   addq.l #1,d1
    2140:	|  |  |  |  |     |   move.l d1,24(sp)
    2144:	|  |  |  |  |     |   movea.l 4(sp),a0
    2148:	|  |  |  |  |     |   adda.l d0,a0
    214a:	|  |  |  |  |     |   move.b #95,(a0)
    214e:	|  |  |  |  |     |   move.l 24(sp),d0
    2152:	|  |  |  |  |     |   move.l d0,d1
    2154:	|  |  |  |  |     |   addq.l #1,d1
    2156:	|  |  |  |  |     |   move.l d1,24(sp)
    215a:	|  |  |  |  |     |   movea.l 4(sp),a0
    215e:	|  |  |  |  |     |   adda.l d0,a0
    2160:	|  |  |  |  |     |   move.b #76,(a0)
    2164:	|  |  |  |  |  /--|-- bra.w 232e <encodeFilename+0x326>
				case '>':	newName[i++] = '_';		newName[i++] = 'G';		break;
    2168:	|  |  |  |  |  |  |   move.l 24(sp),d0
    216c:	|  |  |  |  |  |  |   move.l d0,d1
    216e:	|  |  |  |  |  |  |   addq.l #1,d1
    2170:	|  |  |  |  |  |  |   move.l d1,24(sp)
    2174:	|  |  |  |  |  |  |   movea.l 4(sp),a0
    2178:	|  |  |  |  |  |  |   adda.l d0,a0
    217a:	|  |  |  |  |  |  |   move.b #95,(a0)
    217e:	|  |  |  |  |  |  |   move.l 24(sp),d0
    2182:	|  |  |  |  |  |  |   move.l d0,d1
    2184:	|  |  |  |  |  |  |   addq.l #1,d1
    2186:	|  |  |  |  |  |  |   move.l d1,24(sp)
    218a:	|  |  |  |  |  |  |   movea.l 4(sp),a0
    218e:	|  |  |  |  |  |  |   adda.l d0,a0
    2190:	|  |  |  |  |  |  |   move.b #71,(a0)
    2194:	|  |  |  |  |  +--|-- bra.w 232e <encodeFilename+0x326>
				case '|':	newName[i++] = '_';		newName[i++] = 'P';		break;
    2198:	|  |  |  |  |  |  \-> move.l 24(sp),d0
    219c:	|  |  |  |  |  |      move.l d0,d1
    219e:	|  |  |  |  |  |      addq.l #1,d1
    21a0:	|  |  |  |  |  |      move.l d1,24(sp)
    21a4:	|  |  |  |  |  |      movea.l 4(sp),a0
    21a8:	|  |  |  |  |  |      adda.l d0,a0
    21aa:	|  |  |  |  |  |      move.b #95,(a0)
    21ae:	|  |  |  |  |  |      move.l 24(sp),d0
    21b2:	|  |  |  |  |  |      move.l d0,d1
    21b4:	|  |  |  |  |  |      addq.l #1,d1
    21b6:	|  |  |  |  |  |      move.l d1,24(sp)
    21ba:	|  |  |  |  |  |      movea.l 4(sp),a0
    21be:	|  |  |  |  |  |      adda.l d0,a0
    21c0:	|  |  |  |  |  |      move.b #80,(a0)
    21c4:	|  |  |  |  |  +----- bra.w 232e <encodeFilename+0x326>
				case '_':	newName[i++] = '_';		newName[i++] = 'U';		break;
    21c8:	|  |  |  |  |  |      move.l 24(sp),d0
    21cc:	|  |  |  |  |  |      move.l d0,d1
    21ce:	|  |  |  |  |  |      addq.l #1,d1
    21d0:	|  |  |  |  |  |      move.l d1,24(sp)
    21d4:	|  |  |  |  |  |      movea.l 4(sp),a0
    21d8:	|  |  |  |  |  |      adda.l d0,a0
    21da:	|  |  |  |  |  |      move.b #95,(a0)
    21de:	|  |  |  |  |  |      move.l 24(sp),d0
    21e2:	|  |  |  |  |  |      move.l d0,d1
    21e4:	|  |  |  |  |  |      addq.l #1,d1
    21e6:	|  |  |  |  |  |      move.l d1,24(sp)
    21ea:	|  |  |  |  |  |      movea.l 4(sp),a0
    21ee:	|  |  |  |  |  |      adda.l d0,a0
    21f0:	|  |  |  |  |  |      move.b #85,(a0)
    21f4:	|  |  |  |  |  +----- bra.w 232e <encodeFilename+0x326>
				case '\"':	newName[i++] = '_';		newName[i++] = 'S';		break;
    21f8:	|  |  |  |  |  |      move.l 24(sp),d0
    21fc:	|  |  |  |  |  |      move.l d0,d1
    21fe:	|  |  |  |  |  |      addq.l #1,d1
    2200:	|  |  |  |  |  |      move.l d1,24(sp)
    2204:	|  |  |  |  |  |      movea.l 4(sp),a0
    2208:	|  |  |  |  |  |      adda.l d0,a0
    220a:	|  |  |  |  |  |      move.b #95,(a0)
    220e:	|  |  |  |  |  |      move.l 24(sp),d0
    2212:	|  |  |  |  |  |      move.l d0,d1
    2214:	|  |  |  |  |  |      addq.l #1,d1
    2216:	|  |  |  |  |  |      move.l d1,24(sp)
    221a:	|  |  |  |  |  |      movea.l 4(sp),a0
    221e:	|  |  |  |  |  |      adda.l d0,a0
    2220:	|  |  |  |  |  |      move.b #83,(a0)
    2224:	|  |  |  |  |  +----- bra.w 232e <encodeFilename+0x326>
				case '\\':	newName[i++] = '_';		newName[i++] = 'B';		break;
    2228:	|  |  |  |  |  |      move.l 24(sp),d0
    222c:	|  |  |  |  |  |      move.l d0,d1
    222e:	|  |  |  |  |  |      addq.l #1,d1
    2230:	|  |  |  |  |  |      move.l d1,24(sp)
    2234:	|  |  |  |  |  |      movea.l 4(sp),a0
    2238:	|  |  |  |  |  |      adda.l d0,a0
    223a:	|  |  |  |  |  |      move.b #95,(a0)
    223e:	|  |  |  |  |  |      move.l 24(sp),d0
    2242:	|  |  |  |  |  |      move.l d0,d1
    2244:	|  |  |  |  |  |      addq.l #1,d1
    2246:	|  |  |  |  |  |      move.l d1,24(sp)
    224a:	|  |  |  |  |  |      movea.l 4(sp),a0
    224e:	|  |  |  |  |  |      adda.l d0,a0
    2250:	|  |  |  |  |  |      move.b #66,(a0)
    2254:	|  |  |  |  |  +----- bra.w 232e <encodeFilename+0x326>
				case '/':	newName[i++] = '_';		newName[i++] = 'F';		break;
    2258:	|  |  |  |  |  |      move.l 24(sp),d0
    225c:	|  |  |  |  |  |      move.l d0,d1
    225e:	|  |  |  |  |  |      addq.l #1,d1
    2260:	|  |  |  |  |  |      move.l d1,24(sp)
    2264:	|  |  |  |  |  |      movea.l 4(sp),a0
    2268:	|  |  |  |  |  |      adda.l d0,a0
    226a:	|  |  |  |  |  |      move.b #95,(a0)
    226e:	|  |  |  |  |  |      move.l 24(sp),d0
    2272:	|  |  |  |  |  |      move.l d0,d1
    2274:	|  |  |  |  |  |      addq.l #1,d1
    2276:	|  |  |  |  |  |      move.l d1,24(sp)
    227a:	|  |  |  |  |  |      movea.l 4(sp),a0
    227e:	|  |  |  |  |  |      adda.l d0,a0
    2280:	|  |  |  |  |  |      move.b #70,(a0)
    2284:	|  |  |  |  |  +----- bra.w 232e <encodeFilename+0x326>
				case ':':	newName[i++] = '_';		newName[i++] = 'C';		break;
    2288:	|  |  |  |  |  |      move.l 24(sp),d0
    228c:	|  |  |  |  |  |      move.l d0,d1
    228e:	|  |  |  |  |  |      addq.l #1,d1
    2290:	|  |  |  |  |  |      move.l d1,24(sp)
    2294:	|  |  |  |  |  |      movea.l 4(sp),a0
    2298:	|  |  |  |  |  |      adda.l d0,a0
    229a:	|  |  |  |  |  |      move.b #95,(a0)
    229e:	|  |  |  |  |  |      move.l 24(sp),d0
    22a2:	|  |  |  |  |  |      move.l d0,d1
    22a4:	|  |  |  |  |  |      addq.l #1,d1
    22a6:	|  |  |  |  |  |      move.l d1,24(sp)
    22aa:	|  |  |  |  |  |      movea.l 4(sp),a0
    22ae:	|  |  |  |  |  |      adda.l d0,a0
    22b0:	|  |  |  |  |  |      move.b #67,(a0)
    22b4:	|  |  |  |  |  +----- bra.s 232e <encodeFilename+0x326>
				case '*':	newName[i++] = '_';		newName[i++] = 'A';		break;
    22b6:	|  |  |  |  |  |      move.l 24(sp),d0
    22ba:	|  |  |  |  |  |      move.l d0,d1
    22bc:	|  |  |  |  |  |      addq.l #1,d1
    22be:	|  |  |  |  |  |      move.l d1,24(sp)
    22c2:	|  |  |  |  |  |      movea.l 4(sp),a0
    22c6:	|  |  |  |  |  |      adda.l d0,a0
    22c8:	|  |  |  |  |  |      move.b #95,(a0)
    22cc:	|  |  |  |  |  |      move.l 24(sp),d0
    22d0:	|  |  |  |  |  |      move.l d0,d1
    22d2:	|  |  |  |  |  |      addq.l #1,d1
    22d4:	|  |  |  |  |  |      move.l d1,24(sp)
    22d8:	|  |  |  |  |  |      movea.l 4(sp),a0
    22dc:	|  |  |  |  |  |      adda.l d0,a0
    22de:	|  |  |  |  |  |      move.b #65,(a0)
    22e2:	|  |  |  |  |  +----- bra.s 232e <encodeFilename+0x326>
				case '?':	newName[i++] = '_';		newName[i++] = 'Q';		break;
    22e4:	|  |  |  |  |  |      move.l 24(sp),d0
    22e8:	|  |  |  |  |  |      move.l d0,d1
    22ea:	|  |  |  |  |  |      addq.l #1,d1
    22ec:	|  |  |  |  |  |      move.l d1,24(sp)
    22f0:	|  |  |  |  |  |      movea.l 4(sp),a0
    22f4:	|  |  |  |  |  |      adda.l d0,a0
    22f6:	|  |  |  |  |  |      move.b #95,(a0)
    22fa:	|  |  |  |  |  |      move.l 24(sp),d0
    22fe:	|  |  |  |  |  |      move.l d0,d1
    2300:	|  |  |  |  |  |      addq.l #1,d1
    2302:	|  |  |  |  |  |      move.l d1,24(sp)
    2306:	|  |  |  |  |  |      movea.l 4(sp),a0
    230a:	|  |  |  |  |  |      adda.l d0,a0
    230c:	|  |  |  |  |  |      move.b #81,(a0)
    2310:	|  |  |  |  |  +----- bra.s 232e <encodeFilename+0x326>

				default:	newName[i++] = *nameIn;							break;
    2312:	|  |  |  |  \--|----> move.l 24(sp),d0
    2316:	|  |  |  |     |      move.l d0,d1
    2318:	|  |  |  |     |      addq.l #1,d1
    231a:	|  |  |  |     |      move.l d1,24(sp)
    231e:	|  |  |  |     |      movea.l 4(sp),a0
    2322:	|  |  |  |     |      adda.l d0,a0
    2324:	|  |  |  |     |      movea.l 32(sp),a1
    2328:	|  |  |  |     |      move.b (a1),d0
    232a:	|  |  |  |     |      move.b d0,(a0)
    232c:	|  |  |  |     |      nop
			}
			newName[i] = 0;
    232e:	|  |  |  |     \----> move.l 24(sp),d0
    2332:	|  |  |  |            movea.l 4(sp),a0
    2336:	|  |  |  |            adda.l d0,a0
    2338:	|  |  |  |            clr.b (a0)
			nameIn ++;
    233a:	|  |  |  |            addq.l #1,32(sp)
		while (*nameIn) {
    233e:	|  |  |  \----------> movea.l 32(sp),a0
    2342:	|  |  |               move.b (a0),d0
    2344:	|  |  \-------------- bne.w 207c <encodeFilename+0x74>
		}
		return newName;
    2348:	|  |                  move.l 4(sp),d0
    234c:	+--|----------------- bra.s 2392 <encodeFilename+0x38a>
	} else {
		int a;
		for (a = 0; nameIn[a]; a ++) {
    234e:	|  \----------------> clr.l 20(sp)
    2352:	|              /----- bra.s 2378 <encodeFilename+0x370>
			if (nameIn[a] == '\\') nameIn[a] ='/';
    2354:	|           /--|----> move.l 20(sp),d0
    2358:	|           |  |      movea.l 32(sp),a0
    235c:	|           |  |      adda.l d0,a0
    235e:	|           |  |      move.b (a0),d0
    2360:	|           |  |      cmpi.b #92,d0
    2364:	|           |  |  /-- bne.s 2374 <encodeFilename+0x36c>
    2366:	|           |  |  |   move.l 20(sp),d0
    236a:	|           |  |  |   movea.l 32(sp),a0
    236e:	|           |  |  |   adda.l d0,a0
    2370:	|           |  |  |   move.b #47,(a0)
		for (a = 0; nameIn[a]; a ++) {
    2374:	|           |  |  \-> addq.l #1,20(sp)
    2378:	|           |  \----> move.l 20(sp),d0
    237c:	|           |         movea.l 32(sp),a0
    2380:	|           |         adda.l d0,a0
    2382:	|           |         move.b (a0),d0
    2384:	|           \-------- bne.s 2354 <encodeFilename+0x34c>
		}

		return copyString (nameIn);
    2386:	|                     move.l 32(sp),-(sp)
    238a:	|                     jsr 2d32 <copyString>
    2390:	|                     addq.l #4,sp
	}
}
    2392:	\-------------------> movea.l (sp)+,a6
    2394:	                      lea 24(sp),sp
    2398:	                      rts

0000239a <floatSwap>:

float floatSwap( float f )
{
    239a:	subq.l #8,sp
	{
		float f;
		unsigned char b[4];
	} dat1, dat2;

	dat1.f = f;
    239c:	move.l 12(sp),4(sp)
	dat2.b[0] = dat1.b[3];
    23a2:	move.b 7(sp),d0
    23a6:	move.b d0,(sp)
	dat2.b[1] = dat1.b[2];
    23a8:	move.b 6(sp),d0
    23ac:	move.b d0,1(sp)
	dat2.b[2] = dat1.b[1];
    23b0:	move.b 5(sp),d0
    23b4:	move.b d0,2(sp)
	dat2.b[3] = dat1.b[0];
    23b8:	move.b 4(sp),d0
    23bc:	move.b d0,3(sp)
	return dat2.f;
    23c0:	move.l (sp),d0
}
    23c2:	addq.l #8,sp
    23c4:	rts

000023c6 <get2bytes>:

int get2bytes (BPTR fp) {
    23c6:	lea -24(sp),sp
    23ca:	move.l a6,-(sp)
	int f1, f2;

	f1 = FGetC (fp);
    23cc:	move.l 32(sp),24(sp)
    23d2:	move.l 7566 <DOSBase>,d0
    23d8:	movea.l d0,a6
    23da:	move.l 24(sp),d1
    23de:	jsr -306(a6)
    23e2:	move.l d0,20(sp)
    23e6:	move.l 20(sp),d0
    23ea:	move.l d0,16(sp)
	f2 = FGetC (fp);
    23ee:	move.l 32(sp),12(sp)
    23f4:	move.l 7566 <DOSBase>,d0
    23fa:	movea.l d0,a6
    23fc:	move.l 12(sp),d1
    2400:	jsr -306(a6)
    2404:	move.l d0,8(sp)
    2408:	move.l 8(sp),d0
    240c:	move.l d0,4(sp)

	return (f1 * 256 + f2);
    2410:	move.l 16(sp),d0
    2414:	lsl.l #8,d0
    2416:	add.l 4(sp),d0
}
    241a:	movea.l (sp)+,a6
    241c:	lea 24(sp),sp
    2420:	rts

00002422 <get4bytes>:

ULONG get4bytes (BPTR fp) {
    2422:	lea -52(sp),sp
    2426:	move.l a6,-(sp)
	int f1, f2, f3, f4;

	f1 = FGetC (fp);
    2428:	move.l 60(sp),52(sp)
    242e:	move.l 7566 <DOSBase>,d0
    2434:	movea.l d0,a6
    2436:	move.l 52(sp),d1
    243a:	jsr -306(a6)
    243e:	move.l d0,48(sp)
    2442:	move.l 48(sp),d0
    2446:	move.l d0,44(sp)
	f2 = FGetC (fp);
    244a:	move.l 60(sp),40(sp)
    2450:	move.l 7566 <DOSBase>,d0
    2456:	movea.l d0,a6
    2458:	move.l 40(sp),d1
    245c:	jsr -306(a6)
    2460:	move.l d0,36(sp)
    2464:	move.l 36(sp),d0
    2468:	move.l d0,32(sp)
	f3 = FGetC (fp);
    246c:	move.l 60(sp),28(sp)
    2472:	move.l 7566 <DOSBase>,d0
    2478:	movea.l d0,a6
    247a:	move.l 28(sp),d1
    247e:	jsr -306(a6)
    2482:	move.l d0,24(sp)
    2486:	move.l 24(sp),d0
    248a:	move.l d0,20(sp)
	f4 = FGetC (fp);
    248e:	move.l 60(sp),16(sp)
    2494:	move.l 7566 <DOSBase>,d0
    249a:	movea.l d0,a6
    249c:	move.l 16(sp),d1
    24a0:	jsr -306(a6)
    24a4:	move.l d0,12(sp)
    24a8:	move.l 12(sp),d0
    24ac:	move.l d0,8(sp)

	ULONG x = f1 + f2*256 + f3*256*256 + f4*256*256*256;
    24b0:	move.l 32(sp),d0
    24b4:	lsl.l #8,d0
    24b6:	move.l d0,d1
    24b8:	add.l 44(sp),d1
    24bc:	move.l 20(sp),d0
    24c0:	swap d0
    24c2:	clr.w d0
    24c4:	add.l d0,d1
    24c6:	move.l 8(sp),d0
    24ca:	lsl.w #8,d0
    24cc:	swap d0
    24ce:	clr.w d0
    24d0:	add.l d1,d0
    24d2:	move.l d0,4(sp)

	return x;
    24d6:	move.l 4(sp),d0
}
    24da:	movea.l (sp)+,a6
    24dc:	lea 52(sp),sp
    24e0:	rts

000024e2 <getFloat>:

float getFloat (BPTR fp) {
    24e2:	    lea -28(sp),sp
    24e6:	    movem.l d2-d4/a6,-(sp)
	float f;
	LONG blocks_read = FRead( fp, &f, sizeof (float), 1 ); 
    24ea:	    move.l 48(sp),40(sp)
    24f0:	    lea 44(sp),a0
    24f4:	    lea -28(a0),a0
    24f8:	    move.l a0,36(sp)
    24fc:	    moveq #4,d0
    24fe:	    move.l d0,32(sp)
    2502:	    moveq #1,d0
    2504:	    move.l d0,28(sp)
    2508:	    move.l 7566 <DOSBase>,d0
    250e:	    movea.l d0,a6
    2510:	    move.l 40(sp),d1
    2514:	    move.l 36(sp),d2
    2518:	    move.l 32(sp),d3
    251c:	    move.l 28(sp),d4
    2520:	    jsr -324(a6)
    2524:	    move.l d0,24(sp)
    2528:	    move.l 24(sp),d0
    252c:	    move.l d0,20(sp)
	if (blocks_read != 1) {
    2530:	    moveq #1,d0
    2532:	    cmp.l 20(sp),d0
    2536:	/-- beq.s 2546 <getFloat+0x64>
		KPrintF("Reading error in getFloat.\n");
    2538:	|   pea 542c <sludger.c.a3710121+0xa2>
    253e:	|   jsr 3168 <KPrintF>
    2544:	|   addq.l #4,sp
	}
	return floatSwap(f);
    2546:	\-> move.l 16(sp),d0
    254a:	    move.l d0,-(sp)
    254c:	    jsr 239a <floatSwap>
    2552:	    addq.l #4,sp
	return f;
}
    2554:	    movem.l (sp)+,d2-d4/a6
    2558:	    lea 28(sp),sp
    255c:	    rts

0000255e <readString>:

char * readString (BPTR fp) {
    255e:	          lea -32(sp),sp
    2562:	          move.l a6,-(sp)

	int a, len = get2bytes (fp);
    2564:	          move.l 40(sp),-(sp)
    2568:	          jsr 23c6 <get2bytes>
    256e:	          addq.l #4,sp
    2570:	          move.l d0,28(sp)
	//debugOut ("MOREIO: readString - len %i\n", len);
	char * s = AllocVec(len+1,MEMF_ANY);
    2574:	          move.l 28(sp),d0
    2578:	          addq.l #1,d0
    257a:	          move.l d0,24(sp)
    257e:	          clr.l 20(sp)
    2582:	          move.l 755e <SysBase>,d0
    2588:	          movea.l d0,a6
    258a:	          move.l 24(sp),d0
    258e:	          move.l 20(sp),d1
    2592:	          jsr -684(a6)
    2596:	          move.l d0,16(sp)
    259a:	          move.l 16(sp),d0
    259e:	          move.l d0,12(sp)
	if(s == 0) return NULL;
    25a2:	      /-- bne.s 25a8 <readString+0x4a>
    25a4:	      |   moveq #0,d0
    25a6:	/-----|-- bra.s 25fe <readString+0xa0>
	for (a = 0; a < len; a ++) {
    25a8:	|     \-> clr.l 32(sp)
    25ac:	|     /-- bra.s 25e4 <readString+0x86>
		s[a] = (char) (FGetC (fp) - 1);
    25ae:	|  /--|-> move.l 40(sp),8(sp)
    25b4:	|  |  |   move.l 7566 <DOSBase>,d0
    25ba:	|  |  |   movea.l d0,a6
    25bc:	|  |  |   move.l 8(sp),d1
    25c0:	|  |  |   jsr -306(a6)
    25c4:	|  |  |   move.l d0,4(sp)
    25c8:	|  |  |   move.l 4(sp),d0
    25cc:	|  |  |   move.l d0,d0
    25ce:	|  |  |   move.b d0,d1
    25d0:	|  |  |   subq.b #1,d1
    25d2:	|  |  |   move.l 32(sp),d0
    25d6:	|  |  |   movea.l 12(sp),a0
    25da:	|  |  |   adda.l d0,a0
    25dc:	|  |  |   move.b d1,d0
    25de:	|  |  |   move.b d0,(a0)
	for (a = 0; a < len; a ++) {
    25e0:	|  |  |   addq.l #1,32(sp)
    25e4:	|  |  \-> move.l 32(sp),d0
    25e8:	|  |      cmp.l 28(sp),d0
    25ec:	|  \----- blt.s 25ae <readString+0x50>
	}
	s[len] = 0;
    25ee:	|         move.l 28(sp),d0
    25f2:	|         movea.l 12(sp),a0
    25f6:	|         adda.l d0,a0
    25f8:	|         clr.b (a0)
	//debugOut ("MOREIO: readString: %s\n", s);
	return s;
    25fa:	|         move.l 12(sp),d0
    25fe:	\-------> movea.l (sp)+,a6
    2600:	          lea 32(sp),sp
    2604:	          rts

00002606 <initObjectTypes>:
#include <proto/exec.h>

#include "objtypes.h"

BOOL initObjectTypes () {
	return TRUE;
    2606:	moveq #1,d0
    2608:	rts

0000260a <getLanguageForFileB>:
int *languageTable;
char **languageName;
struct settingsStruct gameSettings;

int getLanguageForFileB ()
{
    260a:	          subq.l #8,sp
	int indexNum = -1;
    260c:	          moveq #-1,d0
    260e:	          move.l d0,4(sp)

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    2612:	          clr.l (sp)
    2614:	   /----- bra.s 263a <getLanguageForFileB+0x30>
		if (languageTable[i] == gameSettings.languageID) indexNum = i;
    2616:	/--|----> move.l 75d2 <languageTable>,d1
    261c:	|  |      move.l (sp),d0
    261e:	|  |      add.l d0,d0
    2620:	|  |      add.l d0,d0
    2622:	|  |      movea.l d1,a0
    2624:	|  |      adda.l d0,a0
    2626:	|  |      move.l (a0),d0
    2628:	|  |      move.l d0,d1
    262a:	|  |      move.l 75da <gameSettings>,d0
    2630:	|  |      cmp.l d1,d0
    2632:	|  |  /-- bne.s 2638 <getLanguageForFileB+0x2e>
    2634:	|  |  |   move.l (sp),4(sp)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    2638:	|  |  \-> addq.l #1,(sp)
    263a:	|  \----> move.l 75de <gameSettings+0x4>,d0
    2640:	|         cmp.l (sp),d0
    2642:	\-------- bcc.s 2616 <getLanguageForFileB+0xc>
	}

	return indexNum;
    2644:	          move.l 4(sp),d0
}
    2648:	          addq.l #8,sp
    264a:	          rts

0000264c <getPrefsFilename>:

char * getPrefsFilename (char * filename) {
    264c:	          lea -20(sp),sp
    2650:	          move.l a6,-(sp)
	// Yes, this trashes the original string, but
	// we also free it at the end (warning!)...

	int n, i;

	n = strlen (filename);
    2652:	          move.l 28(sp),-(sp)
    2656:	          jsr 2cf2 <strlen>
    265c:	          addq.l #4,sp
    265e:	          move.l d0,12(sp)


	if (n > 4 && filename[n-4] == '.') {
    2662:	          moveq #4,d0
    2664:	          cmp.l 12(sp),d0
    2668:	      /-- bge.s 268c <getPrefsFilename+0x40>
    266a:	      |   move.l 12(sp),d0
    266e:	      |   subq.l #4,d0
    2670:	      |   movea.l 28(sp),a0
    2674:	      |   adda.l d0,a0
    2676:	      |   move.b (a0),d0
    2678:	      |   cmpi.b #46,d0
    267c:	      +-- bne.s 268c <getPrefsFilename+0x40>
		filename[n-4] = 0;
    267e:	      |   move.l 12(sp),d0
    2682:	      |   subq.l #4,d0
    2684:	      |   movea.l 28(sp),a0
    2688:	      |   adda.l d0,a0
    268a:	      |   clr.b (a0)
	}

	char * f = filename;
    268c:	      \-> move.l 28(sp),16(sp)
	for (i = 0; i<n; i++) {
    2692:	          clr.l 20(sp)
    2696:	   /----- bra.s 26be <getPrefsFilename+0x72>
		if (filename[i] == '/') f = filename + i + 1;
    2698:	/--|----> move.l 20(sp),d0
    269c:	|  |      movea.l 28(sp),a0
    26a0:	|  |      adda.l d0,a0
    26a2:	|  |      move.b (a0),d0
    26a4:	|  |      cmpi.b #47,d0
    26a8:	|  |  /-- bne.s 26ba <getPrefsFilename+0x6e>
    26aa:	|  |  |   move.l 20(sp),d0
    26ae:	|  |  |   addq.l #1,d0
    26b0:	|  |  |   move.l 28(sp),d1
    26b4:	|  |  |   add.l d0,d1
    26b6:	|  |  |   move.l d1,16(sp)
	for (i = 0; i<n; i++) {
    26ba:	|  |  \-> addq.l #1,20(sp)
    26be:	|  \----> move.l 20(sp),d0
    26c2:	|         cmp.l 12(sp),d0
    26c6:	\-------- blt.s 2698 <getPrefsFilename+0x4c>
	}

	char * joined = joinStrings (f, ".ini");
    26c8:	          pea 5448 <sludger.c.a3710121+0xbe>
    26ce:	          move.l 20(sp),-(sp)
    26d2:	          jsr 2da0 <joinStrings>
    26d8:	          addq.l #8,sp
    26da:	          move.l d0,8(sp)

	FreeVec(filename);
    26de:	          move.l 28(sp),4(sp)
    26e4:	          move.l 755e <SysBase>,d0
    26ea:	          movea.l d0,a6
    26ec:	          movea.l 4(sp),a1
    26f0:	          jsr -690(a6)
	filename = NULL;
    26f4:	          clr.l 28(sp)
	return joined;
    26f8:	          move.l 8(sp),d0
}
    26fc:	          movea.l (sp)+,a6
    26fe:	          lea 20(sp),sp
    2702:	          rts

00002704 <makeLanguageTable>:

void makeLanguageTable (BPTR table)
{
    2704:	             lea -28(sp),sp
    2708:	             move.l a6,-(sp)
    270a:	             move.l a2,-(sp)
	languageTable = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    270c:	             move.l 75de <gameSettings+0x4>,d0
    2712:	             move.l d0,d1
    2714:	             addq.l #1,d1
    2716:	             move.l d1,28(sp)
    271a:	             clr.l 24(sp)
    271e:	             move.l 755e <SysBase>,d0
    2724:	             movea.l d0,a6
    2726:	             move.l 28(sp),d0
    272a:	             move.l 24(sp),d1
    272e:	             jsr -684(a6)
    2732:	             move.l d0,20(sp)
    2736:	             move.l 20(sp),d0
    273a:	             move.l d0,75d2 <languageTable>
    if( languageTable == 0) {
    2740:	             move.l 75d2 <languageTable>,d0
    2746:	         /-- bne.s 2756 <makeLanguageTable+0x52>
        KPrintF("makeLanguageTable: Cannot Alloc Mem for languageTable");
    2748:	         |   pea 544d <sludger.c.a3710121+0xc3>
    274e:	         |   jsr 3168 <KPrintF>
    2754:	         |   addq.l #4,sp
    }

	languageName = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    2756:	         \-> move.l 75de <gameSettings+0x4>,d0
    275c:	             move.l d0,d1
    275e:	             addq.l #1,d1
    2760:	             move.l d1,16(sp)
    2764:	             clr.l 12(sp)
    2768:	             move.l 755e <SysBase>,d0
    276e:	             movea.l d0,a6
    2770:	             move.l 16(sp),d0
    2774:	             move.l 12(sp),d1
    2778:	             jsr -684(a6)
    277c:	             move.l d0,8(sp)
    2780:	             move.l 8(sp),d0
    2784:	             move.l d0,75d6 <languageName>
	if( languageName == 0) {
    278a:	             move.l 75d6 <languageName>,d0
    2790:	         /-- bne.s 27a0 <makeLanguageTable+0x9c>
        KPrintF("makeLanguageName: Cannot Alloc Mem for languageName");
    2792:	         |   pea 5483 <sludger.c.a3710121+0xf9>
    2798:	         |   jsr 3168 <KPrintF>
    279e:	         |   addq.l #4,sp
    }

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    27a0:	         \-> clr.l 32(sp)
    27a4:	   /-------- bra.s 281c <makeLanguageTable+0x118>
		languageTable[i] = i ? get2bytes (table) : 0;
    27a6:	/--|-------> tst.l 32(sp)
    27aa:	|  |  /----- beq.s 27ba <makeLanguageTable+0xb6>
    27ac:	|  |  |      move.l 40(sp),-(sp)
    27b0:	|  |  |      jsr 23c6 <get2bytes>
    27b6:	|  |  |      addq.l #4,sp
    27b8:	|  |  |  /-- bra.s 27bc <makeLanguageTable+0xb8>
    27ba:	|  |  \--|-> moveq #0,d0
    27bc:	|  |     \-> movea.l 75d2 <languageTable>,a0
    27c2:	|  |         move.l 32(sp),d1
    27c6:	|  |         add.l d1,d1
    27c8:	|  |         add.l d1,d1
    27ca:	|  |         adda.l d1,a0
    27cc:	|  |         move.l d0,(a0)
		languageName[i] = 0;
    27ce:	|  |         move.l 75d6 <languageName>,d1
    27d4:	|  |         move.l 32(sp),d0
    27d8:	|  |         add.l d0,d0
    27da:	|  |         add.l d0,d0
    27dc:	|  |         movea.l d1,a0
    27de:	|  |         adda.l d0,a0
    27e0:	|  |         clr.l (a0)
		if (gameVersion >= VERSION(2,0)) {
    27e2:	|  |         move.l 74a6 <gameVersion>,d0
    27e8:	|  |         cmpi.l #511,d0
    27ee:	|  |     /-- ble.s 2818 <makeLanguageTable+0x114>
			if (gameSettings.numLanguages)
    27f0:	|  |     |   move.l 75de <gameSettings+0x4>,d0
    27f6:	|  |     +-- beq.s 2818 <makeLanguageTable+0x114>
				languageName[i] = readString (table);
    27f8:	|  |     |   move.l 75d6 <languageName>,d1
    27fe:	|  |     |   move.l 32(sp),d0
    2802:	|  |     |   add.l d0,d0
    2804:	|  |     |   add.l d0,d0
    2806:	|  |     |   movea.l d1,a2
    2808:	|  |     |   adda.l d0,a2
    280a:	|  |     |   move.l 40(sp),-(sp)
    280e:	|  |     |   jsr 255e <readString>
    2814:	|  |     |   addq.l #4,sp
    2816:	|  |     |   move.l d0,(a2)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    2818:	|  |     \-> addq.l #1,32(sp)
    281c:	|  \-------> move.l 75de <gameSettings+0x4>,d0
    2822:	|            cmp.l 32(sp),d0
    2826:	\----------- bcc.w 27a6 <makeLanguageTable+0xa2>
		}
	}
}
    282a:	             nop
    282c:	             nop
    282e:	             movea.l (sp)+,a2
    2830:	             movea.l (sp)+,a6
    2832:	             lea 28(sp),sp
    2836:	             rts

00002838 <readIniFile>:

void readIniFile (char * filename) {
    2838:	                      lea -564(sp),sp
    283c:	                      move.l a6,-(sp)
    283e:	                      move.l d2,-(sp)
	char * langName = getPrefsFilename (copyString (filename));
    2840:	                      move.l 576(sp),-(sp)
    2844:	                      jsr 2d32 <copyString>
    284a:	                      addq.l #4,sp
    284c:	                      move.l d0,-(sp)
    284e:	                      jsr 264c <getPrefsFilename>
    2854:	                      addq.l #4,sp
    2856:	                      move.l d0,562(sp)

	BPTR fp = Open(langName,MODE_OLDFILE);	
    285a:	                      move.l 562(sp),558(sp)
    2860:	                      move.l #1005,554(sp)
    2868:	                      move.l 7566 <DOSBase>,d0
    286e:	                      movea.l d0,a6
    2870:	                      move.l 558(sp),d1
    2874:	                      move.l 554(sp),d2
    2878:	                      jsr -30(a6)
    287c:	                      move.l d0,550(sp)
    2880:	                      move.l 550(sp),d0
    2884:	                      move.l d0,546(sp)

	gameSettings.languageID = 0;
    2888:	                      clr.l 75da <gameSettings>
	gameSettings.userFullScreen = TRUE; //Always fullscreen on AMIGA
    288e:	                      move.w #1,75e2 <gameSettings+0x8>
	gameSettings.refreshRate = 0;
    2896:	                      clr.l 75e4 <gameSettings+0xa>
	gameSettings.antiAlias = 1;
    289c:	                      moveq #1,d0
    289e:	                      move.l d0,75e8 <gameSettings+0xe>
	gameSettings.fixedPixels = FALSE;
    28a4:	                      clr.w 75ec <gameSettings+0x12>
	gameSettings.noStartWindow = FALSE;
    28aa:	                      clr.w 75ee <gameSettings+0x14>
	gameSettings.debugMode = FALSE;
    28b0:	                      clr.w 75f0 <gameSettings+0x16>

	FreeVec(langName);
    28b6:	                      move.l 562(sp),542(sp)
    28bc:	                      move.l 755e <SysBase>,d0
    28c2:	                      movea.l d0,a6
    28c4:	                      movea.l 542(sp),a1
    28c8:	                      jsr -690(a6)
	langName = NULL;
    28cc:	                      clr.l 562(sp)

	if (fp) {
    28d0:	                      tst.l 546(sp)
    28d4:	/-------------------- beq.w 2bb2 <readIniFile+0x37a>
		char lineSoFar[257] = "";
    28d8:	|                     move.l sp,d0
    28da:	|                     addi.l #265,d0
    28e0:	|                     move.l #257,d1
    28e6:	|                     move.l d1,-(sp)
    28e8:	|                     clr.l -(sp)
    28ea:	|                     move.l d0,-(sp)
    28ec:	|                     jsr 3138 <memset>
    28f2:	|                     lea 12(sp),sp
		char secondSoFar[257] = "";
    28f6:	|                     move.l sp,d0
    28f8:	|                     addq.l #8,d0
    28fa:	|                     move.l #257,d1
    2900:	|                     move.l d1,-(sp)
    2902:	|                     clr.l -(sp)
    2904:	|                     move.l d0,-(sp)
    2906:	|                     jsr 3138 <memset>
    290c:	|                     lea 12(sp),sp
		unsigned char here = 0;
    2910:	|                     clr.b 571(sp)
		char readChar = ' ';
    2914:	|                     move.b #32,570(sp)
		BOOL keepGoing = TRUE;
    291a:	|                     move.w #1,568(sp)
		BOOL doingSecond = FALSE;
    2920:	|                     clr.w 566(sp)
		LONG tmp = 0;
    2924:	|                     clr.l 538(sp)

		do {

			tmp = FGetC (fp);
    2928:	|  /----------------> move.l 546(sp),534(sp)
    292e:	|  |                  move.l 7566 <DOSBase>,d0
    2934:	|  |                  movea.l d0,a6
    2936:	|  |                  move.l 534(sp),d1
    293a:	|  |                  jsr -306(a6)
    293e:	|  |                  move.l d0,530(sp)
    2942:	|  |                  move.l 530(sp),d0
    2946:	|  |                  move.l d0,538(sp)
			if (tmp == - 1) {
    294a:	|  |                  moveq #-1,d1
    294c:	|  |                  cmp.l 538(sp),d1
    2950:	|  |           /----- bne.s 295e <readIniFile+0x126>
				readChar = '\n';
    2952:	|  |           |      move.b #10,570(sp)
				keepGoing = FALSE;
    2958:	|  |           |      clr.w 568(sp)
    295c:	|  |           |  /-- bra.s 2964 <readIniFile+0x12c>
			} else {
				readChar = (char) tmp;
    295e:	|  |           \--|-> move.b 541(sp),570(sp)
			}

			switch (readChar) {
    2964:	|  |              \-> move.b 570(sp),d0
    2968:	|  |                  ext.w d0
    296a:	|  |                  movea.w d0,a0
    296c:	|  |                  moveq #61,d0
    296e:	|  |                  cmp.l a0,d0
    2970:	|  |     /----------- beq.w 2b1a <readIniFile+0x2e2>
    2974:	|  |     |            moveq #61,d1
    2976:	|  |     |            cmp.l a0,d1
    2978:	|  |  /--|----------- blt.w 2b26 <readIniFile+0x2ee>
    297c:	|  |  |  |            moveq #10,d0
    297e:	|  |  |  |            cmp.l a0,d0
    2980:	|  |  |  |        /-- beq.s 298a <readIniFile+0x152>
    2982:	|  |  |  |        |   moveq #13,d1
    2984:	|  |  |  |        |   cmp.l a0,d1
    2986:	|  |  +--|--------|-- bne.w 2b26 <readIniFile+0x2ee>
				case '\n':
				case '\r':
				if (doingSecond) {
    298a:	|  |  |  |        \-> tst.w 566(sp)
    298e:	|  |  |  |     /----- beq.w 2b08 <readIniFile+0x2d0>
					if (strcmp (lineSoFar, "LANGUAGE") == 0)
    2992:	|  |  |  |     |      pea 54b7 <sludger.c.a3710121+0x12d>
    2998:	|  |  |  |     |      move.l sp,d0
    299a:	|  |  |  |     |      addi.l #269,d0
    29a0:	|  |  |  |     |      move.l d0,-(sp)
    29a2:	|  |  |  |     |      jsr 2cb2 <strcmp>
    29a8:	|  |  |  |     |      addq.l #8,sp
    29aa:	|  |  |  |     |      tst.l d0
    29ac:	|  |  |  |     |  /-- bne.s 29c6 <readIniFile+0x18e>
					{
						gameSettings.languageID = stringToInt (secondSoFar);
    29ae:	|  |  |  |     |  |   move.l sp,d0
    29b0:	|  |  |  |     |  |   addq.l #8,d0
    29b2:	|  |  |  |     |  |   move.l d0,-(sp)
    29b4:	|  |  |  |     |  |   jsr 2bbe <stringToInt>
    29ba:	|  |  |  |     |  |   addq.l #4,sp
    29bc:	|  |  |  |     |  |   move.l d0,75da <gameSettings>
    29c2:	|  |  |  |     +--|-- bra.w 2b08 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "WINDOW") == 0)
    29c6:	|  |  |  |     |  \-> pea 54c0 <sludger.c.a3710121+0x136>
    29cc:	|  |  |  |     |      move.l sp,d0
    29ce:	|  |  |  |     |      addi.l #269,d0
    29d4:	|  |  |  |     |      move.l d0,-(sp)
    29d6:	|  |  |  |     |      jsr 2cb2 <strcmp>
    29dc:	|  |  |  |     |      addq.l #8,sp
    29de:	|  |  |  |     |      tst.l d0
    29e0:	|  |  |  |     |  /-- bne.s 2a06 <readIniFile+0x1ce>
					{
						gameSettings.userFullScreen = ! stringToInt (secondSoFar);
    29e2:	|  |  |  |     |  |   move.l sp,d0
    29e4:	|  |  |  |     |  |   addq.l #8,d0
    29e6:	|  |  |  |     |  |   move.l d0,-(sp)
    29e8:	|  |  |  |     |  |   jsr 2bbe <stringToInt>
    29ee:	|  |  |  |     |  |   addq.l #4,sp
    29f0:	|  |  |  |     |  |   tst.l d0
    29f2:	|  |  |  |     |  |   seq d0
    29f4:	|  |  |  |     |  |   neg.b d0
    29f6:	|  |  |  |     |  |   move.b d0,d0
    29f8:	|  |  |  |     |  |   andi.w #255,d0
    29fc:	|  |  |  |     |  |   move.w d0,75e2 <gameSettings+0x8>
    2a02:	|  |  |  |     +--|-- bra.w 2b08 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "REFRESH") == 0)
    2a06:	|  |  |  |     |  \-> pea 54c7 <sludger.c.a3710121+0x13d>
    2a0c:	|  |  |  |     |      move.l sp,d0
    2a0e:	|  |  |  |     |      addi.l #269,d0
    2a14:	|  |  |  |     |      move.l d0,-(sp)
    2a16:	|  |  |  |     |      jsr 2cb2 <strcmp>
    2a1c:	|  |  |  |     |      addq.l #8,sp
    2a1e:	|  |  |  |     |      tst.l d0
    2a20:	|  |  |  |     |  /-- bne.s 2a3a <readIniFile+0x202>
					{
						gameSettings.refreshRate = stringToInt (secondSoFar);
    2a22:	|  |  |  |     |  |   move.l sp,d0
    2a24:	|  |  |  |     |  |   addq.l #8,d0
    2a26:	|  |  |  |     |  |   move.l d0,-(sp)
    2a28:	|  |  |  |     |  |   jsr 2bbe <stringToInt>
    2a2e:	|  |  |  |     |  |   addq.l #4,sp
    2a30:	|  |  |  |     |  |   move.l d0,75e4 <gameSettings+0xa>
    2a36:	|  |  |  |     +--|-- bra.w 2b08 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "ANTIALIAS") == 0)
    2a3a:	|  |  |  |     |  \-> pea 54cf <sludger.c.a3710121+0x145>
    2a40:	|  |  |  |     |      move.l sp,d0
    2a42:	|  |  |  |     |      addi.l #269,d0
    2a48:	|  |  |  |     |      move.l d0,-(sp)
    2a4a:	|  |  |  |     |      jsr 2cb2 <strcmp>
    2a50:	|  |  |  |     |      addq.l #8,sp
    2a52:	|  |  |  |     |      tst.l d0
    2a54:	|  |  |  |     |  /-- bne.s 2a6e <readIniFile+0x236>
					{
						gameSettings.antiAlias = stringToInt (secondSoFar);
    2a56:	|  |  |  |     |  |   move.l sp,d0
    2a58:	|  |  |  |     |  |   addq.l #8,d0
    2a5a:	|  |  |  |     |  |   move.l d0,-(sp)
    2a5c:	|  |  |  |     |  |   jsr 2bbe <stringToInt>
    2a62:	|  |  |  |     |  |   addq.l #4,sp
    2a64:	|  |  |  |     |  |   move.l d0,75e8 <gameSettings+0xe>
    2a6a:	|  |  |  |     +--|-- bra.w 2b08 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "FIXEDPIXELS") == 0)
    2a6e:	|  |  |  |     |  \-> pea 54d9 <sludger.c.a3710121+0x14f>
    2a74:	|  |  |  |     |      move.l sp,d0
    2a76:	|  |  |  |     |      addi.l #269,d0
    2a7c:	|  |  |  |     |      move.l d0,-(sp)
    2a7e:	|  |  |  |     |      jsr 2cb2 <strcmp>
    2a84:	|  |  |  |     |      addq.l #8,sp
    2a86:	|  |  |  |     |      tst.l d0
    2a88:	|  |  |  |     |  /-- bne.s 2aa2 <readIniFile+0x26a>
					{
						gameSettings.fixedPixels = stringToInt (secondSoFar);
    2a8a:	|  |  |  |     |  |   move.l sp,d0
    2a8c:	|  |  |  |     |  |   addq.l #8,d0
    2a8e:	|  |  |  |     |  |   move.l d0,-(sp)
    2a90:	|  |  |  |     |  |   jsr 2bbe <stringToInt>
    2a96:	|  |  |  |     |  |   addq.l #4,sp
    2a98:	|  |  |  |     |  |   move.l d0,d0
    2a9a:	|  |  |  |     |  |   move.w d0,75ec <gameSettings+0x12>
    2aa0:	|  |  |  |     +--|-- bra.s 2b08 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "NOSTARTWINDOW") == 0)
    2aa2:	|  |  |  |     |  \-> pea 54e5 <sludger.c.a3710121+0x15b>
    2aa8:	|  |  |  |     |      move.l sp,d0
    2aaa:	|  |  |  |     |      addi.l #269,d0
    2ab0:	|  |  |  |     |      move.l d0,-(sp)
    2ab2:	|  |  |  |     |      jsr 2cb2 <strcmp>
    2ab8:	|  |  |  |     |      addq.l #8,sp
    2aba:	|  |  |  |     |      tst.l d0
    2abc:	|  |  |  |     |  /-- bne.s 2ad6 <readIniFile+0x29e>
					{
						gameSettings.noStartWindow = stringToInt (secondSoFar);
    2abe:	|  |  |  |     |  |   move.l sp,d0
    2ac0:	|  |  |  |     |  |   addq.l #8,d0
    2ac2:	|  |  |  |     |  |   move.l d0,-(sp)
    2ac4:	|  |  |  |     |  |   jsr 2bbe <stringToInt>
    2aca:	|  |  |  |     |  |   addq.l #4,sp
    2acc:	|  |  |  |     |  |   move.l d0,d0
    2ace:	|  |  |  |     |  |   move.w d0,75ee <gameSettings+0x14>
    2ad4:	|  |  |  |     +--|-- bra.s 2b08 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "DEBUGMODE") == 0)
    2ad6:	|  |  |  |     |  \-> pea 54f3 <sludger.c.a3710121+0x169>
    2adc:	|  |  |  |     |      move.l sp,d0
    2ade:	|  |  |  |     |      addi.l #269,d0
    2ae4:	|  |  |  |     |      move.l d0,-(sp)
    2ae6:	|  |  |  |     |      jsr 2cb2 <strcmp>
    2aec:	|  |  |  |     |      addq.l #8,sp
    2aee:	|  |  |  |     |      tst.l d0
    2af0:	|  |  |  |     +----- bne.s 2b08 <readIniFile+0x2d0>
					{
						gameSettings.debugMode = stringToInt (secondSoFar);
    2af2:	|  |  |  |     |      move.l sp,d0
    2af4:	|  |  |  |     |      addq.l #8,d0
    2af6:	|  |  |  |     |      move.l d0,-(sp)
    2af8:	|  |  |  |     |      jsr 2bbe <stringToInt>
    2afe:	|  |  |  |     |      addq.l #4,sp
    2b00:	|  |  |  |     |      move.l d0,d0
    2b02:	|  |  |  |     |      move.w d0,75f0 <gameSettings+0x16>
					}
				}
				here = 0;
    2b08:	|  |  |  |     \----> clr.b 571(sp)
				doingSecond = FALSE;
    2b0c:	|  |  |  |            clr.w 566(sp)
				lineSoFar[0] = 0;
    2b10:	|  |  |  |            clr.b 265(sp)
				secondSoFar[0] = 0;
    2b14:	|  |  |  |            clr.b 8(sp)
				break;
    2b18:	|  |  |  |  /-------- bra.s 2b90 <readIniFile+0x358>

				case '=':
				doingSecond = TRUE;
    2b1a:	|  |  |  \--|-------> move.w #1,566(sp)
				here = 0;
    2b20:	|  |  |     |         clr.b 571(sp)
				break;
    2b24:	|  |  |     +-------- bra.s 2b90 <readIniFile+0x358>

				default:
				if (doingSecond) {
    2b26:	|  |  \-----|-------> tst.w 566(sp)
    2b2a:	|  |        |  /----- beq.s 2b5e <readIniFile+0x326>
					secondSoFar[here ++] = readChar;
    2b2c:	|  |        |  |      move.b 571(sp),d0
    2b30:	|  |        |  |      move.b d0,d1
    2b32:	|  |        |  |      addq.b #1,d1
    2b34:	|  |        |  |      move.b d1,571(sp)
    2b38:	|  |        |  |      move.b d0,d0
    2b3a:	|  |        |  |      andi.l #255,d0
    2b40:	|  |        |  |      lea 572(sp),a0
    2b44:	|  |        |  |      adda.l d0,a0
    2b46:	|  |        |  |      move.b 570(sp),-564(a0)
					secondSoFar[here] = 0;
    2b4c:	|  |        |  |      moveq #0,d0
    2b4e:	|  |        |  |      move.b 571(sp),d0
    2b52:	|  |        |  |      lea 572(sp),a0
    2b56:	|  |        |  |      adda.l d0,a0
    2b58:	|  |        |  |      clr.b -564(a0)
				} else {
					lineSoFar[here ++] = readChar;
					lineSoFar[here] = 0;
				}
				break;
    2b5c:	|  |        |  |  /-- bra.s 2b8e <readIniFile+0x356>
					lineSoFar[here ++] = readChar;
    2b5e:	|  |        |  \--|-> move.b 571(sp),d0
    2b62:	|  |        |     |   move.b d0,d1
    2b64:	|  |        |     |   addq.b #1,d1
    2b66:	|  |        |     |   move.b d1,571(sp)
    2b6a:	|  |        |     |   move.b d0,d0
    2b6c:	|  |        |     |   andi.l #255,d0
    2b72:	|  |        |     |   lea 572(sp),a0
    2b76:	|  |        |     |   adda.l d0,a0
    2b78:	|  |        |     |   move.b 570(sp),-307(a0)
					lineSoFar[here] = 0;
    2b7e:	|  |        |     |   moveq #0,d0
    2b80:	|  |        |     |   move.b 571(sp),d0
    2b84:	|  |        |     |   lea 572(sp),a0
    2b88:	|  |        |     |   adda.l d0,a0
    2b8a:	|  |        |     |   clr.b -307(a0)
				break;
    2b8e:	|  |        |     \-> nop
			}
		} while (keepGoing);
    2b90:	|  |        \-------> tst.w 568(sp)
    2b94:	|  \----------------- bne.w 2928 <readIniFile+0xf0>

		Close(fp);
    2b98:	|                     move.l 546(sp),526(sp)
    2b9e:	|                     move.l 7566 <DOSBase>,d0
    2ba4:	|                     movea.l d0,a6
    2ba6:	|                     move.l 526(sp),d1
    2baa:	|                     jsr -36(a6)
    2bae:	|                     move.l d0,522(sp)
	}
}
    2bb2:	\-------------------> nop
    2bb4:	                      move.l (sp)+,d2
    2bb6:	                      movea.l (sp)+,a6
    2bb8:	                      lea 564(sp),sp
    2bbc:	                      rts

00002bbe <stringToInt>:

unsigned int stringToInt (char * s) {
    2bbe:	             subq.l #8,sp
	int i = 0;
    2bc0:	             clr.l 4(sp)
	BOOL negative = FALSE;
    2bc4:	             clr.w 2(sp)
	for (;;) {
		if (*s >= '0' && *s <= '9') {
    2bc8:	/----------> movea.l 12(sp),a0
    2bcc:	|            move.b (a0),d0
    2bce:	|            cmpi.b #47,d0
    2bd2:	|        /-- ble.s 2c0a <stringToInt+0x4c>
    2bd4:	|        |   movea.l 12(sp),a0
    2bd8:	|        |   move.b (a0),d0
    2bda:	|        |   cmpi.b #57,d0
    2bde:	|        +-- bgt.s 2c0a <stringToInt+0x4c>
			i *= 10;
    2be0:	|        |   move.l 4(sp),d1
    2be4:	|        |   move.l d1,d0
    2be6:	|        |   add.l d0,d0
    2be8:	|        |   add.l d0,d0
    2bea:	|        |   add.l d1,d0
    2bec:	|        |   add.l d0,d0
    2bee:	|        |   move.l d0,4(sp)
			i += *s - '0';
    2bf2:	|        |   movea.l 12(sp),a0
    2bf6:	|        |   move.b (a0),d0
    2bf8:	|        |   ext.w d0
    2bfa:	|        |   movea.w d0,a0
    2bfc:	|        |   moveq #-48,d0
    2bfe:	|        |   add.l a0,d0
    2c00:	|        |   add.l d0,4(sp)
			s ++;
    2c04:	|        |   addq.l #1,12(sp)
    2c08:	|  /-----|-- bra.s 2c42 <stringToInt+0x84>
		} else if (*s == '-') {
    2c0a:	|  |     \-> movea.l 12(sp),a0
    2c0e:	|  |         move.b (a0),d0
    2c10:	|  |         cmpi.b #45,d0
    2c14:	|  |     /-- bne.s 2c2e <stringToInt+0x70>
			negative = ! negative;
    2c16:	|  |     |   tst.w 2(sp)
    2c1a:	|  |     |   seq d0
    2c1c:	|  |     |   neg.b d0
    2c1e:	|  |     |   move.b d0,d0
    2c20:	|  |     |   andi.w #255,d0
    2c24:	|  |     |   move.w d0,2(sp)
			s++;
    2c28:	|  |     |   addq.l #1,12(sp)
    2c2c:	+--|-----|-- bra.s 2bc8 <stringToInt+0xa>
		} else {
			if (negative)
    2c2e:	|  |     \-> tst.w 2(sp)
    2c32:	|  |     /-- beq.s 2c3c <stringToInt+0x7e>
				return -i;
    2c34:	|  |     |   move.l 4(sp),d0
    2c38:	|  |     |   neg.l d0
    2c3a:	|  |  /--|-- bra.s 2c44 <stringToInt+0x86>
			return i;
    2c3c:	|  |  |  \-> move.l 4(sp),d0
    2c40:	|  |  +----- bra.s 2c44 <stringToInt+0x86>
		if (*s >= '0' && *s <= '9') {
    2c42:	\--\--|----X bra.s 2bc8 <stringToInt+0xa>
		}
	}
    2c44:	      \----> addq.l #8,sp
    2c46:	             rts

00002c48 <fileExists>:
 *  Helper functions that don't depend on other source files.
 */
#include <proto/dos.h>
#include "helpers.h"

BYTE fileExists(const char * file) {
    2c48:	    lea -28(sp),sp
    2c4c:	    move.l a6,-(sp)
    2c4e:	    move.l d2,-(sp)
	BPTR tester;
	BYTE retval = 0;
    2c50:	    clr.b 35(sp)
	tester = Open(file, MODE_OLDFILE);
    2c54:	    move.l 40(sp),30(sp)
    2c5a:	    move.l #1005,26(sp)
    2c62:	    move.l 7566 <DOSBase>,d0
    2c68:	    movea.l d0,a6
    2c6a:	    move.l 30(sp),d1
    2c6e:	    move.l 26(sp),d2
    2c72:	    jsr -30(a6)
    2c76:	    move.l d0,22(sp)
    2c7a:	    move.l 22(sp),d0
    2c7e:	    move.l d0,18(sp)
	if (tester) {
    2c82:	/-- beq.s 2ca4 <fileExists+0x5c>
		retval = 1;
    2c84:	|   move.b #1,35(sp)
		Close(tester);
    2c8a:	|   move.l 18(sp),14(sp)
    2c90:	|   move.l 7566 <DOSBase>,d0
    2c96:	|   movea.l d0,a6
    2c98:	|   move.l 14(sp),d1
    2c9c:	|   jsr -36(a6)
    2ca0:	|   move.l d0,10(sp)
	}
	return retval;
    2ca4:	\-> move.b 35(sp),d0
    2ca8:	    move.l (sp)+,d2
    2caa:	    movea.l (sp)+,a6
    2cac:	    lea 28(sp),sp
    2cb0:	    rts

00002cb2 <strcmp>:
#include "support/gcc8_c_support.h"


int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1 == *s2))
    2cb2:	   /-- bra.s 2cbc <strcmp+0xa>
    {
        s1++;
    2cb4:	/--|-> addq.l #1,4(sp)
        s2++;
    2cb8:	|  |   addq.l #1,8(sp)
    while(*s1 && (*s1 == *s2))
    2cbc:	|  \-> movea.l 4(sp),a0
    2cc0:	|      move.b (a0),d0
    2cc2:	|  /-- beq.s 2cd4 <strcmp+0x22>
    2cc4:	|  |   movea.l 4(sp),a0
    2cc8:	|  |   move.b (a0),d1
    2cca:	|  |   movea.l 8(sp),a0
    2cce:	|  |   move.b (a0),d0
    2cd0:	|  |   cmp.b d1,d0
    2cd2:	\--|-- beq.s 2cb4 <strcmp+0x2>
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
    2cd4:	   \-> movea.l 4(sp),a0
    2cd8:	       move.b (a0),d0
    2cda:	       moveq #0,d1
    2cdc:	       move.b d0,d1
    2cde:	       movea.l 8(sp),a0
    2ce2:	       move.b (a0),d0
    2ce4:	       move.b d0,d0
    2ce6:	       andi.l #255,d0
    2cec:	       sub.l d0,d1
    2cee:	       move.l d1,d0
}
    2cf0:	       rts

00002cf2 <strlen>:

long unsigned int strlen (const char *s) 
{  
    2cf2:	       subq.l #4,sp
	long unsigned int i = 0;
    2cf4:	       clr.l (sp)
	while(s[i]) i++; 
    2cf6:	   /-- bra.s 2cfa <strlen+0x8>
    2cf8:	/--|-> addq.l #1,(sp)
    2cfa:	|  \-> movea.l 8(sp),a0
    2cfe:	|      adda.l (sp),a0
    2d00:	|      move.b (a0),d0
    2d02:	\----- bne.s 2cf8 <strlen+0x6>
	return(i);
    2d04:	       move.l (sp),d0
}
    2d06:	       addq.l #4,sp
    2d08:	       rts

00002d0a <strcpy>:

char *strcpy(char *t, const char *s) 
{
	while(*t++ = *s++);
    2d0a:	    nop
    2d0c:	/-> move.l 8(sp),d0
    2d10:	|   move.l d0,d1
    2d12:	|   addq.l #1,d1
    2d14:	|   move.l d1,8(sp)
    2d18:	|   movea.l 4(sp),a0
    2d1c:	|   lea 1(a0),a1
    2d20:	|   move.l a1,4(sp)
    2d24:	|   movea.l d0,a1
    2d26:	|   move.b (a1),d0
    2d28:	|   move.b d0,(a0)
    2d2a:	|   move.b (a0),d0
    2d2c:	\-- bne.s 2d0c <strcpy+0x2>
}
    2d2e:	    nop
    2d30:	    rts

00002d32 <copyString>:

char * copyString (const char * copyMe) {
    2d32:	       lea -16(sp),sp
    2d36:	       move.l a6,-(sp)
	
	char * newString = AllocVec(strlen(copyMe)+1, MEMF_ANY); 
    2d38:	       move.l 24(sp),-(sp)
    2d3c:	       jsr 2cf2 <strlen>
    2d42:	       addq.l #4,sp
    2d44:	       move.l d0,d1
    2d46:	       addq.l #1,d1
    2d48:	       move.l d1,16(sp)
    2d4c:	       clr.l 12(sp)
    2d50:	       move.l 755e <SysBase>,d0
    2d56:	       movea.l d0,a6
    2d58:	       move.l 16(sp),d0
    2d5c:	       move.l 12(sp),d1
    2d60:	       jsr -684(a6)
    2d64:	       move.l d0,8(sp)
    2d68:	       move.l 8(sp),d0
    2d6c:	       move.l d0,4(sp)
	if(newString == 0) {
    2d70:	   /-- bne.s 2d84 <copyString+0x52>
		KPrintF("copystring: Can't reserve memory for newString\n");
    2d72:	   |   pea 54fd <sludger.c.a3710121+0x173>
    2d78:	   |   jsr 3168 <KPrintF>
    2d7e:	   |   addq.l #4,sp
		return NULL;	
    2d80:	   |   moveq #0,d0
    2d82:	/--|-- bra.s 2d98 <copyString+0x66>
	}
	strcpy (newString, copyMe);
    2d84:	|  \-> move.l 24(sp),-(sp)
    2d88:	|      move.l 8(sp),-(sp)
    2d8c:	|      jsr 2d0a <strcpy>
    2d92:	|      addq.l #8,sp
	return newString;
    2d94:	|      move.l 4(sp),d0
}
    2d98:	\----> movea.l (sp)+,a6
    2d9a:	       lea 16(sp),sp
    2d9e:	       rts

00002da0 <joinStrings>:

char * joinStrings (const char * s1, const char * s2) {
    2da0:	    lea -20(sp),sp
    2da4:	    move.l a6,-(sp)
    2da6:	    move.l d2,-(sp)
	char * newString = AllocVec(strlen (s1) + strlen (s2) + 1, MEMF_ANY); 
    2da8:	    move.l 32(sp),-(sp)
    2dac:	    jsr 2cf2 <strlen>
    2db2:	    addq.l #4,sp
    2db4:	    move.l d0,d2
    2db6:	    move.l 36(sp),-(sp)
    2dba:	    jsr 2cf2 <strlen>
    2dc0:	    addq.l #4,sp
    2dc2:	    add.l d2,d0
    2dc4:	    move.l d0,d1
    2dc6:	    addq.l #1,d1
    2dc8:	    move.l d1,20(sp)
    2dcc:	    clr.l 16(sp)
    2dd0:	    move.l 755e <SysBase>,d0
    2dd6:	    movea.l d0,a6
    2dd8:	    move.l 20(sp),d0
    2ddc:	    move.l 16(sp),d1
    2de0:	    jsr -684(a6)
    2de4:	    move.l d0,12(sp)
    2de8:	    move.l 12(sp),d0
    2dec:	    move.l d0,8(sp)
	char * t = newString;
    2df0:	    move.l 8(sp),24(sp)

	while(*t++ = *s1++);
    2df6:	    nop
    2df8:	/-> move.l 32(sp),d0
    2dfc:	|   move.l d0,d1
    2dfe:	|   addq.l #1,d1
    2e00:	|   move.l d1,32(sp)
    2e04:	|   movea.l 24(sp),a0
    2e08:	|   lea 1(a0),a1
    2e0c:	|   move.l a1,24(sp)
    2e10:	|   movea.l d0,a1
    2e12:	|   move.b (a1),d0
    2e14:	|   move.b d0,(a0)
    2e16:	|   move.b (a0),d0
    2e18:	\-- bne.s 2df8 <joinStrings+0x58>
	t--;
    2e1a:	    subq.l #1,24(sp)
	while(*t++ = *s2++);
    2e1e:	    nop
    2e20:	/-> move.l 36(sp),d0
    2e24:	|   move.l d0,d1
    2e26:	|   addq.l #1,d1
    2e28:	|   move.l d1,36(sp)
    2e2c:	|   movea.l 24(sp),a0
    2e30:	|   lea 1(a0),a1
    2e34:	|   move.l a1,24(sp)
    2e38:	|   movea.l d0,a1
    2e3a:	|   move.b (a1),d0
    2e3c:	|   move.b d0,(a0)
    2e3e:	|   move.b (a0),d0
    2e40:	\-- bne.s 2e20 <joinStrings+0x80>

	return newString;
    2e42:	    move.l 8(sp),d0
}
    2e46:	    move.l (sp)+,d2
    2e48:	    movea.l (sp)+,a6
    2e4a:	    lea 20(sp),sp
    2e4e:	    rts

00002e50 <unlinkVar>:
#include "support/gcc8_c_support.h"
#include "people.h"
#include "stringy.h"
#include "variable.h"

void unlinkVar (struct variable thisVar) {
    2e50:	                      lea -16(sp),sp
    2e54:	                      move.l a6,-(sp)
	switch (thisVar.varType) {
    2e56:	                      move.l 24(sp),d0
    2e5a:	                      moveq #10,d1
    2e5c:	                      cmp.l d0,d1
    2e5e:	            /-------- beq.w 2ef8 <unlinkVar+0xa8>
    2e62:	            |         moveq #10,d1
    2e64:	            |         cmp.l d0,d1
    2e66:	/-----------|-------- bcs.w 2f54 <unlinkVar+0x104>
    2e6a:	|           |         moveq #8,d1
    2e6c:	|           |         cmp.l d0,d1
    2e6e:	|  /--------|-------- beq.w 2f44 <unlinkVar+0xf4>
    2e72:	|  |        |         moveq #8,d1
    2e74:	|  |        |         cmp.l d0,d1
    2e76:	+--|--------|-------- bcs.w 2f54 <unlinkVar+0x104>
    2e7a:	|  |        |         moveq #3,d1
    2e7c:	|  |        |         cmp.l d0,d1
    2e7e:	|  |        |     /-- beq.s 2e8a <unlinkVar+0x3a>
    2e80:	|  |        |     |   moveq #6,d1
    2e82:	|  |        |     |   cmp.l d0,d1
    2e84:	|  |        |  /--|-- beq.s 2ea8 <unlinkVar+0x58>
		case SVT_ANIM:
		deleteAnim (thisVar.varData.animHandler);
		break;

		default:
		break;
    2e86:	+--|--------|--|--|-- bra.w 2f54 <unlinkVar+0x104>
        FreeVec(thisVar.varData.theString);
    2e8a:	|  |        |  |  \-> move.l 28(sp),4(sp)
    2e90:	|  |        |  |      move.l 755e <SysBase>,d0
    2e96:	|  |        |  |      movea.l d0,a6
    2e98:	|  |        |  |      movea.l 4(sp),a1
    2e9c:	|  |        |  |      jsr -690(a6)
		thisVar.varData.theString = NULL;
    2ea0:	|  |        |  |      clr.l 28(sp)
		break;
    2ea4:	|  |  /-----|--|----- bra.w 2f5e <unlinkVar+0x10e>
		thisVar.varData.theStack -> timesUsed --;
    2ea8:	|  |  |     |  \----> movea.l 28(sp),a0
    2eac:	|  |  |     |         move.l 8(a0),d0
    2eb0:	|  |  |     |         subq.l #1,d0
    2eb2:	|  |  |     |         move.l d0,8(a0)
		if (thisVar.varData.theStack -> timesUsed <= 0) {
    2eb6:	|  |  |     |         movea.l 28(sp),a0
    2eba:	|  |  |     |         move.l 8(a0),d0
    2ebe:	|  |  |  /--|-------- bgt.w 2f58 <unlinkVar+0x108>
			while (thisVar.varData.theStack -> first) trimStack (thisVar.varData.theStack -> first);
    2ec2:	|  |  |  |  |     /-- bra.s 2ed4 <unlinkVar+0x84>
    2ec4:	|  |  |  |  |  /--|-> movea.l 28(sp),a0
    2ec8:	|  |  |  |  |  |  |   move.l (a0),d0
    2eca:	|  |  |  |  |  |  |   move.l d0,-(sp)
    2ecc:	|  |  |  |  |  |  |   jsr 306c <trimStack>
    2ed2:	|  |  |  |  |  |  |   addq.l #4,sp
    2ed4:	|  |  |  |  |  |  \-> movea.l 28(sp),a0
    2ed8:	|  |  |  |  |  |      move.l (a0),d0
    2eda:	|  |  |  |  |  \----- bne.s 2ec4 <unlinkVar+0x74>
			FreeVec(thisVar.varData.theStack);
    2edc:	|  |  |  |  |         move.l 28(sp),8(sp)
    2ee2:	|  |  |  |  |         move.l 755e <SysBase>,d0
    2ee8:	|  |  |  |  |         movea.l d0,a6
    2eea:	|  |  |  |  |         movea.l 8(sp),a1
    2eee:	|  |  |  |  |         jsr -690(a6)
			thisVar.varData.theStack = NULL;
    2ef2:	|  |  |  |  |         clr.l 28(sp)
		break;
    2ef6:	|  |  |  +--|-------- bra.s 2f58 <unlinkVar+0x108>
		thisVar.varData.fastArray -> timesUsed --;
    2ef8:	|  |  |  |  \-------> movea.l 28(sp),a0
    2efc:	|  |  |  |            move.l 8(a0),d0
    2f00:	|  |  |  |            subq.l #1,d0
    2f02:	|  |  |  |            move.l d0,8(a0)
		if (thisVar.varData.theStack -> timesUsed <= 0) {
    2f06:	|  |  |  |            movea.l 28(sp),a0
    2f0a:	|  |  |  |            move.l 8(a0),d0
    2f0e:	|  |  |  |        /-- bgt.s 2f5c <unlinkVar+0x10c>
            FreeVec( thisVar.varData.fastArray -> fastVariables);
    2f10:	|  |  |  |        |   movea.l 28(sp),a0
    2f14:	|  |  |  |        |   move.l (a0),16(sp)
    2f18:	|  |  |  |        |   move.l 755e <SysBase>,d0
    2f1e:	|  |  |  |        |   movea.l d0,a6
    2f20:	|  |  |  |        |   movea.l 16(sp),a1
    2f24:	|  |  |  |        |   jsr -690(a6)
			FreeVec(thisVar.varData.fastArray);
    2f28:	|  |  |  |        |   move.l 28(sp),12(sp)
    2f2e:	|  |  |  |        |   move.l 755e <SysBase>,d0
    2f34:	|  |  |  |        |   movea.l d0,a6
    2f36:	|  |  |  |        |   movea.l 12(sp),a1
    2f3a:	|  |  |  |        |   jsr -690(a6)
			thisVar.varData.fastArray = NULL;
    2f3e:	|  |  |  |        |   clr.l 28(sp)
		break;
    2f42:	|  |  |  |        +-- bra.s 2f5c <unlinkVar+0x10c>
		deleteAnim (thisVar.varData.animHandler);
    2f44:	|  \--|--|--------|-> move.l 28(sp),d0
    2f48:	|     |  |        |   move.l d0,-(sp)
    2f4a:	|     |  |        |   jsr 1e62 <deleteAnim>
    2f50:	|     |  |        |   addq.l #4,sp
		break;
    2f52:	|     +--|--------|-- bra.s 2f5e <unlinkVar+0x10e>
		break;
    2f54:	\-----|--|--------|-> nop
    2f56:	      +--|--------|-- bra.s 2f5e <unlinkVar+0x10e>
		break;
    2f58:	      |  \--------|-> nop
    2f5a:	      +-----------|-- bra.s 2f5e <unlinkVar+0x10e>
		break;
    2f5c:	      |           \-> nop
	}
}
    2f5e:	      \-------------> nop
    2f60:	                      movea.l (sp)+,a6
    2f62:	                      lea 16(sp),sp
    2f66:	                      rts

00002f68 <copyMain>:

BOOL copyMain (const struct variable from, struct variable to) {
	to.varType = from.varType;
    2f68:	       move.l 4(sp),d0
    2f6c:	       move.l d0,12(sp)
	switch (to.varType) {
    2f70:	       move.l 12(sp),d0
    2f74:	       moveq #10,d1
    2f76:	       cmp.l d0,d1
    2f78:	/----- bcs.w 302c <copyMain+0xc4>
    2f7c:	|      add.l d0,d0
    2f7e:	|      movea.l d0,a0
    2f80:	|      adda.l #12172,a0
    2f86:	|      move.w (a0),d0
    2f88:	|      jmp (2f8c <copyMain+0x24>,pc,d0.w)
    2f8c:	|      ori.l #1441814,(a4)+
    2f92:	|      .short 0x003e
    2f94:	|      ori.b #22,(a6)
    2f98:	|      ori.w #22,-(a0)
    2f9c:	|      ori.l #7995428,d6
		case SVT_INT:
		case SVT_FUNC:
		case SVT_BUILT:
		case SVT_FILE:
		case SVT_OBJTYPE:
		to.varData.intValue = from.varData.intValue;
    2fa2:	|      move.l 8(sp),d0
    2fa6:	|      move.l d0,16(sp)
		return TRUE;
    2faa:	|      moveq #1,d0
    2fac:	|  /-- bra.w 303e <copyMain+0xd6>

		case SVT_FASTARRAY:
		to.varData.fastArray = from.varData.fastArray;
    2fb0:	|  |   move.l 8(sp),d0
    2fb4:	|  |   move.l d0,16(sp)
		to.varData.fastArray -> timesUsed ++;
    2fb8:	|  |   movea.l 16(sp),a0
    2fbc:	|  |   move.l 8(a0),d0
    2fc0:	|  |   addq.l #1,d0
    2fc2:	|  |   move.l d0,8(a0)
		return TRUE;
    2fc6:	|  |   moveq #1,d0
    2fc8:	|  +-- bra.s 303e <copyMain+0xd6>

		case SVT_STRING:
		to.varData.theString = copyString (from.varData.theString);
    2fca:	|  |   move.l 8(sp),d0
    2fce:	|  |   move.l d0,-(sp)
    2fd0:	|  |   jsr 2d32 <copyString>
    2fd6:	|  |   addq.l #4,sp
    2fd8:	|  |   move.l d0,16(sp)
		return to.varData.theString ? TRUE : FALSE;
    2fdc:	|  |   move.l 16(sp),d0
    2fe0:	|  |   sne d0
    2fe2:	|  |   neg.b d0
    2fe4:	|  |   move.b d0,d0
    2fe6:	|  |   andi.w #255,d0
    2fea:	|  +-- bra.s 303e <copyMain+0xd6>

		case SVT_STACK:
		to.varData.theStack = from.varData.theStack;
    2fec:	|  |   move.l 8(sp),d0
    2ff0:	|  |   move.l d0,16(sp)
		to.varData.theStack -> timesUsed ++;
    2ff4:	|  |   movea.l 16(sp),a0
    2ff8:	|  |   move.l 8(a0),d0
    2ffc:	|  |   addq.l #1,d0
    2ffe:	|  |   move.l d0,8(a0)
		return TRUE;
    3002:	|  |   moveq #1,d0
    3004:	|  +-- bra.s 303e <copyMain+0xd6>

		case SVT_COSTUME:
		to.varData.costumeHandler = from.varData.costumeHandler;
    3006:	|  |   move.l 8(sp),d0
    300a:	|  |   move.l d0,16(sp)
		return TRUE;
    300e:	|  |   moveq #1,d0
    3010:	|  +-- bra.s 303e <copyMain+0xd6>

		case SVT_ANIM:
		to.varData.animHandler = copyAnim (from.varData.animHandler);
    3012:	|  |   move.l 8(sp),d0
    3016:	|  |   move.l d0,-(sp)
    3018:	|  |   jsr 1cc8 <copyAnim>
    301e:	|  |   addq.l #4,sp
    3020:	|  |   move.l d0,16(sp)
		return TRUE;
    3024:	|  |   moveq #1,d0
    3026:	|  +-- bra.s 303e <copyMain+0xd6>

		case SVT_NULL:
		return TRUE;
    3028:	|  |   moveq #1,d0
    302a:	|  +-- bra.s 303e <copyMain+0xd6>

		default:
		break;
    302c:	\--|-> nop
	}
	KPrintF("Unknown value type");
    302e:	   |   pea 552d <sludger.c.a3710121+0x1a3>
    3034:	   |   jsr 3168 <KPrintF>
    303a:	   |   addq.l #4,sp
	return FALSE;
    303c:	   |   clr.w d0
}
    303e:	   \-> rts

00003040 <copyVariable>:

BOOL copyVariable (const struct variable from, struct variable to) {
	unlinkVar (to);
    3040:	move.l 16(sp),-(sp)
    3044:	move.l 16(sp),-(sp)
    3048:	jsr 2e50 <unlinkVar>
    304e:	addq.l #8,sp
	return copyMain (from, to);
    3050:	move.l 16(sp),-(sp)
    3054:	move.l 16(sp),-(sp)
    3058:	move.l 16(sp),-(sp)
    305c:	move.l 16(sp),-(sp)
    3060:	jsr 2f68 <copyMain>
    3066:	lea 16(sp),sp
}
    306a:	rts

0000306c <trimStack>:

void trimStack (struct variableStack * stack) {
    306c:	subq.l #8,sp
    306e:	move.l a6,-(sp)
	struct variableStack * killMe = stack;
    3070:	move.l 16(sp),8(sp)
	stack = stack -> next;
    3076:	movea.l 16(sp),a0
    307a:	move.l 8(a0),16(sp)

	// When calling this, we've ALWAYS checked that stack != NULL
	unlinkVar (killMe -> thisVar);
    3080:	movea.l 8(sp),a0
    3084:	move.l 4(a0),-(sp)
    3088:	move.l (a0),-(sp)
    308a:	jsr 2e50 <unlinkVar>
    3090:	addq.l #8,sp
	FreeVec(killMe);
    3092:	move.l 8(sp),4(sp)
    3098:	move.l 755e <SysBase>,d0
    309e:	movea.l d0,a6
    30a0:	movea.l 4(sp),a1
    30a4:	jsr -690(a6)
    30a8:	nop
    30aa:	movea.l (sp)+,a6
    30ac:	addq.l #8,sp
    30ae:	rts

000030b0 <noFloor>:
#include "support/gcc8_c_support.h"

struct flor * currentFloor = NULL;

void noFloor () {
	currentFloor -> numPolygons = 0;
    30b0:	movea.l 75f2 <currentFloor>,a0
    30b6:	clr.l 8(a0)
	currentFloor -> polygon = NULL;
    30ba:	movea.l 75f2 <currentFloor>,a0
    30c0:	clr.l 12(a0)
	currentFloor -> vertex = NULL;
    30c4:	movea.l 75f2 <currentFloor>,a0
    30ca:	clr.l 4(a0)
	currentFloor -> matrix = NULL;
    30ce:	movea.l 75f2 <currentFloor>,a0
    30d4:	clr.l 16(a0)
}
    30d8:	nop
    30da:	rts

000030dc <initFloor>:

BOOL initFloor () {
    30dc:	       lea -12(sp),sp
    30e0:	       move.l a6,-(sp)
	currentFloor = AllocVec(sizeof(struct flor), MEMF_ANY);
    30e2:	       moveq #20,d0
    30e4:	       move.l d0,12(sp)
    30e8:	       clr.l 8(sp)
    30ec:	       move.l 755e <SysBase>,d0
    30f2:	       movea.l d0,a6
    30f4:	       move.l 12(sp),d0
    30f8:	       move.l 8(sp),d1
    30fc:	       jsr -684(a6)
    3100:	       move.l d0,4(sp)
    3104:	       move.l 4(sp),d0
    3108:	       move.l d0,75f2 <currentFloor>

    if(currentFloor == 0) {
    310e:	       move.l 75f2 <currentFloor>,d0
    3114:	/----- bne.s 3128 <initFloor+0x4c>
        KPrintF("initFloor: Could not initialize Mem");
    3116:	|      pea 5540 <sludger.c.a3710121+0x1b6>
    311c:	|      jsr 3168 <KPrintF>
    3122:	|      addq.l #4,sp
        return FALSE;
    3124:	|      clr.w d0
    3126:	|  /-- bra.s 3130 <initFloor+0x54>
    }

	noFloor ();
    3128:	\--|-> jsr 30b0 <noFloor>
	return TRUE;
    312e:	   |   moveq #1,d0
    3130:	   \-> movea.l (sp)+,a6
    3132:	       lea 12(sp),sp
    3136:	       rts

00003138 <memset>:
void* memset(void *dest, int val, unsigned long len) {
    3138:	       subq.l #4,sp
	unsigned char *ptr = (unsigned char *)dest;
    313a:	       move.l 8(sp),(sp)
	while(len-- > 0)
    313e:	   /-- bra.s 3150 <memset+0x18>
		*ptr++ = val;
    3140:	/--|-> move.l (sp),d0
    3142:	|  |   move.l d0,d1
    3144:	|  |   addq.l #1,d1
    3146:	|  |   move.l d1,(sp)
    3148:	|  |   move.l 12(sp),d1
    314c:	|  |   movea.l d0,a0
    314e:	|  |   move.b d1,(a0)
	while(len-- > 0)
    3150:	|  \-> move.l 16(sp),d0
    3154:	|      move.l d0,d1
    3156:	|      subq.l #1,d1
    3158:	|      move.l d1,16(sp)
    315c:	|      tst.l d0
    315e:	\----- bne.s 3140 <memset+0x8>
	return dest;
    3160:	       move.l 8(sp),d0
}
    3164:	       addq.l #4,sp
    3166:	       rts

00003168 <KPrintF>:
void KPrintF(const char* fmt, ...) {
    3168:	       lea -128(sp),sp
    316c:	       movem.l a2-a3/a6,-(sp)
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    3170:	       move.w f0ff60 <gcc8_c_support.c.af0a41ba+0xefb7f0>,d0
    3176:	       cmpi.w #20153,d0
    317a:	   /-- beq.s 319e <KPrintF+0x36>
    317c:	   |   cmpi.w #-24562,d0
    3180:	   +-- beq.s 319e <KPrintF+0x36>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
    3182:	   |   movea.l 755e <SysBase>,a6
    3188:	   |   movea.l 144(sp),a0
    318c:	   |   lea 148(sp),a1
    3190:	   |   lea 33fc <KPutCharX>,a2
    3196:	   |   suba.l a3,a3
    3198:	   |   jsr -522(a6)
}
    319c:	/--|-- bra.s 31c8 <KPrintF+0x60>
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
    319e:	|  \-> movea.l 755e <SysBase>,a6
    31a4:	|      movea.l 144(sp),a0
    31a8:	|      lea 148(sp),a1
    31ac:	|      lea 340a <PutChar>,a2
    31b2:	|      lea 12(sp),a3
    31b6:	|      jsr -522(a6)
		UaeDbgLog(86, temp);
    31ba:	|      move.l a3,-(sp)
    31bc:	|      pea 56 <_start+0x56>
    31c0:	|      jsr f0ff60 <gcc8_c_support.c.af0a41ba+0xefb7f0>
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    31c6:	|      addq.l #8,sp
}
    31c8:	\----> movem.l (sp)+,a2-a3/a6
    31cc:	       lea 128(sp),sp
    31d0:	       rts

000031d2 <warpmode>:

void warpmode(int on) { // bool
    31d2:	          subq.l #8,sp
	long(*UaeConf)(long mode, int index, const char* param, int param_len, char* outbuf, int outbuf_len);
	UaeConf = (long(*)(long, int, const char*, int, char*, int))0xf0ff60;
    31d4:	          move.l #15794016,4(sp)
	if(*((UWORD *)UaeConf) == 0x4eb9 || *((UWORD *)UaeConf) == 0xa00e) {
    31dc:	          movea.l 4(sp),a0
    31e0:	          move.w (a0),d0
    31e2:	          cmpi.w #20153,d0
    31e6:	      /-- beq.s 31f6 <warpmode+0x24>
    31e8:	      |   movea.l 4(sp),a0
    31ec:	      |   move.w (a0),d0
    31ee:	      |   cmpi.w #-24562,d0
    31f2:	/-----|-- bne.w 32fa <warpmode+0x128>
		char outbuf;
		UaeConf(82, -1, on ? "cpu_speed max" : "cpu_speed real", 0, &outbuf, 1);
    31f6:	|     \-> tst.l 12(sp)
    31fa:	|  /----- beq.s 3204 <warpmode+0x32>
    31fc:	|  |      move.l #21860,d0
    3202:	|  |  /-- bra.s 320a <warpmode+0x38>
    3204:	|  \--|-> move.l #21874,d0
    320a:	|     \-> pea 1 <_start+0x1>
    320e:	|         move.l sp,d1
    3210:	|         addq.l #7,d1
    3212:	|         move.l d1,-(sp)
    3214:	|         clr.l -(sp)
    3216:	|         move.l d0,-(sp)
    3218:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeb88f>
    321c:	|         pea 52 <_start+0x52>
    3220:	|         movea.l 28(sp),a0
    3224:	|         jsr (a0)
    3226:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_cycle_exact false" : "cpu_cycle_exact true", 0, &outbuf, 1);
    322a:	|         tst.l 12(sp)
    322e:	|  /----- beq.s 3238 <warpmode+0x66>
    3230:	|  |      move.l #21889,d0
    3236:	|  |  /-- bra.s 323e <warpmode+0x6c>
    3238:	|  \--|-> move.l #21911,d0
    323e:	|     \-> pea 1 <_start+0x1>
    3242:	|         move.l sp,d1
    3244:	|         addq.l #7,d1
    3246:	|         move.l d1,-(sp)
    3248:	|         clr.l -(sp)
    324a:	|         move.l d0,-(sp)
    324c:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeb88f>
    3250:	|         pea 52 <_start+0x52>
    3254:	|         movea.l 28(sp),a0
    3258:	|         jsr (a0)
    325a:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_memory_cycle_exact false" : "cpu_memory_cycle_exact true", 0, &outbuf, 1);
    325e:	|         tst.l 12(sp)
    3262:	|  /----- beq.s 326c <warpmode+0x9a>
    3264:	|  |      move.l #21932,d0
    326a:	|  |  /-- bra.s 3272 <warpmode+0xa0>
    326c:	|  \--|-> move.l #21961,d0
    3272:	|     \-> pea 1 <_start+0x1>
    3276:	|         move.l sp,d1
    3278:	|         addq.l #7,d1
    327a:	|         move.l d1,-(sp)
    327c:	|         clr.l -(sp)
    327e:	|         move.l d0,-(sp)
    3280:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeb88f>
    3284:	|         pea 52 <_start+0x52>
    3288:	|         movea.l 28(sp),a0
    328c:	|         jsr (a0)
    328e:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
    3292:	|         tst.l 12(sp)
    3296:	|  /----- beq.s 32a0 <warpmode+0xce>
    3298:	|  |      move.l #21989,d0
    329e:	|  |  /-- bra.s 32a6 <warpmode+0xd4>
    32a0:	|  \--|-> move.l #22015,d0
    32a6:	|     \-> pea 1 <_start+0x1>
    32aa:	|         move.l sp,d1
    32ac:	|         addq.l #7,d1
    32ae:	|         move.l d1,-(sp)
    32b0:	|         clr.l -(sp)
    32b2:	|         move.l d0,-(sp)
    32b4:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeb88f>
    32b8:	|         pea 52 <_start+0x52>
    32bc:	|         movea.l 28(sp),a0
    32c0:	|         jsr (a0)
    32c2:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
    32c6:	|         tst.l 12(sp)
    32ca:	|  /----- beq.s 32d4 <warpmode+0x102>
    32cc:	|  |      move.l #22040,d0
    32d2:	|  |  /-- bra.s 32da <warpmode+0x108>
    32d4:	|  \--|-> move.l #22050,d0
    32da:	|     \-> pea 1 <_start+0x1>
    32de:	|         move.l sp,d1
    32e0:	|         addq.l #7,d1
    32e2:	|         move.l d1,-(sp)
    32e4:	|         clr.l -(sp)
    32e6:	|         move.l d0,-(sp)
    32e8:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeb88f>
    32ec:	|         pea 52 <_start+0x52>
    32f0:	|         movea.l 28(sp),a0
    32f4:	|         jsr (a0)
    32f6:	|         lea 24(sp),sp
	}
}
    32fa:	\-------> nop
    32fc:	          addq.l #8,sp
    32fe:	          rts

00003300 <debug_cmd>:

static void debug_cmd(unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4) {
    3300:	       subq.l #4,sp
	long(*UaeLib)(unsigned int arg0, unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4);
	UaeLib = (long(*)(unsigned int, unsigned int, unsigned int, unsigned int, unsigned int))0xf0ff60;
    3302:	       move.l #15794016,(sp)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
    3308:	       movea.l (sp),a0
    330a:	       move.w (a0),d0
    330c:	       cmpi.w #20153,d0
    3310:	   /-- beq.s 331c <debug_cmd+0x1c>
    3312:	   |   movea.l (sp),a0
    3314:	   |   move.w (a0),d0
    3316:	   |   cmpi.w #-24562,d0
    331a:	/--|-- bne.s 333a <debug_cmd+0x3a>
		UaeLib(88, arg1, arg2, arg3, arg4);
    331c:	|  \-> move.l 20(sp),-(sp)
    3320:	|      move.l 20(sp),-(sp)
    3324:	|      move.l 20(sp),-(sp)
    3328:	|      move.l 20(sp),-(sp)
    332c:	|      pea 58 <_start+0x58>
    3330:	|      movea.l 20(sp),a0
    3334:	|      jsr (a0)
    3336:	|      lea 20(sp),sp
	}
}
    333a:	\----> nop
    333c:	       addq.l #4,sp
    333e:	       rts

00003340 <debug_start_idle>:
	debug_cmd(barto_cmd_text, (((unsigned int)left) << 16) | ((unsigned int)top), (unsigned int)text, color);
}

// profiler
void debug_start_idle() {
	debug_cmd(barto_cmd_set_idle, 1, 0, 0);
    3340:	clr.l -(sp)
    3342:	clr.l -(sp)
    3344:	pea 1 <_start+0x1>
    3348:	pea 5 <_start+0x5>
    334c:	jsr 3300 <debug_cmd>
    3352:	lea 16(sp),sp
}
    3356:	nop
    3358:	rts

0000335a <debug_stop_idle>:

void debug_stop_idle() {
	debug_cmd(barto_cmd_set_idle, 0, 0, 0);
    335a:	clr.l -(sp)
    335c:	clr.l -(sp)
    335e:	clr.l -(sp)
    3360:	pea 5 <_start+0x5>
    3364:	jsr 3300 <debug_cmd>
    336a:	lea 16(sp),sp
}
    336e:	nop
    3370:	rts

00003372 <__udivsi3>:
	.section .text.__udivsi3,"ax",@progbits
	.type __udivsi3, function
	.globl	__udivsi3
__udivsi3:
	.cfi_startproc
	movel	d2, sp@-
    3372:	       move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
    3374:	       move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
    3378:	       move.l 8(sp),d0

	cmpl	#0x10000, d1 /* divisor >= 2 ^ 16 ?   */
    337c:	       cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
    3382:	   /-- bcc.s 339a <__udivsi3+0x28>
	movel	d0, d2
    3384:	   |   move.l d0,d2
	clrw	d2
    3386:	   |   clr.w d2
	swap	d2
    3388:	   |   swap d2
	divu	d1, d2          /* high quotient in lower word */
    338a:	   |   divu.w d1,d2
	movew	d2, d0		/* save high quotient */
    338c:	   |   move.w d2,d0
	swap	d0
    338e:	   |   swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
    3390:	   |   move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
    3394:	   |   divu.w d1,d2
	movew	d2, d0
    3396:	   |   move.w d2,d0
	jra	6f
    3398:	/--|-- bra.s 33ca <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
    339a:	|  \-> move.l d1,d2
4:	lsrl	#1, d1	/* shift divisor */
    339c:	|  /-> lsr.l #1,d1
	lsrl	#1, d0	/* shift dividend */
    339e:	|  |   lsr.l #1,d0
	cmpl	#0x10000, d1 /* still divisor >= 2 ^ 16 ?  */
    33a0:	|  |   cmpi.l #65536,d1
	jcc	4b
    33a6:	|  \-- bcc.s 339c <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
    33a8:	|      divu.w d1,d0
	andl	#0xffff, d0 /* mask out divisor, ignore remainder */
    33aa:	|      andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
    33b0:	|      move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
    33b2:	|      mulu.w d0,d1
	swap	d2
    33b4:	|      swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
    33b6:	|      mulu.w d0,d2
	swap	d2		/* align high part with low part */
    33b8:	|      swap d2
	tstw	d2		/* high part 17 bits? */
    33ba:	|      tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
    33bc:	|  /-- bne.s 33c8 <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
    33be:	|  |   add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
    33c0:	|  +-- bcs.s 33c8 <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
    33c2:	|  |   cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
    33c6:	+--|-- bls.s 33ca <__udivsi3+0x58>
5:	subql	#1, d0	/* adjust quotient */
    33c8:	|  \-> subq.l #1,d0

6:	movel	sp@+, d2
    33ca:	\----> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    33cc:	       rts

000033ce <__divsi3>:
	.section .text.__divsi3,"ax",@progbits
	.type __divsi3, function
	.globl	__divsi3
 __divsi3:
 	.cfi_startproc
	movel	d2, sp@-
    33ce:	    move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	#1, d2	/* sign of result stored in d2 (=1 or =-1) */
    33d0:	    moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
    33d2:	    move.l 12(sp),d1
	jpl	1f
    33d6:	/-- bpl.s 33dc <__divsi3+0xe>
	negl	d1
    33d8:	|   neg.l d1
	negb	d2		/* change sign because divisor <0  */
    33da:	|   neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
    33dc:	\-> move.l 8(sp),d0
	jpl	2f
    33e0:	/-- bpl.s 33e6 <__divsi3+0x18>
	negl	d0
    33e2:	|   neg.l d0
	negb	d2
    33e4:	|   neg.b d2

2:	movel	d1, sp@-
    33e6:	\-> move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    33e8:	    move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__udivsi3	/* divide abs(dividend) by abs(divisor) */
    33ea:	    jsr 3372 <__udivsi3>
	addql	#8, sp
    33f0:	    addq.l #8,sp
	.cfi_adjust_cfa_offset -8

	tstb	d2
    33f2:	    tst.b d2
	jpl	3f
    33f4:	/-- bpl.s 33f8 <__divsi3+0x2a>
	negl	d0
    33f6:	|   neg.l d0

3:	movel	sp@+, d2
    33f8:	\-> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    33fa:	    rts

000033fc <KPutCharX>:
	.type KPutCharX, function
	.globl	KPutCharX

KPutCharX:
	.cfi_startproc
    move.l  a6, -(sp)
    33fc:	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
    33fe:	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
    3402:	jsr -516(a6)
    move.l (sp)+, a6
    3406:	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
    3408:	rts

0000340a <PutChar>:
	.type PutChar, function
	.globl	PutChar

PutChar:
	.cfi_startproc
	move.b d0, (a3)+
    340a:	move.b d0,(a3)+
	rts
    340c:	rts
