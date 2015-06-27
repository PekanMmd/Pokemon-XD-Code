//
//  XGString.swift
//  XG Tool
//
//  Created by The Steez on 25/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGString: NSObject{
	
	var chars = [XGUnicodeCharacters]()
	
	var table = XGFiles.NameAndFolder("", .Documents)
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
	
	var byteStream : [UInt8] {
		get {
			var stream = [UInt8]()
			for char in chars {
				stream = stream + char.byteStream
			}
			return stream
		}
	}
	
	override func isEqual(object: AnyObject?) -> Bool {
		
		if object == nil {
			return false
		}
		
		if !(object!.isKindOfClass(XGString)) {
			return false
		}
		
		let cmpstr = object! as! XGString
		
		return self.string == cmpstr.string
		
	}
	
	func copyString() {
		var pb = UIPasteboard.generalPasteboard()
		pb.string = self.string
	}
	
	func append(char: XGUnicodeCharacters) {
		self.chars.append(char)
	}
	
	init(string: String, file: XGFiles, sid: Int) {
		super.init()
		
		self.table = file
		self.id = sid
		
		var chars = [XGUnicodeCharacters]()
		
		var current   = string.startIndex
		var end		  = string.endIndex
		
		while current != end {
			
			var char = string.substringWithRange(Range<String.Index>(start: current,end: advance(current, 1)))
			current = advance(current, 1)
			
			if char == "[" {
				var midString = ""
				
				char = string.substringWithRange(Range<String.Index>(start: current,end: advance(current, 1)))
				current = advance(current, 1)
				
				while char != "]" {
					midString = midString + char
					
					char = string.substringWithRange(Range<String.Index>(start: current,end: advance(current, 1)))
					current = advance(current, 1)
				}
				
				var sp = XGSpecialCharacters.fromString(midString)
				var extraBytes = [Int]()
				
				if sp.extraBytes > 0 {
					current = advance(current, 1)
					
					for var i = 0; i < sp.extraBytes; i++ {
						
						var byte = ""
						char = string.substringWithRange(Range<String.Index>(start: current,end: advance(current, 1)))
						current = advance(current, 1)
						byte = byte + char
						
						char = string.substringWithRange(Range<String.Index>(start: current,end: advance(current, 1)))
						current = advance(current, 1)
						byte = byte + char
						
						extraBytes.append(XGUnicodeCharacters.hexStringToInt(byte))
						
					}
					current = advance(current, 1)
				}
				
				let ch = XGUnicodeCharacters.Special(sp, extraBytes)
				chars.append(ch)
				
			} else {
				
				let charScalar = String(char).unicodeScalars
				let charValue  = Int(charScalar[charScalar.startIndex].value)
				
				let ch = XGUnicodeCharacters.Unicode(charValue)
				chars.append(ch)
				
			}
			
		}
		
		self.chars = chars
	}
	
	func replace(alert: Bool) -> Bool {
		return self.table.stringTable.replaceString(self, alert: alert)
	}
   
}

















