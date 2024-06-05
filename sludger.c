#include <proto/exec.h>
#include <proto/dos.h>

#include "sludger.h"
#include "builtin.h"
#include "errors.h"
#include "fileset.h"
#include "graphics.h"
#include "loadsave.h"
#include "language.h"
#include "moreio.h"
#include "people.h"
#include "statusba.h"
#include "stringy.h"
#include "support/gcc8_c_support.h"
#include "variable.h"
#include "version.h"

extern int desiredfps;
extern int dialogValue;
extern struct personaAnimation * mouseCursorAnim;

struct eventHandlers mainHandlers;

char * * allBIFNames = NULL;
char * * allResourceNames = NULL;
unsigned char brightnessLevel = 255;
struct loadedFunction * allRunningFunctions = NULL;
char * * allUserFunc = NULL;
BOOL captureAllKeys = FALSE;
struct eventHandlers * currentEvents = & mainHandlers;
FILETIME fileTime;
int gameVersion;
extern struct loadedFunction * saverFunc;
struct variable * globalVars;
struct inputType input;
int languageNum = -1;
int lastFramesPerSecond = -1;
char * loadNow = NULL;
struct variableStack * noStack = NULL;
int numBIFNames = 0;
int numGlobals;
int numResourceNames = 0;
int numUserFunc = 0;
int specialSettings;


void abortFunction (struct loadedFunction * fun) {
	int a;

	pauseFunction (fun);
	while (fun -> stack) trimStack (fun -> stack);
	FreeVec( fun -> compiledLines);
	for (a = 0; a < fun -> numLocals; a ++) unlinkVar (&(fun -> localVars[a]));
	FreeVec(fun -> localVars);
	unlinkVar (fun -> reg);
	if (fun -> calledBy) abortFunction (fun -> calledBy);
	FreeVec(fun);
	fun = NULL;
}

