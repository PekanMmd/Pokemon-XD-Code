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
	case known(String,Int,Int,[XDSMacroTypes?]?, XDSMacroTypes?,String)
	case unknown(Int)
	
	var name : String {
		switch self {
			case .operators(let name,_,_)	: return name
			case .unknownOperator(let val)  : return "operator\(val)"
			case .known(let name,_,_,_,_,_)	: return name
			case .unknown(let val)			: return "function\(val)"
		}
	}
	
	var index : Int {
		switch self {
			case .operators(_,let val,_)	: return val
			case .unknownOperator(let val)	: return val
			case .known(_,let val,_,_,_,_)	: return val
			case .unknown(let val)			: return val
		}
	}
	
	var parameters : Int {
		switch self {
			case .operators(_,_,let val)	: return val
			case .unknownOperator(_) 		: return 0
			case .known(_,_,let val,_,_,_)	: return val
			case .unknown					: return 0
		}
	}
	
	var macros : [XDSMacroTypes?]? {
		switch self {
			case .operators					: return nil
			case .unknownOperator			: return nil
			case .known(_,_,_,let val,_,_)	: return val
			case .unknown					: return nil
		}
	}
	
	var returnMacro : XDSMacroTypes? {
		switch self {
			case .operators					: return nil
			case .unknownOperator			: return nil
			case .known(_,_,_,_,let val,_)	: return val
			case .unknown					: return nil
		}
	}
	
	var hint : String {
		switch self {
		case .operators					: return ""
		case .unknownOperator			: return ""
		case .known(_,_,_,_,_,let val)	: return val
		case .unknown					: return ""
		}
	}
}

enum XGScriptClass {
	case operators
	case classes(Int)
	
