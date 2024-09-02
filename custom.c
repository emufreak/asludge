#define CSTCOPSIZE 400
#define CSTBPL1HIGH 28*2+1
#define CSTBPL1LOW 29*2+1
#define CSTBPL2HIGH 30*2+1
#define CSTBPL2LOW 31*2+1
#define CSTBPL3HIGH 32*2+1
#define CSTBPL3LOW 33*2+1
#define CSTBPL4HIGH 34*2+1
#define CSTBPL4LOW 35*2+1
#define CSTBPL5HIGH 36*2+1
#define CSTBPL5LOW 37*2+1
#define EMULATOR

#include <exec/types.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <hardware/custom.h>

#include "custom.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"

extern unsigned int winWidth, winHeight;

UWORD CstPaletteLoaded = 0;
UWORD CstBackdropSize;
UWORD CstBackdropSizePlane;
UWORD *CstBackDrop;
UWORD *CstCopperList;
UWORD CstApplyBackDropCounter = 0; //Backdrop needs to be loaded twice. Once for every buffer in separate frames.
ULONG *CstViewBuffer;
ULONG *CstDrawBuffer;
struct CleanupQueue *CstCleanupQueueViewBuffer = NULL;
struct CleanupQueue *CstCleanupQueueDrawBuffer = NULL;
UWORD *CstBackDropBufferApplyStart;
UWORD *CstBackDropBufferApplyCursor;
UWORD *CstClColor;
UWORD *CstPalette;
UWORD *CstClCursor;

ULONG CstClSprites[] = { 0x001200000, 0x001220000,0x001240000,0x001260000, 0x001280000,                          
        0x0012a0000, 0x0012c0000, 0x0012e0000, 0x001300000, 0x001320000, 0x001340000,
                 0x001360000, 0x001380000, 0x0013a0000, 0x0013c0000, 0x0013e0000  };

ULONG CstClScreen[] = { 0x001fc0000, 0x001060000, 0x0009687ff, 
        0x0008e2c81, 0x000902cc1,0x000920038, 0x0009400d0, 
        0x001020000, 0x001040009, 0x001080000, 0x0010a0000, 0x001005200 };

ULONG CstClBitplanes[] = { 0x0e00000, 0x0e20000, 0x0e40000, 0x0e60000,
    0x0e80000, 0x0ea0000, 0x0ec0000, 0x0ee0000,
    0x0f00000, 0x0f20000 };

ULONG CstClColorTemplate[] = { 
    0x1800000, 0x1820000, 0x1840000, 0x1860000, 0x1880000, 0x18a0000, 0x18c0000, 0x18e0000,
    0x1900000, 0x1920000, 0x1940000, 0x1960000, 0x1980000, 0x19a0000, 0x19c0000, 0x19e0000,
    0x1a00000, 0x1a20000, 0x1a40000, 0x1a60000, 0x1a80000, 0x1aa0000, 0x1ac0000, 0x1ae0000,
    0x1b00000, 0x1b20000, 0x1b40000, 0x1b60000, 0x1b80000, 0x1ba0000, 0x1bc0000, 0x1be0000 
};

void CstBlankScreen( int width, int height) {

  KPrintF("CstBlankScreen: started\n");

  if( !CstBackDrop) {
    KPrintF("CstBlankScreen: Backdrop empty nothing to do\n");
    return;
  }

  CstPaletteLoaded = 0;

  volatile struct Custom *custom = (struct Custom*)0xdff000;

  width /= 16;

  WaitBlit();

  //Both Buffers need to be done
  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltamod = 0;
  custom->bltbmod = 0;
  custom->bltcmod = 0;
  custom->bltdmod = 0;
  custom->bltcon1 = 0;
  custom->bltcon0 = 0x0100;
  ULONG bltdpt = (ULONG) CstBackDrop;
  UWORD bltsize = height*64+width;    
  UWORD blitsize = width*height*2;

  KPrintF("CstBlankScreen: Starting Blits\n");

  for(int i2=0;i2<5;i2++)
  {            
    custom->bltdpt = (APTR) bltdpt;
    custom->bltsize = bltsize;            
    WaitBlit();
    bltdpt += blitsize;
  }

  KPrintF("CstBlankScreen: Finished Blits\n");

  CstApplyBackDropCounter = 2;

  *CstBackDropBufferApplyCursor++ = winWidth/16;
  *CstBackDropBufferApplyCursor++ = winHeight;
  *CstBackDropBufferApplyCursor++ = 0;
  *CstBackDropBufferApplyCursor++ = 0;
  *CstBackDropBufferApplyCursor++ = 0;

  KPrintF("CstBlankScreen: end\n");


}

