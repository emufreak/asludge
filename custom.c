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
//#define EMULATOR

#include <exec/types.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <hardware/custom.h>

#include "custom.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"

extern unsigned int winWidth, winHeight;

UWORD CstBackdropSize;
UWORD CstBackdropSizePlane;
UWORD *CstBackDrop;
UWORD *CstCopperList;
BOOL CstApplyBackDropCounter = 0; //Backdrop needs to be loaded twice. Once for every buffer in separate frames.
ULONG *CstViewBuffer;
ULONG *CstDrawBuffer;
UWORD *CstClColor;
UWORD *CstPalette;

ULONG CstClSprites[] = { 0x001200000, 0x001220000,0x001240000,0x001260000, 0x001280000, 
        0x0012a0000, 0x0012c0000, 0x0012e0000, 0x001300000, 0x001320000, 0x001340000,
                 0x001360000, 0x001380000, 0x0013a0000, 0x0013c0000, 0x0013e0000  };

ULONG CstClScreen[] = { 0x001fc0000, 0x001060000, 0x0009683f0, 
        0x0008e2c81, 0x000902cc1,0x000920038, 0x0009400d0, 
        0x001020000, 0x001040000, 0x001080000, 0x0010a0000, 0x001005200 };

ULONG CstClBitplanes[] = { 0x0e00000, 0x0e20000, 0x0e40000, 0x0e60000,
    0x0e80000, 0x0ea0000, 0x0ec0000, 0x0ee0000,
    0x0f00000, 0x0f20000 };

ULONG CstClColorTemplate[] = { 
    0x1800000, 0x1820fff, 0x1840000, 0x1860000, 0x1880000, 0x18a0000, 0x18c0000, 0x18e0000,
    0x1900000, 0x1920000, 0x1940000, 0x1960000, 0x1980000, 0x19a0000, 0x19c0000, 0x19e0000,
    0x1a00000, 0x1a20000, 0x1a40000, 0x1a60000, 0x1a80000, 0x1aa0000, 0x1ac0000, 0x1ae0000,
    0x1b00000, 0x1b20000, 0x1b40000, 0x1b60000, 0x1b80000, 0x1ba0000, 0x1bc0000, 0x1be0000 
};

void CstBlankScreen( int width, int height) {
  volatile struct Custom *custom = (struct Custom*)0xdff000;

  width /= 16;

  WaitBlit();

  //Both Buffers need to be done
  for(int i=0;i<2;i++) {
    custom->bltafwm = 0xffff;
    custom->bltalwm = 0xffff;
    custom->bltamod = 0;
    custom->bltbmod = 0;
    custom->bltcmod = 0;
    custom->bltdmod = 0;
    custom->bltcon1 = 0;
    custom->bltcon0 = 0x0100;
    ULONG bltdpt = (ULONG) CstDrawBuffer;
    UWORD bltsize = height*64+width;    
    UWORD blitsize = width*height*2;
    for(int i2=0;i2<5;i2++)
    {            
      custom->bltdpt = (APTR) bltdpt;
      custom->bltsize = bltsize;            
      WaitBlit();
      bltdpt += blitsize;
    }

    WaitBlit();
    WaitVbl();
    CstSwapBuffer();
  }

}

UWORD * CstCreateCopperlist( int width) {
  
  ULONG *retval = AllocMem(  CSTCOPSIZE, MEMF_CHIP);
  
  if( retval == 0) {
    KPrintF("CstCreateCopperlist: Allocation of Ram for Copper failed.\n", 40);
    Exit(1);
  }
  ULONG *cl = retval;

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
  ULONG *bplcursorsrc = (ULONG *) CstBackDrop;
  ULONG *bplcursordst = (ULONG *) CstDrawBuffer;
  for(int i=0;i<CstBackdropSize/4;i++)
  {
    *bplcursordst++ = *bplcursorsrc++;
  }

  UWORD *tmp = CstClColor;
  UWORD reg = 0x180;
  UWORD *colorpos = CstPalette;

  for(int i=0;i<32;i++) { //ToDo Support other number of bitplanes
    *tmp++ = reg;
    reg +=2;
    *tmp++ = *colorpos++;
  }
}

