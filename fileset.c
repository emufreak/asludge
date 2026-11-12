#include <proto/exec.h>
#include <proto/dos.h>

#include "fileset.h"
#include "gamefile.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"
#include "version.h"
#include "profile.h"

BPTR bigDataFile = NULL;

ULONG startIndex;
BOOL sliceBusy = TRUE;
ULONG startOfDataIndex, startOfTextIndex,
			  startOfSubIndex, startOfObjectIndex;

// Converts a string from Windows CP-1252 to UTF-8.
// This is needed for old games.
char * convertString(char * s) {
	return NULL;
}

void finishAccess () {
#ifdef PROFILE
	if (sliceBusy) PROF_LEAVE();
#endif
	sliceBusy = FALSE;
}

// The game file is read through gamefile.c (a block cache and one Read for big pieces): Seek, FGetC and FRead on it cost 3 ms a
// packet and 28 microseconds a byte on an A1200. Every offset below is absolute.

char * getNumberedString (int value) {

	if (sliceBusy) {
		Write(Output(), (APTR)"getNumberedString: Can't read from data file. I'm already reading something\n", 76);
		return NULL;
	}

	PROF_ENTER (PFC_STRING);
	GfSeek ((value << 2) + startOfTextIndex);
	value = GfGet4 ();
	GfSeek (value);

	char * s = readString (bigDataFile);
	PROF_LEAVE ();

	return s;
}

unsigned int openFileFromNum (int num) {

	if (sliceBusy) {
		KPrintF("Can't read from data file", "I'm already reading something");
		return 0;
	}

	PROF_ENTER (PFC_DATA);
	GfSeek (startOfDataIndex + (num << 2));
	ULONG relative = GfGet4 ();
	GfSeek (GfTell () + relative);		// (relative to the end of the index entry)
	sliceBusy = TRUE;

	return GfGet4 ();
}

BOOL openObjectSlice (int num) {

    if (sliceBusy) {
        KPrintF("Can't read from data file", "I'm already reading something");
        return FALSE;
    }

    PROF_ENTER (PFC_OBJTYPE);
    GfSeek (startOfObjectIndex + (num << 2));
    GfSeek (GfGet4 ());
    return sliceBusy = TRUE;
}

BOOL openSubSlice (int num) {

	if (sliceBusy) {
		KPrintF("Can't read from data file", "I'm already reading something");
		return FALSE;
	}

	PROF_ENTER (PFC_FUNCLOAD);
	GfSeek (startOfSubIndex + (num << 2));
	GfSeek (GfGet4 ());
	return sliceBusy = TRUE;
}

void setFileIndices (BPTR fp, unsigned int numLanguages, unsigned int skipBefore) {
	if (fp) {
		// Keep hold of the file handle, and let things get at it
		bigDataFile = fp;
		startIndex = Seek( fp, 0, OFFSET_CURRENT);		// (dos knows how far the header reads got: it takes its read-ahead into account)
		GfInit (fp);
		GfSeek (startIndex);
	} else {
		// No file pointer - this means that we reuse the bigDataFile
		GfSeek (startIndex);
	}
	sliceBusy = FALSE;

	if (skipBefore > numLanguages) {
		KPrintF("setFileIndices: Warning: Not a valid language ID! Using default instead.");
		skipBefore = 0;
	}

	// STRINGS
	int skipAfter = numLanguages - skipBefore;
	while (skipBefore) {
		GfSeek (GfGet4 ());
		skipBefore --;
	}
	startOfTextIndex = GfTell () + 4;

	GfSeek (GfGet4 ());

	while (skipAfter) {
		GfSeek (GfGet4 ());
		skipAfter --;
	}

	startOfSubIndex = GfTell () + 4;
	ULONG length = GfGet4 ();
	GfSeek (GfTell () + length);

	startOfObjectIndex = GfTell () + 4;
	length = GfGet4 ();
	GfSeek (GfTell () + length);

	// Remember that the data section starts here
	startOfDataIndex = GfTell ();
}
