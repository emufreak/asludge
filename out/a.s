
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
       2:	       move.l #16384,d0
       8:	       subi.l #16384,d0
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
      22:	|  |   lea 4000 <player>,a0
      28:	|  |   movea.l (0,a1,a0.l),a0
      2c:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      2e:	|  |   addq.l #1,4(sp)
      32:	|  \-> move.l 4(sp),d0
      36:	|      cmp.l (sp),d0
      38:	\----- bcs.s 18 <_start+0x18>

	count = __init_array_end - __init_array_start;
      3a:	       move.l #16384,d0
      40:	       subi.l #16384,d0
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
      5a:	|  |   lea 4000 <player>,a0
      60:	|  |   movea.l (0,a1,a0.l),a0
      64:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      66:	|  |   addq.l #1,4(sp)
      6a:	|  \-> move.l 4(sp),d0
      6e:	|      cmp.l (sp),d0
      70:	\----- bcs.s 50 <_start+0x50>

	main();
      72:	       jsr 5ca <main>

	// call dtors
	count = __fini_array_end - __fini_array_start;
      78:	       move.l #16384,d0
      7e:	       subi.l #16384,d0
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
      9a:	|  |   lea 4000 <player>,a0
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

int numBIFNames = 0;
char * * allBIFNames = NULL;
int numUserFunc = 0;

BOOL initSludge (char * filename) {
      b8:	          lea -32(sp),sp
      bc:	          move.l a6,-(sp)
	int a = 0;
      be:	          clr.l 28(sp)
	mouseCursorAnim = makeNullAnim ();
      c2:	          jsr 77e <makeNullAnim>
      c8:	          move.l d0,54b2 <mouseCursorAnim>

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, gameVersion);
      ce:	          move.l 548a <gameVersion>,d0
      d4:	          move.l d0,-(sp)
      d6:	          pea 1042 <PutChar+0x4>
      dc:	          pea 45 <_start+0x45>
      e0:	          pea 47 <_start+0x47>
      e4:	          move.l 56(sp),-(sp)
      e8:	          jsr 1bc <openAndVerify>
      ee:	          lea 20(sp),sp
      f2:	          move.l d0,24(sp)
	if (! fp) return FALSE;
      f6:	      /-- bne.s fe <initSludge+0x46>
      f8:	      |   clr.w d0
      fa:	/-----|-- bra.w 1b4 <initSludge+0xfc>
	if (FGetC (fp)) {
      fe:	|     \-> move.l 24(sp),20(sp)
     104:	|         move.l 54a2 <DOSBase>,d0
     10a:	|         movea.l d0,a6
     10c:	|         move.l 20(sp),d1
     110:	|         jsr -306(a6)
     114:	|         move.l d0,16(sp)
     118:	|         move.l 16(sp),d0
     11c:	+-------- beq.w 1b4 <initSludge+0xfc>
		numBIFNames = get2bytes (fp);
     120:	|         move.l 24(sp),-(sp)
     124:	|         jsr 7e4 <get2bytes>
     12a:	|         addq.l #4,sp
     12c:	|         move.l d0,548e <numBIFNames>
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
     132:	|         move.l 548e <numBIFNames>,d0
     138:	|         move.l d0,12(sp)
     13c:	|         clr.l 8(sp)
     140:	|         move.l 549a <SysBase>,d0
     146:	|         movea.l d0,a6
     148:	|         move.l 12(sp),d0
     14c:	|         move.l 8(sp),d1
     150:	|         jsr -684(a6)
     154:	|         move.l d0,4(sp)
     158:	|         move.l 4(sp),d0
     15c:	|         move.l d0,5492 <allBIFNames>
		if(allBIFNames == 0) return FALSE;
     162:	|         move.l 5492 <allBIFNames>,d0
     168:	|     /-- bne.s 16e <initSludge+0xb6>
     16a:	|     |   clr.w d0
     16c:	+-----|-- bra.s 1b4 <initSludge+0xfc>
		for (int fn = 0; fn < numBIFNames; fn ++) {
     16e:	|     \-> clr.l 32(sp)
     172:	|     /-- bra.s 196 <initSludge+0xde>
			allBIFNames[fn] = readString (fp);
     174:	|  /--|-> move.l 24(sp),-(sp)
     178:	|  |  |   jsr 840 <readString>
     17e:	|  |  |   addq.l #4,sp
     180:	|  |  |   movea.l 5492 <allBIFNames>,a0
     186:	|  |  |   move.l 32(sp),d1
     18a:	|  |  |   add.l d1,d1
     18c:	|  |  |   add.l d1,d1
     18e:	|  |  |   adda.l d1,a0
     190:	|  |  |   move.l d0,(a0)
		for (int fn = 0; fn < numBIFNames; fn ++) {
     192:	|  |  |   addq.l #1,32(sp)
     196:	|  |  \-> move.l 548e <numBIFNames>,d0
     19c:	|  |      cmp.l 32(sp),d0
     1a0:	|  \----- bgt.s 174 <initSludge+0xbc>
		}
		numUserFunc = get2bytes (fp);
     1a2:	|         move.l 24(sp),-(sp)
     1a6:	|         jsr 7e4 <get2bytes>
     1ac:	|         addq.l #4,sp
     1ae:	|         move.l d0,5496 <numUserFunc>
	}
}
     1b4:	\-------> movea.l (sp)+,a6
     1b6:	          lea 32(sp),sp
     1ba:	          rts