UWORD * CstCreateCopperlist( int width) {
  
  ULONG *retval = AllocMem(  CSTCOPSIZE, MEMF_CHIP);
  
  if( retval == 0) {
    KPrintF("CstCreateCopperlist: Allocation of Ram for Copper failed.\n", 40);
    Exit(1);
  }
  ULONG *cl = retval;
  CstClCursor = (UWORD *)cl;

  ULONG *clpartinstruction;
  clpartinstruction = CstClSprites;
  for(int i=0; i<16;i++)
    *cl++ = *clpartinstruction++;

  clpartinstruction = CstClScreen;

  for(int i=0; i<12;i++)
    *cl++ = *clpartinstruction++;

  clpartinstruction = CstClBitplanes;
  for(int i=0; i<10;i++)
    *cl++ = *clpartinstruction++;        

  
  clpartinstruction = CstClColorTemplate;
  CstClColor = (UWORD *) cl;
  for(int i=0; i<32;i++)
    *cl++ = *clpartinstruction++;        
 
  /* Screen is bigger than real screen? Setup BPLxMod accordingly*/
  if(width > 40) {
    int tmp = width - 40;
    UWORD *cw = (UWORD *) cl; 
    *cw++ = 0x108;
    *cw++ = tmp;
    *cw++ = 0x10a;
    *cw++ = tmp;     
  }

  *cl++ = 0xfffffffe;
  return (UWORD *) retval;  
}

void CstDisplayBackDrop() 
{
 volatile struct Custom *custom = (struct Custom*)0xdff000;  

  KPrintF("CstDisplayBackDrop: Started");

  CstBackDropBufferApplyCursor = CstBackDropBufferApplyStart;
  UWORD *cursor = CstBackDropBufferApplyStart;
  if(!*cursor || !CstDrawBuffer) {
    return;
  } 

  WaitBlit();
  
  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;  
  custom->bltcon0 = 0x9f0;
  
  while(*cursor)
  {    
    UWORD width = *cursor++;
    UWORD height = *cursor++;
    UWORD xpos = *cursor++;
    UWORD ypos = *cursor++;

    custom->bltamod = winWidth/8-width*2;
    custom->bltdmod = winWidth/8-width*2;
    ULONG bltapt = ((ULONG) CstBackDrop) + ypos*winWidth/8 + xpos;
    ULONG bltdpt = ((ULONG) CstDrawBuffer) + ypos*winWidth/8 + xpos;
    for(int i=0;i<5;i++) //ToDo other numbers of Bitplanes
    {
      custom->bltapt = (APTR) bltapt;
      custom->bltdpt = (APTR) bltdpt;
      custom->bltsize = (height << 6) + width;
      bltapt += winWidth/8*winHeight;
      bltdpt += winWidth/8*winHeight;
      WaitBlit();
    }  
  }
  UWORD *colorpos = CstPalette;
  
  UWORD *tmp = CstClColor;
  for(int i=0;i<32;i++) { //ToDo Support other number of bitplanes
    *tmp++;
    *tmp++ = *colorpos++;
  }
}

