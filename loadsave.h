#include <proto/exec.h>
#include <proto/dos.h>

#include "variable.h"

void clearStackLib ();
struct stackHandler * getStackFromLibrary (int n);
struct loadedFunction * loadFunction (BPTR fp);
BOOL loadGame (char * fname);
struct variableStack * loadStack (BPTR fp, struct variableStack ** last);
struct stackHandler * loadStackRef (BPTR fp);
void saveFunction (struct loadedFunction * fun, BPTR fp);
BOOL saveGame (char * fname);
void saveStack (struct variableStack * vs, BPTR fp);
BOOL saveStackRef (struct stackHandler * vs, BPTR fp);
BOOL saveVariable (struct variable * from, BPTR fp);