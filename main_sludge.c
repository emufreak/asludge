#include <proto/dos.h>
#include <proto/exec.h>
#include "backdrop.h"
#include "fileset.h"
#include "floor.h"
#include "support/gcc8_c_support.h"
#include "main_sludge.h"
#include "objtypes.h"
#include "people.h"
#include "statusba.h"
#include "graphics.h"
#include "stringy.h"
#include "helpers.h"
#include "moreio.h"
#include "sludger.h"
#include "talk.h"
#include "variable.h"

#define PATHSLASH '/'
#define MAX_PATH        1024          // maximum size of a path name
int realWinWidth = 640, realWinHeight = 480;

extern float cameraZoom;

extern int specialSettings;

extern struct variableStack * noStack;

int dialogValue = 0;

char * gameName = NULL;
char * gamePath = NULL;
char *bundleFolder;
int weAreDoneSoQuit;

int main_sludge(int argc, char *argv[])
{	
	/* Dimensions of our window. */
	//AMIGA TODO: Maybe remove as there will be no windowed mode
    winWidth = 320;
    winHeight = 256;

	char * sludgeFile;

	if(argc == 0) {
		bundleFolder = copyString("game/");
	} else {
		bundleFolder = copyString(argv[0]);
	}
    
	int lastSlash = -1;
	for (int i = 0; bundleFolder[i]; i ++) {
		if (bundleFolder[i] == PATHSLASH) lastSlash = i;
	}
	bundleFolder[lastSlash+1] = NULL;

	if (argc > 1) {
		sludgeFile = argv[argc - 1];
	} else {
		sludgeFile = joinStrings (bundleFolder, "gamedata.slg");
		if (! ( fileExists (sludgeFile) ) ) {
			FreeVec(sludgeFile);
			sludgeFile = joinStrings (bundleFolder, "gamedata");			
		}
	}

	//AMIGA TODO: Show arguments
	/*if (! parseCmdlineParameters(argc, argv) && !(sludgeFile) ) {
		printCmdlineUsage();
		return 0;
	}*/
	if (! fileExists(sludgeFile) ) {	
		Write(Output(), (APTR)"Game file not found.\n", 21);
		//AMIGA TODO: Show arguments
		//printCmdlineUsage();
		return 0;
	}

	setGameFilePath (sludgeFile);
	if (! initSludge (sludgeFile)) return 0;
	
	if (! resizeBackdrop (winWidth, winHeight)) {
		KPrintF("Couldn't allocate memory for backdrop");
		return FALSE;
	}

	if (! initPeople ())
	{
		KPrintF("Couldn't initialise people stuff");
		return FALSE;
	}

	if (! initFloor ())
	{
		KPrintF("Couldn't initialise floor stuff");
		return FALSE;
	}

	if (! initObjectTypes ())
	{
		KPrintF("Couldn't initialise object type stuff");
		return FALSE;
	}

	initSpeech ();
	initStatusBar ();

	gameName = getNumberedString(1);
	//initSoundStuff (hMainWindow); Todo Amiga: Maybe move soundstuff here
	startNewFunctionNum (0, 0, NULL, noStack, TRUE);

	weAreDoneSoQuit = 0;
	while ( !weAreDoneSoQuit ) {
		handleInput();
	}
	//Amiga Cleanup
	FreeVec(sludgeFile);
}

void setGameFilePath (char * f) {
	char currentDir[1000];

	if (!GetCurrentDirName( currentDir, 998)) {
		KPrintF("setGameFilePath: Can't get current directory.\n");
	}	

	int got = -1, a;	

	for (a = 0; f[a]; a ++) {
		if (f[a] == PATHSLASH) got = a;
	}

	if (got != -1) {
		f[got] = 0;	
		BPTR lock = Lock(f, ACCESS_READ);	
		if (!CurrentDir(lock)) {
			KPrintF("setGameFilePath:: Failed changing to directory %s\n", f);
		}
		f[got] = PATHSLASH;
	}

	gamePath = AllocVec(400, MEMF_ANY);
	if (gamePath==0) {
		KPrintF("setGameFilePath: Can't reserve memory for game directory.\n");
		return;
	}

	BPTR lock = Lock(gamePath, ACCESS_READ);	
	if (! CurrentDir(lock)) {
		KPrintF("setGameFilePath: Can't get game directory.\n");
	}
	
	lock = Lock(currentDir, ACCESS_READ);	
	if (!CurrentDir(lock)) {	
		KPrintF("setGameFilePath: Failed changing to directory %s\n", currentDir);
	}

	//Free Mem
	if (gamePath != 0) FreeVec(gamePath);
}

void amiga_quit()
{
	if( bundleFolder != 0) FreeVec(bundleFolder);
}