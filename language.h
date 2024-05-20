#include <proto/exec.h>

#ifndef __LANGUAGE_H__
#define __LANGUAGE_H__

struct settingsStruct
{
	unsigned int languageID;
	unsigned int numLanguages;
	BOOL userFullScreen;
	unsigned int refreshRate;
	int antiAlias;
	BOOL fixedPixels;
	BOOL noStartWindow;
	BOOL debugMode;
};

int getLanguageForFileB ();
unsigned int stringToInt (char * s);
extern struct settingsStruct gameSettings;
void makeLanguageTable (BPTR table);
void readIniFile (char * filename);


#endif