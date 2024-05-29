#include <proto/exec.h>
#include <proto/dos.h>

#include "moreio.h"
#include "support/gcc8_c_support.h"
#include "objtypes.h"

struct objectType * allObjectTypes = NULL;

struct objectType * findObjectType (int i) {
	struct objectType * huntType = allObjectTypes;

	while (huntType) {
		if (huntType -> objectNum == i) return huntType;
		huntType = huntType -> next;
	}

	return loadObjectType (i);
}

BOOL initObjectTypes () {
	return TRUE;
}

struct objectType * loadObjectRef (BPTR fp) {
	struct objectType * r = loadObjectType (get2bytes (fp));
	FreeVec(r -> screenName);
	r -> screenName = readString (fp);
	return r;
}

struct objectType * loadObjectType (int i) {
	int a, nameNum;
	struct objectType * newType = AllocVec( sizeof( struct objectType),MEMF_ANY);

	if (checkNew (newType)) {
		if (openObjectSlice (i)) {
			nameNum = get2bytes (bigDataFile);
			newType -> r = (BYTE) FGetC (bigDataFile);
			newType -> g = (BYTE) FGetC (bigDataFile);
			newType -> b = (BYTE) FGetC (bigDataFile);
			newType -> speechGap = fgetc (bigDataFile);
			newType -> walkSpeed = fgetc (bigDataFile);
			newType -> wrapSpeech = get4bytes (bigDataFile);
			newType -> spinSpeed = get2bytes (bigDataFile);

			if (gameVersion >= VERSION(1,6))
			{
				// aaLoad
				fgetc (bigDataFile);
				getFloat (bigDataFile);
				getFloat (bigDataFile);
			}
			
			if (gameVersion >= VERSION(1,4)) {
				newType -> flags = get2bytes (bigDataFile);
			} else {
				newType -> flags = 0;
			}

			newType -> numCom = get2bytes (bigDataFile);
			newType -> allCombis = (newType -> numCom) ? new combination[newType -> numCom] : NULL;

#if DEBUG_COMBINATIONS
			FILE * callEventLog = fopen ("callEventLog.txt", "at");
			if (callEventLog)
			{
				fprintf (callEventLog, "Object type %d has %d combinations... ", i, newType -> numCom);
			}
#endif

			for (a = 0; a < newType -> numCom; a ++) {
				newType -> allCombis[a].withObj = get2bytes (bigDataFile);
				newType -> allCombis[a].funcNum = get2bytes (bigDataFile);
#if DEBUG_COMBINATIONS
				if (callEventLog)
				{
					fprintf (callEventLog, "%d(%d) ", newType -> allCombis[a].withObj, newType -> allCombis[a].funcNum);
				}
#endif
			}
#if DEBUG_COMBINATIONS
			if (callEventLog)
			{
				fprintf (callEventLog, "\n");
				fclose (callEventLog);
			}
#endif
			finishAccess ();
			newType -> screenName = getNumberedString (nameNum);
			newType -> objectNum = i;
			newType -> next = allObjectTypes;
			allObjectTypes = newType;
			return newType;
		}
	}
	return NULL;
}

void removeObjectType (struct objectType * oT) {
	struct objectType * * huntRegion = allObjectTypes;

	while (* huntRegion) {
		if ((* huntRegion) == oT) {
//			FILE * debuggy2 = fopen ("debug.txt", "at");
//			fprintf (debuggy2, "DELETING OBJECT TYPE: %p %s\n", oT, oT -> screenName);
//			fclose (debuggy2);

			* huntRegion = oT -> next;
			FreeVec(oT -> allCombis);
			FreeVec(oT -> screenName);
			FreeVec(oT);
			return;
		} else {
			huntRegion = & ((* huntRegion) -> next);
		}
	}
	KPrintF("Can't delete object type: bad pointer");
}

void saveObjectRef (struct objectType * r, BPTR fp) {
	put2bytes (r -> objectNum, fp);
	writeString (r -> screenName, fp);
}