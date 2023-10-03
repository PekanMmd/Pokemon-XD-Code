//
//  CMSExpr.swift
//  GoD Tool
//
//  Created by Stars Momodu on 03/06/2021.
//

import Foundation

typealias CMSVariable = String
typealias CMSMacro = String
typealias CMSLocation = Int

enum CMSConstant: CustomStringConvertible {
	case void(Int), integer(Int), float(Float)
	case unknownType(typeID: Int, value: Int)

	var description: String {
		switch self {
		case .void(_):
			return "null"
		case .integer(let raw):
			return "\(raw < 0x100 ? raw.string : raw.hexString())"
		case .float(let raw):
			return "\(raw)"
		case .unknownType(let typeID, let value):
			return "Type\(typeID)(\(value))"
		}
	}

	var integerValue: Int {
		switch self {
		case .void(let i), .integer(let i), .unknownType(_, value: let i):
			return i
		case .float(let f):
			return Int(f)
		}
	}
}

indirect enum CMSExpr {

	case nop
	case bracket(CMSExpr) // Adds brackets () around the sub expression

	case constant(CMSConstant) // Just an integer or float literal
	case macroDefinition(CMSMacro, String) // a line assigning a value to a macro
	case macroConstant(CMSConstant, CMSMacroTypes) // a constant value that has been replaced by a macro
	case msgMacroConstant(XGString) // a special macro for integers representing msg ids which have the string included in the macro
	case scriptFunctionConstant(Int, Int) // a special macro for integers representing a function index in a script

	case variable(CMScriptVar, CMSExpr) // global variables, local variables, function arguments or raw value on top of the stack
	case variableAssignment(CMSExpr, CMSExpr) // assign the result of an expression to a variable
	case structAssignment(CMSExpr, CMSExpr, Int) // assign a range of contiguous values of the specified length from one variable to another

	case operation(CMSOperators, [CMSExpr]) // apply a unary or binary operator to the sub expression(s) +, -, *, &, ==, <, !, etc.
	case call(Int, [CMSExpr]) // calls a function defined in a script with the sub expressions passed as arguments
	case callBuiltIn(Int, [CMSExpr]) // calls a function built into the game engine with the sub expressions passed as arguments
	case print(String, [CMSExpr]) // a special function that prints a string with optional sub expressions for interpolation
	case yield(CMSExpr) // a special function which pauses code execution for a given number of frames

	case CMSReturn // regular return
	case CMSReturnResult(CMSExpr) // return the result of the sub expression

	case jumpFalse(CMSExpr, CMSLocation) // used for branched logic. The code from a goto to its location represent if, while type logic
	case location(CMSLocation) // the target of a goto statement
	case silentLocation(CMSLocation) // locations that aren't printed because the goto + location are replaced with if, else, while, etc.
	case jump(CMSLocation) // forced jump to a different location. Typically used for while loops or else statements

	case functionDefinition(String, [CMSVariable]) // the first line of a function specifying its name and declaring its arguments
	case function(CMSExpr, [CMSExpr]) // the definition of a function and the block of sequential statements in it
	case ifStatement([(CMSExpr, [CMSExpr])]) // the condition for the statement and the block of sequential statements if the condition is met
	case whileLoop(CMSExpr, [CMSExpr]) // the condition for the loop and the block of sequential statements while the condition is met

	case commentSingleLine(String) // represents a comment to be ignored by the compiler
	case commentMultiLine(String) // represents a comment to be ignored by the compiler
	case error(String) // an expression used when there's an error but still acts as though it's a normal expression and will be printed in the decompiled code for easier debugging

	case exit // possibly only used to mark the very end of an entire script file. Unsure if this ever actually used within a function

	func unbracketed() -> CMSExpr {
		switch self {
		case .bracket(let expr):
			return expr.unbracketed()
		default:
			return self
		}
	}

	var isVariable: Bool {
		switch self {
		case .variable: return true
		default: return false
		}
	}

	var isFullStatement: Bool {
		// A statement that performs some kind of action when on a line on its own
		switch self.unbracketed() {
		case .nop, .variable, .constant, .location, .silentLocation, .commentSingleLine, .commentMultiLine, .macroConstant, .msgMacroConstant:
			return false
		default:
			return true
		}
	}

	var macroName: String {
		switch self {
		case .macroDefinition(let s, _):
			return s
		default:
			return ""
		}
	}

	var macroRawValue: String {
		switch self {
		case .macroDefinition(_, let s):
			return s
		default:
			return ""
		}
	}

	var comment: CMSExpr? {
		switch self {
		case .callBuiltIn(102, let exprs), .callBuiltIn(152, let exprs):
			if !fileDecodingMode,
			   case .macroConstant(.integer(let battleID), .battleID) = exprs[0],
			   let battle = XGBattle(index: battleID) {
				return .commentMultiLine(battle.description)
			}
			return nil
		default:
			return nil
		}
	}

	func text(script: XGScript?) -> String {
		switch self {
		case .nop:
			return ""
		case .bracket(let expr):
			return "(\(expr.text(script: script)))"
		case .operation(let op, let exprs):
			switch exprs.count {
			case 1: return "\(op)\(exprs[0].text(script: script))"
			case 2: return "\(exprs[1].text(script: script)) \(op) \(exprs[0].text(script: script))"
			default: return CMSExpr.error("Invalid operation: \(op) \(exprs.map{$0.text(script: script)})").text(script: script)
			}
		case .constant(let constant):
			return constant.description
		case .variable(let descriptor, let valueExpression):
			var isValidExpression = false
			var argValue = ""
			var arrayIndexValue: String?
			switch valueExpression.unbracketed() {
			case .constant(.integer(let value)):
				isValidExpression = true
				argValue = "\(value)"
			case .constant(.float), .macroConstant, .msgMacroConstant, .scriptFunctionConstant:
				isValidExpression = descriptor.isLiteral
			case .operation(.add, let subExprs):
				if descriptor.isGlobalVar {
					arrayIndexValue = subExprs[1].text(script: script)
					argValue = subExprs[0].text(script: script)
				}
				fallthrough
			case .operation:
				isValidExpression = descriptor.isGlobalVar || descriptor.isLiteral
			case .callBuiltIn, .call:
				isValidExpression = descriptor.isLiteral
			case .variable:
				isValidExpression = descriptor.isGlobalVar || descriptor.isLiteral
				if descriptor.isGlobalVar {
					argValue = valueExpression.text(script: script)
				}
			default:
				isValidExpression = false
			}
			guard isValidExpression else {
				printg("Error: Unexpected variable \(descriptor), \(valueExpression.text(script: script))")
				return CMSExpr.error("Unexpected variable: \(descriptor), \(valueExpression.text(script: script))").text(script: script)
			}

			if descriptor.isGlobalVar {
				if let arrayIndex = arrayIndexValue {
					return "gvar\(arrayIndex)[\(argValue)]"
				} else {
					return "gvar\(argValue)"
				}
			} else if descriptor.isLocalVar {
				return "arg\(argValue)"
			} else if descriptor.isLiteral {
				return "\(valueExpression.text(script: script))"
			}
			printg("Error: Unexpected variable \(descriptor), \(valueExpression.text(script: script))")
			return CMSExpr.error("Unexpected variable: \(descriptor), \(valueExpression.text(script: script))").text(script: script)
		case .variableAssignment(let variable, let expr):
			return "\(variable.text(script: script)) = \(expr.text(script: script))"
		case .structAssignment(let var1, let var2, let length):
			return "\(var1.text(script: script))[0:\(length)] = \(var2.text(script: script))[0:\(length)]"
		case .call(let functionIndex, let exprs):
			var text = "function\(functionIndex)("
			for expr in exprs {
				text += "\(expr.text(script: script)), "
			}
			if exprs.count > 0 {
				text.removeLast(); text.removeLast()
			}
			text += ")"
			return text
		case .CMSReturn:
			return "return"
		case .CMSReturnResult(let expr):
			return "return \(expr.text(script: script))"
		case .callBuiltIn(let functionIndex, let exprs):
			var text = "function\(functionIndex)("
			if let functionName = ScriptBuiltInFunctions[functionIndex]?.name {
				text = "\(functionName)("
			}
			for expr in exprs {
				text += "\(expr.text(script: script)), "
			}
			if exprs.count > 0 {
				text.removeLast(); text.removeLast()
			}
			text += ")"

			if let comment = self.comment {
				switch comment {
				case .commentMultiLine:
					text += "\n" + comment.text(script: nil) + "\n"
				case .commentSingleLine:
					text += comment.text(script: nil) + "n"
				default:
					assertionFailure("Comment should be either a single or multiline comment")
					text += "\n"
				}
			}

			return text
		case .location(let value):
			return "@location_\(value.hex())"
		case .silentLocation(_):
			return ""
		case .jumpFalse(let condition, let location):
			return "goto \(CMSExpr.location(location).text(script: script)) ifnot \(condition.text(script: script))"
		case .jump(let location):
			return "goto \(CMSExpr.location(location).text(script: script))"
		case .functionDefinition(let functionName, let argNames):
			var text = "function \(functionName)("
			for name in argNames {
				text += "\(name), "
			}
			if argNames.count > 0 {
				text.removeLast(); text.removeLast()
			}
			text += ")"
			return text
		case .function(let definition, let exprs):
			var text = "\(definition.text(script: script)) {\n"
			for expression in exprs {
				for line in expression.text(script: script).split(separator: "\n") {
					text += "    \(line)\n"
				}
			}
			return text + "}\n\n"
		case .print(let string, let args):
			var text = "System.printf(\"\(string)\""
			for arg in args {
				text += ", \(arg.text(script: script))"
			}
			text += ")"
			return text
		case .yield(let frames):
			return "System.yield(\(frames.text(script: script)))"
		case .ifStatement(let blocks):
			let parts = blocks.count
			var lines = [String]()

			for i in 0 ..< parts {
				let (condition, exprs) = blocks[i]
				var keyword = "else if"
				if i == 0 {
					keyword = "if"
				}

				var conditionText: String?
				switch condition {
				case .nop: // is else statement with no condition
					if i > 0 {
						keyword = "else"
					} else {
						assertionFailure("The if statement needs a condition")
					}
				case .jumpFalse(let c, _):
					conditionText = "(\(c.text(script: script)))"
				default:
 					assertionFailure("Make sure to always have a jump false as condition")
				}
				if i == 0 {
					lines += [keyword + " " + (conditionText ?? "") + " {\n"]
				} else {
					let last = lines.count - 1
					lines[last] = lines[last].replacingOccurrences(of: "\n", with: "") + " " + keyword + (conditionText == nil ? "" : " ") + (conditionText ?? "") + " {\n"
				}

				for expr in exprs {
					let subText = "\(expr.text(script: script))"
					for line in subText.split(separator: "\n") {
						lines.append("    \(line)\n")
					}
				}
				lines += ["}\n\n"]
			}

			return lines.joined(separator: "\n")
		case .whileLoop(let condition, let exprs):
			let text = CMSExpr.ifStatement([(condition, exprs)]).text(script: script)
			let spliced = text.substring(from: 2, to: text.length)
			return "while" + spliced
		case .commentMultiLine(let text):
			var commentText = "/*\n"
			for line in text.split(separator: "\n") {
				commentText += " * \(line)\n"
			}
			return commentText + "\n */"
		case .commentSingleLine(let text):
			return "// " + text
		case .macroDefinition(let macroName, let rawValue):
			return "define \(macroName) \(rawValue)"
		case .macroConstant(let constant, let type):
			return type.textForValue(constant, script: script)
		case .msgMacroConstant(let string):
			return CMSExpr.macroForString(xs: string)
		case .scriptFunctionConstant(let type, let index):
			switch type {
			case 0:
				return "Null"
			case 0x596:
				return "Common.script\(index)"
			case 0x100:
				return "script\(index)"
			default:
				return CMSExpr.error("Function call to unknown script: \(type), function: \(index)").text(script: script)
			}
		case .exit:
			return "exit"
		case .error(let text):
			return ">>Error: \(text)"
		}
	}

	func updateMacroTypes(withType type: CMSMacroTypes? = nil, script: XGScript?) -> (updatedExpr: CMSExpr, updatedType: CMSMacroTypes?, macroConstants: [CMSExpr]) {
		switch self {
		case .bracket(let subExpr):
			let (newSub, updatedType, constants) = subExpr.updateMacroTypes(withType: type, script: script)
			return (.bracket(newSub),updatedType, constants)
		case .macroConstant(let constant, let type):
			let constants = type.needsDefine ? [CMSExpr.macroDefinition(self.macroName,type.textForValue(constant, script: script))] : []
			return (self, type, constants)
		case .msgMacroConstant(_):
			return (self, .msgID, [])
		case .operation(let operatorValue, let subs):
			let operatorOverrideType = operatorValue.forcedReturnType
			let typeToSet = operatorOverrideType != nil ? nil : type
			if subs.count == 1 {
				let (newSub, updatedType, constants) = subs[0].updateMacroTypes(withType: typeToSet, script: script)
				return (.operation(operatorValue, [newSub]), operatorOverrideType ?? updatedType, constants)
			} else if subs.count == 2 {
				let (newSub1, updatedType1, constants1) = subs[0].updateMacroTypes(withType: typeToSet, script: script)
				let (newSub2, updatedType2, constants2) = subs[1].updateMacroTypes(withType: typeToSet, script: script)
				if updatedType1 != nil, updatedType2 == nil {
					let (newSub2, _, constants2) = subs[1].updateMacroTypes(withType: updatedType1, script: script)
					return (.operation(operatorValue, [newSub1, newSub2]), operatorOverrideType ?? updatedType1, constants1 + constants2)
				} else if updatedType2 != nil, updatedType1 == nil {
					let (newSub1, _, constants1) = subs[0].updateMacroTypes(withType: updatedType2, script: script)
					return (.operation(operatorValue, [newSub1, newSub2]), operatorOverrideType ?? updatedType2, constants1 + constants2)
				} else {
					return (.operation(operatorValue, [newSub1, newSub2]), operatorOverrideType ?? updatedType1, constants1 + constants2)
				}
			} else {
				return (self, operatorOverrideType, [])
			}
		case .constant(.integer(let constant)):
			switch type {
			case .msgID:
				let string = script?.stringTable?.stringWithID(constant) ?? getStringSafelyWithID(id: constant)
				return (.msgMacroConstant(string), .msgID, [])
			case .scriptFunction:
				return (.scriptFunctionConstant(constant >> 16, constant & 0xFFFF), .scriptFunction, [])
			default:
				if let newType = type {
					let newExpr = newType.needsMacro ? CMSExpr.macroConstant(.integer(constant), newType) : self
					return (newExpr, newType, newType.needsDefine ? [CMSExpr.macroDefinition(newType.textForValue(.integer(constant), script: script), "\(self.text(script: script))")] : [])
				} else {
					return (self, nil, [])
				}
			}
		case .variable(let variableType, let sub):
			if variableType.isLiteral {
				let (newSub, newType, constants) = sub.updateMacroTypes(withType: type, script: script)
				return (.variable(variableType, newSub), newType, constants)
			} else {
				return (self, nil, [])
			}
		case .variableAssignment(let sub1, let sub2):
			let (newSub1, _, constants1) = sub1.updateMacroTypes(withType: type, script: script)
			let (newSub2, _, constants2) = sub2.updateMacroTypes(withType: type, script: script)
			return (.variableAssignment(newSub1, newSub2), nil, constants1 + constants2)
		case .structAssignment(let sub1, let sub2, let length):
			let (newSub1, _, constants1) = sub1.updateMacroTypes(withType: type, script: script)
			let (newSub2, _, constants2) = sub2.updateMacroTypes(withType: type, script: script)
			return (.structAssignment(newSub1, newSub2, length), nil, constants1 + constants2)
		case .call(let index, let subs):
			var constants = [CMSExpr]()
			let newSubs = subs.map { (sub) -> CMSExpr  in
				let (newSub, _, newConstants) = sub.updateMacroTypes(withType: type, script: script)
				constants += newConstants
				return newSub
			}
			return (.call(index, newSubs), nil, constants)
		case .callBuiltIn(let index, let subs):
			var returnType: CMSMacroTypes?
			var newSubs = [CMSExpr]()
			var newConstants = [CMSExpr]()
			for i in 0 ..< subs.count {
				if let data = ScriptBuiltInFunctions[index],
				   let paramTypes = data.parameterTypes,
				   i < paramTypes.count,
				   paramTypes[i] != nil {
					let (newSub, _, newConstantValues) = subs[i].updateMacroTypes(withType: paramTypes[i], script: script)
					newSubs.append(newSub)
					newConstants += newConstantValues
				} else {
					let (newSub, _, newConstantValues) = subs[i].updateMacroTypes(script: script)
					newSubs.append(newSub)
					newConstants += newConstantValues
				}
			}

			returnType = ScriptBuiltInFunctions[index]?.returnType
			return (.callBuiltIn(index, newSubs), returnType, newConstants)
		case .print(let text, let subs):
			var constants = [CMSExpr]()
			let newSubs = subs.map { (sub) -> CMSExpr  in
				let (newSub, _, newConstants) = sub.updateMacroTypes(withType: type, script: script)
				constants += newConstants
				return newSub
			}
			return (.print(text, newSubs), nil, constants)
		case .yield(let sub):
			let (newSub, _, constants) = sub.updateMacroTypes(withType: type, script: script)
			return (.yield(newSub), nil, constants)
		case .CMSReturnResult(let sub):
			let (newSub, _, constants) = sub.updateMacroTypes(withType: type, script: script)
			return (.CMSReturnResult(newSub), nil, constants)
		case .jumpFalse(let condition, let location):
			let (newSub, _, constants) = condition.updateMacroTypes(withType: type, script: script)
			return (.jumpFalse(newSub, location), nil, constants)
		case .ifStatement(let blocks):
			var constants = [CMSExpr]()
			var newBlocks = [(CMSExpr, [CMSExpr])]()

			blocks.forEach { (condition, block) in
				let (newCondition, _, newConstants1) = condition.updateMacroTypes(withType: .bool, script: script)
				constants += newConstants1

				let newSubs = block.map { (sub) -> CMSExpr  in
					let (newSub, _, newConstants2) = sub.updateMacroTypes(withType: type, script: script)
					constants += newConstants2
					return newSub
				}

				newBlocks.append((newCondition, newSubs))
			}

			return (.ifStatement(newBlocks), nil, constants)

		case .whileLoop(let condition, let block):
			var constants = [CMSExpr]()

			let (newCondition, _, newConstants1) = condition.updateMacroTypes(withType: .bool, script: script)
			constants += newConstants1

			let newSubs = block.map { (sub) -> CMSExpr  in
				let (newSub, _, newConstants2) = sub.updateMacroTypes(withType: type, script: script)
				constants += newConstants2
				return newSub
			}
			return (.whileLoop(newCondition, newSubs), nil, constants)
		case .function(let definition, let block):
			var constants = [CMSExpr]()
			let newSubs = block.map { (sub) -> CMSExpr  in
				let (newSub, _, newConstants) = sub.updateMacroTypes(withType: type, script: script)
				constants += newConstants
				return newSub
			}
			return (.function(definition, newSubs), nil, constants)
		default:
			return (self, nil, [])
		}
	}

	static func macroWithName(_ name: String) -> String {
		return "#\(name)"
	}

	static func macroForString(xs: XGString) -> String {
		if xs.id == 0 {
			return "$:0:"
		}
		if xs.table == nil {
			return "$:\(xs.id):"
		}
		// must replace double quotes with special character since xds doesn't use escaped characters
		var updatedString = xs.string.replacingOccurrences(of: "\"", with: "[Quote]")
		updatedString = updatedString.replacingOccurrences(of: "\n", with: "[New Line]")
		return "$:\(xs.id):" + "\"\(updatedString)\""
	}
}

extension Array where Element == CMSExpr {
	var description: String {
		var text = ""
		for expr in self {
			text += "\(expr)\n"
		}
		if text.length > 0 {
			text.removeLast()
		}
		return text
	}
}
