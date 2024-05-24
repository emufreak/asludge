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

struct eventHandlers mainHandlers;
struct eventHandlers * currentEvents = & mainHandlers;

struct inputType input;
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

struct variableStack * noStack = NULL;
struct variable * globalVars;
int numGlobals;
struct loadedFunction * allRunningFunctions = NULL;
char * loadNow = NULL;
BOOL captureAllKeys = FALSE;
unsigned char brightnessLevel = 255;
extern struct loadedFunction * saverFunc;

void abortFunction (struct loadedFunction * fun) {
	int a;

	pauseFunction (fun);
	while (fun -> stack) trimStack (fun -> stack);
	FreeVec( fun -> compiledLines);
	for (a = 0; a < fun -> numLocals; a ++) unlinkVar (fun -> localVars[a]);
	FreeVec(fun -> localVars);
	unlinkVar (fun -> reg);
	if (fun -> calledBy) abortFunction (fun -> calledBy);
	FreeVec(fun);
	fun = NULL;
}

void finishFunction (struct loadedFunction * fun) {
	int a;

	pauseFunction (fun);
	if (fun -> stack) KPrintF("finishfunction:", ERROR_NON_EMPTY_STACK);
	FreeVec( fun -> compiledLines);
	for (a = 0; a < fun -> numLocals; a ++) unlinkVar (fun -> localVars[a]);
	FreeVec(fun -> localVars);
	unlinkVar (fun -> reg);
	FreeVec(fun):
	fun = NULL;
}

BOOL handleInput () {
	//Amiga Todo: Actually handle input
	return runSludge ();
}

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

BOOL loadFunctionCode (struct loadedFunction * newFunc) {
	unsigned int numLines, numLinesRead;
	int a;

	if (! openSubSlice (newFunc -> originalNumber)) return FALSE;
	

	newFunc-> unfreezable	= FGetC (bigDataFile);
	numLines				= get2bytes (bigDataFile);
	newFunc -> numArgs		= get2bytes (bigDataFile);
	newFunc -> numLocals	= get2bytes (bigDataFile);
	newFunc -> compiledLines = AllocVec( sizeof(struct lineOfCode) * numLines,MEMF_ANY);
	if (! newFunc -> compiledLines) {
		KPrintF("loadFunctionCode: cannot allocate memory");
		return FALSE;
	}

	for (numLinesRead = 0; numLinesRead < numLines; numLinesRead ++) {
		newFunc -> compiledLines[numLinesRead].theCommand = (enum sludgeCommand) FGetC(bigDataFile);
		newFunc -> compiledLines[numLinesRead].param = get2bytes (bigDataFile);
	}

	finishAccess ();

	// Now we need to reserve memory for the local variables
	if(newFunc->numLocals > 1) {
		newFunc -> localVars = AllocVec( sizeof(struct variable) * newFunc->numLocals,MEMF_ANY);
		if (!newFunc -> localVars) {
			KPrintF("loadFunctionCode: cannot allocate memory");
			return FALSE;
		}

		for (a = 0; a < newFunc -> numLocals; a ++) {
			initVarNew (newFunc -> localVars[a]);
		}
	}
	return TRUE;
}

void loadHandlers (BPTR fp) {
	currentEvents -> leftMouseFunction		= get2bytes (fp);
	currentEvents -> leftMouseUpFunction	= get2bytes (fp);
	currentEvents -> rightMouseFunction		= get2bytes (fp);
	currentEvents -> rightMouseUpFunction	= get2bytes (fp);
	currentEvents -> moveMouseFunction		= get2bytes (fp);
	currentEvents -> focusFunction			= get2bytes (fp);
	currentEvents -> spaceFunction			= get2bytes (fp);
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

void pauseFunction (struct loadedFunction * fun) {
	struct loadedFunction * * huntAndDestroy = & allRunningFunctions;
	while (* huntAndDestroy) {
		if (fun == * huntAndDestroy) {
			(* huntAndDestroy) = (* huntAndDestroy) -> next;
			fun->next = NULL;
		} else {
			huntAndDestroy = & (* huntAndDestroy) -> next;
		}
	}
}

void restartFunction (struct loadedFunction * fun) {
	fun -> next = allRunningFunctions;
	allRunningFunctions = fun;
}

BOOL runSludge () {
	
	struct loadedFunction * thisFunction = allRunningFunctions;
	struct loadedFunction * nextFunction;

	while (thisFunction) {
		nextFunction = thisFunction -> next;

		if (! thisFunction -> freezerLevel) {
			if (thisFunction -> timeLeft) {
				if (thisFunction -> timeLeft < 0) {				
					thisFunction -> timeLeft = 0;
				} else if (! -- (thisFunction -> timeLeft)) {
				}
			} else {
				if (thisFunction -> isSpeech) {
					thisFunction -> isSpeech = FALSE;
					killAllSpeech ();
				}
				if (! continueFunction (thisFunction))
					return FALSE;
			}
		}

		thisFunction = nextFunction;
	}

	if (loadNow) {
		if (loadNow[0] == ':') {
			saveGame (loadNow + 1);
			setVariable (saverFunc->reg, SVT_INT, 1);
		} else {
			if (! loadGame (loadNow)) return FALSE;
		}
		FreeVec(loadNow);
		loadNow = NULL;
	}

	return TRUE;
}

void saveHandlers (FILE * fp) {
	put2bytes (currentEvents -> leftMouseFunction,		fp);
	put2bytes (currentEvents -> leftMouseUpFunction,	fp);
	put2bytes (currentEvents -> rightMouseFunction,		fp);
	put2bytes (currentEvents -> rightMouseUpFunction,	fp);
	put2bytes (currentEvents -> moveMouseFunction,		fp);
	put2bytes (currentEvents -> focusFunction,			fp);
	put2bytes (currentEvents -> spaceFunction,			fp);
}

int startNewFunctionNum (unsigned int funcNum, unsigned int numParamsExpected, struct loadedFunction * calledBy, struct variableStack * vStack, BOOL returnSommet) {
	struct loadedFunction * newFunc = AllocVec(sizeof(struct loadedFunction),MEMF_ANY);
	if(!newFunc) {
		KPrintF("startNewFunction: Cannot allocate memory");
		return 0;
	}
	newFunc -> originalNumber = funcNum;

	loadFunctionCode (newFunc);

	if (newFunc -> numArgs != (int)numParamsExpected) {
		KPrintF("Wrong number of parameters!");
		return NULL; 
	}
	if (newFunc -> numArgs > newFunc -> numLocals)  {
		KPrintF ("More arguments than local variable space!");
		return NULL; 
	}
	
	// Now, lets copy the parameters from the calling function's stack...

	while (numParamsExpected) {
		numParamsExpected --;
		if (vStack == NULL) {
			KPrintF("Corrupted file! The stack's empty and there were still parameters expected");
			return NULL;
		}
		copyVariable (vStack -> thisVar, newFunc -> localVars[numParamsExpected]);
		trimStack (vStack);
	}

	newFunc -> cancelMe = FALSE;
	newFunc -> timeLeft = 0;
	newFunc -> returnSomething = returnSommet;
	newFunc -> calledBy = calledBy;
	newFunc -> stack = NULL;
	newFunc -> freezerLevel = 0;
	newFunc -> runThisLine = 0;
	newFunc -> isSpeech = 0;
	newFunc -> reg -> varType = SVT_NULL;

	restartFunction (newFunc);
	return 1;
}
