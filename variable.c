#include <proto/exec.h>
#include <proto/dos.h>


#include "variable.h"
#include "fileset.h"
#include "loadsave.h"
#include "moreio.h"
#include "newfatal.h"
#include "objtypes.h"
#include "people.h"
#include "sprbanks.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"



const char * typeName[] = {"undefined", "number", "user function", "string",
							"built-in function", "file", "stack",
							"object type", "animation", "costume"};


BOOL addVarToStack(const struct variable * va, struct variableStack ** thisStack) {
    struct variableStack * newStack = (struct variableStack *)AllocVec(sizeof(struct variableStack), MEMF_ANY);
    if (!newStack) return FALSE;

    if (!copyMain(va, &newStack->thisVar)) {
        FreeVec(newStack);
        return FALSE;
    }

    newStack->next = *thisStack;
    *thisStack = newStack;
    return TRUE;
}

BOOL addVarToStackQuick(struct variable *va, struct variableStack **thisStack) {
    struct variableStack *newStack = AllocVec(sizeof(struct variableStack), MEMF_ANY);
    if (!newStack) return FALSE;

//    if (!copyMain(va, &newStack->thisVar)) return FALSE;

    memcpy(&(newStack->thisVar), va, sizeof(struct variable));
    va->varType = SVT_NULL;

    newStack->next = *thisStack;
    *thisStack = newStack;
    return TRUE;
}

void addVariablesInSecond(struct variable * var1, struct variable * var2) {
	if (var1->varType == SVT_INT && var2->varType == SVT_INT) {
		var2->varData.intValue += var1->varData.intValue;
	} else {
		char * string1 = getTextFromAnyVar(var1);
		char * string2 = getTextFromAnyVar(var2);

		unlinkVar(var2);
		var2->varData.theString = joinStrings(string1, string2);
		var2->varType = SVT_STRING;
		FreeVec(string1);
		FreeVec(string2);
	}
}

void compareVariablesInSecond (const struct variable *var1, struct variable *var2) {	
	setVariable (var2, SVT_INT, compareVars (*var1, *var2));
}


int compareVars (const struct variable var1, const struct variable var2) {
	int re = 0;
	if (var1.varType == var2.varType) {
		switch (var1.varType) {
			case SVT_NULL:
			re = 1;
			break;

			case SVT_COSTUME:
			re = (var1.varData.costumeHandler == var2.varData.costumeHandler);
			break;

			case SVT_ANIM:
			re = (var1.varData.animHandler == var2.varData.animHandler);
			break;

			case SVT_STRING:

			re = (strcmp (var1.varData.theString, var2.varData.theString) == 0);
			break;

			case SVT_STACK:
			re = (var1.varData.theStack == var2.varData.theStack);
			break;

			default:
			re = (var1.varData.intValue == var2.varData.intValue);
		}
	}
	return re;
}

BOOL copyStack (const struct variable * from, struct variable * to) {
	to->varType = SVT_STACK;
	to->varData.theStack = (struct stackHandler *)AllocVec(sizeof(struct stackHandler), MEMF_ANY);
	if (!to->varData.theStack) return FALSE;
	to->varData.theStack->first = NULL;
	to->varData.theStack->last = NULL;
	to->varData.theStack->timesUsed = 1;
	struct variableStack * a = from->varData.theStack->first;

	while (a) {
		addVarToStack(&a->thisVar, &(to->varData.theStack->first));
		if (to->varData.theStack->last == NULL) {
			to->varData.theStack->last = to->varData.theStack->first;
		}
		a = a->next;
	}

	return TRUE;
}

int deleteVarFromStack (const struct variable * va, struct variableStack ** thisStack, BOOL allOfEm) {
    struct variableStack ** huntVar = thisStack;
    struct variableStack * killMe;
    int reply = 0;

    while (*huntVar) {
        if (compareVars((*huntVar)->thisVar, *va)) {
            killMe = *huntVar;
            *huntVar = killMe->next;
            unlinkVar(&killMe->thisVar);
            FreeVec(killMe);
            if (!allOfEm) return 1;
            reply++;
        } else {
            huntVar = &((*huntVar)->next);
        }
    }

    return reply;
}


