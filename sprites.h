#include <proto/dos.h>

struct sprite {
	int width, height, xhot, yhot;
	int tex_x;
	int texNum;
	//unsigned char * data;
};

struct spriteBank {
	int total;
	int type;
	struct sprite * sprites;
	BOOL isFont;
};

BOOL loadSpriteBank (int fileNum, struct spriteBank *loadhere, BOOL isFont);