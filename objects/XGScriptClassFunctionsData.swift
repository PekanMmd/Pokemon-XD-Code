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
	// .xds script format requires classes to be named with first character capitalised and all subsequent characters in lowercase
	 0 : "Standard",
	 4 : "Vector",
	 7 : "Array",
	33 : "Camera",
	35 : "Character",
	37 : "Pokemon",
	38 : "Movement",
	39 : "Tasks",
	40 : "Dialogue",
	41 : "Transition",
	42 : "Battle",
	43 : "Player",
	47 : "Sound",
	52 : "Daycare",
	54 : "Taskmanager",
	59 : "Shadowpokemon",
	60 : "Pokespot"
]

//MARK: - Operators
let ScriptOperators : [(String,Int,Int)] = [
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
	("<=", 49, 2), //# ordering of strings is done comparing their respective lengths
	("<", 50, 2),
	(">=", 51, 2),
	(">", 52, 2),
	("!=", 53, 2)
	//#------------------------------------------------------------------
]

// function name, function id, number parameters, parameter types, return types
let ScriptClassFunctions : [Int : [(String,Int,Int,[XDSMacroTypes?]?,XDSMacroTypes?)]] = [
//MARK: - Standard
	0 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Timer-related functions", start = 17, nb = 6),
		("pause", 17, 1, nil, nil),
		("yield", 18, 1, nil, nil),
		("setTimer", 19, 1, nil, nil),
		("getTimer", 20, 1, nil, nil),
		("waitUntil", 21, 2, nil, nil),
		("printString", 22, 1, nil, nil),
		("typename", 29, 1, nil, nil),
		("getCharacter", 30, 2, nil, nil), //# (str, index)
		("setCharacter", 31, 1, nil, nil),
		("findSubstring", 32, 2, nil, nil), //#BUGGED, returns -1
		("setBit", 33, 2, nil, nil),
		("clearBit", 34, 2, nil, nil),
		("mergeBits", 35, 2, nil, nil),
		("nand", 36, 2, nil, nil),
		//#------------------------------------------------------------------------------------
		//Category(name = "Math functions", start = 48, nb = 6),
		("sin", 48, 1, nil, nil), //# trigo. function below work with degrees
		("cos", 49, 1, nil, nil),
		("tan", 50, 1, nil, nil),
		("atan2", 51, 1, nil, nil),
		("acos", 52, 1, nil, nil),
		("sqrt", 53, 1, nil, nil),
		//#------------------------------------------------------------------------------------
		//Category(name = "Functions manipulating a single flag", start = 129, nb = 5),
		
		("setFlagTotrue", 129, 1, [.flag], nil),
		("setFlagTofalse", 130, 1, [.flag], nil),
		("setFlag", 131, 2, [.flag, nil], nil),
		("checkFlag", 132, 2, [.flag, nil], .bool),
		("getFlag", 133, 1, [.flag], nil),
		
		//#------------------------------------------------------------------------------------
		//Category(name = "Misc. 1", start = 136, nb = 5),
		
		("printf", 136, 1, nil, nil),
		("genRandomNumberMod", 137, 1, nil, nil), // generates a random number between 0 and the parameter - 1
		("setShadowPkmStatus", 138, 2, [.shadowID, .shadowStatus], nil),
		("checkMultiFlagsInv", 139, 1, nil, nil),
		("checkMultiFlags", 140, 1, nil, nil),
		//#------------------------------------------------------------------------------------
		//Category(name = "Debugging functions", start = 142, nb = 2),
		
		("syncTaskFromLibraryScript", 142, 3, nil, nil), //#nbArgs, function ID, ... (args, nil)
		("setDebugMenuVisibility", 143, 1, nil, nil), //# not sure it works on release builds
		
		//Category(name = "Misc. 2", start = 145, nb = 16),
		
		("setPreviousMapID", 145, 1, [.room], nil), //# the game uses the term "floor"
		("getPreviousMapID", 146, 0, nil, .room),
		("unknownFunction147", 147, 2, nil, nil), //# (int, float)
		("getPkmSpeciesName", 148, 1, [.msg], nil),
		("getTreasureBoxCharacter", 149, 1, [.treasureID], nil), //# (int treasureID) returns a character object for the treasure
		("speciesRelatedFunction148", 150, 1, [.pokemon], nil), //# take the species index as arg
		("getArrayElement", 151, 1, nil, nil), //# (array, index)
		("unknownFunction152", 152, 1, nil, nil),
		("distance", 153, 2, nil, nil),  //# between the two points whose coordinates are the vector args
		("unknownFunction154", 154, 1, nil, nil), //# (character), returns 0 by default
		("unknownFunction155", 155, 6, nil, nil),  //# (float, int, int, int, int, int) -> 0
		("GCComListenerDestroy", 154, 0, nil, nil), //# so says Dolphin-Emu
		("unknownFunction155", 155, 5, nil, nil),  //# (int, float, float, float, float) -> 0
		("unknownFunction156", 156, 1, nil, nil), //# return type: (int) -> character
		("getScreenResfreshRate", 157, 0, nil, nil), //# FPS as float
		("getRegion", 158, 0, nil, nil),
		("getLanguage", 159, 0, nil, nil)
	],
	