void CstLoadBackdrop( BPTR fp, int x, int y) {
	KPrintF("CstLoadBackDrop: Loading of Background started");

  UWORD width = get2bytes(fp);
  UWORD height = get2bytes(fp);  

  UWORD widthbytes = width/8;
  UWORD widthwords = widthbytes/2;  
  UWORD sizeplane =  widthbytes*height;
  UWORD size = sizeplane * 5; //Todo other number of bitplanes

  //Load Palette to Copper
  UWORD reg = 0x180;
  CstPalette = AllocVec(32*2,MEMF_ANY); //ToDo other number of bitplanes
  UWORD *tmp = CstPalette;
  for(int i=0;i<32;i++) { //ToDo Support other number of bitplanes   
    *tmp++ = get2bytes(fp);
  }

  UWORD *tmpbuffer = AllocVec(size, MEMF_CHIP); //Todo other number of bitplanes

  //UWORD *tmpbuffercursor = tmpbuffer;
  UWORD count = FRead( fp, tmpbuffer, 2, size/2);
  
  if(!count) {
    KPrintF("Error while reading stream");
    return;
  }  

  UWORD *tmpmask = AllocVec(sizeplane, MEMF_CHIP);

#ifdef EMULATOR
  debug_register_bitmap(tmpbuffer, "tmpbuffer.bpl", width, height, 5, 0);
  debug_register_bitmap(tmpbuffer, "tmpmask.bpl", width, height, 1, 0);
#endif     

  count = FRead( fp, tmpmask, 2, sizeplane/2);

  if(!count) {
    KPrintF("Error while reading stream");
    return;
  }

  volatile struct Custom *custom = (struct Custom*)0xdff000;

  ULONG backdropcursor = (ULONG) CstBackDrop; 
  UWORD offset = widthwords*y + x / 16;
  backdropcursor += offset; 

 	KPrintF("CstLoadBackDrop: Starting Blit");


  WaitBlit();

  custom->bltafwm = 0xffff;
  custom->bltalwm = 0xffff;
  custom->bltamod = 0;
  custom->bltbmod = 0;
  custom->bltcmod = winWidth / 8 - widthbytes;
  custom->bltdmod = winWidth / 8 - widthbytes;
  custom->bltcon0 = 0xfca;
  custom->bltcon1 = 0;
  
  ULONG tmpbuffercursor = (ULONG) tmpbuffer;
  for(int i=0;i<5;i++) //Todo other number of bitplanes
  {
    
    custom->bltapt = tmpmask;
    custom->bltbpt = tmpbuffercursor;
    custom->bltcpt = backdropcursor;
    custom->bltdpt = backdropcursor;
    custom->bltsize = (height<<6)+widthwords;
    tmpbuffercursor += sizeplane;
    backdropcursor += CstBackdropSizePlane;
  }    

  WaitBlit();

 	KPrintF("CstLoadBackDrop: Freeing Memory");


  FreeVec(tmpbuffer);
  FreeVec(tmpmask);

  CstApplyBackDropCounter = 2;

  KPrintF("CstLoadBackDrop: Finished");

}

void CstSetCl(UWORD *copperlist)
{
  volatile struct Custom *custom = (struct Custom*)0xdff000;
  custom->cop1lc = (ULONG) copperlist;
}

void CstSludgeDisplay() {  
  if(CstApplyBackDropCounter > 0) 
  {
    CstDisplayBackDrop();
    CstApplyBackDropCounter--;
  }
  CstSwapBuffer();
  
}

void CstSwapBuffer( ) {
  ULONG *tmp;
  tmp = CstViewBuffer;
  CstViewBuffer = CstDrawBuffer;
  CstDrawBuffer = tmp;

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

  width = width / 8;

  if( width < 40) 
  {
    KPrintF("CstReserveBackdrop: Screens smaller than 320px not supported.");
    return FALSE;
  }  

  CstCopperList = CstCreateCopperlist( width);
  CstBackdropSizePlane = width*height;
  CstBackdropSize = CstBackdropSizePlane * 5; //Todo: Support other Bitplane Modes;

  CstBackDrop = AllocVec(CstBackdropSize,MEMF_CHIP);
  if( !CstBackDrop)
  {    
    KPrintF("CstReserveBackdrop: Cannot allocate memory for Backdrop");
    return FALSE;  
  }

  //Initialize Buffer
  ULONG *cursor = (ULONG *)CstBackDrop;
  for(int i=0;i<CstBackdropSize/4;i++)
  {
    *cursor++ = 0;
  }  
  
  CstDrawBuffer = AllocVec(CstBackdropSize,MEMF_CHIP);
  CstViewBuffer = AllocVec(CstBackdropSize,MEMF_CHIP);

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
}


