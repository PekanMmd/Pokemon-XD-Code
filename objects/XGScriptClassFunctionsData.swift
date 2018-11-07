//
//  XGScriptClassFunctionsInfo.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

//MARK: - Class Names
let ScriptClassNames : [Int : String] = [
	// .xds script format requires classes to be named with first character capitalised
	 0 : "Standard",
	 4 : "Vector",
	 7 : "Array",
	 
	// 33 is first object class, 60 is last
	33 : "Camera",
	35 : "Character",
	37 : "Pokemon",
	38 : "Movement",
	39 : "Tasks",
	40 : "Dialogue",
	41 : "Transition",
	42 : "Battle",
	43 : "Player",
	45 : "Room",
	47 : "Sound",
	49 : "PDA",
	52 : "Daycare",
	54 : "TaskManager",
	58 : "Effects",
	59 : "ShadowPokemon",
	60 : "Pokespot"
]

//MARK: - Operators
let ScriptOperators : [(name: String, index: Int, parameterCount: Int)] = [
	//#------------------------------------------------------------------
	//Category(name = "Unary operators", start = 16, nb = 10),
	
	("!", 16, 1), // not
	("-", 17, 1), // negative
	
	// type cast
	("hex", 18, 1),
	("string", 19, 1),
	("integer", 20, 1),
	("float", 21, 1),
	
	// parameters
	("getvx", 22, 1),
	("getvy", 23, 1),
	("getvz", 24, 1),
	("zerofloat", 25, 1), //# always returns 0.0 ...
	//#------------------------------------------------------------------
	//Category(name = "Binary non-comparison operators", start = 32, nb = 8),
	
	("^", 32, 2), // xor
	("or", 33, 2), // or |
	("and", 34, 2), // and &
	("+", 35, 2), // add # str + str is defined as concatenation
	("-", 36, 2), // subtract
	("*", 37, 2), // multiply # int * str or str * int is defined. For vectors = <a,b,c>*<c,d,e> = <a*c, b*d, c*e>
	("/", 38, 2), //# you cannot /0 for ints and floats but for vectors you can ...
	("%", 39, 2), //# operands are implicitly converted to int, if possible.
	//#------------------------------------------------------------------
	//Category(name = "Comparison operators", start = 48, nb = 6),
	
	("=", 48, 2), //# For string equality comparison: '?' every character goes, '*' everything goes after here
	(">", 49, 2), //# ordering of strings is done comparing their respective lengths
	(">=", 50, 2),
	("<", 51, 2),
	("<=", 52, 2),
	("!=", 53, 2)
	//#------------------------------------------------------------------
]

