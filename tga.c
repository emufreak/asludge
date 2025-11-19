#include <proto/exec.h>

#include "custom.h"
#include "tga.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"

void tgaHeaderRead(BPTR file, TGAHeader *header)
{
   // read header
   header->identsize= FGetC(file);    // number of ident bytes after header, usually 0
   header->cmaptype= FGetC(file);     // type of colour map 0=none, 1=has palette
   header->imagetype= FGetC(file);    // type of image 0=none,1=indexed,2=rgb,3=grey,+8=rle packed

   header->cmapstart= tgaReadWord(file);    // first colour map entry in palette
   header->cmaplength= tgaReadWord(file);   // number of colours in palette
   header->cmapformat= FGetC(file);   // number of bits per palette entry 15,16,24,32

   header->originx= tgaReadWord(file);      // image x origin
   header->originy= tgaReadWord(file);      // image y origin

   header->width= tgaReadWord(file);
   header->height= tgaReadWord(file);
   header->bpp= FGetC(file);
   header->bpc= FGetC(file);

   //read picture id but ignore
   for(int i=0;i<header->identsize;i++)
   {
    FGetC(file);
   }
}

int tgaLoad(BPTR file, unsigned int **buf, int *sizex, int *sizey)
{
   TGAHeader      info;
   int            i,j;
   unsigned int   pal[256];
   unsigned char* data;

   tgaHeaderRead(file, &info);

   // post some debug infos
   //printf("load tga: %s (%dx%dx%d) pal:%d\n", name, info.width, info.height, info.bpp, info.cmaplength);


   data=(unsigned char*)CstAllocVec((int)info.width*(int)info.height*4,MEMF_ANY);

   // get palette data
   if (info.imagetype==1) // indexed colors
   {
      // load palette
      if (info.cmaplength<=256)
      switch (info.cmapformat)
      {
         case 32: tgaLoadPal32(file, pal, info.cmaplength); break;
         default:
            KPrintF("tgaLoad: Cannot load Palette: Incompatible Palette format");
            break;
      }
   }
/*
   else
   if (info.imagetype==2) // rgb data
   {
      // there is no palette
   }
*/
   else
   if (info.imagetype==3) // grey-scale
   {
      // create grey palette, so we can handle greyscale just as 8bit data
      for (i=0;i<256;i++) pal[i]= (255<<24)+(i<<16)+(i<<8)+(i);
   }

   // load scanlines
   for (j=0;j<info.height;j++)
   {
      // tga is bottom up
      unsigned int *dst= (unsigned int *)data + (info.height-1-j) * info.width;

      switch(info.bpp)
      {
         case 8:  tgaLoadScanline8(file, dst, info.width, pal); break;
         default:
            KPrintF("tgaLoad: Cannot load Picture: Incompatible bitdepth");
            break;
      }
   }

   // finish up
   *buf= (unsigned int*)data;
   if (sizex)
      *sizex= info.width;
   if (sizey)
      *sizey= info.height;


   return 32;
}

int tgaLoad8(BPTR file, void **buffer, int *width, int *height, unsigned int *pal)
{
   TGAHeader      info;
   int            y;
   int            rle;
   unsigned char* data;

   //return 1;

	//printf(" tga load: %s\n", filename);

   tgaHeaderRead(file, &info);

   rle= info.imagetype >> 3 & 1;
   info.imagetype &= 7;

   if (info.imagetype!=1 && info.imagetype!=3) // indexed colors
      KPrintF("tgaLoad8: Nonindexed Pictures not supported");
      return 0;

   if (info.cmaplength>256)
      KPrintF("tgaLoad8: Maximum colors exceeded");
      return 0;

   // load palette
   if (info.imagetype==1)
   {
      tgaLoadPalette(file, pal, info.cmapformat, info.cmaplength);
   }
   else if (info.imagetype==3) // grey-scale
   {
      // create grey palette, so we can handle greyscale just as 8bit data
      if (pal)
      {
         unsigned int color= 0xff000000;
         unsigned int size= 256;
         do {
            *pal++= color;
            color+= 0x010101;
         } while (--size);
      }
   }

   // buffer=0: es wird nur die palette geladen
   if (buffer)
   {
      unsigned char *dst;
      int pitch;

      data= (unsigned char*)CstAllocVec((int)info.width*(int)info.height,MEMF_ANY);

      if (info.bpc & 0x20)  // top -> down
      {
         dst= data;
         pitch= info.width;
      }
      else
      {
         dst= data + (info.height-1) * info.width;
         pitch= -info.width;
      }

      if (rle)
      {
         int scan= 0;
         int count= 0;
         int col= 0;
         int len;
         unsigned char* scanline= dst;

         y= info.height;
         scan= info.width;
         while (y)
         {
            if (count==0)
            {
               count= FGetC(file) + 1;
               if (count>128) //run length packet yes or no
               {
                  // repeat single pixel color
                  count-=128;
                  col= FGetC(file);
               }
               else
               {
                  col= -1;
               }
            }

            len= count;
            if (len > scan) len= scan;

            if (col>=0)
               memset(dst, col, len);
            else
               FRead( file, dst, 1, len);

            dst+=len;
            count-=len;
            scan-=len;

            // next scanline?
            if (scan<=0)
            {
               scan= info.width;
               scanline += pitch;
               dst= scanline;
               y--;
            }
         }
      }
      else
      {
         // load scanlines
         for (y=info.height; y>0; y--)
         {
            // read uncompressed pixels
//            for (i=0; i<info.width; i++) dst[i]= streamReadByte(&stream);
            FRead(file, dst, 1, info.width);
            dst+=pitch;
         }
      }

      // finish up
      *buffer= data;
   }
   if (width) *width= info.width;
   if (height) *height= info.height;

   return 1;
}

void tgaLoadPal32(BPTR file, unsigned int *dst, int size)
{
   unsigned char temp[1024];
   FRead(file, temp, 4, size);

   if (dst)
   {
      unsigned char* src= temp;
      unsigned int r= 0;
      unsigned int g= 0;
      unsigned int b= 0;
      do
      {
         b= *src++ >> 4;
         g= *src++ >> 4;
         r= *src++ >> 4;
         *src++; //Skip Transparency
         *dst++= (b<<8)+(g<<4)+(r);
      } while (--size);
   }
}

void tgaLoadPalette(BPTR file, unsigned int *pal, int format, int size)
{
   switch (format)
   {
      case 32:
         tgaLoadPal32(file, pal, size);
         break;
      default:
         KPrintF("tgaLoadPalette: Only colors with palette BBGGRRTT supported");
         break;
   }
}



void tgaLoadScanline8(BPTR file, unsigned int *dst, int x, unsigned int *pal)
{
   int i;
   for (i=0;i<x;i++)
   {
      unsigned char index= FGetC(file);
      *dst++= pal[index];
   }
}

int tgaReadWord (BPTR fp) {
	int f1, f2;

	f1 = FGetC (fp);
	f2 = FGetC (fp);

	return (f1 + f2 * 256);
}