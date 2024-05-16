#include <proto/exec.h>
#include <proto/dos.h>

#include "sludger.h"
#include "errors.h"
#include "people.h"
#include "support/gcc8_c_support.h"
#include "version.h"

int gameVersion;
extern struct personaAnimation * mouseCursorAnim;

int numBIFNames = 0;
char * * allBIFNames = NULL;
int numUserFunc = 0;

BOOL initSludge (char * filename) {
	int a = 0;
	mouseCursorAnim = makeNullAnim ();

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, gameVersion);
	if (! fp) return FALSE;
	if (FGetC (fp)) {
		numBIFNames = get2bytes (fp);
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
		if(allBIFNames == 0) return FALSE;
		for (int fn = 0; fn < numBIFNames; fn ++) {
			allBIFNames[fn] = readString (fp);
		}
		numUserFunc = get2bytes (fp);
	}
}

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int fileVersion) {
	BPTR fp = Open(filename,MODE_OLDFILE);

	if (! fp) {
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
		KPrintF("openAndVerify: Can't open file", filename);
		return NULL;
	}
	BOOL headerBad = FALSE;
	if (FGetC (fp) != 'S') headerBad = TRUE;
	if (FGetC (fp) != 'L') headerBad = TRUE;
	if (FGetC (fp) != 'U') headerBad = TRUE;
	if (FGetC (fp) != 'D') headerBad = TRUE;
	if (FGetC (fp) != extra1) headerBad = TRUE;
	if (FGetC (fp) != extra2) headerBad = TRUE;
	if (headerBad) {
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
		KPrintF("openAndVerify: Bad Header\n");
		return NULL;
	}
	FGetC (fp);
	while (FGetC(fp)) {;}

	int majVersion = FGetC (fp);
	int minVersion = FGetC (fp);
	fileVersion = majVersion * 256 + minVersion;

	char txtVer[120];

	if (fileVersion > WHOLE_VERSION) {
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
		KPrintF(ERROR_VERSION_TOO_LOW_1);
		return NULL;
	} else if (fileVersion < MINIM_VERSION) {
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
		return NULL;
	}
	return fp;
}