#ifndef __VARIABLE_H__
#define __VARIABLE_H__

enum variableType {SVT_NULL, SVT_INT, SVT_FUNC, SVT_STRING,
				   SVT_BUILT, SVT_FILE, SVT_STACK,
				   SVT_OBJTYPE, SVT_ANIM, SVT_COSTUME,
				   SVT_FASTARRAY, SVT_NUM_TYPES};

struct fastArrayHandler {
	struct variable *			fastVariables;
	int							size;
	int							timesUsed;
};

struct stackHandler {
	struct variableStack *		first;
	struct variableStack *		last;
	int							timesUsed;
};

union variableData {
	signed int					intValue;
	char *						theString;
	struct stackHandler *				theStack;
	struct personaAnimation *	animHandler;
	struct persona *    		costumeHandler;
	struct fastArrayHandler *			fastArray; //Amiga Todo. Check if this works
};

struct variable {
	enum variableType				varType;
	union variableData				varData;
};

struct variableStack {
	struct variable					thisVar;
	struct variableStack	* 			next;
};

BOOL copyVariable (const struct variable *from, struct variable *to);
char * getTextFromAnyVar (const variable *from);
BOOL loadVariable (struct variable * to, BPTR fp);
void setVariable (struct variable *thisVar, enum variableType vT, int value);
void trimStack (struct variableStack * stack);
void unlinkVar (struct variable *thisVar);

#define initVarNew(thisVar) 	thisVar.varType = SVT_NULL

#endif