#include <proto/exec.h>
#include <proto/dos.h>

#include "variable.h"
#include "loadsave.h"
#include "moreio.h"
#include "objtypes.h"
#include "people.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"



const char * typeName[] = {"undefined", "number", "user function", "string",
							"built-in function", "file", "stack",
							"object type", "animation", "costume"};

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

void unlinkVar (struct variable *thisVar) {
	switch (thisVar->varType) {
		case SVT_STRING:
        FreeVec(thisVar->varData.theString);
		thisVar->varData.theString = NULL;
		break;

		case SVT_STACK:
		thisVar->varData.theStack -> timesUsed --;
		if (thisVar->varData.theStack -> timesUsed <= 0) {
			while (thisVar->varData.theStack -> first) trimStack (thisVar->varData.theStack -> first);
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

BOOL copyMain (const struct variable from, struct variable to) {
	to.varType = from.varType;
	switch (to.varType) {
		case SVT_INT:
		case SVT_FUNC:
		case SVT_BUILT:
		case SVT_FILE:
		case SVT_OBJTYPE:
		to.varData.intValue = from.varData.intValue;
		return TRUE;

		case SVT_FASTARRAY:
		to.varData.fastArray = from.varData.fastArray;
		to.varData.fastArray -> timesUsed ++;
		return TRUE;

		case SVT_STRING:
		to.varData.theString = copyString (from.varData.theString);
		return to.varData.theString ? TRUE : FALSE;

		case SVT_STACK:
		to.varData.theStack = from.varData.theStack;
		to.varData.theStack -> timesUsed ++;
		return TRUE;

		case SVT_COSTUME:
		to.varData.costumeHandler = from.varData.costumeHandler;
		return TRUE;

		case SVT_ANIM:
		to.varData.animHandler = copyAnim (from.varData.animHandler);
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
	return copyMain(*from, *to);
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
				grabText = getTextFromAnyVar (from->varData.fastArray -> fastVariables[i]);
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
				grabText = getTextFromAnyVar (stacky -> thisVar);
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
			if (! checkNew (buff)) return NULL;
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

void setVariable (struct variable *thisVar, enum variableType vT, int value) {
	unlinkVar (thisVar);
	thisVar->varType = vT;
	thisVar->varData.intValue = value;
}

void trimStack (struct variableStack * stack) {
	struct variableStack * killMe = stack;
	stack = stack -> next;

	// When calling this, we've ALWAYS checked that stack != NULL
	unlinkVar (&(killMe -> thisVar));
	FreeVec(killMe);
}