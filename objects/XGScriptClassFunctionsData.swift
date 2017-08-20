//
//  XGScriptClassFunctionsInfo.swift
//  XGCommandLineTools
//
//  Created by The Steez on 21/05/2016.
//  Copyright © 2016 Ovation International. All rights reserved.
//

import Foundation

/*

"""
FunctionInfo

List of operators (complete) and class methods

**Priority of types when implicitely converting**:
string < int < float < (not always convertible, like for ex. in the vector methods) vector

**Calling convention for operators**:

(top of stack)
param 2 (if it exists)
param 1

=>

(top of stack)
result

**Calling convention for script functions and methods**:
(top of stack)
etc ...
param 1
param 2

=>
result in $lastResult (for standard functions/methods, this is int(0) by default (i.e unless otherwise mentionned))

^This applies for both standard (callstd) and script-coded (call) function calls

Only the first class (clsID = 0, which is not really a class) does not need a first parameter, but uses 'reserve 0' nevertheless.

All other classes need a instance, be it fake or not. Fake instances are either uninitialized local variables (created along with other local variables,
with 'reserve n'), or most of the time, (still unitialized) singletons (refer to Instruction).

For a script function, the stack has the following layout:

local variable no. n
...
local variable no. 0
return address			($stack[0])
parameter no. 1
...
parameter no. n
(etc ...)


Special callbacks:
(signature : 4 ints)

Map scripts:
pushpop_postprocess,
modify_floor,
preprocess,
hero_main,
postprocesss,
pushpop_preprocess,
talk_follower,
sound,
anywaysave_callback, (when trying to save)
anywaysave_restart, (when saving map data)
etc...

Common script:
(need to be verified)
Function #8 (0x59600008): when the map starts to change
Function #9 (0x59600009): when the map finishes to change
"""


*/

//MARK: - Class Names
let classNames : [Int : String] = [
	 0 : "Standard",
	 4 : "Vector",
	 7 : "Array",
	35 : "Character",
	37 : "Pokemon",
	39 : "Tasks",
	40 : "Dialogs",
	41 : "Transition",
	43 : "Player",
	47 : "Sound",
	52 : "DayCare",
	54 : "TaskManager",
	59 : "ShadowPokemon",
	60 : "PokeSpot"
]

//MARK: - Operators
let operators : [(String,Int,Int)] = [
	//#------------------------------------------------------------------
	//Category(name = "Unary operators", start = 16, nb = 10),
	
	("not", 16, 1),
	("negative", 17, 1),
	("hex", 18, 1),
	("string", 19, 1),
	("integer", 20, 1),
	("float", 21, 1),
	("getvx", 22, 1),
	("getvy", 23, 1),
	("getvz", 24, 1),
	("zerofloat", 25, 1), //# always returns 0.0 ...
	//#------------------------------------------------------------------
	//Category(name = "Binary non-comparison operators", start = 32, nb = 8),
	
	("xor", 32, 2),
	("||", 33, 2),
	("&&", 34, 2),
	("+", 35, 2), //# str + str is defined => con//Catenation
	("-", 36, 2),
	("x", 37, 2), //# int * str or str * int is defined. For vectors = <a,b,c>*<c,d,e> = <a*c, b*d, c*e>
	("/", 38, 2), //# you cannot /0 for ints and floats but for vectors you can ...
	("%", 39, 2), //# operands are implicitly converted to int, if possible.
	//#------------------------------------------------------------------
	//Category(name = "Comparison operators", start = 48, nb = 6),
	
	("==", 48, 2), //# For string equality comparison: '?' every character goes, '*' everything goes after here
	(">", 49, 2), //# ordering of strings is done comparing their respective lengths
	(">=", 50, 2),
	("<", 51, 2),
	("<=", 52, 2),
	("!=", 53, 2)
	//#------------------------------------------------------------------
]

