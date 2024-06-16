#include <proto/exec.h>
#include <exec/types.h>
#include <proto/dos.h>

#include "savedata.h"
#include "moreio.h"
#include "stringy.h"
#include "variable.h"
#include "support/gcc8_c_support.h"

#define LOAD_ERROR "Can't load custom data...\n\n"


extern char * gamePath;

char encode1 = 0;
char encode2 = 0;
unsigned short saveEncoding = FALSE;

BOOL fileToStack(char *filename, struct stackHandler *sH) {
    struct variable stringVar;
    stringVar.varType = SVT_NULL;
    const char *checker = saveEncoding ? "[Custom data (encoded)]\r\n" : "[Custom data (ASCII)]\n";

    BPTR fp = Open(filename, MODE_OLDFILE);
    if (!fp) {
        KPrintF("No such file", filename);
        return FALSE;
    }

    encode1 = (unsigned char)saveEncoding & 255;
    encode2 = (unsigned char)(saveEncoding >> 8);

    while (*checker) {
        if (FGetC(fp) != *checker) {
            Close(fp);
            KPrintF(LOAD_ERROR "This isn't a SLUDGE custom data file:", filename);
            return FALSE;
        }
        checker++;
    }

    if (saveEncoding) {
        char *checker = readStringEncoded(fp);
        if (strcmp(checker, "UN�LO�CKED")) {
            Close(fp);
            KPrintF(LOAD_ERROR "The current file encoding setting does not match the encoding setting used when this file was created:", filename);
            return FALSE;
        }
        FreeVec(checker);
        checker = NULL;
    }

    for (;;) {
        if (saveEncoding) {
            LONG tmp = FGetC(fp) ^ encode1;

            if (tmp == -1) break;

            char i = (char) tmp;

            switch (i) {
                case 0: {
                    char *g = readStringEncoded(fp);
                    makeTextVar(&stringVar, g);
                    FreeVec(g);
                }
                break;

                case 1:
                    setVariable(&stringVar, SVT_INT, get4bytes(fp));
                    break;

                case 2:
                    setVariable(&stringVar, SVT_INT, FGetC(fp));
                    break;

                default:
                    KPrintF(LOAD_ERROR "Corrupt custom data file:", filename);
                    Close(fp);
                    return FALSE;
            }
        } else {
            char *line = readTextPlain(fp);
            if (!line) break;
            makeTextVar(&stringVar, line);
        }

        if (sH->first == NULL) {
            // Adds to the TOP of the array... oops!
            if (!addVarToStackQuick(&stringVar, &sH->first)) return FALSE;
            sH->last = sH->first;
        } else {
            // Adds to the END of the array... much better
            if (!addVarToStackQuick(&stringVar, &sH->last->next)) return FALSE;
            sH->last = sH->last->next;
        }
    }
    Close(fp);
    return TRUE;
}

char *readStringEncoded(BPTR fp) {
    int a, len = get2bytes(fp);
    char *s = AllocVec(len + 1, MEMF_ANY);
    if (!s) return NULL;
    for (a = 0; a < len; a++) {
        s[a] = (char)(FGetC(fp) ^ encode1);
        encode1 += encode2;
    }
    s[len] = 0;
    return s;
}

char *readTextPlain(BPTR fp) {
    ULONG startPos;
    int stringSize = 0;
    BOOL keepGoing = TRUE;
    char gotChar;
    char *reply;

    startPos = Seek(fp, 0, OFFSET_CURRENT);

    LONG tmp;
    while (keepGoing) {
        tmp = FGetC(fp);
        char gotChar = (char) tmp;
        if (gotChar == '\n' || tmp == -1) {
            keepGoing = FALSE;
        } else {
            stringSize++;
        }
    }

    if ((stringSize == 0) && tmp == -1) {
        return NULL;
    } else {
        Seek(fp, startPos, OFFSET_BEGINNING);
        reply = AllocVec(stringSize + 1, MEMF_ANY);
        if (reply == NULL) return NULL;
        int bytesRead = FRead(fp, reply, 1, stringSize);
        if (bytesRead != stringSize) {
            KPrintF("Reading error in readTextPlain.\n");
        }
        FGetC(fp); // Skip the newline character
        reply[stringSize] = 0;
    }

    return reply;
}


BOOL stackToFile (char * filename, const struct variable * from) {
    BPTR fp = Open( filename, MODE_NEWFILE);

    if (!fp) {
        KPrintF("Can't create file", filename);
        return FALSE;
    }

    struct variableStack * hereWeAre = from->varData.theStack->first;

    encode1 = (unsigned char) saveEncoding & 255;
    encode2 = (unsigned char) (saveEncoding >> 8);

    if (saveEncoding) {
        FPrintf(fp, "[Custom data (encoded)]\r\n");
        writeStringEncoded("UN�LO�CKED", fp);
    } else {
        FPrintf(fp, "[Custom data (ASCII)]\n");
    }

    while (hereWeAre) {
        if (saveEncoding) {
            switch (hereWeAre->thisVar.varType) {
                case SVT_STRING:
                    FPutC(fp, encode1);
                    writeStringEncoded(hereWeAre->thisVar.varData.theString, fp);
                    break;

                case SVT_INT:
                    // Small enough to be stored as a char
                    if (hereWeAre->thisVar.varData.intValue >= 0 && hereWeAre->thisVar.varData.intValue < 256) {
                        FPutC(fp, 2 ^ encode1);
                        FPutC(fp, hereWeAre->thisVar.varData.intValue);
                    } else {
                        FPutC(fp, 1 ^ encode1);
                        put4bytes(hereWeAre->thisVar.varData.intValue, fp);
                    }
                    break;

                default:
                    KPrintF("Can't create an encoded custom data file containing anything other than numbers and strings", filename);
                    Close(fp);
                    return FALSE;
            }
        } else {
            char * makeSureItsText = getTextFromAnyVar(&hereWeAre->thisVar);
            if (makeSureItsText == NULL) break;
            FPrintf(fp, "%s\n", *makeSureItsText);
            FreeVec(makeSureItsText);
        }

        hereWeAre = hereWeAre->next;
    }
    Close(fp);
    return TRUE;
}

void writeStringEncoded (const char * s, BPTR fp) {
	int a, len = strlen (s);

	put2bytes (len, fp);
	for (a = 0; a < len; a ++) {
		FPutC (fp, s[a] ^ encode1);
		encode1 += encode2;
	}
}
