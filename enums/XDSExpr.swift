//
//  XDSExpr.swift
//  GoDToolCL
//
//  Created by The Steez on 29/05/2018.
//

import Foundation

typealias XDSVariable   = String
typealias XDSLocation   = String
typealias XDSClassID    = Int
typealias XDSFunctionID = Int
typealias XDSOperator	= Int

let kXDSCommentIndicator = "\\\\"

indirect enum XDSExpr {
	
	case nop
	case bracket(XDSExpr)
	case unaryOperator(XDSOperator, XDSExpr)
	case binaryOperator(XDSOperator, XDSExpr, XDSExpr)
	case loadImmediate(XDSConstant)
	case loadVariable(XDSVariable)
	case setVariable(XDSVariable, XDSExpr)
	case setVector(XDSVariable, XDSExpr)
	case call(XDSLocation, [XDSExpr])
	case XDSReturn
	case XDSReturnResult(XDSExpr)
	case callStandard(XDSClassID, XDSFunctionID, [XDSExpr]) // returns a value in last result
	case callStandardVoid(XDSClassID, XDSFunctionID, [XDSExpr])
	case jumpTrue(XDSExpr, XDSLocation)
	case jumpFalse(XDSExpr, XDSLocation)
	case jump(XDSLocation)
	case loadPointer(XDSVariable)
	case reserve(Int)
	case location(XDSLocation)
	case locationIndex(Int)
	case function(XDSVariable, [XDSVariable])
	case comment(String)
	case macro(String, String)
	case msgMacro(XGString)
	case exit
	case setLine(Int)
	//TODO: - add xdsdefault
	
	
	// used for comparison in order tyo eschew switch statements
	var xdsID : Int {
		var id = 0
		switch self {
		case .bracket(_):
			id += 1
			fallthrough
		case .unaryOperator(_, _):
			id += 1
			fallthrough
		case .binaryOperator(_, _, _):
			id += 1
			fallthrough
		case .loadImmediate(_):
			id += 1
			fallthrough
		case .loadVariable(_):
			id += 1
			fallthrough
		case .setVariable(_, _):
			id += 1
			fallthrough
		case .setVector(_, _):
			id += 1
			fallthrough
		case .call(_, _):
			id += 1
			fallthrough
		case .XDSReturn:
			id += 1
			fallthrough
		case .XDSReturnResult(_):
			id += 1
			fallthrough
		case .callStandard(_, _, _):
			id += 1
			fallthrough
		case .callStandardVoid(_, _, _):
			id += 1
			fallthrough
		case .jumpTrue(_, _):
			id += 1
			fallthrough
		case .jumpFalse(_, _):
			id += 1
			fallthrough
		case .jump(_):
			id += 1
			fallthrough
		case .loadPointer(_):
			id += 1
			fallthrough
		case .reserve(_):
			id += 1
			fallthrough
		case .location(_):
			id += 1
			fallthrough
		case .locationIndex(_):
			id += 1
			fallthrough
		case .function(_, _):
			id += 1
			fallthrough
		case .comment(_):
			id += 1
			fallthrough
		case .macro(_, _):
			id += 1
			fallthrough
		case .msgMacro(_):
			id += 1
			fallthrough
		case .exit:
			id += 1
			fallthrough
		case .setLine(_):
			id += 1
			fallthrough
		case .nop:
			break
		}
		return id
	}
	
	var bracketed : XDSExpr {
		switch self {
		case .loadVariable:
			fallthrough
		case .loadPointer:
			fallthrough
		case .nop:
			fallthrough
		case .bracket:
			fallthrough
		case .unaryOperator:
			fallthrough
		case .loadImmediate:
			fallthrough
		case .exit:
			fallthrough
		case .msgMacro:
			fallthrough
		case .location:
			fallthrough
		case .locationIndex:
			fallthrough
		case .XDSReturn:
			return self
		default:
			return .bracket(self)
		}
	}
	
	var forcedBracketed : XDSExpr {
		switch self {
		case .bracket:
			return self
		default:
			return .bracket(self)
		}
	}
	
	var constants : [XDSConstant] {
		var constants = [XDSConstant]()
		
		switch self {
		case .call(_, let es):
			for e in es {
				constants += e.constants
			}
		case .loadImmediate(let v):
			return [v]
		case .bracket(let e):
			return e.constants
		case .unaryOperator(_,let e):
			return e.constants
		case .binaryOperator(_, let e1, let e2):
			return e1.constants + e2.constants
		case .setVariable(_, let e):
			return e.constants
		case .setVector(_, let e):
			return e.constants
		case .jumpTrue(let e, _):
			return e.constants
		case .jumpFalse(let e, _):
			return e.constants
		case .XDSReturnResult(let e):
			return e.constants
		case.callStandardVoid(_, _, let es):
			for e in es {
				constants += e.constants
			}
		case.callStandard(_, _, let es):
			for e in es {
				constants += e.constants
			}
		default:
			break
		}
		
		return constants
	}
	
	var instructionCount : Int {
		switch self {
		case .nop:
			return 0
		case .bracket(let e):
			return e.instructionCount
		case .unaryOperator(_, let e):
			return 1 + e.instructionCount
		case .binaryOperator(_, let e1, let e2):
			return 1 + e1.instructionCount + e2.instructionCount
		case .loadImmediate(let v):
			return v.type.string == XDSConstantTypes.string.string ?  1 : 2
		case .loadVariable(_):
			return 1
		case .setVariable(_, let e):
			return 1 + e.instructionCount
		case .setVector(_, let e):
			return 1 + e.instructionCount
		case .call(_, let es):
			var count = 1
			for e in es {
				count += e.instructionCount
			}
			return count
		case .XDSReturn:
			return 2 // includes release
		case .XDSReturnResult(let e):
			return 2 + e.instructionCount
		case .callStandard(_, _, let es):
			var count = 3 // includes pop and ldvar last rsult
			for e in es {
				count += e.instructionCount
			}
			return count
		case .callStandardVoid(_, _, let es):
			var count = 2 // includes pop
			for e in es {
				count += e.instructionCount
			}
			return count
		case .jumpTrue(let e, _):
			return 1 + e.instructionCount
		case .jumpFalse(let e, _):
			return 1 + e.instructionCount
		case .jump(_):
			return 1
		case .loadPointer(_):
			return 1
		case .reserve(_):
			return 1
		case .locationIndex(let i):
			return XDSExpr.location(XDSExpr.locationWithIndex(i)).instructionCount
		case .location(_):
			return 0
		case .function(_, _):
			return 0
		case .exit:
			return 1
		case .setLine(_):
			return 1
		case .comment(_):
			return 0
		case .macro(_):
			return 0
		case .msgMacro(_):
			return 2 // load immediate msgid
		}
	}
	
	static func locationWithIndex(_ i: Int) -> XDSLocation {
		return XDSExpr.locationWithName("location_" + i.string)
	}
	
	static func locationWithName(_ n: String) -> XDSLocation {
		return "@" + n
	}
	
	static func indexForLocation(_ l: XDSLocation) -> Int {
		return Int(l.replacingOccurrences(of: "@location_", with: "")) ?? -1
	}
	
	var text : String {
		switch self {
			
		// ignore these instructions
		case .nop:
			fallthrough
		case .reserve(_):
			fallthrough
		case .setLine(_):
			return ""
		
			
		// variables and primitives
		case .loadImmediate(let v):
			switch v.type {
			case .float:
				return "\(v.asFloat)"
			case .pokemon:
				return "\(XGPokemon.pokemon(v.asInt).name.string)"
			default:
				return "\(v.asInt)"
			}
		case .loadVariable(let v):
			return v
		case .loadPointer(let s):
			return s
		
		// operations
		case .bracket(let e):
			return "(" + e.text + ")"
		case .unaryOperator(let o,let e):
			return XGScriptClassesInfo.operators.operatorWithID(o).name + e.text
		case .binaryOperator(let o, let e1, let e2):
			if (e1.xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID) && (e2.xdsID != XDSExpr.loadImmediate(XDSConstant.null).xdsID) {
				let reversed = e2.text + " \(XGScriptClassesInfo.operators.operatorWithID(o).name) " + e1.text
				switch o {
				case 48: // = equal
					fallthrough
				case 53: // != not equal
					return reversed
				case 33:
					fallthrough
				case 34:
					return reversed
				default:
					return e1.text + " \(XGScriptClassesInfo.operators.operatorWithID(o).name) " + e2.text
				}
			} else {
				return e1.text + " \(XGScriptClassesInfo.operators.operatorWithID(o).name) " + e2.text
			}
			
		// assignments
		case .setVariable(let v, let e):
			return v + " = " + e.text
		case .setVector(let v, let e):
			return v + " = " + e.text
			
		// function calls
		case .function(let name, let params):
			var s = "function " + XDSExpr.locationWithName(name)
			
			for param in params {
				s += " " + param
			}
			return s
		case .call(let l, let es):
			var s = "exec " + l
			for e in es {
				s += " " + e.text
			}
			return s
		case .callStandard(let c, let f, let es):
			return XDSExpr.callStandardVoid(c, f, es).text
		case .callStandardVoid(let c, let f, let es):
			let xdsclass = XGScriptClassesInfo.classes(c)
			let xdsfunction = xdsclass.functionWithID(f)
			var s = c > 0 ? es[0].text + "." : ""
			s += xdsfunction.name
			let firstIndex = c == 0 ? 0 : 1
			for i in firstIndex ..< es.count {
				let e = es[i]
				s += " " + e.text
			}
			return s
			
		// control flow
		case .location(let l):
			return l
		case .locationIndex(let i):
			return XDSExpr.locationWithIndex(i)
		case .jumpTrue(let e, let l):
			return "goto " + l + " if " + e.text
		case .jumpFalse(let e, let l):
			return "goto " + l + " ifFalse " + e.text
		case .jump(let l):
			return "goto " + l
		case .XDSReturn:
			return "return"
		case .XDSReturnResult(let e):
			return "return " + e.text
		case .exit:
			return "exit"
		
		// convenience
		case .comment(let s):
			return kXDSCommentIndicator + s
		case .macro(let s, let t):
			return "define #" + s + " " + t
		case .msgMacro(let x):
			let id = x.id > 0 ? ":\(x.id):" : ""
			return "$" + id + "\"\(x.string)\""
		}
	}
	
	var comment : XDSExpr? {
		switch self {
		case .callStandardVoid(let c, let f, let params):
			
			if c == 35 { // Character
				if f == 70 { // set model
					if params[1].xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID {
						let modelId = params[1].constants[0].value
						let archive = XGFiles.fsys("people_archive.fsys").fsysData
						let mindex = archive.indexForIdentifier(identifier: modelId.int)
						let name = archive.fileNameForFileWithIndex(index: mindex)
						return .comment("model: " + name)
					}
				}
				
				if f == 73 { // talk
					let type = params[1].constants[0].value
					if type == 9 {
						if params[3].xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID {
							let battleId = params[3].constants[0].value.int
							if let battle = XGBattle(index: battleId).trainer {
								let s = ("\n" + battle.fullDescription).replacingOccurrences(of: "\n", with: "\n" + kXDSCommentIndicator + " ")
								return .comment(s)
							}
						}
					}
					if type == 14 {
						if params[3].xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID {
							let itemId = params[3].constants[0].value.int
							let item = XGItems.item(itemId).name.string
							return .comment(" receive item: " + item)
						}
					}
				}
			}
			
			
			if c == 40 { // Dialogue
			
				if f == 72 { // startBattle
					if params[1].xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID {
						let battleId = params[1].constants[0].value.int
						if let battle = XGBattle(index: battleId).trainer {
							let s = ("\n" + battle.fullDescription).replacingOccurrences(of: "\n", with: "\n" + kXDSCommentIndicator + " ")
							return .comment(s)
						}
					}
				}
			
			
				if f == 39 { // open poke mart menu
					
					if params[1].xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID {
						let martId = params[1].constants[0].value.int
						let mart = XGPokemart(index: martId).items
						var s = ""
						for item in mart {
							s += "\n" + kXDSCommentIndicator + " " + item.name.string
						}
						return .comment(s)
					}
				}
				
			}
			
			if c == 42 { // Battle
				if f == 16 { // startBattle
					if params[1].xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID {
						let battleId = params[1].constants[0].value.int
						if let battle = XGBattle(index: battleId).trainer {
							let s = ("\n" + battle.fullDescription).replacingOccurrences(of: "\n", with: "\n" + kXDSCommentIndicator + " ")
							return .comment(s)
						}
					}
				}
			}
		
		default:
			return nil
		}
		return nil
	}
	
	
}










