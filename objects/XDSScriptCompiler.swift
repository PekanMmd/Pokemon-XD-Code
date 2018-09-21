//
//  XDSScriptCompiler.swift
//  GoDToolCL
//
//  Created by The Steez on 09/06/2018.
//

import Cocoa

var error = ""
class XDSScriptCompiler: NSObject {
	typealias XDSCode = [UInt32]
	
	static var chars  = [String]()
	static var gvars  = [String]()
	static var arrys  = [String]()
	static var vects  = [String]()
	static var strgs  = [String]()
	static var args   = [String]()
	static var locals = [String]()
	
	class func compile(text: String, toFile file: XGFiles) -> Bool {
		if let data = compile(text: text) {
			data.file = file
			data.save()
			return true
		}
		return false
	}
	
	class func getErrorString() -> String {
		return error
	}
	
	class func compile(text: String) -> XGMutableData? {
		
		gvars  = [String]()
		arrys  = [String]()
		vects  = [String]()
		strgs  = [String]()
		args   = [String]()
		locals = [String]()
		
		var stripped = stripComments(text: text)
		stripped = stripWhiteSpace(text: stripped)
		let macro = macroprocessor(text: stripped)
		
		if macro == nil {
			return nil
		}
		let lines = getLines(text: macro!)
		
		var expressions = [XDSExpr]()
		for line in lines {
			if let tokens = tokenise(line: line) {
				if let eval = evalTokens(tokens: tokens) {
					expressions.append(eval)
				} else {
					return nil
				}
			} else {
				return nil
			}
		}
		if let stack = createExprStack(expressions) {
			
			let ftbl = getFTBL(stack)
			let gvar = getGVAR(stack)
			let strg = getSTRG(stack)
			let vect = getVECT(stack)
			let giri = getGIRI(stack)
			let arry = getARRY(stack)
			let code = getCODE(stack, gvar: gvar.names, arry: arry.names, vect: vect.names, strg: strg, giri: giri.names)
			
			var data = XDSCode()
			data += compileFTBL(ftbl)
			data += compileHEAD(ftbl)
			data += compileCODE(code)
			data += compileGVAR(gvar.values)
			data += compileSTRG(strg)
			data += compileVECT(vect.values)
			data += compileGIRI(giri.values)
			data += compileARRY(arry.values)
			
			let size = data.count * 4
			data = compileTCOD(size: size) + data
			
			let compiled = XGMutableData()
			for datum in data {
				compiled.appendBytes(datum.charArray)
			}
			return compiled
		}
		return nil
	}
	
	private class func macroprocessor(text: String) -> String? {
		
		var updated = ""
		let lines = getLines(text: text)
		var macros = [(macro: XDSMacro, replacement: String)]()
		
		for line in lines {
			if let tokens = tokenise(line: line) {
				if tokens.count > 0 {
					if tokens[0] == "define" {
						if tokens.count >= 3 {
							let macro = tokens[1]
							var replacement = tokens[2]
							for i in 3 ..< tokens.count {
								replacement += " " + tokens[i]
							}
							macros.append((macro: macro, replacement: replacement))
						} else {
							error = "Incomplete define statement."
							for i in 0 ..< tokens.count {
								error += " " + tokens[i]
							}
							return nil
						}
					} else if tokens[0] == "assign" {
						let newTokens = tokens.map({ (token) -> String in
							var new = token
							for (macro, repl) in macros {
								new = new == macro ? repl : new
							}
							return new
						})
						if !handleAssignment(tokens: newTokens) {
							return nil
						}
					} else {
						var updatedLine = line
						for (macro, repl) in macros {
							for add in [" ", ".", ")", ">", "]", "\"", "\n"] {
								updatedLine = updatedLine.replacingOccurrences(of: macro + add, with: repl + add)
							}
						}
						updated += updatedLine
					}
				}
			} else {
				return nil
			}
		}
		
		return updated
	}
	
