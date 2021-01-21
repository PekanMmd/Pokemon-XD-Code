//
//  XGScriptOps.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

let instructionNames = [
	
	"nop",
	"operator",
	"ldimm",
	"ldvar",
	"setvar",
	"setvector",
	"pop",
	"call",
	"return",
	"callstd",
	"jmptrue",
	"jmpfalse",
	"jmp",
	"reserve",
	"release",
	"exit",
	"setline",
	"ldncpvar",
	#if GAME_PBR
	"unknown18",
	"loadShortImmediate"
	#endif
	
]

let vectorCoordNames = ["x","y","z","4"]

enum XGScriptOps : Int {
	case nop			= 0
	case xd_operator	= 1
	case loadImmediate = 2
	case loadVariable = 3
	case setVariable = 4
	case setVector = 5
	case pop = 6
	case call = 7
	case return_op = 8
	case callStandard = 9
	case jumpIfTrue = 10
	case jumpIfFalse = 11
	case jump = 12
	case reserve = 13
	case release = 14
	case exit = 15
	case setLine = 16
	case loadNonCopyableVariable = 17
	#if GAME_PBR
	case unknown18 = 18
	case loadShortImmediate = 19
	#endif
	
	
	var name : String {
		get {
			return instructionNames[self.rawValue]
		}
	}
	
}
