//
//  XGExtensions.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 04/03/2017.
//  Copyright © 2017 StarsMmd. All rights reserved.
//

import Foundation

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




