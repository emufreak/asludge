#ifndef __SLUDGE_GRAPHICS_H__
#define __SLUDGE_GRAPHICS_H__

#include <exec/types.h>

struct textureList {
	unsigned int name;
	unsigned int width;
	unsigned int height; 
	struct textureList * next;
};

extern BOOL NPOT_textures;
extern unsigned int winWidth, winHeight;
void deleteTextures(unsigned int n,  unsigned int * textures);
void setGraphicsWindow(BOOL fullscreen);

#endif

