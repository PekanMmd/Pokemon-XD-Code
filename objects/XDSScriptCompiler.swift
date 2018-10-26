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
	
	// MARK: - variables
	static var giris  = (names: [XDSVariable](), values: [GIRI]())
	static var gvars  = (names: [XDSVariable](), values: [XDSConstant]())
	static var arrys  = (names: [XDSVariable](), values: [[XDSConstant]]())
	static var vects  = (names: [XDSVariable](), values: [VECT]())
	static var args   = [String : [XDSVariable]]()
	static var locals = [String : [XDSVariable]]()
	static var strgs  = [String]()
	static var locations = [String : Int]()
	static var characters = [XGCharacter]()
	
	// special variables
	static var scriptID = 0 // currently unknown what this value represents
	static var baseStringID = 0
	static var xdsversion : Float = 0.0
	static var writeDisassembly = false
	static var decompileXDS = false
	static var updateStringIDs = false
	static var increaseMSGSize = false
	
	static var scriptFile : XGFiles?
	static var stringTable : XGStringTable?
	static var relFile     : XGMapRel?
	static var targetFileName = ""
	
	static var error = ""
	static var currentFunction = ""
	static var sugarVarCounter = 1
	
	static var updatedText = ""
	
	class func setFlags(disassemble: Bool, decompile: Bool, updateStrings: Bool, increaseMSG: Bool) {
		writeDisassembly = disassemble
		decompileXDS = decompile
		updateStringIDs = updateStrings
		increaseMSGSize = increaseMSG
	}
	
	class func clearCompilerFlags() {
		writeDisassembly = false
		decompileXDS = false
		updateStringIDs = false
		increaseMSGSize = false
		scriptFile = nil
		relFile = nil
		stringTable = nil
		targetFileName = ""
		updatedText = ""
	}
	
	// MARK: - specify file or text to compile
	class func compile(textFile file: XGFiles) -> Bool {
		let scdFile = XGFiles.scd(file.fileName.removeFileExtensions())
		return compile(textFile: file, toFile: scdFile)
	}
	
	class func compile(textFile file: XGFiles, toFile target: XGFiles) -> Bool {
		if file.exists {
			scriptFile = file
			return compile(text: file.text, toFile: target)
		}
		return false
	}
	
	class func compile(text: String, toFile file: XGFiles) -> Bool {
		
		targetFileName = file.fileName.removeFileExtensions()
		updatedText = text
		if let file = XDSScriptCompiler.scriptFile {
			
			if file.folder.files.contains(where: { (rel) -> Bool in
				return (targetFileName == file.fileName.removeFileExtensions()) && rel.fileType == .rel
			}) {
				relFile = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.rel.fileExtension, file.folder).mapData
			}
			
			if file.folder.files.contains(where: { (msg) -> Bool in
				return (targetFileName == file.fileName.removeFileExtensions()) && msg.fileType == .msg
			}) {
				stringTable = XGFiles.nameAndFolder(file.fileName.removeFileExtensions() + XGFileTypes.msg.fileExtension, file.folder).stringTable
			}
			
		}
		
		if relFile == nil && XGFiles.rel(targetFileName).exists {
			relFile = XGFiles.rel(targetFileName).mapData
		}
		
		if stringTable == nil && XGFiles.msg(targetFileName).exists {
			stringTable = XGFiles.msg(targetFileName).stringTable
		}
		
		if let data = compile(text) {
			data.file = file
			data.save()
			saveFiles()
			
			if file.exists {
				printg("Successfully compiled script: \(file.fileName)!")
				if writeDisassembly {
					printg("Disassembling newly compiled file...")
					file.scriptData.description.save(toFile: .nameAndFolder(file.fileName + ".txt", file.folder))
					printg("Disassembly complete!")
				}
				if decompileXDS {
					printg("redecompiling newly compiled file...")
					file.scriptData.getXDSScript().save(toFile: .nameAndFolder(file.fileName.removeFileExtensions() + "_decompiled.xds", file.folder))
					printg("Decompilation complete!")
				}
				
				clearCompilerFlags()
				return true
			} else {
				
				let errorString = "XDS compilation error, File: \(file.fileName) \nError- failed to save file."
				printg(errorString)
				
				clearCompilerFlags()
				return false
			}
		}
		
		clearCompilerFlags()
		let errorString = "XDS compilation error, File: \(file.fileName) \nError-" + error
		
		printg(errorString)
		return false
	}
	
	class func saveFiles() {
		
		loadAllStrings()
		if let table = stringTable {
			for stable in allStringTables where stable.file.path == table.file.path {
				printg("saving string table:", stable.file.path)
				stable.save()
			}
		}
		
		if relFile != nil {
			printg("saving characters.")
			for character in characters {
				if verbose {
					printg("saving character:", character.rid)
				}
				character.save()
			}
		}
		
		if updatedText.length > 0 {
			if let file = scriptFile {
				printg("saving updated text.")
				updatedText.save(toFile: file)
			}
		}
		
	}
	
	class func compile(_ script: String) -> XGMutableData? {
		
		giris  = (names: [XDSVariable](), values: [GIRI]())
		gvars  = (names: [XDSVariable](), values: [XDSConstant]())
		arrys  = (names: [XDSVariable](), values: [[XDSConstant]]())
		vects  = (names: [XDSVariable](), values: [VECT]())
		args   = [String : [XDSVariable]]()
		locals = [String : [XDSVariable]]()
		strgs  = [String]()
		locations = [String : Int]()
		characters = [XGCharacter]()
		currentFunction = ""
		sugarVarCounter = 1
		
		scriptID = 0
		baseStringID = 0
		xdsversion = 0
		
		let strippedComments = stripComments(text: script)
		let stripped = stripWhiteSpace(text: strippedComments)
		
		if stripped == nil {
			return nil
		}
		
		let macro = macroprocessor(text: stripped!)
		
		if macro == nil {
			return nil
		}
		
		let statements = getLines(text: macro!)
		
		var expressions = [XDSExpr]()
		for statement in statements {
			if let tokens = tokenise(text: statement) {
				
				if let eval = evalTokens(tokens: tokens) {
					expressions.append(eval)
				} else {
					return nil
				}
			} else {
				return nil
			}
		}
		
		let stack = createExprStack(expressions)
		locations = getLocations(expressions)
		
		let ftbl = getFTBL(expressions)
		if let code = getCODE(stack, gvar: gvars.names, arry: arrys.names, giri: giris.names) {
			
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
			
			if let rel = relFile {
				if !writeCharacterDataToRel(file: rel.file, ftbl: ftbl) {
					printg("failed to save character data")
					printg(error)
				}
			} else {
				printg("Skipping character assignment. Map file for script was not found.")
			}
			
			
			return compiled
		}
		return nil
	}
	
	class func handleMSGString(id: Int?, text: String) -> Int? {
		// pass string without surrounding quotation marks
		// if id is nil then generate a new string with the next free id
		// replace occurrences of [Quote] with \"
		// check that id isn't 0 otherwise simply return 0 without parsing string
		// use baseStringID as starting value to search for unused string ids
		// return -1 if failed to replace string and set error
		
		// return the strings finalised id or -1 if failed
		let uptext = text.replacingOccurrences(of: "[Quote]", with: "\"")
		if verbose {
			if text.length > 0 {
				printg("Replacing msg\(id == nil ? " by creating new id:" + text : "with id: \(id!.hexString()) " + text)")
			}
		}
		
		var newID : Int? = nil
		
		if id != nil {
			newID = id
			if id! > kMaxStringID {
				error = "The maximum string id is 0xFFFFF (1048575): \(id!) - \(text)"
				return -1
			}
			
			var found = false
			if let table = stringTable {
				if table.containsStringWithId(newID!) {
					found = true
					let string = XGString(string: uptext, file: table.file, sid: newID)
					loadAllStrings()
					for stable in allStringTables {
						if stable.file.path == table.file.path {
							if !stable.replaceString(string, alert: false, save: false, increaseLength: true) {
								error = "Failed to replace msg: $:\(id!):\"\(text)\"\n maybe because the string was too large.\nTry setting '++IncreaseMSGSize' to 'YES'."
								return -1
							}
						}
					}
				}
			}
			
			if !found {
				if let msg = getStringWithID(id: id!) {
					if !msg.duplicateWithString(uptext).replace(increaseSize: increaseMSGSize, save: false) {
						error = "Failed to replace msg: $:\(id!):\"\(text)\"\n either the msg doesn't exist in any file or the string was too large.\nIn the event of the latter try setting 'Increase MSG  Size' to 'YES'."
						return -1
					}
				} else {
					if let stable = stringTable {
						loadAllStrings()
						for table in allStringTables {
							if table.file.path == stable.file.path {
								let string = XGString(string: uptext, file: table.file, sid: newID)
								if table.addString(string, increaseSize: increaseMSGSize, save: true) {
									if verbose {
										printg("Added string :\(text) to file: \(stable.file.path) with ID: \(newID!)")
									}
								} else {
									error = "Failed to replace msg: $:\(id!):\"\(text)\"\n maybe because the string was too large.\nTry setting 'Increase MSG Size' to 'YES'."
									return -1
								}
							}
						}
					}
				}
			}
		} else {
			if let stable = stringTable {
				newID = freeMSGID(from: baseStringID)
				if newID != nil {
					loadAllStrings()
					for table in allStringTables {
						if table.file.path == stable.file.path {
							let string = XGString(string: uptext, file: table.file, sid: newID)
							if table.addString(string, increaseSize: increaseMSGSize, save: false) {
								if verbose {
									printg("Added string :\(text) to file: \(table.file.path) with ID: \(newID!)")
								}
								
								if updateStringIDs {
									if let file = scriptFile {
										if file.fileType == .xds {
											updatedText = updatedText.replacingOccurrences(of: "$" + "\"" + text + "\"", with: "$:\(newID!):" + "\"" + text + "\"")
											updatedText = updatedText.replacingOccurrences(of: "$::" + "\"" + text + "\"", with: "$:\(newID!):" + "\"" + text + "\"")
										}
									}
								}
								
							} else {
								error = "Couldn't create string with id: \(id!)"
								return -1
							}
						}
					}
				} else {
					error = "Couldn't find a new string id after \(baseStringID)."
					return -1
				}
			} else {
				error = "Failed to add msg: $:\(id!):\"\(text)\"\n as the msg file '\(targetFileName + XGFileTypes.msg.fileExtension)' couldn't be found."
				return -1
			}
		}
		
		return newID
	}
	
	class func getStringStartIndex(str: String) -> UInt32 {
		var start = 0
		for s in strgs {
			if s == str {
				return UInt32(start)
			}
			start += s.length + 1
		}
		return UInt32(start) // should never hit this case in theory
	}
	
	// MARK: - language specific parsing
	// In order to compile other programming or scripting languages
	// simply create custom versions of these functions and
	// add cases to the switch statements to determine which
	// file extensions the format is for.
	private class func macroprocessor(text: String) -> String? {
		if let file = XDSScriptCompiler.scriptFile {
			let ext = file.fileExtension
			switch ext {
			case "xds": return macroprocessorXDS(text: text)
			default:    break
			}
		}
		return macroprocessorXDS(text: text)
	}
	
	private class func getLines(text: String) -> [String] {
		if let file = XDSScriptCompiler.scriptFile {
			let ext = file.fileExtension
			switch ext {
			case "xds": return getLinesXDS(text: text)
			default:    break
			}
		}
		return getLinesXDS(text: text)
	}
	
	private class func stripWhiteSpace(text: String) -> String? {
		if let file = XDSScriptCompiler.scriptFile {
			let ext = file.fileExtension
			switch ext {
			case "xds": return stripWhiteSpaceXDS(text: text)
			default:    break
			}
		}
		return stripWhiteSpaceXDS(text: text)
	}
	
	private class func stripComments(text: String) -> String {
		if let file = XDSScriptCompiler.scriptFile {
			let ext = file.fileExtension
			switch ext {
			case "xds": return stripCommentsXDS(text: text)
			default:    break
			}
		}
		return stripCommentsXDS(text: text)
	}
	
	private class func tokenise(text: String) -> [String]? {
		if let file = XDSScriptCompiler.scriptFile {
			let ext = file.fileExtension
			switch ext {
			case "xds": return tokeniseXDS(text: text)
			default:    break
			}
		}
		return tokeniseXDS(text: text)
	}
	
	private class func evalTokens(tokens: [String]) -> XDSExpr? {
		if let file = XDSScriptCompiler.scriptFile {
			let ext = file.fileExtension
			switch ext {
			case "xds": return evalTokensXDS(tokens: tokens, subExpr: false)
			default:    break
			}
		}
		return evalTokensXDS(tokens: tokens, subExpr: false)
	}

	//MARK: - process the expressions
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
			case .functionDefinition(let name, _):
				locations[name] = currentLocation
			case .ifStatement(let parts):
				for (condition, block) in parts {
					var SubCount = 0
					for (loc, val) in getLocations(block) {
						locations[loc] = val + currentLocation + condition.instructionCount + SubCount
					}
					SubCount += condition.instructionCount
					for b in block {
						SubCount += b.instructionCount
					}
				}
			case .whileLoop(let condition, let block):
				for (loc, val) in getLocations(block) {
					locations[loc] = val + currentLocation + condition.instructionCount
				}
			case .function(.functionDefinition(let location, _), let block):
				locations[location] = currentLocation
				for (loc, val) in getLocations(block) {
					locations[loc] = val + currentLocation + 1 //1 is (header.instructionCount)
				}
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
			case .function(.functionDefinition(let name, _), let block):
				functions += [(currentLocation, 0, name, functions.count)]
			default:
				break
			}
			currentLocation += expr.instructionCount
		}
		
		return functions
	}
	
	private class func getCODE(_ exprs: XGStack<XDSExpr>, gvar: [String], arry: [String], giri: [String]) -> [XGScriptInstruction]? {
		
		var instructions = [XGScriptInstruction]()
		
		let expressions = exprs
		while !expressions.isEmpty {
			let nextExpression = expressions.pop()
			
			switch nextExpression {
			case .function(.functionDefinition(let name, _), _):
				currentFunction = name
			default: break
			}
			
			switch nextExpression {
			case .call(let name, _):
				if args[name] == nil {
					error = "Error in script function call: '\(name)' is not a function location."
					return nil
				}
			case .callVoid(let name, _):
				if args[name] == nil {
					error = "Error in script function call: '\(name)' is not a function location."
					return nil
				}
			case .jump(let location):
				if locations[location] == nil {
					error = "Invalid goto location: location '\(location)' doesn't exist."
					return nil
				}
			case .jumpTrue(_, let location):
				if locations[location] == nil {
					error = "Invalid goto location: location '\(location)' doesn't exist."
					return nil
				}
			case .jumpFalse(_, let location):
				if locations[location] == nil {
					error = "Invalid goto location: location '\(location)' doesn't exist."
					return nil
				}
			default:
				break
				
			}
			
			let (instructs, errorString) = nextExpression.instructions(gvar: gvar, arry: arry, giri: giri, locals: locals[currentFunction]!, args: args[currentFunction]!, locations: locations)
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
	
	private class func writeCharacterDataToRel(file: XGFiles, ftbl: [FTBL]) -> Bool {
		
		let rel = XGMapRel(file: file, checkScript: false)
		
		
		// cannot simply count characters as there's no guarantee the RIDs are consecutive
		var maxRID = -1
		for character in XDSScriptCompiler.characters {
			maxRID = max(maxRID, character.rid)
		}
		if maxRID >= rel.characters.count {
			// TODO: add space for extra characters
			error = "Character resource id is larger than the file's maximum of \(rel.characters.count)"
			return false
		}
		
		
		for character in XDSScriptCompiler.characters  {
			character.file = file
			character.characterIndex = character.rid
			if character.rid >= 0 {
				
				for (_, _, name, index) in ftbl {
					if name == character.scriptName {
						character.scriptIndex = index
						character.hasScript = true
					}
					if name == character.passiveScriptName {
						character.passiveScriptIndex = index
						character.hasPassiveScript = true
					}
				}
				
				if character.gid > 0 && character.rid < rel.characters.count {
					character.startOffset = rel.characters[character.rid].startOffset
				} else if character.gid == 0 {
					printg("error: can't write character data for player or party characters with group id of 0")
				} else {
					printg("error: can't write character data for negative group id: \(character.rid)")
				}
			} else {
				printg("error: can't write character data for negative character id: \(character.rid)")
			}
			
		}
		
		return true
	}
	
	// MARK: - compiling the script object to .scd format
	private class func compileTCOD(size: Int) -> XDSCode {
		return [0x54434F44,UInt32(size + 0x10),0x0,0x0]
	}
	
	private class func compileFTBL(_ data: [FTBL]) -> XDSCode {
		
		var code = XDSCode()
		code += [0x4654424C] // unicode 'FTBL'
		
		var headSize : UInt32 = UInt32(data.count) * 8
		var stringSize : UInt32 = 0x0
		
		var functionNames = [String]()
		for (_, _, n, _) in data {
			let name = n.substring(from: 1, to: n.length)
			functionNames.addUnique(name)
			stringSize += UInt32(name.length) + 1 // + 1 for space
		}
		
		let firstStringOffset = headSize + 0x20
		
		var sectionSize = headSize + stringSize + 0x20
		// make sure section is padded for alignment
		let remainder = 16 - (sectionSize % 16)
		if remainder < 16 {
			sectionSize += remainder
		}
		
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
		for (codeOffset, _, n, _) in data {
			let name = n.substring(from: 1, to: n.length)
			code += [UInt32(codeOffset)]
			code += [getFuncNameStartIndex(str: name) + firstStringOffset]
		}
		
		// fill strings
		var currentWord : UInt32 = 0x0
		var currentByteIndex = 3
		
		// adds one byte at a time, buffering into a uint32 and adding the whole word once full
		func addByte(_ byte: UInt8) {
			let value = UInt32(byte) << (currentByteIndex * 8)
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
				addByte(char.unicode)
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
		let remainder = 16 - (sectionSize % 16)
		if remainder < 16 {
			sectionSize += remainder
		}
		
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
		let remainder = 16 - (sectionSize % 16)
		if remainder < 16 {
			sectionSize += remainder
		}
		
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
		let remainder = 16 - (sectionSize % 16)
		if remainder < 16 {
			sectionSize += remainder
		}
		
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
		let remainder = 16 - (sectionSize % 16)
		if remainder < 16 {
			sectionSize += remainder
		}
		
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
			
			var initialised : UInt32 = 0 // set to 1 if array already has usable values. 0 all set to 0
			for element in a {
				if element.asInt > 0 {
					initialised = 1
				}
			}
			
			let indexInit = (initialised << 24) + currentIndex
			arrayCode += [UInt32(a.count), 0, indexInit, 0] // array header
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
		let remainder = 16 - (sectionSize % 16)
		if remainder < 16 {
			sectionSize += remainder
		}
		
		code += [UInt32(sectionSize)] // section size
		code += [0,0] // padding
		code += [UInt32(data.count)] // number of entries
		code += [0,0,0] // padding
		
		var currentWord : UInt32 = 0x0
		var currentByteIndex = 3
		
		// adds one byte at a time, buffering into a uint32 and adding the whole word once full
		func addByte(_ byte: UInt8) {
			let value = UInt32(byte) << (currentByteIndex * 8)
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
				addByte(char.unicode)
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
		let remainder = 16 - (sectionSize % 16)
		if remainder < 16 {
			sectionSize += remainder
		}
		
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
		let remainder = 16 - (sectionSize % 16)
		if remainder < 16 {
			sectionSize += remainder
		}
		
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















