000001bc <openAndVerify>:

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int fileVersion) {
     1bc:	       lea -312(sp),sp
     1c0:	       movem.l d2-d3/a6,-(sp)
     1c4:	       move.l 332(sp),d1
     1c8:	       move.l 336(sp),d0
     1cc:	       move.b d1,d1
     1ce:	       move.b d1,16(sp)
     1d2:	       move.b d0,d0
     1d4:	       move.b d0,14(sp)
	BPTR fp = Open(filename,MODE_OLDFILE);
     1d8:	       move.l 328(sp),318(sp)
     1de:	       move.l #1005,314(sp)
     1e6:	       move.l 54a2 <DOSBase>,d0
     1ec:	       movea.l d0,a6
     1ee:	       move.l 318(sp),d1
     1f2:	       move.l 314(sp),d2
     1f6:	       jsr -30(a6)
     1fa:	       move.l d0,310(sp)
     1fe:	       move.l 310(sp),d0
     202:	       move.l d0,306(sp)

	if (! fp) {
     206:	   /-- bne.s 262 <openAndVerify+0xa6>
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
     208:	   |   move.l 54a2 <DOSBase>,d0
     20e:	   |   movea.l d0,a6
     210:	   |   jsr -60(a6)
     214:	   |   move.l d0,154(sp)
     218:	   |   move.l 154(sp),d0
     21c:	   |   move.l d0,150(sp)
     220:	   |   move.l #4219,146(sp)
     228:	   |   moveq #31,d0
     22a:	   |   move.l d0,142(sp)
     22e:	   |   move.l 54a2 <DOSBase>,d0
     234:	   |   movea.l d0,a6
     236:	   |   move.l 150(sp),d1
     23a:	   |   move.l 146(sp),d2
     23e:	   |   move.l 142(sp),d3
     242:	   |   jsr -48(a6)
     246:	   |   move.l d0,138(sp)
		KPrintF("openAndVerify: Can't open file", filename);
     24a:	   |   move.l 328(sp),-(sp)
     24e:	   |   pea 109b <PutChar+0x5d>
     254:	   |   jsr e26 <KPrintF>
     25a:	   |   addq.l #8,sp
		return NULL;
     25c:	   |   moveq #0,d0
     25e:	/--|-- bra.w 51a <openAndVerify+0x35e>
	}
	BOOL headerBad = FALSE;
     262:	|  \-> clr.w 322(sp)
	if (FGetC (fp) != 'S') headerBad = TRUE;
     266:	|      move.l 306(sp),302(sp)
     26c:	|      move.l 54a2 <DOSBase>,d0
     272:	|      movea.l d0,a6
     274:	|      move.l 302(sp),d1
     278:	|      jsr -306(a6)
     27c:	|      move.l d0,298(sp)
     280:	|      move.l 298(sp),d0
     284:	|      moveq #83,d1
     286:	|      cmp.l d0,d1
     288:	|  /-- beq.s 290 <openAndVerify+0xd4>
     28a:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'L') headerBad = TRUE;
     290:	|  \-> move.l 306(sp),294(sp)
     296:	|      move.l 54a2 <DOSBase>,d0
     29c:	|      movea.l d0,a6
     29e:	|      move.l 294(sp),d1
     2a2:	|      jsr -306(a6)
     2a6:	|      move.l d0,290(sp)
     2aa:	|      move.l 290(sp),d0
     2ae:	|      moveq #76,d1
     2b0:	|      cmp.l d0,d1
     2b2:	|  /-- beq.s 2ba <openAndVerify+0xfe>
     2b4:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'U') headerBad = TRUE;
     2ba:	|  \-> move.l 306(sp),286(sp)
     2c0:	|      move.l 54a2 <DOSBase>,d0
     2c6:	|      movea.l d0,a6
     2c8:	|      move.l 286(sp),d1
     2cc:	|      jsr -306(a6)
     2d0:	|      move.l d0,282(sp)
     2d4:	|      move.l 282(sp),d0
     2d8:	|      moveq #85,d1
     2da:	|      cmp.l d0,d1
     2dc:	|  /-- beq.s 2e4 <openAndVerify+0x128>
     2de:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'D') headerBad = TRUE;
     2e4:	|  \-> move.l 306(sp),278(sp)
     2ea:	|      move.l 54a2 <DOSBase>,d0
     2f0:	|      movea.l d0,a6
     2f2:	|      move.l 278(sp),d1
     2f6:	|      jsr -306(a6)
     2fa:	|      move.l d0,274(sp)
     2fe:	|      move.l 274(sp),d0
     302:	|      moveq #68,d1
     304:	|      cmp.l d0,d1
     306:	|  /-- beq.s 30e <openAndVerify+0x152>
     308:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra1) headerBad = TRUE;
     30e:	|  \-> move.l 306(sp),270(sp)
     314:	|      move.l 54a2 <DOSBase>,d0
     31a:	|      movea.l d0,a6
     31c:	|      move.l 270(sp),d1
     320:	|      jsr -306(a6)
     324:	|      move.l d0,266(sp)
     328:	|      move.l 266(sp),d1
     32c:	|      move.b 16(sp),d0
     330:	|      ext.w d0
     332:	|      movea.w d0,a0
     334:	|      cmpa.l d1,a0
     336:	|  /-- beq.s 33e <openAndVerify+0x182>
     338:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra2) headerBad = TRUE;
     33e:	|  \-> move.l 306(sp),262(sp)
     344:	|      move.l 54a2 <DOSBase>,d0
     34a:	|      movea.l d0,a6
     34c:	|      move.l 262(sp),d1
     350:	|      jsr -306(a6)
     354:	|      move.l d0,258(sp)
     358:	|      move.l 258(sp),d1
     35c:	|      move.b 14(sp),d0
     360:	|      ext.w d0
     362:	|      movea.w d0,a0
     364:	|      cmpa.l d1,a0
     366:	|  /-- beq.s 36e <openAndVerify+0x1b2>
     368:	|  |   move.w #1,322(sp)
	if (headerBad) {
     36e:	|  \-> tst.w 322(sp)
     372:	|  /-- beq.s 3ca <openAndVerify+0x20e>
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
     374:	|  |   move.l 54a2 <DOSBase>,d0
     37a:	|  |   movea.l d0,a6
     37c:	|  |   jsr -60(a6)
     380:	|  |   move.l d0,174(sp)
     384:	|  |   move.l 174(sp),d0
     388:	|  |   move.l d0,170(sp)
     38c:	|  |   move.l #4282,166(sp)
     394:	|  |   moveq #31,d0
     396:	|  |   move.l d0,162(sp)
     39a:	|  |   move.l 54a2 <DOSBase>,d0
     3a0:	|  |   movea.l d0,a6
     3a2:	|  |   move.l 170(sp),d1
     3a6:	|  |   move.l 166(sp),d2
     3aa:	|  |   move.l 162(sp),d3
     3ae:	|  |   jsr -48(a6)
     3b2:	|  |   move.l d0,158(sp)
		KPrintF("openAndVerify: Bad Header\n");
     3b6:	|  |   pea 10ba <PutChar+0x7c>
     3bc:	|  |   jsr e26 <KPrintF>
     3c2:	|  |   addq.l #4,sp
		return NULL;
     3c4:	|  |   moveq #0,d0
     3c6:	+--|-- bra.w 51a <openAndVerify+0x35e>
	}
	FGetC (fp);
     3ca:	|  \-> move.l 306(sp),254(sp)
     3d0:	|      move.l 54a2 <DOSBase>,d0
     3d6:	|      movea.l d0,a6
     3d8:	|      move.l 254(sp),d1
     3dc:	|      jsr -306(a6)
     3e0:	|      move.l d0,250(sp)
	while (FGetC(fp)) {;}
     3e4:	|      nop
     3e6:	|  /-> move.l 306(sp),246(sp)
     3ec:	|  |   move.l 54a2 <DOSBase>,d0
     3f2:	|  |   movea.l d0,a6
     3f4:	|  |   move.l 246(sp),d1
     3f8:	|  |   jsr -306(a6)
     3fc:	|  |   move.l d0,242(sp)
     400:	|  |   move.l 242(sp),d0
     404:	|  \-- bne.s 3e6 <openAndVerify+0x22a>

	int majVersion = FGetC (fp);
     406:	|      move.l 306(sp),238(sp)
     40c:	|      move.l 54a2 <DOSBase>,d0
     412:	|      movea.l d0,a6
     414:	|      move.l 238(sp),d1
     418:	|      jsr -306(a6)
     41c:	|      move.l d0,234(sp)
     420:	|      move.l 234(sp),d0
     424:	|      move.l d0,230(sp)
	int minVersion = FGetC (fp);
     428:	|      move.l 306(sp),226(sp)
     42e:	|      move.l 54a2 <DOSBase>,d0
     434:	|      movea.l d0,a6
     436:	|      move.l 226(sp),d1
     43a:	|      jsr -306(a6)
     43e:	|      move.l d0,222(sp)
     442:	|      move.l 222(sp),d0
     446:	|      move.l d0,218(sp)
	fileVersion = majVersion * 256 + minVersion;
     44a:	|      move.l 230(sp),d0
     44e:	|      lsl.l #8,d0
     450:	|      move.l 218(sp),d1
     454:	|      add.l d0,d1
     456:	|      move.l d1,344(sp)

	char txtVer[120];

	if (fileVersion > WHOLE_VERSION) {
     45a:	|      cmpi.l #514,344(sp)
     462:	|  /-- ble.s 4b8 <openAndVerify+0x2fc>
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
     464:	|  |   move.l 54a2 <DOSBase>,d0
     46a:	|  |   movea.l d0,a6
     46c:	|  |   jsr -60(a6)
     470:	|  |   move.l d0,194(sp)
     474:	|  |   move.l 194(sp),d0
     478:	|  |   move.l d0,190(sp)
     47c:	|  |   move.l #4309,186(sp)
     484:	|  |   moveq #100,d0
     486:	|  |   move.l d0,182(sp)
     48a:	|  |   move.l 54a2 <DOSBase>,d0
     490:	|  |   movea.l d0,a6
     492:	|  |   move.l 190(sp),d1
     496:	|  |   move.l 186(sp),d2
     49a:	|  |   move.l 182(sp),d3
     49e:	|  |   jsr -48(a6)
     4a2:	|  |   move.l d0,178(sp)
		KPrintF(ERROR_VERSION_TOO_LOW_1);
     4a6:	|  |   pea 10d5 <PutChar+0x97>
     4ac:	|  |   jsr e26 <KPrintF>
     4b2:	|  |   addq.l #4,sp
		return NULL;
     4b4:	|  |   moveq #0,d0
     4b6:	+--|-- bra.s 51a <openAndVerify+0x35e>
	} else if (fileVersion < MINIM_VERSION) {
     4b8:	|  \-> cmpi.l #257,344(sp)
     4c0:	|  /-- bgt.s 516 <openAndVerify+0x35a>
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
     4c2:	|  |   move.l 54a2 <DOSBase>,d0
     4c8:	|  |   movea.l d0,a6
     4ca:	|  |   jsr -60(a6)
     4ce:	|  |   move.l d0,214(sp)
     4d2:	|  |   move.l 214(sp),d0
     4d6:	|  |   move.l d0,210(sp)
     4da:	|  |   move.l #4378,206(sp)
     4e2:	|  |   moveq #100,d1
     4e4:	|  |   move.l d1,202(sp)
     4e8:	|  |   move.l 54a2 <DOSBase>,d0
     4ee:	|  |   movea.l d0,a6
     4f0:	|  |   move.l 210(sp),d1
     4f4:	|  |   move.l 206(sp),d2
     4f8:	|  |   move.l 202(sp),d3
     4fc:	|  |   jsr -48(a6)
     500:	|  |   move.l d0,198(sp)
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
     504:	|  |   pea 111a <PutChar+0xdc>
     50a:	|  |   jsr e26 <KPrintF>
     510:	|  |   addq.l #4,sp
		return NULL;
     512:	|  |   moveq #0,d0
     514:	+--|-- bra.s 51a <openAndVerify+0x35e>
	}
	return fp;
     516:	|  \-> move.l 306(sp),d0
     51a:	\----> movem.l (sp)+,d2-d3/a6
     51e:	       lea 312(sp),sp
     522:	       rts