// MARK: - Class functions
// parameter count is the minimum needed for the function to work
// having too many is okay and some functions can have varying numbers of parameters
// depending on usage.
// parameter or return types of nil means they are unknown, none is used if it is known to have no type (void)
let ScriptClassFunctions : [Int : [(name: String, index: Int, parameterCount: Int, parameterTypes: [XDSMacroTypes?]?, returnType: XDSMacroTypes?)]] = [
//MARK: - Standard
	0 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Timer-related functions", start = 17, nb = 6),
		("pause", 17, 1, [.float], .null),
		("yield", 18, 1, [.integer], .null),
		("setTimer", 19, 1, nil, .null),
		("getTimer", 20, 1, nil, nil),
		("waitUntil", 21, 2, nil, .null),
		("printString", 22, 1, [.string], .null),
		("typeName", 29, 1, [.anyType], .string),
		("getCharacter", 30, 2, [.string, .integerIndex], nil), //# (str, index)
		("setCharacter", 31, 1, nil, nil),
		("findSubstring", 32, 2, [.string, nil], .invalid), //#BUGGED, returns -1
		("setBit", 33, 2, [.integer, .integer], .integer),
		("clearBit", 34, 2, [.integer, .integer], .integer),
		("mergeBits", 35, 2, [.integer, .integer], .integer),
		("nand", 36, 2, [.bool, .bool], .bool),
		//#------------------------------------------------------------------------------------
		//Category(name = "Math functions", start = 48, nb = 6),
		("sin", 48, 1, [.integerAngleDegrees], .float), //# trigo. function below work with degrees
		("cos", 49, 1, [.integerAngleDegrees], .float),
		("tan", 50, 1, [.integerAngleDegrees], .float),
		("atan2", 51, 1, [.float], .integer),
		("acos", 52, 1, [.float], .integerAngleDegrees),
		("sqrt", 53, 1, [.float], .float),
		//#------------------------------------------------------------------------------------
		//Category(name = "Functions manipulating a single flag", start = 129, nb = 5),
		
		("setFlagToTrue", 129, 1, [.flag], .null),
		("setFlagToFalse", 130, 1, [.flag], .null),
		("setFlag", 131, 2, [.flag, .integer], .null),
		("isFlagSet", 132, 2, [.flag, .integer], .bool),
		("getFlag", 133, 1, [.flag], .integer),
		
		//#------------------------------------------------------------------------------------
		//Category(name = "Misc. 1", start = 136, nb = 5),
		
		("printf", 136, 1, [.string, .optional(.list(.anyType))], .null), // params also include pattern matches like %d
		("genRandomNumberMod", 137, 1, [.integer], .integer), // generates a random number between 0 and the parameter - 1
		("setShadowPokemonStatus", 138, 2, [.shadowID, .shadowStatus], .null),
		("checkMultiFlagsInv", 139, 1, [.array(.flag)], .bool),
		("checkMultiFlags", 140, 1, [.array(.flag)], .bool),
		//#------------------------------------------------------------------------------------
		//Category(name = "Debugging functions", start = 142, nb = 2),
		
		("syncTaskFromLibraryScript", 142, 3, [.integer, .integer, .list(.anyType)], .null), //#nbArgs, function ID, ... (args, nil)
		("setDebugMenuVisibility", 143, 1, [.bool], .null), //# not sure it works on release builds
		
		//Category(name = "Misc. 2", start = 145, nb = 16),
		
		("setPreviousMapID", 145, 1, [.room], .null), //# the game uses the term "floor"
		("getPreviousMapID", 146, 0, [], .room),
		("function147", 147, 2, [.integer, .float], nil), //# (int, float)
		("getStringWithID", 148, 1, [.msg], .string),
		("getTreasureBoxCharacter", 149, 1, [.treasureID], .objectName("Character")), //# (int treasureID) returns a character object for the treasure
		("function148", 150, 1, [.pokemon], nil), //# take the species index as arg
		("getArrayElement", 151, 1, [.arrayIndex], .anyType), //# (array, index)
		("isHM", 152, 1, [.move], .bool),
		("distance", 153, 2, [.vector, .vector], .float),  //# between the two points whose coordinates are the vector args
		("characterGetID", 154, 1, [.objectName("Character")], .integer), //# (character), returns 0 by default
		("getCharacterWithID", 156, 1, [.integer], .objectName("Character")), //# return type: (int) -> character
		("getFrameRate", 157, 0, [.null], .float), //# FPS as float
		("getRegion", 158, 0, [.null], .region),
		("getLanguage", 159, 0, [.null], .language)
	],
	
//MARK: - Vector
	4 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Type conversions", start = 3, nb = 1),
		
		("toString", 3, 1, [.vector], .string),
		//#------------------------------------------------------------------------------------
		
		//Category(name = "Methods", start = 16, nb = 13),
		
		("clear", 16, 1, [.vector], .vector),
		("normalize", 17, 1, [.vector], .vector),
		("set", 18, 3, [.vector, .vectorDimension, .float], .vector),
		("set2", 19, 4, [.vector, .vectorDimension, .float, nil], .vector),
		("fill", 20, 2, [.vector, .float], .vector),
		("abs", 21, 1, [.vector], .null), //#in place
		("negate", 22, 1, [.vector], .null), //#in place
		("isZero", 23, 1, [.vector], .bool),
		("crossProduct", 24, 2, [.vector, .vector], .vector),
		("dotProduct", 25, 2, [.vector, .vector], .float),
		("norm", 26, 1, [.vector], .vector),
		("squaredNorm", 27, 1, [.vector], .vector),
		("angle", 28, 2, [.vector], .float)
	],
	
