#include "sludger.h"

enum builtReturn {BR_KEEP_AND_PAUSE, BR_ERROR, BR_CONTINUE, BR_PAUSE, BR_CALLAFUNC, BR_ALREADY_GONE};

enum builtReturn callBuiltIn (int whichFunc, int numParams, struct loadedFunction * fun);
static BOOL getFuncNumForCallback(int numParams, struct loadedFunction * fun, int *functionNum);
static enum builtReturn sayCore (int numParams, struct loadedFunction * fun, BOOL sayIt);
