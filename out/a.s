
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
       2:	       move.l #26439,d0
       8:	       subi.l #26439,d0
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
      22:	|  |   lea 6747 <__fini_array_end>,a0
      28:	|  |   movea.l (0,a1,a0.l),a0
      2c:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      2e:	|  |   addq.l #1,4(sp)
      32:	|  \-> move.l 4(sp),d0
      36:	|      cmp.l (sp),d0
      38:	\----- bcs.s 18 <_start+0x18>

	count = __init_array_end - __init_array_start;
      3a:	       move.l #26439,d0
      40:	       subi.l #26439,d0
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
      5a:	|  |   lea 6747 <__fini_array_end>,a0
      60:	|  |   movea.l (0,a1,a0.l),a0
      64:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      66:	|  |   addq.l #1,4(sp)
      6a:	|  \-> move.l 4(sp),d0
      6e:	|      cmp.l (sp),d0
      70:	\----- bcs.s 50 <_start+0x50>

	main();
      72:	       jsr 13f2 <main>

	// call dtors
	count = __fini_array_end - __fini_array_start;
      78:	       move.l #26439,d0
      7e:	       subi.l #26439,d0
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
      9a:	|  |   lea 6747 <__fini_array_end>,a0
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

000000b8 <initSludge>:
FILETIME fileTime;

struct variable * globalVars;
int numGlobals;

BOOL initSludge (char * filename) {
      b8:	             lea -296(sp),sp
      bc:	             movem.l d2-d4/a2/a6,-(sp)
	int a = 0;
      c0:	             clr.l 312(sp)
	mouseCursorAnim = makeNullAnim ();
      c4:	             jsr 15c2 <makeNullAnim>
      ca:	             move.l d0,7c8c <mouseCursorAnim>

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, &gameVersion);
      d0:	             pea 7be2 <gameVersion>
      d6:	             pea 2742 <PutChar+0x4>
      dc:	             pea 45 <_start+0x45>
      e0:	             pea 47 <_start+0x47>
      e4:	             move.l 336(sp),-(sp)
      e8:	             jsr 824 <openAndVerify>
      ee:	             lea 20(sp),sp
      f2:	             move.l d0,292(sp)
	if (! fp) return FALSE;
      f6:	         /-- bne.s fe <initSludge+0x46>
      f8:	         |   clr.w d0
      fa:	/--------|-- bra.w 81a <initSludge+0x762>
	if (FGetC (fp)) {
      fe:	|        \-> move.l 292(sp),288(sp)
     104:	|            move.l 7c3a <DOSBase>,d0
     10a:	|            movea.l d0,a6
     10c:	|            move.l 288(sp),d1
     110:	|            jsr -306(a6)
     114:	|            move.l d0,284(sp)
     118:	|            move.l 284(sp),d0
     11c:	|  /-------- beq.w 2c2 <initSludge+0x20a>
		numBIFNames = get2bytes (fp);
     120:	|  |         move.l 292(sp),-(sp)
     124:	|  |         jsr 19e6 <get2bytes>
     12a:	|  |         addq.l #4,sp
     12c:	|  |         move.l d0,7bea <numBIFNames>
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
     132:	|  |         move.l 7bea <numBIFNames>,d0
     138:	|  |         move.l d0,280(sp)
     13c:	|  |         clr.l 276(sp)
     140:	|  |         move.l 7c32 <SysBase>,d0
     146:	|  |         movea.l d0,a6
     148:	|  |         move.l 280(sp),d0
     14c:	|  |         move.l 276(sp),d1
     150:	|  |         jsr -684(a6)
     154:	|  |         move.l d0,272(sp)
     158:	|  |         move.l 272(sp),d0
     15c:	|  |         move.l d0,7bee <allBIFNames>
		if(allBIFNames == 0) return FALSE;
     162:	|  |         move.l 7bee <allBIFNames>,d0
     168:	|  |     /-- bne.s 170 <initSludge+0xb8>
     16a:	|  |     |   clr.w d0
     16c:	+--|-----|-- bra.w 81a <initSludge+0x762>
		for (int fn = 0; fn < numBIFNames; fn ++) {
     170:	|  |     \-> clr.l 308(sp)
     174:	|  |     /-- bra.s 19a <initSludge+0xe2>
			allBIFNames[fn] = (char *) readString (fp);
     176:	|  |  /--|-> move.l 7bee <allBIFNames>,d1
     17c:	|  |  |  |   move.l 308(sp),d0
     180:	|  |  |  |   add.l d0,d0
     182:	|  |  |  |   add.l d0,d0
     184:	|  |  |  |   movea.l d1,a2
     186:	|  |  |  |   adda.l d0,a2
     188:	|  |  |  |   move.l 292(sp),-(sp)
     18c:	|  |  |  |   jsr 1b7e <readString>
     192:	|  |  |  |   addq.l #4,sp
     194:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numBIFNames; fn ++) {
     196:	|  |  |  |   addq.l #1,308(sp)
     19a:	|  |  |  \-> move.l 7bea <numBIFNames>,d0
     1a0:	|  |  |      cmp.l 308(sp),d0
     1a4:	|  |  \----- bgt.s 176 <initSludge+0xbe>
		}
		numUserFunc = get2bytes (fp);
     1a6:	|  |         move.l 292(sp),-(sp)
     1aa:	|  |         jsr 19e6 <get2bytes>
     1b0:	|  |         addq.l #4,sp
     1b2:	|  |         move.l d0,7bf2 <numUserFunc>
		allUserFunc = AllocVec(numUserFunc,MEMF_ANY);
     1b8:	|  |         move.l 7bf2 <numUserFunc>,d0
     1be:	|  |         move.l d0,268(sp)
     1c2:	|  |         clr.l 264(sp)
     1c6:	|  |         move.l 7c32 <SysBase>,d0
     1cc:	|  |         movea.l d0,a6
     1ce:	|  |         move.l 268(sp),d0
     1d2:	|  |         move.l 264(sp),d1
     1d6:	|  |         jsr -684(a6)
     1da:	|  |         move.l d0,260(sp)
     1de:	|  |         move.l 260(sp),d0
     1e2:	|  |         move.l d0,7bf6 <allUserFunc>
		if( allUserFunc == 0) return FALSE;
     1e8:	|  |         move.l 7bf6 <allUserFunc>,d0
     1ee:	|  |     /-- bne.s 1f6 <initSludge+0x13e>
     1f0:	|  |     |   clr.w d0
     1f2:	+--|-----|-- bra.w 81a <initSludge+0x762>

		for (int fn = 0; fn < numUserFunc; fn ++) {
     1f6:	|  |     \-> clr.l 304(sp)
     1fa:	|  |     /-- bra.s 220 <initSludge+0x168>
			allUserFunc[fn] =   (char *) readString (fp);
     1fc:	|  |  /--|-> move.l 7bf6 <allUserFunc>,d1
     202:	|  |  |  |   move.l 304(sp),d0
     206:	|  |  |  |   add.l d0,d0
     208:	|  |  |  |   add.l d0,d0
     20a:	|  |  |  |   movea.l d1,a2
     20c:	|  |  |  |   adda.l d0,a2
     20e:	|  |  |  |   move.l 292(sp),-(sp)
     212:	|  |  |  |   jsr 1b7e <readString>
     218:	|  |  |  |   addq.l #4,sp
     21a:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numUserFunc; fn ++) {
     21c:	|  |  |  |   addq.l #1,304(sp)
     220:	|  |  |  \-> move.l 7bf2 <numUserFunc>,d0
     226:	|  |  |      cmp.l 304(sp),d0
     22a:	|  |  \----- bgt.s 1fc <initSludge+0x144>
		}
		if (gameVersion >= VERSION(1,3)) {
     22c:	|  |         move.l 7be2 <gameVersion>,d0
     232:	|  |         cmpi.l #258,d0
     238:	|  +-------- ble.w 2c2 <initSludge+0x20a>
			numResourceNames = get2bytes (fp);
     23c:	|  |         move.l 292(sp),-(sp)
     240:	|  |         jsr 19e6 <get2bytes>
     246:	|  |         addq.l #4,sp
     248:	|  |         move.l d0,7bfa <numResourceNames>
			allResourceNames = AllocVec(numResourceNames,MEMF_ANY);
     24e:	|  |         move.l 7bfa <numResourceNames>,d0
     254:	|  |         move.l d0,256(sp)
     258:	|  |         clr.l 252(sp)
     25c:	|  |         move.l 7c32 <SysBase>,d0
     262:	|  |         movea.l d0,a6
     264:	|  |         move.l 256(sp),d0
     268:	|  |         move.l 252(sp),d1
     26c:	|  |         jsr -684(a6)
     270:	|  |         move.l d0,248(sp)
     274:	|  |         move.l 248(sp),d0
     278:	|  |         move.l d0,7bfe <allResourceNames>
			if(allResourceNames == 0) return FALSE;
     27e:	|  |         move.l 7bfe <allResourceNames>,d0
     284:	|  |     /-- bne.s 28c <initSludge+0x1d4>
     286:	|  |     |   clr.w d0
     288:	+--|-----|-- bra.w 81a <initSludge+0x762>

			for (int fn = 0; fn < numResourceNames; fn ++) {
     28c:	|  |     \-> clr.l 300(sp)
     290:	|  |     /-- bra.s 2b6 <initSludge+0x1fe>
				allResourceNames[fn] =  (char *) readString (fp);
     292:	|  |  /--|-> move.l 7bfe <allResourceNames>,d1
     298:	|  |  |  |   move.l 300(sp),d0
     29c:	|  |  |  |   add.l d0,d0
     29e:	|  |  |  |   add.l d0,d0
     2a0:	|  |  |  |   movea.l d1,a2
     2a2:	|  |  |  |   adda.l d0,a2
     2a4:	|  |  |  |   move.l 292(sp),-(sp)
     2a8:	|  |  |  |   jsr 1b7e <readString>
     2ae:	|  |  |  |   addq.l #4,sp
     2b0:	|  |  |  |   move.l d0,(a2)
			for (int fn = 0; fn < numResourceNames; fn ++) {
     2b2:	|  |  |  |   addq.l #1,300(sp)
     2b6:	|  |  |  \-> move.l 7bfa <numResourceNames>,d0
     2bc:	|  |  |      cmp.l 300(sp),d0
     2c0:	|  |  \----- bgt.s 292 <initSludge+0x1da>
			}
		}
	}
	winWidth = get2bytes (fp);
     2c2:	|  \-------> move.l 292(sp),-(sp)
     2c6:	|            jsr 19e6 <get2bytes>
     2cc:	|            addq.l #4,sp
     2ce:	|            move.l d0,7bda <winWidth>
	winHeight = get2bytes (fp);
     2d4:	|            move.l 292(sp),-(sp)
     2d8:	|            jsr 19e6 <get2bytes>
     2de:	|            addq.l #4,sp
     2e0:	|            move.l d0,7bde <winHeight>
	specialSettings = FGetC (fp);
     2e6:	|            move.l 292(sp),244(sp)
     2ec:	|            move.l 7c3a <DOSBase>,d0
     2f2:	|            movea.l d0,a6
     2f4:	|            move.l 244(sp),d1
     2f8:	|            jsr -306(a6)
     2fc:	|            move.l d0,240(sp)
     300:	|            move.l 240(sp),d0
     304:	|            move.l d0,7be6 <specialSettings>

	desiredfps = 1000/FGetC (fp);
     30a:	|            move.l 292(sp),236(sp)
     310:	|            move.l 7c3a <DOSBase>,d0
     316:	|            movea.l d0,a6
     318:	|            move.l 236(sp),d1
     31c:	|            jsr -306(a6)
     320:	|            move.l d0,232(sp)
     324:	|            move.l 232(sp),d0
     328:	|            move.l d0,-(sp)
     32a:	|            pea 3e8 <initSludge+0x330>
     32e:	|            jsr 2702 <__divsi3>
     334:	|            addq.l #8,sp
     336:	|            move.l d0,6748 <desiredfps>

	FreeVec(readString (fp));
     33c:	|            move.l 292(sp),-(sp)
     340:	|            jsr 1b7e <readString>
     346:	|            addq.l #4,sp
     348:	|            move.l d0,228(sp)
     34c:	|            move.l 7c32 <SysBase>,d0
     352:	|            movea.l d0,a6
     354:	|            movea.l 228(sp),a1
     358:	|            jsr -690(a6)

	ULONG blocks_read = FRead( fp, &fileTime, sizeof (FILETIME), 1 ); 
     35c:	|            move.l 292(sp),224(sp)
     362:	|            move.l #31746,220(sp)
     36a:	|            moveq #8,d0
     36c:	|            move.l d0,216(sp)
     370:	|            moveq #1,d1
     372:	|            move.l d1,212(sp)
     376:	|            move.l 7c3a <DOSBase>,d0
     37c:	|            movea.l d0,a6
     37e:	|            move.l 224(sp),d1
     382:	|            move.l 220(sp),d2
     386:	|            move.l 216(sp),d3
     38a:	|            move.l 212(sp),d4
     38e:	|            jsr -324(a6)
     392:	|            move.l d0,208(sp)
     396:	|            move.l 208(sp),d0
     39a:	|            move.l d0,204(sp)
	if (blocks_read != 1) {
     39e:	|            moveq #1,d0
     3a0:	|            cmp.l 204(sp),d0
     3a4:	|        /-- beq.s 3b4 <initSludge+0x2fc>
		KPrintF("Reading error in initSludge.\n");
     3a6:	|        |   pea 277b <PutChar+0x3d>
     3ac:	|        |   jsr 249c <KPrintF>
     3b2:	|        |   addq.l #4,sp
	}

	char * dataFol = (gameVersion >= VERSION(1,3)) ? readString(fp) : joinStrings ("", "");
     3b4:	|        \-> move.l 7be2 <gameVersion>,d0
     3ba:	|            cmpi.l #258,d0
     3c0:	|        /-- ble.s 3d0 <initSludge+0x318>
     3c2:	|        |   move.l 292(sp),-(sp)
     3c6:	|        |   jsr 1b7e <readString>
     3cc:	|        |   addq.l #4,sp
     3ce:	|     /--|-- bra.s 3e4 <initSludge+0x32c>
     3d0:	|     |  \-> pea 2799 <PutChar+0x5b>
     3d6:	|     |      pea 2799 <PutChar+0x5b>
     3dc:	|     |      jsr 1d14 <joinStrings>
     3e2:	|     |      addq.l #8,sp
     3e4:	|     \----> move.l d0,200(sp)

	gameSettings.numLanguages = (gameVersion >= VERSION(1,3)) ? (FGetC (fp)) : 0;
     3e8:	|            move.l 7be2 <gameVersion>,d0
     3ee:	|            cmpi.l #258,d0
     3f4:	|     /----- ble.s 416 <initSludge+0x35e>
     3f6:	|     |      move.l 292(sp),196(sp)
     3fc:	|     |      move.l 7c3a <DOSBase>,d0
     402:	|     |      movea.l d0,a6
     404:	|     |      move.l 196(sp),d1
     408:	|     |      jsr -306(a6)
     40c:	|     |      move.l d0,192(sp)
     410:	|     |      move.l 192(sp),d0
     414:	|     |  /-- bra.s 418 <initSludge+0x360>
     416:	|     \--|-> moveq #0,d0
     418:	|        \-> move.l d0,7c78 <gameSettings+0x4>
	makeLanguageTable (fp);
     41e:	|            move.l 292(sp),-(sp)
     422:	|            jsr 1ebe <makeLanguageTable>
     428:	|            addq.l #4,sp

	if (gameVersion >= VERSION(1,6))
     42a:	|            move.l 7be2 <gameVersion>,d0
     430:	|            cmpi.l #261,d0
     436:	|        /-- ble.s 484 <initSludge+0x3cc>
	{
		FGetC(fp);
     438:	|        |   move.l 292(sp),188(sp)
     43e:	|        |   move.l 7c3a <DOSBase>,d0
     444:	|        |   movea.l d0,a6
     446:	|        |   move.l 188(sp),d1
     44a:	|        |   jsr -306(a6)
     44e:	|        |   move.l d0,184(sp)
		// aaLoad
		FGetC (fp);
     452:	|        |   move.l 292(sp),180(sp)
     458:	|        |   move.l 7c3a <DOSBase>,d0
     45e:	|        |   movea.l d0,a6
     460:	|        |   move.l 180(sp),d1
     464:	|        |   jsr -306(a6)
     468:	|        |   move.l d0,176(sp)
		getFloat (fp);
     46c:	|        |   move.l 292(sp),-(sp)
     470:	|        |   jsr 1b02 <getFloat>
     476:	|        |   addq.l #4,sp
		getFloat (fp);
     478:	|        |   move.l 292(sp),-(sp)
     47c:	|        |   jsr 1b02 <getFloat>
     482:	|        |   addq.l #4,sp
	}

	char * checker = readString (fp);
     484:	|        \-> move.l 292(sp),-(sp)
     488:	|            jsr 1b7e <readString>
     48e:	|            addq.l #4,sp
     490:	|            move.l d0,172(sp)

	if (strcmp (checker, "okSoFar")) {
     494:	|            pea 279a <PutChar+0x5c>
     49a:	|            move.l 176(sp),-(sp)
     49e:	|            jsr 1c26 <strcmp>
     4a4:	|            addq.l #8,sp
     4a6:	|            tst.l d0
     4a8:	|        /-- beq.s 4b0 <initSludge+0x3f8>
		return FALSE;
     4aa:	|        |   clr.w d0
     4ac:	+--------|-- bra.w 81a <initSludge+0x762>
	}
	FreeVec( checker);
     4b0:	|        \-> move.l 172(sp),168(sp)
     4b6:	|            move.l 7c32 <SysBase>,d0
     4bc:	|            movea.l d0,a6
     4be:	|            movea.l 168(sp),a1
     4c2:	|            jsr -690(a6)
	checker = NULL;
     4c6:	|            clr.l 172(sp)

    unsigned char customIconLogo = FGetC (fp);
     4ca:	|            move.l 292(sp),164(sp)
     4d0:	|            move.l 7c3a <DOSBase>,d0
     4d6:	|            movea.l d0,a6
     4d8:	|            move.l 164(sp),d1
     4dc:	|            jsr -306(a6)
     4e0:	|            move.l d0,160(sp)
     4e4:	|            move.l 160(sp),d0
     4e8:	|            move.b d0,159(sp)

	if (customIconLogo & 1) {
     4ec:	|            moveq #0,d0
     4ee:	|            move.b 159(sp),d0
     4f2:	|            moveq #1,d1
     4f4:	|            and.l d1,d0
     4f6:	|        /-- beq.s 54e <initSludge+0x496>
		// There is an icon - read it!
		Write(Output(), (APTR)"initsludge:Game Icon not supported on this plattform.\n", 54);
     4f8:	|        |   move.l 7c3a <DOSBase>,d0
     4fe:	|        |   movea.l d0,a6
     500:	|        |   jsr -60(a6)
     504:	|        |   move.l d0,38(sp)
     508:	|        |   move.l 38(sp),d0
     50c:	|        |   move.l d0,34(sp)
     510:	|        |   move.l #10146,30(sp)
     518:	|        |   moveq #54,d0
     51a:	|        |   move.l d0,26(sp)
     51e:	|        |   move.l 7c3a <DOSBase>,d0
     524:	|        |   movea.l d0,a6
     526:	|        |   move.l 34(sp),d1
     52a:	|        |   move.l 30(sp),d2
     52e:	|        |   move.l 26(sp),d3
     532:	|        |   jsr -48(a6)
     536:	|        |   move.l d0,22(sp)
		KPrintF("initsludge: Game Icon not supported on this plattform.\n");
     53a:	|        |   pea 27d9 <PutChar+0x9b>
     540:	|        |   jsr 249c <KPrintF>
     546:	|        |   addq.l #4,sp
		return FALSE;
     548:	|        |   clr.w d0
     54a:	+--------|-- bra.w 81a <initSludge+0x762>
	}

	numGlobals = get2bytes (fp);
     54e:	|        \-> move.l 292(sp),-(sp)
     552:	|            jsr 19e6 <get2bytes>
     558:	|            addq.l #4,sp
     55a:	|            move.l d0,7c0e <numGlobals>

	globalVars = AllocVec( sizeof(struct variable) * numGlobals,MEMF_ANY);
     560:	|            move.l 7c0e <numGlobals>,d0
     566:	|            lsl.l #3,d0
     568:	|            move.l d0,154(sp)
     56c:	|            clr.l 150(sp)
     570:	|            move.l 7c32 <SysBase>,d0
     576:	|            movea.l d0,a6
     578:	|            move.l 154(sp),d0
     57c:	|            move.l 150(sp),d1
     580:	|            jsr -684(a6)
     584:	|            move.l d0,146(sp)
     588:	|            move.l 146(sp),d0
     58c:	|            move.l d0,7c0a <globalVars>
	if(globalVars == 0) {
     592:	|            move.l 7c0a <globalVars>,d0
     598:	|        /-- bne.s 5ae <initSludge+0x4f6>
		KPrintF("initsludge: Cannot allocate memory for globalvars\n");
     59a:	|        |   pea 2811 <PutChar+0xd3>
     5a0:	|        |   jsr 249c <KPrintF>
     5a6:	|        |   addq.l #4,sp
		return FALSE;
     5a8:	|        |   clr.w d0
     5aa:	+--------|-- bra.w 81a <initSludge+0x762>
	}		 
	for (a = 0; a < numGlobals; a ++) initVarNew (globalVars[a]);
     5ae:	|        \-> clr.l 312(sp)
     5b2:	|        /-- bra.s 5ca <initSludge+0x512>
     5b4:	|     /--|-> move.l 7c0a <globalVars>,d1
     5ba:	|     |  |   move.l 312(sp),d0
     5be:	|     |  |   lsl.l #3,d0
     5c0:	|     |  |   movea.l d1,a0
     5c2:	|     |  |   adda.l d0,a0
     5c4:	|     |  |   clr.l (a0)
     5c6:	|     |  |   addq.l #1,312(sp)
     5ca:	|     |  \-> move.l 7c0e <numGlobals>,d0
     5d0:	|     |      cmp.l 312(sp),d0
     5d4:	|     \----- bgt.s 5b4 <initSludge+0x4fc>

	setFileIndices (fp, gameSettings.numLanguages, 0);
     5d6:	|            move.l 7c78 <gameSettings+0x4>,d0
     5dc:	|            clr.l -(sp)
     5de:	|            move.l d0,-(sp)
     5e0:	|            move.l 300(sp),-(sp)
     5e4:	|            jsr 1080 <setFileIndices>
     5ea:	|            lea 12(sp),sp

	char * gameNameOrig = getNumberedString(1);	
     5ee:	|            pea 1 <_start+0x1>
     5f2:	|            jsr f82 <getNumberedString>
     5f8:	|            addq.l #4,sp
     5fa:	|            move.l d0,142(sp)
	char * gameName = encodeFilename (gameNameOrig);
     5fe:	|            move.l 142(sp),-(sp)
     602:	|            jsr 1628 <encodeFilename>
     608:	|            addq.l #4,sp
     60a:	|            move.l d0,138(sp)

	FreeVec(gameNameOrig);
     60e:	|            move.l 142(sp),134(sp)
     614:	|            move.l 7c32 <SysBase>,d0
     61a:	|            movea.l d0,a6
     61c:	|            movea.l 134(sp),a1
     620:	|            jsr -690(a6)

	BPTR lock = CreateDir( gameName );
     624:	|            move.l 138(sp),130(sp)
     62a:	|            move.l 7c3a <DOSBase>,d0
     630:	|            movea.l d0,a6
     632:	|            move.l 130(sp),d1
     636:	|            jsr -120(a6)
     63a:	|            move.l d0,126(sp)
     63e:	|            move.l 126(sp),d0
     642:	|            move.l d0,296(sp)
	if(lock == 0) {
     646:	|        /-- bne.s 674 <initSludge+0x5bc>
		//Directory does already exist
		lock = Lock(gameName, ACCESS_READ);
     648:	|        |   move.l 138(sp),122(sp)
     64e:	|        |   moveq #-2,d1
     650:	|        |   move.l d1,118(sp)
     654:	|        |   move.l 7c3a <DOSBase>,d0
     65a:	|        |   movea.l d0,a6
     65c:	|        |   move.l 122(sp),d1
     660:	|        |   move.l 118(sp),d2
     664:	|        |   jsr -84(a6)
     668:	|        |   move.l d0,114(sp)
     66c:	|        |   move.l 114(sp),d0
     670:	|        |   move.l d0,296(sp)
	}

	if (!CurrentDir(lock)) {
     674:	|        \-> move.l 296(sp),110(sp)
     67a:	|            move.l 7c3a <DOSBase>,d0
     680:	|            movea.l d0,a6
     682:	|            move.l 110(sp),d1
     686:	|            jsr -126(a6)
     68a:	|            move.l d0,106(sp)
     68e:	|            move.l 106(sp),d0
     692:	|        /-- bne.s 6ee <initSludge+0x636>
		KPrintF("initsludge: Failed changing to directory %s\n", gameName);
     694:	|        |   move.l 138(sp),-(sp)
     698:	|        |   pea 2844 <PutChar+0x106>
     69e:	|        |   jsr 249c <KPrintF>
     6a4:	|        |   addq.l #8,sp
		Write(Output(), (APTR)"initsludge:Failed changing to directory\n", 40);
     6a6:	|        |   move.l 7c3a <DOSBase>,d0
     6ac:	|        |   movea.l d0,a6
     6ae:	|        |   jsr -60(a6)
     6b2:	|        |   move.l d0,58(sp)
     6b6:	|        |   move.l 58(sp),d0
     6ba:	|        |   move.l d0,54(sp)
     6be:	|        |   move.l #10353,50(sp)
     6c6:	|        |   moveq #40,d0
     6c8:	|        |   move.l d0,46(sp)
     6cc:	|        |   move.l 7c3a <DOSBase>,d0
     6d2:	|        |   movea.l d0,a6
     6d4:	|        |   move.l 54(sp),d1
     6d8:	|        |   move.l 50(sp),d2
     6dc:	|        |   move.l 46(sp),d3
     6e0:	|        |   jsr -48(a6)
     6e4:	|        |   move.l d0,42(sp)
		return FALSE;
     6e8:	|        |   clr.w d0
     6ea:	+--------|-- bra.w 81a <initSludge+0x762>
	}

	FreeVec(gameName);
     6ee:	|        \-> move.l 138(sp),102(sp)
     6f4:	|            move.l 7c32 <SysBase>,d0
     6fa:	|            movea.l d0,a6
     6fc:	|            movea.l 102(sp),a1
     700:	|            jsr -690(a6)

	readIniFile (filename);
     704:	|            move.l 320(sp),-(sp)
     708:	|            jsr 1ff2 <readIniFile>
     70e:	|            addq.l #4,sp

	// Now set file indices properly to the chosen language.
	languageNum = getLanguageForFileB ();
     710:	|            jsr 1dc4 <getLanguageForFileB>
     716:	|            move.l d0,674c <languageNum>
	if (languageNum < 0) KPrintF("Can't find the translation data specified!");
     71c:	|            move.l 674c <languageNum>,d0
     722:	|        /-- bpl.s 732 <initSludge+0x67a>
     724:	|        |   pea 289a <PutChar+0x15c>
     72a:	|        |   jsr 249c <KPrintF>
     730:	|        |   addq.l #4,sp
	setFileIndices (NULL, gameSettings.numLanguages, languageNum);
     732:	|        \-> move.l 674c <languageNum>,d0
     738:	|            move.l d0,d1
     73a:	|            move.l 7c78 <gameSettings+0x4>,d0
     740:	|            move.l d1,-(sp)
     742:	|            move.l d0,-(sp)
     744:	|            clr.l -(sp)
     746:	|            jsr 1080 <setFileIndices>
     74c:	|            lea 12(sp),sp

	if (dataFol[0]) {
     750:	|            movea.l 200(sp),a0
     754:	|            move.b (a0),d0
     756:	|     /----- beq.w 800 <initSludge+0x748>
		char *dataFolder = encodeFilename(dataFol);
     75a:	|     |      move.l 200(sp),-(sp)
     75e:	|     |      jsr 1628 <encodeFilename>
     764:	|     |      addq.l #4,sp
     766:	|     |      move.l d0,98(sp)
		lock = CreateDir( dataFolder );
     76a:	|     |      move.l 98(sp),94(sp)
     770:	|     |      move.l 7c3a <DOSBase>,d0
     776:	|     |      movea.l d0,a6
     778:	|     |      move.l 94(sp),d1
     77c:	|     |      jsr -120(a6)
     780:	|     |      move.l d0,90(sp)
     784:	|     |      move.l 90(sp),d0
     788:	|     |      move.l d0,296(sp)
		if(lock == 0) {
     78c:	|     |  /-- bne.s 7ba <initSludge+0x702>
			//Directory does already exist
			lock = Lock(dataFolder, ACCESS_READ);		
     78e:	|     |  |   move.l 98(sp),86(sp)
     794:	|     |  |   moveq #-2,d1
     796:	|     |  |   move.l d1,82(sp)
     79a:	|     |  |   move.l 7c3a <DOSBase>,d0
     7a0:	|     |  |   movea.l d0,a6
     7a2:	|     |  |   move.l 86(sp),d1
     7a6:	|     |  |   move.l 82(sp),d2
     7aa:	|     |  |   jsr -84(a6)
     7ae:	|     |  |   move.l d0,78(sp)
     7b2:	|     |  |   move.l 78(sp),d0
     7b6:	|     |  |   move.l d0,296(sp)
		}


		if (!CurrentDir(lock)) {
     7ba:	|     |  \-> move.l 296(sp),74(sp)
     7c0:	|     |      move.l 7c3a <DOSBase>,d0
     7c6:	|     |      movea.l d0,a6
     7c8:	|     |      move.l 74(sp),d1
     7cc:	|     |      jsr -126(a6)
     7d0:	|     |      move.l d0,70(sp)
     7d4:	|     |      move.l 70(sp),d0
     7d8:	|     |  /-- bne.s 7ea <initSludge+0x732>
			(Output(), (APTR)"initsludge:This game's data folder is inaccessible!\n", 52);
     7da:	|     |  |   move.l 7c3a <DOSBase>,d0
     7e0:	|     |  |   movea.l d0,a6
     7e2:	|     |  |   jsr -60(a6)
     7e6:	|     |  |   move.l d0,66(sp)
		}
		FreeVec(dataFolder);
     7ea:	|     |  \-> move.l 98(sp),62(sp)
     7f0:	|     |      move.l 7c32 <SysBase>,d0
     7f6:	|     |      movea.l d0,a6
     7f8:	|     |      movea.l 62(sp),a1
     7fc:	|     |      jsr -690(a6)
	}

 	positionStatus (10, winHeight - 15);
     800:	|     \----> movea.l 7bde <winHeight>,a0
     806:	|            lea -15(a0),a0
     80a:	|            move.l a0,d0
     80c:	|            move.l d0,-(sp)
     80e:	|            pea a <_start+0xa>
     812:	|            jsr 15a6 <positionStatus>
     818:	|            addq.l #8,sp



}
     81a:	\----------> movem.l (sp)+,d2-d4/a2/a6
     81e:	             lea 296(sp),sp
     822:	             rts