void CstDisplayCursor(UWORD x, UWORD y, UWORD height, UBYTE *spritedata)
{
  spritedata[0] = (UBYTE) (y & 0xff); //Low 8 Bits of y
  spritedata[1] = (UBYTE) (x >> 1); //High 8 Bits of x
  spritedata[2] = (UBYTE) (y+height & 0xff); //Sprite Stop Low 8 Bits

  UWORD lowbitx = x & 0x1;
  UWORD vstophighbit = ((y+height) & 0x100) >> 7;
  UWORD vstarthighbit = (y & 0x100) >> 6;

  spritedata[3] = lowbitx + vstophighbit + vstarthighbit; //Low Bit X, Sprite Stop High Bit

  ULONG ptr = (ULONG) spritedata; 
  UWORD loptr = (UWORD) ptr & 0xffff;
  UWORD hiptr = ptr >> 16;

  CstClCursor[1] = hiptr;
  CstClCursor[3] = loptr;

}

void CstDrawBackdrop() {  
  if(CstApplyBackDropCounter > 0) 
  {
    CstDisplayBackDrop();
    CstApplyBackDropCounter--;
  }    
}

void CstLoadBackdrop( BPTR fp, int x, int y) {

	KPrintF("CstLoadBackDrop: Loading of Background started");

  UWORD width = get2bytes(fp);
  UWORD height = get2bytes(fp);  

  UWORD widthbyteslayer = width/8;
  UWORD widthwordslayer = widthbyteslayer/2;  
  UWORD widthbytesbackdrop = winWidth / 8;
  UWORD sizeplane =  widthbyteslayer*height;
  UWORD size = sizeplane * 5; //Todo other number of bitplanes

  //Load Palette to Copper
  if( CstPaletteLoaded == 0)
  {    
    UWORD reg = 0x180;

    if(CstPalette) {
      FreeVec(CstPalette);
    }

    CstPalette = AllocVec(32*2,MEMF_ANY); //ToDo other number of bitplanes
    CstPaletteLoaded = 1;
    UWORD *tmp = CstPalette;
    for(int i=0;i<32;i++) { //ToDo Support other number of bitplanes   
      *tmp++ = get2bytes(fp);
    }
  }
  else
  //There's already a palette loaded for this background. Do not load palette
  {
    for(int i=0;i<32;i++) { //ToDo Support other number of bitplanes   
      get2bytes(fp);
    }
  }

  //Load Picture From Disk
  UWORD *tmpbuffer = AllocVec(size, MEMF_CHIP); //Todo other number of bitplanes
  if( !tmpbuffer)
  {
    KPrintF("CstLoadBackDrop: Cannot allocate Memory for tmpbuffer");
  }
  UWORD *tmpmask = AllocVec(sizeplane, MEMF_CHIP);
  if( !tmpmask)
  {
    KPrintF("CstLoadBackDrop: Cannot allocate Memory for tmpmask");
  }

#ifdef EMULATOR
  debug_register_bitmap(tmpbuffer, "tmpbuffer.bpl", width, height, 5, 0);
  debug_register_bitmap(tmpbuffer, "tmpmask.bpl", width, height, 1, 0);
#endif  

  UWORD count = FRead( fp, tmpbuffer, 2, size/2);
  if(!count) {
    KPrintF("Error while reading stream");
    return;
  }  
  count = FRead( fp, tmpmask, 2, sizeplane/2);
   

  if(!count) {
    KPrintF("Error while reading stream");
    return;
  }

  //Writing to Framebuffer
  volatile struct Custom *custom = (struct Custom*)0xdff000;

  ULONG backdropcursor = (ULONG) CstBackDrop; 
  UWORD offset = widthbytesbackdrop*y + x / 8;
  backdropcursor += offset; 

 	KPrintF("CstLoadBackDrop: Starting Blit");


  WaitBlit();

  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltamod = 0;
  custom->bltbmod = 0;
  custom->bltcmod = widthbytesbackdrop - widthbyteslayer;
  custom->bltdmod = widthbytesbackdrop - widthbyteslayer;
  custom->bltcon0 = 0xfca;
  custom->bltcon1 = 0;
  
  ULONG tmpbuffercursor = (ULONG) tmpbuffer;
  for(int i=0;i<5;i++) //Todo other number of bitplanes
  {    
    custom->bltapt = (APTR) tmpmask;
    custom->bltbpt = (APTR) tmpbuffercursor;
    custom->bltcpt = (APTR)backdropcursor;
    custom->bltdpt = (APTR) backdropcursor;
    custom->bltsize = (height<<6)+widthwordslayer;
    tmpbuffercursor += sizeplane;
    backdropcursor += CstBackdropSizePlane;
  }    

  WaitBlit();

 	KPrintF("CstLoadBackDrop: Freeing Memory");


  FreeVec(tmpbuffer);
  FreeVec(tmpmask);

  CstApplyBackDropCounter = 2;

  *CstBackDropBufferApplyCursor++ = winWidth/16;
  *CstBackDropBufferApplyCursor++ = winHeight;
  *CstBackDropBufferApplyCursor++ = 0;
  *CstBackDropBufferApplyCursor++ = 0;
  *CstBackDropBufferApplyCursor++ = 0;

  KPrintF("CstLoadBackDrop: Finished");

}

