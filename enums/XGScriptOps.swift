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
	"ldncpvar"
	
]

let vectorCoordNames = ["x","y","z","4"]

enum XGScriptOps : Int {
	case nop		= 0
	case xd_operator
	case loadImmediate
	case loadVariable
	case setVariable
	case setVector
	case pop
	case call
	case return_op
	case callStandard
	case jumpIfTrue
	case jumpIfFalse
	case jump
	case reserve
	case release
	case exit
	case setLine
	case loadAndCopyVariable
	
	
	var name : String {
		get {
			return instructionNames[self.rawValue]
		}
	}
	
}
