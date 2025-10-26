#include <proto/dos.h>
#include <proto/exec.h>

#include "backdrop.h"
#include "custom.h"
#include "support/gcc8_c_support.h"
#include "freeze.h"

extern struct zBufferData *zBuffer;  // In zbuffer.cpp
extern struct onScreenPerson * allPeople;
extern struct screenRegion * allScreenRegions;
extern struct screenRegion * overRegion;
extern struct speechStruct * speech;
extern struct inputType input;
extern int lightMapNumber, zBufferNumber;
extern struct eventHandlers * currentEvents;
extern struct personaAnimation * mouseCursorAnim;
extern int mouseCursorFrameNum;
extern int cameraX, cameraY;
extern unsigned int sceneWidth, sceneHeight;
extern float cameraZoom;
extern BOOL backdropExists;

struct frozenStuffStruct * frozenStuff = NULL;


BOOL freeze () {
	//KPrintF("calling freeze()\n");

	struct frozenStuffStruct * newFreezer = (struct frozenStuffStruct *) AllocVec(sizeof(struct frozenStuffStruct), MEMF_ANY);
	if (!newFreezer) return FALSE;

	CstFreeze();

	// Grab a copy of the current scene
	//ToDo: Amiga Graphics handling here	

	int picWidth = sceneWidth;
	int picHeight = sceneHeight;	



	newFreezer -> sceneWidth = sceneWidth;
	newFreezer -> sceneHeight = sceneHeight;
	newFreezer -> cameraX = cameraX;
	newFreezer -> cameraY = cameraY;
	newFreezer -> cameraZoom = cameraZoom;

	// resizeBackdrop kills parallax stuff, light map, z-buffer...
	/*if (! resizeBackdrop (winWidth, winHeight)) {
		KPrintF("Can't create new temporary backdrop buffer");
	}*/

	backdropExists = TRUE;

	newFreezer -> allPeople = allPeople;
	allPeople = NULL;

	struct statusStuff * newStatusStuff = (struct statusStuff *) AllocVec(sizeof(struct statusStuff), MEMF_ANY);
	if (!newStatusStuff) return FALSE;	

	newFreezer -> allScreenRegions = allScreenRegions;
	allScreenRegions = NULL;
	overRegion = NULL;

	newFreezer -> mouseCursorAnim = mouseCursorAnim;
	newFreezer -> mouseCursorFrameNum = mouseCursorFrameNum;
	mouseCursorAnim = makeNullAnim ();
	mouseCursorFrameNum = 0;

	newFreezer -> zBuffer = zBuffer;
	zBuffer = NULL;

	newFreezer -> speech = speech;
	initSpeech ();

	newFreezer -> currentEvents = currentEvents;
	currentEvents = (struct eventHandlers *) AllocVec(sizeof(struct eventHandlers), MEMF_ANY);
	if (!currentEvents) return FALSE;
	memset ( currentEvents, 0, sizeof(struct eventHandlers));

	newFreezer -> next = frozenStuff;
	frozenStuff = newFreezer;

	return TRUE;
}

int howFrozen () {
	int a = 0;
	struct frozenStuffStruct * f = frozenStuff;
	while (f) {
		a ++;
		f = f -> next;
	}
	return a;
}

void unfreeze () {
	struct frozenStuffStruct * killMe = frozenStuff;

	if (! frozenStuff) return;

	CstUnfreeze();

	sceneWidth = frozenStuff -> sceneWidth;
	sceneHeight = frozenStuff -> sceneHeight;

	cameraX = frozenStuff -> cameraX;
	cameraY = frozenStuff -> cameraY;
	input.mouseX = (int)(input.mouseX * cameraZoom);
	input.mouseY = (int)(input.mouseY * cameraZoom);
	cameraZoom = frozenStuff -> cameraZoom;
	input.mouseX = (int)(input.mouseX / cameraZoom);
	input.mouseY = (int)(input.mouseY / cameraZoom);

	killAllPeople ();
	allPeople = frozenStuff -> allPeople;

	killAllRegions ();
	allScreenRegions = frozenStuff -> allScreenRegions;
	
	deleteAnim (mouseCursorAnim);  
	mouseCursorAnim = frozenStuff -> mouseCursorAnim;
	mouseCursorFrameNum = frozenStuff -> mouseCursorFrameNum;	

	killZBuffer ();
	zBuffer = frozenStuff->zBuffer;

	if (currentEvents) FreeVec(currentEvents);
	currentEvents = frozenStuff -> currentEvents;

	killAllSpeech ();
	if (speech) FreeVec(speech);
	speech = frozenStuff -> speech;

	frozenStuff = frozenStuff -> next;

	overRegion = NULL;
	if (killMe) FreeVec(killMe);
	killMe = NULL;
}

