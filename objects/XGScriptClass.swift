//
//  XGScriptClass.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

enum XGScriptFunction {
	
	case operators(String,Int,Int)
	case unknownOperator(Int)
	case known(String,Int,Int,[XDSMacroTypes?]?, XDSMacroTypes?)
	case unknown(Int)
	
	var name : String {
		switch self {
			case .operators(let name,_,_)	: return name
			case .unknownOperator(let val)  : return "operator\(val)"
			case .known(let name,_,_,_,_)	: return name
			case .unknown(let val)			: return "function\(val)"
		}
	}
	
	var index : Int {
		switch self {
			case .operators(_,let val,_)	: return val
			case .unknownOperator(let val)	: return val
			case .known(_,let val,_,_,_)	: return val
			case .unknown(let val)			: return val
		}
	}
	
	var parameters : Int {
		switch self {
			case .operators(_,_,let val)	: return val
			case .unknownOperator(let val)  : return 0
			case .known(_,_,let val,_,_)	: return val
			case .unknown					: return 0
		}
	}
	
	var macros : [XDSMacroTypes?]? {
		switch self {
			case .operators				: return nil
			case .unknownOperator		: return nil
			case .known(_,_,_,let val,_): return val
			case .unknown				: return nil
		}
	}
	
	var returnMacro : XDSMacroTypes? {
		switch self {
			case .operators				: return nil
			case .unknownOperator		: return nil
			case .known(_,_,_,_,let val): return val
			case .unknown				: return nil
		}
	}
}

enum XGScriptClass {
	case operators
	case classes(Int)
	
	var name : String {
		switch self {
			case .operators			: return "Operator"
			case .classes(let val)	: return ScriptClassNames[val]?.capitalized ?? "Class\(val)"
		}
	}
	
	var index : Int {
		switch self {
			case .operators			: return -1
			case .classes(let val)	: return val
		}
	}
	
	subscript(id: Int) -> XGScriptFunction {
		
		switch self {
			case .operators			: return operatorWithID(id)
			case .classes			: return functionWithID(id)
		}
		
	}
	
	func operatorWithID(_ id: Int) -> XGScriptFunction {
		
		for (name,index,parameters) in ScriptOperators {
			if index == id {
				return .operators(name, index, parameters)
			}
			
		}
		
		// Hopefully shouldn't hit this case
		// All operators should be documented
		printg("Error: encountered unknown operator \(id)")
		return .unknownOperator(id)
	}
	
	func functionWithID(_ id: Int) -> XGScriptFunction {
		let info = ScriptClassFunctions[self.index]
		
		if info == nil {
			return .unknown(id)
		}
		
		for (name,index,parameters,macros, macro) in info! {
			if index == id {
				return .known(name, index, parameters, macros, macro)
			}
		}
		
		return .unknown(id)
	}
	
	func classDotFunction(_ id: Int) -> String {
		return self.name + "." + self[id].name
	}
	
	func functionWithName(_ name: String) -> XGScriptFunction? {
		
		let kMaxNumberOfXDSClassFunctions = 200 // theoretical limit is 0xffff but 200 is probably safe
		for i in 0 ..< kMaxNumberOfXDSClassFunctions {
			let info = self[i]
			if info.name.lowercased() == name.lowercased() {
				return info
			}
			
			// so old scripts can still refer to renamed functions by "function" + number
			if XGScriptFunction.unknown(i).name.lowercased() == name.lowercased() {
				return self[i]
			}
			
		}
		
		return nil
	}
	
	static func getClassNamed(_ name: String) -> XGScriptClass? {
		
		// so old scripts can still refer to renamed classes by "Class" + number
		if name.length > 5 {
			if name.substring(from: 0, to: 5) == "Class" {
				if let val = name.substring(from: 5, to: name.length).integerValue {
					if val < 127 {
						return XGScriptClass.classes(val)
					}
				}
			}
		}
		
		let kNumberOfXDSClasses = 60
		for i in 0 ..< kNumberOfXDSClasses {
			let info = XGScriptClass.classes(i)
			if info.name.lowercased() == name.lowercased() {
				return info
			}
		}
		return nil
	}
	
	var RAMOffset : UInt32? {
		switch self {
		case .operators:
			return nil
		case .classes(let c):
			
			if c == 0 {
				return nil
			}
			
			if c == 4 {
				// vector
				return 0x80242a70
			}
			if c == 7 {
				// array
				return 0x802426b4
			}
			
			if c == 54 {
				// task manager
				return 0x80243098
			}
			
			if c < 33 || c > 60 {
				return nil
			}
			
			let dol = XGFiles.dol.data!
			let branchCodeStart = dol.getWordAtOffset(0x40bc5c - kDOLTableToRAMOffsetDifference + ((c - 33) * 4)) - 0x80000000
			let branchInstructionOffset = branchCodeStart + 0xc
			let branchInstruction = dol.getWordAtOffset(branchInstructionOffset.int - kDOLtoRAMOffsetDifference)
			var branchDifference = ((branchInstruction & 0x3FFFFFF) - 1)
			// check if negative
			if ((branchDifference >> 25) & 0x1.unsigned) == 1 {
				// if so extend 1 bits to make in32 negative
				branchDifference = branchDifference | 0xFC
			}
			return branchInstructionOffset + branchDifference + 0x80000000
			
		}
	}
	
}

