//MARK: - Array
	7 : [
		//#------------------------------------------------------------------------------------
		("invalidFunction0", 0, 0, [.null], .invalid),
		("invalidFunction1", 1, 0, [.null], .invalid),
		("invalidFunction2", 2, 0, [.null], .invalid),
		//#------------------------------------------------------------------------------------
		//Category(name = "Type conversions", start = 3, nb = 1),
		
		("toString", 3, 1, [.array(.anyType)], .string),
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (1)", start = 16, nb = 5),
		
		("get", 16, 2, [.array(.anyType), .arrayIndex], .anyType), // array get
		("set", 17, 3, [.array(.anyType), .arrayIndex, .anyType], .null), // array set
		("size", 18, 1, [.array(.anyType)], .integer),
		("resize", 19, 2, [.array(.anyType), .integer], .invalid), //#REMOVED
		("extend", 20, 2, [.array(.anyType), .integer], .invalid), //#REMOVED
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (2) : iterator functions", start = 22, nb = 4),
		
		("resetIterator", 22, 1, [.array(.anyType)], .null),
		("derefIterator", 23, 2, [.array(.anyType), nil], .null),
		("getIteratorPos", 24, 2, [.array(.anyType), nil], .integer),
		("append", 25, 2, [.array(.anyType), .anyType], .invalid) //#REMOVED
	],
	
//MARK: - Camera
	33 : [
		("followCharacter", 18, 2, [.objectName("Camera"), .objectName("Character")], .null), // # (Character target)
		
		("setPosition", 21, 4, [.objectName("Camera"), .integerFloatOverload, .integerFloatOverload, .integerFloatOverload], .null), // x, y , z
	
	],
	
//MARK: - Character
	35 : [
		//# The biggest class out there, there are 99 functions
		
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("setVisibility", 16, 2, [.objectName("Character"), .bool], .null), //# (int visible)
		("displayMessage", 21, 3, [.objectName("Character"), .msg, .bool], .null), //# (int msgID, int unk ?)
		
		("isWithinBounds", 25, 5, [.objectName("Character"), .float, .float, .float, .float], .bool), // # (Float x1, Float z1, Float x2, Float z2) ordering of ranges is interchangeable i.e. x1 > x2 == x2 > x1
		("isWithinBoundsWithOptions", 27, 7, [.objectName("Character"), .float, .float, .float, .float, .integer, .bool], .bool), //# x1 z1 x2 z2 unk unk
		("setPosition", 29, 4, [.objectName("Character"), .integerFloatOverload, .integerFloatOverload, .integerFloatOverload], .null), //# (int/float x, int/float y, int/float z) accepts either int or float for any of the values and can mix and match as desired
		("fallToPosition", 30, 2, [.objectName("Character"), .float, .float, .float], .null),
		("setRotation", 31, 4, [.objectName("Character"), .integerFloatOverload, .integerFloatOverload, .integerFloatOverload], .null), // int angle around x axis, int angle around y axis, int angle around z axis
		
		("moveToPosition", 36, 4, [.objectName("Character"), .integer, .integer, .integer], .null), //# (int speed, int x, int y, int z)
		
		("waitForAnimation", 39, 2, [.objectName("Character"), .bool], .null), // bool wait for completion
		
		("setCharacterFlags", 40, 2, [.objectName("Character"), .integer], .null), //# (int flags ?)
		("clearCharacterFlags", 41, 2, [.objectName("Character"), .integer], .null), //# (int flags ?)
		
		("faceCharacter", 49, 3, [.objectName("Character"), .objectName("Character"), .float], .null), // # (Character target, float unknown(speed?))
		
		("runToPosition", 55, 4, [.objectName("Character"), .float, .float, .float], .null), // (float x, float y, float z)
		
		("faceAngleInDegrees", 62, 2, [.objectName("Character"), .integerAngleDegrees], .null), // # (int direction) (0 = straight down)
		
		("setModel", 70, 2, [.objectName("Character"), .model], .null), //# (int id)
		
		("getMovementSpeed", 72, 2, [.objectName("Character")], .floatFraction), // float between 0.0 and 1.0
		("talk", 73, 3, [.objectName("Character"), .talk, .msg, .optional(.variableType), .optional(.variableType)], .anyType), //# (int type, ...) // set last 2 macros based on talk type
		//# Some type of character dialogs (total: 22):
		//# (Valid values for type : 1-3, 6-21).
		//#	(1, msgID): normal msg
		//#	(2, msgID): the character comes at you, then talks, then goes away (to be verified; anyways he/she moves)
		//#	(8, msgID): yes/no question
		//# (battleID, 9, msgID) talks and then initiates a battle
		//# (quantity,itemID, 14, msgID) talks and then adds item to player's bag silently
		//#	(15, species): plays the species' cry
		//#	(16, msgID): informative dialog with no sound
		
		("getPosition", 75, 1, [.objectName("Character")], .vector),
		
		("useHealingMachine", 101, 3, [.objectName("Character"), .datsIdentifier, .array(.integer), .array(.integer)], .null),
	],
	
