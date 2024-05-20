
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
       2:	       move.l #26027,d0
       8:	       subi.l #26027,d0
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
      22:	|  |   lea 65ab <__fini_array_end>,a0
      28:	|  |   movea.l (0,a1,a0.l),a0
      2c:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      2e:	|  |   addq.l #1,4(sp)
      32:	|  \-> move.l 4(sp),d0
      36:	|      cmp.l (sp),d0
      38:	\----- bcs.s 18 <_start+0x18>

	count = __init_array_end - __init_array_start;
      3a:	       move.l #26027,d0
      40:	       subi.l #26027,d0
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
      5a:	|  |   lea 65ab <__fini_array_end>,a0
      60:	|  |   movea.l (0,a1,a0.l),a0
      64:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      66:	|  |   addq.l #1,4(sp)
      6a:	|  \-> move.l 4(sp),d0
      6e:	|      cmp.l (sp),d0
      70:	\----- bcs.s 50 <_start+0x50>

	main();
      72:	       jsr 1292 <main>

	// call dtors
	count = __fini_array_end - __fini_array_start;
      78:	       move.l #26027,d0
      7e:	       subi.l #26027,d0
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
      9a:	|  |   lea 65ab <__fini_array_end>,a0
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
      b8:	             lea -260(sp),sp
      bc:	             movem.l d2-d4/a2/a6,-(sp)
	int a = 0;
      c0:	             clr.l 276(sp)
	mouseCursorAnim = makeNullAnim ();
      c4:	             jsr 1446 <makeNullAnim>
      ca:	             move.l d0,7abe <mouseCursorAnim>

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, &gameVersion);
      d0:	             pea 7a3e <gameVersion>
      d6:	             pea 2584 <PutChar+0x4>
      dc:	             pea 45 <_start+0x45>
      e0:	             pea 47 <_start+0x47>
      e4:	             move.l 300(sp),-(sp)
      e8:	             jsr 73c <openAndVerify>
      ee:	             lea 20(sp),sp
      f2:	             move.l d0,260(sp)
	if (! fp) return FALSE;
      f6:	         /-- bne.s fe <initSludge+0x46>
      f8:	         |   clr.w d0
      fa:	/--------|-- bra.w 732 <initSludge+0x67a>
	if (FGetC (fp)) {
      fe:	|        \-> move.l 260(sp),256(sp)
     104:	|            move.l 7a96 <DOSBase>,d0
     10a:	|            movea.l d0,a6
     10c:	|            move.l 256(sp),d1
     110:	|            jsr -306(a6)
     114:	|            move.l d0,252(sp)
     118:	|            move.l 252(sp),d0
     11c:	|  /-------- beq.w 2c2 <initSludge+0x20a>
		numBIFNames = get2bytes (fp);
     120:	|  |         move.l 260(sp),-(sp)
     124:	|  |         jsr 186a <get2bytes>
     12a:	|  |         addq.l #4,sp
     12c:	|  |         move.l d0,7a46 <numBIFNames>
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
     132:	|  |         move.l 7a46 <numBIFNames>,d0
     138:	|  |         move.l d0,248(sp)
     13c:	|  |         clr.l 244(sp)
     140:	|  |         move.l 7a8e <SysBase>,d0
     146:	|  |         movea.l d0,a6
     148:	|  |         move.l 248(sp),d0
     14c:	|  |         move.l 244(sp),d1
     150:	|  |         jsr -684(a6)
     154:	|  |         move.l d0,240(sp)
     158:	|  |         move.l 240(sp),d0
     15c:	|  |         move.l d0,7a4a <allBIFNames>
		if(allBIFNames == 0) return FALSE;
     162:	|  |         move.l 7a4a <allBIFNames>,d0
     168:	|  |     /-- bne.s 170 <initSludge+0xb8>
     16a:	|  |     |   clr.w d0
     16c:	+--|-----|-- bra.w 732 <initSludge+0x67a>
		for (int fn = 0; fn < numBIFNames; fn ++) {
     170:	|  |     \-> clr.l 272(sp)
     174:	|  |     /-- bra.s 19a <initSludge+0xe2>
			allBIFNames[fn] = (char *) readString (fp);
     176:	|  |  /--|-> move.l 7a4a <allBIFNames>,d1
     17c:	|  |  |  |   move.l 272(sp),d0
     180:	|  |  |  |   add.l d0,d0
     182:	|  |  |  |   add.l d0,d0
     184:	|  |  |  |   movea.l d1,a2
     186:	|  |  |  |   adda.l d0,a2
     188:	|  |  |  |   move.l 260(sp),-(sp)
     18c:	|  |  |  |   jsr 1a02 <readString>
     192:	|  |  |  |   addq.l #4,sp
     194:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numBIFNames; fn ++) {
     196:	|  |  |  |   addq.l #1,272(sp)
     19a:	|  |  |  \-> move.l 7a46 <numBIFNames>,d0
     1a0:	|  |  |      cmp.l 272(sp),d0
     1a4:	|  |  \----- bgt.s 176 <initSludge+0xbe>
		}
		numUserFunc = get2bytes (fp);
     1a6:	|  |         move.l 260(sp),-(sp)
     1aa:	|  |         jsr 186a <get2bytes>
     1b0:	|  |         addq.l #4,sp
     1b2:	|  |         move.l d0,7a4e <numUserFunc>
		allUserFunc = AllocVec(numUserFunc,MEMF_ANY);
     1b8:	|  |         move.l 7a4e <numUserFunc>,d0
     1be:	|  |         move.l d0,236(sp)
     1c2:	|  |         clr.l 232(sp)
     1c6:	|  |         move.l 7a8e <SysBase>,d0
     1cc:	|  |         movea.l d0,a6
     1ce:	|  |         move.l 236(sp),d0
     1d2:	|  |         move.l 232(sp),d1
     1d6:	|  |         jsr -684(a6)
     1da:	|  |         move.l d0,228(sp)
     1de:	|  |         move.l 228(sp),d0
     1e2:	|  |         move.l d0,7a52 <allUserFunc>
		if( allUserFunc == 0) return FALSE;
     1e8:	|  |         move.l 7a52 <allUserFunc>,d0
     1ee:	|  |     /-- bne.s 1f6 <initSludge+0x13e>
     1f0:	|  |     |   clr.w d0
     1f2:	+--|-----|-- bra.w 732 <initSludge+0x67a>

		for (int fn = 0; fn < numUserFunc; fn ++) {
     1f6:	|  |     \-> clr.l 268(sp)
     1fa:	|  |     /-- bra.s 220 <initSludge+0x168>
			allUserFunc[fn] =   (char *) readString (fp);
     1fc:	|  |  /--|-> move.l 7a52 <allUserFunc>,d1
     202:	|  |  |  |   move.l 268(sp),d0
     206:	|  |  |  |   add.l d0,d0
     208:	|  |  |  |   add.l d0,d0
     20a:	|  |  |  |   movea.l d1,a2
     20c:	|  |  |  |   adda.l d0,a2
     20e:	|  |  |  |   move.l 260(sp),-(sp)
     212:	|  |  |  |   jsr 1a02 <readString>
     218:	|  |  |  |   addq.l #4,sp
     21a:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numUserFunc; fn ++) {
     21c:	|  |  |  |   addq.l #1,268(sp)
     220:	|  |  |  \-> move.l 7a4e <numUserFunc>,d0
     226:	|  |  |      cmp.l 268(sp),d0
     22a:	|  |  \----- bgt.s 1fc <initSludge+0x144>
		}
		if (gameVersion >= VERSION(1,3)) {
     22c:	|  |         move.l 7a3e <gameVersion>,d0
     232:	|  |         cmpi.l #258,d0
     238:	|  +-------- ble.w 2c2 <initSludge+0x20a>
			numResourceNames = get2bytes (fp);
     23c:	|  |         move.l 260(sp),-(sp)
     240:	|  |         jsr 186a <get2bytes>
     246:	|  |         addq.l #4,sp
     248:	|  |         move.l d0,7a56 <numResourceNames>
			allResourceNames = AllocVec(numResourceNames,MEMF_ANY);
     24e:	|  |         move.l 7a56 <numResourceNames>,d0
     254:	|  |         move.l d0,224(sp)
     258:	|  |         clr.l 220(sp)
     25c:	|  |         move.l 7a8e <SysBase>,d0
     262:	|  |         movea.l d0,a6
     264:	|  |         move.l 224(sp),d0
     268:	|  |         move.l 220(sp),d1
     26c:	|  |         jsr -684(a6)
     270:	|  |         move.l d0,216(sp)
     274:	|  |         move.l 216(sp),d0
     278:	|  |         move.l d0,7a5a <allResourceNames>
			if(allResourceNames == 0) return FALSE;
     27e:	|  |         move.l 7a5a <allResourceNames>,d0
     284:	|  |     /-- bne.s 28c <initSludge+0x1d4>
     286:	|  |     |   clr.w d0
     288:	+--|-----|-- bra.w 732 <initSludge+0x67a>

			for (int fn = 0; fn < numResourceNames; fn ++) {
     28c:	|  |     \-> clr.l 264(sp)
     290:	|  |     /-- bra.s 2b6 <initSludge+0x1fe>
				allResourceNames[fn] =  (char *) readString (fp);
     292:	|  |  /--|-> move.l 7a5a <allResourceNames>,d1
     298:	|  |  |  |   move.l 264(sp),d0
     29c:	|  |  |  |   add.l d0,d0
     29e:	|  |  |  |   add.l d0,d0
     2a0:	|  |  |  |   movea.l d1,a2
     2a2:	|  |  |  |   adda.l d0,a2
     2a4:	|  |  |  |   move.l 260(sp),-(sp)
     2a8:	|  |  |  |   jsr 1a02 <readString>
     2ae:	|  |  |  |   addq.l #4,sp
     2b0:	|  |  |  |   move.l d0,(a2)
			for (int fn = 0; fn < numResourceNames; fn ++) {
     2b2:	|  |  |  |   addq.l #1,264(sp)
     2b6:	|  |  |  \-> move.l 7a56 <numResourceNames>,d0
     2bc:	|  |  |      cmp.l 264(sp),d0
     2c0:	|  |  \----- bgt.s 292 <initSludge+0x1da>
			}
		}
	}
	winWidth = get2bytes (fp);
     2c2:	|  \-------> move.l 260(sp),-(sp)
     2c6:	|            jsr 186a <get2bytes>
     2cc:	|            addq.l #4,sp
     2ce:	|            move.l d0,7a36 <winWidth>
	winHeight = get2bytes (fp);
     2d4:	|            move.l 260(sp),-(sp)
     2d8:	|            jsr 186a <get2bytes>
     2de:	|            addq.l #4,sp
     2e0:	|            move.l d0,7a3a <winHeight>
	specialSettings = FGetC (fp);
     2e6:	|            move.l 260(sp),212(sp)
     2ec:	|            move.l 7a96 <DOSBase>,d0
     2f2:	|            movea.l d0,a6
     2f4:	|            move.l 212(sp),d1
     2f8:	|            jsr -306(a6)
     2fc:	|            move.l d0,208(sp)
     300:	|            move.l 208(sp),d0
     304:	|            move.l d0,7a42 <specialSettings>

	desiredfps = 1000/FGetC (fp);
     30a:	|            move.l 260(sp),204(sp)
     310:	|            move.l 7a96 <DOSBase>,d0
     316:	|            movea.l d0,a6
     318:	|            move.l 204(sp),d1
     31c:	|            jsr -306(a6)
     320:	|            move.l d0,200(sp)
     324:	|            move.l 200(sp),d0
     328:	|            move.l d0,-(sp)
     32a:	|            pea 3e8 <initSludge+0x330>
     32e:	|            jsr 2544 <__divsi3>
     334:	|            addq.l #8,sp
     336:	|            move.l d0,65ac <desiredfps>

	FreeVec(readString (fp));
     33c:	|            move.l 260(sp),-(sp)
     340:	|            jsr 1a02 <readString>
     346:	|            addq.l #4,sp
     348:	|            move.l d0,196(sp)
     34c:	|            move.l 7a8e <SysBase>,d0
     352:	|            movea.l d0,a6
     354:	|            movea.l 196(sp),a1
     358:	|            jsr -690(a6)

	ULONG blocks_read = FRead( fp, &fileTime, sizeof (FILETIME), 1 ); 
     35c:	|            move.l 260(sp),192(sp)
     362:	|            move.l #31326,188(sp)
     36a:	|            moveq #8,d0
     36c:	|            move.l d0,184(sp)
     370:	|            moveq #1,d1
     372:	|            move.l d1,180(sp)
     376:	|            move.l 7a96 <DOSBase>,d0
     37c:	|            movea.l d0,a6
     37e:	|            move.l 192(sp),d1
     382:	|            move.l 188(sp),d2
     386:	|            move.l 184(sp),d3
     38a:	|            move.l 180(sp),d4
     38e:	|            jsr -324(a6)
     392:	|            move.l d0,176(sp)
     396:	|            move.l 176(sp),d0
     39a:	|            move.l d0,172(sp)
	if (blocks_read != 1) {
     39e:	|            moveq #1,d0
     3a0:	|            cmp.l 172(sp),d0
     3a4:	|        /-- beq.s 3b4 <initSludge+0x2fc>
		KPrintF("Reading error in initSludge.\n");
     3a6:	|        |   pea 25bd <PutChar+0x3d>
     3ac:	|        |   jsr 22de <KPrintF>
     3b2:	|        |   addq.l #4,sp
	}

	char * dataFol = (gameVersion >= VERSION(1,3)) ? readString(fp) : joinStrings ("", "");
     3b4:	|        \-> move.l 7a3e <gameVersion>,d0
     3ba:	|            cmpi.l #258,d0
     3c0:	|        /-- ble.s 3d0 <initSludge+0x318>
     3c2:	|        |   move.l 260(sp),-(sp)
     3c6:	|        |   jsr 1a02 <readString>
     3cc:	|        |   addq.l #4,sp
     3ce:	|     /--|-- bra.s 3e4 <initSludge+0x32c>
     3d0:	|     |  \-> pea 25db <PutChar+0x5b>
     3d6:	|     |      pea 25db <PutChar+0x5b>
     3dc:	|     |      jsr 1b98 <joinStrings>
     3e2:	|     |      addq.l #8,sp
     3e4:	|     \----> move.l d0,168(sp)

	gameSettings.numLanguages = (gameVersion >= VERSION(1,3)) ? (FGetC (fp)) : 0;
     3e8:	|            move.l 7a3e <gameVersion>,d0
     3ee:	|            cmpi.l #258,d0
     3f4:	|     /----- ble.s 416 <initSludge+0x35e>
     3f6:	|     |      move.l 260(sp),164(sp)
     3fc:	|     |      move.l 7a96 <DOSBase>,d0
     402:	|     |      movea.l d0,a6
     404:	|     |      move.l 164(sp),d1
     408:	|     |      jsr -306(a6)
     40c:	|     |      move.l d0,160(sp)
     410:	|     |      move.l 160(sp),d0
     414:	|     |  /-- bra.s 418 <initSludge+0x360>
     416:	|     \--|-> moveq #0,d0
     418:	|        \-> move.l d0,7aaa <gameSettings+0x4>
	makeLanguageTable (fp);
     41e:	|            move.l 260(sp),-(sp)
     422:	|            jsr 1d00 <makeLanguageTable>
     428:	|            addq.l #4,sp

	if (gameVersion >= VERSION(1,6))
     42a:	|            move.l 7a3e <gameVersion>,d0
     430:	|            cmpi.l #261,d0
     436:	|        /-- ble.s 484 <initSludge+0x3cc>
	{
		FGetC(fp);
     438:	|        |   move.l 260(sp),156(sp)
     43e:	|        |   move.l 7a96 <DOSBase>,d0
     444:	|        |   movea.l d0,a6
     446:	|        |   move.l 156(sp),d1
     44a:	|        |   jsr -306(a6)
     44e:	|        |   move.l d0,152(sp)
		// aaLoad
		FGetC (fp);
     452:	|        |   move.l 260(sp),148(sp)
     458:	|        |   move.l 7a96 <DOSBase>,d0
     45e:	|        |   movea.l d0,a6
     460:	|        |   move.l 148(sp),d1
     464:	|        |   jsr -306(a6)
     468:	|        |   move.l d0,144(sp)
		getFloat (fp);
     46c:	|        |   move.l 260(sp),-(sp)
     470:	|        |   jsr 1986 <getFloat>
     476:	|        |   addq.l #4,sp
		getFloat (fp);
     478:	|        |   move.l 260(sp),-(sp)
     47c:	|        |   jsr 1986 <getFloat>
     482:	|        |   addq.l #4,sp
	}

	char * checker = readString (fp);
     484:	|        \-> move.l 260(sp),-(sp)
     488:	|            jsr 1a02 <readString>
     48e:	|            addq.l #4,sp
     490:	|            move.l d0,140(sp)

	if (strcmp (checker, "okSoFar")) {
     494:	|            pea 25dc <PutChar+0x5c>
     49a:	|            move.l 144(sp),-(sp)
     49e:	|            jsr 1aaa <strcmp>
     4a4:	|            addq.l #8,sp
     4a6:	|            tst.l d0
     4a8:	|        /-- beq.s 4b0 <initSludge+0x3f8>
		return FALSE;
     4aa:	|        |   clr.w d0
     4ac:	+--------|-- bra.w 732 <initSludge+0x67a>
	}
	FreeVec( checker);
     4b0:	|        \-> move.l 140(sp),136(sp)
     4b6:	|            move.l 7a8e <SysBase>,d0
     4bc:	|            movea.l d0,a6
     4be:	|            movea.l 136(sp),a1
     4c2:	|            jsr -690(a6)
	checker = NULL;
     4c6:	|            clr.l 140(sp)

    unsigned char customIconLogo = FGetC (fp);
     4ca:	|            move.l 260(sp),132(sp)
     4d0:	|            move.l 7a96 <DOSBase>,d0
     4d6:	|            movea.l d0,a6
     4d8:	|            move.l 132(sp),d1
     4dc:	|            jsr -306(a6)
     4e0:	|            move.l d0,128(sp)
     4e4:	|            move.l 128(sp),d0
     4e8:	|            move.b d0,127(sp)

	if (customIconLogo & 1) {
     4ec:	|            moveq #0,d0
     4ee:	|            move.b 127(sp),d0
     4f2:	|            moveq #1,d1
     4f4:	|            and.l d1,d0
     4f6:	|        /-- beq.s 54e <initSludge+0x496>
		// There is an icon - read it!
		Write(Output(), (APTR)"initsludge:Game Icon not supported on this plattform.\n", 54);
     4f8:	|        |   move.l 7a96 <DOSBase>,d0
     4fe:	|        |   movea.l d0,a6
     500:	|        |   jsr -60(a6)
     504:	|        |   move.l d0,36(sp)
     508:	|        |   move.l 36(sp),d0
     50c:	|        |   move.l d0,32(sp)
     510:	|        |   move.l #9700,28(sp)
     518:	|        |   moveq #54,d0
     51a:	|        |   move.l d0,24(sp)
     51e:	|        |   move.l 7a96 <DOSBase>,d0
     524:	|        |   movea.l d0,a6
     526:	|        |   move.l 32(sp),d1
     52a:	|        |   move.l 28(sp),d2
     52e:	|        |   move.l 24(sp),d3
     532:	|        |   jsr -48(a6)
     536:	|        |   move.l d0,20(sp)
		KPrintF("initsludge: Game Icon not supported on this plattform.\n");
     53a:	|        |   pea 261b <PutChar+0x9b>
     540:	|        |   jsr 22de <KPrintF>
     546:	|        |   addq.l #4,sp
		return FALSE;
     548:	|        |   clr.w d0
     54a:	+--------|-- bra.w 732 <initSludge+0x67a>
	}

	numGlobals = get2bytes (fp);
     54e:	|        \-> move.l 260(sp),-(sp)
     552:	|            jsr 186a <get2bytes>
     558:	|            addq.l #4,sp
     55a:	|            move.l d0,7a6a <numGlobals>

	globalVars = AllocVec( sizeof(struct variable) * numGlobals,MEMF_ANY);
     560:	|            move.l 7a6a <numGlobals>,d0
     566:	|            lsl.l #3,d0
     568:	|            move.l d0,122(sp)
     56c:	|            clr.l 118(sp)
     570:	|            move.l 7a8e <SysBase>,d0
     576:	|            movea.l d0,a6
     578:	|            move.l 122(sp),d0
     57c:	|            move.l 118(sp),d1
     580:	|            jsr -684(a6)
     584:	|            move.l d0,114(sp)
     588:	|            move.l 114(sp),d0
     58c:	|            move.l d0,7a66 <globalVars>
	if(globalVars == 0) {
     592:	|            move.l 7a66 <globalVars>,d0
     598:	|        /-- bne.s 5ae <initSludge+0x4f6>
		KPrintF("initsludge: Cannot allocate memory for globalvars\n");
     59a:	|        |   pea 2653 <PutChar+0xd3>
     5a0:	|        |   jsr 22de <KPrintF>
     5a6:	|        |   addq.l #4,sp
		return FALSE;
     5a8:	|        |   clr.w d0
     5aa:	+--------|-- bra.w 732 <initSludge+0x67a>
	}		 
	for (a = 0; a < numGlobals; a ++) initVarNew (globalVars[a]);
     5ae:	|        \-> clr.l 276(sp)
     5b2:	|        /-- bra.s 5ca <initSludge+0x512>
     5b4:	|     /--|-> move.l 7a66 <globalVars>,d1
     5ba:	|     |  |   move.l 276(sp),d0
     5be:	|     |  |   lsl.l #3,d0
     5c0:	|     |  |   movea.l d1,a0
     5c2:	|     |  |   adda.l d0,a0
     5c4:	|     |  |   clr.l (a0)
     5c6:	|     |  |   addq.l #1,276(sp)
     5ca:	|     |  \-> move.l 7a6a <numGlobals>,d0
     5d0:	|     |      cmp.l 276(sp),d0
     5d4:	|     \----- bgt.s 5b4 <initSludge+0x4fc>

	setFileIndices (fp, gameSettings.numLanguages, 0);
     5d6:	|            move.l 7aaa <gameSettings+0x4>,d0
     5dc:	|            clr.l -(sp)
     5de:	|            move.l d0,-(sp)
     5e0:	|            move.l 268(sp),-(sp)
     5e4:	|            jsr f20 <setFileIndices>
     5ea:	|            lea 12(sp),sp

	char * gameNameOrig = getNumberedString(1);	
     5ee:	|            pea 1 <_start+0x1>
     5f2:	|            jsr e22 <getNumberedString>
     5f8:	|            addq.l #4,sp
     5fa:	|            move.l d0,110(sp)
	char * gameName = encodeFilename (gameNameOrig);
     5fe:	|            move.l 110(sp),-(sp)
     602:	|            jsr 14ac <encodeFilename>
     608:	|            addq.l #4,sp
     60a:	|            move.l d0,106(sp)

	FreeVec(gameNameOrig);
     60e:	|            move.l 110(sp),102(sp)
     614:	|            move.l 7a8e <SysBase>,d0
     61a:	|            movea.l d0,a6
     61c:	|            movea.l 102(sp),a1
     620:	|            jsr -690(a6)

	BPTR lock = CreateDir( gameName );
     624:	|            move.l 106(sp),98(sp)
     62a:	|            move.l 7a96 <DOSBase>,d0
     630:	|            movea.l d0,a6
     632:	|            move.l 98(sp),d1
     636:	|            jsr -120(a6)
     63a:	|            move.l d0,94(sp)
     63e:	|            move.l 94(sp),d0
     642:	|            move.l d0,90(sp)
	if(lock == 0) {
     646:	|        /-- bne.s 698 <initSludge+0x5e0>
		KPrintF("Could not create game Directory\n");
     648:	|        |   pea 2686 <PutChar+0x106>
     64e:	|        |   jsr 22de <KPrintF>
     654:	|        |   addq.l #4,sp
		Write(Output(), (APTR)"initsludge:Could not create game Directory\n", 43);
     656:	|        |   move.l 7a96 <DOSBase>,d0
     65c:	|        |   movea.l d0,a6
     65e:	|        |   jsr -60(a6)
     662:	|        |   move.l d0,86(sp)
     666:	|        |   move.l 86(sp),d0
     66a:	|        |   move.l d0,82(sp)
     66e:	|        |   move.l #9895,78(sp)
     676:	|        |   moveq #43,d1
     678:	|        |   move.l d1,74(sp)
     67c:	|        |   move.l 7a96 <DOSBase>,d0
     682:	|        |   movea.l d0,a6
     684:	|        |   move.l 82(sp),d1
     688:	|        |   move.l 78(sp),d2
     68c:	|        |   move.l 74(sp),d3
     690:	|        |   jsr -48(a6)
     694:	|        |   move.l d0,70(sp)
	}

	if (!SetCurrentDirName(gameName)) {
     698:	|        \-> move.l 106(sp),66(sp)
     69e:	|            move.l 7a96 <DOSBase>,d0
     6a4:	|            movea.l d0,a6
     6a6:	|            move.l 66(sp),d1
     6aa:	|            jsr -558(a6)
     6ae:	|            move.w d0,64(sp)
     6b2:	|            move.w 64(sp),d0
     6b6:	|        /-- bne.s 710 <initSludge+0x658>
		KPrintF("initsludge: Failed changing to directory %s\n", gameName);
     6b8:	|        |   move.l 106(sp),-(sp)
     6bc:	|        |   pea 26d3 <PutChar+0x153>
     6c2:	|        |   jsr 22de <KPrintF>
     6c8:	|        |   addq.l #8,sp
		Write(Output(), (APTR)"initsludge:Failed changing to directory\n", 40);
     6ca:	|        |   move.l 7a96 <DOSBase>,d0
     6d0:	|        |   movea.l d0,a6
     6d2:	|        |   jsr -60(a6)
     6d6:	|        |   move.l d0,56(sp)
     6da:	|        |   move.l 56(sp),d0
     6de:	|        |   move.l d0,52(sp)
     6e2:	|        |   move.l #9984,48(sp)
     6ea:	|        |   moveq #40,d0
     6ec:	|        |   move.l d0,44(sp)
     6f0:	|        |   move.l 7a96 <DOSBase>,d0
     6f6:	|        |   movea.l d0,a6
     6f8:	|        |   move.l 52(sp),d1
     6fc:	|        |   move.l 48(sp),d2
     700:	|        |   move.l 44(sp),d3
     704:	|        |   jsr -48(a6)
     708:	|        |   move.l d0,40(sp)
		return FALSE;
     70c:	|        |   clr.w d0
     70e:	+--------|-- bra.s 732 <initSludge+0x67a>
	}

	FreeVec(gameName);
     710:	|        \-> move.l 106(sp),60(sp)
     716:	|            move.l 7a8e <SysBase>,d0
     71c:	|            movea.l d0,a6
     71e:	|            movea.l 60(sp),a1
     722:	|            jsr -690(a6)

	readIniFile (filename);
     726:	|            move.l 284(sp),-(sp)
     72a:	|            jsr 1e34 <readIniFile>
     730:	|            addq.l #4,sp

}
     732:	\----------> movem.l (sp)+,d2-d4/a2/a6
     736:	             lea 260(sp),sp
     73a:	             rts

