//
//  XGExtensions.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 04/03/2017.
//  Copyright © 2017 StarsMmd. All rights reserved.
//

import Foundation


extension Sequence where Iterator.Element == Int {
	var byteString : String {
		var s = ""
		for i in self {
			s += String(format: "%02x ", i)
		}
		return s
	}
	
	var hexStream : String {
		var s = ""
		for i in self {
			s += String(format: "%02x ", i)
		}
		return s
	}
}

extension Array where Element == Int {
	
	mutating func addUnique(_ new: Int) {
		if !self.contains(new) {
			self.append(new)
		}
	}
	
}

extension Array where Element == String {
	
	mutating func addUnique(_ new: String) {
		if !self.contains(new) {
			self.append(new)
		}
	}
	
}


extension NSObject {
	@objc func println() {
		printg(self)
	}
}

extension Bool {
	var string : String {
		return self ? "Yes" : "No"
	}
}

extension Int {
	
	var boolean : Bool {
		return self != 0
	}
	
	var string : String {
		return String(self)
	}
	
	var unsigned : UInt32 {
		if self >= 0 {
			return UInt32(self)
		}
		return UInt32(0xFFFFFFFF) - UInt32(-(self + 1))
	}
	
	func println() {
		printg(self)
	}
	
	func hex() -> String {
		return String(format: "%x", self).uppercased()
	}
	
	func hexString() -> String {
		return "0x" + hex()
	}
	
	var byteArray : [Int] {
		var val = self
		var array = [0,0,0,0]
		for j in [3,2,1,0] {
			array[j] = Int(val % 0x100)
			val = val >> 8
		}
		return array
	}
	
	var charArray : [UInt8] {
		return byteArray.map({ (i) -> UInt8 in
			return UInt8(i)
		})
	}
	
	func stringIDToString() -> XGString {
		return getStringSafelyWithID(id: self)
	}
	
}

extension UInt32 {
	
	func println() {
		printg(self)
	}
	
	func hexToSignedFloat() -> Float {
		var toInt = Int32(bitPattern: self)
		var float : Float32 = 0
		memcpy(&float, &toInt, MemoryLayout.size(ofValue: float))
		return float
	}
	
	var byteArray : [Int] {
		var val = self
		var array = [0,0,0,0]
		for j in [3,2,1,0] {
			array[j] = Int(val % 0x100)
			val = val >> 8
		}
		return array
	}
	
	var charArray : [UInt8] {
		return byteArray.map({ (i) -> UInt8 in
			return UInt8(i)
		})
	}
	
	var int : Int {
		return Int(self)
	}
	
	var int16 : Int {
		var value = (self & 0xFFFF).int
		value = value > 0x8000 ? value - 0x10000 : value
		return value
	}
	
	var int32 : Int {
		var value = (self & 0xFFFFFFFF).int
		value = value > 0x80000000 ? value - 0x100000000 : value
		return value
	}
	
	func hex() -> String {
		return String(format: "%08x", self).uppercased()
	}
	
	func hexString() -> String {
		return "0x" + hex()
	}
	
	func stringIDToString() -> XGString {
		return getStringSafelyWithID(id: self.int)
	}
	
}

extension Float {
	
	func println() {
		printg(self)
	}
	
	var string : String {
		return String(describing: self)
	}
	
	func raisedToPower(_ pow: Int) -> Float {
		var result : Float = 1.0
		for _ in 0 ..< pow {
			result *= self
		}
		return result
	}
	
	func floatToHex() -> UInt32 {
		return self.bitPattern
	}
	
}

extension String {
	
	func println() {
		printg(self)
	}
	
	func spaceToLength(_ length: Int) -> String {
		
		var spaces = ""
		let wordLength = self.characters.count
		for i in 1 ... length {
			if i > wordLength {
				spaces += " "
			}
		}
		
		return self + spaces
	}
	
	func spaceLeftToLength(_ length: Int) -> String {
		
		var spaces = ""
		let wordLength = self.characters.count
		for i in 1 ... length {
			if i > wordLength {
				spaces += " "
			}
		}
		
		return spaces + self
	}
	
	func removeFileExtensions() -> String {
		let extensionIndex = self.characters.index(of: ".") ?? self.endIndex
		
		return self.substring(to: extensionIndex)
	}
	
	var fileExtensions : String {
		let extensionIndex = self.characters.index(of: ".") ?? self.endIndex
		
		return self.substring(from: extensionIndex)
	}
	
	var cppEnum : String {
		// convention used in PkmGCTools by Tux
		return self.replacingOccurrences(of: "-", with: " ").capitalized.replacingOccurrences(of: " ", with: "")
		
	}
	
	var functionName : String? {
		if !self.contains("(") || !self.contains(")") {
			return nil
		}
		var string = ""
		let ss = self.stack
		while ss.peek() != "(" {
			string += ss.pop()
		}
		return string
	}
	
