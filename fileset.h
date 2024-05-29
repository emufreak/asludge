#include <proto/dos.h>

extern BPTR bigDataFile;

char * convertString(char * s);
char * getNumberedString();
void finishAccess ();
unsigned int openFileFromNum (int num);
BOOL openSubSlice (int num);
void setFileIndices (BPTR fp, unsigned int numLanguages, unsigned int skipBefore);
