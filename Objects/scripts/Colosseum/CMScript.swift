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
let currentCMSVersion: Float = 0.9
let minXDSVersionCompatibilty: Float = 0.9

typealias FTBL = (codeOffset: Int, end: Int, name: String, index: Int)

class XGScript: CustomStringConvertible {
	
	var file: XGFiles!
	var mapRel: XGMapRel?
	var data: XGMutableData!
	var stringTable: XGStringTable?

	var scriptTypeID: Int = 0
	var numberOfFunctions = 0
	var unknown = 0
	var codeStartPointer1: UInt32 = 0
	var codeStartPointer2: UInt32 = 0

	var startOffset = 0
	var fixedFileSize: Int?

	var ftbl = [FTBL]()
	
	 var codeLength : Int {
		return 0
	}
	
	convenience init(file: XGFiles) {
		var fileData = XGMutableData()
		if let data = file.data {
			fileData = data
		} else {
			fileData.file = file
		}

		var fixedStartOffset = 0
		var fixedLength = fileData.length
		if file == .common_rel {
			fixedStartOffset = CommonIndexes.Script.startOffset
			fixedLength = CommonIndexes.Script.length
		}
		self.init(data: fileData.getSubDataFromOffset(fixedStartOffset, length: fixedLength), startOffset: fixedStartOffset, fixedLength: fixedLength)
	}

