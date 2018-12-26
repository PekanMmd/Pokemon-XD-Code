//
//  XDSExpr.swift
//  Revolution Tool CL
//
//  Created by The Steez on 26/12/2018.
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
	case locationSilent(XDSLocation) // used for convenience but not printed as part of the script
	case locationIndex(Int)
	case functionDefinition(XDSLocation, [XDSVariable])
	case function(XDSExpr, [XDSExpr])
	case ifStatement([(XDSExpr, [XDSExpr])])
	case whileLoop(XDSExpr, [XDSExpr])
	case comment(String)
	case macro(XDSMacro, String)
	case msgMacro(XGString)
	case exit
	case setLine(Int)
	case unknown18(UInt32)
	case loadShortImmediate(XDSConstant)
	
	var isLoadImmediate : Bool {
		return self.xdsID == XDSExpr.loadImmediate(XDSConstant.null).xdsID
	}
	
	var isImmediate : Bool {
		return self.isLoadImmediate
	}
	
	var isVariable : Bool {
		return self.xdsID == XDSExpr.loadVariable("").xdsID || self.xdsID == XDSExpr.loadPointer("").xdsID
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
		case .unknown18:
			id += 1
			fallthrough
		case .loadShortImmediate:
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
		case .locationSilent:
			id += 1
			fallthrough
		case .locationIndex:
			id += 1
			fallthrough
		case .functionDefinition:
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
			id += 1
			fallthrough
		case .function:
			id += 1
			fallthrough
		case .ifStatement:
			id += 1
			fallthrough
		case .whileLoop:
			id += 1
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
		case .loadShortImmediate:
			fallthrough
		case .exit:
			fallthrough
		case .msgMacro:
			fallthrough
		case .location:
			fallthrough
		case .locationSilent:
			fallthrough
		case .locationIndex:
			fallthrough
		case .XDSReturn:
			return self
		case .callStandard:
			return self
		case .callStandardVoid:
			return self
		case .call:
			return self
		case .callVoid:
			return self
		case .ifStatement:
			return self
		case .whileLoop:
			return self
		case .function:
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
	
	var variable : XDSVariable? {
		switch self{
		case .loadVariable(let v):
			return v
		case .loadPointer(let v):
			return v
		default:
			return nil
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
		case .ifStatement(let es):
			for (c, subs) in es {
				constants += c.constants
				for sub in subs {
					constants += sub.constants
				}
			}
		case .whileLoop(let c, let es):
			constants += c.constants
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
		case .unknown18:
			return 1
		case .bracket(let e):
			return e.instructionCount
		case .unaryOperator(_, let e):
			return 1 + e.instructionCount
		case .binaryOperator(_, let e1, let e2):
			return 1 + e1.instructionCount + e2.instructionCount
		case .loadImmediate(let c):
			return (c.type.string == XDSConstantTypes.string.string) || c.type.string == XDSConstantTypes.vector.string ?  1 : 2
		case .loadShortImmediate:
			return 1
		case .loadVariable:
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
			var count = 2 // includes ldvar last result
			for e in es {
				count += e.instructionCount
			}
			// if it has params then also need an instruction for pop
			if es.count > 0 {
				count += 1
			}
			return count
		case .callStandardVoid(_, _, let es):
			var count = 1
			for e in es {
				count += e.instructionCount
			}
			// if it has params then also need an instruction for pop
			if es.count > 0 {
				count += 1
			}
			return count
		case .jumpTrue(let e, _):
			return 1 + e.instructionCount
		case .jumpFalse(let e, _):
			return 1 + e.instructionCount
		case .jump:
			return 1
		case .loadPointer:
			return 1
		case .reserve:
			return 1
		case .locationIndex(let i):
			return XDSExpr.location(XDSExpr.locationWithIndex(i)).instructionCount
		case .location:
			return 0
		case .locationSilent:
			return 0
		case .functionDefinition:
			return 1 // includes reserve
		case .exit:
			return 1
		case .setLine:
			return 1
		case .comment:
			return 0
		case .macro:
			return 0
		case .msgMacro:
			return 2 // load immediate msgid
		case .function(let def, let es):
			var count = def.instructionCount
			for e in es {
				count += e.instructionCount
			}
			return count
		case .ifStatement(let es):
			var count = 0
			
			for (c, subs) in es {
				count += c.instructionCount
				for sub in subs {
					count += sub.instructionCount
				}
			}
			
			return count
		case .whileLoop(let c, let es):
			var count = 0
			
			count += c.instructionCount
			for e in es {
				count += e.instructionCount
			}
			
			return count
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
	
	var macroRawValue : String {
		switch self {
		case .macro(_, let s):
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
	
	static func indexForLocation(_ l: XDSLocation) -> Int {
		return l.replacingOccurrences(of: "@location_", with: "").integerValue ?? -1
	}
	
	var text : [String] {
		switch self {
			
		// ignore these instructions
		case .nop:
			fallthrough
		case .reserve(_):
			fallthrough
		case .setLine(_):
			return [""]
			
		case .unknown18(let u):
			return ["unknownInstruction(\(u.hexString()))"]
			
		// variables and primitives
		case .loadImmediate(let c):
			return [c.rawValueString]
		case .loadShortImmediate(let c):
			return [c.rawValueString]
		case .loadVariable(let v):
			return [v]
		case .loadPointer(let s):
			return [s]
			
		// operations
		case .bracket(let e):
			return ["(" + e.text[0] + ")"]
		case .unaryOperator(let o,let e):
			return [XGScriptClass.operators[o].name + e.forcedBracketed.text[0]]
		case .binaryOperator(let o, let e1, let e2):
			return [e1.text[0] + " \(XGScriptClass.operators[o].name) " + e2.text[0]]
			
		// assignments
		case .setVariable(let v, let e):
			return [v + " = " + e.text[0]]
		case .setVector(let v, let d, let e):
			return [v + "." + d.string + " = " + e.text[0]]
			
		// function calls
		case .functionDefinition(let name, let params):
			var s = "function " + name + "("
			
			var firstParam = true
			for param in params {
				s += (firstParam ? "" : " ") + param
				firstParam = false
			}
			s += ")"
			return [s]
		case .call(let l, let params):
			return XDSExpr.callVoid(l, params).text
		case .callVoid(let l, let params):
			var s = l + "("
			
			var firstParam = true
			for param in params {
				s += (firstParam ? "" : " ") + param.text[0]
				firstParam = false
			}
			s += ")"
			return [s]
		case .callStandard(let c, let f, let es):
			return XDSExpr.callStandardVoid(c, f, es).text
		case .callStandardVoid(let c, let f, let es):
			// array get
			if c == 7 && f == 16 {
				
				return [es[0].text[0] + "[" + es[1].text[0] + "]"]
				
				// array set
			} else if c == 7 && f == 17 {
				
				return [es[0].text[0] + "[" + es[1].text[0] + "] = " + es[2].text[0]]
				
			} else {
				let xdsclass = XGScriptClass.classes(c)
				let xdsfunction = xdsclass[f]
				var s = ""
				// local variables and function parameters need additional class info
				if c > 0 {
					s += xdsclass.name + "."
				}
				s += xdsfunction.name + "("
				for i in 0 ..< es.count {
					let e = es[i]
					s += (i == 0 ? "" : " ") + e.text[0]
				}
				s += ")"
				return [s]
			}
			
		// control flow
		case .location(let l):
			return [l]
		case .locationSilent:
			return []
		case .locationIndex(let i):
			return [XDSExpr.locationWithIndex(i)]
		case .jumpTrue(let e, let l):
			return ["goto " + l + " if " + e.text[0]]
		case .jumpFalse(let e, let l):
			return ["goto " + l + " ifnot " + e.text[0]]
		case .jump(let l):
			return ["goto " + l]
		case .XDSReturn:
			return ["return"]
		case .XDSReturnResult(let e):
			return ["return " + e.text[0]]
		case .exit:
			return ["exit"]
			
		// convenience
		case .comment(let s):
			return [s]
		case .macro(let s, let t):
			return ["define " + s + " " + t]
		case .msgMacro(let x):
			return [XDSExpr.macroForString(xs: x)]
			
		// compound statements
		case .function(let def, let es):
			var s = [def.text[0] + " {\n\n"]
			for e in es {
				
				switch e {
				case .ifStatement:
					s[s.count - 1] = s[s.count - 1] + "\n"
				case .whileLoop:
					s[s.count - 1] = s[s.count - 1] + "\n"
				default:
					break
				}
				
				let lines = e.text
				var newLine = lines.count == 1 ? "\n" : ""
				if lines.count == 0 {
					newLine = ""
				}
				for line in lines {
					s += ["    " + line + newLine]
				}
			}
			s += ["\n}\n"]
			return s
			
		case .ifStatement(let es):
			let parts = es.count
			var lines = [String]()
			
			for i in 0 ..< parts {
				let (condition, exprs) = es[i]
				var keyword = "else"
				if i == 0 {
					keyword = "if"
				}
				
				var conditionText = ""
				switch condition {
				case .jumpFalse(.loadImmediate(let c), _):
					conditionText = (c.asInt == 0 ? "(NO)" : "(YES)")
				case .jumpFalse(let c, _):
					conditionText = c.forcedBracketed.text[0]
				case .jumpTrue(let c, _):
					conditionText = "!" + c.forcedBracketed.text[0]
				default:
					// TODO: get rid of this as it messes with instruction count
					// should always add condition as a jump
					conditionText = condition.text[0]
				}
				if i == 0 {
					lines += [keyword + " " + conditionText + " {\n"]
				} else {
					let last = lines.count - 1
					lines[last] = lines[last].replacingOccurrences(of: "\n", with: "") + " " + keyword + " {\n"
				}
				
				for i in 0 ..< exprs.count {
					let expr = exprs[i]
					let subLines = expr.text
					var newLine = subLines.count == 1 ? "\n" : ""
					if expr.text.count == 0 {
						newLine = ""
					}
					
					for subLine in expr.text {
						lines += ["    " + subLine + newLine]
					}
				}
				lines += ["}\n\n"]
			}
			
			return lines
			
		case .whileLoop(let condition, let exprs):
			
			var conditionText = ""
			switch condition {
			case .jumpFalse(.loadImmediate(let c), _):
				conditionText = (c.asInt == 0 ? "(NO)" : "(YES)")
			case .jumpFalse(let c, _):
				conditionText = c.bracketed.text[0]
			case .jumpTrue(let c, _):
				conditionText = "!" + c.forcedBracketed.text[0]
			default:
				// TODO: get rid of this as it messes with instruction count
				// should always add condition as a jump
				conditionText = condition.text[0]
			}
			var lines = ["while " + conditionText + " {\n"]
			
			for i in 0 ..< exprs.count {
				let expr = exprs[i]
				let subLines = expr.text
				var newLine = subLines.count == 0 ? "\n" : ""
				if expr.text.count == 0 {
					newLine = ""
				}
				
				for subLine in expr.text {
					lines += ["    " + subLine + newLine]
				}
			}
			lines += ["    }\n\n"]
			return lines
		}
	}
	
	var comment : XDSExpr? {
		return nil
	}
	
	var macroVariable : String? {
		switch self {
		case .bracket(let e):
			return e.macroVariable
		case .callStandard(7, 17, let es):
			return es[0].macroVariable
		case .callStandard(7, 16, let es):
			return es[0].macroVariable
		case .callStandard(let c, let f, _):
			return XGScriptClass.classes(c).classDotFunction(f)
		case .loadVariable(let v):
			return v
		case .loadPointer(let v):
			return v
		case .call(let l, _):
			return l
		default:
			return nil
		}
	}
	
	var paramMacroVariables : [String?] {
		switch self {
		case .call(_, let es):
			return es.map { (e) -> String? in
				return e.macroVariable
			}
		case .callStandard(7, 17, let es):
			return [es[2].macroVariable]
		case .callStandard(_, _, let es):
			return es.map({ (e) -> String? in
				return e.macroVariable
			})
		case .bracket(let e):
			return e.paramMacroVariables
		case .callVoid(_, let es):
			return es.map { (e) -> String? in
				return e.macroVariable
			}
		case .callStandardVoid(_, _, let es):
			return es.map({ (e) -> String? in
				return e.macroVariable
			})
		default:
			return []
		}
	}
	
	var macros : [XDSExpr] {
		switch self {
			
		case .bracket(let e):
			return e.macros
		case .unaryOperator(_, let e):
			return e.macros
		case .binaryOperator(_, let e1, let e2):
			return e1.macros + e2.macros
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
		case .function(let def, let es):
			var macs = def.macros
			for e in es {
				macs += e.macros
			}
			return macs
		case .whileLoop(let c, let es):
			var macs = c.macros
			for e in es {
				macs += e.macros
			}
			return macs
		case .ifStatement(let parts):
			var macs = [XDSExpr]()
			for (c, es) in parts {
				macs += c.macros
				for e in es {
					macs += e.macros
				}
				return macs
			}
			return macs
		default:
			return []
		}
	}
	
	var items : [XGItems] {
		switch self {
			
		case .bracket(let e):
			return e.items
		case .unaryOperator(_, let e):
			return e.items
		case .binaryOperator(_, let e1, let e2):
			return e1.items + e2.items
		case .XDSReturnResult(let e):
			return e.items
		case .callStandard(_, _, let es):
			var macs = [XGItems]()
			for e in es {
				macs += e.items
			}
			return macs
		case .callStandardVoid(_, _, let es):
			var macs = [XGItems]()
			for e in es {
				macs += e.items
			}
			return macs
		case .setVariable(_, let e):
			return e.items
		case .setVector(_, _, let e):
			return e.items
		case .call(_, let es):
			var macs = [XGItems]()
			for e in es {
				macs += e.items
			}
			return macs
		case .callVoid(_, let es):
			var macs = [XGItems]()
			for e in es {
				macs += e.items
			}
			return macs
		case .jumpTrue(let e, _):
			return e.items
		case .jumpFalse(let e, _):
			return e.items
		case .function(let def, let es):
			var macs = def.items
			for e in es {
				macs += e.items
			}
			return macs
		case .whileLoop(let c, let es):
			var macs = c.items
			for e in es {
				macs += e.items
			}
			return macs
		case .ifStatement(let parts):
			var macs = [XGItems]()
			for (c, es) in parts {
				macs += c.items
				for e in es {
					macs += e.items
				}
				return macs
			}
			return macs
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
				return (1, (0x10000 - (locals.index(of: variable)! + 1)) & 0xFFFF)
			} else if args.contains(variable) {
				return (1, args.index(of: variable)! + 1)
			} else if let classInfo = XGScriptClass.getClassNamed(variable) {
				return (3, classInfo.index)
			} else {
				return nil
			}
		}
		
		switch self {
		
		case .unknown18(let u):
			return ([XGScriptInstruction(bytes: u, next: 0)] , nil)
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
			
		case .loadVariable(let variable):
			if let (level, index) = getLevelIndexForVariable(variable: variable) {
				return ([XGScriptInstruction.variableInstruction(op: .loadVariable, level: level, index: index)], nil)
			} else {
				return (nil, "Invalid variable name '\(variable)'.")
			}
			
		case .loadShortImmediate(let c):
			return ([XGScriptInstruction(opCode: .loadShortImmediate, subOpCode: c.type.index, parameter: c.asInt)], nil)
			
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
			
			var currentInstructions = [XGScriptInstruction.call(location: locations[name]!)]
			if params.count > 0 {
				currentInstructions += [XGScriptInstruction.pop(count: params.count)]
			}
			currentInstructions += [XGScriptInstruction.loadVarLastResult()]
			return (paramInstructions + currentInstructions, nil)
			
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
			
			var currentInstructions = [XGScriptInstruction.call(location: locations[name]!)]
			if params.count > 0 {
				currentInstructions += [XGScriptInstruction.pop(count: params.count)]
			}
			return (paramInstructions + currentInstructions, nil)
			
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
			
			var currentInstructions = [XGScriptInstruction.functionCall(classID: c, funcID: f)]
			if params.count > 0 {
				currentInstructions += [XGScriptInstruction.pop(count: params.count)]
			}
			currentInstructions += [XGScriptInstruction.loadVarLastResult()]
			return (paramInstructions + currentInstructions, nil)
			
		case .callStandardVoid(let c, let f, let params):
			var paramInstructions = [XGScriptInstruction]()
			for param in params {
				let (subs, error) = param.instructions(gvar:gvar,arry:arry,giri:giri,locals:locals,args:args,locations:locations)
				if subs == nil {
					return (nil, error)
				}
				paramInstructions = subs! + paramInstructions
			}
			
			var currentInstructions = [XGScriptInstruction.functionCall(classID: c, funcID: f)]
			if params.count > 0 {
				currentInstructions += [XGScriptInstruction.pop(count: params.count)]
			}
			return (paramInstructions + currentInstructions, nil)
			
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
			
		case .function(let def, let es):
			var list = [XGScriptInstruction]()
			
			for expr in [def] + es {
				let (subs, err) = expr.instructions(gvar: gvar, arry: arry, giri: giri, locals: locals, args: args, locations: locations)
				if subs != nil {
					list += subs!
				} else {
					return (nil, err)
				}
			}
			return (list, nil)
			
		case .whileLoop(let c, let es):
			var list = [XGScriptInstruction]()
			
			for expr in [c] + es {
				let (subs, err) = expr.instructions(gvar: gvar, arry: arry, giri: giri, locals: locals, args: args, locations: locations)
				if subs != nil {
					list += subs!
				} else {
					return (nil, err)
				}
			}
			return (list, nil)
			
		case .ifStatement(let parts):
			var list = [XGScriptInstruction]()
			
			for (c, es) in parts {
				for expr in [c] + es {
					let (subs, err) = expr.instructions(gvar: gvar, arry: arry, giri: giri, locals: locals, args: args, locations: locations)
					if subs != nil {
						list += subs!
					} else {
						return (nil, err)
					}
				}
			}
			return (list, nil)
			
		// don't output any code for locations. they're just used for reference by the compiler
		case .location:
			return ([], nil)
		case .locationSilent:
			return ([], nil)
		case .locationIndex:
			return ([], nil)
			
			
		case .functionDefinition:
			return ([XGScriptInstruction.reserve(count: locals.count)], nil)
			
		// shouldn't be able to access these through the script compiler but for completion sake:
		case .comment:
			return ([], nil)
		case .macro:
			return ([], nil)
		case .msgMacro(let string):
			let constant = XDSConstant.integer(string.id)
			return ([XGScriptInstruction.loadImmediate(c: constant)],nil)
		case .exit:
			return ([XGScriptInstruction(opCode: .exit, subOpCode: 0, parameter: 0)],nil)
		case .setLine(let index):
			return ([XGScriptInstruction(opCode: .setLine, subOpCode: 0, parameter: index)],nil)
		}
	}
	
}
