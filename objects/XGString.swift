//
//  XGString.swift
//  XG Tool
//
//  Created by StarsMmd on 25/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

class XGString: NSObject {
	
	var chars = [XGUnicodeCharacters]()
	
	var table = XGFiles.nameAndFolder("", .Documents)
	var id	  = 0
	
	var length : Int {
		get {
			var count = 0
			for char in chars {
				count += char.length
			}
			return count
		}
	}
	
	override var description : String {
		get {
			return string
		}
	}
	
	var string : String {
		get {
			var str = ""
			for char in chars {
				str = str + char.string
			}
			return str
		}
	}
	
	var stringPlusIDAndFile : String {
		get {
			return "ID : 0x" + String(format: "%x", id) + " " + "\(id)" + " \nFile: \(table.fileName)\n\(string)\n"
		}
	}
	
	var byteStream : [UInt8] {
		get {
			var stream = [UInt8]()
			for char in chars {
				stream = stream + char.byteStream
			}
			return stream
		}
	}
	
	override func isEqual(_ object: Any?) -> Bool {
		
		if object == nil {
			return false
		}
		
		if !((object! as AnyObject).isKind(of: XGString.self)) {
			return false
		}
		
		let cmpstr = object! as! XGString
		
		return self.string == cmpstr.string
		
	}
	
	func copyString() {
//		let pb = UIPasteboard.generalPasteboard()
//		pb.string = self.string
	}
	
	func append(_ char: XGUnicodeCharacters) {
		self.chars.append(char)
	}
	
	func println() {
		print(self.string)
	}
	
	init(string: String, file: XGFiles?, sid: Int?) {
		super.init()
		
		self.table = file ?? XGFiles.nameAndFolder("", .Documents)
		self.id = sid ?? 0
		
		var chars = [XGUnicodeCharacters]()
		
		var current   = string.startIndex
		let end		  = string.endIndex
		
		while current != end {
			
			var char = string.substring(with: (current ..< string.characters.index(current, offsetBy: 1)))
			current = string.characters.index(current, offsetBy: 1)
			
			if char == "[" {
				var midString = ""
				
				char = string.substring(with: (current ..< string.characters.index(current, offsetBy: 1)))
				current = string.characters.index(current, offsetBy: 1)
				
				while char != "]" {
					midString = midString + char
					
					char = string.substring(with: (current ..< string.characters.index(current, offsetBy: 1)))
					current = string.characters.index(current, offsetBy: 1)
				}
				
				let sp = XGSpecialCharacters.fromString(midString)
				var extraBytes = [Int]()
				
				if sp.extraBytes > 0 {
					current = string.characters.index(current, offsetBy: 1)
					
					for _ in 0 ..< sp.extraBytes {
						
						var byte = ""
						char = string.substring(with: (current ..< string.characters.index(current, offsetBy: 1)))
						current = string.characters.index(current, offsetBy: 1)
						byte = byte + char
						
						char = string.substring(with: (current ..< string.characters.index(current, offsetBy: 1)))
						current = string.characters.index(current, offsetBy: 1)
						byte = byte + char
						
						extraBytes.append(XGUnicodeCharacters.hexStringToInt(byte))
						
					}
					current = string.characters.index(current, offsetBy: 1)
				}
				
				let ch = XGUnicodeCharacters.special(sp, extraBytes)
				chars.append(ch)
				
			} else {
				
				let charScalar = String(char).unicodeScalars
				let charValue  = Int(charScalar[charScalar.startIndex].value)
				
				let ch = XGUnicodeCharacters.unicode(charValue)
				chars.append(ch)
				
			}
			
		}
		
		self.chars = chars
	}
	
	func replace() -> Bool {
		if self.id == 0 {
			return false
		}
		return self.table.stringTable.replaceString(self, alert: false)
	}
	
	func containsSubstring(_ sub: String) -> Bool {
		return self.string.range(of: sub, options: .caseInsensitive, range: nil, locale: nil) != nil
	}
	
	func replaceSubstring(_ sub: String, withString new: String, verbose: Bool) {
		let str = self.string.replacingOccurrences(of: sub, with: new, options: [], range: nil)
		self.duplicateWithString(str).replace()
	}
	
	func duplicateWithString(_ str: String) -> XGString {
		return XGString(string: str, file: self.table, sid: self.id)
	}
	
   
}

















