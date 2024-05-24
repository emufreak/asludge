#include <proto/exec.h>

#include "moreio.h"
#include "support/gcc8_c_support.h"
#include "objtypes.h"

struct objectType * allObjectTypes = NULL;

BOOL initObjectTypes () {
	return TRUE;
}

struct objectType * loadObjectRef (BPTR fp) {
	struct objectType * r = loadObjectType (get2bytes (fp));
	FreeVec(r -> screenName);
	r -> screenName = readString (fp);
	return r;
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