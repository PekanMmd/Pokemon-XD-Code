//
//  XGScript.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

let kScriptSectionHeaderSize = 0x20
let kScriptSizeOfTCOD = 0x10
let kScriptFTBLSize = 0x8
let kScriptGVARSize = 0x8
let kScriptVECTSize = 0xc
let kScriptGIRISize = 0x8
let kScriptARRYPointerSize = 0x4

let kScriptSectionSizeOffset = 0x4
let kScriptSectionEntriesOffset = 0x10


typealias FTBL = (codeOffset: Int, name: String)
typealias GIRI = (groupID: Int, resourceID: Int)
typealias VECT = (x: Float, y: Float, z: Float)

class XGScript: NSObject {
	
	var file : XGFiles!
	var mapRel : XGMapRel!
	
	var FTBLStart = 0
	var HEADStart = 0
	var CODEStart = 0
	
	var GVARStart = 0
	var STRGStart = 0
	var VECTStart = 0
	var GIRIStart = 0 // group id resource id
	var ARRYStart = 0
	
	var ftbl = [FTBL]()
	var code = [XGScriptInstruction]()
	
	var gvar = [XDSConstant]()
	var strg = [String]()
	var vect = [VECT]()
	var giri = [GIRI]()
	var arry = [[XDSConstant]]()
	
	
	init(file: XGFiles) {
		super.init()
		
		self.file = file
		
		let data = file.data
		
		let relFile = XGFiles.rel(self.file.fileName.removeFileExtensions() + ".rel")
		if relFile.exists {
			mapRel = XGMapRel(file: relFile, checkScript: false)
		}
		
		self.FTBLStart = kScriptSizeOfTCOD
		self.HEADStart = FTBLStart + Int(data.get4BytesAtOffset(FTBLStart + kScriptSectionSizeOffset))
		self.CODEStart = HEADStart + Int(data.get4BytesAtOffset(HEADStart + kScriptSectionSizeOffset))
		self.GVARStart = CODEStart + Int(data.get4BytesAtOffset(CODEStart + kScriptSectionSizeOffset))
		self.STRGStart = GVARStart + Int(data.get4BytesAtOffset(GVARStart + kScriptSectionSizeOffset))
		self.VECTStart = STRGStart + Int(data.get4BytesAtOffset(STRGStart + kScriptSectionSizeOffset))
		self.GIRIStart = VECTStart + Int(data.get4BytesAtOffset(VECTStart + kScriptSectionSizeOffset))
		self.ARRYStart = GIRIStart + Int(data.get4BytesAtOffset(GIRIStart + kScriptSectionSizeOffset))
		
		let numberFTBLEntries = Int(data.get4BytesAtOffset(FTBLStart + kScriptSectionEntriesOffset))
//		let numberHEADEntries = Int(data.get4BytesAtOffset(HEADStart + kScriptSectionEntriesOffset))
//		let numberCODEEntries = Int(data.get4BytesAtOffset(CODEStart + kScriptSectionEntriesOffset))
		let numberGVAREntries = Int(data.get4BytesAtOffset(GVARStart + kScriptSectionEntriesOffset))
		let numberSTRGEntries = Int(data.get4BytesAtOffset(STRGStart + kScriptSectionEntriesOffset))
		let numberVECTEntries = Int(data.get4BytesAtOffset(VECTStart + kScriptSectionEntriesOffset))
		let numberGIRIEntries = Int(data.get4BytesAtOffset(GIRIStart + kScriptSectionEntriesOffset))
		let numberARRYEntries = Int(data.get4BytesAtOffset(ARRYStart + kScriptSectionEntriesOffset))
		
		for i in 0 ..< numberFTBLEntries {
			let start = FTBLStart + kScriptSectionHeaderSize + (i * kScriptFTBLSize)
			let codeOffset = Int(data.get4BytesAtOffset(start))
			let nameOffset = Int(data.get4BytesAtOffset(start + 0x4))
			let name = getStringAtOffset(nameOffset + kScriptSizeOfTCOD)
			self.ftbl.append((codeOffset,name))
		}
		
		for i in 0 ..< numberGVAREntries {
			let start = GVARStart + kScriptSectionHeaderSize + (i * kScriptGVARSize)
			self.gvar.append( XDSConstant(type: data.get2BytesAtOffset(start), rawValue: data.get4BytesAtOffset(start + 4)) )
		}
		
		var strgPos = STRGStart + kScriptSectionHeaderSize
		for _ in 0 ..< numberSTRGEntries {
			let str = getStringAtOffset(strgPos)
			self.strg.append(str)
			strgPos += str.characters.count + 1
		}
		
		for i in 0 ..< numberVECTEntries {
			let start = VECTStart + kScriptSectionHeaderSize + (i * kScriptVECTSize)
			let x = data.get4BytesAtOffset(start).hexToSignedFloat()
			let y = data.get4BytesAtOffset(start + 4).hexToSignedFloat()
			let z = data.get4BytesAtOffset(start + 8).hexToSignedFloat()
			self.vect.append((x,y,z))
		}
		
		for i in 0 ..< numberGIRIEntries {
			let start = GIRIStart + kScriptSectionHeaderSize + (i * kScriptGIRISize)
			let groupID = Int(data.get4BytesAtOffset(start))
			let resourceID = Int(data.get4BytesAtOffset(start + 0x4))
			self.giri.append((groupID, resourceID))
		}
		
		for i in 0 ..< numberARRYEntries {
			
			let start = ARRYStart + kScriptSectionHeaderSize
			
			let startPointer = data.get4BytesAtOffset(start + (i * kScriptARRYPointerSize)).int
			let entries = data.get4BytesAtOffset(start + startPointer - 0x10).int
			
			var arr = [XDSConstant]()
			for j in 0 ..< entries {
				let varStart = start + startPointer + (j * kScriptGVARSize)
				arr.append( XDSConstant(type: data.get2BytesAtOffset(varStart), rawValue: data.get4BytesAtOffset(varStart + 4)) )
			}
			self.arry.append(arr)
		}
		
		var rawCode = data.getWordStreamFromOffset(CODEStart + kScriptSectionHeaderSize, length: GVARStart - (CODEStart + kScriptSectionHeaderSize))
		
		var codePointer = 0
		while codePointer < rawCode.count {
			let instruction = XGScriptInstruction(bytes: rawCode[codePointer], next: codePointer == (rawCode.count - 1) ? 0 : rawCode[codePointer + 1])
			self.code.append(instruction)
			codePointer += instruction.length
		}
		
		
	}
	
	
	func getStringAtOffset(_ offset: Int) -> String {
		
		let data = self.file.data
		
		var currentOffset = offset
		
		var currChar = 0x0
		var nextChar = 0x1
		
		let string = XGString(string: "", file: nil, sid: nil)
		
		while (nextChar != 0x00) {
			
			currChar = data.getByteAtOffset(currentOffset)
			currentOffset += 1
			
			string.append(.unicode(currChar))
			
			
			nextChar = data.getByteAtOffset(currentOffset)
			
		}
		
		return string.string
		
	}
	