BOOL continueFunction (struct loadedFunction * fun) {
	BOOL keepLooping = TRUE;
	BOOL advanceNow;
	unsigned int param;
	enum sludgeCommand com;

	if (fun -> cancelMe) {
		abortFunction (fun);
		return TRUE;
	}

	while (keepLooping) {
		advanceNow = TRUE;
		param = fun -> compiledLines[fun -> runThisLine].param;
		com = fun -> compiledLines[fun -> runThisLine].theCommand;
//		fprintf (stderr, "com: %d param: %d (%s)\n", com, param,
//				(com < numSludgeCommands) ? sludgeText[com] : ERROR_UNKNOWN_MCODE); fflush(stderr);

		switch (com) {
			case SLU_RETURN:
			if (fun -> calledBy) {
				struct loadedFunction * returnTo = fun -> calledBy;
				if (fun -> returnSomething) copyVariable (fun -> reg, returnTo -> reg);
				finishFunction (fun);
				fun = returnTo;
				restartFunction (fun);
			} else {
				finishFunction (fun);
				advanceNow = FALSE;		// So we don't do anything else with "fun"
				keepLooping = FALSE;	// So we drop out of the loop
			}
			break;

			case SLU_CALLIT:
			switch (fun -> reg->varType) {
				case SVT_FUNC:
				pauseFunction (fun);		
				if (! startNewFunctionNum (fun -> reg->varData.intValue, param, fun, fun -> stack,TRUE)) return FALSE;
				fun = allRunningFunctions;
				advanceNow = FALSE;		// So we don't do anything else with "fun"
				break;

				case SVT_BUILT:
					{
					enum builtReturn br = callBuiltIn (fun -> reg->varData.intValue, param, fun);

					switch (br) {
						case BR_ERROR:
							KPrintF("Unknown error. This shouldn't happen. Please notify the SLUDGE developers.");
							return FALSE;

						case BR_PAUSE:
						pauseFunction (fun);
						// No break!

						case BR_KEEP_AND_PAUSE:
						keepLooping = FALSE;
						break;

						case BR_ALREADY_GONE:
						keepLooping = FALSE;
						advanceNow = FALSE;
						break;

						case BR_CALLAFUNC:
						{
							int i = fun -> reg->varData.intValue;
							setVariable (fun -> reg, SVT_INT, 1);
							pauseFunction (fun);							
							if (! startNewFunctionNum (i, 0, fun, noStack, FALSE)) return FALSE;
							fun = allRunningFunctions;
							advanceNow = FALSE;		// So we don't do anything else with "fun"
						}
						break;

						default:
						break;
					}
				}
				break;

				default:
				KPrintF(ERROR_CALL_NONFUNCTION);
				return FALSE;
			}
			break;

			// These all grab things and shove 'em into the register

			case SLU_LOAD_NULL:
			setVariable (fun -> reg, SVT_NULL, 0);
			break;

			case SLU_LOAD_FILE:
			setVariable (fun -> reg, SVT_FILE, param);
			break;

			case SLU_LOAD_VALUE:
			setVariable (fun -> reg, SVT_INT, param);
			break;

			case SLU_LOAD_LOCAL:
			if (! copyVariable (&(fun -> localVars[param]), fun -> reg)) return FALSE;
			break;

			case SLU_AND:
			setVariable (fun -> reg, SVT_INT, getBoolean (fun -> reg) && getBoolean(&(fun -> stack -> thisVar)));
			trimStack (fun -> stack);
			break;

			case SLU_OR:
			setVariable (fun -> reg, SVT_INT, getBoolean (fun -> reg) || getBoolean (&(fun -> stack -> thisVar)));
			trimStack (fun -> stack);
			break;

			case SLU_LOAD_FUNC:
			setVariable (fun -> reg, SVT_FUNC, param);
			break;

			case SLU_LOAD_BUILT:
			setVariable (fun -> reg, SVT_BUILT, param);
			break;

			case SLU_LOAD_OBJTYPE:
			setVariable (fun -> reg, SVT_OBJTYPE, param);
			break;

			case SLU_UNREG:
			if (dialogValue != 1) {
				KPrintF(ERROR_HACKER);
				return FALSE;
			}
			break;

			case SLU_LOAD_STRING:
				if (! loadStringToVar (fun -> reg, param)) {
					return FALSE;
				}
			break;

			case SLU_INDEXGET:
			case SLU_INCREMENT_INDEX:
			case SLU_DECREMENT_INDEX:
			switch (fun -> stack -> thisVar.varType) {
				case SVT_NULL:
				if (com == SLU_INDEXGET) {
					setVariable (fun -> reg, SVT_NULL, 0);
					trimStack (fun -> stack);
				} else {
					KPrintF((ERROR_INCDEC_UNKNOWN));
					return FALSE;
				}
				break;

				case SVT_FASTARRAY:
				case SVT_STACK:
				if (fun -> stack -> thisVar.varData.theStack -> first == NULL) {
					KPrintF((ERROR_INDEX_EMPTY));
					return FALSE;
				} else {
					int ii;
					if (! getValueType(&ii, SVT_INT,&fun -> reg)) return FALSE;
					struct variable * grab = (fun -> stack -> thisVar.varType == SVT_FASTARRAY) ?
						fastArrayGetByIndex (fun -> stack -> thisVar.varData.fastArray, ii)
							:
						stackGetByIndex (fun -> stack -> thisVar.varData.theStack -> first, ii);

					trimStack (fun -> stack);

					if (! grab) {
						setVariable (fun -> reg, SVT_NULL, 0);
					} else {
						int ii;
						switch (com) {
							case SLU_INCREMENT_INDEX:
							if (! getValueType (&ii, SVT_INT, grab)) return FALSE;
							setVariable (fun -> reg, SVT_INT, ii);
							grab -> varData.intValue = ii + 1;
							break;

							case SLU_DECREMENT_INDEX:
							if (! getValueType (&ii, SVT_INT, grab)) return FALSE;
							setVariable (fun -> reg, SVT_INT, ii);
							grab -> varData.intValue = ii - 1;
							break;

							default:
							if (! copyVariable (grab, fun -> reg)) return FALSE;
						}
					}
				}
				break;

				default:
				KPrintF((ERROR_INDEX_NONSTACK));
				return FALSE;
			}
			break;

			case SLU_INDEXSET:
			switch (fun -> stack -> thisVar.varType) {
				case SVT_STACK:
				if (fun -> stack -> thisVar.varData.theStack -> first == NULL) {
					KPrintF((ERROR_INDEX_EMPTY));
					return FALSE;
				} else {
					int ii;
					if (! getValueType(&ii, SVT_INT,&fun -> reg)) return FALSE;
					if (! stackSetByIndex (fun -> stack -> thisVar.varData.theStack -> first, ii, fun -> stack -> next -> thisVar)) {
						return FALSE;
					}
					trimStack (fun -> stack);
					trimStack (fun -> stack);
				}
				break;

				case SVT_FASTARRAY:
				{
					int ii;
					if (! getValueType (&ii, SVT_INT, &fun->reg)) return FALSE;
					struct variable * v = fastArrayGetByIndex (fun -> stack -> thisVar.varData.fastArray, ii);
					if (v == NULL) KPrintF(("Not within bounds of fast array."));
					return FALSE;
					if (! copyVariable (&(fun -> stack -> next -> thisVar), v)) return FALSE;
					trimStack (fun -> stack);
					trimStack (fun -> stack);
				}
				break;

				default:
				KPrintF((ERROR_INDEX_NONSTACK));
				return FALSE;
			}
			break;

			// What can we do with the register? Well, we can copy it into a local
			// variable, a global or onto the stack...

			case SLU_INCREMENT_LOCAL:
			{
				int ii;
				if (! getValueType(&ii, SVT_INT,&fun -> localVars[param])) return FALSE;
				setVariable (fun -> reg, SVT_INT, ii);
				setVariable (&(fun -> localVars[param]), SVT_INT, ii + 1);
			}
			break;

			case SLU_INCREMENT_GLOBAL:
			{
				int ii;
				if (! getValueType(&ii, SVT_INT,&globalVars[param])) return FALSE;
				setVariable (fun -> reg, SVT_INT, ii);
				setVariable (&globalVars[param], SVT_INT, ii + 1);
			}
			break;

			case SLU_DECREMENT_LOCAL:
			{
				int ii;
				if (! getValueType(&ii, SVT_INT,&fun -> localVars[param])) return FALSE;
				setVariable (fun -> reg, SVT_INT, ii);
				setVariable (&(fun -> localVars[param]), SVT_INT, ii - 1);
			}
			break;

			case SLU_DECREMENT_GLOBAL:
			{
				int ii;
				if (! getValueType(&ii, SVT_INT,&globalVars[param])) return FALSE;
				setVariable (fun -> reg, SVT_INT, ii);
				setVariable (&globalVars[param], SVT_INT, ii - 1);
			}
			break;

			case SLU_SET_LOCAL:
			if (! copyVariable (fun -> reg, &(fun -> localVars[param]))) return FALSE;
			break;

			case SLU_SET_GLOBAL:
//			newDebug ("  Copying TO global variable", param);
//			newDebug ("  Global type at the moment", globalVars[param].varType);
			if (! copyVariable (fun -> reg, &globalVars[param])) return FALSE;
//			newDebug ("  New type", globalVars[param].varType);
			break;

			case SLU_LOAD_GLOBAL:
//			newDebug ("  Copying FROM global variable", param);
//			newDebug ("  Global type at the moment", globalVars[param].varType);
			if (! copyVariable (&globalVars[param], fun -> reg)) return FALSE;
			break;

			case SLU_STACK_PUSH:
			if (! addVarToStack (fun -> reg, fun -> stack)) return FALSE;
			break;

			case SLU_QUICK_PUSH:
			if (! addVarToStackQuick (fun -> reg, fun -> stack)) return FALSE;
			break;

			case SLU_NOT:
			setVariable (fun -> reg, SVT_INT, ! getBoolean (fun -> reg));
			break;

			case SLU_BR_ZERO:
			if (! getBoolean (fun -> reg)) {
				advanceNow = FALSE;
				fun -> runThisLine = param;
			}
			break;

			case SLU_BRANCH:
			advanceNow = FALSE;
			fun -> runThisLine = param;
			break;

			case SLU_NEGATIVE:
			{
				int i;
				if (! getValueType(&i, SVT_INT,&fun -> reg)) return FALSE;
				setVariable (fun -> reg, SVT_INT, -i);
			}
			break;

			// All these things rely on there being somet' on the stack

			case SLU_MULT:
			case SLU_PLUS:
			case SLU_MINUS:
			case SLU_MODULUS:
			case SLU_DIVIDE:
			case SLU_EQUALS:
			case SLU_NOT_EQ:
			case SLU_LESSTHAN:
			case SLU_MORETHAN:
			case SLU_LESS_EQUAL:
			case SLU_MORE_EQUAL:
			if (fun -> stack) {
				int firstValue, secondValue;

				switch (com) {
					case SLU_PLUS:
					addVariablesInSecond (fun -> stack -> thisVar, fun -> reg);
					trimStack (fun -> stack);
					break;

					case SLU_EQUALS:
					compareVariablesInSecond (&(fun -> stack -> thisVar), &(fun -> reg));
					trimStack (fun -> stack);
					break;

					case SLU_NOT_EQ:
					compareVariablesInSecond (&(fun -> stack -> thisVar), &(fun -> reg));
					trimStack (fun -> stack);
	               	fun -> reg->varData.intValue = ! fun -> reg->varData.intValue;
					break;

					default:
					if (! getValueType (&firstValue, SVT_INT, &fun->stack->thisVar)) return FALSE;
					if (! getValueType(&secondValue, SVT_INT,&fun -> reg)) return FALSE;
					trimStack (fun -> stack);

					switch (com) {
						case SLU_MULT:
						setVariable (fun -> reg, SVT_INT, firstValue * secondValue);
						break;

						case SLU_MINUS:
						setVariable (fun -> reg, SVT_INT, firstValue - secondValue);
						break;

						case SLU_MODULUS:
						setVariable (fun -> reg, SVT_INT, firstValue % secondValue);
						break;

						case SLU_DIVIDE:
						setVariable (fun -> reg, SVT_INT, firstValue / secondValue);
						break;

						case SLU_LESSTHAN:
						setVariable (fun -> reg, SVT_INT, firstValue < secondValue);
						break;

						case SLU_MORETHAN:
						setVariable (fun -> reg, SVT_INT, firstValue > secondValue);
						break;

						case SLU_LESS_EQUAL:
						setVariable (fun -> reg, SVT_INT, firstValue <= secondValue);
						break;

						case SLU_MORE_EQUAL:
						setVariable (fun -> reg, SVT_INT, firstValue >= secondValue);
						break;

						default:
						break;
					}
				}
			} else {
				KPrintF((ERROR_NOSTACK));
				return FALSE;
			}
			break;

			default:
			KPrintF((ERROR_UNKNOWN_CODE));
			return FALSE;
		}

		if (advanceNow) fun -> runThisLine ++;

	}
	return TRUE;
}

