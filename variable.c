#include <proto/exec.h>
#include "support/gcc8_c_support.h"
#include "people.h"
#include "stringy.h"
#include "variable.h"

void unlinkVar (struct variable thisVar) {
	switch (thisVar.varType) {
		case SVT_STRING:
        FreeVec(thisVar.varData.theString);
		thisVar.varData.theString = NULL;
		break;

		case SVT_STACK:
		thisVar.varData.theStack -> timesUsed --;
		if (thisVar.varData.theStack -> timesUsed <= 0) {
			while (thisVar.varData.theStack -> first) trimStack (thisVar.varData.theStack -> first);
			FreeVec(thisVar.varData.theStack);
			thisVar.varData.theStack = NULL;
		}
		break;

		case SVT_FASTARRAY:
		thisVar.varData.fastArray -> timesUsed --;
		if (thisVar.varData.theStack -> timesUsed <= 0) {
            FreeVec( thisVar.varData.fastArray -> fastVariables);
			FreeVec(thisVar.varData.fastArray);
			thisVar.varData.fastArray = NULL;
		}
		break;

		case SVT_ANIM:
		deleteAnim (thisVar.varData.animHandler);
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

BOOL copyVariable (const struct variable from, struct variable to) {
	unlinkVar (to);
	return copyMain (from, to);
}

void trimStack (struct variableStack * stack) {
	struct variableStack * killMe = stack;
	stack = stack -> next;

	// When calling this, we've ALWAYS checked that stack != NULL
	unlinkVar (killMe -> thisVar);
	FreeVec(killMe);
}