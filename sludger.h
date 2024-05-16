#ifndef SLUDGER_H
#define SLUDGER_H

#include <proto/exec.h>

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int fileVersion);
BOOL initSludge (char *);

#endif