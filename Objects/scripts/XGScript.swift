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

let kScriptUnknownIDOffset = 0x28

let kScriptSectionSizeOffset = 0x4
let kScriptSectionEntriesOffset = 0x10


typealias FTBL = (codeOffset: Int, end: Int, name: String, index: Int)
typealias GIRI = (groupID: Int, resourceID: Int)
typealias VECT = (x: Float, y: Float, z: Float)

let currentXDSVersion : Float = 1.1

class XGScript: NSObject {
	
	var file : XGFiles!
	@objc var mapRel : XGMapRel?
	@objc var data : XGMutableData!
	
	@objc var FTBLStart = 0
	@objc var HEADStart = 0
	@objc var CODEStart = 0
	
	@objc var GVARStart = 0
	@objc var STRGStart = 0
	@objc var VECTStart = 0
	@objc var GIRIStart = 0 // group id resource id
	@objc var ARRYStart = 0
	
	var ftbl = [FTBL]()
	@objc var code = [XGScriptInstruction]()
	
	@objc var gvar = [XDSConstant]()
	@objc var strg = [String]()
	var vect = [VECT]()
	var giri = [GIRI]()
	@objc var arry = [[XDSConstant]]()
	
	var globalMacroTypes = [XDSVariable : XDSMacroTypes]()
	var localMacroTypes = [String : [XDSVariable : XDSMacroTypes]]()
	
	var scriptID : UInt32 = 0x0
	
	@objc var codeLength : Int {
		var count = 0
		
		for c in self.code {
			count += c.length
		}
		
		return count
	}
	
	convenience init(file: XGFiles) {
		self.init(data: file.data!)
	}
	