0000073c <openAndVerify>:

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion) {
     73c:	       lea -312(sp),sp
     740:	       movem.l d2-d3/a6,-(sp)
     744:	       move.l 332(sp),d1
     748:	       move.l 336(sp),d0
     74c:	       move.b d1,d1
     74e:	       move.b d1,16(sp)
     752:	       move.b d0,d0
     754:	       move.b d0,14(sp)
	BPTR fp = Open(filename,MODE_OLDFILE);
     758:	       move.l 328(sp),318(sp)
     75e:	       move.l #1005,314(sp)
     766:	       move.l 7a96 <DOSBase>,d0
     76c:	       movea.l d0,a6
     76e:	       move.l 318(sp),d1
     772:	       move.l 314(sp),d2
     776:	       jsr -30(a6)
     77a:	       move.l d0,310(sp)
     77e:	       move.l 310(sp),d0
     782:	       move.l d0,306(sp)

	if (! fp) {
     786:	   /-- bne.s 7e2 <openAndVerify+0xa6>
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
     788:	   |   move.l 7a96 <DOSBase>,d0
     78e:	   |   movea.l d0,a6
     790:	   |   jsr -60(a6)
     794:	   |   move.l d0,154(sp)
     798:	   |   move.l 154(sp),d0
     79c:	   |   move.l d0,150(sp)
     7a0:	   |   move.l #10025,146(sp)
     7a8:	   |   moveq #31,d0
     7aa:	   |   move.l d0,142(sp)
     7ae:	   |   move.l 7a96 <DOSBase>,d0
     7b4:	   |   movea.l d0,a6
     7b6:	   |   move.l 150(sp),d1
     7ba:	   |   move.l 146(sp),d2
     7be:	   |   move.l 142(sp),d3
     7c2:	   |   jsr -48(a6)
     7c6:	   |   move.l d0,138(sp)
		KPrintF("openAndVerify: Can't open file", filename);
     7ca:	   |   move.l 328(sp),-(sp)
     7ce:	   |   pea 2749 <PutChar+0x1c9>
     7d4:	   |   jsr 22de <KPrintF>
     7da:	   |   addq.l #8,sp
		return NULL;
     7dc:	   |   moveq #0,d0
     7de:	/--|-- bra.w aa2 <openAndVerify+0x366>
	}
	BOOL headerBad = FALSE;
     7e2:	|  \-> clr.w 322(sp)
	if (FGetC (fp) != 'S') headerBad = TRUE;
     7e6:	|      move.l 306(sp),302(sp)
     7ec:	|      move.l 7a96 <DOSBase>,d0
     7f2:	|      movea.l d0,a6
     7f4:	|      move.l 302(sp),d1
     7f8:	|      jsr -306(a6)
     7fc:	|      move.l d0,298(sp)
     800:	|      move.l 298(sp),d0
     804:	|      moveq #83,d1
     806:	|      cmp.l d0,d1
     808:	|  /-- beq.s 810 <openAndVerify+0xd4>
     80a:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'L') headerBad = TRUE;
     810:	|  \-> move.l 306(sp),294(sp)
     816:	|      move.l 7a96 <DOSBase>,d0
     81c:	|      movea.l d0,a6
     81e:	|      move.l 294(sp),d1
     822:	|      jsr -306(a6)
     826:	|      move.l d0,290(sp)
     82a:	|      move.l 290(sp),d0
     82e:	|      moveq #76,d1
     830:	|      cmp.l d0,d1
     832:	|  /-- beq.s 83a <openAndVerify+0xfe>
     834:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'U') headerBad = TRUE;
     83a:	|  \-> move.l 306(sp),286(sp)
     840:	|      move.l 7a96 <DOSBase>,d0
     846:	|      movea.l d0,a6
     848:	|      move.l 286(sp),d1
     84c:	|      jsr -306(a6)
     850:	|      move.l d0,282(sp)
     854:	|      move.l 282(sp),d0
     858:	|      moveq #85,d1
     85a:	|      cmp.l d0,d1
     85c:	|  /-- beq.s 864 <openAndVerify+0x128>
     85e:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'D') headerBad = TRUE;
     864:	|  \-> move.l 306(sp),278(sp)
     86a:	|      move.l 7a96 <DOSBase>,d0
     870:	|      movea.l d0,a6
     872:	|      move.l 278(sp),d1
     876:	|      jsr -306(a6)
     87a:	|      move.l d0,274(sp)
     87e:	|      move.l 274(sp),d0
     882:	|      moveq #68,d1
     884:	|      cmp.l d0,d1
     886:	|  /-- beq.s 88e <openAndVerify+0x152>
     888:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra1) headerBad = TRUE;
     88e:	|  \-> move.l 306(sp),270(sp)
     894:	|      move.l 7a96 <DOSBase>,d0
     89a:	|      movea.l d0,a6
     89c:	|      move.l 270(sp),d1
     8a0:	|      jsr -306(a6)
     8a4:	|      move.l d0,266(sp)
     8a8:	|      move.l 266(sp),d1
     8ac:	|      move.b 16(sp),d0
     8b0:	|      ext.w d0
     8b2:	|      movea.w d0,a0
     8b4:	|      cmpa.l d1,a0
     8b6:	|  /-- beq.s 8be <openAndVerify+0x182>
     8b8:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra2) headerBad = TRUE;
     8be:	|  \-> move.l 306(sp),262(sp)
     8c4:	|      move.l 7a96 <DOSBase>,d0
     8ca:	|      movea.l d0,a6
     8cc:	|      move.l 262(sp),d1
     8d0:	|      jsr -306(a6)
     8d4:	|      move.l d0,258(sp)
     8d8:	|      move.l 258(sp),d1
     8dc:	|      move.b 14(sp),d0
     8e0:	|      ext.w d0
     8e2:	|      movea.w d0,a0
     8e4:	|      cmpa.l d1,a0
     8e6:	|  /-- beq.s 8ee <openAndVerify+0x1b2>
     8e8:	|  |   move.w #1,322(sp)
	if (headerBad) {
     8ee:	|  \-> tst.w 322(sp)
     8f2:	|  /-- beq.s 94a <openAndVerify+0x20e>
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
     8f4:	|  |   move.l 7a96 <DOSBase>,d0
     8fa:	|  |   movea.l d0,a6
     8fc:	|  |   jsr -60(a6)
     900:	|  |   move.l d0,174(sp)
     904:	|  |   move.l 174(sp),d0
     908:	|  |   move.l d0,170(sp)
     90c:	|  |   move.l #10088,166(sp)
     914:	|  |   moveq #31,d0
     916:	|  |   move.l d0,162(sp)
     91a:	|  |   move.l 7a96 <DOSBase>,d0
     920:	|  |   movea.l d0,a6
     922:	|  |   move.l 170(sp),d1
     926:	|  |   move.l 166(sp),d2
     92a:	|  |   move.l 162(sp),d3
     92e:	|  |   jsr -48(a6)
     932:	|  |   move.l d0,158(sp)
		KPrintF("openAndVerify: Bad Header\n");
     936:	|  |   pea 2768 <PutChar+0x1e8>
     93c:	|  |   jsr 22de <KPrintF>
     942:	|  |   addq.l #4,sp
		return NULL;
     944:	|  |   moveq #0,d0
     946:	+--|-- bra.w aa2 <openAndVerify+0x366>
	}
	FGetC (fp);
     94a:	|  \-> move.l 306(sp),254(sp)
     950:	|      move.l 7a96 <DOSBase>,d0
     956:	|      movea.l d0,a6
     958:	|      move.l 254(sp),d1
     95c:	|      jsr -306(a6)
     960:	|      move.l d0,250(sp)
	while (FGetC(fp)) {;}
     964:	|      nop
     966:	|  /-> move.l 306(sp),246(sp)
     96c:	|  |   move.l 7a96 <DOSBase>,d0
     972:	|  |   movea.l d0,a6
     974:	|  |   move.l 246(sp),d1
     978:	|  |   jsr -306(a6)
     97c:	|  |   move.l d0,242(sp)
     980:	|  |   move.l 242(sp),d0
     984:	|  \-- bne.s 966 <openAndVerify+0x22a>

	int majVersion = FGetC (fp);
     986:	|      move.l 306(sp),238(sp)
     98c:	|      move.l 7a96 <DOSBase>,d0
     992:	|      movea.l d0,a6
     994:	|      move.l 238(sp),d1
     998:	|      jsr -306(a6)
     99c:	|      move.l d0,234(sp)
     9a0:	|      move.l 234(sp),d0
     9a4:	|      move.l d0,230(sp)
	int minVersion = FGetC (fp);
     9a8:	|      move.l 306(sp),226(sp)
     9ae:	|      move.l 7a96 <DOSBase>,d0
     9b4:	|      movea.l d0,a6
     9b6:	|      move.l 226(sp),d1
     9ba:	|      jsr -306(a6)
     9be:	|      move.l d0,222(sp)
     9c2:	|      move.l 222(sp),d0
     9c6:	|      move.l d0,218(sp)
	*fileVersion = majVersion * 256 + minVersion;
     9ca:	|      move.l 230(sp),d0
     9ce:	|      lsl.l #8,d0
     9d0:	|      add.l 218(sp),d0
     9d4:	|      movea.l 344(sp),a0
     9d8:	|      move.l d0,(a0)

	char txtVer[120];

	if (*fileVersion > WHOLE_VERSION) {
     9da:	|      movea.l 344(sp),a0
     9de:	|      move.l (a0),d0
     9e0:	|      cmpi.l #514,d0
     9e6:	|  /-- ble.s a3c <openAndVerify+0x300>
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
     9e8:	|  |   move.l 7a96 <DOSBase>,d0
     9ee:	|  |   movea.l d0,a6
     9f0:	|  |   jsr -60(a6)
     9f4:	|  |   move.l d0,194(sp)
     9f8:	|  |   move.l 194(sp),d0
     9fc:	|  |   move.l d0,190(sp)
     a00:	|  |   move.l #10115,186(sp)
     a08:	|  |   moveq #100,d1
     a0a:	|  |   move.l d1,182(sp)
     a0e:	|  |   move.l 7a96 <DOSBase>,d0
     a14:	|  |   movea.l d0,a6
     a16:	|  |   move.l 190(sp),d1
     a1a:	|  |   move.l 186(sp),d2
     a1e:	|  |   move.l 182(sp),d3
     a22:	|  |   jsr -48(a6)
     a26:	|  |   move.l d0,178(sp)
		KPrintF(ERROR_VERSION_TOO_LOW_1);
     a2a:	|  |   pea 2783 <PutChar+0x203>
     a30:	|  |   jsr 22de <KPrintF>
     a36:	|  |   addq.l #4,sp
		return NULL;
     a38:	|  |   moveq #0,d0
     a3a:	+--|-- bra.s aa2 <openAndVerify+0x366>
	} else if (*fileVersion < MINIM_VERSION) {
     a3c:	|  \-> movea.l 344(sp),a0
     a40:	|      move.l (a0),d0
     a42:	|      cmpi.l #257,d0
     a48:	|  /-- bgt.s a9e <openAndVerify+0x362>
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
     a4a:	|  |   move.l 7a96 <DOSBase>,d0
     a50:	|  |   movea.l d0,a6
     a52:	|  |   jsr -60(a6)
     a56:	|  |   move.l d0,214(sp)
     a5a:	|  |   move.l 214(sp),d0
     a5e:	|  |   move.l d0,210(sp)
     a62:	|  |   move.l #10184,206(sp)
     a6a:	|  |   moveq #100,d0
     a6c:	|  |   move.l d0,202(sp)
     a70:	|  |   move.l 7a96 <DOSBase>,d0
     a76:	|  |   movea.l d0,a6
     a78:	|  |   move.l 210(sp),d1
     a7c:	|  |   move.l 206(sp),d2
     a80:	|  |   move.l 202(sp),d3
     a84:	|  |   jsr -48(a6)
     a88:	|  |   move.l d0,198(sp)
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
     a8c:	|  |   pea 27c8 <PutChar+0x248>
     a92:	|  |   jsr 22de <KPrintF>
     a98:	|  |   addq.l #4,sp
		return NULL;
     a9a:	|  |   moveq #0,d0
     a9c:	+--|-- bra.s aa2 <openAndVerify+0x366>
	}
	return fp;
     a9e:	|  \-> move.l 306(sp),d0
     aa2:	\----> movem.l (sp)+,d2-d3/a6
     aa6:	       lea 312(sp),sp
     aaa:	       rts

00000aac <main_sludge>:
char * gameName = NULL;
char * gamePath = NULL;
char *bundleFolder;