00000824 <openAndVerify>:

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion) {
     824:	       lea -312(sp),sp
     828:	       movem.l d2-d3/a6,-(sp)
     82c:	       move.l 332(sp),d1
     830:	       move.l 336(sp),d0
     834:	       move.b d1,d1
     836:	       move.b d1,16(sp)
     83a:	       move.b d0,d0
     83c:	       move.b d0,14(sp)
	BPTR fp = Open(filename,MODE_OLDFILE);
     840:	       move.l 328(sp),318(sp)
     846:	       move.l #1005,314(sp)
     84e:	       move.l 7c3a <DOSBase>,d0
     854:	       movea.l d0,a6
     856:	       move.l 318(sp),d1
     85a:	       move.l 314(sp),d2
     85e:	       jsr -30(a6)
     862:	       move.l d0,310(sp)
     866:	       move.l 310(sp),d0
     86a:	       move.l d0,306(sp)

	if (! fp) {
     86e:	   /-- bne.s 8ca <openAndVerify+0xa6>
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
     870:	   |   move.l 7c3a <DOSBase>,d0
     876:	   |   movea.l d0,a6
     878:	   |   jsr -60(a6)
     87c:	   |   move.l d0,154(sp)
     880:	   |   move.l 154(sp),d0
     884:	   |   move.l d0,150(sp)
     888:	   |   move.l #10437,146(sp)
     890:	   |   moveq #31,d0
     892:	   |   move.l d0,142(sp)
     896:	   |   move.l 7c3a <DOSBase>,d0
     89c:	   |   movea.l d0,a6
     89e:	   |   move.l 150(sp),d1
     8a2:	   |   move.l 146(sp),d2
     8a6:	   |   move.l 142(sp),d3
     8aa:	   |   jsr -48(a6)
     8ae:	   |   move.l d0,138(sp)
		KPrintF("openAndVerify: Can't open file", filename);
     8b2:	   |   move.l 328(sp),-(sp)
     8b6:	   |   pea 28e5 <PutChar+0x1a7>
     8bc:	   |   jsr 249c <KPrintF>
     8c2:	   |   addq.l #8,sp
		return NULL;
     8c4:	   |   moveq #0,d0
     8c6:	/--|-- bra.w b8a <openAndVerify+0x366>
	}
	BOOL headerBad = FALSE;
     8ca:	|  \-> clr.w 322(sp)
	if (FGetC (fp) != 'S') headerBad = TRUE;
     8ce:	|      move.l 306(sp),302(sp)
     8d4:	|      move.l 7c3a <DOSBase>,d0
     8da:	|      movea.l d0,a6
     8dc:	|      move.l 302(sp),d1
     8e0:	|      jsr -306(a6)
     8e4:	|      move.l d0,298(sp)
     8e8:	|      move.l 298(sp),d0
     8ec:	|      moveq #83,d1
     8ee:	|      cmp.l d0,d1
     8f0:	|  /-- beq.s 8f8 <openAndVerify+0xd4>
     8f2:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'L') headerBad = TRUE;
     8f8:	|  \-> move.l 306(sp),294(sp)
     8fe:	|      move.l 7c3a <DOSBase>,d0
     904:	|      movea.l d0,a6
     906:	|      move.l 294(sp),d1
     90a:	|      jsr -306(a6)
     90e:	|      move.l d0,290(sp)
     912:	|      move.l 290(sp),d0
     916:	|      moveq #76,d1
     918:	|      cmp.l d0,d1
     91a:	|  /-- beq.s 922 <openAndVerify+0xfe>
     91c:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'U') headerBad = TRUE;
     922:	|  \-> move.l 306(sp),286(sp)
     928:	|      move.l 7c3a <DOSBase>,d0
     92e:	|      movea.l d0,a6
     930:	|      move.l 286(sp),d1
     934:	|      jsr -306(a6)
     938:	|      move.l d0,282(sp)
     93c:	|      move.l 282(sp),d0
     940:	|      moveq #85,d1
     942:	|      cmp.l d0,d1
     944:	|  /-- beq.s 94c <openAndVerify+0x128>
     946:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'D') headerBad = TRUE;
     94c:	|  \-> move.l 306(sp),278(sp)
     952:	|      move.l 7c3a <DOSBase>,d0
     958:	|      movea.l d0,a6
     95a:	|      move.l 278(sp),d1
     95e:	|      jsr -306(a6)
     962:	|      move.l d0,274(sp)
     966:	|      move.l 274(sp),d0
     96a:	|      moveq #68,d1
     96c:	|      cmp.l d0,d1
     96e:	|  /-- beq.s 976 <openAndVerify+0x152>
     970:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra1) headerBad = TRUE;
     976:	|  \-> move.l 306(sp),270(sp)
     97c:	|      move.l 7c3a <DOSBase>,d0
     982:	|      movea.l d0,a6
     984:	|      move.l 270(sp),d1
     988:	|      jsr -306(a6)
     98c:	|      move.l d0,266(sp)
     990:	|      move.l 266(sp),d1
     994:	|      move.b 16(sp),d0
     998:	|      ext.w d0
     99a:	|      movea.w d0,a0
     99c:	|      cmpa.l d1,a0
     99e:	|  /-- beq.s 9a6 <openAndVerify+0x182>
     9a0:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra2) headerBad = TRUE;
     9a6:	|  \-> move.l 306(sp),262(sp)
     9ac:	|      move.l 7c3a <DOSBase>,d0
     9b2:	|      movea.l d0,a6
     9b4:	|      move.l 262(sp),d1
     9b8:	|      jsr -306(a6)
     9bc:	|      move.l d0,258(sp)
     9c0:	|      move.l 258(sp),d1
     9c4:	|      move.b 14(sp),d0
     9c8:	|      ext.w d0
     9ca:	|      movea.w d0,a0
     9cc:	|      cmpa.l d1,a0
     9ce:	|  /-- beq.s 9d6 <openAndVerify+0x1b2>
     9d0:	|  |   move.w #1,322(sp)
	if (headerBad) {
     9d6:	|  \-> tst.w 322(sp)
     9da:	|  /-- beq.s a32 <openAndVerify+0x20e>
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
     9dc:	|  |   move.l 7c3a <DOSBase>,d0
     9e2:	|  |   movea.l d0,a6
     9e4:	|  |   jsr -60(a6)
     9e8:	|  |   move.l d0,174(sp)
     9ec:	|  |   move.l 174(sp),d0
     9f0:	|  |   move.l d0,170(sp)
     9f4:	|  |   move.l #10500,166(sp)
     9fc:	|  |   moveq #31,d0
     9fe:	|  |   move.l d0,162(sp)
     a02:	|  |   move.l 7c3a <DOSBase>,d0
     a08:	|  |   movea.l d0,a6
     a0a:	|  |   move.l 170(sp),d1
     a0e:	|  |   move.l 166(sp),d2
     a12:	|  |   move.l 162(sp),d3
     a16:	|  |   jsr -48(a6)
     a1a:	|  |   move.l d0,158(sp)
		KPrintF("openAndVerify: Bad Header\n");
     a1e:	|  |   pea 2904 <PutChar+0x1c6>
     a24:	|  |   jsr 249c <KPrintF>
     a2a:	|  |   addq.l #4,sp
		return NULL;
     a2c:	|  |   moveq #0,d0
     a2e:	+--|-- bra.w b8a <openAndVerify+0x366>
	}
	FGetC (fp);
     a32:	|  \-> move.l 306(sp),254(sp)
     a38:	|      move.l 7c3a <DOSBase>,d0
     a3e:	|      movea.l d0,a6
     a40:	|      move.l 254(sp),d1
     a44:	|      jsr -306(a6)
     a48:	|      move.l d0,250(sp)
	while (FGetC(fp)) {;}
     a4c:	|      nop
     a4e:	|  /-> move.l 306(sp),246(sp)
     a54:	|  |   move.l 7c3a <DOSBase>,d0
     a5a:	|  |   movea.l d0,a6
     a5c:	|  |   move.l 246(sp),d1
     a60:	|  |   jsr -306(a6)
     a64:	|  |   move.l d0,242(sp)
     a68:	|  |   move.l 242(sp),d0
     a6c:	|  \-- bne.s a4e <openAndVerify+0x22a>

	int majVersion = FGetC (fp);
     a6e:	|      move.l 306(sp),238(sp)
     a74:	|      move.l 7c3a <DOSBase>,d0
     a7a:	|      movea.l d0,a6
     a7c:	|      move.l 238(sp),d1
     a80:	|      jsr -306(a6)
     a84:	|      move.l d0,234(sp)
     a88:	|      move.l 234(sp),d0
     a8c:	|      move.l d0,230(sp)
	int minVersion = FGetC (fp);
     a90:	|      move.l 306(sp),226(sp)
     a96:	|      move.l 7c3a <DOSBase>,d0
     a9c:	|      movea.l d0,a6
     a9e:	|      move.l 226(sp),d1
     aa2:	|      jsr -306(a6)
     aa6:	|      move.l d0,222(sp)
     aaa:	|      move.l 222(sp),d0
     aae:	|      move.l d0,218(sp)
	*fileVersion = majVersion * 256 + minVersion;
     ab2:	|      move.l 230(sp),d0
     ab6:	|      lsl.l #8,d0
     ab8:	|      add.l 218(sp),d0
     abc:	|      movea.l 344(sp),a0
     ac0:	|      move.l d0,(a0)

	char txtVer[120];

	if (*fileVersion > WHOLE_VERSION) {
     ac2:	|      movea.l 344(sp),a0
     ac6:	|      move.l (a0),d0
     ac8:	|      cmpi.l #514,d0
     ace:	|  /-- ble.s b24 <openAndVerify+0x300>
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
     ad0:	|  |   move.l 7c3a <DOSBase>,d0
     ad6:	|  |   movea.l d0,a6
     ad8:	|  |   jsr -60(a6)
     adc:	|  |   move.l d0,194(sp)
     ae0:	|  |   move.l 194(sp),d0
     ae4:	|  |   move.l d0,190(sp)
     ae8:	|  |   move.l #10527,186(sp)
     af0:	|  |   moveq #100,d1
     af2:	|  |   move.l d1,182(sp)
     af6:	|  |   move.l 7c3a <DOSBase>,d0
     afc:	|  |   movea.l d0,a6
     afe:	|  |   move.l 190(sp),d1
     b02:	|  |   move.l 186(sp),d2
     b06:	|  |   move.l 182(sp),d3
     b0a:	|  |   jsr -48(a6)
     b0e:	|  |   move.l d0,178(sp)
		KPrintF(ERROR_VERSION_TOO_LOW_1);
     b12:	|  |   pea 291f <PutChar+0x1e1>
     b18:	|  |   jsr 249c <KPrintF>
     b1e:	|  |   addq.l #4,sp
		return NULL;
     b20:	|  |   moveq #0,d0
     b22:	+--|-- bra.s b8a <openAndVerify+0x366>
	} else if (*fileVersion < MINIM_VERSION) {
     b24:	|  \-> movea.l 344(sp),a0
     b28:	|      move.l (a0),d0
     b2a:	|      cmpi.l #257,d0
     b30:	|  /-- bgt.s b86 <openAndVerify+0x362>
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
     b32:	|  |   move.l 7c3a <DOSBase>,d0
     b38:	|  |   movea.l d0,a6
     b3a:	|  |   jsr -60(a6)
     b3e:	|  |   move.l d0,214(sp)
     b42:	|  |   move.l 214(sp),d0
     b46:	|  |   move.l d0,210(sp)
     b4a:	|  |   move.l #10596,206(sp)
     b52:	|  |   moveq #100,d0
     b54:	|  |   move.l d0,202(sp)
     b58:	|  |   move.l 7c3a <DOSBase>,d0
     b5e:	|  |   movea.l d0,a6
     b60:	|  |   move.l 210(sp),d1
     b64:	|  |   move.l 206(sp),d2
     b68:	|  |   move.l 202(sp),d3
     b6c:	|  |   jsr -48(a6)
     b70:	|  |   move.l d0,198(sp)
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
     b74:	|  |   pea 2964 <PutChar+0x226>
     b7a:	|  |   jsr 249c <KPrintF>
     b80:	|  |   addq.l #4,sp
		return NULL;
     b82:	|  |   moveq #0,d0
     b84:	+--|-- bra.s b8a <openAndVerify+0x366>
	}
	return fp;
     b86:	|  \-> move.l 306(sp),d0
     b8a:	\----> movem.l (sp)+,d2-d3/a6
     b8e:	       lea 312(sp),sp
     b92:	       rts

