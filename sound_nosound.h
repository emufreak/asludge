#include <proto/dos.h>

struct soundList {
	int sound;
	struct soundList * next;
	struct soundList * prev;
	int cacheIndex;
	int vol;
};

int cacheSound (int f);
void huntKillFreeSound (int filenum);
void huntKillSound (int filenum);
void loadSounds (BPTR fp);
BOOL playMOD (int f, int a, int fromTrack);
void playSoundList(struct soundList *s);
void saveSounds (BPTR fp);
void setDefaultMusicVolume (int v);
void setDefaultSoundVolume (int v);
void setMusicVolume (int a, int v);
void setSoundLoop (int a, int s, int e);
void setSoundVolume (int a, int v);
BOOL startSound (int f, BOOL loopy);
void stopMOD (int i);