00000524 <WaitVbl>:
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
}

//vblank begins at vpos 312 hpos 1 and ends at vpos 25 hpos 1
//vsync begins at line 2 hpos 132 and ends at vpos 5 hpos 18 
void WaitVbl() {
     524:	       subq.l #8,sp
	debug_start_idle();
     526:	       jsr ffe <debug_start_idle>
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
     52c:	   /-> movea.l #14675972,a0
     532:	   |   move.l (a0),d0
     534:	   |   move.l d0,(sp)
		vpos&=0x1ff00;
     536:	   |   move.l (sp),d0
     538:	   |   andi.l #130816,d0
     53e:	   |   move.l d0,(sp)
		if (vpos!=(311<<8))
     540:	   |   move.l (sp),d0
     542:	   |   cmpi.l #79616,d0
     548:	   \-- beq.s 52c <WaitVbl+0x8>
			break;
	}
	while (1) {
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
     54a:	/----> movea.l #14675972,a0
     550:	|      move.l (a0),d0
     552:	|      move.l d0,4(sp)
		vpos&=0x1ff00;
     556:	|      move.l 4(sp),d0
     55a:	|      andi.l #130816,d0
     560:	|      move.l d0,4(sp)
		if (vpos==(311<<8))
     564:	|      move.l 4(sp),d0
     568:	|      cmpi.l #79616,d0
     56e:	|  /-- beq.s 572 <WaitVbl+0x4e>
	while (1) {
     570:	\--|-- bra.s 54a <WaitVbl+0x26>
			break;
     572:	   \-> nop
	}
	debug_stop_idle();
     574:	       jsr 1018 <debug_stop_idle>
}
     57a:	       nop
     57c:	       addq.l #8,sp
     57e:	       rts

00000580 <p61Init>:
	// The Player® 6.1A: Copyright © 1992-95 Jarno Paananen
	// P61.testmod - Module by Skylord/Sector 7 
	INCBIN(player, "player610.6.no_cia.bin")
	INCBIN_CHIP(module, "testmod.p61")

	int p61Init(const void* module) { // returns 0 if success, non-zero otherwise
     580:	move.l a3,-(sp)
     582:	move.l a2,-(sp)
		register volatile const void* _a0 ASM("a0") = module;
     584:	movea.l 12(sp),a0
		register volatile const void* _a1 ASM("a1") = NULL;
     588:	suba.l a1,a1
		register volatile const void* _a2 ASM("a2") = NULL;
     58a:	suba.l a2,a2
		register volatile const void* _a3 ASM("a3") = player;
     58c:	move.l 4000 <player>,d0
     592:	movea.l d0,a3
		register                int   _d0 ASM("d0"); // return value
		__asm volatile (
     594:	movem.l d1-d7/a4-a6,-(sp)
     598:	jsr (a3)
     59a:	movem.l (sp)+,d1-d7/a4-a6
			"movem.l (%%sp)+,%%d1-%%d7/%%a4-%%a6"
		: "=r" (_d0), "+rf"(_a0), "+rf"(_a1), "+rf"(_a2), "+rf"(_a3)
		:
		: "cc", "memory");
		return _d0;
	}
     59e:	movea.l (sp)+,a2
     5a0:	movea.l (sp)+,a3
     5a2:	rts

000005a4 <p61End>:
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}

	void p61End() {
     5a4:	move.l a6,-(sp)
     5a6:	move.l a3,-(sp)
		register volatile const void* _a3 ASM("a3") = player;
     5a8:	move.l 4000 <player>,d0
     5ae:	movea.l d0,a3
		register volatile const void* _a6 ASM("a6") = (void*)0xdff000;
     5b0:	movea.l #14675968,a6
		__asm volatile (
     5b6:	movem.l d0-d1/a0-a1,-(sp)
     5ba:	jsr 8(a3)
     5be:	movem.l (sp)+,d0-d1/a0-a1
			"jsr 8(%%a3)\n"
			"movem.l (%%sp)+,%%d0-%%d1/%%a0-%%a1"
		: "+rf"(_a3), "+rf"(_a6)
		:
		: "cc", "memory");
	}
     5c2:	nop
     5c4:	movea.l (sp)+,a3
     5c6:	movea.l (sp)+,a6
     5c8:	rts

000005ca <main>:
static void Wait10() { WaitLine(0x10); }
static void Wait11() { WaitLine(0x11); }
static void Wait12() { WaitLine(0x12); }
static void Wait13() { WaitLine(0x13); }

int main(int argc, char *argv[]) {
     5ca:	    lea -64(sp),sp
     5ce:	    movem.l d2-d3/a6,-(sp)
	SysBase = *((struct ExecBase**)4UL);
     5d2:	    movea.w #4,a0
     5d6:	    move.l (a0),d0
     5d8:	    move.l d0,549a <SysBase>
	custom = (struct Custom*)0xdff000;
     5de:	    move.l #14675968,549e <custom>

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR)"graphics.library",0);
     5e8:	    move.l #10953,72(sp)
     5f0:	    clr.l 68(sp)
     5f4:	    move.l 549a <SysBase>,d0
     5fa:	    movea.l d0,a6
     5fc:	    movea.l 72(sp),a1
     600:	    move.l 68(sp),d0
     604:	    jsr -552(a6)
     608:	    move.l d0,64(sp)
     60c:	    move.l 64(sp),d0
     610:	    move.l d0,54a6 <GfxBase>
	if (!GfxBase)
     616:	    move.l 54a6 <GfxBase>,d0
     61c:	/-- bne.s 632 <main+0x68>
		Exit(0);
     61e:	|   clr.l 60(sp)
     622:	|   move.l 54a2 <DOSBase>,d0
     628:	|   movea.l d0,a6
     62a:	|   move.l 60(sp),d1
     62e:	|   jsr -144(a6)

	// used for printing
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
     632:	\-> move.l #10970,56(sp)
     63a:	    clr.l 52(sp)
     63e:	    move.l 549a <SysBase>,d0
     644:	    movea.l d0,a6
     646:	    movea.l 56(sp),a1
     64a:	    move.l 52(sp),d0
     64e:	    jsr -552(a6)
     652:	    move.l d0,48(sp)
     656:	    move.l 48(sp),d0
     65a:	    move.l d0,54a2 <DOSBase>
	if (!DOSBase)
     660:	    move.l 54a2 <DOSBase>,d0
     666:	/-- bne.s 67c <main+0xb2>
		Exit(0);
     668:	|   clr.l 44(sp)
     66c:	|   move.l 54a2 <DOSBase>,d0
     672:	|   movea.l d0,a6
     674:	|   move.l 44(sp),d1
     678:	|   jsr -144(a6)

	KPrintF("Hello debugger from Amiga!\n");
     67c:	\-> pea 2ae6 <incbin_player_end+0x1e>
     682:	    jsr e26 <KPrintF>
     688:	    addq.l #4,sp

	Write(Output(), (APTR)"Hello console!\n", 15);
     68a:	    move.l 54a2 <DOSBase>,d0
     690:	    movea.l d0,a6
     692:	    jsr -60(a6)
     696:	    move.l d0,40(sp)
     69a:	    move.l 40(sp),d0
     69e:	    move.l d0,36(sp)
     6a2:	    move.l #11010,32(sp)
     6aa:	    moveq #15,d0
     6ac:	    move.l d0,28(sp)
     6b0:	    move.l 54a2 <DOSBase>,d0
     6b6:	    movea.l d0,a6
     6b8:	    move.l 36(sp),d1
     6bc:	    move.l 32(sp),d2
     6c0:	    move.l 28(sp),d3
     6c4:	    jsr -48(a6)
     6c8:	    move.l d0,24(sp)
	Delay(50);
     6cc:	    moveq #50,d0
     6ce:	    move.l d0,20(sp)
     6d2:	    move.l 54a2 <DOSBase>,d0
     6d8:	    movea.l d0,a6
     6da:	    move.l 20(sp),d1
     6de:	    jsr -198(a6)

	warpmode(1);
     6e2:	    pea 1 <_start+0x1>
     6e6:	    jsr e90 <warpmode>
     6ec:	    addq.l #4,sp
	// TODO: precalc stuff here
