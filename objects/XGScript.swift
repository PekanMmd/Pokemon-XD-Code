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
	
	var gvar = [XGScriptVar]()
	var strg = [String]()
	var vect = [VECT]()
	var giri = [GIRI]()
	var arry = [[XGScriptVar]]()
	
	
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
			self.gvar.append( XGScriptVar(type: data.get2BytesAtOffset(start), rawValue: data.get4BytesAtOffset(start + 4)) )
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
			
			var arr = [XGScriptVar]()
			for j in 0 ..< entries {
				let varStart = start + startPointer + (j * kScriptGVARSize)
				arr.append( XGScriptVar(type: data.get2BytesAtOffset(varStart), rawValue: data.get4BytesAtOffset(varStart + 4)) )
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
				switch instruction.scriptVar.type {
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
	
	func getInstructionStack() -> XGStack<XDSExpr> {
		let stack = XGStack<XDSExpr>()
		
		for instruction in self.code {
			
			switch instruction.opCode {
				
			case .setLine:
				stack.push(.setLine(instruction.parameter))
			case .jumpIfFalse:
				stack.push(.jumpFalse(stack.pop(), "Location\(instruction.parameter)"))
            case .jumpIfTrue:
                stack.push(.jumpTrue(stack.pop(), "Location\(instruction.parameter)"))
            case .jump:
                stack.push(.jump("Location\(instruction.parameter)"))
            case .call:
                stack.push(.call("Location\(instruction.parameter)", []))
            case .exit:
                stack.push(.exit)
            case .xd_operator:
                if (instruction.subOpCode > 25 && instruction.subOpCode < 32) {
                    let e = stack.pop()
                    switch e {
                    case loadVariable:
                        fallthrough
                    case nop:
                        fallthrough
                    case bracket:
                        fallthrough
                    case unaryOperator:
                        fallthrough
                    case loadImmediate:
                        fallthrough
                    case exit:
                        fallthrough
                    case XDSReturn:
                        stack.push(.unaryOperator(instruction.subOpCode, e))
                    default:
                        stack.push(.unaryOperator(instruction.subOpCode, .bracket(e)))
                    }
                    
                    stack.push(.unaryOperator(instruction.subOpCode, stack.pop()))
                } else if (instruction.subOpCode > 32 && instruction.subOpCode < 39 || instruction.subOpCode < 53 && instruction.subOpCode > 48) {
                    let e1 = stack.pop()
                    let e2 = stack.pop()
                    var r1 = XDSExpr.setLine(0)
                    var r2 = XDSExpr.setLine(0)
                    
                    switch e1 {
                    case loadVariable:
                        fallthrough
                    case nop:
                        fallthrough
                    case bracket:
                        fallthrough
                    case unaryOperator:
                        fallthrough
                    case loadImmediate:
                        fallthrough
                    case exit:
                        fallthrough
                    case XDSReturn:
                        r1 = e1;
                    default:
                        r1 = .bracket(e1)
                    }
                    
                    switch e2 {
                    case loadVariable:
                        fallthrough
                    case nop:
                        fallthrough
                    case bracket:
                        fallthrough
                    case unaryOperator:
                        fallthrough
                    case loadImmediate:
                        fallthrough
                    case exit:
                        fallthrough
                    case XDSReturn:
                        r2 = e2;
                    default:
                        r2 = .bracket(e2)
                    }
                    stack.push(instruction.subOpCode, .binaryOperator(r2, r1))
                } else {
                    printg("error! Unknown subOpCode!")
                }
            case .nop:
                break
            case .loadImmediate:
                stack.push(.loadImmediate(instruction.scriptVar))
            case .loadVariable:
                switch self.subOpCode {
                case 0:
                    stack.push(.loadVariable("GVAR[\(self.parameter)]"))
                case 1:
                    stack.push(.loadVariable("Stack[\(self.parameter)]"))
                case 2:
                    stack.push(.loadVariable("LastResult"))
                default:
                    if param < 0x80 && param > 0 {
                        stack.push(.loadVariable("" + XGScriptClassesInfo.classes(param).name.lowercased()))
                    } else if param == 0x80 {
                        stack.push(.loadVariable("#characters[player]"))
                    } else if param <= 0x120 {
                        stack.push(.loadVariable("characters[\(param - 0x80)]"))
                    } else if param < 0x300 && param >= 0x200 {
                        stack.push(.loadVariable("arrays[\(param - 0x200)]"))
                    } else {
                        stack.push(.loadVariable("invalid"))
                    }
                    
                }
            case .setVariable:
                switch self.subOpCode {
                case 0:
                    stack.push(.setVariable("GVAR[\(self.parameter)]"))
                case 1:
                    stack.push(.setVariable("Stack[\(self.parameter)]"))
                case 2:
                    stack.push(.setVariable("LastResult"))
                default:
                    if param < 0x80 && param > 0 {
                        stack.push(.setVariable("" + XGScriptClassesInfo.classes(param).name.lowercased()))
                    } else if param == 0x80 {
                        stack.push(.setVariable("#characters[player]"))
                    } else if param <= 0x120 {
                        stack.push(.setVariable("characters[\(param - 0x80)]"))
                    } else if param < 0x300 && param >= 0x200 {
                        stack.push(.setVariable("arrays[\(param - 0x200)]"))
                    } else {
                        stack.push(.setVariable("invalid"))
                    }
                    
                }
            case .setVector:
                <#code#>
            case .pop:
                <#code#>
            case .return_op:
                <#code#>
            case .callStandard:
                <#code#>
            case .reserve:
                <#code#>
            case .release:
                <#code#>
            case .loadNonCopyableVariable:
                <#code#>
            }
            
		}
		
		return stack
	}
	
	func getXDSScript() -> String {
		let stack = getInstructionStack()
		let script = ""
		
		for instruction in stack.asArray {
			
		}
		
		return script
	}
	
}





















