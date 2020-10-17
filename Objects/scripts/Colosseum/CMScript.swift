//
//  CMScript.swift
//  GoD Tool
//
//  Created by The Steez on 13/03/2019.
//

import Foundation

// ASM for the script interpreter in the US version can be found
// at RAM Offset: 0x800f6bc4
// Jump table for callstd functions is at 0x802e1cf0 (12 bytes per entry)

// Script interpreter has maximum stack size of 100
// r3 is script meta data and stack
// first 0x6c bytes are meta data
// stack is at 0x6c
// offset 0x0 pointer to start of script file
// current script position pointer at 0x14 from r3
// return stack position? pointer at 0x1c
// current stack size stored at offset 0x28 from r3

let kCMScriptHeaderSize = 24

typealias FTBL = (codeOffset: Int, end: Int, name: String, index: Int)

class XGScript: CustomStringConvertible {
	
	var file : XGFiles!
	@objc var mapRel : XGMapRel?
	@objc var data : XGMutableData!

	var magicBytes: UInt32 = 0
	var numberOfFunctions = 0
	var unknown = 0
	var codeStartPointer1: UInt32 = 0
	var codeStartPointer2: UInt32 = 0

	var ftbl = [FTBL]()
	
	@objc var codeLength : Int {
		return 0
	}
	
	convenience init(file: XGFiles) {
		var fileData = XGMutableData()
		if file.exists, let data = file.data {
			fileData = data
		} else {
			fileData.file = file
		}
		self.init(data: fileData)
	}

	init(data: XGMutableData) {
		self.data = data
		self.file = data.file
		guard data.length > kCMScriptHeaderSize else {
			return
		}

		magicBytes = data.getWordAtOffset(0)
		numberOfFunctions = data.get2BytesAtOffset(4)
		unknown = data.get2BytesAtOffset(8)
		codeStartPointer1 = data.getWordAtOffset(12)
		codeStartPointer2 = data.getWordAtOffset(16)

		var tempFTBL = [FTBL]()

		for i in 0 ..< numberOfFunctions {
			let pointerOffset = kCMScriptHeaderSize + (i * 4)
			let codeOffset = data.get4BytesAtOffset(pointerOffset)
			tempFTBL.append((codeOffset: codeOffset, end: 0, name: "@function_\(i)", index: i))
		}
		tempFTBL = tempFTBL.sorted(by: { (f1, f2) -> Bool in
			f1.codeOffset < f2.codeOffset
		})
		var previousFunction: FTBL?
		for f in tempFTBL {
			if var previous = previousFunction {
				previous.end = f.codeOffset
				ftbl.append(previous)
			}
			previousFunction = f
		}
		let lastFunction = tempFTBL.last
		if var last = lastFunction {
			last.end = data.length
			ftbl.append(last)
		}
	}

	func getByteCodeForFunction(withIndex index: Int) -> [Int] {
		guard index < ftbl.count else {
			return []
		}
		let f = ftbl[index]
		return data.getByteStreamFromOffset(f.codeOffset, length: f.end - f.codeOffset)
	}

	func getInstructionsForFunction(withIndex index: Int) -> [XGScriptOps] {
		let byteCode = getByteCodeForFunction(withIndex: index)
		return parse(byteCode: byteCode)
	}

	func parse(byteCode: [Int]) -> [XGScriptOps] {
		var currentOffset = 0
		var instructions = [XGScriptOps]()
		let data = XGMutableData(byteStream: byteCode)

		func readChar() -> UInt8 {
			defer { currentOffset += 1 }
			return data.getCharAtOffset(currentOffset)
		}
		func readHalf() -> UInt16 {
			defer { currentOffset += 2 }
			return data.getHalfAtOffset(currentOffset)
		}
		func readWord() -> UInt32 {
			defer { currentOffset += 4 }
			return data.getWordAtOffset(currentOffset)
		}
		
		while currentOffset < data.length {
			let currentByte = readChar()

			switch currentByte {
			case 0: instructions.append(.nop)
			case 1: instructions.append(.exit)
			case 2: instructions.append(.pushMinus1)
			case 3: instructions.append(.pop(unused: CMScriptVar.fromMask(readChar()), count: readHalf()))
			case 4: instructions.append(.call(functionID: readWord(), unknown1: readHalf(), unknown2: readHalf()))
			case 5: instructions.append(.return_op)
			case 6: instructions.append(.jump(offset: readWord()))
			case 7: instructions.append(.jumpFalse(offset: readWord()))
			case 8: instructions.append(.push(type: readChar(), value: readWord()))
			case 9, 10, 11, 12:
				printg("Invalid op code error when parsing script instructions")
				return []
			case 13: instructions.append(.and(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 14: instructions.append(.or(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 15: instructions.append(.pushVar(var1: CMScriptVar.fromMask(readChar())))
			case 16: instructions.append(.unknown16(var1: CMScriptVar.fromMask(readChar()), count: readHalf()))
			case 17: instructions.append(.not(var1: CMScriptVar.fromMask(readChar())))
			case 18: instructions.append(.negate(var1: CMScriptVar.fromMask(readChar())))
			case 19: instructions.append(.pushVar2(var1: CMScriptVar.fromMask(readChar())))
			case 20: instructions.append(.multiply(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 21: instructions.append(.divide(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 22: instructions.append(.mod(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 23: instructions.append(.add(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 24: instructions.append(.subtract(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 25: instructions.append(.greaterThan(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 26: instructions.append(.greaterThanEqual(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 27: instructions.append(.lessThan(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 28: instructions.append(.lessThanEqual(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 29: instructions.append(.equal(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 30: instructions.append(.notEqual(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 31: instructions.append(.unknown31(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 32: instructions.append(.unknown32(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 33: instructions.append(.unknown33(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 34: instructions.append(.unknown34(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 35: instructions.append(.unknown35(unused: readHalf(), unknown: readHalf()))
			case 36: instructions.append(.unknown36(unused: readHalf(), unknown: readHalf()))
			case 37: instructions.append(.callStandard(unused: readHalf(), argCount: readHalf()))
			default:
				printg("Unknown op code error when parsing script instructions")
				return []
			}
		}
		return instructions
	}

	var description: String {
		var text = file.fileName + "\n"
		text += "\(ftbl.count) functions\n\n"

		for f in ftbl {
			text += f.name + " (\(f.codeOffset.hexString()))\n"
		}
		text += "\n\n"

		for f in 0 ..< script.numberOfFunctions {
			let instructions = script.getInstructionsForFunction(withIndex: f)
			text += script.ftbl[f].name + "\n-----------------\n"

			var currentOffset = script.ftbl[f].codeOffset

			for i in 0 ..< instructions.count {
				text += currentOffset.unsigned.hex() + ": " + instructions[i].description + "\n"
				currentOffset += instructions[i].length

				if case .callStandard = instructions[i], i > instructions[i].argCount + 1 {
					let fidInstruction = instructions[i - 1 - instructions[i].argCount]
					let previousInstruction = instructions[i - 1]
					switch fidInstruction {
					case .push(2, value: let functionID):
						if let functionName = CMSScriptStandardFunctions[functionID.int] {
							text += ">> CallStandard \(functionName)\n"

							switch previousInstruction {
							case .push(2, value: let value):
								// display message
								if functionID == 0x36 {
									let msgID = value.int
									let string = getStringSafelyWithID(id: msgID)
									text += ">> $:\(msgID):\"\(string)\"\n\n"
								}
							default: continue
							}
						}
					default: continue
					}
				}
			}
			text += "\n"
		}
		return text
	}
}