00000b94 <main_sludge>:
char * gameName = NULL;
char * gamePath = NULL;
char *bundleFolder;

int main_sludge(int argc, char *argv[])
{	
     b94:	          lea -40(sp),sp
     b98:	          movem.l d2-d3/a6,-(sp)
	/* Dimensions of our window. */
	//AMIGA TODO: Maybe remove as there will be no windowed mode
    winWidth = 320;
     b9c:	          move.l #320,7bda <winWidth>
    winHeight = 256;
     ba6:	          move.l #256,7bde <winHeight>

	char * sludgeFile;

	if(argc == 0) {
     bb0:	          tst.l 56(sp)
     bb4:	      /-- bne.s bcc <main_sludge+0x38>
		bundleFolder = copyString("game/");
     bb6:	      |   pea 29ab <PutChar+0x26d>
     bbc:	      |   jsr 1ca6 <copyString>
     bc2:	      |   addq.l #4,sp
     bc4:	      |   move.l d0,7c16 <bundleFolder>
     bca:	   /--|-- bra.s be2 <main_sludge+0x4e>
	} else {
		bundleFolder = copyString(argv[0]);
     bcc:	   |  \-> movea.l 60(sp),a0
     bd0:	   |      move.l (a0),d0
     bd2:	   |      move.l d0,-(sp)
     bd4:	   |      jsr 1ca6 <copyString>
     bda:	   |      addq.l #4,sp
     bdc:	   |      move.l d0,7c16 <bundleFolder>
	}
    
	int lastSlash = -1;
     be2:	   \----> moveq #-1,d0
     be4:	          move.l d0,44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
     be8:	          clr.l 40(sp)
     bec:	   /----- bra.s c0e <main_sludge+0x7a>
		if (bundleFolder[i] == PATHSLASH) lastSlash = i;
     bee:	/--|----> move.l 7c16 <bundleFolder>,d1
     bf4:	|  |      move.l 40(sp),d0
     bf8:	|  |      movea.l d1,a0
     bfa:	|  |      adda.l d0,a0
     bfc:	|  |      move.b (a0),d0
     bfe:	|  |      cmpi.b #47,d0
     c02:	|  |  /-- bne.s c0a <main_sludge+0x76>
     c04:	|  |  |   move.l 40(sp),44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
     c0a:	|  |  \-> addq.l #1,40(sp)
     c0e:	|  \----> move.l 7c16 <bundleFolder>,d1
     c14:	|         move.l 40(sp),d0
     c18:	|         movea.l d1,a0
     c1a:	|         adda.l d0,a0
     c1c:	|         move.b (a0),d0
     c1e:	\-------- bne.s bee <main_sludge+0x5a>
	}
	bundleFolder[lastSlash+1] = NULL;
     c20:	          move.l 7c16 <bundleFolder>,d0
     c26:	          move.l 44(sp),d1
     c2a:	          addq.l #1,d1
     c2c:	          movea.l d0,a0
     c2e:	          adda.l d1,a0
     c30:	          clr.b (a0)

	if (argc > 1) {
     c32:	          moveq #1,d0
     c34:	          cmp.l 56(sp),d0
     c38:	      /-- bge.s c54 <main_sludge+0xc0>
		sludgeFile = argv[argc - 1];
     c3a:	      |   move.l 56(sp),d0
     c3e:	      |   addi.l #1073741823,d0
     c44:	      |   add.l d0,d0
     c46:	      |   add.l d0,d0
     c48:	      |   movea.l 60(sp),a0
     c4c:	      |   adda.l d0,a0
     c4e:	      |   move.l (a0),48(sp)
     c52:	   /--|-- bra.s cae <main_sludge+0x11a>
	} else {
		sludgeFile = joinStrings (bundleFolder, "gamedata.slg");
     c54:	   |  \-> move.l 7c16 <bundleFolder>,d0
     c5a:	   |      pea 29b1 <PutChar+0x273>
     c60:	   |      move.l d0,-(sp)
     c62:	   |      jsr 1d14 <joinStrings>
     c68:	   |      addq.l #8,sp
     c6a:	   |      move.l d0,48(sp)
		if (! ( fileExists (sludgeFile) ) ) {
     c6e:	   |      move.l 48(sp),-(sp)
     c72:	   |      jsr 2402 <fileExists>
     c78:	   |      addq.l #4,sp
     c7a:	   |      tst.b d0
     c7c:	   +----- bne.s cae <main_sludge+0x11a>
			FreeVec(sludgeFile);
     c7e:	   |      move.l 48(sp),36(sp)
     c84:	   |      move.l 7c32 <SysBase>,d0
     c8a:	   |      movea.l d0,a6
     c8c:	   |      movea.l 36(sp),a1
     c90:	   |      jsr -690(a6)
			sludgeFile = joinStrings (bundleFolder, "gamedata");			
     c94:	   |      move.l 7c16 <bundleFolder>,d0
     c9a:	   |      pea 29be <PutChar+0x280>
     ca0:	   |      move.l d0,-(sp)
     ca2:	   |      jsr 1d14 <joinStrings>
     ca8:	   |      addq.l #8,sp
     caa:	   |      move.l d0,48(sp)
	//AMIGA TODO: Show arguments
	/*if (! parseCmdlineParameters(argc, argv) && !(sludgeFile) ) {
		printCmdlineUsage();
		return 0;
	}*/
	if (! fileExists(sludgeFile) ) {	
     cae:	   \----> move.l 48(sp),-(sp)
     cb2:	          jsr 2402 <fileExists>
     cb8:	          addq.l #4,sp
     cba:	          tst.b d0
     cbc:	      /-- bne.s d04 <main_sludge+0x170>
		Write(Output(), (APTR)"Game file not found.\n", 21);
     cbe:	      |   move.l 7c3a <DOSBase>,d0
     cc4:	      |   movea.l d0,a6
     cc6:	      |   jsr -60(a6)
     cca:	      |   move.l d0,28(sp)
     cce:	      |   move.l 28(sp),d0
     cd2:	      |   move.l d0,24(sp)
     cd6:	      |   move.l #10695,20(sp)
     cde:	      |   moveq #21,d0
     ce0:	      |   move.l d0,16(sp)
     ce4:	      |   move.l 7c3a <DOSBase>,d0
     cea:	      |   movea.l d0,a6
     cec:	      |   move.l 24(sp),d1
     cf0:	      |   move.l 20(sp),d2
     cf4:	      |   move.l 16(sp),d3
     cf8:	      |   jsr -48(a6)
     cfc:	      |   move.l d0,12(sp)
		//AMIGA TODO: Show arguments
		//printCmdlineUsage();
		return 0;
     d00:	      |   moveq #0,d0
     d02:	   /--|-- bra.s d3a <main_sludge+0x1a6>
	}

	setGameFilePath (sludgeFile);
     d04:	   |  \-> move.l 48(sp),-(sp)
     d08:	   |      jsr d44 <setGameFilePath>
     d0e:	   |      addq.l #4,sp
	if (! initSludge (sludgeFile)) return 0;
     d10:	   |      move.l 48(sp),-(sp)
     d14:	   |      jsr b8 <initSludge>
     d1a:	   |      addq.l #4,sp
     d1c:	   |      tst.w d0
     d1e:	   |  /-- bne.s d24 <main_sludge+0x190>
     d20:	   |  |   moveq #0,d0
     d22:	   +--|-- bra.s d3a <main_sludge+0x1a6>
	
	//Amiga Cleanup
	FreeVec(sludgeFile);
     d24:	   |  \-> move.l 48(sp),32(sp)
     d2a:	   |      move.l 7c32 <SysBase>,d0
     d30:	   |      movea.l d0,a6
     d32:	   |      movea.l 32(sp),a1
     d36:	   |      jsr -690(a6)
}
     d3a:	   \----> movem.l (sp)+,d2-d3/a6
     d3e:	          lea 40(sp),sp
     d42:	          rts

00000d44 <setGameFilePath>:

void setGameFilePath (char * f) {
     d44:	          lea -1104(sp),sp
     d48:	          move.l a6,-(sp)
     d4a:	          move.l d2,-(sp)
	char currentDir[1000];

	if (!GetCurrentDirName( currentDir, 998)) {
     d4c:	          move.l #1112,d0
     d52:	          add.l sp,d0
     d54:	          addi.l #-1102,d0
     d5a:	          move.l d0,1100(sp)
     d5e:	          move.l #998,1096(sp)
     d66:	          move.l 7c3a <DOSBase>,d0
     d6c:	          movea.l d0,a6
     d6e:	          move.l 1100(sp),d1
     d72:	          move.l 1096(sp),d2
     d76:	          jsr -564(a6)
     d7a:	          move.w d0,1094(sp)
     d7e:	          move.w 1094(sp),d0
     d82:	      /-- bne.s d92 <setGameFilePath+0x4e>
		KPrintF("setGameFilePath: Can't get current directory.\n");
     d84:	      |   pea 29dd <PutChar+0x29f>
     d8a:	      |   jsr 249c <KPrintF>
     d90:	      |   addq.l #4,sp
	}	

	int got = -1, a;	
     d92:	      \-> moveq #-1,d0
     d94:	          move.l d0,1108(sp)

	for (a = 0; f[a]; a ++) {
     d98:	          clr.l 1104(sp)
     d9c:	   /----- bra.s dba <setGameFilePath+0x76>
		if (f[a] == PATHSLASH) got = a;
     d9e:	/--|----> move.l 1104(sp),d0
     da2:	|  |      movea.l 1116(sp),a0
     da6:	|  |      adda.l d0,a0
     da8:	|  |      move.b (a0),d0
     daa:	|  |      cmpi.b #47,d0
     dae:	|  |  /-- bne.s db6 <setGameFilePath+0x72>
     db0:	|  |  |   move.l 1104(sp),1108(sp)
	for (a = 0; f[a]; a ++) {
     db6:	|  |  \-> addq.l #1,1104(sp)
     dba:	|  \----> move.l 1104(sp),d0
     dbe:	|         movea.l 1116(sp),a0
     dc2:	|         adda.l d0,a0
     dc4:	|         move.b (a0),d0
     dc6:	\-------- bne.s d9e <setGameFilePath+0x5a>
	}

	if (got != -1) {
     dc8:	          moveq #-1,d0
     dca:	          cmp.l 1108(sp),d0
     dce:	   /----- beq.s e48 <setGameFilePath+0x104>
		f[got] = 0;	
     dd0:	   |      move.l 1108(sp),d0
     dd4:	   |      movea.l 1116(sp),a0
     dd8:	   |      adda.l d0,a0
     dda:	   |      clr.b (a0)
		BPTR lock = Lock(f, ACCESS_READ);	
     ddc:	   |      move.l 1116(sp),1090(sp)
     de2:	   |      moveq #-2,d0
     de4:	   |      move.l d0,1086(sp)
     de8:	   |      move.l 7c3a <DOSBase>,d0
     dee:	   |      movea.l d0,a6
     df0:	   |      move.l 1090(sp),d1
     df4:	   |      move.l 1086(sp),d2
     df8:	   |      jsr -84(a6)
     dfc:	   |      move.l d0,1082(sp)
     e00:	   |      move.l 1082(sp),d0
     e04:	   |      move.l d0,1078(sp)
		if (!CurrentDir(lock)) {
     e08:	   |      move.l 1078(sp),1074(sp)
     e0e:	   |      move.l 7c3a <DOSBase>,d0
     e14:	   |      movea.l d0,a6
     e16:	   |      move.l 1074(sp),d1
     e1a:	   |      jsr -126(a6)
     e1e:	   |      move.l d0,1070(sp)
     e22:	   |      move.l 1070(sp),d0
     e26:	   |  /-- bne.s e3a <setGameFilePath+0xf6>
			KPrintF("setGameFilePath:: Failed changing to directory %s\n", f);
     e28:	   |  |   move.l 1116(sp),-(sp)
     e2c:	   |  |   pea 2a0c <PutChar+0x2ce>
     e32:	   |  |   jsr 249c <KPrintF>
     e38:	   |  |   addq.l #8,sp
		}
		f[got] = PATHSLASH;
     e3a:	   |  \-> move.l 1108(sp),d0
     e3e:	   |      movea.l 1116(sp),a0
     e42:	   |      adda.l d0,a0
     e44:	   |      move.b #47,(a0)
	}

	gamePath = AllocVec(400, MEMF_ANY);
     e48:	   \----> move.l #400,1066(sp)
     e50:	          clr.l 1062(sp)
     e54:	          move.l 7c32 <SysBase>,d0
     e5a:	          movea.l d0,a6
     e5c:	          move.l 1066(sp),d0
     e60:	          move.l 1062(sp),d1
     e64:	          jsr -684(a6)
     e68:	          move.l d0,1058(sp)
     e6c:	          move.l 1058(sp),d0
     e70:	          move.l d0,7c12 <gamePath>
	if (gamePath==0) {
     e76:	          move.l 7c12 <gamePath>,d0
     e7c:	      /-- bne.s e90 <setGameFilePath+0x14c>
		KPrintF("setGameFilePath: Can't reserve memory for game directory.\n");
     e7e:	      |   pea 2a3f <PutChar+0x301>
     e84:	      |   jsr 249c <KPrintF>
     e8a:	      |   addq.l #4,sp
     e8c:	   /--|-- bra.w f78 <setGameFilePath+0x234>
		return;
	}

	BPTR lock = Lock(gamePath, ACCESS_READ);	
     e90:	   |  \-> move.l 7c12 <gamePath>,1054(sp)
     e98:	   |      moveq #-2,d0
     e9a:	   |      move.l d0,1050(sp)
     e9e:	   |      move.l 7c3a <DOSBase>,d0
     ea4:	   |      movea.l d0,a6
     ea6:	   |      move.l 1054(sp),d1
     eaa:	   |      move.l 1050(sp),d2
     eae:	   |      jsr -84(a6)
     eb2:	   |      move.l d0,1046(sp)
     eb6:	   |      move.l 1046(sp),d0
     eba:	   |      move.l d0,1042(sp)
	if (! CurrentDir(lock)) {
     ebe:	   |      move.l 1042(sp),1038(sp)
     ec4:	   |      move.l 7c3a <DOSBase>,d0
     eca:	   |      movea.l d0,a6
     ecc:	   |      move.l 1038(sp),d1
     ed0:	   |      jsr -126(a6)
     ed4:	   |      move.l d0,1034(sp)
     ed8:	   |      move.l 1034(sp),d0
     edc:	   |  /-- bne.s eec <setGameFilePath+0x1a8>
		KPrintF("setGameFilePath: Can't get game directory.\n");
     ede:	   |  |   pea 2a7a <PutChar+0x33c>
     ee4:	   |  |   jsr 249c <KPrintF>
     eea:	   |  |   addq.l #4,sp
	}
	
	lock = Lock(currentDir, ACCESS_READ);	
     eec:	   |  \-> move.l #1112,d0
     ef2:	   |      add.l sp,d0
     ef4:	   |      addi.l #-1102,d0
     efa:	   |      move.l d0,1030(sp)
     efe:	   |      moveq #-2,d0
     f00:	   |      move.l d0,1026(sp)
     f04:	   |      move.l 7c3a <DOSBase>,d0
     f0a:	   |      movea.l d0,a6
     f0c:	   |      move.l 1030(sp),d1
     f10:	   |      move.l 1026(sp),d2
     f14:	   |      jsr -84(a6)
     f18:	   |      move.l d0,1022(sp)
     f1c:	   |      move.l 1022(sp),d0
     f20:	   |      move.l d0,1042(sp)
	if (!CurrentDir(lock)) {	
     f24:	   |      move.l 1042(sp),1018(sp)
     f2a:	   |      move.l 7c3a <DOSBase>,d0
     f30:	   |      movea.l d0,a6
     f32:	   |      move.l 1018(sp),d1
     f36:	   |      jsr -126(a6)
     f3a:	   |      move.l d0,1014(sp)
     f3e:	   |      move.l 1014(sp),d0
     f42:	   |  /-- bne.s f58 <setGameFilePath+0x214>
		KPrintF("setGameFilePath: Failed changing to directory %s\n", currentDir);
     f44:	   |  |   moveq #10,d0
     f46:	   |  |   add.l sp,d0
     f48:	   |  |   move.l d0,-(sp)
     f4a:	   |  |   pea 2aa6 <PutChar+0x368>
     f50:	   |  |   jsr 249c <KPrintF>
     f56:	   |  |   addq.l #8,sp
	}

	//Free Mem
	if (gamePath != 0) FreeVec(gamePath);
     f58:	   |  \-> move.l 7c12 <gamePath>,d0
     f5e:	   +----- beq.s f78 <setGameFilePath+0x234>
     f60:	   |      move.l 7c12 <gamePath>,1010(sp)
     f68:	   |      move.l 7c32 <SysBase>,d0
     f6e:	   |      movea.l d0,a6
     f70:	   |      movea.l 1010(sp),a1
     f74:	   |      jsr -690(a6)
}
     f78:	   \----> move.l (sp)+,d2
     f7a:	          movea.l (sp)+,a6
     f7c:	          lea 1104(sp),sp
     f80:	          rts

00000f82 <getNumberedString>:
// This is needed for old games.
char * convertString(char * s) {
	return NULL;
}

char * getNumberedString (int value) {
     f82:	       lea -56(sp),sp
     f86:	       movem.l d2-d3/a6,-(sp)

	if (sliceBusy) {
     f8a:	       move.w 6750 <sliceBusy>,d0
     f90:	   /-- beq.s fda <getNumberedString+0x58>
		Write(Output(), (APTR)"getNumberedString: Can't read from data file. I'm already reading something\n", 76);        
     f92:	   |   move.l 7c3a <DOSBase>,d0
     f98:	   |   movea.l d0,a6
     f9a:	   |   jsr -60(a6)
     f9e:	   |   move.l d0,28(sp)
     fa2:	   |   move.l 28(sp),d0
     fa6:	   |   move.l d0,24(sp)
     faa:	   |   move.l #10968,20(sp)
     fb2:	   |   moveq #76,d0
     fb4:	   |   move.l d0,16(sp)
     fb8:	   |   move.l 7c3a <DOSBase>,d0
     fbe:	   |   movea.l d0,a6
     fc0:	   |   move.l 24(sp),d1
     fc4:	   |   move.l 20(sp),d2
     fc8:	   |   move.l 16(sp),d3
     fcc:	   |   jsr -48(a6)
     fd0:	   |   move.l d0,12(sp)
		return NULL;
     fd4:	   |   moveq #0,d0
     fd6:	/--|-- bra.w 1076 <getNumberedString+0xf4>
	}

	Seek(bigDataFile, (value << 2) + startOfTextIndex, OFFSET_BEGINNING);
     fda:	|  \-> move.l 7c1a <bigDataFile>,64(sp)
     fe2:	|      move.l 72(sp),d0
     fe6:	|      add.l d0,d0
     fe8:	|      add.l d0,d0
     fea:	|      move.l d0,d1
     fec:	|      move.l 7c26 <startOfTextIndex>,d0
     ff2:	|      add.l d1,d0
     ff4:	|      move.l d0,60(sp)
     ff8:	|      moveq #-1,d0
     ffa:	|      move.l d0,56(sp)
     ffe:	|      move.l 7c3a <DOSBase>,d0
    1004:	|      movea.l d0,a6
    1006:	|      move.l 64(sp),d1
    100a:	|      move.l 60(sp),d2
    100e:	|      move.l 56(sp),d3
    1012:	|      jsr -66(a6)
    1016:	|      move.l d0,52(sp)
	value = get4bytes (bigDataFile);
    101a:	|      move.l 7c1a <bigDataFile>,d0
    1020:	|      move.l d0,-(sp)
    1022:	|      jsr 1a42 <get4bytes>
    1028:	|      addq.l #4,sp
    102a:	|      move.l d0,72(sp)
	Seek (bigDataFile, value, OFFSET_BEGINING);
    102e:	|      move.l 7c1a <bigDataFile>,48(sp)
    1036:	|      move.l 72(sp),44(sp)
    103c:	|      moveq #-1,d0
    103e:	|      move.l d0,40(sp)
    1042:	|      move.l 7c3a <DOSBase>,d0
    1048:	|      movea.l d0,a6
    104a:	|      move.l 48(sp),d1
    104e:	|      move.l 44(sp),d2
    1052:	|      move.l 40(sp),d3
    1056:	|      jsr -66(a6)
    105a:	|      move.l d0,36(sp)

	char * s = readString (bigDataFile);    
    105e:	|      move.l 7c1a <bigDataFile>,d0
    1064:	|      move.l d0,-(sp)
    1066:	|      jsr 1b7e <readString>
    106c:	|      addq.l #4,sp
    106e:	|      move.l d0,32(sp)
	
	return s;
    1072:	|      move.l 32(sp),d0
}
    1076:	\----> movem.l (sp)+,d2-d3/a6
    107a:	       lea 56(sp),sp
    107e:	       rts

00001080 <setFileIndices>:

void setFileIndices (BPTR fp, unsigned int numLanguages, unsigned int skipBefore) {
    1080:	       lea -180(sp),sp
    1084:	       movem.l d2-d3/a6,-(sp)
	if (fp) {
    1088:	       tst.l 196(sp)
    108c:	/----- beq.s 10cc <setFileIndices+0x4c>
		// Keep hold of the file handle, and let things get at it
		bigDataFile = fp;
    108e:	|      move.l 196(sp),7c1a <bigDataFile>
		startIndex = Seek( fp, 0, OFFSET_CURRENT);
    1096:	|      move.l 196(sp),168(sp)
    109c:	|      clr.l 164(sp)
    10a0:	|      clr.l 160(sp)
    10a4:	|      move.l 7c3a <DOSBase>,d0
    10aa:	|      movea.l d0,a6
    10ac:	|      move.l 168(sp),d1
    10b0:	|      move.l 164(sp),d2
    10b4:	|      move.l 160(sp),d3
    10b8:	|      jsr -66(a6)
    10bc:	|      move.l d0,156(sp)
    10c0:	|      move.l 156(sp),d0
    10c4:	|      move.l d0,7c1e <startIndex>
    10ca:	|  /-- bra.s 1106 <setFileIndices+0x86>
	} else {
		// No file pointer - this means that we reuse the bigDataFile
		fp = bigDataFile;
    10cc:	\--|-> move.l 7c1a <bigDataFile>,196(sp)
        Seek(fp, startIndex, OFFSET_BEGINNING);
    10d4:	   |   move.l 196(sp),184(sp)
    10da:	   |   move.l 7c1e <startIndex>,d0
    10e0:	   |   move.l d0,180(sp)
    10e4:	   |   moveq #-1,d0
    10e6:	   |   move.l d0,176(sp)
    10ea:	   |   move.l 7c3a <DOSBase>,d0
    10f0:	   |   movea.l d0,a6
    10f2:	   |   move.l 184(sp),d1
    10f6:	   |   move.l 180(sp),d2
    10fa:	   |   move.l 176(sp),d3
    10fe:	   |   jsr -66(a6)
    1102:	   |   move.l d0,172(sp)
	}
	sliceBusy = FALSE;
    1106:	   \-> clr.w 6750 <sliceBusy>

	if (skipBefore > numLanguages) {
    110c:	       move.l 204(sp),d0
    1110:	       cmp.l 200(sp),d0
    1114:	   /-- bls.s 1128 <setFileIndices+0xa8>
		KPrintF("setFileIndices: Warning: Not a valid language ID! Using default instead.");
    1116:	   |   pea 2b25 <PutChar+0x3e7>
    111c:	   |   jsr 249c <KPrintF>
    1122:	   |   addq.l #4,sp
		skipBefore = 0;
    1124:	   |   clr.l 204(sp)
	}

	// STRINGS
	int skipAfter = numLanguages - skipBefore;
    1128:	   \-> move.l 200(sp),d0
    112c:	       sub.l 204(sp),d0
    1130:	       move.l d0,188(sp)
	while (skipBefore) {
    1134:	   /-- bra.s 1170 <setFileIndices+0xf0>
        Seek(fp, get4bytes(fp),0);		
    1136:	/--|-> move.l 196(sp),24(sp)
    113c:	|  |   move.l 196(sp),-(sp)
    1140:	|  |   jsr 1a42 <get4bytes>
    1146:	|  |   addq.l #4,sp
    1148:	|  |   move.l d0,20(sp)
    114c:	|  |   clr.l 16(sp)
    1150:	|  |   move.l 7c3a <DOSBase>,d0
    1156:	|  |   movea.l d0,a6
    1158:	|  |   move.l 24(sp),d1
    115c:	|  |   move.l 20(sp),d2
    1160:	|  |   move.l 16(sp),d3
    1164:	|  |   jsr -66(a6)
    1168:	|  |   move.l d0,12(sp)
		skipBefore --;
    116c:	|  |   subq.l #1,204(sp)
	while (skipBefore) {
    1170:	|  \-> tst.l 204(sp)
    1174:	\----- bne.s 1136 <setFileIndices+0xb6>
	}
	startOfTextIndex = startIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    1176:	       move.l 196(sp),152(sp)
    117c:	       clr.l 148(sp)
    1180:	       clr.l 144(sp)
    1184:	       move.l 7c3a <DOSBase>,d0
    118a:	       movea.l d0,a6
    118c:	       move.l 152(sp),d1
    1190:	       move.l 148(sp),d2
    1194:	       move.l 144(sp),d3
    1198:	       jsr -66(a6)
    119c:	       move.l d0,140(sp)
    11a0:	       move.l 140(sp),d0
    11a4:	       addq.l #4,d0
    11a6:	       move.l d0,7c1e <startIndex>
    11ac:	       move.l 7c1e <startIndex>,d0
    11b2:	       move.l d0,7c26 <startOfTextIndex>

	Seek(fp, get4bytes (fp), OFFSET_BEGINNING);
    11b8:	       move.l 196(sp),136(sp)
    11be:	       move.l 196(sp),-(sp)
    11c2:	       jsr 1a42 <get4bytes>
    11c8:	       addq.l #4,sp
    11ca:	       move.l d0,132(sp)
    11ce:	       moveq #-1,d0
    11d0:	       move.l d0,128(sp)
    11d4:	       move.l 7c3a <DOSBase>,d0
    11da:	       movea.l d0,a6
    11dc:	       move.l 136(sp),d1
    11e0:	       move.l 132(sp),d2
    11e4:	       move.l 128(sp),d3
    11e8:	       jsr -66(a6)
    11ec:	       move.l d0,124(sp)

	while (skipAfter) {
    11f0:	   /-- bra.s 122e <setFileIndices+0x1ae>
        Seek( fp, get4bytes (fp), OFFSET_BEGINING);
    11f2:	/--|-> move.l 196(sp),40(sp)
    11f8:	|  |   move.l 196(sp),-(sp)
    11fc:	|  |   jsr 1a42 <get4bytes>
    1202:	|  |   addq.l #4,sp
    1204:	|  |   move.l d0,36(sp)
    1208:	|  |   moveq #-1,d0
    120a:	|  |   move.l d0,32(sp)
    120e:	|  |   move.l 7c3a <DOSBase>,d0
    1214:	|  |   movea.l d0,a6
    1216:	|  |   move.l 40(sp),d1
    121a:	|  |   move.l 36(sp),d2
    121e:	|  |   move.l 32(sp),d3
    1222:	|  |   jsr -66(a6)
    1226:	|  |   move.l d0,28(sp)
		skipAfter --;
    122a:	|  |   subq.l #1,188(sp)
	while (skipAfter) {
    122e:	|  \-> tst.l 188(sp)
    1232:	\----- bne.s 11f2 <setFileIndices+0x172>
	}

	startOfSubIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    1234:	       move.l 196(sp),120(sp)
    123a:	       clr.l 116(sp)
    123e:	       clr.l 112(sp)
    1242:	       move.l 7c3a <DOSBase>,d0
    1248:	       movea.l d0,a6
    124a:	       move.l 120(sp),d1
    124e:	       move.l 116(sp),d2
    1252:	       move.l 112(sp),d3
    1256:	       jsr -66(a6)
    125a:	       move.l d0,108(sp)
    125e:	       move.l 108(sp),d0
    1262:	       addq.l #4,d0
    1264:	       move.l d0,7c2a <startOfSubIndex>
    Seek( fp, get4bytes (fp), OFFSET_CURRENT);
    126a:	       move.l 196(sp),104(sp)
    1270:	       move.l 196(sp),-(sp)
    1274:	       jsr 1a42 <get4bytes>
    127a:	       addq.l #4,sp
    127c:	       move.l d0,100(sp)
    1280:	       clr.l 96(sp)
    1284:	       move.l 7c3a <DOSBase>,d0
    128a:	       movea.l d0,a6
    128c:	       move.l 104(sp),d1
    1290:	       move.l 100(sp),d2
    1294:	       move.l 96(sp),d3
    1298:	       jsr -66(a6)
    129c:	       move.l d0,92(sp)

	startOfObjectIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    12a0:	       move.l 196(sp),88(sp)
    12a6:	       clr.l 84(sp)
    12aa:	       clr.l 80(sp)
    12ae:	       move.l 7c3a <DOSBase>,d0
    12b4:	       movea.l d0,a6
    12b6:	       move.l 88(sp),d1
    12ba:	       move.l 84(sp),d2
    12be:	       move.l 80(sp),d3
    12c2:	       jsr -66(a6)
    12c6:	       move.l d0,76(sp)
    12ca:	       move.l 76(sp),d0
    12ce:	       addq.l #4,d0
    12d0:	       move.l d0,7c2e <startOfObjectIndex>
	Seek (fp, get4bytes (fp), OFFSET_CURRENT);
    12d6:	       move.l 196(sp),72(sp)
    12dc:	       move.l 196(sp),-(sp)
    12e0:	       jsr 1a42 <get4bytes>
    12e6:	       addq.l #4,sp
    12e8:	       move.l d0,68(sp)
    12ec:	       clr.l 64(sp)
    12f0:	       move.l 7c3a <DOSBase>,d0
    12f6:	       movea.l d0,a6
    12f8:	       move.l 72(sp),d1
    12fc:	       move.l 68(sp),d2
    1300:	       move.l 64(sp),d3
    1304:	       jsr -66(a6)
    1308:	       move.l d0,60(sp)

	// Remember that the data section starts here
	startOfDataIndex =  Seek( fp, 0, OFFSET_CURRENT);
    130c:	       move.l 196(sp),56(sp)
    1312:	       clr.l 52(sp)
    1316:	       clr.l 48(sp)
    131a:	       move.l 7c3a <DOSBase>,d0
    1320:	       movea.l d0,a6
    1322:	       move.l 56(sp),d1
    1326:	       move.l 52(sp),d2
    132a:	       move.l 48(sp),d3
    132e:	       jsr -66(a6)
    1332:	       move.l d0,44(sp)
    1336:	       move.l 44(sp),d0
    133a:	       move.l d0,7c22 <startOfDataIndex>
    1340:	       nop
    1342:	       movem.l (sp)+,d2-d3/a6
    1346:	       lea 180(sp),sp
    134a:	       rts

0000134c <WaitVbl>:
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
}

//vblank begins at vpos 312 hpos 1 and ends at vpos 25 hpos 1
//vsync begins at line 2 hpos 132 and ends at vpos 5 hpos 18 
void WaitVbl() {
    134c:	       subq.l #8,sp
	debug_start_idle();
    134e:	       jsr 2674 <debug_start_idle>
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    1354:	   /-> movea.l #14675972,a0
    135a:	   |   move.l (a0),d0
    135c:	   |   move.l d0,(sp)
		vpos&=0x1ff00;
    135e:	   |   move.l (sp),d0
    1360:	   |   andi.l #130816,d0
    1366:	   |   move.l d0,(sp)
		if (vpos!=(311<<8))
    1368:	   |   move.l (sp),d0
    136a:	   |   cmpi.l #79616,d0
    1370:	   \-- beq.s 1354 <WaitVbl+0x8>
			break;
	}
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    1372:	/----> movea.l #14675972,a0
    1378:	|      move.l (a0),d0
    137a:	|      move.l d0,4(sp)
		vpos&=0x1ff00;
    137e:	|      move.l 4(sp),d0
    1382:	|      andi.l #130816,d0
    1388:	|      move.l d0,4(sp)
		if (vpos==(311<<8))
    138c:	|      move.l 4(sp),d0
    1390:	|      cmpi.l #79616,d0
    1396:	|  /-- beq.s 139a <WaitVbl+0x4e>
	while (1) {
    1398:	\--|-- bra.s 1372 <WaitVbl+0x26>
			break;
    139a:	   \-> nop
	}
	debug_stop_idle();
    139c:	       jsr 268e <debug_stop_idle>
}
    13a2:	       nop
    13a4:	       addq.l #8,sp
    13a6:	       rts

000013a8 <p61Init>:
	// The Player® 6.1A: Copyright © 1992-95 Jarno Paananen
	// P61.testmod - Module by Skylord/Sector 7 
	INCBIN(player, "player610.6.no_cia.bin")
	INCBIN_CHIP(module, "testmod.p61")

	int p61Init(const void* module) { // returns 0 if success, non-zero otherwise
    13a8:	move.l a3,-(sp)
    13aa:	move.l a2,-(sp)
		register volatile const void* _a0 ASM("a0") = module;
    13ac:	movea.l 12(sp),a0
		register volatile const void* _a1 ASM("a1") = NULL;
    13b0:	suba.l a1,a1
		register volatile const void* _a2 ASM("a2") = NULL;
    13b2:	suba.l a2,a2
		register volatile const void* _a3 ASM("a3") = player;
    13b4:	move.l 6752 <player>,d0
    13ba:	movea.l d0,a3
		register                int   _d0 ASM("d0"); // return value
		__asm volatile (
    13bc:	movem.l d1-d7/a4-a6,-(sp)
    13c0:	jsr (a3)
    13c2:	movem.l (sp)+,d1-d7/a4-a6
			"movem.l (%%sp)+,%%d1-%%d7/%%a4-%%a6"
		: "=r" (_d0), "+rf"(_a0), "+rf"(_a1), "+rf"(_a2), "+rf"(_a3)
		:
		: "cc", "memory");
		return _d0;
	}
    13c6:	movea.l (sp)+,a2
    13c8:	movea.l (sp)+,a3
    13ca:	rts

000013cc <p61End>:
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}

	void p61End() {
    13cc:	move.l a6,-(sp)
    13ce:	move.l a3,-(sp)
		register volatile const void* _a3 ASM("a3") = player;
    13d0:	move.l 6752 <player>,d0
    13d6:	movea.l d0,a3
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
    13d8:	movea.l #14675968,a6
		__asm volatile (
    13de:	movem.l d0-d1/a0-a1,-(sp)
    13e2:	jsr 8(a3)
    13e6:	movem.l (sp)+,d0-d1/a0-a1
			"jsr 8(%%a3)\n"
			"movem.l (%%sp)+,%%d0-%%d1/%%a0-%%a1"
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}
    13ea:	nop
    13ec:	movea.l (sp)+,a3
    13ee:	movea.l (sp)+,a6
    13f0:	rts

000013f2 <main>:
static void Wait10() { WaitLine(0x10); }
static void Wait11() { WaitLine(0x11); }
static void Wait12() { WaitLine(0x12); }
static void Wait13() { WaitLine(0x13); }

int main(int argc, char *argv[]) {
    13f2:	    lea -64(sp),sp
    13f6:	    movem.l d2-d3/a6,-(sp)
	SysBase = *((struct ExecBase**)4UL);
    13fa:	    movea.w #4,a0
    13fe:	    move.l (a0),d0
    1400:	    move.l d0,7c32 <SysBase>
	custom = (struct Custom*)0xdff000;
    1406:	    move.l #14675968,7c36 <custom>

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR)"graphics.library",0);
    1410:	    move.l #17621,72(sp)
    1418:	    clr.l 68(sp)
    141c:	    move.l 7c32 <SysBase>,d0
    1422:	    movea.l d0,a6
    1424:	    movea.l 72(sp),a1
    1428:	    move.l 68(sp),d0
    142c:	    jsr -552(a6)
    1430:	    move.l d0,64(sp)
    1434:	    move.l 64(sp),d0
    1438:	    move.l d0,7c3e <GfxBase>
	if (!GfxBase)
    143e:	    move.l 7c3e <GfxBase>,d0
    1444:	/-- bne.s 145a <main+0x68>
		Exit(0);
    1446:	|   clr.l 60(sp)
    144a:	|   move.l 7c3a <DOSBase>,d0
    1450:	|   movea.l d0,a6
    1452:	|   move.l 60(sp),d1
    1456:	|   jsr -144(a6)

	// used for printing
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
    145a:	\-> move.l #17638,56(sp)
    1462:	    clr.l 52(sp)
    1466:	    move.l 7c32 <SysBase>,d0
    146c:	    movea.l d0,a6
    146e:	    movea.l 56(sp),a1
    1472:	    move.l 52(sp),d0
    1476:	    jsr -552(a6)
    147a:	    move.l d0,48(sp)
    147e:	    move.l 48(sp),d0
    1482:	    move.l d0,7c3a <DOSBase>
	if (!DOSBase)
    1488:	    move.l 7c3a <DOSBase>,d0
    148e:	/-- bne.s 14a4 <main+0xb2>
		Exit(0);
    1490:	|   clr.l 44(sp)
    1494:	|   move.l 7c3a <DOSBase>,d0
    149a:	|   movea.l d0,a6
    149c:	|   move.l 44(sp),d1
    14a0:	|   jsr -144(a6)

	KPrintF("Hello debugger from Amiga!\n");
    14a4:	\-> pea 44f2 <incbin_player_end+0x1e>
    14aa:	    jsr 249c <KPrintF>
    14b0:	    addq.l #4,sp

	Write(Output(), (APTR)"Hello console!\n", 15);
    14b2:	    move.l 7c3a <DOSBase>,d0
    14b8:	    movea.l d0,a6
    14ba:	    jsr -60(a6)
    14be:	    move.l d0,40(sp)
    14c2:	    move.l 40(sp),d0
    14c6:	    move.l d0,36(sp)
    14ca:	    move.l #17678,32(sp)
    14d2:	    moveq #15,d0
    14d4:	    move.l d0,28(sp)
    14d8:	    move.l 7c3a <DOSBase>,d0
    14de:	    movea.l d0,a6
    14e0:	    move.l 36(sp),d1
    14e4:	    move.l 32(sp),d2
    14e8:	    move.l 28(sp),d3
    14ec:	    jsr -48(a6)
    14f0:	    move.l d0,24(sp)
	Delay(50);
    14f4:	    moveq #50,d0
    14f6:	    move.l d0,20(sp)
    14fa:	    move.l 7c3a <DOSBase>,d0
    1500:	    movea.l d0,a6
    1502:	    move.l 20(sp),d1
    1506:	    jsr -198(a6)

	warpmode(1);
    150a:	    pea 1 <_start+0x1>
    150e:	    jsr 2506 <warpmode>
    1514:	    addq.l #4,sp
	// TODO: precalc stuff here
#ifdef MUSIC
	if(p61Init(module) != 0)
    1516:	    move.l 6756 <module>,d0
    151c:	    move.l d0,-(sp)
    151e:	    jsr 13a8 <p61Init>
    1524:	    addq.l #4,sp
    1526:	    tst.l d0
    1528:	/-- beq.s 1538 <main+0x146>
		KPrintF("p61Init failed!\n");
    152a:	|   pea 451e <incbin_player_end+0x4a>
    1530:	|   jsr 249c <KPrintF>
    1536:	|   addq.l #4,sp
#endif
	warpmode(0);
    1538:	\-> clr.l -(sp)
    153a:	    jsr 2506 <warpmode>
    1540:	    addq.l #4,sp

	//TakeSystem();
	custom->dmacon = 0x87ff;
    1542:	    movea.l 7c36 <custom>,a0
    1548:	    move.w #-30721,150(a0)
	WaitVbl();
    154e:	    jsr 134c <WaitVbl>

	main_sludge(argc, argv);
    1554:	    move.l 84(sp),-(sp)
    1558:	    move.l 84(sp),-(sp)
    155c:	    jsr b94 <main_sludge>
    1562:	    addq.l #8,sp
	debug_register_copperlist(copper2, "copper2", sizeof(copper2), 0);*/



#ifdef MUSIC
	p61End();
    1564:	    jsr 13cc <p61End>
#endif

	// END
	//FreeSystem();

	CloseLibrary((struct Library*)DOSBase);
    156a:	    move.l 7c3a <DOSBase>,16(sp)
    1572:	    move.l 7c32 <SysBase>,d0
    1578:	    movea.l d0,a6
    157a:	    movea.l 16(sp),a1
    157e:	    jsr -414(a6)
	CloseLibrary((struct Library*)GfxBase);
    1582:	    move.l 7c3e <GfxBase>,12(sp)
    158a:	    move.l 7c32 <SysBase>,d0
    1590:	    movea.l d0,a6
    1592:	    movea.l 12(sp),a1
    1596:	    jsr -414(a6)
    159a:	    moveq #0,d0
}
    159c:	    movem.l (sp)+,d2-d3/a6
    15a0:	    lea 64(sp),sp
    15a4:	    rts

000015a6 <positionStatus>:

struct statusStuff mainStatus;
struct statusStuff * nowStatus = & mainStatus;

void positionStatus (int x, int y) {
	nowStatus -> statusX = x;
    15a6:	movea.l 675a <nowStatus>,a0
    15ac:	move.l 4(sp),10(a0)
	nowStatus -> statusY = y;
    15b2:	movea.l 675a <nowStatus>,a0
    15b8:	move.l 8(sp),14(a0)
    15be:	nop
    15c0:	rts

000015c2 <makeNullAnim>:
#include <proto/exec.h>

#include "people.h"

struct personaAnimation * makeNullAnim () {
    15c2:	       lea -16(sp),sp
    15c6:	       move.l a6,-(sp)

	struct personaAnimation * newAnim	= AllocVec(sizeof(struct personaAnimation),MEMF_ANY);
    15c8:	       moveq #12,d0
    15ca:	       move.l d0,16(sp)
    15ce:	       clr.l 12(sp)
    15d2:	       move.l 7c32 <SysBase>,d0
    15d8:	       movea.l d0,a6
    15da:	       move.l 16(sp),d0
    15de:	       move.l 12(sp),d1
    15e2:	       jsr -684(a6)
    15e6:	       move.l d0,8(sp)
    15ea:	       move.l 8(sp),d0
    15ee:	       move.l d0,4(sp)
    if(newAnim == 0) {
    15f2:	   /-- bne.s 1606 <makeNullAnim+0x44>
     	KPrintF("makeNullAnim: Can't reserve Memory\n");
    15f4:	   |   pea 452f <incbin_player_end+0x5b>
    15fa:	   |   jsr 249c <KPrintF>
    1600:	   |   addq.l #4,sp
        return NULL;    
    1602:	   |   moveq #0,d0
    1604:	/--|-- bra.s 1620 <makeNullAnim+0x5e>
    }  

	newAnim -> theSprites		= NULL;
    1606:	|  \-> movea.l 4(sp),a0
    160a:	|      clr.l (a0)
	newAnim -> numFrames		= 0;
    160c:	|      movea.l 4(sp),a0
    1610:	|      clr.l 8(a0)
	newAnim -> frames			= NULL;
    1614:	|      movea.l 4(sp),a0
    1618:	|      clr.l 4(a0)
	return newAnim;
    161c:	|      move.l 4(sp),d0
}
    1620:	\----> movea.l (sp)+,a6
    1622:	       lea 16(sp),sp
    1626:	       rts

00001628 <encodeFilename>:
#include "support/gcc8_c_support.h"
#include "moreio.h"

BOOL allowAnyFilename = TRUE;

char * encodeFilename (char * nameIn) {
    1628:	                      lea -24(sp),sp
    162c:	                      move.l a6,-(sp)
	if (! nameIn) return NULL;
    162e:	                      tst.l 32(sp)
    1632:	                  /-- bne.s 163a <encodeFilename+0x12>
    1634:	                  |   moveq #0,d0
    1636:	/-----------------|-- bra.w 19b2 <encodeFilename+0x38a>
	if (allowAnyFilename) {
    163a:	|                 \-> move.w 675e <allowAnyFilename>,d0
    1640:	|  /----------------- beq.w 196e <encodeFilename+0x346>
		char * newName = AllocVec( strlen(nameIn)*2+1,MEMF_ANY);
    1644:	|  |                  move.l 32(sp),-(sp)
    1648:	|  |                  jsr 1c66 <strlen>
    164e:	|  |                  addq.l #4,sp
    1650:	|  |                  add.l d0,d0
    1652:	|  |                  move.l d0,d1
    1654:	|  |                  addq.l #1,d1
    1656:	|  |                  move.l d1,16(sp)
    165a:	|  |                  clr.l 12(sp)
    165e:	|  |                  move.l 7c32 <SysBase>,d0
    1664:	|  |                  movea.l d0,a6
    1666:	|  |                  move.l 16(sp),d0
    166a:	|  |                  move.l 12(sp),d1
    166e:	|  |                  jsr -684(a6)
    1672:	|  |                  move.l d0,8(sp)
    1676:	|  |                  move.l 8(sp),d0
    167a:	|  |                  move.l d0,4(sp)
		if(newName == 0) {
    167e:	|  |              /-- bne.s 1694 <encodeFilename+0x6c>
			KPrintF( "encodefilename: Could not allocate Memory");
    1680:	|  |              |   pea 4553 <incbin_player_end+0x7f>
    1686:	|  |              |   jsr 249c <KPrintF>
    168c:	|  |              |   addq.l #4,sp
			return NULL;
    168e:	|  |              |   moveq #0,d0
    1690:	+--|--------------|-- bra.w 19b2 <encodeFilename+0x38a>
		}

		int i = 0;
    1694:	|  |              \-> clr.l 24(sp)
		while (*nameIn) {
    1698:	|  |     /----------- bra.w 195e <encodeFilename+0x336>
			switch (*nameIn) {
    169c:	|  |  /--|----------> movea.l 32(sp),a0
    16a0:	|  |  |  |            move.b (a0),d0
    16a2:	|  |  |  |            ext.w d0
    16a4:	|  |  |  |            movea.w d0,a0
    16a6:	|  |  |  |            moveq #95,d0
    16a8:	|  |  |  |            cmp.l a0,d0
    16aa:	|  |  |  |        /-- blt.w 174e <encodeFilename+0x126>
    16ae:	|  |  |  |        |   moveq #34,d1
    16b0:	|  |  |  |        |   cmp.l a0,d1
    16b2:	|  |  |  |  /-----|-- bgt.w 1932 <encodeFilename+0x30a>
    16b6:	|  |  |  |  |     |   moveq #-34,d0
    16b8:	|  |  |  |  |     |   add.l a0,d0
    16ba:	|  |  |  |  |     |   moveq #61,d1
    16bc:	|  |  |  |  |     |   cmp.l d0,d1
    16be:	|  |  |  |  +-----|-- bcs.w 1932 <encodeFilename+0x30a>
    16c2:	|  |  |  |  |     |   add.l d0,d0
    16c4:	|  |  |  |  |     |   movea.l d0,a0
    16c6:	|  |  |  |  |     |   adda.l #5842,a0
    16cc:	|  |  |  |  |     |   move.w (a0),d0
    16ce:	|  |  |  |  |     |   jmp (16d2 <encodeFilename+0xaa>,pc,d0.w)
    16d2:	|  |  |  |  |     |   bchg d0,d6
    16d4:	|  |  |  |  |     |   andi.w #608,-(a0)
    16d8:	|  |  |  |  |     |   andi.w #608,-(a0)
    16dc:	|  |  |  |  |     |   andi.w #608,-(a0)
    16e0:	|  |  |  |  |     |   andi.w #516,-(a0)
    16e4:	|  |  |  |  |     |   andi.w #608,-(a0)
    16e8:	|  |  |  |  |     |   andi.w #608,-(a0)
    16ec:	|  |  |  |  |     |   bclr d0,-(a6)
    16ee:	|  |  |  |  |     |   andi.w #608,-(a0)
    16f2:	|  |  |  |  |     |   andi.w #608,-(a0)
    16f6:	|  |  |  |  |     |   andi.w #608,-(a0)
    16fa:	|  |  |  |  |     |   andi.w #608,-(a0)
    16fe:	|  |  |  |  |     |   andi.w #608,-(a0)
    1702:	|  |  |  |  |     |   bset d0,(a6)
    1704:	|  |  |  |  |     |   andi.w #134,-(a0)
    1708:	|  |  |  |  |     |   andi.w #182,-(a0)
    170c:	|  |  |  |  |     |   andi.b #96,(96,a2,d0.w:2)
    1712:	|  |  |  |  |     |   andi.w #608,-(a0)
    1716:	|  |  |  |  |     |   andi.w #608,-(a0)
    171a:	|  |  |  |  |     |   andi.w #608,-(a0)
    171e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1722:	|  |  |  |  |     |   andi.w #608,-(a0)
    1726:	|  |  |  |  |     |   andi.w #608,-(a0)
    172a:	|  |  |  |  |     |   andi.w #608,-(a0)
    172e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1732:	|  |  |  |  |     |   andi.w #608,-(a0)
    1736:	|  |  |  |  |     |   andi.w #608,-(a0)
    173a:	|  |  |  |  |     |   andi.w #608,-(a0)
    173e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1742:	|  |  |  |  |     |   andi.w #608,-(a0)
    1746:	|  |  |  |  |     |   bchg d0,(96,a6,d0.w:2)
    174a:	|  |  |  |  |     |   andi.w #278,-(a0)
    174e:	|  |  |  |  |     \-> moveq #124,d0
    1750:	|  |  |  |  |         cmp.l a0,d0
    1752:	|  |  |  |  |     /-- beq.s 17b8 <encodeFilename+0x190>
    1754:	|  |  |  |  +-----|-- bra.w 1932 <encodeFilename+0x30a>
				case '<':	newName[i++] = '_';		newName[i++] = 'L';		break;
    1758:	|  |  |  |  |     |   move.l 24(sp),d0
    175c:	|  |  |  |  |     |   move.l d0,d1
    175e:	|  |  |  |  |     |   addq.l #1,d1
    1760:	|  |  |  |  |     |   move.l d1,24(sp)
    1764:	|  |  |  |  |     |   movea.l 4(sp),a0
    1768:	|  |  |  |  |     |   adda.l d0,a0
    176a:	|  |  |  |  |     |   move.b #95,(a0)
    176e:	|  |  |  |  |     |   move.l 24(sp),d0
    1772:	|  |  |  |  |     |   move.l d0,d1
    1774:	|  |  |  |  |     |   addq.l #1,d1
    1776:	|  |  |  |  |     |   move.l d1,24(sp)
    177a:	|  |  |  |  |     |   movea.l 4(sp),a0
    177e:	|  |  |  |  |     |   adda.l d0,a0
    1780:	|  |  |  |  |     |   move.b #76,(a0)
    1784:	|  |  |  |  |  /--|-- bra.w 194e <encodeFilename+0x326>
				case '>':	newName[i++] = '_';		newName[i++] = 'G';		break;
    1788:	|  |  |  |  |  |  |   move.l 24(sp),d0
    178c:	|  |  |  |  |  |  |   move.l d0,d1
    178e:	|  |  |  |  |  |  |   addq.l #1,d1
    1790:	|  |  |  |  |  |  |   move.l d1,24(sp)
    1794:	|  |  |  |  |  |  |   movea.l 4(sp),a0
    1798:	|  |  |  |  |  |  |   adda.l d0,a0
    179a:	|  |  |  |  |  |  |   move.b #95,(a0)
    179e:	|  |  |  |  |  |  |   move.l 24(sp),d0
    17a2:	|  |  |  |  |  |  |   move.l d0,d1
    17a4:	|  |  |  |  |  |  |   addq.l #1,d1
    17a6:	|  |  |  |  |  |  |   move.l d1,24(sp)
    17aa:	|  |  |  |  |  |  |   movea.l 4(sp),a0
    17ae:	|  |  |  |  |  |  |   adda.l d0,a0
    17b0:	|  |  |  |  |  |  |   move.b #71,(a0)
    17b4:	|  |  |  |  |  +--|-- bra.w 194e <encodeFilename+0x326>
				case '|':	newName[i++] = '_';		newName[i++] = 'P';		break;
    17b8:	|  |  |  |  |  |  \-> move.l 24(sp),d0
    17bc:	|  |  |  |  |  |      move.l d0,d1
    17be:	|  |  |  |  |  |      addq.l #1,d1
    17c0:	|  |  |  |  |  |      move.l d1,24(sp)
    17c4:	|  |  |  |  |  |      movea.l 4(sp),a0
    17c8:	|  |  |  |  |  |      adda.l d0,a0
    17ca:	|  |  |  |  |  |      move.b #95,(a0)
    17ce:	|  |  |  |  |  |      move.l 24(sp),d0
    17d2:	|  |  |  |  |  |      move.l d0,d1
    17d4:	|  |  |  |  |  |      addq.l #1,d1
    17d6:	|  |  |  |  |  |      move.l d1,24(sp)
    17da:	|  |  |  |  |  |      movea.l 4(sp),a0
    17de:	|  |  |  |  |  |      adda.l d0,a0
    17e0:	|  |  |  |  |  |      move.b #80,(a0)
    17e4:	|  |  |  |  |  +----- bra.w 194e <encodeFilename+0x326>
				case '_':	newName[i++] = '_';		newName[i++] = 'U';		break;
    17e8:	|  |  |  |  |  |      move.l 24(sp),d0
    17ec:	|  |  |  |  |  |      move.l d0,d1
    17ee:	|  |  |  |  |  |      addq.l #1,d1
    17f0:	|  |  |  |  |  |      move.l d1,24(sp)
    17f4:	|  |  |  |  |  |      movea.l 4(sp),a0
    17f8:	|  |  |  |  |  |      adda.l d0,a0
    17fa:	|  |  |  |  |  |      move.b #95,(a0)
    17fe:	|  |  |  |  |  |      move.l 24(sp),d0
    1802:	|  |  |  |  |  |      move.l d0,d1
    1804:	|  |  |  |  |  |      addq.l #1,d1
    1806:	|  |  |  |  |  |      move.l d1,24(sp)
    180a:	|  |  |  |  |  |      movea.l 4(sp),a0
    180e:	|  |  |  |  |  |      adda.l d0,a0
    1810:	|  |  |  |  |  |      move.b #85,(a0)
    1814:	|  |  |  |  |  +----- bra.w 194e <encodeFilename+0x326>
				case '\"':	newName[i++] = '_';		newName[i++] = 'S';		break;
    1818:	|  |  |  |  |  |      move.l 24(sp),d0
    181c:	|  |  |  |  |  |      move.l d0,d1
    181e:	|  |  |  |  |  |      addq.l #1,d1
    1820:	|  |  |  |  |  |      move.l d1,24(sp)
    1824:	|  |  |  |  |  |      movea.l 4(sp),a0
    1828:	|  |  |  |  |  |      adda.l d0,a0
    182a:	|  |  |  |  |  |      move.b #95,(a0)
    182e:	|  |  |  |  |  |      move.l 24(sp),d0
    1832:	|  |  |  |  |  |      move.l d0,d1
    1834:	|  |  |  |  |  |      addq.l #1,d1
    1836:	|  |  |  |  |  |      move.l d1,24(sp)
    183a:	|  |  |  |  |  |      movea.l 4(sp),a0
    183e:	|  |  |  |  |  |      adda.l d0,a0
    1840:	|  |  |  |  |  |      move.b #83,(a0)
    1844:	|  |  |  |  |  +----- bra.w 194e <encodeFilename+0x326>
				case '\\':	newName[i++] = '_';		newName[i++] = 'B';		break;
    1848:	|  |  |  |  |  |      move.l 24(sp),d0
    184c:	|  |  |  |  |  |      move.l d0,d1
    184e:	|  |  |  |  |  |      addq.l #1,d1
    1850:	|  |  |  |  |  |      move.l d1,24(sp)
    1854:	|  |  |  |  |  |      movea.l 4(sp),a0
    1858:	|  |  |  |  |  |      adda.l d0,a0
    185a:	|  |  |  |  |  |      move.b #95,(a0)
    185e:	|  |  |  |  |  |      move.l 24(sp),d0
    1862:	|  |  |  |  |  |      move.l d0,d1
    1864:	|  |  |  |  |  |      addq.l #1,d1
    1866:	|  |  |  |  |  |      move.l d1,24(sp)
    186a:	|  |  |  |  |  |      movea.l 4(sp),a0
    186e:	|  |  |  |  |  |      adda.l d0,a0
    1870:	|  |  |  |  |  |      move.b #66,(a0)
    1874:	|  |  |  |  |  +----- bra.w 194e <encodeFilename+0x326>
				case '/':	newName[i++] = '_';		newName[i++] = 'F';		break;
    1878:	|  |  |  |  |  |      move.l 24(sp),d0
    187c:	|  |  |  |  |  |      move.l d0,d1
    187e:	|  |  |  |  |  |      addq.l #1,d1
    1880:	|  |  |  |  |  |      move.l d1,24(sp)
    1884:	|  |  |  |  |  |      movea.l 4(sp),a0
    1888:	|  |  |  |  |  |      adda.l d0,a0
    188a:	|  |  |  |  |  |      move.b #95,(a0)
    188e:	|  |  |  |  |  |      move.l 24(sp),d0
    1892:	|  |  |  |  |  |      move.l d0,d1
    1894:	|  |  |  |  |  |      addq.l #1,d1
    1896:	|  |  |  |  |  |      move.l d1,24(sp)
    189a:	|  |  |  |  |  |      movea.l 4(sp),a0
    189e:	|  |  |  |  |  |      adda.l d0,a0
    18a0:	|  |  |  |  |  |      move.b #70,(a0)
    18a4:	|  |  |  |  |  +----- bra.w 194e <encodeFilename+0x326>
				case ':':	newName[i++] = '_';		newName[i++] = 'C';		break;
    18a8:	|  |  |  |  |  |      move.l 24(sp),d0
    18ac:	|  |  |  |  |  |      move.l d0,d1
    18ae:	|  |  |  |  |  |      addq.l #1,d1
    18b0:	|  |  |  |  |  |      move.l d1,24(sp)
    18b4:	|  |  |  |  |  |      movea.l 4(sp),a0
    18b8:	|  |  |  |  |  |      adda.l d0,a0
    18ba:	|  |  |  |  |  |      move.b #95,(a0)
    18be:	|  |  |  |  |  |      move.l 24(sp),d0
    18c2:	|  |  |  |  |  |      move.l d0,d1
    18c4:	|  |  |  |  |  |      addq.l #1,d1
    18c6:	|  |  |  |  |  |      move.l d1,24(sp)
    18ca:	|  |  |  |  |  |      movea.l 4(sp),a0
    18ce:	|  |  |  |  |  |      adda.l d0,a0
    18d0:	|  |  |  |  |  |      move.b #67,(a0)
    18d4:	|  |  |  |  |  +----- bra.s 194e <encodeFilename+0x326>
				case '*':	newName[i++] = '_';		newName[i++] = 'A';		break;
    18d6:	|  |  |  |  |  |      move.l 24(sp),d0
    18da:	|  |  |  |  |  |      move.l d0,d1
    18dc:	|  |  |  |  |  |      addq.l #1,d1
    18de:	|  |  |  |  |  |      move.l d1,24(sp)
    18e2:	|  |  |  |  |  |      movea.l 4(sp),a0
    18e6:	|  |  |  |  |  |      adda.l d0,a0
    18e8:	|  |  |  |  |  |      move.b #95,(a0)
    18ec:	|  |  |  |  |  |      move.l 24(sp),d0
    18f0:	|  |  |  |  |  |      move.l d0,d1
    18f2:	|  |  |  |  |  |      addq.l #1,d1
    18f4:	|  |  |  |  |  |      move.l d1,24(sp)
    18f8:	|  |  |  |  |  |      movea.l 4(sp),a0
    18fc:	|  |  |  |  |  |      adda.l d0,a0
    18fe:	|  |  |  |  |  |      move.b #65,(a0)
    1902:	|  |  |  |  |  +----- bra.s 194e <encodeFilename+0x326>
				case '?':	newName[i++] = '_';		newName[i++] = 'Q';		break;
    1904:	|  |  |  |  |  |      move.l 24(sp),d0
    1908:	|  |  |  |  |  |      move.l d0,d1
    190a:	|  |  |  |  |  |      addq.l #1,d1
    190c:	|  |  |  |  |  |      move.l d1,24(sp)
    1910:	|  |  |  |  |  |      movea.l 4(sp),a0
    1914:	|  |  |  |  |  |      adda.l d0,a0
    1916:	|  |  |  |  |  |      move.b #95,(a0)
    191a:	|  |  |  |  |  |      move.l 24(sp),d0
    191e:	|  |  |  |  |  |      move.l d0,d1
    1920:	|  |  |  |  |  |      addq.l #1,d1
    1922:	|  |  |  |  |  |      move.l d1,24(sp)
    1926:	|  |  |  |  |  |      movea.l 4(sp),a0
    192a:	|  |  |  |  |  |      adda.l d0,a0
    192c:	|  |  |  |  |  |      move.b #81,(a0)
    1930:	|  |  |  |  |  +----- bra.s 194e <encodeFilename+0x326>

				default:	newName[i++] = *nameIn;							break;
    1932:	|  |  |  |  \--|----> move.l 24(sp),d0
    1936:	|  |  |  |     |      move.l d0,d1
    1938:	|  |  |  |     |      addq.l #1,d1
    193a:	|  |  |  |     |      move.l d1,24(sp)
    193e:	|  |  |  |     |      movea.l 4(sp),a0
    1942:	|  |  |  |     |      adda.l d0,a0
    1944:	|  |  |  |     |      movea.l 32(sp),a1
    1948:	|  |  |  |     |      move.b (a1),d0
    194a:	|  |  |  |     |      move.b d0,(a0)
    194c:	|  |  |  |     |      nop
			}
			newName[i] = 0;
    194e:	|  |  |  |     \----> move.l 24(sp),d0
    1952:	|  |  |  |            movea.l 4(sp),a0
    1956:	|  |  |  |            adda.l d0,a0
    1958:	|  |  |  |            clr.b (a0)
			nameIn ++;
    195a:	|  |  |  |            addq.l #1,32(sp)
		while (*nameIn) {
    195e:	|  |  |  \----------> movea.l 32(sp),a0
    1962:	|  |  |               move.b (a0),d0
    1964:	|  |  \-------------- bne.w 169c <encodeFilename+0x74>
		}
		return newName;
    1968:	|  |                  move.l 4(sp),d0
    196c:	+--|----------------- bra.s 19b2 <encodeFilename+0x38a>
	} else {
		int a;
		for (a = 0; nameIn[a]; a ++) {
    196e:	|  \----------------> clr.l 20(sp)
    1972:	|              /----- bra.s 1998 <encodeFilename+0x370>
			if (nameIn[a] == '\\') nameIn[a] ='/';
    1974:	|           /--|----> move.l 20(sp),d0
    1978:	|           |  |      movea.l 32(sp),a0
    197c:	|           |  |      adda.l d0,a0
    197e:	|           |  |      move.b (a0),d0
    1980:	|           |  |      cmpi.b #92,d0
    1984:	|           |  |  /-- bne.s 1994 <encodeFilename+0x36c>
    1986:	|           |  |  |   move.l 20(sp),d0
    198a:	|           |  |  |   movea.l 32(sp),a0
    198e:	|           |  |  |   adda.l d0,a0
    1990:	|           |  |  |   move.b #47,(a0)
		for (a = 0; nameIn[a]; a ++) {
    1994:	|           |  |  \-> addq.l #1,20(sp)
    1998:	|           |  \----> move.l 20(sp),d0
    199c:	|           |         movea.l 32(sp),a0
    19a0:	|           |         adda.l d0,a0
    19a2:	|           |         move.b (a0),d0
    19a4:	|           \-------- bne.s 1974 <encodeFilename+0x34c>
		}

		return copyString (nameIn);
    19a6:	|                     move.l 32(sp),-(sp)
    19aa:	|                     jsr 1ca6 <copyString>
    19b0:	|                     addq.l #4,sp
	}
}
    19b2:	\-------------------> movea.l (sp)+,a6
    19b4:	                      lea 24(sp),sp
    19b8:	                      rts

000019ba <floatSwap>:

float floatSwap( float f )
{
    19ba:	subq.l #8,sp
	{
		float f;
		unsigned char b[4];
	} dat1, dat2;

	dat1.f = f;
    19bc:	move.l 12(sp),4(sp)
	dat2.b[0] = dat1.b[3];
    19c2:	move.b 7(sp),d0
    19c6:	move.b d0,(sp)
	dat2.b[1] = dat1.b[2];
    19c8:	move.b 6(sp),d0
    19cc:	move.b d0,1(sp)
	dat2.b[2] = dat1.b[1];
    19d0:	move.b 5(sp),d0
    19d4:	move.b d0,2(sp)
	dat2.b[3] = dat1.b[0];
    19d8:	move.b 4(sp),d0
    19dc:	move.b d0,3(sp)
	return dat2.f;
    19e0:	move.l (sp),d0
}
    19e2:	addq.l #8,sp
    19e4:	rts

000019e6 <get2bytes>:

int get2bytes (BPTR fp) {
    19e6:	lea -24(sp),sp
    19ea:	move.l a6,-(sp)
	int f1, f2;

	f1 = FGetC (fp);
    19ec:	move.l 32(sp),24(sp)
    19f2:	move.l 7c3a <DOSBase>,d0
    19f8:	movea.l d0,a6
    19fa:	move.l 24(sp),d1
    19fe:	jsr -306(a6)
    1a02:	move.l d0,20(sp)
    1a06:	move.l 20(sp),d0
    1a0a:	move.l d0,16(sp)
	f2 = FGetC (fp);
    1a0e:	move.l 32(sp),12(sp)
    1a14:	move.l 7c3a <DOSBase>,d0
    1a1a:	movea.l d0,a6
    1a1c:	move.l 12(sp),d1
    1a20:	jsr -306(a6)
    1a24:	move.l d0,8(sp)
    1a28:	move.l 8(sp),d0
    1a2c:	move.l d0,4(sp)

	return (f1 * 256 + f2);
    1a30:	move.l 16(sp),d0
    1a34:	lsl.l #8,d0
    1a36:	add.l 4(sp),d0
}
    1a3a:	movea.l (sp)+,a6
    1a3c:	lea 24(sp),sp
    1a40:	rts

00001a42 <get4bytes>:

ULONG get4bytes (BPTR fp) {
    1a42:	lea -52(sp),sp
    1a46:	move.l a6,-(sp)
	int f1, f2, f3, f4;

	f1 = FGetC (fp);
    1a48:	move.l 60(sp),52(sp)
    1a4e:	move.l 7c3a <DOSBase>,d0
    1a54:	movea.l d0,a6
    1a56:	move.l 52(sp),d1
    1a5a:	jsr -306(a6)
    1a5e:	move.l d0,48(sp)
    1a62:	move.l 48(sp),d0
    1a66:	move.l d0,44(sp)
	f2 = FGetC (fp);
    1a6a:	move.l 60(sp),40(sp)
    1a70:	move.l 7c3a <DOSBase>,d0
    1a76:	movea.l d0,a6
    1a78:	move.l 40(sp),d1
    1a7c:	jsr -306(a6)
    1a80:	move.l d0,36(sp)
    1a84:	move.l 36(sp),d0
    1a88:	move.l d0,32(sp)
	f3 = FGetC (fp);
    1a8c:	move.l 60(sp),28(sp)
    1a92:	move.l 7c3a <DOSBase>,d0
    1a98:	movea.l d0,a6
    1a9a:	move.l 28(sp),d1
    1a9e:	jsr -306(a6)
    1aa2:	move.l d0,24(sp)
    1aa6:	move.l 24(sp),d0
    1aaa:	move.l d0,20(sp)
	f4 = FGetC (fp);
    1aae:	move.l 60(sp),16(sp)
    1ab4:	move.l 7c3a <DOSBase>,d0
    1aba:	movea.l d0,a6
    1abc:	move.l 16(sp),d1
    1ac0:	jsr -306(a6)
    1ac4:	move.l d0,12(sp)
    1ac8:	move.l 12(sp),d0
    1acc:	move.l d0,8(sp)

	ULONG x = f1 + f2*256 + f3*256*256 + f4*256*256*256;
    1ad0:	move.l 32(sp),d0
    1ad4:	lsl.l #8,d0
    1ad6:	move.l d0,d1
    1ad8:	add.l 44(sp),d1
    1adc:	move.l 20(sp),d0
    1ae0:	swap d0
    1ae2:	clr.w d0
    1ae4:	add.l d0,d1
    1ae6:	move.l 8(sp),d0
    1aea:	lsl.w #8,d0
    1aec:	swap d0
    1aee:	clr.w d0
    1af0:	add.l d1,d0
    1af2:	move.l d0,4(sp)

	return x;
    1af6:	move.l 4(sp),d0
}
    1afa:	movea.l (sp)+,a6
    1afc:	lea 52(sp),sp
    1b00:	rts

00001b02 <getFloat>:

float getFloat (BPTR fp) {
    1b02:	    lea -28(sp),sp
    1b06:	    movem.l d2-d4/a6,-(sp)
	float f;
	LONG blocks_read = FRead( fp, &f, sizeof (float), 1 ); 
    1b0a:	    move.l 48(sp),40(sp)
    1b10:	    lea 44(sp),a0
    1b14:	    lea -28(a0),a0
    1b18:	    move.l a0,36(sp)
    1b1c:	    moveq #4,d0
    1b1e:	    move.l d0,32(sp)
    1b22:	    moveq #1,d0
    1b24:	    move.l d0,28(sp)
    1b28:	    move.l 7c3a <DOSBase>,d0
    1b2e:	    movea.l d0,a6
    1b30:	    move.l 40(sp),d1
    1b34:	    move.l 36(sp),d2
    1b38:	    move.l 32(sp),d3
    1b3c:	    move.l 28(sp),d4
    1b40:	    jsr -324(a6)
    1b44:	    move.l d0,24(sp)
    1b48:	    move.l 24(sp),d0
    1b4c:	    move.l d0,20(sp)
	if (blocks_read != 1) {
    1b50:	    moveq #1,d0
    1b52:	    cmp.l 20(sp),d0
    1b56:	/-- beq.s 1b66 <getFloat+0x64>
		KPrintF("Reading error in getFloat.\n");
    1b58:	|   pea 457d <incbin_player_end+0xa9>
    1b5e:	|   jsr 249c <KPrintF>
    1b64:	|   addq.l #4,sp
	}
	return floatSwap(f);
    1b66:	\-> move.l 16(sp),d0
    1b6a:	    move.l d0,-(sp)
    1b6c:	    jsr 19ba <floatSwap>
    1b72:	    addq.l #4,sp
	return f;
}
    1b74:	    movem.l (sp)+,d2-d4/a6
    1b78:	    lea 28(sp),sp
    1b7c:	    rts

00001b7e <readString>:

char * readString (BPTR fp) {
    1b7e:	          lea -32(sp),sp
    1b82:	          move.l a6,-(sp)

	int a, len = get2bytes (fp);
    1b84:	          move.l 40(sp),-(sp)
    1b88:	          jsr 19e6 <get2bytes>
    1b8e:	          addq.l #4,sp
    1b90:	          move.l d0,28(sp)
	//debugOut ("MOREIO: readString - len %i\n", len);
	char * s = AllocVec(len+1,MEMF_ANY);
    1b94:	          move.l 28(sp),d0
    1b98:	          addq.l #1,d0
    1b9a:	          move.l d0,24(sp)
    1b9e:	          clr.l 20(sp)
    1ba2:	          move.l 7c32 <SysBase>,d0
    1ba8:	          movea.l d0,a6
    1baa:	          move.l 24(sp),d0
    1bae:	          move.l 20(sp),d1
    1bb2:	          jsr -684(a6)
    1bb6:	          move.l d0,16(sp)
    1bba:	          move.l 16(sp),d0
    1bbe:	          move.l d0,12(sp)
	if(s == 0) return NULL;
    1bc2:	      /-- bne.s 1bc8 <readString+0x4a>
    1bc4:	      |   moveq #0,d0
    1bc6:	/-----|-- bra.s 1c1e <readString+0xa0>
	for (a = 0; a < len; a ++) {
    1bc8:	|     \-> clr.l 32(sp)
    1bcc:	|     /-- bra.s 1c04 <readString+0x86>
		s[a] = (char) (FGetC (fp) - 1);
    1bce:	|  /--|-> move.l 40(sp),8(sp)
    1bd4:	|  |  |   move.l 7c3a <DOSBase>,d0
    1bda:	|  |  |   movea.l d0,a6
    1bdc:	|  |  |   move.l 8(sp),d1
    1be0:	|  |  |   jsr -306(a6)
    1be4:	|  |  |   move.l d0,4(sp)
    1be8:	|  |  |   move.l 4(sp),d0
    1bec:	|  |  |   move.l d0,d0
    1bee:	|  |  |   move.b d0,d1
    1bf0:	|  |  |   subq.b #1,d1
    1bf2:	|  |  |   move.l 32(sp),d0
    1bf6:	|  |  |   movea.l 12(sp),a0
    1bfa:	|  |  |   adda.l d0,a0
    1bfc:	|  |  |   move.b d1,d0
    1bfe:	|  |  |   move.b d0,(a0)
	for (a = 0; a < len; a ++) {
    1c00:	|  |  |   addq.l #1,32(sp)
    1c04:	|  |  \-> move.l 32(sp),d0
    1c08:	|  |      cmp.l 28(sp),d0
    1c0c:	|  \----- blt.s 1bce <readString+0x50>
	}
	s[len] = 0;
    1c0e:	|         move.l 28(sp),d0
    1c12:	|         movea.l 12(sp),a0
    1c16:	|         adda.l d0,a0
    1c18:	|         clr.b (a0)
	//debugOut ("MOREIO: readString: %s\n", s);
	return s;
    1c1a:	|         move.l 12(sp),d0
    1c1e:	\-------> movea.l (sp)+,a6
    1c20:	          lea 32(sp),sp
    1c24:	          rts

00001c26 <strcmp>:
#include "support/gcc8_c_support.h"


int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1 == *s2))
    1c26:	   /-- bra.s 1c30 <strcmp+0xa>
    {
        s1++;
    1c28:	/--|-> addq.l #1,4(sp)
        s2++;
    1c2c:	|  |   addq.l #1,8(sp)
    while(*s1 && (*s1 == *s2))
    1c30:	|  \-> movea.l 4(sp),a0
    1c34:	|      move.b (a0),d0
    1c36:	|  /-- beq.s 1c48 <strcmp+0x22>
    1c38:	|  |   movea.l 4(sp),a0
    1c3c:	|  |   move.b (a0),d1
    1c3e:	|  |   movea.l 8(sp),a0
    1c42:	|  |   move.b (a0),d0
    1c44:	|  |   cmp.b d1,d0
    1c46:	\--|-- beq.s 1c28 <strcmp+0x2>
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
    1c48:	   \-> movea.l 4(sp),a0
    1c4c:	       move.b (a0),d0
    1c4e:	       moveq #0,d1
    1c50:	       move.b d0,d1
    1c52:	       movea.l 8(sp),a0
    1c56:	       move.b (a0),d0
    1c58:	       move.b d0,d0
    1c5a:	       andi.l #255,d0
    1c60:	       sub.l d0,d1
    1c62:	       move.l d1,d0
}
    1c64:	       rts

00001c66 <strlen>:

long unsigned int strlen (const char *s) 
{  
    1c66:	       subq.l #4,sp
	long unsigned int i = 0;
    1c68:	       clr.l (sp)
	while(s[i]) i++; 
    1c6a:	   /-- bra.s 1c6e <strlen+0x8>
    1c6c:	/--|-> addq.l #1,(sp)
    1c6e:	|  \-> movea.l 8(sp),a0
    1c72:	|      adda.l (sp),a0
    1c74:	|      move.b (a0),d0
    1c76:	\----- bne.s 1c6c <strlen+0x6>
	return(i);
    1c78:	       move.l (sp),d0
}
    1c7a:	       addq.l #4,sp
    1c7c:	       rts

00001c7e <strcpy>:

char *strcpy(char *t, const char *s) 
{
	while(*t++ = *s++);
    1c7e:	    nop
    1c80:	/-> move.l 8(sp),d0
    1c84:	|   move.l d0,d1
    1c86:	|   addq.l #1,d1
    1c88:	|   move.l d1,8(sp)
    1c8c:	|   movea.l 4(sp),a0
    1c90:	|   lea 1(a0),a1
    1c94:	|   move.l a1,4(sp)
    1c98:	|   movea.l d0,a1
    1c9a:	|   move.b (a1),d0
    1c9c:	|   move.b d0,(a0)
    1c9e:	|   move.b (a0),d0
    1ca0:	\-- bne.s 1c80 <strcpy+0x2>
}
    1ca2:	    nop
    1ca4:	    rts

00001ca6 <copyString>:

char * copyString (const char * copyMe) {
    1ca6:	       lea -16(sp),sp
    1caa:	       move.l a6,-(sp)
	
	char * newString = AllocVec(strlen(copyMe)+1, MEMF_ANY); 
    1cac:	       move.l 24(sp),-(sp)
    1cb0:	       jsr 1c66 <strlen>
    1cb6:	       addq.l #4,sp
    1cb8:	       move.l d0,d1
    1cba:	       addq.l #1,d1
    1cbc:	       move.l d1,16(sp)
    1cc0:	       clr.l 12(sp)
    1cc4:	       move.l 7c32 <SysBase>,d0
    1cca:	       movea.l d0,a6
    1ccc:	       move.l 16(sp),d0
    1cd0:	       move.l 12(sp),d1
    1cd4:	       jsr -684(a6)
    1cd8:	       move.l d0,8(sp)
    1cdc:	       move.l 8(sp),d0
    1ce0:	       move.l d0,4(sp)
	if(newString == 0) {
    1ce4:	   /-- bne.s 1cf8 <copyString+0x52>
		KPrintF("copystring: Can't reserve memory for newString\n");
    1ce6:	   |   pea 4599 <incbin_player_end+0xc5>
    1cec:	   |   jsr 249c <KPrintF>
    1cf2:	   |   addq.l #4,sp
		return NULL;	
    1cf4:	   |   moveq #0,d0
    1cf6:	/--|-- bra.s 1d0c <copyString+0x66>
	}
	strcpy (newString, copyMe);
    1cf8:	|  \-> move.l 24(sp),-(sp)
    1cfc:	|      move.l 8(sp),-(sp)
    1d00:	|      jsr 1c7e <strcpy>
    1d06:	|      addq.l #8,sp
	return newString;
    1d08:	|      move.l 4(sp),d0
}
    1d0c:	\----> movea.l (sp)+,a6
    1d0e:	       lea 16(sp),sp
    1d12:	       rts

00001d14 <joinStrings>:

char * joinStrings (const char * s1, const char * s2) {
    1d14:	    lea -20(sp),sp
    1d18:	    move.l a6,-(sp)
    1d1a:	    move.l d2,-(sp)
	char * newString = AllocVec(strlen (s1) + strlen (s2) + 1, MEMF_ANY); 
    1d1c:	    move.l 32(sp),-(sp)
    1d20:	    jsr 1c66 <strlen>
    1d26:	    addq.l #4,sp
    1d28:	    move.l d0,d2
    1d2a:	    move.l 36(sp),-(sp)
    1d2e:	    jsr 1c66 <strlen>
    1d34:	    addq.l #4,sp
    1d36:	    add.l d2,d0
    1d38:	    move.l d0,d1
    1d3a:	    addq.l #1,d1
    1d3c:	    move.l d1,20(sp)
    1d40:	    clr.l 16(sp)
    1d44:	    move.l 7c32 <SysBase>,d0
    1d4a:	    movea.l d0,a6
    1d4c:	    move.l 20(sp),d0
    1d50:	    move.l 16(sp),d1
    1d54:	    jsr -684(a6)
    1d58:	    move.l d0,12(sp)
    1d5c:	    move.l 12(sp),d0
    1d60:	    move.l d0,8(sp)
	char * t = newString;
    1d64:	    move.l 8(sp),24(sp)

	while(*t++ = *s1++);
    1d6a:	    nop
    1d6c:	/-> move.l 32(sp),d0
    1d70:	|   move.l d0,d1
    1d72:	|   addq.l #1,d1
    1d74:	|   move.l d1,32(sp)
    1d78:	|   movea.l 24(sp),a0
    1d7c:	|   lea 1(a0),a1
    1d80:	|   move.l a1,24(sp)
    1d84:	|   movea.l d0,a1
    1d86:	|   move.b (a1),d0
    1d88:	|   move.b d0,(a0)
    1d8a:	|   move.b (a0),d0
    1d8c:	\-- bne.s 1d6c <joinStrings+0x58>
	t--;
    1d8e:	    subq.l #1,24(sp)
	while(*t++ = *s2++);
    1d92:	    nop
    1d94:	/-> move.l 36(sp),d0
    1d98:	|   move.l d0,d1
    1d9a:	|   addq.l #1,d1
    1d9c:	|   move.l d1,36(sp)
    1da0:	|   movea.l 24(sp),a0
    1da4:	|   lea 1(a0),a1
    1da8:	|   move.l a1,24(sp)
    1dac:	|   movea.l d0,a1
    1dae:	|   move.b (a1),d0
    1db0:	|   move.b d0,(a0)
    1db2:	|   move.b (a0),d0
    1db4:	\-- bne.s 1d94 <joinStrings+0x80>

	return newString;
    1db6:	    move.l 8(sp),d0
}
    1dba:	    move.l (sp)+,d2
    1dbc:	    movea.l (sp)+,a6
    1dbe:	    lea 20(sp),sp
    1dc2:	    rts

00001dc4 <getLanguageForFileB>:
int *languageTable;
char **languageName;
struct settingsStruct gameSettings;

int getLanguageForFileB ()
{
    1dc4:	          subq.l #8,sp
	int indexNum = -1;
    1dc6:	          moveq #-1,d0
    1dc8:	          move.l d0,4(sp)

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    1dcc:	          clr.l (sp)
    1dce:	   /----- bra.s 1df4 <getLanguageForFileB+0x30>
		if (languageTable[i] == gameSettings.languageID) indexNum = i;
    1dd0:	/--|----> move.l 7c6c <languageTable>,d1
    1dd6:	|  |      move.l (sp),d0
    1dd8:	|  |      add.l d0,d0
    1dda:	|  |      add.l d0,d0
    1ddc:	|  |      movea.l d1,a0
    1dde:	|  |      adda.l d0,a0
    1de0:	|  |      move.l (a0),d0
    1de2:	|  |      move.l d0,d1
    1de4:	|  |      move.l 7c74 <gameSettings>,d0
    1dea:	|  |      cmp.l d1,d0
    1dec:	|  |  /-- bne.s 1df2 <getLanguageForFileB+0x2e>
    1dee:	|  |  |   move.l (sp),4(sp)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    1df2:	|  |  \-> addq.l #1,(sp)
    1df4:	|  \----> move.l 7c78 <gameSettings+0x4>,d0
    1dfa:	|         cmp.l (sp),d0
    1dfc:	\-------- bcc.s 1dd0 <getLanguageForFileB+0xc>
	}

	return indexNum;
    1dfe:	          move.l 4(sp),d0
}
    1e02:	          addq.l #8,sp
    1e04:	          rts

00001e06 <getPrefsFilename>:

char * getPrefsFilename (char * filename) {
    1e06:	          lea -20(sp),sp
    1e0a:	          move.l a6,-(sp)
	// Yes, this trashes the original string, but
	// we also free it at the end (warning!)...

	int n, i;

	n = strlen (filename);
    1e0c:	          move.l 28(sp),-(sp)
    1e10:	          jsr 1c66 <strlen>
    1e16:	          addq.l #4,sp
    1e18:	          move.l d0,12(sp)


	if (n > 4 && filename[n-4] == '.') {
    1e1c:	          moveq #4,d0
    1e1e:	          cmp.l 12(sp),d0
    1e22:	      /-- bge.s 1e46 <getPrefsFilename+0x40>
    1e24:	      |   move.l 12(sp),d0
    1e28:	      |   subq.l #4,d0
    1e2a:	      |   movea.l 28(sp),a0
    1e2e:	      |   adda.l d0,a0
    1e30:	      |   move.b (a0),d0
    1e32:	      |   cmpi.b #46,d0
    1e36:	      +-- bne.s 1e46 <getPrefsFilename+0x40>
		filename[n-4] = 0;
    1e38:	      |   move.l 12(sp),d0
    1e3c:	      |   subq.l #4,d0
    1e3e:	      |   movea.l 28(sp),a0
    1e42:	      |   adda.l d0,a0
    1e44:	      |   clr.b (a0)
	}

	char * f = filename;
    1e46:	      \-> move.l 28(sp),16(sp)
	for (i = 0; i<n; i++) {
    1e4c:	          clr.l 20(sp)
    1e50:	   /----- bra.s 1e78 <getPrefsFilename+0x72>
		if (filename[i] == '/') f = filename + i + 1;
    1e52:	/--|----> move.l 20(sp),d0
    1e56:	|  |      movea.l 28(sp),a0
    1e5a:	|  |      adda.l d0,a0
    1e5c:	|  |      move.b (a0),d0
    1e5e:	|  |      cmpi.b #47,d0
    1e62:	|  |  /-- bne.s 1e74 <getPrefsFilename+0x6e>
    1e64:	|  |  |   move.l 20(sp),d0
    1e68:	|  |  |   addq.l #1,d0
    1e6a:	|  |  |   move.l 28(sp),d1
    1e6e:	|  |  |   add.l d0,d1
    1e70:	|  |  |   move.l d1,16(sp)
	for (i = 0; i<n; i++) {
    1e74:	|  |  \-> addq.l #1,20(sp)
    1e78:	|  \----> move.l 20(sp),d0
    1e7c:	|         cmp.l 12(sp),d0
    1e80:	\-------- blt.s 1e52 <getPrefsFilename+0x4c>
	}

	char * joined = joinStrings (f, ".ini");
    1e82:	          pea 45c9 <incbin_player_end+0xf5>
    1e88:	          move.l 20(sp),-(sp)
    1e8c:	          jsr 1d14 <joinStrings>
    1e92:	          addq.l #8,sp
    1e94:	          move.l d0,8(sp)

	FreeVec(filename);
    1e98:	          move.l 28(sp),4(sp)
    1e9e:	          move.l 7c32 <SysBase>,d0
    1ea4:	          movea.l d0,a6
    1ea6:	          movea.l 4(sp),a1
    1eaa:	          jsr -690(a6)
	filename = NULL;
    1eae:	          clr.l 28(sp)
	return joined;
    1eb2:	          move.l 8(sp),d0
}
    1eb6:	          movea.l (sp)+,a6
    1eb8:	          lea 20(sp),sp
    1ebc:	          rts

00001ebe <makeLanguageTable>:

void makeLanguageTable (BPTR table)
{
    1ebe:	             lea -28(sp),sp
    1ec2:	             move.l a6,-(sp)
    1ec4:	             move.l a2,-(sp)
	languageTable = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    1ec6:	             move.l 7c78 <gameSettings+0x4>,d0
    1ecc:	             move.l d0,d1
    1ece:	             addq.l #1,d1
    1ed0:	             move.l d1,28(sp)
    1ed4:	             clr.l 24(sp)
    1ed8:	             move.l 7c32 <SysBase>,d0
    1ede:	             movea.l d0,a6
    1ee0:	             move.l 28(sp),d0
    1ee4:	             move.l 24(sp),d1
    1ee8:	             jsr -684(a6)
    1eec:	             move.l d0,20(sp)
    1ef0:	             move.l 20(sp),d0
    1ef4:	             move.l d0,7c6c <languageTable>
    if( languageTable == 0) {
    1efa:	             move.l 7c6c <languageTable>,d0
    1f00:	         /-- bne.s 1f10 <makeLanguageTable+0x52>
        KPrintF("makeLanguageTable: Cannot Alloc Mem for languageTable");
    1f02:	         |   pea 45ce <incbin_player_end+0xfa>
    1f08:	         |   jsr 249c <KPrintF>
    1f0e:	         |   addq.l #4,sp
    }

	languageName = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    1f10:	         \-> move.l 7c78 <gameSettings+0x4>,d0
    1f16:	             move.l d0,d1
    1f18:	             addq.l #1,d1
    1f1a:	             move.l d1,16(sp)
    1f1e:	             clr.l 12(sp)
    1f22:	             move.l 7c32 <SysBase>,d0
    1f28:	             movea.l d0,a6
    1f2a:	             move.l 16(sp),d0
    1f2e:	             move.l 12(sp),d1
    1f32:	             jsr -684(a6)
    1f36:	             move.l d0,8(sp)
    1f3a:	             move.l 8(sp),d0
    1f3e:	             move.l d0,7c70 <languageName>
	if( languageName == 0) {
    1f44:	             move.l 7c70 <languageName>,d0
    1f4a:	         /-- bne.s 1f5a <makeLanguageTable+0x9c>
        KPrintF("makeLanguageName: Cannot Alloc Mem for languageName");
    1f4c:	         |   pea 4604 <incbin_player_end+0x130>
    1f52:	         |   jsr 249c <KPrintF>
    1f58:	         |   addq.l #4,sp
    }

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    1f5a:	         \-> clr.l 32(sp)
    1f5e:	   /-------- bra.s 1fd6 <makeLanguageTable+0x118>
		languageTable[i] = i ? get2bytes (table) : 0;
    1f60:	/--|-------> tst.l 32(sp)
    1f64:	|  |  /----- beq.s 1f74 <makeLanguageTable+0xb6>
    1f66:	|  |  |      move.l 40(sp),-(sp)
    1f6a:	|  |  |      jsr 19e6 <get2bytes>
    1f70:	|  |  |      addq.l #4,sp
    1f72:	|  |  |  /-- bra.s 1f76 <makeLanguageTable+0xb8>
    1f74:	|  |  \--|-> moveq #0,d0
    1f76:	|  |     \-> movea.l 7c6c <languageTable>,a0
    1f7c:	|  |         move.l 32(sp),d1
    1f80:	|  |         add.l d1,d1
    1f82:	|  |         add.l d1,d1
    1f84:	|  |         adda.l d1,a0
    1f86:	|  |         move.l d0,(a0)
		languageName[i] = 0;
    1f88:	|  |         move.l 7c70 <languageName>,d1
    1f8e:	|  |         move.l 32(sp),d0
    1f92:	|  |         add.l d0,d0
    1f94:	|  |         add.l d0,d0
    1f96:	|  |         movea.l d1,a0
    1f98:	|  |         adda.l d0,a0
    1f9a:	|  |         clr.l (a0)
		if (gameVersion >= VERSION(2,0)) {
    1f9c:	|  |         move.l 7be2 <gameVersion>,d0
    1fa2:	|  |         cmpi.l #511,d0
    1fa8:	|  |     /-- ble.s 1fd2 <makeLanguageTable+0x114>
			if (gameSettings.numLanguages)
    1faa:	|  |     |   move.l 7c78 <gameSettings+0x4>,d0
    1fb0:	|  |     +-- beq.s 1fd2 <makeLanguageTable+0x114>
				languageName[i] = readString (table);
    1fb2:	|  |     |   move.l 7c70 <languageName>,d1
    1fb8:	|  |     |   move.l 32(sp),d0
    1fbc:	|  |     |   add.l d0,d0
    1fbe:	|  |     |   add.l d0,d0
    1fc0:	|  |     |   movea.l d1,a2
    1fc2:	|  |     |   adda.l d0,a2
    1fc4:	|  |     |   move.l 40(sp),-(sp)
    1fc8:	|  |     |   jsr 1b7e <readString>
    1fce:	|  |     |   addq.l #4,sp
    1fd0:	|  |     |   move.l d0,(a2)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    1fd2:	|  |     \-> addq.l #1,32(sp)
    1fd6:	|  \-------> move.l 7c78 <gameSettings+0x4>,d0
    1fdc:	|            cmp.l 32(sp),d0
    1fe0:	\----------- bcc.w 1f60 <makeLanguageTable+0xa2>
		}
	}
}
    1fe4:	             nop
    1fe6:	             nop
    1fe8:	             movea.l (sp)+,a2
    1fea:	             movea.l (sp)+,a6
    1fec:	             lea 28(sp),sp
    1ff0:	             rts

00001ff2 <readIniFile>:

void readIniFile (char * filename) {
    1ff2:	                      lea -564(sp),sp
    1ff6:	                      move.l a6,-(sp)
    1ff8:	                      move.l d2,-(sp)
	char * langName = getPrefsFilename (copyString (filename));
    1ffa:	                      move.l 576(sp),-(sp)
    1ffe:	                      jsr 1ca6 <copyString>
    2004:	                      addq.l #4,sp
    2006:	                      move.l d0,-(sp)
    2008:	                      jsr 1e06 <getPrefsFilename>
    200e:	                      addq.l #4,sp
    2010:	                      move.l d0,562(sp)

	BPTR fp = Open(langName,MODE_OLDFILE);	
    2014:	                      move.l 562(sp),558(sp)
    201a:	                      move.l #1005,554(sp)
    2022:	                      move.l 7c3a <DOSBase>,d0
    2028:	                      movea.l d0,a6
    202a:	                      move.l 558(sp),d1
    202e:	                      move.l 554(sp),d2
    2032:	                      jsr -30(a6)
    2036:	                      move.l d0,550(sp)
    203a:	                      move.l 550(sp),d0
    203e:	                      move.l d0,546(sp)

	gameSettings.languageID = 0;
    2042:	                      clr.l 7c74 <gameSettings>
	gameSettings.userFullScreen = TRUE; //Always fullscreen on AMIGA
    2048:	                      move.w #1,7c7c <gameSettings+0x8>
	gameSettings.refreshRate = 0;
    2050:	                      clr.l 7c7e <gameSettings+0xa>
	gameSettings.antiAlias = 1;
    2056:	                      moveq #1,d0
    2058:	                      move.l d0,7c82 <gameSettings+0xe>
	gameSettings.fixedPixels = FALSE;
    205e:	                      clr.w 7c86 <gameSettings+0x12>
	gameSettings.noStartWindow = FALSE;
    2064:	                      clr.w 7c88 <gameSettings+0x14>
	gameSettings.debugMode = FALSE;
    206a:	                      clr.w 7c8a <gameSettings+0x16>

	FreeVec(langName);
    2070:	                      move.l 562(sp),542(sp)
    2076:	                      move.l 7c32 <SysBase>,d0
    207c:	                      movea.l d0,a6
    207e:	                      movea.l 542(sp),a1
    2082:	                      jsr -690(a6)
	langName = NULL;
    2086:	                      clr.l 562(sp)

	if (fp) {
    208a:	                      tst.l 546(sp)
    208e:	/-------------------- beq.w 236c <readIniFile+0x37a>
		char lineSoFar[257] = "";
    2092:	|                     move.l sp,d0
    2094:	|                     addi.l #265,d0
    209a:	|                     move.l #257,d1
    20a0:	|                     move.l d1,-(sp)
    20a2:	|                     clr.l -(sp)
    20a4:	|                     move.l d0,-(sp)
    20a6:	|                     jsr 246c <memset>
    20ac:	|                     lea 12(sp),sp
		char secondSoFar[257] = "";
    20b0:	|                     move.l sp,d0
    20b2:	|                     addq.l #8,d0
    20b4:	|                     move.l #257,d1
    20ba:	|                     move.l d1,-(sp)
    20bc:	|                     clr.l -(sp)
    20be:	|                     move.l d0,-(sp)
    20c0:	|                     jsr 246c <memset>
    20c6:	|                     lea 12(sp),sp
		unsigned char here = 0;
    20ca:	|                     clr.b 571(sp)
		char readChar = ' ';
    20ce:	|                     move.b #32,570(sp)
		BOOL keepGoing = TRUE;
    20d4:	|                     move.w #1,568(sp)
		BOOL doingSecond = FALSE;
    20da:	|                     clr.w 566(sp)
		LONG tmp = 0;
    20de:	|                     clr.l 538(sp)

		do {

			tmp = FGetC (fp);
    20e2:	|  /----------------> move.l 546(sp),534(sp)
    20e8:	|  |                  move.l 7c3a <DOSBase>,d0
    20ee:	|  |                  movea.l d0,a6
    20f0:	|  |                  move.l 534(sp),d1
    20f4:	|  |                  jsr -306(a6)
    20f8:	|  |                  move.l d0,530(sp)
    20fc:	|  |                  move.l 530(sp),d0
    2100:	|  |                  move.l d0,538(sp)
			if (tmp == - 1) {
    2104:	|  |                  moveq #-1,d1
    2106:	|  |                  cmp.l 538(sp),d1
    210a:	|  |           /----- bne.s 2118 <readIniFile+0x126>
				readChar = '\n';
    210c:	|  |           |      move.b #10,570(sp)
				keepGoing = FALSE;
    2112:	|  |           |      clr.w 568(sp)
    2116:	|  |           |  /-- bra.s 211e <readIniFile+0x12c>
			} else {
				readChar = (char) tmp;
    2118:	|  |           \--|-> move.b 541(sp),570(sp)
			}

			switch (readChar) {
    211e:	|  |              \-> move.b 570(sp),d0
    2122:	|  |                  ext.w d0
    2124:	|  |                  movea.w d0,a0
    2126:	|  |                  moveq #61,d0
    2128:	|  |                  cmp.l a0,d0
    212a:	|  |     /----------- beq.w 22d4 <readIniFile+0x2e2>
    212e:	|  |     |            moveq #61,d1
    2130:	|  |     |            cmp.l a0,d1
    2132:	|  |  /--|----------- blt.w 22e0 <readIniFile+0x2ee>
    2136:	|  |  |  |            moveq #10,d0
    2138:	|  |  |  |            cmp.l a0,d0
    213a:	|  |  |  |        /-- beq.s 2144 <readIniFile+0x152>
    213c:	|  |  |  |        |   moveq #13,d1
    213e:	|  |  |  |        |   cmp.l a0,d1
    2140:	|  |  +--|--------|-- bne.w 22e0 <readIniFile+0x2ee>
				case '\n':
				case '\r':
				if (doingSecond) {
    2144:	|  |  |  |        \-> tst.w 566(sp)
    2148:	|  |  |  |     /----- beq.w 22c2 <readIniFile+0x2d0>
					if (strcmp (lineSoFar, "LANGUAGE") == 0)
    214c:	|  |  |  |     |      pea 4638 <incbin_player_end+0x164>
    2152:	|  |  |  |     |      move.l sp,d0
    2154:	|  |  |  |     |      addi.l #269,d0
    215a:	|  |  |  |     |      move.l d0,-(sp)
    215c:	|  |  |  |     |      jsr 1c26 <strcmp>
    2162:	|  |  |  |     |      addq.l #8,sp
    2164:	|  |  |  |     |      tst.l d0
    2166:	|  |  |  |     |  /-- bne.s 2180 <readIniFile+0x18e>
					{
						gameSettings.languageID = stringToInt (secondSoFar);
    2168:	|  |  |  |     |  |   move.l sp,d0
    216a:	|  |  |  |     |  |   addq.l #8,d0
    216c:	|  |  |  |     |  |   move.l d0,-(sp)
    216e:	|  |  |  |     |  |   jsr 2378 <stringToInt>
    2174:	|  |  |  |     |  |   addq.l #4,sp
    2176:	|  |  |  |     |  |   move.l d0,7c74 <gameSettings>
    217c:	|  |  |  |     +--|-- bra.w 22c2 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "WINDOW") == 0)
    2180:	|  |  |  |     |  \-> pea 4641 <incbin_player_end+0x16d>
    2186:	|  |  |  |     |      move.l sp,d0
    2188:	|  |  |  |     |      addi.l #269,d0
    218e:	|  |  |  |     |      move.l d0,-(sp)
    2190:	|  |  |  |     |      jsr 1c26 <strcmp>
    2196:	|  |  |  |     |      addq.l #8,sp
    2198:	|  |  |  |     |      tst.l d0
    219a:	|  |  |  |     |  /-- bne.s 21c0 <readIniFile+0x1ce>
					{
						gameSettings.userFullScreen = ! stringToInt (secondSoFar);
    219c:	|  |  |  |     |  |   move.l sp,d0
    219e:	|  |  |  |     |  |   addq.l #8,d0
    21a0:	|  |  |  |     |  |   move.l d0,-(sp)
    21a2:	|  |  |  |     |  |   jsr 2378 <stringToInt>
    21a8:	|  |  |  |     |  |   addq.l #4,sp
    21aa:	|  |  |  |     |  |   tst.l d0
    21ac:	|  |  |  |     |  |   seq d0
    21ae:	|  |  |  |     |  |   neg.b d0
    21b0:	|  |  |  |     |  |   move.b d0,d0
    21b2:	|  |  |  |     |  |   andi.w #255,d0
    21b6:	|  |  |  |     |  |   move.w d0,7c7c <gameSettings+0x8>
    21bc:	|  |  |  |     +--|-- bra.w 22c2 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "REFRESH") == 0)
    21c0:	|  |  |  |     |  \-> pea 4648 <incbin_player_end+0x174>
    21c6:	|  |  |  |     |      move.l sp,d0
    21c8:	|  |  |  |     |      addi.l #269,d0
    21ce:	|  |  |  |     |      move.l d0,-(sp)
    21d0:	|  |  |  |     |      jsr 1c26 <strcmp>
    21d6:	|  |  |  |     |      addq.l #8,sp
    21d8:	|  |  |  |     |      tst.l d0
    21da:	|  |  |  |     |  /-- bne.s 21f4 <readIniFile+0x202>
					{
						gameSettings.refreshRate = stringToInt (secondSoFar);
    21dc:	|  |  |  |     |  |   move.l sp,d0
    21de:	|  |  |  |     |  |   addq.l #8,d0
    21e0:	|  |  |  |     |  |   move.l d0,-(sp)
    21e2:	|  |  |  |     |  |   jsr 2378 <stringToInt>
    21e8:	|  |  |  |     |  |   addq.l #4,sp
    21ea:	|  |  |  |     |  |   move.l d0,7c7e <gameSettings+0xa>
    21f0:	|  |  |  |     +--|-- bra.w 22c2 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "ANTIALIAS") == 0)
    21f4:	|  |  |  |     |  \-> pea 4650 <incbin_player_end+0x17c>
    21fa:	|  |  |  |     |      move.l sp,d0
    21fc:	|  |  |  |     |      addi.l #269,d0
    2202:	|  |  |  |     |      move.l d0,-(sp)
    2204:	|  |  |  |     |      jsr 1c26 <strcmp>
    220a:	|  |  |  |     |      addq.l #8,sp
    220c:	|  |  |  |     |      tst.l d0
    220e:	|  |  |  |     |  /-- bne.s 2228 <readIniFile+0x236>
					{
						gameSettings.antiAlias = stringToInt (secondSoFar);
    2210:	|  |  |  |     |  |   move.l sp,d0
    2212:	|  |  |  |     |  |   addq.l #8,d0
    2214:	|  |  |  |     |  |   move.l d0,-(sp)
    2216:	|  |  |  |     |  |   jsr 2378 <stringToInt>
    221c:	|  |  |  |     |  |   addq.l #4,sp
    221e:	|  |  |  |     |  |   move.l d0,7c82 <gameSettings+0xe>
    2224:	|  |  |  |     +--|-- bra.w 22c2 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "FIXEDPIXELS") == 0)
    2228:	|  |  |  |     |  \-> pea 465a <incbin_player_end+0x186>
    222e:	|  |  |  |     |      move.l sp,d0
    2230:	|  |  |  |     |      addi.l #269,d0
    2236:	|  |  |  |     |      move.l d0,-(sp)
    2238:	|  |  |  |     |      jsr 1c26 <strcmp>
    223e:	|  |  |  |     |      addq.l #8,sp
    2240:	|  |  |  |     |      tst.l d0
    2242:	|  |  |  |     |  /-- bne.s 225c <readIniFile+0x26a>
					{
						gameSettings.fixedPixels = stringToInt (secondSoFar);
    2244:	|  |  |  |     |  |   move.l sp,d0
    2246:	|  |  |  |     |  |   addq.l #8,d0
    2248:	|  |  |  |     |  |   move.l d0,-(sp)
    224a:	|  |  |  |     |  |   jsr 2378 <stringToInt>
    2250:	|  |  |  |     |  |   addq.l #4,sp
    2252:	|  |  |  |     |  |   move.l d0,d0
    2254:	|  |  |  |     |  |   move.w d0,7c86 <gameSettings+0x12>
    225a:	|  |  |  |     +--|-- bra.s 22c2 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "NOSTARTWINDOW") == 0)
    225c:	|  |  |  |     |  \-> pea 4666 <incbin_player_end+0x192>
    2262:	|  |  |  |     |      move.l sp,d0
    2264:	|  |  |  |     |      addi.l #269,d0
    226a:	|  |  |  |     |      move.l d0,-(sp)
    226c:	|  |  |  |     |      jsr 1c26 <strcmp>
    2272:	|  |  |  |     |      addq.l #8,sp
    2274:	|  |  |  |     |      tst.l d0
    2276:	|  |  |  |     |  /-- bne.s 2290 <readIniFile+0x29e>
					{
						gameSettings.noStartWindow = stringToInt (secondSoFar);
    2278:	|  |  |  |     |  |   move.l sp,d0
    227a:	|  |  |  |     |  |   addq.l #8,d0
    227c:	|  |  |  |     |  |   move.l d0,-(sp)
    227e:	|  |  |  |     |  |   jsr 2378 <stringToInt>
    2284:	|  |  |  |     |  |   addq.l #4,sp
    2286:	|  |  |  |     |  |   move.l d0,d0
    2288:	|  |  |  |     |  |   move.w d0,7c88 <gameSettings+0x14>
    228e:	|  |  |  |     +--|-- bra.s 22c2 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "DEBUGMODE") == 0)
    2290:	|  |  |  |     |  \-> pea 4674 <incbin_player_end+0x1a0>
    2296:	|  |  |  |     |      move.l sp,d0
    2298:	|  |  |  |     |      addi.l #269,d0
    229e:	|  |  |  |     |      move.l d0,-(sp)
    22a0:	|  |  |  |     |      jsr 1c26 <strcmp>
    22a6:	|  |  |  |     |      addq.l #8,sp
    22a8:	|  |  |  |     |      tst.l d0
    22aa:	|  |  |  |     +----- bne.s 22c2 <readIniFile+0x2d0>
					{
						gameSettings.debugMode = stringToInt (secondSoFar);
    22ac:	|  |  |  |     |      move.l sp,d0
    22ae:	|  |  |  |     |      addq.l #8,d0
    22b0:	|  |  |  |     |      move.l d0,-(sp)
    22b2:	|  |  |  |     |      jsr 2378 <stringToInt>
    22b8:	|  |  |  |     |      addq.l #4,sp
    22ba:	|  |  |  |     |      move.l d0,d0
    22bc:	|  |  |  |     |      move.w d0,7c8a <gameSettings+0x16>
					}
				}
				here = 0;
    22c2:	|  |  |  |     \----> clr.b 571(sp)
				doingSecond = FALSE;
    22c6:	|  |  |  |            clr.w 566(sp)
				lineSoFar[0] = 0;
    22ca:	|  |  |  |            clr.b 265(sp)
				secondSoFar[0] = 0;
    22ce:	|  |  |  |            clr.b 8(sp)
				break;
    22d2:	|  |  |  |  /-------- bra.s 234a <readIniFile+0x358>

				case '=':
				doingSecond = TRUE;
    22d4:	|  |  |  \--|-------> move.w #1,566(sp)
				here = 0;
    22da:	|  |  |     |         clr.b 571(sp)
				break;
    22de:	|  |  |     +-------- bra.s 234a <readIniFile+0x358>

				default:
				if (doingSecond) {
    22e0:	|  |  \-----|-------> tst.w 566(sp)
    22e4:	|  |        |  /----- beq.s 2318 <readIniFile+0x326>
					secondSoFar[here ++] = readChar;
    22e6:	|  |        |  |      move.b 571(sp),d0
    22ea:	|  |        |  |      move.b d0,d1
    22ec:	|  |        |  |      addq.b #1,d1
    22ee:	|  |        |  |      move.b d1,571(sp)
    22f2:	|  |        |  |      move.b d0,d0
    22f4:	|  |        |  |      andi.l #255,d0
    22fa:	|  |        |  |      lea 572(sp),a0
    22fe:	|  |        |  |      adda.l d0,a0
    2300:	|  |        |  |      move.b 570(sp),-564(a0)
					secondSoFar[here] = 0;
    2306:	|  |        |  |      moveq #0,d0
    2308:	|  |        |  |      move.b 571(sp),d0
    230c:	|  |        |  |      lea 572(sp),a0
    2310:	|  |        |  |      adda.l d0,a0
    2312:	|  |        |  |      clr.b -564(a0)
				} else {
					lineSoFar[here ++] = readChar;
					lineSoFar[here] = 0;
				}
				break;
    2316:	|  |        |  |  /-- bra.s 2348 <readIniFile+0x356>
					lineSoFar[here ++] = readChar;
    2318:	|  |        |  \--|-> move.b 571(sp),d0
    231c:	|  |        |     |   move.b d0,d1
    231e:	|  |        |     |   addq.b #1,d1
    2320:	|  |        |     |   move.b d1,571(sp)
    2324:	|  |        |     |   move.b d0,d0
    2326:	|  |        |     |   andi.l #255,d0
    232c:	|  |        |     |   lea 572(sp),a0
    2330:	|  |        |     |   adda.l d0,a0
    2332:	|  |        |     |   move.b 570(sp),-307(a0)
					lineSoFar[here] = 0;
    2338:	|  |        |     |   moveq #0,d0
    233a:	|  |        |     |   move.b 571(sp),d0
    233e:	|  |        |     |   lea 572(sp),a0
    2342:	|  |        |     |   adda.l d0,a0
    2344:	|  |        |     |   clr.b -307(a0)
				break;
    2348:	|  |        |     \-> nop
			}
		} while (keepGoing);
    234a:	|  |        \-------> tst.w 568(sp)
    234e:	|  \----------------- bne.w 20e2 <readIniFile+0xf0>

		Close(fp);
    2352:	|                     move.l 546(sp),526(sp)
    2358:	|                     move.l 7c3a <DOSBase>,d0
    235e:	|                     movea.l d0,a6
    2360:	|                     move.l 526(sp),d1
    2364:	|                     jsr -36(a6)
    2368:	|                     move.l d0,522(sp)
	}
}
    236c:	\-------------------> nop
    236e:	                      move.l (sp)+,d2
    2370:	                      movea.l (sp)+,a6
    2372:	                      lea 564(sp),sp
    2376:	                      rts

