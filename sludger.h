#ifndef SLUDGER_H
#define SLUDGER_H

#include <proto/exec.h>
#include "csludge.h"

typedef struct _FILETIME {
	ULONG dwLowDateTime;
	ULONG dwHighDateTime;
} FILETIME;

struct lineOfCode {
	enum sludgeCommand				theCommand;
	ULONG						param;
};

struct loadedFunction {
	int							originalNumber;
	struct lineOfCode *			compiledLines;
	int							numLocals, timeLeft, numArgs;
	struct variable *			localVars;
	struct variableStack *		stack;
	struct variable	*			reg; 
	unsigned int				runThisLine;
	struct loadedFunction *		calledBy;
	struct loadedFunction *		next;
	BOOL						returnSomething, isSpeech, unfreezable, cancelMe;
	unsigned char				freezerLevel;
};

struct inputType {
	BOOL leftClick, rightClick, justMoved, leftRelease, rightRelease;
	int mouseX, mouseY, keyPressed;
};

BOOL handleInput ();
BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion);
BOOL runSludge();
BOOL initSludge (char *);
int startNewFunctionNum (unsigned int funcNum, unsigned int numParamsExpected, struct loadedFunction * calledBy, struct variableStack * vStack, BOOL returnSommet);

#endif