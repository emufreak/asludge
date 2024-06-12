#include <proto/dos.h>

struct soundList {
	int sound;
	struct soundList * next;
	struct soundList * prev;
	int cacheIndex;
	int vol;
};

void loadSounds (BPTR fp);
BOOL playMOD (int f, int a, int fromTrack);
void saveSounds (BPTR fp);
void setMusicVolume (int a, int v);
void setSoundVolume (int a, int v);
BOOL startSound (int f, BOOL loopy);
void stopMOD (int i);