//MARK: - Vector
	4 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Type conversions", start = 3, nb = 1),
		
		("toString", 3, 1, nil, nil),
		//#------------------------------------------------------------------------------------
		
		//Category(name = "Methods", start = 16, nb = 13),
		
		("clear", 16, 1, nil, nil),
		("normalize", 17, 1, nil, nil),
		("set", 18, 4, nil, nil),
		("set2", 19, 4, nil, nil),
		("fill", 20, 2, nil, nil),
		("abs", 21, 1, nil, nil), //#in place
		("negate", 22, 1, nil, nil), //#in place
		("isZero", 23, 1, nil, nil),
		("crossProduct", 24, 2, nil, nil),
		("dotProduct", 25, 2, nil, nil),
		("norm", 26, 1, nil, nil),
		("squaredNorm", 27, 1, nil, nil),
		("angle", 28, 2, nil, nil)
	],
	
//MARK: - Array
	7 : [
		//#------------------------------------------------------------------------------------
		("invalidFunction0", 0, 0, nil, nil),
		("invalidFunction1", 1, 0, nil, nil),
		("invalidFunction2", 2, 0, nil, nil),
		//#------------------------------------------------------------------------------------
		//Category(name = "Type conversions", start = 3, nb = 1),
		
		("toString", 3, 1, nil, nil),
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (1)", start = 16, nb = 5),
		
		("get", 16, 2, nil, nil), // array get
		("set", 17, 3, nil, nil), // array set
		("size", 18, 1, nil, nil),
		("resize", 19, 2, nil, nil), //#REMOVED
		("extend", 20, 2, nil, nil), //#REMOVED
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (2) : iterator functions", start = 22, nb = 4),
		
		("resetIterator", 22, 1, nil, nil),
		("derefIterator", 23, 2, nil, nil),
		("getIteratorPos", 24, 2, nil, nil),
		("append", 25, 2, nil, nil) //#REMOVED
	],
	
//MARK: - Camera
	33 : [
		("followCharacter", 18, 1, nil, nil), // # (Character target)
	
	],
	
//MARK: - Character
	35 : [
		//# The biggest class out there, there are 99 functions
		
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("setVisibility", 16, 1, [.bool], nil), //# (int visible)
		("displayMsgWithSpeciesSound", 21, 2, [.msg, nil], nil), //# (int msgID, int unk ?)
		//# Uses the species cry from Dialogs::setMsgVar($dialogs, 50, species)
		
		("checkIfCrossingLine", 25, 4, nil, .bool), // # (Float x1, Float z1, Float x2, Float z2)?
		("checkIsInRange", 27, 4, nil, .bool), //# (int x, int y, int z, float angle?)
		("setPosition", 29, 3, nil, nil), //# (int/float x, int/float y, int/float z) accepts either int or float for any of the values and can mix and match as desired
		
		("moveToPosition", 36, 4, nil, nil), //# (int speed, int x, int y, int z)
		
		("setCharacterFlags", 40, 2, nil, nil), //# (int flags ?)
		("clearCharacterFlags", 41, 2, nil, nil), //# (int flags ?)
		
		("faceCharacter", 49, 3, nil, nil), // # (Character target, float unknown)
		
		("runToPosition", 55, 4, nil, nil), // (float x, float y, float z)
		
		("faceAngleInDegrees", 62, 1, nil, nil), // # (int direction) (0 = straight down)
		
		("setModel", 70, 1, [.model], nil), //# (int id)
		
		("talk", 73, 2, [.talk, .msg, nil, nil], nil), //# (int type, ...) // set last 2 macros based on talk type
		//# Some type of character dialogs (total: 22):
		//# (Valid values for type : 1-3, 6-21).
		//#	(1, msgID): normal msg
		//#	(2, msgID): the character comes at you, then talks, then goes away (to be verified; anyways he/she moves)
		//#	(8, msgID): yes/no question
		//# (battleID, 9, msgID) talks and then initiates a battle
		//# (quantity,itemID, 14, msgID) talks and then adds item to player's bag silently
		//#	(15, species): plays the species' cry
		//#	(16, msgID): informative dialog with no sound
	],
	