void finishFunction (struct loadedFunction * fun) {
	int a;

	pauseFunction (fun);
	if (fun -> stack) KPrintF("finishfunction:", ERROR_NON_EMPTY_STACK);
	FreeVec( fun -> compiledLines);
	for (a = 0; a < fun -> numLocals; a ++) unlinkVar (&(fun -> localVars[a]));
	FreeVec(fun -> localVars);
	unlinkVar (fun -> reg);
	FreeVec(fun);
	fun = NULL;
}

BOOL handleInput () {
	//Amiga Todo: Actually handle input
	return runSludge ();
}

BOOL initSludge (char * filename) {
	int a = 0;
	mouseCursorAnim = makeNullAnim ();

	//Amiga: Attention. This was changed to a Nonpointer Type
	BPTR fp = openAndVerify (filename, 'G', 'E', ERROR_BAD_HEADER, &gameVersion);
	if (! fp) return FALSE;
	if (FGetC (fp)) {
		numBIFNames = get2bytes (fp);
		allBIFNames = AllocVec(numBIFNames,MEMF_ANY);
		if(allBIFNames == 0) return FALSE;
		for (int fn = 0; fn < numBIFNames; fn ++) {
			allBIFNames[fn] = (char *) readString (fp);
		}
		numUserFunc = get2bytes (fp);
		allUserFunc = AllocVec(numUserFunc,MEMF_ANY);
		if( allUserFunc == 0) return FALSE;

		for (int fn = 0; fn < numUserFunc; fn ++) {
			allUserFunc[fn] =   (char *) readString (fp);
		}
		if (gameVersion >= VERSION(1,3)) {
			numResourceNames = get2bytes (fp);
			allResourceNames = AllocVec(numResourceNames,MEMF_ANY);
			if(allResourceNames == 0) return FALSE;

			for (int fn = 0; fn < numResourceNames; fn ++) {
				allResourceNames[fn] =  (char *) readString (fp);
			}
		}
	}
	winWidth = get2bytes (fp);
	winHeight = get2bytes (fp);
	specialSettings = FGetC (fp);

	desiredfps = 1000/FGetC (fp);

	FreeVec(readString (fp));

	ULONG blocks_read = FRead( fp, &fileTime, sizeof (FILETIME), 1 ); 
	if (blocks_read != 1) {
		KPrintF("Reading error in initSludge.\n");
	}

	char * dataFol = (gameVersion >= VERSION(1,3)) ? readString(fp) : joinStrings ("", "");

	gameSettings.numLanguages = (gameVersion >= VERSION(1,3)) ? (FGetC (fp)) : 0;
	makeLanguageTable (fp);

	if (gameVersion >= VERSION(1,6))
	{
		FGetC(fp);
		// aaLoad
		FGetC (fp);
		getFloat (fp);
		getFloat (fp);
	}

	char * checker = readString (fp);

	if (strcmp (checker, "okSoFar")) {
		return FALSE;
	}
	FreeVec( checker);
	checker = NULL;

    unsigned char customIconLogo = FGetC (fp);

	if (customIconLogo & 1) {
		// There is an icon - read it!
		Write(Output(), (APTR)"initsludge:Game Icon not supported on this plattform.\n", 54);
		KPrintF("initsludge: Game Icon not supported on this plattform.\n");
		return FALSE;
	}

	numGlobals = get2bytes (fp);

	globalVars = AllocVec( sizeof(struct variable) * numGlobals,MEMF_ANY);
	if(globalVars == 0) {
		KPrintF("initsludge: Cannot allocate memory for globalvars\n");
		return FALSE;
	}		 
	for (a = 0; a < numGlobals; a ++) initVarNew (globalVars[a]);

	setFileIndices (fp, gameSettings.numLanguages, 0);

	char * gameNameOrig = getNumberedString(1);	
	char * gameName = encodeFilename (gameNameOrig);

	FreeVec(gameNameOrig);

	BPTR lock = CreateDir( gameName );
	if(lock == 0) {
		//Directory does already exist
		lock = Lock(gameName, ACCESS_READ);
	}

	if (!CurrentDir(lock)) {
		KPrintF("initsludge: Failed changing to directory %s\n", gameName);
		Write(Output(), (APTR)"initsludge:Failed changing to directory\n", 40);
		return FALSE;
	}

	FreeVec(gameName);

	readIniFile (filename);

	// Now set file indices properly to the chosen language.
	languageNum = getLanguageForFileB ();
	if (languageNum < 0) KPrintF("Can't find the translation data specified!");
	setFileIndices (NULL, gameSettings.numLanguages, languageNum);

	if (dataFol[0]) {
		char *dataFolder = encodeFilename(dataFol);
		lock = CreateDir( dataFolder );
		if(lock == 0) {
			//Directory does already exist
			lock = Lock(dataFolder, ACCESS_READ);		
		}


		if (!CurrentDir(lock)) {
			(Output(), (APTR)"initsludge:This game's data folder is inaccessible!\n", 52);
		}
		FreeVec(dataFolder);
	}

 	positionStatus (10, winHeight - 15);

	return TRUE;
}

