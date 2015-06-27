//
//  XGStringTableReference.swift
//  XG Tool
//
//  Created by The Steez on 19/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

let kNumberOfStringsOffset = 0x04
let kEndOfHeader		   = 0x10

class XGStringTable: NSObject {
	
	var file = XGFiles.NameAndFolder("", .Documents)
	var startOffset = 0x0
	var stringTable = XGMutableData()
	var stringOffsets = [Int : Int]()
	
	var numberOfEntries : Int {
		get {
			return stringTable.get2BytesAtOffset(kNumberOfStringsOffset)
		}
	}
	
	var fileSize : Int {
		get {
			return self.stringTable.length
		}
	}
	
	var extraCharacters : Int {
		
		get {
			var currentChar = 0x00
			var currentOffset = fileSize - 3 // the file always ends in 0x0000 to end its last string so it isn't included
			
			var length = 0
			
			while currentChar == 0x00 {
				
				currentChar = stringTable.getByteAtOffset(currentOffset)
				
				if currentChar == 0x00 { length++ }
				
				currentOffset--
				
			}
			
			return length
		}
		
	}
	
	class func common_rel() -> XGStringTable {
		
		return XGStringTable(file: .Common_rel, startOffset: 0x04E274, fileSize: 0x0DC70)
		
	}
	
	class func tableres2() -> XGStringTable {
		
		return XGStringTable(file: .Tableres2, startOffset: 0x048F88, fileSize: 0x16E83)
		
	}
	
	class func dol() -> XGStringTable {
		
		return  XGStringTable(file: .Dol, startOffset: 0x374FC0, fileSize: 0x17C20)
		
	}
	
	class func common_relOriginal() -> XGStringTable {
		
		return XGStringTable(file: .Resources(.FDAT("common_rel")), startOffset: 0x04E274, fileSize: 0x0DC70)
		
	}
	
	class func tableres2Original() -> XGStringTable {
		
		return XGStringTable(file: .Resources(.FDAT("tableres2")), startOffset: 0x048F88, fileSize: 0x16E83)
		
	}
	
	class func dolOriginal() -> XGStringTable {
		
		return  XGStringTable(file: .Resources(.DOL), startOffset: 0x374FC0, fileSize: 0x17C20)
		
	}
	
	init(file: XGFiles, startOffset: Int, fileSize: Int) {
		super.init()
		
		self.file = file
		self.startOffset = startOffset
		self.stringTable = file.data
		
		stringTable.deleteBytesInRange(NSMakeRange(0, startOffset))
		stringTable.deleteBytesInRange(NSMakeRange(fileSize, stringTable.length - fileSize))
		
		getOffsets()
	}
	
	func save() {
		
		var data = file.data
		
		data.replaceBytesFromOffset(self.startOffset, withByteStream: stringTable.byteStream)
		
		data.save()
		
	}
	
	func getOffsets() {
		
		var currentOffset = kEndOfHeader
		
		for var i = 0; i < numberOfEntries; i++ {
			
			var id = stringTable.get4BytesAtOffset(currentOffset)
			
			currentOffset += 4
			
			var offset = stringTable.get4BytesAtOffset(currentOffset)
			
			self.stringOffsets[Int(id)] = Int(offset)
			
			currentOffset += 4
			
		}
		
	}
	
	func updateOffsets() {
		
		var currentOffset = kEndOfHeader
		
		var sids = [Int]()
		
		for (sid, off) in self.stringOffsets {
			sids.append(sid)
		}
		
		sids.sort{$0 < $1}
		
		for sid in sids {
			
			stringTable.replace4BytesAtOffset(currentOffset, withBytes: UInt32(sid))
			
			currentOffset += 4
			
			stringTable.replace4BytesAtOffset(currentOffset, withBytes: UInt32(stringOffsets[sid]!))
			
			currentOffset += 4
			
		}
		
	}
	
