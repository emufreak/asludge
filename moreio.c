#include <proto/exec.h>
#include <proto/dos.h>

#include "stringy.h"
#include "support/gcc8_c_support.h"
#include "moreio.h"

BOOL allowAnyFilename = TRUE;

char * copyString(const char * c) {
    char * r = (char *)AllocVec(strlen(c) + 1, MEMF_ANY);
    if (!r) return NULL;
    strcpy(r, c);
    return r;
}

char * decodeFilename(char * nameIn) {
	if (allowAnyFilename) {
		char * newName = (char *)AllocVec(strlen(nameIn) + 1, MEMF_ANY);
		if (!newName) return NULL;

		int i = 0;
		while (*nameIn) {
			if (*nameIn == '_') {
				nameIn++;
				switch (*nameIn) {
					case 'L':	newName[i] = '<';	nameIn++;	break;
					case 'G':	newName[i] = '>';	nameIn++;	break;
					case 'P':	newName[i] = '|';	nameIn++;	break;
					case 'U':	newName[i] = '_';	nameIn++;	break;
					case 'S':	newName[i] = '\"';	nameIn++;	break;
					case 'B':	newName[i] = '\\';	nameIn++;	break;
					case 'F':	newName[i] = '/';	nameIn++;	break;
					case 'C':	newName[i] = ':';	nameIn++;	break;
					case 'A':	newName[i] = '*';	nameIn++;	break;
					case 'Q':	newName[i] = '?';	nameIn++;	break;
					default:	newName[i] = '_';
				}
			} else {
				newName[i] = *nameIn;
				nameIn++;
			}
			i++;
		}
		newName[i] = 0;
		return newName;
	} else {
		return copyString(nameIn);
	}
}

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

FLOAT FLOATSwap( FLOAT f )
{
	union
	{
		FLOAT f;
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

FLOAT getFloat (BPTR fp) {
	FLOAT f;
	LONG blocks_read = FRead( fp, &f, sizeof (FLOAT), 1 ); 
	if (blocks_read != 1) {
		KPrintF("Reading error in getFloat.\n");
	}
	return FLOATSwap(f);
	return f;
}

short getSigned (BPTR fp) {
	short f;
	LONG bytes_read = Read(fp, &f, sizeof(short));
	if (bytes_read != sizeof (short)) {
		KPrintF("getSigned: Reading error in getSigned.\n");
	}
	f = shortSwap(f);
	return f;
}

void put2bytes (int numtoput, BPTR fp) {
	FPutC( fp, (char) (numtoput / 256));
	FPutC( fp, (char) (numtoput % 256));
}

void put4bytes (ULONG i, BPTR fp) {
	//	fwrite (&i, sizeof (long int), 1, fp);
	unsigned char f1, f2, f3, f4;

	f4 = i / (256*256*256);
	i = i % (256*256*256);
	f3 = i / (256*256);
	i = i % (256*256);
	f2 = i / 256;
	f1 = i % 256;

	FPutC (fp,f1);
	FPutC (fp,f2);
	FPutC (fp,f3);
	FPutC (fp,f4);
}

void putFloat (FLOAT f, BPTR fp) {
	f = FLOATSwap(f);
	Write( fp, &f, sizeof (FLOAT));
}

void putSigned (short f, BPTR fp) {
	f = shortSwap(f);
	Write(fp, &f, sizeof(short));
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

short shortSwap( short s )
{
	unsigned char b1, b2;
	
	b1 = s & 255;
	b2 = (s >> 8) & 255;
	
	return (b1 << 8) + b2;
}

void writeString (char * s, BPTR fp) {
	int a, len = strlen (s);
	put2bytes (len, fp);
	for (a = 0; a < len; a ++) {
		FPutC (fp,s[a] + 1);
	}
}