	init(data: XGMutableData, startOffset: Int = 0, fixedLength: Int = 0) {
		self.data = data
		self.file = data.file
		fixedFileSize = fixedLength
		self.startOffset = startOffset
		guard data.length > kCMScriptHeaderSize else {
			return
		}

		if file != .common_rel {
			// check for rel file in same folder
			let relFile = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.rel.fileExtension, file.folder)
			if relFile.exists {
				let rel = XGMapRel(file: relFile, checkScript: false)
				mapRel = rel
			}

			// if not found, check for rel file in rels folder
			if mapRel == nil {
				let relFile = XGFiles.typeAndFsysName(.rel, file.fileName.removeFileExtensions())
				if relFile.exists {
					let rel = XGMapRel(file: relFile, checkScript: false)
					mapRel = rel
				}
			}

			// check for msg file in same folder
			let msgFile = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.msg.fileExtension, file.folder)
			if msgFile.exists {
				stringTable = msgFile.stringTable
			} else {
			// if not found, check for msg file in string tables folder
				let msgFile = XGFiles.typeAndFsysName(.msg, file.fileName.removeFileExtensions())
				if msgFile.exists {
					stringTable = msgFile.stringTable
				}
			}
		}

		scriptTypeID = data.get2BytesAtOffset(0) // 0x596 for common, 0x100 for other
		numberOfFunctions = data.get2BytesAtOffset(4)
		unknown = data.get2BytesAtOffset(8)
		codeStartPointer1 = data.getWordAtOffset(12)
		codeStartPointer2 = data.getWordAtOffset(16)

		var tempFTBL = [FTBL]()

		for i in 0 ..< numberOfFunctions {
			let pointerOffset = kCMScriptHeaderSize + (i * 4)
			let codeOffset = data.get4BytesAtOffset(pointerOffset)
			tempFTBL.append((codeOffset: codeOffset, end: 0, name: "function\(i)", index: i))
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
		ftbl.sort(by: {$0.index < $1.index})
	}

	func getByteCodeForFunction(withIndex index: Int) -> [Int] {
		guard index < ftbl.count else {
			return []
		}
		let f = ftbl[index]
		return data.getByteStreamFromOffset(f.codeOffset, length: f.end - f.codeOffset)
	}

	func getInstructionsForFunction(withIndex index: Int) -> [CMScriptOps] {
		let byteCode = getByteCodeForFunction(withIndex: index)
		return parse(byteCode: byteCode)
	}

	func parse(byteCode: [Int]) -> [CMScriptOps] {
		var currentOffset = 0
		var instructions = [CMScriptOps]()
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

		var reachedExit = false
		while currentOffset < data.length, !reachedExit {
			let currentByte = readChar()

			switch currentByte {
			case 0: instructions.append(.nop)
			case 1: reachedExit = true//; instructions.append(.exit)
			case 2: instructions.append(.pushMinus1)
			case 3: instructions.append(.pop(unused: CMScriptVar.fromMask(readChar()), count: readHalf()))
			case 4: instructions.append(.call(functionID: readWord(), returnCount: readHalf(), argCount: readHalf()))
			case 5: instructions.append(.return_op)
			case 6: instructions.append(.jump(offset: readWord()))
			case 7: instructions.append(.jumpFalse(offset: readWord()))
			case 8: instructions.append(.pushImmediate(type: CMScriptValueTypes.fromID(Int(readChar())), value: readWord()))
			case 9, 10, 11, 12:
				printg("Invalid op code error when parsing script instructions")
				return []
			case 13: instructions.append(.and(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 14: instructions.append(.or(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 15: instructions.append(.pushVar(var1: CMScriptVar.fromMask(readChar())))
			case 16: instructions.append(.pushMultiVar(var1: CMScriptVar.fromMask(readChar()), count: readHalf()))
			case 17: instructions.append(.not(var1: CMScriptVar.fromMask(readChar())))
			case 18: instructions.append(.negate(var1: CMScriptVar.fromMask(readChar())))
			case 19: instructions.append(.pushVar2(var1: CMScriptVar.fromMask(readChar())))
			case 20: instructions.append(.multiply(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 21: instructions.append(.divide(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 22: instructions.append(.mod(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 23: instructions.append(.add(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 24: instructions.append(.subtract(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 25: instructions.append(.lessThan(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 26: instructions.append(.lessThanEqual(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 27: instructions.append(.greaterThan(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 28: instructions.append(.greaterThanEqual(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 29: instructions.append(.equal(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 30: instructions.append(.notEqual(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 31: instructions.append(.setVar(source: CMScriptVar.fromMask(readChar()), target: CMScriptVar.fromMask(readChar())))
			case 32: instructions.append(.copyStruct(source: CMScriptVar.fromMask(readChar()), destination: CMScriptVar.fromMask(readChar()), length: readHalf()))
			case 33: instructions.append(.andl(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 34: instructions.append(.orl(var1: CMScriptVar.fromMask(readChar()), var2: CMScriptVar.fromMask(readChar())))
			case 35: instructions.append(.printf(unused: readHalf(), argCount: readHalf()))
			case 36: instructions.append(.yield(unused: readHalf(), argCount: readHalf()))
			case 37: instructions.append(.callStandard(returnCount: readHalf(), argCount: readHalf()))
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

		for f in ftbl.sorted(by: { (f1, f2) -> Bool in
			f1.index < f2.index
		}) {
			text += f.name + " (fileOffset: \(f.codeOffset.hexString()))\n"
		}
		text += "\n\n"

		for f in 0 ..< numberOfFunctions {
			let instructions = getInstructionsForFunction(withIndex: f)
			text += ftbl[f].name + "\n-----------------\n"

			var currentOffset = ftbl[f].codeOffset

			for i in 0 ..< instructions.count {
				text += currentOffset.unsigned.hex() + ": " + instructions[i].description + "\n"
				currentOffset += instructions[i].length

				if case .callStandard = instructions[i], i > instructions[i].argCount + 1 {
					let fidInstruction = instructions[i - 1 - instructions[i].argCount]
					let previousInstruction = instructions[i - 1]
					switch fidInstruction {
					case .pushImmediate(.integer, value: let functionID):
						if let functionName = ScriptBuiltInFunctions[functionID.int]?.name {
							text += ">> CallStandard \(functionName)\n"

							switch previousInstruction {
							case .pushImmediate(.integer, value: let value):
								// display message
								if functionID == 0x36 {
									let msgID = value.int
									let string = stringTable?.stringWithID(msgID) ?? getStringSafelyWithID(id: msgID)
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

	func getXDSScript() -> String {
		var text = generateXDSHeader()
		text += "".addRepeated(s: "\n", count: 3)

		// Special macros for GoD tool
		text += "// Compiler options\n"
		for macro in self.getSpecialMacros() {
			text += macro + "\n"
		}

		let (globals, macros) = getGlobalVars()
		let (exprs, macros2) = loadExpressions()

		let allMacros = macros + macros2
		// macros
		text += "\n// Macro defintions\n"

		var uniqueMacros = [CMSExpr]()
		for macro in allMacros {
			if macro.macroName == "YES" || macro.macroName == "NO" {
				continue
			}
			if uniqueMacros.contains(where: { (expr) -> Bool in
				return expr.macroName == macro.macroName
			}) {
				if !uniqueMacros.contains(where: { (expr) -> Bool in
					return (expr.macroName == macro.macroName) && (expr.macroRawValue == macro.macroRawValue)
				}) {
					var suffix = 2
					while uniqueMacros.contains(where: { (expr) -> Bool in
						return expr.macroName == macro.macroName + suffix.string
					}) {
						suffix += 1
					}
					uniqueMacros.append(.macroDefinition(macro.macroName + suffix.string, macro.macroRawValue))
				}
			} else {
				uniqueMacros.append(macro)
			}
		}

		for macro in uniqueMacros.sorted(by: { (m1, m2) -> Bool in
			return m1.macroName < m2.macroName
		}) {
			text += macro.text(script: self) + "\n"
		}

		text += "\n\n" + globals + "\n"

		exprs.forEach { (expr) in
			text += "\(expr.text(script: self))\n"
		}
		return text
	}

	func getGlobalVars() -> (text: String, macros: [CMSExpr]) {
		var str = ""
		var mac = [CMSExpr]()

		if let rel = mapRel {
			let characters = [
				XGCharacter(resourceID: 100),
				XGCharacter(resourceID: 101)
			] + rel.characters

			characters.forEach { character in
				str += "Character GroupID: " + character.gid.string + " ResourceID: " + character.rid.string + " "
				if character.gid != 0 {
					let charID = character.characterID
					if charID > 0 {
						let macroString = CMSExpr.macroWithName("CHARACTER_ID_" + character.name.simplified.uppercased())
						str += "CharacterID: " + macroString + " "
						mac.append(.macroDefinition(macroString, charID.string))
					}

					if !fileDecodingMode {
						let modelID = character.model.index
						if modelID == 0 {
							str += "ModelID: 0 "
						} else {
							let macroString = CMSExpr.macroWithName("MODEL_ID_" + character.model.name.simplified.uppercased())
							str += "ModelID: " + macroString + " "
							mac.append(.macroDefinition(macroString, modelID.string))
						}
					}

					let movement = (character.movementType ?? .index(0)).index
					if movement > 0 {
						str += "MovementID: " + movement.string + " "
					}

					if !character.isVisible {
						str += "Visible: NO "
					}

					str += "Flags: " + character.flags.hexString() + " "

					str += "X: " + character.xCoordinate.string + " "
					str += "Y: " + character.yCoordinate.string + " "
					str += "Z: " + character.zCoordinate.string + " "
					if character.angle != 0 {
						str += "Angle: " + character.angle.string   + " "
					}

					if character.hasScript {
						if character.scriptIndex < ftbl.count {
							str += "Script: \(ftbl[character.scriptIndex].name) "
						}
					}
					if character.hasPassiveScript {
						if character.passiveScriptIndex < ftbl.count {
							str += "Background: \(ftbl[character.passiveScriptIndex].name) "
						}
					}

				}

				if character.gid == 0 {
					switch character.rid {
					case 100: str += " // Wes"
					case 101: str += " // Rui"
					default: str += " // Invalid GIRI"
					}
				}
				str += "\n"
			}
			str += "\n"
		}

		return (str, mac)
	}

	func loadExpressions() -> (expressions: [CMSExpr], macroDefs: [CMSExpr]) {
		var expressions = [CMSExpr]()

		for f in 0 ..< numberOfFunctions {
			var argCount = 0
			let functionExpressions = XGStack<CMSExpr>()
			let instructions = getInstructionsForFunction(withIndex: f)
			let functionStartOffset = ftbl[f].codeOffset

			var jumpLocations = [Int]()
			// first pass to find jump locations
			// must separate first pass in order to catch negative jumps in loops etc.
			for instruction in instructions {

				switch instruction {
				case .jump(let l), .jumpFalse(let l):
					jumpLocations.addUnique(l.int)
				default:
					break
				}
			}

			var currentLocation = functionStartOffset
			if jumpLocations.contains(currentLocation) {
				functionExpressions.push(.location(currentLocation))
			}
			instructions.forEach { (instruction) in
				switch instruction {

				case .nop:
					break
				case .exit:
					break
				case .pushMinus1:
					functionExpressions.push(.constant(.integer(-1)))
				case .pop:
					break
				case .call(functionID: let functionID, _, argCount: let argCount):
					var args = [CMSExpr]()
					for _ in 0 ..< argCount {
						if !functionExpressions.isEmpty {
							args.append(functionExpressions.pop())
						} else {
							printg("Error decompiling script. not enough arguments on stack for script function.")
						}
					}
					functionExpressions.push(.call(functionID.int, args.reversed()))
				case .return_op:
					switch functionExpressions.peek() {
					case .variableAssignment(.variable(let varDescriptor, .constant(.integer(0))), let subExpr):
						if varDescriptor.isLocalVar {
							functionExpressions.pop()
							functionExpressions.push(.CMSReturnResult(subExpr))
						} else {
							fallthrough
						}
					case .CMSReturnResult, .CMSReturn:
						break;
					default:
						functionExpressions.push(.CMSReturn)
					}
				case .jump(offset: let offset):
					functionExpressions.push(.jump(offset.int))
				case .jumpFalse(offset: let offset):
					if functionExpressions.isEmpty {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						functionExpressions.push(.jumpFalse(functionExpressions.pop(), offset.int))
					}
				case .pushImmediate(type: let type, value: let value):
					let constant: CMSConstant
					switch type {
					case .none: constant = .void(value.int)
					case .integer: constant = .integer(value.int32)
					case .float: constant = .float(value.hexToSignedFloat())
					case .unknown(let id): constant = .unknownType(typeID: id, value: value.int)
					}
					functionExpressions.push(.constant(constant))
				case .and(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.and, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .or(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.or, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .pushVar(var1: let var1):
					if functionExpressions.count < 1 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						if var1.isLocalVar {
							switch arg1 {
							case .constant(.integer(let constant)):
								argCount = max(argCount, constant + 1)
							default:
								break
							}
						}
						if var1.isLiteral {
							functionExpressions.push(arg1)
						} else {
							functionExpressions.push(CMSExpr.variable(var1, arg1))
						}
					}
				case .pushMultiVar(var1: let var1, count: let count):
					if functionExpressions.count < 1 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else if count != 1 {
						printg("Error decompiling script. Unhandled push multi var with count > 1")
					} else {
						let arg1 = functionExpressions.pop()
						if var1.isLocalVar {
							switch arg1 {
							case .constant(.integer(let constant)):
								argCount = max(argCount, constant + 1)
							default:
								break
							}
						}
						if var1.isLiteral {
							functionExpressions.push(arg1)
						} else {
							functionExpressions.push(CMSExpr.variable(var1, arg1))
						}
					}
				case .not(var1: let var1):
					if functionExpressions.count < 1 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						functionExpressions.push(.operation(.not, [CMSExpr.variable(var1, arg1)]))
					}
				case .negate(var1: let var1):
					if functionExpressions.count < 1 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						functionExpressions.push(.operation(.negate, [CMSExpr.variable(var1, arg1)]))
					}
				case .pushVar2(var1: let var1):
					if functionExpressions.count < 1 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						if var1.isLocalVar {
							switch arg1 {
							case .constant(.integer(let constant)):
								argCount = max(argCount, constant + 1)
							default:
								break
							}
						}
						if var1.isLiteral {
							functionExpressions.push(arg1)
						} else {
							functionExpressions.push(CMSExpr.variable(var1, arg1))
						}
					}
				case .multiply(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.multiply, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .divide(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.divide, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .mod(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.mod, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .add(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.add, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .subtract(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.subtract, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .lessThan(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.lessThan, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .lessThanEqual(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.lessThanEqual, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .greaterThan(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.greaterThan, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .greaterThanEqual(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.greaterThanEqual, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .equal(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.equal, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .notEqual(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.notEqual, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .setVar(source: let source, target: let target):
					if functionExpressions.count > 1 {
						let expression = functionExpressions.pop()
						let targetVariableExpression = functionExpressions.pop()
						functionExpressions.push(.variableAssignment(.variable(target, targetVariableExpression), .variable(source, expression)))
					} else {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					}
				case .copyStruct(source: let source, destination: let destination, length: let length):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg2 = functionExpressions.pop()
						let arg1 = functionExpressions.pop()
						#warning("TODO: check these are ordered correctly")
						functionExpressions.push(.structAssignment(CMSExpr.variable(source, arg1), CMSExpr.variable(destination, arg2), Int(length)))
					}
				case .andl(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.andl, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .orl(var1: let var1, var2: let var2):
					if functionExpressions.count < 2 {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						let arg1 = functionExpressions.pop()
						let arg2 = functionExpressions.pop()
						functionExpressions.push(.operation(.orl, [CMSExpr.variable(var1, arg1), CMSExpr.variable(var2, arg2)]))
					}
				case .printf(_, argCount: let argCount):
					var args = [CMSExpr]()
					for _ in 1 ..< argCount {
						if !functionExpressions.isEmpty {
							args.append(functionExpressions.pop())
						} else {
							printg("Error decompiling script. not enough arguments on stack for script function.")
						}
					}
					var string = ""
					if !functionExpressions.isEmpty {
						let stringPointerExpression = functionExpressions.pop()
						switch stringPointerExpression {
						case .constant(.integer(let offset)):
							string = data.getStringAtOffset(offset, charLength: .char, maxCharacters: nil)
						default:
							printg("Error: function index isn't an integer constant")
						}
					}
					functionExpressions.push(.print(string, args))
				case .yield(_, argCount: let argCount):
					if argCount != 1 {
						printg("Error decompiling script. Yield with multiple arguments not handled.")
					} else if functionExpressions.isEmpty {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					} else {
						functionExpressions.push(.yield(functionExpressions.pop()))
					}
				case .callStandard(_, argCount: let argCount):
					var args = [CMSExpr]()
					for _ in 0 ..< argCount - 1 {
						if !functionExpressions.isEmpty {
							args.append(functionExpressions.pop())
						} else {
							printg("Error decompiling script. not enough arguments on stack for script function.")
						}
					}
					if !functionExpressions.isEmpty {

						var functionID = 0
						while !functionExpressions.isEmpty, functionID == 0 {
							let functionIdExpression = functionExpressions.pop()
							switch functionIdExpression {
							case .constant(.integer(let id)):
								functionID = id
							default:
								continue
							}
						}
						if functionID == 0 {
							printg("Error: function index isn't an integer constant")
						}
						var validFunctionCall = false
						if !functionExpressions.isEmpty {
							// pop local var 0 which comes before every function call
							switch functionExpressions.pop() {
							case .variable, .constant:
								validFunctionCall = true
							default:
								validFunctionCall = false
							}
							if !validFunctionCall {
								// double check function calls are always preceded by another stack value
								assertionFailure("Function calls aren't implemented properly")
							}
						} else {
							printg("Error: Call standard not preceded by local var 0")
						}
						functionExpressions.push(.callBuiltIn(functionID, args.reversed()))
					} else {
						printg("Error decompiling script. not enough arguments on stack for script function.")
					}
				case .invalid(id: let id):
					functionExpressions.push(.error("Unexpected instruction with id \(id)"))
				}

				currentLocation += instruction.length
				if jumpLocations.contains(currentLocation) {
					functionExpressions.push(.location(currentLocation))
				}
			}

			expressions.append(.function(.functionDefinition("script\(f)", (0 ..< argCount).map{"arg\($0)"}), functionExpressions.asArray))
		}

		return compoundExpressions(expressions)
	}

	private func compoundExpressions(_ expressions: [CMSExpr]) -> (expressions: [CMSExpr], macroDefs: [CMSExpr]) {

		var exprs = compoundIfStatements(expressions)
		exprs = compoundWhileLoops(exprs) // requires if statements to be compounded first
		exprs = compoundElseStatements(exprs) // after while loops since those ones are faster to analyse and will mean fewer false searches for else
		exprs = compoundElifStatements(exprs) // requires else statements to be compounded first
		exprs = reShowRequiredLocations(exprs)

		var macros = [CMSExpr]()
		exprs = exprs.map {
			let (newExpr, _, macs) = $0.updateMacroTypes(script: self)
			macros += macs
			return newExpr
		}

		return (exprs, macros)
	}

	private func compoundIfStatements(_ expressions: [CMSExpr]) -> [CMSExpr] {

		let exprs = expressions.stack
		var list = [CMSExpr]()

		while !exprs.isEmpty {
			let expr = exprs.pop()
			switch expr {
			case .function(let definition, let block):
				list.append(.function(definition, compoundIfStatements(block)))

			case .jumpFalse(_, let location):
				var ifSubs = [CMSExpr]()

				var searching = true
				while searching, !exprs.isEmpty {
					let nextSub = exprs.pop()
					switch nextSub {
					case .location(location),  .silentLocation(location):
						ifSubs.append(.silentLocation(location)) // in case another instruction inside the if statement refers to this location
						list.append(.ifStatement([(expr, compoundIfStatements(ifSubs))]))
						list.append(.silentLocation(location)) // in case another instruction outside the if statement refers to this location
						searching = false
					default:
						ifSubs.append(nextSub)
					}
				}
				if searching {
					// location wasn't found, usually due to a negative jump
					list.append(expr)
					for expr in ifSubs {
						exprs.push(expr) // put everything else back
					}
				}

			default:
				list.append(expr)
			}
		}

		return list
	}

	private func compoundElseStatements(_ expressions: [CMSExpr]) -> [CMSExpr] {

		let exprs = expressions.stack
		var list = [CMSExpr]()

		while !exprs.isEmpty {
			let expr = exprs.pop()
			switch expr {
			case .function(let definition, let block):
				list.append(.function(definition, compoundElseStatements(block)))

			case .whileLoop(let condition, let block):
				list.append(.whileLoop(condition, compoundElseStatements(block)))

			case .ifStatement(let blocks):
					if blocks.count == 1,
					let lastExpr = blocks[0].1.lastAction,
					case .jump(let location) = lastExpr
					{
						var elseSubs = [CMSExpr]()

						var searching = true
						while searching, !exprs.isEmpty {
							let nextSub = exprs.pop()
							switch nextSub {
							case .location(location),  .silentLocation(location):
								var ifSubs = blocks[0].1
								ifSubs.removeLastAction()
								elseSubs.append(.silentLocation(location)) // in case another instruction inside the else statement refers to this location
								list.append(.ifStatement( [
									(blocks[0].0, compoundElseStatements(ifSubs)), // original if statement
									(.nop, compoundElseStatements(elseSubs)) // additional else statement
								]))
								list.append(.silentLocation(location)) // in case another instruction outside the else statement refers to this location
								searching = false
							default:
								elseSubs.append(nextSub)
							}
						}
						if searching {
							// location wasn't found, usually due to a negative jump
							list.append(expr)
							for expr in elseSubs {
								exprs.push(expr) // put everything else back
							}
						}

					} else {
						var compoundedBlocks = [(CMSExpr, [CMSExpr])]()
						for block in blocks {
							compoundedBlocks.append((block.0, compoundElseStatements(block.1)))
						}
						list.append(.ifStatement(compoundedBlocks))
					}

			default:
				list.append(expr)
			}
		}

		return list
	}

	private func compoundElifStatements(_ expressions: [CMSExpr]) -> [CMSExpr] {

		let exprs = expressions.stack
		var list = [CMSExpr]()

		while !exprs.isEmpty {
			let expr = exprs.pop()
			switch expr {
			case .function(let definition, let block):
				list.append(.function(definition, compoundElifStatements(block)))

			case .whileLoop(let condition, let block):
				list.append(.whileLoop(condition, compoundElifStatements(block)))

			case .ifStatement(let blocks):
				// combine if statement sub blocks into else-if blocks
				if blocks.count > 1, // has at least an if and an else
				   let elseBlock = blocks.last,
				   case .nop = elseBlock.0, // last has no condition so is else case and not elif
				   elseBlock.1.actionCount == 1, // only has one sub expression
				   case .ifStatement(let subBlocks) = compoundElifStatements(elseBlock.1).lastAction // when the only sub expression is an if statement
				{
					var newBlocks = blocks
					newBlocks.removeLast() // remove else case
					newBlocks = newBlocks.map { ($0.0, compoundElifStatements($0.1)) }
					newBlocks += subBlocks

					list.append(.ifStatement(newBlocks))
				} else {
					var compoundedBlocks = [(CMSExpr, [CMSExpr])]()
					for block in blocks {
						compoundedBlocks.append((block.0, compoundElifStatements(block.1)))
					}
					list.append(.ifStatement(compoundedBlocks))
				}

			default:
				list.append(expr)
			}
		}

		return list
	}

	private func compoundWhileLoops(_ expressions: [CMSExpr]) -> [CMSExpr] {

		let exprs = expressions.stack
		var list = [CMSExpr]()

		while !exprs.isEmpty {
			let expr = exprs.pop()
			switch expr {
			case .function(let definition, let block):
				list.append(.function(definition, compoundWhileLoops(block)))

			case .ifStatement(let blocks):
				var compoundedBlocks = [(CMSExpr, [CMSExpr])]()
				for block in blocks {
					compoundedBlocks.append((block.0, compoundWhileLoops(block.1)))
				}
				list.append(.ifStatement(compoundedBlocks))

			case .location(let location), .silentLocation(let location):
				// if the next expression is an if statement which loops back to this location and the end then it's a while loop
				if let peek = exprs.peek(),
				   case .ifStatement(let blocks) = peek,
				   blocks.count == 1, // while loops only have one block
				   let lastExpr = blocks[0].1.lastAction, // at least enough expressions for the jump to loop start and the silent location at end of if block
				   case .jump(location) = lastExpr // last expression (other than silent location at end) jumps back to this location
				{
					exprs.pop() // remove the if statement and replace it with while loop
					list.append(.silentLocation(location)) // in case another instruction outside the loop refers to the same location
					let condition = blocks[0].0
					var newSubBlock = blocks[0].1
					newSubBlock.removeLastAction() // remove goto from end of while loop
					list.append(.whileLoop(condition, compoundWhileLoops(newSubBlock)))

				} else {
					list.append(expr)
				}
			default:
				list.append(expr)
			}
		}

		return list
	}

	private func reShowRequiredLocations(_ expressions: [CMSExpr]) -> [CMSExpr] {
		// After compounding statements there may still be some forced gotos remaing
		// such as "break" statements in while loops
		// Those locations may have been converted to silent ones in the compounding process
		// and if so this function will turn them back to regular locations
		var requiredLocations = [CMSLocation]()
		func getJumps(exprs: [CMSExpr]) {
			exprs.forEach { expression in
				switch expression {
				case .jump(let location), .jumpFalse(_, let location):
					requiredLocations.addUnique(location)
				case .function(_, let block), .whileLoop(_, let block):
					getJumps(exprs: block)
				case .ifStatement(let blocks):
					blocks.forEach { block in
						getJumps(exprs: block.1)
					}
				default:
					return
				}
			}
		}
		getJumps(exprs: expressions)

		guard !requiredLocations.isEmpty else {
			return expressions
		}

		func updateRequiredLocations(exprs: [CMSExpr]) -> [CMSExpr] {
			// Check backwards so lowest instance of location is used if there are multiple
			// E.g. for if statements which create a copy both inside and outside the statement, we want the one outside
			return exprs.reversed().map { expression in
				switch expression {
				case .silentLocation(let location) where requiredLocations.contains(location):
					requiredLocations = requiredLocations.filter{ $0 != location }
					return .location(location)
				case .function(let def, let block):
					return .function(def, updateRequiredLocations(exprs: block))
				case .whileLoop(let condition, let block):
					return .whileLoop(condition, updateRequiredLocations(exprs: block))
				case .ifStatement(let blocks):
					return .ifStatement(blocks.map { block in
						return (block.0, updateRequiredLocations(exprs: block.1))
					})
				default:
					return expression
				}
			}.reversed()
		}
		return updateRequiredLocations(exprs: expressions)
	}

	private func generateXDSHeader() -> String {
		// just arbitrary comments at the top of the file
		let longline = "Decompiled using Gale of Darkness Tool by @StarsMmd"
		let date = Date(timeIntervalSinceNow: 0)
		let shortline = "on \(date).".spaceToLength(longline.count)
		let filename = (self.file.fileName.removeFileExtensions() + XGFileTypes.xds.fileExtension).spaceToLength(longline.count)
		return """
		/////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////
		////                                                     ////
		//// \(filename) ////
		//// Decompiled using Colosseum Tool by @StarsMmd        ////
		//// \(shortline) ////
		////                                                     ////
		/////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////
		"""
	}

	private func getSpecialMacros() -> [String] {
		var macs = [String]()
		macs.append("define ++CMSVersion " + String(format: "%1.1f", currentCMSVersion) + " // lets future versions of the compiler know which rules to follow")
		macs.append("// define ++CreateBackup YES // before saving the compiled .scd file, if it already exists it will be backed up")
		macs.append("// define ++BaseStringID 0x10000 // This overrides the compiler's base string id when searching for unused string ids")

		return macs
	}
}




