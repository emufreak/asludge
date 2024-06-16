#include <proto/exec.h>
#include <proto/dos.h>

#include "language.h"
#include "moreio.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"
#include "version.h"

int *languageTable;
char **languageName;
struct settingsStruct gameSettings;

int getLanguageForFileB ()
{
	int indexNum = -1;

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
		if ((unsigned int) languageTable[i] == gameSettings.languageID) indexNum = i;
	}

	return indexNum;
}

char * getPrefsFilename (char * filename) {
	// Yes, this trashes the original string, but
	// we also free it at the end (warning!)...

	int n, i;

	n = strlen (filename);


	if (n > 4 && filename[n-4] == '.') {
		filename[n-4] = 0;
	}

	char * f = filename;
	for (i = 0; i<n; i++) {
		if (filename[i] == '/') f = filename + i + 1;
	}

	char * joined = joinStrings (f, ".ini");

	FreeVec(filename);
	filename = NULL;
	return joined;
}

void makeLanguageTable (BPTR table)
{
	languageTable = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
    if( languageTable == 0) {
        KPrintF("makeLanguageTable: Cannot Alloc Mem for languageTable");
    }

	languageName = AllocVec(gameSettings.numLanguages + 1,MEMF_ANY);
	if( languageName == 0) {
        KPrintF("makeLanguageName: Cannot Alloc Mem for languageName");
    }

	for (unsigned int i = 0; i <= gameSettings.numLanguages; i ++) {
		languageTable[i] = i ? get2bytes (table) : 0;
		languageName[i] = 0;
		if (gameVersion >= VERSION(2,0)) {
			if (gameSettings.numLanguages)
				languageName[i] = readString (table);
		}
	}
}

void readIniFile (char * filename) {
	char * langName = getPrefsFilename (copyString (filename));

	BPTR fp = Open(langName,MODE_OLDFILE);	

	gameSettings.languageID = 0;
	gameSettings.userFullScreen = TRUE; //Always fullscreen on AMIGA
	gameSettings.refreshRate = 0;
	gameSettings.antiAlias = 1;
	gameSettings.fixedPixels = FALSE;
	gameSettings.noStartWindow = FALSE;
	gameSettings.debugMode = FALSE;

	FreeVec(langName);
	langName = NULL;

	if (fp) {
		char lineSoFar[257] = "";
		char secondSoFar[257] = "";
		unsigned char here = 0;
		char readChar = ' ';
		BOOL keepGoing = TRUE;
		BOOL doingSecond = FALSE;
		LONG tmp = 0;

		do {

			tmp = FGetC (fp);
			if (tmp == - 1) {
				readChar = '\n';
				keepGoing = FALSE;
			} else {
				readChar = (char) tmp;
			}

			switch (readChar) {
				case '\n':
				case '\r':
				if (doingSecond) {
					if (strcmp (lineSoFar, "LANGUAGE") == 0)
					{
						gameSettings.languageID = stringToInt (secondSoFar);
					}
					else if (strcmp (lineSoFar, "WINDOW") == 0)
					{
						gameSettings.userFullScreen = ! stringToInt (secondSoFar);
					}
					else if (strcmp (lineSoFar, "REFRESH") == 0)
					{
						gameSettings.refreshRate = stringToInt (secondSoFar);
					}
					else if (strcmp (lineSoFar, "ANTIALIAS") == 0)
					{
						gameSettings.antiAlias = stringToInt (secondSoFar);
					}
					else if (strcmp (lineSoFar, "FIXEDPIXELS") == 0)
					{
						gameSettings.fixedPixels = stringToInt (secondSoFar);
					}
					else if (strcmp (lineSoFar, "NOSTARTWINDOW") == 0)
					{
						gameSettings.noStartWindow = stringToInt (secondSoFar);
					}
					else if (strcmp (lineSoFar, "DEBUGMODE") == 0)
					{
						gameSettings.debugMode = stringToInt (secondSoFar);
					}
				}
				here = 0;
				doingSecond = FALSE;
				lineSoFar[0] = 0;
				secondSoFar[0] = 0;
				break;

				case '=':
				doingSecond = TRUE;
				here = 0;
				break;

				default:
				if (doingSecond) {
					secondSoFar[here ++] = readChar;
					secondSoFar[here] = 0;
				} else {
					lineSoFar[here ++] = readChar;
					lineSoFar[here] = 0;
				}
				break;
			}
		} while (keepGoing);

		Close(fp);
	}
}

unsigned int stringToInt (char * s) {
	int i = 0;
	BOOL negative = FALSE;
	for (;;) {
		if (*s >= '0' && *s <= '9') {
			i *= 10;
			i += *s - '0';
			s ++;
		} else if (*s == '-') {
			negative = ! negative;
			s++;
		} else {
			if (negative)
				return -i;
			return i;
		}
	}
}