00002378 <stringToInt>:

unsigned int stringToInt (char * s) {
    2378:	             subq.l #8,sp
	int i = 0;
    237a:	             clr.l 4(sp)
	BOOL negative = FALSE;
    237e:	             clr.w 2(sp)
	for (;;) {
		if (*s >= '0' && *s <= '9') {
    2382:	/----------> movea.l 12(sp),a0
    2386:	|            move.b (a0),d0
    2388:	|            cmpi.b #47,d0
    238c:	|        /-- ble.s 23c4 <stringToInt+0x4c>
    238e:	|        |   movea.l 12(sp),a0
    2392:	|        |   move.b (a0),d0
    2394:	|        |   cmpi.b #57,d0
    2398:	|        +-- bgt.s 23c4 <stringToInt+0x4c>
			i *= 10;
    239a:	|        |   move.l 4(sp),d1
    239e:	|        |   move.l d1,d0
    23a0:	|        |   add.l d0,d0
    23a2:	|        |   add.l d0,d0
    23a4:	|        |   add.l d1,d0
    23a6:	|        |   add.l d0,d0
    23a8:	|        |   move.l d0,4(sp)
			i += *s - '0';
    23ac:	|        |   movea.l 12(sp),a0
    23b0:	|        |   move.b (a0),d0
    23b2:	|        |   ext.w d0
    23b4:	|        |   movea.w d0,a0
    23b6:	|        |   moveq #-48,d0
    23b8:	|        |   add.l a0,d0
    23ba:	|        |   add.l d0,4(sp)
			s ++;
    23be:	|        |   addq.l #1,12(sp)
    23c2:	|  /-----|-- bra.s 23fc <stringToInt+0x84>
		} else if (*s == '-') {
    23c4:	|  |     \-> movea.l 12(sp),a0
    23c8:	|  |         move.b (a0),d0
    23ca:	|  |         cmpi.b #45,d0
    23ce:	|  |     /-- bne.s 23e8 <stringToInt+0x70>
			negative = ! negative;
    23d0:	|  |     |   tst.w 2(sp)
    23d4:	|  |     |   seq d0
    23d6:	|  |     |   neg.b d0
    23d8:	|  |     |   move.b d0,d0
    23da:	|  |     |   andi.w #255,d0
    23de:	|  |     |   move.w d0,2(sp)
			s++;
    23e2:	|  |     |   addq.l #1,12(sp)
    23e6:	+--|-----|-- bra.s 2382 <stringToInt+0xa>
		} else {
			if (negative)
    23e8:	|  |     \-> tst.w 2(sp)
    23ec:	|  |     /-- beq.s 23f6 <stringToInt+0x7e>
				return -i;
    23ee:	|  |     |   move.l 4(sp),d0
    23f2:	|  |     |   neg.l d0
    23f4:	|  |  /--|-- bra.s 23fe <stringToInt+0x86>
			return i;
    23f6:	|  |  |  \-> move.l 4(sp),d0
    23fa:	|  |  +----- bra.s 23fe <stringToInt+0x86>
		if (*s >= '0' && *s <= '9') {
    23fc:	\--\--|----X bra.s 2382 <stringToInt+0xa>
		}
	}
    23fe:	      \----> addq.l #8,sp
    2400:	             rts

00002402 <fileExists>:
 *  Helper functions that don't depend on other source files.
 */
#include <proto/dos.h>
#include "helpers.h"

BYTE fileExists(const char * file) {
    2402:	    lea -28(sp),sp
    2406:	    move.l a6,-(sp)
    2408:	    move.l d2,-(sp)
	BPTR tester;
	BYTE retval = 0;
    240a:	    clr.b 35(sp)
	tester = Open(file, MODE_OLDFILE);
    240e:	    move.l 40(sp),30(sp)
    2414:	    move.l #1005,26(sp)
    241c:	    move.l 7c3a <DOSBase>,d0
    2422:	    movea.l d0,a6
    2424:	    move.l 30(sp),d1
    2428:	    move.l 26(sp),d2
    242c:	    jsr -30(a6)
    2430:	    move.l d0,22(sp)
    2434:	    move.l 22(sp),d0
    2438:	    move.l d0,18(sp)
	if (tester) {
    243c:	/-- beq.s 245e <fileExists+0x5c>
		retval = 1;
    243e:	|   move.b #1,35(sp)
		Close(tester);
    2444:	|   move.l 18(sp),14(sp)
    244a:	|   move.l 7c3a <DOSBase>,d0
    2450:	|   movea.l d0,a6
    2452:	|   move.l 14(sp),d1
    2456:	|   jsr -36(a6)
    245a:	|   move.l d0,10(sp)
	}
	return retval;
    245e:	\-> move.b 35(sp),d0
    2462:	    move.l (sp)+,d2
    2464:	    movea.l (sp)+,a6
    2466:	    lea 28(sp),sp
    246a:	    rts

0000246c <memset>:
void* memset(void *dest, int val, unsigned long len) {
    246c:	       subq.l #4,sp
	unsigned char *ptr = (unsigned char *)dest;
    246e:	       move.l 8(sp),(sp)
	while(len-- > 0)
    2472:	   /-- bra.s 2484 <memset+0x18>
		*ptr++ = val;
    2474:	/--|-> move.l (sp),d0
    2476:	|  |   move.l d0,d1
    2478:	|  |   addq.l #1,d1
    247a:	|  |   move.l d1,(sp)
    247c:	|  |   move.l 12(sp),d1
    2480:	|  |   movea.l d0,a0
    2482:	|  |   move.b d1,(a0)
	while(len-- > 0)
    2484:	|  \-> move.l 16(sp),d0
    2488:	|      move.l d0,d1
    248a:	|      subq.l #1,d1
    248c:	|      move.l d1,16(sp)
    2490:	|      tst.l d0
    2492:	\----- bne.s 2474 <memset+0x8>
	return dest;
    2494:	       move.l 8(sp),d0
}
    2498:	       addq.l #4,sp
    249a:	       rts

0000249c <KPrintF>:
void KPrintF(const char* fmt, ...) {
    249c:	       lea -128(sp),sp
    24a0:	       movem.l a2-a3/a6,-(sp)
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    24a4:	       move.w f0ff60 <gcc8_c_support.c.af0a41ba+0xefff41>,d0
    24aa:	       cmpi.w #20153,d0
    24ae:	   /-- beq.s 24d2 <KPrintF+0x36>
    24b0:	   |   cmpi.w #-24562,d0
    24b4:	   +-- beq.s 24d2 <KPrintF+0x36>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
    24b6:	   |   movea.l 7c32 <SysBase>,a6
    24bc:	   |   movea.l 144(sp),a0
    24c0:	   |   lea 148(sp),a1
    24c4:	   |   lea 2730 <KPutCharX>,a2
    24ca:	   |   suba.l a3,a3
    24cc:	   |   jsr -522(a6)
}
    24d0:	/--|-- bra.s 24fc <KPrintF+0x60>
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
    24d2:	|  \-> movea.l 7c32 <SysBase>,a6
    24d8:	|      movea.l 144(sp),a0
    24dc:	|      lea 148(sp),a1
    24e0:	|      lea 273e <PutChar>,a2
    24e6:	|      lea 12(sp),a3
    24ea:	|      jsr -522(a6)
		UaeDbgLog(86, temp);
    24ee:	|      move.l a3,-(sp)
    24f0:	|      pea 56 <_start+0x56>
    24f4:	|      jsr f0ff60 <gcc8_c_support.c.af0a41ba+0xefff41>
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    24fa:	|      addq.l #8,sp
}
    24fc:	\----> movem.l (sp)+,a2-a3/a6
    2500:	       lea 128(sp),sp
    2504:	       rts

00002506 <warpmode>:

void warpmode(int on) { // bool
    2506:	          subq.l #8,sp
	long(*UaeConf)(long mode, int index, const char* param, int param_len, char* outbuf, int outbuf_len);
	UaeConf = (long(*)(long, int, const char*, int, char*, int))0xf0ff60;
    2508:	          move.l #15794016,4(sp)
	if(*((UWORD *)UaeConf) == 0x4eb9 || *((UWORD *)UaeConf) == 0xa00e) {
    2510:	          movea.l 4(sp),a0
    2514:	          move.w (a0),d0
    2516:	          cmpi.w #20153,d0
    251a:	      /-- beq.s 252a <warpmode+0x24>
    251c:	      |   movea.l 4(sp),a0
    2520:	      |   move.w (a0),d0
    2522:	      |   cmpi.w #-24562,d0
    2526:	/-----|-- bne.w 262e <warpmode+0x128>
		char outbuf;
		UaeConf(82, -1, on ? "cpu_speed max" : "cpu_speed real", 0, &outbuf, 1);
    252a:	|     \-> tst.l 12(sp)
    252e:	|  /----- beq.s 2538 <warpmode+0x32>
    2530:	|  |      move.l #18046,d0
    2536:	|  |  /-- bra.s 253e <warpmode+0x38>
    2538:	|  \--|-> move.l #18060,d0
    253e:	|     \-> pea 1 <_start+0x1>
    2542:	|         move.l sp,d1
    2544:	|         addq.l #7,d1
    2546:	|         move.l d1,-(sp)
    2548:	|         clr.l -(sp)
    254a:	|         move.l d0,-(sp)
    254c:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeffe0>
    2550:	|         pea 52 <_start+0x52>
    2554:	|         movea.l 28(sp),a0
    2558:	|         jsr (a0)
    255a:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_cycle_exact false" : "cpu_cycle_exact true", 0, &outbuf, 1);
    255e:	|         tst.l 12(sp)
    2562:	|  /----- beq.s 256c <warpmode+0x66>
    2564:	|  |      move.l #18075,d0
    256a:	|  |  /-- bra.s 2572 <warpmode+0x6c>
    256c:	|  \--|-> move.l #18097,d0
    2572:	|     \-> pea 1 <_start+0x1>
    2576:	|         move.l sp,d1
    2578:	|         addq.l #7,d1
    257a:	|         move.l d1,-(sp)
    257c:	|         clr.l -(sp)
    257e:	|         move.l d0,-(sp)
    2580:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeffe0>
    2584:	|         pea 52 <_start+0x52>
    2588:	|         movea.l 28(sp),a0
    258c:	|         jsr (a0)
    258e:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_memory_cycle_exact false" : "cpu_memory_cycle_exact true", 0, &outbuf, 1);
    2592:	|         tst.l 12(sp)
    2596:	|  /----- beq.s 25a0 <warpmode+0x9a>
    2598:	|  |      move.l #18118,d0
    259e:	|  |  /-- bra.s 25a6 <warpmode+0xa0>
    25a0:	|  \--|-> move.l #18147,d0
    25a6:	|     \-> pea 1 <_start+0x1>
    25aa:	|         move.l sp,d1
    25ac:	|         addq.l #7,d1
    25ae:	|         move.l d1,-(sp)
    25b0:	|         clr.l -(sp)
    25b2:	|         move.l d0,-(sp)
    25b4:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeffe0>
    25b8:	|         pea 52 <_start+0x52>
    25bc:	|         movea.l 28(sp),a0
    25c0:	|         jsr (a0)
    25c2:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
    25c6:	|         tst.l 12(sp)
    25ca:	|  /----- beq.s 25d4 <warpmode+0xce>
    25cc:	|  |      move.l #18175,d0
    25d2:	|  |  /-- bra.s 25da <warpmode+0xd4>
    25d4:	|  \--|-> move.l #18201,d0
    25da:	|     \-> pea 1 <_start+0x1>
    25de:	|         move.l sp,d1
    25e0:	|         addq.l #7,d1
    25e2:	|         move.l d1,-(sp)
    25e4:	|         clr.l -(sp)
    25e6:	|         move.l d0,-(sp)
    25e8:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeffe0>
    25ec:	|         pea 52 <_start+0x52>
    25f0:	|         movea.l 28(sp),a0
    25f4:	|         jsr (a0)
    25f6:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
    25fa:	|         tst.l 12(sp)
    25fe:	|  /----- beq.s 2608 <warpmode+0x102>
    2600:	|  |      move.l #18226,d0
    2606:	|  |  /-- bra.s 260e <warpmode+0x108>
    2608:	|  \--|-> move.l #18236,d0
    260e:	|     \-> pea 1 <_start+0x1>
    2612:	|         move.l sp,d1
    2614:	|         addq.l #7,d1
    2616:	|         move.l d1,-(sp)
    2618:	|         clr.l -(sp)
    261a:	|         move.l d0,-(sp)
    261c:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xfffeffe0>
    2620:	|         pea 52 <_start+0x52>
    2624:	|         movea.l 28(sp),a0
    2628:	|         jsr (a0)
    262a:	|         lea 24(sp),sp
	}
}
    262e:	\-------> nop
    2630:	          addq.l #8,sp
    2632:	          rts

00002634 <debug_cmd>:

static void debug_cmd(unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4) {
    2634:	       subq.l #4,sp
	long(*UaeLib)(unsigned int arg0, unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4);
	UaeLib = (long(*)(unsigned int, unsigned int, unsigned int, unsigned int, unsigned int))0xf0ff60;
    2636:	       move.l #15794016,(sp)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
    263c:	       movea.l (sp),a0
    263e:	       move.w (a0),d0
    2640:	       cmpi.w #20153,d0
    2644:	   /-- beq.s 2650 <debug_cmd+0x1c>
    2646:	   |   movea.l (sp),a0
    2648:	   |   move.w (a0),d0
    264a:	   |   cmpi.w #-24562,d0
    264e:	/--|-- bne.s 266e <debug_cmd+0x3a>
		UaeLib(88, arg1, arg2, arg3, arg4);
    2650:	|  \-> move.l 20(sp),-(sp)
    2654:	|      move.l 20(sp),-(sp)
    2658:	|      move.l 20(sp),-(sp)
    265c:	|      move.l 20(sp),-(sp)
    2660:	|      pea 58 <_start+0x58>
    2664:	|      movea.l 20(sp),a0
    2668:	|      jsr (a0)
    266a:	|      lea 20(sp),sp
	}
}
    266e:	\----> nop
    2670:	       addq.l #4,sp
    2672:	       rts

00002674 <debug_start_idle>:
	debug_cmd(barto_cmd_text, (((unsigned int)left) << 16) | ((unsigned int)top), (unsigned int)text, color);
}

