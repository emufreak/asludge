#include <proto/exec.h>

#include "allfiles.h"
#include "backdrop.h"
#include "builtin.h"
#include "cursors.h"
#include "floor.h"
#include "fonttext.h"
#include "freeze.h"
#include "graphics.h"
#include "language.h"
#include "moreio.h"
#include "people.h"
#include "region.h"
#include "savedata.h"
#include "sound_nosound.h"
#include "sprbanks.h"
#include "sludger.h"
#include "statusba.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"
#include "talk.h"
#include "utils.h"
#include "variable.h"
#include "zbuffer.h"

extern BOOL allowAnyFilename;
extern unsigned char brightnessLevel;
extern BOOL captureAllKeys;
extern struct eventHandlers * currentEvents;
extern unsigned char fadeMode;
extern short fontSpace;
extern char * gamePath;
extern struct inputType input;
extern int lastFramesPerSecond, thumbWidth, thumbHeight;
extern char * loadNow;
extern struct variableStack ** noStack;
extern struct statusStuff * nowStatus;
extern int numBIFNames, numUserFunc;
extern unsigned short saveEncoding;
extern unsigned int sceneWidth, sceneHeight;
extern FLOAT speechSpeed;
extern UWORD textPaletteIndex;
extern struct screenRegion * overRegion;


typedef enum builtReturn (* builtInSludgeFunc) (int numParams, struct loadedFunction * fun);

extern struct Library *MathBase;
int cameraX, cameraY;
FLOAT cameraZoom = 1.0;
char * launchMe = NULL;
struct variable * launchResult = NULL;
struct loadedFunction * saverFunc;

int speechMode = 0;

struct builtInFunctionData
{
	builtInSludgeFunc func;
};


int paramNum[] = {-1, 0, 1, 1, -1, -1, 1, 3, 4, 1, 0, 0, 8, -1,		// SAY -> MOVEMOUSE
	-1, 0, 0, -1, -1, 1, 1, 1, 1, 4, 1, 1, 2, 1,// FOCUS -> REMOVEREGION
	2, 2, 0, 0, 2,								// ANIMATE -> SETSCALE
	-1, 2, 1, 0, 0, 0, 1, 0, 3, 				// new/push/pop stack, status stuff
	2, 0, 0, 3, 1, 0, 2,						// delFromStack -> completeTimers
	-1, -1, -1, 2, 2, 0, 3, 1, 					// anim, costume, pO, setC, wait, sS, substring, stringLength
	0, 1, 1, 0, 2,  							// dark, save, load, quit, rename
	1, 3, 3, 1, 2, 1, 1, 3, 1, 0, 0, 2, 1,		// stackSize, pasteString, startMusic, defvol, vol, stopmus, stopsound, setfont, alignStatus, show x 2, pos'Status, setFloor
	-1, -1, 1, 1, 2, 1, 1, 1, -1, -1, -1, 1, 1,	// force, jump, peekstart, peekend, enqueue, getSavedGames, inFont, loopSound, removeChar, stopCharacter
	1, 0, 1, 3, 1, 2, 1, 2, 2,					// launch, howFrozen, pastecol, litcol, checksaved, FLOAT, cancelfunc, walkspeed, delAll
	2, 3, 1, 2, 2, 0, 0, 1, 2, 3, 1, -1,		// extras, mixoverlay, pastebloke, getMScreenX/Y, setSound(Default/-)Volume, looppoints, speechMode, setLightMap
	-1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1,			// think, getCharacterDirection, is(char/region/moving), deleteGame, renameGame, hardScroll, stringWidth, speechSpeed, normalCharacter
	2, 1, 2, 1, 3, 1, 1, 2, 1,					// fetchEvent, setBrightness, spin, fontSpace, burnString, captureAll, cacheSound, setSpinSpeed, transitionMode
	1, 0, 0, 1, 0, 2, 1, 1, 1,					// movie(Start/Abort/Playing), updateDisplay, getSoundCache, savedata, loaddata, savemode, freeSound
	3, 0, 3, 3, 2, 1, 1,						// setParallax, clearParallax, setBlankColour, setBurnColour, getPixelColour, makeFastArray, getCharacterScale
	0, 2, 0,									// getLanguage, launchWith, getFramesPerSecond
	3, 2, 2, 0, 0, 1,							// readThumbnail, setThumbnailSize, hasFlag, snapshot, clearSnapshot, anyFilename
	2, 1,										// regGet, fatal
	4, 3, -1, 0,								// chr AA, max AA, setBackgroundEffect, doBackgroundEffect
	2,											// setCharacterAngleOffset
	2, 5,										// setCharacterTransparency, setCharacterColourise
	1,											// zoomCamera
	1, 0, 0, 5									// playMovie, stopMovie, pauseMovie, addZBufferLayer
};

#pragma mark -
#pragma mark Built in functions

#define builtIn(a) 			static enum builtReturn builtIn_ ## a (int numParams, struct loadedFunction * fun)

#define UNUSEDALL		 	(void) (0 && sizeof(numParams) && sizeof (fun));

BOOL failSecurityCheck(char * fn) {
	if (fn == NULL) return TRUE;

	int a = 0;

	while (fn[a]) {
		switch (fn[a]) {
			case ':':
			case '\\':
			case '/':
			case '*':
			case '?':
			case '"':
			case '<':
			case '>':
			case '|':
				KPrintF("Filenames may not contain the following characters: \n\n\\  /  :  \"  <  >  |  ?  *\n\nConsequently, the following filename is not allowed:", fn);
				return TRUE;
		}
		a++;
	}
	return FALSE;
}

static enum builtReturn sayCore (int numParams, struct loadedFunction * fun, BOOL sayIt)
{
	int fileNum = -1;
	char * newText;
	int objT, p;
	killSpeechTimers ();