	private class func handleAssignment(tokens: [String]) -> Bool {
		//TODO: - handle assignments
		return true
	}
	
	class func stripWhiteSpace(text: String) -> String {
		
		var stripped = ""
		let stack = text.stack
		
		enum WhiteSpaceScopes {
			case space
			case newLine
			case string
			case normal
		}
		
		var scope = WhiteSpaceScopes.normal
		
		if !stack.isEmpty {
			var done = false
			while !done {
				if stack.peek() == "\n" {
					stack.pop()
				} else {
					done = true
				}
				if stack.isEmpty {
					done = true
				}
			}
		}
		
		while !stack.isEmpty {
			
			var ignore = false
			if scope == .space {
				if stack.peek() == " " {
					ignore = true
				} else if stack.peek() == "\n" {
					scope = .newLine
				} else if stack.peek() == "\"" {
					scope = .string
				} else {
					scope = .normal
				}
			} else if scope == .newLine {
				if (stack.peek() == "\n") || (stack.peek() == " ") {
					ignore = true
				} else if stack.peek() == "\"" {
					scope = .string
				} else {
					scope = .normal
				}
			} else if scope == .string {
				if stack.peek() == "\"" {
					scope = .normal
				}
			} else {
				if stack.peek() == " " {
					scope = .space
				} else if stack.peek() == "\n" {
					scope = .newLine
				} else if stack.peek() == "\"" {
					scope = .string
				}
			}
			
			let current = stack.pop()
			if !ignore {
				stripped += current
			}
			
		}
		
		return stripped
	}
	
	private class func stripComments(text: String) -> String {
		
		var stripped = ""
		let stack = text.stack
		
		enum CommentScopes {
			case singleLine
			case multiLine
			case string
			case normal
		}
		var scope = CommentScopes.normal
		
		while !stack.isEmpty {
			
			let currentChar = stack.pop()
			
			if scope == .singleLine {
				if currentChar == "\n" {
					scope = .normal
					stripped += "\n"
				}
				continue
			} else if scope == .multiLine {
				if currentChar == "*" && stack.peek() == "/" {
					stack.pop()
					scope = .normal
				}
				continue
			} else if scope == .string {
				if currentChar == "\"" {
					scope = .normal
				}
				stripped += currentChar
				continue
			} else {
				if currentChar == "/" && stack.peek() == "/" {
					scope = .singleLine
					stack.pop()
					continue
				} else if currentChar == "/" && stack.peek() == "*" {
					scope = .multiLine
					stack.pop()
					continue
				} else if currentChar == "\"" {
					scope = .string
					stripped += "\""
					continue
				} else {
					stripped += currentChar
				}
			}
			
		}
		
		return stripped
	}
	
	private class func getLines(text: String) -> [String] {
		
		let stack = text.stack
		var lines = [String]()
		var currentLine = ""
		
		while !stack.isEmpty {
			let currentChar = stack.pop()
			if currentChar != "\n" {
				currentLine += currentChar
			} else {
				lines.append(currentLine + "\n")
				currentLine = ""
			}
		}
		
		return lines
	}
	
	private class func tokenise(line: String) -> [String]? {
		
		enum BracketScopes : String {
			case round = "("
			case square = "["
			case angled = "<"
			case string = "\""
			case normal = ""
			
			var closing : String {
				switch self {
				case .round: return ")"
				case .square: return "]"
				case .angled: return ">"
				case .string: return "\""
				case .normal: return ""
				}
			}
		}
		
		let scopeStack = XGStack<BracketScopes>()
		let stack = line.stack
		var currentToken = ""
		var tokens = [String]()
		scopeStack.push(.normal)
		