int main_sludge(int argc, char *argv[])
{	
     aac:	          lea -40(sp),sp
     ab0:	          movem.l d2-d3/a6,-(sp)
	/* Dimensions of our window. */
	//AMIGA TODO: Maybe remove as there will be no windowed mode
    winWidth = 320;
     ab4:	          move.l #320,7a36 <winWidth>
    winHeight = 256;
     abe:	          move.l #256,7a3a <winHeight>

	char * sludgeFile;

	if(argc == 0) {
     ac8:	          tst.l 56(sp)
     acc:	      /-- bne.s ae4 <main_sludge+0x38>
		bundleFolder = copyString("game/");
     ace:	      |   pea 280f <PutChar+0x28f>
     ad4:	      |   jsr 1b2a <copyString>
     ada:	      |   addq.l #4,sp
     adc:	      |   move.l d0,7a72 <bundleFolder>
     ae2:	   /--|-- bra.s afa <main_sludge+0x4e>
	} else {
		bundleFolder = copyString(argv[0]);
     ae4:	   |  \-> movea.l 60(sp),a0
     ae8:	   |      move.l (a0),d0
     aea:	   |      move.l d0,-(sp)
     aec:	   |      jsr 1b2a <copyString>
     af2:	   |      addq.l #4,sp
     af4:	   |      move.l d0,7a72 <bundleFolder>
	}
    
	int lastSlash = -1;
     afa:	   \----> moveq #-1,d0
     afc:	          move.l d0,44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
     b00:	          clr.l 40(sp)
     b04:	   /----- bra.s b26 <main_sludge+0x7a>
		if (bundleFolder[i] == PATHSLASH) lastSlash = i;
     b06:	/--|----> move.l 7a72 <bundleFolder>,d1
     b0c:	|  |      move.l 40(sp),d0
     b10:	|  |      movea.l d1,a0
     b12:	|  |      adda.l d0,a0
     b14:	|  |      move.b (a0),d0
     b16:	|  |      cmpi.b #47,d0
     b1a:	|  |  /-- bne.s b22 <main_sludge+0x76>
     b1c:	|  |  |   move.l 40(sp),44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
     b22:	|  |  \-> addq.l #1,40(sp)
     b26:	|  \----> move.l 7a72 <bundleFolder>,d1
     b2c:	|         move.l 40(sp),d0
     b30:	|         movea.l d1,a0
     b32:	|         adda.l d0,a0
     b34:	|         move.b (a0),d0
     b36:	\-------- bne.s b06 <main_sludge+0x5a>
	}
	bundleFolder[lastSlash+1] = NULL;
     b38:	          move.l 7a72 <bundleFolder>,d0
     b3e:	          move.l 44(sp),d1
     b42:	          addq.l #1,d1
     b44:	          movea.l d0,a0
     b46:	          adda.l d1,a0
     b48:	          clr.b (a0)

	if (argc > 1) {
     b4a:	          moveq #1,d0
     b4c:	          cmp.l 56(sp),d0
     b50:	      /-- bge.s b6c <main_sludge+0xc0>
		sludgeFile = argv[argc - 1];
     b52:	      |   move.l 56(sp),d0
     b56:	      |   addi.l #1073741823,d0
     b5c:	      |   add.l d0,d0
     b5e:	      |   add.l d0,d0
     b60:	      |   movea.l 60(sp),a0
     b64:	      |   adda.l d0,a0
     b66:	      |   move.l (a0),48(sp)
     b6a:	   /--|-- bra.s bc6 <main_sludge+0x11a>
	} else {
		sludgeFile = joinStrings (bundleFolder, "gamedata.slg");
     b6c:	   |  \-> move.l 7a72 <bundleFolder>,d0
     b72:	   |      pea 2815 <PutChar+0x295>
     b78:	   |      move.l d0,-(sp)
     b7a:	   |      jsr 1b98 <joinStrings>
     b80:	   |      addq.l #8,sp
     b82:	   |      move.l d0,48(sp)
		if (! ( fileExists (sludgeFile) ) ) {
     b86:	   |      move.l 48(sp),-(sp)
     b8a:	   |      jsr 2244 <fileExists>
     b90:	   |      addq.l #4,sp
     b92:	   |      tst.b d0
     b94:	   +----- bne.s bc6 <main_sludge+0x11a>
			FreeVec(sludgeFile);
     b96:	   |      move.l 48(sp),36(sp)
     b9c:	   |      move.l 7a8e <SysBase>,d0
     ba2:	   |      movea.l d0,a6
     ba4:	   |      movea.l 36(sp),a1
     ba8:	   |      jsr -690(a6)
			sludgeFile = joinStrings (bundleFolder, "gamedata");			
     bac:	   |      move.l 7a72 <bundleFolder>,d0
     bb2:	   |      pea 2822 <PutChar+0x2a2>
     bb8:	   |      move.l d0,-(sp)
     bba:	   |      jsr 1b98 <joinStrings>
     bc0:	   |      addq.l #8,sp
     bc2:	   |      move.l d0,48(sp)
	//AMIGA TODO: Show arguments
	/*if (! parseCmdlineParameters(argc, argv) && !(sludgeFile) ) {
		printCmdlineUsage();
		return 0;
	}*/
	if (! fileExists(sludgeFile) ) {	
     bc6:	   \----> move.l 48(sp),-(sp)
     bca:	          jsr 2244 <fileExists>
     bd0:	          addq.l #4,sp
     bd2:	          tst.b d0
     bd4:	      /-- bne.s c1c <main_sludge+0x170>
		Write(Output(), (APTR)"Game file not found.\n", 21);
     bd6:	      |   move.l 7a96 <DOSBase>,d0
     bdc:	      |   movea.l d0,a6
     bde:	      |   jsr -60(a6)
     be2:	      |   move.l d0,28(sp)
     be6:	      |   move.l 28(sp),d0
     bea:	      |   move.l d0,24(sp)
     bee:	      |   move.l #10283,20(sp)
     bf6:	      |   moveq #21,d0
     bf8:	      |   move.l d0,16(sp)
     bfc:	      |   move.l 7a96 <DOSBase>,d0
     c02:	      |   movea.l d0,a6
     c04:	      |   move.l 24(sp),d1
     c08:	      |   move.l 20(sp),d2
     c0c:	      |   move.l 16(sp),d3
     c10:	      |   jsr -48(a6)
     c14:	      |   move.l d0,12(sp)
		//AMIGA TODO: Show arguments
		//printCmdlineUsage();
		return 0;
     c18:	      |   moveq #0,d0
     c1a:	   /--|-- bra.s c52 <main_sludge+0x1a6>
	}

	setGameFilePath (sludgeFile);
     c1c:	   |  \-> move.l 48(sp),-(sp)
     c20:	   |      jsr c5c <setGameFilePath>
     c26:	   |      addq.l #4,sp
	if (! initSludge (sludgeFile)) return 0;
     c28:	   |      move.l 48(sp),-(sp)
     c2c:	   |      jsr b8 <initSludge>
     c32:	   |      addq.l #4,sp
     c34:	   |      tst.w d0
     c36:	   |  /-- bne.s c3c <main_sludge+0x190>
     c38:	   |  |   moveq #0,d0
     c3a:	   +--|-- bra.s c52 <main_sludge+0x1a6>
	
	//Amiga Cleanup
	FreeVec(sludgeFile);
     c3c:	   |  \-> move.l 48(sp),32(sp)
     c42:	   |      move.l 7a8e <SysBase>,d0
     c48:	   |      movea.l d0,a6
     c4a:	   |      movea.l 32(sp),a1
     c4e:	   |      jsr -690(a6)
}
     c52:	   \----> movem.l (sp)+,d2-d3/a6
     c56:	          lea 40(sp),sp
     c5a:	          rts

00000c5c <setGameFilePath>:

void setGameFilePath (char * f) {
     c5c:	          lea -1056(sp),sp
     c60:	          move.l a6,-(sp)
     c62:	          move.l d2,-(sp)
	char currentDir[1000];

	if (!GetCurrentDirName( currentDir, 998)) {
     c64:	          move.l #1064,d0
     c6a:	          add.l sp,d0
     c6c:	          addi.l #-1056,d0
     c72:	          move.l d0,1052(sp)
     c76:	          move.l #998,1048(sp)
     c7e:	          move.l 7a96 <DOSBase>,d0
     c84:	          movea.l d0,a6
     c86:	          move.l 1052(sp),d1
     c8a:	          move.l 1048(sp),d2
     c8e:	          jsr -564(a6)
     c92:	          move.w d0,1046(sp)
     c96:	          move.w 1046(sp),d0
     c9a:	      /-- bne.s caa <setGameFilePath+0x4e>
		KPrintF("setGameFilePath: Can't get current directory.\n");
     c9c:	      |   pea 2841 <PutChar+0x2c1>
     ca2:	      |   jsr 22de <KPrintF>
     ca8:	      |   addq.l #4,sp
	}	

	int got = -1, a;	
     caa:	      \-> moveq #-1,d0
     cac:	          move.l d0,1060(sp)

	for (a = 0; f[a]; a ++) {
     cb0:	          clr.l 1056(sp)
     cb4:	   /----- bra.s cd2 <setGameFilePath+0x76>
		if (f[a] == PATHSLASH) got = a;
     cb6:	/--|----> move.l 1056(sp),d0
     cba:	|  |      movea.l 1068(sp),a0
     cbe:	|  |      adda.l d0,a0
     cc0:	|  |      move.b (a0),d0
     cc2:	|  |      cmpi.b #47,d0
     cc6:	|  |  /-- bne.s cce <setGameFilePath+0x72>
     cc8:	|  |  |   move.l 1056(sp),1060(sp)
	for (a = 0; f[a]; a ++) {
     cce:	|  |  \-> addq.l #1,1056(sp)
     cd2:	|  \----> move.l 1056(sp),d0
     cd6:	|         movea.l 1068(sp),a0
     cda:	|         adda.l d0,a0
     cdc:	|         move.b (a0),d0
     cde:	\-------- bne.s cb6 <setGameFilePath+0x5a>
	}

	if (got != -1) {
     ce0:	          moveq #-1,d0
     ce2:	          cmp.l 1060(sp),d0
     ce6:	   /----- beq.s d34 <setGameFilePath+0xd8>
		f[got] = 0;		
     ce8:	   |      move.l 1060(sp),d0
     cec:	   |      movea.l 1068(sp),a0
     cf0:	   |      adda.l d0,a0
     cf2:	   |      clr.b (a0)
		if (!SetCurrentDirName(f)) {
     cf4:	   |      move.l 1068(sp),1042(sp)
     cfa:	   |      move.l 7a96 <DOSBase>,d0
     d00:	   |      movea.l d0,a6
     d02:	   |      move.l 1042(sp),d1
     d06:	   |      jsr -558(a6)
     d0a:	   |      move.w d0,1040(sp)
     d0e:	   |      move.w 1040(sp),d0
     d12:	   |  /-- bne.s d26 <setGameFilePath+0xca>
			KPrintF("setGameFilePath:: Failed changing to directory %s\n", f);
     d14:	   |  |   move.l 1068(sp),-(sp)
     d18:	   |  |   pea 2870 <PutChar+0x2f0>
     d1e:	   |  |   jsr 22de <KPrintF>
     d24:	   |  |   addq.l #8,sp
		}
		f[got] = PATHSLASH;
     d26:	   |  \-> move.l 1060(sp),d0
     d2a:	   |      movea.l 1068(sp),a0
     d2e:	   |      adda.l d0,a0
     d30:	   |      move.b #47,(a0)
	}

	gamePath = AllocVec(400, MEMF_ANY);
     d34:	   \----> move.l #400,1036(sp)
     d3c:	          clr.l 1032(sp)
     d40:	          move.l 7a8e <SysBase>,d0
     d46:	          movea.l d0,a6
     d48:	          move.l 1036(sp),d0
     d4c:	          move.l 1032(sp),d1
     d50:	          jsr -684(a6)
     d54:	          move.l d0,1028(sp)
     d58:	          move.l 1028(sp),d0
     d5c:	          move.l d0,7a6e <gamePath>
	if (gamePath==0) {
     d62:	          move.l 7a6e <gamePath>,d0
     d68:	      /-- bne.s d7c <setGameFilePath+0x120>
		KPrintF("setGameFilePath: Can't reserve memory for game directory.\n");
     d6a:	      |   pea 28a3 <PutChar+0x323>
     d70:	      |   jsr 22de <KPrintF>
     d76:	      |   addq.l #4,sp
     d78:	   /--|-- bra.w e18 <setGameFilePath+0x1bc>
		return;
	}

	if (! GetCurrentDirName (gamePath, 398)) {
     d7c:	   |  \-> move.l 7a6e <gamePath>,1024(sp)
     d84:	   |      move.l #398,1020(sp)
     d8c:	   |      move.l 7a96 <DOSBase>,d0
     d92:	   |      movea.l d0,a6
     d94:	   |      move.l 1024(sp),d1
     d98:	   |      move.l 1020(sp),d2
     d9c:	   |      jsr -564(a6)
     da0:	   |      move.w d0,1018(sp)
     da4:	   |      move.w 1018(sp),d0
     da8:	   |  /-- bne.s db8 <setGameFilePath+0x15c>
		KPrintF("setGameFilePath: Can't get game directory.\n");
     daa:	   |  |   pea 28de <PutChar+0x35e>
     db0:	   |  |   jsr 22de <KPrintF>
     db6:	   |  |   addq.l #4,sp
	}

	if (!SetCurrentDirName(currentDir)) {	
     db8:	   |  \-> move.l #1064,d0
     dbe:	   |      add.l sp,d0
     dc0:	   |      addi.l #-1056,d0
     dc6:	   |      move.l d0,1014(sp)
     dca:	   |      move.l 7a96 <DOSBase>,d0
     dd0:	   |      movea.l d0,a6
     dd2:	   |      move.l 1014(sp),d1
     dd6:	   |      jsr -558(a6)
     dda:	   |      move.w d0,1012(sp)
     dde:	   |      move.w 1012(sp),d0
     de2:	   |  /-- bne.s df8 <setGameFilePath+0x19c>
		KPrintF("setGameFilePath: Failed changing to directory %s\n", currentDir);
     de4:	   |  |   move.l sp,d0
     de6:	   |  |   addq.l #8,d0
     de8:	   |  |   move.l d0,-(sp)
     dea:	   |  |   pea 290a <PutChar+0x38a>
     df0:	   |  |   jsr 22de <KPrintF>
     df6:	   |  |   addq.l #8,sp
	}

	//Free Mem
	if (gamePath != 0) FreeVec(gamePath);
     df8:	   |  \-> move.l 7a6e <gamePath>,d0
     dfe:	   +----- beq.s e18 <setGameFilePath+0x1bc>
     e00:	   |      move.l 7a6e <gamePath>,1008(sp)
     e08:	   |      move.l 7a8e <SysBase>,d0
     e0e:	   |      movea.l d0,a6
     e10:	   |      movea.l 1008(sp),a1
     e14:	   |      jsr -690(a6)
}
     e18:	   \----> move.l (sp)+,d2
     e1a:	          movea.l (sp)+,a6
     e1c:	          lea 1056(sp),sp
     e20:	          rts

00000e22 <getNumberedString>:
// This is needed for old games.
char * convertString(char * s) {
	return NULL;
}

char * getNumberedString (int value) {
     e22:	       lea -56(sp),sp
     e26:	       movem.l d2-d3/a6,-(sp)

	if (sliceBusy) {
     e2a:	       move.w 65b0 <sliceBusy>,d0
     e30:	   /-- beq.s e7a <getNumberedString+0x58>
		Write(Output(), (APTR)"getNumberedString: Can't read from data file. I'm already reading something\n", 76);        
     e32:	   |   move.l 7a96 <DOSBase>,d0
     e38:	   |   movea.l d0,a6
     e3a:	   |   jsr -60(a6)
     e3e:	   |   move.l d0,28(sp)
     e42:	   |   move.l 28(sp),d0
     e46:	   |   move.l d0,24(sp)
     e4a:	   |   move.l #10556,20(sp)
     e52:	   |   moveq #76,d0
     e54:	   |   move.l d0,16(sp)
     e58:	   |   move.l 7a96 <DOSBase>,d0
     e5e:	   |   movea.l d0,a6
     e60:	   |   move.l 24(sp),d1
     e64:	   |   move.l 20(sp),d2
     e68:	   |   move.l 16(sp),d3
     e6c:	   |   jsr -48(a6)
     e70:	   |   move.l d0,12(sp)
		return NULL;
     e74:	   |   moveq #0,d0
     e76:	/--|-- bra.w f16 <getNumberedString+0xf4>
	}

	Seek(bigDataFile, (value << 2) + startOfTextIndex, OFFSET_BEGINNING);
     e7a:	|  \-> move.l 7a76 <bigDataFile>,64(sp)
     e82:	|      move.l 72(sp),d0
     e86:	|      add.l d0,d0
     e88:	|      add.l d0,d0
     e8a:	|      move.l d0,d1
     e8c:	|      move.l 7a82 <startOfTextIndex>,d0
     e92:	|      add.l d1,d0
     e94:	|      move.l d0,60(sp)
     e98:	|      moveq #-1,d0
     e9a:	|      move.l d0,56(sp)
     e9e:	|      move.l 7a96 <DOSBase>,d0
     ea4:	|      movea.l d0,a6
     ea6:	|      move.l 64(sp),d1
     eaa:	|      move.l 60(sp),d2
     eae:	|      move.l 56(sp),d3
     eb2:	|      jsr -66(a6)
     eb6:	|      move.l d0,52(sp)
	value = get4bytes (bigDataFile);
     eba:	|      move.l 7a76 <bigDataFile>,d0
     ec0:	|      move.l d0,-(sp)
     ec2:	|      jsr 18c6 <get4bytes>
     ec8:	|      addq.l #4,sp
     eca:	|      move.l d0,72(sp)
	Seek (bigDataFile, value, OFFSET_BEGINING);
     ece:	|      move.l 7a76 <bigDataFile>,48(sp)
     ed6:	|      move.l 72(sp),44(sp)
     edc:	|      moveq #-1,d0
     ede:	|      move.l d0,40(sp)
     ee2:	|      move.l 7a96 <DOSBase>,d0
     ee8:	|      movea.l d0,a6
     eea:	|      move.l 48(sp),d1
     eee:	|      move.l 44(sp),d2
     ef2:	|      move.l 40(sp),d3
     ef6:	|      jsr -66(a6)
     efa:	|      move.l d0,36(sp)

	char * s = readString (bigDataFile);    
     efe:	|      move.l 7a76 <bigDataFile>,d0
     f04:	|      move.l d0,-(sp)
     f06:	|      jsr 1a02 <readString>
     f0c:	|      addq.l #4,sp
     f0e:	|      move.l d0,32(sp)
	
	return s;
     f12:	|      move.l 32(sp),d0
}
     f16:	\----> movem.l (sp)+,d2-d3/a6
     f1a:	       lea 56(sp),sp
     f1e:	       rts

00000f20 <setFileIndices>:

void setFileIndices (BPTR fp, unsigned int numLanguages, unsigned int skipBefore) {
     f20:	       lea -180(sp),sp
     f24:	       movem.l d2-d3/a6,-(sp)
	if (fp) {
     f28:	       tst.l 196(sp)
     f2c:	/----- beq.s f6c <setFileIndices+0x4c>
		// Keep hold of the file handle, and let things get at it
		bigDataFile = fp;
     f2e:	|      move.l 196(sp),7a76 <bigDataFile>
		startIndex = Seek( fp, 0, OFFSET_CURRENT);
     f36:	|      move.l 196(sp),168(sp)
     f3c:	|      clr.l 164(sp)
     f40:	|      clr.l 160(sp)
     f44:	|      move.l 7a96 <DOSBase>,d0
     f4a:	|      movea.l d0,a6
     f4c:	|      move.l 168(sp),d1
     f50:	|      move.l 164(sp),d2
     f54:	|      move.l 160(sp),d3
     f58:	|      jsr -66(a6)
     f5c:	|      move.l d0,156(sp)
     f60:	|      move.l 156(sp),d0
     f64:	|      move.l d0,7a7a <startIndex>
     f6a:	|  /-- bra.s fa6 <setFileIndices+0x86>
	} else {
		// No file pointer - this means that we reuse the bigDataFile
		fp = bigDataFile;
     f6c:	\--|-> move.l 7a76 <bigDataFile>,196(sp)
        Seek(fp, startIndex, OFFSET_BEGINNING);
     f74:	   |   move.l 196(sp),184(sp)
     f7a:	   |   move.l 7a7a <startIndex>,d0
     f80:	   |   move.l d0,180(sp)
     f84:	   |   moveq #-1,d0
     f86:	   |   move.l d0,176(sp)
     f8a:	   |   move.l 7a96 <DOSBase>,d0
     f90:	   |   movea.l d0,a6
     f92:	   |   move.l 184(sp),d1
     f96:	   |   move.l 180(sp),d2
     f9a:	   |   move.l 176(sp),d3
     f9e:	   |   jsr -66(a6)
     fa2:	   |   move.l d0,172(sp)
	}
	sliceBusy = FALSE;
     fa6:	   \-> clr.w 65b0 <sliceBusy>

	if (skipBefore > numLanguages) {
     fac:	       move.l 204(sp),d0
     fb0:	       cmp.l 200(sp),d0
     fb4:	   /-- bls.s fc8 <setFileIndices+0xa8>
		KPrintF("setFileIndices: Warning: Not a valid language ID! Using default instead.");
     fb6:	   |   pea 2989 <PutChar+0x409>
     fbc:	   |   jsr 22de <KPrintF>
     fc2:	   |   addq.l #4,sp
		skipBefore = 0;
     fc4:	   |   clr.l 204(sp)
	}

	// STRINGS
	int skipAfter = numLanguages - skipBefore;
     fc8:	   \-> move.l 200(sp),d0
     fcc:	       sub.l 204(sp),d0
     fd0:	       move.l d0,188(sp)
	while (skipBefore) {
     fd4:	   /-- bra.s 1010 <setFileIndices+0xf0>
        Seek(fp, get4bytes(fp),0);		
     fd6:	/--|-> move.l 196(sp),24(sp)
     fdc:	|  |   move.l 196(sp),-(sp)
     fe0:	|  |   jsr 18c6 <get4bytes>
     fe6:	|  |   addq.l #4,sp
     fe8:	|  |   move.l d0,20(sp)
     fec:	|  |   clr.l 16(sp)
     ff0:	|  |   move.l 7a96 <DOSBase>,d0
     ff6:	|  |   movea.l d0,a6
     ff8:	|  |   move.l 24(sp),d1
     ffc:	|  |   move.l 20(sp),d2
    1000:	|  |   move.l 16(sp),d3
    1004:	|  |   jsr -66(a6)
    1008:	|  |   move.l d0,12(sp)
		skipBefore --;
    100c:	|  |   subq.l #1,204(sp)
	while (skipBefore) {
    1010:	|  \-> tst.l 204(sp)
    1014:	\----- bne.s fd6 <setFileIndices+0xb6>
	}
	startOfTextIndex = startIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    1016:	       move.l 196(sp),152(sp)
    101c:	       clr.l 148(sp)
    1020:	       clr.l 144(sp)
    1024:	       move.l 7a96 <DOSBase>,d0
    102a:	       movea.l d0,a6
    102c:	       move.l 152(sp),d1
    1030:	       move.l 148(sp),d2
    1034:	       move.l 144(sp),d3
    1038:	       jsr -66(a6)
    103c:	       move.l d0,140(sp)
    1040:	       move.l 140(sp),d0
    1044:	       addq.l #4,d0
    1046:	       move.l d0,7a7a <startIndex>
    104c:	       move.l 7a7a <startIndex>,d0
    1052:	       move.l d0,7a82 <startOfTextIndex>

	Seek(fp, get4bytes (fp), OFFSET_BEGINNING);
    1058:	       move.l 196(sp),136(sp)
    105e:	       move.l 196(sp),-(sp)
    1062:	       jsr 18c6 <get4bytes>
    1068:	       addq.l #4,sp
    106a:	       move.l d0,132(sp)
    106e:	       moveq #-1,d0
    1070:	       move.l d0,128(sp)
    1074:	       move.l 7a96 <DOSBase>,d0
    107a:	       movea.l d0,a6
    107c:	       move.l 136(sp),d1
    1080:	       move.l 132(sp),d2
    1084:	       move.l 128(sp),d3
    1088:	       jsr -66(a6)
    108c:	       move.l d0,124(sp)

	while (skipAfter) {
    1090:	   /-- bra.s 10ce <setFileIndices+0x1ae>
        Seek( fp, get4bytes (fp), OFFSET_BEGINING);
    1092:	/--|-> move.l 196(sp),40(sp)
    1098:	|  |   move.l 196(sp),-(sp)
    109c:	|  |   jsr 18c6 <get4bytes>
    10a2:	|  |   addq.l #4,sp
    10a4:	|  |   move.l d0,36(sp)
    10a8:	|  |   moveq #-1,d0
    10aa:	|  |   move.l d0,32(sp)
    10ae:	|  |   move.l 7a96 <DOSBase>,d0
    10b4:	|  |   movea.l d0,a6
    10b6:	|  |   move.l 40(sp),d1
    10ba:	|  |   move.l 36(sp),d2
    10be:	|  |   move.l 32(sp),d3
    10c2:	|  |   jsr -66(a6)
    10c6:	|  |   move.l d0,28(sp)
		skipAfter --;
    10ca:	|  |   subq.l #1,188(sp)
	while (skipAfter) {
    10ce:	|  \-> tst.l 188(sp)
    10d2:	\----- bne.s 1092 <setFileIndices+0x172>
	}

	startOfSubIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    10d4:	       move.l 196(sp),120(sp)
    10da:	       clr.l 116(sp)
    10de:	       clr.l 112(sp)
    10e2:	       move.l 7a96 <DOSBase>,d0
    10e8:	       movea.l d0,a6
    10ea:	       move.l 120(sp),d1
    10ee:	       move.l 116(sp),d2
    10f2:	       move.l 112(sp),d3
    10f6:	       jsr -66(a6)
    10fa:	       move.l d0,108(sp)
    10fe:	       move.l 108(sp),d0
    1102:	       addq.l #4,d0
    1104:	       move.l d0,7a86 <startOfSubIndex>
    Seek( fp, get4bytes (fp), OFFSET_CURRENT);
    110a:	       move.l 196(sp),104(sp)
    1110:	       move.l 196(sp),-(sp)
    1114:	       jsr 18c6 <get4bytes>
    111a:	       addq.l #4,sp
    111c:	       move.l d0,100(sp)
    1120:	       clr.l 96(sp)
    1124:	       move.l 7a96 <DOSBase>,d0
    112a:	       movea.l d0,a6
    112c:	       move.l 104(sp),d1
    1130:	       move.l 100(sp),d2
    1134:	       move.l 96(sp),d3
    1138:	       jsr -66(a6)
    113c:	       move.l d0,92(sp)

	startOfObjectIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    1140:	       move.l 196(sp),88(sp)
    1146:	       clr.l 84(sp)
    114a:	       clr.l 80(sp)
    114e:	       move.l 7a96 <DOSBase>,d0
    1154:	       movea.l d0,a6
    1156:	       move.l 88(sp),d1
    115a:	       move.l 84(sp),d2
    115e:	       move.l 80(sp),d3
    1162:	       jsr -66(a6)
    1166:	       move.l d0,76(sp)
    116a:	       move.l 76(sp),d0
    116e:	       addq.l #4,d0
    1170:	       move.l d0,7a8a <startOfObjectIndex>
	Seek (fp, get4bytes (fp), OFFSET_CURRENT);
    1176:	       move.l 196(sp),72(sp)
    117c:	       move.l 196(sp),-(sp)
    1180:	       jsr 18c6 <get4bytes>
    1186:	       addq.l #4,sp
    1188:	       move.l d0,68(sp)
    118c:	       clr.l 64(sp)
    1190:	       move.l 7a96 <DOSBase>,d0
    1196:	       movea.l d0,a6
    1198:	       move.l 72(sp),d1
    119c:	       move.l 68(sp),d2
    11a0:	       move.l 64(sp),d3
    11a4:	       jsr -66(a6)
    11a8:	       move.l d0,60(sp)

	// Remember that the data section starts here
	startOfDataIndex =  Seek( fp, 0, OFFSET_CURRENT);
    11ac:	       move.l 196(sp),56(sp)
    11b2:	       clr.l 52(sp)
    11b6:	       clr.l 48(sp)
    11ba:	       move.l 7a96 <DOSBase>,d0
    11c0:	       movea.l d0,a6
    11c2:	       move.l 56(sp),d1
    11c6:	       move.l 52(sp),d2
    11ca:	       move.l 48(sp),d3
    11ce:	       jsr -66(a6)
    11d2:	       move.l d0,44(sp)
    11d6:	       move.l 44(sp),d0
    11da:	       move.l d0,7a7e <startOfDataIndex>
    11e0:	       nop
    11e2:	       movem.l (sp)+,d2-d3/a6
    11e6:	       lea 180(sp),sp
    11ea:	       rts

000011ec <WaitVbl>:
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
}

//vblank begins at vpos 312 hpos 1 and ends at vpos 25 hpos 1
//vsync begins at line 2 hpos 132 and ends at vpos 5 hpos 18 
void WaitVbl() {
    11ec:	       subq.l #8,sp
	debug_start_idle();
    11ee:	       jsr 24b6 <debug_start_idle>
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    11f4:	   /-> movea.l #14675972,a0
    11fa:	   |   move.l (a0),d0
    11fc:	   |   move.l d0,(sp)
		vpos&=0x1ff00;
    11fe:	   |   move.l (sp),d0
    1200:	   |   andi.l #130816,d0
    1206:	   |   move.l d0,(sp)
		if (vpos!=(311<<8))
    1208:	   |   move.l (sp),d0
    120a:	   |   cmpi.l #79616,d0
    1210:	   \-- beq.s 11f4 <WaitVbl+0x8>
			break;
	}
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    1212:	/----> movea.l #14675972,a0
    1218:	|      move.l (a0),d0
    121a:	|      move.l d0,4(sp)
		vpos&=0x1ff00;
    121e:	|      move.l 4(sp),d0
    1222:	|      andi.l #130816,d0
    1228:	|      move.l d0,4(sp)
		if (vpos==(311<<8))
    122c:	|      move.l 4(sp),d0
    1230:	|      cmpi.l #79616,d0
    1236:	|  /-- beq.s 123a <WaitVbl+0x4e>
	while (1) {
    1238:	\--|-- bra.s 1212 <WaitVbl+0x26>
			break;
    123a:	   \-> nop
	}
	debug_stop_idle();
    123c:	       jsr 24d0 <debug_stop_idle>
}
    1242:	       nop
    1244:	       addq.l #8,sp
    1246:	       rts

00001248 <p61Init>:
	// The Player® 6.1A: Copyright © 1992-95 Jarno Paananen
	// P61.testmod - Module by Skylord/Sector 7 
	INCBIN(player, "player610.6.no_cia.bin")
	INCBIN_CHIP(module, "testmod.p61")

	int p61Init(const void* module) { // returns 0 if success, non-zero otherwise
    1248:	move.l a3,-(sp)
    124a:	move.l a2,-(sp)
		register volatile const void* _a0 ASM("a0") = module;
    124c:	movea.l 12(sp),a0
		register volatile const void* _a1 ASM("a1") = NULL;
    1250:	suba.l a1,a1
		register volatile const void* _a2 ASM("a2") = NULL;
    1252:	suba.l a2,a2
		register volatile const void* _a3 ASM("a3") = player;
    1254:	move.l 65b2 <player>,d0
    125a:	movea.l d0,a3
		register                int   _d0 ASM("d0"); // return value
		__asm volatile (
    125c:	movem.l d1-d7/a4-a6,-(sp)
    1260:	jsr (a3)
    1262:	movem.l (sp)+,d1-d7/a4-a6
			"movem.l (%%sp)+,%%d1-%%d7/%%a4-%%a6"
		: "=r" (_d0), "+rf"(_a0), "+rf"(_a1), "+rf"(_a2), "+rf"(_a3)
		:
		: "cc", "memory");
		return _d0;
	}
    1266:	movea.l (sp)+,a2
    1268:	movea.l (sp)+,a3
    126a:	rts

0000126c <p61End>:
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}

	void p61End() {
    126c:	move.l a6,-(sp)
    126e:	move.l a3,-(sp)
		register volatile const void* _a3 ASM("a3") = player;
    1270:	move.l 65b2 <player>,d0
    1276:	movea.l d0,a3
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
    1278:	movea.l #14675968,a6
		__asm volatile (
    127e:	movem.l d0-d1/a0-a1,-(sp)
    1282:	jsr 8(a3)
    1286:	movem.l (sp)+,d0-d1/a0-a1
			"jsr 8(%%a3)\n"
			"movem.l (%%sp)+,%%d0-%%d1/%%a0-%%a1"
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}
    128a:	nop
    128c:	movea.l (sp)+,a3
    128e:	movea.l (sp)+,a6
    1290:	rts

00001292 <main>:
static void Wait10() { WaitLine(0x10); }
static void Wait11() { WaitLine(0x11); }
static void Wait12() { WaitLine(0x12); }
static void Wait13() { WaitLine(0x13); }

int main(int argc, char *argv[]) {
    1292:	    lea -64(sp),sp
    1296:	    movem.l d2-d3/a6,-(sp)
	SysBase = *((struct ExecBase**)4UL);
    129a:	    movea.w #4,a0
    129e:	    move.l (a0),d0
    12a0:	    move.l d0,7a8e <SysBase>
	custom = (struct Custom*)0xdff000;
    12a6:	    move.l #14675968,7a92 <custom>

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR)"graphics.library",0);
    12b0:	    move.l #17209,72(sp)
    12b8:	    clr.l 68(sp)
    12bc:	    move.l 7a8e <SysBase>,d0
    12c2:	    movea.l d0,a6
    12c4:	    movea.l 72(sp),a1
    12c8:	    move.l 68(sp),d0
    12cc:	    jsr -552(a6)
    12d0:	    move.l d0,64(sp)
    12d4:	    move.l 64(sp),d0
    12d8:	    move.l d0,7a9a <GfxBase>
	if (!GfxBase)
    12de:	    move.l 7a9a <GfxBase>,d0
    12e4:	/-- bne.s 12fa <main+0x68>
		Exit(0);
    12e6:	|   clr.l 60(sp)
    12ea:	|   move.l 7a96 <DOSBase>,d0
    12f0:	|   movea.l d0,a6
    12f2:	|   move.l 60(sp),d1
    12f6:	|   jsr -144(a6)

	// used for printing
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
    12fa:	\-> move.l #17226,56(sp)
    1302:	    clr.l 52(sp)
    1306:	    move.l 7a8e <SysBase>,d0
    130c:	    movea.l d0,a6
    130e:	    movea.l 56(sp),a1
    1312:	    move.l 52(sp),d0
    1316:	    jsr -552(a6)
    131a:	    move.l d0,48(sp)
    131e:	    move.l 48(sp),d0
    1322:	    move.l d0,7a96 <DOSBase>
	if (!DOSBase)
    1328:	    move.l 7a96 <DOSBase>,d0
    132e:	/-- bne.s 1344 <main+0xb2>
		Exit(0);
    1330:	|   clr.l 44(sp)
    1334:	|   move.l 7a96 <DOSBase>,d0
    133a:	|   movea.l d0,a6
    133c:	|   move.l 44(sp),d1
    1340:	|   jsr -144(a6)

	KPrintF("Hello debugger from Amiga!\n");
    1344:	\-> pea 4356 <incbin_player_end+0x1e>
    134a:	    jsr 22de <KPrintF>
    1350:	    addq.l #4,sp

	Write(Output(), (APTR)"Hello console!\n", 15);
    1352:	    move.l 7a96 <DOSBase>,d0
    1358:	    movea.l d0,a6
    135a:	    jsr -60(a6)
    135e:	    move.l d0,40(sp)
    1362:	    move.l 40(sp),d0
    1366:	    move.l d0,36(sp)
    136a:	    move.l #17266,32(sp)
    1372:	    moveq #15,d0
    1374:	    move.l d0,28(sp)
    1378:	    move.l 7a96 <DOSBase>,d0
    137e:	    movea.l d0,a6
    1380:	    move.l 36(sp),d1
    1384:	    move.l 32(sp),d2
    1388:	    move.l 28(sp),d3
    138c:	    jsr -48(a6)
    1390:	    move.l d0,24(sp)
	Delay(50);
    1394:	    moveq #50,d0
    1396:	    move.l d0,20(sp)
    139a:	    move.l 7a96 <DOSBase>,d0
    13a0:	    movea.l d0,a6
    13a2:	    move.l 20(sp),d1
    13a6:	    jsr -198(a6)

	warpmode(1);
    13aa:	    pea 1 <_start+0x1>
    13ae:	    jsr 2348 <warpmode>
    13b4:	    addq.l #4,sp
	// TODO: precalc stuff here
#ifdef MUSIC
	if(p61Init(module) != 0)
    13b6:	    move.l 65b6 <module>,d0
    13bc:	    move.l d0,-(sp)
    13be:	    jsr 1248 <p61Init>
    13c4:	    addq.l #4,sp
    13c6:	    tst.l d0
    13c8:	/-- beq.s 13d8 <main+0x146>
		KPrintF("p61Init failed!\n");
    13ca:	|   pea 4382 <incbin_player_end+0x4a>
    13d0:	|   jsr 22de <KPrintF>
    13d6:	|   addq.l #4,sp
#endif
	warpmode(0);
    13d8:	\-> clr.l -(sp)
    13da:	    jsr 2348 <warpmode>
    13e0:	    addq.l #4,sp

	//TakeSystem();
	custom->dmacon = 0x87ff;
    13e2:	    movea.l 7a92 <custom>,a0
    13e8:	    move.w #-30721,150(a0)
	WaitVbl();
    13ee:	    jsr 11ec <WaitVbl>

	main_sludge(argc, argv);
    13f4:	    move.l 84(sp),-(sp)
    13f8:	    move.l 84(sp),-(sp)
    13fc:	    jsr aac <main_sludge>
    1402:	    addq.l #8,sp
	debug_register_copperlist(copper2, "copper2", sizeof(copper2), 0);*/



#ifdef MUSIC
	p61End();
    1404:	    jsr 126c <p61End>
#endif

	// END
	//FreeSystem();

	CloseLibrary((struct Library*)DOSBase);
    140a:	    move.l 7a96 <DOSBase>,16(sp)
    1412:	    move.l 7a8e <SysBase>,d0
    1418:	    movea.l d0,a6
    141a:	    movea.l 16(sp),a1
    141e:	    jsr -414(a6)
	CloseLibrary((struct Library*)GfxBase);
    1422:	    move.l 7a9a <GfxBase>,12(sp)
    142a:	    move.l 7a8e <SysBase>,d0
    1430:	    movea.l d0,a6
    1432:	    movea.l 12(sp),a1
    1436:	    jsr -414(a6)
    143a:	    moveq #0,d0
}
    143c:	    movem.l (sp)+,d2-d3/a6
    1440:	    lea 64(sp),sp
    1444:	    rts

00001446 <makeNullAnim>:
#include <proto/exec.h>

#include "people.h"

struct personaAnimation * makeNullAnim () {
    1446:	       lea -16(sp),sp
    144a:	       move.l a6,-(sp)

	struct personaAnimation * newAnim	= AllocVec(sizeof(struct personaAnimation),MEMF_ANY);
    144c:	       moveq #12,d0
    144e:	       move.l d0,16(sp)
    1452:	       clr.l 12(sp)
    1456:	       move.l 7a8e <SysBase>,d0
    145c:	       movea.l d0,a6
    145e:	       move.l 16(sp),d0
    1462:	       move.l 12(sp),d1
    1466:	       jsr -684(a6)
    146a:	       move.l d0,8(sp)
    146e:	       move.l 8(sp),d0
    1472:	       move.l d0,4(sp)
    if(newAnim == 0) {
    1476:	   /-- bne.s 148a <makeNullAnim+0x44>
     	KPrintF("makeNullAnim: Can't reserve Memory\n");
    1478:	   |   pea 4393 <incbin_player_end+0x5b>
    147e:	   |   jsr 22de <KPrintF>
    1484:	   |   addq.l #4,sp
        return NULL;    
    1486:	   |   moveq #0,d0
    1488:	/--|-- bra.s 14a4 <makeNullAnim+0x5e>
    }  

	newAnim -> theSprites		= NULL;
    148a:	|  \-> movea.l 4(sp),a0
    148e:	|      clr.l (a0)
	newAnim -> numFrames		= 0;
    1490:	|      movea.l 4(sp),a0
    1494:	|      clr.l 8(a0)
	newAnim -> frames			= NULL;
    1498:	|      movea.l 4(sp),a0
    149c:	|      clr.l 4(a0)
	return newAnim;
    14a0:	|      move.l 4(sp),d0
}
    14a4:	\----> movea.l (sp)+,a6
    14a6:	       lea 16(sp),sp
    14aa:	       rts

000014ac <encodeFilename>:
#include "support/gcc8_c_support.h"
#include "moreio.h"

BOOL allowAnyFilename = TRUE;

char * encodeFilename (char * nameIn) {
    14ac:	                      lea -24(sp),sp
    14b0:	                      move.l a6,-(sp)
	if (! nameIn) return NULL;
    14b2:	                      tst.l 32(sp)
    14b6:	                  /-- bne.s 14be <encodeFilename+0x12>
    14b8:	                  |   moveq #0,d0
    14ba:	/-----------------|-- bra.w 1836 <encodeFilename+0x38a>
	if (allowAnyFilename) {
    14be:	|                 \-> move.w 65ba <allowAnyFilename>,d0
    14c4:	|  /----------------- beq.w 17f2 <encodeFilename+0x346>
		char * newName = AllocVec( strlen(nameIn)*2+1,MEMF_ANY);
    14c8:	|  |                  move.l 32(sp),-(sp)
    14cc:	|  |                  jsr 1aea <strlen>
    14d2:	|  |                  addq.l #4,sp
    14d4:	|  |                  add.l d0,d0
    14d6:	|  |                  move.l d0,d1
    14d8:	|  |                  addq.l #1,d1
    14da:	|  |                  move.l d1,16(sp)
    14de:	|  |                  clr.l 12(sp)
    14e2:	|  |                  move.l 7a8e <SysBase>,d0
    14e8:	|  |                  movea.l d0,a6
    14ea:	|  |                  move.l 16(sp),d0
    14ee:	|  |                  move.l 12(sp),d1
    14f2:	|  |                  jsr -684(a6)
    14f6:	|  |                  move.l d0,8(sp)
    14fa:	|  |                  move.l 8(sp),d0
    14fe:	|  |                  move.l d0,4(sp)
		if(newName == 0) {
    1502:	|  |              /-- bne.s 1518 <encodeFilename+0x6c>
			KPrintF( "encodefilename: Could not allocate Memory");
    1504:	|  |              |   pea 43b7 <incbin_player_end+0x7f>
    150a:	|  |              |   jsr 22de <KPrintF>
    1510:	|  |              |   addq.l #4,sp
			return NULL;
    1512:	|  |              |   moveq #0,d0
    1514:	+--|--------------|-- bra.w 1836 <encodeFilename+0x38a>
		}

		int i = 0;
    1518:	|  |              \-> clr.l 24(sp)
		while (*nameIn) {
    151c:	|  |     /----------- bra.w 17e2 <encodeFilename+0x336>
			switch (*nameIn) {
    1520:	|  |  /--|----------> movea.l 32(sp),a0
    1524:	|  |  |  |            move.b (a0),d0
    1526:	|  |  |  |            ext.w d0
    1528:	|  |  |  |            movea.w d0,a0
    152a:	|  |  |  |            moveq #95,d0
    152c:	|  |  |  |            cmp.l a0,d0
    152e:	|  |  |  |        /-- blt.w 15d2 <encodeFilename+0x126>
    1532:	|  |  |  |        |   moveq #34,d1
    1534:	|  |  |  |        |   cmp.l a0,d1
    1536:	|  |  |  |  /-----|-- bgt.w 17b6 <encodeFilename+0x30a>
    153a:	|  |  |  |  |     |   moveq #-34,d0
    153c:	|  |  |  |  |     |   add.l a0,d0
    153e:	|  |  |  |  |     |   moveq #61,d1
    1540:	|  |  |  |  |     |   cmp.l d0,d1
    1542:	|  |  |  |  +-----|-- bcs.w 17b6 <encodeFilename+0x30a>
    1546:	|  |  |  |  |     |   add.l d0,d0
    1548:	|  |  |  |  |     |   movea.l d0,a0
    154a:	|  |  |  |  |     |   adda.l #5462,a0
    1550:	|  |  |  |  |     |   move.w (a0),d0
    1552:	|  |  |  |  |     |   jmp (1556 <encodeFilename+0xaa>,pc,d0.w)
    1556:	|  |  |  |  |     |   bchg d0,d6
    1558:	|  |  |  |  |     |   andi.w #608,-(a0)
    155c:	|  |  |  |  |     |   andi.w #608,-(a0)
    1560:	|  |  |  |  |     |   andi.w #608,-(a0)
    1564:	|  |  |  |  |     |   andi.w #516,-(a0)
    1568:	|  |  |  |  |     |   andi.w #608,-(a0)
    156c:	|  |  |  |  |     |   andi.w #608,-(a0)
    1570:	|  |  |  |  |     |   bclr d0,-(a6)
    1572:	|  |  |  |  |     |   andi.w #608,-(a0)
    1576:	|  |  |  |  |     |   andi.w #608,-(a0)
    157a:	|  |  |  |  |     |   andi.w #608,-(a0)
    157e:	|  |  |  |  |     |   andi.w #608,-(a0)
    1582:	|  |  |  |  |     |   andi.w #608,-(a0)
    1586:	|  |  |  |  |     |   bset d0,(a6)
    1588:	|  |  |  |  |     |   andi.w #134,-(a0)
    158c:	|  |  |  |  |     |   andi.w #182,-(a0)
    1590:	|  |  |  |  |     |   andi.b #96,(96,a2,d0.w:2)
    1596:	|  |  |  |  |     |   andi.w #608,-(a0)
    159a:	|  |  |  |  |     |   andi.w #608,-(a0)
    159e:	|  |  |  |  |     |   andi.w #608,-(a0)
    15a2:	|  |  |  |  |     |   andi.w #608,-(a0)
    15a6:	|  |  |  |  |     |   andi.w #608,-(a0)
    15aa:	|  |  |  |  |     |   andi.w #608,-(a0)
    15ae:	|  |  |  |  |     |   andi.w #608,-(a0)
    15b2:	|  |  |  |  |     |   andi.w #608,-(a0)
    15b6:	|  |  |  |  |     |   andi.w #608,-(a0)
    15ba:	|  |  |  |  |     |   andi.w #608,-(a0)
    15be:	|  |  |  |  |     |   andi.w #608,-(a0)
    15c2:	|  |  |  |  |     |   andi.w #608,-(a0)
    15c6:	|  |  |  |  |     |   andi.w #608,-(a0)
    15ca:	|  |  |  |  |     |   bchg d0,(96,a6,d0.w:2)
    15ce:	|  |  |  |  |     |   andi.w #278,-(a0)
    15d2:	|  |  |  |  |     \-> moveq #124,d0
    15d4:	|  |  |  |  |         cmp.l a0,d0
    15d6:	|  |  |  |  |     /-- beq.s 163c <encodeFilename+0x190>
    15d8:	|  |  |  |  +-----|-- bra.w 17b6 <encodeFilename+0x30a>
				case '<':	newName[i++] = '_';		newName[i++] = 'L';		break;
    15dc:	|  |  |  |  |     |   move.l 24(sp),d0
    15e0:	|  |  |  |  |     |   move.l d0,d1
    15e2:	|  |  |  |  |     |   addq.l #1,d1
    15e4:	|  |  |  |  |     |   move.l d1,24(sp)
    15e8:	|  |  |  |  |     |   movea.l 4(sp),a0
    15ec:	|  |  |  |  |     |   adda.l d0,a0
    15ee:	|  |  |  |  |     |   move.b #95,(a0)
    15f2:	|  |  |  |  |     |   move.l 24(sp),d0
    15f6:	|  |  |  |  |     |   move.l d0,d1
    15f8:	|  |  |  |  |     |   addq.l #1,d1
    15fa:	|  |  |  |  |     |   move.l d1,24(sp)
    15fe:	|  |  |  |  |     |   movea.l 4(sp),a0
    1602:	|  |  |  |  |     |   adda.l d0,a0
    1604:	|  |  |  |  |     |   move.b #76,(a0)
    1608:	|  |  |  |  |  /--|-- bra.w 17d2 <encodeFilename+0x326>
				case '>':	newName[i++] = '_';		newName[i++] = 'G';		break;
    160c:	|  |  |  |  |  |  |   move.l 24(sp),d0
    1610:	|  |  |  |  |  |  |   move.l d0,d1
    1612:	|  |  |  |  |  |  |   addq.l #1,d1
    1614:	|  |  |  |  |  |  |   move.l d1,24(sp)
    1618:	|  |  |  |  |  |  |   movea.l 4(sp),a0
    161c:	|  |  |  |  |  |  |   adda.l d0,a0
    161e:	|  |  |  |  |  |  |   move.b #95,(a0)
    1622:	|  |  |  |  |  |  |   move.l 24(sp),d0
    1626:	|  |  |  |  |  |  |   move.l d0,d1
    1628:	|  |  |  |  |  |  |   addq.l #1,d1
    162a:	|  |  |  |  |  |  |   move.l d1,24(sp)
    162e:	|  |  |  |  |  |  |   movea.l 4(sp),a0
    1632:	|  |  |  |  |  |  |   adda.l d0,a0
    1634:	|  |  |  |  |  |  |   move.b #71,(a0)
    1638:	|  |  |  |  |  +--|-- bra.w 17d2 <encodeFilename+0x326>
				case '|':	newName[i++] = '_';		newName[i++] = 'P';		break;
    163c:	|  |  |  |  |  |  \-> move.l 24(sp),d0
    1640:	|  |  |  |  |  |      move.l d0,d1
    1642:	|  |  |  |  |  |      addq.l #1,d1
    1644:	|  |  |  |  |  |      move.l d1,24(sp)
    1648:	|  |  |  |  |  |      movea.l 4(sp),a0
    164c:	|  |  |  |  |  |      adda.l d0,a0
    164e:	|  |  |  |  |  |      move.b #95,(a0)
    1652:	|  |  |  |  |  |      move.l 24(sp),d0
    1656:	|  |  |  |  |  |      move.l d0,d1
    1658:	|  |  |  |  |  |      addq.l #1,d1
    165a:	|  |  |  |  |  |      move.l d1,24(sp)
    165e:	|  |  |  |  |  |      movea.l 4(sp),a0
    1662:	|  |  |  |  |  |      adda.l d0,a0
    1664:	|  |  |  |  |  |      move.b #80,(a0)
    1668:	|  |  |  |  |  +----- bra.w 17d2 <encodeFilename+0x326>
				case '_':	newName[i++] = '_';		newName[i++] = 'U';		break;
    166c:	|  |  |  |  |  |      move.l 24(sp),d0
    1670:	|  |  |  |  |  |      move.l d0,d1
    1672:	|  |  |  |  |  |      addq.l #1,d1
    1674:	|  |  |  |  |  |      move.l d1,24(sp)
    1678:	|  |  |  |  |  |      movea.l 4(sp),a0
    167c:	|  |  |  |  |  |      adda.l d0,a0
    167e:	|  |  |  |  |  |      move.b #95,(a0)
    1682:	|  |  |  |  |  |      move.l 24(sp),d0
    1686:	|  |  |  |  |  |      move.l d0,d1
    1688:	|  |  |  |  |  |      addq.l #1,d1
    168a:	|  |  |  |  |  |      move.l d1,24(sp)
    168e:	|  |  |  |  |  |      movea.l 4(sp),a0
    1692:	|  |  |  |  |  |      adda.l d0,a0
    1694:	|  |  |  |  |  |      move.b #85,(a0)
    1698:	|  |  |  |  |  +----- bra.w 17d2 <encodeFilename+0x326>
				case '\"':	newName[i++] = '_';		newName[i++] = 'S';		break;
    169c:	|  |  |  |  |  |      move.l 24(sp),d0
    16a0:	|  |  |  |  |  |      move.l d0,d1
    16a2:	|  |  |  |  |  |      addq.l #1,d1
    16a4:	|  |  |  |  |  |      move.l d1,24(sp)
    16a8:	|  |  |  |  |  |      movea.l 4(sp),a0
    16ac:	|  |  |  |  |  |      adda.l d0,a0
    16ae:	|  |  |  |  |  |      move.b #95,(a0)
    16b2:	|  |  |  |  |  |      move.l 24(sp),d0
    16b6:	|  |  |  |  |  |      move.l d0,d1
    16b8:	|  |  |  |  |  |      addq.l #1,d1
    16ba:	|  |  |  |  |  |      move.l d1,24(sp)
    16be:	|  |  |  |  |  |      movea.l 4(sp),a0
    16c2:	|  |  |  |  |  |      adda.l d0,a0
    16c4:	|  |  |  |  |  |      move.b #83,(a0)
    16c8:	|  |  |  |  |  +----- bra.w 17d2 <encodeFilename+0x326>
				case '\\':	newName[i++] = '_';		newName[i++] = 'B';		break;
    16cc:	|  |  |  |  |  |      move.l 24(sp),d0
    16d0:	|  |  |  |  |  |      move.l d0,d1
    16d2:	|  |  |  |  |  |      addq.l #1,d1
    16d4:	|  |  |  |  |  |      move.l d1,24(sp)
    16d8:	|  |  |  |  |  |      movea.l 4(sp),a0
    16dc:	|  |  |  |  |  |      adda.l d0,a0
    16de:	|  |  |  |  |  |      move.b #95,(a0)
    16e2:	|  |  |  |  |  |      move.l 24(sp),d0
    16e6:	|  |  |  |  |  |      move.l d0,d1
    16e8:	|  |  |  |  |  |      addq.l #1,d1
    16ea:	|  |  |  |  |  |      move.l d1,24(sp)
    16ee:	|  |  |  |  |  |      movea.l 4(sp),a0
    16f2:	|  |  |  |  |  |      adda.l d0,a0
    16f4:	|  |  |  |  |  |      move.b #66,(a0)
    16f8:	|  |  |  |  |  +----- bra.w 17d2 <encodeFilename+0x326>
				case '/':	newName[i++] = '_';		newName[i++] = 'F';		break;
    16fc:	|  |  |  |  |  |      move.l 24(sp),d0
    1700:	|  |  |  |  |  |      move.l d0,d1
    1702:	|  |  |  |  |  |      addq.l #1,d1
    1704:	|  |  |  |  |  |      move.l d1,24(sp)
    1708:	|  |  |  |  |  |      movea.l 4(sp),a0
    170c:	|  |  |  |  |  |      adda.l d0,a0
    170e:	|  |  |  |  |  |      move.b #95,(a0)
    1712:	|  |  |  |  |  |      move.l 24(sp),d0
    1716:	|  |  |  |  |  |      move.l d0,d1
    1718:	|  |  |  |  |  |      addq.l #1,d1
    171a:	|  |  |  |  |  |      move.l d1,24(sp)
    171e:	|  |  |  |  |  |      movea.l 4(sp),a0
    1722:	|  |  |  |  |  |      adda.l d0,a0
    1724:	|  |  |  |  |  |      move.b #70,(a0)
    1728:	|  |  |  |  |  +----- bra.w 17d2 <encodeFilename+0x326>
				case ':':	newName[i++] = '_';		newName[i++] = 'C';		break;
    172c:	|  |  |  |  |  |      move.l 24(sp),d0
    1730:	|  |  |  |  |  |      move.l d0,d1
    1732:	|  |  |  |  |  |      addq.l #1,d1
    1734:	|  |  |  |  |  |      move.l d1,24(sp)
    1738:	|  |  |  |  |  |      movea.l 4(sp),a0
    173c:	|  |  |  |  |  |      adda.l d0,a0
    173e:	|  |  |  |  |  |      move.b #95,(a0)
    1742:	|  |  |  |  |  |      move.l 24(sp),d0
    1746:	|  |  |  |  |  |      move.l d0,d1
    1748:	|  |  |  |  |  |      addq.l #1,d1
    174a:	|  |  |  |  |  |      move.l d1,24(sp)
    174e:	|  |  |  |  |  |      movea.l 4(sp),a0
    1752:	|  |  |  |  |  |      adda.l d0,a0
    1754:	|  |  |  |  |  |      move.b #67,(a0)
    1758:	|  |  |  |  |  +----- bra.s 17d2 <encodeFilename+0x326>
				case '*':	newName[i++] = '_';		newName[i++] = 'A';		break;
    175a:	|  |  |  |  |  |      move.l 24(sp),d0
    175e:	|  |  |  |  |  |      move.l d0,d1
    1760:	|  |  |  |  |  |      addq.l #1,d1
    1762:	|  |  |  |  |  |      move.l d1,24(sp)
    1766:	|  |  |  |  |  |      movea.l 4(sp),a0
    176a:	|  |  |  |  |  |      adda.l d0,a0
    176c:	|  |  |  |  |  |      move.b #95,(a0)
    1770:	|  |  |  |  |  |      move.l 24(sp),d0
    1774:	|  |  |  |  |  |      move.l d0,d1
    1776:	|  |  |  |  |  |      addq.l #1,d1
    1778:	|  |  |  |  |  |      move.l d1,24(sp)
    177c:	|  |  |  |  |  |      movea.l 4(sp),a0
    1780:	|  |  |  |  |  |      adda.l d0,a0
    1782:	|  |  |  |  |  |      move.b #65,(a0)
    1786:	|  |  |  |  |  +----- bra.s 17d2 <encodeFilename+0x326>
				case '?':	newName[i++] = '_';		newName[i++] = 'Q';		break;
    1788:	|  |  |  |  |  |      move.l 24(sp),d0
    178c:	|  |  |  |  |  |      move.l d0,d1
    178e:	|  |  |  |  |  |      addq.l #1,d1
    1790:	|  |  |  |  |  |      move.l d1,24(sp)
    1794:	|  |  |  |  |  |      movea.l 4(sp),a0
    1798:	|  |  |  |  |  |      adda.l d0,a0
    179a:	|  |  |  |  |  |      move.b #95,(a0)
    179e:	|  |  |  |  |  |      move.l 24(sp),d0
    17a2:	|  |  |  |  |  |      move.l d0,d1
    17a4:	|  |  |  |  |  |      addq.l #1,d1
    17a6:	|  |  |  |  |  |      move.l d1,24(sp)
    17aa:	|  |  |  |  |  |      movea.l 4(sp),a0
    17ae:	|  |  |  |  |  |      adda.l d0,a0
    17b0:	|  |  |  |  |  |      move.b #81,(a0)
    17b4:	|  |  |  |  |  +----- bra.s 17d2 <encodeFilename+0x326>

				default:	newName[i++] = *nameIn;							break;
    17b6:	|  |  |  |  \--|----> move.l 24(sp),d0
    17ba:	|  |  |  |     |      move.l d0,d1
    17bc:	|  |  |  |     |      addq.l #1,d1
    17be:	|  |  |  |     |      move.l d1,24(sp)
    17c2:	|  |  |  |     |      movea.l 4(sp),a0
    17c6:	|  |  |  |     |      adda.l d0,a0
    17c8:	|  |  |  |     |      movea.l 32(sp),a1
    17cc:	|  |  |  |     |      move.b (a1),d0
    17ce:	|  |  |  |     |      move.b d0,(a0)
    17d0:	|  |  |  |     |      nop
			}
			newName[i] = 0;
    17d2:	|  |  |  |     \----> move.l 24(sp),d0
    17d6:	|  |  |  |            movea.l 4(sp),a0
    17da:	|  |  |  |            adda.l d0,a0
    17dc:	|  |  |  |            clr.b (a0)
			nameIn ++;
    17de:	|  |  |  |            addq.l #1,32(sp)
		while (*nameIn) {
    17e2:	|  |  |  \----------> movea.l 32(sp),a0
    17e6:	|  |  |               move.b (a0),d0
    17e8:	|  |  \-------------- bne.w 1520 <encodeFilename+0x74>
		}
		return newName;
    17ec:	|  |                  move.l 4(sp),d0
    17f0:	+--|----------------- bra.s 1836 <encodeFilename+0x38a>
	} else {
		int a;
		for (a = 0; nameIn[a]; a ++) {
    17f2:	|  \----------------> clr.l 20(sp)
    17f6:	|              /----- bra.s 181c <encodeFilename+0x370>
			if (nameIn[a] == '\\') nameIn[a] ='/';
    17f8:	|           /--|----> move.l 20(sp),d0
    17fc:	|           |  |      movea.l 32(sp),a0
    1800:	|           |  |      adda.l d0,a0
    1802:	|           |  |      move.b (a0),d0
    1804:	|           |  |      cmpi.b #92,d0
    1808:	|           |  |  /-- bne.s 1818 <encodeFilename+0x36c>
    180a:	|           |  |  |   move.l 20(sp),d0
    180e:	|           |  |  |   movea.l 32(sp),a0
    1812:	|           |  |  |   adda.l d0,a0
    1814:	|           |  |  |   move.b #47,(a0)
		for (a = 0; nameIn[a]; a ++) {
    1818:	|           |  |  \-> addq.l #1,20(sp)
    181c:	|           |  \----> move.l 20(sp),d0
    1820:	|           |         movea.l 32(sp),a0
    1824:	|           |         adda.l d0,a0
    1826:	|           |         move.b (a0),d0
    1828:	|           \-------- bne.s 17f8 <encodeFilename+0x34c>
		}

		return copyString (nameIn);
    182a:	|                     move.l 32(sp),-(sp)
    182e:	|                     jsr 1b2a <copyString>
    1834:	|                     addq.l #4,sp
	}
}
    1836:	\-------------------> movea.l (sp)+,a6
    1838:	                      lea 24(sp),sp
    183c:	                      rts

0000183e <floatSwap>:

float floatSwap( float f )
{
    183e:	subq.l #8,sp
	{
		float f;
		unsigned char b[4];
	} dat1, dat2;

	dat1.f = f;
    1840:	move.l 12(sp),4(sp)
	dat2.b[0] = dat1.b[3];
    1846:	move.b 7(sp),d0
    184a:	move.b d0,(sp)
	dat2.b[1] = dat1.b[2];
    184c:	move.b 6(sp),d0
    1850:	move.b d0,1(sp)
	dat2.b[2] = dat1.b[1];
    1854:	move.b 5(sp),d0
    1858:	move.b d0,2(sp)
	dat2.b[3] = dat1.b[0];
    185c:	move.b 4(sp),d0
    1860:	move.b d0,3(sp)
	return dat2.f;
    1864:	move.l (sp),d0
}
    1866:	addq.l #8,sp
    1868:	rts

0000186a <get2bytes>:

int get2bytes (BPTR fp) {
    186a:	lea -24(sp),sp
    186e:	move.l a6,-(sp)
	int f1, f2;

	f1 = FGetC (fp);
    1870:	move.l 32(sp),24(sp)
    1876:	move.l 7a96 <DOSBase>,d0
    187c:	movea.l d0,a6
    187e:	move.l 24(sp),d1
    1882:	jsr -306(a6)
    1886:	move.l d0,20(sp)
    188a:	move.l 20(sp),d0
    188e:	move.l d0,16(sp)
	f2 = FGetC (fp);
    1892:	move.l 32(sp),12(sp)
    1898:	move.l 7a96 <DOSBase>,d0
    189e:	movea.l d0,a6
    18a0:	move.l 12(sp),d1
    18a4:	jsr -306(a6)
    18a8:	move.l d0,8(sp)
    18ac:	move.l 8(sp),d0
    18b0:	move.l d0,4(sp)

	return (f1 * 256 + f2);
    18b4:	move.l 16(sp),d0
    18b8:	lsl.l #8,d0
    18ba:	add.l 4(sp),d0
}
    18be:	movea.l (sp)+,a6
    18c0:	lea 24(sp),sp
    18c4:	rts

000018c6 <get4bytes>:

ULONG get4bytes (BPTR fp) {
    18c6:	lea -52(sp),sp
    18ca:	move.l a6,-(sp)
	int f1, f2, f3, f4;

	f1 = FGetC (fp);
    18cc:	move.l 60(sp),52(sp)
    18d2:	move.l 7a96 <DOSBase>,d0
    18d8:	movea.l d0,a6
    18da:	move.l 52(sp),d1
    18de:	jsr -306(a6)
    18e2:	move.l d0,48(sp)
    18e6:	move.l 48(sp),d0
    18ea:	move.l d0,44(sp)
	f2 = FGetC (fp);
    18ee:	move.l 60(sp),40(sp)
    18f4:	move.l 7a96 <DOSBase>,d0
    18fa:	movea.l d0,a6
    18fc:	move.l 40(sp),d1
    1900:	jsr -306(a6)
    1904:	move.l d0,36(sp)
    1908:	move.l 36(sp),d0
    190c:	move.l d0,32(sp)
	f3 = FGetC (fp);
    1910:	move.l 60(sp),28(sp)
    1916:	move.l 7a96 <DOSBase>,d0
    191c:	movea.l d0,a6
    191e:	move.l 28(sp),d1
    1922:	jsr -306(a6)
    1926:	move.l d0,24(sp)
    192a:	move.l 24(sp),d0
    192e:	move.l d0,20(sp)
	f4 = FGetC (fp);
    1932:	move.l 60(sp),16(sp)
    1938:	move.l 7a96 <DOSBase>,d0
    193e:	movea.l d0,a6
    1940:	move.l 16(sp),d1
    1944:	jsr -306(a6)
    1948:	move.l d0,12(sp)
    194c:	move.l 12(sp),d0
    1950:	move.l d0,8(sp)

	ULONG x = f1 + f2*256 + f3*256*256 + f4*256*256*256;
    1954:	move.l 32(sp),d0
    1958:	lsl.l #8,d0
    195a:	move.l d0,d1
    195c:	add.l 44(sp),d1
    1960:	move.l 20(sp),d0
    1964:	swap d0
    1966:	clr.w d0
    1968:	add.l d0,d1
    196a:	move.l 8(sp),d0
    196e:	lsl.w #8,d0
    1970:	swap d0
    1972:	clr.w d0
    1974:	add.l d1,d0
    1976:	move.l d0,4(sp)

	return x;
    197a:	move.l 4(sp),d0
}
    197e:	movea.l (sp)+,a6
    1980:	lea 52(sp),sp
    1984:	rts

00001986 <getFloat>:

float getFloat (BPTR fp) {
    1986:	    lea -28(sp),sp
    198a:	    movem.l d2-d4/a6,-(sp)
	float f;
	LONG blocks_read = FRead( fp, &f, sizeof (float), 1 ); 
    198e:	    move.l 48(sp),40(sp)
    1994:	    lea 44(sp),a0
    1998:	    lea -28(a0),a0
    199c:	    move.l a0,36(sp)
    19a0:	    moveq #4,d0
    19a2:	    move.l d0,32(sp)
    19a6:	    moveq #1,d0
    19a8:	    move.l d0,28(sp)
    19ac:	    move.l 7a96 <DOSBase>,d0
    19b2:	    movea.l d0,a6
    19b4:	    move.l 40(sp),d1
    19b8:	    move.l 36(sp),d2
    19bc:	    move.l 32(sp),d3
    19c0:	    move.l 28(sp),d4
    19c4:	    jsr -324(a6)
    19c8:	    move.l d0,24(sp)
    19cc:	    move.l 24(sp),d0
    19d0:	    move.l d0,20(sp)
	if (blocks_read != 1) {
    19d4:	    moveq #1,d0
    19d6:	    cmp.l 20(sp),d0
    19da:	/-- beq.s 19ea <getFloat+0x64>
		KPrintF("Reading error in getFloat.\n");
    19dc:	|   pea 43e1 <incbin_player_end+0xa9>
    19e2:	|   jsr 22de <KPrintF>
    19e8:	|   addq.l #4,sp
	}
	return floatSwap(f);
    19ea:	\-> move.l 16(sp),d0
    19ee:	    move.l d0,-(sp)
    19f0:	    jsr 183e <floatSwap>
    19f6:	    addq.l #4,sp
	return f;
}
    19f8:	    movem.l (sp)+,d2-d4/a6
    19fc:	    lea 28(sp),sp
    1a00:	    rts

00001a02 <readString>:

char * readString (BPTR fp) {
    1a02:	          lea -32(sp),sp
    1a06:	          move.l a6,-(sp)

	int a, len = get2bytes (fp);
    1a08:	          move.l 40(sp),-(sp)
    1a0c:	          jsr 186a <get2bytes>
    1a12:	          addq.l #4,sp
    1a14:	          move.l d0,28(sp)
	//debugOut ("MOREIO: readString - len %i\n", len);
	char * s = AllocVec(len+1,MEMF_ANY);
    1a18:	          move.l 28(sp),d0
    1a1c:	          addq.l #1,d0
    1a1e:	          move.l d0,24(sp)
    1a22:	          clr.l 20(sp)
    1a26:	          move.l 7a8e <SysBase>,d0
    1a2c:	          movea.l d0,a6
    1a2e:	          move.l 24(sp),d0
    1a32:	          move.l 20(sp),d1
    1a36:	          jsr -684(a6)
    1a3a:	          move.l d0,16(sp)
    1a3e:	          move.l 16(sp),d0
    1a42:	          move.l d0,12(sp)
	if(s == 0) return NULL;
    1a46:	      /-- bne.s 1a4c <readString+0x4a>
    1a48:	      |   moveq #0,d0
    1a4a:	/-----|-- bra.s 1aa2 <readString+0xa0>
	for (a = 0; a < len; a ++) {
    1a4c:	|     \-> clr.l 32(sp)
    1a50:	|     /-- bra.s 1a88 <readString+0x86>
		s[a] = (char) (FGetC (fp) - 1);
    1a52:	|  /--|-> move.l 40(sp),8(sp)
    1a58:	|  |  |   move.l 7a96 <DOSBase>,d0
    1a5e:	|  |  |   movea.l d0,a6
    1a60:	|  |  |   move.l 8(sp),d1
    1a64:	|  |  |   jsr -306(a6)
    1a68:	|  |  |   move.l d0,4(sp)
    1a6c:	|  |  |   move.l 4(sp),d0
    1a70:	|  |  |   move.l d0,d0
    1a72:	|  |  |   move.b d0,d1
    1a74:	|  |  |   subq.b #1,d1
    1a76:	|  |  |   move.l 32(sp),d0
    1a7a:	|  |  |   movea.l 12(sp),a0
    1a7e:	|  |  |   adda.l d0,a0
    1a80:	|  |  |   move.b d1,d0
    1a82:	|  |  |   move.b d0,(a0)
	for (a = 0; a < len; a ++) {
    1a84:	|  |  |   addq.l #1,32(sp)
    1a88:	|  |  \-> move.l 32(sp),d0
    1a8c:	|  |      cmp.l 28(sp),d0
    1a90:	|  \----- blt.s 1a52 <readString+0x50>
	}
	s[len] = 0;
    1a92:	|         move.l 28(sp),d0
    1a96:	|         movea.l 12(sp),a0
    1a9a:	|         adda.l d0,a0
    1a9c:	|         clr.b (a0)
	//debugOut ("MOREIO: readString: %s\n", s);
	return s;
    1a9e:	|         move.l 12(sp),d0
    1aa2:	\-------> movea.l (sp)+,a6
    1aa4:	          lea 32(sp),sp
    1aa8:	          rts

00001aaa <strcmp>:
#include "support/gcc8_c_support.h"


int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1 == *s2))
    1aaa:	   /-- bra.s 1ab4 <strcmp+0xa>
    {
        s1++;
    1aac:	/--|-> addq.l #1,4(sp)
        s2++;
    1ab0:	|  |   addq.l #1,8(sp)
    while(*s1 && (*s1 == *s2))
    1ab4:	|  \-> movea.l 4(sp),a0
    1ab8:	|      move.b (a0),d0
    1aba:	|  /-- beq.s 1acc <strcmp+0x22>
    1abc:	|  |   movea.l 4(sp),a0
    1ac0:	|  |   move.b (a0),d1
    1ac2:	|  |   movea.l 8(sp),a0
    1ac6:	|  |   move.b (a0),d0
    1ac8:	|  |   cmp.b d1,d0
    1aca:	\--|-- beq.s 1aac <strcmp+0x2>
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
    1acc:	   \-> movea.l 4(sp),a0
    1ad0:	       move.b (a0),d0
    1ad2:	       moveq #0,d1
    1ad4:	       move.b d0,d1
    1ad6:	       movea.l 8(sp),a0
    1ada:	       move.b (a0),d0
    1adc:	       move.b d0,d0
    1ade:	       andi.l #255,d0
    1ae4:	       sub.l d0,d1
    1ae6:	       move.l d1,d0
}
    1ae8:	       rts

00001aea <strlen>:

long unsigned int strlen (const char *s) 
{  
    1aea:	       subq.l #4,sp
	long unsigned int i = 0;
    1aec:	       clr.l (sp)
	while(s[i]) i++; 
    1aee:	   /-- bra.s 1af2 <strlen+0x8>
    1af0:	/--|-> addq.l #1,(sp)
    1af2:	|  \-> movea.l 8(sp),a0
    1af6:	|      adda.l (sp),a0
    1af8:	|      move.b (a0),d0
    1afa:	\----- bne.s 1af0 <strlen+0x6>
	return(i);
    1afc:	       move.l (sp),d0
}
    1afe:	       addq.l #4,sp
    1b00:	       rts

00001b02 <strcpy>:

char *strcpy(char *t, const char *s) 
{
	while(*t++ = *s++);
    1b02:	    nop
    1b04:	/-> move.l 8(sp),d0
    1b08:	|   move.l d0,d1
    1b0a:	|   addq.l #1,d1
    1b0c:	|   move.l d1,8(sp)
    1b10:	|   movea.l 4(sp),a0
    1b14:	|   lea 1(a0),a1
    1b18:	|   move.l a1,4(sp)
    1b1c:	|   movea.l d0,a1
    1b1e:	|   move.b (a1),d0
    1b20:	|   move.b d0,(a0)
    1b22:	|   move.b (a0),d0
    1b24:	\-- bne.s 1b04 <strcpy+0x2>
}
    1b26:	    nop
    1b28:	    rts

00001b2a <copyString>:

char * copyString (const char * copyMe) {
    1b2a:	       lea -16(sp),sp
    1b2e:	       move.l a6,-(sp)
	
	char * newString = AllocVec(strlen(copyMe)+1, MEMF_ANY); 
    1b30:	       move.l 24(sp),-(sp)
    1b34:	       jsr 1aea <strlen>
    1b3a:	       addq.l #4,sp
    1b3c:	       move.l d0,d1
    1b3e:	       addq.l #1,d1
    1b40:	       move.l d1,16(sp)
    1b44:	       clr.l 12(sp)
    1b48:	       move.l 7a8e <SysBase>,d0
    1b4e:	       movea.l d0,a6
    1b50:	       move.l 16(sp),d0
    1b54:	       move.l 12(sp),d1
    1b58:	       jsr -684(a6)
    1b5c:	       move.l d0,8(sp)
    1b60:	       move.l 8(sp),d0
    1b64:	       move.l d0,4(sp)
	if(newString == 0) {
    1b68:	   /-- bne.s 1b7c <copyString+0x52>
		KPrintF("copystring: Can't reserve memory for newString\n");
    1b6a:	   |   pea 43fd <incbin_player_end+0xc5>
    1b70:	   |   jsr 22de <KPrintF>
    1b76:	   |   addq.l #4,sp
		return NULL;	
    1b78:	   |   moveq #0,d0
    1b7a:	/--|-- bra.s 1b90 <copyString+0x66>
	}
	strcpy (newString, copyMe);
    1b7c:	|  \-> move.l 24(sp),-(sp)
    1b80:	|      move.l 8(sp),-(sp)
    1b84:	|      jsr 1b02 <strcpy>
    1b8a:	|      addq.l #8,sp
	return newString;
    1b8c:	|      move.l 4(sp),d0
}
    1b90:	\----> movea.l (sp)+,a6
    1b92:	       lea 16(sp),sp
    1b96:	       rts

00001b98 <joinStrings>:

char * joinStrings (const char * s1, const char * s2) {
    1b98:	    lea -20(sp),sp
    1b9c:	    move.l a6,-(sp)
    1b9e:	    move.l d2,-(sp)
	char * newString = AllocVec(strlen (s1) + strlen (s2) + 1, MEMF_ANY); 
    1ba0:	    move.l 32(sp),-(sp)
    1ba4:	    jsr 1aea <strlen>
    1baa:	    addq.l #4,sp
    1bac:	    move.l d0,d2
    1bae:	    move.l 36(sp),-(sp)
    1bb2:	    jsr 1aea <strlen>
    1bb8:	    addq.l #4,sp
    1bba:	    add.l d2,d0
    1bbc:	    move.l d0,d1
    1bbe:	    addq.l #1,d1
    1bc0:	    move.l d1,20(sp)
    1bc4:	    clr.l 16(sp)
    1bc8:	    move.l 7a8e <SysBase>,d0
    1bce:	    movea.l d0,a6
    1bd0:	    move.l 20(sp),d0
    1bd4:	    move.l 16(sp),d1
    1bd8:	    jsr -684(a6)
    1bdc:	    move.l d0,12(sp)
    1be0:	    move.l 12(sp),d0
    1be4:	    move.l d0,8(sp)
	char * t = newString;
    1be8:	    move.l 8(sp),24(sp)

	while(*t++ = *s1++);
    1bee:	    nop
    1bf0:	/-> move.l 32(sp),d0
    1bf4:	|   move.l d0,d1
    1bf6:	|   addq.l #1,d1
    1bf8:	|   move.l d1,32(sp)
    1bfc:	|   movea.l 24(sp),a0
    1c00:	|   lea 1(a0),a1
    1c04:	|   move.l a1,24(sp)
    1c08:	|   movea.l d0,a1
    1c0a:	|   move.b (a1),d0
    1c0c:	|   move.b d0,(a0)
    1c0e:	|   move.b (a0),d0
    1c10:	\-- bne.s 1bf0 <joinStrings+0x58>
	t--;
    1c12:	    subq.l #1,24(sp)
	while(*t++ = *s2++);
    1c16:	    nop
    1c18:	/-> move.l 36(sp),d0
    1c1c:	|   move.l d0,d1
    1c1e:	|   addq.l #1,d1
    1c20:	|   move.l d1,36(sp)
    1c24:	|   movea.l 24(sp),a0
    1c28:	|   lea 1(a0),a1
    1c2c:	|   move.l a1,24(sp)
    1c30:	|   movea.l d0,a1
    1c32:	|   move.b (a1),d0
    1c34:	|   move.b d0,(a0)
    1c36:	|   move.b (a0),d0
    1c38:	\-- bne.s 1c18 <joinStrings+0x80>

	return newString;
    1c3a:	    move.l 8(sp),d0
}
    1c3e:	    move.l (sp)+,d2
    1c40:	    movea.l (sp)+,a6
    1c42:	    lea 20(sp),sp
    1c46:	    rts

00001c48 <getPrefsFilename>:

int *languageTable;
char **languageName;
struct settingsStruct gameSettings;

char * getPrefsFilename (char * filename) {
    1c48:	          lea -20(sp),sp
    1c4c:	          move.l a6,-(sp)
	// Yes, this trashes the original string, but
	// we also free it at the end (warning!)...

	int n, i;

	n = strlen (filename);
    1c4e:	          move.l 28(sp),-(sp)
    1c52:	          jsr 1aea <strlen>
    1c58:	          addq.l #4,sp
    1c5a:	          move.l d0,12(sp)


	if (n > 4 && filename[n-4] == '.') {
    1c5e:	          moveq #4,d0
    1c60:	          cmp.l 12(sp),d0
    1c64:	      /-- bge.s 1c88 <getPrefsFilename+0x40>
    1c66:	      |   move.l 12(sp),d0
    1c6a:	      |   subq.l #4,d0
    1c6c:	      |   movea.l 28(sp),a0
    1c70:	      |   adda.l d0,a0
    1c72:	      |   move.b (a0),d0
    1c74:	      |   cmpi.b #46,d0
    1c78:	      +-- bne.s 1c88 <getPrefsFilename+0x40>
		filename[n-4] = 0;
    1c7a:	      |   move.l 12(sp),d0
    1c7e:	      |   subq.l #4,d0
    1c80:	      |   movea.l 28(sp),a0
    1c84:	      |   adda.l d0,a0
    1c86:	      |   clr.b (a0)
	}

	char * f = filename;
    1c88:	      \-> move.l 28(sp),16(sp)
	for (i = 0; i<n; i++) {
    1c8e:	          clr.l 20(sp)
    1c92:	   /----- bra.s 1cba <getPrefsFilename+0x72>
		if (filename[i] == '/') f = filename + i + 1;
    1c94:	/--|----> move.l 20(sp),d0
    1c98:	|  |      movea.l 28(sp),a0
    1c9c:	|  |      adda.l d0,a0
    1c9e:	|  |      move.b (a0),d0
    1ca0:	|  |      cmpi.b #47,d0
    1ca4:	|  |  /-- bne.s 1cb6 <getPrefsFilename+0x6e>
    1ca6:	|  |  |   move.l 20(sp),d0
    1caa:	|  |  |   addq.l #1,d0
    1cac:	|  |  |   move.l 28(sp),d1
    1cb0:	|  |  |   add.l d0,d1
    1cb2:	|  |  |   move.l d1,16(sp)
	for (i = 0; i<n; i++) {
    1cb6:	|  |  \-> addq.l #1,20(sp)
    1cba:	|  \----> move.l 20(sp),d0
    1cbe:	|         cmp.l 12(sp),d0
    1cc2:	\-------- blt.s 1c94 <getPrefsFilename+0x4c>
	}

	char * joined = joinStrings (f, ".ini");
    1cc4:	          pea 442d <incbin_player_end+0xf5>
    1cca:	          move.l 20(sp),-(sp)
    1cce:	          jsr 1b98 <joinStrings>
    1cd4:	          addq.l #8,sp
    1cd6:	          move.l d0,8(sp)

	FreeVec(filename);
    1cda:	          move.l 28(sp),4(sp)
    1ce0:	          move.l 7a8e <SysBase>,d0
    1ce6:	          movea.l d0,a6
    1ce8:	          movea.l 4(sp),a1
    1cec:	          jsr -690(a6)
	filename = NULL;
    1cf0:	          clr.l 28(sp)
	return joined;
    1cf4:	          move.l 8(sp),d0
}
    1cf8:	          movea.l (sp)+,a6
    1cfa:	          lea 20(sp),sp
    1cfe:	          rts

00001d00 <makeLanguageTable>:

void makeLanguageTable (BPTR table)
{
    1d00:	             lea -28(sp),sp
    1d04:	             move.l a6,-(sp)
    1d06:	             move.l a2,-(sp)
	languageTable = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    1d08:	             move.l 7aaa <gameSettings+0x4>,d0
    1d0e:	             move.l d0,d1
    1d10:	             addq.l #1,d1
    1d12:	             move.l d1,28(sp)
    1d16:	             clr.l 24(sp)
    1d1a:	             move.l 7a8e <SysBase>,d0
    1d20:	             movea.l d0,a6
    1d22:	             move.l 28(sp),d0
    1d26:	             move.l 24(sp),d1
    1d2a:	             jsr -684(a6)
    1d2e:	             move.l d0,20(sp)
    1d32:	             move.l 20(sp),d0
    1d36:	             move.l d0,7a9e <languageTable>
    if( languageTable == 0) {
    1d3c:	             move.l 7a9e <languageTable>,d0
    1d42:	         /-- bne.s 1d52 <makeLanguageTable+0x52>
        KPrintF("makeLanguageTable: Cannot Alloc Mem for languageTable");
    1d44:	         |   pea 4432 <incbin_player_end+0xfa>
    1d4a:	         |   jsr 22de <KPrintF>
    1d50:	         |   addq.l #4,sp
    }

	languageName = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    1d52:	         \-> move.l 7aaa <gameSettings+0x4>,d0
    1d58:	             move.l d0,d1
    1d5a:	             addq.l #1,d1
    1d5c:	             move.l d1,16(sp)
    1d60:	             clr.l 12(sp)
    1d64:	             move.l 7a8e <SysBase>,d0
    1d6a:	             movea.l d0,a6
    1d6c:	             move.l 16(sp),d0
    1d70:	             move.l 12(sp),d1
    1d74:	             jsr -684(a6)
    1d78:	             move.l d0,8(sp)
    1d7c:	             move.l 8(sp),d0
    1d80:	             move.l d0,7aa2 <languageName>
	if( languageName == 0) {
    1d86:	             move.l 7aa2 <languageName>,d0
    1d8c:	         /-- bne.s 1d9c <makeLanguageTable+0x9c>
        KPrintF("makeLanguageName: Cannot Alloc Mem for languageName");
    1d8e:	         |   pea 4468 <incbin_player_end+0x130>
    1d94:	         |   jsr 22de <KPrintF>
    1d9a:	         |   addq.l #4,sp
    }

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    1d9c:	         \-> clr.l 32(sp)
    1da0:	   /-------- bra.s 1e18 <makeLanguageTable+0x118>
		languageTable[i] = i ? get2bytes (table) : 0;
    1da2:	/--|-------> tst.l 32(sp)
    1da6:	|  |  /----- beq.s 1db6 <makeLanguageTable+0xb6>
    1da8:	|  |  |      move.l 40(sp),-(sp)
    1dac:	|  |  |      jsr 186a <get2bytes>
    1db2:	|  |  |      addq.l #4,sp
    1db4:	|  |  |  /-- bra.s 1db8 <makeLanguageTable+0xb8>
    1db6:	|  |  \--|-> moveq #0,d0
    1db8:	|  |     \-> movea.l 7a9e <languageTable>,a0
    1dbe:	|  |         move.l 32(sp),d1
    1dc2:	|  |         add.l d1,d1
    1dc4:	|  |         add.l d1,d1
    1dc6:	|  |         adda.l d1,a0
    1dc8:	|  |         move.l d0,(a0)
		languageName[i] = 0;
    1dca:	|  |         move.l 7aa2 <languageName>,d1
    1dd0:	|  |         move.l 32(sp),d0
    1dd4:	|  |         add.l d0,d0
    1dd6:	|  |         add.l d0,d0
    1dd8:	|  |         movea.l d1,a0
    1dda:	|  |         adda.l d0,a0
    1ddc:	|  |         clr.l (a0)
		if (gameVersion >= VERSION(2,0)) {
    1dde:	|  |         move.l 7a3e <gameVersion>,d0
    1de4:	|  |         cmpi.l #511,d0
    1dea:	|  |     /-- ble.s 1e14 <makeLanguageTable+0x114>
			if (gameSettings.numLanguages)
    1dec:	|  |     |   move.l 7aaa <gameSettings+0x4>,d0
    1df2:	|  |     +-- beq.s 1e14 <makeLanguageTable+0x114>
				languageName[i] = readString (table);
    1df4:	|  |     |   move.l 7aa2 <languageName>,d1
    1dfa:	|  |     |   move.l 32(sp),d0
    1dfe:	|  |     |   add.l d0,d0
    1e00:	|  |     |   add.l d0,d0
    1e02:	|  |     |   movea.l d1,a2
    1e04:	|  |     |   adda.l d0,a2
    1e06:	|  |     |   move.l 40(sp),-(sp)
    1e0a:	|  |     |   jsr 1a02 <readString>
    1e10:	|  |     |   addq.l #4,sp
    1e12:	|  |     |   move.l d0,(a2)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    1e14:	|  |     \-> addq.l #1,32(sp)
    1e18:	|  \-------> move.l 7aaa <gameSettings+0x4>,d0
    1e1e:	|            cmp.l 32(sp),d0
    1e22:	\----------- bcc.w 1da2 <makeLanguageTable+0xa2>
		}
	}
}
    1e26:	             nop
    1e28:	             nop
    1e2a:	             movea.l (sp)+,a2
    1e2c:	             movea.l (sp)+,a6
    1e2e:	             lea 28(sp),sp
    1e32:	             rts

00001e34 <readIniFile>:

void readIniFile (char * filename) {
    1e34:	                      lea -564(sp),sp
    1e38:	                      move.l a6,-(sp)
    1e3a:	                      move.l d2,-(sp)
	char * langName = getPrefsFilename (copyString (filename));
    1e3c:	                      move.l 576(sp),-(sp)
    1e40:	                      jsr 1b2a <copyString>
    1e46:	                      addq.l #4,sp
    1e48:	                      move.l d0,-(sp)
    1e4a:	                      jsr 1c48 <getPrefsFilename>
    1e50:	                      addq.l #4,sp
    1e52:	                      move.l d0,562(sp)

	BPTR fp = Open(langName,MODE_OLDFILE);	
    1e56:	                      move.l 562(sp),558(sp)
    1e5c:	                      move.l #1005,554(sp)
    1e64:	                      move.l 7a96 <DOSBase>,d0
    1e6a:	                      movea.l d0,a6
    1e6c:	                      move.l 558(sp),d1
    1e70:	                      move.l 554(sp),d2
    1e74:	                      jsr -30(a6)
    1e78:	                      move.l d0,550(sp)
    1e7c:	                      move.l 550(sp),d0
    1e80:	                      move.l d0,546(sp)

	gameSettings.languageID = 0;
    1e84:	                      clr.l 7aa6 <gameSettings>
	gameSettings.userFullScreen = TRUE; //Always fullscreen on AMIGA
    1e8a:	                      move.w #1,7aae <gameSettings+0x8>
	gameSettings.refreshRate = 0;
    1e92:	                      clr.l 7ab0 <gameSettings+0xa>
	gameSettings.antiAlias = 1;
    1e98:	                      moveq #1,d0
    1e9a:	                      move.l d0,7ab4 <gameSettings+0xe>
	gameSettings.fixedPixels = FALSE;
    1ea0:	                      clr.w 7ab8 <gameSettings+0x12>
	gameSettings.noStartWindow = FALSE;
    1ea6:	                      clr.w 7aba <gameSettings+0x14>
	gameSettings.debugMode = FALSE;
    1eac:	                      clr.w 7abc <gameSettings+0x16>

	FreeVec(langName);
    1eb2:	                      move.l 562(sp),542(sp)
    1eb8:	                      move.l 7a8e <SysBase>,d0
    1ebe:	                      movea.l d0,a6
    1ec0:	                      movea.l 542(sp),a1
    1ec4:	                      jsr -690(a6)
	langName = NULL;
    1ec8:	                      clr.l 562(sp)

	if (fp) {
    1ecc:	                      tst.l 546(sp)
    1ed0:	/-------------------- beq.w 21ae <readIniFile+0x37a>
		char lineSoFar[257] = "";
    1ed4:	|                     move.l sp,d0
    1ed6:	|                     addi.l #265,d0
    1edc:	|                     move.l #257,d1
    1ee2:	|                     move.l d1,-(sp)
    1ee4:	|                     clr.l -(sp)
    1ee6:	|                     move.l d0,-(sp)
    1ee8:	|                     jsr 22ae <memset>
    1eee:	|                     lea 12(sp),sp
		char secondSoFar[257] = "";
    1ef2:	|                     move.l sp,d0
    1ef4:	|                     addq.l #8,d0
    1ef6:	|                     move.l #257,d1
    1efc:	|                     move.l d1,-(sp)
    1efe:	|                     clr.l -(sp)
    1f00:	|                     move.l d0,-(sp)
    1f02:	|                     jsr 22ae <memset>
    1f08:	|                     lea 12(sp),sp
		unsigned char here = 0;
    1f0c:	|                     clr.b 571(sp)
		char readChar = ' ';
    1f10:	|                     move.b #32,570(sp)
		BOOL keepGoing = TRUE;
    1f16:	|                     move.w #1,568(sp)
		BOOL doingSecond = FALSE;
    1f1c:	|                     clr.w 566(sp)
		LONG tmp = 0;
    1f20:	|                     clr.l 538(sp)

		do {

			tmp = FGetC (fp);
    1f24:	|  /----------------> move.l 546(sp),534(sp)
    1f2a:	|  |                  move.l 7a96 <DOSBase>,d0
    1f30:	|  |                  movea.l d0,a6
    1f32:	|  |                  move.l 534(sp),d1
    1f36:	|  |                  jsr -306(a6)
    1f3a:	|  |                  move.l d0,530(sp)
    1f3e:	|  |                  move.l 530(sp),d0
    1f42:	|  |                  move.l d0,538(sp)
			if (tmp == - 1) {
    1f46:	|  |                  moveq #-1,d1
    1f48:	|  |                  cmp.l 538(sp),d1
    1f4c:	|  |           /----- bne.s 1f5a <readIniFile+0x126>
				readChar = '\n';
    1f4e:	|  |           |      move.b #10,570(sp)
				keepGoing = FALSE;
    1f54:	|  |           |      clr.w 568(sp)
    1f58:	|  |           |  /-- bra.s 1f60 <readIniFile+0x12c>
			} else {
				readChar = (char) tmp;
    1f5a:	|  |           \--|-> move.b 541(sp),570(sp)
			}

			switch (readChar) {
    1f60:	|  |              \-> move.b 570(sp),d0
    1f64:	|  |                  ext.w d0
    1f66:	|  |                  movea.w d0,a0
    1f68:	|  |                  moveq #61,d0
    1f6a:	|  |                  cmp.l a0,d0
    1f6c:	|  |     /----------- beq.w 2116 <readIniFile+0x2e2>
    1f70:	|  |     |            moveq #61,d1
    1f72:	|  |     |            cmp.l a0,d1
    1f74:	|  |  /--|----------- blt.w 2122 <readIniFile+0x2ee>
    1f78:	|  |  |  |            moveq #10,d0
    1f7a:	|  |  |  |            cmp.l a0,d0
    1f7c:	|  |  |  |        /-- beq.s 1f86 <readIniFile+0x152>
    1f7e:	|  |  |  |        |   moveq #13,d1
    1f80:	|  |  |  |        |   cmp.l a0,d1
    1f82:	|  |  +--|--------|-- bne.w 2122 <readIniFile+0x2ee>
				case '\n':
				case '\r':
				if (doingSecond) {
    1f86:	|  |  |  |        \-> tst.w 566(sp)
    1f8a:	|  |  |  |     /----- beq.w 2104 <readIniFile+0x2d0>
					if (strcmp (lineSoFar, "LANGUAGE") == 0)
    1f8e:	|  |  |  |     |      pea 449c <incbin_player_end+0x164>
    1f94:	|  |  |  |     |      move.l sp,d0
    1f96:	|  |  |  |     |      addi.l #269,d0
    1f9c:	|  |  |  |     |      move.l d0,-(sp)
    1f9e:	|  |  |  |     |      jsr 1aaa <strcmp>
    1fa4:	|  |  |  |     |      addq.l #8,sp
    1fa6:	|  |  |  |     |      tst.l d0
    1fa8:	|  |  |  |     |  /-- bne.s 1fc2 <readIniFile+0x18e>
					{
						gameSettings.languageID = stringToInt (secondSoFar);
    1faa:	|  |  |  |     |  |   move.l sp,d0
    1fac:	|  |  |  |     |  |   addq.l #8,d0
    1fae:	|  |  |  |     |  |   move.l d0,-(sp)
    1fb0:	|  |  |  |     |  |   jsr 21ba <stringToInt>
    1fb6:	|  |  |  |     |  |   addq.l #4,sp
    1fb8:	|  |  |  |     |  |   move.l d0,7aa6 <gameSettings>
    1fbe:	|  |  |  |     +--|-- bra.w 2104 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "WINDOW") == 0)
    1fc2:	|  |  |  |     |  \-> pea 44a5 <incbin_player_end+0x16d>
    1fc8:	|  |  |  |     |      move.l sp,d0
    1fca:	|  |  |  |     |      addi.l #269,d0
    1fd0:	|  |  |  |     |      move.l d0,-(sp)
    1fd2:	|  |  |  |     |      jsr 1aaa <strcmp>
    1fd8:	|  |  |  |     |      addq.l #8,sp
    1fda:	|  |  |  |     |      tst.l d0
    1fdc:	|  |  |  |     |  /-- bne.s 2002 <readIniFile+0x1ce>
					{
						gameSettings.userFullScreen = ! stringToInt (secondSoFar);
    1fde:	|  |  |  |     |  |   move.l sp,d0
    1fe0:	|  |  |  |     |  |   addq.l #8,d0
    1fe2:	|  |  |  |     |  |   move.l d0,-(sp)
    1fe4:	|  |  |  |     |  |   jsr 21ba <stringToInt>
    1fea:	|  |  |  |     |  |   addq.l #4,sp
    1fec:	|  |  |  |     |  |   tst.l d0
    1fee:	|  |  |  |     |  |   seq d0
    1ff0:	|  |  |  |     |  |   neg.b d0
    1ff2:	|  |  |  |     |  |   move.b d0,d0
    1ff4:	|  |  |  |     |  |   andi.w #255,d0
    1ff8:	|  |  |  |     |  |   move.w d0,7aae <gameSettings+0x8>
    1ffe:	|  |  |  |     +--|-- bra.w 2104 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "REFRESH") == 0)
    2002:	|  |  |  |     |  \-> pea 44ac <incbin_player_end+0x174>
    2008:	|  |  |  |     |      move.l sp,d0
    200a:	|  |  |  |     |      addi.l #269,d0
    2010:	|  |  |  |     |      move.l d0,-(sp)
    2012:	|  |  |  |     |      jsr 1aaa <strcmp>
    2018:	|  |  |  |     |      addq.l #8,sp
    201a:	|  |  |  |     |      tst.l d0
    201c:	|  |  |  |     |  /-- bne.s 2036 <readIniFile+0x202>
					{
						gameSettings.refreshRate = stringToInt (secondSoFar);
    201e:	|  |  |  |     |  |   move.l sp,d0
    2020:	|  |  |  |     |  |   addq.l #8,d0
    2022:	|  |  |  |     |  |   move.l d0,-(sp)
    2024:	|  |  |  |     |  |   jsr 21ba <stringToInt>
    202a:	|  |  |  |     |  |   addq.l #4,sp
    202c:	|  |  |  |     |  |   move.l d0,7ab0 <gameSettings+0xa>
    2032:	|  |  |  |     +--|-- bra.w 2104 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "ANTIALIAS") == 0)
    2036:	|  |  |  |     |  \-> pea 44b4 <incbin_player_end+0x17c>
    203c:	|  |  |  |     |      move.l sp,d0
    203e:	|  |  |  |     |      addi.l #269,d0
    2044:	|  |  |  |     |      move.l d0,-(sp)
    2046:	|  |  |  |     |      jsr 1aaa <strcmp>
    204c:	|  |  |  |     |      addq.l #8,sp
    204e:	|  |  |  |     |      tst.l d0
    2050:	|  |  |  |     |  /-- bne.s 206a <readIniFile+0x236>
					{
						gameSettings.antiAlias = stringToInt (secondSoFar);
    2052:	|  |  |  |     |  |   move.l sp,d0
    2054:	|  |  |  |     |  |   addq.l #8,d0
    2056:	|  |  |  |     |  |   move.l d0,-(sp)
    2058:	|  |  |  |     |  |   jsr 21ba <stringToInt>
    205e:	|  |  |  |     |  |   addq.l #4,sp
    2060:	|  |  |  |     |  |   move.l d0,7ab4 <gameSettings+0xe>
    2066:	|  |  |  |     +--|-- bra.w 2104 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "FIXEDPIXELS") == 0)
    206a:	|  |  |  |     |  \-> pea 44be <incbin_player_end+0x186>
    2070:	|  |  |  |     |      move.l sp,d0
    2072:	|  |  |  |     |      addi.l #269,d0
    2078:	|  |  |  |     |      move.l d0,-(sp)
    207a:	|  |  |  |     |      jsr 1aaa <strcmp>
    2080:	|  |  |  |     |      addq.l #8,sp
    2082:	|  |  |  |     |      tst.l d0
    2084:	|  |  |  |     |  /-- bne.s 209e <readIniFile+0x26a>
					{
						gameSettings.fixedPixels = stringToInt (secondSoFar);
    2086:	|  |  |  |     |  |   move.l sp,d0
    2088:	|  |  |  |     |  |   addq.l #8,d0
    208a:	|  |  |  |     |  |   move.l d0,-(sp)
    208c:	|  |  |  |     |  |   jsr 21ba <stringToInt>
    2092:	|  |  |  |     |  |   addq.l #4,sp
    2094:	|  |  |  |     |  |   move.l d0,d0
    2096:	|  |  |  |     |  |   move.w d0,7ab8 <gameSettings+0x12>
    209c:	|  |  |  |     +--|-- bra.s 2104 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "NOSTARTWINDOW") == 0)
    209e:	|  |  |  |     |  \-> pea 44ca <incbin_player_end+0x192>
    20a4:	|  |  |  |     |      move.l sp,d0
    20a6:	|  |  |  |     |      addi.l #269,d0
    20ac:	|  |  |  |     |      move.l d0,-(sp)
    20ae:	|  |  |  |     |      jsr 1aaa <strcmp>
    20b4:	|  |  |  |     |      addq.l #8,sp
    20b6:	|  |  |  |     |      tst.l d0
    20b8:	|  |  |  |     |  /-- bne.s 20d2 <readIniFile+0x29e>
					{
						gameSettings.noStartWindow = stringToInt (secondSoFar);
    20ba:	|  |  |  |     |  |   move.l sp,d0
    20bc:	|  |  |  |     |  |   addq.l #8,d0
    20be:	|  |  |  |     |  |   move.l d0,-(sp)
    20c0:	|  |  |  |     |  |   jsr 21ba <stringToInt>
    20c6:	|  |  |  |     |  |   addq.l #4,sp
    20c8:	|  |  |  |     |  |   move.l d0,d0
    20ca:	|  |  |  |     |  |   move.w d0,7aba <gameSettings+0x14>
    20d0:	|  |  |  |     +--|-- bra.s 2104 <readIniFile+0x2d0>
					}
					else if (strcmp (lineSoFar, "DEBUGMODE") == 0)
    20d2:	|  |  |  |     |  \-> pea 44d8 <incbin_player_end+0x1a0>
    20d8:	|  |  |  |     |      move.l sp,d0
    20da:	|  |  |  |     |      addi.l #269,d0
    20e0:	|  |  |  |     |      move.l d0,-(sp)
    20e2:	|  |  |  |     |      jsr 1aaa <strcmp>
    20e8:	|  |  |  |     |      addq.l #8,sp
    20ea:	|  |  |  |     |      tst.l d0
    20ec:	|  |  |  |     +----- bne.s 2104 <readIniFile+0x2d0>
					{
						gameSettings.debugMode = stringToInt (secondSoFar);
    20ee:	|  |  |  |     |      move.l sp,d0
    20f0:	|  |  |  |     |      addq.l #8,d0
    20f2:	|  |  |  |     |      move.l d0,-(sp)
    20f4:	|  |  |  |     |      jsr 21ba <stringToInt>
    20fa:	|  |  |  |     |      addq.l #4,sp
    20fc:	|  |  |  |     |      move.l d0,d0
    20fe:	|  |  |  |     |      move.w d0,7abc <gameSettings+0x16>
					}
				}
				here = 0;
    2104:	|  |  |  |     \----> clr.b 571(sp)
				doingSecond = FALSE;
    2108:	|  |  |  |            clr.w 566(sp)
				lineSoFar[0] = 0;
    210c:	|  |  |  |            clr.b 265(sp)
				secondSoFar[0] = 0;
    2110:	|  |  |  |            clr.b 8(sp)
				break;
    2114:	|  |  |  |  /-------- bra.s 218c <readIniFile+0x358>

				case '=':
				doingSecond = TRUE;
    2116:	|  |  |  \--|-------> move.w #1,566(sp)
				here = 0;
    211c:	|  |  |     |         clr.b 571(sp)
				break;
    2120:	|  |  |     +-------- bra.s 218c <readIniFile+0x358>

				default:
				if (doingSecond) {
    2122:	|  |  \-----|-------> tst.w 566(sp)
    2126:	|  |        |  /----- beq.s 215a <readIniFile+0x326>
					secondSoFar[here ++] = readChar;
    2128:	|  |        |  |      move.b 571(sp),d0
    212c:	|  |        |  |      move.b d0,d1
    212e:	|  |        |  |      addq.b #1,d1
    2130:	|  |        |  |      move.b d1,571(sp)
    2134:	|  |        |  |      move.b d0,d0
    2136:	|  |        |  |      andi.l #255,d0
    213c:	|  |        |  |      lea 572(sp),a0
    2140:	|  |        |  |      adda.l d0,a0
    2142:	|  |        |  |      move.b 570(sp),-564(a0)
					secondSoFar[here] = 0;
    2148:	|  |        |  |      moveq #0,d0
    214a:	|  |        |  |      move.b 571(sp),d0
    214e:	|  |        |  |      lea 572(sp),a0
    2152:	|  |        |  |      adda.l d0,a0
    2154:	|  |        |  |      clr.b -564(a0)
				} else {
					lineSoFar[here ++] = readChar;
					lineSoFar[here] = 0;
				}
				break;
    2158:	|  |        |  |  /-- bra.s 218a <readIniFile+0x356>
					lineSoFar[here ++] = readChar;
    215a:	|  |        |  \--|-> move.b 571(sp),d0
    215e:	|  |        |     |   move.b d0,d1
    2160:	|  |        |     |   addq.b #1,d1
    2162:	|  |        |     |   move.b d1,571(sp)
    2166:	|  |        |     |   move.b d0,d0
    2168:	|  |        |     |   andi.l #255,d0
    216e:	|  |        |     |   lea 572(sp),a0
    2172:	|  |        |     |   adda.l d0,a0
    2174:	|  |        |     |   move.b 570(sp),-307(a0)
					lineSoFar[here] = 0;
    217a:	|  |        |     |   moveq #0,d0
    217c:	|  |        |     |   move.b 571(sp),d0
    2180:	|  |        |     |   lea 572(sp),a0
    2184:	|  |        |     |   adda.l d0,a0
    2186:	|  |        |     |   clr.b -307(a0)
				break;
    218a:	|  |        |     \-> nop
			}
		} while (keepGoing);
    218c:	|  |        \-------> tst.w 568(sp)
    2190:	|  \----------------- bne.w 1f24 <readIniFile+0xf0>

		Close(fp);
    2194:	|                     move.l 546(sp),526(sp)
    219a:	|                     move.l 7a96 <DOSBase>,d0
    21a0:	|                     movea.l d0,a6
    21a2:	|                     move.l 526(sp),d1
    21a6:	|                     jsr -36(a6)
    21aa:	|                     move.l d0,522(sp)
	}
}
    21ae:	\-------------------> nop
    21b0:	                      move.l (sp)+,d2
    21b2:	                      movea.l (sp)+,a6
    21b4:	                      lea 564(sp),sp
    21b8:	                      rts

