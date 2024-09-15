#include <exec/types.h>

#include "people.h"
#include "region.h"
#include "sludger.h"
#include "statusba.h"
#include "talk.h"

struct frozenStuffStruct {
	struct onScreenPerson * allPeople;
	struct screenRegion * allScreenRegions;
	int zPanels;	
	int lightMapNumber, zBufferNumber;
	struct speechStruct * speech;
	struct statusStuff * frozenStatus;
	struct eventHandlers * currentEvents;
	struct personaAnimation * mouseCursorAnim;
	int mouseCursorFrameNum;
	int cameraX, cameraY, sceneWidth, sceneHeight;
	float cameraZoom;
	struct frozenStuffStruct * next;
};

BOOL freeze();