	override var description: String {
		
		let linebreak = "-----------------------------------\n"
		
		// file name
		var desc = linebreak + self.file.fileName + "\n"
		desc += linebreak
		
		
		// list function names
		desc += "\nFunctions: \(ftbl.count)\n"
		desc += linebreak
		
		for i in 0 ..< self.ftbl.count {
			let (_, name) = self.ftbl[i]
			desc += "\(i): " + name + "\n"
		}
		
		// list script code instructions
		desc += "\nCode\n"
		desc += linebreak
		
		var index = 0
		for i in 0 ..< self.code.count {
			
			// if this instruction is the start of a function, add the function's name
			for (offset, name) in self.ftbl {
				if offset == index {
					desc += "\n" + name + ":\n" + linebreak
					desc += "index |  offset  |   code   | text\n"
				}
			}
			
			// convert instruction to string
			let instruction = self.code[i]
			desc += "\(index.hexString())    (\((index * 4 + CODEStart + kScriptSectionHeaderSize).hexString())):  [\(instruction.raw1.hex())]  \(instruction)" + "\n"
			
			index += instruction.length
			
			// spacing
			let spaceOps : [XGScriptOps] = [.pop,.return_op,.jump,.jumpIfTrue,.jumpIfFalse]
			if spaceOps.contains(instruction.opCode) {
				desc += "\n"
			}
			
			// add context to values
			if instruction.opCode == .call {
				for (index, name) in self.ftbl {
					if index == instruction.parameter {
						desc += ">> " + name + "\n"
					}
				}
			}
			
			if instruction.opCode == .loadNonCopyableVariable || instruction.opCode == .loadVariable {
				if instruction.parameter > 0x80 && instruction.parameter <= 0x120 {
					let index = instruction.parameter - 0x80
					if index < giri.count {
						if giri[index].groupID != 0 {
							let charIndex = giri[index].resourceID
							let char = mapRel.characters[charIndex]
							desc += " " + char.model.name + " " + char.name + "\n"
						}
					}
					
				}
			}
			
			if instruction.opCode == .loadImmediate {
				switch instruction.constant.type {
				case .string:
					desc += ">> \"" + getStringAtOffset(STRGStart + kScriptSectionHeaderSize + instruction.parameter) + "\"\n"
				default:
					break
				}
			}
			
			if instruction.opCode == .callStandard {
				
				if instruction.subOpCode == 35 { // Character
					if instruction.parameter == 70 { // set model
						
						let instr = self.code[i - 2]
						if instr .opCode == .loadImmediate {
							let mid = instr.parameter
							var mindex = -1
							var archive : XGFsys!
							
							let fsys = self.file.fileName.removeFileExtensions() + ".fsys"
							for folder in [XGFolders.AutoFSYS, XGFolders.FSYS, XGFolders.MenuFSYS] {
								let fsysFile = XGFiles.nameAndFolder(fsys, folder)
								if fsysFile.exists && mindex < 0 {
									archive = fsysFile.fsysData
									mindex = archive.indexForIdentifier(identifier: mid)
								}
							}
							
							if mindex < 0 {
								archive = XGFiles.fsys("people_archive.fsys").fsysData
								mindex = archive.indexForIdentifier(identifier: mid)
							}
							
							desc += ">> " + archive.fileNames[mindex] + "\n"
						}
					}
					
					if instruction.parameter == 73 { // talk
						let instr = self.code[i - 3]
						if instr .opCode == .loadImmediate {
							let sid = instr.parameter
							desc += ">> \"" + getStringSafelyWithID(id: sid).string + "\"\n"
						}
						let typeInstr = self.code[i - 2]
						if typeInstr .opCode == .loadImmediate {
							let type = typeInstr.parameter
							if type == 9 {
								let instr = self.code[i - 4]
								if instr .opCode == .loadImmediate {
									let bid = instr.parameter
									desc += ">>\n" + XGBattle(index: bid).trainer!.fullDescription + "\n"
								}
							}
							if type == 14 {
								let instr = self.code[i - 4]
								if instr .opCode == .loadImmediate {
									let itemid = instr.parameter
									desc += ">> receive item: " + XGItems.item(itemid).name.string + "\n"
								}
							}
						}
					}
					if instruction.parameter == 21 { // display message with sound
						let instr = self.code[i - 2]
						if instr .opCode == .loadImmediate {
							let sid = instr.parameter
							desc += ">> \"" + getStringSafelyWithID(id: sid).string + "\"\n"
						}
						
					}
					
				}
				
				if instruction.subOpCode == 40 { // Dialogue
					
					if instruction.parameter == 72 { // startBattle
						let instr = self.code[i - 2]
						if instr .opCode == .loadImmediate {
							let bid = instr.parameter
							desc += ">>\n" + XGBattle(index: bid).trainer!.fullDescription + "\n"
						}
					}
					
					if instruction.parameter == 39 { // open poke mart menu
						
						let instr = self.code[i - 2]
						if instr .opCode == .loadImmediate {
							let mid = instr.parameter
							let mart = XGPokemart(index: mid).items
							desc += ">>\n"
							for item in mart {
								desc += item.name.string + "\n"
							}
							desc += "\n"
						}
						
					}
					
					if instruction.parameter == 29 { // display custom menu
						
						let instr = self.code[i - 2]
						if instr.opCode == .loadNonCopyableVariable {
							let param = instr.parameter
							if param < 0x300 && param >= 0x200 {
								let arrayIndex = param - 0x200
								for element in arry[arrayIndex] {
									desc += ">>" + getStringSafelyWithID(id: element.asInt).string + "\n"
								}
							}
						}
						
					}
					
					if instruction.parameter == 16 || instruction.parameter == 17 { // display msg box
						let instr = self.code[i - 2]
						if instr.opCode == .loadImmediate {
							let sid = instr.parameter
							desc += ">> \"" + getStringSafelyWithID(id: sid).string + "\"\n"
						}
					}
				}
				
				if instruction.subOpCode == 43 { // Player
					if instruction.parameter == 26 || instruction.parameter == 27 || instruction.parameter == 28 || instruction.parameter == 67 { // receive item, check item in bag
						let instr = self.code[i - 2]
						if instr .opCode == .loadImmediate {
							let iid = instr.parameter - (instr.parameter < CommonIndexes.NumberOfItems.value ? 0 : 150)
							desc += ">> " + XGItems.item(iid).name.string + "\n"
						}
					}
				}
				
				if instruction.subOpCode == 42 { // Battle
					if instruction.parameter == 16 { // startBattle
						let instr = self.code[i - 2]
						if instr .opCode == .loadImmediate {
							let bid = instr.parameter
							desc += ">>\n" + XGBattle(index: bid).trainer!.fullDescription + "\n"
						}
					}
				}
				
				if instruction.subOpCode == 38 { // Movement
					if instruction.parameter == 22 { // warp to room
						let instr = self.code[i - 2]
						if instr .opCode == .loadImmediate {
							let sid = instr.parameter
							let room = XGRoom.roomWithID(sid)
							let roomName = room == nil ? "invalid room" : room!.name
							desc += ">> \"" + roomName + "\"\n"
						}
					}
				}
				
			}
		}
		
		// list global variables
		desc += "\nGVAR: \(self.gvar.count)\n" + linebreak
		for g in  0 ..< self.gvar.count {
			desc += "\(g): " + self.gvar[g].description + "\n"
		}
		
		desc += "\nARRY: \(self.arry.count)\n" + linebreak
		for a in 0 ..< self.arry.count {
			desc += "\(a): " + String(describing: self.arry[a]) + "\n"
		}
		
		desc += "\nVECT: \(self.vect.count)\n" + linebreak
		for v in 0 ..< self.vect.count {
			desc += "\(v): < \(vect[v].x), \(vect[v].y), \(vect[v].z) >\n"
		}
		
		desc += "\nGIRI: \(self.giri.count)\n" + linebreak
		for g in  0 ..< self.giri.count {
			let currentGiri = self.giri[g]
			
			desc += "\(g): GroupID(\(currentGiri.groupID)), ResourceID(\(currentGiri.resourceID))"
			if currentGiri.groupID != 0 && currentGiri.resourceID < mapRel.characters.count {
				let char = mapRel.characters[currentGiri.resourceID]
				desc += " " + char.model.name + " " + char.name + " <\(char.xCoordinate), \(char.yCoordinate), \(char.zCoordinate)>" + "\n"
			} else if currentGiri.groupID == 0 && currentGiri.resourceID == 100 {
				desc += " Player\n"
			} else {
				desc += "\n"
			}
		}
		
		return desc
	}
	
