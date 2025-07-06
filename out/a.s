
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
       2:	       move.l #52759,d0
       8:	       subi.l #52759,d0
       e:	       asr.l #2,d0
      10:	       move.l d0,(sp)
	for (i = 0; i < count; i++)
      12:	       clr.l 4(sp)
      16:	   ,-- bra.s 32 <_start+0x32>
		__preinit_array_start[i]();
      18:	,--|-> move.l 4(sp),d0
      1c:	|  |   add.l d0,d0
      1e:	|  |   movea.l d0,a1
      20:	|  |   adda.l d0,a1
      22:	|  |   lea ce17 <__fini_array_end>,a0
      28:	|  |   movea.l (0,a1,a0.l),a0
      2c:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      2e:	|  |   addq.l #1,4(sp)
      32:	|  '-> move.l 4(sp),d0
      36:	|      cmp.l (sp),d0
      38:	'----- bcs.s 18 <_start+0x18>

	count = __init_array_end - __init_array_start;
      3a:	       move.l #52759,d0
      40:	       subi.l #52759,d0
      46:	       asr.l #2,d0
      48:	       move.l d0,(sp)
	for (i = 0; i < count; i++)
      4a:	       clr.l 4(sp)
      4e:	   ,-- bra.s 6a <_start+0x6a>
		__init_array_start[i]();
      50:	,--|-> move.l 4(sp),d0
      54:	|  |   add.l d0,d0
      56:	|  |   movea.l d0,a1
      58:	|  |   adda.l d0,a1
      5a:	|  |   lea ce17 <__fini_array_end>,a0
      60:	|  |   movea.l (0,a1,a0.l),a0
      64:	|  |   jsr (a0)
	for (i = 0; i < count; i++)
      66:	|  |   addq.l #1,4(sp)
      6a:	|  '-> move.l 4(sp),d0
      6e:	|      cmp.l (sp),d0
      70:	'----- bcs.s 50 <_start+0x50>

	main();
      72:	       jsr 4544 <main>

	// call dtors
	count = __fini_array_end - __fini_array_start;
      78:	       move.l #52759,d0
      7e:	       subi.l #52759,d0
      84:	       asr.l #2,d0
      86:	       move.l d0,(sp)
	for (i = count; i > 0; i--)
      88:	       move.l (sp),4(sp)
      8c:	   ,-- bra.s aa <_start+0xaa>
		__fini_array_start[i - 1]();
      8e:	,--|-> move.l 4(sp),d0
      92:	|  |   subq.l #1,d0
      94:	|  |   add.l d0,d0
      96:	|  |   movea.l d0,a1
      98:	|  |   adda.l d0,a1
      9a:	|  |   lea ce17 <__fini_array_end>,a0
      a0:	|  |   movea.l (0,a1,a0.l),a0
      a4:	|  |   jsr (a0)
	for (i = count; i > 0; i--)
      a6:	|  |   subq.l #1,4(sp)
      aa:	|  '-> tst.l 4(sp)
      ae:	'----- bne.s 8e <_start+0x8e>
}
      b0:	       nop
      b2:	       nop
      b4:	       addq.l #8,sp
      b6:	       rts

000000b8 <copyString>:
#include "support/gcc8_c_support.h"
#include "moreio.h"

BOOL allowAnyFilename = TRUE;

char * copyString(const char * c) {
      b8:	       lea -16(sp),sp
      bc:	       move.l a6,-(sp)
    char * r = (char *)AllocVec(strlen(c) + 1, MEMF_ANY);
      be:	       move.l 24(sp),-(sp)
      c2:	       jsr 6ce0 <strlen>
      c8:	       addq.l #4,sp
      ca:	       move.l d0,d1
      cc:	       addq.l #1,d1
      ce:	       move.l d1,16(sp)
      d2:	       clr.l 12(sp)
      d6:	       move.l d018 <SysBase>,d0
      dc:	       movea.l d0,a6
      de:	       move.l 16(sp),d0
      e2:	       move.l 12(sp),d1
      e6:	       jsr -684(a6)
      ea:	       move.l d0,8(sp)
      ee:	       move.l 8(sp),d0
      f2:	       move.l d0,4(sp)
    if (!r) return NULL;
      f6:	   ,-- bne.s fc <copyString+0x44>
      f8:	   |   moveq #0,d0
      fa:	,--|-- bra.s 110 <copyString+0x58>
    strcpy(r, c);
      fc:	|  '-> move.l 24(sp),-(sp)
     100:	|      move.l 8(sp),-(sp)
     104:	|      jsr 6cf8 <strcpy>
     10a:	|      addq.l #8,sp
    return r;
     10c:	|      move.l 4(sp),d0
}
     110:	'----> movea.l (sp)+,a6
     112:	       lea 16(sp),sp
     116:	       rts

00000118 <encodeFilename>:
	} else {
		return copyString(nameIn);
	}
}

char * encodeFilename (char * nameIn) {
     118:	                      lea -24(sp),sp
     11c:	                      move.l a6,-(sp)
	if (! nameIn) return NULL;
     11e:	                      tst.l 32(sp)
     122:	                  ,-- bne.s 12a <encodeFilename+0x12>
     124:	                  |   moveq #0,d0
     126:	,-----------------|-- bra.w 4a2 <encodeFilename+0x38a>
	if (allowAnyFilename) {
     12a:	|                 '-> move.w ce18 <allowAnyFilename>,d0
     130:	|  ,----------------- beq.w 45e <encodeFilename+0x346>
		char * newName = AllocVec( strlen(nameIn)*2+1,MEMF_ANY);
     134:	|  |                  move.l 32(sp),-(sp)
     138:	|  |                  jsr 6ce0 <strlen>
     13e:	|  |                  addq.l #4,sp
     140:	|  |                  add.l d0,d0
     142:	|  |                  move.l d0,d1
     144:	|  |                  addq.l #1,d1
     146:	|  |                  move.l d1,16(sp)
     14a:	|  |                  clr.l 12(sp)
     14e:	|  |                  move.l d018 <SysBase>,d0
     154:	|  |                  movea.l d0,a6
     156:	|  |                  move.l 16(sp),d0
     15a:	|  |                  move.l 12(sp),d1
     15e:	|  |                  jsr -684(a6)
     162:	|  |                  move.l d0,8(sp)
     166:	|  |                  move.l 8(sp),d0
     16a:	|  |                  move.l d0,4(sp)
		if(newName == 0) {
     16e:	|  |              ,-- bne.s 184 <encodeFilename+0x6c>
			KPrintF( "encodefilename: Could not allocate Memory");
     170:	|  |              |   pea 7c78 <PutChar+0x4>
     176:	|  |              |   jsr 725e <KPrintF>
     17c:	|  |              |   addq.l #4,sp
			return NULL;
     17e:	|  |              |   moveq #0,d0
     180:	+--|--------------|-- bra.w 4a2 <encodeFilename+0x38a>
		}

		int i = 0;
     184:	|  |              '-> clr.l 24(sp)
		while (*nameIn) {
     188:	|  |     ,----------- bra.w 44e <encodeFilename+0x336>
			switch (*nameIn) {
     18c:	|  |  ,--|----------> movea.l 32(sp),a0
     190:	|  |  |  |            move.b (a0),d0
     192:	|  |  |  |            ext.w d0
     194:	|  |  |  |            movea.w d0,a0
     196:	|  |  |  |            moveq #95,d0
     198:	|  |  |  |            cmp.l a0,d0
     19a:	|  |  |  |        ,-- blt.w 23e <encodeFilename+0x126>
     19e:	|  |  |  |        |   moveq #34,d1
     1a0:	|  |  |  |        |   cmp.l a0,d1
     1a2:	|  |  |  |  ,-----|-- bgt.w 422 <encodeFilename+0x30a>
     1a6:	|  |  |  |  |     |   moveq #-34,d0
     1a8:	|  |  |  |  |     |   add.l a0,d0
     1aa:	|  |  |  |  |     |   moveq #61,d1
     1ac:	|  |  |  |  |     |   cmp.l d0,d1
     1ae:	|  |  |  |  +-----|-- bcs.w 422 <encodeFilename+0x30a>
     1b2:	|  |  |  |  |     |   add.l d0,d0
     1b4:	|  |  |  |  |     |   movea.l d0,a0
     1b6:	|  |  |  |  |     |   adda.l #450,a0
     1bc:	|  |  |  |  |     |   move.w (a0),d0
     1be:	|  |  |  |  |     |   jmp (1c2 <encodeFilename+0xaa>,pc,d0.w)
     1c2:	|  |  |  |  |     |   bchg d0,d6
     1c4:	|  |  |  |  |     |   andi.w #608,-(a0)
     1c8:	|  |  |  |  |     |   andi.w #608,-(a0)
     1cc:	|  |  |  |  |     |   andi.w #608,-(a0)
     1d0:	|  |  |  |  |     |   andi.w #516,-(a0)
     1d4:	|  |  |  |  |     |   andi.w #608,-(a0)
     1d8:	|  |  |  |  |     |   andi.w #608,-(a0)
     1dc:	|  |  |  |  |     |   bclr d0,-(a6)
     1de:	|  |  |  |  |     |   andi.w #608,-(a0)
     1e2:	|  |  |  |  |     |   andi.w #608,-(a0)
     1e6:	|  |  |  |  |     |   andi.w #608,-(a0)
     1ea:	|  |  |  |  |     |   andi.w #608,-(a0)
     1ee:	|  |  |  |  |     |   andi.w #608,-(a0)
     1f2:	|  |  |  |  |     |   bset d0,(a6)
     1f4:	|  |  |  |  |     |   andi.w #134,-(a0)
     1f8:	|  |  |  |  |     |   andi.w #182,-(a0)
     1fc:	|  |  |  |  |     |   andi.b #96,(96,a2,d0.w:2)
     202:	|  |  |  |  |     |   andi.w #608,-(a0)
     206:	|  |  |  |  |     |   andi.w #608,-(a0)
     20a:	|  |  |  |  |     |   andi.w #608,-(a0)
     20e:	|  |  |  |  |     |   andi.w #608,-(a0)
     212:	|  |  |  |  |     |   andi.w #608,-(a0)
     216:	|  |  |  |  |     |   andi.w #608,-(a0)
     21a:	|  |  |  |  |     |   andi.w #608,-(a0)
     21e:	|  |  |  |  |     |   andi.w #608,-(a0)
     222:	|  |  |  |  |     |   andi.w #608,-(a0)
     226:	|  |  |  |  |     |   andi.w #608,-(a0)
     22a:	|  |  |  |  |     |   andi.w #608,-(a0)
     22e:	|  |  |  |  |     |   andi.w #608,-(a0)
     232:	|  |  |  |  |     |   andi.w #608,-(a0)
     236:	|  |  |  |  |     |   bchg d0,(96,a6,d0.w:2)
     23a:	|  |  |  |  |     |   andi.w #278,-(a0)
     23e:	|  |  |  |  |     '-> moveq #124,d0
     240:	|  |  |  |  |         cmp.l a0,d0
     242:	|  |  |  |  |     ,-- beq.s 2a8 <encodeFilename+0x190>
     244:	|  |  |  |  +-----|-- bra.w 422 <encodeFilename+0x30a>
				case '<':	newName[i++] = '_';		newName[i++] = 'L';		break;
     248:	|  |  |  |  |     |   move.l 24(sp),d0
     24c:	|  |  |  |  |     |   move.l d0,d1
     24e:	|  |  |  |  |     |   addq.l #1,d1
     250:	|  |  |  |  |     |   move.l d1,24(sp)
     254:	|  |  |  |  |     |   movea.l 4(sp),a0
     258:	|  |  |  |  |     |   adda.l d0,a0
     25a:	|  |  |  |  |     |   move.b #95,(a0)
     25e:	|  |  |  |  |     |   move.l 24(sp),d0
     262:	|  |  |  |  |     |   move.l d0,d1
     264:	|  |  |  |  |     |   addq.l #1,d1
     266:	|  |  |  |  |     |   move.l d1,24(sp)
     26a:	|  |  |  |  |     |   movea.l 4(sp),a0
     26e:	|  |  |  |  |     |   adda.l d0,a0
     270:	|  |  |  |  |     |   move.b #76,(a0)
     274:	|  |  |  |  |  ,--|-- bra.w 43e <encodeFilename+0x326>
				case '>':	newName[i++] = '_';		newName[i++] = 'G';		break;
     278:	|  |  |  |  |  |  |   move.l 24(sp),d0
     27c:	|  |  |  |  |  |  |   move.l d0,d1
     27e:	|  |  |  |  |  |  |   addq.l #1,d1
     280:	|  |  |  |  |  |  |   move.l d1,24(sp)
     284:	|  |  |  |  |  |  |   movea.l 4(sp),a0
     288:	|  |  |  |  |  |  |   adda.l d0,a0
     28a:	|  |  |  |  |  |  |   move.b #95,(a0)
     28e:	|  |  |  |  |  |  |   move.l 24(sp),d0
     292:	|  |  |  |  |  |  |   move.l d0,d1
     294:	|  |  |  |  |  |  |   addq.l #1,d1
     296:	|  |  |  |  |  |  |   move.l d1,24(sp)
     29a:	|  |  |  |  |  |  |   movea.l 4(sp),a0
     29e:	|  |  |  |  |  |  |   adda.l d0,a0
     2a0:	|  |  |  |  |  |  |   move.b #71,(a0)
     2a4:	|  |  |  |  |  +--|-- bra.w 43e <encodeFilename+0x326>
				case '|':	newName[i++] = '_';		newName[i++] = 'P';		break;
     2a8:	|  |  |  |  |  |  '-> move.l 24(sp),d0
     2ac:	|  |  |  |  |  |      move.l d0,d1
     2ae:	|  |  |  |  |  |      addq.l #1,d1
     2b0:	|  |  |  |  |  |      move.l d1,24(sp)
     2b4:	|  |  |  |  |  |      movea.l 4(sp),a0
     2b8:	|  |  |  |  |  |      adda.l d0,a0
     2ba:	|  |  |  |  |  |      move.b #95,(a0)
     2be:	|  |  |  |  |  |      move.l 24(sp),d0
     2c2:	|  |  |  |  |  |      move.l d0,d1
     2c4:	|  |  |  |  |  |      addq.l #1,d1
     2c6:	|  |  |  |  |  |      move.l d1,24(sp)
     2ca:	|  |  |  |  |  |      movea.l 4(sp),a0
     2ce:	|  |  |  |  |  |      adda.l d0,a0
     2d0:	|  |  |  |  |  |      move.b #80,(a0)
     2d4:	|  |  |  |  |  +----- bra.w 43e <encodeFilename+0x326>
				case '_':	newName[i++] = '_';		newName[i++] = 'U';		break;
     2d8:	|  |  |  |  |  |      move.l 24(sp),d0
     2dc:	|  |  |  |  |  |      move.l d0,d1
     2de:	|  |  |  |  |  |      addq.l #1,d1
     2e0:	|  |  |  |  |  |      move.l d1,24(sp)
     2e4:	|  |  |  |  |  |      movea.l 4(sp),a0
     2e8:	|  |  |  |  |  |      adda.l d0,a0
     2ea:	|  |  |  |  |  |      move.b #95,(a0)
     2ee:	|  |  |  |  |  |      move.l 24(sp),d0
     2f2:	|  |  |  |  |  |      move.l d0,d1
     2f4:	|  |  |  |  |  |      addq.l #1,d1
     2f6:	|  |  |  |  |  |      move.l d1,24(sp)
     2fa:	|  |  |  |  |  |      movea.l 4(sp),a0
     2fe:	|  |  |  |  |  |      adda.l d0,a0
     300:	|  |  |  |  |  |      move.b #85,(a0)
     304:	|  |  |  |  |  +----- bra.w 43e <encodeFilename+0x326>
				case '\"':	newName[i++] = '_';		newName[i++] = 'S';		break;
     308:	|  |  |  |  |  |      move.l 24(sp),d0
     30c:	|  |  |  |  |  |      move.l d0,d1
     30e:	|  |  |  |  |  |      addq.l #1,d1
     310:	|  |  |  |  |  |      move.l d1,24(sp)
     314:	|  |  |  |  |  |      movea.l 4(sp),a0
     318:	|  |  |  |  |  |      adda.l d0,a0
     31a:	|  |  |  |  |  |      move.b #95,(a0)
     31e:	|  |  |  |  |  |      move.l 24(sp),d0
     322:	|  |  |  |  |  |      move.l d0,d1
     324:	|  |  |  |  |  |      addq.l #1,d1
     326:	|  |  |  |  |  |      move.l d1,24(sp)
     32a:	|  |  |  |  |  |      movea.l 4(sp),a0
     32e:	|  |  |  |  |  |      adda.l d0,a0
     330:	|  |  |  |  |  |      move.b #83,(a0)
     334:	|  |  |  |  |  +----- bra.w 43e <encodeFilename+0x326>
				case '\\':	newName[i++] = '_';		newName[i++] = 'B';		break;
     338:	|  |  |  |  |  |      move.l 24(sp),d0
     33c:	|  |  |  |  |  |      move.l d0,d1
     33e:	|  |  |  |  |  |      addq.l #1,d1
     340:	|  |  |  |  |  |      move.l d1,24(sp)
     344:	|  |  |  |  |  |      movea.l 4(sp),a0
     348:	|  |  |  |  |  |      adda.l d0,a0
     34a:	|  |  |  |  |  |      move.b #95,(a0)
     34e:	|  |  |  |  |  |      move.l 24(sp),d0
     352:	|  |  |  |  |  |      move.l d0,d1
     354:	|  |  |  |  |  |      addq.l #1,d1
     356:	|  |  |  |  |  |      move.l d1,24(sp)
     35a:	|  |  |  |  |  |      movea.l 4(sp),a0
     35e:	|  |  |  |  |  |      adda.l d0,a0
     360:	|  |  |  |  |  |      move.b #66,(a0)
     364:	|  |  |  |  |  +----- bra.w 43e <encodeFilename+0x326>
				case '/':	newName[i++] = '_';		newName[i++] = 'F';		break;
     368:	|  |  |  |  |  |      move.l 24(sp),d0
     36c:	|  |  |  |  |  |      move.l d0,d1
     36e:	|  |  |  |  |  |      addq.l #1,d1
     370:	|  |  |  |  |  |      move.l d1,24(sp)
     374:	|  |  |  |  |  |      movea.l 4(sp),a0
     378:	|  |  |  |  |  |      adda.l d0,a0
     37a:	|  |  |  |  |  |      move.b #95,(a0)
     37e:	|  |  |  |  |  |      move.l 24(sp),d0
     382:	|  |  |  |  |  |      move.l d0,d1
     384:	|  |  |  |  |  |      addq.l #1,d1
     386:	|  |  |  |  |  |      move.l d1,24(sp)
     38a:	|  |  |  |  |  |      movea.l 4(sp),a0
     38e:	|  |  |  |  |  |      adda.l d0,a0
     390:	|  |  |  |  |  |      move.b #70,(a0)
     394:	|  |  |  |  |  +----- bra.w 43e <encodeFilename+0x326>
				case ':':	newName[i++] = '_';		newName[i++] = 'C';		break;
     398:	|  |  |  |  |  |      move.l 24(sp),d0
     39c:	|  |  |  |  |  |      move.l d0,d1
     39e:	|  |  |  |  |  |      addq.l #1,d1
     3a0:	|  |  |  |  |  |      move.l d1,24(sp)
     3a4:	|  |  |  |  |  |      movea.l 4(sp),a0
     3a8:	|  |  |  |  |  |      adda.l d0,a0
     3aa:	|  |  |  |  |  |      move.b #95,(a0)
     3ae:	|  |  |  |  |  |      move.l 24(sp),d0
     3b2:	|  |  |  |  |  |      move.l d0,d1
     3b4:	|  |  |  |  |  |      addq.l #1,d1
     3b6:	|  |  |  |  |  |      move.l d1,24(sp)
     3ba:	|  |  |  |  |  |      movea.l 4(sp),a0
     3be:	|  |  |  |  |  |      adda.l d0,a0
     3c0:	|  |  |  |  |  |      move.b #67,(a0)
     3c4:	|  |  |  |  |  +----- bra.s 43e <encodeFilename+0x326>
				case '*':	newName[i++] = '_';		newName[i++] = 'A';		break;
     3c6:	|  |  |  |  |  |      move.l 24(sp),d0
     3ca:	|  |  |  |  |  |      move.l d0,d1
     3cc:	|  |  |  |  |  |      addq.l #1,d1
     3ce:	|  |  |  |  |  |      move.l d1,24(sp)
     3d2:	|  |  |  |  |  |      movea.l 4(sp),a0
     3d6:	|  |  |  |  |  |      adda.l d0,a0
     3d8:	|  |  |  |  |  |      move.b #95,(a0)
     3dc:	|  |  |  |  |  |      move.l 24(sp),d0
     3e0:	|  |  |  |  |  |      move.l d0,d1
     3e2:	|  |  |  |  |  |      addq.l #1,d1
     3e4:	|  |  |  |  |  |      move.l d1,24(sp)
     3e8:	|  |  |  |  |  |      movea.l 4(sp),a0
     3ec:	|  |  |  |  |  |      adda.l d0,a0
     3ee:	|  |  |  |  |  |      move.b #65,(a0)
     3f2:	|  |  |  |  |  +----- bra.s 43e <encodeFilename+0x326>
				case '?':	newName[i++] = '_';		newName[i++] = 'Q';		break;
     3f4:	|  |  |  |  |  |      move.l 24(sp),d0
     3f8:	|  |  |  |  |  |      move.l d0,d1
     3fa:	|  |  |  |  |  |      addq.l #1,d1
     3fc:	|  |  |  |  |  |      move.l d1,24(sp)
     400:	|  |  |  |  |  |      movea.l 4(sp),a0
     404:	|  |  |  |  |  |      adda.l d0,a0
     406:	|  |  |  |  |  |      move.b #95,(a0)
     40a:	|  |  |  |  |  |      move.l 24(sp),d0
     40e:	|  |  |  |  |  |      move.l d0,d1
     410:	|  |  |  |  |  |      addq.l #1,d1
     412:	|  |  |  |  |  |      move.l d1,24(sp)
     416:	|  |  |  |  |  |      movea.l 4(sp),a0
     41a:	|  |  |  |  |  |      adda.l d0,a0
     41c:	|  |  |  |  |  |      move.b #81,(a0)
     420:	|  |  |  |  |  +----- bra.s 43e <encodeFilename+0x326>

				default:	newName[i++] = *nameIn;							break;
     422:	|  |  |  |  '--|----> move.l 24(sp),d0
     426:	|  |  |  |     |      move.l d0,d1
     428:	|  |  |  |     |      addq.l #1,d1
     42a:	|  |  |  |     |      move.l d1,24(sp)
     42e:	|  |  |  |     |      movea.l 4(sp),a0
     432:	|  |  |  |     |      adda.l d0,a0
     434:	|  |  |  |     |      movea.l 32(sp),a1
     438:	|  |  |  |     |      move.b (a1),d0
     43a:	|  |  |  |     |      move.b d0,(a0)
     43c:	|  |  |  |     |      nop
			}
			newName[i] = 0;
     43e:	|  |  |  |     '----> move.l 24(sp),d0
     442:	|  |  |  |            movea.l 4(sp),a0
     446:	|  |  |  |            adda.l d0,a0
     448:	|  |  |  |            clr.b (a0)
			nameIn ++;
     44a:	|  |  |  |            addq.l #1,32(sp)
		while (*nameIn) {
     44e:	|  |  |  '----------> movea.l 32(sp),a0
     452:	|  |  |               move.b (a0),d0
     454:	|  |  '-------------- bne.w 18c <encodeFilename+0x74>
		}
		return newName;
     458:	|  |                  move.l 4(sp),d0
     45c:	+--|----------------- bra.s 4a2 <encodeFilename+0x38a>
	} else {
		int a;
		for (a = 0; nameIn[a]; a ++) {
     45e:	|  '----------------> clr.l 20(sp)
     462:	|              ,----- bra.s 488 <encodeFilename+0x370>
			if (nameIn[a] == '\\') nameIn[a] ='/';
     464:	|           ,--|----> move.l 20(sp),d0
     468:	|           |  |      movea.l 32(sp),a0
     46c:	|           |  |      adda.l d0,a0
     46e:	|           |  |      move.b (a0),d0
     470:	|           |  |      cmpi.b #92,d0
     474:	|           |  |  ,-- bne.s 484 <encodeFilename+0x36c>
     476:	|           |  |  |   move.l 20(sp),d0
     47a:	|           |  |  |   movea.l 32(sp),a0
     47e:	|           |  |  |   adda.l d0,a0
     480:	|           |  |  |   move.b #47,(a0)
		for (a = 0; nameIn[a]; a ++) {
     484:	|           |  |  '-> addq.l #1,20(sp)
     488:	|           |  '----> move.l 20(sp),d0
     48c:	|           |         movea.l 32(sp),a0
     490:	|           |         adda.l d0,a0
     492:	|           |         move.b (a0),d0
     494:	|           '-------- bne.s 464 <encodeFilename+0x34c>
		}

		return copyString (nameIn);
     496:	|                     move.l 32(sp),-(sp)
     49a:	|                     jsr b8 <copyString>
     4a0:	|                     addq.l #4,sp
	}
}
     4a2:	'-------------------> movea.l (sp)+,a6
     4a4:	                      lea 24(sp),sp
     4a8:	                      rts

000004aa <FLOATSwap>:

FLOAT FLOATSwap( FLOAT f )
{
     4aa:	subq.l #8,sp
	{
		FLOAT f;
		unsigned char b[4];
	} dat1, dat2;

	dat1.f = f;
     4ac:	move.l 12(sp),4(sp)
	dat2.b[0] = dat1.b[3];
     4b2:	move.b 7(sp),d0
     4b6:	move.b d0,(sp)
	dat2.b[1] = dat1.b[2];
     4b8:	move.b 6(sp),d0
     4bc:	move.b d0,1(sp)
	dat2.b[2] = dat1.b[1];
     4c0:	move.b 5(sp),d0
     4c4:	move.b d0,2(sp)
	dat2.b[3] = dat1.b[0];
     4c8:	move.b 4(sp),d0
     4cc:	move.b d0,3(sp)
	return dat2.f;
     4d0:	move.l (sp),d0
}
     4d2:	addq.l #8,sp
     4d4:	rts

000004d6 <get2bytes>:

int get2bytes (BPTR fp) {
     4d6:	lea -24(sp),sp
     4da:	move.l a6,-(sp)
	int f1, f2;

	f1 = FGetC (fp);
     4dc:	move.l 32(sp),24(sp)
     4e2:	move.l d020 <DOSBase>,d0
     4e8:	movea.l d0,a6
     4ea:	move.l 24(sp),d1
     4ee:	jsr -306(a6)
     4f2:	move.l d0,20(sp)
     4f6:	move.l 20(sp),d0
     4fa:	move.l d0,16(sp)
	f2 = FGetC (fp);
     4fe:	move.l 32(sp),12(sp)
     504:	move.l d020 <DOSBase>,d0
     50a:	movea.l d0,a6
     50c:	move.l 12(sp),d1
     510:	jsr -306(a6)
     514:	move.l d0,8(sp)
     518:	move.l 8(sp),d0
     51c:	move.l d0,4(sp)

	return (f1 * 256 + f2);
     520:	move.l 16(sp),d0
     524:	lsl.l #8,d0
     526:	add.l 4(sp),d0
}
     52a:	movea.l (sp)+,a6
     52c:	lea 24(sp),sp
     530:	rts

00000532 <get4bytes>:

ULONG get4bytes (BPTR fp) {
     532:	lea -52(sp),sp
     536:	move.l a6,-(sp)
	int f1, f2, f3, f4;

	f1 = FGetC (fp);
     538:	move.l 60(sp),52(sp)
     53e:	move.l d020 <DOSBase>,d0
     544:	movea.l d0,a6
     546:	move.l 52(sp),d1
     54a:	jsr -306(a6)
     54e:	move.l d0,48(sp)
     552:	move.l 48(sp),d0
     556:	move.l d0,44(sp)
	f2 = FGetC (fp);
     55a:	move.l 60(sp),40(sp)
     560:	move.l d020 <DOSBase>,d0
     566:	movea.l d0,a6
     568:	move.l 40(sp),d1
     56c:	jsr -306(a6)
     570:	move.l d0,36(sp)
     574:	move.l 36(sp),d0
     578:	move.l d0,32(sp)
	f3 = FGetC (fp);
     57c:	move.l 60(sp),28(sp)
     582:	move.l d020 <DOSBase>,d0
     588:	movea.l d0,a6
     58a:	move.l 28(sp),d1
     58e:	jsr -306(a6)
     592:	move.l d0,24(sp)
     596:	move.l 24(sp),d0
     59a:	move.l d0,20(sp)
	f4 = FGetC (fp);
     59e:	move.l 60(sp),16(sp)
     5a4:	move.l d020 <DOSBase>,d0
     5aa:	movea.l d0,a6
     5ac:	move.l 16(sp),d1
     5b0:	jsr -306(a6)
     5b4:	move.l d0,12(sp)
     5b8:	move.l 12(sp),d0
     5bc:	move.l d0,8(sp)

	ULONG x = f1 + f2*256 + f3*256*256 + f4*256*256*256;
     5c0:	move.l 32(sp),d0
     5c4:	lsl.l #8,d0
     5c6:	move.l d0,d1
     5c8:	add.l 44(sp),d1
     5cc:	move.l 20(sp),d0
     5d0:	swap d0
     5d2:	clr.w d0
     5d4:	add.l d0,d1
     5d6:	move.l 8(sp),d0
     5da:	lsl.w #8,d0
     5dc:	swap d0
     5de:	clr.w d0
     5e0:	add.l d1,d0
     5e2:	move.l d0,4(sp)

	return x;
     5e6:	move.l 4(sp),d0
}
     5ea:	movea.l (sp)+,a6
     5ec:	lea 52(sp),sp
     5f0:	rts

000005f2 <getFloat>:

FLOAT getFloat (BPTR fp) {
     5f2:	    lea -28(sp),sp
     5f6:	    movem.l d2-d4/a6,-(sp)
	FLOAT f;
	LONG blocks_read = FRead( fp, &f, sizeof (FLOAT), 1 ); 
     5fa:	    move.l 48(sp),40(sp)
     600:	    lea 44(sp),a0
     604:	    lea -28(a0),a0
     608:	    move.l a0,36(sp)
     60c:	    moveq #4,d0
     60e:	    move.l d0,32(sp)
     612:	    moveq #1,d0
     614:	    move.l d0,28(sp)
     618:	    move.l d020 <DOSBase>,d0
     61e:	    movea.l d0,a6
     620:	    move.l 40(sp),d1
     624:	    move.l 36(sp),d2
     628:	    move.l 32(sp),d3
     62c:	    move.l 28(sp),d4
     630:	    jsr -324(a6)
     634:	    move.l d0,24(sp)
     638:	    move.l 24(sp),d0
     63c:	    move.l d0,20(sp)
	if (blocks_read != 1) {
     640:	    moveq #1,d0
     642:	    cmp.l 20(sp),d0
     646:	,-- beq.s 656 <getFloat+0x64>
		KPrintF("Reading error in getFloat.\n");
     648:	|   pea 7ca2 <PutChar+0x2e>
     64e:	|   jsr 725e <KPrintF>
     654:	|   addq.l #4,sp
	}
	return FLOATSwap(f);
     656:	'-> move.l 16(sp),d0
     65a:	    move.l d0,-(sp)
     65c:	    jsr 4aa <FLOATSwap>
     662:	    addq.l #4,sp
	return f;
}
     664:	    movem.l (sp)+,d2-d4/a6
     668:	    lea 28(sp),sp
     66c:	    rts

0000066e <readString>:
void putSigned (short f, BPTR fp) {
	f = shortSwap(f);
	Write(fp, &f, sizeof(short));
}

char * readString (BPTR fp) {
     66e:	          lea -32(sp),sp
     672:	          move.l a6,-(sp)

	int a, len = get2bytes (fp);
     674:	          move.l 40(sp),-(sp)
     678:	          jsr 4d6 <get2bytes>
     67e:	          addq.l #4,sp
     680:	          move.l d0,28(sp)
	//debugOut ("MOREIO: readString - len %i\n", len);
	char * s = AllocVec(len+1,MEMF_ANY);
     684:	          move.l 28(sp),d0
     688:	          addq.l #1,d0
     68a:	          move.l d0,24(sp)
     68e:	          clr.l 20(sp)
     692:	          move.l d018 <SysBase>,d0
     698:	          movea.l d0,a6
     69a:	          move.l 24(sp),d0
     69e:	          move.l 20(sp),d1
     6a2:	          jsr -684(a6)
     6a6:	          move.l d0,16(sp)
     6aa:	          move.l 16(sp),d0
     6ae:	          move.l d0,12(sp)
	if(s == 0) return NULL;
     6b2:	      ,-- bne.s 6b8 <readString+0x4a>
     6b4:	      |   moveq #0,d0
     6b6:	,-----|-- bra.s 70e <readString+0xa0>
	for (a = 0; a < len; a ++) {
     6b8:	|     '-> clr.l 32(sp)
     6bc:	|     ,-- bra.s 6f4 <readString+0x86>
		s[a] = (char) (FGetC (fp) - 1);
     6be:	|  ,--|-> move.l 40(sp),8(sp)
     6c4:	|  |  |   move.l d020 <DOSBase>,d0
     6ca:	|  |  |   movea.l d0,a6
     6cc:	|  |  |   move.l 8(sp),d1
     6d0:	|  |  |   jsr -306(a6)
     6d4:	|  |  |   move.l d0,4(sp)
     6d8:	|  |  |   move.l 4(sp),d0
     6dc:	|  |  |   move.l d0,d0
     6de:	|  |  |   move.b d0,d1
     6e0:	|  |  |   subq.b #1,d1
     6e2:	|  |  |   move.l 32(sp),d0
     6e6:	|  |  |   movea.l 12(sp),a0
     6ea:	|  |  |   adda.l d0,a0
     6ec:	|  |  |   move.b d1,d0
     6ee:	|  |  |   move.b d0,(a0)
	for (a = 0; a < len; a ++) {
     6f0:	|  |  |   addq.l #1,32(sp)
     6f4:	|  |  '-> move.l 32(sp),d0
     6f8:	|  |      cmp.l 28(sp),d0
     6fc:	|  '----- blt.s 6be <readString+0x50>
	}
	s[len] = 0;
     6fe:	|         move.l 28(sp),d0
     702:	|         movea.l 12(sp),a0
     706:	|         adda.l d0,a0
     708:	|         clr.b (a0)
	//debugOut ("MOREIO: readString: %s\n", s);
	return s;
     70a:	|         move.l 12(sp),d0
}
     70e:	'-------> movea.l (sp)+,a6
     710:	          lea 32(sp),sp
     714:	          rts

00000716 <displayCursor>:
int mouseCursorFrameNum = 0;
int mouseCursorCountUp = 0;

extern struct inputType input;

void displayCursor () {
     716:	    movem.l d2-d5,-(sp)

	
	if( mouseCursorAnim->theSprites)
     71a:	    movea.l cf44 <mouseCursorAnim>,a0
     720:	    move.l (a0),d0
     722:	,-- beq.w 822 <displayCursor+0x10c>
	{		
		CstDisplayCursor( input.mouseX + 128 - mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].xhot,
			input.mouseY + 44 - mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].yhot,
			mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].height,
			(UBYTE *) mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].data);
     726:	|   movea.l cf44 <mouseCursorAnim>,a0
     72c:	|   movea.l (a0),a0
     72e:	|   movea.l 16(a0),a1
     732:	|   movea.l cf44 <mouseCursorAnim>,a0
     738:	|   movea.l 4(a0),a0
     73c:	|   move.l (a0),d0
     73e:	|   move.l d0,d1
     740:	|   move.l d1,d0
     742:	|   lsl.l #3,d0
     744:	|   sub.l d1,d0
     746:	|   add.l d0,d0
     748:	|   add.l d0,d0
     74a:	|   lea (0,a1,d0.l),a0
     74e:	|   movea.l 24(a0),a1
			mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].height,
     752:	|   movea.l cf44 <mouseCursorAnim>,a0
     758:	|   movea.l (a0),a0
     75a:	|   move.l 16(a0),d2
     75e:	|   movea.l cf44 <mouseCursorAnim>,a0
     764:	|   movea.l 4(a0),a0
     768:	|   move.l (a0),d0
     76a:	|   move.l d0,d1
     76c:	|   move.l d1,d0
     76e:	|   lsl.l #3,d0
     770:	|   sub.l d1,d0
     772:	|   add.l d0,d0
     774:	|   add.l d0,d0
     776:	|   movea.l d2,a0
     778:	|   adda.l d0,a0
     77a:	|   move.l 4(a0),d0
		CstDisplayCursor( input.mouseX + 128 - mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].xhot,
     77e:	|   move.l d0,d0
     780:	|   moveq #0,d3
     782:	|   move.w d0,d3
			input.mouseY + 44 - mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].yhot,
     784:	|   move.l cfdc <input+0xe>,d0
     78a:	|   move.l d0,d2
     78c:	|   movea.l cf44 <mouseCursorAnim>,a0
     792:	|   movea.l (a0),a0
     794:	|   move.l 16(a0),d4
     798:	|   movea.l cf44 <mouseCursorAnim>,a0
     79e:	|   movea.l 4(a0),a0
     7a2:	|   move.l (a0),d0
     7a4:	|   move.l d0,d1
     7a6:	|   move.l d1,d0
     7a8:	|   lsl.l #3,d0
     7aa:	|   sub.l d1,d0
     7ac:	|   add.l d0,d0
     7ae:	|   add.l d0,d0
     7b0:	|   movea.l d4,a0
     7b2:	|   adda.l d0,a0
     7b4:	|   move.l 12(a0),d0
     7b8:	|   move.l d0,d0
     7ba:	|   move.w d2,d1
     7bc:	|   sub.w d0,d1
     7be:	|   move.w d1,d0
     7c0:	|   addi.w #44,d0
		CstDisplayCursor( input.mouseX + 128 - mouseCursorAnim->theSprites->bank.sprites[mouseCursorAnim->frames->frameNum].xhot,
     7c4:	|   moveq #0,d2
     7c6:	|   move.w d0,d2
     7c8:	|   move.l cfd8 <input+0xa>,d0
     7ce:	|   move.l d0,d4
     7d0:	|   movea.l cf44 <mouseCursorAnim>,a0
     7d6:	|   movea.l (a0),a0
     7d8:	|   move.l 16(a0),d5
     7dc:	|   movea.l cf44 <mouseCursorAnim>,a0
     7e2:	|   movea.l 4(a0),a0
     7e6:	|   move.l (a0),d0
     7e8:	|   move.l d0,d1
     7ea:	|   move.l d1,d0
     7ec:	|   lsl.l #3,d0
     7ee:	|   sub.l d1,d0
     7f0:	|   add.l d0,d0
     7f2:	|   add.l d0,d0
     7f4:	|   movea.l d5,a0
     7f6:	|   adda.l d0,a0
     7f8:	|   move.l 8(a0),d0
     7fc:	|   move.l d0,d0
     7fe:	|   move.w d4,d1
     800:	|   sub.w d0,d1
     802:	|   move.w d1,d0
     804:	|   addi.w #128,d0
     808:	|   move.w d0,d0
     80a:	|   andi.l #65535,d0
     810:	|   move.l a1,-(sp)
     812:	|   move.l d3,-(sp)
     814:	|   move.l d2,-(sp)
     816:	|   move.l d0,-(sp)
     818:	|   jsr a48 <CstDisplayCursor>
     81e:	|   lea 16(sp),sp
	}
}
     822:	'-> nop
     824:	    movem.l (sp)+,d2-d5
     828:	    rts

0000082a <CstCreateCopperlist>:
  KPrintF("CstBlankScreen: end\n");

  //custom->color[0] = 0x000;	
}

UWORD * CstCreateCopperlist( int width) {
     82a:	       lea -52(sp),sp
     82e:	       move.l a6,-(sp)
     830:	       move.l d2,-(sp)
  
  ULONG *retval = AllocMem(  CSTCOPSIZE, MEMF_CHIP);
     832:	       move.l #400,32(sp)
     83a:	       moveq #2,d0
     83c:	       move.l d0,28(sp)
     840:	       move.l d018 <SysBase>,d0
     846:	       movea.l d0,a6
     848:	       move.l 32(sp),d0
     84c:	       move.l 28(sp),d1
     850:	       jsr -198(a6)
     854:	       move.l d0,24(sp)
     858:	       move.l 24(sp),d0
     85c:	       move.l d0,20(sp)
  
  if( retval == 0) {
     860:	   ,-- bne.s 88a <CstCreateCopperlist+0x60>
    KPrintF("CstCreateCopperlist: Allocation of Ram for Copper failed.\n", 40);
     862:	   |   pea 28 <_start+0x28>
     866:	   |   pea 7d82 <PutChar+0x10e>
     86c:	   |   jsr 725e <KPrintF>
     872:	   |   addq.l #8,sp
    Exit(1);
     874:	   |   moveq #1,d1
     876:	   |   move.l d1,16(sp)
     87a:	   |   move.l d020 <DOSBase>,d0
     880:	   |   movea.l d0,a6
     882:	   |   move.l 16(sp),d1
     886:	   |   jsr -144(a6)
  }
  ULONG *cl = retval;
     88a:	   '-> move.l 20(sp),56(sp)
  CstClCursor = (UWORD *)cl;
     890:	       move.l 56(sp),cf76 <CstClCursor>

  ULONG *clpartinstruction;
  clpartinstruction = CstClSprites;
     898:	       move.l #52762,52(sp)
  for(int i=0; i<16;i++)
     8a0:	       clr.l 48(sp)
     8a4:	   ,-- bra.s 8ca <CstCreateCopperlist+0xa0>
    *cl++ = *clpartinstruction++;
     8a6:	,--|-> move.l 52(sp),d1
     8aa:	|  |   move.l d1,d2
     8ac:	|  |   addq.l #4,d2
     8ae:	|  |   move.l d2,52(sp)
     8b2:	|  |   move.l 56(sp),d0
     8b6:	|  |   move.l d0,d2
     8b8:	|  |   addq.l #4,d2
     8ba:	|  |   move.l d2,56(sp)
     8be:	|  |   movea.l d1,a0
     8c0:	|  |   move.l (a0),d1
     8c2:	|  |   movea.l d0,a0
     8c4:	|  |   move.l d1,(a0)
  for(int i=0; i<16;i++)
     8c6:	|  |   addq.l #1,48(sp)
     8ca:	|  '-> moveq #15,d0
     8cc:	|      cmp.l 48(sp),d0
     8d0:	'----- bge.s 8a6 <CstCreateCopperlist+0x7c>

  clpartinstruction = CstClScreen;
     8d2:	       move.l #52826,52(sp)

  for(int i=0; i<12;i++)
     8da:	       clr.l 44(sp)
     8de:	   ,-- bra.s 904 <CstCreateCopperlist+0xda>
    *cl++ = *clpartinstruction++;
     8e0:	,--|-> move.l 52(sp),d1
     8e4:	|  |   move.l d1,d2
     8e6:	|  |   addq.l #4,d2
     8e8:	|  |   move.l d2,52(sp)
     8ec:	|  |   move.l 56(sp),d0
     8f0:	|  |   move.l d0,d2
     8f2:	|  |   addq.l #4,d2
     8f4:	|  |   move.l d2,56(sp)
     8f8:	|  |   movea.l d1,a0
     8fa:	|  |   move.l (a0),d1
     8fc:	|  |   movea.l d0,a0
     8fe:	|  |   move.l d1,(a0)
  for(int i=0; i<12;i++)
     900:	|  |   addq.l #1,44(sp)
     904:	|  '-> moveq #11,d0
     906:	|      cmp.l 44(sp),d0
     90a:	'----- bge.s 8e0 <CstCreateCopperlist+0xb6>

  clpartinstruction = CstClBitplanes;
     90c:	       move.l #52874,52(sp)
  for(int i=0; i<10;i++)
     914:	       clr.l 40(sp)
     918:	   ,-- bra.s 93e <CstCreateCopperlist+0x114>
    *cl++ = *clpartinstruction++;        
     91a:	,--|-> move.l 52(sp),d1
     91e:	|  |   move.l d1,d2
     920:	|  |   addq.l #4,d2
     922:	|  |   move.l d2,52(sp)
     926:	|  |   move.l 56(sp),d0
     92a:	|  |   move.l d0,d2
     92c:	|  |   addq.l #4,d2
     92e:	|  |   move.l d2,56(sp)
     932:	|  |   movea.l d1,a0
     934:	|  |   move.l (a0),d1
     936:	|  |   movea.l d0,a0
     938:	|  |   move.l d1,(a0)
  for(int i=0; i<10;i++)
     93a:	|  |   addq.l #1,40(sp)
     93e:	|  '-> moveq #9,d0
     940:	|      cmp.l 40(sp),d0
     944:	'----- bge.s 91a <CstCreateCopperlist+0xf0>

  
  clpartinstruction = CstClColorTemplate;
     946:	       move.l #52914,52(sp)
  CstClColor = (UWORD *) cl;
     94e:	       move.l 56(sp),cf6c <CstClColor>
  for(int i=0; i<32;i++)
     956:	       clr.l 36(sp)
     95a:	   ,-- bra.s 980 <CstCreateCopperlist+0x156>
    *cl++ = *clpartinstruction++;        
     95c:	,--|-> move.l 52(sp),d1
     960:	|  |   move.l d1,d2
     962:	|  |   addq.l #4,d2
     964:	|  |   move.l d2,52(sp)
     968:	|  |   move.l 56(sp),d0
     96c:	|  |   move.l d0,d2
     96e:	|  |   addq.l #4,d2
     970:	|  |   move.l d2,56(sp)
     974:	|  |   movea.l d1,a0
     976:	|  |   move.l (a0),d1
     978:	|  |   movea.l d0,a0
     97a:	|  |   move.l d1,(a0)
  for(int i=0; i<32;i++)
     97c:	|  |   addq.l #1,36(sp)
     980:	|  '-> moveq #31,d0
     982:	|      cmp.l 36(sp),d0
     986:	'----- bge.s 95c <CstCreateCopperlist+0x132>
 
  /* Screen is bigger than real screen? Setup BPLxMod accordingly*/
  if(width > 40) {
     988:	       moveq #40,d1
     98a:	       cmp.l 64(sp),d1
     98e:	   ,-- bge.s 9ec <CstCreateCopperlist+0x1c2>
    int tmp = width - 40;
     990:	   |   moveq #-40,d2
     992:	   |   add.l 64(sp),d2
     996:	   |   move.l d2,12(sp)
    UWORD *cw = (UWORD *) cl; 
     99a:	   |   move.l 56(sp),8(sp)
    *cw++ = 0x108;
     9a0:	   |   move.l 8(sp),d0
     9a4:	   |   move.l d0,d1
     9a6:	   |   addq.l #2,d1
     9a8:	   |   move.l d1,8(sp)
     9ac:	   |   movea.l d0,a0
     9ae:	   |   move.w #264,(a0)
    *cw++ = tmp;
     9b2:	   |   move.l 8(sp),d0
     9b6:	   |   move.l d0,d1
     9b8:	   |   addq.l #2,d1
     9ba:	   |   move.l d1,8(sp)
     9be:	   |   move.l 12(sp),d1
     9c2:	   |   movea.l d0,a0
     9c4:	   |   move.w d1,(a0)
    *cw++ = 0x10a;
     9c6:	   |   move.l 8(sp),d0
     9ca:	   |   move.l d0,d1
     9cc:	   |   addq.l #2,d1
     9ce:	   |   move.l d1,8(sp)
     9d2:	   |   movea.l d0,a0
     9d4:	   |   move.w #266,(a0)
    *cw++ = tmp;     
     9d8:	   |   move.l 8(sp),d0
     9dc:	   |   move.l d0,d1
     9de:	   |   addq.l #2,d1
     9e0:	   |   move.l d1,8(sp)
     9e4:	   |   move.l 12(sp),d1
     9e8:	   |   movea.l d0,a0
     9ea:	   |   move.w d1,(a0)
  }

  *cl++ = 0xffdffffe;
     9ec:	   '-> move.l 56(sp),d0
     9f0:	       move.l d0,d1
     9f2:	       addq.l #4,d1
     9f4:	       move.l d1,56(sp)
     9f8:	       movea.l d0,a0
     9fa:	       move.l #-2097154,(a0)
  *cl++ = 0x2d01ff00;
     a00:	       move.l 56(sp),d0
     a04:	       move.l d0,d1
     a06:	       addq.l #4,d1
     a08:	       move.l d1,56(sp)
     a0c:	       movea.l d0,a0
     a0e:	       move.l #755105536,(a0)
  *cl++ = 0x9c8010;
     a14:	       move.l 56(sp),d0
     a18:	       move.l d0,d1
     a1a:	       addq.l #4,d1
     a1c:	       move.l d1,56(sp)
     a20:	       movea.l d0,a0
     a22:	       move.l #10256400,(a0)

  *cl++ = 0xfffffffe;
     a28:	       move.l 56(sp),d0
     a2c:	       move.l d0,d1
     a2e:	       addq.l #4,d1
     a30:	       move.l d1,56(sp)
     a34:	       moveq #-2,d2
     a36:	       movea.l d0,a0
     a38:	       move.l d2,(a0)
  return (UWORD *) retval;  
     a3a:	       move.l 20(sp),d0
}
     a3e:	       move.l (sp)+,d2
     a40:	       movea.l (sp)+,a6
     a42:	       lea 52(sp),sp
     a46:	       rts

00000a48 <CstDisplayCursor>:
  custom->bltsize = height * 64 + bltwidth;

}

void CstDisplayCursor(UWORD x, UWORD y, UWORD height, UBYTE *spritedata)
{
     a48:	lea -20(sp),sp
     a4c:	movea.l 24(sp),a0
     a50:	move.l 28(sp),d1
     a54:	move.l 32(sp),d0
     a58:	movea.w a0,a0
     a5a:	move.w a0,4(sp)
     a5e:	move.w d1,d1
     a60:	move.w d1,2(sp)
     a64:	move.w d0,d0
     a66:	move.w d0,(sp)
  spritedata[0] = (UBYTE) (y & 0xff); //Low 8 Bits of y
     a68:	move.w 2(sp),d0
     a6c:	movea.l 36(sp),a0
     a70:	move.b d0,(a0)
  spritedata[1] = (UBYTE) (x >> 1); //High 8 Bits of x
     a72:	move.w 4(sp),d0
     a76:	lsr.w #1,d0
     a78:	movea.l 36(sp),a0
     a7c:	addq.l #1,a0
     a7e:	move.l d0,d0
     a80:	move.b d0,(a0)
  spritedata[2] = (UBYTE) (y+height & 0xff); //Sprite Stop Low 8 Bits
     a82:	move.w 2(sp),d1
     a86:	move.w (sp),d0
     a88:	movea.l 36(sp),a0
     a8c:	addq.l #2,a0
     a8e:	add.b d1,d0
     a90:	move.b d0,(a0)

  UWORD lowbitx = x & 0x1;
     a92:	move.w 4(sp),d0
     a96:	andi.w #1,d0
     a9a:	move.w d0,18(sp)
  UWORD vstophighbit = ((y+height) & 0x100) >> 7;
     a9e:	move.w 2(sp),d0
     aa2:	add.w (sp),d0
     aa4:	move.w d0,d0
     aa6:	andi.l #65535,d0
     aac:	asr.l #7,d0
     aae:	move.l d0,d0
     ab0:	move.w d0,d1
     ab2:	andi.w #2,d1
     ab6:	move.w d1,16(sp)
  UWORD vstarthighbit = (y & 0x100) >> 6;
     aba:	moveq #0,d0
     abc:	move.w 2(sp),d0
     ac0:	asr.l #6,d0
     ac2:	move.l d0,d0
     ac4:	move.w d0,d1
     ac6:	andi.w #4,d1
     aca:	move.w d1,14(sp)

  spritedata[3] = lowbitx + vstophighbit + vstarthighbit; //Low Bit X, Sprite Stop High Bit
     ace:	move.w 18(sp),d1
     ad2:	move.w 16(sp),d0
     ad6:	add.b d0,d1
     ad8:	move.w 14(sp),d0
     adc:	movea.l 36(sp),a0
     ae0:	addq.l #3,a0
     ae2:	add.b d1,d0
     ae4:	move.b d0,(a0)

  ULONG ptr = (ULONG) spritedata; 
     ae6:	move.l 36(sp),10(sp)
  UWORD loptr = (UWORD) ptr & 0xffff;
     aec:	move.w 12(sp),8(sp)
  UWORD hiptr = ptr >> 16;
     af2:	move.l 10(sp),d0
     af6:	clr.w d0
     af8:	swap d0
     afa:	move.w d0,6(sp)

  CstClCursor[1] = hiptr;
     afe:	move.l cf76 <CstClCursor>,d0
     b04:	movea.l d0,a0
     b06:	addq.l #2,a0
     b08:	move.w 6(sp),(a0)
  CstClCursor[3] = loptr;
     b0c:	move.l cf76 <CstClCursor>,d0
     b12:	movea.l d0,a0
     b14:	addq.l #6,a0
     b16:	move.w 8(sp),(a0)

}
     b1a:	nop
     b1c:	lea 20(sp),sp
     b20:	rts

00000b22 <CstDrawZBuffer>:

__attribute__((optimize("Ofast"))) 
UBYTE *CstDrawZBuffer( struct sprite *sprite, struct zBufferData *zbuffer, WORD x, WORD y) 
{
     b22:	                                                                subq.l #8,sp
     b24:	                                                                movem.l d2-d7/a2-a6,-(sp)
     b28:	                                                                movea.l 56(sp),a3
     b2c:	                                                                movea.l 60(sp),a2
     b30:	                                                                move.l 64(sp),d2
     b34:	                                                                move.l 68(sp),d7
     b38:	                                                                movea.w d2,a4
     b3a:	                                                                move.w d7,50(sp)
  //In Case nothing needs to be done return sprite mask without changes
       
  WORD zbufferset = 0;

  #ifdef EMULATOR
    debug_register_bitmap(CstZBufferResult, "SpriteMask", sprite->width, sprite->height, 1, 0);
     b3e:	                                                                clr.l -(sp)
     b40:	                                                                pea 1 <_start+0x1>
     b44:	                                                                movea.w 6(a3),a0
     b48:	                                                                move.l a0,-(sp)
     b4a:	                                                                movea.w 2(a3),a0
     b4e:	                                                                move.l a0,-(sp)
     b50:	                                                                pea 7dcf <PutChar+0x15b>
     b56:	                                                                move.l cf7a <CstZBufferResult>,-(sp)
     b5c:	                                                                lea 7346 <debug_register_bitmap>,a5
     b62:	                                                                jsr (a5)
    debug_register_bitmap(CstZBufferWork, "tmbpuffer", sprite->width+16, sprite->height, 1, 0);
     b64:	                                                                clr.l -(sp)
     b66:	                                                                pea 1 <_start+0x1>
     b6a:	                                                                movea.w 6(a3),a0
     b6e:	                                                                move.l a0,-(sp)
     b70:	                                                                move.w 2(a3),d0
     b74:	                                                                addi.w #16,d0
     b78:	                                                                movea.w d0,a0
     b7a:	                                                                move.l a0,-(sp)
     b7c:	                                                                pea 7dda <PutChar+0x166>
     b82:	                                                                move.l cf7e <CstZBufferWork>,-(sp)
     b88:	                                                                jsr (a5)
  #endif    

  while(zbuffer) 
     b8a:	                                                                lea 48(sp),sp
     b8e:	                                                                cmpa.w #0,a2
     b92:	,-------------------------------------------------------------- beq.w 1050 <CstDrawZBuffer+0x52e>
  {              
    WORD spritex1oncanvas = x;
    UWORD spritex2oncanvas = spritex1oncanvas+sprite->width;
     b96:	|                                                               move.w d2,48(sp)
     b9a:	|                                                               move.l (a3),d2
    WORD spritey1oncanvas = y;
    UWORD spritey2oncanvas = spritey1oncanvas + sprite->height;
     b9c:	|                                                               movea.l 4(a3),a5
  WORD zbufferset = 0;
     ba0:	|                                                               clr.w 46(sp)
    UWORD spritey2oncanvas = spritey1oncanvas + sprite->height;
     ba4:	|                       ,-------------------------------------> move.w a5,d3
     ba6:	|                       |                                       add.w d7,d3
    BOOL zbufferfromleft = FALSE;
    BOOL zbufferfrombottom = FALSE;
    BOOL zbufferfromtop = FALSE;
  
    //Sprite will be drawn behind the zBuffer. We need to do something
    if(spritey2oncanvas < zbuffer->yz) 
     ba8:	|                       |                                       andi.l #65535,d3
     bae:	|                       |                                       cmp.l 16(a2),d3
     bb2:	|        ,--------------|-------------------------------------- bge.w d58 <CstDrawZBuffer+0x236>
    WORD zbufferx1oncanvas = zbuffer->topx;
     bb6:	|        |              |                                       move.l 8(a2),d6
    WORD zbuffery1oncanvas = zbuffer->topy;
     bba:	|        |              |                                       move.l 12(a2),d5
    WORD zbufferx2oncanvas = zbufferx1oncanvas + zbuffer->width;
     bbe:	|        |              |                                       move.w d6,d0
     bc0:	|        |              |                                       add.w 2(a2),d0
    WORD zbuffery2oncanvas = zbuffery1oncanvas + zbuffer->height;
     bc4:	|        |              |                                       move.w 6(a2),d4
     bc8:	|        |              |                                       add.w d5,d4
    {    
      //sprite ------------x1+++++++++++++++++++x2-----------------*/
      /*zbuffer-------------------x1++++++++++?????????------------*/      
      if(spritex1oncanvas <= zbufferx1oncanvas && spritex2oncanvas > zbufferx1oncanvas)
     bca:	|        |              |                                       cmp.w a4,d6
     bcc:	|        |           ,--|-------------------------------------- bge.w ee4 <CstDrawZBuffer+0x3c2>
        zbufferfromright = TRUE;
      //sprite -------------------------x1++++??????-------*/
      /*zbuffer-------------------x1+++++++++++x2----------*/  
      else if(spritex1oncanvas > zbufferx1oncanvas && spritex1oncanvas < zbufferx2oncanvas)
     bd0:	|        |           |  |                                       cmp.w a4,d0
     bd2:	|        +-----------|--|-------------------------------------- ble.w d58 <CstDrawZBuffer+0x236>
        zbufferfromleft = TRUE;       

      //Overlap on X-Axis. Now Check y-axis
      if( zbufferfromleft || zbufferfromright)         
      {
        if(spritey1oncanvas <= zbuffery1oncanvas && spritey2oncanvas > zbuffery1oncanvas)
     bd6:	|        |           |  |                                       move.w 50(sp),d0
     bda:	|        |           |  |                                       cmp.w d0,d5
     bdc:	|        |     ,-----|--|-------------------------------------- blt.w 1030 <CstDrawZBuffer+0x50e>
     be0:	|        |     |     |  |                                       movea.w d5,a0
        else if(spritey1oncanvas > zbuffery1oncanvas && spritey1oncanvas < zbuffery2oncanvas)
          zbufferfromtop = TRUE;       
      }

      //Overlap on both Axis
      if( (zbufferfromright || zbufferfromleft) && (zbufferfrombottom || zbufferfromtop))
     be2:	|        |     |     |  |                                       cmpa.l d3,a0
     be4:	|        +-----|-----|--|-------------------------------------- bge.w d58 <CstDrawZBuffer+0x236>
        {    
          //Get Distance R
          /*sprite  ------------x1++++++++++?????????-------------------------*/    
          //zbuffer ------------------x1+++++++++++++++++++x2-----------------*/             
          
          xdiff = spritex1oncanvas - zbufferx1oncanvas;
     be8:	|        |     |     |  |                                       move.w 48(sp),d0
     bec:	|        |     |     |  |                                       sub.w d6,d0
          xdiffbyte = (xdiff / 16) * 2;          
          xdiffrest = (xdiff - xdiffbyte * 8);    
     bee:	|        |     |     |  |                                       move.w d0,d6
     bf0:	|        |     |     |  |                                       andi.w #15,d6
     bf4:	|        |     |     |  |                                       movea.w d6,a5

                         
          bytewidth = (sprite->width/16)*2;
     bf6:	|        |     |     |  |                                       tst.l d2
     bf8:	|        |  ,--|-----|--|-------------------------------------- blt.w d7a <CstDrawZBuffer+0x258>
     bfc:	|        |  |  |  ,--|--|-------------------------------------> asr.l #4,d2
     bfe:	|        |  |  |  |  |  |                                       add.w d2,d2
          if(sprite->height == 60) {
            sprite->height = 60;
          }
          
          custom->bltafwm = 0xffff;
     c00:	|        |  |  |  |  |  |                                       move.w #-1,dff044 <gcc8_c_support.c.c60c1f2b+0xdb1b95>
          custom->bltalwm = 0xffff;                      
     c08:	|        |  |  |  |  |  |                                       move.w #-1,dff046 <gcc8_c_support.c.c60c1f2b+0xdb1b97>
          custom->bltcon1 = 0;          
     c10:	|        |  |  |  |  |  |                                       move.w #0,dff042 <gcc8_c_support.c.c60c1f2b+0xdb1b93>

          if (xdiffrest) {
            bytewidth += 2; 
            //xdiffbyte += -2;            
            bltapt = (ULONG) zbuffer->bitplane + xdiffbyte;  
            WaitBlit();   
     c18:	|        |  |  |  |  |  |                                       lea d024 <GfxBase>,a0
     c1e:	|        |  |  |  |  |  |                                       movea.l (a0),a6
          xdiffbyte = (xdiff / 16) * 2;          
     c20:	|        |  |  |  |  |  |                                       lsr.w #4,d0
     c22:	|        |  |  |  |  |  |                                       move.w d0,d6
     c24:	|        |  |  |  |  |  |                                       add.w d0,d6
            bltapt = (ULONG) zbuffer->bitplane + xdiffbyte;  
     c26:	|        |  |  |  |  |  |                                       andi.l #65535,d6
     c2c:	|        |  |  |  |  |  |                                       add.l 20(a2),d6
          if (xdiffrest) {
     c30:	|        |  |  |  |  |  |                                       clr.w d0
     c32:	|        |  |  |  |  |  |                                       cmp.w a5,d0
     c34:	|        |  |  |  |  |  |        ,----------------------------- beq.w dba <CstDrawZBuffer+0x298>
            bytewidth += 2; 
     c38:	|        |  |  |  |  |  |        |        ,-------------------> addq.w #2,d2
            WaitBlit();   
     c3a:	|        |  |  |  |  |  |        |        |                     jsr -228(a6)
            custom->bltdpt = CstZBufferWork;                
     c3e:	|        |  |  |  |  |  |        |        |                     move.l cf7e <CstZBufferWork>,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
            custom->bltcon0 = (16 - xdiffrest) * 4096 + 0x9f0;              
     c48:	|        |  |  |  |  |  |        |        |                     move.w a5,d0
     c4a:	|        |  |  |  |  |  |        |        |                     moveq #12,d1
     c4c:	|        |  |  |  |  |  |        |        |                     lsl.w d1,d0
     c4e:	|        |  |  |  |  |  |        |        |                     move.w #2544,d1
     c52:	|        |  |  |  |  |  |        |        |                     sub.w d0,d1
     c54:	|        |  |  |  |  |  |        |        |                     move.w d1,dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
            custom->bltamod = zbuffer->width/8 - bytewidth;
     c5a:	|        |  |  |  |  |  |        |        |                     move.l (a2),d0
     c5c:	|        |  |  |  |  |  |        |        |                     move.l d0,d1
     c5e:	|  ,-----|--|--|--|--|--|--------|--------|-------------------- bmi.w 1102 <CstDrawZBuffer+0x5e0>
     c62:	|  |     |  |  |  |  |  |        |        |                     asr.l #3,d1
     c64:	|  |     |  |  |  |  |  |        |        |                     sub.w d2,d1
     c66:	|  |     |  |  |  |  |  |        |        |                     move.w d1,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
            custom->bltdmod = 0;                                                            
     c6c:	|  |     |  |  |  |  |  |        |        |                     move.w #0,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
        } 
        
        //Get Distance R
        //zbuffer ------------x1+++++++++++++++++++x2-----------------*/
        /*sprite--------------RRRRRRRRx1++++++++++?????????------------*/    
        UWORD ydiff = spritey1oncanvas - zbuffery1oncanvas;
     c74:	|  |  ,--|--|--|--|--|--|--------|--------|-------------------> move.w d7,d1
     c76:	|  |  |  |  |  |  |  |  |        |        |                     sub.w d5,d1

        UWORD height;
        if( zbuffery2oncanvas > spritey2oncanvas) 
     c78:	|  |  |  |  |  |  |  |  |        |        |                     movea.w d4,a0
     c7a:	|  |  |  |  |  |  |  |  |        |        |                     cmpa.l d3,a0
     c7c:	|  |  |  |  |  |  |  |  |        |     ,--|-------------------- ble.w dfa <CstDrawZBuffer+0x2d8>
          height = sprite->height;
     c80:	|  |  |  |  |  |  |  |  |        |     |  |        ,----------> move.l 4(a3),d4
        else
          height = zbuffery2oncanvas - spritey1oncanvas;

        custom->bltapt = (APTR) bltapt + ydiff*zbuffer->width/8; 
     c84:	|  |  |  |  |  |  |  |  |        |     |  |        |            move.l d0,-(sp)
     c86:	|  |  |  |  |  |  |  |  |        |     |  |        |            move.w d1,-(sp)
     c88:	|  |  |  |  |  |  |  |  |        |     |  |        |            clr.w -(sp)
     c8a:	|  |  |  |  |  |  |  |  |        |     |  |        |            jsr 7b8c <__mulsi3>
     c90:	|  |  |  |  |  |  |  |  |        |     |  |        |            addq.l #8,sp
     c92:	|  |  |  |  |  |  |  |  |        |     |  |        |            tst.l d0
     c94:	|  |  |  |  |  |  |  |  |        |     |  |  ,-----|----------- blt.w e10 <CstDrawZBuffer+0x2ee>
     c98:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  ,-------> asr.l #3,d0
     c9a:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         add.l d6,d0
     c9c:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.l d0,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
        UWORD bltsize =  height*64+bytewidth/2;          
     ca2:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         lsl.w #6,d4
     ca4:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         lsr.w #1,d2
        custom->bltsize = height*64+bytewidth/2;
     ca6:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         add.w d2,d4
     ca8:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.w d4,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
       
        WaitBlit();
     cae:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         lea d024 <GfxBase>,a0
     cb4:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         movea.l (a0),a6
     cb6:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         jsr -228(a6)

        custom->bltafwm = 0xffff;
     cba:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.w #-1,dff044 <gcc8_c_support.c.c60c1f2b+0xdb1b95>
        custom->bltalwm = 0xffff;
     cc2:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.w #-1,dff046 <gcc8_c_support.c.c60c1f2b+0xdb1b97>
        custom->bltamod = 2;
     cca:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.w #2,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
        custom->bltbmod = 0;
     cd2:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.w #0,dff062 <gcc8_c_support.c.c60c1f2b+0xdb1bb3>
        custom->bltdmod = 0;
     cda:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.w #0,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
        custom->bltcon0 = 0xd0c; //Copy A to D
     ce2:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.w #3340,dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
        custom->bltcon1 = 0;        
     cea:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.w #0,dff042 <gcc8_c_support.c.c60c1f2b+0xdb1b93>

        custom->bltapt = (APTR) CstZBufferWork + 2;
     cf2:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.l cf7e <CstZBufferWork>,d0
     cf8:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         addq.l #2,d0
     cfa:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.l d0,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>

        if (zbufferset == 0) {
          custom->bltbpt = (APTR) ((ULONG) sprite->data)+(sprite->width/8)*sprite->height*5;
     d00:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         move.l (a3),d2
     d02:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         movea.l 4(a3),a5
        if (zbufferset == 0) {
     d06:	|  |  |  |  |  |  |  |  |        |     |  |  |     |  |         tst.w 46(sp)
     d0a:	|  |  |  |  |  |  |  |  |        |  ,--|--|--|-----|--|-------- bne.w e88 <CstDrawZBuffer+0x366>
          custom->bltbpt = (APTR) ((ULONG) sprite->data)+(sprite->width/8)*sprite->height*5;
     d0e:	|  |  |  |  |  |  |  |  |        |  |  |  |  |  ,--|--|-------> move.l d2,d0
     d10:	|  |  |  |  |  |  |  |  |  ,-----|--|--|--|--|--|--|--|-------- bmi.w ebe <CstDrawZBuffer+0x39c>
     d14:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         asr.l #3,d0
     d16:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         move.l a5,-(sp)
     d18:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         move.l d0,-(sp)
     d1a:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         jsr 7b8c <__mulsi3>
     d20:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         addq.l #8,sp
     d22:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         move.l d0,d1
     d24:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         add.l d0,d1
     d26:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         add.l d1,d1
     d28:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         add.l d0,d1
     d2a:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         add.l 24(a3),d1
     d2e:	|  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |         move.l d1,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
        }
        else {
          custom->bltbpt = (APTR) CstZBufferResult;
        }
        custom->bltdpt = (APTR) CstZBufferResult;
     d34:	|  |  |  |  |  |  |  |  |  |  ,--|--|--|--|--|--|--|--|-------> move.l cf7a <CstZBufferResult>,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
        custom->bltsize = (sprite->height<<6)+sprite->width/16;  
     d3e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |         move.w a5,d1
     d40:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |         lsl.w #6,d1
     d42:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |         move.l d2,d0
     d44:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  ,----- bmi.w ea6 <CstDrawZBuffer+0x384>
     d48:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  ,-> asr.l #4,d0
     d4a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   add.w d1,d0
     d4c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
        zbufferset = 1;
     d52:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   move.w #1,46(sp)
      }
    }
    zbuffer = zbuffer->nextPanel;
     d58:	|  |  |  >--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-> movea.l 24(a2),a2
  while(zbuffer) 
     d5c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   cmpa.w #0,a2
     d60:	|  |  |  |  |  |  |  |  '--|--|--|--|--|--|--|--|--|--|--|--|-- bne.w ba4 <CstDrawZBuffer+0x82>
  }
  
  if(zbufferset == 0)
     d64:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   tst.w 46(sp)
     d68:	+--|--|--|--|--|--|--|-----|--|--|--|--|--|--|--|--|--|--|--|-- beq.w 1050 <CstDrawZBuffer+0x52e>
    custom->bltdpt = (APTR) CstZBufferResult;
    custom->bltsize = (sprite->height<<6)+sprite->width/16;      

  }

  return CstZBufferResult;
     d6c:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   move.l cf7a <CstZBufferResult>,d0

}
     d72:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   movem.l (sp)+,d2-d7/a2-a6
     d76:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   addq.l #8,sp
     d78:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   rts
          bytewidth = (sprite->width/16)*2;
     d7a:	|  |  |  |  >--|--|--|-----|--|--|--|--|--|--|--|--|--|--|--|-> moveq #15,d1
     d7c:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   add.l d1,d2
     d7e:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   asr.l #4,d2
     d80:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   add.w d2,d2
          custom->bltafwm = 0xffff;
     d82:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   move.w #-1,dff044 <gcc8_c_support.c.c60c1f2b+0xdb1b95>
          custom->bltalwm = 0xffff;                      
     d8a:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   move.w #-1,dff046 <gcc8_c_support.c.c60c1f2b+0xdb1b97>
          custom->bltcon1 = 0;          
     d92:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   move.w #0,dff042 <gcc8_c_support.c.c60c1f2b+0xdb1b93>
            WaitBlit();   
     d9a:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   lea d024 <GfxBase>,a0
     da0:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   movea.l (a0),a6
          xdiffbyte = (xdiff / 16) * 2;          
     da2:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   lsr.w #4,d0
     da4:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   move.w d0,d6
     da6:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   add.w d0,d6
            bltapt = (ULONG) zbuffer->bitplane + xdiffbyte;  
     da8:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   andi.l #65535,d6
     dae:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   add.l 20(a2),d6
          if (xdiffrest) {
     db2:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   clr.w d0
     db4:	|  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |   cmp.w a5,d0
     db6:	|  |  |  |  |  |  |  |     |  |  |  |  |  '--|--|--|--|--|--|-- bne.w c38 <CstDrawZBuffer+0x116>
            WaitBlit();         
     dba:	|  |  |  |  |  |  |  |     |  |  '--|--|-----|--|--|--|--|--|-> jsr -228(a6)
            custom->bltdpt = CstZBufferWork + 2;       
     dbe:	|  |  |  |  |  |  |  |     |  |     |  |     |  |  |  |  |  |   move.l cf7e <CstZBufferWork>,d0
     dc4:	|  |  |  |  |  |  |  |     |  |     |  |     |  |  |  |  |  |   addq.l #2,d0
     dc6:	|  |  |  |  |  |  |  |     |  |     |  |     |  |  |  |  |  |   move.l d0,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
            custom->bltcon0 = 4096 + 0x9f0;              
     dcc:	|  |  |  |  |  |  |  |     |  |     |  |     |  |  |  |  |  |   move.w #6640,dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
            custom->bltamod = zbuffer->width/8 - bytewidth;
     dd4:	|  |  |  |  |  |  |  |     |  |     |  |     |  |  |  |  |  |   move.l (a2),d0
     dd6:	|  |  |  |  |  |  |  |     |  |     |  |     |  |  |  |  |  |   move.l d0,d1
     dd8:	|  |  |  |  |  |  |  |  ,--|--|-----|--|-----|--|--|--|--|--|-- bmi.w 10ea <CstDrawZBuffer+0x5c8>
     ddc:	|  |  |  |  |  |  |  |  |  |  |     |  |     |  |  |  |  |  |   asr.l #3,d1
     dde:	|  |  |  |  |  |  |  |  |  |  |     |  |     |  |  |  |  |  |   sub.w d2,d1
     de0:	|  |  |  |  |  |  |  |  |  |  |     |  |     |  |  |  |  |  |   move.w d1,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
            custom->bltdmod = 2;                                                            
     de6:	|  |  |  |  |  |  |  |  |  |  |     |  |     |  |  |  |  |  |   move.w #2,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
        UWORD ydiff = spritey1oncanvas - zbuffery1oncanvas;
     dee:	|  |  |  |  |  |  |  |  |  |  |  ,--|--|-----|--|--|--|--|--|-> move.w d7,d1
     df0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |   sub.w d5,d1
        if( zbuffery2oncanvas > spritey2oncanvas) 
     df2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |   movea.w d4,a0
     df4:	|  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |   cmpa.l d3,a0
     df6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  '--|--|--|-- bgt.w c80 <CstDrawZBuffer+0x15e>
          height = zbuffery2oncanvas - spritey1oncanvas;
     dfa:	|  |  |  |  |  |  |  |  |  |  |  |  |  '-----|--|-----|--|--|-> sub.w d7,d4
        custom->bltapt = (APTR) bltapt + ydiff*zbuffer->width/8; 
     dfc:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |     |  |  |   move.l d0,-(sp)
     dfe:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |     |  |  |   move.w d1,-(sp)
     e00:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |     |  |  |   clr.w -(sp)
     e02:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |     |  |  |   jsr 7b8c <__mulsi3>
     e08:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |     |  |  |   addq.l #8,sp
     e0a:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |     |  |  |   tst.l d0
     e0c:	|  |  |  |  |  |  |  |  |  |  |  |  |        |  |     '--|--|-- bge.w c98 <CstDrawZBuffer+0x176>
     e10:	|  |  |  |  |  |  |  |  |  |  |  |  |        '--|--------|--|-> addq.l #7,d0
     e12:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   asr.l #3,d0
     e14:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   add.l d6,d0
     e16:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.l d0,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
        UWORD bltsize =  height*64+bytewidth/2;          
     e1c:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   lsl.w #6,d4
     e1e:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   lsr.w #1,d2
        custom->bltsize = height*64+bytewidth/2;
     e20:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   add.w d2,d4
     e22:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.w d4,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
        WaitBlit();
     e28:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   lea d024 <GfxBase>,a0
     e2e:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   movea.l (a0),a6
     e30:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   jsr -228(a6)
        custom->bltafwm = 0xffff;
     e34:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.w #-1,dff044 <gcc8_c_support.c.c60c1f2b+0xdb1b95>
        custom->bltalwm = 0xffff;
     e3c:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.w #-1,dff046 <gcc8_c_support.c.c60c1f2b+0xdb1b97>
        custom->bltamod = 2;
     e44:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.w #2,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
        custom->bltbmod = 0;
     e4c:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.w #0,dff062 <gcc8_c_support.c.c60c1f2b+0xdb1bb3>
        custom->bltdmod = 0;
     e54:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.w #0,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
        custom->bltcon0 = 0xd0c; //Copy A to D
     e5c:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.w #3340,dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
        custom->bltcon1 = 0;        
     e64:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.w #0,dff042 <gcc8_c_support.c.c60c1f2b+0xdb1b93>
        custom->bltapt = (APTR) CstZBufferWork + 2;
     e6c:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.l cf7e <CstZBufferWork>,d0
     e72:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   addq.l #2,d0
     e74:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.l d0,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
          custom->bltbpt = (APTR) ((ULONG) sprite->data)+(sprite->width/8)*sprite->height*5;
     e7a:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   move.l (a3),d2
     e7c:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   movea.l 4(a3),a5
        if (zbufferset == 0) {
     e80:	|  |  |  |  |  |  |  |  |  |  |  |  |           |        |  |   tst.w 46(sp)
     e84:	|  |  |  |  |  |  |  |  |  |  |  |  |           '--------|--|-- beq.w d0e <CstDrawZBuffer+0x1ec>
          custom->bltbpt = (APTR) CstZBufferResult;
     e88:	|  |  |  |  |  |  |  |  |  |  |  |  '--------------------|--|-> move.l cf7a <CstZBufferResult>,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
        custom->bltdpt = (APTR) CstZBufferResult;
     e92:	|  |  |  |  |  |  |  |  |  |  |  |                       |  |   move.l cf7a <CstZBufferResult>,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
        custom->bltsize = (sprite->height<<6)+sprite->width/16;  
     e9c:	|  |  |  |  |  |  |  |  |  |  |  |                       |  |   move.w a5,d1
     e9e:	|  |  |  |  |  |  |  |  |  |  |  |                       |  |   lsl.w #6,d1
     ea0:	|  |  |  |  |  |  |  |  |  |  |  |                       |  |   move.l d2,d0
     ea2:	|  |  |  |  |  |  |  |  |  |  |  |                       |  '-- bpl.w d48 <CstDrawZBuffer+0x226>
     ea6:	|  |  |  |  |  |  |  |  |  |  |  |                       '----> moveq #15,d0
     ea8:	|  |  |  |  |  |  |  |  |  |  |  |                              add.l d2,d0
     eaa:	|  |  |  |  |  |  |  |  |  |  |  |                              asr.l #4,d0
     eac:	|  |  |  |  |  |  |  |  |  |  |  |                              add.w d1,d0
     eae:	|  |  |  |  |  |  |  |  |  |  |  |                              move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
        zbufferset = 1;
     eb4:	|  |  |  |  |  |  |  |  |  |  |  |                              move.w #1,46(sp)
     eba:	|  |  |  +--|--|--|--|--|--|--|--|----------------------------- bra.w d58 <CstDrawZBuffer+0x236>
          custom->bltbpt = (APTR) ((ULONG) sprite->data)+(sprite->width/8)*sprite->height*5;
     ebe:	|  |  |  |  |  |  |  |  |  '--|--|----------------------------> addq.l #7,d0
     ec0:	|  |  |  |  |  |  |  |  |     |  |                              asr.l #3,d0
     ec2:	|  |  |  |  |  |  |  |  |     |  |                              move.l a5,-(sp)
     ec4:	|  |  |  |  |  |  |  |  |     |  |                              move.l d0,-(sp)
     ec6:	|  |  |  |  |  |  |  |  |     |  |                              jsr 7b8c <__mulsi3>
     ecc:	|  |  |  |  |  |  |  |  |     |  |                              addq.l #8,sp
     ece:	|  |  |  |  |  |  |  |  |     |  |                              move.l d0,d1
     ed0:	|  |  |  |  |  |  |  |  |     |  |                              add.l d0,d1
     ed2:	|  |  |  |  |  |  |  |  |     |  |                              add.l d1,d1
     ed4:	|  |  |  |  |  |  |  |  |     |  |                              add.l d0,d1
     ed6:	|  |  |  |  |  |  |  |  |     |  |                              add.l 24(a3),d1
     eda:	|  |  |  |  |  |  |  |  |     |  |                              move.l d1,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
     ee0:	|  |  |  |  |  |  |  |  |     '--|----------------------------- bra.w d34 <CstDrawZBuffer+0x212>
    UWORD spritex2oncanvas = spritex1oncanvas+sprite->width;
     ee4:	|  |  |  |  |  |  |  '--|--------|----------------------------> move.w 48(sp),d1
     ee8:	|  |  |  |  |  |  |     |        |                              add.w d2,d1
      if(spritex1oncanvas <= zbufferx1oncanvas && spritex2oncanvas > zbufferx1oncanvas)
     eea:	|  |  |  |  |  |  |     |        |                              andi.l #65535,d1
     ef0:	|  |  |  |  |  |  |     |        |                              movea.l d1,a6
     ef2:	|  |  |  |  |  |  |     |        |                              movea.w d6,a1
     ef4:	|  |  |  |  |  |  |     |        |                              cmpa.l d1,a1
     ef6:	|  |  |  +--|--|--|-----|--------|----------------------------- bge.w d58 <CstDrawZBuffer+0x236>
        if(spritey1oncanvas <= zbuffery1oncanvas && spritey2oncanvas > zbuffery1oncanvas)
     efa:	|  |  |  |  |  |  |     |        |                              move.w 50(sp),d1
     efe:	|  |  |  |  |  |  |     |        |                              cmp.w d1,d5
     f00:	|  |  |  |  |  |  |     |        |        ,-------------------- bge.w 100c <CstDrawZBuffer+0x4ea>
      if( (zbufferfromright || zbufferfromleft) && (zbufferfrombottom || zbufferfromtop))
     f04:	|  |  |  |  |  |  |     |        |        |                     cmp.w 50(sp),d4
     f08:	|  |  |  +--|--|--|-----|--------|--------|-------------------- ble.w d58 <CstDrawZBuffer+0x236>
          xdiff = zbufferx1oncanvas - spritex1oncanvas;
     f0c:	|  |  |  |  |  |  |     |        |        |                     sub.w 48(sp),d6
          xdiffbyte = (xdiff / 16) * 2;          
     f10:	|  |  |  |  |  |  |     |        |        |                     move.w d6,d1
     f12:	|  |  |  |  |  |  |     |        |        |                     lsr.w #4,d1
     f14:	|  |  |  |  |  |  |     |        |        |                     movea.w d1,a5
          xdiffrest = (xdiff - xdiffbyte * 8);       
     f16:	|  |  |  |  |  |  |     |        |        |                     andi.w #15,d6
     f1a:	|  |  |  |  |  |  |     |        |        |                     move.w d6,44(sp)
          bytewidth = (sprite->width/16)*2 + 2;
     f1e:	|  |  |  |  |  |  |     |        |        |                     tst.l d2
     f20:	|  |  |  |  |  |  |     |        |     ,--|-------------------- blt.w faa <CstDrawZBuffer+0x488>
     f24:	|  |  |  |  |  |  |     |        |     |  |  ,----------------> asr.l #4,d2
     f26:	|  |  |  |  |  |  |     |        |     |  |  |                  addq.l #1,d2
     f28:	|  |  |  |  |  |  |     |        |     |  |  |                  add.w d2,d2
          if( zbufferx2oncanvas > spritex2oncanvas)    
     f2a:	|  |  |  |  |  |  |     |        |     |  |  |                  movea.w d0,a0
     f2c:	|  |  |  |  |  |  |     |        |     |  |  |                  cmpa.l a0,a6
     f2e:	|  |  |  |  |  |  |     |        |     |  |  |  ,-------------- bge.w fbc <CstDrawZBuffer+0x49a>
            WaitBlit();  
     f32:	|  |  |  |  |  |  |     |        |     |  |  |  |  ,----------> lea d024 <GfxBase>,a0
     f38:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            movea.l (a0),a6
     f3a:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            jsr -228(a6)
            custom->bltafwm = 0xffff;
     f3e:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            move.w #-1,dff044 <gcc8_c_support.c.c60c1f2b+0xdb1b95>
            custom->bltalwm = 0xffff;          
     f46:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            move.w #-1,dff046 <gcc8_c_support.c.c60c1f2b+0xdb1b97>
            custom->bltdpt = CstZBufferWork;        
     f4e:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            move.l cf7e <CstZBufferWork>,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
            custom->bltcon1 = 0;               
     f58:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            move.w #0,dff042 <gcc8_c_support.c.c60c1f2b+0xdb1b93>
              bltapt = (ULONG) zbuffer->bitplane - xdiffbyte;          
     f60:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            movea.l 20(a2),a0
              custom->bltamod = zbuffer->width/8 - bytewidth;
     f64:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            move.l (a2),d0
     f66:	|  |  |  |  |  |  |     |        |     |  |  |  |  |            move.l d0,d1
     f68:	|  |  |  |  |  |  |     |        |     |  |  |  |  |     ,----- bmi.s fd4 <CstDrawZBuffer+0x4b2>
     f6a:	|  |  |  |  |  |  |     |        |     |  |  |  |  |     |      asr.l #3,d1
     f6c:	|  |  |  |  |  |  |     |        |     |  |  |  |  |     |      movea.w d1,a6
     f6e:	|  |  |  |  |  |  |     |        |     |  |  |  |  |     |      suba.w d2,a6
            if (xdiffrest) {
     f70:	|  |  |  |  |  |  |     |        |     |  |  |  |  |     |      tst.w 44(sp)
     f74:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  ,--|----- beq.s fe2 <CstDrawZBuffer+0x4c0>
              custom->bltcon0 = xdiffrest * 4096 + 0x9f0;              
     f76:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  ,-> move.w 44(sp),d6
     f7a:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   moveq #12,d1
     f7c:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   lsl.w d1,d6
     f7e:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   addi.w #2544,d6
     f82:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   move.w d6,dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
              custom->bltamod = zbuffer->width/8 - bytewidth;
     f88:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   move.w a6,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
              custom->bltdmod = 0;                                                            
     f8e:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   move.w #0,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
              xdiffbyte += 2;                 
     f96:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   move.w a5,d1
     f98:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   addq.w #1,d1
     f9a:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   add.w d1,d1
              bltapt = (ULONG) zbuffer->bitplane - xdiffbyte;          
     f9c:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   andi.l #65535,d1
     fa2:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   move.l a0,d6
     fa4:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   sub.l d1,d6
     fa6:	|  |  +--|--|--|--|-----|--------|-----|--|--|--|--|--|--|--|-- bra.w c74 <CstDrawZBuffer+0x152>
          bytewidth = (sprite->width/16)*2 + 2;
     faa:	|  |  |  |  |  |  |     |        |     >--|--|--|--|--|--|--|-> moveq #15,d6
     fac:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   add.l d6,d2
     fae:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   asr.l #4,d2
     fb0:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   addq.l #1,d2
     fb2:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   add.w d2,d2
          if( zbufferx2oncanvas > spritex2oncanvas)    
     fb4:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   movea.w d0,a0
     fb6:	|  |  |  |  |  |  |     |        |     |  |  |  |  |  |  |  |   cmpa.l a0,a6
     fb8:	|  |  |  |  |  |  |     |        |     |  |  |  |  '--|--|--|-- blt.w f32 <CstDrawZBuffer+0x410>
              KPrintF("Cstdrawzbuffer: Current version only supports zbuffer size equal to screen size");
     fbc:	|  |  |  |  |  |  |     |        |     |  |  |  '-----|--|--|-> pea 7de4 <PutChar+0x170>
     fc2:	|  |  |  |  |  |  |     |        |     |  |  |        |  |  |   jsr 725e <KPrintF>
              return FALSE;
     fc8:	|  |  |  |  |  |  |     |        |     |  |  |        |  |  |   addq.l #4,sp
     fca:	|  |  |  |  |  |  |     |        |     |  |  |        |  |  |   moveq #0,d0
}
     fcc:	|  |  |  |  |  |  |     |        |     |  |  |        |  |  |   movem.l (sp)+,d2-d7/a2-a6
     fd0:	|  |  |  |  |  |  |     |        |     |  |  |        |  |  |   addq.l #8,sp
     fd2:	|  |  |  |  |  |  |     |        |     |  |  |        |  |  |   rts
              custom->bltamod = zbuffer->width/8 - bytewidth;
     fd4:	|  |  |  |  |  |  |     |        |     |  |  |        |  '--|-> addq.l #7,d1
     fd6:	|  |  |  |  |  |  |     |        |     |  |  |        |     |   asr.l #3,d1
     fd8:	|  |  |  |  |  |  |     |        |     |  |  |        |     |   movea.w d1,a6
     fda:	|  |  |  |  |  |  |     |        |     |  |  |        |     |   suba.w d2,a6
            if (xdiffrest) {
     fdc:	|  |  |  |  |  |  |     |        |     |  |  |        |     |   tst.w 44(sp)
     fe0:	|  |  |  |  |  |  |     |        |     |  |  |        |     '-- bne.s f76 <CstDrawZBuffer+0x454>
              custom->bltcon0 = 0x9f0;              
     fe2:	|  |  |  |  |  |  |     |        |     |  |  |        '-------> move.w #2544,dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
              custom->bltamod = zbuffer->width/8 - bytewidth;
     fea:	|  |  |  |  |  |  |     |        |     |  |  |                  move.w a6,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
              custom->bltdmod = 0;                                                            
     ff0:	|  |  |  |  |  |  |     |        |     |  |  |                  move.w #0,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
              xdiffbyte += 2;                 
     ff8:	|  |  |  |  |  |  |     |        |     |  |  |                  move.w a5,d1
     ffa:	|  |  |  |  |  |  |     |        |     |  |  |                  addq.w #1,d1
     ffc:	|  |  |  |  |  |  |     |        |     |  |  |                  add.w d1,d1
              bltapt = (ULONG) zbuffer->bitplane - xdiffbyte;          
     ffe:	|  |  |  |  |  |  |     |        |     |  |  |                  andi.l #65535,d1
    1004:	|  |  |  |  |  |  |     |        |     |  |  |                  move.l a0,d6
    1006:	|  |  |  |  |  |  |     |        |     |  |  |                  sub.l d1,d6
    1008:	|  |  +--|--|--|--|-----|--------|-----|--|--|----------------- bra.w c74 <CstDrawZBuffer+0x152>
        if(spritey1oncanvas <= zbuffery1oncanvas && spritey2oncanvas > zbuffery1oncanvas)
    100c:	|  |  |  |  |  |  |     |        |     |  '--|----------------> movea.w d5,a0
      if( (zbufferfromright || zbufferfromleft) && (zbufferfrombottom || zbufferfromtop))
    100e:	|  |  |  |  |  |  |     |        |     |     |                  cmpa.l d3,a0
    1010:	|  |  |  +--|--|--|-----|--------|-----|-----|----------------- bge.w d58 <CstDrawZBuffer+0x236>
          xdiff = zbufferx1oncanvas - spritex1oncanvas;
    1014:	|  |  |  |  |  |  |     |        |     |     |                  sub.w 48(sp),d6
          xdiffbyte = (xdiff / 16) * 2;          
    1018:	|  |  |  |  |  |  |     |        |     |     |                  move.w d6,d1
    101a:	|  |  |  |  |  |  |     |        |     |     |                  lsr.w #4,d1
    101c:	|  |  |  |  |  |  |     |        |     |     |                  movea.w d1,a5
          xdiffrest = (xdiff - xdiffbyte * 8);       
    101e:	|  |  |  |  |  |  |     |        |     |     |                  andi.w #15,d6
    1022:	|  |  |  |  |  |  |     |        |     |     |                  move.w d6,44(sp)
          bytewidth = (sprite->width/16)*2 + 2;
    1026:	|  |  |  |  |  |  |     |        |     |     |                  tst.l d2
    1028:	|  |  |  |  |  |  |     |        |     |     '----------------- bge.w f24 <CstDrawZBuffer+0x402>
    102c:	|  |  |  |  |  |  |     |        |     '----------------------- bra.w faa <CstDrawZBuffer+0x488>
      if( (zbufferfromright || zbufferfromleft) && (zbufferfrombottom || zbufferfromtop))
    1030:	|  |  |  |  |  '--|-----|--------|----------------------------> cmp.w 50(sp),d4
    1034:	|  |  |  '--|-----|-----|--------|----------------------------- ble.w d58 <CstDrawZBuffer+0x236>
          xdiff = spritex1oncanvas - zbufferx1oncanvas;
    1038:	|  |  |     |     |     |        |                              move.w 48(sp),d0
    103c:	|  |  |     |     |     |        |                              sub.w d6,d0
          xdiffrest = (xdiff - xdiffbyte * 8);    
    103e:	|  |  |     |     |     |        |                              move.w d0,d6
    1040:	|  |  |     |     |     |        |                              andi.w #15,d6
    1044:	|  |  |     |     |     |        |                              movea.w d6,a5
          bytewidth = (sprite->width/16)*2;
    1046:	|  |  |     |     |     |        |                              tst.l d2
    1048:	|  |  |     |     '-----|--------|----------------------------- bge.w bfc <CstDrawZBuffer+0xda>
    104c:	|  |  |     '-----------|--------|----------------------------- bra.w d7a <CstDrawZBuffer+0x258>
    WaitBlit();
    1050:	'--|--|-----------------|--------|----------------------------> movea.l d024 <GfxBase>,a6
    1056:	   |  |                 |        |                              jsr -228(a6)
    custom->bltafwm = 0xffff;
    105a:	   |  |                 |        |                              move.w #-1,dff044 <gcc8_c_support.c.c60c1f2b+0xdb1b95>
    custom->bltalwm = 0xffff;
    1062:	   |  |                 |        |                              move.w #-1,dff046 <gcc8_c_support.c.c60c1f2b+0xdb1b97>
    custom->bltamod = 0;
    106a:	   |  |                 |        |                              move.w #0,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
    custom->bltbmod = 0;
    1072:	   |  |                 |        |                              move.w #0,dff062 <gcc8_c_support.c.c60c1f2b+0xdb1bb3>
    custom->bltcmod = 0;
    107a:	   |  |                 |        |                              move.w #0,dff060 <gcc8_c_support.c.c60c1f2b+0xdb1bb1>
    custom->bltdmod = 0;
    1082:	   |  |                 |        |                              move.w #0,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
    custom->bltcon0 = 0x9f0; //Copy A to D
    108a:	   |  |                 |        |                              move.w #2544,dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
    custom->bltcon1 = 0;        
    1092:	   |  |                 |        |                              move.w #0,dff042 <gcc8_c_support.c.c60c1f2b+0xdb1b93>
    custom->bltapt = (APTR) ((ULONG) sprite->data)+(sprite->width/8)*sprite->height*5;
    109a:	   |  |                 |        |                              move.l (a3),d2
    109c:	   |  |                 |        |                              move.l 4(a3),d3
    10a0:	   |  |                 |        |                              move.l d2,d0
    10a2:	   |  |                 |        |                    ,-------- bmi.w 112a <CstDrawZBuffer+0x608>
    10a6:	   |  |                 |        |                    |         asr.l #3,d0
    10a8:	   |  |                 |        |                    |         move.l d3,-(sp)
    10aa:	   |  |                 |        |                    |         move.l d0,-(sp)
    10ac:	   |  |                 |        |                    |         jsr 7b8c <__mulsi3>
    10b2:	   |  |                 |        |                    |         addq.l #8,sp
    10b4:	   |  |                 |        |                    |         move.l d0,d1
    10b6:	   |  |                 |        |                    |         add.l d0,d1
    10b8:	   |  |                 |        |                    |         add.l d1,d1
    10ba:	   |  |                 |        |                    |         add.l d1,d0
    10bc:	   |  |                 |        |                    |         add.l 24(a3),d0
    10c0:	   |  |                 |        |                    |         move.l d0,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltdpt = (APTR) CstZBufferResult;
    10c6:	   |  |                 |        |                    |         move.l cf7a <CstZBufferResult>,d0
    10cc:	   |  |                 |        |                    |         move.l d0,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (sprite->height<<6)+sprite->width/16;      
    10d2:	   |  |                 |        |                    |         lsl.w #6,d3
    10d4:	   |  |                 |        |                    |         tst.l d2
    10d6:	   |  |                 |        |                 ,--|-------- blt.s 111a <CstDrawZBuffer+0x5f8>
    10d8:	   |  |                 |        |                 |  |  ,----> asr.l #4,d2
    10da:	   |  |                 |        |                 |  |  |      add.w d2,d3
    10dc:	   |  |                 |        |                 |  |  |      move.w d3,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
}
    10e2:	   |  |                 |        |                 |  |  |  ,-> movem.l (sp)+,d2-d7/a2-a6
    10e6:	   |  |                 |        |                 |  |  |  |   addq.l #8,sp
    10e8:	   |  |                 |        |                 |  |  |  |   rts
            custom->bltamod = zbuffer->width/8 - bytewidth;
    10ea:	   |  |                 '--------|-----------------|--|--|--|-> addq.l #7,d1
    10ec:	   |  |                          |                 |  |  |  |   asr.l #3,d1
    10ee:	   |  |                          |                 |  |  |  |   sub.w d2,d1
    10f0:	   |  |                          |                 |  |  |  |   move.w d1,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
            custom->bltdmod = 2;                                                            
    10f6:	   |  |                          |                 |  |  |  |   move.w #2,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
    10fe:	   |  |                          '-----------------|--|--|--|-- bra.w dee <CstDrawZBuffer+0x2cc>
            custom->bltamod = zbuffer->width/8 - bytewidth;
    1102:	   '--|--------------------------------------------|--|--|--|-> addq.l #7,d1
    1104:	      |                                            |  |  |  |   asr.l #3,d1
    1106:	      |                                            |  |  |  |   sub.w d2,d1
    1108:	      |                                            |  |  |  |   move.w d1,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
            custom->bltdmod = 0;                                                            
    110e:	      |                                            |  |  |  |   move.w #0,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
    1116:	      '--------------------------------------------|--|--|--|-- bra.w c74 <CstDrawZBuffer+0x152>
    custom->bltsize = (sprite->height<<6)+sprite->width/16;      
    111a:	                                                   >--|--|--|-> moveq #15,d1
    111c:	                                                   |  |  |  |   add.l d1,d2
    111e:	                                                   |  |  |  |   asr.l #4,d2
    1120:	                                                   |  |  |  |   add.w d2,d3
    1122:	                                                   |  |  |  |   move.w d3,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
  return CstZBufferResult;
    1128:	                                                   |  |  |  '-- bra.s 10e2 <CstDrawZBuffer+0x5c0>
    custom->bltapt = (APTR) ((ULONG) sprite->data)+(sprite->width/8)*sprite->height*5;
    112a:	                                                   |  '--|----> addq.l #7,d0
    112c:	                                                   |     |      asr.l #3,d0
    112e:	                                                   |     |      move.l d3,-(sp)
    1130:	                                                   |     |      move.l d0,-(sp)
    1132:	                                                   |     |      jsr 7b8c <__mulsi3>
    1138:	                                                   |     |      addq.l #8,sp
    113a:	                                                   |     |      move.l d0,d1
    113c:	                                                   |     |      add.l d0,d1
    113e:	                                                   |     |      add.l d1,d1
    1140:	                                                   |     |      add.l d1,d0
    1142:	                                                   |     |      add.l 24(a3),d0
    1146:	                                                   |     |      move.l d0,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltdpt = (APTR) CstZBufferResult;
    114c:	                                                   |     |      move.l cf7a <CstZBufferResult>,d0
    1152:	                                                   |     |      move.l d0,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (sprite->height<<6)+sprite->width/16;      
    1158:	                                                   |     |      lsl.w #6,d3
    115a:	                                                   |     |      tst.l d2
    115c:	                                                   |     '----- bge.w 10d8 <CstDrawZBuffer+0x5b6>
    1160:	                                                   '----------- bra.s 111a <CstDrawZBuffer+0x5f8>

00001162 <CstFreeBuffer>:

void CstFreeBuffer( ) {
    1162:	    lea -20(sp),sp
    1166:	    move.l a6,-(sp)
  if( CstDrawBuffer) FreeVec(CstDrawBuffer);
    1168:	    move.l cf60 <CstDrawBuffer>,d0
    116e:	,-- beq.s 1188 <CstFreeBuffer+0x26>
    1170:	|   move.l cf60 <CstDrawBuffer>,20(sp)
    1178:	|   move.l d018 <SysBase>,d0
    117e:	|   movea.l d0,a6
    1180:	|   movea.l 20(sp),a1
    1184:	|   jsr -690(a6)
  if( CstViewBuffer) FreeVec(CstViewBuffer);
    1188:	'-> move.l cf5c <CstViewBuffer>,d0
    118e:	,-- beq.s 11a8 <CstFreeBuffer+0x46>
    1190:	|   move.l cf5c <CstViewBuffer>,16(sp)
    1198:	|   move.l d018 <SysBase>,d0
    119e:	|   movea.l d0,a6
    11a0:	|   movea.l 16(sp),a1
    11a4:	|   jsr -690(a6)
  if( CstCopperList) FreeVec(CstCopperList);  
    11a8:	'-> move.l cf58 <CstCopperList>,d0
    11ae:	,-- beq.s 11c8 <CstFreeBuffer+0x66>
    11b0:	|   move.l cf58 <CstCopperList>,12(sp)
    11b8:	|   move.l d018 <SysBase>,d0
    11be:	|   movea.l d0,a6
    11c0:	|   movea.l 12(sp),a1
    11c4:	|   jsr -690(a6)
  if( CstBackDrop) FreeVec(CstBackDrop);  
    11c8:	'-> move.l cf50 <CstBackDrop>,d0
    11ce:	,-- beq.s 11e8 <CstFreeBuffer+0x86>
    11d0:	|   move.l cf50 <CstBackDrop>,8(sp)
    11d8:	|   move.l d018 <SysBase>,d0
    11de:	|   movea.l d0,a6
    11e0:	|   movea.l 8(sp),a1
    11e4:	|   jsr -690(a6)
  if( CstBackDropBackup) FreeVec(CstBackDropBackup);
    11e8:	'-> move.l cf54 <CstBackDropBackup>,d0
    11ee:	,-- beq.s 1208 <CstFreeBuffer+0xa6>
    11f0:	|   move.l cf54 <CstBackDropBackup>,4(sp)
    11f8:	|   move.l d018 <SysBase>,d0
    11fe:	|   movea.l d0,a6
    1200:	|   movea.l 4(sp),a1
    1204:	|   jsr -690(a6)
  CstDrawBuffer = NULL;
    1208:	'-> clr.l cf60 <CstDrawBuffer>
  CstViewBuffer = NULL;
    120e:	    clr.l cf5c <CstViewBuffer>
  CstCopperList = NULL;
    1214:	    clr.l cf58 <CstCopperList>
  CstBackDrop = NULL;
    121a:	    clr.l cf50 <CstBackDrop>

}
    1220:	    nop
    1222:	    movea.l (sp)+,a6
    1224:	    lea 20(sp),sp
    1228:	    rts

0000122a <CstInitVBlankHandler>:

  KPrintF("CstFreeze: Finished");

}  

void CstInitVBlankHandler( ) {
    122a:	    lea -20(sp),sp
    122e:	    move.l a6,-(sp)
  if ((CstVbint = AllocMem(sizeof(struct Interrupt),    
    1230:	    moveq #22,d0
    1232:	    move.l d0,20(sp)
    1236:	    move.l #65537,16(sp)
    123e:	    move.l d018 <SysBase>,d0
    1244:	    movea.l d0,a6
    1246:	    move.l 20(sp),d0
    124a:	    move.l 16(sp),d1
    124e:	    jsr -198(a6)
    1252:	    move.l d0,12(sp)
    1256:	    move.l 12(sp),d0
    125a:	    move.l d0,cf48 <CstVbint>
    1260:	    move.l cf48 <CstVbint>,d0
    1266:	,-- beq.s 12a6 <CstInitVBlankHandler+0x7c>
                         MEMF_PUBLIC|MEMF_CLEAR))) {
    CstVbint->is_Node.ln_Type = NT_INTERRUPT;       
    1268:	|   movea.l cf48 <CstVbint>,a0
    126e:	|   move.b #2,8(a0)
    CstVbint->is_Node.ln_Pri = -60;
    1274:	|   movea.l cf48 <CstVbint>,a0
    127a:	|   move.b #-60,9(a0)
    CstVbint->is_Node.ln_Name = "VertB-Example";
    1280:	|   movea.l cf48 <CstVbint>,a0
    1286:	|   move.l #32438,10(a0)
    CstVbint->is_Data = NULL;
    128e:	|   movea.l cf48 <CstVbint>,a0
    1294:	|   clr.l 14(a0)
    CstVbint->is_Code = CstVBlankHandler;
    1298:	|   movea.l cf48 <CstVbint>,a0
    129e:	|   move.l #9264,18(a0)
  }

  AddIntServer( INTB_COPER, CstVbint); 
    12a6:	'-> moveq #4,d0
    12a8:	    move.l d0,8(sp)
    12ac:	    move.l cf48 <CstVbint>,4(sp)
    12b4:	    move.l d018 <SysBase>,d0
    12ba:	    movea.l d0,a6
    12bc:	    move.l 8(sp),d0
    12c0:	    movea.l 4(sp),a1
    12c4:	    jsr -168(a6)

}
    12c8:	    nop
    12ca:	    movea.l (sp)+,a6
    12cc:	    lea 20(sp),sp
    12d0:	    rts

000012d2 <CstRestoreScreen>:
  //custom->color[0] = 0x000;
}


void CstRestoreScreen()
{
    12d2:	                   lea -36(sp),sp
    12d6:	                   move.l a6,-(sp)
    12d8:	                   move.l d2,-(sp)
  volatile struct Custom *custom = (struct Custom*)0xdff000;  
    12da:	                   move.l #14675968,16(sp)
  //custom->color[0] = 0xf00;
  //struct CleanupQueue *cursor  = CstCleanupQueueDrawBuffer;
  if(!CstCleanupQueueDrawBuffer || !CstDrawBuffer) {
    12e2:	                   move.l cf68 <CstCleanupQueueDrawBuffer>,d0
    12e8:	,----------------- beq.w 1548 <CstRestoreScreen+0x276>
    12ec:	|                  move.l cf60 <CstDrawBuffer>,d0
    12f2:	+----------------- beq.w 1548 <CstRestoreScreen+0x276>
    return;
  } 

  UWORD *colorpos = CstPalette;
    12f6:	|                  move.l cf72 <CstPalette>,40(sp)
  UWORD *tmp = CstClColor;
    12fe:	|                  move.l cf6c <CstClColor>,36(sp)
  for(int i=0;i<32;i++) { //ToDo Support other number of bitplanes
    1306:	|                  clr.l 32(sp)
    130a:	|              ,-- bra.s 133c <CstRestoreScreen+0x6a>
    *tmp++;
    130c:	|           ,--|-> move.l 36(sp),d0
    1310:	|           |  |   move.l d0,d1
    1312:	|           |  |   addq.l #2,d1
    1314:	|           |  |   move.l d1,36(sp)
    *tmp++ = *colorpos++;
    1318:	|           |  |   move.l 40(sp),d1
    131c:	|           |  |   move.l d1,d2
    131e:	|           |  |   addq.l #2,d2
    1320:	|           |  |   move.l d2,40(sp)
    1324:	|           |  |   move.l 36(sp),d0
    1328:	|           |  |   move.l d0,d2
    132a:	|           |  |   addq.l #2,d2
    132c:	|           |  |   move.l d2,36(sp)
    1330:	|           |  |   movea.l d1,a0
    1332:	|           |  |   move.w (a0),d1
    1334:	|           |  |   movea.l d0,a0
    1336:	|           |  |   move.w d1,(a0)
  for(int i=0;i<32;i++) { //ToDo Support other number of bitplanes
    1338:	|           |  |   addq.l #1,32(sp)
    133c:	|           |  '-> moveq #31,d0
    133e:	|           |      cmp.l 32(sp),d0
    1342:	|           '----- bge.s 130c <CstRestoreScreen+0x3a>
  }

  WaitBlit();
    1344:	|                  move.l d024 <GfxBase>,d0
    134a:	|                  movea.l d0,a6
    134c:	|                  jsr -228(a6)
  
  custom->bltafwm = 0xffff;
    1350:	|                  movea.l 16(sp),a0
    1354:	|                  move.w #-1,68(a0)
  custom->bltalwm = 0xffff;  
    135a:	|                  movea.l 16(sp),a0
    135e:	|                  move.w #-1,70(a0)
  custom->bltcon0 = 0x9f0;
    1364:	|                  movea.l 16(sp),a0
    1368:	|                  move.w #2544,64(a0)
  
  while(CstCleanupQueueDrawBuffer)
    136e:	|     ,----------- bra.w 153c <CstRestoreScreen+0x26a>
  {    

    if( CstCleanupQueueDrawBuffer->person && CstCleanupQueueDrawBuffer->person->samePosCount < 3
    1372:	|  ,--|----------> movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    1378:	|  |  |            move.l 4(a0),d0
    137c:	|  |  |     ,----- beq.s 1392 <CstRestoreScreen+0xc0>
    137e:	|  |  |     |      movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    1384:	|  |  |     |      movea.l 4(a0),a0
    1388:	|  |  |     |      move.l 16(a0),d0
    138c:	|  |  |     |      moveq #2,d1
    138e:	|  |  |     |      cmp.l d0,d1
    1390:	|  |  |     |  ,-- bge.s 13a0 <CstRestoreScreen+0xce>
      || CstCleanupQueueDrawBuffer->person == NULL)
    1392:	|  |  |     '--|-> movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    1398:	|  |  |        |   move.l 4(a0),d0
    139c:	|  |  |  ,-----|-- bne.w 150a <CstRestoreScreen+0x238>
    {
      custom->bltamod = winWidth/8-CstCleanupQueueDrawBuffer->widthinwords*2;
    13a0:	|  |  |  |     '-> move.l cf86 <winWidth>,d0
    13a6:	|  |  |  |         lsr.l #3,d0
    13a8:	|  |  |  |         move.l d0,d1
    13aa:	|  |  |  |         movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    13b0:	|  |  |  |         move.w 8(a0),d0
    13b4:	|  |  |  |         add.w d0,d0
    13b6:	|  |  |  |         sub.w d0,d1
    13b8:	|  |  |  |         movea.l 16(sp),a0
    13bc:	|  |  |  |         move.w d1,100(a0)
      custom->bltdmod = winWidth/8-CstCleanupQueueDrawBuffer->widthinwords*2;
    13c0:	|  |  |  |         move.l cf86 <winWidth>,d0
    13c6:	|  |  |  |         lsr.l #3,d0
    13c8:	|  |  |  |         move.l d0,d1
    13ca:	|  |  |  |         movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    13d0:	|  |  |  |         move.w 8(a0),d0
    13d4:	|  |  |  |         add.w d0,d0
    13d6:	|  |  |  |         sub.w d0,d1
    13d8:	|  |  |  |         movea.l 16(sp),a0
    13dc:	|  |  |  |         move.w d1,102(a0)
      ULONG bltapt = ((ULONG) CstBackDrop) + CstCleanupQueueDrawBuffer->starty*winWidth/8 + CstCleanupQueueDrawBuffer->startxinbytes;
    13e0:	|  |  |  |         movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    13e6:	|  |  |  |         move.w 14(a0),d0
    13ea:	|  |  |  |         move.w d0,d0
    13ec:	|  |  |  |         andi.l #65535,d0
    13f2:	|  |  |  |         move.l cf86 <winWidth>,d1
    13f8:	|  |  |  |         move.l d1,-(sp)
    13fa:	|  |  |  |         move.l d0,-(sp)
    13fc:	|  |  |  |         jsr 7b8c <__mulsi3>
    1402:	|  |  |  |         addq.l #8,sp
    1404:	|  |  |  |         move.l d0,d1
    1406:	|  |  |  |         lsr.l #3,d1
    1408:	|  |  |  |         move.l cf50 <CstBackDrop>,d0
    140e:	|  |  |  |         add.l d0,d1
    1410:	|  |  |  |         movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    1416:	|  |  |  |         move.w 12(a0),d0
    141a:	|  |  |  |         move.w d0,d0
    141c:	|  |  |  |         andi.l #65535,d0
    1422:	|  |  |  |         move.l d1,d2
    1424:	|  |  |  |         add.l d0,d2
    1426:	|  |  |  |         move.l d2,28(sp)
      ULONG bltdpt = ((ULONG) CstDrawBuffer) + CstCleanupQueueDrawBuffer->starty*winWidth/8 + CstCleanupQueueDrawBuffer->startxinbytes;
    142a:	|  |  |  |         movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    1430:	|  |  |  |         move.w 14(a0),d0
    1434:	|  |  |  |         move.w d0,d0
    1436:	|  |  |  |         andi.l #65535,d0
    143c:	|  |  |  |         move.l cf86 <winWidth>,d1
    1442:	|  |  |  |         move.l d1,-(sp)
    1444:	|  |  |  |         move.l d0,-(sp)
    1446:	|  |  |  |         jsr 7b8c <__mulsi3>
    144c:	|  |  |  |         addq.l #8,sp
    144e:	|  |  |  |         move.l d0,d1
    1450:	|  |  |  |         lsr.l #3,d1
    1452:	|  |  |  |         move.l cf60 <CstDrawBuffer>,d0
    1458:	|  |  |  |         add.l d0,d1
    145a:	|  |  |  |         movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    1460:	|  |  |  |         move.w 12(a0),d0
    1464:	|  |  |  |         move.w d0,d0
    1466:	|  |  |  |         andi.l #65535,d0
    146c:	|  |  |  |         move.l d1,d2
    146e:	|  |  |  |         add.l d0,d2
    1470:	|  |  |  |         move.l d2,24(sp)
      for(int i=0;i<5;i++) //ToDo other numbers of Bitplanes
    1474:	|  |  |  |         clr.l 20(sp)
    1478:	|  |  |  |     ,-- bra.w 1500 <CstRestoreScreen+0x22e>
      {
        custom->bltapt = (APTR) bltapt;
    147c:	|  |  |  |  ,--|-> move.l 28(sp),d0
    1480:	|  |  |  |  |  |   movea.l 16(sp),a0
    1484:	|  |  |  |  |  |   move.l d0,80(a0)
        custom->bltdpt = (APTR) bltdpt;
    1488:	|  |  |  |  |  |   move.l 24(sp),d0
    148c:	|  |  |  |  |  |   movea.l 16(sp),a0
    1490:	|  |  |  |  |  |   move.l d0,84(a0)
        custom->bltsize = (CstCleanupQueueDrawBuffer->height << 6) + CstCleanupQueueDrawBuffer->widthinwords;
    1494:	|  |  |  |  |  |   movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    149a:	|  |  |  |  |  |   move.w 10(a0),d0
    149e:	|  |  |  |  |  |   lsl.w #6,d0
    14a0:	|  |  |  |  |  |   movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    14a6:	|  |  |  |  |  |   move.w 8(a0),d1
    14aa:	|  |  |  |  |  |   add.w d1,d0
    14ac:	|  |  |  |  |  |   movea.l 16(sp),a0
    14b0:	|  |  |  |  |  |   move.w d0,88(a0)
        bltapt += winWidth/8*winHeight;
    14b4:	|  |  |  |  |  |   move.l cf86 <winWidth>,d0
    14ba:	|  |  |  |  |  |   lsr.l #3,d0
    14bc:	|  |  |  |  |  |   move.l cf8a <winHeight>,d1
    14c2:	|  |  |  |  |  |   move.l d1,-(sp)
    14c4:	|  |  |  |  |  |   move.l d0,-(sp)
    14c6:	|  |  |  |  |  |   jsr 7b8c <__mulsi3>
    14cc:	|  |  |  |  |  |   addq.l #8,sp
    14ce:	|  |  |  |  |  |   add.l d0,28(sp)
        bltdpt += winWidth/8*winHeight;
    14d2:	|  |  |  |  |  |   move.l cf86 <winWidth>,d0
    14d8:	|  |  |  |  |  |   lsr.l #3,d0
    14da:	|  |  |  |  |  |   move.l cf8a <winHeight>,d1
    14e0:	|  |  |  |  |  |   move.l d1,-(sp)
    14e2:	|  |  |  |  |  |   move.l d0,-(sp)
    14e4:	|  |  |  |  |  |   jsr 7b8c <__mulsi3>
    14ea:	|  |  |  |  |  |   addq.l #8,sp
    14ec:	|  |  |  |  |  |   add.l d0,24(sp)
        WaitBlit();
    14f0:	|  |  |  |  |  |   move.l d024 <GfxBase>,d0
    14f6:	|  |  |  |  |  |   movea.l d0,a6
    14f8:	|  |  |  |  |  |   jsr -228(a6)
      for(int i=0;i<5;i++) //ToDo other numbers of Bitplanes
    14fc:	|  |  |  |  |  |   addq.l #1,20(sp)
    1500:	|  |  |  |  |  '-> moveq #4,d0
    1502:	|  |  |  |  |      cmp.l 20(sp),d0
    1506:	|  |  |  |  '----- bge.w 147c <CstRestoreScreen+0x1aa>
      }
    }
    struct CleanupQueue *todelete = CstCleanupQueueDrawBuffer;
    150a:	|  |  |  '-------> move.l cf68 <CstCleanupQueueDrawBuffer>,12(sp)
    CstCleanupQueueDrawBuffer = CstCleanupQueueDrawBuffer->next;  
    1512:	|  |  |            movea.l cf68 <CstCleanupQueueDrawBuffer>,a0
    1518:	|  |  |            move.l 16(a0),d0
    151c:	|  |  |            move.l d0,cf68 <CstCleanupQueueDrawBuffer>
    FreeVec(todelete);    
    1522:	|  |  |            move.l 12(sp),8(sp)
    1528:	|  |  |            move.l d018 <SysBase>,d0
    152e:	|  |  |            movea.l d0,a6
    1530:	|  |  |            movea.l 8(sp),a1
    1534:	|  |  |            jsr -690(a6)
    todelete = NULL;
    1538:	|  |  |            clr.l 12(sp)
  while(CstCleanupQueueDrawBuffer)
    153c:	|  |  '----------> move.l cf68 <CstCleanupQueueDrawBuffer>,d0
    1542:	|  '-------------- bne.w 1372 <CstRestoreScreen+0xa0>
    1546:	|              ,-- bra.s 154a <CstRestoreScreen+0x278>
    return;
    1548:	'--------------|-> nop
  }
  //custom->color[0] = 0x000;
}
    154a:	               '-> move.l (sp)+,d2
    154c:	                   movea.l (sp)+,a6
    154e:	                   lea 36(sp),sp
    1552:	                   rts

00001554 <CstScaleSprite>:

__attribute__((optimize("Ofast"))) 
void CstScaleSprite( struct sprite *single, struct onScreenPerson *person, WORD x, WORD y, UWORD destinationtype)
{  
    1554:	                                                                                           lea -32(sp),sp
    1558:	                                                                                           movem.l d2-d7/a2-a6,-(sp)
    155c:	                                                                                           movea.l 80(sp),a2
    1560:	                                                                                           move.l 84(sp),64(sp)
    1566:	                                                                                           move.l 88(sp),d3
    156a:	                                                                                           move.l 92(sp),48(sp)
    1570:	                                                                                           move.w d3,d7
    1572:	                                                                                           move.w 50(sp),d2
    1576:	                                                                                           move.w 98(sp),d5
  if( single->width == 320)
  {
    single->width = 320;
  }

  UBYTE *mask = CstDrawZBuffer( single, zBuffer, x, y);
    157a:	                                                                                           movea.w d2,a3
    157c:	                                                                                           movea.w d3,a6
    157e:	                                                                                           move.l a3,-(sp)
    1580:	                                                                                           move.l a6,-(sp)
    1582:	                                                                                           move.l d074 <zBuffer>,-(sp)
    1588:	                                                                                           move.l a2,-(sp)
    158a:	                                                                                           jsr b22 <CstDrawZBuffer>
    1590:	                                                                                           move.l d0,d4

  UWORD *destination = 0;
  switch(destinationtype)
    1592:	                                                                                           lea 16(sp),sp
    1596:	                                                                                           cmpi.w #1,d5
    159a:	                                                            ,----------------------------- beq.w 1a6a <CstScaleSprite+0x516>
    159e:	                                                            |                              cmpi.w #2,d5
    15a2:	                                                            |                 ,----------- beq.w 18d0 <CstScaleSprite+0x37c>
    15a6:	                                                            |                 |            suba.l a4,a4
  ULONG ystartdst;
  ULONG ystartsrc; 
  ULONG blitheight;

  if( y < 0) {
    if(y + single->height < 0) {
    15a8:	                                                            |  ,--------------|----------> move.l 4(a2),d1
    15ac:	                                                            |  |              |            move.l a3,d0
    15ae:	                                                            |  |              |            add.l d1,d0
  if( y < 0) {
    15b0:	                                                            |  |              |            tst.w d2
    15b2:	                                                            |  |           ,--|----------- blt.w 18e4 <CstScaleSprite+0x390>
      return;
    }
    ystartdst = 0;
    ystartsrc = y*-1;
    blitheight = single->height+y;
  } else if(y+single->height > (int) winHeight) {
    15b6:	                                                            |  |           |  |  ,-------> movea.l cf8a <winHeight>,a0
    15bc:	                                                            |  |           |  |  |         cmp.l a0,d0
    15be:	                                                            |  |  ,--------|--|--|-------- ble.w 1a74 <CstScaleSprite+0x520>
    if(y  > (int) winHeight) {
    15c2:	                                                            |  |  |        |  |  |         cmpa.l a3,a0
    15c4:	                     ,--------------------------------------|--|--|--------|--|--|-------- blt.w 1ba2 <CstScaleSprite+0x64e>
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;
    }
    ystartdst = y;
    15c8:	                     |                                      |  |  |        |  |  |         move.l a3,d6
    ystartsrc = 0;
    blitheight = winHeight-y;
    15ca:	                     |                                      |  |  |        |  |  |         suba.l a3,a0
    15cc:	                     |                                      |  |  |        |  |  |         move.l a0,54(sp)
    ystartsrc = 0;
    15d0:	                     |                                      |  |  |        |  |  |         moveq #0,d2


  if( x < 0) 
  { //Leftmost part outside screen

    if(x + single->width < 0) {
    15d2:	                     |                                      |  |  |  ,-----|--|--|-------> move.l (a2),d1
    15d4:	                     |                                      |  |  |  |     |  |  |         move.l a6,d0
    15d6:	                     |                                      |  |  |  |     |  |  |         add.l d1,d0
  if( x < 0) 
    15d8:	                     |                                      |  |  |  |     |  |  |         tst.w d7
    15da:	                     |                                      |  |  |  |     |  |  |  ,----- blt.w 1900 <CstScaleSprite+0x3ac>
      CstCleanupQueueViewBuffer->height = blitheight; 
      CstCleanupQueueViewBuffer->startxinbytes = 0; 
      CstCleanupQueueViewBuffer->starty = ystartdst;  
    }           
  } 
  else if(x + single->width > (int) winWidth) 
    15de:	                     |                                      |  |  |  |     |  |  |  |  ,-> movea.l cf86 <winWidth>,a5
    15e4:	                     |                                      |  |  |  |     |  |  |  |  |   cmp.l a5,d0
    15e6:	                     |                                      |  |  |  |  ,--|--|--|--|--|-- ble.w 1a80 <CstScaleSprite+0x52c>
  { //Rightmost part outside screen   

    if(x - single->width > (int) winWidth)
    15ea:	                     |                                      |  |  |  |  |  |  |  |  |  |   suba.l d1,a6
    15ec:	                     |                                      |  |  |  |  |  |  |  |  |  |   cmpa.l a5,a6
    15ee:	                     +--------------------------------------|--|--|--|--|--|--|--|--|--|-- bgt.w 1ba2 <CstScaleSprite+0x64e>
    {    
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;
    }
    extrawords = 0; //Shifted out part of source outside screen. No need to blit this
    cutwordssource = (x+single->width - winWidth)/16;
    15f2:	                     |                                      |  |  |  |  |  |  |  |  |  |   sub.l a5,d0
    15f4:	                     |                                      |  |  |  |  |  |  |  |  |  |   lsr.l #4,d0
    15f6:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d0,68(sp)
    15fa:	                     |                                      |  |  |  |  |  |  |  |  |  |   movea.w d0,a3
    cutmaskpixel = 0;    
    bltapt = ((ULONG) mask)+ystartsrc*single->width/8;
    15fc:	                     |                                      |  |  |  |  |  |  |  |  |  |   lea 7b8c <__mulsi3>,a6
    1602:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d2,-(sp)
    1604:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d1,-(sp)
    1606:	                     |                                      |  |  |  |  |  |  |  |  |  |   jsr (a6)
    1608:	                     |                                      |  |  |  |  |  |  |  |  |  |   addq.l #8,sp
    160a:	                     |                                      |  |  |  |  |  |  |  |  |  |   lsr.l #3,d0
    160c:	                     |                                      |  |  |  |  |  |  |  |  |  |   add.l d0,d4
    bltbpt = (ULONG) single->data+ystartsrc*single->width/8;
    160e:	                     |                                      |  |  |  |  |  |  |  |  |  |   add.l 24(a2),d0
    1612:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d0,60(sp)
    bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    1616:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.w d3,d7
    1618:	                     |                                      |  |  |  |  |  |  |  |  |  |   asr.w #4,d7
    161a:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d6,-(sp)
    161c:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l a5,-(sp)
    161e:	                     |                                      |  |  |  |  |  |  |  |  |  |   jsr (a6)
    1620:	                     |                                      |  |  |  |  |  |  |  |  |  |   addq.l #8,sp
    1622:	                     |                                      |  |  |  |  |  |  |  |  |  |   lsr.l #3,d0
    1624:	                     |                                      |  |  |  |  |  |  |  |  |  |   movea.w d7,a0
    1626:	                     |                                      |  |  |  |  |  |  |  |  |  |   adda.l a0,a0
    1628:	                     |                                      |  |  |  |  |  |  |  |  |  |   adda.l a0,a4
    162a:	                     |                                      |  |  |  |  |  |  |  |  |  |   lea (0,a4,d0.l),a5
    bltdpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltcon0 = 0xfca + ((x%16) << 12);
    162e:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.w d3,d2
    1630:	                     |                                      |  |  |  |  |  |  |  |  |  |   andi.w #15,d2
    1634:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.w d2,58(sp)
    1638:	                     |                                      |  |  |  |  |  |  |  |  |  |   moveq #15,d1
    163a:	                     |                                      |  |  |  |  |  |  |  |  |  |   and.l d3,d1
    163c:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d1,d0
    163e:	                     |                                      |  |  |  |  |  |  |  |  |  |   moveq #12,d2
    1640:	                     |                                      |  |  |  |  |  |  |  |  |  |   lsl.l d2,d0
    1642:	                     |                                      |  |  |  |  |  |  |  |  |  |   movea.l d0,a4
    1644:	                     |                                      |  |  |  |  |  |  |  |  |  |   lea 4042(a4),a4
    bltcon1 = ((x%16) << 12);
    bltalwm = 0xffff << (x%16); 
    1648:	                     |                                      |  |  |  |  |  |  |  |  |  |   moveq #0,d0
    164a:	                     |                                      |  |  |  |  |  |  |  |  |  |   not.w d0
    164c:	                     |                                      |  |  |  |  |  |  |  |  |  |   lsl.l d1,d0
    164e:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.w d0,52(sp)

    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    1652:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l cf68 <CstCleanupQueueDrawBuffer>,d2
    CstCleanupQueueDrawBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    1658:	                     |                                      |  |  |  |  |  |  |  |  |  |   movea.l d018 <SysBase>,a6
    165e:	                     |                                      |  |  |  |  |  |  |  |  |  |   moveq #20,d0
    1660:	                     |                                      |  |  |  |  |  |  |  |  |  |   moveq #0,d1
    1662:	                     |                                      |  |  |  |  |  |  |  |  |  |   jsr -684(a6)
    1666:	                     |                                      |  |  |  |  |  |  |  |  |  |   movea.l d0,a0
    1668:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d0,cf68 <CstCleanupQueueDrawBuffer>
    CstCleanupQueueDrawBuffer->next = next;   
    166e:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d2,16(a0)

    CstCleanupQueueDrawBuffer->x = x;
    1672:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.w d3,(a0)
    CstCleanupQueueDrawBuffer->y = y;
    1674:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.w 50(sp),2(a0)
    CstCleanupQueueDrawBuffer->person = person; 
    167a:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l 64(sp),4(a0)
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource; //Width in X Bytes
    1680:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l (a2),d1
    1682:	                     |                                      |  |  |  |  |  |  |  |  |  |   move.l d1,d0
    1684:	         ,-----------|--------------------------------------|--|--|--|--|--|--|--|--|--|-- bmi.w 1e82 <CstScaleSprite+0x92e>
    1688:	         |           |                                      |  |  |  |  |  |  |  |  |  |   asr.l #4,d0
    168a:	         |           |                                      |  |  |  |  |  |  |  |  |  |   movea.w 70(sp),a1
    168e:	         |           |                                      |  |  |  |  |  |  |  |  |  |   adda.w d0,a1
    1690:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w a1,8(a0)
    CstCleanupQueueDrawBuffer->height =  blitheight; //Height
    1694:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w 56(sp),d2
    1698:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w d2,10(a0)
    CstCleanupQueueDrawBuffer->startxinbytes =  (x/16)*2; //X Start in Bytes;
    169c:	         |           |                                      |  |  |  |  |  |  |  |  |  |   add.w d7,d7
    169e:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w d7,74(sp)
    16a2:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w d7,12(a0)
    CstCleanupQueueDrawBuffer->starty = ystartdst;
    16a6:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w d6,54(sp)
    16aa:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w d6,14(a0)
      CstCleanupQueueViewBuffer->starty = ystartdst;
    } 
  }

  UWORD bltafwm = 0xffff >> cutmaskpixel;
  WORD bltamod = cutwordssource*2-(extrawords*2); //Jump to next line
    16ae:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w 70(sp),d6
    16b2:	         |           |                                      |  |  |  |  |  |  |  |  |  |   add.w d6,d6
  custom->bltalwm = bltalwm;
  custom->bltamod = bltamod;
  custom->bltbmod = bltbmod;
  custom->bltcmod = bltcmod;
  custom->bltdmod = bltdmod;
  custom->bltcon0 = bltcon0;
    16b4:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w a4,72(sp)
  custom->bltcon1 = bltcon1;  
    16b8:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w 58(sp),d7
    16bc:	         |           |                                      |  |  |  |  |  |  |  |  |  |   moveq #12,d0
    16be:	         |           |                                      |  |  |  |  |  |  |  |  |  |   lsl.w d0,d7
    16c0:	         |           |                                      |  |  |  |  |  |  |  |  |  |   move.w d7,58(sp)
    if( destinationtype != SCREEN)
    16c4:	         |           |                                      |  |  |  |  |  |  |  |  |  |   cmpi.w #1,d5
    16c8:	      ,--|-----------|--------------------------------------|--|--|--|--|--|--|--|--|--|-- beq.w 1ef2 <CstScaleSprite+0x99e>
      next = CstCleanupQueueViewBuffer;
    16cc:	      |  |  ,--------|--------------------------------------|--|--|--|--|--|--|--|--|--|-> move.l cf64 <CstCleanupQueueViewBuffer>,d5
      CstCleanupQueueViewBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    16d2:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   movea.l d018 <SysBase>,a6
    16d8:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   moveq #20,d0
    16da:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   moveq #0,d1
    16dc:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   jsr -684(a6)
    16e0:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   movea.l d0,a0
    16e2:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.l d0,cf64 <CstCleanupQueueViewBuffer>
      CstCleanupQueueViewBuffer->next = next;   
    16e8:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.l d5,16(a0)
      CstCleanupQueueViewBuffer->x = x;
    16ec:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.w d3,(a0)
      CstCleanupQueueViewBuffer->y = y;
    16ee:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.w 50(sp),2(a0)
      CstCleanupQueueViewBuffer->person = person; 
    16f4:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.l 64(sp),4(a0)
      CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource;
    16fa:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.l (a2),d1
    16fc:	      |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.l d1,d0
    16fe:	   ,--|--|--|--------|--------------------------------------|--|--|--|--|--|--|--|--|--|-- bmi.w 1f38 <CstScaleSprite+0x9e4>
    1702:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   asr.l #4,d0
    1704:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.w 70(sp),d7
    1708:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   add.w d0,d7
    170a:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.w d7,8(a0)
      CstCleanupQueueViewBuffer->height =  blitheight;
    170e:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.w d2,10(a0)
      CstCleanupQueueViewBuffer->startxinbytes =  (x/16)*2; //X Start in Bytes;
    1712:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.w 74(sp),12(a0)
      CstCleanupQueueViewBuffer->starty = ystartdst; 
    1718:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.w 54(sp),14(a0)
    171e:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   movea.w #-1,a4
    extrawords = 0; //Shifted out part of source outside screen. No need to blit this
    1722:	   |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   clr.w d7
  WORD bltcmod = winWidth/8-single->width/8-extrawords*2+cutwordssource*2;
    1724:	,--|--|--|--|--------|--------------------------------------|--|--|--|--|--|--|--|--|--|-> move.l cf86 <winWidth>,d0
    172a:	|  |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   lsr.l #3,d0
    172c:	|  |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   move.w d6,d5
    172e:	|  |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   add.w d0,d5
    1730:	|  |  |  |  |        |                                      |  |  |  |  |  |  |  |  |  |   tst.l d1
    1732:	|  |  |  |  |  ,-----|--------------------------------------|--|--|--|--|--|--|--|--|--|-- blt.w 1c76 <CstScaleSprite+0x722>
    1736:	|  |  |  |  |  |  ,--|--------------------------------------|--|--|--|--|--|--|--|--|--|-> asr.l #3,d1
    1738:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   sub.w d1,d5
  WaitBlit();
    173a:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.l #53284,d3
    1740:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   movea.l d3,a0
    1742:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   movea.l (a0),a6
    1744:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   jsr -228(a6)
  custom->bltafwm = bltafwm;
    1748:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.w a4,dff044 <gcc8_c_support.c.c60c1f2b+0xdb1b95>
  custom->bltalwm = bltalwm;
    174e:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.w 52(sp),dff046 <gcc8_c_support.c.c60c1f2b+0xdb1b97>
  custom->bltamod = bltamod;
    1756:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.w d6,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
  custom->bltbmod = bltbmod;
    175c:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.w d6,dff062 <gcc8_c_support.c.c60c1f2b+0xdb1bb3>
  custom->bltcmod = bltcmod;
    1762:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.w d5,dff060 <gcc8_c_support.c.c60c1f2b+0xdb1bb1>
  custom->bltdmod = bltdmod;
    1768:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.w d5,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
  custom->bltcon0 = bltcon0;
    176e:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.w 72(sp),dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
  custom->bltcon1 = bltcon1;  
    1776:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.w 58(sp),dff042 <gcc8_c_support.c.c60c1f2b+0xdb1b93>

  UWORD bltbptplus = (single->width >> 3)*single->height;
    177e:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.l (a2),d0
  {
    custom->bltapt = (APTR) bltapt;
    custom->bltbpt = (APTR) bltbpt;
    custom->bltcpt = (APTR) bltcpt;
    custom->bltdpt = (APTR) bltdpt;
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1780:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   lsl.w #6,d2
  UWORD bltbptplus = (single->width >> 3)*single->height;
    1782:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.l d0,d6
    1784:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   asr.l #3,d6
    1786:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   muls.w 6(a2),d6
    bltbpt += bltbptplus;
    178a:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   andi.l #65535,d6
  UWORD bltcptplus = winWidth/8*winHeight;
    1790:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.l cf86 <winWidth>,d5
    1796:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   lsr.l #3,d5
    1798:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   muls.w cf8c <winHeight+0x2>,d5
    bltcpt += bltcptplus;
    179e:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   andi.l #65535,d5
    custom->bltapt = (APTR) bltapt;
    17a4:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    17aa:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.l 60(sp),dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    17b2:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.l a5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    17b8:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   move.l a5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    17be:	|  |  |  |  |  |  |  |                                      |  |  |  |  |  |  |  |  |  |   tst.l d0
    17c0:	|  |  |  |  |  |  |  |                       ,--------------|--|--|--|--|--|--|--|--|--|-- blt.w 1d06 <CstScaleSprite+0x7b2>
    17c4:	|  |  |  |  |  |  |  |                       |     ,--------|--|--|--|--|--|--|--|--|--|-> asr.l #4,d0
    17c6:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   add.w d7,d0
    17c8:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   add.w d2,d0
    17ca:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   sub.w a3,d0
    17cc:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    bltbpt += bltbptplus;
    17d2:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   movea.l 60(sp),a4
    17d6:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   adda.l d6,a4
    bltcpt += bltcptplus;
    17d8:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   adda.l d5,a5
    bltdpt += bltcptplus;
    WaitBlit();
    17da:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   movea.l d3,a0
    17dc:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   movea.l (a0),a6
    17de:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   jsr -228(a6)
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    17e2:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   move.l (a2),d0
    custom->bltapt = (APTR) bltapt;
    17e4:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    17ea:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   move.l a4,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    17f0:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   move.l a5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    17f6:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   move.l a5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    17fc:	|  |  |  |  |  |  |  |                       |     |        |  |  |  |  |  |  |  |  |  |   tst.l d0
    17fe:	|  |  |  |  |  |  |  |                 ,-----|-----|--------|--|--|--|--|--|--|--|--|--|-- blt.w 1d48 <CstScaleSprite+0x7f4>
    1802:	|  |  |  |  |  |  |  |                 |     |  ,--|--------|--|--|--|--|--|--|--|--|--|-> asr.l #4,d0
    1804:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   add.w d7,d0
    1806:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   add.w d2,d0
    1808:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   sub.w a3,d0
    180a:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    bltbpt += bltbptplus;
    1810:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   adda.l d6,a4
    bltcpt += bltcptplus;
    1812:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   adda.l d5,a5
    WaitBlit();
    1814:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l d3,a0
    1816:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l (a0),a6
    1818:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   jsr -228(a6)
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    181c:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   move.l (a2),d0
    custom->bltapt = (APTR) bltapt;
    181e:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    1824:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   move.l a4,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    182a:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   move.l a5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    1830:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   move.l a5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1836:	|  |  |  |  |  |  |  |                 |     |  |  |        |  |  |  |  |  |  |  |  |  |   tst.l d0
    1838:	|  |  |  |  |  |  |  |           ,-----|-----|--|--|--------|--|--|--|--|--|--|--|--|--|-- blt.w 1d86 <CstScaleSprite+0x832>
    183c:	|  |  |  |  |  |  |  |           |     |  ,--|--|--|--------|--|--|--|--|--|--|--|--|--|-> asr.l #4,d0
    183e:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   add.w d7,d0
    1840:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   add.w d2,d0
    1842:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   sub.w a3,d0
    1844:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    bltbpt += bltbptplus;
    184a:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   adda.l d6,a4
    bltcpt += bltcptplus;
    184c:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   adda.l d5,a5
    WaitBlit();
    184e:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l d3,a0
    1850:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l (a0),a6
    1852:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   jsr -228(a6)
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1856:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l (a2),d0
    custom->bltapt = (APTR) bltapt;
    1858:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    185e:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l a4,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    1864:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l a5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    186a:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l a5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1870:	|  |  |  |  |  |  |  |           |     |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   tst.l d0
    1872:	|  |  |  |  |  |  |  |     ,-----|-----|--|--|--|--|--------|--|--|--|--|--|--|--|--|--|-- blt.w 1dc4 <CstScaleSprite+0x870>
    1876:	|  |  |  |  |  |  |  |     |     |  ,--|--|--|--|--|--------|--|--|--|--|--|--|--|--|--|-> asr.l #4,d0
    1878:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   add.w d7,d0
    187a:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   add.w d2,d0
    187c:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   sub.w a3,d0
    187e:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    bltbpt += bltbptplus;
    1884:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   add.l a4,d6
    bltcpt += bltcptplus;
    1886:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   add.l a5,d5
    WaitBlit();
    1888:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l d3,a0
    188a:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l (a0),a6
    188c:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   jsr -228(a6)
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1890:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l (a2),d0
    custom->bltapt = (APTR) bltapt;
    1892:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    1898:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d6,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    189e:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    18a4:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    18aa:	|  |  |  |  |  |  |  |     |     |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   tst.l d0
    18ac:	|  |  |  |  |  |  |  |  ,--|-----|--|--|--|--|--|--|--------|--|--|--|--|--|--|--|--|--|-- blt.w 1e02 <CstScaleSprite+0x8ae>
    18b0:	|  |  |  |  |  |  |  |  |  |  ,--|--|--|--|--|--|--|--------|--|--|--|--|--|--|--|--|--|-> asr.l #4,d0
    18b2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   add.w d0,d7
    18b4:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   add.w d2,d7
    18b6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   sub.w a3,d7
    18b8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.w d7,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    WaitBlit();
    18be:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l d3,a0
    18c0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l (a0),a6
    18c2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   jsr -228(a6)
  }   

}
    18c6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movem.l (sp)+,d2-d7/a2-a6
    18ca:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   lea 32(sp),sp
    18ce:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   rts
      destination = (UWORD *) CstBackDrop;      
    18d0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  '--|--|--|-> movea.l cf50 <CstBackDrop>,a4
    if(y + single->height < 0) {
    18d6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |  |  |   move.l 4(a2),d1
    18da:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |  |  |   move.l a3,d0
    18dc:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |  |  |   add.l d1,d0
  if( y < 0) {
    18de:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |  |  |   tst.w d2
    18e0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     '--|--|-- bge.w 15b6 <CstScaleSprite+0x62>
    if(y + single->height < 0) {
    18e4:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  '--------|--|-> tst.l d0
    18e6:	|  |  |  |  |  |  |  +--|--|--|--|--|--|--|--|--|--|--------|--|--|--|--|-----------|--|-- blt.w 1ba2 <CstScaleSprite+0x64e>
    ystartsrc = y*-1;
    18ea:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  |   move.l a3,d2
    18ec:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  |   neg.l d2
    blitheight = single->height+y;
    18ee:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  |   move.l d0,54(sp)
    ystartdst = 0;
    18f2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  |   moveq #0,d6
    if(x + single->width < 0) {
    18f4:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  |   move.l (a2),d1
    18f6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  |   move.l a6,d0
    18f8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  |   add.l d1,d0
  if( x < 0) 
    18fa:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  |   tst.w d7
    18fc:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           |  '-- bge.w 15de <CstScaleSprite+0x8a>
    if(x + single->width < 0) {
    1900:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |           '----> tst.l d0
    1902:	|  |  |  |  |  |  |  +--|--|--|--|--|--|--|--|--|--|--------|--|--|--|--|----------------- blt.w 1ba2 <CstScaleSprite+0x64e>
    cutwordssource = (x*-1)/16; 
    1906:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  move.w d3,d0
    1908:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  addi.w #15,d0
    190c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  asr.w #4,d0
    190e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  neg.w d0
    1910:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  move.w d0,52(sp)
    1914:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  movea.w d0,a3
    cutmaskpixel = (x*-1)%16;   
    1916:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  move.l a6,d0
    1918:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  neg.l d0
    191a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  moveq #15,d7
    191c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  and.l d0,d7
    191e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  move.l d7,68(sp)
      bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 - 2;
    1922:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  lea 7b8c <__mulsi3>,a6
    1928:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  move.l cf86 <winWidth>,-(sp)
    192e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  move.l d6,-(sp)
    1930:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  move.l d1,52(sp)
    1934:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  jsr (a6)
    1936:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  addq.l #8,sp
    1938:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  lsr.l #3,d0
    if( cutmaskpixel > 0)
    193a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  move.l 44(sp),d1
    193e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |                  tst.l d7
    1940:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  ,-------------- beq.w 1bb8 <CstScaleSprite+0x664>
      bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 - 2;
    1944:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               lea (-2,a4,d0.l),a5
      bltdpt = ((ULONG) destination) + ystartdst*winWidth/8 - 2;
    1948:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.w 52(sp),d7
    194c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               subq.w #1,d7
    194e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.w d7,74(sp)
      bltcon0 = 0xfca + ((16-cutmaskpixel) << 12);
    1952:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               movea.w #16,a0
    1956:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               suba.l 68(sp),a0
    195a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l a0,d7
    195c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               moveq #12,d0
    195e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               lsl.l d0,d7
  custom->bltcon0 = bltcon0;
    1960:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               addi.w #4042,d7
    1964:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.w d7,72(sp)
  custom->bltcon1 = bltcon1;  
    1968:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.w a0,d7
    196a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               lsl.w d0,d7
    196c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.w d7,58(sp)
      extrawords = 1;
    1970:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               moveq #1,d7
    bltapt = ((ULONG) mask)+cutwordssource*2+ystartsrc*single->width/8;
    1972:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               movea.w 52(sp),a4
    1976:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               adda.l a4,a4
    1978:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l d2,-(sp)
    197a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l d1,-(sp)
    197c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               jsr (a6)
    197e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               addq.l #8,sp
    1980:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               lsr.l #3,d0
    1982:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               add.l a4,d4
    1984:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               add.l d0,d4
    bltbpt = ((ULONG) single->data)+cutwordssource*2+ystartsrc*single->width/8;
    1986:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               adda.l 24(a2),a4
    198a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               add.l a4,d0
    198c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l d0,60(sp)
    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    1990:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l cf68 <CstCleanupQueueDrawBuffer>,d2
    CstCleanupQueueDrawBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    1996:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               movea.l d018 <SysBase>,a6
    199c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               moveq #20,d0
    199e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               moveq #0,d1
    19a0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               jsr -684(a6)
    19a4:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               movea.l d0,a0
    19a6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l d0,cf68 <CstCleanupQueueDrawBuffer>
    CstCleanupQueueDrawBuffer->next = next;   
    19ac:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l d2,16(a0)
    CstCleanupQueueDrawBuffer->x = x;
    19b0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.w d3,(a0)
    CstCleanupQueueDrawBuffer->y = y;
    19b2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.w 50(sp),2(a0)
    CstCleanupQueueDrawBuffer->person = person;      
    19b8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l 64(sp),4(a0)
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource+extrawords; //Width in X Bytes
    19be:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l (a2),d1
    19c0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |               move.l d1,d0
    19c2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     ,-------- bmi.w 1c22 <CstScaleSprite+0x6ce>
    19c6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     ,-> asr.l #4,d0
    19c8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   add.w 52(sp),d0
    19cc:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   add.w d7,d0
    19ce:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   move.w d0,8(a0)
    CstCleanupQueueDrawBuffer->height = blitheight;
    19d2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   move.w 56(sp),d2
    19d6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   move.w d2,10(a0)
    CstCleanupQueueDrawBuffer->startxinbytes = 0;
    19da:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   clr.w 12(a0)
    CstCleanupQueueDrawBuffer->starty = ystartdst;
    19de:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   move.w d6,54(sp)
    19e2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   move.w d6,14(a0)
  UWORD bltafwm = 0xffff >> cutmaskpixel;
    19e6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   moveq #0,d0
    19e8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   not.w d0
    19ea:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   move.l 68(sp),d6
    19ee:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   asr.l d6,d0
    19f0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   movea.l d0,a4
  WORD bltamod = cutwordssource*2-(extrawords*2); //Jump to next line
    19f2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   move.w 74(sp),d6
    19f6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   add.w d6,d6
    if( destinationtype != SCREEN)
    19f8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |     |     |   cmpi.w #1,d5
    19fc:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  ,--|-----|-- beq.w 1c60 <CstScaleSprite+0x70c>
      next = CstCleanupQueueViewBuffer;
    1a00:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  ,--|-> move.l cf64 <CstCleanupQueueViewBuffer>,d5
      CstCleanupQueueViewBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    1a06:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l d018 <SysBase>,a6
    1a0c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   moveq #20,d0
    1a0e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   moveq #0,d1
    1a10:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   jsr -684(a6)
    1a14:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   movea.l d0,a0
    1a16:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d0,cf64 <CstCleanupQueueViewBuffer>
      CstCleanupQueueViewBuffer->next = next;
    1a1c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d5,16(a0)
      CstCleanupQueueViewBuffer->x = x;
    1a20:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.w d3,(a0)
      CstCleanupQueueViewBuffer->y = y;
    1a22:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.w 50(sp),2(a0)
      CstCleanupQueueViewBuffer->person = person;
    1a28:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l 64(sp),4(a0)
      CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource+extrawords; //Width in X Bytes
    1a2e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l (a2),d1
    1a30:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |  |  |   move.l d1,d0
    1a32:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     ,--|--|--|--|--|--|--|--|--|--|-- bmi.w 1ecc <CstScaleSprite+0x978>
    1a36:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |   asr.l #4,d0
    1a38:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |   add.w 52(sp),d0
    1a3c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |   add.w d7,d0
    1a3e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |   move.w d0,8(a0)
      CstCleanupQueueViewBuffer->height = blitheight; 
    1a42:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |   move.w d2,10(a0)
      CstCleanupQueueViewBuffer->startxinbytes = 0; 
    1a46:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |   clr.w 12(a0)
      CstCleanupQueueViewBuffer->starty = ystartdst;  
    1a4a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |   move.w 54(sp),14(a0)
    bltalwm = 0; //Last Word of this channel almost masked out
    1a50:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |   clr.w 52(sp)
  WORD bltcmod = winWidth/8-single->width/8-extrawords*2+cutwordssource*2;
    1a54:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  ,--|--|--|--|--|--|--|--|--|--|--|-> move.l cf86 <winWidth>,d0
    1a5a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   lsr.l #3,d0
    1a5c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   move.w d6,d5
    1a5e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   add.w d0,d5
    1a60:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   tst.l d1
    1a62:	|  |  |  |  |  |  +--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-- bge.w 1736 <CstScaleSprite+0x1e2>
    1a66:	|  |  |  |  |  +--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-- bra.w 1c76 <CstScaleSprite+0x722>
      destination = (UWORD *) CstDrawBuffer;      
    1a6a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  '--|--|--|--|--|--|--|--|--|-> movea.l cf60 <CstDrawBuffer>,a4
      break;
    1a70:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     '--|--|--|--|--|--|--|--|-- bra.w 15a8 <CstScaleSprite+0x54>
    ystartdst = y;
    1a74:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        '--|--|--|--|--|--|--|-> move.l a3,d6
    blitheight = single->height;
    1a76:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |  |  |  |  |  |  |   move.l d1,54(sp)
    ystartsrc = 0;
    1a7a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |  |  |  |  |  |  |   moveq #0,d2
    1a7c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           '--|--|--|--|--|--|-- bra.w 15d2 <CstScaleSprite+0x7e>
    bltapt = ((ULONG) mask) +ystartsrc*single->width/8;
    1a80:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |              '--|--|--|--|--|-> lea 7b8c <__mulsi3>,a3
    1a86:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l d2,-(sp)
    1a88:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l d1,-(sp)
    1a8a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   jsr (a3)
    1a8c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   addq.l #8,sp
    1a8e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   lsr.l #3,d0
    1a90:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   add.l d0,d4
    bltbpt = (ULONG) single->data+ystartsrc*single->width/8;
    1a92:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   add.l 24(a2),d0
    1a96:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l d0,60(sp)
    bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    1a9a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.w d3,d7
    1a9c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   asr.w #4,d7
    1a9e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l d6,-(sp)
    1aa0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l a5,-(sp)
    1aa2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   jsr (a3)
    1aa4:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   addq.l #8,sp
    1aa6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   lsr.l #3,d0
    1aa8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   movea.w d7,a0
    1aaa:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   adda.l a0,a0
    1aac:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   adda.l a0,a4
    1aae:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   lea (0,a4,d0.l),a5
    bltcon0 = 0xfca + ((x%16) << 12);
    1ab2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.w d3,d2
    1ab4:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   andi.w #15,d2
    1ab8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.w d2,58(sp)
    1abc:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   moveq #15,d0
    1abe:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   and.l d3,d0
    1ac0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   moveq #12,d1
    1ac2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   lsl.l d1,d0
    1ac4:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   movea.l d0,a3
    1ac6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   lea 4042(a3),a3
    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    1aca:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l cf68 <CstCleanupQueueDrawBuffer>,d2
    CstCleanupQueueDrawBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    1ad0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   movea.l d018 <SysBase>,a6
    1ad6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   moveq #20,d0
    1ad8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   moveq #0,d1
    1ada:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   jsr -684(a6)
    1ade:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   movea.l d0,a0
    1ae0:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l d0,cf68 <CstCleanupQueueDrawBuffer>
    CstCleanupQueueDrawBuffer->next = next;   
    1ae6:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l d2,16(a0)
    CstCleanupQueueDrawBuffer->x = x;
    1aea:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.w d3,(a0)
    CstCleanupQueueDrawBuffer->y = y;
    1aec:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.w 50(sp),2(a0)
    CstCleanupQueueDrawBuffer->person = person; 
    1af2:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l 64(sp),4(a0)
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource+extrawords; 
    1af8:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l (a2),d1
    1afa:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                 |  |  |  |  |   move.l d1,d0
    1afc:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           ,-----|--|--|--|--|-- bmi.w 1e26 <CstScaleSprite+0x8d2>
    1b00:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   asr.l #4,d0
    1b02:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   addq.w #1,d0
    1b04:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   move.w d0,8(a0)
    CstCleanupQueueDrawBuffer->height =  blitheight; 
    1b08:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   move.w 56(sp),d2
    1b0c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   move.w d2,10(a0)
    CstCleanupQueueDrawBuffer->startxinbytes =  (x/16)*2; 
    1b10:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   add.w d7,d7
    1b12:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   move.w d7,12(a0)
    CstCleanupQueueDrawBuffer->starty = ystartdst;
    1b16:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   movea.w d6,a4
    1b18:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   move.w d6,14(a0)
  custom->bltcon0 = bltcon0;
    1b1c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   move.w a3,72(sp)
  custom->bltcon1 = bltcon1;  
    1b20:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   move.w 58(sp),d6
    1b24:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   moveq #12,d0
    1b26:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   lsl.w d0,d6
    1b28:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   move.w d6,58(sp)
    if( destinationtype != SCREEN)
    1b2c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |           |     |  |  |  |  |   cmpi.w #1,d5
    1b30:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        ,--|-----|--|--|--|--|-- beq.w 1e5e <CstScaleSprite+0x90a>
      next = CstCleanupQueueViewBuffer;
    1b34:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  ,--|--|--|--|--|-> move.l cf64 <CstCleanupQueueViewBuffer>,d5
      CstCleanupQueueViewBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    1b3a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   movea.l d018 <SysBase>,a6
    1b40:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   moveq #20,d0
    1b42:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   moveq #0,d1
    1b44:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   jsr -684(a6)
    1b48:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   movea.l d0,a0
    1b4a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   move.l d0,cf64 <CstCleanupQueueViewBuffer>
      CstCleanupQueueViewBuffer->next = next;   
    1b50:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   move.l d5,16(a0)
      CstCleanupQueueViewBuffer->x = x;
    1b54:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   move.w d3,(a0)
      CstCleanupQueueViewBuffer->y = y;
    1b56:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   move.w 50(sp),2(a0)
      CstCleanupQueueViewBuffer->person = person; 
    1b5c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   move.l 64(sp),4(a0)
      CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource+extrawords; 
    1b62:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   move.l (a2),d1
    1b64:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |        |  |  |  |  |  |  |  |   move.l d1,d0
    1b66:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     ,--|--|--|--|--|--|--|--|-- bmi.w 1f0e <CstScaleSprite+0x9ba>
    1b6a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   asr.l #4,d0
    1b6c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   addq.w #1,d0
    1b6e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   move.w d0,8(a0)
      CstCleanupQueueViewBuffer->height =  blitheight; 
    1b72:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   move.w d2,10(a0)
      CstCleanupQueueViewBuffer->startxinbytes =  (x/16)*2; 
    1b76:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   move.w d7,12(a0)
      CstCleanupQueueViewBuffer->starty = ystartdst;
    1b7a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   move.w a4,14(a0)
    1b7e:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   movea.w #-1,a4
    1b82:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   moveq #-2,d6
    bltalwm = 0; //Last Word of this channel almost masked out
    1b84:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   clr.w 52(sp)
    cutwordssource = 0;
    1b88:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   suba.l a3,a3
    extrawords = 1;
    1b8a:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |   moveq #1,d7
  WORD bltcmod = winWidth/8-single->width/8-extrawords*2+cutwordssource*2;
    1b8c:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  ,--|--|--|--|--|--|--|--|--|-> move.l cf86 <winWidth>,d0
    1b92:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   lsr.l #3,d0
    1b94:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   move.w d6,d5
    1b96:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   add.w d0,d5
    1b98:	|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   tst.l d1
    1b9a:	|  |  |  |  |  |  +--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-- bge.w 1736 <CstScaleSprite+0x1e2>
    1b9e:	|  |  |  |  |  +--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-- bra.w 1c76 <CstScaleSprite+0x722>
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
    1ba2:	|  |  |  |  |  |  |  '--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|-> move.l #32747,80(sp)
}
    1baa:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   movem.l (sp)+,d2-d7/a2-a6
    1bae:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   lea 32(sp),sp
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
    1bb2:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |   jmp 725e <KPrintF>
      bltcpt = ((ULONG) destination) + ystartdst*winWidth/8;
    1bb8:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  '--|--|--|--|-> lea (0,a4,d0.l),a5
    1bbc:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.w 52(sp),74(sp)
    1bc2:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   clr.w 58(sp)
    1bc6:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.w #4042,72(sp)
      extrawords = 0;
    1bcc:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   clr.w d7
    bltapt = ((ULONG) mask)+cutwordssource*2+ystartsrc*single->width/8;
    1bce:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   movea.w 52(sp),a4
    1bd2:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   adda.l a4,a4
    1bd4:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l d2,-(sp)
    1bd6:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l d1,-(sp)
    1bd8:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   jsr (a6)
    1bda:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   addq.l #8,sp
    1bdc:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   lsr.l #3,d0
    1bde:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   add.l a4,d4
    1be0:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   add.l d0,d4
    bltbpt = ((ULONG) single->data)+cutwordssource*2+ystartsrc*single->width/8;
    1be2:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   adda.l 24(a2),a4
    1be6:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   add.l a4,d0
    1be8:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l d0,60(sp)
    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    1bec:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l cf68 <CstCleanupQueueDrawBuffer>,d2
    CstCleanupQueueDrawBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    1bf2:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   movea.l d018 <SysBase>,a6
    1bf8:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   moveq #20,d0
    1bfa:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   moveq #0,d1
    1bfc:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   jsr -684(a6)
    1c00:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   movea.l d0,a0
    1c02:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l d0,cf68 <CstCleanupQueueDrawBuffer>
    CstCleanupQueueDrawBuffer->next = next;   
    1c08:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l d2,16(a0)
    CstCleanupQueueDrawBuffer->x = x;
    1c0c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.w d3,(a0)
    CstCleanupQueueDrawBuffer->y = y;
    1c0e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.w 50(sp),2(a0)
    CstCleanupQueueDrawBuffer->person = person;      
    1c14:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l 64(sp),4(a0)
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource+extrawords; //Width in X Bytes
    1c1a:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l (a2),d1
    1c1c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  |   move.l d1,d0
    1c1e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  |  |  '-- bpl.w 19c6 <CstScaleSprite+0x472>
    1c22:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |  '--|----> moveq #15,d0
    1c24:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      add.l d1,d0
    1c26:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      asr.l #4,d0
    1c28:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      add.w 52(sp),d0
    1c2c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      add.w d7,d0
    1c2e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      move.w d0,8(a0)
    CstCleanupQueueDrawBuffer->height = blitheight;
    1c32:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      move.w 56(sp),d2
    1c36:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      move.w d2,10(a0)
    CstCleanupQueueDrawBuffer->startxinbytes = 0;
    1c3a:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      clr.w 12(a0)
    CstCleanupQueueDrawBuffer->starty = ystartdst;
    1c3e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      move.w d6,54(sp)
    1c42:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      move.w d6,14(a0)
  UWORD bltafwm = 0xffff >> cutmaskpixel;
    1c46:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      moveq #0,d0
    1c48:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      not.w d0
    1c4a:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      move.l 68(sp),d6
    1c4e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      asr.l d6,d0
    1c50:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      movea.l d0,a4
  WORD bltamod = cutwordssource*2-(extrawords*2); //Jump to next line
    1c52:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      move.w 74(sp),d6
    1c56:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      add.w d6,d6
    if( destinationtype != SCREEN)
    1c58:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     |      cmpi.w #1,d5
    1c5c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     |     '----- bne.w 1a00 <CstScaleSprite+0x4ac>
    bltalwm = 0; //Last Word of this channel almost masked out
    1c60:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |     '----------> clr.w 52(sp)
  WORD bltcmod = winWidth/8-single->width/8-extrawords*2+cutwordssource*2;
    1c64:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l cf86 <winWidth>,d0
    1c6a:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  lsr.l #3,d0
    1c6c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w d6,d5
    1c6e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  add.w d0,d5
    1c70:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  tst.l d1
    1c72:	|  |  |  |  |  |  +-----|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|----------------- bge.w 1736 <CstScaleSprite+0x1e2>
    1c76:	|  |  |  |  |  >--|-----|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|----------------> addq.l #7,d1
    1c78:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  asr.l #3,d1
    1c7a:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  sub.w d1,d5
  WaitBlit();
    1c7c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l #53284,d3
    1c82:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  movea.l d3,a0
    1c84:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  movea.l (a0),a6
    1c86:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  jsr -228(a6)
  custom->bltafwm = bltafwm;
    1c8a:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w a4,dff044 <gcc8_c_support.c.c60c1f2b+0xdb1b95>
  custom->bltalwm = bltalwm;
    1c90:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w 52(sp),dff046 <gcc8_c_support.c.c60c1f2b+0xdb1b97>
  custom->bltamod = bltamod;
    1c98:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w d6,dff064 <gcc8_c_support.c.c60c1f2b+0xdb1bb5>
  custom->bltbmod = bltbmod;
    1c9e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w d6,dff062 <gcc8_c_support.c.c60c1f2b+0xdb1bb3>
  custom->bltcmod = bltcmod;
    1ca4:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w d5,dff060 <gcc8_c_support.c.c60c1f2b+0xdb1bb1>
  custom->bltdmod = bltdmod;
    1caa:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w d5,dff066 <gcc8_c_support.c.c60c1f2b+0xdb1bb7>
  custom->bltcon0 = bltcon0;
    1cb0:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w 72(sp),dff040 <gcc8_c_support.c.c60c1f2b+0xdb1b91>
  custom->bltcon1 = bltcon1;  
    1cb8:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.w 58(sp),dff042 <gcc8_c_support.c.c60c1f2b+0xdb1b93>
  UWORD bltbptplus = (single->width >> 3)*single->height;
    1cc0:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l (a2),d0
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1cc2:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  lsl.w #6,d2
  UWORD bltbptplus = (single->width >> 3)*single->height;
    1cc4:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l d0,d6
    1cc6:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  asr.l #3,d6
    1cc8:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  muls.w 6(a2),d6
    bltbpt += bltbptplus;
    1ccc:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  andi.l #65535,d6
  UWORD bltcptplus = winWidth/8*winHeight;
    1cd2:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l cf86 <winWidth>,d5
    1cd8:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  lsr.l #3,d5
    1cda:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  muls.w cf8c <winHeight+0x2>,d5
    bltcpt += bltcptplus;
    1ce0:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  andi.l #65535,d5
    custom->bltapt = (APTR) bltapt;
    1ce6:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    1cec:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l 60(sp),dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    1cf4:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l a5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    1cfa:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  move.l a5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1d00:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |                  tst.l d0
    1d02:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  |  |  '--|--|--|--|--|--|--|----------------- bge.w 17c4 <CstScaleSprite+0x270>
    1d06:	|  |  |  |  |  |  |     |  |  |  |  |  |  |  '--|-----|--|--|--|--|--|--|----------------> moveq #15,d1
    1d08:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  add.l d1,d0
    1d0a:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  asr.l #4,d0
    1d0c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  add.w d7,d0
    1d0e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  add.w d2,d0
    1d10:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  sub.w a3,d0
    1d12:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    bltbpt += bltbptplus;
    1d18:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  movea.l 60(sp),a4
    1d1c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  adda.l d6,a4
    bltcpt += bltcptplus;
    1d1e:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  adda.l d5,a5
    WaitBlit();
    1d20:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  movea.l d3,a0
    1d22:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  movea.l (a0),a6
    1d24:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  jsr -228(a6)
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1d28:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  move.l (a2),d0
    custom->bltapt = (APTR) bltapt;
    1d2a:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    1d30:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  move.l a4,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    1d36:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  move.l a5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    1d3c:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  move.l a5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1d42:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     |     |  |  |  |  |  |  |                  tst.l d0
    1d44:	|  |  |  |  |  |  |     |  |  |  |  |  |  |     '-----|--|--|--|--|--|--|----------------- bge.w 1802 <CstScaleSprite+0x2ae>
    1d48:	|  |  |  |  |  |  |     |  |  |  |  |  '--|-----------|--|--|--|--|--|--|----------------> moveq #15,d1
    1d4a:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  add.l d1,d0
    1d4c:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  asr.l #4,d0
    1d4e:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  add.w d7,d0
    1d50:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  add.w d2,d0
    1d52:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  sub.w a3,d0
    1d54:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    bltbpt += bltbptplus;
    1d5a:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  adda.l d6,a4
    bltcpt += bltcptplus;
    1d5c:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  adda.l d5,a5
    WaitBlit();
    1d5e:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  movea.l d3,a0
    1d60:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  movea.l (a0),a6
    1d62:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  jsr -228(a6)
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1d66:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  move.l (a2),d0
    custom->bltapt = (APTR) bltapt;
    1d68:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    1d6e:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  move.l a4,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    1d74:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  move.l a5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    1d7a:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  move.l a5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1d80:	|  |  |  |  |  |  |     |  |  |  |  |     |           |  |  |  |  |  |  |                  tst.l d0
    1d82:	|  |  |  |  |  |  |     |  |  |  |  |     '-----------|--|--|--|--|--|--|----------------- bge.w 183c <CstScaleSprite+0x2e8>
    1d86:	|  |  |  |  |  |  |     |  |  |  '--|-----------------|--|--|--|--|--|--|----------------> moveq #15,d1
    1d88:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  add.l d1,d0
    1d8a:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  asr.l #4,d0
    1d8c:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  add.w d7,d0
    1d8e:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  add.w d2,d0
    1d90:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  sub.w a3,d0
    1d92:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    bltbpt += bltbptplus;
    1d98:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  adda.l d6,a4
    bltcpt += bltcptplus;
    1d9a:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  adda.l d5,a5
    WaitBlit();
    1d9c:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  movea.l d3,a0
    1d9e:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  movea.l (a0),a6
    1da0:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  jsr -228(a6)
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1da4:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  move.l (a2),d0
    custom->bltapt = (APTR) bltapt;
    1da6:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    1dac:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  move.l a4,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    1db2:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  move.l a5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    1db8:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  move.l a5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1dbe:	|  |  |  |  |  |  |     |  |  |     |                 |  |  |  |  |  |  |                  tst.l d0
    1dc0:	|  |  |  |  |  |  |     |  |  |     '-----------------|--|--|--|--|--|--|----------------- bge.w 1876 <CstScaleSprite+0x322>
    1dc4:	|  |  |  |  |  |  |     |  '--|-----------------------|--|--|--|--|--|--|----------------> moveq #15,d1
    1dc6:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  add.l d1,d0
    1dc8:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  asr.l #4,d0
    1dca:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  add.w d7,d0
    1dcc:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  add.w d2,d0
    1dce:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  sub.w a3,d0
    1dd0:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  move.w d0,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    bltbpt += bltbptplus;
    1dd6:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  add.l a4,d6
    bltcpt += bltcptplus;
    1dd8:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  add.l a5,d5
    WaitBlit();
    1dda:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  movea.l d3,a0
    1ddc:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  movea.l (a0),a6
    1dde:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  jsr -228(a6)
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1de2:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  move.l (a2),d0
    custom->bltapt = (APTR) bltapt;
    1de4:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  move.l d4,dff050 <gcc8_c_support.c.c60c1f2b+0xdb1ba1>
    custom->bltbpt = (APTR) bltbpt;
    1dea:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  move.l d6,dff04c <gcc8_c_support.c.c60c1f2b+0xdb1b9d>
    custom->bltcpt = (APTR) bltcpt;
    1df0:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  move.l d5,dff048 <gcc8_c_support.c.c60c1f2b+0xdb1b99>
    custom->bltdpt = (APTR) bltdpt;
    1df6:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  move.l d5,dff054 <gcc8_c_support.c.c60c1f2b+0xdb1ba5>
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    1dfc:	|  |  |  |  |  |  |     |     |                       |  |  |  |  |  |  |                  tst.l d0
    1dfe:	|  |  |  |  |  |  |     |     '-----------------------|--|--|--|--|--|--|----------------- bge.w 18b0 <CstScaleSprite+0x35c>
    1e02:	|  |  |  |  |  |  |     '-----------------------------|--|--|--|--|--|--|----------------> moveq #15,d1
    1e04:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  add.l d1,d0
    1e06:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  asr.l #4,d0
    1e08:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  add.w d0,d7
    1e0a:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  add.w d2,d7
    1e0c:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  sub.w a3,d7
    1e0e:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  move.w d7,dff058 <gcc8_c_support.c.c60c1f2b+0xdb1ba9>
    WaitBlit();
    1e14:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  movea.l d3,a0
    1e16:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  movea.l (a0),a6
    1e18:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  jsr -228(a6)
}
    1e1c:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  movem.l (sp)+,d2-d7/a2-a6
    1e20:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  lea 32(sp),sp
    1e24:	|  |  |  |  |  |  |                                   |  |  |  |  |  |  |                  rts
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource+extrawords; 
    1e26:	|  |  |  |  |  |  |                                   |  |  |  |  |  '--|----------------> moveq #15,d0
    1e28:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  add.l d1,d0
    1e2a:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  asr.l #4,d0
    1e2c:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  addq.w #1,d0
    1e2e:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  move.w d0,8(a0)
    CstCleanupQueueDrawBuffer->height =  blitheight; 
    1e32:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  move.w 56(sp),d2
    1e36:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  move.w d2,10(a0)
    CstCleanupQueueDrawBuffer->startxinbytes =  (x/16)*2; 
    1e3a:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  add.w d7,d7
    1e3c:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  move.w d7,12(a0)
    CstCleanupQueueDrawBuffer->starty = ystartdst;
    1e40:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  movea.w d6,a4
    1e42:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  move.w d6,14(a0)
  custom->bltcon0 = bltcon0;
    1e46:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  move.w a3,72(sp)
  custom->bltcon1 = bltcon1;  
    1e4a:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  move.w 58(sp),d6
    1e4e:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  moveq #12,d0
    1e50:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  lsl.w d0,d6
    1e52:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  move.w d6,58(sp)
    if( destinationtype != SCREEN)
    1e56:	|  |  |  |  |  |  |                                   |  |  |  |  |     |                  cmpi.w #1,d5
    1e5a:	|  |  |  |  |  |  |                                   |  |  |  |  |     '----------------- bne.w 1b34 <CstScaleSprite+0x5e0>
    extrawords = 1;
    1e5e:	|  |  |  |  |  |  |                                   |  |  |  |  '----------------------> moveq #1,d7
    1e60:	|  |  |  |  |  |  |                                   |  |  |  |                           movea.w #-1,a4
    1e64:	|  |  |  |  |  |  |                                   |  |  |  |                           moveq #-2,d6
    bltalwm = 0; //Last Word of this channel almost masked out
    1e66:	|  |  |  |  |  |  |                                   |  |  |  |                           clr.w 52(sp)
    cutwordssource = 0;
    1e6a:	|  |  |  |  |  |  |                                   |  |  |  |                           suba.l a3,a3
  WORD bltcmod = winWidth/8-single->width/8-extrawords*2+cutwordssource*2;
    1e6c:	|  |  |  |  |  |  |                                   |  |  |  |                           move.l cf86 <winWidth>,d0
    1e72:	|  |  |  |  |  |  |                                   |  |  |  |                           lsr.l #3,d0
    1e74:	|  |  |  |  |  |  |                                   |  |  |  |                           move.w d6,d5
    1e76:	|  |  |  |  |  |  |                                   |  |  |  |                           add.w d0,d5
    1e78:	|  |  |  |  |  |  |                                   |  |  |  |                           tst.l d1
    1e7a:	|  |  |  |  |  |  +-----------------------------------|--|--|--|-------------------------- bge.w 1736 <CstScaleSprite+0x1e2>
    1e7e:	|  |  |  |  |  +--|-----------------------------------|--|--|--|-------------------------- bra.w 1c76 <CstScaleSprite+0x722>
    CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource; //Width in X Bytes
    1e82:	|  |  |  '--|--|--|-----------------------------------|--|--|--|-------------------------> moveq #15,d0
    1e84:	|  |  |     |  |  |                                   |  |  |  |                           add.l d1,d0
    1e86:	|  |  |     |  |  |                                   |  |  |  |                           asr.l #4,d0
    1e88:	|  |  |     |  |  |                                   |  |  |  |                           movea.w 70(sp),a1
    1e8c:	|  |  |     |  |  |                                   |  |  |  |                           adda.w d0,a1
    1e8e:	|  |  |     |  |  |                                   |  |  |  |                           move.w a1,8(a0)
    CstCleanupQueueDrawBuffer->height =  blitheight; //Height
    1e92:	|  |  |     |  |  |                                   |  |  |  |                           move.w 56(sp),d2
    1e96:	|  |  |     |  |  |                                   |  |  |  |                           move.w d2,10(a0)
    CstCleanupQueueDrawBuffer->startxinbytes =  (x/16)*2; //X Start in Bytes;
    1e9a:	|  |  |     |  |  |                                   |  |  |  |                           add.w d7,d7
    1e9c:	|  |  |     |  |  |                                   |  |  |  |                           move.w d7,74(sp)
    1ea0:	|  |  |     |  |  |                                   |  |  |  |                           move.w d7,12(a0)
    CstCleanupQueueDrawBuffer->starty = ystartdst;
    1ea4:	|  |  |     |  |  |                                   |  |  |  |                           move.w d6,54(sp)
    1ea8:	|  |  |     |  |  |                                   |  |  |  |                           move.w d6,14(a0)
  WORD bltamod = cutwordssource*2-(extrawords*2); //Jump to next line
    1eac:	|  |  |     |  |  |                                   |  |  |  |                           move.w 70(sp),d6
    1eb0:	|  |  |     |  |  |                                   |  |  |  |                           add.w d6,d6
  custom->bltcon0 = bltcon0;
    1eb2:	|  |  |     |  |  |                                   |  |  |  |                           move.w a4,72(sp)
  custom->bltcon1 = bltcon1;  
    1eb6:	|  |  |     |  |  |                                   |  |  |  |                           move.w 58(sp),d7
    1eba:	|  |  |     |  |  |                                   |  |  |  |                           moveq #12,d0
    1ebc:	|  |  |     |  |  |                                   |  |  |  |                           lsl.w d0,d7
    1ebe:	|  |  |     |  |  |                                   |  |  |  |                           move.w d7,58(sp)
    if( destinationtype != SCREEN)
    1ec2:	|  |  |     |  |  |                                   |  |  |  |                           cmpi.w #1,d5
    1ec6:	|  |  |     '--|--|-----------------------------------|--|--|--|-------------------------- bne.w 16cc <CstScaleSprite+0x178>
    1eca:	|  |  +--------|--|-----------------------------------|--|--|--|-------------------------- bra.s 1ef2 <CstScaleSprite+0x99e>
      CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource+extrawords; //Width in X Bytes
    1ecc:	|  |  |        |  |                                   |  '--|--|-------------------------> moveq #15,d0
    1ece:	|  |  |        |  |                                   |     |  |                           add.l d1,d0
    1ed0:	|  |  |        |  |                                   |     |  |                           asr.l #4,d0
    1ed2:	|  |  |        |  |                                   |     |  |                           add.w 52(sp),d0
    1ed6:	|  |  |        |  |                                   |     |  |                           add.w d7,d0
    1ed8:	|  |  |        |  |                                   |     |  |                           move.w d0,8(a0)
      CstCleanupQueueViewBuffer->height = blitheight; 
    1edc:	|  |  |        |  |                                   |     |  |                           move.w d2,10(a0)
      CstCleanupQueueViewBuffer->startxinbytes = 0; 
    1ee0:	|  |  |        |  |                                   |     |  |                           clr.w 12(a0)
      CstCleanupQueueViewBuffer->starty = ystartdst;  
    1ee4:	|  |  |        |  |                                   |     |  |                           move.w 54(sp),14(a0)
    bltalwm = 0; //Last Word of this channel almost masked out
    1eea:	|  |  |        |  |                                   |     |  |                           clr.w 52(sp)
    1eee:	|  |  |        |  |                                   '-----|--|-------------------------- bra.w 1a54 <CstScaleSprite+0x500>
    1ef2:	|  |  '--------|--|-----------------------------------------|--|-------------------------> movea.w #-1,a4
    extrawords = 0; //Shifted out part of source outside screen. No need to blit this
    1ef6:	|  |           |  |                                         |  |                           clr.w d7
  WORD bltcmod = winWidth/8-single->width/8-extrawords*2+cutwordssource*2;
    1ef8:	|  |           |  |                                         |  |                           move.l cf86 <winWidth>,d0
    1efe:	|  |           |  |                                         |  |                           lsr.l #3,d0
    1f00:	|  |           |  |                                         |  |                           move.w d6,d5
    1f02:	|  |           |  |                                         |  |                           add.w d0,d5
    1f04:	|  |           |  |                                         |  |                           tst.l d1
    1f06:	|  |           |  '-----------------------------------------|--|-------------------------- bge.w 1736 <CstScaleSprite+0x1e2>
    1f0a:	|  |           '--------------------------------------------|--|-------------------------- bra.w 1c76 <CstScaleSprite+0x722>
      CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource+extrawords; 
    1f0e:	|  |                                                        |  '-------------------------> moveq #15,d0
    1f10:	|  |                                                        |                              add.l d1,d0
    1f12:	|  |                                                        |                              asr.l #4,d0
    1f14:	|  |                                                        |                              addq.w #1,d0
    1f16:	|  |                                                        |                              move.w d0,8(a0)
      CstCleanupQueueViewBuffer->height =  blitheight; 
    1f1a:	|  |                                                        |                              move.w d2,10(a0)
      CstCleanupQueueViewBuffer->startxinbytes =  (x/16)*2; 
    1f1e:	|  |                                                        |                              move.w d7,12(a0)
      CstCleanupQueueViewBuffer->starty = ystartdst;
    1f22:	|  |                                                        |                              move.w a4,14(a0)
    1f26:	|  |                                                        |                              movea.w #-1,a4
    1f2a:	|  |                                                        |                              moveq #-2,d6
    bltalwm = 0; //Last Word of this channel almost masked out
    1f2c:	|  |                                                        |                              clr.w 52(sp)
    cutwordssource = 0;
    1f30:	|  |                                                        |                              suba.l a3,a3
    extrawords = 1;
    1f32:	|  |                                                        |                              moveq #1,d7
    1f34:	|  |                                                        '----------------------------- bra.w 1b8c <CstScaleSprite+0x638>
      CstCleanupQueueViewBuffer->widthinwords = single->width/16+cutwordssource;
    1f38:	|  '-------------------------------------------------------------------------------------> moveq #15,d0
    1f3a:	|                                                                                          add.l d1,d0
    1f3c:	|                                                                                          asr.l #4,d0
    1f3e:	|                                                                                          move.w 70(sp),d7
    1f42:	|                                                                                          add.w d0,d7
    1f44:	|                                                                                          move.w d7,8(a0)
      CstCleanupQueueViewBuffer->height =  blitheight;
    1f48:	|                                                                                          move.w d2,10(a0)
      CstCleanupQueueViewBuffer->startxinbytes =  (x/16)*2; //X Start in Bytes;
    1f4c:	|                                                                                          move.w 74(sp),12(a0)
      CstCleanupQueueViewBuffer->starty = ystartdst; 
    1f52:	|                                                                                          move.w 54(sp),14(a0)
    1f58:	|                                                                                          movea.w #-1,a4
    extrawords = 0; //Shifted out part of source outside screen. No need to blit this
    1f5c:	|                                                                                          clr.w d7
    1f5e:	'----------------------------------------------------------------------------------------- bra.w 1724 <CstScaleSprite+0x1d0>

00001f62 <CstSetCl>:

void CstSetCl(UWORD *copperlist)
{
    1f62:	subq.l #4,sp
  volatile struct Custom *custom = (struct Custom*)0xdff000;
    1f64:	move.l #14675968,(sp)
  custom->cop1lc = (ULONG) copperlist;
    1f6a:	move.l 8(sp),d0
    1f6e:	movea.l (sp),a0
    1f70:	move.l d0,128(a0)
}
    1f74:	nop
    1f76:	addq.l #4,sp
    1f78:	rts

00001f7a <CstSwapBuffer>:

void CstSwapBuffer( ) {
    1f7a:	lea -20(sp),sp
  ULONG *tmp;
  tmp = CstViewBuffer;
    1f7e:	move.l cf5c <CstViewBuffer>,16(sp)
  CstViewBuffer = CstDrawBuffer;
    1f86:	move.l cf60 <CstDrawBuffer>,d0
    1f8c:	move.l d0,cf5c <CstViewBuffer>
  CstDrawBuffer = tmp;
    1f92:	move.l 16(sp),cf60 <CstDrawBuffer>

  struct CleanupQueue *tmp2 = CstCleanupQueueViewBuffer;
    1f9a:	move.l cf64 <CstCleanupQueueViewBuffer>,12(sp)
  CstCleanupQueueViewBuffer = CstCleanupQueueDrawBuffer;
    1fa2:	move.l cf68 <CstCleanupQueueDrawBuffer>,d0
    1fa8:	move.l d0,cf64 <CstCleanupQueueViewBuffer>
  CstCleanupQueueDrawBuffer = tmp2;
    1fae:	move.l 12(sp),cf68 <CstCleanupQueueDrawBuffer>


  UWORD *copword = CstCopperList;
    1fb6:	move.l cf58 <CstCopperList>,8(sp)
  ULONG ptr = (ULONG) CstViewBuffer;
    1fbe:	move.l cf5c <CstViewBuffer>,d0
    1fc4:	move.l d0,4(sp)
  UWORD highword = ptr >> 16;
    1fc8:	move.l 4(sp),d0
    1fcc:	clr.w d0
    1fce:	swap d0
    1fd0:	move.w d0,2(sp)
  UWORD lowword = ptr & 0xffff;  
    1fd4:	move.w 6(sp),(sp)

  copword[CSTBPL1LOW] = lowword;
    1fd8:	movea.w #118,a0
    1fdc:	adda.l 8(sp),a0
    1fe0:	move.w (sp),(a0)
  copword[CSTBPL1HIGH] = highword;
    1fe2:	movea.w #114,a0
    1fe6:	adda.l 8(sp),a0
    1fea:	move.w 2(sp),(a0)

  ptr +=  40*256;
    1fee:	addi.l #10240,4(sp)
  highword = ptr >> 16;
    1ff6:	move.l 4(sp),d0
    1ffa:	clr.w d0
    1ffc:	swap d0
    1ffe:	move.w d0,2(sp)
  lowword = ptr & 0xffff;  
    2002:	move.w 6(sp),(sp)

  copword[CSTBPL2LOW] = lowword;
    2006:	movea.w #126,a0
    200a:	adda.l 8(sp),a0
    200e:	move.w (sp),(a0)
  copword[CSTBPL2HIGH] = highword;
    2010:	movea.w #122,a0
    2014:	adda.l 8(sp),a0
    2018:	move.w 2(sp),(a0)
  
  ptr +=  40*256;
    201c:	addi.l #10240,4(sp)
  highword = ptr >> 16;
    2024:	move.l 4(sp),d0
    2028:	clr.w d0
    202a:	swap d0
    202c:	move.w d0,2(sp)
  lowword = ptr & 0xffff;  
    2030:	move.w 6(sp),(sp)
  
  copword[CSTBPL3LOW] = lowword;
    2034:	movea.l 8(sp),a0
    2038:	lea 134(a0),a0
    203c:	move.w (sp),(a0)
  copword[CSTBPL3HIGH] = highword;
    203e:	movea.l 8(sp),a0
    2042:	lea 130(a0),a0
    2046:	move.w 2(sp),(a0)

  ptr +=  40*256;
    204a:	addi.l #10240,4(sp)
  highword = ptr >> 16;
    2052:	move.l 4(sp),d0
    2056:	clr.w d0
    2058:	swap d0
    205a:	move.w d0,2(sp)
  lowword = ptr & 0xffff;  
    205e:	move.w 6(sp),(sp)

  copword[CSTBPL4LOW] = lowword;
    2062:	movea.l 8(sp),a0
    2066:	lea 142(a0),a0
    206a:	move.w (sp),(a0)
  copword[CSTBPL4HIGH] = highword;
    206c:	movea.l 8(sp),a0
    2070:	lea 138(a0),a0
    2074:	move.w 2(sp),(a0)

  ptr +=  40*256;
    2078:	addi.l #10240,4(sp)
  highword = ptr >> 16;
    2080:	move.l 4(sp),d0
    2084:	clr.w d0
    2086:	swap d0
    2088:	move.w d0,2(sp)
  lowword = ptr & 0xffff;  
    208c:	move.w 6(sp),(sp)

  copword[CSTBPL5LOW] = lowword;
    2090:	movea.l 8(sp),a0
    2094:	lea 150(a0),a0
    2098:	move.w (sp),(a0)
  copword[CSTBPL5HIGH] = highword;
    209a:	movea.l 8(sp),a0
    209e:	lea 146(a0),a0
    20a2:	move.w 2(sp),(a0)

}
    20a6:	nop
    20a8:	lea 20(sp),sp
    20ac:	rts

000020ae <CstReserveBackdrop>:

BOOL CstReserveBackdrop(int width, int height) {
    20ae:	          lea -68(sp),sp
    20b2:	          move.l a6,-(sp)

 	KPrintF("CstReserveBackdrop: Begin");
    20b4:	          pea 801e <PutChar+0x3aa>
    20ba:	          jsr 725e <KPrintF>
    20c0:	          addq.l #4,sp

  width = width / 8;
    20c2:	          move.l 76(sp),d0
    20c6:	      ,-- bpl.s 20ca <CstReserveBackdrop+0x1c>
    20c8:	      |   addq.l #7,d0
    20ca:	      '-> asr.l #3,d0
    20cc:	          move.l d0,76(sp)

  if( width < 40) 
    20d0:	          moveq #39,d0
    20d2:	          cmp.l 76(sp),d0
    20d6:	      ,-- blt.s 20ec <CstReserveBackdrop+0x3e>
  {
    KPrintF("CstReserveBackdrop: Screens smaller than 320px not supported.");
    20d8:	      |   pea 8038 <PutChar+0x3c4>
    20de:	      |   jsr 725e <KPrintF>
    20e4:	      |   addq.l #4,sp
    return FALSE;
    20e6:	      |   clr.w d0
    20e8:	,-----|-- bra.w 2428 <CstReserveBackdrop+0x37a>
  }  
  KPrintF("CstReserveBackdrop: Screen Okay");
    20ec:	|     '-> pea 8076 <PutChar+0x402>
    20f2:	|         jsr 725e <KPrintF>
    20f8:	|         addq.l #4,sp

  CstCopperList = CstCreateCopperlist( width);
    20fa:	|         move.l 76(sp),-(sp)
    20fe:	|         jsr 82a <CstCreateCopperlist>
    2104:	|         addq.l #4,sp
    2106:	|         move.l d0,cf58 <CstCopperList>
  KPrintF("CstReserveBackdrop: Copperlist created");
    210c:	|         pea 8096 <PutChar+0x422>
    2112:	|         jsr 725e <KPrintF>
    2118:	|         addq.l #4,sp
  CstBackdropSizePlane = width*height;
    211a:	|         move.l 76(sp),d1
    211e:	|         move.l 80(sp),d0
    2122:	|         muls.w d1,d0
    2124:	|         move.w d0,cf4e <CstBackdropSizePlane>
  CstBackdropSize = CstBackdropSizePlane * 5; //Todo: Support other Bitplane Modes;  
    212a:	|         move.w cf4e <CstBackdropSizePlane>,d1
    2130:	|         move.w d1,d0
    2132:	|         add.w d0,d0
    2134:	|         add.w d0,d0
    2136:	|         add.w d1,d0
    2138:	|         move.w d0,cf4c <CstBackdropSize>
  

  CstBackDrop = AllocVec(CstBackdropSize,MEMF_CHIP);
    213e:	|         move.w cf4c <CstBackdropSize>,d0
    2144:	|         move.w d0,d0
    2146:	|         andi.l #65535,d0
    214c:	|         move.l d0,60(sp)
    2150:	|         moveq #2,d1
    2152:	|         move.l d1,56(sp)
    2156:	|         move.l d018 <SysBase>,d0
    215c:	|         movea.l d0,a6
    215e:	|         move.l 60(sp),d0
    2162:	|         move.l 56(sp),d1
    2166:	|         jsr -684(a6)
    216a:	|         move.l d0,52(sp)
    216e:	|         move.l 52(sp),d0
    2172:	|         move.l d0,cf50 <CstBackDrop>
  if( !CstBackDrop)
    2178:	|         move.l cf50 <CstBackDrop>,d0
    217e:	|     ,-- bne.s 2194 <CstReserveBackdrop+0xe6>
  {    
    KPrintF("CstReserveBackdrop: Cannot allocate memory for Backdrop");
    2180:	|     |   pea 80bd <PutChar+0x449>
    2186:	|     |   jsr 725e <KPrintF>
    218c:	|     |   addq.l #4,sp
    return FALSE;  
    218e:	|     |   clr.w d0
    2190:	+-----|-- bra.w 2428 <CstReserveBackdrop+0x37a>
  }
  KPrintF("CstReserveBackdrop: Backdrop reserved");
    2194:	|     '-> pea 80f5 <PutChar+0x481>
    219a:	|         jsr 725e <KPrintF>
    21a0:	|         addq.l #4,sp

  //Initialize Buffer
  ULONG *cursor = (ULONG *)CstBackDrop;
    21a2:	|         move.l cf50 <CstBackDrop>,68(sp)
  for(int i=0;i<CstBackdropSize/4;i++)
    21aa:	|         clr.l 64(sp)
    21ae:	|     ,-- bra.s 21c4 <CstReserveBackdrop+0x116>
  {
    *cursor++ = 0;
    21b0:	|  ,--|-> move.l 68(sp),d0
    21b4:	|  |  |   move.l d0,d1
    21b6:	|  |  |   addq.l #4,d1
    21b8:	|  |  |   move.l d1,68(sp)
    21bc:	|  |  |   movea.l d0,a0
    21be:	|  |  |   clr.l (a0)
  for(int i=0;i<CstBackdropSize/4;i++)
    21c0:	|  |  |   addq.l #1,64(sp)
    21c4:	|  |  '-> move.w cf4c <CstBackdropSize>,d0
    21ca:	|  |      lsr.w #2,d0
    21cc:	|  |      move.w d0,d0
    21ce:	|  |      andi.l #65535,d0
    21d4:	|  |      cmp.l 64(sp),d0
    21d8:	|  '----- bgt.s 21b0 <CstReserveBackdrop+0x102>
  }  
  
  CstDrawBuffer = AllocVec(CstBackdropSize+width*2,MEMF_CHIP); //Some extra size for bob routine border area
    21da:	|         move.w cf4c <CstBackdropSize>,d0
    21e0:	|         move.w d0,d0
    21e2:	|         andi.l #65535,d0
    21e8:	|         move.l 76(sp),d1
    21ec:	|         add.l d1,d1
    21ee:	|         add.l d1,d0
    21f0:	|         move.l d0,48(sp)
    21f4:	|         moveq #2,d0
    21f6:	|         move.l d0,44(sp)
    21fa:	|         move.l d018 <SysBase>,d0
    2200:	|         movea.l d0,a6
    2202:	|         move.l 48(sp),d0
    2206:	|         move.l 44(sp),d1
    220a:	|         jsr -684(a6)
    220e:	|         move.l d0,40(sp)
    2212:	|         move.l 40(sp),d0
    2216:	|         move.l d0,cf60 <CstDrawBuffer>
  if( !CstDrawBuffer)
    221c:	|         move.l cf60 <CstDrawBuffer>,d0
    2222:	|     ,-- bne.s 2238 <CstReserveBackdrop+0x18a>
  {    
    KPrintF("CstReserveBackdrop: Cannot allocate memory for DrawBuffer");
    2224:	|     |   pea 811b <PutChar+0x4a7>
    222a:	|     |   jsr 725e <KPrintF>
    2230:	|     |   addq.l #4,sp
    return FALSE;  
    2232:	|     |   clr.w d0
    2234:	+-----|-- bra.w 2428 <CstReserveBackdrop+0x37a>
  }
  KPrintF("CstReserveBackdrop: DrawBuffer reserved");
    2238:	|     '-> pea 8155 <PutChar+0x4e1>
    223e:	|         jsr 725e <KPrintF>
    2244:	|         addq.l #4,sp
    
  CstViewBuffer = AllocVec(CstBackdropSize+width*2,MEMF_CHIP); //Some extra size for bob routine border area
    2246:	|         move.w cf4c <CstBackdropSize>,d0
    224c:	|         move.w d0,d0
    224e:	|         andi.l #65535,d0
    2254:	|         move.l 76(sp),d1
    2258:	|         add.l d1,d1
    225a:	|         add.l d1,d0
    225c:	|         move.l d0,36(sp)
    2260:	|         moveq #2,d1
    2262:	|         move.l d1,32(sp)
    2266:	|         move.l d018 <SysBase>,d0
    226c:	|         movea.l d0,a6
    226e:	|         move.l 36(sp),d0
    2272:	|         move.l 32(sp),d1
    2276:	|         jsr -684(a6)
    227a:	|         move.l d0,28(sp)
    227e:	|         move.l 28(sp),d0
    2282:	|         move.l d0,cf5c <CstViewBuffer>
  if( !CstViewBuffer)
    2288:	|         move.l cf5c <CstViewBuffer>,d0
    228e:	|     ,-- bne.s 22a4 <CstReserveBackdrop+0x1f6>
  {    
    KPrintF("CstReserveBackdrop: Cannot allocate memory for ViewBuffer");
    2290:	|     |   pea 817d <PutChar+0x509>
    2296:	|     |   jsr 725e <KPrintF>
    229c:	|     |   addq.l #4,sp
    return FALSE;  
    229e:	|     |   clr.w d0
    22a0:	+-----|-- bra.w 2428 <CstReserveBackdrop+0x37a>
  }
  KPrintF("CstReserveBackdrop: ViewBuffer reserved");
    22a4:	|     '-> pea 81b7 <PutChar+0x543>
    22aa:	|         jsr 725e <KPrintF>
    22b0:	|         addq.l #4,sp
  
  CstDrawBuffer += width/4; //divide with 4 because pointer is ulong 
    22b2:	|         move.l cf60 <CstDrawBuffer>,d1
    22b8:	|         move.l 76(sp),d0
    22bc:	|     ,-- bpl.s 22c0 <CstReserveBackdrop+0x212>
    22be:	|     |   addq.l #3,d0
    22c0:	|     '-> asr.l #2,d0
    22c2:	|         add.l d0,d0
    22c4:	|         add.l d0,d0
    22c6:	|         add.l d1,d0
    22c8:	|         move.l d0,cf60 <CstDrawBuffer>
  CstViewBuffer += width/4; //divide with 4 because pointer is ulong
    22ce:	|         move.l cf5c <CstViewBuffer>,d1
    22d4:	|         move.l 76(sp),d0
    22d8:	|     ,-- bpl.s 22dc <CstReserveBackdrop+0x22e>
    22da:	|     |   addq.l #3,d0
    22dc:	|     '-> asr.l #2,d0
    22de:	|         add.l d0,d0
    22e0:	|         add.l d0,d0
    22e2:	|         add.l d1,d0
    22e4:	|         move.l d0,cf5c <CstViewBuffer>
  
  CstZBufferResult = AllocVec( CSTMAXWIDTHSPRITE/8*CSTMAXHEIGHTSPRITE,MEMF_CHIP);
    22ea:	|         move.l #5200,24(sp)
    22f2:	|         moveq #2,d0
    22f4:	|         move.l d0,20(sp)
    22f8:	|         move.l d018 <SysBase>,d0
    22fe:	|         movea.l d0,a6
    2300:	|         move.l 24(sp),d0
    2304:	|         move.l 20(sp),d1
    2308:	|         jsr -684(a6)
    230c:	|         move.l d0,16(sp)
    2310:	|         move.l 16(sp),d0
    2314:	|         move.l d0,cf7a <CstZBufferResult>
  CstZBufferWork = AllocVec( (CSTMAXWIDTHSPRITE/8+2)*CSTMAXHEIGHTSPRITE,MEMF_CHIP);
    231a:	|         move.l #5600,12(sp)
    2322:	|         moveq #2,d1
    2324:	|         move.l d1,8(sp)
    2328:	|         move.l d018 <SysBase>,d0
    232e:	|         movea.l d0,a6
    2330:	|         move.l 12(sp),d0
    2334:	|         move.l 8(sp),d1
    2338:	|         jsr -684(a6)
    233c:	|         move.l d0,4(sp)
    2340:	|         move.l 4(sp),d0
    2344:	|         move.l d0,cf7e <CstZBufferWork>

#ifdef EMULATOR
 	debug_register_bitmap(CstBackDrop, "CstBackDrop.bpl", 320, 256, 5, 0);
    234a:	|         move.l cf50 <CstBackDrop>,d0
    2350:	|         clr.l -(sp)
    2352:	|         pea 5 <_start+0x5>
    2356:	|         pea 100 <copyString+0x48>
    235a:	|         pea 140 <encodeFilename+0x28>
    235e:	|         pea 81df <PutChar+0x56b>
    2364:	|         move.l d0,-(sp)
    2366:	|         jsr 7346 <debug_register_bitmap>
    236c:	|         lea 24(sp),sp
  debug_register_bitmap(CstDrawBuffer, "drawbuffer.bpl", width*8, height, 5, 0);
    2370:	|         move.l 80(sp),d0
    2374:	|         movea.w d0,a1
    2376:	|         move.l 76(sp),d0
    237a:	|         lsl.w #3,d0
    237c:	|         movea.w d0,a0
    237e:	|         move.l cf60 <CstDrawBuffer>,d0
    2384:	|         clr.l -(sp)
    2386:	|         pea 5 <_start+0x5>
    238a:	|         move.l a1,-(sp)
    238c:	|         move.l a0,-(sp)
    238e:	|         pea 81ef <PutChar+0x57b>
    2394:	|         move.l d0,-(sp)
    2396:	|         jsr 7346 <debug_register_bitmap>
    239c:	|         lea 24(sp),sp
  debug_register_bitmap(CstViewBuffer, "viewbuffer.bpl", width*8, height, 5, 0);
    23a0:	|         move.l 80(sp),d0
    23a4:	|         movea.w d0,a1
    23a6:	|         move.l 76(sp),d0
    23aa:	|         lsl.w #3,d0
    23ac:	|         movea.w d0,a0
    23ae:	|         move.l cf5c <CstViewBuffer>,d0
    23b4:	|         clr.l -(sp)
    23b6:	|         pea 5 <_start+0x5>
    23ba:	|         move.l a1,-(sp)
    23bc:	|         move.l a0,-(sp)
    23be:	|         pea 81fe <PutChar+0x58a>
    23c4:	|         move.l d0,-(sp)
    23c6:	|         jsr 7346 <debug_register_bitmap>
    23cc:	|         lea 24(sp),sp
#endif

  

  if( !CstCopperList || ! CstDrawBuffer || !CstViewBuffer)
    23d0:	|         move.l cf58 <CstCopperList>,d0
    23d6:	|     ,-- beq.s 23e8 <CstReserveBackdrop+0x33a>
    23d8:	|     |   move.l cf60 <CstDrawBuffer>,d0
    23de:	|     +-- beq.s 23e8 <CstReserveBackdrop+0x33a>
    23e0:	|     |   move.l cf5c <CstViewBuffer>,d0
    23e6:	|  ,--|-- bne.s 23fa <CstReserveBackdrop+0x34c>
  {
    KPrintF("CstReserveBackdrop: Memory allocation failed");
    23e8:	|  |  '-> pea 820d <PutChar+0x599>
    23ee:	|  |      jsr 725e <KPrintF>
    23f4:	|  |      addq.l #4,sp
    return FALSE;
    23f6:	|  |      clr.w d0
    23f8:	+--|----- bra.s 2428 <CstReserveBackdrop+0x37a>
  }

  KPrintF("CstReserveBackdrop: Setting Copperlist");
    23fa:	|  '----> pea 823a <PutChar+0x5c6>
    2400:	|         jsr 725e <KPrintF>
    2406:	|         addq.l #4,sp
  CstSetCl( CstCopperList);
    2408:	|         move.l cf58 <CstCopperList>,d0
    240e:	|         move.l d0,-(sp)
    2410:	|         jsr 1f62 <CstSetCl>
    2416:	|         addq.l #4,sp
  KPrintF("CstReserveBackdrop: Copperlist Set");
    2418:	|         pea 8261 <PutChar+0x5ed>
    241e:	|         jsr 725e <KPrintF>
    2424:	|         addq.l #4,sp
  return TRUE;
    2426:	|         moveq #1,d0

}
    2428:	'-------> movea.l (sp)+,a6
    242a:	          lea 68(sp),sp
    242e:	          rts

00002430 <CstVBlankHandler>:
  KPrintF("CstUnfreeze: Finished");

}

void CstVBlankHandler()
{
    2430:	subq.l #4,sp
  volatile struct Custom *custom = (struct Custom*)0xdff000;    
    2432:	move.l #14675968,(sp)
  KPrintF("CstVBlankHandler: VBlank Handler Started");
    2438:	pea 82e9 <PutChar+0x675>
    243e:	jsr 725e <KPrintF>
    2444:	addq.l #4,sp


  custom->intreq = 1 << INTB_COPER;
    2446:	movea.l (sp),a0
    2448:	move.w #16,156(a0)
  custom->intreq = 1 << INTB_COPER;
    244e:	movea.l (sp),a0
    2450:	move.w #16,156(a0)
  //p61Music();
  CstFrameCounter++;
    2456:	move.w cf70 <CstFrameCounter>,d0
    245c:	addq.w #1,d0
    245e:	move.w d0,cf70 <CstFrameCounter>
}
    2464:	nop
    2466:	addq.l #4,sp
    2468:	rts

0000246a <initSpeech>:
		*offset = (int) ((FLOAT)winWidth/cameraZoom) - 5 - xx2;
	}
}


void initSpeech () {
    246a:	       lea -12(sp),sp
    246e:	       move.l a6,-(sp)
	speech = AllocVec(sizeof(struct speechStruct), MEMF_ANY);
    2470:	       moveq #20,d0
    2472:	       move.l d0,12(sp)
    2476:	       clr.l 8(sp)
    247a:	       move.l d018 <SysBase>,d0
    2480:	       movea.l d0,a6
    2482:	       move.l 12(sp),d0
    2486:	       move.l 8(sp),d1
    248a:	       jsr -684(a6)
    248e:	       move.l d0,4(sp)
    2492:	       move.l 4(sp),d0
    2496:	       move.l d0,cf82 <speech>
	if (speech) {
    249c:	       move.l cf82 <speech>,d0
    24a2:	,----- beq.s 24ce <initSpeech+0x64>
		speech -> currentTalker = NULL;
    24a4:	|      movea.l cf82 <speech>,a0
    24aa:	|      clr.l (a0)
		speech -> allSpeech = NULL;
    24ac:	|      movea.l cf82 <speech>,a0
    24b2:	|      clr.l 4(a0)
		speech -> speechY = 0;
    24b6:	|      movea.l cf82 <speech>,a0
    24bc:	|      clr.l 8(a0)
		speech -> lastFile = -1;
    24c0:	|      movea.l cf82 <speech>,a0
    24c6:	|      moveq #-1,d0
    24c8:	|      move.l d0,12(a0)
	} else
    {
        KPrintF("Could not allocate memory");
    }
}
    24cc:	|  ,-- bra.s 24dc <initSpeech+0x72>
        KPrintF("Could not allocate memory");
    24ce:	'--|-> pea 8312 <PutChar+0x69e>
    24d4:	   |   jsr 725e <KPrintF>
    24da:	   |   addq.l #4,sp
}
    24dc:	   '-> nop
    24de:	       movea.l (sp)+,a6
    24e0:	       lea 12(sp),sp
    24e4:	       rts

000024e6 <setFrames>:
			viewLine = viewLine -> next;
		}
		FPutC (fp, 0);
}

void setFrames (struct onScreenPerson *m, int a) {
    24e6:	move.l d2,-(sp)
	m->myAnim = m->myPersona -> animation[(a * m->myPersona -> numDirections) + m->direction];
    24e8:	movea.l 8(sp),a0
    24ec:	movea.l 80(a0),a0
    24f0:	move.l (a0),d2
    24f2:	movea.l 8(sp),a0
    24f6:	movea.l 80(a0),a0
    24fa:	move.l 4(a0),d0
    24fe:	move.l 12(sp),-(sp)
    2502:	move.l d0,-(sp)
    2504:	jsr 7b8c <__mulsi3>
    250a:	addq.l #8,sp
    250c:	move.l d0,d1
    250e:	movea.l 8(sp),a0
    2512:	move.l 106(a0),d0
    2516:	add.l d1,d0
    2518:	add.l d0,d0
    251a:	add.l d0,d0
    251c:	movea.l d2,a0
    251e:	adda.l d0,a0
    2520:	move.l (a0),d0
    2522:	movea.l 8(sp),a0
    2526:	move.l d0,72(a0)
}
    252a:	nop
    252c:	move.l (sp)+,d2
    252e:	rts

00002530 <deleteTextures>:
extern int specialSettings;
struct textureList *firstTexture = NULL;
BOOL NPOT_textures = TRUE;

void deleteTextures(unsigned int n,  unsigned int * textures)
{
    2530:	                      lea -24(sp),sp
    2534:	                      move.l a6,-(sp)
	if (firstTexture == NULL) {
    2536:	                      move.l cf8e <firstTexture>,d0
    253c:	,-------------------- beq.w 261a <deleteTextures+0xea>
		//debugOut("Deleting texture while list is already empty.\n");
	} else {
		for (unsigned int i = 0; i < n; i++) {
    2540:	|                     clr.l 24(sp)
    2544:	|     ,-------------- bra.w 260e <deleteTextures+0xde>
			BOOL found = FALSE;
    2548:	|  ,--|-------------> clr.w 18(sp)
			struct textureList *list = firstTexture;
    254c:	|  |  |               move.l cf8e <firstTexture>,20(sp)
			if (list->name == textures[i]) {
    2554:	|  |  |               movea.l 20(sp),a0
    2558:	|  |  |               move.l (a0),d1
    255a:	|  |  |               move.l 24(sp),d0
    255e:	|  |  |               add.l d0,d0
    2560:	|  |  |               add.l d0,d0
    2562:	|  |  |               movea.l 36(sp),a0
    2566:	|  |  |               adda.l d0,a0
    2568:	|  |  |               move.l (a0),d0
    256a:	|  |  |               cmp.l d1,d0
    256c:	|  |  |  ,----------- bne.w 2600 <deleteTextures+0xd0>
				found = TRUE;
    2570:	|  |  |  |            move.w #1,18(sp)
				firstTexture = list->next;
    2576:	|  |  |  |            movea.l 20(sp),a0
    257a:	|  |  |  |            move.l 12(a0),d0
    257e:	|  |  |  |            move.l d0,cf8e <firstTexture>
				FreeVec(list);
    2584:	|  |  |  |            move.l 20(sp),6(sp)
    258a:	|  |  |  |            move.l d018 <SysBase>,d0
    2590:	|  |  |  |            movea.l d0,a6
    2592:	|  |  |  |            movea.l 6(sp),a1
    2596:	|  |  |  |            jsr -690(a6)
				continue;
    259a:	|  |  |  |  ,-------- bra.s 260a <deleteTextures+0xda>
			}

			while (list->next) {
				if (list->next->name == textures[i]) {
    259c:	|  |  |  |  |  ,----> movea.l 20(sp),a0
    25a0:	|  |  |  |  |  |      movea.l 12(a0),a0
    25a4:	|  |  |  |  |  |      move.l (a0),d1
    25a6:	|  |  |  |  |  |      move.l 24(sp),d0
    25aa:	|  |  |  |  |  |      add.l d0,d0
    25ac:	|  |  |  |  |  |      add.l d0,d0
    25ae:	|  |  |  |  |  |      movea.l 36(sp),a0
    25b2:	|  |  |  |  |  |      adda.l d0,a0
    25b4:	|  |  |  |  |  |      move.l (a0),d0
    25b6:	|  |  |  |  |  |      cmp.l d1,d0
    25b8:	|  |  |  |  |  |  ,-- bne.s 25f6 <deleteTextures+0xc6>
					found = TRUE;
    25ba:	|  |  |  |  |  |  |   move.w #1,18(sp)
					struct textureList *deleteMe = list->next;
    25c0:	|  |  |  |  |  |  |   movea.l 20(sp),a0
    25c4:	|  |  |  |  |  |  |   move.l 12(a0),14(sp)
					list->next = list->next->next;
    25ca:	|  |  |  |  |  |  |   movea.l 20(sp),a0
    25ce:	|  |  |  |  |  |  |   movea.l 12(a0),a0
    25d2:	|  |  |  |  |  |  |   move.l 12(a0),d0
    25d6:	|  |  |  |  |  |  |   movea.l 20(sp),a0
    25da:	|  |  |  |  |  |  |   move.l d0,12(a0)
					FreeVec(deleteMe);
    25de:	|  |  |  |  |  |  |   move.l 14(sp),10(sp)
    25e4:	|  |  |  |  |  |  |   move.l d018 <SysBase>,d0
    25ea:	|  |  |  |  |  |  |   movea.l d0,a6
    25ec:	|  |  |  |  |  |  |   movea.l 10(sp),a1
    25f0:	|  |  |  |  |  |  |   jsr -690(a6)
					break;
    25f4:	|  |  |  |  +--|--|-- bra.s 260a <deleteTextures+0xda>
				}
				list = list->next;
    25f6:	|  |  |  |  |  |  '-> movea.l 20(sp),a0
    25fa:	|  |  |  |  |  |      move.l 12(a0),20(sp)
			while (list->next) {
    2600:	|  |  |  '--|--|----> movea.l 20(sp),a0
    2604:	|  |  |     |  |      move.l 12(a0),d0
    2608:	|  |  |     |  '----- bne.s 259c <deleteTextures+0x6c>
		for (unsigned int i = 0; i < n; i++) {
    260a:	|  |  |     '-------> addq.l #1,24(sp)
    260e:	|  |  '-------------> move.l 24(sp),d0
    2612:	|  |                  cmp.l 32(sp),d0
    2616:	|  '----------------- bcs.w 2548 <deleteTextures+0x18>
			}
		}
	}
}
    261a:	'-------------------> nop
    261c:	                      movea.l (sp)+,a6
    261e:	                      lea 24(sp),sp
    2622:	                      rts

00002624 <main_sludge>:
char * gamePath = NULL;
char *bundleFolder;
int weAreDoneSoQuit;

int main_sludge(int argc, char *argv[])
{
    2624:	             lea -44(sp),sp
    2628:	             movem.l d2-d3/a6,-(sp)
	CstInitVBlankHandler();
    262c:	             jsr 122a <CstInitVBlankHandler>

	/* Dimensions of our window. */
	//AMIGA TODO: Maybe remove as there will be no windowed mode
    winWidth = 320;
    2632:	             move.l #320,cf86 <winWidth>
    winHeight = 256;
    263c:	             move.l #256,cf8a <winHeight>

	char * sludgeFile;

	if(argc == 0) {
    2646:	             tst.l 60(sp)
    264a:	         ,-- bne.s 2662 <main_sludge+0x3e>
		bundleFolder = copyString("game/");
    264c:	         |   pea 83bc <PutChar+0x748>
    2652:	         |   jsr b8 <copyString>
    2658:	         |   addq.l #4,sp
    265a:	         |   move.l d0,cf9a <bundleFolder>
    2660:	      ,--|-- bra.s 2678 <main_sludge+0x54>
	} else {
		bundleFolder = copyString(argv[0]);
    2662:	      |  '-> movea.l 64(sp),a0
    2666:	      |      move.l (a0),d0
    2668:	      |      move.l d0,-(sp)
    266a:	      |      jsr b8 <copyString>
    2670:	      |      addq.l #4,sp
    2672:	      |      move.l d0,cf9a <bundleFolder>
	}
    
	int lastSlash = -1;
    2678:	      '----> moveq #-1,d0
    267a:	             move.l d0,48(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
    267e:	             clr.l 44(sp)
    2682:	      ,----- bra.s 26a4 <main_sludge+0x80>
		if (bundleFolder[i] == PATHSLASH) lastSlash = i;
    2684:	   ,--|----> move.l cf9a <bundleFolder>,d1
    268a:	   |  |      move.l 44(sp),d0
    268e:	   |  |      movea.l d1,a0
    2690:	   |  |      adda.l d0,a0
    2692:	   |  |      move.b (a0),d0
    2694:	   |  |      cmpi.b #47,d0
    2698:	   |  |  ,-- bne.s 26a0 <main_sludge+0x7c>
    269a:	   |  |  |   move.l 44(sp),48(sp)
	for (int i = 0; bundleFolder[i]; i ++) {
    26a0:	   |  |  '-> addq.l #1,44(sp)
    26a4:	   |  '----> move.l cf9a <bundleFolder>,d1
    26aa:	   |         move.l 44(sp),d0
    26ae:	   |         movea.l d1,a0
    26b0:	   |         adda.l d0,a0
    26b2:	   |         move.b (a0),d0
    26b4:	   '-------- bne.s 2684 <main_sludge+0x60>
	}
	bundleFolder[lastSlash+1] = NULL;
    26b6:	             move.l cf9a <bundleFolder>,d0
    26bc:	             move.l 48(sp),d1
    26c0:	             addq.l #1,d1
    26c2:	             movea.l d0,a0
    26c4:	             adda.l d1,a0
    26c6:	             clr.b (a0)

	if (argc > 1) {
    26c8:	             moveq #1,d0
    26ca:	             cmp.l 60(sp),d0
    26ce:	         ,-- bge.s 26ea <main_sludge+0xc6>
		sludgeFile = argv[argc - 1];
    26d0:	         |   move.l 60(sp),d0
    26d4:	         |   addi.l #1073741823,d0
    26da:	         |   add.l d0,d0
    26dc:	         |   add.l d0,d0
    26de:	         |   movea.l 64(sp),a0
    26e2:	         |   adda.l d0,a0
    26e4:	         |   move.l (a0),52(sp)
    26e8:	      ,--|-- bra.s 2744 <main_sludge+0x120>
	} else {
		sludgeFile = joinStrings (bundleFolder, "gamedata.slg");
    26ea:	      |  '-> move.l cf9a <bundleFolder>,d0
    26f0:	      |      pea 83c2 <PutChar+0x74e>
    26f6:	      |      move.l d0,-(sp)
    26f8:	      |      jsr 6d20 <joinStrings>
    26fe:	      |      addq.l #8,sp
    2700:	      |      move.l d0,52(sp)
		if (! ( fileExists (sludgeFile) ) ) {
    2704:	      |      move.l 52(sp),-(sp)
    2708:	      |      jsr 6c1a <fileExists>
    270e:	      |      addq.l #4,sp
    2710:	      |      tst.b d0
    2712:	      +----- bne.s 2744 <main_sludge+0x120>
			FreeVec(sludgeFile);
    2714:	      |      move.l 52(sp),40(sp)
    271a:	      |      move.l d018 <SysBase>,d0
    2720:	      |      movea.l d0,a6
    2722:	      |      movea.l 40(sp),a1
    2726:	      |      jsr -690(a6)
			sludgeFile = joinStrings (bundleFolder, "gamedata");			
    272a:	      |      move.l cf9a <bundleFolder>,d0
    2730:	      |      pea 83cf <PutChar+0x75b>
    2736:	      |      move.l d0,-(sp)
    2738:	      |      jsr 6d20 <joinStrings>
    273e:	      |      addq.l #8,sp
    2740:	      |      move.l d0,52(sp)
	//AMIGA TODO: Show arguments
	/*if (! parseCmdlineParameters(argc, argv) && !(sludgeFile) ) {
		printCmdlineUsage();
		return 0;
	}*/
	KPrintF("Game file not found.\n");
    2744:	      '----> pea 83d8 <PutChar+0x764>
    274a:	             jsr 725e <KPrintF>
    2750:	             addq.l #4,sp
	if (! fileExists(sludgeFile) ) {	
    2752:	             move.l 52(sp),-(sp)
    2756:	             jsr 6c1a <fileExists>
    275c:	             addq.l #4,sp
    275e:	             tst.b d0
    2760:	         ,-- bne.s 27b8 <main_sludge+0x194>
		Write(Output(), (APTR)"Game file not found.\n", 21);
    2762:	         |   move.l d020 <DOSBase>,d0
    2768:	         |   movea.l d0,a6
    276a:	         |   jsr -60(a6)
    276e:	         |   move.l d0,28(sp)
    2772:	         |   move.l 28(sp),d0
    2776:	         |   move.l d0,24(sp)
    277a:	         |   move.l #33752,20(sp)
    2782:	         |   moveq #21,d0
    2784:	         |   move.l d0,16(sp)
    2788:	         |   move.l d020 <DOSBase>,d0
    278e:	         |   movea.l d0,a6
    2790:	         |   move.l 24(sp),d1
    2794:	         |   move.l 20(sp),d2
    2798:	         |   move.l 16(sp),d3
    279c:	         |   jsr -48(a6)
    27a0:	         |   move.l d0,12(sp)
		KPrintF("Game file not found.\n");
    27a4:	         |   pea 83d8 <PutChar+0x764>
    27aa:	         |   jsr 725e <KPrintF>
    27b0:	         |   addq.l #4,sp
		//AMIGA TODO: Show arguments
		//printCmdlineUsage();
		return 0;
    27b2:	         |   moveq #0,d0
    27b4:	,--------|-- bra.w 29d0 <main_sludge+0x3ac>
	}

	KPrintF("Setgamefilepath\n");
    27b8:	|        '-> pea 83ee <PutChar+0x77a>
    27be:	|            jsr 725e <KPrintF>
    27c4:	|            addq.l #4,sp
	setGameFilePath (sludgeFile);	
    27c6:	|            move.l 52(sp),-(sp)
    27ca:	|            jsr 29da <setGameFilePath>
    27d0:	|            addq.l #4,sp
	if (! initSludge (sludgeFile)) return 0;
    27d2:	|            move.l 52(sp),-(sp)
    27d6:	|            jsr 2c18 <initSludge>
    27dc:	|            addq.l #4,sp
    27de:	|            tst.w d0
    27e0:	|        ,-- bne.s 27e8 <main_sludge+0x1c4>
    27e2:	|        |   moveq #0,d0
    27e4:	+--------|-- bra.w 29d0 <main_sludge+0x3ac>
	
	if( winWidth != 320 || winHeight != 256) {
    27e8:	|        '-> move.l cf86 <winWidth>,d0
    27ee:	|            cmpi.l #320,d0
    27f4:	|        ,-- bne.s 2804 <main_sludge+0x1e0>
    27f6:	|        |   move.l cf8a <winHeight>,d0
    27fc:	|        |   cmpi.l #256,d0
    2802:	|     ,--|-- beq.s 2826 <main_sludge+0x202>
		KPrintF("This Screen Format is currently unsupported on Amiga. Only PAL Lowres supported atm. winWidth and winHeight will be reseted.");	
    2804:	|     |  '-> pea 83ff <PutChar+0x78b>
    280a:	|     |      jsr 725e <KPrintF>
    2810:	|     |      addq.l #4,sp
		winWidth = 320;
    2812:	|     |      move.l #320,cf86 <winWidth>
		winHeight = 256;
    281c:	|     |      move.l #256,cf8a <winHeight>
	}

	KPrintF("Resizing Backdrop\n");
    2826:	|     '----> pea 847c <PutChar+0x808>
    282c:	|            jsr 725e <KPrintF>
    2832:	|            addq.l #4,sp
	if (! resizeBackdrop (winWidth, winHeight)) {
    2834:	|            move.l cf8a <winHeight>,d0
    283a:	|            move.l d0,d1
    283c:	|            move.l cf86 <winWidth>,d0
    2842:	|            move.l d1,-(sp)
    2844:	|            move.l d0,-(sp)
    2846:	|            jsr 6586 <resizeBackdrop>
    284c:	|            addq.l #8,sp
    284e:	|            tst.w d0
    2850:	|        ,-- bne.s 2866 <main_sludge+0x242>
		KPrintF("Couldn't allocate memory for backdrop");
    2852:	|        |   pea 848f <PutChar+0x81b>
    2858:	|        |   jsr 725e <KPrintF>
    285e:	|        |   addq.l #4,sp
		return FALSE;
    2860:	|        |   moveq #0,d0
    2862:	+--------|-- bra.w 29d0 <main_sludge+0x3ac>
	}

	KPrintF("Init People\n");
    2866:	|        '-> pea 84b5 <PutChar+0x841>
    286c:	|            jsr 725e <KPrintF>
    2872:	|            addq.l #4,sp
	if (! initPeople ())
    2874:	|            jsr 5ba2 <initPeople>
    287a:	|            tst.w d0
    287c:	|        ,-- bne.s 2892 <main_sludge+0x26e>
	{
		KPrintF("Couldn't initialise people stuff");
    287e:	|        |   pea 84c2 <PutChar+0x84e>
    2884:	|        |   jsr 725e <KPrintF>
    288a:	|        |   addq.l #4,sp
		return FALSE;
    288c:	|        |   moveq #0,d0
    288e:	+--------|-- bra.w 29d0 <main_sludge+0x3ac>
	}

	KPrintF("Init Floor\n");
    2892:	|        '-> pea 84e3 <PutChar+0x86f>
    2898:	|            jsr 725e <KPrintF>
    289e:	|            addq.l #4,sp
	if (! initFloor ())
    28a0:	|            jsr 7182 <initFloor>
    28a6:	|            tst.w d0
    28a8:	|        ,-- bne.s 28be <main_sludge+0x29a>
	{
		KPrintF("Couldn't initialise floor stuff");
    28aa:	|        |   pea 84ef <PutChar+0x87b>
    28b0:	|        |   jsr 725e <KPrintF>
    28b6:	|        |   addq.l #4,sp
		
		return FALSE;
    28b8:	|        |   moveq #0,d0
    28ba:	+--------|-- bra.w 29d0 <main_sludge+0x3ac>
	}

	KPrintF("Init Objecttype\n");
    28be:	|        '-> pea 850f <PutChar+0x89b>
    28c4:	|            jsr 725e <KPrintF>
    28ca:	|            addq.l #4,sp
	if (! initObjectTypes ())
    28cc:	|            jsr 65c2 <initObjectTypes>
    28d2:	|            tst.w d0
    28d4:	|        ,-- bne.s 28ea <main_sludge+0x2c6>
	{
		KPrintF("Couldn't initialise object type stuff");
    28d6:	|        |   pea 8520 <PutChar+0x8ac>
    28dc:	|        |   jsr 725e <KPrintF>
    28e2:	|        |   addq.l #4,sp
		return FALSE;
    28e4:	|        |   moveq #0,d0
    28e6:	+--------|-- bra.w 29d0 <main_sludge+0x3ac>
	}

	KPrintF("Init speech\n");
    28ea:	|        '-> pea 8546 <PutChar+0x8d2>
    28f0:	|            jsr 725e <KPrintF>
    28f6:	|            addq.l #4,sp
	initSpeech ();
    28f8:	|            jsr 246a <initSpeech>
	KPrintF("Init status bar\n");
    28fe:	|            pea 8553 <PutChar+0x8df>
    2904:	|            jsr 725e <KPrintF>
    290a:	|            addq.l #4,sp
	initStatusBar ();
    290c:	|            jsr 482c <initStatusBar>

	KPrintF("Get numbered string\n");
    2912:	|            pea 8564 <PutChar+0x8f0>
    2918:	|            jsr 725e <KPrintF>
    291e:	|            addq.l #4,sp
	gameName = getNumberedString(1);
    2920:	|            pea 1 <_start+0x1>
    2924:	|            jsr 3d84 <getNumberedString>
    292a:	|            addq.l #4,sp
    292c:	|            move.l d0,cf92 <gameName>
	//initSoundStuff (hMainWindow); Todo Amiga: Maybe move soundstuff here
	KPrintF("Start new function num\n");
    2932:	|            pea 8579 <PutChar+0x905>
    2938:	|            jsr 725e <KPrintF>
    293e:	|            addq.l #4,sp
	startNewFunctionNum (0, 0, NULL, noStack, TRUE);
    2940:	|            move.l cfe8 <noStack>,d0
    2946:	|            pea 1 <_start+0x1>
    294a:	|            move.l d0,-(sp)
    294c:	|            clr.l -(sp)
    294e:	|            clr.l -(sp)
    2950:	|            clr.l -(sp)
    2952:	|            jsr 3d2e <startNewFunctionNum>
    2958:	|            lea 20(sp),sp

	KPrintF("Starting main loop");
    295c:	|            pea 8591 <PutChar+0x91d>
    2962:	|            jsr 725e <KPrintF>
    2968:	|            addq.l #4,sp

	volatile struct Custom *custom = (struct Custom*)0xdff000;
    296a:	|            move.l #14675968,36(sp)
	weAreDoneSoQuit = 0;
    2972:	|            clr.l cf9e <weAreDoneSoQuit>
	//WaitVbl();
	CstFrameCounter = 0;
    2978:	|            clr.w cf70 <CstFrameCounter>

	while ( !weAreDoneSoQuit ) {	
    297e:	|     ,----- bra.s 29b2 <main_sludge+0x38e>
		//custom->color[0] = 0xf00;			
		sludgeDisplay ();
    2980:	|  ,--|----> jsr 3bf8 <sludgeDisplay>
		CsiCheckInput();
    2986:	|  |  |      jsr 6270 <CsiCheckInput>
		walkAllPeople();
    298c:	|  |  |      jsr 5efc <walkAllPeople>
		//handleInput();
		//custom->color[0] = 0x000;			
		//WaitVbl();
		while( CstFrameCounter < gameSettings.refreshRate)
    2992:	|  |  |      nop
    2994:	|  |  |  ,-> move.w cf70 <CstFrameCounter>,d0
    299a:	|  |  |  |   move.w d0,d0
    299c:	|  |  |  |   andi.l #65535,d0
    29a2:	|  |  |  |   move.l d0d0 <gameSettings+0xa>,d1
    29a8:	|  |  |  |   cmp.l d0,d1
    29aa:	|  |  |  '-- bhi.s 2994 <main_sludge+0x370>
		{		
		}
		CstFrameCounter = 0;
    29ac:	|  |  |      clr.w cf70 <CstFrameCounter>
	while ( !weAreDoneSoQuit ) {	
    29b2:	|  |  '----> move.l cf9e <weAreDoneSoQuit>,d0
    29b8:	|  '-------- beq.s 2980 <main_sludge+0x35c>
	}	
	//Amiga Cleanup
	FreeVec(sludgeFile);
    29ba:	|            move.l 52(sp),32(sp)
    29c0:	|            move.l d018 <SysBase>,d0
    29c6:	|            movea.l d0,a6
    29c8:	|            movea.l 32(sp),a1
    29cc:	|            jsr -690(a6)
}
    29d0:	'----------> movem.l (sp)+,d2-d3/a6
    29d4:	             lea 44(sp),sp
    29d8:	             rts

000029da <setGameFilePath>:

void setGameFilePath (char * f) {
    29da:	          lea -1104(sp),sp
    29de:	          move.l a6,-(sp)
    29e0:	          move.l d2,-(sp)
	char currentDir[1000];

	if (!GetCurrentDirName( currentDir, 998)) {
    29e2:	          move.l #1112,d0
    29e8:	          add.l sp,d0
    29ea:	          addi.l #-1102,d0
    29f0:	          move.l d0,1100(sp)
    29f4:	          move.l #998,1096(sp)
    29fc:	          move.l d020 <DOSBase>,d0
    2a02:	          movea.l d0,a6
    2a04:	          move.l 1100(sp),d1
    2a08:	          move.l 1096(sp),d2
    2a0c:	          jsr -564(a6)
    2a10:	          move.w d0,1094(sp)
    2a14:	          move.w 1094(sp),d0
    2a18:	      ,-- bne.s 2a28 <setGameFilePath+0x4e>
		KPrintF("setGameFilePath:  current directory.\n");
    2a1a:	      |   pea 85a4 <PutChar+0x930>
    2a20:	      |   jsr 725e <KPrintF>
    2a26:	      |   addq.l #4,sp
	}	

	int got = -1, a;	
    2a28:	      '-> moveq #-1,d0
    2a2a:	          move.l d0,1108(sp)

	for (a = 0; f[a]; a ++) {
    2a2e:	          clr.l 1104(sp)
    2a32:	   ,----- bra.s 2a50 <setGameFilePath+0x76>
		if (f[a] == PATHSLASH) got = a;
    2a34:	,--|----> move.l 1104(sp),d0
    2a38:	|  |      movea.l 1116(sp),a0
    2a3c:	|  |      adda.l d0,a0
    2a3e:	|  |      move.b (a0),d0
    2a40:	|  |      cmpi.b #47,d0
    2a44:	|  |  ,-- bne.s 2a4c <setGameFilePath+0x72>
    2a46:	|  |  |   move.l 1104(sp),1108(sp)
	for (a = 0; f[a]; a ++) {
    2a4c:	|  |  '-> addq.l #1,1104(sp)
    2a50:	|  '----> move.l 1104(sp),d0
    2a54:	|         movea.l 1116(sp),a0
    2a58:	|         adda.l d0,a0
    2a5a:	|         move.b (a0),d0
    2a5c:	'-------- bne.s 2a34 <setGameFilePath+0x5a>
	}

	if (got != -1) {
    2a5e:	          moveq #-1,d0
    2a60:	          cmp.l 1108(sp),d0
    2a64:	   ,----- beq.s 2ade <setGameFilePath+0x104>
		f[got] = 0;	
    2a66:	   |      move.l 1108(sp),d0
    2a6a:	   |      movea.l 1116(sp),a0
    2a6e:	   |      adda.l d0,a0
    2a70:	   |      clr.b (a0)
		BPTR lock = Lock(f, ACCESS_READ);	
    2a72:	   |      move.l 1116(sp),1090(sp)
    2a78:	   |      moveq #-2,d0
    2a7a:	   |      move.l d0,1086(sp)
    2a7e:	   |      move.l d020 <DOSBase>,d0
    2a84:	   |      movea.l d0,a6
    2a86:	   |      move.l 1090(sp),d1
    2a8a:	   |      move.l 1086(sp),d2
    2a8e:	   |      jsr -84(a6)
    2a92:	   |      move.l d0,1082(sp)
    2a96:	   |      move.l 1082(sp),d0
    2a9a:	   |      move.l d0,1078(sp)
		if (!CurrentDir(lock)) {
    2a9e:	   |      move.l 1078(sp),1074(sp)
    2aa4:	   |      move.l d020 <DOSBase>,d0
    2aaa:	   |      movea.l d0,a6
    2aac:	   |      move.l 1074(sp),d1
    2ab0:	   |      jsr -126(a6)
    2ab4:	   |      move.l d0,1070(sp)
    2ab8:	   |      move.l 1070(sp),d0
    2abc:	   |  ,-- bne.s 2ad0 <setGameFilePath+0xf6>
			KPrintF("setGameFilePath:: Failed changing to directory %s\n", f);
    2abe:	   |  |   move.l 1116(sp),-(sp)
    2ac2:	   |  |   pea 85ca <PutChar+0x956>
    2ac8:	   |  |   jsr 725e <KPrintF>
    2ace:	   |  |   addq.l #8,sp
		}
		f[got] = PATHSLASH;
    2ad0:	   |  '-> move.l 1108(sp),d0
    2ad4:	   |      movea.l 1116(sp),a0
    2ad8:	   |      adda.l d0,a0
    2ada:	   |      move.b #47,(a0)
	}

	gamePath = AllocVec(400, MEMF_ANY);
    2ade:	   '----> move.l #400,1066(sp)
    2ae6:	          clr.l 1062(sp)
    2aea:	          move.l d018 <SysBase>,d0
    2af0:	          movea.l d0,a6
    2af2:	          move.l 1066(sp),d0
    2af6:	          move.l 1062(sp),d1
    2afa:	          jsr -684(a6)
    2afe:	          move.l d0,1058(sp)
    2b02:	          move.l 1058(sp),d0
    2b06:	          move.l d0,cf96 <gamePath>
	if (gamePath==0) {
    2b0c:	          move.l cf96 <gamePath>,d0
    2b12:	      ,-- bne.s 2b26 <setGameFilePath+0x14c>
		KPrintF("setGameFilePath: Can't reserve memory for game directory.\n");
    2b14:	      |   pea 85fd <PutChar+0x989>
    2b1a:	      |   jsr 725e <KPrintF>
    2b20:	      |   addq.l #4,sp
    2b22:	   ,--|-- bra.w 2c0e <setGameFilePath+0x234>
		return;
	}

	BPTR lock = Lock(gamePath, ACCESS_READ);	
    2b26:	   |  '-> move.l cf96 <gamePath>,1054(sp)
    2b2e:	   |      moveq #-2,d0
    2b30:	   |      move.l d0,1050(sp)
    2b34:	   |      move.l d020 <DOSBase>,d0
    2b3a:	   |      movea.l d0,a6
    2b3c:	   |      move.l 1054(sp),d1
    2b40:	   |      move.l 1050(sp),d2
    2b44:	   |      jsr -84(a6)
    2b48:	   |      move.l d0,1046(sp)
    2b4c:	   |      move.l 1046(sp),d0
    2b50:	   |      move.l d0,1042(sp)
	if (! CurrentDir(lock)) {
    2b54:	   |      move.l 1042(sp),1038(sp)
    2b5a:	   |      move.l d020 <DOSBase>,d0
    2b60:	   |      movea.l d0,a6
    2b62:	   |      move.l 1038(sp),d1
    2b66:	   |      jsr -126(a6)
    2b6a:	   |      move.l d0,1034(sp)
    2b6e:	   |      move.l 1034(sp),d0
    2b72:	   |  ,-- bne.s 2b82 <setGameFilePath+0x1a8>
		KPrintF("setGameFilePath: Can't get game directory.\n");
    2b74:	   |  |   pea 8638 <PutChar+0x9c4>
    2b7a:	   |  |   jsr 725e <KPrintF>
    2b80:	   |  |   addq.l #4,sp
	}
	
	lock = Lock(currentDir, ACCESS_READ);	
    2b82:	   |  '-> move.l #1112,d0
    2b88:	   |      add.l sp,d0
    2b8a:	   |      addi.l #-1102,d0
    2b90:	   |      move.l d0,1030(sp)
    2b94:	   |      moveq #-2,d0
    2b96:	   |      move.l d0,1026(sp)
    2b9a:	   |      move.l d020 <DOSBase>,d0
    2ba0:	   |      movea.l d0,a6
    2ba2:	   |      move.l 1030(sp),d1
    2ba6:	   |      move.l 1026(sp),d2
    2baa:	   |      jsr -84(a6)
    2bae:	   |      move.l d0,1022(sp)
    2bb2:	   |      move.l 1022(sp),d0
    2bb6:	   |      move.l d0,1042(sp)
	if (!CurrentDir(lock)) {	
    2bba:	   |      move.l 1042(sp),1018(sp)
    2bc0:	   |      move.l d020 <DOSBase>,d0
    2bc6:	   |      movea.l d0,a6
    2bc8:	   |      move.l 1018(sp),d1
    2bcc:	   |      jsr -126(a6)
    2bd0:	   |      move.l d0,1014(sp)
    2bd4:	   |      move.l 1014(sp),d0
    2bd8:	   |  ,-- bne.s 2bee <setGameFilePath+0x214>
		KPrintF("setGameFilePath: Failed changing to directory %s\n", currentDir);
    2bda:	   |  |   moveq #10,d0
    2bdc:	   |  |   add.l sp,d0
    2bde:	   |  |   move.l d0,-(sp)
    2be0:	   |  |   pea 8664 <PutChar+0x9f0>
    2be6:	   |  |   jsr 725e <KPrintF>
    2bec:	   |  |   addq.l #8,sp
	}

	//Free Mem
	if (gamePath != 0) FreeVec(gamePath);
    2bee:	   |  '-> move.l cf96 <gamePath>,d0
    2bf4:	   +----- beq.s 2c0e <setGameFilePath+0x234>
    2bf6:	   |      move.l cf96 <gamePath>,1010(sp)
    2bfe:	   |      move.l d018 <SysBase>,d0
    2c04:	   |      movea.l d0,a6
    2c06:	   |      movea.l 1010(sp),a1
    2c0a:	   |      jsr -690(a6)
}
    2c0e:	   '----> move.l (sp)+,d2
    2c10:	          movea.l (sp)+,a6
    2c12:	          lea 1104(sp),sp
    2c16:	          rts

00002c18 <initSludge>:

	lastRegion = overRegion;
	return runSludge ();
}

BOOL initSludge (char * filename) {
    2c18:	             lea -292(sp),sp
    2c1c:	             movem.l d2-d4/a2/a6,-(sp)
	int a = 0;
    2c20:	             clr.l 308(sp)
	mouseCursorAnim = makeNullAnim ();
    2c24:	             jsr 5bc0 <makeNullAnim>
    2c2a:	             move.l d0,cf44 <mouseCursorAnim>

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, &gameVersion);
    2c30:	             pea cfc6 <gameVersion>
    2c36:	             pea 898b <PutChar+0xd17>
    2c3c:	             pea 45 <_start+0x45>
    2c40:	             pea 47 <_start+0x47>
    2c44:	             move.l 332(sp),-(sp)
    2c48:	             jsr 3848 <openAndVerify>
    2c4e:	             lea 20(sp),sp
    2c52:	             move.l d0,288(sp)
	if (! fp) return FALSE;
    2c56:	         ,-- bne.s 2c5e <initSludge+0x46>
    2c58:	         |   clr.w d0
    2c5a:	,--------|-- bra.w 3386 <initSludge+0x76e>
	if (FGetC (fp)) {
    2c5e:	|        '-> move.l 288(sp),284(sp)
    2c64:	|            move.l d020 <DOSBase>,d0
    2c6a:	|            movea.l d0,a6
    2c6c:	|            move.l 284(sp),d1
    2c70:	|            jsr -306(a6)
    2c74:	|            move.l d0,280(sp)
    2c78:	|            move.l 280(sp),d0
    2c7c:	|  ,-------- beq.w 2e26 <initSludge+0x20e>
		numBIFNames = get2bytes (fp);
    2c80:	|  |         move.l 288(sp),-(sp)
    2c84:	|  |         jsr 4d6 <get2bytes>
    2c8a:	|  |         addq.l #4,sp
    2c8c:	|  |         move.l d0,cfec <numBIFNames>
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
    2c92:	|  |         move.l cfec <numBIFNames>,d0
    2c98:	|  |         move.l d0,276(sp)
    2c9c:	|  |         clr.l 272(sp)
    2ca0:	|  |         move.l d018 <SysBase>,d0
    2ca6:	|  |         movea.l d0,a6
    2ca8:	|  |         move.l 276(sp),d0
    2cac:	|  |         move.l 272(sp),d1
    2cb0:	|  |         jsr -684(a6)
    2cb4:	|  |         move.l d0,268(sp)
    2cb8:	|  |         move.l 268(sp),d0
    2cbc:	|  |         move.l d0,cfa2 <allBIFNames>
		if(allBIFNames == 0) return FALSE;
    2cc2:	|  |         move.l cfa2 <allBIFNames>,d0
    2cc8:	|  |     ,-- bne.s 2cd0 <initSludge+0xb8>
    2cca:	|  |     |   clr.w d0
    2ccc:	+--|-----|-- bra.w 3386 <initSludge+0x76e>
		for (int fn = 0; fn < numBIFNames; fn ++) {
    2cd0:	|  |     '-> clr.l 304(sp)
    2cd4:	|  |     ,-- bra.s 2cfa <initSludge+0xe2>
			allBIFNames[fn] = (char *) readString (fp);
    2cd6:	|  |  ,--|-> move.l cfa2 <allBIFNames>,d1
    2cdc:	|  |  |  |   move.l 304(sp),d0
    2ce0:	|  |  |  |   add.l d0,d0
    2ce2:	|  |  |  |   add.l d0,d0
    2ce4:	|  |  |  |   movea.l d1,a2
    2ce6:	|  |  |  |   adda.l d0,a2
    2ce8:	|  |  |  |   move.l 288(sp),-(sp)
    2cec:	|  |  |  |   jsr 66e <readString>
    2cf2:	|  |  |  |   addq.l #4,sp
    2cf4:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numBIFNames; fn ++) {
    2cf6:	|  |  |  |   addq.l #1,304(sp)
    2cfa:	|  |  |  '-> move.l cfec <numBIFNames>,d0
    2d00:	|  |  |      cmp.l 304(sp),d0
    2d04:	|  |  '----- bgt.s 2cd6 <initSludge+0xbe>
		}
		numUserFunc = get2bytes (fp);
    2d06:	|  |         move.l 288(sp),-(sp)
    2d0a:	|  |         jsr 4d6 <get2bytes>
    2d10:	|  |         addq.l #4,sp
    2d12:	|  |         move.l d0,cff8 <numUserFunc>
		allUserFunc = AllocVec(numUserFunc,MEMF_ANY);
    2d18:	|  |         move.l cff8 <numUserFunc>,d0
    2d1e:	|  |         move.l d0,264(sp)
    2d22:	|  |         clr.l 260(sp)
    2d26:	|  |         move.l d018 <SysBase>,d0
    2d2c:	|  |         movea.l d0,a6
    2d2e:	|  |         move.l 264(sp),d0
    2d32:	|  |         move.l 260(sp),d1
    2d36:	|  |         jsr -684(a6)
    2d3a:	|  |         move.l d0,256(sp)
    2d3e:	|  |         move.l 256(sp),d0
    2d42:	|  |         move.l d0,cfba <allUserFunc>
		if( allUserFunc == 0) return FALSE;
    2d48:	|  |         move.l cfba <allUserFunc>,d0
    2d4e:	|  |     ,-- bne.s 2d56 <initSludge+0x13e>
    2d50:	|  |     |   clr.w d0
    2d52:	+--|-----|-- bra.w 3386 <initSludge+0x76e>

		for (int fn = 0; fn < numUserFunc; fn ++) {
    2d56:	|  |     '-> clr.l 300(sp)
    2d5a:	|  |     ,-- bra.s 2d80 <initSludge+0x168>
			allUserFunc[fn] =   (char *) readString (fp);
    2d5c:	|  |  ,--|-> move.l cfba <allUserFunc>,d1
    2d62:	|  |  |  |   move.l 300(sp),d0
    2d66:	|  |  |  |   add.l d0,d0
    2d68:	|  |  |  |   add.l d0,d0
    2d6a:	|  |  |  |   movea.l d1,a2
    2d6c:	|  |  |  |   adda.l d0,a2
    2d6e:	|  |  |  |   move.l 288(sp),-(sp)
    2d72:	|  |  |  |   jsr 66e <readString>
    2d78:	|  |  |  |   addq.l #4,sp
    2d7a:	|  |  |  |   move.l d0,(a2)
		for (int fn = 0; fn < numUserFunc; fn ++) {
    2d7c:	|  |  |  |   addq.l #1,300(sp)
    2d80:	|  |  |  '-> move.l cff8 <numUserFunc>,d0
    2d86:	|  |  |      cmp.l 300(sp),d0
    2d8a:	|  |  '----- bgt.s 2d5c <initSludge+0x144>
		}
		if (gameVersion >= VERSION(1,3)) {
    2d8c:	|  |         move.l cfc6 <gameVersion>,d0
    2d92:	|  |         cmpi.l #258,d0
    2d98:	|  +-------- ble.w 2e26 <initSludge+0x20e>
			numResourceNames = get2bytes (fp);
    2d9c:	|  |         move.l 288(sp),-(sp)
    2da0:	|  |         jsr 4d6 <get2bytes>
    2da6:	|  |         addq.l #4,sp
    2da8:	|  |         move.l d0,cff4 <numResourceNames>
			allResourceNames = AllocVec(sizeof(char *) * numResourceNames,MEMF_ANY);
    2dae:	|  |         move.l cff4 <numResourceNames>,d0
    2db4:	|  |         add.l d0,d0
    2db6:	|  |         add.l d0,d0
    2db8:	|  |         move.l d0,252(sp)
    2dbc:	|  |         clr.l 248(sp)
    2dc0:	|  |         move.l d018 <SysBase>,d0
    2dc6:	|  |         movea.l d0,a6
    2dc8:	|  |         move.l 252(sp),d0
    2dcc:	|  |         move.l 248(sp),d1
    2dd0:	|  |         jsr -684(a6)
    2dd4:	|  |         move.l d0,244(sp)
    2dd8:	|  |         move.l 244(sp),d0
    2ddc:	|  |         move.l d0,cfb2 <allResourceNames>
			if(allResourceNames == 0) return FALSE;
    2de2:	|  |         move.l cfb2 <allResourceNames>,d0
    2de8:	|  |     ,-- bne.s 2df0 <initSludge+0x1d8>
    2dea:	|  |     |   clr.w d0
    2dec:	+--|-----|-- bra.w 3386 <initSludge+0x76e>

			for (int fn = 0; fn < numResourceNames; fn ++) {
    2df0:	|  |     '-> clr.l 296(sp)
    2df4:	|  |     ,-- bra.s 2e1a <initSludge+0x202>
				allResourceNames[fn] =  (char *) readString (fp);
    2df6:	|  |  ,--|-> move.l cfb2 <allResourceNames>,d1
    2dfc:	|  |  |  |   move.l 296(sp),d0
    2e00:	|  |  |  |   add.l d0,d0
    2e02:	|  |  |  |   add.l d0,d0
    2e04:	|  |  |  |   movea.l d1,a2
    2e06:	|  |  |  |   adda.l d0,a2
    2e08:	|  |  |  |   move.l 288(sp),-(sp)
    2e0c:	|  |  |  |   jsr 66e <readString>
    2e12:	|  |  |  |   addq.l #4,sp
    2e14:	|  |  |  |   move.l d0,(a2)
			for (int fn = 0; fn < numResourceNames; fn ++) {
    2e16:	|  |  |  |   addq.l #1,296(sp)
    2e1a:	|  |  |  '-> move.l cff4 <numResourceNames>,d0
    2e20:	|  |  |      cmp.l 296(sp),d0
    2e24:	|  |  '----- bgt.s 2df6 <initSludge+0x1de>
			}
		}
	}

	input.mouseX = 129;
    2e26:	|  '-------> move.l #129,cfd8 <input+0xa>
	input.mouseY = 100;
    2e30:	|            moveq #100,d0
    2e32:	|            move.l d0,cfdc <input+0xe>
	winWidth = get2bytes (fp);
    2e38:	|            move.l 288(sp),-(sp)
    2e3c:	|            jsr 4d6 <get2bytes>
    2e42:	|            addq.l #4,sp
    2e44:	|            move.l d0,cf86 <winWidth>
	winHeight = get2bytes (fp);
    2e4a:	|            move.l 288(sp),-(sp)
    2e4e:	|            jsr 4d6 <get2bytes>
    2e54:	|            addq.l #4,sp
    2e56:	|            move.l d0,cf8a <winHeight>
	specialSettings = FGetC (fp);
    2e5c:	|            move.l 288(sp),240(sp)
    2e62:	|            move.l d020 <DOSBase>,d0
    2e68:	|            movea.l d0,a6
    2e6a:	|            move.l 240(sp),d1
    2e6e:	|            jsr -306(a6)
    2e72:	|            move.l d0,236(sp)
    2e76:	|            move.l 236(sp),d0
    2e7a:	|            move.l d0,cffc <specialSettings>

	desiredfps = 1000/FGetC (fp);
    2e80:	|            move.l 288(sp),232(sp)
    2e86:	|            move.l d020 <DOSBase>,d0
    2e8c:	|            movea.l d0,a6
    2e8e:	|            move.l 232(sp),d1
    2e92:	|            jsr -306(a6)
    2e96:	|            move.l d0,228(sp)
    2e9a:	|            move.l 228(sp),d0
    2e9e:	|            move.l d0,-(sp)
    2ea0:	|            pea 3e8 <encodeFilename+0x2d0>
    2ea4:	|            jsr 7c0a <__divsi3>
    2eaa:	|            addq.l #8,sp
    2eac:	|            move.l d0,cf3c <desiredfps>

	readString(fp); //Need to keep reading to stay on track. But the comented line below looks wrong.
    2eb2:	|            move.l 288(sp),-(sp)
    2eb6:	|            jsr 66e <readString>
    2ebc:	|            addq.l #4,sp
	//FreeVec(readString (fp));

	ULONG blocks_read = FRead( fp, &fileTime, sizeof (FILETIME), 1 ); 
    2ebe:	|            move.l 288(sp),224(sp)
    2ec4:	|            move.l #53182,220(sp)
    2ecc:	|            moveq #8,d1
    2ece:	|            move.l d1,216(sp)
    2ed2:	|            moveq #1,d0
    2ed4:	|            move.l d0,212(sp)
    2ed8:	|            move.l d020 <DOSBase>,d0
    2ede:	|            movea.l d0,a6
    2ee0:	|            move.l 224(sp),d1
    2ee4:	|            move.l 220(sp),d2
    2ee8:	|            move.l 216(sp),d3
    2eec:	|            move.l 212(sp),d4
    2ef0:	|            jsr -324(a6)
    2ef4:	|            move.l d0,208(sp)
    2ef8:	|            move.l 208(sp),d0
    2efc:	|            move.l d0,204(sp)
	if (blocks_read != 1) {
    2f00:	|            moveq #1,d1
    2f02:	|            cmp.l 204(sp),d1
    2f06:	|        ,-- beq.s 2f16 <initSludge+0x2fe>
		KPrintF("Reading error in initSludge.\n");
    2f08:	|        |   pea 89c4 <PutChar+0xd50>
    2f0e:	|        |   jsr 725e <KPrintF>
    2f14:	|        |   addq.l #4,sp
	}

	char * dataFol = (gameVersion >= VERSION(1,3)) ? readString(fp) : joinStrings ("", "");
    2f16:	|        '-> move.l cfc6 <gameVersion>,d0
    2f1c:	|            cmpi.l #258,d0
    2f22:	|        ,-- ble.s 2f32 <initSludge+0x31a>
    2f24:	|        |   move.l 288(sp),-(sp)
    2f28:	|        |   jsr 66e <readString>
    2f2e:	|        |   addq.l #4,sp
    2f30:	|     ,--|-- bra.s 2f46 <initSludge+0x32e>
    2f32:	|     |  '-> pea 89e2 <PutChar+0xd6e>
    2f38:	|     |      pea 89e2 <PutChar+0xd6e>
    2f3e:	|     |      jsr 6d20 <joinStrings>
    2f44:	|     |      addq.l #8,sp
    2f46:	|     '----> move.l d0,200(sp)

	gameSettings.numLanguages = (gameVersion >= VERSION(1,3)) ? (FGetC (fp)) : 0;
    2f4a:	|            move.l cfc6 <gameVersion>,d0
    2f50:	|            cmpi.l #258,d0
    2f56:	|     ,----- ble.s 2f78 <initSludge+0x360>
    2f58:	|     |      move.l 288(sp),196(sp)
    2f5e:	|     |      move.l d020 <DOSBase>,d0
    2f64:	|     |      movea.l d0,a6
    2f66:	|     |      move.l 196(sp),d1
    2f6a:	|     |      jsr -306(a6)
    2f6e:	|     |      move.l d0,192(sp)
    2f72:	|     |      move.l 192(sp),d0
    2f76:	|     |  ,-- bra.s 2f7a <initSludge+0x362>
    2f78:	|     '--|-> moveq #0,d0
    2f7a:	|        '-> move.l d0,d0ca <gameSettings+0x4>
	makeLanguageTable (fp);
    2f80:	|            move.l 288(sp),-(sp)
    2f84:	|            jsr 66c0 <makeLanguageTable>
    2f8a:	|            addq.l #4,sp

	if (gameVersion >= VERSION(1,6))
    2f8c:	|            move.l cfc6 <gameVersion>,d0
    2f92:	|            cmpi.l #261,d0
    2f98:	|        ,-- ble.s 2fe6 <initSludge+0x3ce>
	{
		FGetC(fp);
    2f9a:	|        |   move.l 288(sp),188(sp)
    2fa0:	|        |   move.l d020 <DOSBase>,d0
    2fa6:	|        |   movea.l d0,a6
    2fa8:	|        |   move.l 188(sp),d1
    2fac:	|        |   jsr -306(a6)
    2fb0:	|        |   move.l d0,184(sp)
		// aaLoad
		FGetC (fp);
    2fb4:	|        |   move.l 288(sp),180(sp)
    2fba:	|        |   move.l d020 <DOSBase>,d0
    2fc0:	|        |   movea.l d0,a6
    2fc2:	|        |   move.l 180(sp),d1
    2fc6:	|        |   jsr -306(a6)
    2fca:	|        |   move.l d0,176(sp)
		getFloat (fp);
    2fce:	|        |   move.l 288(sp),-(sp)
    2fd2:	|        |   jsr 5f2 <getFloat>
    2fd8:	|        |   addq.l #4,sp
		getFloat (fp);
    2fda:	|        |   move.l 288(sp),-(sp)
    2fde:	|        |   jsr 5f2 <getFloat>
    2fe4:	|        |   addq.l #4,sp
	}

	char * checker = readString (fp);
    2fe6:	|        '-> move.l 288(sp),-(sp)
    2fea:	|            jsr 66e <readString>
    2ff0:	|            addq.l #4,sp
    2ff2:	|            move.l d0,172(sp)

	if (strcmp (checker, "okSoFar")) {
    2ff6:	|            pea 89e3 <PutChar+0xd6f>
    2ffc:	|            move.l 176(sp),-(sp)
    3000:	|            jsr 6ca0 <strcmp>
    3006:	|            addq.l #8,sp
    3008:	|            tst.l d0
    300a:	|        ,-- beq.s 3012 <initSludge+0x3fa>
		return FALSE;
    300c:	|        |   clr.w d0
    300e:	+--------|-- bra.w 3386 <initSludge+0x76e>
	}
	FreeVec( checker);
    3012:	|        '-> move.l 172(sp),168(sp)
    3018:	|            move.l d018 <SysBase>,d0
    301e:	|            movea.l d0,a6
    3020:	|            movea.l 168(sp),a1
    3024:	|            jsr -690(a6)
	checker = NULL;
    3028:	|            clr.l 172(sp)

    unsigned char customIconLogo = FGetC (fp);
    302c:	|            move.l 288(sp),164(sp)
    3032:	|            move.l d020 <DOSBase>,d0
    3038:	|            movea.l d0,a6
    303a:	|            move.l 164(sp),d1
    303e:	|            jsr -306(a6)
    3042:	|            move.l d0,160(sp)
    3046:	|            move.l 160(sp),d0
    304a:	|            move.b d0,159(sp)

	if (customIconLogo & 1) {
    304e:	|            moveq #0,d0
    3050:	|            move.b 159(sp),d0
    3054:	|            moveq #1,d1
    3056:	|            and.l d1,d0
    3058:	|        ,-- beq.s 30b0 <initSludge+0x498>
		// There is an icon - read it!
		Write(Output(), (APTR)"initsludge:Game Icon not supported on this plattform.\n", 54);
    305a:	|        |   move.l d020 <DOSBase>,d0
    3060:	|        |   movea.l d0,a6
    3062:	|        |   jsr -60(a6)
    3066:	|        |   move.l d0,38(sp)
    306a:	|        |   move.l 38(sp),d0
    306e:	|        |   move.l d0,34(sp)
    3072:	|        |   move.l #35307,30(sp)
    307a:	|        |   moveq #54,d0
    307c:	|        |   move.l d0,26(sp)
    3080:	|        |   move.l d020 <DOSBase>,d0
    3086:	|        |   movea.l d0,a6
    3088:	|        |   move.l 34(sp),d1
    308c:	|        |   move.l 30(sp),d2
    3090:	|        |   move.l 26(sp),d3
    3094:	|        |   jsr -48(a6)
    3098:	|        |   move.l d0,22(sp)
		KPrintF("initsludge: Game Icon not supported on this plattform.\n");
    309c:	|        |   pea 8a22 <PutChar+0xdae>
    30a2:	|        |   jsr 725e <KPrintF>
    30a8:	|        |   addq.l #4,sp
		return FALSE;
    30aa:	|        |   clr.w d0
    30ac:	+--------|-- bra.w 3386 <initSludge+0x76e>
	}

	numGlobals = get2bytes (fp);
    30b0:	|        '-> move.l 288(sp),-(sp)
    30b4:	|            jsr 4d6 <get2bytes>
    30ba:	|            addq.l #4,sp
    30bc:	|            move.l d0,cff0 <numGlobals>

	globalVars = AllocVec( sizeof(struct variable) * numGlobals,MEMF_ANY);
    30c2:	|            move.l cff0 <numGlobals>,d0
    30c8:	|            lsl.l #3,d0
    30ca:	|            move.l d0,154(sp)
    30ce:	|            clr.l 150(sp)
    30d2:	|            move.l d018 <SysBase>,d0
    30d8:	|            movea.l d0,a6
    30da:	|            move.l 154(sp),d0
    30de:	|            move.l 150(sp),d1
    30e2:	|            jsr -684(a6)
    30e6:	|            move.l d0,146(sp)
    30ea:	|            move.l 146(sp),d0
    30ee:	|            move.l d0,cfca <globalVars>
	if(globalVars == 0 && numGlobals > 0) {
    30f4:	|            move.l cfca <globalVars>,d0
    30fa:	|        ,-- bne.s 3118 <initSludge+0x500>
    30fc:	|        |   move.l cff0 <numGlobals>,d0
    3102:	|        +-- ble.s 3118 <initSludge+0x500>
		KPrintF("initsludge: Cannot allocate memory for globalvars\n");
    3104:	|        |   pea 8a5a <PutChar+0xde6>
    310a:	|        |   jsr 725e <KPrintF>
    3110:	|        |   addq.l #4,sp
		return FALSE;
    3112:	|        |   clr.w d0
    3114:	+--------|-- bra.w 3386 <initSludge+0x76e>
	}		 
	for (a = 0; a < numGlobals; a ++) initVarNew (globalVars[a]);
    3118:	|        '-> clr.l 308(sp)
    311c:	|        ,-- bra.s 3134 <initSludge+0x51c>
    311e:	|     ,--|-> move.l cfca <globalVars>,d1
    3124:	|     |  |   move.l 308(sp),d0
    3128:	|     |  |   lsl.l #3,d0
    312a:	|     |  |   movea.l d1,a0
    312c:	|     |  |   adda.l d0,a0
    312e:	|     |  |   clr.l (a0)
    3130:	|     |  |   addq.l #1,308(sp)
    3134:	|     |  '-> move.l cff0 <numGlobals>,d0
    313a:	|     |      cmp.l 308(sp),d0
    313e:	|     '----- bgt.s 311e <initSludge+0x506>

	setFileIndices (fp, gameSettings.numLanguages, 0);
    3140:	|            move.l d0ca <gameSettings+0x4>,d0
    3146:	|            clr.l -(sp)
    3148:	|            move.l d0,-(sp)
    314a:	|            move.l 296(sp),-(sp)
    314e:	|            jsr 3f42 <setFileIndices>
    3154:	|            lea 12(sp),sp

	char * gameNameOrig = getNumberedString(1);	
    3158:	|            pea 1 <_start+0x1>
    315c:	|            jsr 3d84 <getNumberedString>
    3162:	|            addq.l #4,sp
    3164:	|            move.l d0,142(sp)
	char * gameName = encodeFilename (gameNameOrig);
    3168:	|            move.l 142(sp),-(sp)
    316c:	|            jsr 118 <encodeFilename>
    3172:	|            addq.l #4,sp
    3174:	|            move.l d0,138(sp)

	FreeVec(gameNameOrig);
    3178:	|            move.l 142(sp),134(sp)
    317e:	|            move.l d018 <SysBase>,d0
    3184:	|            movea.l d0,a6
    3186:	|            movea.l 134(sp),a1
    318a:	|            jsr -690(a6)

	BPTR lock = CreateDir( gameName );
    318e:	|            move.l 138(sp),130(sp)
    3194:	|            move.l d020 <DOSBase>,d0
    319a:	|            movea.l d0,a6
    319c:	|            move.l 130(sp),d1
    31a0:	|            jsr -120(a6)
    31a4:	|            move.l d0,126(sp)
    31a8:	|            move.l 126(sp),d0
    31ac:	|            move.l d0,292(sp)
	if(lock == 0) {
    31b0:	|        ,-- bne.s 31de <initSludge+0x5c6>
		//Directory does already exist
		lock = Lock(gameName, ACCESS_READ);
    31b2:	|        |   move.l 138(sp),122(sp)
    31b8:	|        |   moveq #-2,d1
    31ba:	|        |   move.l d1,118(sp)
    31be:	|        |   move.l d020 <DOSBase>,d0
    31c4:	|        |   movea.l d0,a6
    31c6:	|        |   move.l 122(sp),d1
    31ca:	|        |   move.l 118(sp),d2
    31ce:	|        |   jsr -84(a6)
    31d2:	|        |   move.l d0,114(sp)
    31d6:	|        |   move.l 114(sp),d0
    31da:	|        |   move.l d0,292(sp)
	}

	if (!CurrentDir(lock)) {
    31de:	|        '-> move.l 292(sp),110(sp)
    31e4:	|            move.l d020 <DOSBase>,d0
    31ea:	|            movea.l d0,a6
    31ec:	|            move.l 110(sp),d1
    31f0:	|            jsr -126(a6)
    31f4:	|            move.l d0,106(sp)
    31f8:	|            move.l 106(sp),d0
    31fc:	|        ,-- bne.s 3258 <initSludge+0x640>
		KPrintF("initsludge: Failed changing to directory %s\n", gameName);
    31fe:	|        |   move.l 138(sp),-(sp)
    3202:	|        |   pea 8a8d <PutChar+0xe19>
    3208:	|        |   jsr 725e <KPrintF>
    320e:	|        |   addq.l #8,sp
		Write(Output(), (APTR)"initsludge:Failed changing to directory\n", 40);
    3210:	|        |   move.l d020 <DOSBase>,d0
    3216:	|        |   movea.l d0,a6
    3218:	|        |   jsr -60(a6)
    321c:	|        |   move.l d0,58(sp)
    3220:	|        |   move.l 58(sp),d0
    3224:	|        |   move.l d0,54(sp)
    3228:	|        |   move.l #35514,50(sp)
    3230:	|        |   moveq #40,d0
    3232:	|        |   move.l d0,46(sp)
    3236:	|        |   move.l d020 <DOSBase>,d0
    323c:	|        |   movea.l d0,a6
    323e:	|        |   move.l 54(sp),d1
    3242:	|        |   move.l 50(sp),d2
    3246:	|        |   move.l 46(sp),d3
    324a:	|        |   jsr -48(a6)
    324e:	|        |   move.l d0,42(sp)
		return FALSE;
    3252:	|        |   clr.w d0
    3254:	+--------|-- bra.w 3386 <initSludge+0x76e>
	}

	FreeVec(gameName);
    3258:	|        '-> move.l 138(sp),102(sp)
    325e:	|            move.l d018 <SysBase>,d0
    3264:	|            movea.l d0,a6
    3266:	|            movea.l 102(sp),a1
    326a:	|            jsr -690(a6)

	readIniFile (filename);
    326e:	|            move.l 316(sp),-(sp)
    3272:	|            jsr 67f4 <readIniFile>
    3278:	|            addq.l #4,sp

	// Now set file indices properly to the chosen language.
	languageNum = getLanguageForFileB ();
    327a:	|            jsr 65c6 <getLanguageForFileB>
    3280:	|            move.l d0,cf32 <languageNum>
	if (languageNum < 0) KPrintF("Can't find the translation data specified!");
    3286:	|            move.l cf32 <languageNum>,d0
    328c:	|        ,-- bpl.s 329c <initSludge+0x684>
    328e:	|        |   pea 8ae3 <PutChar+0xe6f>
    3294:	|        |   jsr 725e <KPrintF>
    329a:	|        |   addq.l #4,sp
	setFileIndices (NULL, gameSettings.numLanguages, languageNum);
    329c:	|        '-> move.l cf32 <languageNum>,d0
    32a2:	|            move.l d0,d1
    32a4:	|            move.l d0ca <gameSettings+0x4>,d0
    32aa:	|            move.l d1,-(sp)
    32ac:	|            move.l d0,-(sp)
    32ae:	|            clr.l -(sp)
    32b0:	|            jsr 3f42 <setFileIndices>
    32b6:	|            lea 12(sp),sp

	if (dataFol[0]) {
    32ba:	|            movea.l 200(sp),a0
    32be:	|            move.b (a0),d0
    32c0:	|     ,----- beq.w 336a <initSludge+0x752>
		char *dataFolder = encodeFilename(dataFol);
    32c4:	|     |      move.l 200(sp),-(sp)
    32c8:	|     |      jsr 118 <encodeFilename>
    32ce:	|     |      addq.l #4,sp
    32d0:	|     |      move.l d0,98(sp)
		lock = CreateDir( dataFolder );
    32d4:	|     |      move.l 98(sp),94(sp)
    32da:	|     |      move.l d020 <DOSBase>,d0
    32e0:	|     |      movea.l d0,a6
    32e2:	|     |      move.l 94(sp),d1
    32e6:	|     |      jsr -120(a6)
    32ea:	|     |      move.l d0,90(sp)
    32ee:	|     |      move.l 90(sp),d0
    32f2:	|     |      move.l d0,292(sp)
		if(lock == 0) {
    32f6:	|     |  ,-- bne.s 3324 <initSludge+0x70c>
			//Directory does already exist
			lock = Lock(dataFolder, ACCESS_READ);		
    32f8:	|     |  |   move.l 98(sp),86(sp)
    32fe:	|     |  |   moveq #-2,d1
    3300:	|     |  |   move.l d1,82(sp)
    3304:	|     |  |   move.l d020 <DOSBase>,d0
    330a:	|     |  |   movea.l d0,a6
    330c:	|     |  |   move.l 86(sp),d1
    3310:	|     |  |   move.l 82(sp),d2
    3314:	|     |  |   jsr -84(a6)
    3318:	|     |  |   move.l d0,78(sp)
    331c:	|     |  |   move.l 78(sp),d0
    3320:	|     |  |   move.l d0,292(sp)
		}


		if (!CurrentDir(lock)) {
    3324:	|     |  '-> move.l 292(sp),74(sp)
    332a:	|     |      move.l d020 <DOSBase>,d0
    3330:	|     |      movea.l d0,a6
    3332:	|     |      move.l 74(sp),d1
    3336:	|     |      jsr -126(a6)
    333a:	|     |      move.l d0,70(sp)
    333e:	|     |      move.l 70(sp),d0
    3342:	|     |  ,-- bne.s 3354 <initSludge+0x73c>
			(Output(), (APTR)"initsludge:This game's data folder is inaccessible!\n", 52);
    3344:	|     |  |   move.l d020 <DOSBase>,d0
    334a:	|     |  |   movea.l d0,a6
    334c:	|     |  |   jsr -60(a6)
    3350:	|     |  |   move.l d0,66(sp)
		}
		FreeVec(dataFolder);
    3354:	|     |  '-> move.l 98(sp),62(sp)
    335a:	|     |      move.l d018 <SysBase>,d0
    3360:	|     |      movea.l d0,a6
    3362:	|     |      movea.l 62(sp),a1
    3366:	|     |      jsr -690(a6)
	}

 	positionStatus (10, winHeight - 15);
    336a:	|     '----> movea.l cf8a <winHeight>,a0
    3370:	|            lea -15(a0),a0
    3374:	|            move.l a0,d0
    3376:	|            move.l d0,-(sp)
    3378:	|            pea a <_start+0xa>
    337c:	|            jsr 4860 <positionStatus>
    3382:	|            addq.l #8,sp

	return TRUE;
    3384:	|            moveq #1,d0
}
    3386:	'----------> movem.l (sp)+,d2-d4/a2/a6
    338a:	             lea 292(sp),sp
    338e:	             rts

00003390 <loadFunctionCode>:
	}

	killAllSpeech ();
}

struct loadedFunction *loadFunctionCode (unsigned int originalNumber) {
    3390:	                         lea -104(sp),sp
    3394:	                         move.l a6,-(sp)
	unsigned int numLines, numLinesRead;
	struct loadedFunction * newFunc = NULL;
    3396:	                         clr.l 100(sp)
	int a;

#ifndef DISABLEFUNCTIONCACHE
	struct cachedFunction * current = allCachedFunctions;
    339a:	                         move.l cfa6 <allCachedFunctions>,92(sp)
	while( current) {
    33a2:	               ,-------- bra.s 33ea <loadFunctionCode+0x5a>
		if (current->theFunction->originalNumber == originalNumber)
    33a4:	            ,--|-------> movea.l 92(sp),a0
    33a8:	            |  |         movea.l 4(a0),a0
    33ac:	            |  |         move.l (a0),d0
    33ae:	            |  |         cmp.l 112(sp),d0
    33b2:	            |  |  ,----- bne.s 33e0 <loadFunctionCode+0x50>
		{
			if( current->theFunction->unloaded == 1)
    33b4:	            |  |  |      movea.l 92(sp),a0
    33b8:	            |  |  |      movea.l 4(a0),a0
    33bc:	            |  |  |      move.l 58(a0),d0
    33c0:	            |  |  |      moveq #1,d1
    33c2:	            |  |  |      cmp.l d0,d1
    33c4:	            |  |  +----- bne.s 33e0 <loadFunctionCode+0x50>
			{ 
				newFunc = current->theFunction;	
    33c6:	            |  |  |      movea.l 92(sp),a0
    33ca:	            |  |  |      move.l 4(a0),100(sp)
				KPrintF("loadFunctionCode: Found in Cache\n");
    33d0:	            |  |  |      pea 8b0e <PutChar+0xe9a>
    33d6:	            |  |  |      jsr 725e <KPrintF>
    33dc:	            |  |  |      addq.l #4,sp
				break;
    33de:	            |  |  |  ,-- bra.s 33f0 <loadFunctionCode+0x60>
			}									
		}
		current = current->next;
    33e0:	            |  |  '--|-> movea.l 92(sp),a0
    33e4:	            |  |     |   move.l 8(a0),92(sp)
	while( current) {
    33ea:	            |  '-----|-> tst.l 92(sp)
    33ee:	            '--------|-- bne.s 33a4 <loadFunctionCode+0x14>
	}			

	if( !newFunc)
    33f0:	                     '-> tst.l 100(sp)
    33f4:	               ,-------- bne.w 364c <loadFunctionCode+0x2bc>
	{		
		KPrintF("loadFunctionCode: Function not in cache. Loading new function\n");
    33f8:	               |         pea 8b30 <PutChar+0xebc>
    33fe:	               |         jsr 725e <KPrintF>
    3404:	               |         addq.l #4,sp
		numCachedFunctions++;
    3406:	               |         move.l cfae <numCachedFunctions>,d0
    340c:	               |         addq.l #1,d0
    340e:	               |         move.l d0,cfae <numCachedFunctions>
#endif		
		newFunc = AllocVec(sizeof(struct loadedFunction),MEMF_ANY);
    3414:	               |         moveq #62,d0
    3416:	               |         move.l d0,84(sp)
    341a:	               |         clr.l 80(sp)
    341e:	               |         move.l d018 <SysBase>,d0
    3424:	               |         movea.l d0,a6
    3426:	               |         move.l 84(sp),d0
    342a:	               |         move.l 80(sp),d1
    342e:	               |         jsr -684(a6)
    3432:	               |         move.l d0,76(sp)
    3436:	               |         move.l 76(sp),d0
    343a:	               |         move.l d0,100(sp)
	
		if(!newFunc) {
    343e:	               |     ,-- bne.s 3454 <loadFunctionCode+0xc4>
			KPrintF("loadFunctionCode: Cannot allocate memory");
    3440:	               |     |   pea 8b6f <PutChar+0xefb>
    3446:	               |     |   jsr 725e <KPrintF>
    344c:	               |     |   addq.l #4,sp
			return 0;
    344e:	               |     |   moveq #0,d0
    3450:	,--------------|-----|-- bra.w 3840 <loadFunctionCode+0x4b0>
		}

		newFunc -> originalNumber = originalNumber;
    3454:	|              |     '-> move.l 112(sp),d0
    3458:	|              |         movea.l 100(sp),a0
    345c:	|              |         move.l d0,(a0)

		if (! openSubSlice (originalNumber)) return FALSE;
    345e:	|              |         move.l 112(sp),d0
    3462:	|              |         move.l d0,-(sp)
    3464:	|              |         jsr 3e82 <openSubSlice>
    346a:	|              |         addq.l #4,sp
    346c:	|              |         tst.w d0
    346e:	|              |     ,-- bne.s 3476 <loadFunctionCode+0xe6>
    3470:	|              |     |   moveq #0,d0
    3472:	+--------------|-----|-- bra.w 3840 <loadFunctionCode+0x4b0>
		

		newFunc-> unfreezable	= FGetC (bigDataFile);
    3476:	|              |     '-> move.l d000 <bigDataFile>,72(sp)
    347e:	|              |         move.l d020 <DOSBase>,d0
    3484:	|              |         movea.l d0,a6
    3486:	|              |         move.l 72(sp),d1
    348a:	|              |         jsr -306(a6)
    348e:	|              |         move.l d0,68(sp)
    3492:	|              |         move.l 68(sp),d0
    3496:	|              |         move.l d0,d0
    3498:	|              |         movea.l 100(sp),a0
    349c:	|              |         move.w d0,52(a0)
		numLines				= get2bytes (bigDataFile);
    34a0:	|              |         move.l d000 <bigDataFile>,d0
    34a6:	|              |         move.l d0,-(sp)
    34a8:	|              |         jsr 4d6 <get2bytes>
    34ae:	|              |         addq.l #4,sp
    34b0:	|              |         move.l d0,64(sp)
		newFunc -> numArgs		= get2bytes (bigDataFile);
    34b4:	|              |         move.l d000 <bigDataFile>,d0
    34ba:	|              |         move.l d0,-(sp)
    34bc:	|              |         jsr 4d6 <get2bytes>
    34c2:	|              |         addq.l #4,sp
    34c4:	|              |         movea.l 100(sp),a0
    34c8:	|              |         move.l d0,16(a0)
		newFunc -> numLocals	= get2bytes (bigDataFile);	
    34cc:	|              |         move.l d000 <bigDataFile>,d0
    34d2:	|              |         move.l d0,-(sp)
    34d4:	|              |         jsr 4d6 <get2bytes>
    34da:	|              |         addq.l #4,sp
    34dc:	|              |         movea.l 100(sp),a0
    34e0:	|              |         move.l d0,8(a0)

		newFunc -> compiledLines = AllocVec( sizeof(struct lineOfCode) * numLines,MEMF_ANY);
    34e4:	|              |         move.l 64(sp),d0
    34e8:	|              |         lsl.l #3,d0
    34ea:	|              |         move.l d0,60(sp)
    34ee:	|              |         clr.l 56(sp)
    34f2:	|              |         move.l d018 <SysBase>,d0
    34f8:	|              |         movea.l d0,a6
    34fa:	|              |         move.l 60(sp),d0
    34fe:	|              |         move.l 56(sp),d1
    3502:	|              |         jsr -684(a6)
    3506:	|              |         move.l d0,52(sp)
    350a:	|              |         move.l 52(sp),d0
    350e:	|              |         movea.l 100(sp),a0
    3512:	|              |         move.l d0,4(a0)
		if (! newFunc -> compiledLines) {
    3516:	|              |         movea.l 100(sp),a0
    351a:	|              |         move.l 4(a0),d0
    351e:	|              |     ,-- bne.s 3534 <loadFunctionCode+0x1a4>
			KPrintF("loadFunctionCode: cannot allocate memory");
    3520:	|              |     |   pea 8b98 <PutChar+0xf24>
    3526:	|              |     |   jsr 725e <KPrintF>
    352c:	|              |     |   addq.l #4,sp
			return FALSE;
    352e:	|              |     |   moveq #0,d0
    3530:	+--------------|-----|-- bra.w 3840 <loadFunctionCode+0x4b0>
		}
		
		for (numLinesRead = 0; numLinesRead < numLines; numLinesRead ++) {
    3534:	|              |     '-> clr.l 104(sp)
    3538:	|              |     ,-- bra.s 359a <loadFunctionCode+0x20a>
			newFunc -> compiledLines[numLinesRead].theCommand = (enum sludgeCommand) FGetC(bigDataFile);
    353a:	|              |  ,--|-> move.l d000 <bigDataFile>,32(sp)
    3542:	|              |  |  |   move.l d020 <DOSBase>,d0
    3548:	|              |  |  |   movea.l d0,a6
    354a:	|              |  |  |   move.l 32(sp),d1
    354e:	|              |  |  |   jsr -306(a6)
    3552:	|              |  |  |   move.l d0,28(sp)
    3556:	|              |  |  |   move.l 28(sp),d1
    355a:	|              |  |  |   movea.l 100(sp),a0
    355e:	|              |  |  |   movea.l 4(a0),a0
    3562:	|              |  |  |   move.l 104(sp),d0
    3566:	|              |  |  |   lsl.l #3,d0
    3568:	|              |  |  |   adda.l d0,a0
    356a:	|              |  |  |   move.l d1,d0
    356c:	|              |  |  |   move.l d0,(a0)
			newFunc -> compiledLines[numLinesRead].param = get2bytes (bigDataFile);
    356e:	|              |  |  |   move.l d000 <bigDataFile>,d0
    3574:	|              |  |  |   move.l d0,-(sp)
    3576:	|              |  |  |   jsr 4d6 <get2bytes>
    357c:	|              |  |  |   addq.l #4,sp
    357e:	|              |  |  |   move.l d0,d1
    3580:	|              |  |  |   movea.l 100(sp),a0
    3584:	|              |  |  |   movea.l 4(a0),a0
    3588:	|              |  |  |   move.l 104(sp),d0
    358c:	|              |  |  |   lsl.l #3,d0
    358e:	|              |  |  |   adda.l d0,a0
    3590:	|              |  |  |   move.l d1,d0
    3592:	|              |  |  |   move.l d0,4(a0)
		for (numLinesRead = 0; numLinesRead < numLines; numLinesRead ++) {
    3596:	|              |  |  |   addq.l #1,104(sp)
    359a:	|              |  |  '-> move.l 104(sp),d1
    359e:	|              |  |      cmp.l 64(sp),d1
    35a2:	|              |  '----- bcs.s 353a <loadFunctionCode+0x1aa>
		}
		finishAccess ();
    35a4:	|              |         jsr 3d7a <finishAccess>

#ifndef DISABLEFUNCTIONCACHE		
		struct cachedFunction  *next = allCachedFunctions;
    35aa:	|              |         move.l cfa6 <allCachedFunctions>,48(sp)
		allCachedFunctions = AllocVec(sizeof(struct cachedFunction),MEMF_ANY);
    35b2:	|              |         moveq #16,d0
    35b4:	|              |         move.l d0,44(sp)
    35b8:	|              |         clr.l 40(sp)
    35bc:	|              |         move.l d018 <SysBase>,d0
    35c2:	|              |         movea.l d0,a6
    35c4:	|              |         move.l 44(sp),d0
    35c8:	|              |         move.l 40(sp),d1
    35cc:	|              |         jsr -684(a6)
    35d0:	|              |         move.l d0,36(sp)
    35d4:	|              |         move.l 36(sp),d0
    35d8:	|              |         move.l d0,cfa6 <allCachedFunctions>
		allCachedFunctions -> prev = NULL;
    35de:	|              |         movea.l cfa6 <allCachedFunctions>,a0
    35e4:	|              |         clr.l 12(a0)
		if (! allCachedFunctions) {
    35e8:	|              |         move.l cfa6 <allCachedFunctions>,d0
    35ee:	|              |     ,-- bne.s 3604 <loadFunctionCode+0x274>
			KPrintF("loadFunctionCode: cannot allocate memory for cached function");
    35f0:	|              |     |   pea 8bc1 <PutChar+0xf4d>
    35f6:	|              |     |   jsr 725e <KPrintF>
    35fc:	|              |     |   addq.l #4,sp
			return NULL;
    35fe:	|              |     |   moveq #0,d0
    3600:	+--------------|-----|-- bra.w 3840 <loadFunctionCode+0x4b0>
		}
		if( !next) {
    3604:	|              |     '-> tst.l 48(sp)
    3608:	|              |     ,-- bne.s 3616 <loadFunctionCode+0x286>
			lastCachedFunction = allCachedFunctions;
    360a:	|              |     |   move.l cfa6 <allCachedFunctions>,d0
    3610:	|              |     |   move.l d0,cfaa <lastCachedFunction>
		} 	

		if(next) next->prev = allCachedFunctions;
    3616:	|              |     '-> tst.l 48(sp)
    361a:	|              |     ,-- beq.s 362a <loadFunctionCode+0x29a>
    361c:	|              |     |   move.l cfa6 <allCachedFunctions>,d0
    3622:	|              |     |   movea.l 48(sp),a0
    3626:	|              |     |   move.l d0,12(a0)
		
		allCachedFunctions->next = next;
    362a:	|              |     '-> movea.l cfa6 <allCachedFunctions>,a0
    3630:	|              |         move.l 48(sp),8(a0)
		allCachedFunctions->theFunction = newFunc;
    3636:	|              |         movea.l cfa6 <allCachedFunctions>,a0
    363c:	|              |         move.l 100(sp),4(a0)
		allCachedFunctions->funcNum = originalNumber;
    3642:	|              |         movea.l cfa6 <allCachedFunctions>,a0
    3648:	|              |         move.l 112(sp),(a0)

	}	

	newFunc -> unloaded = 0;	
    364c:	|              '-------> movea.l 100(sp),a0
    3650:	|                        clr.l 58(a0)
#endif
	// Now we need to reserve memory for the local variables
	if(newFunc->numLocals > 0) {
    3654:	|                        movea.l 100(sp),a0
    3658:	|                        move.l 8(a0),d0
    365c:	|              ,-------- ble.w 36e2 <loadFunctionCode+0x352>
		newFunc -> localVars = AllocVec( sizeof(struct variable) * newFunc->numLocals,MEMF_ANY);
    3660:	|              |         movea.l 100(sp),a0
    3664:	|              |         move.l 8(a0),d0
    3668:	|              |         lsl.l #3,d0
    366a:	|              |         move.l d0,24(sp)
    366e:	|              |         clr.l 20(sp)
    3672:	|              |         move.l d018 <SysBase>,d0
    3678:	|              |         movea.l d0,a6
    367a:	|              |         move.l 24(sp),d0
    367e:	|              |         move.l 20(sp),d1
    3682:	|              |         jsr -684(a6)
    3686:	|              |         move.l d0,16(sp)
    368a:	|              |         move.l 16(sp),d0
    368e:	|              |         movea.l 100(sp),a0
    3692:	|              |         move.l d0,20(a0)
		if (!newFunc -> localVars) {
    3696:	|              |         movea.l 100(sp),a0
    369a:	|              |         move.l 20(a0),d0
    369e:	|              |     ,-- bne.s 36b4 <loadFunctionCode+0x324>
			KPrintF("loadFunctionCode: cannot allocate memory");
    36a0:	|              |     |   pea 8b98 <PutChar+0xf24>
    36a6:	|              |     |   jsr 725e <KPrintF>
    36ac:	|              |     |   addq.l #4,sp
			return FALSE;
    36ae:	|              |     |   moveq #0,d0
    36b0:	+--------------|-----|-- bra.w 3840 <loadFunctionCode+0x4b0>
		}

		for (a = 0; a < newFunc -> numLocals; a ++) {
    36b4:	|              |     '-> clr.l 96(sp)
    36b8:	|              |     ,-- bra.s 36d2 <loadFunctionCode+0x342>
			initVarNew (newFunc -> localVars[a]);
    36ba:	|              |  ,--|-> movea.l 100(sp),a0
    36be:	|              |  |  |   move.l 20(a0),d1
    36c2:	|              |  |  |   move.l 96(sp),d0
    36c6:	|              |  |  |   lsl.l #3,d0
    36c8:	|              |  |  |   movea.l d1,a0
    36ca:	|              |  |  |   adda.l d0,a0
    36cc:	|              |  |  |   clr.l (a0)
		for (a = 0; a < newFunc -> numLocals; a ++) {
    36ce:	|              |  |  |   addq.l #1,96(sp)
    36d2:	|              |  |  '-> movea.l 100(sp),a0
    36d6:	|              |  |      move.l 8(a0),d0
    36da:	|              |  |      cmp.l 96(sp),d0
    36de:	|              |  '----- bgt.s 36ba <loadFunctionCode+0x32a>
    36e0:	|              |     ,-- bra.s 36ea <loadFunctionCode+0x35a>
		}
	} else
	{
		newFunc->numLocals = NULL;
    36e2:	|              '-----|-> movea.l 100(sp),a0
    36e6:	|                    |   clr.l 8(a0)
	}	

#ifndef DISABLEFUNCTIONCACHE
	if( numCachedFunctions >= CACHEFUNCTIONMAX) 
    36ea:	|                    '-> move.l cfae <numCachedFunctions>,d0
    36f0:	|                        moveq #9,d1
    36f2:	|                        cmp.l d0,d1
    36f4:	|  ,-------------------- bge.w 383c <loadFunctionCode+0x4ac>
	{
		struct cachedFunction *huntanddestroy = lastCachedFunction;
    36f8:	|  |                     move.l cfaa <lastCachedFunction>,88(sp)
		while (huntanddestroy) 
    3700:	|  |     ,-------------- bra.w 37be <loadFunctionCode+0x42e>
		{
			if (huntanddestroy->theFunction->unloaded == 1) 
    3704:	|  |  ,--|-------------> movea.l 88(sp),a0
    3708:	|  |  |  |               movea.l 4(a0),a0
    370c:	|  |  |  |               move.l 58(a0),d0
    3710:	|  |  |  |               moveq #1,d1
    3712:	|  |  |  |               cmp.l d0,d1
    3714:	|  |  |  |  ,----------- bne.w 37b4 <loadFunctionCode+0x424>
			{
				if( huntanddestroy->prev)
    3718:	|  |  |  |  |            movea.l 88(sp),a0
    371c:	|  |  |  |  |            move.l 12(a0),d0
    3720:	|  |  |  |  |        ,-- beq.s 3738 <loadFunctionCode+0x3a8>
					huntanddestroy->prev->next = huntanddestroy->next;							
    3722:	|  |  |  |  |        |   movea.l 88(sp),a0
    3726:	|  |  |  |  |        |   movea.l 12(a0),a0
    372a:	|  |  |  |  |        |   movea.l 88(sp),a1
    372e:	|  |  |  |  |        |   move.l 8(a1),d0
    3732:	|  |  |  |  |        |   move.l d0,8(a0)
    3736:	|  |  |  |  |     ,--|-- bra.s 3758 <loadFunctionCode+0x3c8>
				else
				{
					allCachedFunctions = huntanddestroy->next;
    3738:	|  |  |  |  |     |  '-> movea.l 88(sp),a0
    373c:	|  |  |  |  |     |      move.l 8(a0),d0
    3740:	|  |  |  |  |     |      move.l d0,cfa6 <allCachedFunctions>
					if( allCachedFunctions)
    3746:	|  |  |  |  |     |      move.l cfa6 <allCachedFunctions>,d0
    374c:	|  |  |  |  |     +----- beq.s 3758 <loadFunctionCode+0x3c8>
						allCachedFunctions->prev = NULL;
    374e:	|  |  |  |  |     |      movea.l cfa6 <allCachedFunctions>,a0
    3754:	|  |  |  |  |     |      clr.l 12(a0)
				}

				if (huntanddestroy == lastCachedFunction) {
    3758:	|  |  |  |  |     '----> move.l cfaa <lastCachedFunction>,d0
    375e:	|  |  |  |  |            cmp.l 88(sp),d0
    3762:	|  |  |  |  |     ,----- bne.s 3794 <loadFunctionCode+0x404>
					if( huntanddestroy->prev)
    3764:	|  |  |  |  |     |      movea.l 88(sp),a0
    3768:	|  |  |  |  |     |      move.l 12(a0),d0
    376c:	|  |  |  |  |     |  ,-- beq.s 377e <loadFunctionCode+0x3ee>
						lastCachedFunction = huntanddestroy->prev;
    376e:	|  |  |  |  |     |  |   movea.l 88(sp),a0
    3772:	|  |  |  |  |     |  |   move.l 12(a0),d0
    3776:	|  |  |  |  |     |  |   move.l d0,cfaa <lastCachedFunction>
				{
					if( huntanddestroy->next)
						huntanddestroy->next->prev = huntanddestroy->prev;																
				}				

				break;
    377c:	|  |  |  |  |  ,--|--|-- bra.s 37c8 <loadFunctionCode+0x438>
						lastCachedFunction = NULL;
    377e:	|  |  |  |  |  |  |  '-> clr.l cfaa <lastCachedFunction>
						KPrintF("loadFunctionCode: Last cached function is NULL\n");
    3784:	|  |  |  |  |  |  |      pea 8bfe <PutChar+0xf8a>
    378a:	|  |  |  |  |  |  |      jsr 725e <KPrintF>
    3790:	|  |  |  |  |  |  |      addq.l #4,sp
				break;
    3792:	|  |  |  |  |  +--|----- bra.s 37c8 <loadFunctionCode+0x438>
					if( huntanddestroy->next)
    3794:	|  |  |  |  |  |  '----> movea.l 88(sp),a0
    3798:	|  |  |  |  |  |         move.l 8(a0),d0
    379c:	|  |  |  |  |  +-------- beq.s 37c8 <loadFunctionCode+0x438>
						huntanddestroy->next->prev = huntanddestroy->prev;																
    379e:	|  |  |  |  |  |         movea.l 88(sp),a0
    37a2:	|  |  |  |  |  |         movea.l 8(a0),a0
    37a6:	|  |  |  |  |  |         movea.l 88(sp),a1
    37aa:	|  |  |  |  |  |         move.l 12(a1),d0
    37ae:	|  |  |  |  |  |         move.l d0,12(a0)
				break;
    37b2:	|  |  |  |  |  +-------- bra.s 37c8 <loadFunctionCode+0x438>
			}
			
			huntanddestroy = huntanddestroy->prev;
    37b4:	|  |  |  |  '--|-------> movea.l 88(sp),a0
    37b8:	|  |  |  |     |         move.l 12(a0),88(sp)
		while (huntanddestroy) 
    37be:	|  |  |  '-----|-------> tst.l 88(sp)
    37c2:	|  |  '--------|-------- bne.w 3704 <loadFunctionCode+0x374>
    37c6:	|  |           |     ,-- bra.s 37ca <loadFunctionCode+0x43a>
				break;
    37c8:	|  |           '-----|-> nop
		}		

		if( huntanddestroy)
    37ca:	|  |                 '-> tst.l 88(sp)
    37ce:	|  |                 ,-- beq.s 382e <loadFunctionCode+0x49e>
		{
			numCachedFunctions--;
    37d0:	|  |                 |   move.l cfae <numCachedFunctions>,d0
    37d6:	|  |                 |   subq.l #1,d0
    37d8:	|  |                 |   move.l d0,cfae <numCachedFunctions>
			FreeVec(huntanddestroy->theFunction->compiledLines);
    37de:	|  |                 |   movea.l 88(sp),a0
    37e2:	|  |                 |   movea.l 4(a0),a0
    37e6:	|  |                 |   move.l 4(a0),12(sp)
    37ec:	|  |                 |   move.l d018 <SysBase>,d0
    37f2:	|  |                 |   movea.l d0,a6
    37f4:	|  |                 |   movea.l 12(sp),a1
    37f8:	|  |                 |   jsr -690(a6)
			FreeVec(huntanddestroy->theFunction);
    37fc:	|  |                 |   movea.l 88(sp),a0
    3800:	|  |                 |   move.l 4(a0),8(sp)
    3806:	|  |                 |   move.l d018 <SysBase>,d0
    380c:	|  |                 |   movea.l d0,a6
    380e:	|  |                 |   movea.l 8(sp),a1
    3812:	|  |                 |   jsr -690(a6)
			FreeVec(huntanddestroy);
    3816:	|  |                 |   move.l 88(sp),4(sp)
    381c:	|  |                 |   move.l d018 <SysBase>,d0
    3822:	|  |                 |   movea.l d0,a6
    3824:	|  |                 |   movea.l 4(sp),a1
    3828:	|  |                 |   jsr -690(a6)
    382c:	|  +-----------------|-- bra.s 383c <loadFunctionCode+0x4ac>
		} else 
		{
			KPrintF("loadFunctionCode: Function is still in use\n");
    382e:	|  |                 '-> pea 8c2e <PutChar+0xfba>
    3834:	|  |                     jsr 725e <KPrintF>
    383a:	|  |                     addq.l #4,sp
		}
	}	
#endif					
	
	return newFunc;
    383c:	|  '-------------------> move.l 100(sp),d0

}
    3840:	'----------------------> movea.l (sp)+,a6
    3842:	                         lea 104(sp),sp
    3846:	                         rts

00003848 <openAndVerify>:
	currentEvents -> moveMouseFunction		= get2bytes (fp);
	currentEvents -> focusFunction			= (struct loadedFunction *) get4bytes (fp); //Todo: Changed to pointer type. Check if this is correct.
	currentEvents -> spaceFunction			= get2bytes (fp);
}

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion) {
    3848:	       lea -312(sp),sp
    384c:	       movem.l d2-d3/a6,-(sp)
    3850:	       move.l 332(sp),d1
    3854:	       move.l 336(sp),d0
    3858:	       move.b d1,d1
    385a:	       move.b d1,16(sp)
    385e:	       move.b d0,d0
    3860:	       move.b d0,14(sp)
	BPTR fp = Open(filename,MODE_OLDFILE);
    3864:	       move.l 328(sp),318(sp)
    386a:	       move.l #1005,314(sp)
    3872:	       move.l d020 <DOSBase>,d0
    3878:	       movea.l d0,a6
    387a:	       move.l 318(sp),d1
    387e:	       move.l 314(sp),d2
    3882:	       jsr -30(a6)
    3886:	       move.l d0,310(sp)
    388a:	       move.l 310(sp),d0
    388e:	       move.l d0,306(sp)

	if (! fp) {
    3892:	   ,-- bne.s 38ee <openAndVerify+0xa6>
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
    3894:	   |   move.l d020 <DOSBase>,d0
    389a:	   |   movea.l d0,a6
    389c:	   |   jsr -60(a6)
    38a0:	   |   move.l d0,154(sp)
    38a4:	   |   move.l 154(sp),d0
    38a8:	   |   move.l d0,150(sp)
    38ac:	   |   move.l #35930,146(sp)
    38b4:	   |   moveq #31,d0
    38b6:	   |   move.l d0,142(sp)
    38ba:	   |   move.l d020 <DOSBase>,d0
    38c0:	   |   movea.l d0,a6
    38c2:	   |   move.l 150(sp),d1
    38c6:	   |   move.l 146(sp),d2
    38ca:	   |   move.l 142(sp),d3
    38ce:	   |   jsr -48(a6)
    38d2:	   |   move.l d0,138(sp)
		KPrintF("openAndVerify: Can't open file", filename);
    38d6:	   |   move.l 328(sp),-(sp)
    38da:	   |   pea 8c7a <PutChar+0x1006>
    38e0:	   |   jsr 725e <KPrintF>
    38e6:	   |   addq.l #8,sp
		return NULL;
    38e8:	   |   moveq #0,d0
    38ea:	,--|-- bra.w 3bae <openAndVerify+0x366>
	}
	BOOL headerBad = FALSE;
    38ee:	|  '-> clr.w 322(sp)
	if (FGetC (fp) != 'S') headerBad = TRUE;
    38f2:	|      move.l 306(sp),302(sp)
    38f8:	|      move.l d020 <DOSBase>,d0
    38fe:	|      movea.l d0,a6
    3900:	|      move.l 302(sp),d1
    3904:	|      jsr -306(a6)
    3908:	|      move.l d0,298(sp)
    390c:	|      move.l 298(sp),d0
    3910:	|      moveq #83,d1
    3912:	|      cmp.l d0,d1
    3914:	|  ,-- beq.s 391c <openAndVerify+0xd4>
    3916:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'L') headerBad = TRUE;
    391c:	|  '-> move.l 306(sp),294(sp)
    3922:	|      move.l d020 <DOSBase>,d0
    3928:	|      movea.l d0,a6
    392a:	|      move.l 294(sp),d1
    392e:	|      jsr -306(a6)
    3932:	|      move.l d0,290(sp)
    3936:	|      move.l 290(sp),d0
    393a:	|      moveq #76,d1
    393c:	|      cmp.l d0,d1
    393e:	|  ,-- beq.s 3946 <openAndVerify+0xfe>
    3940:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'U') headerBad = TRUE;
    3946:	|  '-> move.l 306(sp),286(sp)
    394c:	|      move.l d020 <DOSBase>,d0
    3952:	|      movea.l d0,a6
    3954:	|      move.l 286(sp),d1
    3958:	|      jsr -306(a6)
    395c:	|      move.l d0,282(sp)
    3960:	|      move.l 282(sp),d0
    3964:	|      moveq #85,d1
    3966:	|      cmp.l d0,d1
    3968:	|  ,-- beq.s 3970 <openAndVerify+0x128>
    396a:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != 'D') headerBad = TRUE;
    3970:	|  '-> move.l 306(sp),278(sp)
    3976:	|      move.l d020 <DOSBase>,d0
    397c:	|      movea.l d0,a6
    397e:	|      move.l 278(sp),d1
    3982:	|      jsr -306(a6)
    3986:	|      move.l d0,274(sp)
    398a:	|      move.l 274(sp),d0
    398e:	|      moveq #68,d1
    3990:	|      cmp.l d0,d1
    3992:	|  ,-- beq.s 399a <openAndVerify+0x152>
    3994:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra1) headerBad = TRUE;
    399a:	|  '-> move.l 306(sp),270(sp)
    39a0:	|      move.l d020 <DOSBase>,d0
    39a6:	|      movea.l d0,a6
    39a8:	|      move.l 270(sp),d1
    39ac:	|      jsr -306(a6)
    39b0:	|      move.l d0,266(sp)
    39b4:	|      move.l 266(sp),d1
    39b8:	|      move.b 16(sp),d0
    39bc:	|      ext.w d0
    39be:	|      movea.w d0,a0
    39c0:	|      cmpa.l d1,a0
    39c2:	|  ,-- beq.s 39ca <openAndVerify+0x182>
    39c4:	|  |   move.w #1,322(sp)
	if (FGetC (fp) != extra2) headerBad = TRUE;
    39ca:	|  '-> move.l 306(sp),262(sp)
    39d0:	|      move.l d020 <DOSBase>,d0
    39d6:	|      movea.l d0,a6
    39d8:	|      move.l 262(sp),d1
    39dc:	|      jsr -306(a6)
    39e0:	|      move.l d0,258(sp)
    39e4:	|      move.l 258(sp),d1
    39e8:	|      move.b 14(sp),d0
    39ec:	|      ext.w d0
    39ee:	|      movea.w d0,a0
    39f0:	|      cmpa.l d1,a0
    39f2:	|  ,-- beq.s 39fa <openAndVerify+0x1b2>
    39f4:	|  |   move.w #1,322(sp)
	if (headerBad) {
    39fa:	|  '-> tst.w 322(sp)
    39fe:	|  ,-- beq.s 3a56 <openAndVerify+0x20e>
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
    3a00:	|  |   move.l d020 <DOSBase>,d0
    3a06:	|  |   movea.l d0,a6
    3a08:	|  |   jsr -60(a6)
    3a0c:	|  |   move.l d0,174(sp)
    3a10:	|  |   move.l 174(sp),d0
    3a14:	|  |   move.l d0,170(sp)
    3a18:	|  |   move.l #35993,166(sp)
    3a20:	|  |   moveq #31,d0
    3a22:	|  |   move.l d0,162(sp)
    3a26:	|  |   move.l d020 <DOSBase>,d0
    3a2c:	|  |   movea.l d0,a6
    3a2e:	|  |   move.l 170(sp),d1
    3a32:	|  |   move.l 166(sp),d2
    3a36:	|  |   move.l 162(sp),d3
    3a3a:	|  |   jsr -48(a6)
    3a3e:	|  |   move.l d0,158(sp)
		KPrintF("openAndVerify: Bad Header\n");
    3a42:	|  |   pea 8c99 <PutChar+0x1025>
    3a48:	|  |   jsr 725e <KPrintF>
    3a4e:	|  |   addq.l #4,sp
		return NULL;
    3a50:	|  |   moveq #0,d0
    3a52:	+--|-- bra.w 3bae <openAndVerify+0x366>
	}
	FGetC (fp);
    3a56:	|  '-> move.l 306(sp),254(sp)
    3a5c:	|      move.l d020 <DOSBase>,d0
    3a62:	|      movea.l d0,a6
    3a64:	|      move.l 254(sp),d1
    3a68:	|      jsr -306(a6)
    3a6c:	|      move.l d0,250(sp)
	while (FGetC(fp)) {;}
    3a70:	|      nop
    3a72:	|  ,-> move.l 306(sp),246(sp)
    3a78:	|  |   move.l d020 <DOSBase>,d0
    3a7e:	|  |   movea.l d0,a6
    3a80:	|  |   move.l 246(sp),d1
    3a84:	|  |   jsr -306(a6)
    3a88:	|  |   move.l d0,242(sp)
    3a8c:	|  |   move.l 242(sp),d0
    3a90:	|  '-- bne.s 3a72 <openAndVerify+0x22a>

	int majVersion = FGetC (fp);
    3a92:	|      move.l 306(sp),238(sp)
    3a98:	|      move.l d020 <DOSBase>,d0
    3a9e:	|      movea.l d0,a6
    3aa0:	|      move.l 238(sp),d1
    3aa4:	|      jsr -306(a6)
    3aa8:	|      move.l d0,234(sp)
    3aac:	|      move.l 234(sp),d0
    3ab0:	|      move.l d0,230(sp)
	int minVersion = FGetC (fp);
    3ab4:	|      move.l 306(sp),226(sp)
    3aba:	|      move.l d020 <DOSBase>,d0
    3ac0:	|      movea.l d0,a6
    3ac2:	|      move.l 226(sp),d1
    3ac6:	|      jsr -306(a6)
    3aca:	|      move.l d0,222(sp)
    3ace:	|      move.l 222(sp),d0
    3ad2:	|      move.l d0,218(sp)
	*fileVersion = majVersion * 256 + minVersion;
    3ad6:	|      move.l 230(sp),d0
    3ada:	|      lsl.l #8,d0
    3adc:	|      add.l 218(sp),d0
    3ae0:	|      movea.l 344(sp),a0
    3ae4:	|      move.l d0,(a0)

	char txtVer[120];

	if (*fileVersion > WHOLE_VERSION) {
    3ae6:	|      movea.l 344(sp),a0
    3aea:	|      move.l (a0),d0
    3aec:	|      cmpi.l #514,d0
    3af2:	|  ,-- ble.s 3b48 <openAndVerify+0x300>
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
    3af4:	|  |   move.l d020 <DOSBase>,d0
    3afa:	|  |   movea.l d0,a6
    3afc:	|  |   jsr -60(a6)
    3b00:	|  |   move.l d0,194(sp)
    3b04:	|  |   move.l 194(sp),d0
    3b08:	|  |   move.l d0,190(sp)
    3b0c:	|  |   move.l #36020,186(sp)
    3b14:	|  |   moveq #100,d1
    3b16:	|  |   move.l d1,182(sp)
    3b1a:	|  |   move.l d020 <DOSBase>,d0
    3b20:	|  |   movea.l d0,a6
    3b22:	|  |   move.l 190(sp),d1
    3b26:	|  |   move.l 186(sp),d2
    3b2a:	|  |   move.l 182(sp),d3
    3b2e:	|  |   jsr -48(a6)
    3b32:	|  |   move.l d0,178(sp)
		KPrintF(ERROR_VERSION_TOO_LOW_1);
    3b36:	|  |   pea 8cb4 <PutChar+0x1040>
    3b3c:	|  |   jsr 725e <KPrintF>
    3b42:	|  |   addq.l #4,sp
		return NULL;
    3b44:	|  |   moveq #0,d0
    3b46:	+--|-- bra.s 3bae <openAndVerify+0x366>
	} else if (*fileVersion < MINIM_VERSION) {
    3b48:	|  '-> movea.l 344(sp),a0
    3b4c:	|      move.l (a0),d0
    3b4e:	|      cmpi.l #257,d0
    3b54:	|  ,-- bgt.s 3baa <openAndVerify+0x362>
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
    3b56:	|  |   move.l d020 <DOSBase>,d0
    3b5c:	|  |   movea.l d0,a6
    3b5e:	|  |   jsr -60(a6)
    3b62:	|  |   move.l d0,214(sp)
    3b66:	|  |   move.l 214(sp),d0
    3b6a:	|  |   move.l d0,210(sp)
    3b6e:	|  |   move.l #36089,206(sp)
    3b76:	|  |   moveq #100,d0
    3b78:	|  |   move.l d0,202(sp)
    3b7c:	|  |   move.l d020 <DOSBase>,d0
    3b82:	|  |   movea.l d0,a6
    3b84:	|  |   move.l 210(sp),d1
    3b88:	|  |   move.l 206(sp),d2
    3b8c:	|  |   move.l 202(sp),d3
    3b90:	|  |   jsr -48(a6)
    3b94:	|  |   move.l d0,198(sp)
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
    3b98:	|  |   pea 8cf9 <PutChar+0x1085>
    3b9e:	|  |   jsr 725e <KPrintF>
    3ba4:	|  |   addq.l #4,sp
		return NULL;
    3ba6:	|  |   moveq #0,d0
    3ba8:	+--|-- bra.s 3bae <openAndVerify+0x366>
	}
	return fp;
    3baa:	|  '-> move.l 306(sp),d0
}
    3bae:	'----> movem.l (sp)+,d2-d3/a6
    3bb2:	       lea 312(sp),sp
    3bb6:	       rts

00003bb8 <restartFunction>:
struct loadedFunction *preloadNewFunctionNum (unsigned int funcNum) {		

	return loadFunctionCode (funcNum);	
}

void restartFunction (struct loadedFunction * fun) {
    3bb8:	subq.l #4,sp

	int test[1];
	test[0] = fun -> originalNumber;
    3bba:	movea.l 8(sp),a0
    3bbe:	move.l (a0),d0
    3bc0:	move.l d0,(sp)

	KPrintF("Function %ld restarted\n", test[0]);
    3bc2:	move.l (sp),d0
    3bc4:	move.l d0,-(sp)
    3bc6:	pea 8d6d <PutChar+0x10f9>
    3bcc:	jsr 725e <KPrintF>
    3bd2:	addq.l #8,sp

	fun -> next = allRunningFunctions;
    3bd4:	move.l cfb6 <allRunningFunctions>,d0
    3bda:	movea.l 8(sp),a0
    3bde:	move.l d0,44(a0)
	fun -> unloaded = 0;
    3be2:	movea.l 8(sp),a0
    3be6:	clr.l 58(a0)
	allRunningFunctions = fun;
    3bea:	move.l 8(sp),cfb6 <allRunningFunctions>
}
    3bf2:	nop
    3bf4:	addq.l #4,sp
    3bf6:	rts

00003bf8 <sludgeDisplay>:
	put2bytes (currentEvents -> moveMouseFunction,		fp);
	put4bytes ((ULONG) currentEvents -> focusFunction,			fp); //Todo: Changed to pointer type. Check if this is correct.
	put2bytes (currentEvents -> spaceFunction,			fp);
}

void sludgeDisplay () {					
    3bf8:	subq.l #4,sp
  	volatile struct Custom *custom = (struct Custom*)0xdff000;
    3bfa:	move.l #14675968,(sp)
	displayCursor();
    3c00:	jsr 716 <displayCursor>
	CstRestoreScreen();
    3c06:	jsr 12d2 <CstRestoreScreen>
	drawPeople();
    3c0c:	jsr 55be <drawPeople>
	CstSwapBuffer();
    3c12:	jsr 1f7a <CstSwapBuffer>
}
    3c18:	nop
    3c1a:	addq.l #4,sp
    3c1c:	rts

00003c1e <startNewFunctionLoaded>:
		}
	}
	return copyVariable(va, &(vS->thisVar));
}

int startNewFunctionLoaded (struct loadedFunction * newFunc, unsigned int numParamsExpected,struct loadedFunction * calledBy, struct variableStack ** vStack, BOOL returnSommet) {
    3c1e:	             subq.l #8,sp
    3c20:	             move.l 28(sp),d0
    3c24:	             move.w d0,d0
    3c26:	             move.w d0,2(sp)
	
	if (newFunc -> numArgs != (int)numParamsExpected) {
    3c2a:	             movea.l 12(sp),a0
    3c2e:	             move.l 16(a0),d1
    3c32:	             move.l 16(sp),d0
    3c36:	             cmp.l d1,d0
    3c38:	         ,-- beq.s 3c4e <startNewFunctionLoaded+0x30>
		KPrintF("Wrong number of parameters!");
    3c3a:	         |   pea 8d9e <PutChar+0x112a>
    3c40:	         |   jsr 725e <KPrintF>
    3c46:	         |   addq.l #4,sp
		return NULL; 
    3c48:	         |   moveq #0,d0
    3c4a:	,--------|-- bra.w 3d2a <startNewFunctionLoaded+0x10c>
	}
	if (newFunc -> numArgs > newFunc -> numLocals)  {
    3c4e:	|        '-> movea.l 12(sp),a0
    3c52:	|            move.l 16(a0),d1
    3c56:	|            movea.l 12(sp),a0
    3c5a:	|            move.l 8(a0),d0
    3c5e:	|            cmp.l d1,d0
    3c60:	|  ,-------- bge.s 3cca <startNewFunctionLoaded+0xac>
		KPrintF ("More arguments than local variable space!");
    3c62:	|  |         pea 8dba <PutChar+0x1146>
    3c68:	|  |         jsr 725e <KPrintF>
    3c6e:	|  |         addq.l #4,sp
		return NULL; 
    3c70:	|  |         moveq #0,d0
    3c72:	+--|-------- bra.w 3d2a <startNewFunctionLoaded+0x10c>
	}
	
	// Now, lets copy the parameters from the calling function's stack...

	while (numParamsExpected) {
		struct variableStack *vStacksimpleptr = *vStack;
    3c76:	|  |  ,----> movea.l 24(sp),a0
    3c7a:	|  |  |      move.l (a0),4(sp)
		numParamsExpected --;
    3c7e:	|  |  |      subq.l #1,16(sp)
		if (*vStack == NULL) {
    3c82:	|  |  |      movea.l 24(sp),a0
    3c86:	|  |  |      move.l (a0),d0
    3c88:	|  |  |  ,-- bne.s 3c9e <startNewFunctionLoaded+0x80>
			KPrintF("Corrupted file! The stack's empty and there were still parameters expected");
    3c8a:	|  |  |  |   pea 8de4 <PutChar+0x1170>
    3c90:	|  |  |  |   jsr 725e <KPrintF>
    3c96:	|  |  |  |   addq.l #4,sp
			return NULL;
    3c98:	|  |  |  |   moveq #0,d0
    3c9a:	+--|--|--|-- bra.w 3d2a <startNewFunctionLoaded+0x10c>
		}
		copyVariable (&vStacksimpleptr -> thisVar, &newFunc->localVars[numParamsExpected]);
    3c9e:	|  |  |  '-> movea.l 12(sp),a0
    3ca2:	|  |  |      move.l 20(a0),d1
    3ca6:	|  |  |      move.l 16(sp),d0
    3caa:	|  |  |      lsl.l #3,d0
    3cac:	|  |  |      add.l d0,d1
    3cae:	|  |  |      move.l 4(sp),d0
    3cb2:	|  |  |      move.l d1,-(sp)
    3cb4:	|  |  |      move.l d0,-(sp)
    3cb6:	|  |  |      jsr 703c <copyVariable>
    3cbc:	|  |  |      addq.l #8,sp
		trimStack ( vStack);
    3cbe:	|  |  |      move.l 24(sp),-(sp)
    3cc2:	|  |  |      jsr 705a <trimStack>
    3cc8:	|  |  |      addq.l #4,sp
	while (numParamsExpected) {
    3cca:	|  '--|----> tst.l 16(sp)
    3cce:	|     '----- bne.s 3c76 <startNewFunctionLoaded+0x58>
	}

	newFunc -> cancelMe = FALSE;
    3cd0:	|            movea.l 12(sp),a0
    3cd4:	|            clr.w 54(a0)
	newFunc -> timeLeft = 0;
    3cd8:	|            movea.l 12(sp),a0
    3cdc:	|            clr.l 12(a0)
	newFunc -> returnSomething = returnSommet;
    3ce0:	|            movea.l 12(sp),a0
    3ce4:	|            move.w 2(sp),48(a0)
	newFunc -> calledBy = calledBy;
    3cea:	|            movea.l 12(sp),a0
    3cee:	|            move.l 20(sp),40(a0)
	newFunc -> stack = NULL;
    3cf4:	|            movea.l 12(sp),a0
    3cf8:	|            clr.l 24(a0)
	newFunc -> freezerLevel = 0;
    3cfc:	|            movea.l 12(sp),a0
    3d00:	|            clr.b 56(a0)
	newFunc -> runThisLine = 0;
    3d04:	|            movea.l 12(sp),a0
    3d08:	|            clr.l 36(a0)
	newFunc -> isSpeech = 0;
    3d0c:	|            movea.l 12(sp),a0
    3d10:	|            clr.w 50(a0)
	newFunc -> reg.varType = SVT_NULL;
    3d14:	|            movea.l 12(sp),a0
    3d18:	|            clr.l 28(a0)

	restartFunction (newFunc);
    3d1c:	|            move.l 12(sp),-(sp)
    3d20:	|            jsr 3bb8 <restartFunction>
    3d26:	|            addq.l #4,sp
	return 1;
    3d28:	|            moveq #1,d0
}
    3d2a:	'----------> addq.l #8,sp
    3d2c:	             rts

00003d2e <startNewFunctionNum>:

int startNewFunctionNum (unsigned int funcNum, unsigned int numParamsExpected, struct loadedFunction * calledBy, struct variableStack ** vStack, BOOL returnSommet) {
    3d2e:	lea -12(sp),sp
    3d32:	move.l 32(sp),d0
    3d36:	move.w d0,d0
    3d38:	move.w d0,2(sp)
	
	volatile struct Custom *custom = (struct Custom*)0xdff000;
    3d3c:	move.l #14675968,8(sp)
	//custom->color[0] = 0x00f;	

	struct loadedFunction *newFunc = loadFunctionCode (funcNum);	
    3d44:	move.l 16(sp),-(sp)
    3d48:	jsr 3390 <loadFunctionCode>
    3d4e:	addq.l #4,sp
    3d50:	move.l d0,4(sp)
	//custom->color[0] = 0x000;	
	return startNewFunctionLoaded (newFunc, numParamsExpected, calledBy, vStack, returnSommet);
    3d54:	movea.w 2(sp),a0
    3d58:	move.l a0,-(sp)
    3d5a:	move.l 32(sp),-(sp)
    3d5e:	move.l 32(sp),-(sp)
    3d62:	move.l 32(sp),-(sp)
    3d66:	move.l 20(sp),-(sp)
    3d6a:	jsr 3c1e <startNewFunctionLoaded>
    3d70:	lea 20(sp),sp
}
    3d74:	lea 12(sp),sp
    3d78:	rts

00003d7a <finishAccess>:
char * convertString(char * s) {
	return NULL;
}

void finishAccess () {
	sliceBusy = FALSE;
    3d7a:	clr.w cf36 <sliceBusy>
}
    3d80:	nop
    3d82:	rts

00003d84 <getNumberedString>:

char * getNumberedString (int value) {
    3d84:	       lea -56(sp),sp
    3d88:	       movem.l d2-d3/a6,-(sp)

	if (sliceBusy) {
    3d8c:	       move.w cf36 <sliceBusy>,d0
    3d92:	   ,-- beq.s 3ddc <getNumberedString+0x58>
		Write(Output(), (APTR)"getNumberedString: Can't read from data file. I'm already reading something\n", 76);        
    3d94:	   |   move.l d020 <DOSBase>,d0
    3d9a:	   |   movea.l d0,a6
    3d9c:	   |   jsr -60(a6)
    3da0:	   |   move.l d0,28(sp)
    3da4:	   |   move.l 28(sp),d0
    3da8:	   |   move.l d0,24(sp)
    3dac:	   |   move.l #36437,20(sp)
    3db4:	   |   moveq #76,d0
    3db6:	   |   move.l d0,16(sp)
    3dba:	   |   move.l d020 <DOSBase>,d0
    3dc0:	   |   movea.l d0,a6
    3dc2:	   |   move.l 24(sp),d1
    3dc6:	   |   move.l 20(sp),d2
    3dca:	   |   move.l 16(sp),d3
    3dce:	   |   jsr -48(a6)
    3dd2:	   |   move.l d0,12(sp)
		return NULL;
    3dd6:	   |   moveq #0,d0
    3dd8:	,--|-- bra.w 3e78 <getNumberedString+0xf4>
	}

	Seek(bigDataFile, (value << 2) + startOfTextIndex, OFFSET_BEGINNING);
    3ddc:	|  '-> move.l d000 <bigDataFile>,64(sp)
    3de4:	|      move.l 72(sp),d0
    3de8:	|      add.l d0,d0
    3dea:	|      add.l d0,d0
    3dec:	|      move.l d0,d1
    3dee:	|      move.l d00c <startOfTextIndex>,d0
    3df4:	|      add.l d1,d0
    3df6:	|      move.l d0,60(sp)
    3dfa:	|      moveq #-1,d0
    3dfc:	|      move.l d0,56(sp)
    3e00:	|      move.l d020 <DOSBase>,d0
    3e06:	|      movea.l d0,a6
    3e08:	|      move.l 64(sp),d1
    3e0c:	|      move.l 60(sp),d2
    3e10:	|      move.l 56(sp),d3
    3e14:	|      jsr -66(a6)
    3e18:	|      move.l d0,52(sp)
	value = get4bytes (bigDataFile);
    3e1c:	|      move.l d000 <bigDataFile>,d0
    3e22:	|      move.l d0,-(sp)
    3e24:	|      jsr 532 <get4bytes>
    3e2a:	|      addq.l #4,sp
    3e2c:	|      move.l d0,72(sp)
	Seek (bigDataFile, value, OFFSET_BEGINING);
    3e30:	|      move.l d000 <bigDataFile>,48(sp)
    3e38:	|      move.l 72(sp),44(sp)
    3e3e:	|      moveq #-1,d0
    3e40:	|      move.l d0,40(sp)
    3e44:	|      move.l d020 <DOSBase>,d0
    3e4a:	|      movea.l d0,a6
    3e4c:	|      move.l 48(sp),d1
    3e50:	|      move.l 44(sp),d2
    3e54:	|      move.l 40(sp),d3
    3e58:	|      jsr -66(a6)
    3e5c:	|      move.l d0,36(sp)

	char * s = readString (bigDataFile);    
    3e60:	|      move.l d000 <bigDataFile>,d0
    3e66:	|      move.l d0,-(sp)
    3e68:	|      jsr 66e <readString>
    3e6e:	|      addq.l #4,sp
    3e70:	|      move.l d0,32(sp)
	
	return s;
    3e74:	|      move.l 32(sp),d0
}
    3e78:	'----> movem.l (sp)+,d2-d3/a6
    3e7c:	       lea 56(sp),sp
    3e80:	       rts

00003e82 <openSubSlice>:
    // FPrintf(dbug, "Told to skip forward to %ld\n", FTell(bigDataFile));
    // FClose(dbug);
    return sliceBusy = TRUE;
}

BOOL openSubSlice (int num) {
    3e82:	       lea -32(sp),sp
    3e86:	       movem.l d2-d3/a6,-(sp)
//	FILE * dbug = fopen ("debuggy.txt", "at");

//	fprintf (dbug, "\nTrying to open sub %i\n", num);

	if (sliceBusy) {
    3e8a:	       move.w cf36 <sliceBusy>,d0
    3e90:	   ,-- beq.s 3eac <openSubSlice+0x2a>
		KPrintF("Can't read from data file", "I'm already reading something");
    3e92:	   |   pea 8ea2 <PutChar+0x122e>
    3e98:	   |   pea 8ec0 <PutChar+0x124c>
    3e9e:	   |   jsr 725e <KPrintF>
    3ea4:	   |   addq.l #8,sp
		return FALSE;
    3ea6:	   |   clr.w d0
    3ea8:	,--|-- bra.w 3f38 <openSubSlice+0xb6>
	}

//	fprintf (dbug, "Going to position %li\n", startOfSubIndex + (num << 2));
	Seek(bigDataFile, startOfSubIndex + (num << 2), OFFSET_BEGINNING);
    3eac:	|  '-> move.l d000 <bigDataFile>,40(sp)
    3eb4:	|      move.l 48(sp),d0
    3eb8:	|      add.l d0,d0
    3eba:	|      add.l d0,d0
    3ebc:	|      move.l d0,d1
    3ebe:	|      move.l d010 <startOfSubIndex>,d0
    3ec4:	|      add.l d1,d0
    3ec6:	|      move.l d0,36(sp)
    3eca:	|      moveq #-1,d0
    3ecc:	|      move.l d0,32(sp)
    3ed0:	|      move.l d020 <DOSBase>,d0
    3ed6:	|      movea.l d0,a6
    3ed8:	|      move.l 40(sp),d1
    3edc:	|      move.l 36(sp),d2
    3ee0:	|      move.l 32(sp),d3
    3ee4:	|      jsr -66(a6)
    3ee8:	|      move.l d0,28(sp)
	Seek(bigDataFile, get4bytes (bigDataFile), OFFSET_BEGINNING);
    3eec:	|      move.l d000 <bigDataFile>,24(sp)
    3ef4:	|      move.l d000 <bigDataFile>,d0
    3efa:	|      move.l d0,-(sp)
    3efc:	|      jsr 532 <get4bytes>
    3f02:	|      addq.l #4,sp
    3f04:	|      move.l d0,20(sp)
    3f08:	|      moveq #-1,d0
    3f0a:	|      move.l d0,16(sp)
    3f0e:	|      move.l d020 <DOSBase>,d0
    3f14:	|      movea.l d0,a6
    3f16:	|      move.l 24(sp),d1
    3f1a:	|      move.l 20(sp),d2
    3f1e:	|      move.l 16(sp),d3
    3f22:	|      jsr -66(a6)
    3f26:	|      move.l d0,12(sp)
//	fprintf (dbug, "Told to skip forward to %li\n", ftell (bigDataFile));
//	fclose (dbug);
	return sliceBusy = TRUE;
    3f2a:	|      move.w #1,cf36 <sliceBusy>
    3f32:	|      move.w cf36 <sliceBusy>,d0
}
    3f38:	'----> movem.l (sp)+,d2-d3/a6
    3f3c:	       lea 32(sp),sp
    3f40:	       rts

00003f42 <setFileIndices>:

void setFileIndices (BPTR fp, unsigned int numLanguages, unsigned int skipBefore) {
    3f42:	       lea -180(sp),sp
    3f46:	       movem.l d2-d3/a6,-(sp)
	if (fp) {
    3f4a:	       tst.l 196(sp)
    3f4e:	,----- beq.s 3f8e <setFileIndices+0x4c>
		// Keep hold of the file handle, and let things get at it
		bigDataFile = fp;
    3f50:	|      move.l 196(sp),d000 <bigDataFile>
		startIndex = Seek( fp, 0, OFFSET_CURRENT);
    3f58:	|      move.l 196(sp),168(sp)
    3f5e:	|      clr.l 164(sp)
    3f62:	|      clr.l 160(sp)
    3f66:	|      move.l d020 <DOSBase>,d0
    3f6c:	|      movea.l d0,a6
    3f6e:	|      move.l 168(sp),d1
    3f72:	|      move.l 164(sp),d2
    3f76:	|      move.l 160(sp),d3
    3f7a:	|      jsr -66(a6)
    3f7e:	|      move.l d0,156(sp)
    3f82:	|      move.l 156(sp),d0
    3f86:	|      move.l d0,d004 <startIndex>
    3f8c:	|  ,-- bra.s 3fc8 <setFileIndices+0x86>
	} else {
		// No file pointer - this means that we reuse the bigDataFile
		fp = bigDataFile;
    3f8e:	'--|-> move.l d000 <bigDataFile>,196(sp)
        Seek(fp, startIndex, OFFSET_BEGINNING);
    3f96:	   |   move.l 196(sp),184(sp)
    3f9c:	   |   move.l d004 <startIndex>,d0
    3fa2:	   |   move.l d0,180(sp)
    3fa6:	   |   moveq #-1,d0
    3fa8:	   |   move.l d0,176(sp)
    3fac:	   |   move.l d020 <DOSBase>,d0
    3fb2:	   |   movea.l d0,a6
    3fb4:	   |   move.l 184(sp),d1
    3fb8:	   |   move.l 180(sp),d2
    3fbc:	   |   move.l 176(sp),d3
    3fc0:	   |   jsr -66(a6)
    3fc4:	   |   move.l d0,172(sp)
	}
	sliceBusy = FALSE;
    3fc8:	   '-> clr.w cf36 <sliceBusy>

	if (skipBefore > numLanguages) {
    3fce:	       move.l 204(sp),d0
    3fd2:	       cmp.l 200(sp),d0
    3fd6:	   ,-- bls.s 3fea <setFileIndices+0xa8>
		KPrintF("setFileIndices: Warning: Not a valid language ID! Using default instead.");
    3fd8:	   |   pea 8eda <PutChar+0x1266>
    3fde:	   |   jsr 725e <KPrintF>
    3fe4:	   |   addq.l #4,sp
		skipBefore = 0;
    3fe6:	   |   clr.l 204(sp)
	}

	// STRINGS
	int skipAfter = numLanguages - skipBefore;
    3fea:	   '-> move.l 200(sp),d0
    3fee:	       sub.l 204(sp),d0
    3ff2:	       move.l d0,188(sp)
	while (skipBefore) {
    3ff6:	   ,-- bra.s 4034 <setFileIndices+0xf2>
        Seek(fp, get4bytes(fp),OFFSET_BEGINING);		
    3ff8:	,--|-> move.l 196(sp),24(sp)
    3ffe:	|  |   move.l 196(sp),-(sp)
    4002:	|  |   jsr 532 <get4bytes>
    4008:	|  |   addq.l #4,sp
    400a:	|  |   move.l d0,20(sp)
    400e:	|  |   moveq #-1,d0
    4010:	|  |   move.l d0,16(sp)
    4014:	|  |   move.l d020 <DOSBase>,d0
    401a:	|  |   movea.l d0,a6
    401c:	|  |   move.l 24(sp),d1
    4020:	|  |   move.l 20(sp),d2
    4024:	|  |   move.l 16(sp),d3
    4028:	|  |   jsr -66(a6)
    402c:	|  |   move.l d0,12(sp)
		skipBefore --;
    4030:	|  |   subq.l #1,204(sp)
	while (skipBefore) {
    4034:	|  '-> tst.l 204(sp)
    4038:	'----- bne.s 3ff8 <setFileIndices+0xb6>
	}
	startOfTextIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    403a:	       move.l 196(sp),152(sp)
    4040:	       clr.l 148(sp)
    4044:	       clr.l 144(sp)
    4048:	       move.l d020 <DOSBase>,d0
    404e:	       movea.l d0,a6
    4050:	       move.l 152(sp),d1
    4054:	       move.l 148(sp),d2
    4058:	       move.l 144(sp),d3
    405c:	       jsr -66(a6)
    4060:	       move.l d0,140(sp)
    4064:	       move.l 140(sp),d0
    4068:	       addq.l #4,d0
    406a:	       move.l d0,d00c <startOfTextIndex>

	Seek(fp, get4bytes (fp), OFFSET_BEGINNING);
    4070:	       move.l 196(sp),136(sp)
    4076:	       move.l 196(sp),-(sp)
    407a:	       jsr 532 <get4bytes>
    4080:	       addq.l #4,sp
    4082:	       move.l d0,132(sp)
    4086:	       moveq #-1,d0
    4088:	       move.l d0,128(sp)
    408c:	       move.l d020 <DOSBase>,d0
    4092:	       movea.l d0,a6
    4094:	       move.l 136(sp),d1
    4098:	       move.l 132(sp),d2
    409c:	       move.l 128(sp),d3
    40a0:	       jsr -66(a6)
    40a4:	       move.l d0,124(sp)

	while (skipAfter) {
    40a8:	   ,-- bra.s 40e6 <setFileIndices+0x1a4>
        Seek( fp, get4bytes (fp), OFFSET_BEGINING);
    40aa:	,--|-> move.l 196(sp),40(sp)
    40b0:	|  |   move.l 196(sp),-(sp)
    40b4:	|  |   jsr 532 <get4bytes>
    40ba:	|  |   addq.l #4,sp
    40bc:	|  |   move.l d0,36(sp)
    40c0:	|  |   moveq #-1,d0
    40c2:	|  |   move.l d0,32(sp)
    40c6:	|  |   move.l d020 <DOSBase>,d0
    40cc:	|  |   movea.l d0,a6
    40ce:	|  |   move.l 40(sp),d1
    40d2:	|  |   move.l 36(sp),d2
    40d6:	|  |   move.l 32(sp),d3
    40da:	|  |   jsr -66(a6)
    40de:	|  |   move.l d0,28(sp)
		skipAfter --;
    40e2:	|  |   subq.l #1,188(sp)
	while (skipAfter) {
    40e6:	|  '-> tst.l 188(sp)
    40ea:	'----- bne.s 40aa <setFileIndices+0x168>
	}

	startOfSubIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    40ec:	       move.l 196(sp),120(sp)
    40f2:	       clr.l 116(sp)
    40f6:	       clr.l 112(sp)
    40fa:	       move.l d020 <DOSBase>,d0
    4100:	       movea.l d0,a6
    4102:	       move.l 120(sp),d1
    4106:	       move.l 116(sp),d2
    410a:	       move.l 112(sp),d3
    410e:	       jsr -66(a6)
    4112:	       move.l d0,108(sp)
    4116:	       move.l 108(sp),d0
    411a:	       addq.l #4,d0
    411c:	       move.l d0,d010 <startOfSubIndex>
    Seek( fp, get4bytes (fp), OFFSET_CURRENT);
    4122:	       move.l 196(sp),104(sp)
    4128:	       move.l 196(sp),-(sp)
    412c:	       jsr 532 <get4bytes>
    4132:	       addq.l #4,sp
    4134:	       move.l d0,100(sp)
    4138:	       clr.l 96(sp)
    413c:	       move.l d020 <DOSBase>,d0
    4142:	       movea.l d0,a6
    4144:	       move.l 104(sp),d1
    4148:	       move.l 100(sp),d2
    414c:	       move.l 96(sp),d3
    4150:	       jsr -66(a6)
    4154:	       move.l d0,92(sp)

	startOfObjectIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    4158:	       move.l 196(sp),88(sp)
    415e:	       clr.l 84(sp)
    4162:	       clr.l 80(sp)
    4166:	       move.l d020 <DOSBase>,d0
    416c:	       movea.l d0,a6
    416e:	       move.l 88(sp),d1
    4172:	       move.l 84(sp),d2
    4176:	       move.l 80(sp),d3
    417a:	       jsr -66(a6)
    417e:	       move.l d0,76(sp)
    4182:	       move.l 76(sp),d0
    4186:	       addq.l #4,d0
    4188:	       move.l d0,d014 <startOfObjectIndex>
	Seek (fp, get4bytes (fp), OFFSET_CURRENT);
    418e:	       move.l 196(sp),72(sp)
    4194:	       move.l 196(sp),-(sp)
    4198:	       jsr 532 <get4bytes>
    419e:	       addq.l #4,sp
    41a0:	       move.l d0,68(sp)
    41a4:	       clr.l 64(sp)
    41a8:	       move.l d020 <DOSBase>,d0
    41ae:	       movea.l d0,a6
    41b0:	       move.l 72(sp),d1
    41b4:	       move.l 68(sp),d2
    41b8:	       move.l 64(sp),d3
    41bc:	       jsr -66(a6)
    41c0:	       move.l d0,60(sp)

	// Remember that the data section starts here
	startOfDataIndex =  Seek( fp, 0, OFFSET_CURRENT);
    41c4:	       move.l 196(sp),56(sp)
    41ca:	       clr.l 52(sp)
    41ce:	       clr.l 48(sp)
    41d2:	       move.l d020 <DOSBase>,d0
    41d8:	       movea.l d0,a6
    41da:	       move.l 56(sp),d1
    41de:	       move.l 52(sp),d2
    41e2:	       move.l 48(sp),d3
    41e6:	       jsr -66(a6)
    41ea:	       move.l d0,44(sp)
    41ee:	       move.l 44(sp),d0
    41f2:	       move.l d0,d008 <startOfDataIndex>
    41f8:	       nop
    41fa:	       movem.l (sp)+,d2-d3/a6
    41fe:	       lea 180(sp),sp
    4202:	       rts

00004204 <GetVBR>:
static volatile APTR VBR=0;
static APTR SystemIrq;
 
struct View *ActiView;

static APTR GetVBR(void) {
    4204:	    lea -20(sp),sp
    4208:	    move.l a6,-(sp)
    420a:	    move.l d7,-(sp)
	APTR vbr = 0;
    420c:	    clr.l 24(sp)
	UWORD getvbr[] = { 0x4e7a, 0x0801, 0x4e73 }; // MOVEC.L VBR,D0 RTE
    4210:	    move.w #20090,10(sp)
    4216:	    move.w #2049,12(sp)
    421c:	    move.w #20083,14(sp)

	if (SysBase->AttnFlags & AFF_68010) 
    4222:	    movea.l d018 <SysBase>,a0
    4228:	    move.w 296(a0),d0
    422c:	    move.w d0,d0
    422e:	    andi.l #65535,d0
    4234:	    moveq #1,d1
    4236:	    and.l d1,d0
    4238:	,-- beq.s 4266 <GetVBR+0x62>
		vbr = (APTR)Supervisor((ULONG (*)())getvbr);
    423a:	|   lea 28(sp),a0
    423e:	|   lea -18(a0),a0
    4242:	|   move.l a0,20(sp)
    4246:	|   move.l d018 <SysBase>,d0
    424c:	|   movea.l d0,a6
    424e:	|   move.l 20(sp),d7
    4252:	|   exg d7,a5
    4254:	|   jsr -30(a6)
    4258:	|   exg d7,a5
    425a:	|   move.l d0,16(sp)
    425e:	|   move.l 16(sp),d0
    4262:	|   move.l d0,24(sp)

	return vbr;
    4266:	'-> move.l 24(sp),d0
}
    426a:	    move.l (sp)+,d7
    426c:	    movea.l (sp)+,a6
    426e:	    lea 20(sp),sp
    4272:	    rts

00004274 <SetInterruptHandler>:

void SetInterruptHandler(APTR interrupt) {
	*(volatile APTR*)(((UBYTE*)VBR)+0x6c) = interrupt;
    4274:	movea.l d03e <VBR>,a0
    427a:	lea 108(a0),a0
    427e:	move.l 4(sp),(a0)
}
    4282:	nop
    4284:	rts

00004286 <GetInterruptHandler>:

APTR GetInterruptHandler() {
	return *(volatile APTR*)(((UBYTE*)VBR)+0x6c);
    4286:	movea.l d03e <VBR>,a0
    428c:	move.l 108(a0),d0
}
    4290:	rts

00004292 <TakeSystem>:
	UWORD tst=*(volatile UWORD*)&custom->dmaconr; //for compatiblity a1000
	(void)tst;
	while (*(volatile UWORD*)&custom->dmaconr&(1<<14)) {} //blitter busy wait
}

void TakeSystem() {
    4292:	       subq.l #8,sp
    4294:	       move.l a6,-(sp)
	KPrintF("TakeSystem: Run Forbid\n");
    4296:	       pea 8f23 <PutChar+0x12af>
    429c:	       jsr 725e <KPrintF>
    42a2:	       addq.l #4,sp
	Forbid();
    42a4:	       move.l d018 <SysBase>,d0
    42aa:	       movea.l d0,a6
    42ac:	       jsr -132(a6)
	//Save current interrupts and DMA settings so we can restore them upon exit. 
	KPrintF("TakeSystem: Saving Registers\n");
    42b0:	       pea 8f3b <PutChar+0x12c7>
    42b6:	       jsr 725e <KPrintF>
    42bc:	       addq.l #4,sp
	SystemADKCON=custom->adkconr;
    42be:	       movea.l d01c <custom>,a0
    42c4:	       move.w 16(a0),d0
    42c8:	       move.w d0,d03c <SystemADKCON>
	SystemInts=custom->intenar;
    42ce:	       movea.l d01c <custom>,a0
    42d4:	       move.w 28(a0),d0
    42d8:	       move.w d0,d038 <SystemInts>
	SystemDMA=custom->dmaconr;
    42de:	       movea.l d01c <custom>,a0
    42e4:	       move.w 2(a0),d0
    42e8:	       move.w d0,d03a <SystemDMA>
	ActiView=GfxBase->ActiView; //store current view
    42ee:	       movea.l d024 <GfxBase>,a0
    42f4:	       move.l 34(a0),d0
    42f8:	       move.l d0,d046 <ActiView>

	custom->intena=0x7fff;
    42fe:	       movea.l d01c <custom>,a0
    4304:	       move.w #32767,154(a0)
	custom->intena=0x8018;
    430a:	       movea.l d01c <custom>,a0
    4310:	       move.w #-32744,154(a0)
	KPrintF("TakeSystem: LoadView\n");
    4316:	       pea 8f59 <PutChar+0x12e5>
    431c:	       jsr 725e <KPrintF>
    4322:	       addq.l #4,sp
	LoadView(0);
    4324:	       clr.l 4(sp)
    4328:	       move.l d024 <GfxBase>,d0
    432e:	       movea.l d0,a6
    4330:	       movea.l 4(sp),a1
    4334:	       jsr -222(a6)
	KPrintF("TakeSystem: WaitTof\n");
    4338:	       pea 8f6f <PutChar+0x12fb>
    433e:	       jsr 725e <KPrintF>
    4344:	       addq.l #4,sp
	WaitTOF();
    4346:	       move.l d024 <GfxBase>,d0
    434c:	       movea.l d0,a6
    434e:	       jsr -270(a6)
	WaitTOF();
    4352:	       move.l d024 <GfxBase>,d0
    4358:	       movea.l d0,a6
    435a:	       jsr -270(a6)

	KPrintF("TakeSystem: WaitVBL\n");
    435e:	       pea 8f84 <PutChar+0x1310>
    4364:	       jsr 725e <KPrintF>
    436a:	       addq.l #4,sp
	WaitVbl();
    436c:	       jsr 71de <WaitVbl>
	WaitVbl();
    4372:	       jsr 71de <WaitVbl>

	KPrintF("TakeSystem: Doing Blitter Stuff\n");
    4378:	       pea 8f99 <PutChar+0x1325>
    437e:	       jsr 725e <KPrintF>
    4384:	       addq.l #4,sp
	OwnBlitter();
    4386:	       move.l d024 <GfxBase>,d0
    438c:	       movea.l d0,a6
    438e:	       jsr -456(a6)
	WaitBlit();	
    4392:	       move.l d024 <GfxBase>,d0
    4398:	       movea.l d0,a6
    439a:	       jsr -228(a6)
	Disable();
    439e:	       move.l d018 <SysBase>,d0
    43a4:	       movea.l d0,a6
    43a6:	       jsr -120(a6)
	
	//custom->intena=0x7fff;//disable all interrupts
	//custom->intreq=0x7fff;//Clear any interrupts that were pending
	
	KPrintF("TakeSystem: Clear DMA\n");
    43aa:	       pea 8fba <PutChar+0x1346>
    43b0:	       jsr 725e <KPrintF>
    43b6:	       addq.l #4,sp
	custom->dmacon=0x7fff;//Clear all DMA channels
    43b8:	       movea.l d01c <custom>,a0
    43be:	       move.w #32767,150(a0)

	KPrintF("TakeSystem: Set all colors to black\n");
    43c4:	       pea 8fd1 <PutChar+0x135d>
    43ca:	       jsr 725e <KPrintF>
    43d0:	       addq.l #4,sp
	//set all colors black
	for(int a=0;a<32;a++)
    43d2:	       clr.l 8(sp)
    43d6:	   ,-- bra.s 43f4 <TakeSystem+0x162>
		custom->color[a]=0;
    43d8:	,--|-> movea.l d01c <custom>,a0
    43de:	|  |   move.l 8(sp),d0
    43e2:	|  |   addi.l #192,d0
    43e8:	|  |   add.l d0,d0
    43ea:	|  |   move.w #0,(0,a0,d0.l)
	for(int a=0;a<32;a++)
    43f0:	|  |   addq.l #1,8(sp)
    43f4:	|  '-> moveq #31,d0
    43f6:	|      cmp.l 8(sp),d0
    43fa:	'----- bge.s 43d8 <TakeSystem+0x146>

	WaitVbl();
    43fc:	       jsr 71de <WaitVbl>
	WaitVbl();
    4402:	       jsr 71de <WaitVbl>

	KPrintF("TakeSystem: Save System interrupts\n");
    4408:	       pea 8ff6 <PutChar+0x1382>
    440e:	       jsr 725e <KPrintF>
    4414:	       addq.l #4,sp
	VBR=GetVBR();
    4416:	       jsr 4204 <GetVBR>
    441c:	       move.l d0,d03e <VBR>
	SystemIrq=GetInterruptHandler(); //store interrupt register*/
    4422:	       jsr 4286 <GetInterruptHandler>
    4428:	       move.l d0,d042 <SystemIrq>
}
    442e:	       nop
    4430:	       movea.l (sp)+,a6
    4432:	       addq.l #8,sp
    4434:	       rts

00004436 <FreeSystem>:

void FreeSystem() { 
    4436:	subq.l #4,sp
    4438:	move.l a6,-(sp)
	WaitVbl();
    443a:	jsr 71de <WaitVbl>
	WaitBlit();
    4440:	move.l d024 <GfxBase>,d0
    4446:	movea.l d0,a6
    4448:	jsr -228(a6)
	custom->intena=0x7fff;//disable all interrupts
    444c:	movea.l d01c <custom>,a0
    4452:	move.w #32767,154(a0)
	custom->intreq=0x7fff;//Clear any interrupts that were pending
    4458:	movea.l d01c <custom>,a0
    445e:	move.w #32767,156(a0)
	custom->dmacon=0x7fff;//Clear all DMA channels
    4464:	movea.l d01c <custom>,a0
    446a:	move.w #32767,150(a0)

	//restore interrupts
	SetInterruptHandler(SystemIrq);
    4470:	move.l d042 <SystemIrq>,d0
    4476:	move.l d0,-(sp)
    4478:	jsr 4274 <SetInterruptHandler>
    447e:	addq.l #4,sp

	/*Restore system copper list(s). */
	custom->cop1lc=(ULONG)GfxBase->copinit;
    4480:	movea.l d024 <GfxBase>,a0
    4486:	move.l 38(a0),d0
    448a:	movea.l d01c <custom>,a0
    4490:	move.l d0,128(a0)
	custom->cop2lc=(ULONG)GfxBase->LOFlist;
    4494:	movea.l d024 <GfxBase>,a0
    449a:	move.l 50(a0),d0
    449e:	movea.l d01c <custom>,a0
    44a4:	move.l d0,132(a0)
	custom->copjmp1=0x7fff; //start coppper
    44a8:	movea.l d01c <custom>,a0
    44ae:	move.w #32767,136(a0)

	/*Restore all interrupts and DMA settings. */
	//custom->intena=SystemInts|0x8000;
	custom->dmacon=SystemDMA|0x8000;
    44b4:	move.w d03a <SystemDMA>,d0
    44ba:	movea.l d01c <custom>,a0
    44c0:	ori.w #-32768,d0
    44c4:	move.w d0,150(a0)
	custom->adkcon=SystemADKCON|0x8000;
    44c8:	move.w d03c <SystemADKCON>,d0
    44ce:	movea.l d01c <custom>,a0
    44d4:	ori.w #-32768,d0
    44d8:	move.w d0,158(a0)

	WaitBlit();	
    44dc:	move.l d024 <GfxBase>,d0
    44e2:	movea.l d0,a6
    44e4:	jsr -228(a6)
	DisownBlitter();
    44e8:	move.l d024 <GfxBase>,d0
    44ee:	movea.l d0,a6
    44f0:	jsr -462(a6)
	Enable();
    44f4:	move.l d018 <SysBase>,d0
    44fa:	movea.l d0,a6
    44fc:	jsr -126(a6)

	LoadView(ActiView);
    4500:	move.l d046 <ActiView>,4(sp)
    4508:	move.l d024 <GfxBase>,d0
    450e:	movea.l d0,a6
    4510:	movea.l 4(sp),a1
    4514:	jsr -222(a6)
	WaitTOF();
    4518:	move.l d024 <GfxBase>,d0
    451e:	movea.l d0,a6
    4520:	jsr -270(a6)
	WaitTOF();
    4524:	move.l d024 <GfxBase>,d0
    452a:	movea.l d0,a6
    452c:	jsr -270(a6)

	Permit();
    4530:	move.l d018 <SysBase>,d0
    4536:	movea.l d0,a6
    4538:	jsr -138(a6)
}
    453c:	nop
    453e:	movea.l (sp)+,a6
    4540:	addq.l #4,sp
    4542:	rts

00004544 <main>:
static void Wait10() { WaitLine(0x10); }
static void Wait11() { WaitLine(0x11); }
static void Wait12() { WaitLine(0x12); }
static void Wait13() { WaitLine(0x13); }

int main(int argc, char *argv[]) {
    4544:	       lea -132(sp),sp
    4548:	       movem.l d2-d3/a6,-(sp)

	//int *bp = 0x200;
  	//*bp = 0;

	for(int i=0;i<1000;i++) {
    454c:	       clr.l 140(sp)
    4550:	   ,-- bra.s 4556 <main+0x12>
    4552:	,--|-> addq.l #1,140(sp)
    4556:	|  '-> cmpi.l #999,140(sp)
    455e:	'----- ble.s 4552 <main+0xe>

	}

	SysBase = *((struct ExecBase**)4UL);
    4560:	       movea.w #4,a0
    4564:	       move.l (a0),d0
    4566:	       move.l d0,d018 <SysBase>
	custom = (struct Custom*)0xdff000;	
    456c:	       move.l #14675968,d01c <custom>


	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR)"graphics.library",0);
    4576:	       move.l #36890,136(sp)
    457e:	       clr.l 132(sp)
    4582:	       move.l d018 <SysBase>,d0
    4588:	       movea.l d0,a6
    458a:	       movea.l 136(sp),a1
    458e:	       move.l 132(sp),d0
    4592:	       jsr -552(a6)
    4596:	       move.l d0,128(sp)
    459a:	       move.l 128(sp),d0
    459e:	       move.l d0,d024 <GfxBase>
	if (!GfxBase)
    45a4:	       move.l d024 <GfxBase>,d0
    45aa:	   ,-- bne.s 45c0 <main+0x7c>
		Exit(0);
    45ac:	   |   clr.l 124(sp)
    45b0:	   |   move.l d020 <DOSBase>,d0
    45b6:	   |   movea.l d0,a6
    45b8:	   |   move.l 124(sp),d1
    45bc:	   |   jsr -144(a6)

	// used for printing
	DOSBase = (struct DosLibrary*)OpenLibrary((CONST_STRPTR)"dos.library", 0);
    45c0:	   '-> move.l #36907,120(sp)
    45c8:	       clr.l 116(sp)
    45cc:	       move.l d018 <SysBase>,d0
    45d2:	       movea.l d0,a6
    45d4:	       movea.l 120(sp),a1
    45d8:	       move.l 116(sp),d0
    45dc:	       jsr -552(a6)
    45e0:	       move.l d0,112(sp)
    45e4:	       move.l 112(sp),d0
    45e8:	       move.l d0,d020 <DOSBase>
	if (!DOSBase)
    45ee:	       move.l d020 <DOSBase>,d0
    45f4:	   ,-- bne.s 460a <main+0xc6>
		Exit(0);
    45f6:	   |   clr.l 108(sp)
    45fa:	   |   move.l d020 <DOSBase>,d0
    4600:	   |   movea.l d0,a6
    4602:	   |   move.l 108(sp),d1
    4606:	   |   jsr -144(a6)

	MathIeeeSingBasBase = (struct MathIEEEBase *) OpenLibrary("mathieeesingbas.library", 0);	
    460a:	   '-> move.l #36919,104(sp)
    4612:	       clr.l 100(sp)
    4616:	       move.l d018 <SysBase>,d0
    461c:	       movea.l d0,a6
    461e:	       movea.l 104(sp),a1
    4622:	       move.l 100(sp),d0
    4626:	       jsr -552(a6)
    462a:	       move.l d0,96(sp)
    462e:	       move.l 96(sp),d0
    4632:	       move.l d0,d028 <MathIeeeSingBasBase>
	if (!MathIeeeSingBasBase)
    4638:	       move.l d028 <MathIeeeSingBasBase>,d0
    463e:	   ,-- bne.s 4654 <main+0x110>
		Exit(0);	
    4640:	   |   clr.l 92(sp)
    4644:	   |   move.l d020 <DOSBase>,d0
    464a:	   |   movea.l d0,a6
    464c:	   |   move.l 92(sp),d1
    4650:	   |   jsr -144(a6)

	MathIeeeSingTransBase = (struct MathIEEEBase *) OpenLibrary("mathieeesingtrans.library",0);													
    4654:	   '-> move.l #36943,88(sp)
    465c:	       clr.l 84(sp)
    4660:	       move.l d018 <SysBase>,d0
    4666:	       movea.l d0,a6
    4668:	       movea.l 88(sp),a1
    466c:	       move.l 84(sp),d0
    4670:	       jsr -552(a6)
    4674:	       move.l d0,80(sp)
    4678:	       move.l 80(sp),d0
    467c:	       move.l d0,d02c <MathIeeeSingTransBase>
	if (!MathIeeeSingTransBase)
    4682:	       move.l d02c <MathIeeeSingTransBase>,d0
    4688:	   ,-- bne.s 469e <main+0x15a>
		Exit(0);
    468a:	   |   clr.l 76(sp)
    468e:	   |   move.l d020 <DOSBase>,d0
    4694:	   |   movea.l d0,a6
    4696:	   |   move.l 76(sp),d1
    469a:	   |   jsr -144(a6)

	MathIeeeDoubTransBase =  (struct MathIEEEBase *) OpenLibrary("mathieeedoubtrans.library",0);
    469e:	   '-> move.l #36969,72(sp)
    46a6:	       clr.l 68(sp)
    46aa:	       move.l d018 <SysBase>,d0
    46b0:	       movea.l d0,a6
    46b2:	       movea.l 72(sp),a1
    46b6:	       move.l 68(sp),d0
    46ba:	       jsr -552(a6)
    46be:	       move.l d0,64(sp)
    46c2:	       move.l 64(sp),d0
    46c6:	       move.l d0,d034 <MathIeeeDoubTransBase>
	if (!MathIeeeDoubTransBase)		
    46cc:	       move.l d034 <MathIeeeDoubTransBase>,d0
    46d2:	   ,-- bne.s 46e8 <main+0x1a4>
		Exit(0);
    46d4:	   |   clr.l 60(sp)
    46d8:	   |   move.l d020 <DOSBase>,d0
    46de:	   |   movea.l d0,a6
    46e0:	   |   move.l 60(sp),d1
    46e4:	   |   jsr -144(a6)

	MathIeeeDoubBasBase = (struct MathIEEEBase *) OpenLibrary("mathieeedoubbas.library",0);
    46e8:	   '-> move.l #36995,56(sp)
    46f0:	       clr.l 52(sp)
    46f4:	       move.l d018 <SysBase>,d0
    46fa:	       movea.l d0,a6
    46fc:	       movea.l 56(sp),a1
    4700:	       move.l 52(sp),d0
    4704:	       jsr -552(a6)
    4708:	       move.l d0,48(sp)
    470c:	       move.l 48(sp),d0
    4710:	       move.l d0,d030 <MathIeeeDoubBasBase>
	if( !MathIeeeDoubBasBase) 
    4716:	       move.l d030 <MathIeeeDoubBasBase>,d0
    471c:	   ,-- bne.s 4732 <main+0x1ee>
		Exit(0);
    471e:	   |   clr.l 44(sp)
    4722:	   |   move.l d020 <DOSBase>,d0
    4728:	   |   movea.l d0,a6
    472a:	   |   move.l 44(sp),d1
    472e:	   |   jsr -144(a6)
	

	KPrintF(" debugger from Amiga Test 035!\n");
    4732:	   '-> pea 909b <PutChar+0x1427>
    4738:	       jsr 725e <KPrintF>
    473e:	       addq.l #4,sp

	Write(Output(), (APTR)"Hello console Test 035!\n", 25);
    4740:	       move.l d020 <DOSBase>,d0
    4746:	       movea.l d0,a6
    4748:	       jsr -60(a6)
    474c:	       move.l d0,40(sp)
    4750:	       move.l 40(sp),d0
    4754:	       move.l d0,36(sp)
    4758:	       move.l #37051,32(sp)
    4760:	       moveq #25,d0
    4762:	       move.l d0,28(sp)
    4766:	       move.l d020 <DOSBase>,d0
    476c:	       movea.l d0,a6
    476e:	       move.l 36(sp),d1
    4772:	       move.l 32(sp),d2
    4776:	       move.l 28(sp),d3
    477a:	       jsr -48(a6)
    477e:	       move.l d0,24(sp)
	Delay(50);
    4782:	       moveq #50,d0
    4784:	       move.l d0,20(sp)
    4788:	       move.l d020 <DOSBase>,d0
    478e:	       movea.l d0,a6
    4790:	       move.l 20(sp),d1
    4794:	       jsr -198(a6)
		KPrintF("p61Init failed!\n");
#endif
	warpmode(0);*/


	KPrintF("Taking System\n");
    4798:	       pea 90d4 <PutChar+0x1460>
    479e:	       jsr 725e <KPrintF>
    47a4:	       addq.l #4,sp
	TakeSystem();
    47a6:	       jsr 4292 <TakeSystem>
	KPrintF("System Taken\n");
    47ac:	       pea 90e3 <PutChar+0x146f>
    47b2:	       jsr 725e <KPrintF>
    47b8:	       addq.l #4,sp

	custom->dmacon = 0x87ff;
    47ba:	       movea.l d01c <custom>,a0
    47c0:	       move.w #-30721,150(a0)
	WaitVbl();
    47c6:	       jsr 71de <WaitVbl>

	KPrintF("Starting main_sludge\n");
    47cc:	       pea 90f1 <PutChar+0x147d>
    47d2:	       jsr 725e <KPrintF>
    47d8:	       addq.l #4,sp
	main_sludge(argc, argv);	
    47da:	       move.l 152(sp),-(sp)
    47de:	       move.l 152(sp),-(sp)
    47e2:	       jsr 2624 <main_sludge>
    47e8:	       addq.l #8,sp
#ifdef MUSIC
	p61End();
#endif

	// END
	FreeSystem();
    47ea:	       jsr 4436 <FreeSystem>

	CloseLibrary((struct Library*)DOSBase);
    47f0:	       move.l d020 <DOSBase>,16(sp)
    47f8:	       move.l d018 <SysBase>,d0
    47fe:	       movea.l d0,a6
    4800:	       movea.l 16(sp),a1
    4804:	       jsr -414(a6)
	CloseLibrary((struct Library*)GfxBase);
    4808:	       move.l d024 <GfxBase>,12(sp)
    4810:	       move.l d018 <SysBase>,d0
    4816:	       movea.l d0,a6
    4818:	       movea.l 12(sp),a1
    481c:	       jsr -414(a6)
    4820:	       moveq #0,d0
}
    4822:	       movem.l (sp)+,d2-d3/a6
    4826:	       lea 132(sp),sp
    482a:	       rts

0000482c <initStatusBar>:
	}
	nowStatus -> firstStatusBar = NULL;
}

void initStatusBar () {
	mainStatus.firstStatusBar = NULL;
    482c:	clr.l d04a <mainStatus>
	mainStatus.alignStatus = IN_THE_CENTRE;
    4832:	move.w #-1,d04e <mainStatus+0x4>
	mainStatus.litStatus = -1;
    483a:	moveq #-1,d0
    483c:	move.l d0,d050 <mainStatus+0x6>
	mainStatus.statusX = 10;
    4842:	moveq #10,d0
    4844:	move.l d0,d054 <mainStatus+0xa>
	mainStatus.statusY = winHeight - 15;
    484a:	movea.l cf8a <winHeight>,a0
    4850:	lea -15(a0),a0
    4854:	move.l a0,d0
    4856:	move.l d0,d058 <mainStatus+0xe>
	//statusBarColour (255, 255, 255); Amiga Todo: Amigize this
	//statusBarLitColour (255, 255, 128); Amiga Todo: Amigize this
}
    485c:	nop
    485e:	rts

00004860 <positionStatus>:
	}
	return TRUE;
}

void positionStatus (int x, int y) {
	nowStatus -> statusX = x;
    4860:	movea.l cf38 <nowStatus>,a0
    4866:	move.l 4(sp),10(a0)
	nowStatus -> statusY = y;
    486c:	movea.l cf38 <nowStatus>,a0
    4872:	move.l 8(sp),14(a0)
}
    4878:	nop
    487a:	rts

0000487c <killZBuffer>:
	createthis->bitplane = AllocVec( size, MEMF_CHIP);
	CstCreateZBufferLayer (createthis->bitplane, x, y, width, height);

}

void killZBuffer () {
    487c:	       lea -16(sp),sp
    4880:	       move.l a6,-(sp)
	struct zBufferData *zbuffercursor =  zBuffer;
    4882:	       move.l d074 <zBuffer>,16(sp)

	while(zbuffercursor) {
    488a:	   ,-- bra.s 48cc <killZBuffer+0x50>
		struct zBufferData *deleteme = zbuffercursor;
    488c:	,--|-> move.l 16(sp),12(sp)
		zbuffercursor = zbuffercursor->nextPanel;
    4892:	|  |   movea.l 16(sp),a0
    4896:	|  |   move.l 24(a0),16(sp)
		FreeVec(deleteme->bitplane);
    489c:	|  |   movea.l 12(sp),a0
    48a0:	|  |   move.l 20(a0),8(sp)
    48a6:	|  |   move.l d018 <SysBase>,d0
    48ac:	|  |   movea.l d0,a6
    48ae:	|  |   movea.l 8(sp),a1
    48b2:	|  |   jsr -690(a6)
		FreeVec(deleteme);
    48b6:	|  |   move.l 12(sp),4(sp)
    48bc:	|  |   move.l d018 <SysBase>,d0
    48c2:	|  |   movea.l d0,a6
    48c4:	|  |   movea.l 4(sp),a1
    48c8:	|  |   jsr -690(a6)
	while(zbuffercursor) {
    48cc:	|  '-> tst.l 16(sp)
    48d0:	'----- bne.s 488c <killZBuffer+0x10>
	}
	zBuffer = NULL;
    48d2:	       clr.l d074 <zBuffer>
}
    48d8:	       nop
    48da:	       movea.l (sp)+,a6
    48dc:	       lea 16(sp),sp
    48e0:	       rts

000048e2 <forgetSpriteBank>:
extern int cameraX, cameraY;
extern struct inputType input;


void forgetSpriteBank (struct loadedSpriteBank * forgetme)
{			
    48e2:	          lea -32(sp),sp
    48e6:	          move.l a6,-(sp)
	struct spriteBank *spritebanktoforget = &forgetme->bank;
    48e8:	          move.l 40(sp),d0
    48ec:	          addq.l #8,d0
    48ee:	          move.l d0,24(sp)
	
	for (int i = 0; i < spritebanktoforget->total; i++) {
    48f2:	          clr.l 32(sp)
    48f6:	   ,----- bra.s 493c <forgetSpriteBank+0x5a>
		struct sprite *cursprite = &spritebanktoforget->sprites[i];		
    48f8:	,--|----> movea.l 24(sp),a0
    48fc:	|  |      movea.l 8(a0),a0
    4900:	|  |      move.l 32(sp),d1
    4904:	|  |      move.l d1,d0
    4906:	|  |      lsl.l #3,d0
    4908:	|  |      sub.l d1,d0
    490a:	|  |      add.l d0,d0
    490c:	|  |      add.l d0,d0
    490e:	|  |      adda.l d0,a0
    4910:	|  |      move.l a0,8(sp)
		if(cursprite->data) {		
    4914:	|  |      movea.l 8(sp),a0
    4918:	|  |      move.l 24(a0),d0
    491c:	|  |  ,-- beq.s 4938 <forgetSpriteBank+0x56>
			FreeVec(cursprite->data);			
    491e:	|  |  |   movea.l 8(sp),a0
    4922:	|  |  |   move.l 24(a0),4(sp)
    4928:	|  |  |   move.l d018 <SysBase>,d0
    492e:	|  |  |   movea.l d0,a6
    4930:	|  |  |   movea.l 4(sp),a1
    4934:	|  |  |   jsr -690(a6)
	for (int i = 0; i < spritebanktoforget->total; i++) {
    4938:	|  |  '-> addq.l #1,32(sp)
    493c:	|  '----> movea.l 24(sp),a0
    4940:	|         move.l (a0),d0
    4942:	|         cmp.l 32(sp),d0
    4946:	'-------- bgt.s 48f8 <forgetSpriteBank+0x16>
		}		
	}

	FreeVec(spritebanktoforget->sprites);	
    4948:	          movea.l 24(sp),a0
    494c:	          move.l 8(a0),20(sp)
    4952:	          move.l d018 <SysBase>,d0
    4958:	          movea.l d0,a6
    495a:	          movea.l 20(sp),a1
    495e:	          jsr -690(a6)
	
	
	struct loadedSpriteBank *precedingbank = allLoadedBanks;
    4962:	          move.l d0e6 <allLoadedBanks>,28(sp)
	
	while(precedingbank->next->ID != forgetme->ID && precedingbank != NULL)
    496a:	      ,-- bra.s 4976 <forgetSpriteBank+0x94>
	{
		precedingbank = precedingbank->next;
    496c:	   ,--|-> movea.l 28(sp),a0
    4970:	   |  |   move.l 22(a0),28(sp)
	while(precedingbank->next->ID != forgetme->ID && precedingbank != NULL)
    4976:	   |  '-> movea.l 28(sp),a0
    497a:	   |      movea.l 22(a0),a0
    497e:	   |      move.l (a0),d1
    4980:	   |      movea.l 40(sp),a0
    4984:	   |      move.l (a0),d0
    4986:	   |      cmp.l d1,d0
    4988:	   |  ,-- beq.s 4990 <forgetSpriteBank+0xae>
    498a:	   |  |   tst.l 28(sp)
    498e:	   '--|-- bne.s 496c <forgetSpriteBank+0x8a>
	}	

	if(precedingbank)
    4990:	      '-> tst.l 28(sp)
    4994:	   ,----- beq.s 49be <forgetSpriteBank+0xdc>
	{
		//Forget element in the middle of the chain or the last one
		precedingbank->next = forgetme->next;
    4996:	   |      movea.l 40(sp),a0
    499a:	   |      move.l 22(a0),d0
    499e:	   |      movea.l 28(sp),a0
    49a2:	   |      move.l d0,22(a0)
		FreeVec( forgetme);
    49a6:	   |      move.l 40(sp),12(sp)
    49ac:	   |      move.l d018 <SysBase>,d0
    49b2:	   |      movea.l d0,a6
    49b4:	   |      movea.l 12(sp),a1
    49b8:	   |      jsr -690(a6)
	{
		//Forget first element in the chain
		allLoadedBanks = allLoadedBanks->next;
		FreeVec( forgetme);
	}	
}
    49bc:	   |  ,-- bra.s 49e4 <forgetSpriteBank+0x102>
		allLoadedBanks = allLoadedBanks->next;
    49be:	   '--|-> movea.l d0e6 <allLoadedBanks>,a0
    49c4:	      |   move.l 22(a0),d0
    49c8:	      |   move.l d0,d0e6 <allLoadedBanks>
		FreeVec( forgetme);
    49ce:	      |   move.l 40(sp),16(sp)
    49d4:	      |   move.l d018 <SysBase>,d0
    49da:	      |   movea.l d0,a6
    49dc:	      |   movea.l 16(sp),a1
    49e0:	      |   jsr -690(a6)
}
    49e4:	      '-> nop
    49e6:	          movea.l (sp)+,a6
    49e8:	          lea 32(sp),sp
    49ec:	          rts

000049ee <scaleSprite>:
	KPrintF("loadSpriteBank: Complete\n");
	return TRUE;
}

BOOL scaleSprite (struct sprite *single, struct onScreenPerson * thisPerson, BOOL mirror) 
{
    49ee:	                   lea -16(sp),sp
    49f2:	                   move.l d2,-(sp)
    49f4:	                   move.l 32(sp),d0
    49f8:	                   move.w d0,d0
    49fa:	                   move.w d0,6(sp)
	WORD x =  thisPerson->x - single->xhot;
    49fe:	                   movea.l 28(sp),a0
    4a02:	                   move.l (a0),d2
    4a04:	                   movea.l 24(sp),a0
    4a08:	                   move.l 8(a0),d0
    4a0c:	                   move.l d0,-(sp)
    4a0e:	                   jsr 7690 <__floatsisf>
    4a14:	                   addq.l #4,sp
    4a16:	                   move.l d0,-(sp)
    4a18:	                   move.l d2,-(sp)
    4a1a:	                   jsr 7926 <__subsf3>
    4a20:	                   addq.l #8,sp
    4a22:	                   move.l d0,-(sp)
    4a24:	                   jsr 7628 <__fixsfsi>
    4a2a:	                   addq.l #4,sp
    4a2c:	                   move.w d0,18(sp)
	WORD y =  thisPerson->y - single->yhot;			
    4a30:	                   movea.l 28(sp),a0
    4a34:	                   move.l 4(a0),d2
    4a38:	                   movea.l 24(sp),a0
    4a3c:	                   move.l 12(a0),d0
    4a40:	                   move.l d0,-(sp)
    4a42:	                   jsr 7690 <__floatsisf>
    4a48:	                   addq.l #4,sp
    4a4a:	                   move.l d0,-(sp)
    4a4c:	                   move.l d2,-(sp)
    4a4e:	                   jsr 7926 <__subsf3>
    4a54:	                   addq.l #8,sp
    4a56:	                   move.l d0,-(sp)
    4a58:	                   jsr 7628 <__fixsfsi>
    4a5e:	                   addq.l #4,sp
    4a60:	                   move.w d0,8(sp)

	if( x < 0)
    4a64:	                   tst.w 18(sp)
    4a68:	               ,-- bge.s 4a9c <scaleSprite+0xae>
	{
		x = thisPerson->x - single->xhot;
    4a6a:	               |   movea.l 28(sp),a0
    4a6e:	               |   move.l (a0),d2
    4a70:	               |   movea.l 24(sp),a0
    4a74:	               |   move.l 8(a0),d0
    4a78:	               |   move.l d0,-(sp)
    4a7a:	               |   jsr 7690 <__floatsisf>
    4a80:	               |   addq.l #4,sp
    4a82:	               |   move.l d0,-(sp)
    4a84:	               |   move.l d2,-(sp)
    4a86:	               |   jsr 7926 <__subsf3>
    4a8c:	               |   addq.l #8,sp
    4a8e:	               |   move.l d0,-(sp)
    4a90:	               |   jsr 7628 <__fixsfsi>
    4a96:	               |   addq.l #4,sp
    4a98:	               |   move.w d0,18(sp)
	}

	CstScaleSprite( single, thisPerson, x, y,SCREEN);
    4a9c:	               '-> movea.w 8(sp),a1
    4aa0:	                   movea.w 18(sp),a0
    4aa4:	                   pea 1 <_start+0x1>
    4aa8:	                   move.l a1,-(sp)
    4aaa:	                   move.l a0,-(sp)
    4aac:	                   move.l 40(sp),-(sp)
    4ab0:	                   move.l 40(sp),-(sp)
    4ab4:	                   jsr 1554 <CstScaleSprite>
    4aba:	                   lea 20(sp),sp

	UWORD x1, y1, x2, y2;

	if (thisPerson -> extra & EXTRA_FIXTOSCREEN) {
    4abe:	                   movea.l 28(sp),a0
    4ac2:	                   move.l 118(a0),d0
    4ac6:	                   moveq #8,d1
    4ac8:	                   and.l d1,d0
    4aca:	   ,-------------- beq.w 4b96 <scaleSprite+0x1a8>
		if (single->xhot < 0)
    4ace:	   |               movea.l 24(sp),a0
    4ad2:	   |               move.l 8(a0),d0
    4ad6:	   |  ,----------- bpl.s 4b12 <scaleSprite+0x124>
			x1 = x - (int)(mirror ? single->width - single->xhot : single->xhot+1);
    4ad8:	   |  |            move.w 18(sp),d0
    4adc:	   |  |            tst.w 6(sp)
    4ae0:	   |  |     ,----- beq.s 4afa <scaleSprite+0x10c>
    4ae2:	   |  |     |      movea.l 24(sp),a0
    4ae6:	   |  |     |      move.l (a0),d1
    4ae8:	   |  |     |      move.l d1,d2
    4aea:	   |  |     |      movea.l 24(sp),a0
    4aee:	   |  |     |      move.l 8(a0),d1
    4af2:	   |  |     |      move.l d1,d1
    4af4:	   |  |     |      movea.w d2,a0
    4af6:	   |  |     |      suba.w d1,a0
    4af8:	   |  |     |  ,-- bra.s 4b08 <scaleSprite+0x11a>
    4afa:	   |  |     '--|-> movea.l 24(sp),a0
    4afe:	   |  |        |   move.l 8(a0),d1
    4b02:	   |  |        |   move.l d1,d1
    4b04:	   |  |        |   movea.w d1,a0
    4b06:	   |  |        |   addq.w #1,a0
    4b08:	   |  |        '-> move.w d0,d1
    4b0a:	   |  |            sub.w a0,d1
    4b0c:	   |  |            move.w d1,16(sp)
    4b10:	   |  |  ,-------- bra.s 4b4a <scaleSprite+0x15c>
		else
			x1 = x - (int)(mirror ? single->width - (single->xhot+1) : single->xhot);
    4b12:	   |  '--|-------> move.w 18(sp),d1
    4b16:	   |     |         tst.w 6(sp)
    4b1a:	   |     |  ,----- beq.s 4b38 <scaleSprite+0x14a>
    4b1c:	   |     |  |      movea.l 24(sp),a0
    4b20:	   |     |  |      move.l (a0),d0
    4b22:	   |     |  |      move.l d0,d2
    4b24:	   |     |  |      movea.l 24(sp),a0
    4b28:	   |     |  |      move.l 8(a0),d0
    4b2c:	   |     |  |      move.l d0,d0
    4b2e:	   |     |  |      movea.w d2,a0
    4b30:	   |     |  |      suba.w d0,a0
    4b32:	   |     |  |      move.w a0,d0
    4b34:	   |     |  |      subq.w #1,d0
    4b36:	   |     |  |  ,-- bra.s 4b42 <scaleSprite+0x154>
    4b38:	   |     |  '--|-> movea.l 24(sp),a0
    4b3c:	   |     |     |   move.l 8(a0),d0
    4b40:	   |     |     |   move.l d0,d0
    4b42:	   |     |     '-> movea.w d1,a0
    4b44:	   |     |         suba.w d0,a0
    4b46:	   |     |         move.w a0,16(sp)
		
		y1 = y - (single->yhot - thisPerson->floaty);
    4b4a:	   |     '-------> movea.l 28(sp),a0
    4b4e:	   |               move.l 24(a0),d0
    4b52:	   |               move.l d0,d1
    4b54:	   |               movea.l 24(sp),a0
    4b58:	   |               move.l 12(a0),d0
    4b5c:	   |               move.l d0,d0
    4b5e:	   |               sub.w d0,d1
    4b60:	   |               move.w 8(sp),d0
    4b64:	   |               movea.w d1,a0
    4b66:	   |               adda.w d0,a0
    4b68:	   |               move.w a0,14(sp)
		x2 = x1 + single->width;
    4b6c:	   |               movea.l 24(sp),a0
    4b70:	   |               move.l (a0),d0
    4b72:	   |               move.l d0,d0
    4b74:	   |               move.w 16(sp),d1
    4b78:	   |               add.w d0,d1
    4b7a:	   |               move.w d1,12(sp)
		y2 = y1 + single->height;
    4b7e:	   |               movea.l 24(sp),a0
    4b82:	   |               move.l 4(a0),d0
    4b86:	   |               move.l d0,d0
    4b88:	   |               movea.w 14(sp),a0
    4b8c:	   |               adda.w d0,a0
    4b8e:	   |               move.w a0,10(sp)
    4b92:	,--|-------------- bra.w 4c7e <scaleSprite+0x290>
	} else {
		x -= cameraX;
    4b96:	|  '-------------> move.w 18(sp),d1
    4b9a:	|                  move.l d0b6 <cameraX>,d0
    4ba0:	|                  move.l d0,d0
    4ba2:	|                  sub.w d0,d1
    4ba4:	|                  move.w d1,18(sp)
		y -= cameraY;
    4ba8:	|                  move.w 8(sp),d1
    4bac:	|                  move.l d0ba <cameraY>,d0
    4bb2:	|                  move.l d0,d0
    4bb4:	|                  sub.w d0,d1
    4bb6:	|                  move.w d1,8(sp)
		if (single->xhot < 0)
    4bba:	|                  movea.l 24(sp),a0
    4bbe:	|                  move.l 8(a0),d0
    4bc2:	|     ,----------- bpl.s 4bfe <scaleSprite+0x210>
			x1 = x - (int)(mirror ? single->width - single->xhot : single->xhot+1);
    4bc4:	|     |            move.w 18(sp),d0
    4bc8:	|     |            tst.w 6(sp)
    4bcc:	|     |     ,----- beq.s 4be6 <scaleSprite+0x1f8>
    4bce:	|     |     |      movea.l 24(sp),a0
    4bd2:	|     |     |      move.l (a0),d1
    4bd4:	|     |     |      move.l d1,d2
    4bd6:	|     |     |      movea.l 24(sp),a0
    4bda:	|     |     |      move.l 8(a0),d1
    4bde:	|     |     |      move.l d1,d1
    4be0:	|     |     |      movea.w d2,a0
    4be2:	|     |     |      suba.w d1,a0
    4be4:	|     |     |  ,-- bra.s 4bf4 <scaleSprite+0x206>
    4be6:	|     |     '--|-> movea.l 24(sp),a0
    4bea:	|     |        |   move.l 8(a0),d1
    4bee:	|     |        |   move.l d1,d1
    4bf0:	|     |        |   movea.w d1,a0
    4bf2:	|     |        |   addq.w #1,a0
    4bf4:	|     |        '-> move.w d0,d1
    4bf6:	|     |            sub.w a0,d1
    4bf8:	|     |            move.w d1,16(sp)
    4bfc:	|     |  ,-------- bra.s 4c36 <scaleSprite+0x248>
		else
			x1 = x - (int)(mirror ? single->width - (single->xhot+1) : single->xhot);
    4bfe:	|     '--|-------> move.w 18(sp),d1
    4c02:	|        |         tst.w 6(sp)
    4c06:	|        |  ,----- beq.s 4c24 <scaleSprite+0x236>
    4c08:	|        |  |      movea.l 24(sp),a0
    4c0c:	|        |  |      move.l (a0),d0
    4c0e:	|        |  |      move.l d0,d2
    4c10:	|        |  |      movea.l 24(sp),a0
    4c14:	|        |  |      move.l 8(a0),d0
    4c18:	|        |  |      move.l d0,d0
    4c1a:	|        |  |      movea.w d2,a0
    4c1c:	|        |  |      suba.w d0,a0
    4c1e:	|        |  |      move.w a0,d0
    4c20:	|        |  |      subq.w #1,d0
    4c22:	|        |  |  ,-- bra.s 4c2e <scaleSprite+0x240>
    4c24:	|        |  '--|-> movea.l 24(sp),a0
    4c28:	|        |     |   move.l 8(a0),d0
    4c2c:	|        |     |   move.l d0,d0
    4c2e:	|        |     '-> movea.w d1,a0
    4c30:	|        |         suba.w d0,a0
    4c32:	|        |         move.w a0,16(sp)
		
		y1 = y - (single->yhot - thisPerson->floaty);
    4c36:	|        '-------> movea.l 28(sp),a0
    4c3a:	|                  move.l 24(a0),d0
    4c3e:	|                  move.l d0,d1
    4c40:	|                  movea.l 24(sp),a0
    4c44:	|                  move.l 12(a0),d0
    4c48:	|                  move.l d0,d0
    4c4a:	|                  sub.w d0,d1
    4c4c:	|                  move.w 8(sp),d0
    4c50:	|                  movea.w d1,a0
    4c52:	|                  adda.w d0,a0
    4c54:	|                  move.w a0,14(sp)
		x2 = x1 + single->width;
    4c58:	|                  movea.l 24(sp),a0
    4c5c:	|                  move.l (a0),d0
    4c5e:	|                  move.l d0,d0
    4c60:	|                  move.w 16(sp),d1
    4c64:	|                  add.w d0,d1
    4c66:	|                  move.w d1,12(sp)
		y2 = y1 + single->height;
    4c6a:	|                  movea.l 24(sp),a0
    4c6e:	|                  move.l 4(a0),d0
    4c72:	|                  move.l d0,d0
    4c74:	|                  movea.w 14(sp),a0
    4c78:	|                  adda.w d0,a0
    4c7a:	|                  move.w a0,10(sp)
	}

	if (input.mouseX >= x1 && input.mouseX <= x2 && input.mouseY >= y1 && input.mouseY <= y2) {
    4c7e:	'----------------> move.l cfd8 <input+0xa>,d1
    4c84:	                   moveq #0,d0
    4c86:	                   move.w 16(sp),d0
    4c8a:	                   cmp.l d1,d0
    4c8c:	            ,----- bgt.s 4cc2 <scaleSprite+0x2d4>
    4c8e:	            |      move.l cfd8 <input+0xa>,d1
    4c94:	            |      moveq #0,d0
    4c96:	            |      move.w 12(sp),d0
    4c9a:	            |      cmp.l d1,d0
    4c9c:	            +----- blt.s 4cc2 <scaleSprite+0x2d4>
    4c9e:	            |      move.l cfdc <input+0xe>,d1
    4ca4:	            |      moveq #0,d0
    4ca6:	            |      move.w 14(sp),d0
    4caa:	            |      cmp.l d1,d0
    4cac:	            +----- bgt.s 4cc2 <scaleSprite+0x2d4>
    4cae:	            |      move.l cfdc <input+0xe>,d1
    4cb4:	            |      moveq #0,d0
    4cb6:	            |      move.w 10(sp),d0
    4cba:	            |      cmp.l d1,d0
    4cbc:	            +----- blt.s 4cc2 <scaleSprite+0x2d4>
		return TRUE;
    4cbe:	            |      moveq #1,d0
    4cc0:	            |  ,-- bra.s 4cc4 <scaleSprite+0x2d6>
	}
	return FALSE;
    4cc2:	            '--|-> clr.w d0
    4cc4:	               '-> move.l (sp)+,d2
    4cc6:	                   lea 16(sp),sp
    4cca:	                   rts

00004ccc <TF_abs>:

short int scaleHorizon = 75;
short int scaleDivide = 150;

int TF_abs (int a) {
	return (a > 0) ? a : -a;
    4ccc:	    move.l 4(sp),d0
    4cd0:	,-- bpl.s 4cd4 <TF_abs+0x8>
    4cd2:	|   neg.l d0
}
    4cd4:	'-> rts

00004cd6 <copyAnim>:
		thisPerson = thisPerson->next;
	}
}


struct personaAnimation * copyAnim (struct personaAnimation * orig) {
    4cd6:	             lea -36(sp),sp
    4cda:	             move.l a6,-(sp)
	int num = orig -> numFrames;
    4cdc:	             movea.l 44(sp),a0
    4ce0:	             move.l 8(a0),32(sp)


	struct personaAnimation * newAnim	= AllocVec(sizeof( struct personaAnimation), MEMF_ANY);
    4ce6:	             moveq #12,d0
    4ce8:	             move.l d0,28(sp)
    4cec:	             clr.l 24(sp)
    4cf0:	             move.l d018 <SysBase>,d0
    4cf6:	             movea.l d0,a6
    4cf8:	             move.l 28(sp),d0
    4cfc:	             move.l 24(sp),d1
    4d00:	             jsr -684(a6)
    4d04:	             move.l d0,20(sp)
    4d08:	             move.l 20(sp),d0
    4d0c:	             move.l d0,16(sp)
	if (!(newAnim)) {
    4d10:	         ,-- bne.s 4d26 <copyAnim+0x50>
		KPrintF("copyAnim: Cannot allocate memory");
    4d12:	         |   pea 9258 <PutChar+0x15e4>
    4d18:	         |   jsr 725e <KPrintF>
    4d1e:	         |   addq.l #4,sp
		return NULL;
    4d20:	         |   moveq #0,d0
    4d22:	,--------|-- bra.w 4e78 <copyAnim+0x1a2>
	}

	// Copy the easy bits...
	newAnim -> theSprites		= orig -> theSprites;
    4d26:	|        '-> movea.l 44(sp),a0
    4d2a:	|            move.l (a0),d0
    4d2c:	|            movea.l 16(sp),a0
    4d30:	|            move.l d0,(a0)
	newAnim -> theSprites ->timesUsed++;
    4d32:	|            movea.l 16(sp),a0
    4d36:	|            movea.l (a0),a0
    4d38:	|            move.l 4(a0),d0
    4d3c:	|            addq.l #1,d0
    4d3e:	|            move.l d0,4(a0)
	newAnim -> numFrames		= num;
    4d42:	|            movea.l 16(sp),a0
    4d46:	|            move.l 32(sp),8(a0)

	if (num) {
    4d4c:	|  ,-------- beq.w 4e6c <copyAnim+0x196>

		// Argh! Frames! We need a whole NEW array of animFrame structures...

		newAnim->frames = AllocVec(sizeof(struct animFrame) * num, MEMF_ANY);
    4d50:	|  |         move.l 32(sp),d1
    4d54:	|  |         move.l d1,d0
    4d56:	|  |         add.l d0,d0
    4d58:	|  |         add.l d1,d0
    4d5a:	|  |         add.l d0,d0
    4d5c:	|  |         add.l d0,d0
    4d5e:	|  |         move.l d0,12(sp)
    4d62:	|  |         clr.l 8(sp)
    4d66:	|  |         move.l d018 <SysBase>,d0
    4d6c:	|  |         movea.l d0,a6
    4d6e:	|  |         move.l 12(sp),d0
    4d72:	|  |         move.l 8(sp),d1
    4d76:	|  |         jsr -684(a6)
    4d7a:	|  |         move.l d0,4(sp)
    4d7e:	|  |         move.l 4(sp),d0
    4d82:	|  |         movea.l 16(sp),a0
    4d86:	|  |         move.l d0,4(a0)
		if (!newAnim->frames) {
    4d8a:	|  |         movea.l 16(sp),a0
    4d8e:	|  |         move.l 4(a0),d0
    4d92:	|  |     ,-- bne.s 4da8 <copyAnim+0xd2>
			KPrintF("copyAnim: Cannot allocate memory");
    4d94:	|  |     |   pea 9258 <PutChar+0x15e4>
    4d9a:	|  |     |   jsr 725e <KPrintF>
    4da0:	|  |     |   addq.l #4,sp
			return NULL;
    4da2:	|  |     |   moveq #0,d0
    4da4:	+--|-----|-- bra.w 4e78 <copyAnim+0x1a2>
		}

		for (int a = 0; a < num; a ++) {
    4da8:	|  |     '-> clr.l 36(sp)
    4dac:	|  |     ,-- bra.w 4e5e <copyAnim+0x188>
			newAnim -> frames[a].frameNum = orig -> frames[a].frameNum;
    4db0:	|  |  ,--|-> movea.l 44(sp),a0
    4db4:	|  |  |  |   movea.l 4(a0),a0
    4db8:	|  |  |  |   move.l 36(sp),d1
    4dbc:	|  |  |  |   move.l d1,d0
    4dbe:	|  |  |  |   add.l d0,d0
    4dc0:	|  |  |  |   add.l d1,d0
    4dc2:	|  |  |  |   add.l d0,d0
    4dc4:	|  |  |  |   add.l d0,d0
    4dc6:	|  |  |  |   lea (0,a0,d0.l),a1
    4dca:	|  |  |  |   movea.l 16(sp),a0
    4dce:	|  |  |  |   movea.l 4(a0),a0
    4dd2:	|  |  |  |   move.l 36(sp),d1
    4dd6:	|  |  |  |   move.l d1,d0
    4dd8:	|  |  |  |   add.l d0,d0
    4dda:	|  |  |  |   add.l d1,d0
    4ddc:	|  |  |  |   add.l d0,d0
    4dde:	|  |  |  |   add.l d0,d0
    4de0:	|  |  |  |   adda.l d0,a0
    4de2:	|  |  |  |   move.l (a1),d0
    4de4:	|  |  |  |   move.l d0,(a0)
			newAnim -> frames[a].howMany = orig -> frames[a].howMany;
    4de6:	|  |  |  |   movea.l 44(sp),a0
    4dea:	|  |  |  |   movea.l 4(a0),a0
    4dee:	|  |  |  |   move.l 36(sp),d1
    4df2:	|  |  |  |   move.l d1,d0
    4df4:	|  |  |  |   add.l d0,d0
    4df6:	|  |  |  |   add.l d1,d0
    4df8:	|  |  |  |   add.l d0,d0
    4dfa:	|  |  |  |   add.l d0,d0
    4dfc:	|  |  |  |   lea (0,a0,d0.l),a1
    4e00:	|  |  |  |   movea.l 16(sp),a0
    4e04:	|  |  |  |   movea.l 4(a0),a0
    4e08:	|  |  |  |   move.l 36(sp),d1
    4e0c:	|  |  |  |   move.l d1,d0
    4e0e:	|  |  |  |   add.l d0,d0
    4e10:	|  |  |  |   add.l d1,d0
    4e12:	|  |  |  |   add.l d0,d0
    4e14:	|  |  |  |   add.l d0,d0
    4e16:	|  |  |  |   adda.l d0,a0
    4e18:	|  |  |  |   move.l 4(a1),d0
    4e1c:	|  |  |  |   move.l d0,4(a0)
			newAnim -> frames[a].noise = orig -> frames[a].noise;
    4e20:	|  |  |  |   movea.l 44(sp),a0
    4e24:	|  |  |  |   movea.l 4(a0),a0
    4e28:	|  |  |  |   move.l 36(sp),d1
    4e2c:	|  |  |  |   move.l d1,d0
    4e2e:	|  |  |  |   add.l d0,d0
    4e30:	|  |  |  |   add.l d1,d0
    4e32:	|  |  |  |   add.l d0,d0
    4e34:	|  |  |  |   add.l d0,d0
    4e36:	|  |  |  |   lea (0,a0,d0.l),a1
    4e3a:	|  |  |  |   movea.l 16(sp),a0
    4e3e:	|  |  |  |   movea.l 4(a0),a0
    4e42:	|  |  |  |   move.l 36(sp),d1
    4e46:	|  |  |  |   move.l d1,d0
    4e48:	|  |  |  |   add.l d0,d0
    4e4a:	|  |  |  |   add.l d1,d0
    4e4c:	|  |  |  |   add.l d0,d0
    4e4e:	|  |  |  |   add.l d0,d0
    4e50:	|  |  |  |   adda.l d0,a0
    4e52:	|  |  |  |   move.l 8(a1),d0
    4e56:	|  |  |  |   move.l d0,8(a0)
		for (int a = 0; a < num; a ++) {
    4e5a:	|  |  |  |   addq.l #1,36(sp)
    4e5e:	|  |  |  '-> move.l 36(sp),d0
    4e62:	|  |  |      cmp.l 32(sp),d0
    4e66:	|  |  '----- blt.w 4db0 <copyAnim+0xda>
    4e6a:	|  |     ,-- bra.s 4e74 <copyAnim+0x19e>
		}
	} else {
		newAnim -> frames = NULL;
    4e6c:	|  '-----|-> movea.l 16(sp),a0
    4e70:	|        |   clr.l 4(a0)
	}

	return newAnim;
    4e74:	|        '-> move.l 16(sp),d0
}
    4e78:	'----------> movea.l (sp)+,a6
    4e7a:	             lea 36(sp),sp
    4e7e:	             rts

00004e80 <deleteAnim>:
	}

	return newP;
}

void deleteAnim (struct personaAnimation * orig) {
    4e80:	       lea -12(sp),sp
    4e84:	       move.l a6,-(sp)

	if(orig->theSprites)
    4e86:	       movea.l 20(sp),a0
    4e8a:	       move.l (a0),d0
    4e8c:	   ,-- beq.s 4eb6 <deleteAnim+0x36>
	{
		int timesused = --orig->theSprites->timesUsed;
    4e8e:	   |   movea.l 20(sp),a0
    4e92:	   |   movea.l (a0),a0
    4e94:	   |   move.l 4(a0),d0
    4e98:	   |   subq.l #1,d0
    4e9a:	   |   move.l d0,4(a0)
    4e9e:	   |   move.l 4(a0),12(sp)
		
		if(!timesused)
    4ea4:	   +-- bne.s 4eb6 <deleteAnim+0x36>
		{
			forgetSpriteBank( orig->theSprites);
    4ea6:	   |   movea.l 20(sp),a0
    4eaa:	   |   move.l (a0),d0
    4eac:	   |   move.l d0,-(sp)
    4eae:	   |   jsr 48e2 <forgetSpriteBank>
    4eb4:	   |   addq.l #4,sp
		}
	}			
	
	if (orig)
    4eb6:	   '-> tst.l 20(sp)
    4eba:	,----- beq.s 4efa <deleteAnim+0x7a>
	{
		if (orig -> numFrames) {
    4ebc:	|      movea.l 20(sp),a0
    4ec0:	|      move.l 8(a0),d0
    4ec4:	|  ,-- beq.s 4ee0 <deleteAnim+0x60>
			FreeVec( orig->frames);
    4ec6:	|  |   movea.l 20(sp),a0
    4eca:	|  |   move.l 4(a0),8(sp)
    4ed0:	|  |   move.l d018 <SysBase>,d0
    4ed6:	|  |   movea.l d0,a6
    4ed8:	|  |   movea.l 8(sp),a1
    4edc:	|  |   jsr -690(a6)
		}
		FreeVec(orig);
    4ee0:	|  '-> move.l 20(sp),4(sp)
    4ee6:	|      move.l d018 <SysBase>,d0
    4eec:	|      movea.l d0,a6
    4eee:	|      movea.l 4(sp),a1
    4ef2:	|      jsr -690(a6)
		orig = NULL;
    4ef6:	|      clr.l 20(sp)
	}	
	
}
    4efa:	'----> nop
    4efc:	       movea.l (sp)+,a6
    4efe:	       lea 12(sp),sp
    4f02:	       rts

00004f04 <doBorderStuff>:

BOOL doBorderStuff (struct onScreenPerson * moveMe) {
    4f04:	          lea -124(sp),sp
    4f08:	          movem.l d2-d7,-(sp)
    if (moveMe -> inPoly == moveMe -> walkToPoly) {
    4f0c:	          movea.l 152(sp),a0
    4f10:	          move.l 56(a0),d1
    4f14:	          movea.l 152(sp),a0
    4f18:	          move.l 60(a0),d0
    4f1c:	          cmp.l d1,d0
    4f1e:	      ,-- bne.s 4f4e <doBorderStuff+0x4a>
        moveMe -> inPoly = -1;
    4f20:	      |   movea.l 152(sp),a0
    4f24:	      |   moveq #-1,d0
    4f26:	      |   move.l d0,56(a0)
        moveMe -> thisStepX = moveMe -> walkToX;
    4f2a:	      |   movea.l 152(sp),a0
    4f2e:	      |   move.l 40(a0),d0
    4f32:	      |   movea.l 152(sp),a0
    4f36:	      |   move.l d0,48(a0)
        moveMe -> thisStepY = moveMe -> walkToY;
    4f3a:	      |   movea.l 152(sp),a0
    4f3e:	      |   move.l 44(a0),d0
    4f42:	      |   movea.l 152(sp),a0
    4f46:	      |   move.l d0,52(a0)
    4f4a:	   ,--|-- bra.w 54b4 <doBorderStuff+0x5b0>
    } else {
        // The section in which we need to be next...
        int newPoly = currentFloor -> matrix[moveMe -> inPoly][moveMe -> walkToPoly];
    4f4e:	   |  '-> movea.l d0ea <currentFloor>,a0
    4f54:	   |      move.l 16(a0),d1
    4f58:	   |      movea.l 152(sp),a0
    4f5c:	   |      move.l 56(a0),d0
    4f60:	   |      add.l d0,d0
    4f62:	   |      add.l d0,d0
    4f64:	   |      movea.l d1,a0
    4f66:	   |      adda.l d0,a0
    4f68:	   |      move.l (a0),d1
    4f6a:	   |      movea.l 152(sp),a0
    4f6e:	   |      move.l 60(a0),d0
    4f72:	   |      add.l d0,d0
    4f74:	   |      add.l d0,d0
    4f76:	   |      movea.l d1,a0
    4f78:	   |      adda.l d0,a0
    4f7a:	   |      move.l (a0),144(sp)
        if (newPoly == -1) return FALSE;
    4f7e:	   |      moveq #-1,d0
    4f80:	   |      cmp.l 144(sp),d0
    4f84:	   |  ,-- bne.s 4f8c <doBorderStuff+0x88>
    4f86:	   |  |   clr.w d0
    4f88:	,--|--|-- bra.w 55b4 <doBorderStuff+0x6b0>

        // Grab the index of the second matching corner...
        int ID, ID2;
        if (! getMatchingCorners (&(currentFloor -> polygon[moveMe -> inPoly]), &(currentFloor -> polygon[newPoly]), &ID, &ID2))
    4f8c:	|  |  '-> movea.l d0ea <currentFloor>,a0
    4f92:	|  |      move.l 12(a0),d1
    4f96:	|  |      move.l 144(sp),d0
    4f9a:	|  |      lsl.l #3,d0
    4f9c:	|  |      add.l d0,d1
    4f9e:	|  |      movea.l d0ea <currentFloor>,a0
    4fa4:	|  |      movea.l 12(a0),a1
    4fa8:	|  |      movea.l 152(sp),a0
    4fac:	|  |      move.l 56(a0),d0
    4fb0:	|  |      lsl.l #3,d0
    4fb2:	|  |      add.l a1,d0
    4fb4:	|  |      lea 40(sp),a0
    4fb8:	|  |      move.l a0,-(sp)
    4fba:	|  |      lea 48(sp),a0
    4fbe:	|  |      move.l a0,-(sp)
    4fc0:	|  |      move.l d1,-(sp)
    4fc2:	|  |      move.l d0,-(sp)
    4fc4:	|  |      jsr 70a2 <getMatchingCorners>
    4fca:	|  |      lea 16(sp),sp
    4fce:	|  |      tst.w d0
    4fd0:	|  |  ,-- bne.s 4fe6 <doBorderStuff+0xe2>
		{
			KPrintF ("Not a valid floor plan!");
    4fd2:	|  |  |   pea 92a3 <PutChar+0x162f>
    4fd8:	|  |  |   jsr 725e <KPrintF>
    4fde:	|  |  |   addq.l #4,sp
            return FALSE;
    4fe0:	|  |  |   clr.w d0
    4fe2:	+--|--|-- bra.w 55b4 <doBorderStuff+0x6b0>
		}

        // Remember that we're walking to the new polygon...
        moveMe -> inPoly = newPoly;
    4fe6:	|  |  '-> movea.l 152(sp),a0
    4fea:	|  |      move.l 144(sp),56(a0)

        // Calculate the destination position on the coincidental line...
        int x1 = moveMe -> x, y1 = moveMe -> y;
    4ff0:	|  |      movea.l 152(sp),a0
    4ff4:	|  |      move.l (a0),d0
    4ff6:	|  |      move.l d0,-(sp)
    4ff8:	|  |      jsr 7628 <__fixsfsi>
    4ffe:	|  |      addq.l #4,sp
    5000:	|  |      move.l d0,140(sp)
    5004:	|  |      movea.l 152(sp),a0
    5008:	|  |      move.l 4(a0),d0
    500c:	|  |      move.l d0,-(sp)
    500e:	|  |      jsr 7628 <__fixsfsi>
    5014:	|  |      addq.l #4,sp
    5016:	|  |      move.l d0,136(sp)
        int x2 = moveMe -> walkToX, y2 = moveMe -> walkToY;
    501a:	|  |      movea.l 152(sp),a0
    501e:	|  |      move.l 40(a0),132(sp)
    5024:	|  |      movea.l 152(sp),a0
    5028:	|  |      move.l 44(a0),128(sp)
        int x3 = currentFloor -> vertex[ID].x, y3 = currentFloor -> vertex[ID].y;
    502e:	|  |      movea.l d0ea <currentFloor>,a0
    5034:	|  |      move.l 4(a0),d1
    5038:	|  |      move.l 44(sp),d0
    503c:	|  |      lsl.l #3,d0
    503e:	|  |      movea.l d1,a0
    5040:	|  |      adda.l d0,a0
    5042:	|  |      move.l (a0),124(sp)
    5046:	|  |      movea.l d0ea <currentFloor>,a0
    504c:	|  |      move.l 4(a0),d1
    5050:	|  |      move.l 44(sp),d0
    5054:	|  |      lsl.l #3,d0
    5056:	|  |      movea.l d1,a0
    5058:	|  |      adda.l d0,a0
    505a:	|  |      move.l 4(a0),120(sp)
        int x4 = currentFloor -> vertex[ID2].x, y4 = currentFloor -> vertex[ID2].y;
    5060:	|  |      movea.l d0ea <currentFloor>,a0
    5066:	|  |      move.l 4(a0),d1
    506a:	|  |      move.l 40(sp),d0
    506e:	|  |      lsl.l #3,d0
    5070:	|  |      movea.l d1,a0
    5072:	|  |      adda.l d0,a0
    5074:	|  |      move.l (a0),116(sp)
    5078:	|  |      movea.l d0ea <currentFloor>,a0
    507e:	|  |      move.l 4(a0),d1
    5082:	|  |      move.l 40(sp),d0
    5086:	|  |      lsl.l #3,d0
    5088:	|  |      movea.l d1,a0
    508a:	|  |      adda.l d0,a0
    508c:	|  |      move.l 4(a0),112(sp)

        int xAB = x1 - x2;
    5092:	|  |      move.l 140(sp),d0
    5096:	|  |      sub.l 132(sp),d0
    509a:	|  |      move.l d0,108(sp)
        int yAB = y1 - y2;
    509e:	|  |      move.l 136(sp),d0
    50a2:	|  |      sub.l 128(sp),d0
    50a6:	|  |      move.l d0,104(sp)
        int xCD = x4 - x3;
    50aa:	|  |      move.l 116(sp),d0
    50ae:	|  |      sub.l 124(sp),d0
    50b2:	|  |      move.l d0,100(sp)
        int yCD = y4 - y3;
    50b6:	|  |      move.l 112(sp),d0
    50ba:	|  |      sub.l 120(sp),d0
    50be:	|  |      move.l d0,96(sp)

        double m = (yAB * (x3 - x1) - xAB * (y3 - y1));
    50c2:	|  |      move.l 124(sp),d0
    50c6:	|  |      sub.l 140(sp),d0
    50ca:	|  |      move.l 104(sp),-(sp)
    50ce:	|  |      move.l d0,-(sp)
    50d0:	|  |      jsr 7b8c <__mulsi3>
    50d6:	|  |      addq.l #8,sp
    50d8:	|  |      move.l d0,d2
    50da:	|  |      move.l 120(sp),d0
    50de:	|  |      sub.l 136(sp),d0
    50e2:	|  |      move.l 108(sp),-(sp)
    50e6:	|  |      move.l d0,-(sp)
    50e8:	|  |      jsr 7b8c <__mulsi3>
    50ee:	|  |      addq.l #8,sp
    50f0:	|  |      move.l d2,d1
    50f2:	|  |      sub.l d0,d1
    50f4:	|  |      move.l d1,-(sp)
    50f6:	|  |      jsr 7650 <__floatsidf>
    50fc:	|  |      addq.l #4,sp
    50fe:	|  |      move.l d0,32(sp)
    5102:	|  |      move.l d1,36(sp)
    5106:	|  |      move.l 32(sp),88(sp)
    510c:	|  |      move.l 36(sp),92(sp)
        m /= ((xAB * yCD) - (yAB * xCD));
    5112:	|  |      move.l 96(sp),-(sp)
    5116:	|  |      move.l 112(sp),-(sp)
    511a:	|  |      jsr 7b8c <__mulsi3>
    5120:	|  |      addq.l #8,sp
    5122:	|  |      move.l d0,d2
    5124:	|  |      move.l 100(sp),-(sp)
    5128:	|  |      move.l 108(sp),-(sp)
    512c:	|  |      jsr 7b8c <__mulsi3>
    5132:	|  |      addq.l #8,sp
    5134:	|  |      move.l d2,d1
    5136:	|  |      sub.l d0,d1
    5138:	|  |      move.l d1,-(sp)
    513a:	|  |      jsr 7650 <__floatsidf>
    5140:	|  |      addq.l #4,sp
    5142:	|  |      move.l d1,-(sp)
    5144:	|  |      move.l d0,-(sp)
    5146:	|  |      move.l 100(sp),-(sp)
    514a:	|  |      move.l 100(sp),-(sp)
    514e:	|  |      jsr 74e4 <__divdf3>
    5154:	|  |      lea 16(sp),sp
    5158:	|  |      move.l d0,24(sp)
    515c:	|  |      move.l d1,28(sp)
    5160:	|  |      move.l 24(sp),88(sp)
    5166:	|  |      move.l 28(sp),92(sp)

        if (m > 0 && m < 1) {
    516c:	|  |      clr.l -(sp)
    516e:	|  |      clr.l -(sp)
    5170:	|  |      move.l 100(sp),-(sp)
    5174:	|  |      move.l 100(sp),-(sp)
    5178:	|  |      jsr 7786 <__gtdf2>
    517e:	|  |      lea 16(sp),sp
    5182:	|  |      tst.l d0
    5184:	|  |  ,-- ble.w 525c <doBorderStuff+0x358>
    5188:	|  |  |   clr.l -(sp)
    518a:	|  |  |   move.l #1072693248,-(sp)
    5190:	|  |  |   move.l 100(sp),-(sp)
    5194:	|  |  |   move.l 100(sp),-(sp)
    5198:	|  |  |   jsr 780a <__ltdf2>
    519e:	|  |  |   lea 16(sp),sp
    51a2:	|  |  |   tst.l d0
    51a4:	|  |  +-- bge.w 525c <doBorderStuff+0x358>
            moveMe -> thisStepX = x3 + m * xCD;
    51a8:	|  |  |   move.l 124(sp),-(sp)
    51ac:	|  |  |   jsr 7650 <__floatsidf>
    51b2:	|  |  |   addq.l #4,sp
    51b4:	|  |  |   move.l d0,d2
    51b6:	|  |  |   move.l d1,d3
    51b8:	|  |  |   move.l 100(sp),-(sp)
    51bc:	|  |  |   jsr 7650 <__floatsidf>
    51c2:	|  |  |   addq.l #4,sp
    51c4:	|  |  |   move.l 92(sp),-(sp)
    51c8:	|  |  |   move.l 92(sp),-(sp)
    51cc:	|  |  |   move.l d1,-(sp)
    51ce:	|  |  |   move.l d0,-(sp)
    51d0:	|  |  |   jsr 76b8 <__muldf3>
    51d6:	|  |  |   lea 16(sp),sp
    51da:	|  |  |   move.l d1,-(sp)
    51dc:	|  |  |   move.l d0,-(sp)
    51de:	|  |  |   move.l d3,-(sp)
    51e0:	|  |  |   move.l d2,-(sp)
    51e2:	|  |  |   jsr 7482 <__adddf3>
    51e8:	|  |  |   lea 16(sp),sp
    51ec:	|  |  |   move.l d1,-(sp)
    51ee:	|  |  |   move.l d0,-(sp)
    51f0:	|  |  |   jsr 75f2 <__fixdfsi>
    51f6:	|  |  |   addq.l #8,sp
    51f8:	|  |  |   movea.l 152(sp),a0
    51fc:	|  |  |   move.l d0,48(a0)
            moveMe -> thisStepY = y3 + m * yCD;
    5200:	|  |  |   move.l 120(sp),-(sp)
    5204:	|  |  |   jsr 7650 <__floatsidf>
    520a:	|  |  |   addq.l #4,sp
    520c:	|  |  |   move.l d0,d2
    520e:	|  |  |   move.l d1,d3
    5210:	|  |  |   move.l 96(sp),-(sp)
    5214:	|  |  |   jsr 7650 <__floatsidf>
    521a:	|  |  |   addq.l #4,sp
    521c:	|  |  |   move.l 92(sp),-(sp)
    5220:	|  |  |   move.l 92(sp),-(sp)
    5224:	|  |  |   move.l d1,-(sp)
    5226:	|  |  |   move.l d0,-(sp)
    5228:	|  |  |   jsr 76b8 <__muldf3>
    522e:	|  |  |   lea 16(sp),sp
    5232:	|  |  |   move.l d1,-(sp)
    5234:	|  |  |   move.l d0,-(sp)
    5236:	|  |  |   move.l d3,-(sp)
    5238:	|  |  |   move.l d2,-(sp)
    523a:	|  |  |   jsr 7482 <__adddf3>
    5240:	|  |  |   lea 16(sp),sp
    5244:	|  |  |   move.l d1,-(sp)
    5246:	|  |  |   move.l d0,-(sp)
    5248:	|  |  |   jsr 75f2 <__fixdfsi>
    524e:	|  |  |   addq.l #8,sp
    5250:	|  |  |   movea.l 152(sp),a0
    5254:	|  |  |   move.l d0,52(a0)
    5258:	|  +--|-- bra.w 54b4 <doBorderStuff+0x5b0>
        } else {
            int dx13 = x1 - x3, dx14 = x1 - x4, dx23 = x2 - x3, dx24 = x2 - x4;
    525c:	|  |  '-> move.l 140(sp),d0
    5260:	|  |      sub.l 124(sp),d0
    5264:	|  |      move.l d0,84(sp)
    5268:	|  |      move.l 140(sp),d0
    526c:	|  |      sub.l 116(sp),d0
    5270:	|  |      move.l d0,80(sp)
    5274:	|  |      move.l 132(sp),d0
    5278:	|  |      sub.l 124(sp),d0
    527c:	|  |      move.l d0,76(sp)
    5280:	|  |      move.l 132(sp),d0
    5284:	|  |      sub.l 116(sp),d0
    5288:	|  |      move.l d0,72(sp)
            int dy13 = y1 - y3, dy14 = y1 - y4, dy23 = y2 - y3, dy24 = y2 - y4;
    528c:	|  |      move.l 136(sp),d0
    5290:	|  |      sub.l 120(sp),d0
    5294:	|  |      move.l d0,68(sp)
    5298:	|  |      move.l 136(sp),d0
    529c:	|  |      sub.l 112(sp),d0
    52a0:	|  |      move.l d0,64(sp)
    52a4:	|  |      move.l 128(sp),d0
    52a8:	|  |      sub.l 120(sp),d0
    52ac:	|  |      move.l d0,60(sp)
    52b0:	|  |      move.l 128(sp),d0
    52b4:	|  |      sub.l 112(sp),d0
    52b8:	|  |      move.l d0,56(sp)

            dx13 *= dx13; dx14 *= dx14; dx23 *= dx23; dx24 *= dx24;
    52bc:	|  |      move.l 84(sp),-(sp)
    52c0:	|  |      move.l 88(sp),-(sp)
    52c4:	|  |      jsr 7b8c <__mulsi3>
    52ca:	|  |      addq.l #8,sp
    52cc:	|  |      move.l d0,84(sp)
    52d0:	|  |      move.l 80(sp),-(sp)
    52d4:	|  |      move.l 84(sp),-(sp)
    52d8:	|  |      jsr 7b8c <__mulsi3>
    52de:	|  |      addq.l #8,sp
    52e0:	|  |      move.l d0,80(sp)
    52e4:	|  |      move.l 76(sp),-(sp)
    52e8:	|  |      move.l 80(sp),-(sp)
    52ec:	|  |      jsr 7b8c <__mulsi3>
    52f2:	|  |      addq.l #8,sp
    52f4:	|  |      move.l d0,76(sp)
    52f8:	|  |      move.l 72(sp),-(sp)
    52fc:	|  |      move.l 76(sp),-(sp)
    5300:	|  |      jsr 7b8c <__mulsi3>
    5306:	|  |      addq.l #8,sp
    5308:	|  |      move.l d0,72(sp)
            dy13 *= dy13; dy14 *= dy14; dy23 *= dy23; dy24 *= dy24;
    530c:	|  |      move.l 68(sp),-(sp)
    5310:	|  |      move.l 72(sp),-(sp)
    5314:	|  |      jsr 7b8c <__mulsi3>
    531a:	|  |      addq.l #8,sp
    531c:	|  |      move.l d0,68(sp)
    5320:	|  |      move.l 64(sp),-(sp)
    5324:	|  |      move.l 68(sp),-(sp)
    5328:	|  |      jsr 7b8c <__mulsi3>
    532e:	|  |      addq.l #8,sp
    5330:	|  |      move.l d0,64(sp)
    5334:	|  |      move.l 60(sp),-(sp)
    5338:	|  |      move.l 64(sp),-(sp)
    533c:	|  |      jsr 7b8c <__mulsi3>
    5342:	|  |      addq.l #8,sp
    5344:	|  |      move.l d0,60(sp)
    5348:	|  |      move.l 56(sp),-(sp)
    534c:	|  |      move.l 60(sp),-(sp)
    5350:	|  |      jsr 7b8c <__mulsi3>
    5356:	|  |      addq.l #8,sp
    5358:	|  |      move.l d0,56(sp)

            if (sqrt((double) dx13 + dy13) + sqrt((double) dx23 + dy23) <
    535c:	|  |      move.l 84(sp),-(sp)
    5360:	|  |      jsr 7650 <__floatsidf>
    5366:	|  |      addq.l #4,sp
    5368:	|  |      move.l d0,d2
    536a:	|  |      move.l d1,d3
    536c:	|  |      move.l 68(sp),-(sp)
    5370:	|  |      jsr 7650 <__floatsidf>
    5376:	|  |      addq.l #4,sp
    5378:	|  |      move.l d1,-(sp)
    537a:	|  |      move.l d0,-(sp)
    537c:	|  |      move.l d3,-(sp)
    537e:	|  |      move.l d2,-(sp)
    5380:	|  |      jsr 7482 <__adddf3>
    5386:	|  |      lea 16(sp),sp
    538a:	|  |      move.l d1,-(sp)
    538c:	|  |      move.l d0,-(sp)
    538e:	|  |      jsr 7b42 <sqrt>
    5394:	|  |      addq.l #8,sp
    5396:	|  |      move.l d0,d2
    5398:	|  |      move.l d1,d3
    539a:	|  |      move.l 76(sp),-(sp)
    539e:	|  |      jsr 7650 <__floatsidf>
    53a4:	|  |      addq.l #4,sp
    53a6:	|  |      move.l d0,d4
    53a8:	|  |      move.l d1,d5
    53aa:	|  |      move.l 60(sp),-(sp)
    53ae:	|  |      jsr 7650 <__floatsidf>
    53b4:	|  |      addq.l #4,sp
    53b6:	|  |      move.l d1,-(sp)
    53b8:	|  |      move.l d0,-(sp)
    53ba:	|  |      move.l d5,-(sp)
    53bc:	|  |      move.l d4,-(sp)
    53be:	|  |      jsr 7482 <__adddf3>
    53c4:	|  |      lea 16(sp),sp
    53c8:	|  |      move.l d1,-(sp)
    53ca:	|  |      move.l d0,-(sp)
    53cc:	|  |      jsr 7b42 <sqrt>
    53d2:	|  |      addq.l #8,sp
    53d4:	|  |      move.l d1,-(sp)
    53d6:	|  |      move.l d0,-(sp)
    53d8:	|  |      move.l d3,-(sp)
    53da:	|  |      move.l d2,-(sp)
    53dc:	|  |      jsr 7482 <__adddf3>
    53e2:	|  |      lea 16(sp),sp
    53e6:	|  |      move.l d0,d2
    53e8:	|  |      move.l d1,d3
                sqrt((double) dx14 + dy14) + sqrt((double) dx24 + dy24)) {
    53ea:	|  |      move.l 80(sp),-(sp)
    53ee:	|  |      jsr 7650 <__floatsidf>
    53f4:	|  |      addq.l #4,sp
    53f6:	|  |      move.l d0,d4
    53f8:	|  |      move.l d1,d5
    53fa:	|  |      move.l 64(sp),-(sp)
    53fe:	|  |      jsr 7650 <__floatsidf>
    5404:	|  |      addq.l #4,sp
    5406:	|  |      move.l d1,-(sp)
    5408:	|  |      move.l d0,-(sp)
    540a:	|  |      move.l d5,-(sp)
    540c:	|  |      move.l d4,-(sp)
    540e:	|  |      jsr 7482 <__adddf3>
    5414:	|  |      lea 16(sp),sp
    5418:	|  |      move.l d1,-(sp)
    541a:	|  |      move.l d0,-(sp)
    541c:	|  |      jsr 7b42 <sqrt>
    5422:	|  |      addq.l #8,sp
    5424:	|  |      move.l d0,d4
    5426:	|  |      move.l d1,d5
    5428:	|  |      move.l 72(sp),-(sp)
    542c:	|  |      jsr 7650 <__floatsidf>
    5432:	|  |      addq.l #4,sp
    5434:	|  |      move.l d0,d6
    5436:	|  |      move.l d1,d7
    5438:	|  |      move.l 56(sp),-(sp)
    543c:	|  |      jsr 7650 <__floatsidf>
    5442:	|  |      addq.l #4,sp
    5444:	|  |      move.l d1,-(sp)
    5446:	|  |      move.l d0,-(sp)
    5448:	|  |      move.l d7,-(sp)
    544a:	|  |      move.l d6,-(sp)
    544c:	|  |      jsr 7482 <__adddf3>
    5452:	|  |      lea 16(sp),sp
    5456:	|  |      move.l d1,-(sp)
    5458:	|  |      move.l d0,-(sp)
    545a:	|  |      jsr 7b42 <sqrt>
    5460:	|  |      addq.l #8,sp
    5462:	|  |      move.l d1,-(sp)
    5464:	|  |      move.l d0,-(sp)
    5466:	|  |      move.l d5,-(sp)
    5468:	|  |      move.l d4,-(sp)
    546a:	|  |      jsr 7482 <__adddf3>
    5470:	|  |      lea 16(sp),sp
            if (sqrt((double) dx13 + dy13) + sqrt((double) dx23 + dy23) <
    5474:	|  |      move.l d1,-(sp)
    5476:	|  |      move.l d0,-(sp)
    5478:	|  |      move.l d3,-(sp)
    547a:	|  |      move.l d2,-(sp)
    547c:	|  |      jsr 780a <__ltdf2>
    5482:	|  |      lea 16(sp),sp
    5486:	|  |      tst.l d0
    5488:	|  |  ,-- bge.s 54a0 <doBorderStuff+0x59c>
                moveMe -> thisStepX = x3;
    548a:	|  |  |   movea.l 152(sp),a0
    548e:	|  |  |   move.l 124(sp),48(a0)
                moveMe -> thisStepY = y3;
    5494:	|  |  |   movea.l 152(sp),a0
    5498:	|  |  |   move.l 120(sp),52(a0)
    549e:	|  +--|-- bra.s 54b4 <doBorderStuff+0x5b0>
            } else {
                moveMe -> thisStepX = x4;
    54a0:	|  |  '-> movea.l 152(sp),a0
    54a4:	|  |      move.l 116(sp),48(a0)
                moveMe -> thisStepY = y4;
    54aa:	|  |      movea.l 152(sp),a0
    54ae:	|  |      move.l 112(sp),52(a0)
            }
        }
    }

    float yDiff = moveMe -> thisStepY - moveMe -> y;
    54b4:	|  '----> movea.l 152(sp),a0
    54b8:	|         move.l 52(a0),d0
    54bc:	|         move.l d0,-(sp)
    54be:	|         jsr 7690 <__floatsisf>
    54c4:	|         addq.l #4,sp
    54c6:	|         move.l d0,d1
    54c8:	|         movea.l 152(sp),a0
    54cc:	|         move.l 4(a0),d0
    54d0:	|         move.l d0,-(sp)
    54d2:	|         move.l d1,-(sp)
    54d4:	|         jsr 7926 <__subsf3>
    54da:	|         addq.l #8,sp
    54dc:	|         move.l d0,52(sp)
    float xDiff = moveMe -> x - moveMe -> thisStepX;
    54e0:	|         movea.l 152(sp),a0
    54e4:	|         move.l (a0),d2
    54e6:	|         movea.l 152(sp),a0
    54ea:	|         move.l 48(a0),d0
    54ee:	|         move.l d0,-(sp)
    54f0:	|         jsr 7690 <__floatsisf>
    54f6:	|         addq.l #4,sp
    54f8:	|         move.l d0,-(sp)
    54fa:	|         move.l d2,-(sp)
    54fc:	|         jsr 7926 <__subsf3>
    5502:	|         addq.l #8,sp
    5504:	|         move.l d0,48(sp)
    if (xDiff || yDiff) {
    5508:	|         clr.l -(sp)
    550a:	|         move.l 52(sp),-(sp)
    550e:	|         jsr 788e <__nesf2>
    5514:	|         addq.l #8,sp
    5516:	|         tst.l d0
    5518:	|     ,-- bne.s 552c <doBorderStuff+0x628>
    551a:	|     |   clr.l -(sp)
    551c:	|     |   move.l 56(sp),-(sp)
    5520:	|     |   jsr 788e <__nesf2>
    5526:	|     |   addq.l #8,sp
    5528:	|     |   tst.l d0
    552a:	|  ,--|-- beq.s 55a2 <doBorderStuff+0x69e>
        moveMe -> wantAngle = 180 + ANGLEFIX * atan2f(xDiff, yDiff * 2);
    552c:	|  |  '-> move.l 52(sp),d0
    5530:	|  |      move.l d0,-(sp)
    5532:	|  |      move.l d0,-(sp)
    5534:	|  |      jsr 744c <__addsf3>
    553a:	|  |      addq.l #8,sp
    553c:	|  |      move.l d0,-(sp)
    553e:	|  |      move.l 52(sp),-(sp)
    5542:	|  |      jsr 7992 <atan2f>
    5548:	|  |      addq.l #8,sp
    554a:	|  |      move.l d0,-(sp)
    554c:	|  |      jsr 75b2 <__extendsfdf2>
    5552:	|  |      addq.l #4,sp
    5554:	|  |      move.l #-1540411785,-(sp)
    555a:	|  |      move.l #1078765033,-(sp)
    5560:	|  |      move.l d1,-(sp)
    5562:	|  |      move.l d0,-(sp)
    5564:	|  |      jsr 76b8 <__muldf3>
    556a:	|  |      lea 16(sp),sp
    556e:	|  |      clr.l -(sp)
    5570:	|  |      move.l #1080459264,-(sp)
    5576:	|  |      move.l d1,-(sp)
    5578:	|  |      move.l d0,-(sp)
    557a:	|  |      jsr 7482 <__adddf3>
    5580:	|  |      lea 16(sp),sp
    5584:	|  |      move.l d1,-(sp)
    5586:	|  |      move.l d0,-(sp)
    5588:	|  |      jsr 75f2 <__fixdfsi>
    558e:	|  |      addq.l #8,sp
    5590:	|  |      movea.l 152(sp),a0
    5594:	|  |      move.l d0,96(a0)
        moveMe -> spinning = TRUE;
    5598:	|  |      movea.l 152(sp),a0
    559c:	|  |      move.w #1,66(a0)
    }

    setFrames (moveMe, ANI_WALK);
    55a2:	|  '----> pea 1 <_start+0x1>
    55a6:	|         move.l 156(sp),-(sp)
    55aa:	|         jsr 24e6 <setFrames>
    55b0:	|         addq.l #8,sp
    return TRUE;
    55b2:	|         moveq #1,d0
}
    55b4:	'-------> movem.l (sp)+,d2-d7
    55b8:	          lea 124(sp),sp
    55bc:	          rts

000055be <drawPeople>:

void drawPeople () {
    55be:	                   lea -24(sp),sp
    55c2:	                   move.l d2,-(sp)

	shufflePeople ();
    55c4:	                   jsr 5cb4 <shufflePeople>

	struct onScreenPerson * thisPerson = allPeople;
    55ca:	                   move.l d078 <allPeople>,24(sp)
	struct personaAnimation * myAnim = NULL;
    55d2:	                   clr.l 20(sp)
	overRegion = NULL;
    55d6:	                   clr.l d0e2 <overRegion>

	while (thisPerson) {
    55dc:	   ,-------------- bra.w 5b8e <drawPeople+0x5d0>
		if (thisPerson -> show) {
    55e0:	,--|-------------> movea.l 24(sp),a0
    55e4:	|  |               move.w 104(a0),d0
    55e8:	|  |  ,----------- beq.w 5942 <drawPeople+0x384>
			myAnim = thisPerson -> myAnim;
    55ec:	|  |  |            movea.l 24(sp),a0
    55f0:	|  |  |            move.l 72(a0),20(sp)
			if (myAnim != thisPerson -> lastUsedAnim) {
    55f6:	|  |  |            movea.l 24(sp),a0
    55fa:	|  |  |            move.l 76(a0),d0
    55fe:	|  |  |            cmp.l 20(sp),d0
    5602:	|  |  |  ,-------- beq.w 57d0 <drawPeople+0x212>
				thisPerson -> samePosCount = 0;
    5606:	|  |  |  |         movea.l 24(sp),a0
    560a:	|  |  |  |         clr.l 16(a0)
				thisPerson -> lastUsedAnim = myAnim;
    560e:	|  |  |  |         movea.l 24(sp),a0
    5612:	|  |  |  |         move.l 20(sp),76(a0)
				thisPerson -> frameNum = 0;
    5618:	|  |  |  |         movea.l 24(sp),a0
    561c:	|  |  |  |         clr.l 84(a0)
				thisPerson -> frameTick = myAnim -> frames[0].howMany;
    5620:	|  |  |  |         movea.l 20(sp),a0
    5624:	|  |  |  |         movea.l 4(a0),a0
    5628:	|  |  |  |         move.l 4(a0),d0
    562c:	|  |  |  |         movea.l 24(sp),a0
    5630:	|  |  |  |         move.l d0,88(a0)
				if (myAnim -> frames[thisPerson -> frameNum].noise > 0) {
    5634:	|  |  |  |         movea.l 20(sp),a0
    5638:	|  |  |  |         movea.l 4(a0),a1
    563c:	|  |  |  |         movea.l 24(sp),a0
    5640:	|  |  |  |         move.l 84(a0),d0
    5644:	|  |  |  |         move.l d0,d1
    5646:	|  |  |  |         move.l d1,d0
    5648:	|  |  |  |         add.l d0,d0
    564a:	|  |  |  |         add.l d1,d0
    564c:	|  |  |  |         add.l d0,d0
    564e:	|  |  |  |         add.l d0,d0
    5650:	|  |  |  |         lea (0,a1,d0.l),a0
    5654:	|  |  |  |         move.l 8(a0),d0
    5658:	|  |  |  |     ,-- ble.w 56fa <drawPeople+0x13c>
					startSound(myAnim -> frames[thisPerson -> frameNum].noise, FALSE);
    565c:	|  |  |  |     |   movea.l 20(sp),a0
    5660:	|  |  |  |     |   movea.l 4(a0),a1
    5664:	|  |  |  |     |   movea.l 24(sp),a0
    5668:	|  |  |  |     |   move.l 84(a0),d0
    566c:	|  |  |  |     |   move.l d0,d1
    566e:	|  |  |  |     |   move.l d1,d0
    5670:	|  |  |  |     |   add.l d0,d0
    5672:	|  |  |  |     |   add.l d1,d0
    5674:	|  |  |  |     |   add.l d0,d0
    5676:	|  |  |  |     |   add.l d0,d0
    5678:	|  |  |  |     |   lea (0,a1,d0.l),a0
    567c:	|  |  |  |     |   move.l 8(a0),d0
    5680:	|  |  |  |     |   clr.l -(sp)
    5682:	|  |  |  |     |   move.l d0,-(sp)
    5684:	|  |  |  |     |   jsr 649e <startSound>
    568a:	|  |  |  |     |   addq.l #8,sp
					thisPerson -> frameNum ++;
    568c:	|  |  |  |     |   movea.l 24(sp),a0
    5690:	|  |  |  |     |   move.l 84(a0),d0
    5694:	|  |  |  |     |   addq.l #1,d0
    5696:	|  |  |  |     |   movea.l 24(sp),a0
    569a:	|  |  |  |     |   move.l d0,84(a0)
					thisPerson -> frameNum %= thisPerson -> myAnim -> numFrames;
    569e:	|  |  |  |     |   movea.l 24(sp),a0
    56a2:	|  |  |  |     |   move.l 84(a0),d0
    56a6:	|  |  |  |     |   movea.l 24(sp),a0
    56aa:	|  |  |  |     |   movea.l 72(a0),a0
    56ae:	|  |  |  |     |   move.l 8(a0),d1
    56b2:	|  |  |  |     |   move.l d1,-(sp)
    56b4:	|  |  |  |     |   move.l d0,-(sp)
    56b6:	|  |  |  |     |   jsr 7c38 <__modsi3>
    56bc:	|  |  |  |     |   addq.l #8,sp
    56be:	|  |  |  |     |   movea.l 24(sp),a0
    56c2:	|  |  |  |     |   move.l d0,84(a0)
					thisPerson -> frameTick = thisPerson -> myAnim -> frames[thisPerson -> frameNum].howMany;
    56c6:	|  |  |  |     |   movea.l 24(sp),a0
    56ca:	|  |  |  |     |   movea.l 72(a0),a0
    56ce:	|  |  |  |     |   movea.l 4(a0),a1
    56d2:	|  |  |  |     |   movea.l 24(sp),a0
    56d6:	|  |  |  |     |   move.l 84(a0),d0
    56da:	|  |  |  |     |   move.l d0,d1
    56dc:	|  |  |  |     |   move.l d1,d0
    56de:	|  |  |  |     |   add.l d0,d0
    56e0:	|  |  |  |     |   add.l d1,d0
    56e2:	|  |  |  |     |   add.l d0,d0
    56e4:	|  |  |  |     |   add.l d0,d0
    56e6:	|  |  |  |     |   lea (0,a1,d0.l),a0
    56ea:	|  |  |  |     |   move.l 4(a0),d0
    56ee:	|  |  |  |     |   movea.l 24(sp),a0
    56f2:	|  |  |  |     |   move.l d0,88(a0)
    56f6:	|  |  |  |  ,--|-- bra.w 5838 <drawPeople+0x27a>
				} else if (myAnim -> frames[thisPerson -> frameNum].noise) {
    56fa:	|  |  |  |  |  '-> movea.l 20(sp),a0
    56fe:	|  |  |  |  |      movea.l 4(a0),a1
    5702:	|  |  |  |  |      movea.l 24(sp),a0
    5706:	|  |  |  |  |      move.l 84(a0),d0
    570a:	|  |  |  |  |      move.l d0,d1
    570c:	|  |  |  |  |      move.l d1,d0
    570e:	|  |  |  |  |      add.l d0,d0
    5710:	|  |  |  |  |      add.l d1,d0
    5712:	|  |  |  |  |      add.l d0,d0
    5714:	|  |  |  |  |      add.l d0,d0
    5716:	|  |  |  |  |      lea (0,a1,d0.l),a0
    571a:	|  |  |  |  |      move.l 8(a0),d0
    571e:	|  |  |  |  +----- beq.w 5838 <drawPeople+0x27a>
					startNewFunctionNum (- myAnim -> frames[thisPerson -> frameNum].noise, 0, NULL, noStack, TRUE);
    5722:	|  |  |  |  |      movea.l cfe8 <noStack>,a1
    5728:	|  |  |  |  |      movea.l 20(sp),a0
    572c:	|  |  |  |  |      move.l 4(a0),d2
    5730:	|  |  |  |  |      movea.l 24(sp),a0
    5734:	|  |  |  |  |      move.l 84(a0),d0
    5738:	|  |  |  |  |      move.l d0,d1
    573a:	|  |  |  |  |      move.l d1,d0
    573c:	|  |  |  |  |      add.l d0,d0
    573e:	|  |  |  |  |      add.l d1,d0
    5740:	|  |  |  |  |      add.l d0,d0
    5742:	|  |  |  |  |      add.l d0,d0
    5744:	|  |  |  |  |      movea.l d2,a0
    5746:	|  |  |  |  |      adda.l d0,a0
    5748:	|  |  |  |  |      move.l 8(a0),d0
    574c:	|  |  |  |  |      neg.l d0
    574e:	|  |  |  |  |      pea 1 <_start+0x1>
    5752:	|  |  |  |  |      move.l a1,-(sp)
    5754:	|  |  |  |  |      clr.l -(sp)
    5756:	|  |  |  |  |      clr.l -(sp)
    5758:	|  |  |  |  |      move.l d0,-(sp)
    575a:	|  |  |  |  |      jsr 3d2e <startNewFunctionNum>
    5760:	|  |  |  |  |      lea 20(sp),sp
					thisPerson -> frameNum ++;
    5764:	|  |  |  |  |      movea.l 24(sp),a0
    5768:	|  |  |  |  |      move.l 84(a0),d0
    576c:	|  |  |  |  |      addq.l #1,d0
    576e:	|  |  |  |  |      movea.l 24(sp),a0
    5772:	|  |  |  |  |      move.l d0,84(a0)
					thisPerson -> frameNum %= thisPerson -> myAnim -> numFrames;
    5776:	|  |  |  |  |      movea.l 24(sp),a0
    577a:	|  |  |  |  |      move.l 84(a0),d0
    577e:	|  |  |  |  |      movea.l 24(sp),a0
    5782:	|  |  |  |  |      movea.l 72(a0),a0
    5786:	|  |  |  |  |      move.l 8(a0),d1
    578a:	|  |  |  |  |      move.l d1,-(sp)
    578c:	|  |  |  |  |      move.l d0,-(sp)
    578e:	|  |  |  |  |      jsr 7c38 <__modsi3>
    5794:	|  |  |  |  |      addq.l #8,sp
    5796:	|  |  |  |  |      movea.l 24(sp),a0
    579a:	|  |  |  |  |      move.l d0,84(a0)
					thisPerson -> frameTick = thisPerson -> myAnim -> frames[thisPerson -> frameNum].howMany;
    579e:	|  |  |  |  |      movea.l 24(sp),a0
    57a2:	|  |  |  |  |      movea.l 72(a0),a0
    57a6:	|  |  |  |  |      movea.l 4(a0),a1
    57aa:	|  |  |  |  |      movea.l 24(sp),a0
    57ae:	|  |  |  |  |      move.l 84(a0),d0
    57b2:	|  |  |  |  |      move.l d0,d1
    57b4:	|  |  |  |  |      move.l d1,d0
    57b6:	|  |  |  |  |      add.l d0,d0
    57b8:	|  |  |  |  |      add.l d1,d0
    57ba:	|  |  |  |  |      add.l d0,d0
    57bc:	|  |  |  |  |      add.l d0,d0
    57be:	|  |  |  |  |      lea (0,a1,d0.l),a0
    57c2:	|  |  |  |  |      move.l 4(a0),d0
    57c6:	|  |  |  |  |      movea.l 24(sp),a0
    57ca:	|  |  |  |  |      move.l d0,88(a0)
    57ce:	|  |  |  |  +----- bra.s 5838 <drawPeople+0x27a>
				}
			} else {
				if(thisPerson->x == thisPerson->oldx && thisPerson->y == thisPerson->oldy && myAnim->numFrames == 1)
    57d0:	|  |  |  '--|----> movea.l 24(sp),a0
    57d4:	|  |  |     |      move.l (a0),d0
    57d6:	|  |  |     |      movea.l 24(sp),a0
    57da:	|  |  |     |      move.l 8(a0),d1
    57de:	|  |  |     |      move.l d1,-(sp)
    57e0:	|  |  |     |      move.l d0,-(sp)
    57e2:	|  |  |     |      jsr 757c <__eqsf2>
    57e8:	|  |  |     |      addq.l #8,sp
    57ea:	|  |  |     |      tst.l d0
    57ec:	|  |  |     |  ,-- bne.s 5830 <drawPeople+0x272>
    57ee:	|  |  |     |  |   movea.l 24(sp),a0
    57f2:	|  |  |     |  |   move.l 4(a0),d0
    57f6:	|  |  |     |  |   movea.l 24(sp),a0
    57fa:	|  |  |     |  |   move.l 12(a0),d1
    57fe:	|  |  |     |  |   move.l d1,-(sp)
    5800:	|  |  |     |  |   move.l d0,-(sp)
    5802:	|  |  |     |  |   jsr 757c <__eqsf2>
    5808:	|  |  |     |  |   addq.l #8,sp
    580a:	|  |  |     |  |   tst.l d0
    580c:	|  |  |     |  +-- bne.s 5830 <drawPeople+0x272>
    580e:	|  |  |     |  |   movea.l 20(sp),a0
    5812:	|  |  |     |  |   move.l 8(a0),d0
    5816:	|  |  |     |  |   moveq #1,d1
    5818:	|  |  |     |  |   cmp.l d0,d1
    581a:	|  |  |     |  +-- bne.s 5830 <drawPeople+0x272>
				{
					thisPerson->samePosCount++;
    581c:	|  |  |     |  |   movea.l 24(sp),a0
    5820:	|  |  |     |  |   move.l 16(a0),d0
    5824:	|  |  |     |  |   addq.l #1,d0
    5826:	|  |  |     |  |   movea.l 24(sp),a0
    582a:	|  |  |     |  |   move.l d0,16(a0)
    582e:	|  |  |     +--|-- bra.s 5838 <drawPeople+0x27a>
				} else
				{
					thisPerson->samePosCount = 0;
    5830:	|  |  |     |  '-> movea.l 24(sp),a0
    5834:	|  |  |     |      clr.l 16(a0)
				}
			}

			thisPerson->oldx = thisPerson->x;
    5838:	|  |  |     '----> movea.l 24(sp),a0
    583c:	|  |  |            move.l (a0),d0
    583e:	|  |  |            movea.l 24(sp),a0
    5842:	|  |  |            move.l d0,8(a0)
			thisPerson->oldy = thisPerson->y;
    5846:	|  |  |            movea.l 24(sp),a0
    584a:	|  |  |            move.l 4(a0),d0
    584e:	|  |  |            movea.l 24(sp),a0
    5852:	|  |  |            move.l d0,12(a0)
			int fNumSign = myAnim -> frames[thisPerson -> frameNum].frameNum;
    5856:	|  |  |            movea.l 20(sp),a0
    585a:	|  |  |            movea.l 4(a0),a1
    585e:	|  |  |            movea.l 24(sp),a0
    5862:	|  |  |            move.l 84(a0),d0
    5866:	|  |  |            move.l d0,d1
    5868:	|  |  |            move.l d1,d0
    586a:	|  |  |            add.l d0,d0
    586c:	|  |  |            add.l d1,d0
    586e:	|  |  |            add.l d0,d0
    5870:	|  |  |            add.l d0,d0
    5872:	|  |  |            lea (0,a1,d0.l),a0
    5876:	|  |  |            move.l (a0),8(sp)
			int m = fNumSign < 0;
    587a:	|  |  |            move.l 8(sp),d0
    587e:	|  |  |            add.l d0,d0
    5880:	|  |  |            subx.l d0,d0
    5882:	|  |  |            neg.l d0
    5884:	|  |  |            move.b d0,d0
    5886:	|  |  |            move.b d0,d0
    5888:	|  |  |            andi.l #255,d0
    588e:	|  |  |            move.l d0,16(sp)
			int fNum = TF_abs(fNumSign);
    5892:	|  |  |            move.l 8(sp),-(sp)
    5896:	|  |  |            jsr 4ccc <TF_abs>
    589c:	|  |  |            addq.l #4,sp
    589e:	|  |  |            move.l d0,12(sp)
			if (fNum >= myAnim -> theSprites -> bank.total) {
    58a2:	|  |  |            movea.l 20(sp),a0
    58a6:	|  |  |            movea.l (a0),a0
    58a8:	|  |  |            move.l 8(a0),d0
    58ac:	|  |  |            cmp.l 12(sp),d0
    58b0:	|  |  |        ,-- bgt.s 58c0 <drawPeople+0x302>
				fNum = 0;
    58b2:	|  |  |        |   clr.l 12(sp)
				m = 2 - m;
    58b6:	|  |  |        |   moveq #2,d0
    58b8:	|  |  |        |   sub.l 16(sp),d0
    58bc:	|  |  |        |   move.l d0,16(sp)
			}
			if (m != 2) {
    58c0:	|  |  |        '-> moveq #2,d1
    58c2:	|  |  |            cmp.l 16(sp),d1
    58c6:	|  |  +----------- beq.s 5942 <drawPeople+0x384>
				BOOL r = FALSE;
    58c8:	|  |  |            clr.w 6(sp)

				r = scaleSprite ( &myAnim->theSprites->bank.sprites[fNum], thisPerson, m);
    58cc:	|  |  |            move.l 16(sp),d0
    58d0:	|  |  |            movea.w d0,a0
    58d2:	|  |  |            movea.l 20(sp),a1
    58d6:	|  |  |            movea.l (a1),a1
    58d8:	|  |  |            movea.l 16(a1),a1
    58dc:	|  |  |            move.l 12(sp),d1
    58e0:	|  |  |            move.l d1,d0
    58e2:	|  |  |            lsl.l #3,d0
    58e4:	|  |  |            sub.l d1,d0
    58e6:	|  |  |            add.l d0,d0
    58e8:	|  |  |            add.l d0,d0
    58ea:	|  |  |            add.l a1,d0
    58ec:	|  |  |            move.l a0,-(sp)
    58ee:	|  |  |            move.l 28(sp),-(sp)
    58f2:	|  |  |            move.l d0,-(sp)
    58f4:	|  |  |            jsr 49ee <scaleSprite>
    58fa:	|  |  |            lea 12(sp),sp
    58fe:	|  |  |            move.w d0,6(sp)
				if (r) {
    5902:	|  |  +----------- beq.s 5942 <drawPeople+0x384>
					if (thisPerson -> thisType -> screenName[0]) {
    5904:	|  |  |            movea.l 24(sp),a0
    5908:	|  |  |            movea.l 114(a0),a0
    590c:	|  |  |            movea.l (a0),a0
    590e:	|  |  |            move.b (a0),d0
    5910:	|  |  +----------- beq.s 5942 <drawPeople+0x384>
						if (personRegion.thisType != thisPerson -> thisType) lastRegion = NULL;
    5912:	|  |  |            move.l d098 <personRegion+0x1c>,d1
    5918:	|  |  |            movea.l 24(sp),a0
    591c:	|  |  |            move.l 114(a0),d0
    5920:	|  |  |            cmp.l d1,d0
    5922:	|  |  |        ,-- beq.s 592a <drawPeople+0x36c>
    5924:	|  |  |        |   clr.l cfe4 <lastRegion>
						personRegion.thisType = thisPerson -> thisType;
    592a:	|  |  |        '-> movea.l 24(sp),a0
    592e:	|  |  |            move.l 114(a0),d0
    5932:	|  |  |            move.l d0,d098 <personRegion+0x1c>
						overRegion = & personRegion;
    5938:	|  |  |            move.l #53372,d0e2 <overRegion>
					}
				}
			}
		}
		if (! -- thisPerson -> frameTick) {
    5942:	|  |  '----------> movea.l 24(sp),a0
    5946:	|  |               move.l 88(a0),d0
    594a:	|  |               subq.l #1,d0
    594c:	|  |               movea.l 24(sp),a0
    5950:	|  |               move.l d0,88(a0)
    5954:	|  |               movea.l 24(sp),a0
    5958:	|  |               move.l 88(a0),d0
    595c:	|  |        ,----- bne.w 5b84 <drawPeople+0x5c6>
			thisPerson -> frameNum ++;
    5960:	|  |        |      movea.l 24(sp),a0
    5964:	|  |        |      move.l 84(a0),d0
    5968:	|  |        |      addq.l #1,d0
    596a:	|  |        |      movea.l 24(sp),a0
    596e:	|  |        |      move.l d0,84(a0)
			thisPerson -> frameNum %= thisPerson -> myAnim -> numFrames;
    5972:	|  |        |      movea.l 24(sp),a0
    5976:	|  |        |      move.l 84(a0),d0
    597a:	|  |        |      movea.l 24(sp),a0
    597e:	|  |        |      movea.l 72(a0),a0
    5982:	|  |        |      move.l 8(a0),d1
    5986:	|  |        |      move.l d1,-(sp)
    5988:	|  |        |      move.l d0,-(sp)
    598a:	|  |        |      jsr 7c38 <__modsi3>
    5990:	|  |        |      addq.l #8,sp
    5992:	|  |        |      movea.l 24(sp),a0
    5996:	|  |        |      move.l d0,84(a0)
			thisPerson -> frameTick = thisPerson -> myAnim -> frames[thisPerson -> frameNum].howMany;
    599a:	|  |        |      movea.l 24(sp),a0
    599e:	|  |        |      movea.l 72(a0),a0
    59a2:	|  |        |      movea.l 4(a0),a1
    59a6:	|  |        |      movea.l 24(sp),a0
    59aa:	|  |        |      move.l 84(a0),d0
    59ae:	|  |        |      move.l d0,d1
    59b0:	|  |        |      move.l d1,d0
    59b2:	|  |        |      add.l d0,d0
    59b4:	|  |        |      add.l d1,d0
    59b6:	|  |        |      add.l d0,d0
    59b8:	|  |        |      add.l d0,d0
    59ba:	|  |        |      lea (0,a1,d0.l),a0
    59be:	|  |        |      move.l 4(a0),d0
    59c2:	|  |        |      movea.l 24(sp),a0
    59c6:	|  |        |      move.l d0,88(a0)
			if (thisPerson -> show && myAnim && myAnim -> frames) {
    59ca:	|  |        |      movea.l 24(sp),a0
    59ce:	|  |        |      move.w 104(a0),d0
    59d2:	|  |        +----- beq.w 5b84 <drawPeople+0x5c6>
    59d6:	|  |        |      tst.l 20(sp)
    59da:	|  |        +----- beq.w 5b84 <drawPeople+0x5c6>
    59de:	|  |        |      movea.l 20(sp),a0
    59e2:	|  |        |      move.l 4(a0),d0
    59e6:	|  |        +----- beq.w 5b84 <drawPeople+0x5c6>
				if (myAnim -> frames[thisPerson -> frameNum].noise > 0) {
    59ea:	|  |        |      movea.l 20(sp),a0
    59ee:	|  |        |      movea.l 4(a0),a1
    59f2:	|  |        |      movea.l 24(sp),a0
    59f6:	|  |        |      move.l 84(a0),d0
    59fa:	|  |        |      move.l d0,d1
    59fc:	|  |        |      move.l d1,d0
    59fe:	|  |        |      add.l d0,d0
    5a00:	|  |        |      add.l d1,d0
    5a02:	|  |        |      add.l d0,d0
    5a04:	|  |        |      add.l d0,d0
    5a06:	|  |        |      lea (0,a1,d0.l),a0
    5a0a:	|  |        |      move.l 8(a0),d0
    5a0e:	|  |        |  ,-- ble.w 5ab0 <drawPeople+0x4f2>
					startSound(myAnim -> frames[thisPerson -> frameNum].noise, FALSE);
    5a12:	|  |        |  |   movea.l 20(sp),a0
    5a16:	|  |        |  |   movea.l 4(a0),a1
    5a1a:	|  |        |  |   movea.l 24(sp),a0
    5a1e:	|  |        |  |   move.l 84(a0),d0
    5a22:	|  |        |  |   move.l d0,d1
    5a24:	|  |        |  |   move.l d1,d0
    5a26:	|  |        |  |   add.l d0,d0
    5a28:	|  |        |  |   add.l d1,d0
    5a2a:	|  |        |  |   add.l d0,d0
    5a2c:	|  |        |  |   add.l d0,d0
    5a2e:	|  |        |  |   lea (0,a1,d0.l),a0
    5a32:	|  |        |  |   move.l 8(a0),d0
    5a36:	|  |        |  |   clr.l -(sp)
    5a38:	|  |        |  |   move.l d0,-(sp)
    5a3a:	|  |        |  |   jsr 649e <startSound>
    5a40:	|  |        |  |   addq.l #8,sp
					thisPerson -> frameNum ++;
    5a42:	|  |        |  |   movea.l 24(sp),a0
    5a46:	|  |        |  |   move.l 84(a0),d0
    5a4a:	|  |        |  |   addq.l #1,d0
    5a4c:	|  |        |  |   movea.l 24(sp),a0
    5a50:	|  |        |  |   move.l d0,84(a0)
					thisPerson -> frameNum %= thisPerson -> myAnim -> numFrames;
    5a54:	|  |        |  |   movea.l 24(sp),a0
    5a58:	|  |        |  |   move.l 84(a0),d0
    5a5c:	|  |        |  |   movea.l 24(sp),a0
    5a60:	|  |        |  |   movea.l 72(a0),a0
    5a64:	|  |        |  |   move.l 8(a0),d1
    5a68:	|  |        |  |   move.l d1,-(sp)
    5a6a:	|  |        |  |   move.l d0,-(sp)
    5a6c:	|  |        |  |   jsr 7c38 <__modsi3>
    5a72:	|  |        |  |   addq.l #8,sp
    5a74:	|  |        |  |   movea.l 24(sp),a0
    5a78:	|  |        |  |   move.l d0,84(a0)
					thisPerson -> frameTick = thisPerson -> myAnim -> frames[thisPerson -> frameNum].howMany;
    5a7c:	|  |        |  |   movea.l 24(sp),a0
    5a80:	|  |        |  |   movea.l 72(a0),a0
    5a84:	|  |        |  |   movea.l 4(a0),a1
    5a88:	|  |        |  |   movea.l 24(sp),a0
    5a8c:	|  |        |  |   move.l 84(a0),d0
    5a90:	|  |        |  |   move.l d0,d1
    5a92:	|  |        |  |   move.l d1,d0
    5a94:	|  |        |  |   add.l d0,d0
    5a96:	|  |        |  |   add.l d1,d0
    5a98:	|  |        |  |   add.l d0,d0
    5a9a:	|  |        |  |   add.l d0,d0
    5a9c:	|  |        |  |   lea (0,a1,d0.l),a0
    5aa0:	|  |        |  |   move.l 4(a0),d0
    5aa4:	|  |        |  |   movea.l 24(sp),a0
    5aa8:	|  |        |  |   move.l d0,88(a0)
    5aac:	|  |        +--|-- bra.w 5b84 <drawPeople+0x5c6>
				} else if (myAnim -> frames[thisPerson -> frameNum].noise) {
    5ab0:	|  |        |  '-> movea.l 20(sp),a0
    5ab4:	|  |        |      movea.l 4(a0),a1
    5ab8:	|  |        |      movea.l 24(sp),a0
    5abc:	|  |        |      move.l 84(a0),d0
    5ac0:	|  |        |      move.l d0,d1
    5ac2:	|  |        |      move.l d1,d0
    5ac4:	|  |        |      add.l d0,d0
    5ac6:	|  |        |      add.l d1,d0
    5ac8:	|  |        |      add.l d0,d0
    5aca:	|  |        |      add.l d0,d0
    5acc:	|  |        |      lea (0,a1,d0.l),a0
    5ad0:	|  |        |      move.l 8(a0),d0
    5ad4:	|  |        +----- beq.w 5b84 <drawPeople+0x5c6>
					startNewFunctionNum (- myAnim -> frames[thisPerson -> frameNum].noise, 0, NULL, noStack, TRUE);
    5ad8:	|  |        |      movea.l cfe8 <noStack>,a1
    5ade:	|  |        |      movea.l 20(sp),a0
    5ae2:	|  |        |      move.l 4(a0),d2
    5ae6:	|  |        |      movea.l 24(sp),a0
    5aea:	|  |        |      move.l 84(a0),d0
    5aee:	|  |        |      move.l d0,d1
    5af0:	|  |        |      move.l d1,d0
    5af2:	|  |        |      add.l d0,d0
    5af4:	|  |        |      add.l d1,d0
    5af6:	|  |        |      add.l d0,d0
    5af8:	|  |        |      add.l d0,d0
    5afa:	|  |        |      movea.l d2,a0
    5afc:	|  |        |      adda.l d0,a0
    5afe:	|  |        |      move.l 8(a0),d0
    5b02:	|  |        |      neg.l d0
    5b04:	|  |        |      pea 1 <_start+0x1>
    5b08:	|  |        |      move.l a1,-(sp)
    5b0a:	|  |        |      clr.l -(sp)
    5b0c:	|  |        |      clr.l -(sp)
    5b0e:	|  |        |      move.l d0,-(sp)
    5b10:	|  |        |      jsr 3d2e <startNewFunctionNum>
    5b16:	|  |        |      lea 20(sp),sp
					thisPerson -> frameNum ++;
    5b1a:	|  |        |      movea.l 24(sp),a0
    5b1e:	|  |        |      move.l 84(a0),d0
    5b22:	|  |        |      addq.l #1,d0
    5b24:	|  |        |      movea.l 24(sp),a0
    5b28:	|  |        |      move.l d0,84(a0)
					thisPerson -> frameNum %= thisPerson -> myAnim -> numFrames;
    5b2c:	|  |        |      movea.l 24(sp),a0
    5b30:	|  |        |      move.l 84(a0),d0
    5b34:	|  |        |      movea.l 24(sp),a0
    5b38:	|  |        |      movea.l 72(a0),a0
    5b3c:	|  |        |      move.l 8(a0),d1
    5b40:	|  |        |      move.l d1,-(sp)
    5b42:	|  |        |      move.l d0,-(sp)
    5b44:	|  |        |      jsr 7c38 <__modsi3>
    5b4a:	|  |        |      addq.l #8,sp
    5b4c:	|  |        |      movea.l 24(sp),a0
    5b50:	|  |        |      move.l d0,84(a0)
					thisPerson -> frameTick = thisPerson -> myAnim -> frames[thisPerson -> frameNum].howMany;
    5b54:	|  |        |      movea.l 24(sp),a0
    5b58:	|  |        |      movea.l 72(a0),a0
    5b5c:	|  |        |      movea.l 4(a0),a1
    5b60:	|  |        |      movea.l 24(sp),a0
    5b64:	|  |        |      move.l 84(a0),d0
    5b68:	|  |        |      move.l d0,d1
    5b6a:	|  |        |      move.l d1,d0
    5b6c:	|  |        |      add.l d0,d0
    5b6e:	|  |        |      add.l d1,d0
    5b70:	|  |        |      add.l d0,d0
    5b72:	|  |        |      add.l d0,d0
    5b74:	|  |        |      lea (0,a1,d0.l),a0
    5b78:	|  |        |      move.l 4(a0),d0
    5b7c:	|  |        |      movea.l 24(sp),a0
    5b80:	|  |        |      move.l d0,88(a0)
				}
			}
		}
		thisPerson = thisPerson -> next;
    5b84:	|  |        '----> movea.l 24(sp),a0
    5b88:	|  |               move.l 36(a0),24(sp)
	while (thisPerson) {
    5b8e:	|  '-------------> tst.l 24(sp)
    5b92:	'----------------- bne.w 55e0 <drawPeople+0x22>
	}
}
    5b96:	                   nop
    5b98:	                   nop
    5b9a:	                   move.l (sp)+,d2
    5b9c:	                   lea 24(sp),sp
    5ba0:	                   rts

00005ba2 <initPeople>:
	return TRUE;
}


BOOL initPeople () {
	personRegion.sX = 0;
    5ba2:	clr.l d08c <personRegion+0x10>
	personRegion.sY = 0;
    5ba8:	clr.l d090 <personRegion+0x14>
	personRegion.di = -1;
    5bae:	moveq #-1,d0
    5bb0:	move.l d0,d094 <personRegion+0x18>
	allScreenRegions = NULL;
    5bb6:	clr.l d0de <allScreenRegions>

	return TRUE;
    5bbc:	moveq #1,d0
}
    5bbe:	rts

00005bc0 <makeNullAnim>:
		return FALSE;
	}
}


struct personaAnimation * makeNullAnim () {
    5bc0:	       lea -16(sp),sp
    5bc4:	       move.l a6,-(sp)

	struct personaAnimation * newAnim	= AllocVec(sizeof(struct personaAnimation),MEMF_ANY);
    5bc6:	       moveq #12,d0
    5bc8:	       move.l d0,16(sp)
    5bcc:	       clr.l 12(sp)
    5bd0:	       move.l d018 <SysBase>,d0
    5bd6:	       movea.l d0,a6
    5bd8:	       move.l 16(sp),d0
    5bdc:	       move.l 12(sp),d1
    5be0:	       jsr -684(a6)
    5be4:	       move.l d0,8(sp)
    5be8:	       move.l 8(sp),d0
    5bec:	       move.l d0,4(sp)
    if(newAnim == 0) {
    5bf0:	   ,-- bne.s 5c04 <makeNullAnim+0x44>
     	KPrintF("makeNullAnim: Can't reserve Memory\n");
    5bf2:	   |   pea 93df <PutChar+0x176b>
    5bf8:	   |   jsr 725e <KPrintF>
    5bfe:	   |   addq.l #4,sp
        return NULL;    
    5c00:	   |   moveq #0,d0
    5c02:	,--|-- bra.s 5c1e <makeNullAnim+0x5e>
    }  

	newAnim -> theSprites		= NULL;
    5c04:	|  '-> movea.l 4(sp),a0
    5c08:	|      clr.l (a0)
	newAnim -> numFrames		= 0;
    5c0a:	|      movea.l 4(sp),a0
    5c0e:	|      clr.l 8(a0)
	newAnim -> frames			= NULL;
    5c12:	|      movea.l 4(sp),a0
    5c16:	|      clr.l 4(a0)
	return newAnim;
    5c1a:	|      move.l 4(sp),d0
}
    5c1e:	'----> movea.l (sp)+,a6
    5c20:	       lea 16(sp),sp
    5c24:	       rts

00005c26 <moveAndScale>:

void moveAndScale (struct onScreenPerson *me, FLOAT x, FLOAT y) {
    5c26:	    move.l d2,-(sp)
	me->x = x;
    5c28:	    movea.l 8(sp),a0
    5c2c:	    move.l 12(sp),(a0)
	me->y = y;
    5c30:	    movea.l 8(sp),a0
    5c34:	    move.l 16(sp),4(a0)
	me->oldx = 0;
    5c3a:	    movea.l 8(sp),a0
    5c3e:	    clr.l 8(a0)
	me->oldy = 0;
    5c42:	    movea.l 8(sp),a0
    5c46:	    clr.l 12(a0)
	if (! (me->extra & EXTRA_NOSCALE) && scaleDivide) me->scale = (me->y - scaleHorizon) / scaleDivide;
    5c4a:	    movea.l 8(sp),a0
    5c4e:	    move.l 118(a0),d0
    5c52:	    moveq #2,d1
    5c54:	    and.l d1,d0
    5c56:	,-- bne.s 5cae <moveAndScale+0x88>
    5c58:	|   move.w cf42 <scaleDivide>,d0
    5c5e:	+-- beq.s 5cae <moveAndScale+0x88>
    5c60:	|   movea.l 8(sp),a0
    5c64:	|   move.l 4(a0),d2
    5c68:	|   move.w cf40 <scaleHorizon>,d0
    5c6e:	|   movea.w d0,a0
    5c70:	|   move.l a0,-(sp)
    5c72:	|   jsr 7690 <__floatsisf>
    5c78:	|   addq.l #4,sp
    5c7a:	|   move.l d0,-(sp)
    5c7c:	|   move.l d2,-(sp)
    5c7e:	|   jsr 7926 <__subsf3>
    5c84:	|   addq.l #8,sp
    5c86:	|   move.l d0,d2
    5c88:	|   move.w cf42 <scaleDivide>,d0
    5c8e:	|   movea.w d0,a0
    5c90:	|   move.l a0,-(sp)
    5c92:	|   jsr 7690 <__floatsisf>
    5c98:	|   addq.l #4,sp
    5c9a:	|   move.l d0,-(sp)
    5c9c:	|   move.l d2,-(sp)
    5c9e:	|   jsr 7546 <__divsf3>
    5ca4:	|   addq.l #8,sp
    5ca6:	|   movea.l 8(sp),a0
    5caa:	|   move.l d0,32(a0)
}
    5cae:	'-> nop
    5cb0:	    move.l (sp)+,d2
    5cb2:	    rts

00005cb4 <shufflePeople>:
			moveMe->transparency = 0;
			break;
	}
}

void shufflePeople () {
    5cb4:	             lea -20(sp),sp
	struct onScreenPerson ** thisReference = &allPeople;
    5cb8:	             move.l #53368,16(sp)
	struct onScreenPerson * A, * B;

	if (!allPeople) return;
    5cc0:	             move.l d078 <allPeople>,d0
    5cc6:	,----------- beq.w 5d9c <shufflePeople+0xe8>

	while ((*thisReference)->next) {
    5cca:	|     ,----- bra.w 5d8c <shufflePeople+0xd8>
		float y1 = (*thisReference)->y;
    5cce:	|  ,--|----> movea.l 16(sp),a0
    5cd2:	|  |  |      movea.l (a0),a0
    5cd4:	|  |  |      move.l 4(a0),12(sp)
		if ((*thisReference)->extra & EXTRA_FRONT) y1 += 1000;
    5cda:	|  |  |      movea.l 16(sp),a0
    5cde:	|  |  |      movea.l (a0),a0
    5ce0:	|  |  |      move.l 118(a0),d0
    5ce4:	|  |  |      moveq #1,d1
    5ce6:	|  |  |      and.l d1,d0
    5ce8:	|  |  |  ,-- beq.s 5d00 <shufflePeople+0x4c>
    5cea:	|  |  |  |   move.l #1148846080,-(sp)
    5cf0:	|  |  |  |   move.l 16(sp),-(sp)
    5cf4:	|  |  |  |   jsr 744c <__addsf3>
    5cfa:	|  |  |  |   addq.l #8,sp
    5cfc:	|  |  |  |   move.l d0,12(sp)

		float y2 = (*thisReference)->next->y;
    5d00:	|  |  |  '-> movea.l 16(sp),a0
    5d04:	|  |  |      movea.l (a0),a0
    5d06:	|  |  |      movea.l 36(a0),a0
    5d0a:	|  |  |      move.l 4(a0),8(sp)
		if ((*thisReference)->next->extra & EXTRA_FRONT) y2 += 1000;
    5d10:	|  |  |      movea.l 16(sp),a0
    5d14:	|  |  |      movea.l (a0),a0
    5d16:	|  |  |      movea.l 36(a0),a0
    5d1a:	|  |  |      move.l 118(a0),d0
    5d1e:	|  |  |      moveq #1,d1
    5d20:	|  |  |      and.l d1,d0
    5d22:	|  |  |  ,-- beq.s 5d3a <shufflePeople+0x86>
    5d24:	|  |  |  |   move.l #1148846080,-(sp)
    5d2a:	|  |  |  |   move.l 12(sp),-(sp)
    5d2e:	|  |  |  |   jsr 744c <__addsf3>
    5d34:	|  |  |  |   addq.l #8,sp
    5d36:	|  |  |  |   move.l d0,8(sp)

		if (y1 > y2) {
    5d3a:	|  |  |  '-> move.l 8(sp),-(sp)
    5d3e:	|  |  |      move.l 16(sp),-(sp)
    5d42:	|  |  |      jsr 77d4 <__gtsf2>
    5d48:	|  |  |      addq.l #8,sp
    5d4a:	|  |  |      tst.l d0
    5d4c:	|  |  |  ,-- ble.s 5d7e <shufflePeople+0xca>
			A = (*thisReference);
    5d4e:	|  |  |  |   movea.l 16(sp),a0
    5d52:	|  |  |  |   move.l (a0),4(sp)
			B = (*thisReference)->next;
    5d56:	|  |  |  |   movea.l 16(sp),a0
    5d5a:	|  |  |  |   movea.l (a0),a0
    5d5c:	|  |  |  |   move.l 36(a0),(sp)
			A->next = B->next;
    5d60:	|  |  |  |   movea.l (sp),a0
    5d62:	|  |  |  |   move.l 36(a0),d0
    5d66:	|  |  |  |   movea.l 4(sp),a0
    5d6a:	|  |  |  |   move.l d0,36(a0)
			B->next = A;
    5d6e:	|  |  |  |   movea.l (sp),a0
    5d70:	|  |  |  |   move.l 4(sp),36(a0)
			(*thisReference) = B;
    5d76:	|  |  |  |   movea.l 16(sp),a0
    5d7a:	|  |  |  |   move.l (sp),(a0)
    5d7c:	|  |  +--|-- bra.s 5d8c <shufflePeople+0xd8>
		} else {
			thisReference = &((*thisReference)->next);
    5d7e:	|  |  |  '-> movea.l 16(sp),a0
    5d82:	|  |  |      move.l (a0),d0
    5d84:	|  |  |      moveq #36,d1
    5d86:	|  |  |      add.l d0,d1
    5d88:	|  |  |      move.l d1,16(sp)
	while ((*thisReference)->next) {
    5d8c:	|  |  '----> movea.l 16(sp),a0
    5d90:	|  |         movea.l (a0),a0
    5d92:	|  |         move.l 36(a0),d0
    5d96:	|  '-------- bne.w 5cce <shufflePeople+0x1a>
    5d9a:	|        ,-- bra.s 5d9e <shufflePeople+0xea>
	if (!allPeople) return;
    5d9c:	'--------|-> nop
		}
	}
}
    5d9e:	         '-> lea 20(sp),sp
    5da2:	             rts

00005da4 <spinStep>:
void setShown (BOOL h, int ob) {
	struct onScreenPerson * moveMe = findPerson (ob);
	if (moveMe) moveMe -> show = h;
}

void spinStep (struct onScreenPerson * thisPerson) {
    5da4:	       subq.l #8,sp
    5da6:	       move.l d2,-(sp)
	int diff = (thisPerson->angle + 360) - thisPerson->wantAngle;
    5da8:	       movea.l 16(sp),a0
    5dac:	       move.l 92(a0),d0
    5db0:	       move.l d0,d1
    5db2:	       addi.l #360,d1
    5db8:	       movea.l 16(sp),a0
    5dbc:	       move.l 96(a0),d0
    5dc0:	       move.l d1,d2
    5dc2:	       sub.l d0,d2
    5dc4:	       move.l d2,8(sp)
	int eachSlice = thisPerson->spinSpeed ? thisPerson->spinSpeed : (360 / thisPerson->myPersona->numDirections);
    5dc8:	       movea.l 16(sp),a0
    5dcc:	       move.l 122(a0),d0
    5dd0:	   ,-- beq.s 5ddc <spinStep+0x38>
    5dd2:	   |   movea.l 16(sp),a0
    5dd6:	   |   move.l 122(a0),d0
    5dda:	,--|-- bra.s 5df6 <spinStep+0x52>
    5ddc:	|  '-> movea.l 16(sp),a0
    5de0:	|      movea.l 80(a0),a0
    5de4:	|      move.l 4(a0),d0
    5de8:	|      move.l d0,-(sp)
    5dea:	|      pea 168 <encodeFilename+0x50>
    5dee:	|      jsr 7c0a <__divsi3>
    5df4:	|      addq.l #8,sp
    5df6:	'----> move.l d0,4(sp)
	while (diff > 180) {
    5dfa:	   ,-- bra.s 5e04 <spinStep+0x60>
		diff -= 360;
    5dfc:	,--|-> addi.l #-360,8(sp)
	while (diff > 180) {
    5e04:	|  '-> cmpi.l #180,8(sp)
    5e0c:	'----- bgt.s 5dfc <spinStep+0x58>
	}

	if (diff >= eachSlice) {
    5e0e:	       move.l 8(sp),d0
    5e12:	       cmp.l 4(sp),d0
    5e16:	   ,-- blt.s 5e34 <spinStep+0x90>
		turnMeAngle(thisPerson, thisPerson->angle - eachSlice);
    5e18:	   |   movea.l 16(sp),a0
    5e1c:	   |   move.l 92(a0),d0
    5e20:	   |   sub.l 4(sp),d0
    5e24:	   |   move.l d0,-(sp)
    5e26:	   |   move.l 20(sp),-(sp)
    5e2a:	   |   jsr 5e82 <turnMeAngle>
    5e30:	   |   addq.l #8,sp
		turnMeAngle(thisPerson, thisPerson->angle + eachSlice);
	} else {
		turnMeAngle(thisPerson, thisPerson->wantAngle);
		thisPerson->spinning = FALSE;
	}
}
    5e32:	,--|-- bra.s 5e7a <spinStep+0xd6>
	} else if (diff <= -eachSlice) {
    5e34:	|  '-> move.l 4(sp),d0
    5e38:	|      neg.l d0
    5e3a:	|      cmp.l 8(sp),d0
    5e3e:	|  ,-- blt.s 5e5c <spinStep+0xb8>
		turnMeAngle(thisPerson, thisPerson->angle + eachSlice);
    5e40:	|  |   movea.l 16(sp),a0
    5e44:	|  |   move.l 92(a0),d0
    5e48:	|  |   add.l 4(sp),d0
    5e4c:	|  |   move.l d0,-(sp)
    5e4e:	|  |   move.l 20(sp),-(sp)
    5e52:	|  |   jsr 5e82 <turnMeAngle>
    5e58:	|  |   addq.l #8,sp
}
    5e5a:	+--|-- bra.s 5e7a <spinStep+0xd6>
		turnMeAngle(thisPerson, thisPerson->wantAngle);
    5e5c:	|  '-> movea.l 16(sp),a0
    5e60:	|      move.l 96(a0),d0
    5e64:	|      move.l d0,-(sp)
    5e66:	|      move.l 20(sp),-(sp)
    5e6a:	|      jsr 5e82 <turnMeAngle>
    5e70:	|      addq.l #8,sp
		thisPerson->spinning = FALSE;
    5e72:	|      movea.l 16(sp),a0
    5e76:	|      clr.w 66(a0)
}
    5e7a:	'----> nop
    5e7c:	       move.l (sp)+,d2
    5e7e:	       addq.l #8,sp
    5e80:	       rts

00005e82 <turnMeAngle>:
		total += fram -> frames[a].howMany;
	}
	return total;
}

void turnMeAngle (struct onScreenPerson * thisPerson, int direc) {
    5e82:	       subq.l #4,sp
	int d = thisPerson -> myPersona -> numDirections;
    5e84:	       movea.l 8(sp),a0
    5e88:	       movea.l 80(a0),a0
    5e8c:	       move.l 4(a0),(sp)
	thisPerson -> angle = direc;
    5e90:	       movea.l 8(sp),a0
    5e94:	       move.l 12(sp),92(a0)
	direc += (180 / d) + 180 + thisPerson -> angleOffset;
    5e9a:	       move.l (sp),-(sp)
    5e9c:	       pea b4 <_start+0xb4>
    5ea0:	       jsr 7c0a <__divsi3>
    5ea6:	       addq.l #8,sp
    5ea8:	       move.l d0,d1
    5eaa:	       addi.l #180,d1
    5eb0:	       movea.l 8(sp),a0
    5eb4:	       move.l 100(a0),d0
    5eb8:	       add.l d1,d0
    5eba:	       add.l d0,12(sp)
	while (direc >= 360) direc -= 360;
    5ebe:	   ,-- bra.s 5ec8 <turnMeAngle+0x46>
    5ec0:	,--|-> addi.l #-360,12(sp)
    5ec8:	|  '-> cmpi.l #359,12(sp)
    5ed0:	'----- bgt.s 5ec0 <turnMeAngle+0x3e>
	thisPerson -> direction = (direc * d) / 360;
    5ed2:	       move.l (sp),-(sp)
    5ed4:	       move.l 16(sp),-(sp)
    5ed8:	       jsr 7b8c <__mulsi3>
    5ede:	       addq.l #8,sp
    5ee0:	       pea 168 <encodeFilename+0x50>
    5ee4:	       move.l d0,-(sp)
    5ee6:	       jsr 7c0a <__divsi3>
    5eec:	       addq.l #8,sp
    5eee:	       movea.l 8(sp),a0
    5ef2:	       move.l d0,106(a0)
}
    5ef6:	       nop
    5ef8:	       addq.l #4,sp
    5efa:	       rts

00005efc <walkAllPeople>:
        return TRUE;
    }
    return FALSE;
}

void walkAllPeople() {
    5efc:	             subq.l #4,sp
	struct onScreenPerson *thisPerson = allPeople;
    5efe:	             move.l d078 <allPeople>,(sp)

	while (thisPerson) {
    5f04:	   ,-------- bra.s 5f74 <walkAllPeople+0x78>
		if (thisPerson->walking) {
    5f06:	,--|-------> movea.l (sp),a0
    5f08:	|  |         move.w 64(a0),d0
    5f0c:	|  |     ,-- beq.s 5f20 <walkAllPeople+0x24>
			walkMe(thisPerson, TRUE);
    5f0e:	|  |     |   pea 1 <_start+0x1>
    5f12:	|  |     |   move.l 4(sp),-(sp)
    5f16:	|  |     |   jsr 5f80 <walkMe>
    5f1c:	|  |     |   addq.l #8,sp
    5f1e:	|  |  ,--|-- bra.s 5f40 <walkAllPeople+0x44>
		} else if (thisPerson->spinning) {
    5f20:	|  |  |  '-> movea.l (sp),a0
    5f22:	|  |  |      move.w 66(a0),d0
    5f26:	|  |  +----- beq.s 5f40 <walkAllPeople+0x44>
			spinStep(thisPerson);
    5f28:	|  |  |      move.l (sp),-(sp)
    5f2a:	|  |  |      jsr 5da4 <spinStep>
    5f30:	|  |  |      addq.l #4,sp
			setFrames(thisPerson, ANI_STAND);
    5f32:	|  |  |      clr.l -(sp)
    5f34:	|  |  |      move.l 4(sp),-(sp)
    5f38:	|  |  |      jsr 24e6 <setFrames>
    5f3e:	|  |  |      addq.l #8,sp
		}
		if ((!thisPerson->walking) && (!thisPerson->spinning) && thisPerson->continueAfterWalking) {
    5f40:	|  |  '----> movea.l (sp),a0
    5f42:	|  |         move.w 64(a0),d0
    5f46:	|  |     ,-- bne.s 5f6e <walkAllPeople+0x72>
    5f48:	|  |     |   movea.l (sp),a0
    5f4a:	|  |     |   move.w 66(a0),d0
    5f4e:	|  |     +-- bne.s 5f6e <walkAllPeople+0x72>
    5f50:	|  |     |   movea.l (sp),a0
    5f52:	|  |     |   move.l 68(a0),d0
    5f56:	|  |     +-- beq.s 5f6e <walkAllPeople+0x72>
			restartFunction(thisPerson->continueAfterWalking);
    5f58:	|  |     |   movea.l (sp),a0
    5f5a:	|  |     |   move.l 68(a0),d0
    5f5e:	|  |     |   move.l d0,-(sp)
    5f60:	|  |     |   jsr 3bb8 <restartFunction>
    5f66:	|  |     |   addq.l #4,sp
			thisPerson->continueAfterWalking = NULL;
    5f68:	|  |     |   movea.l (sp),a0
    5f6a:	|  |     |   clr.l 68(a0)
		}
		thisPerson = thisPerson->next;
    5f6e:	|  |     '-> movea.l (sp),a0
    5f70:	|  |         move.l 36(a0),(sp)
	while (thisPerson) {
    5f74:	|  '-------> tst.l (sp)
    5f76:	'----------- bne.s 5f06 <walkAllPeople+0xa>
	}
}
    5f78:	             nop
    5f7a:	             nop
    5f7c:	             addq.l #4,sp
    5f7e:	             rts

00005f80 <walkMe>:

BOOL walkMe (struct onScreenPerson * thisPerson, BOOL move) {
    5f80:	                lea -20(sp),sp
    5f84:	                move.l d3,-(sp)
    5f86:	                move.l d2,-(sp)
    5f88:	                move.l 36(sp),d0
    5f8c:	                move.w d0,d0
    5f8e:	                move.w d0,10(sp)
	float xDiff, yDiff, maxDiff, s;

	if (move == -1) move = TRUE;  // Initialize default value for move
    5f92:	                cmpi.w #-1,10(sp)
    5f98:	,-------------- bne.s 5fa0 <walkMe+0x20>
    5f9a:	|               move.w #1,10(sp)

	for (;;) {
		xDiff = thisPerson->thisStepX - thisPerson->x;
    5fa0:	>-------------> movea.l 32(sp),a0
    5fa4:	|               move.l 48(a0),d0
    5fa8:	|               move.l d0,-(sp)
    5faa:	|               jsr 7690 <__floatsisf>
    5fb0:	|               addq.l #4,sp
    5fb2:	|               move.l d0,d1
    5fb4:	|               movea.l 32(sp),a0
    5fb8:	|               move.l (a0),d0
    5fba:	|               move.l d0,-(sp)
    5fbc:	|               move.l d1,-(sp)
    5fbe:	|               jsr 7926 <__subsf3>
    5fc4:	|               addq.l #8,sp
    5fc6:	|               move.l d0,20(sp)
		yDiff = (thisPerson->thisStepY - thisPerson->y) * 2;
    5fca:	|               movea.l 32(sp),a0
    5fce:	|               move.l 52(a0),d0
    5fd2:	|               move.l d0,-(sp)
    5fd4:	|               jsr 7690 <__floatsisf>
    5fda:	|               addq.l #4,sp
    5fdc:	|               move.l d0,d1
    5fde:	|               movea.l 32(sp),a0
    5fe2:	|               move.l 4(a0),d0
    5fe6:	|               move.l d0,-(sp)
    5fe8:	|               move.l d1,-(sp)
    5fea:	|               jsr 7926 <__subsf3>
    5ff0:	|               addq.l #8,sp
    5ff2:	|               move.l d0,-(sp)
    5ff4:	|               move.l d0,-(sp)
    5ff6:	|               jsr 744c <__addsf3>
    5ffc:	|               addq.l #8,sp
    5ffe:	|               move.l d0,16(sp)
		s = thisPerson->scale * thisPerson->walkSpeed;
    6002:	|               movea.l 32(sp),a0
    6006:	|               move.l 32(a0),d2
    600a:	|               movea.l 32(sp),a0
    600e:	|               move.l 28(a0),d0
    6012:	|               move.l d0,-(sp)
    6014:	|               jsr 7690 <__floatsisf>
    601a:	|               addq.l #4,sp
    601c:	|               move.l d0,-(sp)
    601e:	|               move.l d2,-(sp)
    6020:	|               jsr 771a <__mulsf3>
    6026:	|               addq.l #8,sp
    6028:	|               move.l d0,24(sp)
		if (s < 0.2) s = 0.2;
    602c:	|               move.l 24(sp),-(sp)
    6030:	|               jsr 75b2 <__extendsfdf2>
    6036:	|               addq.l #4,sp
    6038:	|               move.l #-1717986918,-(sp)
    603e:	|               move.l #1070176665,-(sp)
    6044:	|               move.l d1,-(sp)
    6046:	|               move.l d0,-(sp)
    6048:	|               jsr 780a <__ltdf2>
    604e:	|               lea 16(sp),sp
    6052:	|               tst.l d0
    6054:	|           ,-- bge.s 605e <walkMe+0xde>
    6056:	|           |   move.l #1045220557,24(sp)

		maxDiff = (TF_abs(xDiff) >= TF_abs(yDiff)) ? TF_abs(xDiff) : TF_abs(yDiff);
    605e:	|           '-> move.l 20(sp),-(sp)
    6062:	|               jsr 7628 <__fixsfsi>
    6068:	|               addq.l #4,sp
    606a:	|               move.l d0,-(sp)
    606c:	|               jsr 4ccc <TF_abs>
    6072:	|               addq.l #4,sp
    6074:	|               move.l d0,d2
    6076:	|               move.l 16(sp),-(sp)
    607a:	|               jsr 7628 <__fixsfsi>
    6080:	|               addq.l #4,sp
    6082:	|               move.l d0,-(sp)
    6084:	|               jsr 4ccc <TF_abs>
    608a:	|               addq.l #4,sp
    608c:	|               cmp.l d2,d0
    608e:	|        ,----- bgt.s 60b2 <walkMe+0x132>
    6090:	|        |      move.l 20(sp),-(sp)
    6094:	|        |      jsr 7628 <__fixsfsi>
    609a:	|        |      addq.l #4,sp
    609c:	|        |      move.l d0,-(sp)
    609e:	|        |      jsr 4ccc <TF_abs>
    60a4:	|        |      addq.l #4,sp
    60a6:	|        |      move.l d0,-(sp)
    60a8:	|        |      jsr 7690 <__floatsisf>
    60ae:	|        |      addq.l #4,sp
    60b0:	|        |  ,-- bra.s 60d2 <walkMe+0x152>
    60b2:	|        '--|-> move.l 16(sp),-(sp)
    60b6:	|           |   jsr 7628 <__fixsfsi>
    60bc:	|           |   addq.l #4,sp
    60be:	|           |   move.l d0,-(sp)
    60c0:	|           |   jsr 4ccc <TF_abs>
    60c6:	|           |   addq.l #4,sp
    60c8:	|           |   move.l d0,-(sp)
    60ca:	|           |   jsr 7690 <__floatsisf>
    60d0:	|           |   addq.l #4,sp
    60d2:	|           '-> move.l d0,12(sp)

		if (TF_abs(maxDiff) > s) {
    60d6:	|               move.l 12(sp),-(sp)
    60da:	|               jsr 7628 <__fixsfsi>
    60e0:	|               addq.l #4,sp
    60e2:	|               move.l d0,-(sp)
    60e4:	|               jsr 4ccc <TF_abs>
    60ea:	|               addq.l #4,sp
    60ec:	|               move.l d0,-(sp)
    60ee:	|               jsr 7690 <__floatsisf>
    60f4:	|               addq.l #4,sp
    60f6:	|               move.l d0,-(sp)
    60f8:	|               move.l 28(sp),-(sp)
    60fc:	|               jsr 7858 <__ltsf2>
    6102:	|               addq.l #8,sp
    6104:	|               tst.l d0
    6106:	|        ,----- bge.w 61b8 <walkMe+0x238>
			if (thisPerson->spinning) {
    610a:	|        |      movea.l 32(sp),a0
    610e:	|        |      move.w 66(a0),d0
    6112:	|        |  ,-- beq.s 6130 <walkMe+0x1b0>
				spinStep(thisPerson);
    6114:	|        |  |   move.l 32(sp),-(sp)
    6118:	|        |  |   jsr 5da4 <spinStep>
    611e:	|        |  |   addq.l #4,sp
				setFrames(thisPerson, ANI_WALK);
    6120:	|        |  |   pea 1 <_start+0x1>
    6124:	|        |  |   move.l 36(sp),-(sp)
    6128:	|        |  |   jsr 24e6 <setFrames>
    612e:	|        |  |   addq.l #8,sp
			}
			s = maxDiff / s;
    6130:	|        |  '-> move.l 24(sp),-(sp)
    6134:	|        |      move.l 16(sp),-(sp)
    6138:	|        |      jsr 7546 <__divsf3>
    613e:	|        |      addq.l #8,sp
    6140:	|        |      move.l d0,24(sp)
			if (move)
    6144:	|        |      tst.w 10(sp)
    6148:	|        |  ,-- beq.s 61b2 <walkMe+0x232>
				moveAndScale(thisPerson,
							 thisPerson->x + xDiff / s,
							 thisPerson->y + yDiff / (s * 2));
    614a:	|        |  |   movea.l 32(sp),a0
    614e:	|        |  |   move.l 4(a0),d2
    6152:	|        |  |   move.l 24(sp),d0
    6156:	|        |  |   move.l d0,-(sp)
    6158:	|        |  |   move.l d0,-(sp)
    615a:	|        |  |   jsr 744c <__addsf3>
    6160:	|        |  |   addq.l #8,sp
    6162:	|        |  |   move.l d0,-(sp)
    6164:	|        |  |   move.l 20(sp),-(sp)
    6168:	|        |  |   jsr 7546 <__divsf3>
    616e:	|        |  |   addq.l #8,sp
				moveAndScale(thisPerson,
    6170:	|        |  |   move.l d0,-(sp)
    6172:	|        |  |   move.l d2,-(sp)
    6174:	|        |  |   jsr 744c <__addsf3>
    617a:	|        |  |   addq.l #8,sp
    617c:	|        |  |   move.l d0,d2
							 thisPerson->x + xDiff / s,
    617e:	|        |  |   movea.l 32(sp),a0
    6182:	|        |  |   move.l (a0),d3
    6184:	|        |  |   move.l 24(sp),-(sp)
    6188:	|        |  |   move.l 24(sp),-(sp)
    618c:	|        |  |   jsr 7546 <__divsf3>
    6192:	|        |  |   addq.l #8,sp
				moveAndScale(thisPerson,
    6194:	|        |  |   move.l d0,-(sp)
    6196:	|        |  |   move.l d3,-(sp)
    6198:	|        |  |   jsr 744c <__addsf3>
    619e:	|        |  |   addq.l #8,sp
    61a0:	|        |  |   move.l d2,-(sp)
    61a2:	|        |  |   move.l d0,-(sp)
    61a4:	|        |  |   move.l 40(sp),-(sp)
    61a8:	|        |  |   jsr 5c26 <moveAndScale>
    61ae:	|        |  |   lea 12(sp),sp
			return TRUE;
    61b2:	|        |  '-> moveq #1,d0
    61b4:	|  ,-----|----- bra.w 6266 <walkMe+0x2e6>
		}

		if (thisPerson->inPoly == -1) {
    61b8:	|  |     '----> movea.l 32(sp),a0
    61bc:	|  |            move.l 56(a0),d0
    61c0:	|  |            moveq #-1,d1
    61c2:	|  |            cmp.l d0,d1
    61c4:	|  |        ,-- bne.s 61fc <walkMe+0x27c>
			if (thisPerson->directionWhenDoneWalking != -1) {
    61c6:	|  |        |   movea.l 32(sp),a0
    61ca:	|  |        |   move.l 110(a0),d0
    61ce:	|  |        |   moveq #-1,d1
    61d0:	|  |        |   cmp.l d0,d1
    61d2:	|  |  ,-----|-- beq.s 6210 <walkMe+0x290>
				thisPerson->wantAngle = thisPerson->directionWhenDoneWalking;
    61d4:	|  |  |     |   movea.l 32(sp),a0
    61d8:	|  |  |     |   move.l 110(a0),d0
    61dc:	|  |  |     |   movea.l 32(sp),a0
    61e0:	|  |  |     |   move.l d0,96(a0)
				thisPerson->spinning = TRUE;
    61e4:	|  |  |     |   movea.l 32(sp),a0
    61e8:	|  |  |     |   move.w #1,66(a0)
				spinStep(thisPerson);
    61ee:	|  |  |     |   move.l 32(sp),-(sp)
    61f2:	|  |  |     |   jsr 5da4 <spinStep>
    61f8:	|  |  |     |   addq.l #4,sp
			}
			break;
    61fa:	|  |  +-----|-- bra.s 6210 <walkMe+0x290>
		}
		if (!doBorderStuff(thisPerson)) break;
    61fc:	|  |  |     '-> move.l 32(sp),-(sp)
    6200:	|  |  |         jsr 4f04 <doBorderStuff>
    6206:	|  |  |         addq.l #4,sp
    6208:	|  |  |         tst.w d0
    620a:	|  |  |  ,----- beq.s 6214 <walkMe+0x294>
		xDiff = thisPerson->thisStepX - thisPerson->x;
    620c:	'--|--|--|----- bra.w 5fa0 <walkMe+0x20>
			break;
    6210:	   |  '--|----> nop
    6212:	   |     |  ,-- bra.s 6216 <walkMe+0x296>
		if (!doBorderStuff(thisPerson)) break;
    6214:	   |     '--|-> nop
	}

	thisPerson->walking = FALSE;
    6216:	   |        '-> movea.l 32(sp),a0
    621a:	   |            clr.w 64(a0)
	setFrames(thisPerson, ANI_STAND);
    621e:	   |            clr.l -(sp)
    6220:	   |            move.l 36(sp),-(sp)
    6224:	   |            jsr 24e6 <setFrames>
    622a:	   |            addq.l #8,sp
	moveAndScale(thisPerson,
				 thisPerson->walkToX,
				 thisPerson->walkToY);
    622c:	   |            movea.l 32(sp),a0
    6230:	   |            move.l 44(a0),d0
	moveAndScale(thisPerson,
    6234:	   |            move.l d0,-(sp)
    6236:	   |            jsr 7690 <__floatsisf>
    623c:	   |            addq.l #4,sp
    623e:	   |            move.l d0,d2
				 thisPerson->walkToX,
    6240:	   |            movea.l 32(sp),a0
    6244:	   |            move.l 40(a0),d0
	moveAndScale(thisPerson,
    6248:	   |            move.l d0,-(sp)
    624a:	   |            jsr 7690 <__floatsisf>
    6250:	   |            addq.l #4,sp
    6252:	   |            move.l d2,-(sp)
    6254:	   |            move.l d0,-(sp)
    6256:	   |            move.l 40(sp),-(sp)
    625a:	   |            jsr 5c26 <moveAndScale>
    6260:	   |            lea 12(sp),sp
	return FALSE;
    6264:	   |            clr.w d0
}
    6266:	   '----------> move.l (sp)+,d2
    6268:	                move.l (sp)+,d3
    626a:	                lea 20(sp),sp
    626e:	                rts

00006270 <CsiCheckInput>:
extern struct inputType input;

UWORD counterx_old = 0;
UWORD countery_old = 0;

void CsiCheckInput() {
    6270:	          lea -12(sp),sp
    volatile struct Custom *custom = (struct Custom*)0xdff000;
    6274:	          move.l #14675968,4(sp)
    UWORD value = custom->joy0dat;
    627c:	          movea.l 4(sp),a0
    6280:	          move.w 10(a0),2(sp)
    UBYTE countery_new = (UBYTE) (custom->joy0dat >> 8);
    6286:	          movea.l 4(sp),a0
    628a:	          move.w 10(a0),d0
    628e:	          lsr.w #8,d0
    6290:	          move.b d0,1(sp)
    UBYTE counterx_new = (UBYTE) (custom->joy0dat & 0xffff);
    6294:	          movea.l 4(sp),a0
    6298:	          move.w 10(a0),d0
    629c:	          move.b d0,(sp)

    if(counterx_new)
    629e:	,-------- beq.w 6344 <CsiCheckInput+0xd4>
    {
        WORD counterx_diff = counterx_new - counterx_old;
    62a2:	|         clr.w d1
    62a4:	|         move.b (sp),d1
    62a6:	|         move.w d0a0 <counterx_old>,d0
    62ac:	|         sub.w d0,d1
    62ae:	|         move.w d1,10(sp)

        if(counterx_diff > 127) {
    62b2:	|         cmpi.w #128,10(sp)
    62b8:	|     ,-- blt.s 62d0 <CsiCheckInput+0x60>
            input.justMoved = TRUE;                
    62ba:	|     |   move.w #1,cfd2 <input+0x4>
            counterx_diff -= 256;    
    62c2:	|     |   move.w 10(sp),d0
    62c6:	|     |   addi.w #-256,d0
    62ca:	|     |   move.w d0,10(sp)
    62ce:	|  ,--|-- bra.s 62fc <CsiCheckInput+0x8c>
        } else if (counterx_diff < -128) {
    62d0:	|  |  '-> cmpi.w #-129,10(sp)
    62d6:	|  |  ,-- bgt.s 62ee <CsiCheckInput+0x7e>
            counterx_diff += 256;
    62d8:	|  |  |   move.w 10(sp),d0
    62dc:	|  |  |   addi.w #256,d0
    62e0:	|  |  |   move.w d0,10(sp)
            input.justMoved = TRUE;
    62e4:	|  |  |   move.w #1,cfd2 <input+0x4>
    62ec:	|  +--|-- bra.s 62fc <CsiCheckInput+0x8c>
        } else if (counterx_diff) {
    62ee:	|  |  '-> tst.w 10(sp)
    62f2:	|  +----- beq.s 62fc <CsiCheckInput+0x8c>
            input.justMoved = TRUE;
    62f4:	|  |      move.w #1,cfd2 <input+0x4>
        }

        input.mouseX += counterx_diff;
    62fc:	|  '----> move.l cfd8 <input+0xa>,d0
    6302:	|         movea.w 10(sp),a0
    6306:	|         add.l a0,d0
    6308:	|         move.l d0,cfd8 <input+0xa>

        if( input.mouseX > (int) winWidth) {
    630e:	|         move.l cfd8 <input+0xa>,d1
    6314:	|         move.l cf86 <winWidth>,d0
    631a:	|         cmp.l d1,d0
    631c:	|     ,-- bge.s 632c <CsiCheckInput+0xbc>
            input.mouseX = winWidth;            
    631e:	|     |   move.l cf86 <winWidth>,d0
    6324:	|     |   move.l d0,cfd8 <input+0xa>
    632a:	|  ,--|-- bra.s 633a <CsiCheckInput+0xca>
        }
        else if(input.mouseX < 0) {
    632c:	|  |  '-> move.l cfd8 <input+0xa>,d0
    6332:	|  +----- bpl.s 633a <CsiCheckInput+0xca>
            input.mouseX = 0;
    6334:	|  |      clr.l cfd8 <input+0xa>
        }

        //KPrintF("CsiCheckInput: MouseX = %d\n", input.mouseX);
        counterx_old = counterx_new;
    633a:	|  '----> clr.w d0
    633c:	|         move.b (sp),d0
    633e:	|         move.w d0,d0a0 <counterx_old>
    }    

    if(countery_new)
    6344:	'-------> tst.b 1(sp)
    6348:	,-------- beq.w 63f2 <CsiCheckInput+0x182>
    {
        WORD countery_diff = countery_new - countery_old;
    634c:	|         clr.w d1
    634e:	|         move.b 1(sp),d1
    6352:	|         move.w d0a2 <countery_old>,d0
    6358:	|         sub.w d0,d1
    635a:	|         move.w d1,8(sp)

        if(countery_diff > 127) {
    635e:	|         cmpi.w #128,8(sp)
    6364:	|     ,-- blt.s 637c <CsiCheckInput+0x10c>
            input.justMoved = TRUE;                
    6366:	|     |   move.w #1,cfd2 <input+0x4>
            countery_diff -= 256;    
    636e:	|     |   move.w 8(sp),d0
    6372:	|     |   addi.w #-256,d0
    6376:	|     |   move.w d0,8(sp)
    637a:	|  ,--|-- bra.s 63a8 <CsiCheckInput+0x138>
        } else if (countery_diff < -128) {
    637c:	|  |  '-> cmpi.w #-129,8(sp)
    6382:	|  |  ,-- bgt.s 639a <CsiCheckInput+0x12a>
            input.justMoved = TRUE;                
    6384:	|  |  |   move.w #1,cfd2 <input+0x4>
            countery_diff += 256;
    638c:	|  |  |   move.w 8(sp),d0
    6390:	|  |  |   addi.w #256,d0
    6394:	|  |  |   move.w d0,8(sp)
    6398:	|  +--|-- bra.s 63a8 <CsiCheckInput+0x138>
        } else if (countery_diff) {
    639a:	|  |  '-> tst.w 8(sp)
    639e:	|  +----- beq.s 63a8 <CsiCheckInput+0x138>
            input.justMoved = TRUE;
    63a0:	|  |      move.w #1,cfd2 <input+0x4>
        }

        input.mouseY += countery_diff;
    63a8:	|  '----> move.l cfdc <input+0xe>,d0
    63ae:	|         movea.w 8(sp),a0
    63b2:	|         add.l a0,d0
    63b4:	|         move.l d0,cfdc <input+0xe>

        if( input.mouseY > (int) winHeight) {
    63ba:	|         move.l cfdc <input+0xe>,d1
    63c0:	|         move.l cf8a <winHeight>,d0
    63c6:	|         cmp.l d1,d0
    63c8:	|     ,-- bge.s 63d8 <CsiCheckInput+0x168>
            input.mouseY = winHeight;            
    63ca:	|     |   move.l cf8a <winHeight>,d0
    63d0:	|     |   move.l d0,cfdc <input+0xe>
    63d6:	|  ,--|-- bra.s 63e6 <CsiCheckInput+0x176>
        }
        else if(input.mouseY < 0) {
    63d8:	|  |  '-> move.l cfdc <input+0xe>,d0
    63de:	|  +----- bpl.s 63e6 <CsiCheckInput+0x176>
            input.mouseY = 0;
    63e0:	|  |      clr.l cfdc <input+0xe>
        }

        //KPrintF("CsiCheckInput: MouseX = %d\n", input.mouseX);
        countery_old = countery_new;
    63e6:	|  '----> clr.w d0
    63e8:	|         move.b 1(sp),d0
    63ec:	|         move.w d0,d0a2 <countery_old>
    } 

    input.leftRelease = FALSE;
    63f2:	'-------> clr.w cfd4 <input+0x6>
    input.rightRelease = FALSE;
    63f8:	          clr.w cfd6 <input+0x8>

    if(input.leftClick && ((*(volatile UBYTE*)0xbfe001)&64))
    63fe:	          move.w cfce <input>,d0
    6404:	      ,-- beq.s 642a <CsiCheckInput+0x1ba>
    6406:	      |   movea.l #12574721,a0
    640c:	      |   move.b (a0),d0
    640e:	      |   move.b d0,d0
    6410:	      |   andi.l #255,d0
    6416:	      |   moveq #64,d1
    6418:	      |   and.l d1,d0
    641a:	      +-- beq.s 642a <CsiCheckInput+0x1ba>
    {
        input.leftClick = FALSE;
    641c:	      |   clr.w cfce <input>
        input.leftRelease = TRUE;
    6422:	      |   move.w #1,cfd4 <input+0x6>
    }

    if(input.rightClick && ((*(volatile UWORD*)0xdff016)&(1<<10)))
    642a:	      '-> move.w cfd0 <input+0x2>,d0
    6430:	      ,-- beq.s 6458 <CsiCheckInput+0x1e8>
    6432:	      |   movea.l #14675990,a0
    6438:	      |   move.w (a0),d0
    643a:	      |   move.w d0,d0
    643c:	      |   andi.l #65535,d0
    6442:	      |   andi.l #1024,d0
    6448:	      +-- beq.s 6458 <CsiCheckInput+0x1e8>
    {
        input.rightClick = FALSE;
    644a:	      |   clr.w cfd0 <input+0x2>
        input.rightRelease = TRUE;
    6450:	      |   move.w #1,cfd6 <input+0x8>
    }


    if(!((*(volatile UBYTE*)0xbfe001)&64)) {
    6458:	      '-> movea.l #12574721,a0
    645e:	          move.b (a0),d0
    6460:	          move.b d0,d0
    6462:	          andi.l #255,d0
    6468:	          moveq #64,d1
    646a:	          and.l d1,d0
    646c:	      ,-- bne.s 6476 <CsiCheckInput+0x206>
        input.leftClick = TRUE;              
    646e:	      |   move.w #1,cfce <input>
    } 
    if(!((*(volatile UWORD*)0xdff016)&(1<<10)) ) {
    6476:	      '-> movea.l #14675990,a0
    647c:	          move.w (a0),d0
    647e:	          move.w d0,d0
    6480:	          andi.l #65535,d0
    6486:	          andi.l #1024,d0
    648c:	      ,-- bne.s 6496 <CsiCheckInput+0x226>
        input.rightClick = TRUE;
    648e:	      |   move.w #1,cfd0 <input+0x2>
    }

    6496:	      '-> nop
    6498:	          lea 12(sp),sp
    649c:	          rts

0000649e <startSound>:

void setSoundVolume (int a, int v) {
//#pragma unused (a,v)
}

BOOL startSound (int f, BOOL loopy) {	
    649e:	subq.l #4,sp
    64a0:	move.l 12(sp),d0
    64a4:	move.w d0,d0
    64a6:	move.w d0,2(sp)
//#pragma unused (f,loopy)
	return TRUE;
    64aa:	moveq #1,d0
}
    64ac:	addq.l #4,sp
    64ae:	rts

000064b0 <killBackDrop>:
   	KPrintF("Amiga: Function not implemented."); //Todo: Amigize this
}


void killBackDrop () {
	CstFreeBuffer();
    64b0:	jsr 1162 <CstFreeBuffer>
	deleteTextures (1, &backdropTextureName);
    64b6:	pea d0ac <backdropTextureName>
    64bc:	pea 1 <_start+0x1>
    64c0:	jsr 2530 <deleteTextures>
    64c6:	addq.l #8,sp
	backdropTextureName = 0;
    64c8:	clr.l d0ac <backdropTextureName>
	backdropExists = FALSE;
    64ce:	clr.w d0b0 <backdropExists>
}
    64d4:	nop
    64d6:	rts

000064d8 <killParallax>:

void killParallax () {
    64d8:	          lea -12(sp),sp
    64dc:	          move.l a6,-(sp)
	while (parallaxStuff) {
    64de:	   ,----- bra.s 654a <killParallax+0x72>

		struct parallaxLayer * k = parallaxStuff;
    64e0:	,--|----> move.l d0b2 <parallaxStuff>,12(sp)
		parallaxStuff = k->next;
    64e8:	|  |      movea.l 12(sp),a0
    64ec:	|  |      move.l 42(a0),d0
    64f0:	|  |      move.l d0,d0b2 <parallaxStuff>

		// Now kill the image
		deleteTextures (1, &k->textureName);
    64f6:	|  |      move.l 12(sp),d0
    64fa:	|  |      addq.l #4,d0
    64fc:	|  |      move.l d0,-(sp)
    64fe:	|  |      pea 1 <_start+0x1>
    6502:	|  |      jsr 2530 <deleteTextures>
    6508:	|  |      addq.l #8,sp
		if( k->texture) FreeVec(k->texture);
    650a:	|  |      movea.l 12(sp),a0
    650e:	|  |      move.l (a0),d0
    6510:	|  |  ,-- beq.s 652a <killParallax+0x52>
    6512:	|  |  |   movea.l 12(sp),a0
    6516:	|  |  |   move.l (a0),8(sp)
    651a:	|  |  |   move.l d018 <SysBase>,d0
    6520:	|  |  |   movea.l d0,a6
    6522:	|  |  |   movea.l 8(sp),a1
    6526:	|  |  |   jsr -690(a6)
		if( k) FreeVec(k);
    652a:	|  |  '-> tst.l 12(sp)
    652e:	|  |  ,-- beq.s 6546 <killParallax+0x6e>
    6530:	|  |  |   move.l 12(sp),4(sp)
    6536:	|  |  |   move.l d018 <SysBase>,d0
    653c:	|  |  |   movea.l d0,a6
    653e:	|  |  |   movea.l 4(sp),a1
    6542:	|  |  |   jsr -690(a6)
		k = NULL;
    6546:	|  |  '-> clr.l 12(sp)
	while (parallaxStuff) {
    654a:	|  '----> move.l d0b2 <parallaxStuff>,d0
    6550:	'-------- bne.s 64e0 <killParallax+0x8>
	}
}
    6552:	          nop
    6554:	          nop
    6556:	          movea.l (sp)+,a6
    6558:	          lea 12(sp),sp
    655c:	          rts

0000655e <reserveBackdrop>:
	deleteTextures (1, &snapshotTextureName);
	snapshotTextureName = 0;
}

BOOL reserveBackdrop () {	
	cameraX = 0;
    655e:	clr.l d0b6 <cameraX>
	cameraY = 0;
    6564:	clr.l d0ba <cameraY>
	
	return CstReserveBackdrop(sceneWidth, sceneHeight);
    656a:	move.l d0a8 <sceneHeight>,d0
    6570:	move.l d0,d1
    6572:	move.l d0a4 <sceneWidth>,d0
    6578:	move.l d1,-(sp)
    657a:	move.l d0,-(sp)
    657c:	jsr 20ae <CstReserveBackdrop>
    6582:	addq.l #8,sp
}
    6584:	rts

00006586 <resizeBackdrop>:

BOOL resizeBackdrop (int x, int y) {
    killBackDrop ();
    6586:	jsr 64b0 <killBackDrop>
	killParallax ();
    658c:	jsr 64d8 <killParallax>
	killZBuffer ();
    6592:	jsr 487c <killZBuffer>
	sceneWidth = x;
    6598:	move.l 4(sp),d0
    659c:	move.l d0,d0a4 <sceneWidth>
	sceneHeight = y;
    65a2:	move.l 8(sp),d0
    65a6:	move.l d0,d0a8 <sceneHeight>
	KPrintF("resizeBackdrop: Reserving new Backdrop");
    65ac:	pea 96f4 <PutChar+0x1a80>
    65b2:	jsr 725e <KPrintF>
    65b8:	addq.l #4,sp
	return reserveBackdrop();
    65ba:	jsr 655e <reserveBackdrop>
	KPrintF("resizeBackdrop: Backdrop reserved");	
}
    65c0:	rts

000065c2 <initObjectTypes>:

	return num;
}

BOOL initObjectTypes () {
	return TRUE;
    65c2:	moveq #1,d0
}
    65c4:	rts

000065c6 <getLanguageForFileB>:
int *languageTable;
char **languageName;
struct settingsStruct gameSettings;

int getLanguageForFileB ()
{
    65c6:	          subq.l #8,sp
	int indexNum = -1;
    65c8:	          moveq #-1,d0
    65ca:	          move.l d0,4(sp)

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    65ce:	          clr.l (sp)
    65d0:	   ,----- bra.s 65f6 <getLanguageForFileB+0x30>
		if ((unsigned int) languageTable[i] == gameSettings.languageID) indexNum = i;
    65d2:	,--|----> move.l d0be <languageTable>,d1
    65d8:	|  |      move.l (sp),d0
    65da:	|  |      add.l d0,d0
    65dc:	|  |      add.l d0,d0
    65de:	|  |      movea.l d1,a0
    65e0:	|  |      adda.l d0,a0
    65e2:	|  |      move.l (a0),d0
    65e4:	|  |      move.l d0,d1
    65e6:	|  |      move.l d0c6 <gameSettings>,d0
    65ec:	|  |      cmp.l d1,d0
    65ee:	|  |  ,-- bne.s 65f4 <getLanguageForFileB+0x2e>
    65f0:	|  |  |   move.l (sp),4(sp)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    65f4:	|  |  '-> addq.l #1,(sp)
    65f6:	|  '----> move.l d0ca <gameSettings+0x4>,d0
    65fc:	|         cmp.l (sp),d0
    65fe:	'-------- bcc.s 65d2 <getLanguageForFileB+0xc>
	}

	return indexNum;
    6600:	          move.l 4(sp),d0
}
    6604:	          addq.l #8,sp
    6606:	          rts

00006608 <getPrefsFilename>:

char * getPrefsFilename (char * filename) {
    6608:	          lea -20(sp),sp
    660c:	          move.l a6,-(sp)
	// Yes, this trashes the original string, but
	// we also free it at the end (warning!)...

	int n, i;

	n = strlen (filename);
    660e:	          move.l 28(sp),-(sp)
    6612:	          jsr 6ce0 <strlen>
    6618:	          addq.l #4,sp
    661a:	          move.l d0,12(sp)


	if (n > 4 && filename[n-4] == '.') {
    661e:	          moveq #4,d0
    6620:	          cmp.l 12(sp),d0
    6624:	      ,-- bge.s 6648 <getPrefsFilename+0x40>
    6626:	      |   move.l 12(sp),d0
    662a:	      |   subq.l #4,d0
    662c:	      |   movea.l 28(sp),a0
    6630:	      |   adda.l d0,a0
    6632:	      |   move.b (a0),d0
    6634:	      |   cmpi.b #46,d0
    6638:	      +-- bne.s 6648 <getPrefsFilename+0x40>
		filename[n-4] = 0;
    663a:	      |   move.l 12(sp),d0
    663e:	      |   subq.l #4,d0
    6640:	      |   movea.l 28(sp),a0
    6644:	      |   adda.l d0,a0
    6646:	      |   clr.b (a0)
	}

	char * f = filename;
    6648:	      '-> move.l 28(sp),16(sp)
	for (i = 0; i<n; i++) {
    664e:	          clr.l 20(sp)
    6652:	   ,----- bra.s 667a <getPrefsFilename+0x72>
		if (filename[i] == '/') f = filename + i + 1;
    6654:	,--|----> move.l 20(sp),d0
    6658:	|  |      movea.l 28(sp),a0
    665c:	|  |      adda.l d0,a0
    665e:	|  |      move.b (a0),d0
    6660:	|  |      cmpi.b #47,d0
    6664:	|  |  ,-- bne.s 6676 <getPrefsFilename+0x6e>
    6666:	|  |  |   move.l 20(sp),d0
    666a:	|  |  |   addq.l #1,d0
    666c:	|  |  |   move.l 28(sp),d1
    6670:	|  |  |   add.l d0,d1
    6672:	|  |  |   move.l d1,16(sp)
	for (i = 0; i<n; i++) {
    6676:	|  |  '-> addq.l #1,20(sp)
    667a:	|  '----> move.l 20(sp),d0
    667e:	|         cmp.l 12(sp),d0
    6682:	'-------- blt.s 6654 <getPrefsFilename+0x4c>
	}

	char * joined = joinStrings (f, ".ini");
    6684:	          pea a99a <PutChar+0x2d26>
    668a:	          move.l 20(sp),-(sp)
    668e:	          jsr 6d20 <joinStrings>
    6694:	          addq.l #8,sp
    6696:	          move.l d0,8(sp)

	FreeVec(filename);
    669a:	          move.l 28(sp),4(sp)
    66a0:	          move.l d018 <SysBase>,d0
    66a6:	          movea.l d0,a6
    66a8:	          movea.l 4(sp),a1
    66ac:	          jsr -690(a6)
	filename = NULL;
    66b0:	          clr.l 28(sp)
	return joined;
    66b4:	          move.l 8(sp),d0
}
    66b8:	          movea.l (sp)+,a6
    66ba:	          lea 20(sp),sp
    66be:	          rts

000066c0 <makeLanguageTable>:

void makeLanguageTable (BPTR table)
{
    66c0:	             lea -28(sp),sp
    66c4:	             move.l a6,-(sp)
    66c6:	             move.l a2,-(sp)
	languageTable = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    66c8:	             move.l d0ca <gameSettings+0x4>,d0
    66ce:	             move.l d0,d1
    66d0:	             addq.l #1,d1
    66d2:	             move.l d1,28(sp)
    66d6:	             clr.l 24(sp)
    66da:	             move.l d018 <SysBase>,d0
    66e0:	             movea.l d0,a6
    66e2:	             move.l 28(sp),d0
    66e6:	             move.l 24(sp),d1
    66ea:	             jsr -684(a6)
    66ee:	             move.l d0,20(sp)
    66f2:	             move.l 20(sp),d0
    66f6:	             move.l d0,d0be <languageTable>
    if( languageTable == 0) {
    66fc:	             move.l d0be <languageTable>,d0
    6702:	         ,-- bne.s 6712 <makeLanguageTable+0x52>
        KPrintF("makeLanguageTable: Cannot Alloc Mem for languageTable");
    6704:	         |   pea a99f <PutChar+0x2d2b>
    670a:	         |   jsr 725e <KPrintF>
    6710:	         |   addq.l #4,sp
    }

	languageName = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    6712:	         '-> move.l d0ca <gameSettings+0x4>,d0
    6718:	             move.l d0,d1
    671a:	             addq.l #1,d1
    671c:	             move.l d1,16(sp)
    6720:	             clr.l 12(sp)
    6724:	             move.l d018 <SysBase>,d0
    672a:	             movea.l d0,a6
    672c:	             move.l 16(sp),d0
    6730:	             move.l 12(sp),d1
    6734:	             jsr -684(a6)
    6738:	             move.l d0,8(sp)
    673c:	             move.l 8(sp),d0
    6740:	             move.l d0,d0c2 <languageName>
	if( languageName == 0) {
    6746:	             move.l d0c2 <languageName>,d0
    674c:	         ,-- bne.s 675c <makeLanguageTable+0x9c>
        KPrintF("makeLanguageName: Cannot Alloc Mem for languageName");
    674e:	         |   pea a9d5 <PutChar+0x2d61>
    6754:	         |   jsr 725e <KPrintF>
    675a:	         |   addq.l #4,sp
    }

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    675c:	         '-> clr.l 32(sp)
    6760:	   ,-------- bra.s 67d8 <makeLanguageTable+0x118>
		languageTable[i] = i ? get2bytes (table) : 0;
    6762:	,--|-------> tst.l 32(sp)
    6766:	|  |  ,----- beq.s 6776 <makeLanguageTable+0xb6>
    6768:	|  |  |      move.l 40(sp),-(sp)
    676c:	|  |  |      jsr 4d6 <get2bytes>
    6772:	|  |  |      addq.l #4,sp
    6774:	|  |  |  ,-- bra.s 6778 <makeLanguageTable+0xb8>
    6776:	|  |  '--|-> moveq #0,d0
    6778:	|  |     '-> movea.l d0be <languageTable>,a0
    677e:	|  |         move.l 32(sp),d1
    6782:	|  |         add.l d1,d1
    6784:	|  |         add.l d1,d1
    6786:	|  |         adda.l d1,a0
    6788:	|  |         move.l d0,(a0)
		languageName[i] = 0;
    678a:	|  |         move.l d0c2 <languageName>,d1
    6790:	|  |         move.l 32(sp),d0
    6794:	|  |         add.l d0,d0
    6796:	|  |         add.l d0,d0
    6798:	|  |         movea.l d1,a0
    679a:	|  |         adda.l d0,a0
    679c:	|  |         clr.l (a0)
		if (gameVersion >= VERSION(2,0)) {
    679e:	|  |         move.l cfc6 <gameVersion>,d0
    67a4:	|  |         cmpi.l #511,d0
    67aa:	|  |     ,-- ble.s 67d4 <makeLanguageTable+0x114>
			if (gameSettings.numLanguages)
    67ac:	|  |     |   move.l d0ca <gameSettings+0x4>,d0
    67b2:	|  |     +-- beq.s 67d4 <makeLanguageTable+0x114>
				languageName[i] = readString (table);
    67b4:	|  |     |   move.l d0c2 <languageName>,d1
    67ba:	|  |     |   move.l 32(sp),d0
    67be:	|  |     |   add.l d0,d0
    67c0:	|  |     |   add.l d0,d0
    67c2:	|  |     |   movea.l d1,a2
    67c4:	|  |     |   adda.l d0,a2
    67c6:	|  |     |   move.l 40(sp),-(sp)
    67ca:	|  |     |   jsr 66e <readString>
    67d0:	|  |     |   addq.l #4,sp
    67d2:	|  |     |   move.l d0,(a2)
	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
    67d4:	|  |     '-> addq.l #1,32(sp)
    67d8:	|  '-------> move.l d0ca <gameSettings+0x4>,d0
    67de:	|            cmp.l 32(sp),d0
    67e2:	'----------- bcc.w 6762 <makeLanguageTable+0xa2>
		}
	}
}
    67e6:	             nop
    67e8:	             nop
    67ea:	             movea.l (sp)+,a2
    67ec:	             movea.l (sp)+,a6
    67ee:	             lea 28(sp),sp
    67f2:	             rts

000067f4 <readIniFile>:

void readIniFile (char * filename) {
    67f4:	                      lea -564(sp),sp
    67f8:	                      move.l a6,-(sp)
    67fa:	                      move.l d2,-(sp)
	char * langName = getPrefsFilename (copyString (filename));
    67fc:	                      move.l 576(sp),-(sp)
    6800:	                      jsr b8 <copyString>
    6806:	                      addq.l #4,sp
    6808:	                      move.l d0,-(sp)
    680a:	                      jsr 6608 <getPrefsFilename>
    6810:	                      addq.l #4,sp
    6812:	                      move.l d0,562(sp)

	langName = joinStrings ("/", langName);
    6816:	                      move.l 562(sp),-(sp)
    681a:	                      pea 9f75 <PutChar+0x2301>
    6820:	                      jsr 6d20 <joinStrings>
    6826:	                      addq.l #8,sp
    6828:	                      move.l d0,562(sp)
	BPTR fp = Open(langName,MODE_OLDFILE);	
    682c:	                      move.l 562(sp),558(sp)
    6832:	                      move.l #1005,554(sp)
    683a:	                      move.l d020 <DOSBase>,d0
    6840:	                      movea.l d0,a6
    6842:	                      move.l 558(sp),d1
    6846:	                      move.l 554(sp),d2
    684a:	                      jsr -30(a6)
    684e:	                      move.l d0,550(sp)
    6852:	                      move.l 550(sp),d0
    6856:	                      move.l d0,546(sp)

	gameSettings.languageID = 0;
    685a:	                      clr.l d0c6 <gameSettings>
	gameSettings.userFullScreen = TRUE; //Always fullscreen on AMIGA
    6860:	                      move.w #1,d0ce <gameSettings+0x8>
	gameSettings.refreshRate = 0;
    6868:	                      clr.l d0d0 <gameSettings+0xa>
	gameSettings.antiAlias = 1;
    686e:	                      moveq #1,d0
    6870:	                      move.l d0,d0d4 <gameSettings+0xe>
	gameSettings.fixedPixels = FALSE;
    6876:	                      clr.w d0d8 <gameSettings+0x12>
	gameSettings.noStartWindow = FALSE;
    687c:	                      clr.w d0da <gameSettings+0x14>
	gameSettings.debugMode = FALSE;
    6882:	                      clr.w d0dc <gameSettings+0x16>

	FreeVec(langName);
    6888:	                      move.l 562(sp),542(sp)
    688e:	                      move.l d018 <SysBase>,d0
    6894:	                      movea.l d0,a6
    6896:	                      movea.l 542(sp),a1
    689a:	                      jsr -690(a6)
	langName = NULL;
    689e:	                      clr.l 562(sp)

	if (fp) {
    68a2:	                      tst.l 546(sp)
    68a6:	,-------------------- beq.w 6b84 <readIniFile+0x390>
		char lineSoFar[257] = "";
    68aa:	|                     move.l sp,d0
    68ac:	|                     addi.l #265,d0
    68b2:	|                     move.l #257,d1
    68b8:	|                     move.l d1,-(sp)
    68ba:	|                     clr.l -(sp)
    68bc:	|                     move.l d0,-(sp)
    68be:	|                     jsr 722e <memset>
    68c4:	|                     lea 12(sp),sp
		char secondSoFar[257] = "";
    68c8:	|                     move.l sp,d0
    68ca:	|                     addq.l #8,d0
    68cc:	|                     move.l #257,d1
    68d2:	|                     move.l d1,-(sp)
    68d4:	|                     clr.l -(sp)
    68d6:	|                     move.l d0,-(sp)
    68d8:	|                     jsr 722e <memset>
    68de:	|                     lea 12(sp),sp
		unsigned char here = 0;
    68e2:	|                     clr.b 571(sp)
		char readChar = ' ';
    68e6:	|                     move.b #32,570(sp)
		BOOL keepGoing = TRUE;
    68ec:	|                     move.w #1,568(sp)
		BOOL doingSecond = FALSE;
    68f2:	|                     clr.w 566(sp)
		LONG tmp = 0;
    68f6:	|                     clr.l 538(sp)

		do {

			tmp = FGetC (fp);
    68fa:	|  ,----------------> move.l 546(sp),534(sp)
    6900:	|  |                  move.l d020 <DOSBase>,d0
    6906:	|  |                  movea.l d0,a6
    6908:	|  |                  move.l 534(sp),d1
    690c:	|  |                  jsr -306(a6)
    6910:	|  |                  move.l d0,530(sp)
    6914:	|  |                  move.l 530(sp),d0
    6918:	|  |                  move.l d0,538(sp)
			if (tmp == - 1) {
    691c:	|  |                  moveq #-1,d1
    691e:	|  |                  cmp.l 538(sp),d1
    6922:	|  |           ,----- bne.s 6930 <readIniFile+0x13c>
				readChar = '\n';
    6924:	|  |           |      move.b #10,570(sp)
				keepGoing = FALSE;
    692a:	|  |           |      clr.w 568(sp)
    692e:	|  |           |  ,-- bra.s 6936 <readIniFile+0x142>
			} else {
				readChar = (char) tmp;
    6930:	|  |           '--|-> move.b 541(sp),570(sp)
			}

			switch (readChar) {
    6936:	|  |              '-> move.b 570(sp),d0
    693a:	|  |                  ext.w d0
    693c:	|  |                  movea.w d0,a0
    693e:	|  |                  moveq #61,d0
    6940:	|  |                  cmp.l a0,d0
    6942:	|  |     ,----------- beq.w 6aec <readIniFile+0x2f8>
    6946:	|  |     |            moveq #61,d1
    6948:	|  |     |            cmp.l a0,d1
    694a:	|  |  ,--|----------- blt.w 6af8 <readIniFile+0x304>
    694e:	|  |  |  |            moveq #10,d0
    6950:	|  |  |  |            cmp.l a0,d0
    6952:	|  |  |  |        ,-- beq.s 695c <readIniFile+0x168>
    6954:	|  |  |  |        |   moveq #13,d1
    6956:	|  |  |  |        |   cmp.l a0,d1
    6958:	|  |  +--|--------|-- bne.w 6af8 <readIniFile+0x304>
				case '\n':
				case '\r':
				if (doingSecond) {
    695c:	|  |  |  |        '-> tst.w 566(sp)
    6960:	|  |  |  |     ,----- beq.w 6ada <readIniFile+0x2e6>
					if (strcmp (lineSoFar, "LANGUAGE") == 0)
    6964:	|  |  |  |     |      pea aa09 <PutChar+0x2d95>
    696a:	|  |  |  |     |      move.l sp,d0
    696c:	|  |  |  |     |      addi.l #269,d0
    6972:	|  |  |  |     |      move.l d0,-(sp)
    6974:	|  |  |  |     |      jsr 6ca0 <strcmp>
    697a:	|  |  |  |     |      addq.l #8,sp
    697c:	|  |  |  |     |      tst.l d0
    697e:	|  |  |  |     |  ,-- bne.s 6998 <readIniFile+0x1a4>
					{
						gameSettings.languageID = stringToInt (secondSoFar);
    6980:	|  |  |  |     |  |   move.l sp,d0
    6982:	|  |  |  |     |  |   addq.l #8,d0
    6984:	|  |  |  |     |  |   move.l d0,-(sp)
    6986:	|  |  |  |     |  |   jsr 6b90 <stringToInt>
    698c:	|  |  |  |     |  |   addq.l #4,sp
    698e:	|  |  |  |     |  |   move.l d0,d0c6 <gameSettings>
    6994:	|  |  |  |     +--|-- bra.w 6ada <readIniFile+0x2e6>
					}
					else if (strcmp (lineSoFar, "WINDOW") == 0)
    6998:	|  |  |  |     |  '-> pea aa12 <PutChar+0x2d9e>
    699e:	|  |  |  |     |      move.l sp,d0
    69a0:	|  |  |  |     |      addi.l #269,d0
    69a6:	|  |  |  |     |      move.l d0,-(sp)
    69a8:	|  |  |  |     |      jsr 6ca0 <strcmp>
    69ae:	|  |  |  |     |      addq.l #8,sp
    69b0:	|  |  |  |     |      tst.l d0
    69b2:	|  |  |  |     |  ,-- bne.s 69d8 <readIniFile+0x1e4>
					{
						gameSettings.userFullScreen = ! stringToInt (secondSoFar);
    69b4:	|  |  |  |     |  |   move.l sp,d0
    69b6:	|  |  |  |     |  |   addq.l #8,d0
    69b8:	|  |  |  |     |  |   move.l d0,-(sp)
    69ba:	|  |  |  |     |  |   jsr 6b90 <stringToInt>
    69c0:	|  |  |  |     |  |   addq.l #4,sp
    69c2:	|  |  |  |     |  |   tst.l d0
    69c4:	|  |  |  |     |  |   seq d0
    69c6:	|  |  |  |     |  |   neg.b d0
    69c8:	|  |  |  |     |  |   move.b d0,d0
    69ca:	|  |  |  |     |  |   andi.w #255,d0
    69ce:	|  |  |  |     |  |   move.w d0,d0ce <gameSettings+0x8>
    69d4:	|  |  |  |     +--|-- bra.w 6ada <readIniFile+0x2e6>
					}
					else if (strcmp (lineSoFar, "REFRESH") == 0)
    69d8:	|  |  |  |     |  '-> pea aa19 <PutChar+0x2da5>
    69de:	|  |  |  |     |      move.l sp,d0
    69e0:	|  |  |  |     |      addi.l #269,d0
    69e6:	|  |  |  |     |      move.l d0,-(sp)
    69e8:	|  |  |  |     |      jsr 6ca0 <strcmp>
    69ee:	|  |  |  |     |      addq.l #8,sp
    69f0:	|  |  |  |     |      tst.l d0
    69f2:	|  |  |  |     |  ,-- bne.s 6a0c <readIniFile+0x218>
					{
						gameSettings.refreshRate = stringToInt (secondSoFar);
    69f4:	|  |  |  |     |  |   move.l sp,d0
    69f6:	|  |  |  |     |  |   addq.l #8,d0
    69f8:	|  |  |  |     |  |   move.l d0,-(sp)
    69fa:	|  |  |  |     |  |   jsr 6b90 <stringToInt>
    6a00:	|  |  |  |     |  |   addq.l #4,sp
    6a02:	|  |  |  |     |  |   move.l d0,d0d0 <gameSettings+0xa>
    6a08:	|  |  |  |     +--|-- bra.w 6ada <readIniFile+0x2e6>
					}
					else if (strcmp (lineSoFar, "ANTIALIAS") == 0)
    6a0c:	|  |  |  |     |  '-> pea aa21 <PutChar+0x2dad>
    6a12:	|  |  |  |     |      move.l sp,d0
    6a14:	|  |  |  |     |      addi.l #269,d0
    6a1a:	|  |  |  |     |      move.l d0,-(sp)
    6a1c:	|  |  |  |     |      jsr 6ca0 <strcmp>
    6a22:	|  |  |  |     |      addq.l #8,sp
    6a24:	|  |  |  |     |      tst.l d0
    6a26:	|  |  |  |     |  ,-- bne.s 6a40 <readIniFile+0x24c>
					{
						gameSettings.antiAlias = stringToInt (secondSoFar);
    6a28:	|  |  |  |     |  |   move.l sp,d0
    6a2a:	|  |  |  |     |  |   addq.l #8,d0
    6a2c:	|  |  |  |     |  |   move.l d0,-(sp)
    6a2e:	|  |  |  |     |  |   jsr 6b90 <stringToInt>
    6a34:	|  |  |  |     |  |   addq.l #4,sp
    6a36:	|  |  |  |     |  |   move.l d0,d0d4 <gameSettings+0xe>
    6a3c:	|  |  |  |     +--|-- bra.w 6ada <readIniFile+0x2e6>
					}
					else if (strcmp (lineSoFar, "FIXEDPIXELS") == 0)
    6a40:	|  |  |  |     |  '-> pea aa2b <PutChar+0x2db7>
    6a46:	|  |  |  |     |      move.l sp,d0
    6a48:	|  |  |  |     |      addi.l #269,d0
    6a4e:	|  |  |  |     |      move.l d0,-(sp)
    6a50:	|  |  |  |     |      jsr 6ca0 <strcmp>
    6a56:	|  |  |  |     |      addq.l #8,sp
    6a58:	|  |  |  |     |      tst.l d0
    6a5a:	|  |  |  |     |  ,-- bne.s 6a74 <readIniFile+0x280>
					{
						gameSettings.fixedPixels = stringToInt (secondSoFar);
    6a5c:	|  |  |  |     |  |   move.l sp,d0
    6a5e:	|  |  |  |     |  |   addq.l #8,d0
    6a60:	|  |  |  |     |  |   move.l d0,-(sp)
    6a62:	|  |  |  |     |  |   jsr 6b90 <stringToInt>
    6a68:	|  |  |  |     |  |   addq.l #4,sp
    6a6a:	|  |  |  |     |  |   move.l d0,d0
    6a6c:	|  |  |  |     |  |   move.w d0,d0d8 <gameSettings+0x12>
    6a72:	|  |  |  |     +--|-- bra.s 6ada <readIniFile+0x2e6>
					}
					else if (strcmp (lineSoFar, "NOSTARTWINDOW") == 0)
    6a74:	|  |  |  |     |  '-> pea aa37 <PutChar+0x2dc3>
    6a7a:	|  |  |  |     |      move.l sp,d0
    6a7c:	|  |  |  |     |      addi.l #269,d0
    6a82:	|  |  |  |     |      move.l d0,-(sp)
    6a84:	|  |  |  |     |      jsr 6ca0 <strcmp>
    6a8a:	|  |  |  |     |      addq.l #8,sp
    6a8c:	|  |  |  |     |      tst.l d0
    6a8e:	|  |  |  |     |  ,-- bne.s 6aa8 <readIniFile+0x2b4>
					{
						gameSettings.noStartWindow = stringToInt (secondSoFar);
    6a90:	|  |  |  |     |  |   move.l sp,d0
    6a92:	|  |  |  |     |  |   addq.l #8,d0
    6a94:	|  |  |  |     |  |   move.l d0,-(sp)
    6a96:	|  |  |  |     |  |   jsr 6b90 <stringToInt>
    6a9c:	|  |  |  |     |  |   addq.l #4,sp
    6a9e:	|  |  |  |     |  |   move.l d0,d0
    6aa0:	|  |  |  |     |  |   move.w d0,d0da <gameSettings+0x14>
    6aa6:	|  |  |  |     +--|-- bra.s 6ada <readIniFile+0x2e6>
					}
					else if (strcmp (lineSoFar, "DEBUGMODE") == 0)
    6aa8:	|  |  |  |     |  '-> pea aa45 <PutChar+0x2dd1>
    6aae:	|  |  |  |     |      move.l sp,d0
    6ab0:	|  |  |  |     |      addi.l #269,d0
    6ab6:	|  |  |  |     |      move.l d0,-(sp)
    6ab8:	|  |  |  |     |      jsr 6ca0 <strcmp>
    6abe:	|  |  |  |     |      addq.l #8,sp
    6ac0:	|  |  |  |     |      tst.l d0
    6ac2:	|  |  |  |     +----- bne.s 6ada <readIniFile+0x2e6>
					{
						gameSettings.debugMode = stringToInt (secondSoFar);
    6ac4:	|  |  |  |     |      move.l sp,d0
    6ac6:	|  |  |  |     |      addq.l #8,d0
    6ac8:	|  |  |  |     |      move.l d0,-(sp)
    6aca:	|  |  |  |     |      jsr 6b90 <stringToInt>
    6ad0:	|  |  |  |     |      addq.l #4,sp
    6ad2:	|  |  |  |     |      move.l d0,d0
    6ad4:	|  |  |  |     |      move.w d0,d0dc <gameSettings+0x16>
					}
				}
				here = 0;
    6ada:	|  |  |  |     '----> clr.b 571(sp)
				doingSecond = FALSE;
    6ade:	|  |  |  |            clr.w 566(sp)
				lineSoFar[0] = 0;
    6ae2:	|  |  |  |            clr.b 265(sp)
				secondSoFar[0] = 0;
    6ae6:	|  |  |  |            clr.b 8(sp)
				break;
    6aea:	|  |  |  |  ,-------- bra.s 6b62 <readIniFile+0x36e>

				case '=':
				doingSecond = TRUE;
    6aec:	|  |  |  '--|-------> move.w #1,566(sp)
				here = 0;
    6af2:	|  |  |     |         clr.b 571(sp)
				break;
    6af6:	|  |  |     +-------- bra.s 6b62 <readIniFile+0x36e>

				default:
				if (doingSecond) {
    6af8:	|  |  '-----|-------> tst.w 566(sp)
    6afc:	|  |        |  ,----- beq.s 6b30 <readIniFile+0x33c>
					secondSoFar[here ++] = readChar;
    6afe:	|  |        |  |      move.b 571(sp),d0
    6b02:	|  |        |  |      move.b d0,d1
    6b04:	|  |        |  |      addq.b #1,d1
    6b06:	|  |        |  |      move.b d1,571(sp)
    6b0a:	|  |        |  |      move.b d0,d0
    6b0c:	|  |        |  |      andi.l #255,d0
    6b12:	|  |        |  |      lea 572(sp),a0
    6b16:	|  |        |  |      adda.l d0,a0
    6b18:	|  |        |  |      move.b 570(sp),-564(a0)
					secondSoFar[here] = 0;
    6b1e:	|  |        |  |      moveq #0,d0
    6b20:	|  |        |  |      move.b 571(sp),d0
    6b24:	|  |        |  |      lea 572(sp),a0
    6b28:	|  |        |  |      adda.l d0,a0
    6b2a:	|  |        |  |      clr.b -564(a0)
				} else {
					lineSoFar[here ++] = readChar;
					lineSoFar[here] = 0;
				}
				break;
    6b2e:	|  |        |  |  ,-- bra.s 6b60 <readIniFile+0x36c>
					lineSoFar[here ++] = readChar;
    6b30:	|  |        |  '--|-> move.b 571(sp),d0
    6b34:	|  |        |     |   move.b d0,d1
    6b36:	|  |        |     |   addq.b #1,d1
    6b38:	|  |        |     |   move.b d1,571(sp)
    6b3c:	|  |        |     |   move.b d0,d0
    6b3e:	|  |        |     |   andi.l #255,d0
    6b44:	|  |        |     |   lea 572(sp),a0
    6b48:	|  |        |     |   adda.l d0,a0
    6b4a:	|  |        |     |   move.b 570(sp),-307(a0)
					lineSoFar[here] = 0;
    6b50:	|  |        |     |   moveq #0,d0
    6b52:	|  |        |     |   move.b 571(sp),d0
    6b56:	|  |        |     |   lea 572(sp),a0
    6b5a:	|  |        |     |   adda.l d0,a0
    6b5c:	|  |        |     |   clr.b -307(a0)
				break;
    6b60:	|  |        |     '-> nop
			}
		} while (keepGoing);
    6b62:	|  |        '-------> tst.w 568(sp)
    6b66:	|  '----------------- bne.w 68fa <readIniFile+0x106>

		Close(fp);
    6b6a:	|                     move.l 546(sp),526(sp)
    6b70:	|                     move.l d020 <DOSBase>,d0
    6b76:	|                     movea.l d0,a6
    6b78:	|                     move.l 526(sp),d1
    6b7c:	|                     jsr -36(a6)
    6b80:	|                     move.l d0,522(sp)
	}
}
    6b84:	'-------------------> nop
    6b86:	                      move.l (sp)+,d2
    6b88:	                      movea.l (sp)+,a6
    6b8a:	                      lea 564(sp),sp
    6b8e:	                      rts

00006b90 <stringToInt>:

unsigned int stringToInt (char * s) {
    6b90:	             subq.l #8,sp
	int i = 0;
    6b92:	             clr.l 4(sp)
	BOOL negative = FALSE;
    6b96:	             clr.w 2(sp)
	for (;;) {
		if (*s >= '0' && *s <= '9') {
    6b9a:	,----------> movea.l 12(sp),a0
    6b9e:	|            move.b (a0),d0
    6ba0:	|            cmpi.b #47,d0
    6ba4:	|        ,-- ble.s 6bdc <stringToInt+0x4c>
    6ba6:	|        |   movea.l 12(sp),a0
    6baa:	|        |   move.b (a0),d0
    6bac:	|        |   cmpi.b #57,d0
    6bb0:	|        +-- bgt.s 6bdc <stringToInt+0x4c>
			i *= 10;
    6bb2:	|        |   move.l 4(sp),d1
    6bb6:	|        |   move.l d1,d0
    6bb8:	|        |   add.l d0,d0
    6bba:	|        |   add.l d0,d0
    6bbc:	|        |   add.l d1,d0
    6bbe:	|        |   add.l d0,d0
    6bc0:	|        |   move.l d0,4(sp)
			i += *s - '0';
    6bc4:	|        |   movea.l 12(sp),a0
    6bc8:	|        |   move.b (a0),d0
    6bca:	|        |   ext.w d0
    6bcc:	|        |   movea.w d0,a0
    6bce:	|        |   moveq #-48,d0
    6bd0:	|        |   add.l a0,d0
    6bd2:	|        |   add.l d0,4(sp)
			s ++;
    6bd6:	|        |   addq.l #1,12(sp)
    6bda:	|  ,-----|-- bra.s 6c14 <stringToInt+0x84>
		} else if (*s == '-') {
    6bdc:	|  |     '-> movea.l 12(sp),a0
    6be0:	|  |         move.b (a0),d0
    6be2:	|  |         cmpi.b #45,d0
    6be6:	|  |     ,-- bne.s 6c00 <stringToInt+0x70>
			negative = ! negative;
    6be8:	|  |     |   tst.w 2(sp)
    6bec:	|  |     |   seq d0
    6bee:	|  |     |   neg.b d0
    6bf0:	|  |     |   move.b d0,d0
    6bf2:	|  |     |   andi.w #255,d0
    6bf6:	|  |     |   move.w d0,2(sp)
			s++;
    6bfa:	|  |     |   addq.l #1,12(sp)
    6bfe:	+--|-----|-- bra.s 6b9a <stringToInt+0xa>
		} else {
			if (negative)
    6c00:	|  |     '-> tst.w 2(sp)
    6c04:	|  |     ,-- beq.s 6c0e <stringToInt+0x7e>
				return -i;
    6c06:	|  |     |   move.l 4(sp),d0
    6c0a:	|  |     |   neg.l d0
    6c0c:	|  |  ,--|-- bra.s 6c16 <stringToInt+0x86>
			return i;
    6c0e:	|  |  |  '-> move.l 4(sp),d0
    6c12:	|  |  +----- bra.s 6c16 <stringToInt+0x86>
		if (*s >= '0' && *s <= '9') {
    6c14:	'--'--|----X bra.s 6b9a <stringToInt+0xa>
		}
	}
    6c16:	      '----> addq.l #8,sp
    6c18:	             rts

00006c1a <fileExists>:
 */
#include <proto/dos.h>
#include "helpers.h"
#include "support/gcc8_c_support.h"

BYTE fileExists(const char * file) {
    6c1a:	    lea -28(sp),sp
    6c1e:	    move.l a6,-(sp)
    6c20:	    move.l d2,-(sp)
	KPrintF("fileexists: Checking File");
    6c22:	    pea aa4f <PutChar+0x2ddb>
    6c28:	    jsr 725e <KPrintF>
    6c2e:	    addq.l #4,sp
	BPTR tester;
	BYTE retval = 0;
    6c30:	    clr.b 35(sp)
	tester = Open(file, MODE_OLDFILE);
    6c34:	    move.l 40(sp),30(sp)
    6c3a:	    move.l #1005,26(sp)
    6c42:	    move.l d020 <DOSBase>,d0
    6c48:	    movea.l d0,a6
    6c4a:	    move.l 30(sp),d1
    6c4e:	    move.l 26(sp),d2
    6c52:	    jsr -30(a6)
    6c56:	    move.l d0,22(sp)
    6c5a:	    move.l 22(sp),d0
    6c5e:	    move.l d0,18(sp)
	if (tester) {
    6c62:	,-- beq.s 6c92 <fileExists+0x78>
		KPrintF("fileexists: File exists");
    6c64:	|   pea aa69 <PutChar+0x2df5>
    6c6a:	|   jsr 725e <KPrintF>
    6c70:	|   addq.l #4,sp
		retval = 1;
    6c72:	|   move.b #1,35(sp)
		Close(tester);
    6c78:	|   move.l 18(sp),14(sp)
    6c7e:	|   move.l d020 <DOSBase>,d0
    6c84:	|   movea.l d0,a6
    6c86:	|   move.l 14(sp),d1
    6c8a:	|   jsr -36(a6)
    6c8e:	|   move.l d0,10(sp)
	}
	return retval;
    6c92:	'-> move.b 35(sp),d0
    6c96:	    move.l (sp)+,d2
    6c98:	    movea.l (sp)+,a6
    6c9a:	    lea 28(sp),sp
    6c9e:	    rts

00006ca0 <strcmp>:
#endif


int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1 == *s2))
    6ca0:	   ,-- bra.s 6caa <strcmp+0xa>
    {
        s1++;
    6ca2:	,--|-> addq.l #1,4(sp)
        s2++;
    6ca6:	|  |   addq.l #1,8(sp)
    while(*s1 && (*s1 == *s2))
    6caa:	|  '-> movea.l 4(sp),a0
    6cae:	|      move.b (a0),d0
    6cb0:	|  ,-- beq.s 6cc2 <strcmp+0x22>
    6cb2:	|  |   movea.l 4(sp),a0
    6cb6:	|  |   move.b (a0),d1
    6cb8:	|  |   movea.l 8(sp),a0
    6cbc:	|  |   move.b (a0),d0
    6cbe:	|  |   cmp.b d1,d0
    6cc0:	'--|-- beq.s 6ca2 <strcmp+0x2>
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
    6cc2:	   '-> movea.l 4(sp),a0
    6cc6:	       move.b (a0),d0
    6cc8:	       moveq #0,d1
    6cca:	       move.b d0,d1
    6ccc:	       movea.l 8(sp),a0
    6cd0:	       move.b (a0),d0
    6cd2:	       move.b d0,d0
    6cd4:	       andi.l #255,d0
    6cda:	       sub.l d0,d1
    6cdc:	       move.l d1,d0
}
    6cde:	       rts

00006ce0 <strlen>:

long unsigned int strlen (const char *s) 
{  
    6ce0:	       subq.l #4,sp
	long unsigned int i = 0;
    6ce2:	       clr.l (sp)
	while(s[i]) i++; 
    6ce4:	   ,-- bra.s 6ce8 <strlen+0x8>
    6ce6:	,--|-> addq.l #1,(sp)
    6ce8:	|  '-> movea.l 8(sp),a0
    6cec:	|      adda.l (sp),a0
    6cee:	|      move.b (a0),d0
    6cf0:	'----- bne.s 6ce6 <strlen+0x6>
	return(i);
    6cf2:	       move.l (sp),d0
}
    6cf4:	       addq.l #4,sp
    6cf6:	       rts

00006cf8 <strcpy>:

char *strcpy(char *t, const char *s) 
{
	while(*t++ = *s++);
    6cf8:	    nop
    6cfa:	,-> move.l 8(sp),d0
    6cfe:	|   move.l d0,d1
    6d00:	|   addq.l #1,d1
    6d02:	|   move.l d1,8(sp)
    6d06:	|   movea.l 4(sp),a0
    6d0a:	|   lea 1(a0),a1
    6d0e:	|   move.l a1,4(sp)
    6d12:	|   movea.l d0,a1
    6d14:	|   move.b (a1),d0
    6d16:	|   move.b d0,(a0)
    6d18:	|   move.b (a0),d0
    6d1a:	'-- bne.s 6cfa <strcpy+0x2>
}
    6d1c:	    nop
    6d1e:	    rts

00006d20 <joinStrings>:

char * joinStrings (const char * s1, const char * s2) {
    6d20:	    lea -20(sp),sp
    6d24:	    move.l a6,-(sp)
    6d26:	    move.l d2,-(sp)
	char * newString = AllocVec(strlen (s1) + strlen (s2) + 1, MEMF_ANY); 
    6d28:	    move.l 32(sp),-(sp)
    6d2c:	    jsr 6ce0 <strlen>
    6d32:	    addq.l #4,sp
    6d34:	    move.l d0,d2
    6d36:	    move.l 36(sp),-(sp)
    6d3a:	    jsr 6ce0 <strlen>
    6d40:	    addq.l #4,sp
    6d42:	    add.l d2,d0
    6d44:	    move.l d0,d1
    6d46:	    addq.l #1,d1
    6d48:	    move.l d1,20(sp)
    6d4c:	    clr.l 16(sp)
    6d50:	    move.l d018 <SysBase>,d0
    6d56:	    movea.l d0,a6
    6d58:	    move.l 20(sp),d0
    6d5c:	    move.l 16(sp),d1
    6d60:	    jsr -684(a6)
    6d64:	    move.l d0,12(sp)
    6d68:	    move.l 12(sp),d0
    6d6c:	    move.l d0,8(sp)
	char * t = newString;
    6d70:	    move.l 8(sp),24(sp)

	while(*t++ = *s1++);
    6d76:	    nop
    6d78:	,-> move.l 32(sp),d0
    6d7c:	|   move.l d0,d1
    6d7e:	|   addq.l #1,d1
    6d80:	|   move.l d1,32(sp)
    6d84:	|   movea.l 24(sp),a0
    6d88:	|   lea 1(a0),a1
    6d8c:	|   move.l a1,24(sp)
    6d90:	|   movea.l d0,a1
    6d92:	|   move.b (a1),d0
    6d94:	|   move.b d0,(a0)
    6d96:	|   move.b (a0),d0
    6d98:	'-- bne.s 6d78 <joinStrings+0x58>
	t--;
    6d9a:	    subq.l #1,24(sp)
	while(*t++ = *s2++);
    6d9e:	    nop
    6da0:	,-> move.l 36(sp),d0
    6da4:	|   move.l d0,d1
    6da6:	|   addq.l #1,d1
    6da8:	|   move.l d1,36(sp)
    6dac:	|   movea.l 24(sp),a0
    6db0:	|   lea 1(a0),a1
    6db4:	|   move.l a1,24(sp)
    6db8:	|   movea.l d0,a1
    6dba:	|   move.b (a1),d0
    6dbc:	|   move.b d0,(a0)
    6dbe:	|   move.b (a0),d0
    6dc0:	'-- bne.s 6da0 <joinStrings+0x80>

	return newString;
    6dc2:	    move.l 8(sp),d0
}
    6dc6:	    move.l (sp)+,d2
    6dc8:	    movea.l (sp)+,a6
    6dca:	    lea 20(sp),sp
    6dce:	    rts

00006dd0 <unlinkVar>:
	unlinkVar (thisVar);
	thisVar->varType = SVT_STRING;
	thisVar->varData.theString = copyString (txt);
}

void unlinkVar (struct variable *thisVar) {
    6dd0:	                      lea -16(sp),sp
    6dd4:	                      move.l a6,-(sp)

	switch (thisVar->varType) {
    6dd6:	                      movea.l 24(sp),a0
    6dda:	                      move.l (a0),d0
    6ddc:	                      moveq #10,d1
    6dde:	                      cmp.l d0,d1
    6de0:	            ,-------- beq.w 6e98 <unlinkVar+0xc8>
    6de4:	            |         moveq #10,d1
    6de6:	            |         cmp.l d0,d1
    6de8:	,-----------|-------- bcs.w 6f0c <unlinkVar+0x13c>
    6dec:	|           |         moveq #8,d1
    6dee:	|           |         cmp.l d0,d1
    6df0:	|  ,--------|-------- beq.w 6ef8 <unlinkVar+0x128>
    6df4:	|  |        |         moveq #8,d1
    6df6:	|  |        |         cmp.l d0,d1
    6df8:	+--|--------|-------- bcs.w 6f0c <unlinkVar+0x13c>
    6dfc:	|  |        |         moveq #3,d1
    6dfe:	|  |        |         cmp.l d0,d1
    6e00:	|  |        |     ,-- beq.s 6e0c <unlinkVar+0x3c>
    6e02:	|  |        |     |   moveq #6,d1
    6e04:	|  |        |     |   cmp.l d0,d1
    6e06:	|  |        |  ,--|-- beq.s 6e32 <unlinkVar+0x62>
		case SVT_ANIM:
		deleteAnim (thisVar->varData.animHandler);
		break;

		default:
		break;
    6e08:	+--|--------|--|--|-- bra.w 6f0c <unlinkVar+0x13c>
        FreeVec(thisVar->varData.theString);
    6e0c:	|  |        |  |  '-> movea.l 24(sp),a0
    6e10:	|  |        |  |      move.l 4(a0),4(sp)
    6e16:	|  |        |  |      move.l d018 <SysBase>,d0
    6e1c:	|  |        |  |      movea.l d0,a6
    6e1e:	|  |        |  |      movea.l 4(sp),a1
    6e22:	|  |        |  |      jsr -690(a6)
		thisVar->varData.theString = NULL;
    6e26:	|  |        |  |      movea.l 24(sp),a0
    6e2a:	|  |        |  |      clr.l 4(a0)
		break;
    6e2e:	|  |  ,-----|--|----- bra.w 6f16 <unlinkVar+0x146>
		thisVar->varData.theStack -> timesUsed --;
    6e32:	|  |  |     |  '----> movea.l 24(sp),a0
    6e36:	|  |  |     |         movea.l 4(a0),a0
    6e3a:	|  |  |     |         move.l 8(a0),d0
    6e3e:	|  |  |     |         subq.l #1,d0
    6e40:	|  |  |     |         move.l d0,8(a0)
		if (thisVar->varData.theStack -> timesUsed <= 0) {
    6e44:	|  |  |     |         movea.l 24(sp),a0
    6e48:	|  |  |     |         movea.l 4(a0),a0
    6e4c:	|  |  |     |         move.l 8(a0),d0
    6e50:	|  |  |  ,--|-------- bgt.w 6f10 <unlinkVar+0x140>
			while (thisVar->varData.theStack -> first) trimStack (&thisVar->varData.theStack -> first);
    6e54:	|  |  |  |  |     ,-- bra.s 6e68 <unlinkVar+0x98>
    6e56:	|  |  |  |  |  ,--|-> movea.l 24(sp),a0
    6e5a:	|  |  |  |  |  |  |   move.l 4(a0),d0
    6e5e:	|  |  |  |  |  |  |   move.l d0,-(sp)
    6e60:	|  |  |  |  |  |  |   jsr 705a <trimStack>
    6e66:	|  |  |  |  |  |  |   addq.l #4,sp
    6e68:	|  |  |  |  |  |  '-> movea.l 24(sp),a0
    6e6c:	|  |  |  |  |  |      movea.l 4(a0),a0
    6e70:	|  |  |  |  |  |      move.l (a0),d0
    6e72:	|  |  |  |  |  '----- bne.s 6e56 <unlinkVar+0x86>
			FreeVec(thisVar->varData.theStack);
    6e74:	|  |  |  |  |         movea.l 24(sp),a0
    6e78:	|  |  |  |  |         move.l 4(a0),8(sp)
    6e7e:	|  |  |  |  |         move.l d018 <SysBase>,d0
    6e84:	|  |  |  |  |         movea.l d0,a6
    6e86:	|  |  |  |  |         movea.l 8(sp),a1
    6e8a:	|  |  |  |  |         jsr -690(a6)
			thisVar->varData.theStack = NULL;
    6e8e:	|  |  |  |  |         movea.l 24(sp),a0
    6e92:	|  |  |  |  |         clr.l 4(a0)
		break;
    6e96:	|  |  |  +--|-------- bra.s 6f10 <unlinkVar+0x140>
		thisVar->varData.fastArray -> timesUsed --;
    6e98:	|  |  |  |  '-------> movea.l 24(sp),a0
    6e9c:	|  |  |  |            movea.l 4(a0),a0
    6ea0:	|  |  |  |            move.l 8(a0),d0
    6ea4:	|  |  |  |            subq.l #1,d0
    6ea6:	|  |  |  |            move.l d0,8(a0)
		if (thisVar->varData.theStack -> timesUsed <= 0) {
    6eaa:	|  |  |  |            movea.l 24(sp),a0
    6eae:	|  |  |  |            movea.l 4(a0),a0
    6eb2:	|  |  |  |            move.l 8(a0),d0
    6eb6:	|  |  |  |        ,-- bgt.s 6f14 <unlinkVar+0x144>
            FreeVec( thisVar->varData.fastArray -> fastVariables);
    6eb8:	|  |  |  |        |   movea.l 24(sp),a0
    6ebc:	|  |  |  |        |   movea.l 4(a0),a0
    6ec0:	|  |  |  |        |   move.l (a0),16(sp)
    6ec4:	|  |  |  |        |   move.l d018 <SysBase>,d0
    6eca:	|  |  |  |        |   movea.l d0,a6
    6ecc:	|  |  |  |        |   movea.l 16(sp),a1
    6ed0:	|  |  |  |        |   jsr -690(a6)
			FreeVec(thisVar->varData.fastArray);
    6ed4:	|  |  |  |        |   movea.l 24(sp),a0
    6ed8:	|  |  |  |        |   move.l 4(a0),12(sp)
    6ede:	|  |  |  |        |   move.l d018 <SysBase>,d0
    6ee4:	|  |  |  |        |   movea.l d0,a6
    6ee6:	|  |  |  |        |   movea.l 12(sp),a1
    6eea:	|  |  |  |        |   jsr -690(a6)
			thisVar->varData.fastArray = NULL;
    6eee:	|  |  |  |        |   movea.l 24(sp),a0
    6ef2:	|  |  |  |        |   clr.l 4(a0)
		break;
    6ef6:	|  |  |  |        +-- bra.s 6f14 <unlinkVar+0x144>
		deleteAnim (thisVar->varData.animHandler);
    6ef8:	|  '--|--|--------|-> movea.l 24(sp),a0
    6efc:	|     |  |        |   move.l 4(a0),d0
    6f00:	|     |  |        |   move.l d0,-(sp)
    6f02:	|     |  |        |   jsr 4e80 <deleteAnim>
    6f08:	|     |  |        |   addq.l #4,sp
		break;
    6f0a:	|     +--|--------|-- bra.s 6f16 <unlinkVar+0x146>
		break;
    6f0c:	'-----|--|--------|-> nop
    6f0e:	      +--|--------|-- bra.s 6f16 <unlinkVar+0x146>
		break;
    6f10:	      |  '--------|-> nop
    6f12:	      +-----------|-- bra.s 6f16 <unlinkVar+0x146>
		break;
    6f14:	      |           '-> nop
	}
}
    6f16:	      '-------------> nop
    6f18:	                      movea.l (sp)+,a6
    6f1a:	                      lea 16(sp),sp
    6f1e:	                      rts

00006f20 <copyMain>:

BOOL copyMain (const struct variable *from, struct variable *to) {
	to->varType = from->varType;
    6f20:	       movea.l 4(sp),a0
    6f24:	       move.l (a0),d0
    6f26:	       movea.l 8(sp),a0
    6f2a:	       move.l d0,(a0)
	switch (to->varType) {
    6f2c:	       movea.l 8(sp),a0
    6f30:	       move.l (a0),d0
    6f32:	       moveq #10,d1
    6f34:	       cmp.l d0,d1
    6f36:	,----- bcs.w 7028 <copyMain+0x108>
    6f3a:	|      add.l d0,d0
    6f3c:	|      movea.l d0,a0
    6f3e:	|      adda.l #28490,a0
    6f44:	|      move.w (a0),d0
    6f46:	|      jmp (6f4a <copyMain+0x2a>,pc,d0.w)
    6f4a:	|      .short 0x00da
    6f4c:	|      ori.b #22,(a6)
    6f50:	|      ori.w #22,(a4)
    6f54:	|      ori.b #-126,(a6)
    6f58:	|      ori.b #-68,(a6)
    6f5c:	|      ori.l #2891887,4(a0)
		case SVT_INT:
		case SVT_FUNC:
		case SVT_BUILT:
		case SVT_FILE:
		case SVT_OBJTYPE:
		to->varData.intValue = from->varData.intValue;
    6f64:	|      move.l 4(a0),d0
    6f68:	|      movea.l 8(sp),a0
    6f6c:	|      move.l d0,4(a0)
		return TRUE;
    6f70:	|      moveq #1,d0
    6f72:	|  ,-- bra.w 703a <copyMain+0x11a>

		case SVT_FASTARRAY:
		to->varData.fastArray = from->varData.fastArray;
    6f76:	|  |   movea.l 4(sp),a0
    6f7a:	|  |   move.l 4(a0),d0
    6f7e:	|  |   movea.l 8(sp),a0
    6f82:	|  |   move.l d0,4(a0)
		to->varData.fastArray -> timesUsed ++;
    6f86:	|  |   movea.l 8(sp),a0
    6f8a:	|  |   movea.l 4(a0),a0
    6f8e:	|  |   move.l 8(a0),d0
    6f92:	|  |   addq.l #1,d0
    6f94:	|  |   move.l d0,8(a0)
		return TRUE;
    6f98:	|  |   moveq #1,d0
    6f9a:	|  +-- bra.w 703a <copyMain+0x11a>

		case SVT_STRING:
		to->varData.theString = copyString (from->varData.theString);
    6f9e:	|  |   movea.l 4(sp),a0
    6fa2:	|  |   move.l 4(a0),d0
    6fa6:	|  |   move.l d0,-(sp)
    6fa8:	|  |   jsr b8 <copyString>
    6fae:	|  |   addq.l #4,sp
    6fb0:	|  |   movea.l 8(sp),a0
    6fb4:	|  |   move.l d0,4(a0)
		return to->varData.theString ? TRUE : FALSE;
    6fb8:	|  |   movea.l 8(sp),a0
    6fbc:	|  |   move.l 4(a0),d0
    6fc0:	|  |   sne d0
    6fc2:	|  |   neg.b d0
    6fc4:	|  |   move.b d0,d0
    6fc6:	|  |   andi.w #255,d0
    6fca:	|  +-- bra.s 703a <copyMain+0x11a>

		case SVT_STACK:
		to->varData.theStack = from->varData.theStack;
    6fcc:	|  |   movea.l 4(sp),a0
    6fd0:	|  |   move.l 4(a0),d0
    6fd4:	|  |   movea.l 8(sp),a0
    6fd8:	|  |   move.l d0,4(a0)
		to->varData.theStack -> timesUsed ++;
    6fdc:	|  |   movea.l 8(sp),a0
    6fe0:	|  |   movea.l 4(a0),a0
    6fe4:	|  |   move.l 8(a0),d0
    6fe8:	|  |   addq.l #1,d0
    6fea:	|  |   move.l d0,8(a0)
		return TRUE;
    6fee:	|  |   moveq #1,d0
    6ff0:	|  +-- bra.s 703a <copyMain+0x11a>

		case SVT_COSTUME:
		to->varData.costumeHandler = from->varData.costumeHandler;
    6ff2:	|  |   movea.l 4(sp),a0
    6ff6:	|  |   move.l 4(a0),d0
    6ffa:	|  |   movea.l 8(sp),a0
    6ffe:	|  |   move.l d0,4(a0)
		return TRUE;
    7002:	|  |   moveq #1,d0
    7004:	|  +-- bra.s 703a <copyMain+0x11a>

		case SVT_ANIM:
		to->varData.animHandler = copyAnim (from->varData.animHandler);
    7006:	|  |   movea.l 4(sp),a0
    700a:	|  |   move.l 4(a0),d0
    700e:	|  |   move.l d0,-(sp)
    7010:	|  |   jsr 4cd6 <copyAnim>
    7016:	|  |   addq.l #4,sp
    7018:	|  |   movea.l 8(sp),a0
    701c:	|  |   move.l d0,4(a0)
		return TRUE;
    7020:	|  |   moveq #1,d0
    7022:	|  +-- bra.s 703a <copyMain+0x11a>

		case SVT_NULL:
		return TRUE;
    7024:	|  |   moveq #1,d0
    7026:	|  +-- bra.s 703a <copyMain+0x11a>

		default:
		break;
    7028:	'--|-> nop
	}
	KPrintF("Unknown value type");
    702a:	   |   pea ac07 <PutChar+0x2f93>
    7030:	   |   jsr 725e <KPrintF>
    7036:	   |   addq.l #4,sp
	return FALSE;
    7038:	   |   clr.w d0
}
    703a:	   '-> rts

0000703c <copyVariable>:

BOOL copyVariable (const struct variable *from, struct variable *to) {
	unlinkVar (to);
    703c:	move.l 8(sp),-(sp)
    7040:	jsr 6dd0 <unlinkVar>
    7046:	addq.l #4,sp
	return copyMain(from, to);
    7048:	move.l 8(sp),-(sp)
    704c:	move.l 8(sp),-(sp)
    7050:	jsr 6f20 <copyMain>
    7056:	addq.l #8,sp
}
    7058:	rts

0000705a <trimStack>:
		a = a -> next;
	}
	return r;
}

void trimStack (struct variableStack ** stack) {
    705a:	subq.l #8,sp
    705c:	move.l a6,-(sp)

	struct variableStack* killMe = *stack;
    705e:	movea.l 16(sp),a0
    7062:	move.l (a0),8(sp)

	*stack = (*stack)->next;
    7066:	movea.l 16(sp),a0
    706a:	movea.l (a0),a0
    706c:	move.l 8(a0),d0
    7070:	movea.l 16(sp),a0
    7074:	move.l d0,(a0)

	// When calling this, we've ALWAYS checked that stack != NULL
	unlinkVar (&(killMe -> thisVar));
    7076:	move.l 8(sp),d0
    707a:	move.l d0,-(sp)
    707c:	jsr 6dd0 <unlinkVar>
    7082:	addq.l #4,sp
	FreeVec(killMe);
    7084:	move.l 8(sp),4(sp)
    708a:	move.l d018 <SysBase>,d0
    7090:	movea.l d0,a6
    7092:	movea.l 4(sp),a1
    7096:	jsr -690(a6)
    709a:	nop
    709c:	movea.l (sp)+,a6
    709e:	addq.l #8,sp
    70a0:	rts

000070a2 <getMatchingCorners>:
                     currentFloor->vertex[currentFloor->polygon[i].vertexID[nV - 1]].y);
        }
    }
}

BOOL getMatchingCorners(struct floorPolygon *a, struct floorPolygon *b, int *cornerA, int *cornerB) {
    70a2:	                      lea -12(sp),sp
    int sharedVertices = 0;
    70a6:	                      clr.l 8(sp)
    int i, j;

    for (i = 0; i < a->numVertices; i++) {
    70aa:	                      clr.l 4(sp)
    70ae:	   ,----------------- bra.w 7140 <getMatchingCorners+0x9e>
        for (j = 0; j < b->numVertices; j++) {
    70b2:	,--|----------------> clr.l (sp)
    70b4:	|  |     ,----------- bra.s 7130 <getMatchingCorners+0x8e>
            if (a->vertexID[i] == b->vertexID[j]) {
    70b6:	|  |  ,--|----------> movea.l 16(sp),a0
    70ba:	|  |  |  |            move.l 4(a0),d1
    70be:	|  |  |  |            move.l 4(sp),d0
    70c2:	|  |  |  |            add.l d0,d0
    70c4:	|  |  |  |            add.l d0,d0
    70c6:	|  |  |  |            movea.l d1,a0
    70c8:	|  |  |  |            adda.l d0,a0
    70ca:	|  |  |  |            move.l (a0),d1
    70cc:	|  |  |  |            movea.l 20(sp),a0
    70d0:	|  |  |  |            movea.l 4(a0),a0
    70d4:	|  |  |  |            move.l (sp),d0
    70d6:	|  |  |  |            add.l d0,d0
    70d8:	|  |  |  |            add.l d0,d0
    70da:	|  |  |  |            adda.l d0,a0
    70dc:	|  |  |  |            move.l (a0),d0
    70de:	|  |  |  |            cmp.l d1,d0
    70e0:	|  |  |  |  ,-------- bne.s 712e <getMatchingCorners+0x8c>
                if (sharedVertices++) {
    70e2:	|  |  |  |  |         move.l 8(sp),d0
    70e6:	|  |  |  |  |         move.l d0,d1
    70e8:	|  |  |  |  |         addq.l #1,d1
    70ea:	|  |  |  |  |         move.l d1,8(sp)
    70ee:	|  |  |  |  |         tst.l d0
    70f0:	|  |  |  |  |     ,-- beq.s 7112 <getMatchingCorners+0x70>
                    *cornerB = a->vertexID[i];
    70f2:	|  |  |  |  |     |   movea.l 16(sp),a0
    70f6:	|  |  |  |  |     |   move.l 4(a0),d1
    70fa:	|  |  |  |  |     |   move.l 4(sp),d0
    70fe:	|  |  |  |  |     |   add.l d0,d0
    7100:	|  |  |  |  |     |   add.l d0,d0
    7102:	|  |  |  |  |     |   movea.l d1,a0
    7104:	|  |  |  |  |     |   adda.l d0,a0
    7106:	|  |  |  |  |     |   move.l (a0),d0
    7108:	|  |  |  |  |     |   movea.l 28(sp),a0
    710c:	|  |  |  |  |     |   move.l d0,(a0)
                    return TRUE;
    710e:	|  |  |  |  |     |   moveq #1,d0
    7110:	|  |  |  |  |  ,--|-- bra.s 7150 <getMatchingCorners+0xae>
                } else {
                    *cornerA = a->vertexID[i];
    7112:	|  |  |  |  |  |  '-> movea.l 16(sp),a0
    7116:	|  |  |  |  |  |      move.l 4(a0),d1
    711a:	|  |  |  |  |  |      move.l 4(sp),d0
    711e:	|  |  |  |  |  |      add.l d0,d0
    7120:	|  |  |  |  |  |      add.l d0,d0
    7122:	|  |  |  |  |  |      movea.l d1,a0
    7124:	|  |  |  |  |  |      adda.l d0,a0
    7126:	|  |  |  |  |  |      move.l (a0),d0
    7128:	|  |  |  |  |  |      movea.l 24(sp),a0
    712c:	|  |  |  |  |  |      move.l d0,(a0)
        for (j = 0; j < b->numVertices; j++) {
    712e:	|  |  |  |  '--|----> addq.l #1,(sp)
    7130:	|  |  |  '-----|----> movea.l 20(sp),a0
    7134:	|  |  |        |      move.l (a0),d0
    7136:	|  |  |        |      cmp.l (sp),d0
    7138:	|  |  '--------|----- bgt.w 70b6 <getMatchingCorners+0x14>
    for (i = 0; i < a->numVertices; i++) {
    713c:	|  |           |      addq.l #1,4(sp)
    7140:	|  '-----------|----> movea.l 16(sp),a0
    7144:	|              |      move.l (a0),d0
    7146:	|              |      cmp.l 4(sp),d0
    714a:	'--------------|----- bgt.w 70b2 <getMatchingCorners+0x10>
                }
            }
        }
    }

    return FALSE;
    714e:	               |      clr.w d0
}
    7150:	               '----> lea 12(sp),sp
    7154:	                      rts

00007156 <noFloor>:



void noFloor () {
	currentFloor -> numPolygons = 0;
    7156:	movea.l d0ea <currentFloor>,a0
    715c:	clr.l 8(a0)
	currentFloor -> polygon = NULL;
    7160:	movea.l d0ea <currentFloor>,a0
    7166:	clr.l 12(a0)
	currentFloor -> vertex = NULL;
    716a:	movea.l d0ea <currentFloor>,a0
    7170:	clr.l 4(a0)
	currentFloor -> matrix = NULL;
    7174:	movea.l d0ea <currentFloor>,a0
    717a:	clr.l 16(a0)
}
    717e:	nop
    7180:	rts

00007182 <initFloor>:

	KPrintF("infloor finished\n");
	return r;
}

BOOL initFloor () {
    7182:	       lea -12(sp),sp
    7186:	       move.l a6,-(sp)
	currentFloor = AllocVec(sizeof(struct flor), MEMF_ANY);
    7188:	       moveq #20,d0
    718a:	       move.l d0,12(sp)
    718e:	       clr.l 8(sp)
    7192:	       move.l d018 <SysBase>,d0
    7198:	       movea.l d0,a6
    719a:	       move.l 12(sp),d0
    719e:	       move.l 8(sp),d1
    71a2:	       jsr -684(a6)
    71a6:	       move.l d0,4(sp)
    71aa:	       move.l 4(sp),d0
    71ae:	       move.l d0,d0ea <currentFloor>

    if(currentFloor == 0) {
    71b4:	       move.l d0ea <currentFloor>,d0
    71ba:	,----- bne.s 71ce <initFloor+0x4c>
        KPrintF("initFloor: Could not initialize Mem");
    71bc:	|      pea ad09 <PutChar+0x3095>
    71c2:	|      jsr 725e <KPrintF>
    71c8:	|      addq.l #4,sp
        return FALSE;
    71ca:	|      clr.w d0
    71cc:	|  ,-- bra.s 71d6 <initFloor+0x54>
    }

	noFloor ();
    71ce:	'--|-> jsr 7156 <noFloor>
	return TRUE;
    71d4:	   |   moveq #1,d0
}
    71d6:	   '-> movea.l (sp)+,a6
    71d8:	       lea 12(sp),sp
    71dc:	       rts

000071de <WaitVbl>:
void WaitVbl() {
    71de:	       subq.l #8,sp
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    71e0:	   ,-> movea.l #14675972,a0
    71e6:	   |   move.l (a0),d0
    71e8:	   |   move.l d0,(sp)
		vpos&=0x1ff00;
    71ea:	   |   move.l (sp),d0
    71ec:	   |   andi.l #130816,d0
    71f2:	   |   move.l d0,(sp)
		if (vpos!=(300<<8))
    71f4:	   |   move.l (sp),d0
    71f6:	   |   cmpi.l #76800,d0
    71fc:	   '-- beq.s 71e0 <WaitVbl+0x2>
		volatile ULONG vpos=*(volatile ULONG*)0xDFF004;
    71fe:	,----> movea.l #14675972,a0
    7204:	|      move.l (a0),d0
    7206:	|      move.l d0,4(sp)
		vpos&=0x1ff00;
    720a:	|      move.l 4(sp),d0
    720e:	|      andi.l #130816,d0
    7214:	|      move.l d0,4(sp)
		if (vpos==(300<<8))
    7218:	|      move.l 4(sp),d0
    721c:	|      cmpi.l #76800,d0
    7222:	|  ,-- beq.s 7226 <WaitVbl+0x48>
	while (1) {
    7224:	'--|-- bra.s 71fe <WaitVbl+0x20>
			break;
    7226:	   '-> nop
}
    7228:	       nop
    722a:	       addq.l #8,sp
    722c:	       rts

0000722e <memset>:
void* memset(void *dest, int val, unsigned long len) {
    722e:	       subq.l #4,sp
	unsigned char *ptr = (unsigned char *)dest;
    7230:	       move.l 8(sp),(sp)
	while(len-- > 0)
    7234:	   ,-- bra.s 7246 <memset+0x18>
		*ptr++ = val;
    7236:	,--|-> move.l (sp),d0
    7238:	|  |   move.l d0,d1
    723a:	|  |   addq.l #1,d1
    723c:	|  |   move.l d1,(sp)
    723e:	|  |   move.l 12(sp),d1
    7242:	|  |   movea.l d0,a0
    7244:	|  |   move.b d1,(a0)
	while(len-- > 0)
    7246:	|  '-> move.l 16(sp),d0
    724a:	|      move.l d0,d1
    724c:	|      subq.l #1,d1
    724e:	|      move.l d1,16(sp)
    7252:	|      tst.l d0
    7254:	'----- bne.s 7236 <memset+0x8>
	return dest;
    7256:	       move.l 8(sp),d0
}
    725a:	       addq.l #4,sp
    725c:	       rts

0000725e <KPrintF>:
void KPrintF(const char* fmt, ...) {
    725e:	       lea -128(sp),sp
    7262:	       movem.l a2-a3/a6,-(sp)
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    7266:	       move.w f0ff60 <gcc8_c_support.c.c60c1f2b+0xec2ab1>,d0
    726c:	       cmpi.w #20153,d0
    7270:	   ,-- beq.s 7294 <KPrintF+0x36>
    7272:	   |   cmpi.w #-24562,d0
    7276:	   +-- beq.s 7294 <KPrintF+0x36>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
    7278:	   |   movea.l d018 <SysBase>,a6
    727e:	   |   movea.l 144(sp),a0
    7282:	   |   lea 148(sp),a1
    7286:	   |   lea 7c66 <KPutCharX>,a2
    728c:	   |   suba.l a3,a3
    728e:	   |   jsr -522(a6)
}
    7292:	,--|-- bra.s 72be <KPrintF+0x60>
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
    7294:	|  '-> movea.l d018 <SysBase>,a6
    729a:	|      movea.l 144(sp),a0
    729e:	|      lea 148(sp),a1
    72a2:	|      lea 7c74 <PutChar>,a2
    72a8:	|      lea 12(sp),a3
    72ac:	|      jsr -522(a6)
		UaeDbgLog(86, temp);
    72b0:	|      move.l a3,-(sp)
    72b2:	|      pea 56 <_start+0x56>
    72b6:	|      jsr f0ff60 <gcc8_c_support.c.c60c1f2b+0xec2ab1>
	if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
    72bc:	|      addq.l #8,sp
}
    72be:	'----> movem.l (sp)+,a2-a3/a6
    72c2:	       lea 128(sp),sp
    72c6:	       rts

000072c8 <debug_cmd>:
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
	}
}

static void debug_cmd(unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4) {
    72c8:	       subq.l #4,sp
	long(*UaeLib)(unsigned int arg0, unsigned int arg1, unsigned int arg2, unsigned int arg3, unsigned int arg4);
	UaeLib = (long(*)(unsigned int, unsigned int, unsigned int, unsigned int, unsigned int))0xf0ff60;
    72ca:	       move.l #15794016,(sp)
	if(*((UWORD *)UaeLib) == 0x4eb9 || *((UWORD *)UaeLib) == 0xa00e) {
    72d0:	       movea.l (sp),a0
    72d2:	       move.w (a0),d0
    72d4:	       cmpi.w #20153,d0
    72d8:	   ,-- beq.s 72e4 <debug_cmd+0x1c>
    72da:	   |   movea.l (sp),a0
    72dc:	   |   move.w (a0),d0
    72de:	   |   cmpi.w #-24562,d0
    72e2:	,--|-- bne.s 7302 <debug_cmd+0x3a>
		UaeLib(88, arg1, arg2, arg3, arg4);
    72e4:	|  '-> move.l 20(sp),-(sp)
    72e8:	|      move.l 20(sp),-(sp)
    72ec:	|      move.l 20(sp),-(sp)
    72f0:	|      move.l 20(sp),-(sp)
    72f4:	|      pea 58 <_start+0x58>
    72f8:	|      movea.l 20(sp),a0
    72fc:	|      jsr (a0)
    72fe:	|      lea 20(sp),sp
	}
}
    7302:	'----> nop
    7304:	       addq.l #4,sp
    7306:	       rts

00007308 <my_strncpy>:
void debug_stop_idle() {
	debug_cmd(barto_cmd_set_idle, 0, 0, 0);
}

// gfx debugger
static void my_strncpy(char* destination, const char* source, unsigned long num) {
    7308:	       move.l d2,-(sp)
	while(*source && --num > 0)
    730a:	   ,-- bra.s 732c <my_strncpy+0x24>
		*destination++ = *source++;
    730c:	,--|-> move.l 12(sp),d1
    7310:	|  |   move.l d1,d0
    7312:	|  |   addq.l #1,d0
    7314:	|  |   move.l d0,12(sp)
    7318:	|  |   move.l 8(sp),d0
    731c:	|  |   move.l d0,d2
    731e:	|  |   addq.l #1,d2
    7320:	|  |   move.l d2,8(sp)
    7324:	|  |   movea.l d1,a0
    7326:	|  |   move.b (a0),d1
    7328:	|  |   movea.l d0,a0
    732a:	|  |   move.b d1,(a0)
	while(*source && --num > 0)
    732c:	|  '-> movea.l 12(sp),a0
    7330:	|      move.b (a0),d0
    7332:	|  ,-- beq.s 733a <my_strncpy+0x32>
    7334:	|  |   subq.l #1,16(sp)
    7338:	'--|-- bne.s 730c <my_strncpy+0x4>
	*destination = '\0';
    733a:	   '-> movea.l 8(sp),a0
    733e:	       clr.b (a0)
}
    7340:	       nop
    7342:	       move.l (sp)+,d2
    7344:	       rts

00007346 <debug_register_bitmap>:

void debug_register_bitmap(const void* addr, const char* name, short width, short height, short numPlanes, unsigned short flags) {
    7346:	    lea -60(sp),sp
    734a:	    movea.l 72(sp),a1
    734e:	    movea.l 76(sp),a0
    7352:	    move.l 80(sp),d1
    7356:	    move.l 84(sp),d0
    735a:	    movea.w a1,a1
    735c:	    move.w a1,8(sp)
    7360:	    movea.w a0,a0
    7362:	    move.w a0,6(sp)
    7366:	    move.w d1,d1
    7368:	    move.w d1,4(sp)
    736c:	    move.w d0,d0
    736e:	    move.w d0,2(sp)
	struct debug_resource resource = {
    7372:	    lea 10(sp),a0
    7376:	    clr.l (a0)
    7378:	    addq.l #4,a0
    737a:	    clr.l (a0)
    737c:	    addq.l #4,a0
    737e:	    clr.l (a0)
    7380:	    addq.l #4,a0
    7382:	    clr.l (a0)
    7384:	    addq.l #4,a0
    7386:	    clr.l (a0)
    7388:	    addq.l #4,a0
    738a:	    clr.l (a0)
    738c:	    addq.l #4,a0
    738e:	    clr.l (a0)
    7390:	    addq.l #4,a0
    7392:	    clr.l (a0)
    7394:	    addq.l #4,a0
    7396:	    clr.l (a0)
    7398:	    addq.l #4,a0
    739a:	    clr.l (a0)
    739c:	    addq.l #4,a0
    739e:	    clr.l (a0)
    73a0:	    addq.l #4,a0
    73a2:	    clr.l (a0)
    73a4:	    addq.l #4,a0
    73a6:	    clr.w (a0)
    73a8:	    addq.l #2,a0
		.address = (unsigned int)addr,
    73aa:	    move.l 64(sp),d0
	struct debug_resource resource = {
    73ae:	    move.l d0,10(sp)
		.size = width / 8 * height * numPlanes,
    73b2:	    move.w 8(sp),d0
    73b6:	,-- bpl.s 73ba <debug_register_bitmap+0x74>
    73b8:	|   addq.w #7,d0
    73ba:	'-> asr.w #3,d0
    73bc:	    movea.w d0,a0
    73be:	    movea.w 6(sp),a1
    73c2:	    move.l a1,-(sp)
    73c4:	    move.l a0,-(sp)
    73c6:	    jsr 7b8c <__mulsi3>
    73cc:	    addq.l #8,sp
    73ce:	    movea.w 4(sp),a0
    73d2:	    move.l a0,-(sp)
    73d4:	    move.l d0,-(sp)
    73d6:	    jsr 7b8c <__mulsi3>
    73dc:	    addq.l #8,sp
	struct debug_resource resource = {
    73de:	    move.l d0,14(sp)
    73e2:	    move.w 2(sp),52(sp)
    73e8:	    move.w 8(sp),54(sp)
    73ee:	    move.w 6(sp),56(sp)
    73f4:	    move.w 4(sp),58(sp)
		.type = debug_resource_type_bitmap,
		.flags = flags,
		.bitmap = { width, height, numPlanes }
	};

	if (flags & debug_resource_bitmap_masked)
    73fa:	    moveq #0,d0
    73fc:	    move.w 2(sp),d0
    7400:	    moveq #2,d1
    7402:	    and.l d1,d0
    7404:	,-- beq.s 7410 <debug_register_bitmap+0xca>
		resource.size *= 2;
    7406:	|   move.l 14(sp),d0
    740a:	|   add.l d0,d0
    740c:	|   move.l d0,14(sp)

	my_strncpy(resource.name, name, sizeof(resource.name));
    7410:	'-> pea 20 <_start+0x20>
    7414:	    move.l 72(sp),-(sp)
    7418:	    lea 18(sp),a0
    741c:	    move.l a0,d0
    741e:	    addq.l #8,d0
    7420:	    move.l d0,-(sp)
    7422:	    jsr 7308 <my_strncpy>
    7428:	    lea 12(sp),sp
	debug_cmd(barto_cmd_register_resource, (unsigned int)&resource, 0, 0);
    742c:	    lea 10(sp),a0
    7430:	    clr.l -(sp)
    7432:	    clr.l -(sp)
    7434:	    move.l a0,-(sp)
    7436:	    pea 4 <_start+0x4>
    743a:	    jsr 72c8 <debug_cmd>
    7440:	    lea 16(sp),sp
}
    7444:	    nop
    7446:	    lea 60(sp),sp
    744a:	    rts

0000744c <__addsf3>:
	};
	my_strncpy(resource.name, name, sizeof(resource.name));
	debug_cmd(barto_cmd_save, (unsigned int)&resource, 0, 0);
}

FLOAT __addsf3( FLOAT a, FLOAT b) {
    744c:	lea -12(sp),sp
    7450:	move.l a6,-(sp)
	return IEEESPAdd( a, b);
    7452:	move.l 20(sp),12(sp)
    7458:	move.l 24(sp),8(sp)
    745e:	move.l d028 <MathIeeeSingBasBase>,d0
    7464:	movea.l d0,a6
    7466:	move.l 12(sp),d0
    746a:	move.l 8(sp),d1
    746e:	jsr -66(a6)
    7472:	move.l d0,4(sp)
    7476:	move.l 4(sp),d0
}
    747a:	movea.l (sp)+,a6
    747c:	lea 12(sp),sp
    7480:	rts

00007482 <__adddf3>:

DOUBLE __adddf3( DOUBLE a, DOUBLE b) {
    7482:	lea -32(sp),sp
    7486:	movem.l d2-d3/a6,-(sp)
	return IEEEDPAdd( a, b);
    748a:	move.l 48(sp),36(sp)
    7490:	move.l 52(sp),40(sp)
    7496:	move.l 56(sp),28(sp)
    749c:	move.l 60(sp),32(sp)
    74a2:	move.l d030 <MathIeeeDoubBasBase>,d0
    74a8:	movea.l d0,a6
    74aa:	move.l 36(sp),d0
    74ae:	move.l 40(sp),d1
    74b2:	move.l 28(sp),d2
    74b6:	move.l 32(sp),d3
    74ba:	jsr -66(a6)
    74be:	move.l d0,12(sp)
    74c2:	move.l d1,16(sp)
    74c6:	move.l 12(sp),20(sp)
    74cc:	move.l 16(sp),24(sp)
    74d2:	move.l 20(sp),d0
    74d6:	move.l 24(sp),d1
}
    74da:	movem.l (sp)+,d2-d3/a6
    74de:	lea 32(sp),sp
    74e2:	rts

000074e4 <__divdf3>:

DOUBLE __divdf3( DOUBLE a, DOUBLE b) {
    74e4:	lea -32(sp),sp
    74e8:	movem.l d2-d3/a6,-(sp)
	return IEEEDPDiv( a, b);
    74ec:	move.l 48(sp),36(sp)
    74f2:	move.l 52(sp),40(sp)
    74f8:	move.l 56(sp),28(sp)
    74fe:	move.l 60(sp),32(sp)
    7504:	move.l d030 <MathIeeeDoubBasBase>,d0
    750a:	movea.l d0,a6
    750c:	move.l 36(sp),d0
    7510:	move.l 40(sp),d1
    7514:	move.l 28(sp),d2
    7518:	move.l 32(sp),d3
    751c:	jsr -84(a6)
    7520:	move.l d0,12(sp)
    7524:	move.l d1,16(sp)
    7528:	move.l 12(sp),20(sp)
    752e:	move.l 16(sp),24(sp)
    7534:	move.l 20(sp),d0
    7538:	move.l 24(sp),d1
}
    753c:	movem.l (sp)+,d2-d3/a6
    7540:	lea 32(sp),sp
    7544:	rts

00007546 <__divsf3>:

FLOAT __divsf3( FLOAT a, FLOAT b) {
    7546:	lea -12(sp),sp
    754a:	move.l a6,-(sp)
	return IEEESPDiv( a, b);
    754c:	move.l 20(sp),12(sp)
    7552:	move.l 24(sp),8(sp)
    7558:	move.l d028 <MathIeeeSingBasBase>,d0
    755e:	movea.l d0,a6
    7560:	move.l 12(sp),d0
    7564:	move.l 8(sp),d1
    7568:	jsr -84(a6)
    756c:	move.l d0,4(sp)
    7570:	move.l 4(sp),d0
}
    7574:	movea.l (sp)+,a6
    7576:	lea 12(sp),sp
    757a:	rts

0000757c <__eqsf2>:

int __eqsf2( FLOAT a, FLOAT b) {
    757c:	lea -12(sp),sp
    7580:	move.l a6,-(sp)
	return IEEESPCmp( a, b);
    7582:	move.l 20(sp),12(sp)
    7588:	move.l 24(sp),8(sp)
    758e:	move.l d028 <MathIeeeSingBasBase>,d0
    7594:	movea.l d0,a6
    7596:	move.l 12(sp),d0
    759a:	move.l 8(sp),d1
    759e:	jsr -42(a6)
    75a2:	move.l d0,4(sp)
    75a6:	move.l 4(sp),d0
}
    75aa:	movea.l (sp)+,a6
    75ac:	lea 12(sp),sp
    75b0:	rts

000075b2 <__extendsfdf2>:

DOUBLE __extendsfdf2 (FLOAT a) {
    75b2:	lea -20(sp),sp
    75b6:	move.l a6,-(sp)
	return IEEEDPFieee( a );
    75b8:	move.l 28(sp),20(sp)
    75be:	move.l d034 <MathIeeeDoubTransBase>,d0
    75c4:	movea.l d0,a6
    75c6:	move.l 20(sp),d0
    75ca:	jsr -108(a6)
    75ce:	move.l d0,4(sp)
    75d2:	move.l d1,8(sp)
    75d6:	move.l 4(sp),12(sp)
    75dc:	move.l 8(sp),16(sp)
    75e2:	move.l 12(sp),d0
    75e6:	move.l 16(sp),d1
}
    75ea:	movea.l (sp)+,a6
    75ec:	lea 20(sp),sp
    75f0:	rts

000075f2 <__fixdfsi>:

LONG __fixdfsi(DOUBLE value) {
    75f2:	lea -12(sp),sp
    75f6:	move.l a6,-(sp)
	return IEEEDPFix(value);
    75f8:	move.l 20(sp),8(sp)
    75fe:	move.l 24(sp),12(sp)
    7604:	move.l d030 <MathIeeeDoubBasBase>,d0
    760a:	movea.l d0,a6
    760c:	move.l 8(sp),d0
    7610:	move.l 12(sp),d1
    7614:	jsr -30(a6)
    7618:	move.l d0,4(sp)
    761c:	move.l 4(sp),d0
}
    7620:	movea.l (sp)+,a6
    7622:	lea 12(sp),sp
    7626:	rts

00007628 <__fixsfsi>:

LONG __fixsfsi(FLOAT value) {
    7628:	subq.l #8,sp
    762a:	move.l a6,-(sp)
	return IEEESPFix(value);
    762c:	move.l 16(sp),8(sp)
    7632:	move.l d028 <MathIeeeSingBasBase>,d0
    7638:	movea.l d0,a6
    763a:	move.l 8(sp),d0
    763e:	jsr -30(a6)
    7642:	move.l d0,4(sp)
    7646:	move.l 4(sp),d0
}
    764a:	movea.l (sp)+,a6
    764c:	addq.l #8,sp
    764e:	rts

00007650 <__floatsidf>:


DOUBLE __floatsidf (int i) {
    7650:	lea -20(sp),sp
    7654:	move.l a6,-(sp)
	return IEEEDPFlt((LONG) i);  
    7656:	move.l 28(sp),20(sp)
    765c:	move.l d030 <MathIeeeDoubBasBase>,d0
    7662:	movea.l d0,a6
    7664:	move.l 20(sp),d0
    7668:	jsr -36(a6)
    766c:	move.l d0,4(sp)
    7670:	move.l d1,8(sp)
    7674:	move.l 4(sp),12(sp)
    767a:	move.l 8(sp),16(sp)
    7680:	move.l 12(sp),d0
    7684:	move.l 16(sp),d1
}
    7688:	movea.l (sp)+,a6
    768a:	lea 20(sp),sp
    768e:	rts

00007690 <__floatsisf>:

FLOAT __floatsisf(int i) {
    7690:	subq.l #8,sp
    7692:	move.l a6,-(sp)
	return IEEESPFlt((LONG) i); 
    7694:	move.l 16(sp),8(sp)
    769a:	move.l d028 <MathIeeeSingBasBase>,d0
    76a0:	movea.l d0,a6
    76a2:	move.l 8(sp),d0
    76a6:	jsr -36(a6)
    76aa:	move.l d0,4(sp)
    76ae:	move.l 4(sp),d0
}
    76b2:	movea.l (sp)+,a6
    76b4:	addq.l #8,sp
    76b6:	rts

000076b8 <__muldf3>:

FLOAT __floatunsisf(unsigned int i) {	
	return IEEESPFlt((LONG) i); 
}

DOUBLE __muldf3( DOUBLE leftParm, DOUBLE rightParm ) {
    76b8:	lea -32(sp),sp
    76bc:	movem.l d2-d3/a6,-(sp)
	return IEEEDPMul( leftParm, rightParm);
    76c0:	move.l 48(sp),36(sp)
    76c6:	move.l 52(sp),40(sp)
    76cc:	move.l 56(sp),28(sp)
    76d2:	move.l 60(sp),32(sp)
    76d8:	move.l d030 <MathIeeeDoubBasBase>,d0
    76de:	movea.l d0,a6
    76e0:	move.l 36(sp),d0
    76e4:	move.l 40(sp),d1
    76e8:	move.l 28(sp),d2
    76ec:	move.l 32(sp),d3
    76f0:	jsr -78(a6)
    76f4:	move.l d0,12(sp)
    76f8:	move.l d1,16(sp)
    76fc:	move.l 12(sp),20(sp)
    7702:	move.l 16(sp),24(sp)
    7708:	move.l 20(sp),d0
    770c:	move.l 24(sp),d1
}
    7710:	movem.l (sp)+,d2-d3/a6
    7714:	lea 32(sp),sp
    7718:	rts

0000771a <__mulsf3>:

 //FLOAT IEEESPMul( FLOAT leftParm, FLOAT rightParm );
FLOAT __mulsf3( FLOAT leftParm, FLOAT rightParm ) {
    771a:	lea -12(sp),sp
    771e:	move.l a6,-(sp)
	return IEEESPMul( leftParm, rightParm);
    7720:	move.l 20(sp),12(sp)
    7726:	move.l 24(sp),8(sp)
    772c:	move.l d028 <MathIeeeSingBasBase>,d0
    7732:	movea.l d0,a6
    7734:	move.l 12(sp),d0
    7738:	move.l 8(sp),d1
    773c:	jsr -78(a6)
    7740:	move.l d0,4(sp)
    7744:	move.l 4(sp),d0
}
    7748:	movea.l (sp)+,a6
    774a:	lea 12(sp),sp
    774e:	rts

00007750 <__gesf2>:


int __gesf2( FLOAT a, FLOAT b) {
    7750:	lea -12(sp),sp
    7754:	move.l a6,-(sp)
	return IEEESPCmp( a, b);
    7756:	move.l 20(sp),12(sp)
    775c:	move.l 24(sp),8(sp)
    7762:	move.l d028 <MathIeeeSingBasBase>,d0
    7768:	movea.l d0,a6
    776a:	move.l 12(sp),d0
    776e:	move.l 8(sp),d1
    7772:	jsr -42(a6)
    7776:	move.l d0,4(sp)
    777a:	move.l 4(sp),d0
}
    777e:	movea.l (sp)+,a6
    7780:	lea 12(sp),sp
    7784:	rts

00007786 <__gtdf2>:

int __gtdf2( DOUBLE a, DOUBLE b) {
    7786:	lea -20(sp),sp
    778a:	movem.l d2-d3/a6,-(sp)
	return IEEEDPCmp( a, b);
    778e:	move.l 36(sp),24(sp)
    7794:	move.l 40(sp),28(sp)
    779a:	move.l 44(sp),16(sp)
    77a0:	move.l 48(sp),20(sp)
    77a6:	move.l d030 <MathIeeeDoubBasBase>,d0
    77ac:	movea.l d0,a6
    77ae:	move.l 24(sp),d0
    77b2:	move.l 28(sp),d1
    77b6:	move.l 16(sp),d2
    77ba:	move.l 20(sp),d3
    77be:	jsr -42(a6)
    77c2:	move.l d0,12(sp)
    77c6:	move.l 12(sp),d0
}
    77ca:	movem.l (sp)+,d2-d3/a6
    77ce:	lea 20(sp),sp
    77d2:	rts

000077d4 <__gtsf2>:

int __gtsf2( FLOAT a, FLOAT b) {
    77d4:	lea -12(sp),sp
    77d8:	move.l a6,-(sp)
	return IEEESPCmp( a, b);
    77da:	move.l 20(sp),12(sp)
    77e0:	move.l 24(sp),8(sp)
    77e6:	move.l d028 <MathIeeeSingBasBase>,d0
    77ec:	movea.l d0,a6
    77ee:	move.l 12(sp),d0
    77f2:	move.l 8(sp),d1
    77f6:	jsr -42(a6)
    77fa:	move.l d0,4(sp)
    77fe:	move.l 4(sp),d0
}
    7802:	movea.l (sp)+,a6
    7804:	lea 12(sp),sp
    7808:	rts

0000780a <__ltdf2>:

int __lesf2( FLOAT a, FLOAT b) {
	return IEEESPCmp( a, b);
}

int __ltdf2( DOUBLE a, DOUBLE b) {
    780a:	lea -20(sp),sp
    780e:	movem.l d2-d3/a6,-(sp)
	return IEEEDPCmp( a, b);
    7812:	move.l 36(sp),24(sp)
    7818:	move.l 40(sp),28(sp)
    781e:	move.l 44(sp),16(sp)
    7824:	move.l 48(sp),20(sp)
    782a:	move.l d030 <MathIeeeDoubBasBase>,d0
    7830:	movea.l d0,a6
    7832:	move.l 24(sp),d0
    7836:	move.l 28(sp),d1
    783a:	move.l 16(sp),d2
    783e:	move.l 20(sp),d3
    7842:	jsr -42(a6)
    7846:	move.l d0,12(sp)
    784a:	move.l 12(sp),d0
}
    784e:	movem.l (sp)+,d2-d3/a6
    7852:	lea 20(sp),sp
    7856:	rts

00007858 <__ltsf2>:

int __ltsf2( FLOAT a, FLOAT b) {
    7858:	lea -12(sp),sp
    785c:	move.l a6,-(sp)
	return IEEESPCmp( a, b);
    785e:	move.l 20(sp),12(sp)
    7864:	move.l 24(sp),8(sp)
    786a:	move.l d028 <MathIeeeSingBasBase>,d0
    7870:	movea.l d0,a6
    7872:	move.l 12(sp),d0
    7876:	move.l 8(sp),d1
    787a:	jsr -42(a6)
    787e:	move.l d0,4(sp)
    7882:	move.l 4(sp),d0
}
    7886:	movea.l (sp)+,a6
    7888:	lea 12(sp),sp
    788c:	rts

0000788e <__nesf2>:

int __nesf2( FLOAT a, FLOAT b) {
    788e:	lea -12(sp),sp
    7892:	move.l a6,-(sp)
	return IEEESPCmp( a, b);
    7894:	move.l 20(sp),12(sp)
    789a:	move.l 24(sp),8(sp)
    78a0:	move.l d028 <MathIeeeSingBasBase>,d0
    78a6:	movea.l d0,a6
    78a8:	move.l 12(sp),d0
    78ac:	move.l 8(sp),d1
    78b0:	jsr -42(a6)
    78b4:	move.l d0,4(sp)
    78b8:	move.l 4(sp),d0
}
    78bc:	movea.l (sp)+,a6
    78be:	lea 12(sp),sp
    78c2:	rts

000078c4 <__subdf3>:

DOUBLE __subdf3 (DOUBLE a, DOUBLE b) {
    78c4:	lea -32(sp),sp
    78c8:	movem.l d2-d3/a6,-(sp)
	return IEEEDPSub( a, b);
    78cc:	move.l 48(sp),36(sp)
    78d2:	move.l 52(sp),40(sp)
    78d8:	move.l 56(sp),28(sp)
    78de:	move.l 60(sp),32(sp)
    78e4:	move.l d030 <MathIeeeDoubBasBase>,d0
    78ea:	movea.l d0,a6
    78ec:	move.l 36(sp),d0
    78f0:	move.l 40(sp),d1
    78f4:	move.l 28(sp),d2
    78f8:	move.l 32(sp),d3
    78fc:	jsr -72(a6)
    7900:	move.l d0,12(sp)
    7904:	move.l d1,16(sp)
    7908:	move.l 12(sp),20(sp)
    790e:	move.l 16(sp),24(sp)
    7914:	move.l 20(sp),d0
    7918:	move.l 24(sp),d1
}
    791c:	movem.l (sp)+,d2-d3/a6
    7920:	lea 32(sp),sp
    7924:	rts

00007926 <__subsf3>:

FLOAT __subsf3 (float a, float b) {
    7926:	lea -12(sp),sp
    792a:	move.l a6,-(sp)
	return IEEESPSub( a, b);
    792c:	move.l 20(sp),12(sp)
    7932:	move.l 24(sp),8(sp)
    7938:	move.l d028 <MathIeeeSingBasBase>,d0
    793e:	movea.l d0,a6
    7940:	move.l 12(sp),d0
    7944:	move.l 8(sp),d1
    7948:	jsr -72(a6)
    794c:	move.l d0,4(sp)
    7950:	move.l 4(sp),d0
}
    7954:	movea.l (sp)+,a6
    7956:	lea 12(sp),sp
    795a:	rts

0000795c <__truncdfsf2>:

FLOAT __truncdfsf2(DOUBLE a) {
    795c:	lea -12(sp),sp
    7960:	move.l a6,-(sp)
	return IEEEDPTieee( a);
    7962:	move.l 20(sp),8(sp)
    7968:	move.l 24(sp),12(sp)
    796e:	move.l d034 <MathIeeeDoubTransBase>,d0
    7974:	movea.l d0,a6
    7976:	move.l 8(sp),d0
    797a:	move.l 12(sp),d1
    797e:	jsr -102(a6)
    7982:	move.l d0,4(sp)
    7986:	move.l 4(sp),d0
}
    798a:	movea.l (sp)+,a6
    798c:	lea 12(sp),sp
    7990:	rts

00007992 <atan2f>:

unsigned int __fixunssfsi (float a) {
	return IEEESPFix(a);
}

FLOAT atan2f(FLOAT y, FLOAT x) {
    7992:	       lea -24(sp),sp
    7996:	       move.l a6,-(sp)
    if (x > 0) {
    7998:	       clr.l -(sp)
    799a:	       move.l 40(sp),-(sp)
    799e:	       jsr 77d4 <__gtsf2>
    79a4:	       addq.l #8,sp
    79a6:	       tst.l d0
    79a8:	   ,-- ble.s 79da <atan2f+0x48>
        return IEEESPAtan(y / x);
    79aa:	   |   move.l 36(sp),-(sp)
    79ae:	   |   move.l 36(sp),-(sp)
    79b2:	   |   jsr 7546 <__divsf3>
    79b8:	   |   addq.l #8,sp
    79ba:	   |   move.l d0,8(sp)
    79be:	   |   move.l d02c <MathIeeeSingTransBase>,d0
    79c4:	   |   movea.l d0,a6
    79c6:	   |   move.l 8(sp),d0
    79ca:	   |   jsr -30(a6)
    79ce:	   |   move.l d0,4(sp)
    79d2:	   |   move.l 4(sp),d0
    79d6:	,--|-- bra.w 7b3a <atan2f+0x1a8>
    } else if (x < 0 && y >= 0) {
    79da:	|  '-> clr.l -(sp)
    79dc:	|      move.l 40(sp),-(sp)
    79e0:	|      jsr 7858 <__ltsf2>
    79e6:	|      addq.l #8,sp
    79e8:	|      tst.l d0
    79ea:	|  ,-- bge.s 7a5e <atan2f+0xcc>
    79ec:	|  |   clr.l -(sp)
    79ee:	|  |   move.l 36(sp),-(sp)
    79f2:	|  |   jsr 7750 <__gesf2>
    79f8:	|  |   addq.l #8,sp
    79fa:	|  |   tst.l d0
    79fc:	|  +-- blt.s 7a5e <atan2f+0xcc>
        return IEEESPAtan(y / x) + PI;
    79fe:	|  |   move.l 36(sp),-(sp)
    7a02:	|  |   move.l 36(sp),-(sp)
    7a06:	|  |   jsr 7546 <__divsf3>
    7a0c:	|  |   addq.l #8,sp
    7a0e:	|  |   move.l d0,24(sp)
    7a12:	|  |   move.l d02c <MathIeeeSingTransBase>,d0
    7a18:	|  |   movea.l d0,a6
    7a1a:	|  |   move.l 24(sp),d0
    7a1e:	|  |   jsr -30(a6)
    7a22:	|  |   move.l d0,20(sp)
    7a26:	|  |   move.l 20(sp),d0
    7a2a:	|  |   move.l d0,-(sp)
    7a2c:	|  |   jsr 75b2 <__extendsfdf2>
    7a32:	|  |   addq.l #4,sp
    7a34:	|  |   move.l #1413754136,-(sp)
    7a3a:	|  |   move.l #1074340347,-(sp)
    7a40:	|  |   move.l d1,-(sp)
    7a42:	|  |   move.l d0,-(sp)
    7a44:	|  |   jsr 7482 <__adddf3>
    7a4a:	|  |   lea 16(sp),sp
    7a4e:	|  |   move.l d1,-(sp)
    7a50:	|  |   move.l d0,-(sp)
    7a52:	|  |   jsr 795c <__truncdfsf2>
    7a58:	|  |   addq.l #8,sp
    7a5a:	+--|-- bra.w 7b3a <atan2f+0x1a8>
    } else if (x < 0 && y < 0) {
    7a5e:	|  '-> clr.l -(sp)
    7a60:	|      move.l 40(sp),-(sp)
    7a64:	|      jsr 7858 <__ltsf2>
    7a6a:	|      addq.l #8,sp
    7a6c:	|      tst.l d0
    7a6e:	|  ,-- bge.s 7ae0 <atan2f+0x14e>
    7a70:	|  |   clr.l -(sp)
    7a72:	|  |   move.l 36(sp),-(sp)
    7a76:	|  |   jsr 7858 <__ltsf2>
    7a7c:	|  |   addq.l #8,sp
    7a7e:	|  |   tst.l d0
    7a80:	|  +-- bge.s 7ae0 <atan2f+0x14e>
        return IEEESPAtan(y / x) - PI;
    7a82:	|  |   move.l 36(sp),-(sp)
    7a86:	|  |   move.l 36(sp),-(sp)
    7a8a:	|  |   jsr 7546 <__divsf3>
    7a90:	|  |   addq.l #8,sp
    7a92:	|  |   move.l d0,16(sp)
    7a96:	|  |   move.l d02c <MathIeeeSingTransBase>,d0
    7a9c:	|  |   movea.l d0,a6
    7a9e:	|  |   move.l 16(sp),d0
    7aa2:	|  |   jsr -30(a6)
    7aa6:	|  |   move.l d0,12(sp)
    7aaa:	|  |   move.l 12(sp),d0
    7aae:	|  |   move.l d0,-(sp)
    7ab0:	|  |   jsr 75b2 <__extendsfdf2>
    7ab6:	|  |   addq.l #4,sp
    7ab8:	|  |   move.l #1413754136,-(sp)
    7abe:	|  |   move.l #1074340347,-(sp)
    7ac4:	|  |   move.l d1,-(sp)
    7ac6:	|  |   move.l d0,-(sp)
    7ac8:	|  |   jsr 78c4 <__subdf3>
    7ace:	|  |   lea 16(sp),sp
    7ad2:	|  |   move.l d1,-(sp)
    7ad4:	|  |   move.l d0,-(sp)
    7ad6:	|  |   jsr 795c <__truncdfsf2>
    7adc:	|  |   addq.l #8,sp
    7ade:	+--|-- bra.s 7b3a <atan2f+0x1a8>
    } else if (x == 0 && y > 0) {
    7ae0:	|  '-> clr.l -(sp)
    7ae2:	|      move.l 40(sp),-(sp)
    7ae6:	|      jsr 757c <__eqsf2>
    7aec:	|      addq.l #8,sp
    7aee:	|      tst.l d0
    7af0:	|  ,-- bne.s 7b0c <atan2f+0x17a>
    7af2:	|  |   clr.l -(sp)
    7af4:	|  |   move.l 36(sp),-(sp)
    7af8:	|  |   jsr 77d4 <__gtsf2>
    7afe:	|  |   addq.l #8,sp
    7b00:	|  |   tst.l d0
    7b02:	|  +-- ble.s 7b0c <atan2f+0x17a>
        return PI / 2;
    7b04:	|  |   move.l #1070141403,d0
    7b0a:	+--|-- bra.s 7b3a <atan2f+0x1a8>
    } else if (x == 0 && y < 0) {
    7b0c:	|  '-> clr.l -(sp)
    7b0e:	|      move.l 40(sp),-(sp)
    7b12:	|      jsr 757c <__eqsf2>
    7b18:	|      addq.l #8,sp
    7b1a:	|      tst.l d0
    7b1c:	|  ,-- bne.s 7b38 <atan2f+0x1a6>
    7b1e:	|  |   clr.l -(sp)
    7b20:	|  |   move.l 36(sp),-(sp)
    7b24:	|  |   jsr 7858 <__ltsf2>
    7b2a:	|  |   addq.l #8,sp
    7b2c:	|  |   tst.l d0
    7b2e:	|  +-- bge.s 7b38 <atan2f+0x1a6>
        return -PI / 2;
    7b30:	|  |   move.l #-1077342245,d0
    7b36:	+--|-- bra.s 7b3a <atan2f+0x1a8>
    } else {
        // This case is x == 0 and y == 0, atan2(0, 0) is undefined, but often treated as 0.
        return 0;
    7b38:	|  '-> moveq #0,d0
    }
}
    7b3a:	'----> movea.l (sp)+,a6
    7b3c:	       lea 24(sp),sp
    7b40:	       rts

00007b42 <sqrt>:

DOUBLE sqrt( DOUBLE input) {
    7b42:	lea -24(sp),sp
    7b46:	move.l a6,-(sp)
	return IEEEDPSqrt(input);
    7b48:	move.l 32(sp),20(sp)
    7b4e:	move.l 36(sp),24(sp)
    7b54:	move.l d034 <MathIeeeDoubTransBase>,d0
    7b5a:	movea.l d0,a6
    7b5c:	move.l 20(sp),d0
    7b60:	move.l 24(sp),d1
    7b64:	jsr -96(a6)
    7b68:	move.l d0,4(sp)
    7b6c:	move.l d1,8(sp)
    7b70:	move.l 4(sp),12(sp)
    7b76:	move.l 8(sp),16(sp)
    7b7c:	move.l 12(sp),d0
    7b80:	move.l 16(sp),d1
}
    7b84:	movea.l (sp)+,a6
    7b86:	lea 24(sp),sp
    7b8a:	rts

00007b8c <__mulsi3>:
	.section .text.__mulsi3,"ax",@progbits
	.type __mulsi3, function
	.globl	__mulsi3
__mulsi3:
	.cfi_startproc
	movew	sp@(4), d0	/* x0 -> d0 */
    7b8c:	move.w 4(sp),d0
	muluw	sp@(10), d0	/* x0*y1 */
    7b90:	mulu.w 10(sp),d0
	movew	sp@(6), d1	/* x1 -> d1 */
    7b94:	move.w 6(sp),d1
	muluw	sp@(8), d1	/* x1*y0 */
    7b98:	mulu.w 8(sp),d1
	addw	d1, d0
    7b9c:	add.w d1,d0
	swap	d0
    7b9e:	swap d0
	clrw	d0
    7ba0:	clr.w d0
	movew	sp@(6), d1	/* x1 -> d1 */
    7ba2:	move.w 6(sp),d1
	muluw	sp@(10), d1	/* x1*y1 */
    7ba6:	mulu.w 10(sp),d1
	addl	d1, d0
    7baa:	add.l d1,d0
	rts
    7bac:	rts

00007bae <__udivsi3>:
	.section .text.__udivsi3,"ax",@progbits
	.type __udivsi3, function
	.globl	__udivsi3
__udivsi3:
	.cfi_startproc
	movel	d2, sp@-
    7bae:	       move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
    7bb0:	       move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
    7bb4:	       move.l 8(sp),d0

	cmpl	#0x10000, d1 /* divisor >= 2 ^ 16 ?   */
    7bb8:	       cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
    7bbe:	   ,-- bcc.s 7bd6 <__udivsi3+0x28>
	movel	d0, d2
    7bc0:	   |   move.l d0,d2
	clrw	d2
    7bc2:	   |   clr.w d2
	swap	d2
    7bc4:	   |   swap d2
	divu	d1, d2          /* high quotient in lower word */
    7bc6:	   |   divu.w d1,d2
	movew	d2, d0		/* save high quotient */
    7bc8:	   |   move.w d2,d0
	swap	d0
    7bca:	   |   swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
    7bcc:	   |   move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
    7bd0:	   |   divu.w d1,d2
	movew	d2, d0
    7bd2:	   |   move.w d2,d0
	jra	6f
    7bd4:	,--|-- bra.s 7c06 <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
    7bd6:	|  '-> move.l d1,d2
4:	lsrl	#1, d1	/* shift divisor */
    7bd8:	|  ,-> lsr.l #1,d1
	lsrl	#1, d0	/* shift dividend */
    7bda:	|  |   lsr.l #1,d0
	cmpl	#0x10000, d1 /* still divisor >= 2 ^ 16 ?  */
    7bdc:	|  |   cmpi.l #65536,d1
	jcc	4b
    7be2:	|  '-- bcc.s 7bd8 <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
    7be4:	|      divu.w d1,d0
	andl	#0xffff, d0 /* mask out divisor, ignore remainder */
    7be6:	|      andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
    7bec:	|      move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
    7bee:	|      mulu.w d0,d1
	swap	d2
    7bf0:	|      swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
    7bf2:	|      mulu.w d0,d2
	swap	d2		/* align high part with low part */
    7bf4:	|      swap d2
	tstw	d2		/* high part 17 bits? */
    7bf6:	|      tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
    7bf8:	|  ,-- bne.s 7c04 <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
    7bfa:	|  |   add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
    7bfc:	|  +-- bcs.s 7c04 <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
    7bfe:	|  |   cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
    7c02:	+--|-- bls.s 7c06 <__udivsi3+0x58>
5:	subql	#1, d0	/* adjust quotient */
    7c04:	|  '-> subq.l #1,d0

6:	movel	sp@+, d2
    7c06:	'----> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    7c08:	       rts

00007c0a <__divsi3>:
	.section .text.__divsi3,"ax",@progbits
	.type __divsi3, function
	.globl	__divsi3
 __divsi3:
 	.cfi_startproc
	movel	d2, sp@-
    7c0a:	    move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	#1, d2	/* sign of result stored in d2 (=1 or =-1) */
    7c0c:	    moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
    7c0e:	    move.l 12(sp),d1
	jpl	1f
    7c12:	,-- bpl.s 7c18 <__divsi3+0xe>
	negl	d1
    7c14:	|   neg.l d1
	negb	d2		/* change sign because divisor <0  */
    7c16:	|   neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
    7c18:	'-> move.l 8(sp),d0
	jpl	2f
    7c1c:	,-- bpl.s 7c22 <__divsi3+0x18>
	negl	d0
    7c1e:	|   neg.l d0
	negb	d2
    7c20:	|   neg.b d2

2:	movel	d1, sp@-
    7c22:	'-> move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    7c24:	    move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__udivsi3	/* divide abs(dividend) by abs(divisor) */
    7c26:	    jsr 7bae <__udivsi3>
	addql	#8, sp
    7c2c:	    addq.l #8,sp
	.cfi_adjust_cfa_offset -8

	tstb	d2
    7c2e:	    tst.b d2
	jpl	3f
    7c30:	,-- bpl.s 7c34 <__divsi3+0x2a>
	negl	d0
    7c32:	|   neg.l d0

3:	movel	sp@+, d2
    7c34:	'-> move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    7c36:	    rts

00007c38 <__modsi3>:
	.section .text.__modsi3,"ax",@progbits
	.type __modsi3, function
	.globl	__modsi3
__modsi3:
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
    7c38:	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
    7c3c:	move.l 4(sp),d0
	movel	d1, sp@-
    7c40:	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    7c42:	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__divsi3
    7c44:	jsr 7c0a <__divsi3>
	addql	#8, sp
    7c4a:	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
    7c4c:	move.l 8(sp),d1
	movel	d1, sp@-
    7c50:	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    7c52:	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	jbsr	__mulsi3	/* d0 = (a/b)*b */
    7c54:	jsr 7b8c <__mulsi3>
	addql	#8, sp
    7c5a:	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
    7c5c:	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
    7c60:	sub.l d0,d1
	movel	d1, d0
    7c62:	move.l d1,d0
	rts
    7c64:	rts

00007c66 <KPutCharX>:
	.type KPutCharX, function
	.globl	KPutCharX

KPutCharX:
	.cfi_startproc
    move.l  a6, -(sp)
    7c66:	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
    7c68:	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
    7c6c:	jsr -516(a6)
    move.l (sp)+, a6
    7c70:	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
    7c72:	rts

00007c74 <PutChar>:
	.type PutChar, function
	.globl	PutChar

PutChar:
	.cfi_startproc
	move.b d0, (a3)+
    7c74:	move.b d0,(a3)+
	rts
    7c76:	rts