ULONG test = 0;

void CstRestoreScreen()
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;  

  //struct CleanupQueue *cursor  = CstCleanupQueueDrawBuffer;
  if(!CstCleanupQueueDrawBuffer || !CstDrawBuffer) {
    return;
  } 

  WaitBlit();
  
  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;  
  custom->bltcon0 = 0x9f0;
  
  while(CstCleanupQueueDrawBuffer)
  {    

    custom->bltamod = winWidth/8-CstCleanupQueueDrawBuffer->widthinwords*2;
    custom->bltdmod = winWidth/8-CstCleanupQueueDrawBuffer->widthinwords*2;
    ULONG bltapt = ((ULONG) CstBackDrop) + CstCleanupQueueDrawBuffer->starty*winWidth/8 + CstCleanupQueueDrawBuffer->startxinbytes;
    ULONG bltdpt = ((ULONG) CstDrawBuffer) + CstCleanupQueueDrawBuffer->starty*winWidth/8 + CstCleanupQueueDrawBuffer->startxinbytes;
    for(int i=0;i<5;i++) //ToDo other numbers of Bitplanes
    {
      custom->bltapt = (APTR) bltapt;
      custom->bltdpt = (APTR) bltdpt;
      custom->bltsize = (CstCleanupQueueDrawBuffer->height << 6) + CstCleanupQueueDrawBuffer->widthinwords;
      bltapt += winWidth/8*winHeight;
      bltdpt += winWidth/8*winHeight;
      WaitBlit();
    }
    struct CleanupQueue *todelete = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = CstCleanupQueueDrawBuffer->next;  
    FreeVec(todelete);    
    todelete = NULL;
  }
  
}