// profiler
void debug_start_idle() {
	debug_cmd(barto_cmd_set_idle, 1, 0, 0);
    2674:	clr.l -(sp)
    2676:	clr.l -(sp)
    2678:	pea 1 <_start+0x1>
    267c:	pea 5 <_start+0x5>
    2680:	jsr 2634 <debug_cmd>
    2686:	lea 16(sp),sp
}
    268a:	nop
    268c:	rts

0000268e <debug_stop_idle>:

void debug_stop_idle() {
	debug_cmd(barto_cmd_set_idle, 0, 0, 0);
    268e:	clr.l -(sp)
    2690:	clr.l -(sp)
    2692:	clr.l -(sp)
    2694:	pea 5 <_start+0x5>
    2698:	jsr 2634 <debug_cmd>
    269e:	lea 16(sp),sp
}
    26a2:	nop
    26a4:	rts

000026a6 <__udivsi3>:
	.section .text.__udivsi3,"ax",@progbits
	.type __udivsi3, function
	.globl	__udivsi3
__udivsi3:
	.cfi_startproc
	movel	d2, sp@-
    26a6:	       move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
    26a8:	       move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
    26ac:	       move.l 8(sp),d0

	cmpl	#0x10000, d1 /* divisor >= 2 ^ 16 ?   */
    26b0:	       cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
    26b6:	   /-- bcc.s 26ce <__udivsi3+0x28>
	movel	d0, d2
    26b8:	   |   move.l d0,d2
	clrw	d2
    26ba:	   |   clr.w d2
	swap	d2
    26bc:	   |   swap d2
	divu	d1, d2          /* high quotient in lower word */
    26be:	   |   divu.w d1,d2
	movew	d2, d0		/* save high quotient */
    26c0:	   |   move.w d2,d0
	swap	d0
    26c2:	   |   swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
    26c4:	   |   move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
    26c8:	   |   divu.w d1,d2
	movew	d2, d0
    26ca:	   |   move.w d2,d0
	jra	6f
    26cc:	/--|-- bra.s 26fe <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
    26ce:	|  \-> move.l d1,d2
