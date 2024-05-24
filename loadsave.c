#include <proto/dos.h>

#include "errors.h"
#include "floor.h"
#include "moreio.h"
#include "loadsave.h"
#include "people.h"
#include "sludger.h"
#include "support/gcc8_c_support.h"
#include "variable.h"
#include "version.h"
#include "zbuffer.h"

//----------------------------------------------------------------------
// From elsewhere
//----------------------------------------------------------------------

extern struct loadedFunction * allRunningFunctions;		// In sludger.cpp
extern BOOL allowAnyFilename;
extern unsigned char brightnessLevel;					// "	"	"
extern int cameraX, cameraY;	
extern float cameraZoom;
extern BOOL captureAllKeys;
extern struct flor * currentFloor;						// In floor.cpp
extern unsigned char fadeMode;							// In transition.cpp
extern struct FILETIME fileTime;						// In sludger.cpp
extern short fontSpace;									// in fonttext.cpp
extern char * fontOrderString;							// "	"	" 
extern struct variable * globalVars;					// In sludger.cpp
extern int languageNum;
extern int lightMapNumber;								// In backdrop.cpp
extern int loadedFontNum, fontHeight, fontTableSize;	// In fonttext.cpp
extern struct personaAnimation * mouseCursorAnim;		// In cursor.cpp
extern int mouseCursorFrameNum;							// "	"	"
extern int numGlobals;									// In sludger.cpp
extern struct parallaxLayer * parallaxStuff;				//		"
extern unsigned short saveEncoding;						// in savedata.cpp
extern struct speechStruct * speech;					// In talk.cpp
extern int speechMode;									// "	"	"
extern char * typeName[];								// In variable.cpp
extern struct zBufferData zBuffer;						// In zbuffer.cpp

//----------------------------------------------------------------------
// Globals (so we know what's saved already and what's a reference
//----------------------------------------------------------------------

struct stackLibrary {
	struct stackHandler * stack;
	struct stackLibrary * next;
};

int stackLibTotal = 0;
struct stackLibrary * stackLib = NULL;

void clearStackLib () {
	struct stackLibrary * k;
	while (stackLib) {
		k = stackLib;
		stackLib = stackLib -> next;
		FreeVec(k);
	}
	stackLibTotal = 0;
}

//----------------------------------------------------------------------
// For saving and loading functions
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Load everything
//----------------------------------------------------------------------

int ssgVersion;

struct loadedFunction * loadFunction (BPTR fp) {
	int a;

	// Reserve memory...

	loadedFunction * buildFunc = new loadedFunction;
	if (! checkNew (buildFunc)) return NULL;

	// See what it was called by and load if we need to...

	buildFunc -> originalNumber = get2bytes (fp);
	buildFunc -> calledBy = NULL;
	if (fgetc (fp)) {
		buildFunc -> calledBy = loadFunction (fp);
		if (! buildFunc -> calledBy) return NULL;
	}

	buildFunc -> timeLeft = get4bytes (fp);
	buildFunc -> runThisLine = get2bytes (fp);
	buildFunc -> freezerLevel = 0;
	buildFunc -> cancelMe = fgetc (fp);
	buildFunc -> returnSomething = fgetc (fp);
	buildFunc -> isSpeech = fgetc (fp);
	loadVariable (& (buildFunc -> reg), fp);
	loadFunctionCode (buildFunc);

	buildFunc -> stack = loadStack (fp, NULL);

	for (a = 0; a < buildFunc -> numLocals; a ++) {
		loadVariable (& (buildFunc -> localVars[a]), fp);
	}

	return buildFunc;
}

