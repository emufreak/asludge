#include <proto/exec.h>
#include <proto/dos.h>

#include "stringy.h"
#include "support/gcc8_c_support.h"
#include "moreio.h"

BOOL allowAnyFilename = TRUE;

char * encodeFilename (char * nameIn) {
	if (! nameIn) return NULL;
	if (allowAnyFilename) {
		char * newName = AllocVec( strlen(nameIn)*2+1,MEMF_ANY);
		if(newName == 0) {
			KPrintF( "encodefilename: Could not allocate Memory");
			return NULL;
		}

		int i = 0;
		while (*nameIn) {
			switch (*nameIn) {
				case '<':	newName[i++] = '_';		newName[i++] = 'L';		break;
				case '>':	newName[i++] = '_';		newName[i++] = 'G';		break;
				case '|':	newName[i++] = '_';		newName[i++] = 'P';		break;
				case '_':	newName[i++] = '_';		newName[i++] = 'U';		break;
				case '\"':	newName[i++] = '_';		newName[i++] = 'S';		break;
				case '\\':	newName[i++] = '_';		newName[i++] = 'B';		break;
				case '/':	newName[i++] = '_';		newName[i++] = 'F';		break;
				case ':':	newName[i++] = '_';		newName[i++] = 'C';		break;
				case '*':	newName[i++] = '_';		newName[i++] = 'A';		break;
				case '?':	newName[i++] = '_';		newName[i++] = 'Q';		break;

				default:	newName[i++] = *nameIn;							break;
			}
			newName[i] = 0;
			nameIn ++;
		}
		return newName;
	} else {
		int a;
		for (a = 0; nameIn[a]; a ++) {
			if (nameIn[a] == '\\') nameIn[a] ='/';
		}

		return copyString (nameIn);
	}
}

float floatSwap( float f )
{
	union
	{
		float f;
		unsigned char b[4];
	} dat1, dat2;

	dat1.f = f;
	dat2.b[0] = dat1.b[3];
	dat2.b[1] = dat1.b[2];
	dat2.b[2] = dat1.b[1];
	dat2.b[3] = dat1.b[0];
	return dat2.f;
}

int get2bytes (BPTR fp) {
	int f1, f2;

	f1 = FGetC (fp);
	f2 = FGetC (fp);

	return (f1 * 256 + f2);
}

ULONG get4bytes (BPTR fp) {
	int f1, f2, f3, f4;

	f1 = FGetC (fp);
	f2 = FGetC (fp);
	f3 = FGetC (fp);
	f4 = FGetC (fp);

	ULONG x = f1 + f2*256 + f3*256*256 + f4*256*256*256;

	return x;
}

float getFloat (BPTR fp) {
	float f;
	LONG blocks_read = FRead( fp, &f, sizeof (float), 1 ); 
	if (blocks_read != 1) {
		KPrintF("Reading error in getFloat.\n");
	}
	return floatSwap(f);
	return f;
}

char * readString (BPTR fp) {

	int a, len = get2bytes (fp);
	//debugOut ("MOREIO: readString - len %i\n", len);
	char * s = AllocVec(len+1,MEMF_ANY);
	if(s == 0) return NULL;
	for (a = 0; a < len; a ++) {
		s[a] = (char) (FGetC (fp) - 1);
	}
	s[len] = 0;
	//debugOut ("MOREIO: readString: %s\n", s);
	return s;
}