void killSpeechTimers () {
	struct loadedFunction * thisFunction = allRunningFunctions;

	while (thisFunction) {
		if (thisFunction -> freezerLevel == 0 && thisFunction -> isSpeech && thisFunction -> timeLeft) {
			thisFunction -> timeLeft = 0;
			thisFunction -> isSpeech = FALSE;
		}
		thisFunction = thisFunction -> next;
	}

	killAllSpeech ();
}

BOOL loadFunctionCode (struct loadedFunction * newFunc) {
	unsigned int numLines, numLinesRead;
	int a;

	if (! openSubSlice (newFunc -> originalNumber)) return FALSE;
	

	newFunc-> unfreezable	= FGetC (bigDataFile);
	numLines				= get2bytes (bigDataFile);
	newFunc -> numArgs		= get2bytes (bigDataFile);
	newFunc -> numLocals	= get2bytes (bigDataFile);
	newFunc -> compiledLines = AllocVec( sizeof(struct lineOfCode) * numLines,MEMF_ANY);
	if (! newFunc -> compiledLines) {
		KPrintF("loadFunctionCode: cannot allocate memory");
		return FALSE;
	}

	for (numLinesRead = 0; numLinesRead < numLines; numLinesRead ++) {
		newFunc -> compiledLines[numLinesRead].theCommand = (enum sludgeCommand) FGetC(bigDataFile);
		newFunc -> compiledLines[numLinesRead].param = get2bytes (bigDataFile);
	}

	finishAccess ();

	// Now we need to reserve memory for the local variables
	if(newFunc->numLocals > 1) {
		newFunc -> localVars = AllocVec( sizeof(struct variable) * newFunc->numLocals,MEMF_ANY);
		if (!newFunc -> localVars) {
			KPrintF("loadFunctionCode: cannot allocate memory");
			return FALSE;
		}

		for (a = 0; a < newFunc -> numLocals; a ++) {
			initVarNew (newFunc -> localVars[a]);
		}
	}
	return TRUE;
}