let functions : [Int : [(String,Int,Int,Bool)]] = [
//MARK: - Standard
	0 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Timer-related functions", start = 17, nb = 6),
		("pause", 17, 1, false),
		("yield", 18, 1, false),
		("setTimer", 19, 1, false),
		("getTimer", 20, 1, false),
		("waitUntil", 21, 2, false),
		("printString", 22, 1, false),
		("typename", 29, 1, false),
		("getCharacter", 30, 2, false), //# (str, index)
		("setCharacter", 31, 1, false),
		("findSubstring", 32, 2, false), //#BUGGED, returns -1
		("setBit", 33, 2, false),
		("clearBit", 34, 2, false),
		("mergeBits", 35, 2, false),
		("nand", 36, 2, false),
		//#------------------------------------------------------------------------------------
		//Category(name = "Math functions", start = 48, nb = 6),
		("sin", 48, 1, false), //# trigo. function below work with degrees
		("cos", 49, 1, false),
		("tan", 50, 1, false),
		("atan2", 51, 1, false),
		("acos", 52, 1, false),
		("sqrt", 53, 1, false),
		//#------------------------------------------------------------------------------------
		//Category(name = "Functions manipulating a single flag", start = 129, nb = 5),
		
		("setFlagTotrue", 129, 1, false),
		("setFlagTofalse", 130, 1, false),
		("setFlag", 131, 1, false),
		("checkFlag", 132, 1, false),
		("getFlag", 133, 1, false),
		
		//#------------------------------------------------------------------------------------
		//Category(name = "Misc. 1", start = 136, nb = 5),
		
		("printf", 136, 1, true),
		("rand", 137, 0, false),
		("setShadowPkmStatus", 138, 2, false),
		("checkMultiFlagsInv", 139, 1, true),
		("checkMultiFlags", 140, 1, true),
		//#------------------------------------------------------------------------------------
		//Category(name = "Debugging functions", start = 142, nb = 2),
		
		("syncTaskFromLibraryScript", 142, 3, true), //#nbArgs, function ID, ... (args)
		("setDebugMenuVisibility", 143, 1, false), //# not sure it works on release builds
		
		//Category(name = "Misc. 2", start = 145, nb = 16),
		
		("setPreviousMapID", 145, 1, false), //# the game uses the term "floor"
		("getPreviousMapID", 146, 0, false),
		("unknownFunction147", 147, 2, false), //# (int, float)
		("getPkmSpeciesName", 148, 1, false),
		("unknownFunction147", 149, 1, false), //# some map related function; returns a reference to a character
		("speciesRelatedFunction148", 150, 1, false), //# take the species index as arg
		("getPkmRelatedArrayElement", 151, 1, false), //# (array, index)
		("unknownFunction152", 152, 1, false),
		("distance", 153, 2, false),  //# between the two points whose coordinates are the vector args
		("unknownFunction154", 154, 1, false), //# (character), returns 0 by default
		("unknownFunction155", 155, 6, false),  //# (float, int, int, int, int, int) -> 0
		("GCComListenerDestroy", 154, 0, false), //# so says Dolphin-Emu
		("unknownFunction155", 155, 5, false),  //# (int, float, float, float, float) -> 0
		("unknownFunction156", 156, 1, false), //# return type: (int) -> character
		("getScreenResfreshRate", 157, 0, false), //# FPS as float
		("getRegion", 158, 0, false),
		("getLanguage", 159, 0, false)
	],
	
//MARK: - Vector
	4 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Type conversions", start = 3, nb = 1),
		
		("toString", 3, 1, false),
		//#------------------------------------------------------------------------------------
		
		//Category(name = "Methods", start = 16, nb = 13),
		
		("clear", 16, 1, false),
		("normalize", 17, 1, false),
		("set", 18, 4, false),
		("set2", 19, 4, false),
		("fill", 20, 2, false),
		("abs", 21, 1, false), //#in place
		("negate", 22, 1, false), //#in place
		("isZero", 23, 1, false),
		("crossProduct", 24, 2, false),
		("dotProduct", 25, 2, false),
		("norm", 26, 1, false),
		("squaredNorm", 27, 1, false),
		("angle", 28, 2, false)
	],
	
//MARK: - Array
	7 : [
		//#------------------------------------------------------------------------------------
		("invalidFunction0", 0, 0, false),
		("invalidFunction1", 1, 0, false),
		("invalidFunction2", 2, 0, false),
		//#------------------------------------------------------------------------------------
		//Category(name = "Type conversions", start = 3, nb = 1),
		
		("toString", 3, 1, false),
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (1)", start = 16, nb = 5),
		
		("get", 16, 2, false),
		("set", 17, 3, false),
		("size", 18, 1, false),
		("resize", 19, 2, false), //#REMOVED
		("extend", 20, 2, false), //#REMOVED
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (2) : iterator functions", start = 22, nb = 4),
		
		("resetIterator", 22, 1, false),
		("derefIterator", 23, 2, false),
		("getIteratorPos", 24, 2, false),
		("append", 25, 2, true) //#REMOVED
	],
	
