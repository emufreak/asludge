#include <exec/types.h>

#include "newfatal.h"

extern int numResourceNames /* = 0*/;
extern char * * allResourceNames /*= NULL*/;

const char * resourceNameFromNum (int i) {
	if (i == -1) return NULL;
	if (numResourceNames == 0) return "RESOURCE";
	if (i < numResourceNames) return allResourceNames[i];
	return "Unknown resource";
}