//MARK: - Pokemon
	37 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("playSpeciesCry", 16, 2, [.anyType, .pokemon], .null), //# (int species) seems to ignore first parameter
		("deleteMove", 17, 1, [.objectName("Pokemon"), .integerIndex], .null), // (int index to delete)
		
		("countMoves", 20, 1, [.objectName("Pokemon")], .integer),
		("getPokeballCaughtWith", 21, 1, [.objectName("Pokemon")], .item),
		("getNickname", 22, 1, [.objectName("Pokemon")], .string),
		
		//# index = 23 does not exist
		
		("isShadowPokemon", 24, 1, [.objectName("Pokemon")], .bool),
		("getMoveAtIndex", 25, 1, [.objectName("Pokemon"), .integerIndex], .move),
		
		("getCurrentHP", 26, 1, [.objectName("Pokemon")], .integer),
		("getCurrentPurificationCounter", 27, 1, [.objectName("Pokemon")], .integer),
		("getSpecies", 28, 1, [.objectName("Pokemon")], .pokemon),
		("isLegendary", 29, 1, [.objectName("Pokemon")], .bool),
		("getHappiness", 30, 1, [.objectName("Pokemon")], .integerUnsignedByte),
		("getSpeciesNameID", 31, 1, [.objectName("Pokemon")], .msg), //# if it's 0 the species is invalid
		("getHeldItem", 32, 1, [.objectName("Pokemon")], .item),
		("getSIDTID", 33, 1, [.objectName("Pokemon")], .integerUnsigned),
		
		("teachMove", 34, 2, [.objectName("Pokemon"), .move], .null), // (int move id)
		("hasLearnedMove", 35, 2, [.objectName("Pokemon"), .move], .bool), // (int move id)
		("canLearnTutorMove", 36, 2, [.objectName("Pokemon"), .move], .bool), // int move id
		("getIndexOfMove", 37, 2, [.objectName("Pokemon"), .move], .integerIndex),
		("displayMoveDeleterMenu", 38, 1, [.objectName("Pokemon")], .integerIndex),
	],
	
