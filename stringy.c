#include <proto/exec.h>
#include <string.h>
#include "support/gcc8_c_support.h"

#ifndef va_start
#define va_start(ap, last) (ap = (va_list)&last + sizeof(last))
#define va_arg(ap, type) (*(type*)(ap += sizeof(type)) - 1)
#define va_end(ap) (ap = (va_list)0)
#endif


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

typedef char* va_list;

#define va_start(ap, last) (ap = (va_list)&last + sizeof(last))
#define va_arg(ap, type) (*(type*)(ap += sizeof(type)) - 1)
#define va_end(ap) (ap = (va_list)0)

char* itoa(int value, char* str, int base) {
    char* rc;
    char* ptr;
    char* low;
    // Set '-' for negative decimals.
    if (base == 10 && value < 0) {
        *str++ = '-';
        value *= -1;
    }
    rc = ptr = str;
    // Set pointer to last digit's place.
    do {
        *ptr++ = "0123456789abcdef"[value % base];
        value /= base;
    } while (value);
    // Null-terminate string.
    *ptr-- = '\0';
    // Reverse string.
    for (low = rc; low < ptr; low++, ptr--) {
        char temp = *low;
        *low = *ptr;
        *ptr = temp;
    }
    return rc;
}

int vsprintf(char* str, const char* format, va_list args) {
    char* s = str;
    const char* p = format;
    int i;
    char* sval;
    char buffer[20];

    while (*p) {
        if (*p == '%') {
            switch (*++p) {
                case 'd':
                    i = va_arg(args, int);
                    itoa(i, buffer, 10);
					for (char* b = buffer; *b; b++) {
                        *s++ = *b;
                    }
                    break;
                case 's':
                    sval = va_arg(args, char*);
                    while (*sval) {
                        *s++ = *sval++;
                    }
                    break;
                case 'c':
                    i = va_arg(args, int);
                    *s++ = (char)i;
                    break;
                default:
                    *s++ = *p;
                    break;
            }
        } else {
            *s++ = *p;
        }
        p++;
    }
    *s = '\0';
    return s - str;
}

int sprintf(char* str, const char* format, ...) {
    va_list args;
    int done;

    va_start(args, format);
    done = vsprintf(str, format, args);
    va_end(args);

    return done;
}
