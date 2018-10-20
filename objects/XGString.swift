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
	@objc var id	  = 0
	
	@objc var dataLength : Int {
		get {
			var count = 0
			for char in chars {
				count += char.length
			}
			return count
		}
	}
	
	@objc var stringLength : Int {
		return chars.count
	}
	
	override var description : String {
		return self.string
	}
	
	@objc var string : String {
		get {
			var str = ""
			for char in chars {
				str = str + char.string
			}
			return str
		}
	}
	
	@objc var stringPlusIDAndFile : String {
		get {
			return "ID : 0x" + String(format: "%x", id) + " " + "\(id)" + " \nFile: \(table.fileName)\n\(string)\n"
		}
	}
	
	@objc var byteStream : [UInt8] {
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
	
	@objc func copyString() {
//		let pb = UIPasteboard.generalPasteboard()
//		pb.string = self.string
	}
	
	func append(_ char: XGUnicodeCharacters) {
		self.chars.append(char)
	}
	
	init(string: String, file: XGFiles?, sid: Int?) {
		// Forgive me! I wrote this years ago when I was still learning swift and the default
		// swift library has some really bad string manipulation functions
		// The function works. It used to be a lot worse... trust me :-)
		super.init()
		
		self.table = file ?? XGFiles.nameAndFolder("", .Documents)
		self.id = sid ?? 0
		
		var chars = [XGUnicodeCharacters]()
		
		var current   = 0
		let end		  = string.length
		
		while current != end {
			
			var char = string.substring(from: current, to: current + 1)
			current += 1
			
			if char == "[" {
				var midString = ""
				
				char = string.substring(from: current, to: current + 1)
				current += 1
				
				while char != "]" {
					midString = midString + char
					
					char = string.substring(from: current, to: current + 1)
					current += 1
				}
				
				let sp = XGSpecialCharacters.fromString(midString)
				var extraBytes = [Int]()
				
				if sp.extraBytes > 0 {
					current += 1
					
					for _ in 0 ..< sp.extraBytes {
						
						var byte = ""
						char = string.substring(from: current, to: current + 1)
						current += 1
						byte = byte + char
						
						char = string.substring(from: current, to: current + 1)
						current += 1
						byte = byte + char
						
						extraBytes.append(XGUnicodeCharacters.hexStringToInt(byte))
						
					}
					current += 1
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
	
	@objc func replace() -> Bool {
		return replace(increaseSize: false)
	}
	
	@objc func replace(increaseSize: Bool) -> Bool {
		if self.id == 0 {
			return false
		}
		
		loadAllStrings()
		var success = true
		for table in allStringTables {
			if table.containsStringWithId(self.id) {
				success = success && table.replaceString(self, alert: false, save: true, increaseLength: increaseSize)
			}
		}
		return success
	}
	
	func replaceDirectly() -> Bool {
		stringsLoaded = false
		return self.table.stringTable.replaceString(self, alert: false, save: true)
	}
	
	@objc func containsSubstring(_ sub: String) -> Bool {
		return self.string.contains(sub)
	}
	
	@objc func replaceSubstring(_ sub: String, withString new: String, verbose: Bool) {
		let str = self.string.replacingOccurrences(of: sub, with: new, options: [], range: nil)
		self.duplicateWithString(str).replace()
	}
	
	@objc func duplicateWithString(_ str: String) -> XGString {
		return XGString(string: str, file: self.table, sid: self.id)
	}
	
   
}

