000021ba <stringToInt>:

unsigned int stringToInt (char * s) {
    21ba:	             subq.l #8,sp
	int i = 0;
    21bc:	             clr.l 4(sp)
	BOOL negative = FALSE;
    21c0:	             clr.w 2(sp)
	for (;;) {
		if (*s >= '0' && *s <= '9') {
    21c4:	/----------> movea.l 12(sp),a0
    21c8:	|            move.b (a0),d0
    21ca:	|            cmpi.b #47,d0
    21ce:	|        /-- ble.s 2206 <stringToInt+0x4c>
    21d0:	|        |   movea.l 12(sp),a0
    21d4:	|        |   move.b (a0),d0
    21d6:	|        |   cmpi.b #57,d0
    21da:	|        +-- bgt.s 2206 <stringToInt+0x4c>
			i *= 10;
    21dc:	|        |   move.l 4(sp),d1
    21e0:	|        |   move.l d1,d0
    21e2:	|        |   add.l d0,d0
    21e4:	|        |   add.l d0,d0
    21e6:	|        |   add.l d1,d0
    21e8:	|        |   add.l d0,d0
    21ea:	|        |   move.l d0,4(sp)
			i += *s - '0';
    21ee:	|        |   movea.l 12(sp),a0
    21f2:	|        |   move.b (a0),d0
    21f4:	|        |   ext.w d0
    21f6:	|        |   movea.w d0,a0
    21f8:	|        |   moveq #-48,d0
    21fa:	|        |   add.l a0,d0
    21fc:	|        |   add.l d0,4(sp)
			s ++;
    2200:	|        |   addq.l #1,12(sp)
    2204:	|  /-----|-- bra.s 223e <stringToInt+0x84>
		} else if (*s == '-') {
    2206:	|  |     \-> movea.l 12(sp),a0
    220a:	|  |         move.b (a0),d0
    220c:	|  |         cmpi.b #45,d0
    2210:	|  |     /-- bne.s 222a <stringToInt+0x70>
			negative = ! negative;
    2212:	|  |     |   tst.w 2(sp)
    2216:	|  |     |   seq d0
    2218:	|  |     |   neg.b d0
    221a:	|  |     |   move.b d0,d0
    221c:	|  |     |   andi.w #255,d0
    2220:	|  |     |   move.w d0,2(sp)
			s++;
    2224:	|  |     |   addq.l #1,12(sp)
    2228:	+--|-----|-- bra.s 21c4 <stringToInt+0xa>
		} else {
			if (negative)
    222a:	|  |     \-> tst.w 2(sp)
    222e:	|  |     /-- beq.s 2238 <stringToInt+0x7e>
				return -i;
    2230:	|  |     |   move.l 4(sp),d0
    2234:	|  |     |   neg.l d0
    2236:	|  |  /--|-- bra.s 2240 <stringToInt+0x86>
			return i;
    2238:	|  |  |  \-> move.l 4(sp),d0
    223c:	|  |  +----- bra.s 2240 <stringToInt+0x86>
		if (*s >= '0' && *s <= '9') {
    223e:	\--\--|----X bra.s 21c4 <stringToInt+0xa>
		}
	}
    2240:	      \----> addq.l #8,sp
    2242:	             rts

00002244 <fileExists>:
 *  Helper functions that don't depend on other source files.
 */
#include <proto/dos.h>
#include "helpers.h"

BYTE fileExists(const char * file) {
    2244:	    lea -28(sp),sp
    2248:	    move.l a6,-(sp)
    224a:	    move.l d2,-(sp)
	BPTR tester;
	BYTE retval = 0;
    224c:	    clr.b 35(sp)
	tester = Open(file, MODE_OLDFILE);
    2250:	    move.l 40(sp),30(sp)
    2256:	    move.l #1005,26(sp)
    225e:	    move.l 7a96 <DOSBase>,d0
    2264:	    movea.l d0,a6
    2266:	    move.l 30(sp),d1
    226a:	    move.l 26(sp),d2
    226e:	    jsr -30(a6)
    2272:	    move.l d0,22(sp)
    2276:	    move.l 22(sp),d0
    227a:	    move.l d0,18(sp)
	if (tester) {
    227e:	/-- beq.s 22a0 <fileExists+0x5c>
		retval = 1;
    2280:	|   move.b #1,35(sp)
		Close(tester);
    2286:	|   move.l 18(sp),14(sp)
    228c:	|   move.l 7a96 <DOSBase>,d0
    2292:	|   movea.l d0,a6
    2294:	|   move.l 14(sp),d1
    2298:	|   jsr -36(a6)
    229c:	|   move.l d0,10(sp)
	}
	return retval;
    22a0:	\-> move.b 35(sp),d0
    22a4:	    move.l (sp)+,d2
    22a6:	    movea.l (sp)+,a6
    22a8:	    lea 28(sp),sp
    22ac:	    rts

000022ae <memset>:
void* memset(void *dest, int val, unsigned long len) {
    22ae:	       subq.l #4,sp
	unsigned char *ptr = (unsigned char *)dest;
    22b0:	       move.l 8(sp),(sp)
	while(len-- > 0)
    22b4:	   /-- bra.s 22c6 <memset+0x18>
		*ptr++ = val;
    22b6:	/--|-> move.l (sp),d0
    22b8:	|  |   move.l d0,d1
    22ba:	|  |   addq.l #1,d1
    22bc:	|  |   move.l d1,(sp)
    22be:	|  |   move.l 12(sp),d1
    22c2:	|  |   movea.l d0,a0
    22c4:	|  |   move.b d1,(a0)
	while(len-- > 0)
    22c6:	|  \-> move.l 16(sp),d0
    22ca:	|      move.l d0,d1
    22cc:	|      subq.l #1,d1
    22ce:	|      move.l d1,16(sp)
    22d2:	|      tst.l d0
    22d4:	\----- bne.s 22b6 <memset+0x8>
	return dest;
    22d6:	       move.l 8(sp),d0
}
    22da:	       addq.l #4,sp
    22dc:	       rts

000022de <KPrintF>:
void KPrintF(const char* fmt, ...) {
    22de:	       lea -128(sp),sp
    22e2:	       movem.l a2-a3/a6,-(sp)
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    22e6:	       move.w f0ff60 <gcc8_c_support.c.af0a41ba+0xf00870>,d0
    22ec:	       cmpi.w #20153,d0
    22f0:	   /-- beq.s 2314 <KPrintF+0x36>
    22f2:	   |   cmpi.w #-24562,d0
    22f6:	   +-- beq.s 2314 <KPrintF+0x36>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
    22f8:	   |   movea.l 7a8e <SysBase>,a6
    22fe:	   |   movea.l 144(sp),a0
    2302:	   |   lea 148(sp),a1
    2306:	   |   lea 2572 <KPutCharX>,a2
    230c:	   |   suba.l a3,a3
    230e:	   |   jsr -522(a6)
}
    2312:	/--|-- bra.s 233e <KPrintF+0x60>
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
    2314:	|  \-> movea.l 7a8e <SysBase>,a6
    231a:	|      movea.l 144(sp),a0
    231e:	|      lea 148(sp),a1
    2322:	|      lea 2580 <PutChar>,a2
    2328:	|      lea 12(sp),a3
    232c:	|      jsr -522(a6)
		UaeDbgLog(86, temp);
    2330:	|      move.l a3,-(sp)
    2332:	|      pea 56 <_start+0x56>
    2336:	|      jsr f0ff60 <gcc8_c_support.c.af0a41ba+0xf00870>
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    233c:	|      addq.l #8,sp
}
    233e:	\----> movem.l (sp)+,a2-a3/a6
    2342:	       lea 128(sp),sp
    2346:	       rts

00002348 <warpmode>:

void warpmode(int on) { // bool
    2348:	          subq.l #8,sp
	long(*UaeConf)(long mode, int index, const char* param, int param_len, char* outbuf, int outbuf_len);
	UaeConf = (long(*)(long, int, const char*, int, char*, int))0xf0ff60;
    234a:	          move.l #15794016,4(sp)
	if(*((UWORD *)UaeConf) == 0x4eb9 || *((UWORD *)UaeConf) == 0xa00e) {
    2352:	          movea.l 4(sp),a0
    2356:	          move.w (a0),d0
    2358:	          cmpi.w #20153,d0
    235c:	      /-- beq.s 236c <warpmode+0x24>
    235e:	      |   movea.l 4(sp),a0
    2362:	      |   move.w (a0),d0
    2364:	      |   cmpi.w #-24562,d0
    2368:	/-----|-- bne.w 2470 <warpmode+0x128>
		char outbuf;
		UaeConf(82, -1, on ? "cpu_speed max" : "cpu_speed real", 0, &outbuf, 1);
    236c:	|     \-> tst.l 12(sp)
    2370:	|  /----- beq.s 237a <warpmode+0x32>
    2372:	|  |      move.l #17634,d0
    2378:	|  |  /-- bra.s 2380 <warpmode+0x38>
    237a:	|  \--|-> move.l #17648,d0
    2380:	|     \-> pea 1 <_start+0x1>
    2384:	|         move.l sp,d1
    2386:	|         addq.l #7,d1
    2388:	|         move.l d1,-(sp)
    238a:	|         clr.l -(sp)
    238c:	|         move.l d0,-(sp)
    238e:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xffff090f>
    2392:	|         pea 52 <_start+0x52>
    2396:	|         movea.l 28(sp),a0
    239a:	|         jsr (a0)
    239c:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_cycle_exact false" : "cpu_cycle_exact true", 0, &outbuf, 1);
    23a0:	|         tst.l 12(sp)
    23a4:	|  /----- beq.s 23ae <warpmode+0x66>
    23a6:	|  |      move.l #17663,d0
    23ac:	|  |  /-- bra.s 23b4 <warpmode+0x6c>
    23ae:	|  \--|-> move.l #17685,d0
    23b4:	|     \-> pea 1 <_start+0x1>
    23b8:	|         move.l sp,d1
    23ba:	|         addq.l #7,d1
    23bc:	|         move.l d1,-(sp)
    23be:	|         clr.l -(sp)
    23c0:	|         move.l d0,-(sp)
    23c2:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xffff090f>
    23c6:	|         pea 52 <_start+0x52>
    23ca:	|         movea.l 28(sp),a0
    23ce:	|         jsr (a0)
    23d0:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_memory_cycle_exact false" : "cpu_memory_cycle_exact true", 0, &outbuf, 1);
    23d4:	|         tst.l 12(sp)
    23d8:	|  /----- beq.s 23e2 <warpmode+0x9a>
    23da:	|  |      move.l #17706,d0
    23e0:	|  |  /-- bra.s 23e8 <warpmode+0xa0>
    23e2:	|  \--|-> move.l #17735,d0
    23e8:	|     \-> pea 1 <_start+0x1>
    23ec:	|         move.l sp,d1
    23ee:	|         addq.l #7,d1
    23f0:	|         move.l d1,-(sp)
    23f2:	|         clr.l -(sp)
    23f4:	|         move.l d0,-(sp)
    23f6:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xffff090f>
    23fa:	|         pea 52 <_start+0x52>
    23fe:	|         movea.l 28(sp),a0
    2402:	|         jsr (a0)
    2404:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
    2408:	|         tst.l 12(sp)
    240c:	|  /----- beq.s 2416 <warpmode+0xce>
    240e:	|  |      move.l #17763,d0
    2414:	|  |  /-- bra.s 241c <warpmode+0xd4>
    2416:	|  \--|-> move.l #17789,d0
    241c:	|     \-> pea 1 <_start+0x1>
    2420:	|         move.l sp,d1
    2422:	|         addq.l #7,d1
    2424:	|         move.l d1,-(sp)
    2426:	|         clr.l -(sp)
    2428:	|         move.l d0,-(sp)
    242a:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xffff090f>
    242e:	|         pea 52 <_start+0x52>
    2432:	|         movea.l 28(sp),a0
    2436:	|         jsr (a0)
    2438:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
    243c:	|         tst.l 12(sp)
    2440:	|  /----- beq.s 244a <warpmode+0x102>
    2442:	|  |      move.l #17814,d0
    2448:	|  |  /-- bra.s 2450 <warpmode+0x108>
    244a:	|  \--|-> move.l #17824,d0
    2450:	|     \-> pea 1 <_start+0x1>
    2454:	|         move.l sp,d1
    2456:	|         addq.l #7,d1
    2458:	|         move.l d1,-(sp)
    245a:	|         clr.l -(sp)
    245c:	|         move.l d0,-(sp)
    245e:	|         pea ffffffff <gcc8_c_support.c.af0a41ba+0xffff090f>
    2462:	|         pea 52 <_start+0x52>
    2466:	|         movea.l 28(sp),a0
    246a:	|         jsr (a0)
    246c:	|         lea 24(sp),sp
	}
}
    2470:	\-------> nop
    2472:	          addq.l #8,sp
    2474:	          rts

00002476 <debug_cmd>:

static void debug_cmd(unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4) {
    2476:	       subq.l #4,sp
	long(*UaeLib)(unsigned int arg0, unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4);
	UaeLib = (long(*)(unsigned int, unsigned int, unsigned int, unsigned int, unsigned int))0xf0ff60;
    2478:	       move.l #15794016,(sp)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
    247e:	       movea.l (sp),a0
    2480:	       move.w (a0),d0
    2482:	       cmpi.w #20153,d0
    2486:	   /-- beq.s 2492 <debug_cmd+0x1c>
    2488:	   |   movea.l (sp),a0
    248a:	   |   move.w (a0),d0
    248c:	   |   cmpi.w #-24562,d0
    2490:	/--|-- bne.s 24b0 <debug_cmd+0x3a>
		UaeLib(88, arg1, arg2, arg3, arg4);
    2492:	|  \-> move.l 20(sp),-(sp)
    2496:	|      move.l 20(sp),-(sp)
    249a:	|      move.l 20(sp),-(sp)
    249e:	|      move.l 20(sp),-(sp)
    24a2:	|      pea 58 <_start+0x58>
    24a6:	|      movea.l 20(sp),a0
    24aa:	|      jsr (a0)
    24ac:	|      lea 20(sp),sp
	}
}
    24b0:	\----> nop
    24b2:	       addq.l #4,sp
    24b4:	       rts

000024b6 <debug_start_idle>:
	debug_cmd(barto_cmd_text, (((unsigned int)left) << 16) | ((unsigned int)top), (unsigned int)text, color);
}