	switch (numParams) {
		case 3:
			if (! getValueType (&fileNum, SVT_FILE, &fun->stack->thisVar)) return BR_ERROR;
			trimStack (&fun -> stack);
			[[fallthrough]];

		case 2:
			newText = getTextFromAnyVar (&(fun -> stack->thisVar));
			if (! newText) return BR_ERROR;
			trimStack (&fun -> stack);
			if (! getValueType(&objT, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
			if (! getValueType(&objT, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
			trimStack (&fun -> stack);
			p = wrapSpeech (newText, objT, fileNum, sayIt);
			fun -> timeLeft = p;
			//debugOut ("BUILTIN: sayCore: %s (%i)\n", newText, p);
			fun -> isSpeech = TRUE;
			FreeVec(newText);
			newText = NULL;
			return BR_KEEP_AND_PAUSE;
	}

	KPrintF("Function should have either 2 or 3 parameters");
	return BR_ERROR;
}

builtIn(say)
{
	UNUSEDALL
	return sayCore (numParams, fun, TRUE);
}

builtIn(think)
{
	UNUSEDALL
	return sayCore (numParams, fun, FALSE);
}

builtIn(freeze)
{
	KPrintF("running freeze\n");
	UNUSEDALL
	freeze ();
	freezeSubs (); 
	fun -> freezerLevel = 0;
	return BR_CONTINUE;
}

builtIn(unfreeze)
{
	KPrintF("running unfreeze\n");
	UNUSEDALL
	unfreeze ();
	unfreezeSubs (); 
	return BR_CONTINUE;
}

builtIn(howFrozen)
{
	//KPrintF("running howfrozen\n");
	UNUSEDALL
	setVariable (&fun -> reg, SVT_INT, howFrozen ());
	return BR_CONTINUE; 
}

builtIn(setCursor)
{
	KPrintF("running setCursor\n");
	UNUSEDALL
	struct personaAnimation * aa = getAnimationFromVar (&(fun -> stack -> thisVar));
	pickAnimCursor (aa);
	trimStack (&fun -> stack);
	return BR_CONTINUE;
}

builtIn(getMouseX)
{
	KPrintF("running getMouseX\n");
	UNUSEDALL
	setVariable (&fun -> reg, SVT_INT, input.mouseX + cameraX);
	return BR_CONTINUE;
}

builtIn(getMouseY)
{
	KPrintF("running getMouseY\n");
	UNUSEDALL
	setVariable (&fun -> reg, SVT_INT, input.mouseY + cameraY);
	return BR_CONTINUE;
}

builtIn(getMouseScreenX)
{
	KPrintF("running getMouseScreenX\n");
	UNUSEDALL
	setVariable (&fun -> reg, SVT_INT, input.mouseX*cameraZoom);
	return BR_CONTINUE;
}

builtIn(getMouseScreenY)
{
	KPrintF("running getMouseScreenY\n");
	UNUSEDALL
	setVariable (&fun -> reg, SVT_INT, input.mouseY*cameraZoom);
	return BR_CONTINUE;
}

builtIn(getStatusText)
{
	KPrintF("running getStatusText\n");
	UNUSEDALL
	makeTextVar (&fun -> reg, statusBarText ());
	return BR_CONTINUE;
}

builtIn(getMatchingFiles)
{
	KPrintF("running getMatchingFiles\n");
	UNUSEDALL
	char * newText = getTextFromAnyVar (&(fun -> stack -> thisVar));
	if (! newText) return BR_ERROR;
	trimStack (&fun -> stack);
	unlinkVar (&fun -> reg);

	// Return value
	fun -> reg.varType = SVT_STACK;
	fun -> reg.varData.theStack = AllocVec(sizeof( struct stackHandler),MEMF_ANY);
	if (!(&fun -> reg.varData.theStack)) return BR_ERROR;
	fun -> reg.varData.theStack -> first = NULL;
	fun -> reg.varData.theStack -> last = NULL;
	fun -> reg.varData.theStack -> timesUsed = 1;
	if (! getSavedGamesStack (fun -> reg.varData.theStack, newText)) return BR_ERROR;
	FreeVec(newText);
	newText = NULL;
	return BR_CONTINUE;
}

builtIn(saveGame)
{
	KPrintF("running saveGame\n");
    UNUSEDALL

    /*if (frozenStuff) {
        fatal ("Can't save game state while the engine is frozen");
    }*/

    loadNow = getTextFromAnyVar(&(fun->stack->thisVar));
    trimStack(&fun->stack);

    char *aaaaa = encodeFilename(loadNow);
    FreeVec(loadNow);
    if (failSecurityCheck(aaaaa)) return BR_ERROR; // Won't fail if encoded, how cool is that? OK, not very.

    loadNow = joinStrings(":", aaaaa);
    FreeVec(aaaaa);

    setVariable(&fun->reg, SVT_INT, 0);
    saverFunc = fun;
    return BR_KEEP_AND_PAUSE;
}

builtIn(fileExists)
{
	KPrintF("running fileExists\n");
    UNUSEDALL
    loadNow = getTextFromAnyVar(&(fun->stack->thisVar));
    trimStack(&fun->stack);
    char *aaaaa = encodeFilename(loadNow);
    FreeVec(loadNow);
    if (failSecurityCheck(aaaaa)) return BR_ERROR;
    BPTR fp = Open(aaaaa, MODE_OLDFILE);
    if (!fp) {        
        KPrintF("Can't get current directory.\n");      
    }
    // Return value
    setVariable(&fun->reg, SVT_INT, (fp != NULL));
    if (fp) Close(fp);
    FreeVec(aaaaa);
    loadNow = NULL;
    return BR_CONTINUE;
}

builtIn(loadGame)
{
	KPrintF("running loadGame\n");
    UNUSEDALL
    char *aaaaa = getTextFromAnyVar(&(fun->stack->thisVar));
    trimStack(&fun->stack);
    loadNow = encodeFilename(aaaaa);
    FreeVec(aaaaa);

    /*if (frozenStuff) {
        fatal("Can't load a saved game while the engine is frozen");
    }*/

    if (failSecurityCheck(loadNow)) return BR_ERROR;
    BPTR fp = Open(loadNow, MODE_OLDFILE);
    if (fp) {
        Close(fp);
        return BR_KEEP_AND_PAUSE;
    }
    FreeVec(loadNow);
    loadNow = NULL;
    return BR_CONTINUE;
}

//--------------------------------------
#pragma mark -
#pragma mark Background image - Painting

builtIn(blankScreen)
{
	KPrintF("running blankScreen\n");
	UNUSEDALL
	blankScreen (0, 0, sceneWidth, sceneHeight);
	return BR_CONTINUE;
}

builtIn(blankArea)
{
	KPrintF("running blankArea\n");
	UNUSEDALL
	int x1, y1, x2, y2;
	if (! getValueType (&y2, SVT_INT, &fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType (&x2, SVT_INT, &fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType (&y1, SVT_INT, &fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType (&x1, SVT_INT, &fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	blankScreen (x1, y1, x2, y2);
	return BR_CONTINUE;
}

builtIn(darkBackground)
{
	KPrintF("running darkBackground\n");
	UNUSEDALL
	darkScreen ();
	return BR_CONTINUE;
}

builtIn(addOverlay)
{
	KPrintF("running addOverlay\n");
	UNUSEDALL
	int fileNumber, xPos, yPos;
	if (! getValueType(&yPos, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&xPos, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&fileNumber, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	loadBackDrop (fileNumber, xPos, yPos);
	return BR_CONTINUE;
}

//addZBufferLayer( xPos, yPos, width, height )
builtIn(addZBufferLayer)
{
	KPrintF("running addZBufferLayer\n");
	UNUSEDALL
	int xpos, ypos, width, height, yz;
	if (! getValueType(&yz, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&height, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&width, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);	
	if (! getValueType(&ypos, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);	
	if (! getValueType(&xpos, SVT_INT, &fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);	
	addZBufferLayer( xpos, ypos, width, height, yz);
	return BR_CONTINUE;
}

builtIn(mixOverlay)
{
	KPrintF("running mixOverlay\n");
	UNUSEDALL
	int fileNumber, xPos, yPos;
	if (! getValueType(&yPos, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&xPos, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&fileNumber, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	mixBackDrop (fileNumber, xPos, yPos);
	return BR_CONTINUE;
}

builtIn(pasteImage)
{
	KPrintF("running pasteImage\n");
	UNUSEDALL
	//KPrintF("pasteimage: Started\n");
	int x, y;
	if (! getValueType(&y, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	struct personaAnimation * pp = getAnimationFromVar (&(fun -> stack -> thisVar));
	trimStack (&fun -> stack);
	if (pp == NULL) return BR_CONTINUE;

	pasteCursor (x, y, pp);
	//KPrintF("pasteimage: Finished\n");
	return BR_CONTINUE;	
}

#pragma mark -
#pragma mark Background Image - Scrolling

builtIn(setSceneDimensions)
{
	KPrintF("running setSceneDimensions\n");
	UNUSEDALL
	int x, y;
	if (! getValueType(&y, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (resizeBackdrop (x, y)) {
		blankScreen (0, 0, x, y);
		return BR_CONTINUE;
	}
	KPrintF("Out of memory creating new backdrop.");
	return BR_ERROR;
}

builtIn(aimCamera)
{
	KPrintF("running aimCamera\n");
	UNUSEDALL
	if (! getValueType(&cameraY, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&cameraX, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	cameraX -= (FLOAT)(winWidth >> 1)/ cameraZoom;
	cameraY -= (FLOAT)(winHeight >> 1)/ cameraZoom;

	if (cameraX < 0) cameraX = 0;
	else if (cameraX > sceneWidth - (FLOAT)winWidth/ cameraZoom) cameraX = sceneWidth - (FLOAT)winWidth/ cameraZoom;
	if (cameraY < 0) cameraY = 0;
	else if (cameraY > sceneHeight - (FLOAT)winHeight/ cameraZoom) cameraY = sceneHeight - (FLOAT)winHeight/ cameraZoom;
	return BR_CONTINUE;
}


builtIn(zoomCamera)
{
	KPrintF("running zoomCamera\n");
	UNUSEDALL
	int z;
	if (! getValueType(&z, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	input.mouseX = input.mouseX * cameraZoom;
	input.mouseY = input.mouseY * cameraZoom;


	cameraZoom = (FLOAT) z * (FLOAT) 0.01;
	if ((FLOAT) winWidth / cameraZoom > sceneWidth) cameraZoom = (FLOAT)winWidth / sceneWidth;
	if ((FLOAT) winHeight / cameraZoom > sceneHeight) cameraZoom = (FLOAT)winHeight / sceneHeight;
	//setPixelCoords (FALSE); Todo: Amigize this

	input.mouseX = input.mouseX / cameraZoom;
	input.mouseY = input.mouseY / cameraZoom;

	return BR_CONTINUE;
}

#pragma mark -
#pragma mark Variables


builtIn(pickOne)
{
	KPrintF("running pickOne\n");
	UNUSEDALL
	if (! numParams) {
		KPrintF ("Built-in function should have at least 1 parameter");
		return BR_ERROR;
	}
	int i = rand() % numParams;

	// Return value
	while (numParams --) {
		if (i == numParams) copyVariable (&(fun -> stack -> thisVar), &fun -> reg);
		trimStack (&fun -> stack);
	}
	return BR_CONTINUE;
}

builtIn(substring)
{
	KPrintF("running substring\n");
    UNUSEDALL
    char *wholeString;
    char *newString;
    int start, length;

    //debugOut ("BUILTIN: substring\n");

    if (!getValueType(&length, SVT_INT,&fun->stack->thisVar)) return BR_ERROR;
    trimStack(&fun->stack);
    if (!getValueType(&start, SVT_INT,&fun->stack->thisVar)) return BR_ERROR;
    trimStack(&fun->stack);
    wholeString = getTextFromAnyVar(&(fun->stack->thisVar));
    trimStack(&fun->stack);
    
    if (strlen(wholeString) < (ULONG) start + length) {
        length = strlen(wholeString) - start;
        if (strlen(wholeString) < (ULONG) start) {
            start = 0;
        }
    }
    if (length < 0) {
        length = 0;
    }
    
    int startoffset = start;
    int endoffset = start + length;

    newString = AllocVec(endoffset - startoffset + 1, MEMF_ANY);
    if (!newString) {
        return BR_ERROR;
    }
    
    memcpy(newString, wholeString + startoffset, endoffset - startoffset);
    newString[endoffset - startoffset] = 0;
    
    makeTextVar(&fun->reg, newString);
    FreeVec(newString);
    return BR_CONTINUE;
}

builtIn(stringLength)
{
	KPrintF("running stringLength\n");
	UNUSEDALL
	char * newText = getTextFromAnyVar (&(fun -> stack -> thisVar));
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, strlen(newText));
	FreeVec(newText);
	return BR_CONTINUE;
}

builtIn(newStack)
{
	KPrintF("running newStack\n");
    UNUSEDALL
    unlinkVar(&fun->reg);

    // Return value
    fun->reg.varType = SVT_STACK;
    fun->reg.varData.theStack = AllocVec(sizeof(struct stackHandler), MEMF_ANY);
    if (!fun->reg.varData.theStack) return BR_ERROR;
    fun->reg.varData.theStack->first = NULL;
    fun->reg.varData.theStack->last = NULL;
    fun->reg.varData.theStack->timesUsed = 1;
    
    while (numParams--) {
        if (!addVarToStack(&fun->stack->thisVar, &fun->reg.varData.theStack->first)) return BR_ERROR;
        if (fun->reg.varData.theStack->last == NULL) {
            fun->reg.varData.theStack->last = fun->reg.varData.theStack->first;
        }
        trimStack(&fun->stack);
    }
    return BR_CONTINUE;
}

// wait is exactly the same function, but limited to 2 parameters
#define builtIn_wait builtIn_newStack

builtIn(stackSize)
{
	KPrintF("running stackSize\n");
	UNUSEDALL
	switch (fun -> stack -> thisVar.varType) {
		case SVT_STACK:
			// Return value
			setVariable (&fun -> reg, SVT_INT, stackSize (fun -> stack -> thisVar.varData.theStack));
			trimStack (&fun -> stack);
			return BR_CONTINUE;

		case SVT_FASTARRAY:
			// Return value
			setVariable (&fun -> reg, SVT_INT, fun -> stack -> thisVar.varData.fastArray -> size);
			trimStack (&fun -> stack);
			return BR_CONTINUE;

		default:
			break;
	}
	KPrintF ("Parameter isn't a stack or a fast array.");
	return BR_ERROR;
}

builtIn(copyStack)
{
	KPrintF("running copyStack\n");
	UNUSEDALL
	if (fun -> stack -> thisVar.varType != SVT_STACK) {
		KPrintF ("Parameter isn't a stack.");
		return BR_ERROR;
	}
	// Return value
	if (! copyStack (&fun -> stack -> thisVar, &fun -> reg)) return BR_ERROR;
	trimStack (&fun -> stack);
	return BR_CONTINUE;
}

builtIn(pushToStack)
{
	KPrintF("running pushToStack\n");
	UNUSEDALL
	if (fun -> stack -> next -> thisVar.varType != SVT_STACK) {
		KPrintF("Parameter isn't a stack");
		return BR_ERROR;
	}

	if (! addVarToStack (&fun -> stack -> thisVar, &fun -> stack -> next -> thisVar.varData.theStack -> first))
		return BR_ERROR;

	if (fun -> stack -> next -> thisVar.varData.theStack -> first -> next == NULL)
		fun -> stack -> next -> thisVar.varData.theStack -> last = fun -> stack -> next -> thisVar.varData.theStack -> first;

	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	return BR_CONTINUE;
}

builtIn(enqueue)
{
	KPrintF("running enqueue\n");
	UNUSEDALL
	if (fun -> stack -> next -> thisVar.varType != SVT_STACK) {
		KPrintF ("Parameter isn't a stack");
		return BR_ERROR;
	}

	if (fun -> stack -> next -> thisVar.varData.theStack -> first == NULL)
	{
		if (! addVarToStack (&fun -> stack -> thisVar, &fun -> stack -> next -> thisVar.varData.theStack -> first))
			return BR_ERROR;

		fun -> stack -> next -> thisVar.varData.theStack -> last = fun -> stack -> next -> thisVar.varData.theStack -> first;
	}
	else
	{
		if (! addVarToStack (&fun -> stack -> thisVar,
							 &fun -> stack -> next -> thisVar.varData.theStack -> last -> next))
			return BR_ERROR;
		fun -> stack -> next -> thisVar.varData.theStack -> last = fun -> stack -> next -> thisVar.varData.theStack -> last -> next;
	}

	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	return BR_CONTINUE;
}

builtIn(deleteFromStack)
{
	KPrintF("running deleteFromStack\n");
	UNUSEDALL
	if (fun -> stack -> next -> thisVar.varType != SVT_STACK) {
		KPrintF ("Parameter isn't a stack.");
		return BR_ERROR;
	}

	// Return value
	setVariable (&fun -> reg, SVT_INT,
				 deleteVarFromStack (&fun -> stack -> thisVar,
									 &fun -> stack -> next -> thisVar.varData.theStack -> first, FALSE));

	// Horrible hacking because 'last' value might now be wrong!
	fun->stack->next->thisVar.varData.theStack->last = stackFindLast (fun->stack->next->thisVar.varData.theStack->first);

	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	return BR_CONTINUE;
}

builtIn(deleteAllFromStack)
{
	KPrintF("running deleteAllFromStack\n");
	UNUSEDALL
	if (fun -> stack -> next -> thisVar.varType != SVT_STACK) {
		KPrintF ("Parameter isn't a stack.");
		return BR_ERROR;
	}

	// Return value
	setVariable (&fun -> reg, SVT_INT,
				 deleteVarFromStack (&fun -> stack -> thisVar,
									 &fun -> stack -> next -> thisVar.varData.theStack -> first, TRUE));

	// Horrible hacking because 'last' value might now be wrong!
	fun->stack->next->thisVar.varData.theStack->last = stackFindLast (fun->stack->next->thisVar.varData.theStack->first);

	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	return BR_CONTINUE;
} 

builtIn(popFromStack)
{
	KPrintF("running popFromStack\n");
	UNUSEDALL
	if (fun -> stack -> thisVar.varType != SVT_STACK) {
		KPrintF ("Parameter isn't a stack.");
		return BR_ERROR;
	}	
	if (fun -> stack -> thisVar.varData.theStack -> first == NULL) {
		KPrintF ("The stack's empty.");
		return BR_ERROR;
	}

	// Return value
	copyVariable (&(fun -> stack -> thisVar.varData.theStack -> first -> thisVar), &fun -> reg);
	trimStack (&fun -> stack -> thisVar.varData.theStack -> first);
	trimStack (&fun -> stack);
	return BR_CONTINUE;
}

builtIn(peekStart)
{
	KPrintF("running peekStart\n");
	UNUSEDALL
	if (fun -> stack -> thisVar.varType != SVT_STACK) {
		KPrintF ("Parameter isn't a stack.");
		return BR_ERROR;
	}
	if (fun -> stack -> thisVar.varData.theStack -> first == NULL) {
		KPrintF ("The stack's empty.");
		return BR_ERROR;
	}

	// Return value
	copyVariable (&(fun -> stack -> thisVar.varData.theStack -> first -> thisVar), &fun -> reg);
	trimStack (&fun -> stack);
	return BR_CONTINUE;
}

builtIn(peekEnd)
{
	KPrintF("running peekEnd\n");
	UNUSEDALL
	if (fun -> stack -> thisVar.varType != SVT_STACK) {
		KPrintF ("Parameter isn't a stack.");
		return BR_ERROR;
	}
	if (fun -> stack -> thisVar.varData.theStack -> first == NULL) {
		KPrintF ("The stack's empty.");
		return BR_ERROR;
	}

	// Return value
	copyVariable (&(fun -> stack -> thisVar.varData.theStack -> last -> thisVar), &fun -> reg);
	trimStack (&fun -> stack);
	return BR_CONTINUE;
}

builtIn(random)
{
	KPrintF("running random\n");
	UNUSEDALL
	int num;

	if (! getValueType(&num, SVT_INT,&fun -> stack -> thisVar))
		return BR_ERROR;

	trimStack (&fun -> stack);
	if (num <= 0) num = 1;
	setVariable (&fun -> reg, SVT_INT, rand() % num);
	return BR_CONTINUE;
}

builtIn (setStatusColour)
{
	KPrintF("running setStatusColour\n");
	UNUSEDALL
	/*int red, green, blue;

	if (! getRGBParams(red, green, blue, fun))
		return BR_ERROR;

	statusBarColour ((byte) red, (byte) green, (byte) blue);
	return BR_CONTINUE; ToDo amigize this?*/
}

builtIn (setLitStatusColour)
{
	KPrintF("running setLitStatusColour\n");
	UNUSEDALL
	/*int red, green, blue;

	if (! getRGBParams(red, green, blue, fun))
		return BR_ERROR;

	statusBarLitColour ((byte) red, (byte) green, (byte) blue);Todo - Amigize this?*/
	return BR_CONTINUE;
}

builtIn (setPasteColour)
{
	KPrintF("running setPasteColour\n");
	UNUSEDALL
	int index;

	if (! getValueType ( &index, SVT_INT, &fun -> stack -> thisVar)) {
		KPrintF ("setPasteColour: Parameter not a number");
		return BR_ERROR;
	}
	trimStack (&fun -> stack);


	textPaletteIndex = (UWORD)index;

	if( textPaletteIndex > 31) {
		KPrintF ("setPasteColour: Paletteindex out of Range");
		textPaletteIndex = 0;
		return BR_ERROR;
	}

	//setFontColour (pastePalette, (byte) red, (byte) green, (byte) blue);
	return BR_CONTINUE;
}

builtIn (setBlankColour)
{
	KPrintF("running setBlankColour\n");
	UNUSEDALL
	/*int red, green, blue;

	if (! getRGBParams(red, green, blue, fun))
		return BR_ERROR;

	currentBlankColour = makeColour (red & 255, green & 255, blue & 255);
	setVariable (&fun -> reg, SVT_INT, 1);Todo Amigize this?*/
	return BR_CONTINUE;
}

builtIn (setBurnColour)
{
	KPrintF("running setBurnColour\n");
	UNUSEDALL
	/*int red, green, blue;

	if (! getRGBParams(red, green, blue, fun))
		return BR_ERROR;

	currentBurnR = red;
	currentBurnG = green;
	currentBurnB = blue;
	setVariable (&fun -> reg, SVT_INT, 1);Todo Amigize this?*/
	return BR_CONTINUE;
}


builtIn(setFont)
{
	KPrintF("running setFont\n");
    UNUSEDALL
    int fileNumber, newHeight;
    if (!getValueType(&newHeight, SVT_INT,&fun->stack->thisVar)) return BR_ERROR;
    //              KPrintF("  Height: %d\n", newHeight);
    trimStack(&fun->stack);
    char *newText = getTextFromAnyVar(&(fun->stack->thisVar));
    if (!newText) return BR_ERROR;
    //              KPrintF("  Character supported: %s\n", newText);
    trimStack(&fun->stack);
    if (!getValueType(&fileNumber, SVT_FILE,&fun->stack->thisVar)) return BR_ERROR;
    //              KPrintF("  File: %d\n", fileNumber);
    trimStack(&fun->stack);
    if (!loadFont(fileNumber, newText, newHeight)) return BR_ERROR;
    //              KPrintF("  Done!\n");
    FreeVec(newText);

    return BR_CONTINUE;
}

builtIn(inFont)
{
	KPrintF("running inFont\n");
	UNUSEDALL
	char * newText = getTextFromAnyVar (&(fun -> stack -> thisVar));
	if (! newText) return BR_ERROR;
	trimStack (&fun -> stack);

	// Return value
	
	setVariable (&fun -> reg, SVT_INT, isInFont(newText));
	return BR_CONTINUE;
}

builtIn(pasteString)
{
	KPrintF("running pasteString\n");
    UNUSEDALL
    char *newText = getTextFromAnyVar(&(fun->stack->thisVar));
    trimStack(&fun->stack);
    int y, x;
    if (!getValueType(&y, SVT_INT,&fun->stack->thisVar)) return BR_ERROR;
    trimStack(&fun->stack);
    if (!getValueType(&x, SVT_INT,&fun->stack->thisVar)) return BR_ERROR;
    trimStack(&fun->stack);
    if (x == IN_THE_CENTRE) 
		x = (winWidth - stringWidth(newText)) >> 1;
    //fixFont(pastePalette); //Todo: Amigize this
    pasteStringToBackdrop(newText, x, y); 
    FreeVec(newText); 
    return BR_CONTINUE;
}

builtIn(anim)
{
	KPrintF("running anim\n");
	UNUSEDALL
	if (numParams < 2) {
		KPrintF("Built-in function anim() must have at least 2 parameters.");
		return BR_ERROR;
	}


	// First store the frame numbers and take 'em off the stack
	struct personaAnimation * ba = createPersonaAnim (numParams - 1, &fun -> stack);

	// Only remaining paramter is the file number
	int fileNumber;
	if (! getValueType(&fileNumber, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	// Load the required sprite bank
	struct loadedSpriteBank * sprBanky = loadBankForAnim (fileNumber);
	if (! sprBanky) return BR_ERROR;	// File not found, fatal done already
	setBankFile (ba, sprBanky);

	// Return value
	newAnimationVariable (&fun -> reg, ba);
	return BR_CONTINUE;
}

builtIn(costume)
{
	KPrintF("running costume\n");
    UNUSEDALL
    struct persona * newPersona = AllocVec(sizeof(struct persona), MEMF_ANY);
    if (!newPersona) return BR_ERROR;
    newPersona->numDirections = numParams / 3;
    if (numParams == 0 || newPersona->numDirections * 3 != numParams) {
        KPrintF("Illegal number of parameters (should be greater than 0 and divisible by 3)");
        return BR_ERROR;
    }
    int iii;
    newPersona->animation = AllocVec(sizeof(struct personaAnimation *) * numParams, MEMF_ANY);
    if (!newPersona->animation) return BR_ERROR;
    for (iii = numParams - 1; iii >= 0; iii--) {
        newPersona->animation[iii] = getAnimationFromVar(&(fun->stack->thisVar));
        trimStack(&fun->stack);
    }

    // Return value
    newCostumeVariable(&fun->reg, newPersona);
    return BR_CONTINUE;
}

builtIn(launch)
{
	KPrintF("running launch\n");
    UNUSEDALL
    char * newTextA = getTextFromAnyVar(&(fun->stack->thisVar));
    if (!newTextA) return BR_ERROR;

    char * newText = encodeFilename(newTextA);

    trimStack(&fun->stack);
    if (newTextA[0] == 'h' &&
        newTextA[1] == 't' &&
        newTextA[2] == 't' &&
        newTextA[3] == 'p' &&
        (newTextA[4] == ':' || (newTextA[4] == 's' && newTextA[5] == ':'))) {

        // IT'S A WEBSITE!
        launchMe = copyString(newTextA);
    } else {
        char *gameDir;
        gameDir = joinStrings(gamePath, "/");

        launchMe = joinStrings(gameDir, newText);
        FreeVec(newText);
        if (!launchMe) return BR_ERROR;
    }
    FreeVec(newTextA);
    setGraphicsWindow(FALSE);
    setVariable(&fun->reg, SVT_INT, 1);
    launchResult = &fun->reg;

    return BR_KEEP_AND_PAUSE;
}

builtIn(pause)
{
	//KPrintF("running pause\n");
	UNUSEDALL
	int theTime;
	if (! getValueType(&theTime, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (theTime > 0) {
		fun -> timeLeft = theTime - 1;
		fun -> isSpeech = FALSE;
		return BR_KEEP_AND_PAUSE;
	}
	return BR_CONTINUE;
}

builtIn(completeTimers)
{
	KPrintF("running completeTimers\n");
	UNUSEDALL
	completeTimers();
	return BR_CONTINUE;
}

builtIn(callEvent)
{
	KPrintF("running callEvent\n");
	UNUSEDALL
	int obj1, obj2;
	if (! getValueType(&obj2, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj1, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	int fNum = getCombinationFunction (obj1, obj2);

	// Return value
	if (fNum) {
		setVariable (&fun -> reg, SVT_FUNC, fNum);
		return BR_CALLAFUNC;
	}
	setVariable (&fun -> reg, SVT_INT, 0);
	return BR_CONTINUE;
}


BOOL reallyWantToQuit = FALSE;

builtIn(quitGame)
{
	KPrintF("running quitGame\n");
	UNUSEDALL
	reallyWantToQuit = TRUE;
	//quit_event.type=SDL_QUIT; Todo: Amigize
	//SDL_PushEvent(&quit_event);
	return BR_CONTINUE;
}


#pragma mark -
#pragma mark Movie functions

// The old movie functions are deprecated and does nothing.
builtIn(_rem_movieStart)
{	
	UNUSEDALL
	trimStack (&fun -> stack);
	KPrintF("Movie Stuff not supported on Amiga");
	return BR_CONTINUE;
}

builtIn(_rem_movieAbort)
{
	UNUSEDALL
	//setVariable (&fun -> reg, SVT_INT, 0);
	KPrintF("Movie Stuff not supported on Amiga");
	return BR_CONTINUE;
}

builtIn(_rem_moviePlaying)
{
	UNUSEDALL
	KPrintF("Movie Stuff not supported on Amiga");
	//setVariable (&fun -> reg, SVT_INT, 0);
	return BR_CONTINUE;
}

builtIn (playMovie)
{
	UNUSEDALL
	/*int fileNumber, r;
		
	if (movieIsPlaying) return BR_PAUSE;
	
	if (! getValueType(&fileNumber, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	
	r = playMovie(fileNumber);
	
	setVariable (&fun -> reg, SVT_INT, r);
	
	if (r && (! fun->next)) {
		restartFunction (fun);
		return BR_ALREADY_GONE;
	}*/
	KPrintF("Movie Stuff not supported on Amiga");
	return BR_CONTINUE;
}

builtIn (stopMovie)
{
	UNUSEDALL
	/*int r;
	
	r = stopMovie();
	
	setVariable (&fun -> reg, SVT_INT, 0);*/
	KPrintF("Movie Stuff not supported on Amiga");
	return BR_CONTINUE;
}

builtIn (pauseMovie)
{
	UNUSEDALL
	/*int r;
	
	r = pauseMovie();
	
	setVariable (&fun -> reg, SVT_INT, 0);*/
	KPrintF("Movie Stuff not supported on Amiga");
	return BR_CONTINUE;
}


#pragma mark -
#pragma mark Audio functions

builtIn(startMusic)
{
	UNUSEDALL
	int fromTrack, musChan, fileNumber;
	if (! getValueType(&fromTrack, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&musChan, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&fileNumber, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! playMOD (fileNumber, musChan, fromTrack)) return BR_CONTINUE; //BR_ERROR;
	return BR_CONTINUE;
}

builtIn(stopMusic)
{
	UNUSEDALL
	int v;
	if (! getValueType(&v, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	stopMOD (v);
	return BR_CONTINUE;
}

builtIn(setMusicVolume)
{
	UNUSEDALL
	int musChan, v;
	if (! getValueType(&v, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&musChan, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setMusicVolume (musChan, v);
	return BR_CONTINUE;
}

builtIn(setDefaultMusicVolume)
{
	UNUSEDALL
	int v;
	if (! getValueType(&v, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setDefaultMusicVolume (v);
	return BR_CONTINUE;
}

builtIn(playSound)
{


	UNUSEDALL
	int fileNumber;
	if (! getValueType(&fileNumber, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! startSound (fileNumber, FALSE)) return BR_CONTINUE;	// Was BR_ERROR
	return BR_CONTINUE;
}

builtIn(loopSound)
{
	UNUSEDALL
	int fileNumber;

	if (numParams < 1) {
		KPrintF("Built-in function loopSound() must have at least 1 parameter.");
		return BR_ERROR;
	} else if (numParams < 2) {

		if (!getValueType(&fileNumber, SVT_FILE,&fun->stack->thisVar)) return BR_ERROR;
		trimStack(&fun->stack);
		if (!startSound(fileNumber, TRUE)) return BR_CONTINUE;	// Was BR_ERROR
		return BR_CONTINUE;
	} else {
		// We have more than one sound to play!

		int doLoop = 2;
		struct soundList *s = NULL;
		struct soundList *old = NULL;

		// Should we loop?
		if (fun->stack->thisVar.varType != SVT_FILE) {
			getValueType(&doLoop, SVT_INT,&fun->stack->thisVar);
			trimStack(&fun->stack);
			numParams--;
		}
		while (numParams) {
			if (!getValueType(&fileNumber, SVT_FILE,&fun->stack->thisVar)) {
				KPrintF("Illegal parameter given built-in function loopSound().");
				return BR_ERROR;
			}
			s = AllocVec(sizeof(struct soundList), MEMF_ANY);
			if (!s) return BR_ERROR;

			s->next = old;
			s->prev = NULL;
			s->sound = fileNumber;
			old = s;

			trimStack(&fun->stack);
			numParams--;
		}
		while (s->next) s = s->next;
		if (doLoop > 1) {
			s->next = old;
			old->prev = s;
		} else if (doLoop) {
			s->next = s;
		}
		old->vol = -1;
		playSoundList(old);
		return BR_CONTINUE;
	}
}

builtIn(stopSound)
{
	UNUSEDALL
	int v;
	if (! getValueType(&v, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	huntKillSound (v);
	return BR_CONTINUE;
}

builtIn(setDefaultSoundVolume)
{
	UNUSEDALL
	int v;
	if (! getValueType(&v, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setDefaultSoundVolume (v);
	return BR_CONTINUE;
}

builtIn(setSoundVolume)
{
	UNUSEDALL
	int musChan, v;
	if (! getValueType(&v, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&musChan, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setSoundVolume (musChan, v);
	return BR_CONTINUE;
}


builtIn(setSoundLoopPoints)
{
	UNUSEDALL
	int musChan, theEnd, theStart;
	if (! getValueType(&theEnd, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&theStart, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&musChan, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setSoundLoop (musChan, theStart, theEnd);
	return BR_CONTINUE;
}

#pragma mark -
#pragma mark Extra room bits

builtIn(setFloor)
{
	KPrintF("running setFloor\n");
	UNUSEDALL
	if (fun -> stack -> thisVar.varType == SVT_FILE) {
		int v;
		getValueType(&v, SVT_FILE,&fun -> stack -> thisVar);
		trimStack (&fun -> stack);
		if (! setFloor (v)) return BR_ERROR;
	} else {
		trimStack (&fun -> stack);
		setFloorNull ();
	}
	return BR_CONTINUE;
}

builtIn(showFloor)
{
	KPrintF("running showFloor\n");
	UNUSEDALL
	drawFloor ();
	return BR_CONTINUE;
}

builtIn(setZBuffer)
{
	KPrintF("running setZBuffer\n");
	UNUSEDALL
	if (fun -> stack -> thisVar.varType == SVT_FILE) {
		int v;
		getValueType(&v, SVT_FILE,&fun -> stack -> thisVar);
		trimStack (&fun -> stack);
		if (! setZBuffer (v)) return BR_ERROR;
	} else {
		trimStack (&fun -> stack);
		killZBuffer ();
	}
	return BR_CONTINUE;
}

builtIn(setLightMap)
{
	KPrintF("running setLightMap\n");
	UNUSEDALL
	/*switch (numParams) {
		case 2:
			if (! getValueType(&lightMapMode, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
			trimStack (&fun -> stack);
			lightMapMode %= LIGHTMAPMODE_NUM;
			// No break;

		case 1:
			if (fun -> stack -> thisVar.varType == SVT_FILE) {
				int v;
				getValueType(&v, SVT_FILE,&fun -> stack -> thisVar);
				trimStack (&fun -> stack);
				if (! loadLightMap (v)) return BR_ERROR;
				setVariable (&fun -> reg, SVT_INT, 1);
			} else {
				trimStack (&fun -> stack);
				killLightMap ();
				setVariable (&fun -> reg, SVT_INT, 0);
			}
			break;

		default:
			fatal ("Function should have either 2 or 3 parameters");
			return BR_ERROR;
	}*/
	KPrintF("Not implemented on Amiga");
	return BR_CONTINUE;
}


#pragma mark -
#pragma mark Objects

builtIn(setSpeechMode)
{
	KPrintF("running setSpeechMode\n");
	UNUSEDALL
	if (! getValueType(&speechMode, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (speechMode < 0 || speechMode > 2) {
		KPrintF ("Valid parameters are be SPEECHANDTEXT, SPEECHONLY or TEXTONLY");
		return BR_ERROR;
	}
	return BR_CONTINUE;
}

builtIn(somethingSpeaking)
{
	KPrintF("running somethingSpeaking\n");
	UNUSEDALL
	int i = isThereAnySpeechGoingOn ();
	if (i == -1) {
		setVariable (&fun -> reg, SVT_INT, 0);
	} else {
		setVariable (&fun -> reg, SVT_OBJTYPE, i);
	}
	return BR_CONTINUE;
}

builtIn(skipSpeech)
{
	KPrintF("running skipSpeech\n");
	UNUSEDALL
	killSpeechTimers ();
	return BR_CONTINUE;
}

builtIn(getOverObject)
{
	KPrintF("running getOverObject\n");
	UNUSEDALL
	if (overRegion)
		// Return value
		setVariable (&fun -> reg, SVT_OBJTYPE, overRegion -> thisType -> objectNum);
	else
		// Return value
		setVariable (&fun -> reg, SVT_INT, 0);
	return BR_CONTINUE;
}

builtIn(rename)
{
	KPrintF("running rename\n");
	UNUSEDALL
	char * newText = getTextFromAnyVar(&(fun->stack->thisVar));
	int objT;
	if (!newText) return BR_ERROR;
	trimStack(&fun->stack);
	if (!getValueType(&objT, SVT_OBJTYPE, &fun->stack->thisVar)) return BR_ERROR;
	trimStack(&fun->stack);
	struct objectType * o = findObjectType(objT);
	FreeVec(o->screenName);
	o->screenName = newText;
	return BR_CONTINUE;
}

builtIn (getObjectX)
{
	KPrintF("running getObjectX\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	struct onScreenPerson * pers = findPerson (objectNumber);
	if (pers) {
		setVariable (&fun -> reg, SVT_INT, pers -> x);
	} else {
		struct screenRegion * la = getRegionForObject (objectNumber);
		if (la) {
			setVariable (&fun -> reg, SVT_INT, la -> sX);
		} else {
			setVariable (&fun -> reg, SVT_INT, 0);
		}
	}
	return BR_CONTINUE;
}

builtIn (getObjectY)
{
	KPrintF("running getObjectY\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	struct onScreenPerson * pers = findPerson (objectNumber);
	if (pers) {
		setVariable (&fun -> reg, SVT_INT, pers -> y);
	} else {
		struct screenRegion * la = getRegionForObject (objectNumber);
		if (la) {
			setVariable (&fun -> reg, SVT_INT, la -> sY);
		} else {
			setVariable (&fun -> reg, SVT_INT, 0);
		}
	}
	return BR_CONTINUE;
}


builtIn(addScreenRegion)
{
	KPrintF("running addScreenRegion\n");
	UNUSEDALL
	int sX, sY, x1, y1, x2, y2, di, objectNumber;
	if (! getValueType(&di, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&sY, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&sX, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&y2, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x2, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&y1, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x1, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (addScreenRegion (x1, y1, x2, y2, sX, sY, di, objectNumber)) return BR_CONTINUE;
	return BR_ERROR;

}

builtIn(removeScreenRegion)
{
	KPrintF("running removeScreenRegion\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	removeScreenRegion (objectNumber);
	return BR_CONTINUE;
}

builtIn(showBoxes)
{
	KPrintF("running showBoxes\n");
	UNUSEDALL
	showBoxes ();
	return BR_CONTINUE;
}

builtIn(removeAllScreenRegions)
{
	KPrintF("running removeAllScreenRegions\n");
	UNUSEDALL
	killAllRegions ();
	return BR_CONTINUE;
}

builtIn(addCharacter)
{
	KPrintF("running addCharacter\n");
	UNUSEDALL
	struct persona * p;
	int x, y, objectNumber;

	p = getCostumeFromVar (&(fun -> stack -> thisVar));
	if (p == NULL) return BR_ERROR;

	trimStack (&fun -> stack);
	if (! getValueType(&y, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (addPerson (x, y, objectNumber, p)) return BR_CONTINUE;
	return BR_ERROR;
}

builtIn(hideCharacter)
{
	KPrintF("running hideCharacter\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setShown (FALSE, objectNumber);
	return BR_CONTINUE;
}

builtIn(showCharacter)
{
	KPrintF("running showCharacter\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setShown (TRUE, objectNumber);
	return BR_CONTINUE;
}

builtIn(removeAllCharacters)
{
	KPrintF("running removeAllCharacters\n");
	UNUSEDALL
	killSpeechTimers ();
	killMostPeople ();
	return BR_CONTINUE;
}

builtIn(setCharacterDrawMode)
{
	KPrintF("running setCharacterDrawMode\n");
	UNUSEDALL
	int obj, di;
	if (! getValueType(&di, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setDrawMode (di, obj);
	return BR_CONTINUE;
}

builtIn(setCharacterTransparency)
{
	KPrintF("running setCharacterTransparency\n");
	UNUSEDALL
	KPrintF("setCharacterTransparency: Not implemented on Amiga");
	return BR_CONTINUE;
}

builtIn(setCharacterColourise)
{
	KPrintF("running setCharacterColourise\n");
	UNUSEDALL
	KPrintF("setCharacterColourise: Currently not implemented on Amiga");
	/*int obj, r, g, b, mix;
	if (! getValueType(&mix, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&b, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&g, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&r, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setPersonColourise (obj, r, g, b, mix);*/
	return BR_CONTINUE;
}

builtIn(setScale)
{
	KPrintF("running setScale\n");
	UNUSEDALL
	int val1, val2;
	if (! getValueType(&val2, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&val1, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setScale ((short int) val1, (short int) val2);
	return BR_CONTINUE;
}

builtIn(stopCharacter)
{
	KPrintF("running stopCharacter\n");
	UNUSEDALL
	int obj;
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	// Return value
	setVariable (&fun -> reg, SVT_INT, stopPerson (obj));
	return BR_CONTINUE;
}

builtIn(pasteCharacter)
{
	KPrintF("running pasteCharacter\n");
	UNUSEDALL
	/*int obj;
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	struct onScreenPerson * thisPerson = findPerson (obj);
	if (thisPerson) {
		struct personaAnimation * myAnim;
		myAnim = thisPerson -> myAnim;
		if (myAnim != thisPerson -> lastUsedAnim) {
			thisPerson -> lastUsedAnim = myAnim;
			thisPerson -> frameNum = 0;
			thisPerson -> frameTick = myAnim -> frames[0].howMany;
		}

		int fNum = myAnim -> frames[thisPerson -> frameNum].frameNum;
		fixScaleSprite (thisPerson -> x, thisPerson -> y, myAnim -> theSprites -> bank.sprites[abs (fNum)], myAnim -> theSprites -> bank.myPalette, thisPerson, 0, 0, fNum < 0);
		setVariable (&fun -> reg, SVT_INT, 1);
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
	} Todo: Amigize this*/
	KPrintF("Not implemented yet for Amiga");
	return BR_CONTINUE;
}

builtIn(animate)
{
	KPrintF("running animate\n");
	UNUSEDALL
	int obj;
	struct personaAnimation * pp = getAnimationFromVar (&(fun -> stack -> thisVar));
	if (pp == NULL) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	animatePerson (obj, pp);
	setVariable (&fun -> reg, SVT_INT, timeForAnim (pp));
	return BR_CONTINUE;
}

builtIn(setCostume)
{
	KPrintF("running setCostume\n");
	UNUSEDALL
	int obj;
	struct persona * pp = getCostumeFromVar(&(fun -> stack -> thisVar));
	if (pp == NULL) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	animatePersonUsingPersona(obj, pp);
	return BR_CONTINUE;
}

builtIn(floatCharacter)
{
	KPrintF("running floatCharacter\n");
	UNUSEDALL
	int obj, di;
	if (! getValueType(&di, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, floatCharacter (di, obj));
	return BR_CONTINUE;
}

builtIn(setCharacterWalkSpeed)
{
	KPrintF("running setCharacterWalkSpeed\n");
	UNUSEDALL
	int obj, di;
	if (! getValueType(&di, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, setCharacterWalkSpeed (di, obj));
	return BR_CONTINUE;
}

builtIn(turnCharacter)
{
	KPrintF("running turnCharacter\n");
	UNUSEDALL
	int obj, di;
	if (! getValueType(&di, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, turnPersonToFace (obj, di));
	return BR_CONTINUE;
}

builtIn(setCharacterExtra)
{
	KPrintF("running setCharacterExtra\n");
	UNUSEDALL
	int obj, di;
	if (! getValueType(&di, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, setPersonExtra (obj, di));
	return BR_CONTINUE;
}

builtIn(removeCharacter)
{	
	KPrintF("running removeCharacter\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	removeOneCharacter (objectNumber);
	return BR_CONTINUE;
}

static enum builtReturn moveChr(int numParams, struct loadedFunction * fun, BOOL force, BOOL immediate)
{
	switch (numParams) {
		case 3:
		{
			int x, y, objectNumber;

			if (! getValueType(&y, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
			trimStack (&fun -> stack);
			if (! getValueType(&x, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
			trimStack (&fun -> stack);
			if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
			trimStack (&fun -> stack);

			if (force) {
				if (forceWalkingPerson (x, y, objectNumber, fun, -1)) return BR_PAUSE;
			} else if (immediate) {
				jumpPerson (x, y, objectNumber);
			} else {
				if (makeWalkingPerson (x, y, objectNumber, fun, -1)) return BR_PAUSE;
			}
			return BR_CONTINUE;
		}

		case 2:
		{
			int toObj, objectNumber;
			struct screenRegion * reggie;

			if (! getValueType(&toObj, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
			trimStack (&fun -> stack);
			if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
			trimStack (&fun -> stack);
			reggie = getRegionForObject (toObj);
			if (reggie == NULL) return BR_CONTINUE;

			if (force)
			{
				if (forceWalkingPerson (reggie -> sX, reggie -> sY,	objectNumber, fun, reggie -> di)) return BR_PAUSE;
			}
			else if (immediate)
			{
				jumpPerson (reggie -> sX, reggie -> sY,	objectNumber);
			}
			else
			{
				if (makeWalkingPerson (reggie -> sX, reggie -> sY, objectNumber, fun, reggie -> di)) return BR_PAUSE;
			}
			return BR_CONTINUE;
		}

		default:
			KPrintF ("Built-in function must have either 2 or 3 parameters.");
			return BR_ERROR;
	}
}

builtIn(moveCharacter)
{
	KPrintF("running moveCharacter\n");
	UNUSEDALL
	return moveChr(numParams, fun, FALSE, FALSE);
}

builtIn(forceCharacter)
{
	KPrintF("running forceCharacter\n");
	UNUSEDALL
	return moveChr(numParams, fun, TRUE, FALSE);
}

builtIn(jumpCharacter)
{
	KPrintF("running jumpCharacter\n");
	UNUSEDALL
	return moveChr(numParams, fun, FALSE, TRUE);
}

builtIn(clearStatus)
{
	KPrintF("running clearStatus\n");
	UNUSEDALL
	clearStatusBar ();
	return BR_CONTINUE;
}

builtIn(removeLastStatus)
{
	KPrintF("running removeLastStatus\n");
	UNUSEDALL
	killLastStatus ();
	return BR_CONTINUE;
}

builtIn(addStatus)
{
	KPrintF("running addStatus\n");
	UNUSEDALL
	addStatusBar ();
	return BR_CONTINUE;
}

builtIn(statusText)
{
	KPrintF("running statusText\n");
	UNUSEDALL
	char * newText = getTextFromAnyVar(&(fun->stack->thisVar));
	if (!newText) return BR_ERROR;
	trimStack(&fun->stack);
	setStatusBar(newText);
	FreeVec(newText);
	return BR_CONTINUE;
}

builtIn(lightStatus)
{
	KPrintF("running lightStatus\n");
	UNUSEDALL
	int val;
	if (! getValueType(&val, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setLitStatus (val);
	return BR_CONTINUE;
}

builtIn(positionStatus)
{
	KPrintF("running positionStatus\n");
	UNUSEDALL
	int x, y;
	if (! getValueType(&y, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	positionStatus (x, y);
	return BR_CONTINUE;
}

builtIn(alignStatus)
{
	KPrintF("running alignStatus\n");
	UNUSEDALL
	int val;
	if (! getValueType(&val, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	nowStatus -> alignStatus = (short) val;
	return BR_CONTINUE;
}

static BOOL getFuncNumForCallback(int numParams, struct loadedFunction * fun, int *functionNum)
{
	switch (numParams) {
		case 0:
			*functionNum = 0;
			break;

		case 1:
			if (! getValueType(functionNum, SVT_FUNC,&fun -> stack -> thisVar)) return FALSE;
			trimStack (&fun -> stack);
			break;

		default:
			KPrintF ("Too many parameters.");
			return FALSE;
	}
	return TRUE;
}

builtIn (onLeftMouse)
{
	KPrintF("running onLeftMouse\n");
	UNUSEDALL
	int functionNum;
	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		currentEvents -> leftMouseFunction = functionNum;
		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn (onLeftMouseUp)
{
	KPrintF("running onLeftMouseUp\n");
	UNUSEDALL
	int functionNum;
	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		currentEvents -> leftMouseUpFunction = functionNum;
		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn (onRightMouse)
{
	KPrintF("running onRightMouse\n");
	UNUSEDALL
	int functionNum;
	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		currentEvents -> rightMouseFunction = functionNum;
		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn (onRightMouseUp)
{
	KPrintF("running onRightMouseUp\n");
	UNUSEDALL
	int functionNum;
	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		currentEvents -> rightMouseUpFunction = functionNum;
		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn (onFocusChange)
{
	KPrintF("running onFocusChange\n");
	UNUSEDALL
	int functionNum;	

	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		struct loadedFunction *oldfunc = currentEvents -> focusFunction;
		if( functionNum != NULL) 
			currentEvents -> focusFunction = preloadNewFunctionNum(functionNum);		
		else
			currentEvents -> focusFunction = NULL;

		if( oldfunc != NULL && oldfunc != currentEvents -> focusFunction )
		{
			unloadFunction(oldfunc);
		}
		

		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn (onMoveMouse)
{
	KPrintF("running onMoveMouse\n");
	UNUSEDALL
	int functionNum;
	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		currentEvents -> moveMouseFunction = functionNum;
		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn (onKeyboard)
{
	KPrintF("running onKeyboard\n");
	UNUSEDALL
	int functionNum;
	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		currentEvents -> spaceFunction = functionNum;
		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn (spawnSub)
{
	KPrintF("running spawnSub\n");
	UNUSEDALL
	int functionNum;
	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		if (! startNewFunctionNum (functionNum, 0, NULL, noStack, TRUE)) return BR_ERROR;
		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn (cancelSub)
{
	KPrintF("running cancelSub\n");
	UNUSEDALL
	int functionNum;
	if (getFuncNumForCallback (numParams, fun, &functionNum))
	{
		BOOL killedMyself;
		cancelAFunction (functionNum, fun, &killedMyself);
		if (killedMyself) {
			abortFunction (fun);
			return BR_ALREADY_GONE;
		}
		return BR_CONTINUE;
	}
	return BR_ERROR;
}

builtIn(stringWidth)
{
	KPrintF("running stringWidth\n");
	UNUSEDALL
	char * theText = getTextFromAnyVar(&(fun->stack->thisVar));
	if (!theText) return BR_ERROR;
	trimStack(&fun->stack);

	// Return value
	setVariable(&fun->reg, SVT_INT, stringWidth(theText));
	FreeVec(theText);
	return BR_CONTINUE;
}

builtIn(hardScroll)
{
	KPrintF("running hardScroll\n");
	UNUSEDALL
	int v;
	if (! getValueType(&v, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	hardScroll (v);
	return BR_CONTINUE;
}


builtIn(isScreenRegion)
{
	KPrintF("running isScreenRegion\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, getRegionForObject (objectNumber) != NULL);
	return BR_CONTINUE;
}

builtIn(setSpeechSpeed)
{
	KPrintF("running setSpeechSpeed\n");
	UNUSEDALL
	int number;
	if (! getValueType(&number, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	speechSpeed = number * (FLOAT) 0.01;
	setVariable (&fun -> reg, SVT_INT, 1);
	return BR_CONTINUE;
}

builtIn(setFontSpacing)
{
	KPrintF("running setFontSpacing\n");
	UNUSEDALL
	int fontSpaceI;
	if (! getValueType(&fontSpaceI, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	fontSpace = fontSpaceI;
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, 1);
	return BR_CONTINUE;
}

builtIn(transitionLevel)
{
	KPrintF("running transitionLevel\n");
	UNUSEDALL
	int number;
	if (! getValueType(&number, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	if (number < 0)
		brightnessLevel = 0;
	else if (number > 255)
		brightnessLevel = 255;
	else
		brightnessLevel = number;

	setVariable (&fun -> reg, SVT_INT, 1);
	return BR_CONTINUE;
}

builtIn(captureAllKeys)
{
	KPrintF("running captureAllKeys\n");
	UNUSEDALL
	captureAllKeys = getBoolean(&(fun -> stack -> thisVar));
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, captureAllKeys);
	return BR_CONTINUE;
}


builtIn(spinCharacter)
{
	KPrintF("running spinCharacter\n");
	UNUSEDALL
	int number, objectNumber;
	if (! getValueType(&number, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	struct onScreenPerson * thisPerson = findPerson (objectNumber);
	if (thisPerson) {
		thisPerson -> wantAngle = number;
		thisPerson -> spinning = TRUE;
		thisPerson -> continueAfterWalking = fun;
		setVariable (&fun -> reg, SVT_INT, 1);
		return BR_PAUSE;
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
		return BR_CONTINUE;
	}
}

builtIn(getCharacterDirection)
{
	KPrintF("running getCharacterDirection\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	struct onScreenPerson * thisPerson = findPerson (objectNumber);
	if (thisPerson) {
		setVariable (&fun -> reg, SVT_INT, thisPerson -> direction);
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
	}
	return BR_CONTINUE;
}

builtIn(isCharacter)
{
	KPrintF("running isCharacter\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	struct onScreenPerson * thisPerson = findPerson (objectNumber);
	setVariable (&fun -> reg, SVT_INT, thisPerson != NULL);
	return BR_CONTINUE;
}

builtIn(normalCharacter)
{
	KPrintF("running normalCharacter\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	struct onScreenPerson * thisPerson = findPerson (objectNumber);
	if (thisPerson)
	{
		thisPerson -> myAnim = thisPerson -> myPersona -> animation[thisPerson -> direction];
		setVariable (&fun -> reg, SVT_INT, 1);
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
	}
	return BR_CONTINUE;
}

builtIn(isMoving)
{
	KPrintF("running isMoving\n");
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	struct onScreenPerson * thisPerson = findPerson (objectNumber);
	if (thisPerson)
	{
		setVariable (&fun -> reg, SVT_INT, thisPerson -> walking);
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
	}
	return BR_CONTINUE;
}

builtIn(fetchEvent)
{
	KPrintF("running fetchEvent\n");
	UNUSEDALL
	int obj1, obj2;
	if (! getValueType(&obj2, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&obj1, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	int fNum = getCombinationFunction (obj1, obj2);

	// Return value
	if (fNum) {
		setVariable (&fun -> reg, SVT_FUNC, fNum);
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
	}
	return BR_CONTINUE;
}

builtIn(deleteFile)
{
	KPrintF("running deleteFile\n");
    UNUSEDALL

    char *namNormal = getTextFromAnyVar(&(fun->stack->thisVar));
    trimStack(&fun->stack);
    char *nam = encodeFilename(namNormal);
    FreeVec(namNormal);
    if (failSecurityCheck(nam)) return BR_ERROR;
    setVariable(&fun->reg, SVT_INT, DeleteFile(nam));
    FreeVec(nam);

    return BR_CONTINUE;
}

builtIn(renameFile)
{
	KPrintF("running renameFile\n");
	UNUSEDALL
	char * temp;

	temp = getTextFromAnyVar(&(fun->stack->thisVar));
	char * newnam = encodeFilename(temp);
	trimStack(&fun->stack);
	if (failSecurityCheck(newnam)) return BR_ERROR;
	FreeVec(temp);

	temp = getTextFromAnyVar(&(fun->stack->thisVar));
	char * nam = encodeFilename(temp);
	trimStack(&fun->stack);
	if (failSecurityCheck(nam)) return BR_ERROR;
	FreeVec(temp);

	setVariable(&fun->reg, SVT_INT, Rename(nam, newnam));
	FreeVec(nam);
	FreeVec(newnam);

	return BR_CONTINUE;
}

builtIn(cacheSound)
{
	KPrintF("running cacheSound\n");
	UNUSEDALL
	int fileNumber;
	if (! getValueType(&fileNumber, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (cacheSound (fileNumber) == -1) return BR_ERROR;
	return BR_CONTINUE;
}

builtIn(burnString)
{
	KPrintF("running burnString\n");
	UNUSEDALL
	/*char * newText = getTextFromAnyVar(&(fun -> stack -> thisVar));
	trimStack (&fun -> stack);
	int y, x;
	if (! getValueType(&y, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (x == IN_THE_CENTRE) x = (winWidth - stringWidth (newText)) >> 1;
	fixFont (pastePalette);
	burnStringToBackdrop (newText, x, y, pastePalette);
	delete[] newText; Todo: Amigize this*/
	KPrintF("burnString: Not implemented for Amiga yet");
	return BR_CONTINUE;
}

builtIn(setCharacterSpinSpeed)
{
	KPrintF("running setCharacterSpinSpeed\n");
	UNUSEDALL
	int speed, who;
	if (! getValueType(&speed, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&who, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	struct onScreenPerson * thisPerson = findPerson (who);

	if (thisPerson) {
		thisPerson -> spinSpeed = speed;
		setVariable (&fun -> reg, SVT_INT, 1);
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
	}
	return BR_CONTINUE;
}

builtIn(setCharacterAngleOffset)
{
	KPrintF("running setCharacterAngleOffset\n");
	UNUSEDALL
	int angle, who;
	if (! getValueType(&angle, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&who, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	struct onScreenPerson * thisPerson = findPerson (who);

	if (thisPerson) {
		thisPerson -> angleOffset = angle;
		setVariable (&fun -> reg, SVT_INT, 1);
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
	}
	return BR_CONTINUE;
}


builtIn(transitionMode)
{
	KPrintF("running transitionMode\n");
	UNUSEDALL
	int n;
	if (! getValueType(&n, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	fadeMode = n;
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, 1);
	return BR_CONTINUE;
}


// Removed function - does nothing
builtIn(_rem_updateDisplay)
{
	UNUSEDALL
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, TRUE);
	return BR_CONTINUE;
}

builtIn(getSoundCache)
{
	UNUSEDALL
	/*fun -> reg.varType = SVT_STACK;
	fun -> reg.varData.theStack = new stackHandler;
	if (! checkNew (&fun -> reg.varData.theStack)) return BR_ERROR;
	fun -> reg.varData.theStack -> first = NULL;
	fun -> reg.varData.theStack -> last = NULL;
	fun -> reg.varData.theStack -> timesUsed = 1;
	if (! getSoundCacheStack (&fun -> reg.varData.theStack)) return BR_ERROR; Todo: Amigize this?*/
	KPrintF("getSoundCache: Not implemented yet for Amiga");
	return BR_CONTINUE;
}

builtIn(saveCustomData)
{
	KPrintF("running saveCustomData\n");
	UNUSEDALL
	// saveCustomData (thisStack, fileName);
	char * fileNameB = getTextFromAnyVar(&(fun->stack->thisVar));
	if (!fileNameB) return BR_ERROR;

	char * fileName = encodeFilename(fileNameB);
	FreeVec(fileNameB);

	if (failSecurityCheck(fileName)) return BR_ERROR;
	trimStack(&fun->stack);

	if (fun->stack->thisVar.varType != SVT_STACK) {
		KPrintF("First parameter isn't a stack");
		return BR_ERROR;
	}
	if (!stackToFile(fileName, &fun->stack->thisVar)) return BR_ERROR;
	trimStack(&fun->stack);
	FreeVec(fileName);
	return BR_CONTINUE;
}

builtIn(loadCustomData)
{
	KPrintF("running loadCustomData\n");
	UNUSEDALL

	char * newTextA = getTextFromAnyVar(&(fun->stack->thisVar));
	if (!newTextA) return BR_ERROR;

	char * newText = encodeFilename(newTextA);
	FreeVec(newTextA);

	if (failSecurityCheck(newText)) return BR_ERROR;
	trimStack(&fun->stack);

	unlinkVar(&fun->reg);
	fun->reg.varType = SVT_STACK;
	fun->reg.varData.theStack = AllocVec(sizeof(struct stackHandler), MEMF_ANY);
	if (!fun->reg.varData.theStack) return BR_ERROR;
	fun->reg.varData.theStack->first = NULL;
	fun->reg.varData.theStack->last = NULL;
	fun->reg.varData.theStack->timesUsed = 1;
	if (!fileToStack(newText, fun->reg.varData.theStack)) return BR_ERROR;
	FreeVec(newText);
	return BR_CONTINUE;
}

builtIn(setCustomEncoding)
{
	KPrintF("running setCustomEncoding\n");
	UNUSEDALL
	int n;
	if (! getValueType(&n, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	saveEncoding = n;
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, 1);
	return BR_CONTINUE;
}

builtIn(freeSound)
{
	UNUSEDALL
	int v;
	if (! getValueType(&v, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	huntKillFreeSound (v);
	return BR_CONTINUE;
}

builtIn(parallaxAdd)
{
	UNUSEDALL
	/*if (frozenStuff) {
		fatal ("Can't set background parallax image while frozen");
		return BR_ERROR;
	} else { Todo: Amigize this*/
		int wrapX, wrapY, v;
		if (! getValueType(&wrapY, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
		trimStack (&fun -> stack);
		if (! getValueType(&wrapX, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
		trimStack (&fun -> stack);
		if (! getValueType(&v, SVT_FILE,&fun -> stack -> thisVar)) return BR_ERROR;
		trimStack (&fun -> stack);

		if (! loadParallax (v, wrapX, wrapY)) return BR_ERROR;
		setVariable (&fun -> reg, SVT_INT, 1);
	//}
	return BR_CONTINUE;
}

builtIn(parallaxClear)
{
	UNUSEDALL
	killParallax ();
	setVariable (&fun -> reg, SVT_INT, 1);
	return BR_CONTINUE;
}

builtIn(getPixelColour)
{
	UNUSEDALL
	/*int x, y;
	if (! getValueType(&y, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	unlinkVar (&fun -> reg);
	fun -> reg.varType = SVT_STACK;
	fun -> reg.varData.theStack = new stackHandler;
	if (! checkNew (&fun -> reg.varData.theStack)) return BR_ERROR;
	fun -> reg.varData.theStack -> first = NULL;
	fun -> reg.varData.theStack -> last = NULL;
	fun -> reg.varData.theStack -> timesUsed = 1;
	if (! getRGBIntoStack (x, y, &fun -> reg.varData.theStack)) return BR_ERROR; Todo: Amigize this*/
	KPrintF("getPixelColor: Not implemented for Amiga");

	return BR_CONTINUE;
}

builtIn(makeFastArray)
{
	UNUSEDALL
	switch (fun -> stack -> thisVar.varType) {
		case SVT_STACK:
		{
			BOOL success = makeFastArrayFromStack (&fun -> reg, fun -> stack -> thisVar.varData.theStack);
			trimStack (&fun -> stack);
			return success ? BR_CONTINUE : BR_ERROR;
		}
			break;

		case SVT_INT:
		{
			int i = fun -> stack -> thisVar.varData.intValue;
			trimStack (&fun -> stack);
			return makeFastArraySize (&fun -> reg, i) ? BR_CONTINUE : BR_ERROR;
		}
			break;

		default:
			break;
	}
	KPrintF ("Parameter must be a number or a stack.");
	return BR_ERROR;
}

builtIn(getCharacterScale)
{
	UNUSEDALL
	int objectNumber;
	if (! getValueType(&objectNumber, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	struct onScreenPerson * pers = findPerson (objectNumber);
	if (pers) {
		setVariable (&fun -> reg, SVT_INT, pers -> scale * (FLOAT) 100); 
	} else {
		setVariable (&fun -> reg, SVT_INT, 0);
	}
	return BR_CONTINUE;
}

builtIn(getLanguageID)
{
	UNUSEDALL
	setVariable (&fun -> reg, SVT_INT, gameSettings.languageID);
	return BR_CONTINUE;
}

// Removed function
builtIn(_rem_launchWith)
{
	UNUSEDALL

	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, FALSE);

	return BR_CONTINUE;

}

builtIn(getFramesPerSecond)
{
	UNUSEDALL
	setVariable (&fun -> reg, SVT_INT, lastFramesPerSecond);
	return BR_CONTINUE;
}

builtIn(showThumbnail)
{
	UNUSEDALL
	/*int x, y;
	if (! getValueType(&y, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&x, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);

	// Encode the name! Encode the name!
	char * aaaaa = getTextFromAnyVar(&(fun -> stack -> thisVar));
	//				deb ("Got name:", aaaaa;)
	trimStack (&fun -> stack);
	//				deb ("About to encode", aaaaa);
	char * file = encodeFilename (aaaaa);
	//				deb ("Made new name", file);
	//				deb ("aaaaa is still ", aaaaa);
	delete[] aaaaa;
	//				deb ("Deleted", "aaaaa");
	showThumbnail (file, x, y);
	delete[] file; Todo Amigize this?*/
	return BR_CONTINUE;
}

builtIn(setThumbnailSize)
{
	UNUSEDALL
	if (! getValueType(&thumbHeight, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&thumbWidth, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (thumbWidth < 0 || thumbHeight < 0 || (unsigned int) thumbWidth > winWidth || (unsigned int) thumbHeight > winHeight) {
		char buff[50];
		sprintf (buff, "%d x %d", thumbWidth, thumbHeight);
		KPrintF ("Invalid thumbnail size", buff);
		return BR_ERROR;
	}
	return BR_CONTINUE;
}

builtIn(hasFlag)
{
	UNUSEDALL
	int objNum, flagIndex;
	if (! getValueType(&flagIndex, SVT_INT,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	if (! getValueType(&objNum, SVT_OBJTYPE,&fun -> stack -> thisVar)) return BR_ERROR;
	trimStack (&fun -> stack);
	struct objectType * objT = findObjectType (objNum);
	if (! objT) return BR_ERROR;
	setVariable (&fun -> reg, SVT_INT, objT->flags & (1 << flagIndex));
	return BR_CONTINUE;
}

builtIn(snapshotGrab)
{
	UNUSEDALL
	return snapshot () ? BR_CONTINUE : BR_ERROR;
}

builtIn(snapshotClear)
{
	UNUSEDALL
	nosnapshot ();
	return BR_CONTINUE;
}

builtIn(bodgeFilenames)
{
	UNUSEDALL
	BOOL lastValue = allowAnyFilename;
	allowAnyFilename = getBoolean(&(fun -> stack -> thisVar));
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, lastValue);
	return BR_CONTINUE;
}

// Deprecated - does nothing.
builtIn(_rem_registryGetString)
{
	UNUSEDALL
	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	setVariable (&fun -> reg, SVT_INT, 0);

	return BR_CONTINUE;
}

builtIn(quitWithFatalError)
{
	UNUSEDALL
	char * mess = getTextFromAnyVar(&(fun -> stack -> thisVar));
	trimStack (&fun -> stack);
	KPrintF (mess);
	return BR_ERROR;
}

builtIn(_rem_setCharacterAA)
{
	UNUSEDALL

	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	trimStack (&fun -> stack);

	return BR_CONTINUE;
}

builtIn(_rem_setMaximumAA)
{
	UNUSEDALL

	trimStack (&fun -> stack);
	trimStack (&fun -> stack);
	trimStack (&fun -> stack);

	return BR_CONTINUE;

}

builtIn(setBackgroundEffect)
{
	UNUSEDALL
	BOOL done = TRUE;
	//BOOL done = blur_createSettings(numParams, fun->stack); Amiga Todo: Amigize?
	setVariable (&fun -> reg, SVT_INT, done ? 1 : 0);
	return BR_CONTINUE;
}

builtIn(doBackgroundEffect)
{
	UNUSEDALL
	//BOOL done = blurScreen ();
	BOOL done = TRUE;
	KPrintF("doBackgroundEffect: Function not implemented on Amiga");
	//Amiga Todo: Amigize this
	setVariable (&fun -> reg, SVT_INT, done ? 1 : 0);
	return BR_CONTINUE;
}

#define FUNC(special,name)		{builtIn_ ## name},
static struct builtInFunctionData builtInFunctionArray[] =
{
FUNC (TRUE, say)
FUNC (TRUE, skipSpeech)
FUNC (TRUE, statusText)
FUNC (TRUE, pause)
FUNC (TRUE, onLeftMouse)
FUNC (TRUE, onRightMouse)
FUNC (TRUE, setCursor)
FUNC (TRUE, addOverlay)
FUNC (TRUE, addCharacter)
FUNC (TRUE, playSound)
FUNC (TRUE, getMouseX)
FUNC (TRUE, getMouseY)
FUNC (TRUE, addScreenRegion)
FUNC (TRUE, onMoveMouse)
FUNC (TRUE, onFocusChange)
FUNC (TRUE, getOverObject)
FUNC (TRUE, blankScreen)
FUNC (TRUE, moveCharacter)
FUNC (TRUE, onKeyboard)
FUNC (TRUE, getObjectX)
FUNC (TRUE, getObjectY)
FUNC (TRUE, random)
FUNC (TRUE, spawnSub)
FUNC (TRUE, blankArea)
FUNC (TRUE, hideCharacter)
FUNC (TRUE, showCharacter)
FUNC (TRUE, callEvent)
FUNC (TRUE, removeScreenRegion)
FUNC (TRUE, animate)
FUNC (TRUE, turnCharacter)
FUNC (TRUE, removeAllCharacters)
FUNC (TRUE, removeAllScreenRegions)
FUNC (TRUE, setScale)
FUNC (TRUE, newStack)
FUNC (TRUE, pushToStack)
FUNC (TRUE, popFromStack)
FUNC (TRUE, clearStatus)
FUNC (TRUE, addStatus)
FUNC (TRUE, removeLastStatus)
FUNC (TRUE, lightStatus)
FUNC (TRUE, getStatusText)
FUNC (TRUE, setStatusColour)
FUNC (TRUE, deleteFromStack)
FUNC (TRUE, freeze)
FUNC (TRUE, unfreeze)
FUNC (TRUE, pasteImage)
FUNC (TRUE, copyStack)
FUNC (TRUE, completeTimers)
FUNC (TRUE, setCharacterDrawMode)
FUNC (TRUE, anim)
FUNC (TRUE, costume)
FUNC (TRUE, pickOne)
FUNC (TRUE, setCostume)
FUNC (TRUE, wait)
FUNC (TRUE, somethingSpeaking)
FUNC (TRUE, substring)
FUNC (TRUE, stringLength)
FUNC (TRUE, darkBackground)
FUNC (TRUE, saveGame)
FUNC (TRUE, loadGame)
FUNC (TRUE, quitGame)
FUNC (TRUE, rename)
FUNC (TRUE, stackSize)
FUNC (TRUE, pasteString)
FUNC (TRUE, startMusic)
FUNC (TRUE, setDefaultMusicVolume)	
FUNC (TRUE, setMusicVolume)	
FUNC (TRUE, stopMusic)
FUNC (TRUE, stopSound)
FUNC (TRUE, setFont)
FUNC (TRUE, alignStatus)
FUNC (TRUE, showFloor)
FUNC (TRUE, showBoxes)
FUNC (TRUE, positionStatus)
FUNC (TRUE, setFloor)
FUNC (TRUE, forceCharacter)
FUNC (TRUE, jumpCharacter)
FUNC (TRUE, peekStart)
FUNC (TRUE, peekEnd)
FUNC (TRUE, enqueue)
FUNC (TRUE, setZBuffer)
FUNC (TRUE, getMatchingFiles)
FUNC (TRUE, inFont)
FUNC (TRUE, onLeftMouseUp)
FUNC (TRUE, onRightMouseUp)
FUNC (TRUE, loopSound)
FUNC (TRUE, removeCharacter)
FUNC (TRUE, stopCharacter)
FUNC (TRUE, launch)
FUNC (TRUE, howFrozen)
FUNC (TRUE, setPasteColour)
FUNC (TRUE, setLitStatusColour)
FUNC (TRUE, fileExists)
FUNC (TRUE, floatCharacter)
FUNC (TRUE, cancelSub)
FUNC (TRUE, setCharacterWalkSpeed)
FUNC (TRUE, deleteAllFromStack)
FUNC (TRUE, setCharacterExtra)
FUNC (TRUE, mixOverlay)
FUNC (TRUE, pasteCharacter)
FUNC (TRUE, setSceneDimensions)
FUNC (TRUE, aimCamera)
FUNC (TRUE, getMouseScreenX)
FUNC (TRUE, getMouseScreenY)
FUNC (TRUE, setDefaultSoundVolume)
FUNC (TRUE, setSoundVolume)
FUNC (TRUE, setSoundLoopPoints)
FUNC (TRUE, setSpeechMode)
FUNC (TRUE, setLightMap)
FUNC (TRUE, think)
FUNC (TRUE, getCharacterDirection)
FUNC (TRUE, isCharacter)
FUNC (TRUE, isScreenRegion)
FUNC (TRUE, isMoving)
FUNC (TRUE, deleteFile)
FUNC (TRUE, renameFile)
FUNC (TRUE, hardScroll)
FUNC (TRUE, stringWidth)
FUNC (TRUE, setSpeechSpeed)
FUNC (TRUE, normalCharacter)
FUNC (TRUE, fetchEvent)
FUNC (TRUE, transitionLevel)
FUNC (TRUE, spinCharacter)
FUNC (TRUE, setFontSpacing)
FUNC (TRUE, burnString)
FUNC (TRUE, captureAllKeys)
FUNC (TRUE, cacheSound)
FUNC (TRUE, setCharacterSpinSpeed)
FUNC (TRUE, transitionMode)
FUNC (false,  _rem_movieStart)
FUNC (false,  _rem_movieAbort)
FUNC (false,  _rem_moviePlaying)
FUNC (false,  _rem_updateDisplay)
FUNC (TRUE, getSoundCache)
FUNC (TRUE, saveCustomData)
FUNC (TRUE, loadCustomData)
FUNC (TRUE, setCustomEncoding)
FUNC (TRUE, freeSound)
FUNC (TRUE, parallaxAdd)
FUNC (TRUE, parallaxClear)
FUNC (TRUE, setBlankColour)
FUNC (TRUE, setBurnColour)
FUNC (TRUE, getPixelColour)
FUNC (TRUE, makeFastArray)
FUNC (TRUE, getCharacterScale)
FUNC (TRUE, getLanguageID)
FUNC (false, _rem_launchWith)
FUNC (TRUE, getFramesPerSecond)
FUNC (TRUE, showThumbnail)
FUNC (TRUE, setThumbnailSize)
FUNC (TRUE, hasFlag)
FUNC (TRUE, snapshotGrab)
FUNC (TRUE, snapshotClear)
FUNC (TRUE, bodgeFilenames)
FUNC (false,  _rem_registryGetString)
FUNC (TRUE, quitWithFatalError)
FUNC (TRUE, _rem_setCharacterAA)
FUNC (TRUE, _rem_setMaximumAA)
FUNC (TRUE, setBackgroundEffect)
FUNC (TRUE, doBackgroundEffect)
FUNC (TRUE, setCharacterAngleOffset)
FUNC (TRUE, setCharacterTransparency)
FUNC (TRUE, setCharacterColourise)
FUNC (TRUE, zoomCamera)
FUNC (TRUE, playMovie)
FUNC (TRUE, stopMovie)
FUNC (TRUE, pauseMovie)
FUNC (TRUE, addZBufferLayer)
};
#undef FUNC

#define NUM_FUNCS			(sizeof (builtInFunctionArray) / sizeof (builtInFunctionArray[0]))


enum builtReturn callBuiltIn (int whichFunc, int numParams, struct loadedFunction * fun) {
   // fprintf (stderr, "Calling function %d: %s\n", whichFunc, builtInFunctionNames[whichFunc]);    fflush (stderr);

	if ((unsigned int)whichFunc < NUM_FUNCS) {
		if (paramNum[whichFunc] != -1) {
			if (paramNum[whichFunc] != numParams) {
				char buff[100];
				sprintf (buff, "Built in function must have %i parameter%s",
						 paramNum[whichFunc],
						 (paramNum[whichFunc] == 1) ? "" : "s");

				KPrintF(copyString (buff));
				return BR_ERROR;
			}
		}

		if (builtInFunctionArray[whichFunc].func)
		{
			//fprintf (stderr, "Calling %i: %s\n", whichFunc, builtInFunctionNames[whichFunc]);			return builtInFunctionArray[whichFunc].func (numParams, fun);
			return builtInFunctionArray[whichFunc].func (numParams, fun);
		}
	}

	KPrintF("Unknown / mented built-in function.");
	return BR_ERROR;
}

