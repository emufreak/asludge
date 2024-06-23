#ifndef SLUDGER_H
#define SLUDGER_H

#include <proto/dos.h>
#include "csludge.h"
#include "variable.h"

typedef struct _FILETIME {
	ULONG dwLowDateTime;
	ULONG dwHighDateTime;
} FILETIME;

struct eventHandlers {
	int leftMouseFunction;
	int leftMouseUpFunction;
	int rightMouseFunction;
	int rightMouseUpFunction;
	int moveMouseFunction;
	int focusFunction;
	int spaceFunction;
};

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
	struct variable				reg; 
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

void abortFunction (struct loadedFunction * fun);
int cancelAFunction (int funcNum, struct loadedFunction * myself, BOOL * killedMyself);
void completeTimers ();
BOOL continueFunction (struct loadedFunction * fun);
void finishFunction (struct loadedFunction * fun);
BOOL handleInput ();
void killSpeechTimers ();
BOOL loadFunctionCode (struct loadedFunction * newFunc);
void loadHandlers (BPTR fp);
BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion);
void restartFunction (struct loadedFunction * fun);
BOOL runSludge();
BOOL initSludge (char *);
void pauseFunction (struct loadedFunction * fun);
void saveHandlers (BPTR fp);
BOOL stackSetByIndex (struct variableStack * vS, unsigned int theIndex, const struct variable * va);
int startNewFunctionNum (unsigned int funcNum, unsigned int numParamsExpected, struct loadedFunction * calledBy, struct variableStack * vStack, BOOL returnSommet);

#endif