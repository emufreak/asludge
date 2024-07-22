#include <proto/dos.h>
#include <exec/types.h>

typedef struct
{
   unsigned char  identsize;    // size of ID field that follows 18 byte header (0 usually)
   unsigned char  cmaptype;     // type of colour map 0=none, 1=has palette
   unsigned char  imagetype;    // type of image 0=none,1=indexed,2=rgb,3=grey,+8=rle packed

   short          cmapstart;    // first colour map entry in palette
   short          cmaplength;   // number of colours in palette
   unsigned char  cmapformat;   // number of bits per palette entry 15,16,24,32

   short          originx;      // image x origin
   short          originy;      // image y origin

   unsigned short width;
   unsigned short height;
   unsigned char  bpp;
   unsigned char  bpc;
} TGAHeader;

int tgaLoad(BPTR file, unsigned int **buf, int *sizex, int *sizey);
int tgaLoad8(BPTR file, void **buffer, int *width, int *height, unsigned int *pal);
void tgaLoadPal32(BPTR file, unsigned int *dst, int size);
void tgaLoadPalette(BPTR file, unsigned int *pal, int format, int size);
void tgaHeaderRead(BPTR file, TGAHeader *header);
void tgaLoadScanline8(BPTR file, unsigned int *dst, int x, unsigned int *pal);
int tgaReadWord (BPTR fp);