void loadHandlers (BPTR fp) {
	currentEvents -> leftMouseFunction		= get2bytes (fp);
	currentEvents -> leftMouseUpFunction	= get2bytes (fp);
	currentEvents -> rightMouseFunction		= get2bytes (fp);
	currentEvents -> rightMouseUpFunction	= get2bytes (fp);
	currentEvents -> moveMouseFunction		= get2bytes (fp);
	currentEvents -> focusFunction			= get2bytes (fp);
	currentEvents -> spaceFunction			= get2bytes (fp);
}

BPTR openAndVerify (char * filename, char extra1, char extra2, const char * er, int *fileVersion) {
	BPTR fp = Open(filename,MODE_OLDFILE);

	if (! fp) {
		Write(Output(), (APTR)"openAndVerify: Can't open file\n", 31);
		KPrintF("openAndVerify: Can't open file", filename);
		return NULL;
	}
	BOOL headerBad = FALSE;
	if (FGetC (fp) != 'S') headerBad = TRUE;
	if (FGetC (fp) != 'L') headerBad = TRUE;
	if (FGetC (fp) != 'U') headerBad = TRUE;
	if (FGetC (fp) != 'D') headerBad = TRUE;
	if (FGetC (fp) != extra1) headerBad = TRUE;
	if (FGetC (fp) != extra2) headerBad = TRUE;
	if (headerBad) {
		Write(Output(), (APTR)"openAndVerify: Bad Header\n", 31);
		KPrintF("openAndVerify: Bad Header\n");
		return NULL;
	}
	FGetC (fp);
	while (FGetC(fp)) {;}

	int majVersion = FGetC (fp);
	int minVersion = FGetC (fp);
	*fileVersion = majVersion * 256 + minVersion;

	char txtVer[120];

	if (*fileVersion > WHOLE_VERSION) {
		//sprintf (txtVer, ERROR_VERSION_TOO_LOW_2, majVersion, minVersion);
		Write(Output(), (APTR)ERROR_VERSION_TOO_LOW_1, 100);
		KPrintF(ERROR_VERSION_TOO_LOW_1);
		return NULL;
	} else if (*fileVersion < MINIM_VERSION) {
		Write(Output(), (APTR)ERROR_VERSION_TOO_HIGH_1, 100);
		KPrintF(ERROR_VERSION_TOO_HIGH_1);
		return NULL;
	}
	return fp;
}

