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
	
	static var giris  = (names: [XDSVariable](), values: [GIRI]())
	static var gvars  = (names: [XDSVariable](), values: [XDSConstant]())
	static var arrys  = (names: [XDSVariable](), values: [[XDSConstant]]())
	static var vects  = (names: [XDSVariable](), values: [VECT]())
	static var args   = [String : [XDSVariable]]()
	static var locals = [String : [XDSVariable]]()
	static var strgs  = [String]()
	static var locations = [String : Int]()
	static var currentFunction = ""
	static var scriptID = 0 // currently unknown what this value represents
	
	static var characters = [XGCharacter]()
	
	static var error = ""
	
	class func compile(text: String, toFile file: XGFiles) -> Bool {
		if let data = compile(text: text) {
			data.file = file
			data.save()
			if file.exists {
				printg("Successfully compiled script: \(file.fileName)")
				return true
			} else {
				let errorString = "XDS compilation error, File: \(file.fileName) \nError- failed to save file."
				
				printg(errorString)
				return false
			}
		}
		
		let errorString = "XDS compilation error, File: \(file.fileName) \nError-" + error
		
		printg(errorString)
		return false
	}
	
	class func compile(text: String) -> XGMutableData? {
		
		giris  = (names: [XDSVariable](), values: [GIRI]())
		gvars  = (names: [XDSVariable](), values: [XDSConstant]())
		arrys  = (names: [XDSVariable](), values: [[XDSConstant]]())
		vects  = (names: [XDSVariable](), values: [VECT]())
		args   = [String : [XDSVariable]]()
		locals = [String : [XDSVariable]]()
		strgs  = [String]()
		locations = [String : Int]()
		characters = [XGCharacter]()
		
		var stripped = stripComments(text: text)
		stripped = stripWhiteSpace(text: stripped)
		let macro = macroprocessor(text: stripped)
		
		// for testing white space and comment stripping
		//stripped.save(toFile: .nameAndFolder("white space stripped.xds", .Documents))
		
		if macro == nil {
			return nil
		}
		// for testing macroprocessor result
		//macro!.save(toFile: .nameAndFolder("macros.xds", .Documents))
		
		let lines = getLines(text: macro!)
		
		var expressions = [XDSExpr]()
		for line in lines {
			if let tokens = tokenise(line: line) {
				
				if currentFunction == "" {
					if tokens.count > 0 {
						if tokens[0] != "function" {
							error = "Only 'define', 'assign' and 'global' statements are allowed before the first function header."
							error = "\nInvalid line: "
							for t in tokens {
								error += " " + t
							}
							return nil
						}
					}
				}
				if let eval = evalTokens(tokens: tokens, subExpr: false) {
					expressions.append(eval)
				} else {
					return nil
				}
			} else {
				return nil
			}
		}
		
		// test that expressions are correct
		var recreated = ""
		for expr in expressions {
			recreated += expr.text + "\n"
		}
		recreated.save(toFile: .nameAndFolder("recreated.xds", .Documents))
		
		
		let stack = createExprStack(expressions)
		
		locations = getLocations(expressions)
		
		let ftbl = getFTBL(expressions)
		if let code = getCODE(stack, gvar: gvars.names, arry: arrys.names, strg: strgs, giri: giris.names) {
			
			var data = XDSCode()
			data += compileFTBL(ftbl)
			data += compileHEAD(ftbl)
			data += compileCODE(code, ftbl)
			data += compileGVAR(gvars.values)
			data += compileSTRG(strgs)
			data += compileVECT(vects.values)
			data += compileGIRI(giris.values)
			data += compileARRY(arrys.values)
			
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
						
						// special define statement for unknown identifier
						// unsure how necessary it is but for now must be explicitly stated
						if tokens.count == 3 {
							if tokens[1] == "++ScriptIdentifier" {
								if let val = Int(tokens[2]) {
									scriptID = val
								} else {
									if tokens[2].isHexInteger {
										let val = tokens[2].hexStringToInt()
										scriptID = val
									}
								}
							}
						}
						
						if tokens.count >= 3 {
							let macro = tokens[1]
							var replacement = tokens[2]
							for i in 3 ..< tokens.count {
								replacement += " " + tokens[i]
							}
							macros.append((macro: macro, replacement: replacement))
						} else {
							error = "Incomplete define statement: "
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
					} else if tokens[0] == "global" {
						let newTokens = tokens.map({ (token) -> String in
							var new = token
							for (macro, repl) in macros {
								new = new == macro ? repl : new
							}
							return new
						})
						if !handleGlobal(tokens: newTokens) {
							return nil
						}
					} else {
						var updatedLine = line
						for (macro, repl) in macros {
							for add in [" ", ".", ")", ">", "]", "(", "<", "[", "\"", "\n"] {
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
		//TODO: complete handle assignments character data
		// don't forget to check for duplicate variable names
		
		var gid = -1
		var rid = -1
		var name = ""
		
		let character = XGCharacter()
		
		
		var assignIndex = 0
		while assignIndex < tokens.count {
			let token = tokens[assignIndex]
			if assignIndex + 1 == tokens.count {
				error = "Assignment variable missing value: \(token)"
				return false
			}
			let nextToken = tokens[assignIndex + 1]
			if nextToken.contains(":") {
				error = "Assignment variable missing value: \(token)"
				return false
			}
			switch token {
			case "assign":
				name = nextToken
			case "groupID:":
				if let val = nextToken.integerValue {
					gid = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
			case "resourceID:":
				if let val = nextToken.integerValue {
					rid = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
				// TODO: Complete handling assignments updating characters in rel
				
			default:
				break
				// uncomment once fully implemented
//				error = "Invalid assignment variable: \(token)"
//				return false
				
			}
			assignIndex += 2
		}
		
		if name.length == 0 {
			error = "Invalid assignment, missing variable name: "
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			return false
		}
		
		if gid < 0 {
			error = "Invalid assignment, missing group id: "
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			return false
		}
		
		if rid < 0 {
			error = "Invalid assignment, missing resource id: "
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			return false
		}
		
		giris.names.append(name)
		giris.values.append((groupID: gid, resourceID: rid))
		
		if gid > 0 {
			characters.append(character)
		}
		
		return true
	}
	
	private class func handleGlobal(tokens: [String]) -> Bool {
		if tokens.count != 4 {
			error = "Incomplete global statement:"
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			return false
		}
		if tokens[2] != "=" {
			error = "Invalid global statement, missing '=':"
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			return false
		}
		if !tokens[1].isValidXDSVariable() {
			error = "Invalid global variable name '\(tokens[1])':"
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			error += "\n Variable names must only contain letters, numbers and underscores."
			error += "\n Variable names must not begin with a number."
			error += "\n Variable names must not begin with an uppercase character."
			return false
		}
		if gvars.names.contains(tokens[1]) || giris.names.contains(tokens[1]) || arrys.names.contains(tokens[1]) || vects.names.contains(tokens[1]) {
			error = "Global variable must have a unique name '\(tokens[1])':"
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			return false
		}
		if parseLiteral(tokens[3]) == nil {
			error = "Invalid global variable value '\(tokens[3])':"
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			return false
		}
		
		let (type, literal) = parseLiteral(tokens[3])!
		switch type {
		//TODO: confirm that .names.append() and .values.append() actually update the static vars
		case .vector:
			vects.names.append(tokens[1])
			vects.values.append((literal[0].asFloat,literal[1].asFloat, literal[2].asFloat))
		case .array:
			arrys.names.append(tokens[1])
			arrys.values.append(literal)
		default:
			gvars.names.append(tokens[1])
			gvars.values.append(literal[0])
		}
		
		return true
	}
	
	private class func handleMSGString(id: Int?, text: String) -> Int? {
		//TODO: msg replacements
		// if id is nil then generate a new string with the next free id
		// replace occurrences of [Quote] with \"
		// check that id isn't 0
		
		// return the strings finalised id or nil if failed
		return id
	}
	
	private class func parseLiteral(_ text: String) -> (XDSConstantTypes, [XDSConstant])? {
		// returns a tuple
		// first element has type vector if second element is 3 floats representing a vector literal
		// first element has type array if second element is an array representing an array literal
		// otherwise second element contains a single value representing a literal. The constant contains its type.
		
		if let val = text.integerValue {
			return (XDSConstantTypes.integer, [XDSConstant(type: XDSConstantTypes.integer.index, rawValue: UInt32(val))])
		}
		
		if let val = Float(text) {
			return (XDSConstantTypes.float, [XDSConstant(type: XDSConstantTypes.float.index, rawValue: val.floatToHex())])
		}
		
		if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(text.substring(from: 0, to: 1)) {
			if text.contains("(") && text.contains(")") {
				if let type = XDSConstantTypes.typeWithName(text.functionName!) {
					if let val = text.parameterString!.integerValue {
						return (type, [XDSConstant(type: type.index, rawValue:UInt32(val))])
					}
				}
			}
		}
		
		if text == "Null" {
			return (XDSConstantTypes.none_t, [XDSConstant.null])
		}
		
		if let index = arrys.names.index(of: text) {
			return (XDSConstantTypes.none_t, [XDSConstant(type: XDSConstantTypes.array.index, rawValue: UInt32(index))])
		}
		
		if let index = vects.names.index(of: text) {
			return (XDSConstantTypes.none_t, [XDSConstant(type: XDSConstantTypes.vector.index, rawValue: UInt32(index))])
		}
		
		if let index = giris.names.index(of: text) {
			return (XDSConstantTypes.none_t, [XDSConstant(type: XDSConstantTypes.character.index, rawValue: UInt32(index))])
		}
		
		if text.substring(from: 0, to: 1) == "<" {
			let parts = text.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").split(separator: " ")
			if parts.count == 3 {
				if let x = Float(String(parts[0])) {
					if let y = Float(String(parts[1])) {
						if let z = Float(String(parts[2])) {
							return (XDSConstantTypes.vector, [XDSConstant(type: XDSConstantTypes.float.index, rawValue: x.floatToHex()), XDSConstant(type: XDSConstantTypes.float.index, rawValue: y.floatToHex()), XDSConstant(type: XDSConstantTypes.float.index, rawValue: z.floatToHex())])
						}
					}
				}
			}
		}
		
		if text.substring(from: 0, to: 1) == "[" {
			let parts = text.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").split(separator: " ")
			var params = [XDSConstant]()
			for token in parts {
				let string = String(token)
				if let (type, val) = parseLiteral(string) {
					params.append(val[0])
				} else {
					error = "Invalid array element: \(string)"
					return nil
				}
				
			}
			return (XDSConstantTypes.array, params)
		}
		
		
		return (XDSConstantTypes.none_t, [XDSConstant(type: 0, rawValue: 0)])
	}
	
	private class func getStringStartIndex(str: String) -> UInt32 {
		var start = 0
		for s in strgs {
			if s == str {
				return UInt32(start)
			}
			start += s.length + 1
		}
		return UInt32(start) // should never hit this case in theory
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
		
		// remove leading new lines
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
		
		// strips consecutive white space characters
		// also combine multiline statements into one line if contained within brackets by treating newlines as
		// regular spaces.
		// doesn't include vector brackets ('<' or '>') as they also serve as greater/less than operators
		var bracketLevel = 0
		let leftBrackets = "(["
		let rightBrackets = ")]"
		
		while !stack.isEmpty {
			
			if leftBrackets.contains(stack.peek()) {
				bracketLevel += 1
			}
			if bracketLevel > 0 {
				if rightBrackets.contains(stack.peek()) {
					bracketLevel -= 1
				}
			}
			
			// replace newlines with regular spaces if within brackets
			if bracketLevel > 0 {
				if stack.peek() == "\n" {
					stack.pop()
					stack.push(" ")
				}
			}
			
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
		
		// remove all spaces at end of line
		// also remove spaces immediately following or preceding brackets
		for (replace, with) in [(" \n","\n"),("[ ","["),("( ","("),(" ]","]"),(" )",")")] {
			while stripped.range(of: replace) != nil {
				stripped = stripped.replacingOccurrences(of: replace, with: with)
			}
		}
		
		if stripped.length > 0 {
			while "\n ".contains(stripped.last!)  {
				stripped.removeLast()
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
		if currentLine.length > 0 {
			lines.append(currentLine + "\n")
		}
		
		return lines
	}
	
	private class func tokenise(line: String) -> [String]? {
		// splits the line into individual tokens by spaces. spaces are ignored within brackets and strings so tokens like bracketed expressions or vector and string literals are considered one token.
		
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
				
				var isOperator = false
				if bracket == .angled {
					if !stack.isEmpty {
						if stack.peek() == " " || stack.peek() == "=" {
							isOperator = true
						}
					}
				}
				
				if !isOperator {
					scopeStack.push(bracket)
				}
				
				currentToken += current
				
			} else {
				for bracket : BracketScopes in [.round, .square, .angled] {
					if current == bracket.closing {
						
						var isOperator = false
						if bracket == .angled {
							if !stack.isEmpty {
								if stack.peek() == " " || stack.peek() == "=" {
									isOperator = true
								}
							}
						}
						
						if !isOperator {
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
				}
				currentToken += current
			}
			
		}
		if currentToken.length > 0 {
			tokens.append(currentToken)
		}
		if scopeStack.peek() != .normal {
			error = "End of line without closing " + scopeStack.peek().rawValue + ". " + currentToken
			return nil
		}
		
		return tokens
	}
	
	private class func evalTokens(tokens: [String], subExpr: Bool) -> XDSExpr? {
		// the tokens are considered a "sub expression" if they are a part of a larger expression, the result of recursively evaluating tokens.
		
		if tokens.count == 0 { return .nop }
		
		// single tokens are handled by evalToken() if they are valid
		if tokens.count == 1 {
			let token = tokens[0]
			
			// return statement, handled by evalToken for consistency
			if token == "return" {
				return evalToken(token)
			}
			
			// accept bracketed expressions, function calls, location markers or any sub expression
			if (token.contains("(") && token.contains(")")) || token.substring(from: 0, to: 1) == "@" || subExpr {
				// if it's a function call, check if it should become callstdvoid, i.e. this isn't a sub expression
				if let expr = evalToken(token) {
					switch expr {
					case .callStandard(let c, let f, let es):
						return subExpr ? expr : .callStandardVoid(c, f, es)
					default:
						return expr
					}
				} else {
					return nil
				}
			}
			
			// any other case is invalid
			error = "Invalid line: \(token)"
			return nil
		}
		
		// These can only be sub expressions (e.g. function calls with return values)
		if subExpr {
			
			// call to script function. since it's a sub expression it should return a value.
			if tokens[0] == "call" && tokens.count > 1 {
				if tokens[1].substring(from: 0, to: 1) == "@" {
					var params = [XDSExpr]()
					if tokens.count > 2 {
						for i in 2 ..< tokens.count {
							if let expr = evalToken(tokens[i]) {
								params.append(expr)
							} else {
								error = "Invalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
						}
					}
					
					return XDSExpr.call(tokens[1], params)
				} else {
					error = "Call must be followed by a function location.\nInvalid line: "
					for t in tokens {
						error += " " + t
					}
					return nil
				}
			}
			
			// binary operators
			if tokens.count == 3 {
				for (name,id,params) in ScriptOperators where params == 2 {
					if name == tokens[1] {
						if let e1 = evalToken(tokens[0]){
							if let e2 = evalToken(tokens[2]){
								return .binaryOperator(id , e1, e2)
							} else {
								return nil
							}
						} else {
							return nil
						}
					}
				}
				
			}
			
			
		}
		
		// check each remaining type of multi token line
		// these cannot be sub expressions
		if !subExpr {
			
			// function declaration
			if tokens[0] == "function" && tokens.count > 1 {
				if tokens[1].substring(from: 0, to: 1) == "@" {
					var params = [XDSVariable]()
					if tokens.count > 2 {
						for i in 2 ..< tokens.count {
							params.append(tokens[i])
						}
					}
					
					// initialise arguments and local variables as this is start of new function
					if locals[tokens[1]] != nil {
						error = "Function must have a unique name.\nInvalid line: "
						for t in tokens {
							error += " " + t
						}
						return nil
					}
					
					locals[tokens[1]] = []
					args[tokens[1]] = params
					currentFunction = tokens[1]
					
					return XDSExpr.function(tokens[1], params)
					
				} else {
					error = "Function header must be followed by a function location name.\nInvalid line: "
					for t in tokens {
						error += " " + t
					}
					return nil
				}
			}
			
			// location jumps
			if tokens[0] == "goto" && tokens.count > 1 {
				
				if tokens.count == 2 {
					if tokens[1].substring(from: 0, to: 1) == "@" {
						return .jump(tokens[1])
					} else {
						error = "Goto must be followed by a location.\nInvalid line: "
						for t in tokens {
							error += " " + t
						}
						return nil
					}
				}
				
				if tokens.count > 3 {
					
					if tokens[1].substring(from: 0, to: 1) == "@" {
						var subTokens = [String]()
						for i in 3 ..< tokens.count {
							subTokens.append(tokens[i])
						}
						
						if tokens[2] == "if" {
							if let expr = evalTokens(tokens: subTokens, subExpr: true) {
								return .jumpTrue(expr, tokens[1])
							} else {
								error += "\nInvalid goto condition.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
						} else if tokens[2] == "ifFalse" {
							if let expr = evalTokens(tokens: subTokens, subExpr: true) {
								return .jumpFalse(expr, tokens[1])
							} else {
								error += "\nInvalid goto condition.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
						}  else {
							error = "Expected 'if' or 'ifFalse' after location.\nInvalid line: "
							for t in tokens {
								error += " " + t
							}
							return nil
						}
					} else {
						error = "Goto must be followed by a location.\nInvalid line: "
						for t in tokens {
							error += " " + t
						}
						return nil
					}
				} else {
					error = "Incomplete goto statement.\nInvalid line: "
					for t in tokens {
						error += " " + t
					}
					return nil
				}
				
				
			}
			
			// call to script function. since it's not a sub expression it should not return a value.
			if tokens[0] == "call" && tokens.count > 1 {
				if tokens[1].substring(from: 0, to: 1) == "@" {
					var params = [XDSExpr]()
					if tokens.count > 2 {
						for i in 2 ..< tokens.count {
							if let expr = evalToken(tokens[i]) {
								params.append(expr)
							} else {
								error += "\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
						}
					}
					
					return XDSExpr.callVoid(tokens[1], params)
				} else {
					error = "Call must be followed by a function location\nInvalid line: "
					for t in tokens {
						error += " " + t
					}
					return nil
				}
			}
			
			// return with return value
			if tokens[0] == "return" {
				var params = [String]()
				if tokens.count > 1 {
					for i in 1 ..< tokens.count {
						params.append(tokens[i])
					}
				}
				
				if let expr = evalTokens(tokens: params, subExpr: true) {
					return XDSExpr.XDSReturnResult(expr)
				} else {
					error += "\nInvalid line: "
					for t in tokens {
						error += " " + t
					}
					return nil
				}
			}
			
			// variable assignment
			if tokens.count > 2 {
				if tokens[1] == "=" {
					var params = [String]()
					if tokens.count > 2 {
						for i in 2 ..< tokens.count {
							params.append(tokens[i])
						}
					}
					
					if let expr = evalTokens(tokens: params, subExpr: true) {
						var variable = ""
						var index : String? = nil
						
						if tokens[0].contains(".") {
							// vector dimension assignment
							
							var subindex = ""
							let ss = tokens[0].stack
							while ss.peek() != "." {
								variable += ss.pop()
							}
							ss.pop()
							while !ss.isEmpty {
								subindex += ss.pop()
							}
							index = subindex
							
							if !vects.names.contains(variable) && !locals[currentFunction]!.contains(variable) && !args[currentFunction]!.contains(variable) && !gvars.names.contains(variable)  {
								error = "Vector \(variable) doesn't exist.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
							
							switch index! {
							case "vx":
								return XDSExpr.setVector(variable, .x, expr)
							case "vy":
								return XDSExpr.setVector(variable, .y, expr)
							case "vz":
								return XDSExpr.setVector(variable, .z, expr)
							default:
								error = "Invalid vector dimension '\(index!)'.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
								
							}
							
						} else if tokens[0].contains("[") && tokens[0].contains("]") {
							// array element assignment
							// syntactic sugar but is actually implemented as a function call
							
							var subindex = ""
							let ss = tokens[0].stack
							while ss.peek() != "[" {
								variable += ss.pop()
							}
							ss.pop()
							while ss.peek() != "]" {
								subindex += ss.pop()
							}
							index = subindex
							
							if !arrys.names.contains(variable) && !locals[currentFunction]!.contains(variable) && !args[currentFunction]!.contains(variable) && !gvars.names.contains(variable)  {
								error = "Array \(variable) doesn't exist.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
							
							if let subTokens = tokenise(line: index!) {
								if let indexpr = evalTokens(tokens: subTokens, subExpr: true) {
									return XDSExpr.callStandardVoid(7, 17, [XDSExpr.loadPointer(variable), indexpr, expr])
								}
							}
							
						} else {
							// global or local variable
							
							variable = tokens[0]
							
							// arrays and vectors are handled above and function arguments can't be modified
							if args[currentFunction]!.contains(variable) {
								error = "Cannot modify a function parameter.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
							if vects.names.contains(variable) {
								error = "No vector dimension specified.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
							if arrys.names.contains(variable) {
								error = "No array index specified.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
							if giris.names.contains(variable) {
								error = "Cannot modify a character variable.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
							if !gvars.names.contains(variable) {
								var locs = locals[currentFunction]!
								locs.addUnique(variable)
								locals[currentFunction] = locs
							}
							return XDSExpr.setVariable(variable, expr)
							
						}
						
					}
				}
			}
			 
		}
		
		error = "Invalid line: "
		for t in tokens {
			error += " " + t
		}
		return nil
	}
	
	private class func evalToken(_ token: String) -> XDSExpr? {
		
		if token.length == 0 {
			error = "Invalid token: \(token)"
			return nil
		}
		
		// return statement
		if token == "return" {
			return XDSExpr.XDSReturn
		}
		
		// load variables
		if token == kXDSLastResultVariable {
			return XDSExpr.loadVariable(token)
		}
		
		if token == kXDSLastResultVariable + "*" {
			return XDSExpr.loadPointer(token)
		}
		
		for name in locals[currentFunction]! + args[currentFunction]!  {
			if token == name {
				return .loadVariable(token)
			}
			if token == name + "*" {
				return .loadPointer(token)
			}
		}
		
		for name in gvars.names {
			if token == name {
				let index = gvars.names.index(of: name)!
				let val = gvars.values[index]
				let type = val.type.index
				if type <= 4 {
					return .loadVariable(token)
				} else {
					return .loadPointer(token)
				}
			}
		}
		
		for name in arrys.names {
			if token == name {
				return .loadPointer(token)
			}
		}
		
		for name in giris.names {
			if token == name {
				return .loadVariable(token)
			}
		}
		
		for name in vects.names {
			if token == name {
				return .loadImmediate(XDSConstant(type: XDSConstantTypes.vector.index, rawValue: UInt32(vects.names.index(of: token)!)))
			}
		}
		
		// bracketed expression
		if token.first! == "(" && token.last! == ")" {
			if let inner = tokenise(line: token.substring(from: 1, to: token.length - 1)) {
				return evalTokens(tokens: inner, subExpr: true)
			} else {
				error = "Invalid bracket contents: \(token)"
				return nil
			}
		}
		
		if token.contains("[") && token.contains("]") {
			// array element access
			// syntactic sugar but is actually implemented as a function call
			
			var index = ""
			var variable = ""
			let ss = token.stack
			while ss.peek() != "[" {
				variable += ss.pop()
			}
			ss.pop()
			while ss.peek() != "]" {
				index += ss.pop()
			}
			
			if let subTokens = tokenise(line: index) {
				if let indexpr = evalTokens(tokens: subTokens, subExpr: true) {
					return XDSExpr.callStandard(7, 16, [XDSExpr.loadPointer(variable), indexpr])
				}
			}
			
		}
		
		if token.contains("(") && token.contains(")") {
			// unary operator, special type literal or function call
			
			var parameters = ""
			var functionName = ""
			var variableName = "" // either variable or class name
			var localClassName = "" // follows local variable
			let ss = token.stack
			while ss.peek() != "(" {
				functionName += ss.pop()
			}
			ss.pop()
			while ss.peek() != ")" {
				parameters += ss.pop()
			}
			
			var functionParameters = [XDSExpr]()
			var functionIndex = 0
			var classIndex = 0
			
			func getParameters() -> [XDSExpr]? {
				var paramList = [XDSExpr]()
				if let tokens = tokenise(line: parameters) {
					for t in tokens {
						if let expr = evalToken(t) {
							paramList.append(expr)
						} else {
							error += "\nInvalid function parameters: \(token)"
							return nil
						}
					}
				}
				return paramList
			}
			
			let functionParts = functionName.split(separator: ".")
			switch functionParts.count {
			case 1:
				// operator or standard classless function
				functionName = String(functionParts[0]) // remains unchanged
				
				// check if unary operator
				for (name,id,params) in ScriptOperators where params == 1 {
					if name == functionName {
						if let tokens = tokenise(line: parameters) {
							if let expr =  evalTokens(tokens: tokens, subExpr: true) {
								return .unaryOperator(id, expr)
							} else {
								error += "\nInvalid operator parameters: \(token)"
								return nil
							}
						} else {
							error = "Invalid operator paramters: \(token)"
							return nil
						}
					}
				}
				
				// check if type literal
				// only types start with capitals
				if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(functionName.substring(from: 0, to: 1)) {
					if let type = XDSConstantTypes.typeWithName(functionName) {
						if let val = parameters.integerValue {
							return .loadImmediate(XDSConstant(type: type.index, rawValue: UInt32(bitPattern: Int32(val))))
						} else {
							error = "Invalid raw integer: \(token)"
							return nil
						}
					} else {
						error = "Invalid type name: \(token)"
						return nil
					}
				}
				
				// check if standard function
				if let info = XGScriptClassesInfo.classes(0).functionWithName(functionName) {
					classIndex = 0
					functionIndex = info.index
					if let params = getParameters() {
						functionParameters = params
					} else {
						return nil
					}
					
				} else {
					error = "Unrecognised function: \(functionName)"
					return nil
				}
				
			case 2:
				// global variable or class function call
				variableName = String(functionParts[0])
				functionName = String(functionParts[1])
				
				if let params = getParameters() {
					functionParameters = [XDSExpr.loadPointer(variableName)] + params
				} else {
					return nil
				}
				
				if let gvarIndex = gvars.names.index(of: variableName) {
					classIndex = gvars.values[gvarIndex].type.index
					
					if let params = getParameters() {
						if classIndex <= 4 {
							functionParameters = [XDSExpr.loadVariable(variableName)] + params
						} else {
							functionParameters = [XDSExpr.loadPointer(variableName)] + params
						}
					}
					
				} else if arrys.names.contains(variableName) {
					classIndex = 7
				} else if vects.names.contains(variableName) {
					classIndex = 4
					
					if let params = getParameters() {
						let immediate = XDSConstant(type: XDSConstantTypes.vector.index, rawValue: UInt32(vects.names.index(of: variableName)!))
						functionParameters = [XDSExpr.loadImmediate(immediate)] + params
					}
				} else if giris.names.contains(variableName) {
					classIndex = 35
					
					if let params = getParameters() {
						// character is loadvar instead of loadpointer(ldncpyvar) when using a character object directly
						functionParameters = [XDSExpr.loadVariable(variableName)] + params
					}
					
				} else if let cinfo = XGScriptClassesInfo.getClassNamed(variableName) {
					classIndex = cinfo.index
					if classIndex == 35 {
						error = "Character functions must be applied to a character variable: \(token)"
						return nil
					}
				} else {
					error = "Invalid class or global variable name: '\(variableName)'"
					return nil
				}
				
				if let finfo = XGScriptClassesInfo.classes(classIndex).functionWithName(functionName) {
					functionIndex = finfo.index
				} else {
					error = "Unrecognised function: '\(functionName)', for class: '\(XGScriptClassesInfo.classes(classIndex).name)'"
					return nil
				}
				
				
			case 3:
				// local variable class function call
				variableName   = String(functionParts[0])
				localClassName = String(functionParts[1])
				functionName   = String(functionParts[2])
				
				if let cinfo = XGScriptClassesInfo.getClassNamed(localClassName) {
					classIndex = cinfo.index
				} else {
					error = "Invalid class name: '\(localClassName)' on token: '\(token)'"
					return nil
				}
				
				if let finfo = XGScriptClassesInfo.classes(classIndex).functionWithName(functionName) {
					functionIndex = finfo.index
				} else {
					error = "Unrecognised function: '\(functionName)', for class: '\(XGScriptClassesInfo.classes(classIndex).name)'"
					return nil
				}
				
				if let params = getParameters() {
					if locals[currentFunction]!.contains(variableName) || args[currentFunction]!.contains(variableName) || variableName == kXDSLastResultVariable {
						if classIndex <= 4 {
							functionParameters = [XDSExpr.loadVariable(variableName)] + params
						} else {
							functionParameters = [XDSExpr.loadPointer(variableName)] + params
						}
					} else {
						// apparently function calls on unassigned local variables are a thing such as in hero main
						// previously returned an error here but now will just assume everything that
						// hits this case is an intended local variable.
						// will be up to the script writer to be careful here.
						// if player.processEvents() in hero main is the only exception then
						// it may be worth simply accounting for it as an edge case.
						// will see if it shows up anywhere else.
						
						var locs = locals[currentFunction]!
						locs.addUnique(variableName)
						locals[currentFunction] = locs
						
						if classIndex <= 4 {
							functionParameters = [XDSExpr.loadVariable(variableName)] + params
						} else {
							functionParameters = [XDSExpr.loadPointer(variableName)] + params
						}
					}
				} else {
					return nil
				}
				
			default:
				error = "Function call with too many parts: \(token)"
				return nil
			}
			
			return .callStandard(classIndex, functionIndex, functionParameters)
			
		}
		
		if let val = Int(token) {
			return .loadImmediate(XDSConstant(type: XDSConstantTypes.integer.index, rawValue: UInt32(bitPattern: Int32(val))))
		}
		
		if token.isHexInteger {
			return .loadImmediate(XDSConstant(type: XDSConstantTypes.integer.index, rawValue: UInt32(bitPattern: Int32(token.hexStringToInt()))))
		}
		
		if let val = Float(token) {
			return .loadImmediate(XDSConstant(type: XDSConstantTypes.float.index, rawValue: val.floatToHex()))
		}
		
		// string literal
		if token.substring(from: 0, to: 1) == "\"" {
			let string = token.replacingOccurrences(of: "\"", with: "")
			strgs.addUnique(string)
			let offset = getStringStartIndex(str: string)
			return .loadImmediate(XDSConstant(type: XDSConstantTypes.string.index, rawValue: offset))
		}
		
		if token.substring(from: 0, to: 1) == "@" {
			if token.length > 1 {
				if token.substring(from: 1, to: token.length).isValidXDSVariable() {
					return .location(token)
				} else {
					error = "Location name must be a valid variable: \(token)"
					return nil
				}
			} else {
				error = "Missing location name: \(token)"
				return nil
			}
		}
		
		if token.substring(from: 0, to: 1) == "$" {
			var id : Int? = nil
			var text : String? = ""
			let ss = token.stack
			ss.pop() // remove leading $
			// check if has an id
			if ss.peek() == ":" {
				ss.pop() // remove opening ':'
				var idText = ""
				while ss.peek() != ":" {
					idText += ss.pop()
					if ss.isEmpty {
						error = "Incomplete message ID: \(token) - missing closing ':'"
						return nil
					}
				}
				ss.pop() // remove closing ':'
				if idText.length > 0 {
					if let val = Int(idText) {
						id = val
					} else {
						error = "Invalid message ID: \(token)"
						return nil
					}
				}
			}
			// check for text
			if !ss.isEmpty {
				if ss.peek() == "\"" {
					ss.pop() // remove opening quote
					while ss.peek() != "\"" {
						text! += ss.pop()
						if ss.isEmpty {
							error = "Invalid message text: \(token) - missing closing '\"'"
							return nil
						}
					}
					ss.pop() // remove closing quote
				} else {
					error = "Invalid message text: missing opening '\"'"
					return nil
				}
			} else {
				text = nil
			}
			
			if text != nil {
				id = handleMSGString(id: id, text: text!)
			}
			
			if id != nil {
				return .loadImmediate(XDSConstant(type: XDSConstantTypes.integer.index, rawValue: UInt32(id!)))
			}
			
			// error in handlemsgstring
			return nil
			
		}
		
		error = "Invalid token: \(token)"
		return nil
	}
	
	// realised I don't need this function but already designed logic around it so might as well use it :-)
	private class func createExprStack(_ exprs: [XDSExpr]) -> XGStack<XDSExpr> {
		let stack = XGStack<XDSExpr>()
		
		for expr in exprs.reversed() {
			stack.push(expr)
		}
		
		return stack
	}
	
	private class func getLocations(_ exprs: [XDSExpr]) -> [String : Int] {
		
		var locations = [String : Int]()
		
		var currentLocation = 0
		for expr in exprs {
			switch expr {
			case .location(let name):
				locations[name] = currentLocation
			case .function(let name, _):
				locations[name] = currentLocation
			default:
				break
			}
			currentLocation += expr.instructionCount
		}
		
		return locations
	}
	
	private class func getFTBL(_ exprs: [XDSExpr]) -> [FTBL] {
		var functions = [FTBL]()
		
		var currentLocation = 0
		for expr in exprs {
			switch expr {
			case .function(let name, _):
				functions += [(currentLocation, 0, name, functions.count)]
			default:
				break
			}
			currentLocation += expr.instructionCount
		}
		
		return functions
	}
	
	private class func getCODE(_ exprs: XGStack<XDSExpr>, gvar: [String], arry: [String], strg: [String], giri: [String]) -> [XGScriptInstruction]? {
		
		var instructions = [XGScriptInstruction]()
		
		let expressions = exprs
		while !expressions.isEmpty {
			let nextExpression = expressions.pop()
			
			switch nextExpression {
			case .function(let name, _):
				currentFunction = name
			default: break
			}
			
			let (instructs, errorString) = nextExpression.instructions(gvar: gvar, arry: arry, strg: strg, giri: giri, locals: locals[currentFunction]!, args: args[currentFunction]!)
			if let e = errorString {
				error = e
				return nil
			}
			if instructs != nil {
				instructions += instructs!
			}
		}
		
		return instructions
	}
	
	
	private class func compileTCOD(size: Int) -> XDSCode {
		return [0x54434F44,UInt32(size + 0x10),0x0,0x0]
	}
	
	private class func compileFTBL(_ data: [FTBL]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x4654424C] // unicode 'FTBL'
		
		var headSize : UInt32 = UInt32(data.count) * 8
		var stringSize : UInt32 = 0x0
		
		var functionNames = [String]()
		for (_, _, name, _) in data {
			functionNames.addUnique(name)
			stringSize += UInt32(name.length) + 1
		}
		
		let firstStringOffset = headSize + 0x20
		
		var sectionSize = headSize + stringSize + 0x20
		// make sure section is padded for alignment
		sectionSize += sectionSize % 16
		
		code += [sectionSize] // section size
		code += [0,0] // padding
		code += [UInt32(data.count)] // number of entries
		code += [firstStringOffset] // first string
		code += [UInt32(self.scriptID),0] // unknown id + padding
		
		
		func getFuncNameStartIndex(str: String) -> UInt32 {
			var start = 0
			for s in functionNames {
				if s == str {
					return UInt32(start)
				}
				start += s.length + 1
			}
			return UInt32(start) // should never hit this case in theory
		}
		
		// fill pointer table
		for (codeOffset, _, name, _) in data {
			code += [UInt32(codeOffset)]
			code += [getFuncNameStartIndex(str: name) + firstStringOffset]
		}
		
		// fill strings
		var currentWord : UInt32 = 0x0
		var currentByteIndex = 3
		
		// adds one byte at a time, buffering into a uint32 and adding the whole word once full
		func addByte(_ byte: UInt8) {
			let value = UInt32(byte) << (currentByteIndex * 4)
			currentWord = currentWord | value
			if currentByteIndex == 0 {
				code += [currentWord]
				currentByteIndex = 3
				currentWord = 0
			} else {
				currentByteIndex -= 1
			}
		}
		
		for s in functionNames {
			let string = XGString(string: s, file: nil, sid: nil)
			for char in string.chars {
				for byte in char.byteStream {
					addByte(byte)
				}
			}
			addByte(0)
		}
		
		// padding
		while code.count * 4 < sectionSize {
			addByte(0)
		}
		
		return code
	}
	
	private class func compileHEAD(_ data: [FTBL]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x48454144] // unicode 'HEAD'
		
		var sectionSize = UInt32(data.count) * 4 + 0x20
		// make sure section is padded for alignment
		sectionSize += sectionSize % 16
		
		code += [sectionSize] // section size
		code += [0,0] // padding
		code += [UInt32(data.count)] // number of entries
		code += [0,0,0] // padding
		for (codeOffset, _, _, _) in data {
			code += [UInt32(codeOffset)]
		}
		
		// padding
		while code.count < sectionSize / 4 {
			code += [0]
		}
		
		return code
	}
	
	private class func compileCODE(_ data: [XGScriptInstruction], _ header: [FTBL]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x434F4445] // unicode 'CODE'
		
		var sectionSize : UInt32 = 0x20
		var instructionCount : UInt32 = 0x0
		for instruction in data {
			sectionSize += UInt32(instruction.length) * 4
			instructionCount += UInt32(instruction.length)
		}
		// make sure section is padded for alignment
		sectionSize += sectionSize % 16
		
		code += [sectionSize] // section size
		code += [0,0] // padding
		code += [UInt32(header.count)] // number of functions
		code += [instructionCount,0,0] // number instruction indexes (loadimm = 2) + padding
		for instruction in data {
			code += [instruction.raw1]
			if instruction.length == 2 {
				code += [instruction.raw2]
			}
			
		}
		
		// padding
		while code.count < sectionSize / 4 {
			code += [0]
		}
		
		return code
	}
	
	private class func compileGVAR(_ data: [XDSConstant]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x47564152] // unicode 'GVAR'
		
		var sectionSize = UInt32(gvars.names.count) * 8 + 0x20
		// make sure section is padded for alignment
		sectionSize += sectionSize % 16
		
		code += [sectionSize] // section size
		code += [0,0] // padding
		code += [UInt32(data.count)] // number of entries
		code += [8,0,0] // entry size + padding
		for val in data {
			code += [UInt32(val.type.index), val.value]
		}
		
		// padding
		while code.count < sectionSize / 4 {
			code += [0]
		}
		
		return code
	}
	
	private class func compileARRY(_ data: [[XDSConstant]]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x41525259] // unicode 'ARRY'
		
		var sectionSize = UInt32(arrys.names.count) * 20 + 0x20
		// 4 for each array start pointer and 16 for each array header
		// 8 for each array element
		for a in data {
			sectionSize += 8 * UInt32(a.count)
		}
		// make sure section is padded for alignment
		sectionSize += sectionSize % 16
		
		code += [sectionSize] // section size
		code += [0,0] // padding
		code += [UInt32(data.count)] // number of entries
		code += [0,0,0] // padding
		
		// pointers to each array start relative to array section (-0x10)
		var currentStart = UInt32(data.count) * 4 + 0x10
		var arrayCode = XDSCode()
		var currentIndex : UInt32 = 0
		for a in data {
			code += [currentStart]
			currentStart += 8 * UInt32(a.count) + 0x10
			arrayCode += [UInt32(a.count), 0, currentIndex, 0] // array header
			currentIndex += 1
			for val in a {
				arrayCode += [UInt32(val.type.index) << 16, val.value]
			}
		}
		
		code += arrayCode
		
		// padding
		while code.count < sectionSize / 4 {
			code += [0]
		}
		
		return code
	}
	
	private class func compileSTRG(_ data: [String]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x53545247] // unicode 'STRG'
		
		var sectionSize = 0x20
		for s in data {
			sectionSize += s.length + 1
		}
		// make sure section is padded for alignment
		sectionSize += sectionSize % 16
		
		code += [UInt32(sectionSize)] // section size
		code += [0,0] // padding
		code += [UInt32(data.count)] // number of entries
		code += [0,0,0] // padding
		
		var currentWord : UInt32 = 0x0
		var currentByteIndex = 3
		
		// adds one byte at a time, buffering into a uint32 and adding the whole word once full
		func addByte(_ byte: UInt8) {
			let value = UInt32(byte) << (currentByteIndex * 4)
			currentWord = currentWord | value
			if currentByteIndex == 0 {
				code += [currentWord]
				currentByteIndex = 3
				currentWord = 0
			} else {
				currentByteIndex -= 1
			}
		}
		
		for s in data {
			let string = XGString(string: s, file: nil, sid: nil)
			for char in string.chars {
				for byte in char.byteStream {
					addByte(byte)
				}
			}
			addByte(0)
		}
		
		// padding
		while code.count * 4 < sectionSize {
			addByte(0)
		}
		
		return code
	}
	
	private class func compileVECT(_ data: [VECT]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x56454354] // unicode 'VECT'
		
		var sectionSize = UInt32(data.count) * 12 + 0x20
		// make sure section is padded for alignment
		sectionSize += sectionSize % 16
		
		code += [sectionSize] // section size
		code += [0,0] // padding
		code += [UInt32(data.count)] // number of entries
		code += [12,0,0] // entry size + padding
		for (x, y, z) in data {
			code += [x.floatToHex(), y.floatToHex(), z.floatToHex()]
		}
		
		// padding
		while code.count < sectionSize / 4 {
			code += [0]
		}
		
		return code
	}
	
	private class func compileGIRI(_ data: [GIRI]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x47495249] // unicode 'GIRI'
		
		var sectionSize = UInt32(data.count) * 8 + 0x20
		// make sure section is padded for alignment
		sectionSize += sectionSize % 16
		
		code += [sectionSize] // section size
		code += [0,0] // padding
		code += [UInt32(data.count)] // number of entries
		code += [0,0,0] // padding
		for (gid, rid) in data {
			code += [UInt32(gid), UInt32(rid)]
		}
		
		// padding
		while code.count < sectionSize / 4 {
			code += [0]
		}
		
		return code
	}

}















