void CstScaleSprite( struct sprite *single, WORD x, WORD y, UWORD destinationtype)
{

  UWORD *destination = 0;
  switch(destinationtype)
  {
    case SCREEN:
      destination = (UWORD *) CstDrawBuffer;      
      break;
    case BACKDROP:
      CstApplyBackDropCounter = 2;
      destination = (UWORD *) CstBackDrop;      
      break;
  }

  UWORD extrawords; //When Input is shifted sometimes an extra word has to be written to cover the whole sprite
  UWORD cutwordssource; //If some words are completely outside of screen
  UWORD cutmaskpixel; //Single pixels outside of Screen need to be masked out to prevent corruption of background
  UWORD bltalwm; //Mask out all or part of last word as out of range of source.
  ULONG bltapt; //Start Position Source Mask
  ULONG bltbpt; //Start Position Source
  ULONG bltcpt; //Start Position Background
  ULONG bltdpt; //Start Position DrawBuffer
  ULONG bltcon0; //Channel configuration and shift mask
  ULONG bltcon1; //Shift Source
  ULONG ystartdst;
  ULONG ystartsrc; 
  ULONG blitheight;

  if( y < 0) {
    if(y + single->height < 0) {
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;
    }
    ystartdst = 0;
    ystartsrc = y*-1;
    blitheight = single->height+y;
  } else if(y+single->height > (int) winHeight) {
    if(y  > (int) winHeight) {
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;
    }
    ystartdst = y;
    ystartsrc = 0;
    blitheight = winHeight-y;
  } else {
    ystartdst = y;
    ystartsrc = 0;
    blitheight = single->height;
  }


  if( x < 0) { //Leftmost part outside screen
    if(x + single->width < 0) {
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;

    }
    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    CstCleanupQueueDrawBuffer->next = next;
    
    extrawords = 1;
    cutwordssource = (x*-1)/16; 
    cutmaskpixel = (x*-1)%16;     
    bltalwm = 0; //Last Word of this channel almost masked out
    bltapt = ((ULONG) single->data)+(single->width/8)*single->height*5+cutwordssource*2+ystartsrc*single->width/8;
    bltbpt = ((ULONG) single->data)+cutwordssource*2+ystartsrc*single->width/8;
    bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 - 2;
    bltdpt = ((ULONG) destination) + ystartdst*winWidth/8 - 2;
    bltcon0 = 0xfca + ((16-cutmaskpixel) << 12);
    bltcon1 = ((16-cutmaskpixel) << 12);
    if( destinationtype == SCREEN)
    {
      CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource+extrawords; //Width in X Bytes
      CstCleanupQueueDrawBuffer->height = blitheight;
      CstCleanupQueueDrawBuffer->startxinbytes = 0;
      CstCleanupQueueDrawBuffer->starty = ystartdst;
    } else {
      *CstBackDropBufferApplyCursor++ = single->width/16+cutwordssource+extrawords;
      *CstBackDropBufferApplyCursor++ = blitheight;
      *CstBackDropBufferApplyCursor++ = 0;
      *CstBackDropBufferApplyCursor++ = ystartdst;
      *CstBackDropBufferApplyCursor++ = 0;
    }
  } else if(x + single->width > (int) winWidth) { //Rightmost part outside screen
    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    CstCleanupQueueDrawBuffer->next = next;    

    if(x - single->width > (int) winWidth)
    {    
      KPrintF("CstScaleSprite: Sprite not on screen nothing to do");
      return;
    }
    extrawords = 0; //Shifted out part of source outside screen. No need to blit this
    cutwordssource = (x+single->width - winWidth)/16;
    cutmaskpixel = 0;
    bltalwm = 0xffff; //Last word contains source data to be blit
    bltapt = ((ULONG) single->data)+(single->width/8)*single->height*5+ystartsrc*single->width/8;
    bltbpt = (ULONG) single->data+ystartsrc*single->width/8;
    bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltdpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltcon0 = 0xfca + ((single->width%16) << 12);
    bltcon1 = ((single->width%16) << 12);
    if( destinationtype == SCREEN)
    {
      CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource; //Width in X Bytes
      CstCleanupQueueDrawBuffer->height =  blitheight; //Height
      CstCleanupQueueDrawBuffer->startxinbytes =  (x/16)*2; //X Start in Bytes;
      CstCleanupQueueDrawBuffer->starty = ystartdst;
    } else {
      *CstBackDropBufferApplyCursor++ = single->width/16+cutwordssource;
      *CstBackDropBufferApplyCursor++ = blitheight;
      *CstBackDropBufferApplyCursor++ = (x/16)*2;
      *CstBackDropBufferApplyCursor++ = ystartdst;
      *CstBackDropBufferApplyCursor++ = 0;
    }
  } else { //Whole Sprite on Screen
    struct CleanupQueue *next = CstCleanupQueueDrawBuffer;
    CstCleanupQueueDrawBuffer = AllocVec( sizeof(struct CleanupQueue),MEMF_ANY);
    CstCleanupQueueDrawBuffer->next = next;    

    extrawords = 1;
    cutwordssource = 0;
    cutmaskpixel = 0;
    bltalwm = 0; //Last Word of this channel almost masked out
    bltapt = ((ULONG) single->data)+(single->width/8)*single->height*5+ystartsrc*single->width/8;
    bltbpt = (ULONG) single->data+ystartsrc*single->width/8;
    bltcpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltdpt = ((ULONG) destination) + ystartdst*winWidth/8 + (x/16)*2;
    bltcon0 = 0xfca + ((x%16) << 12);
    bltcon1 = ((x%16) << 12);
    if( destinationtype == SCREEN)
    {
      CstCleanupQueueDrawBuffer->widthinwords = single->width/16+cutwordssource+extrawords; 
      CstCleanupQueueDrawBuffer->height =  blitheight; 
      CstCleanupQueueDrawBuffer->startxinbytes =  (x/16)*2; 
      CstCleanupQueueDrawBuffer->starty = ystartdst;
    } else
    {
      *CstBackDropBufferApplyCursor++ = single->width/16+cutwordssource+extrawords;
      *CstBackDropBufferApplyCursor++ = blitheight;
      *CstBackDropBufferApplyCursor++ = (x/16)*2;
      *CstBackDropBufferApplyCursor++ = ystartdst;
      *CstBackDropBufferApplyCursor++ = 0;
    }
  }

  UWORD bltafwm = 0xffff >> cutmaskpixel;
  WORD bltamod = cutwordssource*2-(extrawords*2); //Jump to next line
  WORD bltbmod = cutwordssource*2-(extrawords*2); //Jump to next line
  WORD bltcmod = winWidth/8-single->width/8-extrawords*2+cutwordssource*2;
  WORD bltdmod = winWidth/8-single->width/8-extrawords*2+cutwordssource*2;

  volatile struct Custom *custom = (struct Custom*)0xdff000;
  WaitBlit();

  custom->bltafwm = bltafwm;
  custom->bltalwm = bltalwm;
  custom->bltamod = bltamod;
  custom->bltbmod = bltbmod;
  custom->bltcmod = bltcmod;
  custom->bltdmod = bltdmod;
  custom->bltcon0 = bltcon0;
  custom->bltcon1 = bltcon1;  

  UWORD bltbptplus = (single->width >> 3)*single->height;
  UWORD bltcptplus = winWidth/8*winHeight;
  for(int i=0;i<5;i++) //ToDo other numbers of Bitplanes
  {
    custom->bltapt = (APTR) bltapt;
    custom->bltbpt = (APTR) bltbpt;
    custom->bltcpt = (APTR) bltcpt;
    custom->bltdpt = (APTR) bltdpt;
    custom->bltsize = (blitheight << 6) + single->width/16-cutwordssource+extrawords;
    bltbpt += bltbptplus;
    bltcpt += bltcptplus;
    bltdpt += bltcptplus;
    WaitBlit();
  }   
}

