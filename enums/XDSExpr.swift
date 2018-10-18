//
//  XDSExpr.swift
//  GoDToolCL
//
//  Created by The Steez on 29/05/2018.
//

import Foundation

typealias XDSVariable   = String
typealias XDSLocation   = String
typealias XDSMacro      = String
typealias XDSClassID    = Int
typealias XDSFunctionID = Int
typealias XDSOperator	= Int

let kXDSCommentIndicator = "//"

enum XDSVectorDimension : Int {
	case x = 0
	case y = 1
	case z = 2
	case invalid = -1
	
	var string : String {
		switch self {
		case .x : return "vx"
		case .y : return "vy"
		case .z : return "vz"
		default : return "invalidDimension"
		}
	}
}

indirect enum XDSExpr {
	
	case nop
	case bracket(XDSExpr)
	case unaryOperator(XDSOperator, XDSExpr)
	case binaryOperator(XDSOperator, XDSExpr, XDSExpr)
	case loadImmediate(XDSConstant)
	case macroImmediate(XDSConstant, XDSMacroTypes) // a constant value that has been replaced by a macro
	case loadVariable(XDSVariable)
	case loadPointer(XDSVariable)
	case setVariable(XDSVariable, XDSExpr)
	case setVector(XDSVariable, XDSVectorDimension, XDSExpr)
	case call(XDSLocation, [XDSExpr])
	case callVoid(XDSLocation, [XDSExpr])
	case XDSReturn
	case XDSReturnResult(XDSExpr)
	case callStandard(XDSClassID, XDSFunctionID, [XDSExpr]) // returns a value in last result
	case callStandardVoid(XDSClassID, XDSFunctionID, [XDSExpr])
	case jumpTrue(XDSExpr, XDSLocation)
	case jumpFalse(XDSExpr, XDSLocation)
	case jump(XDSLocation)
	case reserve(Int)
	case location(XDSLocation)
	case locationIndex(Int)
	case function(XDSLocation, [XDSVariable])
	case comment(String)
	case macro(XDSMacro, String)
	case msgMacro(XGString)
	case exit
	case setLine(Int)
	
	var isLoadImmediate : Bool {
		return self.xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID
	}
	
	var isImmediate : Bool {
		return self.isLoadImmediate || self.xdsID == XDSExpr.macroImmediate(XDSConstant.null, .none).xdsID
	}
	
	var isReturn : Bool {
		return self.xdsID == XDSExpr.XDSReturn.xdsID || self.xdsID == XDSExpr.XDSReturnResult(.nop).xdsID
	}
	
	var isNop : Bool {
		return self.xdsID == XDSExpr.nop.xdsID
	}
	
	var isCallstdWithReturnValue : Bool {
		return self.xdsID == XDSExpr.callStandard(0, 0, []).xdsID
	}
	
	// used for comparison in order tyo eschew switch statements
	var xdsID : Int {
		var id = 0
		switch self {
		case .bracket:
			id += 1
			fallthrough
		case .unaryOperator:
			id += 1
			fallthrough
		case .binaryOperator:
			id += 1
			fallthrough
		case .loadImmediate:
			id += 1
			fallthrough
		case .macroImmediate:
			id += 1
			fallthrough
		case .loadVariable:
			id += 1
			fallthrough
		case .setVariable:
			id += 1
			fallthrough
		case .setVector:
			id += 1
			fallthrough
		case .call:
			id += 1
			fallthrough
		case .callVoid:
			id += 1
			fallthrough
		case .XDSReturn:
			id += 1
			fallthrough
		case .XDSReturnResult:
			id += 1
			fallthrough
		case .callStandard:
			id += 1
			fallthrough
		case .callStandardVoid:
			id += 1
			fallthrough
		case .jumpTrue:
			id += 1
			fallthrough
		case .jumpFalse:
			id += 1
			fallthrough
		case .jump:
			id += 1
			fallthrough
		case .loadPointer:
			id += 1
			fallthrough
		case .reserve:
			id += 1
			fallthrough
		case .location:
			id += 1
			fallthrough
		case .locationIndex:
			id += 1
			fallthrough
		case .function:
			id += 1
			fallthrough
		case .comment:
			id += 1
			fallthrough
		case .macro:
			id += 1
			fallthrough
		case .msgMacro:
			id += 1
			fallthrough
		case .exit:
			id += 1
			fallthrough
		case .setLine:
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
		case .macroImmediate:
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
		case .callStandard:
			return self
		case .callStandardVoid:
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
		case .callVoid(_, let es):
			for e in es {
				constants += e.constants
			}
		case .loadImmediate(let c):
			return [c]
		case .macroImmediate(let c, _):
			return [c]
		case .bracket(let e):
			return e.constants
		case .unaryOperator(_,let e):
			return e.constants
		case .binaryOperator(_, let e1, let e2):
			return e1.constants + e2.constants
		case .setVariable(_, let e):
			return e.constants
		case .setVector(_, _, let e):
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
			return 1
		case .bracket(let e):
			return e.instructionCount
		case .unaryOperator(_, let e):
			return 1 + e.instructionCount
		case .binaryOperator(_, let e1, let e2):
			return 1 + e1.instructionCount + e2.instructionCount
		case .loadImmediate(let c):
			return (c.type.string == XDSConstantTypes.string.string) || c.type.string == XDSConstantTypes.vector.string ?  1 : 2
		case .macroImmediate(let c, _):
			return (c.type.string == XDSConstantTypes.string.string) || c.type.string == XDSConstantTypes.vector.string ?  1 : 2
		case .loadVariable(_):
			return 1
		case .setVariable(_, let e):
			return 1 + e.instructionCount
		case .setVector(_, _, let e):
			return 1 + e.instructionCount
		case .call(_, let es):
			var count = 2 // includes load var last result
			for e in es {
				count += e.instructionCount
			}
			// if it has params then also need an instruction for pop
			if es.count > 0 {
				count += 1
			}
			return count
		case .callVoid(_, let es):
			var count = 1
			for e in es {
				count += e.instructionCount
			}
			// if it has params then also need an instruction for pop
			if es.count > 0 {
				count += 1
			}
			return count
		case .XDSReturn:
			return 2 // includes release
		case .XDSReturnResult(let e):
			return 3 + e.instructionCount // includes release and setvar last result
		case .callStandard(_, _, let es):
			var count = 3 // includes pop and ldvar last result
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
			return 1 // includes reserve
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
	
	var macroName : String {
		switch self {
		case .macro(let s, _):
			return s
		default:
			return ""
		}
	}
	
	static func locationWithIndex(_ i: Int) -> XDSLocation {
		return XDSExpr.locationWithName("location_" + i.string)
	}
	
	static func locationWithName(_ n: String) -> XDSLocation {
		return "@" + n
	}
	
	static func macroWithName(_ n: String) -> String {
		return "#" + n
	}
	
	static func macroForString(xs: XGString) -> String {
		if xs.id == 0 {
			return "$:0:"
		}
		// must replace double quotes with special character since xds doesn't use escaped characters
		return "$:\(xs.id):" + "\"\(xs.string.replacingOccurrences(of: "\"", with: "[Quote]"))\""
	}
	
	static func stringFromMacroImmediate(c: XDSConstant, t: XDSMacroTypes) -> String {
		switch t {
		case .bool:
			return c.asInt != 0 ? XDSExpr.macroWithName("TRUE") : XDSExpr.macroWithName("FALSE")
		case .flag:
			if let flag = XDSFlags(rawValue: c.asInt) {
				return XDSExpr.macroWithName("FLAG_" + flag.name.simplified.uppercased())
			}
			return c.asInt.string
		case .none:
			printg("error: empty macro value")
			return "error: empty macro value"
		case .pokemon:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("pokemon_none".uppercased())
			}
			return XDSExpr.macroWithName("POKEMON_" + XGPokemon.pokemon(c.asInt).name.string.simplified.uppercased())
		case .item:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("item_none".uppercased())
			}
			return XDSExpr.macroWithName("ITEM_" + XGItems.item(c.asInt).name.string.simplified.uppercased())
		case .model:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("model_none".uppercased())
			}
			return XDSExpr.macroWithName("MODEL_" + XGCharacterModels.modelWithIdentifier(id: c.asInt).name.simplified.uppercased())
		case .move:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("move_none".uppercased())
			}
			return XDSExpr.macroWithName("MOVE_" + XGMoves.move(c.asInt).name.string.simplified.uppercased())
		case .room:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("room_none".uppercased())
			}
			return XDSExpr.macroWithName("ROOM_" + (XGRoom.roomWithID(c.asInt) ?? XGRoom(index: 0)).name.simplified.uppercased())
		case .battlefield:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("battlefield_none".uppercased())
			}
			if let room = XGBattleField(index: c.asInt).room {
				return XDSExpr.macroWithName("BATTLEFIELD_" + room.name.simplified.uppercased())
			}
			return XDSExpr.macroWithName("battlefield_none".uppercased())
		case .msg:
			return macroForString(xs: getStringSafelyWithID(id: c.asInt))
		case .talk:
			if let type = XDSTalkTypes(rawValue: c.asInt) {
			return XDSExpr.macroWithName("SPEECH_TYPE_" + type.string.simplified.uppercased())
			} else {
				printg("error: unknown speech type")
				return "error: unknown speech type"
			}
		case .ability:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("ability_none".uppercased())
			}
			return XDSExpr.macroWithName("ABILITY_" + XGAbilities.ability(c.asInt).name.string.simplified.uppercased())
		case .msgVar:
			return XDSExpr.macroWithName("MSG_VAR" + c.asInt.hexString())
		case .battleResult:
			switch c.asInt {
				case 0: return XDSExpr.macroWithName("result_before_battle".uppercased())
				case 1: return XDSExpr.macroWithName("result_lose".uppercased())
				case 2: return XDSExpr.macroWithName("result_win".uppercased())
				default: return XDSExpr.macroWithName("result_unknown".uppercased() + c.asInt.string)
			}
		case .shadowStatus:
			switch c.asInt {
			case 0: return XDSExpr.macroWithName("status_not_seen".uppercased())
			case 1: return XDSExpr.macroWithName("status_seen_in_world".uppercased())
			case 2: return XDSExpr.macroWithName("status_seen_in_battle".uppercased())
			case 3: return XDSExpr.macroWithName("status_caught".uppercased())
			case 4: return XDSExpr.macroWithName("status_purified".uppercased())
			default: printg("error unknown shadow pokemon status");return "error unknown shadow pokemon status"
			}
		case .battleID:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("battle_none".uppercased())
			}
			return XDSExpr.macroWithName("BATTLE_" + String(format: "%03d", c.asInt))
		case .shadowID:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("shadow_pokemon_none".uppercased())
			}
			return XDSExpr.macroWithName("SHADOW_" + XGDeckPokemon.ddpk(c.asInt).pokemon.name.string.simplified.uppercased()  + String(format: "_%02d", c.asInt))
		case .treasureID:
			if c.asInt == 0 {
				return XDSExpr.macroWithName("treasure_none".uppercased())
			}
			return XDSExpr.macroWithName("TREASURE_" + XGTreasure(index: c.asInt).item.name.string.simplified.uppercased() + String(format: "_%03d", c.asInt))
		case .pokespot:
			guard let spot = XGPokeSpots(rawValue: c.asInt) else {
				printg("error unknown pokespot");return "error unknown pokespot"
			}
			return XDSExpr.macroWithName("POKESPOT_" + spot.string.simplified.uppercased())
		case .partyMember:
			switch c.asInt {
			case 0:
				return "PARTY_MEMBER_NONE"
			case 1:
				return "PARTY_MEMBER_JOVI"
			case 2:
				return "PARTY_MEMBER_KANDEE"
			case 3:
				return "PARTY_MEMBER_KRANE"
			default:
				printg("error unknown party member");return "error unknown party member"
			}
			
		}
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
		case .loadImmediate(let c):
			return c.rawValueString
		case .macroImmediate(let c, let t):
			return XDSExpr.stringFromMacroImmediate(c: c, t: t)
		case .loadVariable(let v):
			return v
		case .loadPointer(let s):
			return s
		
		// operations
		case .bracket(let e):
			return "(" + e.text + ")"
		case .unaryOperator(let o,let e):
			return XGScriptClassesInfo.operators.operatorWithID(o).name + "(" + e.text + ")"
		case .binaryOperator(let o, let e1, let e2):
			return e1.text + " \(XGScriptClassesInfo.operators.operatorWithID(o).name) " + e2.text
			
		// assignments
		case .setVariable(let v, let e):
			return v + " = " + e.text
		case .setVector(let v, let d, let e):
			return v + "." + d.string + " = " + e.text
			
		// function calls
		case .function(let name, let params):
			var s = "function " + name
			
			for param in params {
				s += " " + param
			}
			return s
		case .call(let l, let es):
			var s = "call " + l
			for e in es {
				s += " " + e.text
			}
			return s
		case .callVoid(let l, let es):
			var s = "call " + l
			for e in es {
				s += " " + e.text
			}
			return s
		case .callStandard(let c, let f, let es):
			return XDSExpr.callStandardVoid(c, f, es).text
		case .callStandardVoid(let c, let f, let es):
			// array get
			if c == 7 && f == 16 {
				
				return es[0].text + "[" + es[1].text + "]"
				
			// array set
			} else if c == 7 && f == 17 {
				
				return es[0].text + "[" + es[1].text + "] = " + es[2].text
				
			} else {
				let xdsclass = XGScriptClassesInfo.classes(c)
				let xdsfunction = xdsclass.functionWithID(f)
				// don't need * in function calls as the type is explicitly included
				var s = c > 0 ? es[0].text.replacingOccurrences(of: "*", with: "") + "." : ""
				// local variables and function parameters need additional class info
				if c > 0 {
					if es[0].text.contains("arg") || (es[0].text.contains("var") && !es[0].text.contains("gvar")) || es[0].text.contains(kXDSLastResultVariable) {
						s += xdsclass.name.capitalized + "."
					}
				}
				s += xdsfunction.name + "("
				let firstIndex = c > 0 ? 1 : 0
				for i in firstIndex ..< es.count {
					let e = es[i]
					s += (i == firstIndex ? "" : " ") + e.text
				}
				s += ")"
				return s
			}
			
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
			return s
		case .macro(let s, let t):
			return "define " + s + " " + t
		case .msgMacro(let x):
			return XDSExpr.macroForString(xs: x)
		}
	}
	
	var comment : XDSExpr? {
		switch self {
		case .callStandardVoid(let c, let f, let params):
			
			if c == 35 { // Character
				if f == 73 { // talk
					let type = params[1].constants[0].value
					if type == 9 || type == 6 {
						if (params[3].isImmediate) {
							let battleId = params[3].constants[0].value.int
							let battle = XGBattle(index: battleId)
							let s = "\n/*\n * " + battle.description.replacingOccurrences(of: "\n", with: "\n * ") + "\n */\n"
							return .comment(s)
							
						}
					}
				}
			}
			
			
			if c == 40 { // Dialogue
			
				if f == 72 { // startBattle
					if params[1].isImmediate {
						let battleId = params[1].constants[0].value.int
						let battle = XGBattle(index: battleId)
						let s = "\n/*\n * " + battle.description.replacingOccurrences(of: "\n", with: "\n * ") + "\n */\n"
						return .comment(s)
					}
				}
			
			
				if f == 39 { // open poke mart menu
					
					if params[1].isImmediate {
						let martId = params[1].constants[0].value.int
						let mart = XGPokemart(index: martId).items
						var s = "\n/*"
						for item in mart {
							s += "\n * " + item.name.string
						}
						s += "\n */\n"
						return .comment(s)
					}
				}
				
			}
			
			if c == 42 { // Battle
				if f == 16 { // startBattle
					if params[1].isImmediate {
						let battleId = params[1].constants[0].value.int
						let battle = XGBattle(index: battleId)
						let s = "\n/*\n * " + battle.description.replacingOccurrences(of: "\n", with: "\n * ") + "\n */\n"
						return .comment(s)
					}
				}
			}
		
		default:
			return nil
		}
		return nil
	}
	
	var macros : [XDSExpr] {
		switch self {
			
		case .bracket(let e):
			return e.macros
		case .unaryOperator(_, let e):
			return e.macros
		case .binaryOperator(_, let e1, let e2):
			return e1.macros + e2.macros
		case .macroImmediate(let c, let t):
			return [.macro(self.text,c.rawValueString)]
		case .XDSReturnResult(let e):
			return e.macros
		case .callStandard(_, _, let es):
			var macs = [XDSExpr]()
			for e in es {
				macs += e.macros
			}
			return macs
		case .callStandardVoid(_, _, let es):
			var macs = [XDSExpr]()
			for e in es {
				macs += e.macros
			}
			return macs
		case .setVariable(_, let e):
			return e.macros
		case .setVector(_, _, let e):
			return e.macros
		case .call(_, let es):
			var macs = [XDSExpr]()
			for e in es {
				macs += e.macros
			}
			return macs
		case .callVoid(_, let es):
			var macs = [XDSExpr]()
			for e in es {
				macs += e.macros
			}
			return macs
		case .jumpTrue(let e, _):
			return e.macros
		case .jumpFalse(let e, _):
			return e.macros
		default:
			return []
		}
	}
	
	func instructions(gvar: [String], arry: [String], giri: [String], locals: [String], args: [String], locations: [String : Int]) -> (instructions: [XGScriptInstruction]?, error: String?) {
		
		func getLevelIndexForVariable(variable: String) -> (level: Int, index: Int)? {
			if variable == kXDSLastResultVariable {
				return (2,0)
			} else if gvar.contains(variable) {
				return (0, gvar.index(of: variable)!)
			} else if arry.contains(variable) {
				return (3, arry.index(of: variable)! + 0x200)
			} else if giri.contains(variable) {
				return (3, giri.index(of: variable)! + 0x80)
			} else if locals.contains(variable) {
				return (1, (0x10000 - locals.index(of: variable)!) & 0xFFFF)
			} else if args.contains(variable) {
				return (1, args.index(of: variable)! + 1)
			} else if let classInfo = XGScriptClassesInfo.getClassNamed(variable) {
				return (3, classInfo.index)
			} else {
				return nil
			}
		}
		
		switch self {
			
		case .nop:
			return ([XGScriptInstruction.nopInstruction()], nil)
		case .bracket(let e):
			return e.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
		case .unaryOperator(let id, let es):
			let (subs, err) = es.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			if err == nil {
				return (subs! + [XGScriptInstruction.xdsoperator(op: id)], nil)
			} else {
				return (nil, err)
			}
			
			
		case .binaryOperator(let id, let e1, let e2):
			let (subs1, err1) = e1.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			let (subs2, err2) = e2.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			if subs1 != nil && subs2 != nil {
				return (subs1! + subs2! + [XGScriptInstruction.xdsoperator(op: id)], nil)
			} else {
				if let err = err1 {
					return (nil, err)
				}
				return (nil, err2)
			}
			
			
		case .loadImmediate(let c):
			return ([XGScriptInstruction.loadImmediate(c: c)], nil)
		case .macroImmediate(let c, _):
			return XDSExpr.loadImmediate(c).instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			
			
		case .loadVariable(let variable):
			if let (level, index) = getLevelIndexForVariable(variable: variable) {
				return ([XGScriptInstruction.variableInstruction(op: .loadVariable, level: level, index: index)], nil)
			} else {
				return (nil, "Invalid variable name '\(variable)'.")
			}
			
			
		case .loadPointer(let variable):
			if let (level, index) = getLevelIndexForVariable(variable: variable) {
				return ([XGScriptInstruction.variableInstruction(op: .loadNonCopyableVariable, level: level, index: index)], nil)
			} else {
				return (nil, "Invalid variable name '\(variable)'.")
			}
			
		case .setVariable(let variable, let e):
			let (subs, error) = e.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			if subs == nil {
				return (nil, error)
			}
			
			if let (level, index) = getLevelIndexForVariable(variable: variable) {
				return (subs! + [XGScriptInstruction.variableInstruction(op: .setVariable, level: level, index: index)], nil)
			} else {
				return (nil, "Invalid variable name '\(variable)'.")
			}
			
			
		case .setVector(let variable, let dimension, let e):
			let (subs, error) = e.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			if subs == nil {
				return (nil, error)
			}
			
			if let (level, index) = getLevelIndexForVariable(variable: variable) {
				// vectors use level and dimension
				let levDim = level + (dimension.rawValue << 4)
				return (subs! + [XGScriptInstruction.variableInstruction(op: .setVector, level: levDim, index: index)], nil)
			} else {
				return (nil, "Invalid variable name '\(variable)'.")
			}
			
			
		case .call(let name, let params):
			var paramInstructions = [XGScriptInstruction]()
			for param in params {
				let (subs, error) = param.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
				if subs == nil {
					return (nil, error)
				}
				paramInstructions = subs! + paramInstructions
			}
			
			if locations[name] == nil {
				return (nil, "Function '\(name)' doesn't exist.")
			}
			
			let currentInstruction = XGScriptInstruction.call(location: locations[name]!)
			let lastResult = XGScriptInstruction.loadVarLastResult()
			return (paramInstructions + [currentInstruction, lastResult], nil)
			
		case .callVoid(let name, let params):
			var paramInstructions = [XGScriptInstruction]()
			for param in params {
				let (subs, error) = param.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
				if subs == nil {
					return (nil, error)
				}
				paramInstructions = subs! + paramInstructions
			}
			
			if locations[name] == nil {
				return (nil, "Function '\(name)' doesn't exist.")
			}
			
			let currentInstruction = XGScriptInstruction.call(location: locations[name]!)
			return (paramInstructions + [currentInstruction], nil)
			
		case .XDSReturn:
			let releaseInstruction = XGScriptInstruction.release(count: locals.count)
			let returnInstruction = XGScriptInstruction.xdsreturn()
			return ([releaseInstruction, returnInstruction], nil)
			
		case .XDSReturnResult(let e):
			let (subs, error) = XDSExpr.setVariable(kXDSLastResultVariable, e).instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			if subs == nil {
				return (nil, error)
			}
			
			let releaseInstruction = XGScriptInstruction.release(count: locals.count)
			let returnInstruction = XGScriptInstruction.xdsreturn()
			return (subs! + [releaseInstruction, returnInstruction], nil)
			
		case .callStandard(let c, let f, let params):
			var paramInstructions = [XGScriptInstruction]()
			for param in params {
				let (subs, error) = param.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
				if subs == nil {
					return (nil, error)
				}
				paramInstructions = subs! + paramInstructions
			}
			
			let currentInstruction = XGScriptInstruction.functionCall(classID: c, funcID: f)
			let lastResult = XGScriptInstruction.loadVarLastResult()
			let pop = XGScriptInstruction.pop(count: params.count)
			return (paramInstructions + [currentInstruction, pop, lastResult], nil)
			
		case .callStandardVoid(let c, let f, let params):
			var paramInstructions = [XGScriptInstruction]()
			for param in params {
				let (subs, error) = param.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
				if subs == nil {
					return (nil, error)
				}
				paramInstructions = subs! + paramInstructions
			}
			
			let currentInstruction = XGScriptInstruction.functionCall(classID: c, funcID: f)
			let pop = XGScriptInstruction.pop(count: params.count)
			return (paramInstructions + [currentInstruction, pop], nil)
			
		case .jumpTrue(let e, let location):
			let (subs, err) = e.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			if subs != nil {
				if locations[location] == nil {
					return (nil, "Location '\(location)' doesn't exist.")
				}
				
				return (subs! + [XGScriptInstruction.jump(op: .jumpIfTrue, location: locations[location]!)], nil)
			} else {
				return (nil, err)
			}
			
			
		case .jumpFalse(let e, let location):
			let (subs, err) = e.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
			if subs != nil {
				if locations[location] == nil {
					return (nil, "Location '\(location)' doesn't exist.")
				}
				
				return (subs! + [XGScriptInstruction.jump(op: .jumpIfFalse, location: locations[location]!)], nil)
			} else {
				return (nil, err)
			}
			
			
		case .jump(let location):
			if locations[location] == nil {
				return (nil, "Location '\(location)' doesn't exist.")
			}
			
			return ([XGScriptInstruction.jump(op: .jump, location: locations[location]!)], nil)
			
			
		case .reserve(let count):
			return ([XGScriptInstruction.reserve(count: count)], nil)
			
			
		// don't output any code for locations. they're just used for reference by the compiler
		case .location(_):
			return ([], nil)
		case .locationIndex(_):
			return ([], nil)
			
			
		case .function(let name, _):
			return ([XGScriptInstruction.reserve(count: locals.count)], nil)
			
		// shouldn't be able to access these through the script compiler but for completion sake:
		case .comment(_):
			return ([], nil)
		case .macro(_, _):
			return ([], nil)
		case .msgMacro(let string):
			let constant = XDSConstant(type: 1, rawValue: UInt32(string.id))
			return ([XGScriptInstruction.loadImmediate(c: constant)],nil)
		case .exit:
			return ([XGScriptInstruction(opCode: .exit, subOpCode: 0, parameter: 0)],nil)
		case .setLine(let index):
			return ([XGScriptInstruction(opCode: .setLine, subOpCode: 0, parameter: index)],nil)
		}
	}
	
}