//MARK: - Pokemon
	37 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("playSpecifiedSpeciesCry", 16, 2, [.pokemon], nil), //# (int species)
		
		("playCry", 16, 1, nil, nil),
		("deleteMove", 17, 1, nil, nil), // (int move index)
		
		("countMoves", 20, 1, nil, nil),
		("getPokeballCaughtWith", 1, 21, nil, .item),
		("getNickname", 22, 1, nil, nil),
		
		//# index = 23 does not exist
		
		("isShadow", 24, 1, nil, .bool),
		("getMoveAtIndex", 25, 1, nil, .move), // (int move index)
		
		("getCurrentHP", 26, 1, nil, nil),
		("getCurrentPurificationCounter", 27, 1, nil, nil),
		("getSpeciesIndex", 28, 1, nil, .pokemon),
		("isLegendary", 29, 1, nil, .bool),
		("getHappiness", 30, 1, nil, nil),
		("getSomeSpeciesRelatedIndex", 31, 1, nil, nil), //# if it's 0 the species is invalid
		("getHeldItem", 32, 1, nil, .item),
		("getSIDTID", 33, 1, nil, nil),
		
		("teachMove", 34, 1, [.move, nil], nil), // (int move id)
		("hasLearnedMove", 35, 1, [.move], .bool), // (int move id)
	],
	
//MARK: - Movement
	38: [
		("warpToRoom", 22, 2, [.room, nil], nil), // # (int roomID, int unknown)
	],
	
//MARK: - Tasks
	39 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Task creation functions", start = 16, nb = 4),
		//# Function IDs : if (id & 0x59600000) != 0 : current script, otherwise common script (mask = 0x10000000 iirc)
		
		("createSyncTaskByID", 16, 6, nil, nil), //# (functionID, then 4 ints passed as parameters)
		("createSyncTaskByName", 17, 6, nil, nil), //# the function is selected by its name in the CURRENT script.
		//# HEAD sec. must be present
		("createAsyncTaskByID", 18, 6, nil, nil), //# (functionID, then 4 ints passed as parameters)
		("createAsyncTaskByName", 19, 6, nil, nil), //# the function is selected by its name in the CURRENT script.
		//# HEAD sec. must be present
		
		("getLastReturnedInt", 20, 1, nil, nil),
		("sleep", 21, 2, nil, nil) //# (float) (miliseconds)
	],
	
