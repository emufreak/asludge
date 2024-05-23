#include <proto/dos.h>

#include "loadsave.h"
#include "sludger.h"
#include "support/gcc8_c_support.h"
#include "version.h"

//----------------------------------------------------------------------
// From elsewhere
//----------------------------------------------------------------------

extern struct loadedFunction * allRunningFunctions;			// In sludger.cpp
extern BOOL allowAnyFilename;
extern unsigned char brightnessLevel;					// "	"	"
extern int cameraX, cameraY;	
extern float cameraZoom;
extern BOOL captureAllKeys;
extern struct flor * currentFloor;								// In floor.cpp
extern short fontSpace;									// in fonttext.cpp
extern char * fontOrderString;							// "	"	" 
extern struct variable * globalVars;					// In sludger.cpp
extern int lightMapNumber;								// In backdrop.cpp
extern int loadedFontNum, fontHeight, fontTableSize;	// In fonttext.cpp
extern struct personaAnimation * mouseCursorAnim;		// In cursor.cpp
extern int mouseCursorFrameNum;							// "	"	"
extern int numGlobals;									// In sludger.cpp
extern struct FILETIME fileTime;						// In sludger.cpp

//----------------------------------------------------------------------
// For saving and loading functions
//----------------------------------------------------------------------

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
		fatal (ERROR_GAME_SAVE_FROZEN);
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
	saveHSI (fp);

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
		fputc (1, fp);
		put2bytes (currentFloor -> originalNum, fp);
	} else fputc (0, fp);

	if (zBuffer.tex) {
		fputc (1, fp);
		put2bytes (zBuffer.originalNum, fp);
	} else fputc (0, fp);

	if (lightMap.data) {
		fputc (1, fp);
		put2bytes (lightMapNumber, fp);
	} else fputc (0, fp);

	fputc (lightMapMode, fp);
	fputc (speechMode, fp);
	fputc (fadeMode, fp);
	saveSpeech (speech, fp);
	saveStatusBars (fp);
	saveSounds (fp);

	put2bytes (saveEncoding, fp);

	blur_saveSettings(fp);

	put2bytes (currentBlankColour, fp);
	fputc (currentBurnR, fp);
	fputc (currentBurnG, fp);
	fputc (currentBurnB, fp);

	saveParallaxRecursive (parallaxStuff, fp);
	fputc (0, fp);

	fputc (languageNum, fp);	// Selected language

	saveSnapshot(fp);

	fclose (fp);
	clearStackLib ();
	return true;
}