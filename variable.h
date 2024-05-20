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
	struct fastArrayHandler *			fastArray;
};

struct variable {
	enum variableType				varType;
	union variableData				varData;
};

struct variableStack {
	struct variable					thisVar;
	struct variableStack	* 			next;
};

#define initVarNew(thisVar) 	thisVar.varType = SVT_NULL