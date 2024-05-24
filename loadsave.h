#include <proto/exec.h>

void clearStackLib ();
struct loadedFunction * loadFunction (BPTR fp);
BOOL loadGame (char * fname);
void saveFunction (struct loadedFunction * fun, BPTR fp);
BOOL saveGame (char * fname);
void saveStack (struct variableStack * vs, BPTR fp);
BOOL saveStackRef (struct stackHandler * vs, BPTR fp);
BOOL saveVariable (struct variable * from, BPTR fp);