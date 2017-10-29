//
//  XGExtensions.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 04/03/2017.
//  Copyright © 2017 StarsMmd. All rights reserved.
//

import Foundation

// extension [Int]
//func byteString

extension Sequence where Iterator.Element == Int {
	var byteString : String {
		var s = ""
		for i in self {
			s += String(format: "%02x ", i)
		}
		return s
	}
}

extension NSObject {
	func println() {
		printg(self)
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
	
	func hex() -> String {
		return String(format: "%x", self)
	}
	
	func hexString() -> String {
		return String(format: "0x%x", self)
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
	
}

extension UInt32 {
	
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
	
}

extension Float {
	var string : String {
		return String(describing: self)
	}
}

extension String {
	var simplified : String {
		get {
			var s = self.replacingOccurrences(of: " ", with: "")
			s = s.replacingOccurrences(of: "-", with: "")
			return s.lowercased()
		}
	}
	
	var length : Int {
		return self.characters.count
	}
	
	func substring(from: Int, to: Int) -> String {
		
		if to <= from {
			return ""
		}
		if from > self.characters.count {
			return ""
		}
		if to <= 0 {
			return ""
		}
		
		let f = from < 0 ? 0 : from
		let t = to > self.characters.count ? self.characters.count : to
		
		let start = self.characters.index(self.startIndex, offsetBy: f)
		let subStart = self.substring(from: start)
		return subStart.substring(to: self.characters.index(self.startIndex, offsetBy: t - f))
		
	}
}