void pauseFunction (struct loadedFunction * fun) {
	struct loadedFunction * * huntAndDestroy = & allRunningFunctions;
	while (* huntAndDestroy) {
		if (fun == * huntAndDestroy) {
			(* huntAndDestroy) = (* huntAndDestroy) -> next;
			fun->next = NULL;
		} else {
			huntAndDestroy = & (* huntAndDestroy) -> next;
		}
	}
}

void restartFunction (struct loadedFunction * fun) {
	fun -> next = allRunningFunctions;
	allRunningFunctions = fun;
}

BOOL runSludge () {
	
	struct loadedFunction * thisFunction = allRunningFunctions;
	struct loadedFunction * nextFunction;

	while (thisFunction) {
		nextFunction = thisFunction -> next;

		if (! thisFunction -> freezerLevel) {
			if (thisFunction -> timeLeft) {
				if (thisFunction -> timeLeft < 0) {				
					thisFunction -> timeLeft = 0;
				} else if (! -- (thisFunction -> timeLeft)) {
				}
			} else {
				if (thisFunction -> isSpeech) {
					thisFunction -> isSpeech = FALSE;
					killAllSpeech ();
				}
				if (! continueFunction (thisFunction))
					return FALSE;
			}
		}

		thisFunction = nextFunction;
	}

	if (loadNow) {
		if (loadNow[0] == ':') {
			saveGame (loadNow + 1);
			setVariable (saverFunc->reg, SVT_INT, 1);
		} else {
			if (! loadGame (loadNow)) return FALSE;
		}
		FreeVec(loadNow);
		loadNow = NULL;
	}

	return TRUE;
}

