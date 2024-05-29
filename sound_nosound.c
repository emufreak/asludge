
#include "sound_nosound.h"
#include "moreio.h"

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

void loadSounds (BPTR fp) {
	while (FGetC (fp)) {
		get2bytes (fp);
		get2bytes (fp);
	}
	
	defSoundVol = get2bytes (fp);
	defVol = get2bytes (fp);
}

void saveSounds (BPTR fp) {
	FPutC (fp,0);
	put2bytes (defSoundVol, fp);
	put2bytes (defVol, fp);
}