// profiler
void debug_start_idle() {
	debug_cmd(barto_cmd_set_idle, 1, 0, 0);
    24b6:	clr.l -(sp)
    24b8:	clr.l -(sp)
    24ba:	pea 1 <_start+0x1>
    24be:	pea 5 <_start+0x5>
    24c2:	jsr 2476 <debug_cmd>
    24c8:	lea 16(sp),sp
}
    24cc:	nop
    24ce:	rts

000024d0 <debug_stop_idle>:

void debug_stop_idle() {
	debug_cmd(barto_cmd_set_idle, 0, 0, 0);
    24d0:	clr.l -(sp)
    24d2:	clr.l -(sp)
    24d4:	clr.l -(sp)
    24d6:	pea 5 <_start+0x5>
    24da:	jsr 2476 <debug_cmd>
    24e0:	lea 16(sp),sp
}
    24e4:	nop
    24e6:	rts

000024e8 <__udivsi3>:
	.section .text.__udivsi3,"ax",@progbits
	.type __udivsi3, function
	.globl	__udivsi3
__udivsi3:
	.cfi_startproc
	movel	d2, sp@-
    24e8:	       move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
    24ea:	       move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
    24ee:	       move.l 8(sp),d0

	cmpl	#0x10000, d1 /* divisor >= 2 ^ 16 ?   */
    24f2:	       cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
    24f8:	   /-- bcc.s 2510 <__udivsi3+0x28>
	movel	d0, d2
    24fa:	   |   move.l d0,d2
	clrw	d2
    24fc:	   |   clr.w d2
	swap	d2
    24fe:	   |   swap d2
	divu	d1, d2          /* high quotient in lower word */
    2500:	   |   divu.w d1,d2
	movew	d2, d0		/* save high quotient */
    2502:	   |   move.w d2,d0
	swap	d0
    2504:	   |   swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
    2506:	   |   move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
    250a:	   |   divu.w d1,d2
	movew	d2, d0
    250c:	   |   move.w d2,d0
	jra	6f
    250e:	/--|-- bra.s 2540 <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
    2510:	|  \-> move.l d1,d2