	func getParameterCountForFunction(named name: String) -> Int {
		for i in 0 ..< ftbl.count {
			let f = ftbl[i]
			let g = i == ftbl.count - 1 ? nil : ftbl[i + 1]
			if f.name == name {
				var paramCount = 0
				var currentIndex = f.codeOffset
				let lastIndex = g == nil ? self.code.count : g!.codeOffset
				
				var counter = 0
				var lastI = 0
				func getCodeIndexForInstruction(index: Int) -> Int {
					for i in lastI ..< self.code.count {
						if counter == index {
							lastI = i
							return i
						}
						counter += code[i].length
					}
					return -1
				}
				
				while currentIndex < lastIndex && currentIndex >= 0 {
					let currentInstruction = self.code[getCodeIndexForInstruction(index: currentIndex)]
					switch currentInstruction.opCode {
					case .loadVariable:
						fallthrough
					case .loadNonCopyableVariable:
						if currentInstruction.subOpCode == 1 && currentInstruction.parameter > 0 {
							paramCount += 1
						}
						currentIndex += currentInstruction.length
					default:
						currentIndex += currentInstruction.length
					}
				}
				return paramCount
			}
		}
		printg("couldn't get function parameter count: function \"\(name)\" doesn't exist")
		return 0
	}
	
	func getFunctionAtLocation(location: Int) -> String {
		for f in ftbl {
			if f.codeOffset == location {
				return f.name
			}
		}
		return ""
	}
	