4:	lsrl	#1, d1	/* shift divisor */
    26d0:	|  /-> lsr.l #1,d1
	lsrl	#1, d0	/* shift dividend */
    26d2:	|  |   lsr.l #1,d0
	cmpl	#0x10000, d1 /* still divisor >= 2 ^ 16 ?  */
    26d4:	|  |   cmpi.l #65536,d1
	jcc	4b
    26da:	|  \-- bcc.s 26d0 <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
    26dc:	|      divu.w d1,d0
	andl	#0xffff, d0 /* mask out divisor, ignore remainder */
    26de:	|      andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
    26e4:	|      move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
    26e6:	|      mulu.w d0,d1
	swap	d2
    26e8:	|      swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
    26ea:	|      mulu.w d0,d2
	swap	d2		/* align high part with low part */
    26ec:	|      swap d2
	tstw	d2		/* high part 17 bits? */
    26ee:	|      tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
    26f0:	|  /-- bne.s 26fc <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
    26f2:	|  |   add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
    26f4:	|  +-- bcs.s 26fc <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
    26f6:	|  |   cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
    26fa:	+--|-- bls.s 26fe <__udivsi3+0x58>
5:	subql	#1, d0	/* adjust quotient */
    26fc:	|  \-> subq.l #1,d0

6:	movel	sp@+, d2
    26fe:	\----> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    2700:	       rts

