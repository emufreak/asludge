/*
 *  helpers.cpp
 *  Helper functions that don't depend on other source files.
 */
#include <proto/dos.h>
#include "helpers.h"

BYTE fileExists(const char * file) {
	KPrintF("fileexists: Checking File");
	BPTR tester;
	BYTE retval = 0;
	tester = Open(file, MODE_OLDFILE);
	if (tester) {
		KPrintF("fileexists: File exists");
		retval = 1;
		Close(tester);
	}
	return retval;
}