//MARK: - Dialogue
	40 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("displaySilentMsgBox", 16, 4, [.msg, .bool, .bool], nil), //# (int msgID, bool isInForeground, bool printInstantly)
		("displayMsgBox", 17, 5, [.msg, .bool, .bool, nil], nil), //# (int msgID, bool isInForeground, bool printInstantly, int textSoundPitchLevel)
		("displayYesNoQuestion", 21, 2, nil, .bool),
		
		("setMsgVar", 28, 3, [.msgVar, nil], nil), //# (int type, var val)
		
		("displayCustomMenu", 29, 5, [.msg,nil,nil,nil,nil], nil), // (unk, unk, unk, unk, array of string ids for menu options)
		
		("promptPartyPokemon", 32, 1, nil, nil), //# these functions are **exactly** the same
		("promptPartyPokemon2", 33, 1, nil, nil),
		("openPokemonSummary", 34, 2, nil, nil), //# int partyIndex
		("openMoveSelectionWindow", 35, 2, nil, nil), //# int partyIndex
		
		("promptName", 36, 2, nil, nil), //# (int forWhom, var target, int mode)
		//# forWhom: 0 for Player, 1 for Sister, 2 for Poké. mode: 0 = enter pkm name, 1 = player name, 2 = sister name (not verified)
		("doOpenNamePrompt", 37, 3, nil, nil), //# used by the common script only. Don't use this otherwise
		
		("openPokemartMenu", 39, 2, nil, nil), //# (int pokemart id)
		
		("openPADMenu", 41, 1, nil, nil),
		("yesOrNoPrompt", 42, 1, nil, .bool),
		
		("openItemMenu", 50, 1, nil, nil),
		
		("showWorldMapLocation", 60, 2, nil, nil),
		
		("openMoveRelearnerMenuForPartyMember", 64, 2, nil, .move), //# (int partyIndex)
		
		("openMoneyWindow", 67, 3, nil, nil), //# (int x, int y)
		("closeMoneyWindow", 68, 1, nil, nil),
		
		("openPkCouponsWindow", 70, 3, nil, nil), //# (int x, int y)
		("closePkCouponsWindow", 71, 1, nil, nil),
		
		("startBattle", 72, 2, [.battleID], nil), //# (int battleid)
		("getBattleResult", 74, 1, nil, .battleResult),
		
		("askMewMenuQuestionWithIndex", 78, 2, nil, nil),
		
	],
	
//MARK: - Transition
	41 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 2),
		
		("setup", 16, 3, nil, nil), //#$transition, int flags, float duration
		("checkStatus", 17, 2, [.bool], nil) //#$transition, int waitForCompletion
	],
	
//MARK: - Battle
	42 : [
		
		("startBattle", 16, 4, [.battleID, nil,.bool], nil),// # (int isTrainer, int unknown, int battleID) (battleID list in reference folder)
		("checkBattleResult", 18, 0, nil, .battleResult), // # sets last result to 2 if victory
		
		("setBattlefield", 23, 2, [.battlefield], nil),
		("setPostBattleText", 26, 3, [.battleResult, .msg], nil),
		
		("setBattleID", 42, 2, [.battleID], nil),
	],
	
//MARK: - Player
	43 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Known methods", start = 16, nb=-1),
		
		("processEvents", 17, 1, nil, nil), //# MUST BE CALLED IN THE IDLE LOOP (usually 'hero_main')
		
		("lockMovement", 18, 0, nil, nil),
		("freeMovement", 19, 0, nil, nil),
		
		("receiveItem", 26, 2, [.item, nil], nil), //# (int amount, int ID)
		("receiveItemWithoutMessage", 27, 2, [.item, nil], nil), //# (int amount, int ID)
		("hasItemInBag", 28, 1, [.item], .bool), //# (int ID)
		
		("receiveMoney", 29, 2, nil, nil), //# (int amount) (can be < 0)
		("getMoney", 30, 1, nil, nil),
		("getSavedMoney", 31, 1, nil, nil),
		
		("countPartyPkm", 34, 1, nil, nil), //# (int amount)
		("countShadowPartyPkm", 35, 1, nil, nil), //# (int amount)
		
		("getPartyPkmNameAsString", 36, 2, nil, nil), //# (int partyIndex)
		
		("receiveGiftOrEventPkm", 37, 2, nil, nil), //# (int ID)
		//# 1 to 14:
		//# Male Jolteon (cannot be shiny), Male Vaporeon (cannot), Duking's Plusle (cannot),
		//# Mt. Battle Ho-oh (cannot), Bonus Disc Pikachu (cannot), AGETO Celebi (cannot)
		//#
		//# shadow Togepi (XD) (cannot be shiny), Elekid (can), Meditite (can), Shuckle (can), Larvitar (can),
		//# Chikorita (can), Cyndaquil (can), Totodile (can)
		
		("countPurifiablePartyPkm", 38, 1, nil, nil),
		("healParty", 39, 1, nil, nil),
		("startGroupBattle", 40, 2, nil, nil), //# (int)
		("countNotFaintedPartyPkm", 41, 1, nil, nil),
		("getFirstInvalidPartyPkmIndex", 42, 1, nil, nil), //# -1 if no invalid pkm
		("countValidPartyPkm", 43, 1, nil, nil),
		("getPartyPkm", 44, 2, nil, nil), //# (int index)
		("checkPkmOwnership", 45, 2, nil, nil), //# (int index)
		
		("getFollowingCharacter", 47, 0, nil, .partyMember), // # sets last result to character index of character following the player
		
		("countCaughtShadowPokemon", 49, 0, nil, nil),
		
		("isPCFull", 52, 1, nil, .bool),
		("countLegendaryPartyPkm", 53, 1, nil, nil),
		("setPartyMember", 54, 2, [.partyMember, nil], nil), // int party member character index (0 for none), int unknown. also used to unset.
		
		("countPurfiedPkm", 59, 1, nil, nil),
		("awardMtBattleRibbons", 60, 1, nil, nil),
		("getPkCoupons", 61, 1, nil, nil),
		("setPkCoupons", 62, 2, nil, nil), //# (int nb)
		("receivePkCoupons", 63, 2, nil, nil), //# (int amount) (can be < 0)
		("countAllShadowPkm", 64, 1, nil, nil),
		
		("receiveItemSilently", 67, 5, [nil ,nil, .item, nil], nil), //# (int unk, int unk, int itemid, int quantity)
		("isSpeciesInPC", 68, 2, [.pokemon], .bool), //# (int species)
		("releasePartyPkm", 69, 2, nil, nil), //# (int index). Returns 1 iff there was a valid Pokémon, 0 otherwise.
		
		
	],
	
