#ifndef SLUDGER_H
#define SLUDGER_H

#include <proto/exec.h>

typedef struct _FILETIME {
	ULONG dwLowDateTime;
	ULONG dwHighDateTime;
} FILETIME;

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion);
BOOL initSludge (char *);

#endif