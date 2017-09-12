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
	"load immediate",
	"load variable",
	"set variable",
	"set vector",
	"pop",
	"call",
	"return",
	"call standard",
	"jump if true",
	"jump if false",
	"jump",
	"reserve",
	"release",
	"exit",
	"set line",
	"load and copy variable"
	
]

let vectorCoordNames = ["vx","vy","vz","4"]

enum XGScriptOps : Int {
	case nop		= 0
	case `operator`
	case loadImmediate
	case loadVariable
	case setVariable
	case setVector
	case pop
	case call
	case `return`
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