	func getInstructionStack() -> XGStack<XDSExpr> {
		let stack = XGStack<XDSExpr>()
		
		var functionParams = [String : Int]()
		for f in ftbl {
			functionParams[f.name] = getParameterCountForFunction(named: f.name)
		}
		
		for i in 0 ..< self.code.count {
			
			let instruction = self.code[i]
			
			switch instruction.opCode {
				
			case .setLine:
				stack.push(.setLine(instruction.parameter))
			case .jumpIfFalse:
				// for unary or binary predicates, invert operators so can use jumptrue
				let predicate = stack.pop()
				let location = XDSExpr.locationWithIndex(instruction.parameter)
				switch predicate {
				case .binaryOperator(let o, let e1, let e2):
					switch o {
						/*("=", 48, 2),
						  (">", 49, 2),
						  (">=", 50, 2),
						  ("<", 51, 2),
						  ("<=", 52, 2),
						  ("!=", 53, 2)*/
					case 49:
						stack.push(.jumpTrue(XDSExpr.binaryOperator(52, e1, e2).bracketed, location))
					case 52:
						stack.push(.jumpTrue(XDSExpr.binaryOperator(49, e1, e2).bracketed, location))
					case 50:
						stack.push(.jumpTrue(XDSExpr.binaryOperator(51, e1, e2).bracketed, location))
					case 51:
						stack.push(.jumpTrue(XDSExpr.binaryOperator(50, e1, e2).bracketed, location))
					case 48:
						stack.push(.jumpTrue(XDSExpr.binaryOperator(53, e1, e2).bracketed, location))
					case 53:
						stack.push(.jumpTrue(XDSExpr.binaryOperator(48, e1, e2).bracketed, location))
					default:
						stack.push(.jumpFalse(predicate.bracketed, location))
					}
				case .unaryOperator(let o, let e):
					switch o {
					case 16: // ! not operator
						stack.push(.jumpTrue(e, location))
					default:
						stack.push(.jumpFalse(predicate.bracketed, location))
					}
				default:
					stack.push(.jumpFalse(predicate.bracketed, location))
				}
            case .jumpIfTrue:
                stack.push(.jumpTrue(stack.pop().bracketed, XDSExpr.locationWithIndex(instruction.parameter)))
            case .jump:
                stack.push(.jump(XDSExpr.locationWithIndex(instruction.parameter)))
            case .call:
				let fname = getFunctionAtLocation(location: instruction.parameter)
				let param_count = functionParams[fname] ?? 0
				var params = [XDSExpr]()
				for _ in 0 ..< param_count {
					params.append(stack.pop().bracketed)
				}
                stack.push(.call(fname, params))
            case .exit:
                stack.push(.exit)
            case .xd_operator:
                if instruction.subOpCode >= 18 && instruction.subOpCode <= 25 {
                     stack.push(.unaryOperator(instruction.subOpCode, stack.pop().forcedBracketed))
				} else if instruction.subOpCode >= 16 && instruction.subOpCode <= 17 {
					stack.push(.unaryOperator(instruction.subOpCode, stack.pop().bracketed))
				} else if (instruction.subOpCode >= 32 && instruction.subOpCode <= 39) || (instruction.subOpCode <= 53 && instruction.subOpCode >= 48) {
                    let e2 = stack.pop().bracketed
                    let e1 = stack.pop().bracketed
                    stack.push(.binaryOperator(instruction.subOpCode, e1, e2))
                } else {
					printg("error! Unknown operator: \(instruction.subOpCode)")
                }
            case .nop:
                continue
            case .loadImmediate:
                stack.push(.loadImmediate(instruction.constant))
            case .loadVariable:
				if instruction.XDSVariable != kXDSLastResultVariable { // TODO: evalutate success
					stack.push(.loadPointer(instruction.XDSVariable))
				} else {
					let previous = stack.pop()
					switch previous {
					case .callStandardVoid(let c, let f, let es):
						stack.push(.callStandard(c, f, es))
					default:
						stack.push(previous)
						stack.push(.loadPointer(instruction.XDSVariable))
					}
				}
            case .setVariable:
                stack.push(.setVariable(instruction.XDSVariable, stack.pop().bracketed))
            case .setVector:
                stack.push(.setVector(instruction.XDSVariable, stack.pop().bracketed))
            case .pop:
                continue
            case .return_op:
                let previous = stack.pop()
				switch previous {
				case .setVariable(let v, let e):
					if v == kXDSLastResultVariable {
						stack.push(.XDSReturnResult(e.bracketed))
					} else {
						stack.push(previous)
						stack.push(.XDSReturn)
					}
				default:
					stack.push(previous)
					stack.push(.XDSReturn)
				}
            case .callStandard:
				var paramCount = 0
				if i == self.code.count - 1 {
					printg("error: final function call without pop.")
				}
                let next = self.code[i + 1]
				if next.opCode != .pop {
					printg("error: function call without pop.")
				} else {
					paramCount = next.subOpCode
				}
				var params = [XDSExpr]()
				for _ in 0 ..< paramCount {
					params.append(stack.pop().bracketed)
				}
				stack.push(.callStandardVoid(instruction.subOpCode, instruction.parameter, params))
            case .reserve:
                stack.push(.reserve(instruction.parameter))
            case .release:
                continue
			case .loadNonCopyableVariable:
				if instruction.XDSVariable != kXDSLastResultVariable { // TODO: evalutate success
					stack.push(.loadPointer(instruction.XDSVariable))
				} else {
					let previous = stack.pop()
					switch previous {
					case .callStandardVoid(let c, let f, let es):
						stack.push(.callStandard(c, f, es))
					default:
						stack.push(previous)
						stack.push(.loadPointer(instruction.XDSVariable))
					}
				}
			}
            
		}
		
		return stack
	}
	