	var name : String {
		switch self {
			case .operators			: return "Operator"
			case .classes(let val)	: return ScriptClassNames[val] ?? "Class\(val)"
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
		
		for (name,index,parameters,_) in ScriptOperators {
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
		
		for (name,index,parameters,macros, macro, hint) in info! {
			if index == id {
				return .known(name, index, parameters, macros, macro, hint)
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
		
		let kNumberOfXDSClasses = 100 // vanilla has max class of 60 but leave room for expansion
		for i in 0 ... kNumberOfXDSClasses {
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
			let branchCodeStart = dol.getWordAtOffset(0x40bc5c - kDolTableToRAMOffsetDifference + ((c - 33) * 4)) - 0x80000000
			let branchInstructionOffset = branchCodeStart + 0xc
			let branchInstruction = dol.getWordAtOffset(branchInstructionOffset.int - kDolToRAMOffsetDifference)
			var branchDifference = ((branchInstruction & 0x3FFFFFF) - 1)
			// check if negative
			if ((branchDifference >> 25) & 0x1.unsigned) == 1 {
				// if so extend 1 bits to make in32 negative
				branchDifference = branchDifference | 0xFC
			}
			return branchInstructionOffset + branchDifference + 0x80000000
			
		}
	}

	@discardableResult
	func repointToRAMOffset(_ offset: UInt32) -> Bool {
		switch self {
		case .operators:
			printg("Repointing operators is not yet implemented")
			return false
		case .classes(let c):
			printg("Attempting to repoint script class \(c) to RAM offset:", offset.hexString())
			if c < 33 || c > 60 {
				printg("Currently only allows repointing functions within the default range of 33 to 60")
				return false
			}

			let dol = XGFiles.dol.data!
			let branchCodeStartOffset = 0x40bc5c - kDolTableToRAMOffsetDifference + ((c - 33) * 4)
			dol.replaceWordAtOffset(branchCodeStartOffset, withBytes: offset)
			dol.save()
			printg("Successfully repointed class", c)
			return true
		}
	}

	static func addCustomClassBoilerPlateCode(classOffsetInRAM: Int, numberOfFunctions: Int) {
		// Writes the ASM needed to set up a custom script class
		// Each function pointer in the jump table wil be a 4 byte word pointing
		// to the offset in RAM where that index function will be
		// implemented.
		// This code will automatically dummy out enough space after the class' asm
		// to store the number of function pointers specified and will
		// check against this number before executing the function.
		// Each individual function must handle parsing the arguments
		// from the stack and storing its return value in last result (r4).
		// Make sure the RAM Offset is either in Start.dol or common.rel
		// and has enough space for the following asm and the function pointers.

		// To return a value to the script engine you must store it in last result
		// which is pointed to by r4.
		// Store the return value's type as a half at the memory address of r4.
		// Store the return value itself as a word at the memory address of r4 offset by 4 bytes.

		// To read arguments from the script engine you must read them from the stack.
		// The stack pointer is in r3.
		// Each argument is 8 bytes long. The first half is the value type.
		// The word 4 bytes after the argument's address is the value itself.

		// When the function is complete it should branch back to the "return offset".
		// It's easiest to use btctr for this after loading the offset using mtctr.
		// The return offset is printed when this function completes so note it down somewhere.
		// Also worth noting the start offset for the jump table which is also printed.
		// It'll come in handy when adding new functions to class with the
		// addASMFunctionToCustomClass(jumpTableRAMOffset: Int, functionIndex: Int, codeOffsetInRAM: Int, code: ASM)
		// function below.

		printg("Attempting to add custom class code at offset \(classOffsetInRAM.hexString()) with \(numberOfFunctions) functions.")

		guard numberOfFunctions < 0xFFFF else {
			printg("A script class can't have more than \(0xFFFF) functions")
			return
		}

		var offset = classOffsetInRAM
		if offset < 0x80000000 {
			offset += 0x80000000
		}

		var jumpOffset = 0x0 // Gets set later

		func asmStart() -> ASM {
			return [
				.cmplwi(.r5, UInt32(numberOfFunctions)),
				.bge_l("return"),
				// Load jump table offset in r3
				XGASM.loadImmediateShifted32bit(register: .r3, value: UInt32(jumpOffset)).0,
				XGASM.loadImmediateShifted32bit(register: .r3, value: UInt32(jumpOffset)).1,
				.rlwinm(.r0, .r5, 2, 0, 29), // (0x3fffffff) multiply function index by 4
				.lwzx(.r0, .r3, .r0),
				.mr(.r3, .r6),
				.mr(.r4, .r7),
				.mtctr(.r0),
				.bctr
			]
		}

		let returnLabel: ASM = [.label("return")]

		// Where to resume execution after detouring to this function
		// end of asm function that jumps to each script class
		let returntoScriptEngineOffset: UInt32 = 0x801be194
		let asmEnd: ASM = [
			.li(.r8, 0),
			XGASM.loadImmediateShifted32bit(register: .r4, value: returntoScriptEngineOffset).0,
			XGASM.loadImmediateShifted32bit(register: .r4, value: returntoScriptEngineOffset).1,
			.mr(.r0, .r4),
			.mtctr(.r0),
			.bctr
		]

		jumpOffset = offset + ((asmStart().count + asmEnd.count) * 4)
		let returnOffset = UInt32(offset + (asmStart().count * 4)) // point the dummy pointers here so they do nothing until they're implemented

		XGAssembly.replaceRamASM(RAMOffset: offset, newASM: asmStart() + returnLabel + asmEnd)

		let dummyPointers = [XGASM](repeating: .raw(returnOffset), count: numberOfFunctions)
		XGAssembly.replaceRamASM(RAMOffset: jumpOffset, newASM: dummyPointers)

		printg("Successfully added custom class code.")
		printg("The new class' code is at RAM offset", offset.hexString())
		printg("The jump table is at RAM offset", jumpOffset.hexString())
		printg("The return offset for this class' functions is at RAM offset", returnOffset.hexString())
	}

	static func createCustomClass(withIndex index: Int, atRAMOffset offset: Int, numberOfFunctions: Int) {
		let customClass = XGScriptClass.classes(index)
		guard customClass.repointToRAMOffset(UInt32(offset)) else {
			printg("Couldn't repoint custom class \(index) to offset:", offset.hexString())
			return
		}

		addCustomClassBoilerPlateCode(classOffsetInRAM: offset, numberOfFunctions: numberOfFunctions)
	}

	static func addASMFunctionToCustomClass(jumpTableRAMOffset: Int, functionIndex: Int, codeOffsetInRAM: Int, code: ASM) {
		XGAssembly.replaceRamASM(RAMOffset: codeOffsetInRAM, newASM: code)
		let functionPointerOffset = jumpTableRAMOffset + (functionIndex * 4)
		var codeOffset = codeOffsetInRAM
		if codeOffset < 0x80000000 {
			codeOffset += 0x80000000
		}
		XGAssembly.replaceRamASM(RAMOffset: functionPointerOffset, newASM: [.raw(UInt32(codeOffsetInRAM))])
	}
}

























