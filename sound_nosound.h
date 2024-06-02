#include <proto/dos.h>

struct soundList {
	int sound;
	struct soundList * next;
	struct soundList * prev;
	int cacheIndex;
	int vol;
};

void loadSounds (BPTR fp);
void saveSounds (BPTR fp);