void CstSetCl(UWORD *copperlist)
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  custom->cop1lc = (ULONG) copperlist;
}

void CstSwapBuffer( ) {
  ULONG *tmp;
  tmp = CstViewBuffer;
  CstViewBuffer = CstDrawBuffer;
  CstDrawBuffer = tmp;

  struct CleanupQueue *tmp2 = CstCleanupQueueViewBuffer;
  CstCleanupQueueViewBuffer = CstCleanupQueueDrawBuffer;
  CstCleanupQueueDrawBuffer = tmp2;


  UWORD *copword = CstCopperList;
  ULONG ptr = (ULONG) CstViewBuffer;
  UWORD highword = ptr >> 16;
  UWORD lowword = ptr & 0xffff;  

  copword[CSTBPL1LOW] = lowword;
  copword[CSTBPL1HIGH] = highword;

  ptr +=  40*256;
  highword = ptr >> 16;
  lowword = ptr & 0xffff;  

  copword[CSTBPL2LOW] = lowword;
  copword[CSTBPL2HIGH] = highword;
  
  ptr +=  40*256;
  highword = ptr >> 16;
  lowword = ptr & 0xffff;  
  
  copword[CSTBPL3LOW] = lowword;
  copword[CSTBPL3HIGH] = highword;

  ptr +=  40*256;
  highword = ptr >> 16;
  lowword = ptr & 0xffff;  

  copword[CSTBPL4LOW] = lowword;
  copword[CSTBPL4HIGH] = highword;

  ptr +=  40*256;
  highword = ptr >> 16;
  lowword = ptr & 0xffff;  

  copword[CSTBPL5LOW] = lowword;
  copword[CSTBPL5HIGH] = highword;

}