	@objc init(data: XGMutableData) {
		super.init()
		
		self.file = data.file
		self.data = data
		
		self.scriptID = data.getWordAtOffset(kScriptUnknownIDOffset)
		
		self.FTBLStart = kScriptSizeOfTCOD
		self.HEADStart = FTBLStart + Int(data.getWordAtOffset(FTBLStart + kScriptSectionSizeOffset))
		self.CODEStart = HEADStart + Int(data.getWordAtOffset(HEADStart + kScriptSectionSizeOffset))
		self.GVARStart = CODEStart + Int(data.getWordAtOffset(CODEStart + kScriptSectionSizeOffset))
		self.STRGStart = GVARStart + Int(data.getWordAtOffset(GVARStart + kScriptSectionSizeOffset))
		self.VECTStart = STRGStart + Int(data.getWordAtOffset(STRGStart + kScriptSectionSizeOffset))
		self.GIRIStart = VECTStart + Int(data.getWordAtOffset(VECTStart + kScriptSectionSizeOffset))
		self.ARRYStart = GIRIStart + Int(data.getWordAtOffset(GIRIStart + kScriptSectionSizeOffset))
		
		let numberFTBLEntries = Int(data.getWordAtOffset(FTBLStart + kScriptSectionEntriesOffset))
//		let numberHEADEntries = Int(data.getWordAtOffset(HEADStart + kScriptSectionEntriesOffset))
//		let numberCODEEntries = Int(data.getWordAtOffset(CODEStart + kScriptSectionEntriesOffset))
		let numberGVAREntries = Int(data.getWordAtOffset(GVARStart + kScriptSectionEntriesOffset))
		let numberSTRGEntries = Int(data.getWordAtOffset(STRGStart + kScriptSectionEntriesOffset))
		let numberVECTEntries = Int(data.getWordAtOffset(VECTStart + kScriptSectionEntriesOffset))
		let numberGIRIEntries = Int(data.getWordAtOffset(GIRIStart + kScriptSectionEntriesOffset))
		let numberARRYEntries = Int(data.getWordAtOffset(ARRYStart + kScriptSectionEntriesOffset))
		
		for i in 0 ..< numberFTBLEntries {
			let start = FTBLStart + kScriptSectionHeaderSize + (i * kScriptFTBLSize)
			let codeOffset = Int(data.getWordAtOffset(start))
			let nameOffset = Int(data.getWordAtOffset(start + 0x4))
			let name = getStringAtOffset(nameOffset + kScriptSizeOfTCOD)
			self.ftbl.append((codeOffset,0,name,i))
		}
		
		self.ftbl.sort { (f1, f2) -> Bool in
			return f1.codeOffset < f2.codeOffset
		}
		
		for i in 0 ..< numberGVAREntries {
			let start = GVARStart + kScriptSectionHeaderSize + (i * kScriptGVARSize)
			self.gvar.append( XDSConstant(type: data.get2BytesAtOffset(start + 2), rawValue: data.getWordAtOffset(start + 4)) )
		}
		
		var strgPos = STRGStart + kScriptSectionHeaderSize
		for _ in 0 ..< numberSTRGEntries {
			let str = getStringAtOffset(strgPos)
			self.strg.append(str)
			strgPos += str.length + 1
		}
		
		for i in 0 ..< numberVECTEntries {
			let start = VECTStart + kScriptSectionHeaderSize + (i * kScriptVECTSize)
			let x = data.getWordAtOffset(start).hexToSignedFloat()
			let y = data.getWordAtOffset(start + 4).hexToSignedFloat()
			let z = data.getWordAtOffset(start + 8).hexToSignedFloat()
			self.vect.append((x,y,z))
		}
		
		for i in 0 ..< numberGIRIEntries {
			let start = GIRIStart + kScriptSectionHeaderSize + (i * kScriptGIRISize)
			let groupID = Int(data.getWordAtOffset(start))
			let resourceID = Int(data.getWordAtOffset(start + 0x4))
			self.giri.append((groupID, resourceID))
		}
		
		for i in 0 ..< numberARRYEntries {
			
			let start = ARRYStart + kScriptSectionHeaderSize
			
			let startPointer = data.getWordAtOffset(start + (i * kScriptARRYPointerSize)).int
			let entries = data.getWordAtOffset(start + startPointer - 0x10).int
			
			var arr = [XDSConstant]()
			for j in 0 ..< entries {
				let varStart = start + startPointer + (j * kScriptGVARSize)
				arr.append( XDSConstant(type: data.get2BytesAtOffset(varStart), rawValue: data.getWordAtOffset(varStart + 4)) )
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
		
		var done = false
		var current = self.code.count - 1
		while !done {
			if current == 0 {
				done = true
			} else if self.code[current].opCode == .return_op {
				done = true
			} else {
				self.code[current].isUnusedPostpendedCall = true
			}
			current = current - 1
		}
		
		
		// end offsets for ftbl
		for i in 0 ..< (numberFTBLEntries - 1) {
			self.ftbl[i] = (self.ftbl[i].codeOffset, self.ftbl[i + 1].codeOffset, self.ftbl[i].name,self.ftbl[i].index)
		}
		self.ftbl[numberFTBLEntries - 1] = (self.ftbl[numberFTBLEntries - 1].codeOffset, self.codeLength, self.ftbl[numberFTBLEntries - 1].name,self.ftbl[numberFTBLEntries - 1].index)
		
	}
	
	
	@objc func getStringAtOffset(_ offset: Int) -> String {
		
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
		
		if self.file != .common_rel {
			// check for rel file in same folder
			if self.mapRel == nil {
				let relFile = XGFiles.nameAndFolder(self.file.fileName.removeFileExtensions() + XGFileTypes.rel.fileExtension, self.file.folder)
				if relFile.exists {
					let rel = XGMapRel(file: relFile, checkScript: false)
					if rel.isValid {
						mapRel = rel
					}
				}
			}
			
			// if still not found, check for rel file in rels folder
			if self.mapRel == nil {
				let relFile = XGFiles.rel(self.file.fileName.removeFileExtensions())
				if relFile.exists {
					let rel = XGMapRel(file: relFile, checkScript: false)
					if rel.isValid {
						mapRel = rel
					}
				}
			}
		}
		
		// file name
		var desc = linebreak + self.file.fileName + "\n"
		desc += linebreak
		
		
		// list function names
		desc += "\nFunctions: \(ftbl.count)\n"
		desc += linebreak
		
		for i in 0 ..< self.ftbl.count {
			let (o, _, name,index) = self.ftbl[i]
			desc += "\(index): " + name.spaceToLength(20) + "offset: " + o.hexString() + "\n"
		}
		
		// list script code instructions
		desc += "\nCode\n"
		desc += linebreak
		
		var index = 0
		for i in 0 ..< self.code.count {
			
			// if this instruction is the start of a function, add the function's name
			for (offset, _, name, _) in self.ftbl {
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
				for (index, _, name, _) in self.ftbl {
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
							if let rel = mapRel {
								let char = rel.characters[charIndex]
								desc += " " + char.model.name + " " + char.name + "\n"
							}
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
							
							let fsys = XGFiles.fsys(self.file.fileName.removeFileExtensions())
							if fsys.exists {
								archive = fsys.fsysData
								mindex = archive.indexForIdentifier(identifier: mid)
							}
							
							if mindex < 0 {
								archive = XGFiles.fsys("people_archive").fsysData
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
									desc += ">>\n" + XGBattle(index: bid).description + "\n"
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
							desc += ">>\n" + XGBattle(index: bid).description + "\n"
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
							desc += ">>\n" + XGBattle(index: bid).description + "\n"
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
			if let rel = self.mapRel {
				if currentGiri.groupID != 0 && currentGiri.resourceID < rel.characters.count {
					let char = rel.characters[currentGiri.resourceID]
					desc += " " + char.model.name + " " + char.name + " <\(char.xCoordinate), \(char.yCoordinate), \(char.zCoordinate)>" + "\n"
				} else if currentGiri.groupID == 0 && currentGiri.resourceID == 100 {
					desc += " Player\n"
				} else {
					desc += "\n"
				}
			}
		}
		
		return desc
	}
	
	@objc private func scriptFunctionSetsLastResult(name: String) -> Bool {
		for i in 0 ..< ftbl.count {
			let f = ftbl[i]
			if f.name == name {
				var currentIndex = f.codeOffset
				let lastIndex = f.end
				
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
					case .setVariable:
						if currentInstruction.XDSVariable == kXDSLastResultVariable {
							return true
						}
						currentIndex += currentInstruction.length
					default:
						currentIndex += currentInstruction.length
					}
				}
				return false
			}
		}
		printg("couldn't get function parameter count: function \"\(name)\" doesn't exist")
		return false
	}
	
	@objc private func getLastInstructionIndexforFunction(named name: String) -> Int {
		for i in 0 ..< ftbl.count {
			let f = ftbl[i]
			if f.name == name {
				return f.end
			}
		}
		return -1
	}
	
	@objc private func getParameterCountForFunction(named name: String) -> Int {
		for i in 0 ..< ftbl.count {
			let f = ftbl[i]
			
			if f.name == name {
				var params = [Int]()
				var currentIndex = f.codeOffset
				let lastIndex = f.end
				
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
						if currentInstruction.level == 1 && currentInstruction.parameter > 0 && currentInstruction.parameter < 200 {
							params.addUnique(currentInstruction.parameter)
						}
						currentIndex += currentInstruction.length
					default:
						currentIndex += currentInstruction.length
					}
				}
				return params.count
			}
		}
		printg("couldn't get function parameter count: function \"\(name)\" doesn't exist")
		return 0
	}
	
	@objc private func getFunctionAtLocation(location: Int) -> String {
		for f in ftbl {
			if f.codeOffset == location {
				return f.name
			}
		}
		return ""
	}
	
	private func getInstructionStack() -> (expressions: XGStack<XDSExpr>, macros: [XDSExpr]) {
		let stack = XGStack<XDSExpr>()
		
		globalMacroTypes = [:]
		localMacroTypes = [:]
		
		var functionParams = [String : Int]()
		for f in ftbl {
			functionParams[f.name] = getParameterCountForFunction(named: f.name)
			localMacroTypes["@" + f.name] = [XDSVariable : XDSMacroTypes]()
		}
		
		var currentInstructionIndex = 0
		var currentFunctionIndex = -1
		func currentFunctionName() -> String? {
			if currentFunctionIndex >= 0 && currentFunctionIndex < ftbl.count {
				return "@" + ftbl[currentFunctionIndex].name
			}
			return nil
		}
		
		for i in 0 ..< self.code.count {
			
			let instruction = self.code[i]
			
			for j in 0 ..< ftbl.count {
				if ftbl[j].codeOffset == currentInstructionIndex {
					currentFunctionIndex = j
				}
			}
			currentInstructionIndex += instruction.length
			
			
			switch instruction.opCode {
				
			case .setLine:
				stack.push(.setLine(instruction.parameter))
				
				
			case .jumpIfFalse:
				let predicate = stack.pop()
				if predicate.isReturn {
					stack.push(.nop)
				} else {
					let location = XDSExpr.locationWithIndex(instruction.parameter)
					stack.push(.jumpFalse(predicate, location))
				}
				
				
            case .jumpIfTrue:
				let predicate = stack.pop()
				if predicate.isReturn {
					stack.push(.nop)
				} else {
					let location = XDSExpr.locationWithIndex(instruction.parameter)
					stack.push(.jumpTrue(predicate, location))
				}
				
				
            case .jump:
                stack.push(.jump(XDSExpr.locationWithIndex(instruction.parameter)))
				
				
            case .call:
				if !instruction.isUnusedPostpendedCall {
					let fname = getFunctionAtLocation(location: instruction.parameter)
					
					var paramCount = 0
					if i <= self.code.count - 1 {
						let next = self.code[i + 1]
						if next.opCode == .pop {
							paramCount = next.subOpCode
						}
					}
					
					var params = [XDSExpr]()
					var broken = false // ignore malformed instructions caused by returning mid function.
					for _ in 0 ..< paramCount {
						if !broken {
							if stack.peek().isReturn {
								stack.push(.nop)
								broken = true
							} else {
								params.append(stack.pop().bracketed)
							}
						}
					}
					
					// used to preserve instruction count for locations etc.
					if broken {
						for p in params {
							for _ in 0 ..< p.instructionCount {
								stack.push(.nop)
							}
						}
					} else {
						stack.push(.callVoid(XDSExpr.locationWithName(fname), params))
						
						if scriptFunctionSetsLastResult(name: fname) {
							var found = false
							for j in instruction.parameter ..< getLastInstructionIndexforFunction(named: fname) {
								if found {
									continue
								}
								if j < self.code.count {
									if self.code[j].XDSVariable == kXDSLastResultVariable {
										self.code[j].isScriptFunctionLastResult = true
										found = true
									}
								} else {
									found = true
								}
							}
						}
					}
				} else {
					stack.push(.nop)
				}
				
				
            case .exit:
                stack.push(.exit)
				
				
            case .xd_operator:
                if instruction.subOpCode >= 16 && instruction.subOpCode <= 25 {
					if stack.peek().isReturn {
						stack.push(.nop)
					} else {
						stack.push(.unaryOperator(instruction.subOpCode, stack.pop()))
					}
				} else if (instruction.subOpCode >= 32 && instruction.subOpCode <= 39) || (instruction.subOpCode <= 53 && instruction.subOpCode >= 48) {
					// operator parameters are the opposite ordering of function parameters
					// e.g. e1 % e2 has e1 on the stack first and then e2
					var e1 = XDSExpr.nop
					var e2 = XDSExpr.nop
					if !stack.peek().isReturn {
						e2 = stack.pop()
					}
					if !stack.peek().isReturn {
						e1 = stack.pop()
					}
					
					if e2.isNop {
						stack.push(.nop)
					} else if e1.isNop {
						stack.push(.nop)
						for _ in 0 ..< e2.instructionCount {
							stack.push(.nop)
						}
						stack.push(.nop)
					} else {
						
						var op = instruction.subOpCode
						
						// swap variable ordering if immediate followed by longer expression
						if e1.isImmediate && !e2.isImmediate {
							// swap expression order if possible
							if [37,48,49,50,51,52,53,32,33,35].contains(op) {
								let temp = e1
								e1 = e2
								e2 = temp
								// swap operation direction if operation isn't symmetric
								switch op {
								case 49:
									op = 51
								case 51:
									op = 49
								case 50:
									op = 52
								case 52:
									op = 50
								default:
									break
								}
							}
						}
						
						// replace return type macros if possible
						if e1.isCallstdWithReturnValue && e2.isLoadImmediate {
							
							switch e1 {
							case .callStandard(let c, let f, let es):
								
								let sclass = XGScriptClass.classes(c)
								if sclass.name == "Character" {
									if sclass[f].name == "talk" {
										if es[1].isImmediate {
											if es[1].constants[0].asInt == XDSTalkTypes.promptYesNoBool.rawValue {
												e2 = .macroImmediate(e2.constants[0], .bool)
											} else if es[1].constants[0].asInt == XDSTalkTypes.promptYesNoIndex.rawValue {
												e2 = .macroImmediate(e2.constants[0], .yesNoIndex)
											}
										}
									}
								}
								
							default:
								break // should never reach default case in theory
							}
							
						}
						
						stack.push(.binaryOperator(op, e1.bracketed, e2.bracketed))
					}
                } else {
					printg("error! Unknown operator: \(instruction.subOpCode)")
                }
				
				
            case .nop:
				// must add nops to preserve instruction count
                stack.push(.nop)
				
            case .loadImmediate:
                stack.push(.loadImmediate(instruction.constant))
				
			case .loadNonCopyableVariable:
				stack.push(.loadPointer(instruction.XDSVariable))
				
            case .loadVariable:
				if instruction.XDSVariable != kXDSLastResultVariable { // TODO: evaluate success
					stack.push(.loadVariable(instruction.XDSVariable))
				} else {
					if stack.peek().isReturn && !instruction.isScriptFunctionLastResult {
						stack.push(.nop)
					} else {
						let previous = stack.pop()
						switch previous {
						case .callStandardVoid(let c, let f, let es):
							if !instruction.isScriptFunctionLastResult {
								stack.push(.callStandard(c, f, es))
							} else {
								stack.push(previous)
								stack.push(.loadVariable(instruction.XDSVariable))
							}
						case .callVoid(let l, let es):
							stack.push(.call(l, es))
						default:
							stack.push(previous)
							stack.push(.loadVariable(instruction.XDSVariable))
						}
					}
				}
				
				
            case .setVariable:
				if stack.peek().isReturn {
					stack.push(.nop)
				} else {
					let variable = instruction.XDSVariable
					let value = stack.pop()
					stack.push(.setVariable(variable, value))
				}
				
            case .setVector:
				if stack.peek().isReturn {
					stack.push(.nop)
				} else {
					stack.push(.setVector(instruction.XDSVariable, instruction.vectorDimension, stack.pop().bracketed))
				}
				
            case .pop:
				// automatically included in callstd and call
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
				if i <= self.code.count - 1 {
					let next = self.code[i + 1]
					if next.opCode == .pop {
						paramCount = next.subOpCode
					}
				}
				
				var params = [XDSExpr]()
				
				var c = instruction.subOpCode
				var f = instruction.parameter
				
				// convert standard.getarrayelement to array.get
				// as far as I can tell these are equivalent
				// using just one prevents having to write double the code
				// to account for both case
				if c == XGScriptClass.getClassNamed("Standard")!.index {
					if f == XGScriptClass.getClassNamed("Standard")!.functionWithName("getArrayElement")!.index {
						c = XGScriptClass.getClassNamed("Array")!.index
						f = XGScriptClass.getClassNamed("Array")!.functionWithName("get")!.index
					}
				}
				
				// get macro types if they have been documented
				if let returnMacro = XGScriptClass.classes(c)[f].returnMacro {
					if returnMacro != .array(.anyType) {
						globalMacroTypes[XGScriptClass.classes(c).classDotFunction(f)] = returnMacro
					}
					
				}
				
				var broken = false
				for _ in 0 ..< paramCount {
					if broken {
						continue
					}
					if stack.peek().isReturn {
						broken = true
						continue
					}
					let param = stack.pop()
					params.append(param.bracketed)
				}
				
				if broken {
					stack.push(.nop)
					for p in params {
						for _ in 0 ..< p.instructionCount {
							stack.push(.nop)
						}
					}
				} else {
					stack.push(.callStandardVoid(c, f, params))
				}
				
				
            case .reserve:
                stack.push(.reserve(instruction.parameter))
				
				
            case .release:
                continue // automatically included in return
			
				
			}
			
		}
		
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
		// function headers should replace reserve statements
		// so assume can take out reserves
		var updatedStack = XGStack<XDSExpr>()
		var macros = [XDSExpr]()
		var locationsDictionary = [XDSLocation : Int]()
		
		var instructionIndex = 0
		for expr in stack.asArray {
			
			macros += expr.macros
			
			if let fname = functionLocations[instructionIndex] {
				let paramCount = getParameterCountForFunction(named: fname)
				var params = [XDSVariable]()
				for i in 0 ..< paramCount {
					params.append("arg_" + i.string)
				}
				
				let function = XDSExpr.functionDefinition(XDSExpr.locationWithName(fname), params)
				updatedStack.push(function)
				locationsDictionary[XDSExpr.locationWithName(fname)] = instructionIndex
				
			}
			
			if jumpLocations.contains(instructionIndex) {
				updatedStack.push(XDSExpr.location(XDSExpr.locationWithIndex(instructionIndex)))
				locationsDictionary[XDSExpr.locationWithIndex(instructionIndex)] = instructionIndex
			}
			
			// skips reserves as they should now be replaced by function headers
			switch expr {
			case .reserve(_): instructionIndex += 1; continue
			default: break
			}
			
			updatedStack.push(expr)
			
			if let comment = expr.comment {
				updatedStack.push(comment)
			}
			
			instructionIndex += expr.instructionCount
		}
		
		var currentFuncName = ""
		
		func macTypeForVar(v: XDSVariable) -> XDSMacroTypes? {
			var macroType : XDSMacroTypes?
			macroType = globalMacroTypes[v]
			if macroType == nil {
				macroType = localMacroTypes[currentFuncName]![v]
			}
			if let t = macroType {
				if !t.printsAsMacro {
					macroType = nil
				}
			}
			return macroType
		}
		
		func setMacTypeForVar(v: XDSVariable, to: XDSMacroTypes) -> Bool {
			// returns true if the type was not previously known
			// if so the expr should be considered updated
			// to show new information was made available
			
			var to = to
			switch to {
			case .array(let t):
				to = t
			default:
				break
			}
			
			if !to.printsAsMacro {
				return false
			}
			
			if v.first == "@" || v.contains(".") {
				let result = globalMacroTypes[v] == nil
				// if type was already known check for consistency
				if !result {
					if globalMacroTypes[v]! != to && globalMacroTypes[v]!.printsAsMacro {
						printg("Warning: function '\(v)' has conflicting macro types \(globalMacroTypes[v]!.index) \(to.index).")
					}
				} else {
					globalMacroTypes[v] = to
				}
				return result
			} else if v.contains("gvar") || v.contains("array") {
				let result = globalMacroTypes[v] == nil
				// if type was already known check for consistency
				if !result {
					if globalMacroTypes[v]! != to && globalMacroTypes[v]!.printsAsMacro {
						printg("Warning: global var '\(v)' has conflicting macro types \(globalMacroTypes[v]!.index) \(to.index).")
					} else if !globalMacroTypes[v]!.printsAsMacro {
						globalMacroTypes[v] = to
						return true
					}
				} else {
					globalMacroTypes[v] = to
				}
				return result
			} else if v.contains("var") || v.contains("arg") {
				let result = localMacroTypes[currentFuncName]![v] == nil
				if !result {
					if localMacroTypes[currentFuncName]![v]! != to {
						printg("Warning: function \(currentFuncName) - local var '\(v)' has conflicting macro types. \(localMacroTypes[currentFuncName]![v]!.index) \(to.index)")
					}
				} else {
					localMacroTypes[currentFuncName]![v] = to
				}
				return result
			}
			return false
		}
		
		func updateMacrosList(_ exprs: [XDSExpr]) -> ([XDSExpr], Bool, Bool) {
			var newInfo = false
			var updatePossible = false
			let newEs = exprs.map({ (e) -> XDSExpr in
				let (newE, new, poss) = updateMacros(e)
				newInfo = newInfo || new
				updatePossible = updatePossible || poss
				return newE
			})
			return (newEs, newInfo, updatePossible)
		}
		
		func updateMacros(_ expr: XDSExpr) -> (expr: XDSExpr, newInfo: Bool, updatePossible: Bool) {
			// add macros for global and local vars if macro type can be inferred
			// call repeatedly until no more inferrences can be made
			// returns the updated expression and a boolean for whether
			// or not an update was made. if an update was made the stack should be traversed again
			// until no instructions are updated.
			// so it won't be too slow it keeps track of which instructions can't
			// be updated further so they can be skipped when iterating
			switch expr {
			case .callStandardVoid(7, 17, let es):
				
				var p1 = es[0]
				var p2 = es[2]
				let m1 = p1.macroVariable
				let m2 = p2.macroVariable
				var newInfo = false
				var possible = true
				
				if m1 == nil && m2 == nil {
					newInfo = false
					possible = false
				} else if m2 == nil {
					if p2.isLoadImmediate {
						if let type = macTypeForVar(v: m1!) {
							let c = p2.constants[0]
							if type.printsAsMacro {
								p2 = .macroImmediate(c, type)
								possible = false
							}
							if type.needsDefine {
								let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
								macros.append(.macro(name, c.rawValueString))
							}
							
						}
						
					} else {
						possible = false
					}
					
				} else if m1 == nil {
					if p1.isLoadImmediate {
						if let type = macTypeForVar(v: m2!) {
							let c = p1.constants[0]
							if type.printsAsMacro {
								p1 = .macroImmediate(c, type)
							}
							if type.needsDefine {
								let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
								macros.append(.macro(name, c.rawValueString))
							}
						}
					} else {
						possible = false
					}
					
				} else {
					if let type1 = macTypeForVar(v: m1!) {
						newInfo = newInfo || setMacTypeForVar(v: m2!, to: type1)
						possible = false
					}
					if let type2 = macTypeForVar(v: m2!) {
						newInfo = newInfo || setMacTypeForVar(v: m1!, to: type2)
						possible = false
					}
				}
				
				let (us, n, p) = updateMacrosList([p1, es[1], p2])
				return (.callStandardVoid(7, 17, us), newInfo || n, possible || p)
				
			case .setVariable(let v, let e):
				
				var p2 = e
				let m1 = v
				let m2 = p2.macroVariable
				var newInfo = false
				var possible = true
				
				if m2 == nil {
					
					if p2.isLoadImmediate {
						if let type = macTypeForVar(v: v) {
							let c = p2.constants[0]
							if type.printsAsMacro {
								p2 = .macroImmediate(c, type)
							}
							if type.needsDefine {
								let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
								macros.append(.macro(name, c.rawValueString))
							}
						}
					} else {
						possible = false
					}
					
				}  else {
					if let type1 = macTypeForVar(v: m1) {
						newInfo = newInfo || setMacTypeForVar(v: m2!, to: type1)
						possible = false
					}
					if let type2 = macTypeForVar(v: m2!) {
						newInfo = newInfo || setMacTypeForVar(v: m1, to: type2)
						possible = false
					}
				}
				
				let (u, n, p) = updateMacros(p2)
				return (.setVariable(v, u), newInfo || n, possible || p)
				
			case .binaryOperator(let op, let e1, let e2):
				var p1 = e1
				var p2 = e2
				let m1 = p1.macroVariable
				let m2 = p2.macroVariable
				var newInfo = false
				var possible = true
				
				if m1 == nil && m2 == nil {
					newInfo = false
					possible = false
				} else if m2 == nil {
					if p2.isLoadImmediate {
						if let type = macTypeForVar(v: m1!) {
							let c = p2.constants[0]
							// only print as macro type for certain operator types
							// prevents lines like #SHADOW_TEDDIURSA + #SHADOW_TEDDIURSA
							// when incrementing shadow pokemon loop variables
							if op == 48 || op == 53 || ((op >= 32) && (op <= 34)) {
								if type.printsAsMacro {
									p2 = .macroImmediate(c, type)
								}
								if type.needsDefine {
									let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
									macros.append(.macro(name, c.rawValueString))
								}
							}
							possible = false
						}
					} else {
						possible = false
					}
					
				} else if m1 == nil {
					if p1.isLoadImmediate {
						if let type = macTypeForVar(v: m2!) {
							let c = p1.constants[0]
							// only print as macro type for certain operator types
							// prevents lines like #SHADOW_TEDDIURSA + #SHADOW_TEDDIURSA
							// when incrementing shadow pokemon loop variables
							if op == 48 || op == 53 || ((op >= 32) && (op <= 34)) {
								if type.printsAsMacro {
									p1 = .macroImmediate(c, type)
								}
								if type.needsDefine {
									let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
									macros.append(.macro(name, c.rawValueString))
								}
							}
							possible = false
						}
					} else {
						possible = false
					}
					
				} else {
					if let type1 = macTypeForVar(v: m1!) {
						newInfo = newInfo || setMacTypeForVar(v: m2!, to: type1)
						possible = false
					}
					if let type2 = macTypeForVar(v: m2!) {
						newInfo = newInfo || setMacTypeForVar(v: m1!, to: type2)
						possible = false
					}
				}
				
				let (us, n, p) = updateMacrosList([p1, p2])
				return (.binaryOperator(op, us[0], us[1]), newInfo || n, possible || p)
				
			case .unaryOperator(let op, let e):
				let (uParam, n, p) = updateMacros(e)
				return (.unaryOperator(op, uParam), n, p)
				
			case .bracket(let e):
				let (uParam, n, p) = updateMacros(e)
				return (.bracket(uParam), n, p)
				
			case .call(let loc, let es):
				
				var params = es
				var newInfo = false
				var possible = false
				
				for j in 0 ..< es.count {
					let p1 = es[j]
					let m1 = p1.macroVariable
					let m2 = "arg_\(j)"
					
					if m1 == nil {
						if p1.isLoadImmediate {
							if let type = localMacroTypes[loc]![m2] {
								let c = p1.constants[0]
								if type.printsAsMacro {
									params[j] = .macroImmediate(c, type)
								}
								if type.needsDefine {
									let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
									macros.append(.macro(name, c.rawValueString))
								}
							} else {
								possible = true
							}
						}
						
					} else {
						var set = false
						if let type1 = macTypeForVar(v: m1!) {
							newInfo = newInfo || localMacroTypes[loc]![m2] == nil
							localMacroTypes[loc]![m2] = type1
							set = true
						}
						if let type2 = localMacroTypes[loc]![m2] {
							newInfo = newInfo || setMacTypeForVar(v: m1!, to: type2)
							set = true
						}
						possible = possible || !set
					}
				}
				
				let (uParams, n, p) = updateMacrosList(params)
				return (.call(loc, uParams), newInfo ||  n, possible || p)
			case .callVoid(let loc, let es):
				
				var params = es
				var newInfo = false
				var possible = false
				
				for j in 0 ..< es.count {
					let p1 = es[j]
					let m1 = p1.macroVariable
					let m2 = "arg_\(j)"
					
					if m1 == nil {
						if p1.isLoadImmediate {
							if let type = localMacroTypes[loc]![m2] {
								let c = p1.constants[0]
								if type.printsAsMacro {
									params[j] = .macroImmediate(c, type)
								}
								if type.needsDefine {
									let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
									macros.append(.macro(name, c.rawValueString))
								}
							} else {
								possible = true
							}
						}
						
					} else {
						var set = false
						if let type1 = macTypeForVar(v: m1!) {
							newInfo = newInfo || localMacroTypes[loc]![m2] == nil
							localMacroTypes[loc]![m2] = type1
							set = true
						}
						if let type2 = localMacroTypes[loc]![m2] {
							newInfo = newInfo || setMacTypeForVar(v: m1!, to: type2)
							set = true
						}
						possible = possible || !set
					}
				}
				
				let (uParams, n, p) = updateMacrosList(params)
				return (.callVoid(loc, uParams), newInfo ||  n, possible || p)
				
			case .callStandard(let c, let f, let es):
				var params = es
				var newInfo = false
				
				if let macs = XGScriptClass.classes(c)[f].macros {
					var macroTypes = macs
					while macroTypes.count < es.count {
						macroTypes.append(nil)
					}
					
					// add special/variable macros
					let sclass = XGScriptClass.classes(c)
					if sclass.name == "Character" {
						if sclass[f].name == "talk" {
							if es[1].isImmediate {
								if let talkType = XDSTalkTypes(rawValue: es[1].constants[0].asInt) {
									
									switch talkType {
									case .silentItem:
										macroTypes[3] = talkType.extraMacro
										macroTypes[4] = talkType.extraMacro2
									case .battle1:
										macroTypes[3] = talkType.extraMacro
									case .battle2:
										macroTypes[3] = talkType.extraMacro
									case .speciesCry:
										macroTypes[2] = talkType.extraMacro
										macroTypes[3] = talkType.extraMacro2
									default:
										break
									}
								}
								
							}
						}
					}
					
					if sclass.name == "Dialogue" {
						if sclass[f].name == "setMessageVariable" {
							if es[1].isImmediate {
								if let varType = XDSMSGVarTypes.macroForVarType(es[1].constants[0].asInt) {
									macroTypes[2] = varType
								}
							}
						}
					}
					
					for j in 0 ..< es.count {
						let p1 = es[j]
						let m1 = p1.macroVariable
						let m2 = macroTypes[j]
						
						
						if m2 == nil {
							// do nothing
						} else if m1 == nil {
							if p1.isLoadImmediate {
								if let type = m2 {
									let c = p1.constants[0]
									if type.printsAsMacro {
										params[j] = .macroImmediate(c, type)
									}
									if type.needsDefine {
										let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
										macros.append(.macro(name, c.rawValueString))
									}
								}
							}
							
						} else {
							if let type = m2 {
								newInfo = newInfo || setMacTypeForVar(v: m1!, to: type)
							}
						}
					}
				}
				
				
				let (uParams, n, p) = updateMacrosList(params)
				return (.callStandard(c, f, uParams), newInfo || n, p)
			case .callStandardVoid(let c, let f, let es):
				var params = es
				var newInfo = false
				
				if let macs = XGScriptClass.classes(c)[f].macros {
					var macroTypes =  macs
					while macroTypes.count < es.count {
						macroTypes.append(nil)
					}
					
					// add special/variable macros
					let sclass = XGScriptClass.classes(c)
					if sclass.name == "Character" {
						if sclass[f].name == "talk" {
							if es[1].isImmediate {
								if let talkType = XDSTalkTypes(rawValue: es[1].constants[0].asInt) {
									
									switch talkType {
									case .silentItem:
										macroTypes[3] = talkType.extraMacro
										macroTypes[4] = talkType.extraMacro2
									case .battle1:
										macroTypes[3] = talkType.extraMacro
									case .battle2:
										macroTypes[3] = talkType.extraMacro
									case .speciesCry:
										macroTypes[2] = talkType.extraMacro
										macroTypes[3] = talkType.extraMacro2
									default:
										break
									}
								}
								
							}
						}
					}
					
					if sclass.name == "Dialogue" {
						if sclass[f].name == "setMessageVariable" {
							if es[1].isImmediate {
								if let varType = XDSMSGVarTypes.macroForVarType(es[1].constants[0].asInt) {
									macroTypes[2] = varType
								}
							}
						}
					}
					
					for j in 0 ..< es.count {
						let p1 = es[j]
						let m1 = p1.macroVariable
						let m2 = macroTypes[j]
						
						if m2 == nil {
							// do nothing
						} else if m1 == nil {
							if p1.isLoadImmediate {
								if let type = m2 {
									let c = p1.constants[0]
									if type.printsAsMacro {
										params[j] = .macroImmediate(c, type)
									}
									if type.needsDefine {
										let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
										macros.append(.macro(name, c.rawValueString))
									}
								}
							}
							
						} else {
							if let type = m2 {
								newInfo = newInfo || setMacTypeForVar(v: m1!, to: type)
							}
						}
					}
				}
				
				let (uParams, n, p) = updateMacrosList(params)
				return (.callStandardVoid(c, f, uParams), newInfo || n, p)
				
			case .jumpFalse(let e, let l):
				let (uParam, n, p) = updateMacros(e)
				return (.jumpFalse(uParam, l), n, p)
			case .jumpTrue(let e, let l):
				let (uParam, n, p) = updateMacros(e)
				return (.jumpTrue(uParam, l), n, p)
				
			case .setVector(let v, let d, let e):
				let (uParam, n, p) = updateMacros(e)
				return (.setVector(v, d, uParam), n, p)
				
			case .XDSReturnResult(let e):
				
				var p1 = e
				let m1 = p1.macroVariable
				let m2 = currentFuncName
				var newInfo = false
				var possible = true
				
				if m1 == nil {
					if p1.isLoadImmediate {
						if let type = macTypeForVar(v: m2) {
							
							let c = p1.constants[0]
							if type.printsAsMacro {
								p1 = .macroImmediate(c, type)
							}
							if type.needsDefine {
								let name = XDSExpr.stringFromMacroImmediate(c: c, t: type)
								macros.append(.macro(name, c.rawValueString))
							}
						}
					} else {
						possible = false
					}
				} else {
					if let type1 = macTypeForVar(v: m1!) {
						newInfo = newInfo || setMacTypeForVar(v: m2, to: type1)
						possible = false
					}
					if let type2 = macTypeForVar(v: m2) {
						newInfo = newInfo || setMacTypeForVar(v: m1!, to: type2)
						possible = false
					}
				}
				
				let (u, n, p) = updateMacros(p1)
				return (.XDSReturnResult(u), newInfo || n, possible || p)
				
			default:
				return (expr, false, false)
			}
		}
		
		
		// iterate over expressions until no more type macros can be inferred
		var newInfo = true
		// stop checking expressions that can't possibly change further
		var noUpdate = [Int]()
		
		while newInfo {
			let newStack = XGStack<XDSExpr>()
			newInfo = false
			instructionIndex = 0
			
			for expr in updatedStack.asArray {
				
				switch expr {
				case .functionDefinition(let loc, _):
					currentFuncName = loc
					newStack.push(expr)
				case .location:
					fallthrough
				case .locationIndex:
					fallthrough
				case .locationSilent:
					fallthrough
				case .comment:
					newStack.push(expr)
				default:
					if noUpdate.contains(instructionIndex) {
						newStack.push(expr)
					} else {
						let (u, n, p) = updateMacros(expr)
						newStack.push(u)
						newInfo = newInfo || n
						if !p {
							noUpdate.append(instructionIndex)
						}
					}
					
				}
				instructionIndex += expr.instructionCount
			}
			updatedStack = newStack
		}
		
		// TODO: if else statements, while loops
		// recursively compound statements into if, while or functions
		
		func compoundList(exprs: [XDSExpr]) -> [XDSExpr] {
			
			var exprs = exprs
			var list = [XDSExpr]()
			var index = 0
			var previousLocation = ""
			
			while index < exprs.count {
				let expr = exprs[index]
				switch expr {
				case .functionDefinition(let location, _):
					previousLocation = location
					var subs = [XDSExpr.locationSilent(location)]
					index += 1
					
					var notDone = true
					while (index < exprs.count) && notDone {
						switch exprs[index] {
						case .functionDefinition:
							notDone = false
							break
						case .location(let loc):
							previousLocation = loc
							subs.append(exprs[index])
							index += 1
						case .locationSilent(let loc):
							previousLocation = loc
							subs.append(exprs[index])
							index += 1
						default:
							subs.append(exprs[index])
							index += 1
						}
					}
					
					list.append(.function(expr, compoundList(exprs: [XDSExpr.location(location)] + subs)))
					
				case .location(let location):
					previousLocation = location
					index += 1
					list.append(expr)
				case .locationSilent(let location):
					previousLocation = location
					index += 1
					list.append(expr)
					
				case .jumpTrue(let condition, let location):
					// don't increase index so expr can be processed again as a jumpFalse
					switch condition {
					// swap binary operator direction if possible
						
					// == <-> !=
					case .binaryOperator(48, let e1, let e2):
						exprs[index] = .jumpFalse(.binaryOperator(53, e1, e2), location)
					case .binaryOperator(53, let e1, let e2):
						exprs[index] = .jumpFalse(.binaryOperator(48, e1, e2), location)
						
					// < <-> >=
					case .binaryOperator(51, let e1, let e2):
						exprs[index] = .jumpFalse(.binaryOperator(50, e1, e2), location)
					case .binaryOperator(50, let e1, let e2):
						exprs[index] = .jumpFalse(.binaryOperator(51, e1, e2), location)
						
					// > <-> <=
					case .binaryOperator(49, let e1, let e2):
						exprs[index] = .jumpFalse(.binaryOperator(52, e1, e2), location)
					case .binaryOperator(52, let e1, let e2):
						exprs[index] = .jumpFalse(.binaryOperator(49, e1, e2), location)
						
					default:
						// otherwise negate the condition with the not operator
						exprs[index] = .jumpFalse(.unaryOperator(16, condition), location)
					}
					
					
				case .jumpFalse(let condition, let location):
					// same for jump true
					// jump trues are converted to jump false by this point so code needn't be duplicated
					var ifSubs = [XDSExpr]()
					index += 1
					
					if let currentIndex = locationsDictionary[previousLocation] {
						if let newIndex = locationsDictionary[location] {
							if newIndex > currentIndex {
								
								var notDone = true
								let endLocation = location
								while (index < exprs.count) && notDone {
									
									switch exprs[index] {
										
									case .location(let loc):
										// if end location, end block
										// add compound statement to list
										// set done
										
										if loc == endLocation {
											// don't increase index so location information remains for next section
											notDone = false
											
											let ifSubscomp = compoundList(exprs: [.locationSilent(previousLocation)] + ifSubs + [.locationSilent(loc)])
											let jumpCondition = XDSExpr.jumpFalse(condition, location)
											let ifstatement = XDSExpr.ifStatement([(jumpCondition, ifSubscomp)])
											list.append(ifstatement)
											
										} else {
											ifSubs.append(exprs[index])
											index += 1
										}
									case .locationSilent(let loc):
										// if end location, end block
										// add compound statement to list
										// set done
										
										if loc == endLocation {
											// don't increase index so location information remains for next section
											notDone = false
											
											let ifSubscomp = compoundList(exprs: [.locationSilent(previousLocation)] + ifSubs + [.locationSilent(loc)])
											let jumpCondition = XDSExpr.jumpFalse(condition, location)
											let ifstatement = XDSExpr.ifStatement([(jumpCondition, ifSubscomp)])
											list.append(ifstatement)
											
										} else {
											ifSubs.append(exprs[index])
											index += 1
										}
										
									default:
										// continue adding as normal
										ifSubs.append(exprs[index])
										index += 1
									}
									
									// if end of list then add if subs then else subs
									// as individual expressions
									if index >= exprs.count && notDone {
										list.append(expr)
										list += compoundList(exprs: ifSubs)
									}
									
								}
							} else {
								list.append(expr)
							}
						} else {
							list.append(expr)
							// already incremented
						}
					} else {
						list.append(expr)
						// already incremented
					}
					
				default:
					list.append(expr)
					index += 1
				}
			}
			
			return list
		}
		
		var list = compoundList(exprs: updatedStack.asArray.filter({ (expr) -> Bool in
			switch expr {
			case .setLine:
				return false
			case .nop:
				return false
			default:
				return true
			}
		}))
		
		func getLocations(exprs: [XDSExpr]) -> [XDSLocation] {
			var jumpLocations = [String]()
			for expr in exprs {
				
				switch expr {
				case .jump(let l):
					jumpLocations.addUnique(l)
				case .jumpTrue(_, let l):
					jumpLocations.addUnique(l)
				case .jumpFalse(_, let l):
					jumpLocations.addUnique(l)
				case .ifStatement(let parts):
					for (_, block) in parts {
						for loc in getLocations(exprs: block) {
							jumpLocations.addUnique(loc)
						}
					}
				case .whileLoop(_, let block):
					for loc in getLocations(exprs: block) {
						jumpLocations.addUnique(loc)
					}
				case .function(_, let block):
					for loc in getLocations(exprs: block) {
						jumpLocations.addUnique(loc)
					}
				default:
					break
				}
				
			}
			return jumpLocations
		}
		
		func filterLocations(exprs: [XDSExpr]) -> [XDSExpr] {
			// first pass to get jump locations
			let jumpLocations = getLocations(exprs: exprs)
			
			// second to filter unused locations
			var filtered = [XDSExpr]()
			
			for expr in exprs {
				
				switch expr {
				case .location(let loc):
					if jumpLocations.contains(loc) {
						filtered.append(expr)
					}
				case .ifStatement(let parts):
					var total = [(XDSExpr,[XDSExpr])]()
					
					for (condition, block) in parts {
						var newBlock = [XDSExpr]()
						for expr in filterLocations(exprs: block) {
							newBlock.append(expr)
						}
						total.append((condition, newBlock))
					}
					filtered.append(.ifStatement(total))
				case .whileLoop(let condition, let block):
					var newBlock = [XDSExpr]()
					for expr in filterLocations(exprs: block) {
						newBlock.append(expr)
					}
					filtered.append(.whileLoop(condition, newBlock))
				case .function(let header, let block):
					var newBlock = [XDSExpr]()
					for expr in filterLocations(exprs: block) {
						newBlock.append(expr)
					}
					filtered.append(.function(header, newBlock))
				default:
					filtered.append(expr)
				}
				
			}
			
			return filtered
		}
		
		list = filterLocations(exprs: list)
		
		let compoundStack = XGStack<XDSExpr>()
		for expr in list {
			switch expr {
			case .nop:
				fallthrough
			case .locationSilent:
				break
			default:
				compoundStack.push(expr)
			}
			
		}
		
		return (compoundStack, macros)
	}
	
	@objc private func generateXDSHeader() -> String {
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
		//// Decompiled using Gale of Darkness Tool by @StarsMmd ////
		//// \(shortline) ////
		////                                                     ////
		/////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////
		"""
	}
	
	private func getSpecialMacros() -> [String] {
		var macs = [String]()
		macs.append("define ++XDSVersion " + String(format: "%1.1f", currentXDSVersion) + " // lets future versions of the compiler know which rules to follow")
		macs.append("define ++ScriptIdentifier \(self.scriptID.hexString()) // best not to change this")
		macs.append("// define ++CreateBackup YES // before saving the compiled .scd file, if it already exists it will be backed up")
		macs.append("// define ++BaseStringID 0x10000 // This overrides the compiler's base string id when searching for unused string ids")
		
		return macs
	}
	
	@objc private func generateFTBLHeader() -> String {
		var s = ""
		for f in ftbl {
			s += kXDSCommentIndicator + " function \(f.index): " + f.name + " " + XDSExpr.locationWithIndex(f.codeOffset) + "\n"
		}
		return s
	}
	
	func getGlobalVars() -> (text: String, macros: [XDSExpr]) {
		var str = ""
		var mac = [XDSExpr]()
		
		if giri.count > 0 {
			for i in 0 ..< giri.count {
				let variable = XGScriptInstruction(bytes: 0x03030080 + UInt32(i), next: 0).XDSVariable
				let gid = giri[i].groupID
				let rid = giri[i].resourceID
				str += "assign " + variable + " GroupID: " + gid.string + " ResourceID: " + rid.string + " "
				if let rel = mapRel {
					let g = giri[i]
					if g.groupID != 0 {
						let character = rel.characters[g.resourceID]
						let charID = character.characterID
						if charID > 0 {
							let macroString = XDSExpr.macroWithName("CHARACTERID_" + character.name.simplified.uppercased())
							str += "CharacterID: " + macroString + " "
							mac.append(.macro(macroString, charID.string))
						}
						
						let modelID = character.model.index
						if modelID == 0 {
							str += "ModelID: " + modelID.string + " "
						} else {
							let macroString = XDSExpr.macroWithName("MODELID_" + character.model.name.simplified.uppercased())
							str += "ModelID: " + macroString + " "
							mac.append(.macro(macroString, modelID.string))
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
								str += "Script: " + XDSExpr.locationWithName(ftbl[character.scriptIndex].name) + " "
							}
						}
						if character.hasPassiveScript {
							if character.passiveScriptIndex < ftbl.count {
								str += "Background: " + XDSExpr.locationWithName(ftbl[character.passiveScriptIndex].name) + " "
							}
						}
						
					}
				}
				if gid == 0 {
					switch rid {
					case 100: str += " // Michael"
					case 101: str += " // Jovi"
					case 104: str += " // Kandee"
					case 105: str += " // Prof. Krane"
					default: str += " // Invalid GIRI"
					}
				}
				str += "\n"
			}
		}
		str += "\n"
		
		for i in 0 ..< vect.count {
			let vector = vect[i]
			let variable = "vector_" + String(format: "%02d", i)
			let x = String(format: "%.2f", vector.x)
			let y = String(format: "%.2f", vector.y)
			let z = String(format: "%.2f", vector.z)
			str += "global " + variable + " = <\(x) \(y) \(z)>\n"
			
		}
		str += "\n"
		
		for i in 0 ..< arry.count {
			let array = arry[i]
			
			let variable = "array_" + String(format: "%02d", i)
			let type = globalMacroTypes[variable]
			
			str += "global " + variable + " = ["
			for val in array {
				let value = val.rawValueString
				
				if let t = type {
					let macroString = t.printsAsMacro ? XDSExpr.stringFromMacroImmediate(c: val, t: t) : value
					str += (t == .msg ? "\n" : " ") + macroString
					if t.needsDefine {
						mac.append(.macro(macroString, value))
					}
				} else {
					str += " " + value
				}
			}
			str += " ]\n"
		}
		str += "\n"
		
		
		for i in 0 ..< gvar.count {
			let variable = "gvar_" + String(format: "%02d", i)
			var value = gvar[i].rawValueString
			str += "global " + variable + " = "
			if let type = globalMacroTypes[variable] {
				let macroString = type.printsAsMacro ? XDSExpr.stringFromMacroImmediate(c: gvar[i], t: type) : gvar[i].rawValueString
				str += macroString
				if type.needsDefine {
					mac.append(.macro(macroString, value))
				}
			} else {
				var strgCount = 0
				for i in 0 ..< strg.count {
					strgCount += strg[i].count + 1
				}
				for i in 0 ..< strgCount {
					value = value.replacingOccurrences(of: "String(" + i.string + ")", with: "\"" + getStringAtOffset(i + STRGStart  + kScriptSectionHeaderSize) + "\"")
				}
				str += value
			}
			str += "\n"
		}
		str += "\n"
		
		return (str, mac)
	}
	
	@objc func getXDSScript() -> String {
		// creates xds text from expressions
		// can follow a similar process to decompile to other programming or scripting languages
		
		if self.file != .common_rel {
			// check for rel file in same folder
			if self.mapRel == nil {
				let relFile = XGFiles.nameAndFolder(self.file.fileName.removeFileExtensions() + XGFileTypes.rel.fileExtension, self.file.folder)
				if relFile.exists {
					let rel = XGMapRel(file: relFile, checkScript: false)
					if rel.isValid {
						mapRel = rel
					}
				}
			}
			
			// if still not found, check for rel file in rels folder
			if self.mapRel == nil {
				let relFile = XGFiles.rel(self.file.fileName.removeFileExtensions())
				if relFile.exists {
					let rel = XGMapRel(file: relFile, checkScript: false)
					if rel.isValid {
						mapRel = rel
					}
				}
			}
		}
		
		
		
		let (exprStack, macs) = getInstructionStack()
		
		// write script headers
		var script = generateXDSHeader()
		script += "".addRepeated(s: "\n", count: 3)
		script += generateFTBLHeader()
		script += "".addRepeated(s: "\n", count: 3)
		
		let (globalDefinitions, globalMacros) = getGlobalVars()
		let macros = globalMacros + macs
		
		var uniqueMacros = [XDSExpr]()
		for macro in macros {
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
					uniqueMacros.append(.macro(macro.macroName + suffix.string, macro.macroRawValue))
				}
			} else {
				uniqueMacros.append(macro)
			}
		}
		
		var uniqueCharacterMacros = [XDSExpr]()
		var characterMacros = [String : XDSVariable]()
		for g in  0 ..< self.giri.count {
			let currentGiri = self.giri[g]
			
			if let rel = mapRel {
				if currentGiri.groupID != 0 && currentGiri.resourceID < rel.characters.count {
					
					let char = rel.characters[currentGiri.resourceID]
					if char.name.count > 1 {
						let varname = XGScriptInstruction(bytes: 0x03030080 + UInt32(g), next: 0).XDSVariable
						let basemacname = XDSExpr.macroWithName(char.name.simplified)
						var macname = basemacname
						var macnamecount = 1
						while characterMacros[macname] != nil {
							macname = basemacname + String(format: "%02d", macnamecount)
							macnamecount += 1
						}
						
						uniqueCharacterMacros.append(.macro(macname, varname))
						characterMacros[macname] = varname
					}
				}
			}
			if currentGiri.groupID == 0 && currentGiri.resourceID == 100 {
				let varname = XGScriptInstruction(bytes: 0x03030080, next: 0).XDSVariable
				let macname = XDSExpr.macroWithName("player")
				uniqueCharacterMacros.append(.macro(macname, varname))
				characterMacros[macname] = varname
			}
		}
		
		// Special macros for GoD tool
		script += "// Compiler options\n"
		for macro in self.getSpecialMacros() {
			script += macro + "\n"
		}
		
		// macros
		script += "\n// Macro defintions\n"
		for macro in uniqueMacros.sorted(by: { (m1, m2) -> Bool in
			return m1.macroName < m2.macroName
		}) {
			script += macro.text[0] + "\n"
		}
		for macro in uniqueCharacterMacros.sorted(by: { (m1, m2) -> Bool in
			return m1.macroName < m2.macroName
		}) {
			script += macro.text[0] + "    \n"
		}
		
		script += "\n"
		if (gvar.count + arry.count) > 0 {
			script += kXDSCommentIndicator + "Global Variables\n"
		}
		script += globalDefinitions
		
		
		// write out text
		var instructionIndex = 0
		let expressions = exprStack.asArray
		
		for i in 0 ..< expressions.count {
			
			let expr = expressions[i]
			
			// before expression
			var newLines = 0
			switch expr {
			case .comment:
				newLines = 0
			case .location:
				fallthrough
			case .locationIndex:
				newLines = 2
			case .functionDefinition:
				newLines = 2
			case .function:
				newLines = 2
			default:
				newLines = expr.text[0].length == 0 ? 0 : 1
			}
			
			for _ in 0 ..< newLines {
				script += "\n"
			}
			
			// print expression
			var text = expr.text
			
			// override certain constants
			var strgCount = 0
			for i in 0 ..< strg.count {
				strgCount += strg[i].count + 1
			}
			for i in 0 ..< strgCount {
				text = text.map { (s) -> String in
					return s.replacingOccurrences(of: "String(" + i.string + ")", with: "\"" + getStringAtOffset(i + STRGStart  + kScriptSectionHeaderSize) + "\"")
				}
			}
			
			// override character object variable
			for (macname, varname) in characterMacros {
				for add in [" ", ".", ")", ">", "]", "\"", "\n"] {
					text = text.map { (s) -> String in
						return s.replacingOccurrences(of: varname + add, with: macname + add)
					}
				}
			}
			
			for f in ftbl {
				let locname = XDSExpr.locationWithIndex(f.codeOffset)
				let funname = XDSExpr.locationWithName(f.name)
				for add in [" ", ".", ")", ">", "]", "\"", "\n"] {
					text = text.map { (s) -> String in
						return s.replacingOccurrences(of: locname + add, with: funname + add)
					}
				}
			}
			
			for line in text {
				script += line
			}
			
			// after expression
			newLines = 0
			switch expr {
			case .exit:
				newLines = 2
			case .XDSReturn:
				newLines = 1
			case .XDSReturnResult:
				newLines = 1
			default:
				newLines = 0
			}
			for _ in 0 ..< newLines {
				script += "\n"
			}
			
			instructionIndex += expr.instructionCount
		}
		
		script += "".addRepeated(s: "\n", count: 3)
		
		return script
	}
	
	
	func getItems() -> [XGItems] {
		// modified version of getXDSScript
		// pared down to just the necessary parts
		
		
		var items = [XGItems]()
		let expressions = getInstructionStack().expressions.asArray
		
		for expression in expressions {
			items += expression.items
		}
		
		for i in 0 ..< arry.count {
			let array = arry[i]
			
			let variable = "array_" + String(format: "%02d", i)
			if let type = globalMacroTypes[variable] {
				
				if type == .item {
					for val in array {
						items.append(.item(val.asInt))
					}
				}
			}
		}
		
		
		for i in 0 ..< gvar.count {
			let variable = "gvar_" + String(format: "%02d", i)
			
			if let type = globalMacroTypes[variable] {
				if type == .item {
					let value = gvar[i].asInt
					items.append(.item(value))
				}
			}
		}
		
		return items
	}
	
	
	
	
	
	
	
	
	
}





