struct variable * fastArrayGetByIndex (struct fastArrayHandler * vS, unsigned int theIndex) {
	if (theIndex >= (unsigned int) vS -> size) return NULL;
	return & vS -> fastVariables[theIndex];
}

struct persona * getCostumeFromVar(struct variable *thisVar) {
    struct persona *p = NULL;

    switch (thisVar->varType) {
        case SVT_ANIM:
            p = AllocVec(sizeof(struct persona), MEMF_ANY);
            if (!p) return NULL;
            p->numDirections = 1;
            p->animation = AllocVec(3 * sizeof(struct personaAnimation *), MEMF_ANY);
            if (!p->animation) return NULL;

            for (int iii = 0; iii < 3; iii++) {
                p->animation[iii] = copyAnim(thisVar->varData.animHandler);
            }
            break;

        case SVT_COSTUME:
            return thisVar->varData.costumeHandler;
            break;

        default:
            KPrintF("Expecting an animation variable; found variable of type", typeName[thisVar->varType]);
    }

    return p;
}

BOOL getSavedGamesStack(struct stackHandler * sH, char * ext) {
	char * pattern = joinStrings("*", ext);
	if (!pattern) return FALSE;

	struct variable newName;
	newName.varType = SVT_NULL;

	BPTR dirLock = Lock(".", ACCESS_READ);
	if (!dirLock) return FALSE;

	struct FileInfoBlock *fib = (struct FileInfoBlock *)AllocVec(sizeof(struct FileInfoBlock), MEMF_CLEAR);
	if (!fib) {
		UnLock(dirLock);
		return FALSE;
	}

	BOOL result = FALSE;
	if (Examine(dirLock, fib)) {
		while (ExNext(dirLock, fib)) {
			if (!strcmp(fib->fib_FileName + strlen(fib->fib_FileName) - strlen(ext), ext)) {
				fib->fib_FileName[strlen(fib->fib_FileName) - strlen(ext)] = 0;
				char * decoded = decodeFilename(fib->fib_FileName);
				makeTextVar(&newName, decoded);
				FreeVec(decoded);
				if (!addVarToStack(&newName, &sH->first)) goto cleanup;
				if (sH->last == NULL) sH->last = sH->first;
			}
		}
		result = TRUE;
	}

cleanup:
	FreeVec(fib);
	UnLock(dirLock);
	FreeVec(pattern);
	return result;
}


BOOL getValueType (int *toHere, enum variableType vT, const struct variable *v) {
	//if (! v) return false;
	if (v->varType != vT) {
		char * e1 = joinStrings ("Can only perform specified operation on a value which is of type ", typeName[vT]);
		char * e2 = joinStrings ("... value supplied was of type ", typeName[v->varType]);
		KPrintF(e1, e2);

		return FALSE;
	}
	*toHere = v->varData.intValue;
	return TRUE;
}

BOOL loadStringToVar (struct variable *thisVar, int value) {
	makeTextVar (thisVar, getNumberedString (value));
	return (BOOL) (thisVar->varData.theString != NULL);
}

BOOL loadVariable (struct variable * to, BPTR fp) {
	to -> varType = (enum variableType) FGetC (fp);
	switch (to -> varType) {
		case SVT_INT:
		case SVT_FUNC:
		case SVT_BUILT:
		case SVT_FILE:
		case SVT_OBJTYPE:
		to -> varData.intValue = get4bytes (fp);
		return TRUE;

		case SVT_STRING:
		to -> varData.theString = readString (fp);
		return TRUE;

		case SVT_STACK:
		to -> varData.theStack = loadStackRef (fp);

		return TRUE;

		case SVT_COSTUME:
		to -> varData.costumeHandler = AllocVec(sizeof(struct persona), MEMF_ANY);
		if (!(to -> varData.costumeHandler)) {
			KPrintF("loadvariable: Cannot allocate memory");
			return FALSE;
		}
		loadCostume (to -> varData.costumeHandler, fp);
		return TRUE;

		case SVT_ANIM:
		to -> varData.animHandler = AllocVec( sizeof( struct personaAnimation),MEMF_ANY);
		if (!(to -> varData.animHandler)) {
			KPrintF("loadvariable: Cannot allocate memory");
			return FALSE;
		}
		loadAnim (to -> varData.animHandler, fp);
		return TRUE;

		default:
		break;
	}
	return TRUE;
}