//MARK: - Sound
	47 : [
		
		("playSoundEffect", 16, 4, nil, nil), // int songid, int unk, int volume
		
		("setBGM", 25, 5, nil, nil), //# (int bgm id, int unk1, int unk2, int volume)
	
	],
	
//MARK: - Day Care
	52 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (1) ", start = 16, nb = 4),
		
		("getLevelsGained", 17, 1, nil, nil),
		("getNbOfHundredsOfShadowCtrLost", 18, 1, nil, nil), //# int((shadowPkmCounter - initialShadowPkmCounter)/100)
		("depositPkm", 19, 2, nil, nil),
		("withdrawPkm", 20, 2, nil, nil),
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (2) : checking the daycare status", start = 21, nb = 3),
		
		("calculateCost", 21, 2, nil, nil), //# Cost of daycare : 100*(1 + (currentLevel - initialLevel) + 1 +
		//# int((purifCtr - initialPurifCtr)/100))
		//# or 100*(1 + currentLevel - initialLvl) if (purifCtr - initialPurifCtr) < 100.
		//# 0 if status != PkmDeposited
		("checkDaycareStatus", 22, 1, nil, nil), //# NotVisited (or any other unassigned value) = -1,
		//# NoPkmDeposited = 0, PkmDeposited = 1
		("getPkm", 22, 1, nil, nil)
	],
	
//MARK: - Task Manager
	54 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 8),
		
		("allocateTask", 16, 2, nil, nil), //# returns taskUID ... allocates a task but seems to do nothing ... BROKEN ?
		("zeroFunction17", 17, 1, nil, nil), //# arg : taskUID
		("getTaskCounter", 18, 1, nil, nil),
		("stopTask", 19, 2, nil, nil), //# unusable
		("unknownFunction20", 20, 2, nil, nil), //#set
		("unknownFunction21", 21, 2, nil, nil), //#get
		("unknownFunction22", 22, 3, nil, nil),
		("unknownFunction23", 23, 3, nil, nil)
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
		("isShadowPkmPurified", 16, 2, [.shadowID], .bool),
		("isShadowPkmCaught", 17, 2, [.shadowID], .bool),
		("setShadowPkmStatus", 18, 3, [.shadowID, .shadowStatus], nil),
		("getShadowPkmSpecies", 19, 2, [.shadowID], .pokemon),
		("getShadowPkmStatus", 20, 2, [.shadowID], .shadowStatus),
		("unknownFunction21", 21, 2, nil, nil),
		("setShadowPkmPCBoxIndex", 22, 4, [.shadowID, nil, nil], nil), //# (int index, int subIndex)
	],
	
//MARK: - Pokespot
	60 : [
		("getCurrentWildPokemon", 17, 2, [.pokespot], .pokemon), //# (int pokespotId)
	]
	
]

