		while !stack.isEmpty {
			
			let current = stack.pop()
			
			if (current == " " && scopeStack.peek() == .normal) || current == "\n" {
				tokens.append(currentToken)
				currentToken = ""
			} else if current == "\"" && scopeStack.peek() == .string {
				scopeStack.pop()
				currentToken += current
			} else if let bracket = BracketScopes(rawValue: current) {
				scopeStack.push(bracket)
				currentToken += current
			} else {
				for bracket : BracketScopes in [.round, .square, .angled] {
					if current == bracket.closing {
						if scopeStack.peek() == bracket {
							scopeStack.pop()
						} else {
							if scopeStack.peek() != .string {
								error = "Extraneous bracket: " + current + ". " + currentToken
								return nil
							}
						}
					}
				}
				currentToken += current
			}
			
		}
		if currentToken.count > 0 {
			tokens.append(currentToken)
		}
		if scopeStack.peek() != .normal {
			error = "End of line without closing " + scopeStack.peek().rawValue + ". " + currentToken
			return nil
		}
		
		return tokens
	}
	
	private class func evalTokens(tokens: [String]) -> XDSExpr? {
		
		if tokens.count == 0 { return nil }
		
		if tokens.count == 1 {
			let token = tokens[0]
			if token == "return" {
				return XDSExpr.XDSReturn
			}
			
			if token.contains(".") {
				return evalToken(token)
			}
			
			error = "Invalid line: \(token)"
			return nil
		}
		
		return XDSExpr.nop
	}
	
	private class func evalToken(_ token: String) -> XDSExpr? {
		
		if token.contains(".") {
			let strs = token.split(separator: ".")
			if strs.count != 2 {
				error = "Invalid token: \(token)"
				return nil
			}
			let xdsclass = String(strs[0])
			let function = String(strs[1])
			
			if let cnumber = XGScriptClassesInfo.getClassNamed(xdsclass) {
				error = "Invalid object: \(xdsclass)"
				return nil
			}
		}
		
		return XDSExpr.nop
	}
	
	private class func createExprStack(_ exprs: [XDSExpr]) -> XGStack<XDSExpr>? {
		
		return XGStack<XDSExpr>()
	}
	
	private class func getFTBL(_ exprs: XGStack<XDSExpr>) -> [FTBL] {
		
		return []
	}
	
	private class func getCODE(_ exprs: XGStack<XDSExpr>, gvar: [String], arry: [String], vect: [String], strg: [String], giri: [String]) -> [XGScriptInstruction] {
		
		return []
	}
	
	private class func getGVAR(_ exprs: XGStack<XDSExpr>) -> (names: [String], values: [XDSConstant]) {
		
		return ([],[])
	}
	
	private class func getARRY(_ exprs: XGStack<XDSExpr>) -> (names: [String], values: [[XDSConstant]]) {
		
		return ([],[])
	}
	
	private class func getSTRG(_ exprs: XGStack<XDSExpr>) -> [String] {
		
		return []
	}
	
	private class func getVECT(_ exprs: XGStack<XDSExpr>) -> (names: [String], values: [VECT]) {
		
		return ([],[])
	}
	
	private class func getGIRI(_ exprs: XGStack<XDSExpr>) -> (names: [String], values: [GIRI]) {
		
		return ([],[])
	}
	
	private class func compileTCOD(size: Int) -> XDSCode {
		return [0x54434F44,UInt32(size + 0x10),0x0,0x0]
	}
	
	private class func compileFTBL(_ data: [FTBL]) -> XDSCode {
		
		return []
	}
	
	private class func compileHEAD(_ data: [FTBL]) -> XDSCode {
		
		return []
	}
	
	private class func compileCODE(_ data: [XGScriptInstruction]) -> XDSCode {
		
		return []
	}
	
	private class func compileGVAR(_ data: [XDSConstant]) -> XDSCode {
		
		return []
	}
	
	private class func compileARRY(_ data: [[XDSConstant]]) -> XDSCode {
		
		return []
	}
	
	private class func compileSTRG(_ data: [String]) -> XDSCode {
		
		return []
	}
	
	private class func compileVECT(_ data: [VECT]) -> XDSCode {
		
		return []
	}
	
	private class func compileGIRI(_ data: [GIRI]) -> XDSCode {
		
		return []
	}

}















































