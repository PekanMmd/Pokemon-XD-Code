//
//  PBRScript.swift
//  Revolution Tool CL
//
//  Created by The Steez on 26/12/2018.
//

import Foundation

// mostly the same as XD .scd format but slight differences

let kScriptSectionHeaderSize = 0x20
let kScriptGIRIHeaderSize = 0x10 // just the header and otherwise unused
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
typealias VECT = (x: Float, y: Float, z: Float)

let currentXDSVersion : Float = 1.1

class XGScript: NSObject {
	
	var file : XGFiles!
	var data : XGMutableData!
	
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
	var arry = [[XDSConstant]]()
	
	var scriptID : UInt32 = 0x0
	
	var codeLength : Int {
		var count = 0
		
		for c in self.code {
			count += c.length
		}
		
		return count
	}
	
	convenience init(file: XGFiles) {
		self.init(data: file.data!)
	}
	
	init(data: XGMutableData) {
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
		let numberGVAREntries = Int(data.getWordAtOffset(GVARStart + kScriptSectionEntriesOffset))
		let numberSTRGEntries = Int(data.getWordAtOffset(STRGStart + kScriptSectionEntriesOffset))
		let numberVECTEntries = Int(data.getWordAtOffset(VECTStart + kScriptSectionEntriesOffset))
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
		
		let rawCode = data.getWordStreamFromOffset(CODEStart + kScriptSectionHeaderSize, length: GVARStart - (CODEStart + kScriptSectionHeaderSize))
		
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
	
	
	func getStringAtOffset(_ offset: Int) -> String {
		
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
			let (o, _, name,index) = self.ftbl[i]
			desc += "\(index): " + name.spaceToLength(30) + "offset: " + o.hexString() + "\n"
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
			
			if instruction.opCode == .loadImmediate {
				switch instruction.constant.type {
				case .string:
					desc += ">> \"" + getStringAtOffset(STRGStart + kScriptSectionHeaderSize + instruction.parameter) + "\"\n"
				default:
					break
				}
			}
			
		}
		
		// list global variables
		desc += "\nGVAR: \(self.gvar.count)\n" + linebreak
		for g in  0 ..< self.gvar.count {
			desc += "\(g): " + self.gvar[g].description + "\n"
		}

		desc += "\nSTRG: \(self.strg.count)\n" + linebreak
		var strgPosition = 0
		for str in strg {
			desc += "\(strgPosition): " + str + "\n"
			strgPosition += str.length + 1
		}
		
		desc += "\nARRY: \(self.arry.count)\n" + linebreak
		for a in 0 ..< self.arry.count {
			desc += "\(a): " + String(describing: self.arry[a]) + "\n"
		}
		
		desc += "\nVECT: \(self.vect.count)\n" + linebreak
		for v in 0 ..< self.vect.count {
			desc += "\(v): <\(vect[v].x), \(vect[v].y), \(vect[v].z)>\n"
		}
		
		return desc
	}
	
	
	private func scriptFunctionSetsLastResult(name: String) -> Bool {
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
	
	private func getLastInstructionIndexforFunction(named name: String) -> Int {
		for i in 0 ..< ftbl.count {
			let f = ftbl[i]
			if f.name == name {
				return f.end
			}
		}
		return -1
	}
	
	private func getParameterCountForFunction(named name: String) -> Int {
		for i in 0 ..< ftbl.count {
			let f = ftbl[i]
			
			if f.name == name {
				var paramsCount = 0
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
					case .reserve:
						return currentInstruction.subOpCode
					default:
						currentIndex += currentInstruction.length
					}
				}
				return 0
			}
		}
		printg("couldn't get function parameter count: function \"\(name)\" doesn't exist")
		return 0
	}
	
	private func getFunctionAtLocation(location: Int) -> String {
		for f in ftbl {
			if f.codeOffset == location {
				return f.name
			}
		}
		return ""
	}
	
	private func getInstructionStack() -> XGStack<XDSExpr> {
		let stack = XGStack<XDSExpr>()
		
		var functionParams = [String : Int]()
		for f in ftbl {
			functionParams[f.name] = getParameterCountForFunction(named: f.name)
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
				
			case .unknown18:
				stack.push(.unknown18(instruction.raw1))
				
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
				
			case .loadShortImmediate:
				stack.push(.loadShortImmediate(instruction.constant))
				
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
		var locationsDictionary = [XDSLocation : Int]()
		
		var instructionIndex = 0
		for expr in stack.asArray {
			
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
		
		return compoundStack
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
		//// Decompiled using Gale of Darkness Tool by @StarsMmd ////
		//// \(shortline) ////
		////                                                     ////
		/////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////
		"""
	}
	
	private func generateFTBLHeader() -> String {
		var s = ""
		for f in ftbl {
			s += kXDSCommentIndicator + " function \(f.index): " + f.name + " " + XDSExpr.locationWithIndex(f.codeOffset) + "\n"
		}
		return s
	}
	
	func getGlobalVars() -> String {
		var str = "\n"
		
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
			
			str += "global " + variable + " = ["
			for val in array {
				let value = val.rawValueString
				str += " " + value
			}
			str += " ]\n"
		}
		str += "\n"
		
		
		for i in 0 ..< gvar.count {
			let variable = "gvar_" + String(format: "%02d", i)
			var value = gvar[i].rawValueString
			str += "global " + variable + " = "
			
			var strgCount = 0
			for i in 0 ..< strg.count {
				strgCount += strg[i].count + 1
			}
			for i in 0 ..< strgCount {
				value = value.replacingOccurrences(of: "String(" + i.string + ")", with: "\"" + getStringAtOffset(i + STRGStart  + kScriptSectionHeaderSize) + "\"")
			}
			str += value
			
			str += "\n"
		}
		str += "\n"
		
		return str
	}
	
	func getXDSScript() -> String {
		// creates xds text from expressions
		// can follow a similar process to decompile to other programming or scripting languages
		
		let exprStack = getInstructionStack()
		
		// write script headers
		var script = generateXDSHeader()
		script += "".addRepeated(s: "\n", count: 3)
		script += generateFTBLHeader()
		script += "".addRepeated(s: "\n", count: 3)
		
		let globalDefinitions = getGlobalVars()
		
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
}















