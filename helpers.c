/*
 *  helpers.cpp
 *  Helper functions that don't depend on other source files.
 */
#include <proto/dos.h>
#include "helpers.h"

BYTE fileExists(const char * file) {
	BPTR tester;
	BYTE retval = 0;
	tester = Open(file, MODE_OLDFILE);
	if (tester) {
		retval = 1;
		Close(tester);
	}
	return retval;
}