BOOL CstReserveBackdrop(int width, int height) {

 	KPrintF("CstReserveBackdrop: Begin");

  width = width / 8;

  if( width < 40) 
  {
    KPrintF("CstReserveBackdrop: Screens smaller than 320px not supported.");
    return FALSE;
  }  
  KPrintF("CstReserveBackdrop: Screen Okay");

  CstCopperList = CstCreateCopperlist( width);
  KPrintF("CstReserveBackdrop: Copperlist created");
  CstBackdropSizePlane = width*height;
  CstBackdropSize = CstBackdropSizePlane * 5; //Todo: Support other Bitplane Modes;  
  

  CstBackDrop = AllocVec(CstBackdropSize,MEMF_CHIP);
  if( !CstBackDrop)
  {    
    KPrintF("CstReserveBackdrop: Cannot allocate memory for Backdrop");
    return FALSE;  
  }
  KPrintF("CstReserveBackdrop: Backdrop reserved");

  //Initialize Buffer
  ULONG *cursor = (ULONG *)CstBackDrop;
  for(int i=0;i<CstBackdropSize/4;i++)
  {
    *cursor++ = 0;
  }  
  
  CstDrawBuffer = AllocVec(CstBackdropSize+width*2,MEMF_CHIP); //Some extra size for bob routine border area
  if( !CstDrawBuffer)
  {    
    KPrintF("CstReserveBackdrop: Cannot allocate memory for DrawBuffer");
    return FALSE;  
  }
  KPrintF("CstReserveBackdrop: DrawBuffer reserved");
    
  CstBackDropBufferApplyStart = AllocVec( 100*3*2,MEMF_ANY);
  if( !CstBackDropBufferApplyStart)
  {    
    KPrintF("CstReserveBackdrop: Cannot allocate memory for CstBackDropBufferApplyStart");
    return FALSE;  
  }
  CstBackDropBufferApplyCursor = CstBackDropBufferApplyStart;
  *CstBackDropBufferApplyStart = 0;

  *CstBackDropBufferApplyStart = 0;
  CstViewBuffer = AllocVec(CstBackdropSize+width*2,MEMF_CHIP); //Some extra size for bob routine border area
  if( !CstViewBuffer)
  {    
    KPrintF("CstReserveBackdrop: Cannot allocate memory for ViewBuffer");
    return FALSE;  
  }
  KPrintF("CstReserveBackdrop: ViewBuffer reserved");
  
  CstDrawBuffer += width/4; //divide with 4 because pointer is ulong 
  CstViewBuffer += width/4; //divide with 4 because pointer is ulong
  

#ifdef EMULATOR
 	debug_register_bitmap(CstBackDrop, "CstBackDrop.bpl", 320, 256, 5, 0);
  debug_register_bitmap(CstDrawBuffer, "drawbuffer.bpl", width*8, height, 5, 0);
  debug_register_bitmap(CstViewBuffer, "viewbuffer.bpl", width*8, height, 5, 0);
#endif

  

  if( !CstCopperList || ! CstDrawBuffer || !CstViewBuffer)
  {
    KPrintF("CstReserveBackdrop: Memory allocation failed");
    return FALSE;
  }

  CstSetCl( CstCopperList);
  return TRUE;

}

void CstFreeBuffer( ) {
  if( CstDrawBuffer) FreeVec(CstDrawBuffer);
  if( CstViewBuffer) FreeVec(CstViewBuffer);
  if( CstCopperList) FreeVec(CstCopperList);  
  if( CstBackDrop) FreeVec(CstBackDrop);  
  CstDrawBuffer = NULL;
  CstViewBuffer = NULL;
  CstCopperList = NULL;
  CstBackDrop = NULL;

}


