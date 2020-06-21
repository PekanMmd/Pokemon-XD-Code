//
//  PBRScriptClassData.swift
//  Revolution Tool CL
//
//  Created by The Steez on 26/12/2018.
//

import Foundation


//MARK: - Class Names
let ScriptClassNames : [Int : String] = [
	// .xds script format requires classes to be named with first character capitalised
	0 : "Standard",
	4 : "Vector",
	7 : "Array",
	8 : "ScriptInstruction",
	
	36 : "BattlePokemon",
	54 : "TaskManager"
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
let ScriptClassFunctions : [Int : [(name: String, index: Int, parameterCount: Int)]] = [
	//MARK: - Standard
	0 : [
		("pause", 17, 1),
		("yield", 18, 1),
		("setTimer", 19, 1),
		("getTimer", 20, 1),
		("waitUntil", 21, 2),
		("printString", 22, 1),
		("typeName", 29, 1),
		("getCharacter", 30, 2), //# (str, index)
		("setCharacter", 31, 1),
		("findSubstring", 32, 2), //#BUGGED, returns -1
		("setBit", 33, 2),
		("clearBit", 34, 2),
		("mergeBits", 35, 2),
		("nand", 36, 2),
		("sin", 48, 1), //# trigo. function below work with degrees
		("cos", 49, 1),
		("tan", 50, 1),
		("atan2", 51, 1),
		("acos", 52, 1),
		("sqrt", 53, 1),
		("printf", 136, 1), // params also include pattern matches like %d. debug only
		("genRandomNumberMod", 137, 1), // generates a random number between 0 and the parameter - 1
	],
	
	//MARK: - Vector
	4 : [
		("toString", 3, 1),
		("clear", 16, 1),
		("normalize", 17, 1),
		("set", 18, 3),
		("set2", 19, 4),
		("fill", 20, 2),
		("abs", 21, 1), //#in place
		("negate", 22, 1), //#in place
		("isZero", 23, 1),
		("crossProduct", 24, 2),
		("dotProduct", 25, 2),
		("norm", 26, 1),
		("squaredNorm", 27, 1),
		("angle", 28, 2)
	],
	
	//MARK: - Array
	7 : [
		//#------------------------------------------------------------------------------------
		("invalidFunction0", 0, 0),
		("invalidFunction1", 1, 0),
		("invalidFunction2", 2, 0),
		//#------------------------------------------------------------------------------------
		("toString", 3, 1),
		//#------------------------------------------------------------------------------------
		("get", 16, 2), // array get
		("set", 17, 3), // array set
		("size", 18, 1),
		("resize", 19, 2), //#REMOVED
		("extend", 20, 2), //#REMOVED
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods (2) : iterator functions", start = 22, nb = 4),
		
		("resetIterator", 22, 1),
		("derefIterator", 23, 2),
		("getIteratorPos", 24, 2),
		("append", 25, 2) //#REMOVED
	],

	//MARK: - Battle Pokemon
	36 : [
		("getCurrentMove", 23, 1),
	
	],

	//MARK: - Task Manager
	54 : [
		//#------------------------------------------------------------------------------------
		//Category(name = "Methods", start = 16, nb = 8),

		("allocateTask", 16, 2), //# returns taskUID ... allocates a task but seems to do nothing ... BROKEN ?
		("zeroFunction17", 17, 2), //# arg : taskUID
		("getTaskCounter", 18, 1),
		("stopTask", 19, 2),
	]
	
]