4:	lsrl	#1, d1	/* shift divisor */
    2512:	|  /-> lsr.l #1,d1
	lsrl	#1, d0	/* shift dividend */
    2514:	|  |   lsr.l #1,d0
	cmpl	#0x10000, d1 /* still divisor >= 2 ^ 16 ?  */
    2516:	|  |   cmpi.l #65536,d1
	jcc	4b
    251c:	|  \-- bcc.s 2512 <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
    251e:	|      divu.w d1,d0
	andl	#0xffff, d0 /* mask out divisor, ignore remainder */
    2520:	|      andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
    2526:	|      move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
    2528:	|      mulu.w d0,d1
	swap	d2
    252a:	|      swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
    252c:	|      mulu.w d0,d2
	swap	d2		/* align high part with low part */
    252e:	|      swap d2
	tstw	d2		/* high part 17 bits? */
    2530:	|      tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
    2532:	|  /-- bne.s 253e <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
    2534:	|  |   add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
    2536:	|  +-- bcs.s 253e <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
    2538:	|  |   cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
    253c:	+--|-- bls.s 2540 <__udivsi3+0x58>
5:	subql	#1, d0	/* adjust quotient */
    253e:	|  \-> subq.l #1,d0

6:	movel	sp@+, d2
    2540:	\----> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    2542:	       rts

