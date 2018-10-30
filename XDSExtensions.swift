//
//  XDSExtensions.swift
//  GoD Tool
//
//  Created by The Steez on 22/10/2018.
//

import Foundation

extension XDSScriptCompiler {
	
	class func syntacticSugarVariableXDS() -> String {
		// a variable that is likely to be unique
		// and can be programmatically generated
		// useful for if statements to add in locations
		let variable = "__XDS_SyntacticSugar_Variable_\(XDSScriptCompiler.sugarVarCounter)"
		XDSScriptCompiler.sugarVarCounter += 1
		return variable
	}
	
	class func stripWhiteSpaceXDS(text: String) -> String? {
		
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
					stack.popVoid()
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
		let leftBrackets = "([{"
		let rightBrackets = ")]}"
		let bracketStack = XGStack<String>()
		
		while !stack.isEmpty {
			
			if leftBrackets.contains(stack.peek()) {
				bracketLevel += 1
				bracketStack.push(stack.peek())
			}
			
			if bracketLevel > 0 {
				if rightBrackets.contains(stack.peek()) {
					bracketLevel -= 1
				}
				let right = stack.peek()
				let left = bracketStack.peek()
				if right == "}" && left == "{" {
					bracketStack.popVoid()
				} else if right == "]" && left == "[" {
					bracketStack.popVoid()
				} else if right == ")" && left == "(" {
					bracketStack.popVoid()
				} else {
					error = "Error: Unclosed '\(left)' bracket in text."
				}
			}
			
			// replace newlines with regular spaces if within brackets
			// replace with semi colons if within curly braces
			if bracketLevel > 0 {
				if stack.peek() == "\n" {
					stack.popVoid()
					if bracketStack.peek() == "{" {
						stack.push(";")
					} else {
						stack.push(" ")
					}
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
	
	class func stripCommentsXDS(text: String) -> String {
		
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
					stack.popVoid()
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
					stack.popVoid()
					continue
				} else if currentChar == "/" && stack.peek() == "*" {
					scope = .multiLine
					stack.popVoid()
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
	
	class func getLinesXDS(text: String) -> [String] {
		
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
	
	private class func parseLiteral(_ text: String) -> (XDSConstantTypes, [XDSConstant])? {
		// returns a tuple
		// first element has type vector if second element is 3 floats representing a vector literal
		// first element has type array if second element is an array representing an array literal
		// otherwise second element contains a single value representing a literal. The constant contains its type.
		
		if text.length == 0 {
			return nil
		}
		
		if text.first! == "@" {
			error = "Uh oh, location as a literal! Technically allowed but hoped this day would never come. If you wrote this line yourself then it's probably wrong otherwise tell @StarsMmd he has to implement location literals. \(text)"
			return nil
		}
		
		if let val = text.integerValue {
			return (XDSConstantTypes.integer, [XDSConstant.integer(val)])
		}
		
		if let val = Float(text) {
			return (XDSConstantTypes.float, [XDSConstant.float(val)])
		}
		
		if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(text.substring(from: 0, to: 1)) {
			if text.contains("(") && text.contains(")") {
				if let type = XDSConstantTypes.typeWithName(text.functionName!) {
					if let param = text.parameterString {
						let paramString = param == "" ? "0" : param
						if let val = paramString.integerValue {
							return (type, [XDSConstant(type: type.index, rawValue:UInt32(val))])
						}
					}
				}
			}
		}
		
		if text == "Null" {
			return (XDSConstantTypes.none_t, [XDSConstant.null])
		}
		
		if ["True", "Yes", "YES", "TRUE"].contains(text) {
			return (XDSConstantTypes.integer, [XDSConstant.integer(1)])
		}
		
		if ["False", "No", "NO", "FALSE"].contains(text) {
			return (XDSConstantTypes.integer, [XDSConstant.integer(0)])
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
							return (XDSConstantTypes.vector, [XDSConstant.float(x), XDSConstant.float(y), XDSConstant.float(z)])
						}
					}
				}
			}
		}
		
		if text.length > 2 {
			if text.first! == "[" && text.last! == "]" {
				var inner = text
				inner.removeFirst()
				inner.removeLast()
				if let parts = tokeniseXDS(text: inner) {
					
					var params = [XDSConstant]()
					for token in parts {
						if let (type, val) = parseLiteral(token) {
							if type.index == XDSConstantTypes.array.index {
								error = "Invalid array element, array cannot contain an array: \(token)"
								return nil
							}
							params.append(val[0])
						} else {
							error = "Invalid array element: \(token)"
							return nil
						}
						
					}
					return (XDSConstantTypes.array, params)
				} else {
					return nil
				}
			}
		}
		
		if text.substring(from: 0, to: 1) == "$" {
			let id = text.msgID
			let str = text.msgText
			
			if id != nil {
				if id! < 0 {
					error = "Invalid message id: \(text)"
					return nil
				}
			}
			
			if str != nil {
				if str == "" {
					error = "Invalid message id: \(text)"
					return nil
				}
			}
			
			if id == nil && str == nil {
				error = "Invalid msg macro: \(text)"
				return nil
			}
			
			let newID = str == nil ? id : handleMSGString(id: id, text: str!)
			if newID != nil {
				if newID! < 0 {
					// error in handlemsg
					return nil
				}
				return (XDSConstantTypes.integer, [XDSConstant.integer(newID!)])
			}
		}
		
		return (XDSConstantTypes.none_t, [XDSConstant.null])
	}
	
	
	class func tokeniseXDS(text: String) -> [String]? {
		// splits the line into individual tokens by spaces. spaces are ignored within brackets and strings so tokens like bracketed expressions or vector and string literals are considered one token.
		
		enum BracketScopes : String {
			case round = "("
			case square = "["
			case angled = "<"
			case curly = "{"
			case string = "\""
			case normal = ""
			
			var closing : String {
				switch self {
				case .round: return ")"
				case .square: return "]"
				case .angled: return ">"
				case .curly: return "}"
				case .string: return "\""
				case .normal: return ""
				}
			}
		}
		
		let scopeStack = XGStack<BracketScopes>()
		let stack = text.stack
		var currentToken = ""
		var tokens = [String]()
		scopeStack.push(.normal)
		
		while !stack.isEmpty {
			
			let current = stack.pop()
			
			if (current == " " && scopeStack.peek() == .normal) || (current == "\n" && scopeStack.peek() != .curly) {
				tokens.append(currentToken)
				currentToken = ""
			} else if (current == ";" && scopeStack.peek() != .string && scopeStack.peek() != .curly) {
				tokens.append(currentToken)
				currentToken = ""
			} else if scopeStack.peek() == .string {
				if current == "\"" {
					scopeStack.popVoid()
				}
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
				for bracket : BracketScopes in [.round, .square, .angled, .curly] {
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
								scopeStack.popVoid()
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
		
		return tokens.filter({ (s) -> Bool in
			return s.length > 0
		})
	}
	
	private class func handleSpecialMacro(tokens: [String]) -> Bool {
		
		if tokens[1] == "++ScriptIdentifier" {
			if let val = tokens[2].integerValue {
				scriptID = val
				return true
			} else {
				error = "Invalid script identifier: \(tokens[0]) \(tokens[1]) \(tokens[2])"
				return false
			}
		}
		
		
		if tokens[1] == "++XDSVersion" {
			if let val = Float(tokens[2]) {
				xdsversion = val
				if xdsversion > currentXDSVersion {
					error = "This compiler is too old. It was built for xds versions \(String(format: "%1.1f", currentXDSVersion)) and below.\n"
					error += "\(tokens[0]) \(tokens[1]) \(tokens[2])"
				}
				return true
			} else {
				error = "Invalid xds version: \(tokens[0]) \(tokens[1]) \(tokens[2])"
				return false
			}
		}
		
		
		error = "Unrecognised special macro: \(tokens[1])"
		return false
	}
	
	private class func handleAssignment(tokens: [String]) -> Bool {
		//TODO: complete handle assignments character data
		// don't forget to check for duplicate variable names
		
		var flags = 0
		var isVisible = false
		
		var xCoordinate : Float = 0
		var yCoordinate : Float = 0
		var zCoordinate : Float = 0
		var angle = 0
		
		var hasScript = false
		var scriptName = ""
		var hasPassiveScript = false
		var passiveScriptName = ""
		
		var model : XGCharacterModels!
		var movementType = XGCharacterMovements.index(0)
		var characterID = 0
		
		var gid = -1
		var rid = -1
		
		var name = "" // just for sanity checking the variable, doesn't affect the character data
		
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
			case "GroupID:":
				if let val = nextToken.integerValue {
					gid = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
			case "ResourceID:":
				if let val = nextToken.integerValue {
					rid = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "MovementID:":
				if let val = nextToken.integerValue {
					movementType = .index(val)
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "ModelID:":
				if let val = nextToken.integerValue {
					model = XGCharacterModels(index: val)
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "CharacterID:":
				if let val = nextToken.integerValue {
					characterID = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "Flags:":
				if let val = nextToken.integerValue {
					flags = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "Angle:":
				if let val = nextToken.integerValue {
					angle = val
					while angle < 0 {
						angle += 360
					}
					while angle >= 360 {
						angle -= 360
					}
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "X:":
				if let val = Float(nextToken) {
					xCoordinate = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "Y:":
				if let val = Float(nextToken) {
					yCoordinate = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "Z:":
				if let val = Float(nextToken) {
					zCoordinate = val
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "Script:":
				let functionName = nextToken
				if functionName.substring(from: 0, to: 1) == "@" && functionName.length > 1 {
					scriptName = functionName
					hasScript = true
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "Background:":
				let functionName = nextToken
				if functionName.substring(from: 0, to: 1) == "@" && functionName.length > 1 {
					passiveScriptName = functionName
					hasPassiveScript = true
				} else {
					error = "Invalid \(token) value: '\(nextToken)'"
					return false
				}
				
			case "Visible:":
				let b = nextToken
				if ["YES", "TRUE", "Yes", "True"].contains(b) {
					isVisible = true
				} else if ["NO", "FALSE", "No", "False"].contains(b) {
					isVisible = false
				} else {
					error = "Invalid assignment variable: \(token)"
					return false
				}
				
				
				
			default:
				error = "Invalid assignment variable: \(token)"
				return false
				
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
		
		if gid > 0 && rid >= 0 {
			
			let character = XGCharacter()
			
			character.angle = angle
			character.xCoordinate = xCoordinate
			character.yCoordinate = yCoordinate
			character.zCoordinate = zCoordinate
			character.characterID = characterID
			character.movementType = movementType
			character.hasScript = hasScript
			character.hasPassiveScript = hasPassiveScript
			character.flags = flags
			character.isVisible = isVisible
			character.model = model
			character.scriptName = scriptName
			character.passiveScriptName = passiveScriptName
			
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
		if tokens[1] == kXDSLastResultVariable {
			error = "'\(kXDSLastResultVariable)' is a special reserved variable name."
			for i in 0 ..< tokens.count {
				error += " " + tokens[i]
			}
			return false
		}
		if ["define", "call", "return", "function", "goto", "if", "ifnot", "Null", "global"].contains(tokens[1]) {
			error = "'\(tokens[1])' is a reserved keyword."
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
	
	class func macroprocessorXDS(text: String) -> String? {
		
		var updated = ""
		let lines = getLinesXDS(text: text)
		var macros = [(macro: XDSMacro, replacement: String)]()
		
		for line in lines {
			if let tokens = tokeniseXDS(text: line) {
				if tokens.count > 0 {
					if tokens[0] == "define" {
						
						// special define statements for compiler options
						if tokens.count == 3 {
							if tokens[1].contains("++") {
								if !handleSpecialMacro(tokens: tokens) {
									return nil
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
							for add in [" ", ".", ")", ">", "]", "(", "<", "[", "\"", "\n", "}", "{", ";"] {
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
	
	class func separateBySemiColons(text: String) -> [String] {
		
		enum BracketScopes : String {
			case curly = "{"
			case string = "\""
			case normal = ""
			
			var closing : String {
				switch self {
				case .curly: return "}"
				case .string: return "\""
				case .normal: return ""
				}
			}
		}
		
		let scopeStack = XGStack<BracketScopes>()
		let stack = text.stack
		var currentToken = ""
		var tokens = [String]()
		scopeStack.push(.normal)
		
		while !stack.isEmpty {
			
			let current = stack.pop()
			
			if (current == ";" && scopeStack.peek() != .string && scopeStack.peek() != .curly) {
				tokens.append(currentToken)
				currentToken = ""
			} else if scopeStack.peek() == .string {
				if current == "\"" {
					scopeStack.popVoid()
				}
				currentToken += current
			} else if let bracket = BracketScopes(rawValue: current) {
				
				scopeStack.push(bracket)
				currentToken += current
				
			} else {
				if current == "}" {
					if scopeStack.peek() == .curly {
						scopeStack.popVoid()
					}
				}
				currentToken += current
			}
			
			
			
		}
		if currentToken.length > 0 {
			tokens.append(currentToken)
		}
		
		return tokens.filter({ (s) -> Bool in
			return s.length > 0
		})
	}
	
	class func evalStatementXDS(body: String) -> [XDSExpr]? {
		var statements = [XDSExpr]()
		let lines = separateBySemiColons(text: body)
		for line in lines {
			if let subTokens = tokeniseXDS(text: line) {
				if let expr = evalTokensXDS(tokens: subTokens, subExpr: false) {
					statements.append(expr)
				} else {
					// error in eval tokens
					return nil
				}
			} else {
				// error in tokenise
				return nil
			}
		}
		
		return statements
	}
	
	class func evalTokensXDS(tokens: [String], subExpr: Bool) -> XDSExpr? {
		// the tokens are considered a "sub expression" if they are a part of a larger expression, the result of recursively evaluating tokens.
		// this doesn't include if they are part of a compound statement
		var tokens = tokens.filter { (s) -> Bool in
			return s.length > 0
		}
		if tokens.count == 0 { return .nop }
		
		if tokens.count == 1 {
			let token = tokens[0]
			
			// accept bracketed expressions, function calls, location markers, return statements or any sub expression
			if (token.contains("(") && token.contains(")")) || token.substring(from: 0, to: 1) == "@" || subExpr || token == "return" {
				
				if token.length == 0 {
					error = "Invalid token: \(token)"
					return nil
				}
				
				// return statement
				if token == "return" {
					return XDSExpr.XDSReturn
				}
				
				if token == "Null" {
					return XDSExpr.loadImmediate(XDSConstant.null)
				}
				
				if ["True", "Yes", "YES", "TRUE"].contains(token) {
					return XDSExpr.loadImmediate(XDSConstant.integer(1))
				}
				
				if ["False", "No", "NO", "FALSE"].contains(token) {
					return XDSExpr.loadImmediate(XDSConstant.integer(0))
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
				
				// string literal
				if token.substring(from: 0, to: 1) == "\"" {
					let string = token.replacingOccurrences(of: "\"", with: "")
					strgs.addUnique(string)
					let offset = getStringStartIndex(str: string)
					return .loadImmediate(XDSConstant(type: XDSConstantTypes.string.index, rawValue: offset))
				}
				
				if token.substring(from: 0, to: 1) == "$" {
					var id : Int? = token.msgID
					var text : String? = token.msgText
					
					if id != nil {
						if id! < 0 {
							error = "Invalid message id: \(token)"
							return nil
						}
					}
					
					if text != nil {
						if text == "" {
							error = "Invalid message id: \(token)"
							return nil
						}
					}
					
					if text != nil {
						id = handleMSGString(id: id, text: text!)
					}
					
					if id != nil {
						if id! < 0 {
							// error in handlemsg
							return nil
						}
						return XDSConstant.integer(id!).expression
					}
					
					// error in handlemsgstring
					return nil
					
				}
				
				// bracketed expression
				if token.first! == "(" && token.last! == ")" {
					if let inner = tokeniseXDS(text: token.substring(from: 1, to: token.length - 1)) {
						return evalTokensXDS(tokens: inner, subExpr: true)
					} else {
						error = "Invalid bracket contents: \(token)"
						return nil
					}
				}
				
				if let firstBracket = token.firstBracket {
					if firstBracket == "[" {
						if token.contains("[") && token.last! == "]" {
							// array element access
							// syntactic sugar but is actually implemented as a function call
							
							var index = ""
							var variable = ""
							let ss = token.stack
							while ss.peek() != "[" {
								variable += ss.pop()
							}
							ss.popVoid()
							while ss.count > 1 {
								index += ss.pop()
							}
							
							if let subTokens = tokeniseXDS(text: index) {
								if let indexpr = evalTokensXDS(tokens: subTokens, subExpr: true) {
									return XDSExpr.callStandard(7, 16, [XDSExpr.loadPointer(variable), indexpr])
								}
							}
							
						}
					} else {
						
						if token.contains("(") && token.last! == ")" {
							// unary operator, special type literal or function call
							
							var parameters = ""
							var functionName = ""
							var variableName = "" // either variable or class name
							var localClassName = "" // follows local variable
							let ss = token.stack
							while ss.peek() != "(" {
								functionName += ss.pop()
							}
							ss.popVoid()
							while ss.count > 1 {
								parameters += ss.pop()
							}
							
							var functionParameters = [XDSExpr]()
							var functionIndex = 0
							var classIndex = 0
							
							func getParameters() -> [XDSExpr]? {
								var paramList = [XDSExpr]()
								if let tokens = tokeniseXDS(text: parameters) {
									for t in tokens {
										if let expr = evalTokensXDS(tokens: [t], subExpr: true) {
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
								
								if functionName.substring(from: 0, to: 1) == "@" {
									
									if let params = getParameters() {
										functionParameters = params
									} else {
										return nil
									}
									
									if subExpr {
										return XDSExpr.call(functionName, functionParameters)
									} else {
										return XDSExpr.callVoid(functionName, functionParameters)
									}
								}
								
								// check if unary operator
								for (name,id,params) in ScriptOperators where params == 1 {
									if name == functionName {
										if let tokens = tokeniseXDS(text: parameters) {
											if let expr =  evalTokensXDS(tokens: tokens, subExpr: true) {
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
											return .loadImmediate(XDSConstant(type: type.index, rawValue: val.unsigned))
										} else if parameters == "" {
											return .loadImmediate(XDSConstant(type: type.index, rawValue: 0))
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
								if let info = XGScriptClass.classes(0).functionWithName(functionName) {
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
									
								} else if let cinfo = XGScriptClass.getClassNamed(variableName) {
									classIndex = cinfo.index
									if classIndex == 35 {
										error = "Character functions must be applied to a character variable: \(token)"
										return nil
									}
								} else {
									error = "Invalid class or global variable name: '\(variableName)'"
									return nil
								}
								
								if let finfo = XGScriptClass.classes(classIndex).functionWithName(functionName) {
									functionIndex = finfo.index
								} else {
									error = "Unrecognised function: '\(functionName)', for class: '\(XGScriptClass.classes(classIndex).name)'"
									return nil
								}
								
								
							case 3:
								// local variable class function call
								variableName   = String(functionParts[0])
								localClassName = String(functionParts[1])
								functionName   = String(functionParts[2])
								
								if let cinfo = XGScriptClass.getClassNamed(localClassName) {
									classIndex = cinfo.index
								} else {
									error = "Invalid class name: '\(localClassName)' on token: '\(token)'"
									return nil
								}
								
								if let finfo = XGScriptClass.classes(classIndex).functionWithName(functionName) {
									functionIndex = finfo.index
								} else {
									error = "Unrecognised function: '\(functionName)', for class: '\(XGScriptClass.classes(classIndex).name)'"
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
							
							if !subExpr {
								return .callStandardVoid(classIndex, functionIndex, functionParameters)
							}
							
							return .callStandard(classIndex, functionIndex, functionParameters)
							
						}
					}
				}
				
				if let val = token.integerValue {
					return XDSConstant.integer(val).expression
				}
				
				if let val = Float(token) {
					return XDSConstant.float(val).expression
				}
				
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
			
			// any other case is invalid
			error = "Invalid line: \(token)"
			return nil
		}
		
		// can be subExpr or not
		// if statement
		if tokens[0] == "if" && tokens.count > 1 {
			if tokens[1].length > 2 {
				var conditionBody = tokens[1]
				if conditionBody.first! == "(" && conditionBody.last! == ")" {
					
					conditionBody.removeFirst()
					conditionBody.removeLast()
					
					guard let conditionTokens = tokeniseXDS(text: conditionBody) else {
						error = "Invalid if statement condition: \(tokens[1])"
						return nil
					}
					
					if let condition = evalTokensXDS(tokens: conditionTokens, subExpr: true) {
						// TODO: check condition has valid format
						
						if tokens.count < 3 {
							error = "If statement if \(tokens[1]), missing statement body."
							return nil
						}
						
						var body = tokens[2]
						if body.length < 3 {
							error = "Invalid statement body for if statement \(tokens[1] + " " + tokens[2])."
							return nil
						}
						if body.first! == "{" && body.last == "}" {
							body.removeFirst()
							body.removeLast()
							if let subStatements = evalStatementXDS(body: body) {
								let sugar = XDSExpr.locationWithName(syntacticSugarVariableXDS())
								let jumpCondition = XDSExpr.jumpFalse(condition, sugar)
								return XDSExpr.ifStatement([(jumpCondition, subStatements + [XDSExpr.location(sugar)])])
							} else {
								// error in eval statement
								return nil
							}
						} else {
							error = "Invalid statement body for if statement \(tokens[1] + " " + tokens[2])."
							return nil
						}
						
						
					} else {
						error = "Invalid if statement condition: \(tokens[1])"
						return nil
					}
					
					
				} else {
					error = "If statement, invalid condition \(tokens[1])."
					return nil
				}
				
			} else {
				error = "If statement missing '(' and/or ')' for condition.\nInvalid line: "
				for t in tokens where t.first! != "{" {
					error += " " + t
				}
				return nil
			}
		}
		
		// These can only be sub expressions (e.g. function calls with return values)
		if subExpr {
			
			// binary operators
			if tokens.count == 3 {
				for (name,id,params) in ScriptOperators where params == 2 {
					if name == tokens[1] {
						if let e1 = evalTokensXDS(tokens: [tokens[0]], subExpr: true){
							if let e2 = evalTokensXDS(tokens: [tokens[2]], subExpr: true){
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
					if tokens[1].contains("(") && tokens[1].last! == ")" {
						// function definition
						var params = [XDSVariable]()
						
						let functionName = tokens[1].functionName!
						if let parameters = tokens[1].parameterString {
							if let paramTokens = tokeniseXDS(text: parameters) {
								for token in paramTokens {
									
									if token.isValidXDSVariable() {
										params.append(token)
									} else {
										error = "Invalid parameter variable name \(token) for function \(functionName)."
										return nil
									}
									
								}
								
								// initialise arguments and local variables as this is start of new function
								if locals[functionName] != nil {
									error = "Function must have a unique name.\nInvalid line: "
									for t in tokens where t.first! != "{" {
										error += " " + t
									}
									return nil
								}
								
								locals[functionName] = []
								args[functionName] = params
								currentFunction = functionName
								
								if tokens.count < 3 {
									error = "Function definition \(functionName), missing function body."
									return nil
								}
								
								var body = tokens[2]
								if body.length < 3 {
									error = "Invalid function body for function \(functionName)."
									return nil
								}
								if body.first! == "{" && body.last == "}" {
									body.removeFirst()
									body.removeLast()
									if let subStatements = evalStatementXDS(body: body) {
										let header = XDSExpr.functionDefinition(functionName, params)
										return XDSExpr.function(header, subStatements)
									} else {
										// error in eval statement
										return nil
									}
								} else {
									error = "Invalid function body for function \(functionName)."
									return nil
								}
								
							} else {
								// error in tokenise
								return nil
							}
						}
					} else {
						error = "Function definition \(tokens[1]) missing '(' and/or ')' after function name."
						return nil
					}
					
					} else {
						error = "Function header must be followed by a function location name.\nInvalid line: "
					for t in tokens where t.first! != "{" {
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
							if let expr = evalTokensXDS(tokens: subTokens, subExpr: true) {
								return .jumpTrue(expr, tokens[1])
							} else {
								error += "\nInvalid goto condition.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
						} else if tokens[2] == "ifnot" {
							if let expr = evalTokensXDS(tokens: subTokens, subExpr: true) {
								return .jumpFalse(expr, tokens[1])
							} else {
								error += "\nInvalid goto condition.\nInvalid line: "
								for t in tokens {
									error += " " + t
								}
								return nil
							}
						}  else {
							error = "Expected 'if' or 'ifnot' after location.\nInvalid line: "
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
			
			// return with return value
			if tokens[0] == "return" {
				var params = [String]()
				if tokens.count > 1 {
					for i in 1 ..< tokens.count {
						params.append(tokens[i])
					}
				}
				
				if let expr = evalTokensXDS(tokens: params, subExpr: true) {
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
					
					if let expr = evalTokensXDS(tokens: params, subExpr: true) {
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
							ss.popVoid()
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
							
							if let subTokens = tokeniseXDS(text: index!) {
								if let indexpr = evalTokensXDS(tokens: subTokens, subExpr: true) {
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
	
	
}
