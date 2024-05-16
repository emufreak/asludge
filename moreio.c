#include <proto/exec.h>
#include <proto/dos.h>

#include "moreio.h"

int get2bytes (BPTR fp) {
	int f1, f2;

	f1 = FGetC (fp);
	f2 = FGetC (fp);

	return (f1 * 256 + f2);
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