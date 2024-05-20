#include <proto/exec.h>
#include <proto/dos.h>

#include "sludger.h"
#include "errors.h"
#include "fileset.h"
#include "graphics.h"
#include "language.h"
#include "moreio.h"
#include "people.h"
#include "statusba.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"
#include "variable.h"
#include "version.h"


int gameVersion;
int specialSettings;
extern struct personaAnimation * mouseCursorAnim;
extern int desiredfps;

int numBIFNames = 0;
char * * allBIFNames = NULL;
int numUserFunc = 0;
char * * allUserFunc = NULL;
int numResourceNames = 0;
char * * allResourceNames = NULL;
int languageNum = -1;

FILETIME fileTime;

struct variable * globalVars;
int numGlobals;

BOOL initSludge (char * filename) {
	int a = 0;
	mouseCursorAnim = makeNullAnim ();

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, &gameVersion);
	if (! fp) return FALSE;
	if (FGetC (fp)) {
		numBIFNames = get2bytes (fp);
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
		if(allBIFNames == 0) return FALSE;
		for (int fn = 0; fn < numBIFNames; fn ++) {
			allBIFNames[fn] = (char *) readString (fp);
		}
		numUserFunc = get2bytes (fp);
		allUserFunc = AllocVec(numUserFunc,MEMF_ANY);
		if( allUserFunc == 0) return FALSE;

		for (int fn = 0; fn < numUserFunc; fn ++) {
			allUserFunc[fn] =   (char *) readString (fp);
		}
		if (gameVersion >= VERSION(1,3)) {
			numResourceNames = get2bytes (fp);
			allResourceNames = AllocVec(numResourceNames,MEMF_ANY);
			if(allResourceNames == 0) return FALSE;

			for (int fn = 0; fn < numResourceNames; fn ++) {
				allResourceNames[fn] =  (char *) readString (fp);
			}
		}
	}
	winWidth = get2bytes (fp);
	winHeight = get2bytes (fp);
	specialSettings = FGetC (fp);

	desiredfps = 1000/FGetC (fp);

	FreeVec(readString (fp));

	ULONG blocks_read = FRead( fp, &fileTime, sizeof (FILETIME), 1 ); 
	if (blocks_read != 1) {
		KPrintF("Reading error in initSludge.\n");
	}

	char * dataFol = (gameVersion >= VERSION(1,3)) ? readString(fp) : joinStrings ("", "");

	gameSettings.numLanguages = (gameVersion >= VERSION(1,3)) ? (FGetC (fp)) : 0;
	makeLanguageTable (fp);

	if (gameVersion >= VERSION(1,6))
	{
		FGetC(fp);
		// aaLoad
		FGetC (fp);
		getFloat (fp);
		getFloat (fp);
	}

	char * checker = readString (fp);

	if (strcmp (checker, "okSoFar")) {
		return FALSE;
	}
	FreeVec( checker);
	checker = NULL;

    unsigned char customIconLogo = FGetC (fp);

	if (customIconLogo & 1) {
		// There is an icon - read it!
		Write(Output(), (APTR)"initsludge:Game Icon not supported on this plattform.\n", 54);
		KPrintF("initsludge: Game Icon not supported on this plattform.\n");
		return FALSE;
	}

	numGlobals = get2bytes (fp);

	globalVars = AllocVec( sizeof(struct variable) * numGlobals,MEMF_ANY);
	if(globalVars == 0) {
		KPrintF("initsludge: Cannot allocate memory for globalvars\n");
		return FALSE;
	}		 
	for (a = 0; a < numGlobals; a ++) initVarNew (globalVars[a]);

	setFileIndices (fp, gameSettings.numLanguages, 0);

	char * gameNameOrig = getNumberedString(1);	
	char * gameName = encodeFilename (gameNameOrig);

	FreeVec(gameNameOrig);

	BPTR lock = CreateDir( gameName );
	if(lock == 0) {
		//Directory does already exist
		lock = Lock(gameName, ACCESS_READ);
	}

	if (!CurrentDir(lock)) {
		KPrintF("initsludge: Failed changing to directory %s\n", gameName);
		Write(Output(), (APTR)"initsludge:Failed changing to directory\n", 40);
		return FALSE;
	}

	FreeVec(gameName);

	readIniFile (filename);

	// Now set file indices properly to the chosen language.
	languageNum = getLanguageForFileB ();
	if (languageNum < 0) KPrintF("Can't find the translation data specified!");
	setFileIndices (NULL, gameSettings.numLanguages, languageNum);

	if (dataFol[0]) {
		char *dataFolder = encodeFilename(dataFol);
		lock = CreateDir( dataFolder );
		if(lock == 0) {
			//Directory does already exist
			lock = Lock(dataFolder, ACCESS_READ);		
		}


		if (!CurrentDir(lock)) {
			(Output(), (APTR)"initsludge:This game's data folder is inaccessible!\n", 52);
		}
		FreeVec(dataFolder);
	}

 	positionStatus (10, winHeight - 15);

	return TRUE;
}

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion) {
	BPTR fp = Open(filename,MODE_OLDFILE);

	if (! fp) {
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
		KPrintF("openAndVerify: Can't open file", filename);
		return NULL;
	}
	BOOL headerBad = FALSE;
	if (FGetC (fp) != 'S') headerBad = TRUE;
	if (FGetC (fp) != 'L') headerBad = TRUE;
	if (FGetC (fp) != 'U') headerBad = TRUE;
	if (FGetC (fp) != 'D') headerBad = TRUE;
	if (FGetC (fp) != extra1) headerBad = TRUE;
	if (FGetC (fp) != extra2) headerBad = TRUE;
	if (headerBad) {
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
		KPrintF("openAndVerify: Bad Header\n");
		return NULL;
	}
	FGetC (fp);
	while (FGetC(fp)) {;}

	int majVersion = FGetC (fp);
	int minVersion = FGetC (fp);
	*fileVersion = majVersion * 256 + minVersion;

	char txtVer[120];

	if (*fileVersion > WHOLE_VERSION) {
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
		KPrintF(ERROR_VERSION_TOO_LOW_1);
		return NULL;
	} else if (*fileVersion < MINIM_VERSION) {
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
		return NULL;
	}
	return fp;
}