//MARK: - Character
	35 : [
		//# The biggest class out there, there are 99 functions
		
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("setVisibility", 16, 2, false), //# (int visible)
		("displayMsgWithSpeciesSound", 21, 2, false), //# (int msgID, int unk ?)
		//# Uses the species cry from Dialogs::setMsgVar($dialogs, 50, species)
		
		("canSeePlayer", 27, 4, false), //# (unk parameters)
		("setPosition", 29, 3, false), //# (int x, int y, int z)
		
		("setCharacterFlags", 40, 2, false), //# (int flags ?)
		("clearCharacterFlags", 41, 2, false), //# (int flags ?)
		
		("setModel", 70, 1, false), //# (int id)
		
		("talk", 73, 2, true), //# (int type, ...)
		//# Some type of character dialogs (total: 22):
		//# (Valid values for type : 1-3, 6-21).
		//#	(1, msgID): normal msg
		//#	(2, msgID): the character comes at you, then talks, then goes away (to be verified; anyways he/she moves)
		//#	(8, msgID): yes/no question
		//# (battleID, 9, msgID) talks and then initiates a battle
		//# (itemID, 14, msgID) talks and then adds item to player's bag silently
		//#	(15, species): plays the species' cry
		//#	(16, msgID): informative dialog with no sound
	],
	
//MARK: - Pokemon
	37 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("playSpecifiedSpeciesCry", 16, 2, false), //# (int species)
		
		("playCry", 16, 1, false),
		("deleteMove", 17, 1, false), // (int move id)
		
		("getPokeballCaughtWith", 1, 21, false),
		("getNickname", 1, 22, false),
		
		//# index = 23 does not exist
		
		("isShadow", 24, 1, false),
		
		("getCurrentHP", 26, 1, false),
		("getCurrentPurificationCounter", 27, 1, false),
		("getSpeciesIndex", 28, 1, false),
		("isLegendary", 29, 1, false),
		("getHappiness", 30, 1, false),
		("getSomeSpeciesRelatedIndex", 31, 1, false), //# if it's 0 the species is invalid
		("getHeldItem", 32, 1, false),
		("getSIDTID", 33, 1, false),
		
		("teachMove", 34, 1, false), // (int move ide)
		("hasLearnedMove", 35, 1, false), // (int move id)
	],
	
//MARK: - Tasks
	39 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Task creation functions", start = 16, nb = 4),
		//# Function IDs : if (id & 0x59600000) != 0 : current script, otherwise common script (mask = 0x10000000 iirc)
		
		("createSyncTaskByID", 16, 6, false), //# (functionID, then 4 ints passed as parameters)
		("createSyncTaskByName", 17, 6, false), //# the function is selected by its name in the CURRENT script.
		//# HEAD sec. must be present
		("createAsyncTaskByID", 18, 6, false), //# (functionID, then 4 ints passed as parameters)
		("createAsyncTaskByName", 19, 6, false), //# the function is selected by its name in the CURRENT script.
		//# HEAD sec. must be present
		
		("getLastReturnedInt", 20, 1, false),
		("sleep", 21, 2, false) //# (float) (miliseconds)
	],
	
//MARK: - Dialog
	40 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("displatSilentMsgBox", 16, 4, false), //# (int msgID, int isInForeground, int dontDisplayCharByChar)
		("displayMsgBox", 17, 5, false), //# (int msgID, int isInForeground, int dontDisplayCharByChar,
		//# int textSoundPitchLevel)
		("displayYesNoQuestion", 21, 2, false), //# (int msgID)
		
		("setMsgVar", 28, 3, false), //# (int type, var val)
		
		("promptPartyPokemon2", 32, 1, false), //# these functions are **exactly** the same
		("promptPartyPokemon", 33, 1, false),
		("openPokemonSummary", 34, 1, false), //# no arg ...
		
		("promptName", 36, 2, false), //# (int forWho, var target, int mode)
		//# forWho: 0 for Player, 1 for Sister, 2 for Poké. mode: 0 = enter pkm name, 1 = player name, 2 = sister name (not verified)
		("doOpenNamePrompt", 37, 3, false), //# used by the common script only. Don't use this otherwise
		
		("openPokemartMenu", 39, 2, false), //# (int)
		
		("openPADMenu", 41, 1, false),
		("yesOrNoPrompt", 42, 1, false),
		
		("openItemMenu", 50, 1, false),
		
		("moveRelearner", 64, 2, false), //# (int partyIndex)
		
		("openMoneyWindow", 67, 3, false), //# (int x, int y)
		("closeMoneyWindow", 68, 1, false),
		
		("openPkCouponsWindow", 70, 3, false), //# (int x, int y)
		("closePkCouponsWindow", 71, 1, false),
		
	],
	
//MARK: - Transition
	41 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 2),
		
		("setup", 16, 3, false), //#$transition, int flags, float duration
		("checkStatus", 17, 2, false) //#$transition, int waitForCompletion
	],
	
//MARK: - Unknown42
	42 : [
		
		("startBattle", 16, 4, false),
	],
	
