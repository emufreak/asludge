
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

BOOL playMOD (int f, int a, int fromTrack) {
//#pragma unused (f,a,fromTrack)
    return TRUE;
}

void saveSounds (BPTR fp) {
	FPutC (fp,0);
	put2bytes (defSoundVol, fp);
	put2bytes (defVol, fp);
}

void setMusicVolume (int a, int v) {
//#pragma unused (a,v)
}

void setSoundVolume (int a, int v) {
//#pragma unused (a,v)
}

BOOL startSound (int f, BOOL loopy) {	
//#pragma unused (f,loopy)
	return TRUE;
}

void stopMOD (int i) {
//#pragma unused(i)
}