//MARK: - Movement
	38: [
		("warpToRoom", 22, 2, [.objectName("Movement"), .room], .null), // # (int roomID, int unknown)
		("warpToRoomWithOptions", 49, 2, [.objectName("Movement"), .room, .bool, .integerUnsigned, .integerUnsigned], .null), // # (int roomID, int unknown)
	],
	
//MARK: - Tasks
	39 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Task creation functions", start = 16, nb = 4),
		//# Function IDs : if (id & 0x59600000) != 0 : current script, otherwise common script (mask = 0x10000000 iirc)
		
		("createSyncTaskByID", 16, 6, [.objectName("Tasks"), .integer, .integer, .integer, .integer, .integer], .null), //# (functionID, then 4 ints passed as parameters)
		("createSyncTaskByName", 17, 6, [.objectName("Tasks"), .string, .integer, .integer, .integer, .integer], .null), //# the function is selected by its name in the CURRENT script.
		//# HEAD sec. must be present
		("createAsyncTaskByID", 18, 6, [.objectName("Tasks"), .integer, .integer, .integer, .integer, .integer], .null), //# (functionID, then 4 ints passed as parameters)
		("createAsyncTaskByName", 19, 6, [.objectName("Tasks"), .string, .integer, .integer, .integer, .integer], .null), //# the function is selected by its name in the CURRENT script.
		//# HEAD sec. must be present
		
		("getLastReturnedInt", 20, 1, [.objectName("Tasks")], .integer),
		("sleep", 21, 2, [.objectName("Tasks"), .integerFloatOverload], .null) //# (int/float) (seconds)
	],
	
//MARK: - Dialogue
	40 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("displayMessageSilently", 16, 4, [.objectName("Dialogue"), .msg, .bool, .bool], .null), //# (int msgID, bool isInForeground, bool printInstantly)
		("displayMessage", 17, 5, [.objectName("Dialogue"), .msg, .bool, .bool, .integer], .null), //# (int msgID, bool isInForeground, bool printInstantly, int textSoundPitchLevel) makes the chirping sound as characters are displayed
		("displayYesNoMenu", 21, 2, [.objectName("Dialogue"), .msg], .integerIndex), // result is not boolean but rather index of selected option, 0 indexed
		
		("setMessageVariable", 28, 3, [.objectName("Dialogue"), .msgVar, .variableType], .null), //# (int type, var val) macro type for value is set by compiler based on msgvar value
		
		("displayCustomMenu", 29, 6, [.objectName("Dialogue"), .array(.msg), .integer, .integer, .integer, .integerIndex], .integerIndex), // array of msgids, int number of elements, int x, int y, int index to start cursor on
		
		("displayPartyPokemonMenu", 32, 1, [.objectName("Dialogue")], .integerIndex), //# these functions are **exactly** the same
		("displayPartyPokemonMenu2", 33, 1, [.objectName("Dialogue")], .integerIndex),
		("displayPokemonSummary", 34, 2, [.objectName("Dialogue"), .integerIndex], .null), //# int partyIndex
		("displayMoveMenuForPokemon", 35, 2, [.objectName("Dialogue"), .integerIndex], .integerIndex), //# int partyIndex
		
		("displayNameEntryMenu", 36, 3, [.objectName("Dialogue"), .integer, .integer], .null), //# (int forWhom, var target, int mode)
		//# forWhom: 0 for Player, 1 for Sister, 2 for Poké. mode: 0 = enter Pokemon name, 1 = player name, 2 = sister name (not verified)
		("commonScriptDisplayNameEntryMenu", 37, 3, [.objectName("Dialogue"), .integer, .integer], .null), //# used by the common script only. Don't use this otherwise
		
		("displayPokemartMenu", 39, 2, [.objectName("Dialogue"), .integer], .null), //# (int pokemart id)
		
		("displayPDAMenu", 41, 1, [.objectName("Dialogue")], .null),
		("displayYesNoPrompt", 42, 1, [.objectName("Dialogue")], .bool), // result is boolean true or false
		
		("openItemMenu", 50, 1, [.objectName("Dialogue")], .null),
		
		("showWorldMapLocation", 60, 2, [.objectName("Dialogue"), .integer], .null),
		("showMirorRadarIcon", 61, 1, [.objectName("Dialogue")], .null),
		("hideMirorRadarIcon", 62, 1, [.objectName("Dialogue")], .null),
		
		("displayMoveRelearnerMenuForPartyMember", 64, 2, [.objectName("Dialogue"), .integerIndex], .move), //# (int partyIndex)
		("displayTutorMovesMenu", 65, 1, [.objectName("Dialogue")], .move),
		
		("showMoneyWindow", 67, 3, [.objectName("Dialogue"), .integer, .integer], .null), //# (int x, int y)
		("hideMoneyWindow", 68, 1, [.objectName("Dialogue")], .null),
		
		("showCouponsWindow", 70, 3, [.objectName("Dialogue"), .integer, .integer], .null), //# (int x, int y)
		("hideCouponsWindow", 71, 1, [.objectName("Dialogue")], .null),
		
		("startBattle", 72, 2, [.objectName("Dialogue"), .battleID], .null), //# (int battleid)
		("getBattleResult", 74, 1, [.objectName("Dialogue")], .battleResult),
		
		("displayMewMenuQuestionWithIndex", 78, 2, [.objectName("Dialogue"), .integer], .move),
		
	],
	
