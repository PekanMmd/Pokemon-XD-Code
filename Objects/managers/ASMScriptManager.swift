//
//  ASMScriptManager.swift
//  GoD Tool
//
//  Created by Stars Momodu on 31/08/2021.
//

import Foundation

/// ASM Script instructions
/// -----------------------
/// **Insert <Address>**
/// **Replace <Address>**
/// **Label <Name>**
/// **Raw**
///
/// ASM Script variables
/// -----------------------
/// **$Free** A reserved variable which will be dynamically allocated the next free address at run time
/// **$Name** Any other text preceded by $ should have its address allocated before being used
///

final class ASMScriptManager {

	enum ASMScriptError: Error {
		case invalidRegisterName
		case invalidInteger
		case invalidArgumentCount
		case invalidAddress
	}

	class func readScript(_ file: XGFiles) {
		guard let data = file.data else {
			printg("Couldn't read ASM script:", file.path)
			printg("Couldn't load file's data")
			return
		}
		readScript(data)
	}

	class func readScript(_ data: XGMutableData) {
		readScript(data.string)
	}

	class func readScript(_ text: String) {
		let lines = text.split(separator: "\n")

		var assembly = ASM()
		var labelAddresses = [String: Int]()
		var erroneousLines = [(lineNumber: Int, line: String, error: String)]()
		var currentOffset = -1

		// First pass for labels
		lines.forEachIndexed { (lineNumber, lineString) in
			let line = String(lineString)
			let tokens = line.split(separator: " ")
			// Comment character is #
			guard let firstCharacter = line.first, firstCharacter != "#", tokens.count > 0 else {
				return
			}

			if tokens[0].lowercased() == "label" {
				guard currentOffset >= 0 else {
					erroneousLines.append((lineNumber: lineNumber, line: line, error: "The offset for this label could not be calculated. Make sure to add an `insert` or `replace` instruction before using a label."))
					return
				}
			}
		}

		currentOffset = -1
		lines.forEachIndexed { (lineNumber, lineString) in
			let line = String(lineString)
			let tokens = line.split(separator: " ")
			// Comment character is #
			guard let firstCharacter = line.first, firstCharacter != "#", tokens.count > 0 else {
				return
			}

		}
	}

	private class func asmFromTextLine(_ text: String) throws -> XGASM? {
		let stripped = stripComments(text)
		guard stripped.length > 0 else { return nil }

		let tokens = stripped.split(separator: " ")
		guard tokens.count > 0 else {
			return nil
		}

//		switch tokens[0] {
//
//		}

		return nil
	}

	private class func registerFromTextToken(_ token: String) -> XGRegisters? {
		switch token {
		case "r0": return .r0
		case "r1": return .r1
		case "r2": return .r2
		case "r3": return .r3
		case "r4": return .r4
		case "r5": return .r5
		case "r6": return .r6
		case "r7": return .r7
		case "r8": return .r8
		case "r9": return .r9
		case "r10": return .r10
		case "r11": return .r11
		case "r12": return .r12
		case "r13": return .r13
		case "r14": return .r14
		case "r15": return .r15
		case "r16": return .r16
		case "r17": return .r17
		case "r18": return .r18
		case "r19": return .r19
		case "r20": return .r20
		case "r21": return .r21
		case "r22": return .r22
		case "r23": return .r23
		case "r24": return .r24
		case "r25": return .r25
		case "r26": return .r26
		case "r27": return .r27
		case "r28": return .r28
		case "r29": return .r29
		case "r30": return .r30
		case "r31": return .r31
		case "sp": return .sp
		case "lr": return .lr
		case "ctr": return .ctr
		case "srr0": return .srr0
		case "srr1": return .srr1
		default: return nil
		}
	}

	private class func stripWhiteSpace(_ text: String) -> String {
		return text.replacingOccurrences(of: "\t", with: " ").replacingOccurrences(of: "  ", with: " ")
	}

	private class func stripComments(_ text: String) -> String {
		guard text.contains("#") else { return "" }

		var stripped = ""
		for char in text {
			guard char != "#" else {
				return stripped
			}
			stripped.append(char)
		}
		return stripped
	}
}