BOOL loadGame (char * fname) {
	BPTR fp;
	FILETIME savedGameTime;
	int a;

	while (allRunningFunctions) finishFunction (allRunningFunctions);

	fp = openAndVerify (fname, 'S', 'A', ERROR_GAME_LOAD_NO, ssgVersion);
	if (fp == NULL) return FALSE;

	unsigned int bytes_read = Read( fp, &savedGameTime, sizeof (FILETIME));
	
	if (bytes_read != sizeof (FILETIME)) {
		KPrintF("Reading error in loadGame.\n");
	}

	if (savedGameTime.dwLowDateTime != fileTime.dwLowDateTime ||
		savedGameTime.dwHighDateTime != fileTime.dwHighDateTime) {
		KPrintF("loadgame:", ERROR_GAME_LOAD_WRONG, fname);
		return FALSE; 
	}

	// DON'T ADD ANYTHING NEW BEFORE THIS POINT!

	allowAnyFilename = FgetC (fp);
	captureAllKeys = FgetC (fp);
	FgetC (fp); // updateDisplay (part of movie playing)

	BOOL fontLoaded = FGetC (fp);
	int fontNum;
	char * charOrder;
	if (fontLoaded) {
		fontNum = get2bytes (fp);
		fontHeight = get2bytes (fp);		
		charOrder = readString(fp);		
	}
	//loadFont (fontNum, charOrder, fontHeight); Amiga Todo: Implement Graphics stuff
	FreeVec(charOrder);
	
	fontSpace = getSigned (fp);

	killAllPeople ();
	killAllRegions ();

	int camerX = get2bytes (fp);
	int camerY = get2bytes (fp);
	float camerZ;
	camerZ = getFloat(fp);

	brightnessLevel = fgetc (fp);

	loadHandlers (fp);
	loadRegions (fp);

	mouseCursorAnim = AllocVec( sizeof( struct personaAnimation), MEMF_ANY);
	if (! mouseCursorAnim) {
		KPrintF("loadGame: Cannot allocate memory");
		return FALSE;
	if (! loadAnim (mouseCursorAnim, fp) {
		KPrintF("loadGame: Cannot load anim");
		return FALSE;		
	}
	mouseCursorFrameNum = get2bytes (fp);

	struct loadedFunction * rFunc;
	struct loadedFunction * * buildList = allRunningFunctions;


	int countFunctions = get2bytes (fp);
	while (countFunctions --) {
		rFunc = loadFunction (fp);
		rFunc -> next = NULL;
		(* buildList) = rFunc;
		buildList = & (rFunc -> next);
	}

	for (a = 0; a < numGlobals; a ++) {
		unlinkVar (globalVars[a]);
		loadVariable (& globalVars[a], fp);
	}

	loadPeople (fp);


	if (fgetc (fp)) {
		if (! setFloor (get2bytes (fp))) return false;
	} else setFloorNull ();

	if (fgetc (fp)) {
		if (! setZBuffer (get2bytes (fp))) return false;
	}

	if (fgetc (fp)) {
		if (! loadLightMap (get2bytes (fp))) return false;
	}

	if (ssgVersion >= VERSION(1,4)) {
		lightMapMode = fgetc (fp) % 3;
	}

	speechMode = fgetc (fp);
	fadeMode = fgetc (fp);
	loadSpeech (speech, fp);
	loadStatusBars (fp);
	loadSounds (fp);

	saveEncoding = get2bytes (fp);

	if (ssgVersion >= VERSION(1,6))
	{
		if (ssgVersion < VERSION (2,0)) {
			// aaLoad
			fgetc (fp);
			getFloat (fp);
			getFloat (fp);
		}

		blur_loadSettings(fp);
	}

	if (ssgVersion >= VERSION(1,3)) {
		currentBlankColour = get2bytes (fp);
		currentBurnR = fgetc (fp);
		currentBurnG = fgetc (fp);
		currentBurnB = fgetc (fp);

		// Read parallax layers
		while (fgetc (fp)) {
			int im = get2bytes (fp);
			int fx = get2bytes (fp);
			int fy = get2bytes (fp);

			if (! loadParallax (im, fx, fy)) return false;
		}

		int selectedLanguage = fgetc (fp);
		if (selectedLanguage != languageNum) {
			// Load the saved language!
			languageNum = selectedLanguage;
			setFileIndices (NULL, gameSettings.numLanguages, languageNum);
		}
	}

	nosnapshot ();
	if (ssgVersion >= VERSION(1,4)) {
		if (fgetc (fp)) {
			if (! restoreSnapshot (fp)) return false;
		}
	}

	fclose (fp);
	clearStackLib ();

	cameraX = camerX;
	cameraY = camerY;
	cameraZoom = camerZ;

	return true;
}

void saveFunction (struct loadedFunction * fun, BPTR fp) {
	int a;
	put2bytes (fun -> originalNumber, fp);
	if (fun -> calledBy) {
		FPutC (fp, 1);
		saveFunction (fun -> calledBy, fp);
	} else {
		FPutC (fp, 0);
	}
	put4bytes (fun -> timeLeft, fp);
	put2bytes (fun -> runThisLine, fp);
	FputC (fp, fun -> cancelMe);
	FputC (fp, fun -> returnSomething);
	FputC (fp, fun -> isSpeech);
	saveVariable (& (fun -> reg), fp);

	if (fun -> freezerLevel) {
		KPrintF(ERROR_GAME_SAVE_FROZEN);		
	}
	saveStack (fun -> stack, fp);
	for (a = 0; a < fun -> numLocals; a ++) {
		saveVariable (& (fun -> localVars[a]), fp);
	}
}

BOOL saveGame (char * fname) {
	int a;

	BPTR fp = Open( fname, MODE_NEWFILE);
	if (fp == NULL) {
		KPrintF("saveGame: Cannot create file");
		return FALSE;
	}

	Write( fp, &"SLUDSA", 6);
	FPutC (fp, 0);
	FPutC (fp, 0);
	FPutC (fp, MAJOR_VERSION);
	FPutC (fp, MINOR_VERSION);

	Write ( fp, &fileTime, sizeof(FILETIME));

	// DON'T ADD ANYTHING NEW BEFORE THIS POINT!

	FPutC (fp, allowAnyFilename);
	FPutC (fp, captureAllKeys);
	FPutC (fp, TRUE); // updateDisplay
	FPutC (fp, fontTableSize>0);

	if (fontTableSize>0) {
		put2bytes (loadedFontNum, fp);
		put2bytes (fontHeight, fp);
		writeString(fontOrderString, fp);
	}
	putSigned (fontSpace, fp);

	// Save backdrop
	put2bytes (cameraX, fp);
	put2bytes (cameraY, fp);
	putFloat(cameraZoom, fp);

	FPutC (fp, brightnessLevel);

	// Save event handlers
	saveHandlers (fp);

	// Save regions
	saveRegions (fp);

	saveAnim (mouseCursorAnim, fp);
	put2bytes (mouseCursorFrameNum, fp);

	// Save functions
	struct loadedFunction * thisFunction = allRunningFunctions;
	int countFunctions = 0;
	while (thisFunction) {
		countFunctions ++;
		thisFunction = thisFunction -> next;
	}
	put2bytes (countFunctions, fp);

	thisFunction = allRunningFunctions;
	while (thisFunction) {
		saveFunction (thisFunction, fp);
		thisFunction = thisFunction -> next;
	}

	for (a = 0; a < numGlobals; a ++) {
		saveVariable (& globalVars[a], fp);
	}

	savePeople (fp);

	if (currentFloor -> numPolygons) {
		FPutC (fp, 1);
		put2bytes (currentFloor -> originalNum, fp);
	} else FPutC (fp, 0);

	if (zBuffer.tex) {
		FPutC (fp, 1);
		put2bytes (zBuffer.originalNum, fp);
	} else FPutC (fp,0);

	FPutC (fp, speechMode);
	FPutC (fadeMode, fp);
	saveSpeech (speech, fp);
	saveStatusBars (fp);
	saveSounds (fp);

	put2bytes (saveEncoding, fp);

	saveParallaxRecursive (parallaxStuff, fp);
	FPutC (fp, 0);

	FPutC(fp, languageNum);	// Selected language

	Close(fp);
	clearStackLib ();
	return TRUE;
}

//----------------------------------------------------------------------
// For saving and loading stacks...
//----------------------------------------------------------------------

void saveStack (struct variableStack * vs, BPTR fp) {
	int elements = 0;
	int a;

	struct variableStack * search = vs;
	while (search) {
		elements ++;
		search = search -> next;
	}

	put2bytes (elements, fp);
	search = vs;
	for (a = 0; a < elements; a ++) {
		saveVariable (& search -> thisVar, fp);
		search = search -> next;
	}
}


BOOL saveStackRef (struct stackHandler * vs, BPTR fp) {
	struct stackLibrary * s = stackLib;
	int a = 0;
	while (s) {
		if (s -> stack == vs) {
			fputc (1, fp);
			put2bytes (stackLibTotal - a, fp);
			return TRUE;
		}
		s = s -> next;
		a ++;
	}
	FPutC (fp, 0);
	saveStack (vs -> first, fp);
	s = AllocVec( sizeof(struct stackLibrary), MEMF_ANY);
	stackLibTotal ++;
	if (! s) {
		KPrintF("saveStackRef: Cannot allocate memory");
		return FALSE;
	}
	s -> next = stackLib;
	s -> stack = vs;
	stackLib = s;
	return TRUE;
}

BOOL saveVariable (struct variable * from, BPTR fp)
{
	FPutC (fp,from -> varType);
	switch (from -> varType) {
		case SVT_INT:
		case SVT_FUNC:
		case SVT_BUILT:
		case SVT_FILE:
		case SVT_OBJTYPE:
		put4bytes (from -> varData.intValue, fp);
		return TRUE;

		case SVT_STRING:
		writeString (from -> varData.theString, fp);
		return TRUE;

		case SVT_STACK:
		return saveStackRef (from -> varData.theStack, fp);

		case SVT_COSTUME:
		saveCostume (from -> varData.costumeHandler, fp);
		return FALSE;

		case SVT_ANIM:
		saveAnim (from -> varData.animHandler, fp);
		return FALSE;

		case SVT_NULL:
		return FALSE;

		default:
		KPrintF("Can't save variables of this type:",
					(from->varType < SVT_NUM_TYPES) ?
						typeName[from->varType] :
						"bad ID");						
	}
	return TRUE;
}