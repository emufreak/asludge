#ifndef SLUDGER_H
#define SLUDGER_H

#include <proto/exec.h>

typedef struct _FILETIME {
	ULONG dwLowDateTime;
	ULONG dwHighDateTime;
} FILETIME;

struct inputType {
	BOOL leftClick, rightClick, justMoved, leftRelease, rightRelease;
	int mouseX, mouseY, keyPressed;
};

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion);
BOOL initSludge (char *);

#endif