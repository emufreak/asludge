#include <proto/exec.h>
#include <string.h>
#include "support/gcc8_c_support.h"


int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1 == *s2))
    {
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

long unsigned int strlen (const char *s) 
{  
	long unsigned int i = 0;
	while(s[i]) i++; 
	return(i);
}

char *strcpy(char *t, const char *s) 
{
	while(*t++ = *s++);
}

char * copyString (const char * copyMe) {
	
	char * newString = AllocVec(strlen(copyMe)+1, MEMF_ANY); 
	if(newString == 0) {
		KPrintF("copystring: Can't reserve memory for newString\n");
		return NULL;	
	}
	strcpy (newString, copyMe);
	return newString;
}

char * joinStrings (const char * s1, const char * s2) {
	char * newString = AllocVec(strlen (s1) + strlen (s2) + 1, MEMF_ANY); 
	char * t = newString;

	while(*t++ = *s1++);
	t--;
	while(*t++ = *s2++);

	return newString;
}