BOOL makeFastArrayFromStack (struct variable *to, const struct stackHandler *stacky) {
    int size = stackSize(stacky);
    if (!makeFastArraySize(to, size)) return FALSE;

    // Now let's fill up the new array

    struct variableStack *allV = stacky->first;
    size = 0;
    while (allV) {
        copyMain(&allV->thisVar, &to->varData.fastArray->fastVariables[size]);
        size++;
        allV = allV->next;
    }
    return TRUE;
}


BOOL makeFastArraySize (struct variable *to, int size) {
    if (size < 0) {
		KPrintF("makeFastArraySize: Can't create a fast array with a negative number of elements!");
		return FALSE;
	}		
    unlinkVar(to);
    to->varType = SVT_FASTARRAY;
    to->varData.fastArray = AllocVec(sizeof(struct fastArrayHandler), MEMF_ANY);
    if (!to->varData.fastArray) return FALSE;
    to->varData.fastArray->fastVariables = AllocVec(size * sizeof(struct variable), MEMF_ANY);
    if (!to->varData.fastArray->fastVariables) return FALSE;
    for (int i = 0; i < size; i++) {
        to->varData.fastArray->fastVariables[i].varType = SVT_NULL;
    }
    to->varData.fastArray->size = size;
    to->varData.fastArray->timesUsed = 1;
    return TRUE;
}

void makeTextVar (struct variable *thisVar, const char * txt) {
	unlinkVar (thisVar);
	thisVar->varType = SVT_STRING;
	thisVar->varData.theString = copyString (txt);
}

void unlinkVar (struct variable *thisVar) {

	switch (thisVar->varType) {
		case SVT_STRING:
        FreeVec(thisVar->varData.theString);
		thisVar->varData.theString = NULL;
		break;

		case SVT_STACK:
		thisVar->varData.theStack -> timesUsed --;
		if (thisVar->varData.theStack -> timesUsed <= 0) {
			while (thisVar->varData.theStack -> first) trimStack (&thisVar->varData.theStack -> first);
			FreeVec(thisVar->varData.theStack);
			thisVar->varData.theStack = NULL;
		}



		break;

		case SVT_FASTARRAY:
		thisVar->varData.fastArray -> timesUsed --;
		if (thisVar->varData.theStack -> timesUsed <= 0) {
            FreeVec( thisVar->varData.fastArray -> fastVariables);
			FreeVec(thisVar->varData.fastArray);
			thisVar->varData.fastArray = NULL;
		}
		break;

		case SVT_ANIM:
		deleteAnim (thisVar->varData.animHandler);
		break;

		default:
		break;
	}
}

BOOL copyMain (const struct variable *from, struct variable *to) {
	to->varType = from->varType;
	switch (to->varType) {
		case SVT_INT:
		case SVT_FUNC:
		case SVT_BUILT:
		case SVT_FILE:
		case SVT_OBJTYPE:
		to->varData.intValue = from->varData.intValue;
		return TRUE;

		case SVT_FASTARRAY:
		to->varData.fastArray = from->varData.fastArray;
		to->varData.fastArray -> timesUsed ++;
		return TRUE;

		case SVT_STRING:
		to->varData.theString = copyString (from->varData.theString);
		return to->varData.theString ? TRUE : FALSE;

		case SVT_STACK:
		to->varData.theStack = from->varData.theStack;
		to->varData.theStack -> timesUsed ++;
		return TRUE;

		case SVT_COSTUME:
		to->varData.costumeHandler = from->varData.costumeHandler;
		return TRUE;

		case SVT_ANIM:
		to->varData.animHandler = copyAnim (from->varData.animHandler);
		return TRUE;

		case SVT_NULL:
		return TRUE;

		default:
		break;
	}
	KPrintF("Unknown value type");
	return FALSE;
}

BOOL copyVariable (const struct variable *from, struct variable *to) {
	unlinkVar (to);
	return copyMain(from, to);
}

struct personaAnimation * getAnimationFromVar (struct variable *thisVar) {
	if (thisVar->varType == SVT_ANIM)
		return copyAnim (thisVar->varData.animHandler);

	if (thisVar->varType == SVT_INT && thisVar->varData.intValue == 0)
		return makeNullAnim();

	KPrintF("Expecting an animation variable; found variable of type", typeName[thisVar->varType]);
	return NULL;
}