//MARK: - Transition
	41 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 2),
		
		("begin", 16, 3, [.objectName("Transition"), .transitionID, .integerFloatOverload], .null), //#$transition, int transitionID, int/float duration in seconds
		("wait", 17, 2, [.objectName("Transition"), .bool], .null) //#$transition, bool waitForCompletion. waits for transition to have started before running next instruction, will wait for transition complete before next instruction if parameter is set to true

	],
	
//MARK: - Battle
	42 : [
		
		("startBattle", 16, 4, [.objectName("Battle"), .battleID, .bool, .bool], .null),// # (int isTrainer, int unknown, int battleID) (battleID list in reference folder)
		("getBattleResult", 18, 1, [.objectName("Battle")], .battleResult), // # sets last result to 2 if victory
		
		("setBattlefield", 23, 2, [.objectName("Battle"), .battlefield], .null),
		("setPostBattleText", 26, 3, [.objectName("Battle"), .battleResult, .msg], .null),
		
		("setBattleID", 42, 2, [.objectName("Battle"), .battleID], .null),
	],
	
//MARK: - Player
	43 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("processEvents", 17, 1, [.objectName("Player")], .null), //# MUST BE CALLED IN THE IDLE LOOP (usually 'hero_main')
		
		("lockMovement", 18, 1, [.objectName("Player")], .null),
		("freeMovement", 19, 1, [.objectName("Player")], .null),
		
		("receiveItem", 26, 3, [.objectName("Player"), .item, .integerQuantity], .bool), //# (int amount, int ID) -> bool success
		// returns false if bag was full
		("receiveItemSilently", 27, 3, [.objectName("Player"), .item, .integerQuantity], .bool), //# (int item id, int quantity) -> bool success
		("hasItemInBag", 28, 2, [.objectName("Player"), .item], .bool), //# (int ID)
		
		("receiveMoney", 29, 2, [.objectName("Player"), .integerMoney], .null), //# (int amount) (can be < 0)
		("getMoneyTotal", 30, 1, [.objectName("Player")], .integerMoney),
		("getMoneyStored", 31, 1, [.objectName("Player")], .integerMoney),
		
		("countPartyPokemon", 34, 1, [.objectName("Player")], .integer), //# (int amount)
		("countShadowPartyPokemon", 35, 1, [.objectName("Player")], .integer), //# (int amount)
		
		("getPartyPokemonName", 36, 2, [.objectName("Player"), .integerIndex], .string), //# (int partyIndex)
		
		("receiveGiftPokemon", 37, 2, [.objectName("Player"), .giftPokemon], nil), //# (int ID)
		//# 1 to 14:
		//# Male Jolteon (cannot be shiny), Male Vaporeon (cannot), Duking's Plusle (cannot),
		//# Mt. Battle Ho-oh (cannot), Bonus Disc Pikachu (cannot), AGETO Celebi (cannot)
		//#
		//# shadow Togepi (XD) (cannot be shiny), Elekid (can), Meditite (can), Shuckle (can), Larvitar (can),
		//# Chikorita (can), Cyndaquil (can), Totodile (can)
		
		("countPurifiablePartyPokemon", 38, 1, [.objectName("Player")], .integer),
		("healParty", 39, 1, [.objectName("Player"), .bool], .null),
		("startGroupBattle", 40, 2, [.objectName("Player"), .battleID], .null), //# (int)
		("countNonFaintedPartyPokemon", 41, 1, [.objectName("Player")], .integer),
		("getFirstInvalidPartyPokemonIndex", 42, 1, [.objectName("Player")], .integerIndex), //# -1 if no invalid Pokemon
		("countValidPartyPokemon", 43, 1, [.objectName("Player")], .integer),
		("getPartyPokemonAtIndex", 44, 2, [.objectName("Player"), .integerIndex], .objectName("Pokemon")), //# (int index)
		("checkPokemonOwnership", 45, 2, [.objectName("Player"), .integerIndex], .integer), //# (int index)
		
		("getNPCPartyMember", 47, 1, [.objectName("Player")], .partyMember), // # sets last result to character index of character following the player
		
		("countCaughtShadowPokemon", 49, 1, [.objectName("Player")], .integer),
		
		("isPCFull", 52, 1, [.objectName("Player")], .bool),
		("countLegendaryPartyPokemon", 53, 1, [.objectName("Player")], .integer),
		("setNPCPartyMember", 54, 3, [.objectName("Player"), .partyMember, .bool], .null), // int party member character index (0 for none), int unknown. set party member to 0 to unset party member
		
		("countPurfiedPokemon", 59, 1, [.objectName("Player")], .integer),
		("awardMtBattleRibbons", 60, 1, [.objectName("Player")], .null),
		("getCouponsTotal", 61, 1, [.objectName("Player")], .integerCoupons),
		("setCouponsTotal", 62, 2, [.objectName("Player"), .integerCoupons], .null), //# (int nb)
		("receiveCoupons", 63, 2, [.objectName("Player"), .integerCoupons], .null), //# (int amount) (can be < 0)
		("totalNumberOfShadowPokemon", 64, 1, [.objectName("Player")], .integer),
		
		("obtainItem", 67, 5, [.objectName("Player"), .integerFloatOverload, .item, .integerQuantity, .bool], .null), //# (int message type, int itemid, int quantity, bool unknown)
		("hasSpeciesInPC", 68, 2, [.objectName("Player"), .pokemon], .bool), //# (int species)
		("releasePartyPokemon", 69, 2, [.objectName("Player"), .integerIndex], .bool), //# (int index). Returns 1 iff there was a valid Pokémon, 0 otherwise.
		
	],
	