00002702 <__divsi3>:
	.section .text.__divsi3,"ax",@progbits
	.type __divsi3, function
	.globl	__divsi3
 __divsi3:
 	.cfi_startproc
	movel	d2, sp@-
    2702:	    move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	#1, d2	/* sign of result stored in d2 (=1 or =-1) */
    2704:	    moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
    2706:	    move.l 12(sp),d1
	jpl	1f
    270a:	/-- bpl.s 2710 <__divsi3+0xe>
	negl	d1
    270c:	|   neg.l d1
	negb	d2		/* change sign because divisor <0  */
    270e:	|   neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
    2710:	\-> move.l 8(sp),d0
	jpl	2f
    2714:	/-- bpl.s 271a <__divsi3+0x18>
	negl	d0
    2716:	|   neg.l d0
	negb	d2
    2718:	|   neg.b d2

2:	movel	d1, sp@-
    271a:	\-> move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    271c:	    move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__udivsi3	/* divide abs(dividend) by abs(divisor) */
    271e:	    jsr 26a6 <__udivsi3>
	addql	#8, sp
    2724:	    addq.l #8,sp
	.cfi_adjust_cfa_offset -8

	tstb	d2
    2726:	    tst.b d2
	jpl	3f
    2728:	/-- bpl.s 272c <__divsi3+0x2a>
	negl	d0
    272a:	|   neg.l d0

3:	movel	sp@+, d2
    272c:	\-> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    272e:	    rts

00002730 <KPutCharX>:
	.type KPutCharX, function
	.globl	KPutCharX

KPutCharX:
	.cfi_startproc
    move.l  a6, -(sp)
    2730:	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
    2732:	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
    2736:	jsr -516(a6)
    move.l (sp)+, a6
    273a:	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
    273c:	rts

0000273e <PutChar>:
	.type PutChar, function
	.globl	PutChar

PutChar:
	.cfi_startproc
	move.b d0, (a3)+
    273e:	move.b d0,(a3)+
	rts
    2740:	rts