BOOL getBoolean (const struct variable *from) {
	switch (from->varType) {
		case SVT_NULL:
		return FALSE;

		case SVT_INT:
		return (BOOL) (from->varData.intValue != 0);

		case SVT_STACK:
		return (BOOL) (from->varData.theStack -> first != NULL);

		case SVT_STRING:
		return (BOOL) (from->varData.theString[0] != 0);

		case SVT_FASTARRAY:
		return (BOOL) (from->varData.fastArray -> size != 0);

		default:
		break;
	}
	return TRUE;
}

char * getTextFromAnyVar (const struct variable *from) {
	switch (from->varType) {
		case SVT_STRING:
		return copyString (from->varData.theString);

		case SVT_FASTARRAY:
		{
			char * builder = copyString ("FAST:");
			char * builder2;
			char * grabText;

			for (int i = 0; i < from->varData.fastArray -> size; i ++) {
				builder2 = joinStrings (builder, " ");
				if (! builder2) return NULL;
				FreeVec(builder);
				grabText = getTextFromAnyVar (&from->varData.fastArray -> fastVariables[i]);
				builder = joinStrings (builder2, grabText);
				if (! builder) return NULL;
				FreeVec(grabText);
				grabText = NULL;
				FreeVec(builder2);
				builder2 = NULL;
			}
			return builder;
		}

		case SVT_STACK:
		{
			char * builder = copyString ("ARRAY:");
			char * builder2;
			char * grabText;

			struct variableStack * stacky = from->varData.theStack -> first;

			while (stacky) {
				builder2 = joinStrings (builder, " ");
				if (! builder2) return NULL;
				FreeVec(builder);
				grabText = getTextFromAnyVar (&stacky -> thisVar);
				builder = joinStrings (builder2, grabText);
				if (! builder) return NULL;
				FreeVec(grabText);
				grabText = NULL;
				FreeVec(builder2);
				builder2 = NULL;
				stacky = stacky -> next;
			}
			return builder;
		}

		case SVT_INT:
		{
			char * buff = AllocVec(10, MEMF_ANY);
			if (! buff) {
				KPrintF("getTextFromAnyVar: Cannot allocate Memory");
				return NULL;
			}
			sprintf (buff, "%i", from->varData.intValue);
			return buff;
		}

		case SVT_FILE:
		{

			return joinStrings ("", resourceNameFromNum (from->varData.intValue));
		}

		case SVT_OBJTYPE:
		{
			struct objectType * thisType = findObjectType (from->varData.intValue);
			if (thisType) return copyString (thisType -> screenName);
		}

		default:
		break;
	}

	return copyString (typeName[from->varType]);
}


void newAnimationVariable (struct variable *thisVar, struct personaAnimation * i) {
	unlinkVar (thisVar);
	thisVar->varType = SVT_ANIM;
	thisVar->varData.animHandler = i;
}

void newCostumeVariable (struct variable * thisVar, struct persona * i) {
	unlinkVar(thisVar);
	thisVar->varType = SVT_COSTUME;
	thisVar->varData.costumeHandler = i;
}

void setVariable (struct variable *thisVar, enum variableType vT, int value) {
	unlinkVar (thisVar);	thisVar->varType = vT;
	thisVar->varData.intValue = value;}

struct variable * stackGetByIndex (struct variableStack * vS, unsigned int theIndex) {
    while (theIndex--) {
        vS = vS->next;
        if (!vS) {
            return NULL;
        }
    }
    return &(vS->thisVar);
}

// Would be a LOT better just to keep this up to date in deletevarfromstack function... ah well
struct variableStack * stackFindLast (struct variableStack * hunt) {
	if (hunt == NULL)
		return NULL;

	while (hunt->next)
		hunt = hunt->next;

	return hunt;
}

int stackSize (const struct stackHandler * me) {
	int r = 0;
	struct variableStack * a = me -> first;
	while (a) {
		r ++;
		a = a -> next;
	}
	return r;
}

void trimStack (struct variableStack ** stack) {

	struct variableStack* killMe = *stack;

	*stack = (*stack)->next;

	// When calling this, we've ALWAYS checked that stack != NULL
	unlinkVar (&(killMe -> thisVar));
	FreeVec(killMe);
}