void saveHandlers (BPTR fp) {
	put2bytes (currentEvents -> leftMouseFunction,		fp);
	put2bytes (currentEvents -> leftMouseUpFunction,	fp);
	put2bytes (currentEvents -> rightMouseFunction,		fp);
	put2bytes (currentEvents -> rightMouseUpFunction,	fp);
	put2bytes (currentEvents -> moveMouseFunction,		fp);
	put2bytes (currentEvents -> focusFunction,			fp);
	put2bytes (currentEvents -> spaceFunction,			fp);
}

int startNewFunctionNum (unsigned int funcNum, unsigned int numParamsExpected, struct loadedFunction * calledBy, struct variableStack * vStack, BOOL returnSommet) {
	struct loadedFunction * newFunc = AllocVec(sizeof(struct loadedFunction),MEMF_ANY);
	if(!newFunc) {
		KPrintF("startNewFunction: Cannot allocate memory");
		return 0;
	}
	newFunc -> originalNumber = funcNum;

	loadFunctionCode (newFunc);

	if (newFunc -> numArgs != (int)numParamsExpected) {
		KPrintF("Wrong number of parameters!");
		return NULL; 
	}
	if (newFunc -> numArgs > newFunc -> numLocals)  {
		KPrintF ("More arguments than local variable space!");
		return NULL; 
	}
	
	// Now, lets copy the parameters from the calling function's stack...

	while (numParamsExpected) {
		numParamsExpected --;
		if (vStack == NULL) {
			KPrintF("Corrupted file! The stack's empty and there were still parameters expected");
			return NULL;
		}
		copyVariable (&vStack -> thisVar, &newFunc->localVars[numParamsExpected]);
		trimStack (vStack);
	}

	newFunc -> cancelMe = FALSE;
	newFunc -> timeLeft = 0;
	newFunc -> returnSomething = returnSommet;
	newFunc -> calledBy = calledBy;
	newFunc -> stack = NULL;
	newFunc -> freezerLevel = 0;
	newFunc -> runThisLine = 0;
	newFunc -> isSpeech = 0;
	newFunc -> reg -> varType = SVT_NULL;

	restartFunction (newFunc);
	return 1;
}
