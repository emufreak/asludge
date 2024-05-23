#include <proto/exec.h>

#include "fileset.h"
#include "moreio.h"
#include "support/gcc8_c_support.h"
#include "version.h"

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
	sliceBusy = FALSE;
}

char * getNumberedString (int value) {

	if (sliceBusy) {
		Write(Output(), (APTR)"getNumberedString: Can't read from data file. I'm already reading something\n", 76);        
		return NULL;
	}

	Seek(bigDataFile, (value << 2) + startOfTextIndex, OFFSET_BEGINNING);
	value = get4bytes (bigDataFile);
	Seek (bigDataFile, value, OFFSET_BEGINING);

	char * s = readString (bigDataFile);    
	
	return s;
}


BOOL openSubSlice (int num) {
//	FILE * dbug = fopen ("debuggy.txt", "at");

//	fprintf (dbug, "\nTrying to open sub %i\n", num);

	if (sliceBusy) {
		KPrintF("Can't read from data file", "I'm already reading something");
		return FALSE;
	}

//	fprintf (dbug, "Going to position %li\n", startOfSubIndex + (num << 2));
	Seek(bigDataFile, startOfSubIndex + (num << 2), OFFSET_BEGINNING);
	Seek(bigDataFile, get4bytes (bigDataFile), OFFSET_BEGINNING);
//	fprintf (dbug, "Told to skip forward to %li\n", ftell (bigDataFile));
//	fclose (dbug);
	return sliceBusy = TRUE;
}

void setFileIndices (BPTR fp, unsigned int numLanguages, unsigned int skipBefore) {
	if (fp) {
		// Keep hold of the file handle, and let things get at it
		bigDataFile = fp;
		startIndex = Seek( fp, 0, OFFSET_CURRENT);
	} else {
		// No file pointer - this means that we reuse the bigDataFile
		fp = bigDataFile;
        Seek(fp, startIndex, OFFSET_BEGINNING);
	}
	sliceBusy = FALSE;

	if (skipBefore > numLanguages) {
		KPrintF("setFileIndices: Warning: Not a valid language ID! Using default instead.");
		skipBefore = 0;
	}

	// STRINGS
	int skipAfter = numLanguages - skipBefore;
	while (skipBefore) {
        Seek(fp, get4bytes(fp),0);		
		skipBefore --;
	}
	startOfTextIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;

	Seek(fp, get4bytes (fp), OFFSET_BEGINNING);

	while (skipAfter) {
        Seek( fp, get4bytes (fp), OFFSET_BEGINING);
		skipAfter --;
	}

	startOfSubIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
    Seek( fp, get4bytes (fp), OFFSET_CURRENT);

	startOfObjectIndex = Seek( fp, 0, OFFSET_CURRENT) + 4;
	Seek (fp, get4bytes (fp), OFFSET_CURRENT);

	// Remember that the data section starts here
	startOfDataIndex =  Seek( fp, 0, OFFSET_CURRENT);
}