#ifdef MUSIC
	if(p61Init(module) != 0)
     6ee:	    move.l 4004 <module>,d0
     6f4:	    move.l d0,-(sp)
     6f6:	    jsr 580 <p61Init>
     6fc:	    addq.l #4,sp
     6fe:	    tst.l d0
     700:	/-- beq.s 710 <main+0x146>
		KPrintF("p61Init failed!\n");
     702:	|   pea 2b12 <incbin_player_end+0x4a>
     708:	|   jsr e26 <KPrintF>
     70e:	|   addq.l #4,sp
#endif
	warpmode(0);
     710:	\-> clr.l -(sp)
     712:	    jsr e90 <warpmode>
     718:	    addq.l #4,sp

	//TakeSystem();
	custom->dmacon = 0x87ff;
     71a:	    movea.l 549e <custom>,a0
     720:	    move.w #-30721,150(a0)
	WaitVbl();
     726:	    jsr 524 <WaitVbl>

	main_sludge(argc, argv);
     72c:	    move.l 84(sp),-(sp)
     730:	    move.l 84(sp),-(sp)
     734:	    jsr a46 <main_sludge>
     73a:	    addq.l #8,sp
	debug_register_copperlist(copper2, "copper2", sizeof(copper2), 0);*/



#ifdef MUSIC
	p61End();
     73c:	    jsr 5a4 <p61End>
#endif

	// END
	//FreeSystem();

	CloseLibrary((struct Library*)DOSBase);
     742:	    move.l 54a2 <DOSBase>,16(sp)
     74a:	    move.l 549a <SysBase>,d0
     750:	    movea.l d0,a6
     752:	    movea.l 16(sp),a1
     756:	    jsr -414(a6)
	CloseLibrary((struct Library*)GfxBase);
     75a:	    move.l 54a6 <GfxBase>,12(sp)
     762:	    move.l 549a <SysBase>,d0
     768:	    movea.l d0,a6
     76a:	    movea.l 12(sp),a1
     76e:	    jsr -414(a6)
     772:	    moveq #0,d0
}
     774:	    movem.l (sp)+,d2-d3/a6
     778:	    lea 64(sp),sp
     77c:	    rts

0000077e <makeNullAnim>:
#include <proto/exec.h>

#include "people.h"

struct personaAnimation * makeNullAnim () {
     77e:	       lea -16(sp),sp
     782:	       move.l a6,-(sp)

	struct personaAnimation * newAnim	= AllocVec(sizeof(struct personaAnimation),MEMF_ANY);
     784:	       moveq #12,d0
     786:	       move.l d0,16(sp)
     78a:	       clr.l 12(sp)
     78e:	       move.l 549a <SysBase>,d0
     794:	       movea.l d0,a6
     796:	       move.l 16(sp),d0
     79a:	       move.l 12(sp),d1
     79e:	       jsr -684(a6)
     7a2:	       move.l d0,8(sp)
     7a6:	       move.l 8(sp),d0
     7aa:	       move.l d0,4(sp)
    if(newAnim == 0) {
     7ae:	   /-- bne.s 7c2 <makeNullAnim+0x44>
     	KPrintF("makeNullAnim: Can't reserve Memory\n");
     7b0:	   |   pea 2b23 <incbin_player_end+0x5b>
     7b6:	   |   jsr e26 <KPrintF>
     7bc:	   |   addq.l #4,sp
        return NULL;    
     7be:	   |   moveq #0,d0
     7c0:	/--|-- bra.s 7dc <makeNullAnim+0x5e>
    }  

	newAnim -> theSprites		= NULL;
     7c2:	|  \-> movea.l 4(sp),a0
     7c6:	|      clr.l (a0)
	newAnim -> numFrames		= 0;
     7c8:	|      movea.l 4(sp),a0
     7cc:	|      clr.l 8(a0)
	newAnim -> frames			= NULL;
     7d0:	|      movea.l 4(sp),a0
     7d4:	|      clr.l 4(a0)
	return newAnim;
     7d8:	|      move.l 4(sp),d0
}
     7dc:	\----> movea.l (sp)+,a6
     7de:	       lea 16(sp),sp
     7e2:	       rts

000007e4 <get2bytes>:
#include <proto/exec.h>
#include <proto/dos.h>

#include "moreio.h"

int get2bytes (BPTR fp) {
     7e4:	lea -24(sp),sp
     7e8:	move.l a6,-(sp)
	int f1, f2;

	f1 = FGetC (fp);
     7ea:	move.l 32(sp),24(sp)
     7f0:	move.l 54a2 <DOSBase>,d0
     7f6:	movea.l d0,a6
     7f8:	move.l 24(sp),d1
     7fc:	jsr -306(a6)
     800:	move.l d0,20(sp)
     804:	move.l 20(sp),d0
     808:	move.l d0,16(sp)
	f2 = FGetC (fp);
     80c:	move.l 32(sp),12(sp)
     812:	move.l 54a2 <DOSBase>,d0
     818:	movea.l d0,a6
     81a:	move.l 12(sp),d1
     81e:	jsr -306(a6)
     822:	move.l d0,8(sp)
     826:	move.l 8(sp),d0
     82a:	move.l d0,4(sp)

	return (f1 * 256 + f2);
     82e:	move.l 16(sp),d0
     832:	lsl.l #8,d0
     834:	add.l 4(sp),d0
}
     838:	movea.l (sp)+,a6
     83a:	lea 24(sp),sp
     83e:	rts

00000840 <readString>:

char * readString (BPTR fp) {
     840:	          lea -32(sp),sp
     844:	          move.l a6,-(sp)

	int a, len = get2bytes (fp);
     846:	          move.l 40(sp),-(sp)
     84a:	          jsr 7e4 <get2bytes>
     850:	          addq.l #4,sp
     852:	          move.l d0,28(sp)
	//debugOut ("MOREIO: readString - len %i\n", len);
	char * s = AllocVec(len+1,MEMF_ANY);
     856:	          move.l 28(sp),d0
     85a:	          addq.l #1,d0
     85c:	          move.l d0,24(sp)
     860:	          clr.l 20(sp)
     864:	          move.l 549a <SysBase>,d0
     86a:	          movea.l d0,a6
     86c:	          move.l 24(sp),d0
     870:	          move.l 20(sp),d1
     874:	          jsr -684(a6)
     878:	          move.l d0,16(sp)
     87c:	          move.l 16(sp),d0
     880:	          move.l d0,12(sp)
	if(s == 0) return NULL;
     884:	      /-- bne.s 88a <readString+0x4a>
     886:	      |   moveq #0,d0
     888:	/-----|-- bra.s 8e0 <readString+0xa0>
	for (a = 0; a < len; a ++) {
     88a:	|     \-> clr.l 32(sp)
     88e:	|     /-- bra.s 8c6 <readString+0x86>
		s[a] = (char) (FGetC (fp) - 1);
     890:	|  /--|-> move.l 40(sp),8(sp)
     896:	|  |  |   move.l 54a2 <DOSBase>,d0
     89c:	|  |  |   movea.l d0,a6
     89e:	|  |  |   move.l 8(sp),d1
     8a2:	|  |  |   jsr -306(a6)
     8a6:	|  |  |   move.l d0,4(sp)
     8aa:	|  |  |   move.l 4(sp),d0
     8ae:	|  |  |   move.l d0,d0
     8b0:	|  |  |   move.b d0,d1
     8b2:	|  |  |   subq.b #1,d1
     8b4:	|  |  |   move.l 32(sp),d0
     8b8:	|  |  |   movea.l 12(sp),a0
     8bc:	|  |  |   adda.l d0,a0
     8be:	|  |  |   move.b d1,d0
     8c0:	|  |  |   move.b d0,(a0)
	for (a = 0; a < len; a ++) {
     8c2:	|  |  |   addq.l #1,32(sp)
     8c6:	|  |  \-> move.l 32(sp),d0
     8ca:	|  |      cmp.l 28(sp),d0
     8ce:	|  \----- blt.s 890 <readString+0x50>
	}
	s[len] = 0;
     8d0:	|         move.l 28(sp),d0
     8d4:	|         movea.l 12(sp),a0
     8d8:	|         adda.l d0,a0
     8da:	|         clr.b (a0)
	//debugOut ("MOREIO: readString: %s\n", s);
	return s;
     8dc:	|         move.l 12(sp),d0
     8e0:	\-------> movea.l (sp)+,a6
     8e2:	          lea 32(sp),sp
     8e6:	          rts

000008e8 <strlen>:
#include <proto/exec.h>
#include <string.h>
#include "support/gcc8_c_support.h"

long unsigned int strlen (const char *s) 
{  
     8e8:	       subq.l #4,sp
	long unsigned int i = 0;
     8ea:	       clr.l (sp)
	while(s[i]) i++; 
     8ec:	   /-- bra.s 8f0 <strlen+0x8>
     8ee:	/--|-> addq.l #1,(sp)
     8f0:	|  \-> movea.l 8(sp),a0
     8f4:	|      adda.l (sp),a0
     8f6:	|      move.b (a0),d0
     8f8:	\----- bne.s 8ee <strlen+0x6>
	return(i);
     8fa:	       move.l (sp),d0
}
     8fc:	       addq.l #4,sp
     8fe:	       rts

00000900 <strcpy>:

char *strcpy(char *t, const char *s) 
{
	while(*t++ = *s++);
     900:	    nop
     902:	/-> move.l 8(sp),d0
     906:	|   move.l d0,d1
     908:	|   addq.l #1,d1
     90a:	|   move.l d1,8(sp)
     90e:	|   movea.l 4(sp),a0
     912:	|   lea 1(a0),a1
     916:	|   move.l a1,4(sp)
     91a:	|   movea.l d0,a1
     91c:	|   move.b (a1),d0
     91e:	|   move.b d0,(a0)
     920:	|   move.b (a0),d0
     922:	\-- bne.s 902 <strcpy+0x2>
}
     924:	    nop
     926:	    rts

00000928 <copyString>:

char * copyString (const char * copyMe) {
     928:	       lea -16(sp),sp
     92c:	       move.l a6,-(sp)
	
	char * newString = AllocVec(strlen(copyMe)+1, MEMF_ANY); 
     92e:	       move.l 24(sp),-(sp)
     932:	       jsr 8e8 <strlen>
     938:	       addq.l #4,sp
     93a:	       move.l d0,d1
     93c:	       addq.l #1,d1
     93e:	       move.l d1,16(sp)
     942:	       clr.l 12(sp)
     946:	       move.l 549a <SysBase>,d0
     94c:	       movea.l d0,a6
     94e:	       move.l 16(sp),d0
     952:	       move.l 12(sp),d1
     956:	       jsr -684(a6)
     95a:	       move.l d0,8(sp)
     95e:	       move.l 8(sp),d0
     962:	       move.l d0,4(sp)
	if(newString == 0) {
     966:	   /-- bne.s 97a <copyString+0x52>
		KPrintF("copystring: Can't reserve memory for newString\n");
     968:	   |   pea 2b47 <incbin_player_end+0x7f>
     96e:	   |   jsr e26 <KPrintF>
     974:	   |   addq.l #4,sp
		return NULL;	
     976:	   |   moveq #0,d0
     978:	/--|-- bra.s 98e <copyString+0x66>
	}
	strcpy (newString, copyMe);
     97a:	|  \-> move.l 24(sp),-(sp)
     97e:	|      move.l 8(sp),-(sp)
     982:	|      jsr 900 <strcpy>
     988:	|      addq.l #8,sp
	return newString;
     98a:	|      move.l 4(sp),d0
}
     98e:	\----> movea.l (sp)+,a6
     990:	       lea 16(sp),sp
     994:	       rts

00000996 <joinStrings>:

char * joinStrings (const char * s1, const char * s2) {
     996:	    lea -20(sp),sp
     99a:	    move.l a6,-(sp)
     99c:	    move.l d2,-(sp)
	char * newString = AllocVec(strlen (s1) + strlen (s2) + 1, MEMF_ANY); 
     99e:	    move.l 32(sp),-(sp)
     9a2:	    jsr 8e8 <strlen>
     9a8:	    addq.l #4,sp
     9aa:	    move.l d0,d2
     9ac:	    move.l 36(sp),-(sp)
     9b0:	    jsr 8e8 <strlen>
     9b6:	    addq.l #4,sp
     9b8:	    add.l d2,d0
     9ba:	    move.l d0,d1
     9bc:	    addq.l #1,d1
     9be:	    move.l d1,20(sp)
     9c2:	    clr.l 16(sp)
     9c6:	    move.l 549a <SysBase>,d0
     9cc:	    movea.l d0,a6
     9ce:	    move.l 20(sp),d0
     9d2:	    move.l 16(sp),d1
     9d6:	    jsr -684(a6)
     9da:	    move.l d0,12(sp)
     9de:	    move.l 12(sp),d0
     9e2:	    move.l d0,8(sp)
	char * t = newString;
     9e6:	    move.l 8(sp),24(sp)

	while(*t++ = *s1++);
     9ec:	    nop
     9ee:	/-> move.l 32(sp),d0
     9f2:	|   move.l d0,d1
     9f4:	|   addq.l #1,d1
     9f6:	|   move.l d1,32(sp)
     9fa:	|   movea.l 24(sp),a0
     9fe:	|   lea 1(a0),a1
     a02:	|   move.l a1,24(sp)
     a06:	|   movea.l d0,a1
     a08:	|   move.b (a1),d0
     a0a:	|   move.b d0,(a0)
     a0c:	|   move.b (a0),d0
     a0e:	\-- bne.s 9ee <joinStrings+0x58>
	t--;
     a10:	    subq.l #1,24(sp)
	while(*t++ = *s2++);
     a14:	    nop
     a16:	/-> move.l 36(sp),d0
     a1a:	|   move.l d0,d1
     a1c:	|   addq.l #1,d1
     a1e:	|   move.l d1,36(sp)
     a22:	|   movea.l 24(sp),a0
     a26:	|   lea 1(a0),a1
     a2a:	|   move.l a1,24(sp)
     a2e:	|   movea.l d0,a1
     a30:	|   move.b (a1),d0
     a32:	|   move.b d0,(a0)
     a34:	|   move.b (a0),d0
     a36:	\-- bne.s a16 <joinStrings+0x80>

	return newString;
     a38:	    move.l 8(sp),d0
}
     a3c:	    move.l (sp)+,d2
     a3e:	    movea.l (sp)+,a6
     a40:	    lea 20(sp),sp
     a44:	    rts

00000a46 <main_sludge>:
char * gameName = NULL;
char * gamePath = NULL;
char *bundleFolder;

int main_sludge(int argc, char *argv[])
{	
     a46:	          lea -40(sp),sp
     a4a:	          movem.l d2-d3/a6,-(sp)
	/* Dimensions of our window. */
	//AMIGA TODO: Maybe remove as there will be no windowed mode
    winWidth = 320;
     a4e:	          move.l #320,5482 <winWidth>
    winHeight = 256;
     a58:	          move.l #256,5486 <winHeight>

	char * sludgeFile;

	if(argc == 0) {
     a62:	          tst.l 56(sp)
     a66:	      /-- bne.s a7e <main_sludge+0x38>
		bundleFolder = copyString("game/");
     a68:	      |   pea 2b77 <incbin_player_end+0xaf>
     a6e:	      |   jsr 928 <copyString>
     a74:	      |   addq.l #4,sp
     a76:	      |   move.l d0,54ae <bundleFolder>
     a7c:	   /--|-- bra.s a94 <main_sludge+0x4e>
	} else {
		bundleFolder = copyString(argv[0]);
     a7e:	   |  \-> movea.l 60(sp),a0
     a82:	   |      move.l (a0),d0
     a84:	   |      move.l d0,-(sp)
     a86:	   |      jsr 928 <copyString>
     a8c:	   |      addq.l #4,sp
     a8e:	   |      move.l d0,54ae <bundleFolder>
	}
    
	int lastSlash = -1;
     a94:	   \----> moveq #-1,d0
     a96:	          move.l d0,44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
     a9a:	          clr.l 40(sp)
     a9e:	   /----- bra.s ac0 <main_sludge+0x7a>
		if (bundleFolder[i] == PATHSLASH) lastSlash = i;
     aa0:	/--|----> move.l 54ae <bundleFolder>,d1
     aa6:	|  |      move.l 40(sp),d0
     aaa:	|  |      movea.l d1,a0
     aac:	|  |      adda.l d0,a0
     aae:	|  |      move.b (a0),d0
     ab0:	|  |      cmpi.b #47,d0
     ab4:	|  |  /-- bne.s abc <main_sludge+0x76>
     ab6:	|  |  |   move.l 40(sp),44(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
     abc:	|  |  \-> addq.l #1,40(sp)
     ac0:	|  \----> move.l 54ae <bundleFolder>,d1
     ac6:	|         move.l 40(sp),d0
     aca:	|         movea.l d1,a0
     acc:	|         adda.l d0,a0
     ace:	|         move.b (a0),d0
     ad0:	\-------- bne.s aa0 <main_sludge+0x5a>
	}
	bundleFolder[lastSlash+1] = NULL;
     ad2:	          move.l 54ae <bundleFolder>,d0
     ad8:	          move.l 44(sp),d1
     adc:	          addq.l #1,d1
     ade:	          movea.l d0,a0
     ae0:	          adda.l d1,a0
     ae2:	          clr.b (a0)

	if (argc > 1) {
     ae4:	          moveq #1,d0
     ae6:	          cmp.l 56(sp),d0
     aea:	      /-- bge.s b06 <main_sludge+0xc0>
		sludgeFile = argv[argc - 1];
     aec:	      |   move.l 56(sp),d0
     af0:	      |   addi.l #1073741823,d0
     af6:	      |   add.l d0,d0
     af8:	      |   add.l d0,d0
     afa:	      |   movea.l 60(sp),a0
     afe:	      |   adda.l d0,a0
     b00:	      |   move.l (a0),48(sp)
     b04:	   /--|-- bra.s b60 <main_sludge+0x11a>
	} else {
		sludgeFile = joinStrings (bundleFolder, "gamedata.slg");
     b06:	   |  \-> move.l 54ae <bundleFolder>,d0
     b0c:	   |      pea 2b7d <incbin_player_end+0xb5>
     b12:	   |      move.l d0,-(sp)
     b14:	   |      jsr 996 <joinStrings>
     b1a:	   |      addq.l #8,sp
     b1c:	   |      move.l d0,48(sp)
		if (! ( fileExists (sludgeFile) ) ) {
     b20:	   |      move.l 48(sp),-(sp)
     b24:	   |      jsr dbc <fileExists>
     b2a:	   |      addq.l #4,sp
     b2c:	   |      tst.b d0
     b2e:	   +----- bne.s b60 <main_sludge+0x11a>
			FreeVec(sludgeFile);
     b30:	   |      move.l 48(sp),36(sp)
     b36:	   |      move.l 549a <SysBase>,d0
     b3c:	   |      movea.l d0,a6
     b3e:	   |      movea.l 36(sp),a1
     b42:	   |      jsr -690(a6)
			sludgeFile = joinStrings (bundleFolder, "gamedata");			
     b46:	   |      move.l 54ae <bundleFolder>,d0
     b4c:	   |      pea 2b8a <incbin_player_end+0xc2>
     b52:	   |      move.l d0,-(sp)
     b54:	   |      jsr 996 <joinStrings>
     b5a:	   |      addq.l #8,sp
     b5c:	   |      move.l d0,48(sp)
	//AMIGA TODO: Show arguments
	/*if (! parseCmdlineParameters(argc, argv) && !(sludgeFile) ) {
		printCmdlineUsage();
		return 0;
	}*/
	if (! fileExists(sludgeFile) ) {	
     b60:	   \----> move.l 48(sp),-(sp)
     b64:	          jsr dbc <fileExists>
     b6a:	          addq.l #4,sp
     b6c:	          tst.b d0
     b6e:	      /-- bne.s bb6 <main_sludge+0x170>
		Write(Output(), (APTR)"Game file not found.\n", 21);
     b70:	      |   move.l 54a2 <DOSBase>,d0
     b76:	      |   movea.l d0,a6
     b78:	      |   jsr -60(a6)
     b7c:	      |   move.l d0,28(sp)
     b80:	      |   move.l 28(sp),d0
     b84:	      |   move.l d0,24(sp)
     b88:	      |   move.l #11155,20(sp)
     b90:	      |   moveq #21,d0
     b92:	      |   move.l d0,16(sp)
     b96:	      |   move.l 54a2 <DOSBase>,d0
     b9c:	      |   movea.l d0,a6
     b9e:	      |   move.l 24(sp),d1
     ba2:	      |   move.l 20(sp),d2
     ba6:	      |   move.l 16(sp),d3
     baa:	      |   jsr -48(a6)
     bae:	      |   move.l d0,12(sp)
		//AMIGA TODO: Show arguments
		//printCmdlineUsage();
		return 0;
     bb2:	      |   moveq #0,d0
     bb4:	   /--|-- bra.s bec <main_sludge+0x1a6>
	}

	setGameFilePath (sludgeFile);
     bb6:	   |  \-> move.l 48(sp),-(sp)
     bba:	   |      jsr bf6 <setGameFilePath>
     bc0:	   |      addq.l #4,sp
	if (! initSludge (sludgeFile)) return 0;
     bc2:	   |      move.l 48(sp),-(sp)
     bc6:	   |      jsr b8 <initSludge>
     bcc:	   |      addq.l #4,sp
     bce:	   |      tst.w d0
     bd0:	   |  /-- bne.s bd6 <main_sludge+0x190>
     bd2:	   |  |   moveq #0,d0
     bd4:	   +--|-- bra.s bec <main_sludge+0x1a6>
	//Amiga Cleanup
	FreeVec(sludgeFile);
     bd6:	   |  \-> move.l 48(sp),32(sp)
     bdc:	   |      move.l 549a <SysBase>,d0
     be2:	   |      movea.l d0,a6
     be4:	   |      movea.l 32(sp),a1
     be8:	   |      jsr -690(a6)
}
     bec:	   \----> movem.l (sp)+,d2-d3/a6
     bf0:	          lea 40(sp),sp
     bf4:	          rts

00000bf6 <setGameFilePath>:

void setGameFilePath (char * f) {
     bf6:	          lea -1056(sp),sp
     bfa:	          move.l a6,-(sp)
     bfc:	          move.l d2,-(sp)
	char currentDir[1000];

	if (!GetCurrentDirName( currentDir, 998)) {
     bfe:	          move.l #1064,d0
     c04:	          add.l sp,d0
     c06:	          addi.l #-1056,d0
     c0c:	          move.l d0,1052(sp)
     c10:	          move.l #998,1048(sp)
     c18:	          move.l 54a2 <DOSBase>,d0
     c1e:	          movea.l d0,a6
     c20:	          move.l 1052(sp),d1
     c24:	          move.l 1048(sp),d2
     c28:	          jsr -564(a6)
     c2c:	          move.w d0,1046(sp)
     c30:	          move.w 1046(sp),d0
     c34:	      /-- bne.s c44 <setGameFilePath+0x4e>
		KPrintF("setGameFilePath: Can't get current directory.\n");
     c36:	      |   pea 2ba9 <incbin_player_end+0xe1>
     c3c:	      |   jsr e26 <KPrintF>
     c42:	      |   addq.l #4,sp
	}	

	int got = -1, a;	
     c44:	      \-> moveq #-1,d0
     c46:	          move.l d0,1060(sp)

	for (a = 0; f[a]; a ++) {
     c4a:	          clr.l 1056(sp)
     c4e:	   /----- bra.s c6c <setGameFilePath+0x76>
		if (f[a] == PATHSLASH) got = a;
     c50:	/--|----> move.l 1056(sp),d0
     c54:	|  |      movea.l 1068(sp),a0
     c58:	|  |      adda.l d0,a0
     c5a:	|  |      move.b (a0),d0
     c5c:	|  |      cmpi.b #47,d0
     c60:	|  |  /-- bne.s c68 <setGameFilePath+0x72>
     c62:	|  |  |   move.l 1056(sp),1060(sp)
	for (a = 0; f[a]; a ++) {
     c68:	|  |  \-> addq.l #1,1056(sp)
     c6c:	|  \----> move.l 1056(sp),d0
     c70:	|         movea.l 1068(sp),a0
     c74:	|         adda.l d0,a0
     c76:	|         move.b (a0),d0
     c78:	\-------- bne.s c50 <setGameFilePath+0x5a>
	}

	if (got != -1) {
     c7a:	          moveq #-1,d0
     c7c:	          cmp.l 1060(sp),d0
     c80:	   /----- beq.s cce <setGameFilePath+0xd8>
		f[got] = 0;		
     c82:	   |      move.l 1060(sp),d0
     c86:	   |      movea.l 1068(sp),a0
     c8a:	   |      adda.l d0,a0
     c8c:	   |      clr.b (a0)
		if (!SetCurrentDirName(f)) {
     c8e:	   |      move.l 1068(sp),1042(sp)
     c94:	   |      move.l 54a2 <DOSBase>,d0
     c9a:	   |      movea.l d0,a6
     c9c:	   |      move.l 1042(sp),d1
     ca0:	   |      jsr -558(a6)
     ca4:	   |      move.w d0,1040(sp)
     ca8:	   |      move.w 1040(sp),d0
     cac:	   |  /-- bne.s cc0 <setGameFilePath+0xca>
			KPrintF("setGameFilePath:: Failed changing to directory %s\n", f);
     cae:	   |  |   move.l 1068(sp),-(sp)
     cb2:	   |  |   pea 2bd8 <incbin_player_end+0x110>
     cb8:	   |  |   jsr e26 <KPrintF>
     cbe:	   |  |   addq.l #8,sp
		}
		f[got] = PATHSLASH;
     cc0:	   |  \-> move.l 1060(sp),d0
     cc4:	   |      movea.l 1068(sp),a0
     cc8:	   |      adda.l d0,a0
     cca:	   |      move.b #47,(a0)
	}

	gamePath = AllocVec(400, MEMF_ANY);
     cce:	   \----> move.l #400,1036(sp)
     cd6:	          clr.l 1032(sp)
     cda:	          move.l 549a <SysBase>,d0
     ce0:	          movea.l d0,a6
     ce2:	          move.l 1036(sp),d0
     ce6:	          move.l 1032(sp),d1
     cea:	          jsr -684(a6)
     cee:	          move.l d0,1028(sp)
     cf2:	          move.l 1028(sp),d0
     cf6:	          move.l d0,54aa <gamePath>
	if (gamePath==0) {
     cfc:	          move.l 54aa <gamePath>,d0
     d02:	      /-- bne.s d16 <setGameFilePath+0x120>
		KPrintF("setGameFilePath: Can't reserve memory for game directory.\n");
     d04:	      |   pea 2c0b <incbin_player_end+0x143>
     d0a:	      |   jsr e26 <KPrintF>
     d10:	      |   addq.l #4,sp
     d12:	   /--|-- bra.w db2 <setGameFilePath+0x1bc>
		return;
	}

	if (! GetCurrentDirName (gamePath, 398)) {
     d16:	   |  \-> move.l 54aa <gamePath>,1024(sp)
     d1e:	   |      move.l #398,1020(sp)
     d26:	   |      move.l 54a2 <DOSBase>,d0
     d2c:	   |      movea.l d0,a6
     d2e:	   |      move.l 1024(sp),d1
     d32:	   |      move.l 1020(sp),d2
     d36:	   |      jsr -564(a6)
     d3a:	   |      move.w d0,1018(sp)
     d3e:	   |      move.w 1018(sp),d0
     d42:	   |  /-- bne.s d52 <setGameFilePath+0x15c>
		KPrintF("setGameFilePath: Can't get game directory.\n");
     d44:	   |  |   pea 2c46 <incbin_player_end+0x17e>
     d4a:	   |  |   jsr e26 <KPrintF>
     d50:	   |  |   addq.l #4,sp
	}

	if (!SetCurrentDirName(currentDir)) {	
     d52:	   |  \-> move.l #1064,d0
     d58:	   |      add.l sp,d0
     d5a:	   |      addi.l #-1056,d0
     d60:	   |      move.l d0,1014(sp)
     d64:	   |      move.l 54a2 <DOSBase>,d0
     d6a:	   |      movea.l d0,a6
     d6c:	   |      move.l 1014(sp),d1
     d70:	   |      jsr -558(a6)
     d74:	   |      move.w d0,1012(sp)
     d78:	   |      move.w 1012(sp),d0
     d7c:	   |  /-- bne.s d92 <setGameFilePath+0x19c>
		KPrintF("setGameFilePath: Failed changing to directory %s\n", currentDir);
     d7e:	   |  |   move.l sp,d0
     d80:	   |  |   addq.l #8,d0
     d82:	   |  |   move.l d0,-(sp)
     d84:	   |  |   pea 2c72 <incbin_player_end+0x1aa>
     d8a:	   |  |   jsr e26 <KPrintF>
     d90:	   |  |   addq.l #8,sp
	}

	//Free Mem
	if (gamePath != 0) FreeVec(gamePath);
     d92:	   |  \-> move.l 54aa <gamePath>,d0
     d98:	   +----- beq.s db2 <setGameFilePath+0x1bc>
     d9a:	   |      move.l 54aa <gamePath>,1008(sp)
     da2:	   |      move.l 549a <SysBase>,d0
     da8:	   |      movea.l d0,a6
     daa:	   |      movea.l 1008(sp),a1
     dae:	   |      jsr -690(a6)
}
     db2:	   \----> move.l (sp)+,d2
     db4:	          movea.l (sp)+,a6
     db6:	          lea 1056(sp),sp
     dba:	          rts

00000dbc <fileExists>:
 *  Helper functions that don't depend on other source files.
 */
#include <proto/dos.h>
#include "helpers.h"

BYTE fileExists(const char * file) {
     dbc:	    lea -28(sp),sp
     dc0:	    move.l a6,-(sp)
     dc2:	    move.l d2,-(sp)
	BPTR tester;
	BYTE retval = 0;
     dc4:	    clr.b 35(sp)
	tester = Open(file, MODE_OLDFILE);
     dc8:	    move.l 40(sp),30(sp)
     dce:	    move.l #1005,26(sp)
     dd6:	    move.l 54a2 <DOSBase>,d0
     ddc:	    movea.l d0,a6
     dde:	    move.l 30(sp),d1
     de2:	    move.l 26(sp),d2
     de6:	    jsr -30(a6)
     dea:	    move.l d0,22(sp)
     dee:	    move.l 22(sp),d0
     df2:	    move.l d0,18(sp)
	if (tester) {
     df6:	/-- beq.s e18 <fileExists+0x5c>
		retval = 1;
     df8:	|   move.b #1,35(sp)
		Close(tester);
     dfe:	|   move.l 18(sp),14(sp)
     e04:	|   move.l 54a2 <DOSBase>,d0
     e0a:	|   movea.l d0,a6
     e0c:	|   move.l 14(sp),d1
     e10:	|   jsr -36(a6)
     e14:	|   move.l d0,10(sp)
	}
	return retval;
     e18:	\-> move.b 35(sp),d0
     e1c:	    move.l (sp)+,d2
     e1e:	    movea.l (sp)+,a6
     e20:	    lea 28(sp),sp
     e24:	    rts

00000e26 <KPrintF>:
void KPrintF(const char* fmt, ...) {
     e26:	       lea -128(sp),sp
     e2a:	       movem.l a2-a3/a6,-(sp)
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
     e2e:	       move.w f0ff60 <gcc8_c_support.c.7b853710+0xf05839>,d0
     e34:	       cmpi.w #20153,d0
     e38:	   /-- beq.s e5c <KPrintF+0x36>
     e3a:	   |   cmpi.w #-24562,d0
     e3e:	   +-- beq.s e5c <KPrintF+0x36>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
     e40:	   |   movea.l 549a <SysBase>,a6
     e46:	   |   movea.l 144(sp),a0
     e4a:	   |   lea 148(sp),a1
     e4e:	   |   lea 1030 <KPutCharX>,a2
     e54:	   |   suba.l a3,a3
     e56:	   |   jsr -522(a6)
}
     e5a:	/--|-- bra.s e86 <KPrintF+0x60>
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
     e5c:	|  \-> movea.l 549a <SysBase>,a6
     e62:	|      movea.l 144(sp),a0
     e66:	|      lea 148(sp),a1
     e6a:	|      lea 103e <PutChar>,a2
     e70:	|      lea 12(sp),a3
     e74:	|      jsr -522(a6)
		UaeDbgLog(86, temp);
     e78:	|      move.l a3,-(sp)
     e7a:	|      pea 56 <_start+0x56>
     e7e:	|      jsr f0ff60 <gcc8_c_support.c.7b853710+0xf05839>
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
     e84:	|      addq.l #8,sp
}
     e86:	\----> movem.l (sp)+,a2-a3/a6
     e8a:	       lea 128(sp),sp
     e8e:	       rts

00000e90 <warpmode>:

void warpmode(int on) { // bool
     e90:	          subq.l #8,sp
	long(*UaeConf)(long mode, int index, const char* param, int param_len, char* outbuf, int outbuf_len);
	UaeConf = (long(*)(long, int, const char*, int, char*, int))0xf0ff60;
     e92:	          move.l #15794016,4(sp)
	if(*((UWORD *)UaeConf) == 0x4eb9 || *((UWORD *)UaeConf) == 0xa00e) {
     e9a:	          movea.l 4(sp),a0
     e9e:	          move.w (a0),d0
     ea0:	          cmpi.w #20153,d0
     ea4:	      /-- beq.s eb4 <warpmode+0x24>
     ea6:	      |   movea.l 4(sp),a0
     eaa:	      |   move.w (a0),d0
     eac:	      |   cmpi.w #-24562,d0
     eb0:	/-----|-- bne.w fb8 <warpmode+0x128>
		char outbuf;
		UaeConf(82, -1, on ? "cpu_speed max" : "cpu_speed real", 0, &outbuf, 1);
     eb4:	|     \-> tst.l 12(sp)
     eb8:	|  /----- beq.s ec2 <warpmode+0x32>
     eba:	|  |      move.l #11428,d0
     ec0:	|  |  /-- bra.s ec8 <warpmode+0x38>
     ec2:	|  \--|-> move.l #11442,d0
     ec8:	|     \-> pea 1 <_start+0x1>
     ecc:	|         move.l sp,d1
     ece:	|         addq.l #7,d1
     ed0:	|         move.l d1,-(sp)
     ed2:	|         clr.l -(sp)
     ed4:	|         move.l d0,-(sp)
     ed6:	|         pea ffffffff <gcc8_c_support.c.7b853710+0xffff58d8>
     eda:	|         pea 52 <_start+0x52>
     ede:	|         movea.l 28(sp),a0
     ee2:	|         jsr (a0)
     ee4:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_cycle_exact false" : "cpu_cycle_exact true", 0, &outbuf, 1);
     ee8:	|         tst.l 12(sp)
     eec:	|  /----- beq.s ef6 <warpmode+0x66>
     eee:	|  |      move.l #11457,d0
     ef4:	|  |  /-- bra.s efc <warpmode+0x6c>
     ef6:	|  \--|-> move.l #11479,d0
     efc:	|     \-> pea 1 <_start+0x1>
     f00:	|         move.l sp,d1
     f02:	|         addq.l #7,d1
     f04:	|         move.l d1,-(sp)
     f06:	|         clr.l -(sp)
     f08:	|         move.l d0,-(sp)
     f0a:	|         pea ffffffff <gcc8_c_support.c.7b853710+0xffff58d8>
     f0e:	|         pea 52 <_start+0x52>
     f12:	|         movea.l 28(sp),a0
     f16:	|         jsr (a0)
     f18:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "cpu_memory_cycle_exact false" : "cpu_memory_cycle_exact true", 0, &outbuf, 1);
     f1c:	|         tst.l 12(sp)
     f20:	|  /----- beq.s f2a <warpmode+0x9a>
     f22:	|  |      move.l #11500,d0
     f28:	|  |  /-- bra.s f30 <warpmode+0xa0>
     f2a:	|  \--|-> move.l #11529,d0
     f30:	|     \-> pea 1 <_start+0x1>
     f34:	|         move.l sp,d1
     f36:	|         addq.l #7,d1
     f38:	|         move.l d1,-(sp)
     f3a:	|         clr.l -(sp)
     f3c:	|         move.l d0,-(sp)
     f3e:	|         pea ffffffff <gcc8_c_support.c.7b853710+0xffff58d8>
     f42:	|         pea 52 <_start+0x52>
     f46:	|         movea.l 28(sp),a0
     f4a:	|         jsr (a0)
     f4c:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
     f50:	|         tst.l 12(sp)
     f54:	|  /----- beq.s f5e <warpmode+0xce>
     f56:	|  |      move.l #11557,d0
     f5c:	|  |  /-- bra.s f64 <warpmode+0xd4>
     f5e:	|  \--|-> move.l #11583,d0
     f64:	|     \-> pea 1 <_start+0x1>
     f68:	|         move.l sp,d1
     f6a:	|         addq.l #7,d1
     f6c:	|         move.l d1,-(sp)
     f6e:	|         clr.l -(sp)
     f70:	|         move.l d0,-(sp)
     f72:	|         pea ffffffff <gcc8_c_support.c.7b853710+0xffff58d8>
     f76:	|         pea 52 <_start+0x52>
     f7a:	|         movea.l 28(sp),a0
     f7e:	|         jsr (a0)
     f80:	|         lea 24(sp),sp
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
     f84:	|         tst.l 12(sp)
     f88:	|  /----- beq.s f92 <warpmode+0x102>
     f8a:	|  |      move.l #11608,d0
     f90:	|  |  /-- bra.s f98 <warpmode+0x108>
     f92:	|  \--|-> move.l #11618,d0
     f98:	|     \-> pea 1 <_start+0x1>
     f9c:	|         move.l sp,d1
     f9e:	|         addq.l #7,d1
     fa0:	|         move.l d1,-(sp)
     fa2:	|         clr.l -(sp)
     fa4:	|         move.l d0,-(sp)
     fa6:	|         pea ffffffff <gcc8_c_support.c.7b853710+0xffff58d8>
     faa:	|         pea 52 <_start+0x52>
     fae:	|         movea.l 28(sp),a0
     fb2:	|         jsr (a0)
     fb4:	|         lea 24(sp),sp
	}
}
     fb8:	\-------> nop
     fba:	          addq.l #8,sp
     fbc:	          rts

00000fbe <debug_cmd>:

static void debug_cmd(unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4) {
     fbe:	       subq.l #4,sp
	long(*UaeLib)(unsigned int arg0, unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4);
	UaeLib = (long(*)(unsigned int, unsigned int, unsigned int, unsigned int, unsigned int))0xf0ff60;
     fc0:	       move.l #15794016,(sp)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
     fc6:	       movea.l (sp),a0
     fc8:	       move.w (a0),d0
     fca:	       cmpi.w #20153,d0
     fce:	   /-- beq.s fda <debug_cmd+0x1c>
     fd0:	   |   movea.l (sp),a0
     fd2:	   |   move.w (a0),d0
     fd4:	   |   cmpi.w #-24562,d0
     fd8:	/--|-- bne.s ff8 <debug_cmd+0x3a>
		UaeLib(88, arg1, arg2, arg3, arg4);
     fda:	|  \-> move.l 20(sp),-(sp)
     fde:	|      move.l 20(sp),-(sp)
     fe2:	|      move.l 20(sp),-(sp)
     fe6:	|      move.l 20(sp),-(sp)
     fea:	|      pea 58 <_start+0x58>
     fee:	|      movea.l 20(sp),a0
     ff2:	|      jsr (a0)
     ff4:	|      lea 20(sp),sp
	}
}
     ff8:	\----> nop
     ffa:	       addq.l #4,sp
     ffc:	       rts

00000ffe <debug_start_idle>:
	debug_cmd(barto_cmd_text, (((unsigned int)left) << 16) | ((unsigned int)top), (unsigned int)text, color);
}

// profiler
void debug_start_idle() {
	debug_cmd(barto_cmd_set_idle, 1, 0, 0);
     ffe:	clr.l -(sp)
    1000:	clr.l -(sp)
    1002:	pea 1 <_start+0x1>
    1006:	pea 5 <_start+0x5>
    100a:	jsr fbe <debug_cmd>
    1010:	lea 16(sp),sp
}
    1014:	nop
    1016:	rts

00001018 <debug_stop_idle>:

void debug_stop_idle() {
	debug_cmd(barto_cmd_set_idle, 0, 0, 0);
    1018:	clr.l -(sp)
    101a:	clr.l -(sp)
    101c:	clr.l -(sp)
    101e:	pea 5 <_start+0x5>
    1022:	jsr fbe <debug_cmd>
    1028:	lea 16(sp),sp
}
    102c:	nop
    102e:	rts

00001030 <KPutCharX>:
	.type KPutCharX, function
	.globl	KPutCharX

KPutCharX:
	.cfi_startproc
    move.l  a6, -(sp)
    1030:	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
    1032:	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
    1036:	jsr -516(a6)
    move.l (sp)+, a6
    103a:	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
    103c:	rts

0000103e <PutChar>:
	.type PutChar, function
	.globl	PutChar

PutChar:
	.cfi_startproc
	move.b d0, (a3)+
    103e:	move.b d0,(a3)+
	rts
    1040:	rts