//MARK: - Player
	43 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("processEvents", 17, 1, false), //# MUST BE CALLED IN THE IDLE LOOP (usually 'hero_main')
		
		("lockMovement", 18, 0, false),
		("unlockMovement", 18, 0, false),
		
		("receiveItem", 26, 2, false), //# (int amount, int ID)
		("receiveItemWithoutMessage", 27, 2, false), //# (int amount, int ID)
		("hasItemInBag", 28, 1, false), //# (int ID)
		
		("receiveMoney", 29, 2, false), //# (int amount) (can be < 0)
		("getMoney", 30, 1, false),
		
		("countPartyPkm", 34, 1, false), //# (int amount)
		("countShadowPartyPkm", 35, 1, false), //# (int amount)
		
		("getPartyPkmNameAsString", 36, 2, false), //# (int partyIndex)
		
		("receiveGiftOrEventPkm", 37, 2, false), //# (int ID)
		//# 1 to 14:
		//# Male Jolteon (cannot be shiny), Male Vaporeon (cannot), Duking's Plusle (cannot),
		//# Mt. Battle Ho-oh (cannot), Bonus Disc Pikachu (cannot), AGETO Celebi (cannot)
		//#
		//# shadow Togepi (XD) (cannot be shiny), Elekid (can), Meditite (can), Shuckle (can), Larvitar (can),
		//# Chikorita (can), Cyndaquil (can), Totodile (can)
		
		("countPurifiablePartyPkm", 38, 1, false),
		("healParty", 39, 1, false),
		("startGroupBattle", 40, 2, false), //# (int)
		("countNotFaintedPartyPkm", 41, 1, false),
		("getFirstInvalidPartyPkmIndex", 42, 1, false), //# -1 if no invalid pkm
		("countValidPartyPkm", 43, 1, false),
		("getPartyPkm", 44, 2, false), //# (int index)
		("checkPkmOwnership", 45, 2, false), //# (int index)
		
		("countCaughtShadowPokemon", 49, 0, false),
		
		("isPCFull", 52, 1, false),
		("countLegendaryPartyPkm", 53, 1, false),
		
		("countPurfiedPkm", 59, 1, false),
		("awardMtBattleRibbons", 60, 1, false),
		("getPkCoupons", 61, 1, false),
		("setPkCoupons", 62, 2, false), //# (int nb)
		("receivePkCoupons", 63, 2, false), //# (int amount) (can be < 0)
		("countAllShadowPkm", 64, 1, false),
		
		("isSpeciesInPC", 68, 2, false), //# (int species)
		("releasePartyPkm", 69, 2, false), //# (int index). Returns 1 iff there was a valid Pokémon, 0 otherwise.
		
		
	],
	
//MARK: - Day Care
	52 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (1) ", start = 16, nb = 4),
		
		("getLevelsGained", 17, 1, false),
		("getNbOfHundredsOfShadowCtrLost", 18, 1, false), //# int((shadowPkmCounter - initialShadowPkmCounter)/100)
		("depositPkm", 19, 2, false),
		("withdrawPkm", 20, 2, false),
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (2) : checking the daycare status", start = 21, nb = 3),
		
		("calculateCost", 21, 2, false), //# Cost of daycare : 100*(1 + (currentLevel - initialLevel) + 1 +
		//# int((purifCtr - initialPurifCtr)/100))
		//# or 100*(1 + currentLevel - initialLvl) if (purifCtr - initialPurifCtr) < 100.
		//# 0 if status != PkmDeposited
		("checkDaycareStatus", 22, 1, false), //# NotVisited (or any other unassigned value) = -1,
		//# NoPkmDeposited = 0, PkmDeposited = 1
		("getPkm", 22, 1, false)
	],
	
//MARK: - Task Managet
	54 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 8),
		
		("allo//CateTask", 16, 2, false), //# returns taskUID ... allo//Cates a task but seems to do nothing ... BROKEN ?
		("zeroFunction17", 17, 1, false), //# arg : taskUID
		("getTaskCounter", 18, 1, false),
		("stopTask", 19, 2, false), //# unusable
		("unknownFunction20", 20, 2, false), //#set
		("unknownFunction21", 21, 2, false), //#get
		("unknownFunction22", 22, 3, false),
		("unknownFunction23", 23, 3, false)
	],
	
//MARK: - Shadow Pokemon
	59 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 8),
		
		//# Shadow Pkm status:
		//# 0 : not seen
		//# 1 : seen, as spectator (not battled against)
		//# 2 : seen and battled against
		//# 3 : caught
		//# 4 : purified
		("isShadowPkmPurified", 16, 2, false),
		("isShadowPkmCaught", 17, 2, false),
		("setShadowPkmStatus", 18, 3, false),
		("getShadowPkmSpecies", 19, 2, false),
		("getShadowPkmStatus", 20, 2, false),
		("unknownFunction21", 21, 2, false),
		("setShadowPkmStorageUnit", 22, 4, false), //# (int index, int subIndex)
	],
	
	
	
	
]

