	var parameterString : String? {
		if !self.contains("(") || !self.contains(")") {
			return nil
		}
		if self.functionName == nil {
			return nil
		}
		var string = ""
		let ss = self.replacingOccurrences(of: self.functionName! + "(", with: "").stack
		while ss.count > 1 {
			string += ss.pop()
		}
		if ss.peek() != ")" {
			return nil
		}
		return string
	}
	
	var firstBracket : String? {
		if !self.contains("(") && !self.contains("[") {
			return nil
		}
		let ss = self.stack
		while !ss.isEmpty {
			let b = ss.pop()
			if "([".contains(b) {
				return b
			}
		}
		return nil
	}
	
	func isValidXDSVariable() -> Bool {
		if self.length == 0 { return false }
		if self == self.capitalized { return false}
		if "0123456789".contains(self.first!) { return false }
		let s = self.stack
		while !s.isEmpty {
			let c = s.pop()
			if !"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".contains(c) {
				return false
			}
		}
		
		return true
	}
	
	func save(toFile file: XGFiles) {
		XGUtility.saveString(self, toFile: file)
	}
	
	func hexStringToInt() -> Int {
		return Int(strtoul(self, nil, 16)) // converts hex string to uint and then cast as Int
	}
	
	var isHexInteger : Bool {
		
		if self.length < 3 {
			return false
		}
		
		if self.substring(from: 0, to: 2) != "0x" {
			return false
		}
		let remaining = self.substring(from: 2, to: self.length).stack
		while !remaining.isEmpty {
			let next = remaining.pop()
			if !"0123456789abcdefABCDEF".contains(next) {
				return false
			}
		}
		return true
	}
	
	var integerValue : Int? {
		if self.isHexInteger {
			return self.hexStringToInt()
		} else {
			return Int(self)
		}
	}
	
	var simplified : String {
		get {
			var s = self.replacingOccurrences(of: " ", with: "")
			s = s.replacingOccurrences(of: "-", with: "")
			s = s.replacingOccurrences(of: "é", with: "e")
			s = s.replacingOccurrences(of: ".", with: "")
			s = s.replacingOccurrences(of: "'", with: "")
			s = s.replacingOccurrences(of: "\"", with: "")
			s = s.replacingOccurrences(of: "/", with: "")
			s = s.replacingOccurrences(of: "\\", with: "")
			return s.lowercased()
		}
	}
	
	func addRepeated(s: String, count: Int) -> String {
		if count < 1 {
			return self
		}
		var result = self
		for _ in 0 ..< count {
			result += s
		}
		return result
	}
	
	var length : Int {
		return self.characters.count
	}
	
	func substring(from: Int, to: Int) -> String {
		// includes from, excludes to
		
		if to <= from {
			return ""
		}
		if from > self.count {
			return ""
		}
		if to <= 0 {
			return ""
		}
		
		let f = from < 0 ? 0 : from
		let t = to > self.count ? self.count : to
		
		let start = self.index(self.startIndex, offsetBy: f)
		let end = self.index(self.startIndex, offsetBy: t)
		return String(self[start..<end])
		
	}
	
	var stack : XGStack<String> {
		let s = XGStack<String>()
		var string = self
		for _ in 0 ..< self.count {
			let last = String(describing: string.removeLast())
			s.push(last)
		}
		return s
	}
	
	var msgID : Int? {
		// returns negative value if invalid msgmacro, nil if doesn't exist
		if self.length < 3 {
			return -1
		}
		let ss = self.stack
		if ss.peek() != "$" {
			return -1
		}
		ss.pop() // remove leading $
		
		// check if has an id
		if ss.peek() == ":" {
			ss.pop() // remove opening ':'
			var idText = ""
			while ss.peek() != ":" {
				idText += ss.pop()
				if ss.isEmpty {
					return -1
				}
				if ss.peek() == "\"" {
					return -1
				}
			}
			
			if idText.length == 0 {
				return nil
			}
			
			return idText.integerValue == nil ? -1 : idText.integerValue!
		} else if ss.peek() == "\"" {
			return nil
		} else {
			return -1
		}
	}
	
	var msgText : String? {
		// return empty string if error, nil if doesn't exist
		
		if self.length < 3 {
			return ""
		}
		let ss = self.stack
		if ss.peek() != "$" {
			return ""
		}
		ss.pop() // remove leading $
		
		// check if has an id
		if ss.peek() == ":" {
			ss.pop() // remove opening ':'
			while ss.peek() != ":" {
				ss.pop()
				if ss.isEmpty {
					return ""
				}
			}
			if ss.peek() == ":" {
				ss.pop() // remove closing ':'
			}
		}
		
		var text = ""
		while !ss.isEmpty {
			text += ss.pop()
		}
		if text.length > 2 {
			if text.first! == "\"" && text.last! == "\"" {
				text.removeFirst()
				text.removeLast()
				return text
			}
			return ""
		} else if text.length == 0 {
			return nil
		} else {
			return ""
		}
		
	}
	
}








