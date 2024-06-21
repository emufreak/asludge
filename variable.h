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

void addVariablesInSecond(struct variable * var1, struct variable * var2);
BOOL addVarToStack(const struct variable * va, struct variableStack ** thisStack);
BOOL addVarToStackQuick(struct variable *va, struct variableStack **thisStack);
void compareVariablesInSecond (const struct variable *var1, struct variable *var2);
int compareVars (const struct variable var1, const struct variable var2);
BOOL copyMain (const struct variable from, struct variable to);
BOOL copyStack (const struct variable * from, struct variable * to);
BOOL copyVariable (const struct variable *from, struct variable *to);
char * decodeFilename(char * nameIn);
int deleteVarFromStack(const struct variable *va, struct variableStack **thisStack, BOOL allOfEm);
struct variable * fastArrayGetByIndex (struct fastArrayHandler * vS, unsigned int theIndex);
struct personaAnimation * getAnimationFromVar (struct variable *thisVar);
BOOL getBoolean (const struct variable *from);
struct persona * getCostumeFromVar(struct variable *thisVar);
BOOL getSavedGamesStack(struct stackHandler * sH, char * ext);
BOOL getValueType (int *toHere, enum variableType vT, const struct variable *v);
char * getTextFromAnyVar (const struct variable *from);
BOOL loadStringToVar (struct variable *thisVar, int value);
BOOL loadVariable (struct variable * to, BPTR fp);
void makeTextVar (struct variable *thisVar, const char * txt);
BOOL makeFastArrayFromStack (struct variable *to, const struct stackHandler *stacky);
BOOL makeFastArraySize (struct variable *to, int size);
void newCostumeVariable (struct variable * thisVar, struct persona * i);
void setVariable (struct variable *thisVar, enum variableType vT, int value);
struct variable * stackGetByIndex (struct variableStack * vS, unsigned int theIndex);
int stackSize (const struct stackHandler * me);
struct variableStack * stackFindLast (struct variableStack * hunt);
void trimStack (struct variableStack * stack);
void unlinkVar (struct variable *thisVar);

#define initVarNew(thisVar) 	thisVar.varType = SVT_NULL

#endif