	func getXDSScript() -> String {
		let stack = getInstructionStack()
		
		var jumpLocations = [Int]()
		var functionLocations = [Int : String]()
		for f in ftbl {
			functionLocations[f.codeOffset] = f.name
		}
		
		// first pass to find jump locations
		// must separate first pass in order to catch negative jumps in loops etc.
		for expr in stack.asArray {
			
			switch expr {
			case .jump(let l):
				jumpLocations.addUnique(XDSExpr.indexForLocation(l))
			case .jumpTrue(_, let l):
				jumpLocations.addUnique(XDSExpr.indexForLocation(l))
			case .jumpFalse(_, let l):
				jumpLocations.addUnique(XDSExpr.indexForLocation(l))
			default:
				break
			}
			
		}
		
		// second pass to insert comments and locations
		let updatedStack = XGStack<XDSExpr>()
		var instructionIndex = 0
		for expr in stack.asArray {
			
			if let fname = functionLocations[instructionIndex] {
				let paramCount = getParameterCountForFunction(named: fname)
				var params = [XDSVariable]()
				for i in 0 ..< paramCount {
					params.append("arg_" + i.string)
				}
				
				let function = XDSExpr.function(fname, params)
				let comment  = XDSExpr.comment("".addRepeated(s: "-", count: function.text.count - kXDSCommentIndicator.count))
				updatedStack.push(comment)
				updatedStack.push(function)
				updatedStack.push(comment)
				
			}
			
			if jumpLocations.contains(instructionIndex) {
				updatedStack.push(XDSExpr.locationIndex(instructionIndex))
			}
			
			
			updatedStack.push(expr)
			if let comment = expr.comment {
				updatedStack.push(comment)
			}
			
			instructionIndex += expr.instructionCount
		}
		
		// third pass to print
		var script = ""
		instructionIndex = 0
		var indentation = 0
		let indentationStack = XGStack<Int>()
		let expressions = updatedStack.asArray
		
		for i in 0 ..< expressions.count {
			
			let expr = expressions[i]
			
			// before expression
			var newLines = 0
			switch expr {
			case .location:
				fallthrough
			case .locationIndex:
				newLines = 1
			case .function:
				newLines = 1
			case .XDSReturn:
				fallthrough
			case .XDSReturnResult(_):
				newLines = 1
			default:
				newLines = 0
			}
			for _ in 0 ..< newLines {
				script += "\n"
			}
			
			// decrement indentation
			if indentation > 0 {
				switch expr {
				case .locationIndex(let i):
					if i == indentationStack.peek() {
						indentationStack.pop()
						indentation -= 1
					}
				case .location(let l):
					if XDSExpr.locationWithIndex(indentationStack.peek()) == l {
						indentationStack.pop()
						indentation -= 1
					}
				default:
					break
				}
			}
			
			// print expression
			
			let text = expr.text
			let indent = text.count > 0 ? "".addRepeated(s: "    ", count: indentation) : ""
			
			script += indent + text
			
			// after expression
			newLines = 0
			switch expr {
			case .jumpFalse:
				fallthrough
			case .jumpTrue:
				newLines = 1
			case .jump:
				newLines = 2
			case .call:
				newLines = 2
			case .exit:
				newLines = 4
			case .function:
				newLines = 2
			case .XDSReturn:
				fallthrough
			case .XDSReturnResult(_):
				newLines = 4
			default:
				newLines = expr.text.count == 0 ? 0 : 1
			}
			for _ in 0 ..< newLines {
				script += "\n"
			}
			
			// increment indentation
			if i < expressions.count - 1 {
				switch expr {
				case .jumpTrue(_, let l):
					let target = XDSExpr.indexForLocation(l)
					if target <= instructionIndex { continue }
					var reached = false
					var shouldIndent = false
					for j in i + 1 ..< expressions.count {
						if reached { continue }
						
						let test = expressions[j]
						switch test {
						case .jumpTrue(_, let l):
							if XDSExpr.indexForLocation(l) >= target {
								shouldIndent = false
								reached = true
							}
						case .jumpFalse(_, let l):
							if XDSExpr.indexForLocation(l) >= target {
								shouldIndent = false
								reached = true
							}
						case .location(let l):
							if l == XDSExpr.locationWithIndex(target) && reached == false {
								reached = true
								shouldIndent = true
							}
						case .locationIndex(let i):
							if i == target && reached == false {
								reached = true
								shouldIndent = true
							}
						default:
							continue
						}
					}
					if shouldIndent {
						indentationStack.push(target)
						indentation += 1
					}
				case .jumpFalse(_, let l):
					let target = XDSExpr.indexForLocation(l)
					if target <= instructionIndex { continue }
					var reached = false
					var shouldIndent = false
					for j in i + 1 ..< expressions.count {
						if reached { continue }
						
						let test = expressions[j]
						switch test {
						case .jumpTrue(_, let l):
							if XDSExpr.indexForLocation(l) >= target {
								shouldIndent = false
								reached = true
							}
						case .jumpFalse(_, let l):
							if XDSExpr.indexForLocation(l) >= target {
								shouldIndent = false
								reached = true
							}
						case .location(let l):
							if l == XDSExpr.locationWithIndex(target) {
								reached = true
								shouldIndent = true
							}
						case .locationIndex(let i):
							if i == target {
								reached = true
								shouldIndent = true
							}
						default:
							continue
						}
					}
					if shouldIndent {
						indentationStack.push(target)
						indentation += 1
					}
				default:
					break
				}
				
			}
			
			instructionIndex += expr.instructionCount
		}
		
		
		return script
	}
	
}





















