
#include "sound_bass.h"

#define MAX_SAMPLES 8

BOOL soundOK = FALSE;

int defVol = 128;
int defSoundVol = 255;

struct soundThing {
	//HSAMPLE sample; Amiga ToDo. Replace?	
	int fileLoaded, vol;
	int mostRecentChannel;
	BOOL looping;
};

struct soundThing soundCache[MAX_SAMPLES];

void saveSounds (BPTR fp) {
	if (soundOK) {
		for (int i = 0; i < MAX_SAMPLES; i ++) {
			if (soundCache[i].looping) {
				fputc (1, fp);
				put2bytes (soundCache[i].fileLoaded, fp);
				put2bytes (soundCache[i].vol, fp);
			}
		}
	}
	FPutC (fp, 0);
	put2bytes (defSoundVol, fp);
	put2bytes (defVol, fp);
}