//MARK: - Room
	45 : [
	
		("transformElement", 19, 5, [.objectName("Room"), .datsIdentifier, .integerIndex, .integer, .integer], .null),
		("waitForElementAnimation", 21, 3, [.objectName("Room"), .datsIdentifier, .bool], .null), // bool wait for completion
		
	],
	
//MARK: - Sound
	47 : [
		
		("playSoundEffect", 16, 4, [.objectName("Sound"), .integer, .integer, .integer], .null), // int songid, int unk, int volume
		
		("setBGM", 25, 5, [.objectName("Sound"), .integer, .integer, .integer, .integer], .null), //# (int bgm id, int unk1, int unk2, int volume)
	
	],
	
//MARK: - PDA
	49 : [
	("receiveMailWithID", 20, 2, [.objectName("PDA"), .integer], .null),
	
	],
	
//MARK: - Day Care
	52 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (1) ", start = 16, nb = 4),
		
		("getLevelsGained", 17, 1, [.objectName("Daycare")], .integer),
		("getHundredsOfShadowCounterLost", 18, 1, [.objectName("Daycare")], .integer), //# int((shadowPokemonCounter - initialShadowPokemonCounter)/100)
		("depositPokemon", 19, 2, [.objectName("Daycare"), .integerIndex], .null), // int party index
		("withdrawPokemon", 20, 2, [.objectName("Daycare"), .integerIndex], .null), // int party index to set as withdrawn pokemon
		
		
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (2) : checking the Daycare status", start = 21, nb = 3),
		
		("priceForPurificationCount", 21, 2, [.objectName("Daycare"), .integer], .integerMoney), //# Cost of Daycare : 100*(1 + (currentLevel - initialLevel) + 1 +
		//# int((purifCtr - initialPurifCtr)/100))
		//# or 100*(1 + currentLevel - initialLvl) if (purifCtr - initialPurifCtr) < 100.
		//# 0 if status != PokemonDeposited
		("priceForLevels", 22, 2, [.objectName("Daycare"), .integer], .integerMoney), // int levels gained
		//# NoPokemonDeposited = 0, PokemonDeposited = 1
		("checkIfHasPokemon", 23, 1, [.objectName("Daycare")], .bool),
		("getCurrentPokemon", 24, 1, [.objectName("Daycare")], .objectName("Pokemon")),
	],
	
