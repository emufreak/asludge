#include <proto/exec.h>
#include <exec/types.h>
#include <proto/dos.h>

#include "variable.h"

BOOL fileToStack(char *filename, struct stackHandler *sH);
char *readStringEncoded(BPTR fp);
char *readTextPlain(BPTR fp);
void writeStringEncoded (const char * s, BPTR fp);
BOOL stackToFile (char * filename, const struct variable * from);