00002544 <__divsi3>:
	.section .text.__divsi3,"ax",@progbits
	.type __divsi3, function
	.globl	__divsi3
 __divsi3:
 	.cfi_startproc
	movel	d2, sp@-
    2544:	    move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	#1, d2	/* sign of result stored in d2 (=1 or =-1) */
    2546:	    moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
    2548:	    move.l 12(sp),d1
	jpl	1f
    254c:	/-- bpl.s 2552 <__divsi3+0xe>
	negl	d1
    254e:	|   neg.l d1
	negb	d2		/* change sign because divisor <0  */
    2550:	|   neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
    2552:	\-> move.l 8(sp),d0
	jpl	2f
    2556:	/-- bpl.s 255c <__divsi3+0x18>
	negl	d0
    2558:	|   neg.l d0
	negb	d2
    255a:	|   neg.b d2

2:	movel	d1, sp@-
    255c:	\-> move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    255e:	    move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__udivsi3	/* divide abs(dividend) by abs(divisor) */
    2560:	    jsr 24e8 <__udivsi3>
	addql	#8, sp
    2566:	    addq.l #8,sp
	.cfi_adjust_cfa_offset -8

	tstb	d2
    2568:	    tst.b d2
	jpl	3f
    256a:	/-- bpl.s 256e <__divsi3+0x2a>
	negl	d0
    256c:	|   neg.l d0

3:	movel	sp@+, d2
    256e:	\-> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    2570:	    rts

00002572 <KPutCharX>:
	.type KPutCharX, function
	.globl	KPutCharX

KPutCharX:
	.cfi_startproc
    move.l  a6, -(sp)
    2572:	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
    2574:	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
    2578:	jsr -516(a6)
    move.l (sp)+, a6
    257c:	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
    257e:	rts

00002580 <PutChar>:
	.type PutChar, function
	.globl	PutChar

PutChar:
	.cfi_startproc
	move.b d0, (a3)+
    2580:	move.b d0,(a3)+
	rts
    2582:	rts