//MARK: - Task Manager
	54 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 8),
		
		("allocateTask", 16, 2, [.objectName("TaskManager"), .integer], .integer), //# returns taskUID ... allocates a task but seems to do nothing ... BROKEN ?
		("zeroFunction17", 17, 2, [.objectName("TaskManager"), .integer], nil), //# arg : taskUID
		("getTaskCounter", 18, 1, [.objectName("TaskManager")], .integer),
		("stopTask", 19, 2, [.objectName("TaskManager"), .integer], .null), //# unusable
	],

//MARK: - Effects
	58 : [
		("newEffectsManager", 16, 1, [.anyType], .objectName("Effects")),
		("beginAnimation", 17, 5, [.objectName("Effects"), .integer, .integer, .integer, .bool], .null), // int id, int duration, unk, unk
		("setPosition", 18, 2, [.objectName("Effects"), .vector], .null),
		
		("waitForAnimation", 22, 1, [.objectName("Effects")], .null),
		
	
	],
	
//MARK: - Shadow Pokemon
	59 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 8),
		
		//# Shadow Pokemon status:
		//# 0 : not seen
		//# 1 : seen, as spectator (not battled against)
		//# 2 : seen and battled against
		//# 3 : caught
		//# 4 : purified
		("isShadowPokemonPurified", 16, 2, [.objectName("ShadowPokemon"), .shadowID], .bool),
		("isShadowPokemonCaught", 17, 2, [.objectName("ShadowPokemon"), .shadowID], .bool),
		("setShadowPokemonStatus", 18, 3, [.objectName("ShadowPokemon"), .shadowID, .shadowStatus], .null),
		("getShadowPokemonSpecies", 19, 2, [.objectName("ShadowPokemon"), .shadowID], .pokemon),
		("getShadowPokemonStatus", 20, 2, [.objectName("ShadowPokemon"), .shadowID], .shadowStatus),
		("setShadowPokemonPCBoxIndex", 22, 4, [.objectName("ShadowPokemon"), .shadowID, .PCBox, .integerIndex], .null), //# (int index, int subIndex)
	],
	
//MARK: - Pokespot
	60 : [
		("getCurrentWildPokemon", 17, 2, [.objectName("Pokespot"), .pokespot], .pokemon), //# (int pokespotId)
	]
	
]

