	func replaceString(string: XGString, alert: Bool) -> Bool {
		
		var copyStream = self.stringTable.getCharStreamFromOffset(0, length: self.stringOffsets[string.id]!)
		
		var dataCopy = XGMutableData(byteStream: copyStream, file: self.file)
		
		let oldText = self.stringWithID(string.id)!
		let difference = string.length - oldText.length
		
		if difference <= self.extraCharacters {
			
			var stream = string.byteStream
			
			dataCopy.appendBytes(stream)
			
			
			let oldEnd = self.endOffsetForStringId(string.id)
			
			var newEnd = stringTable.getCharStreamFromOffset(oldEnd, length: fileSize - oldEnd)
			
			var endData = XGMutableData(byteStream: newEnd, file: self.file)
			
			dataCopy.appendBytes(endData.charStream)
			
			if string.length > oldText.length {
				
				for var i = 0; i < difference; i++ {
					
					var currentOff = dataCopy.length - 1
					let range = NSMakeRange(currentOff, 1)
					
					dataCopy.deleteBytesInRange(range)
					
				}
				
				self.increaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
			}
	
			if string.length < oldText.length {
				
				let difference = oldText.length - string.length
				var emptyByte : UInt8 = 0x0
				
				for var i = 0; i < difference; i++ {
					
					dataCopy.data.appendBytes(&emptyByte, length: 1)
					
				}
				
				self.decreaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
			}
			
			self.stringTable = dataCopy
			
			self.updateOffsets()
			self.save()
			
			if alert {
				XGAlertView(title: "String Replacement", message: "The string replacement was successful.", doneButtonTitle: "Sweet", otherButtonTitles: nil, buttonAction: nil)
			}
			
			return true
			
		} else {
			if alert {
				XGAlertView(title: "String Replacement", message: "The new string was too long. String replacement was aborted.", doneButtonTitle: "Cool", otherButtonTitles: nil, buttonAction: nil)
			}
		}
		
		return false
	}
	
	
	func decreaseOffsetsAfter(offset: Int, byCharacters characters: Int) {
		
		for (sid, off) in self.stringOffsets {
			
			if off > offset {
				stringOffsets[sid] = off - characters
			}
		}
		
	}
	
	func increaseOffsetsAfter(offset: Int, byCharacters characters: Int) {
		
		for (sid, off) in self.stringOffsets {
			
			if off > offset {
				stringOffsets[sid] = off + characters
			}
		}
		
	}
	
	func offsetForStringID(stringID : Int) -> Int? {
		
		return self.stringOffsets[stringID]
	}
	
	func endOffsetForStringId(stringID : Int) -> Int {
		
		let startOff = offsetForStringID(stringID)!
		
		let text = stringWithID(stringID)!
		
		return startOff + text.length
		
	}
	
	func getStringAtOffset(offset: Int) -> XGString {
		
		var currentOffset = offset
		
		var currChar = 0x0
		var nextChar = 0x1
		
		var string = XGString(string: "", file: self.file, sid: 0)
		
		while (nextChar != 0x00) {
			
			if currentOffset + 2 > fileSize {
				nextChar = 0x0
				break
			}
			
			currChar = stringTable.get2BytesAtOffset(currentOffset)
			currentOffset += 2
			
			
			// These are special characters used by the game. Similar to escape sequences like \n or \t for newlines and tabs.
			// It is to be hoped that we'll be able to figure out what they all mean eventually.
			if currChar == 0xFFFF {
				
				var sp = XGSpecialCharacters(rawValue: stringTable.getByteAtOffset(currentOffset))!
				currentOffset++
				
				var extra = sp.extraBytes
				
				var stream = stringTable.getByteStreamFromOffset(currentOffset, length: extra)
				currentOffset += extra
				
				string.append(.Special(sp, stream))
				
			} else {
			// This is a regular character so read normally.
				
				string.append(.Unicode(currChar))
			}
			
			nextChar = stringTable.get2BytesAtOffset(currentOffset)
			
		}
		
		return string
		
	}
	
	func stringWithID(stringID: Int) -> XGString? {
		
		let offset = offsetForStringID(stringID)
		
		if offset != nil {
			
			var string = getStringAtOffset(offset!)
			string.id = stringID
			return string
			
		}
		
		return nil
	}
	
	func stringSafelyWithID(stringID: Int) -> XGString {
		
		let string = stringWithID(stringID)
		
		return string ?? XGString(string: "-", file: .NameAndFolder("",.Documents), sid: 0)
	}
	
	func containsStringWithId(stringID: Int) -> Bool {
		
			return stringOffsets.indexForKey(stringID) != nil
		
	}
	
	func allStrings() -> [Int : XGString] {
		
		var strings = [Int : XGString]()
		
		for (sid, off) in self.stringOffsets {
			
			var string = self.stringWithID(sid)
			
			strings[sid] = string
			
		}
		return strings
	}

}






