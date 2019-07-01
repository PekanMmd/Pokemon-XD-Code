//
//  PBRStringTable.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 05/03/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfStringsOffset = 0x06
let kEndOfHeader		   = 0x10

// high order 12 bits are compared with the string table's first 2 bytes
// always seems to be 0 though
let kMaxStringID 		   = 0xFFFFF

enum XGLanguages : Int {
	
	case Japanese = 0
	case EnglishUS
	case EnglishUK
	case German
	case French
	case Italian
	case Spanish
	
	var name : String {
		switch self {
		case .Japanese: return "Japanese"
		case .EnglishUK: return "English (UK)"
		case .EnglishUS: return "English (US)"
		case .French: return "French"
		case .Spanish: return "Spanish"
		case .German: return "German"
		case .Italian: return "Italian"
		}
	}
}

class XGStringTable: NSObject {
	
	var file = XGFiles.nameAndFolder("", .Documents)
	@objc var startOffset = 0x0 // where in the file the string table is located. used for files like common.rel which have more than just the table
	@objc var stringTable = XGMutableData()
	@objc var stringOffsets = [Int : Int]()
	var stringIDs = [Int]()
	
	@objc var numberOfEntries : Int {
		get {
			return stringTable.get2BytesAtOffset(kNumberOfStringsOffset)
		}
	}
	
	@objc var fileSize : Int {
		get {
			return self.stringTable.length
		}
	}
	
	@objc var extraCharacters : Int {
		
		get {
			var currentChar = 0x00
			var currentOffset = fileSize - 3 // the file always ends in 0x0000 to end its last string so it isn't included
			
			var length = 0
			
			while currentChar == 0x00 {
				
				currentChar = stringTable.getByteAtOffset(currentOffset)
				
				if currentChar == 0x00 { length += 1 }
				
				currentOffset -= 1
				
			}
			
			return length
		}
		
	}
	
	init(file: XGFiles, startOffset: Int, fileSize: Int) {
		super.init()
		
		self.file = file
		self.startOffset = startOffset
		self.stringTable = XGMutableData(byteStream: file.data!.charStream, file: file)
		
		stringTable.deleteBytesInRange(NSMakeRange(0, startOffset))
		stringTable.deleteBytesInRange(NSMakeRange(fileSize, stringTable.length - fileSize))
		
		getOffsets()
	}
	
	@objc func save() {
		
		if self.startOffset == 0 {
			stringTable.save()
		} else {
			let data = file.data!
			data.replaceBytesFromOffset(self.startOffset, withByteStream: stringTable.byteStream)
			data.save()
		}
	}
	
	func replaceString(_ string: XGString, save: Bool) -> Bool {
		return self.replaceString(string, alert: false, save: save, increaseLength: false)
	}
	
	func addString(_ string: XGString, increaseSize: Bool, save: Bool) -> Bool {
		
		if self.numberOfEntries == 0xFFFF {
			printg("String table \(stringTable.file.fileName) has the maximum number of entries!")
			return false
		}
		
		if !self.containsStringWithId(string.id) {
			
			if string.id == 0 {
				printg("Cannot add string with id 0")
				return false
			}
			
			let bytesRequired = string.dataLength + 4
			if self.extraCharacters > bytesRequired {
				self.stringTable.deleteBytes(start: stringTable.length - bytesRequired, count: bytesRequired)
			} else {
				if self.startOffset != 0 || !increaseSize {
					printg("Couldn't add string to \(stringTable.file.fileName) because it doesn't have enough space.")
					return false
				}
			}
			
			self.stringTable.insertRepeatedByte(byte: 0, count: bytesRequired, atOffset: (numberOfEntries * 4) + kEndOfHeader)
			let bytes = string.byteStream.map { (i) -> Int in
				return Int(i)
			}
			self.stringTable.replaceBytesFromOffset( ((numberOfEntries + 1) * 4) + kEndOfHeader, withByteStream: bytes)
			
			self.increaseOffsetsAfter(0, byCharacters: bytesRequired)
			self.stringOffsets[string.id] = ((numberOfEntries + 1) * 4) + kEndOfHeader
			self.stringIDs.append(string.id)
			
			self.stringTable.replace2BytesAtOffset(kNumberOfStringsOffset, withBytes: numberOfEntries + 1)
			self.updateOffsets()
			
			if save {
				self.save()
			}
			return true
			
		} else {
			
			return self.replaceString(string, save: save)
		}
	}
	
	@objc func getOffsets() {
		
		var currentOffset = kEndOfHeader
		
		for id in 1 ... numberOfEntries {
			
			let offset = stringTable.getWordAtOffset(currentOffset).int
			self.stringOffsets[id] = offset
			self.stringIDs.append(id)
			currentOffset += 4
			
		}
		
	}
	
	@objc func updateOffsets() {
		
		var currentOffset = kEndOfHeader
		
		var sids = self.stringIDs
		sids.sort{$0 < $1}
		
		for sid in sids {
			
			stringTable.replaceWordAtOffset(currentOffset, withBytes: UInt32(stringOffsets[sid]!))
			currentOffset += 4
			
		}
		
	}
	
	@objc func decreaseOffsetsAfter(_ offset: Int, byCharacters characters: Int) {
		
		for sid in self.stringIDs {
			
			if let off = stringOffsets[sid] {
				if off > offset {
					stringOffsets[sid] = off - characters
				}
			}
		}
		
	}
	
	@objc func increaseOffsetsAfter(_ offset: Int, byCharacters characters: Int) {
		
		for sid in self.stringIDs {
			
			if let off = stringOffsets[sid] {
				if off > offset {
					stringOffsets[sid] = off + characters
				}
			}
		}
		
	}
	
	func offsetForStringID(_ stringID : Int) -> Int? {
		return self.stringOffsets[stringID]
	}
	
	@objc func endOffsetForStringId(_ stringID : Int) -> Int {
		
		let startOff = offsetForStringID(stringID)!
		let text = stringWithID(stringID)!
		
		return startOff + text.dataLength
		
	}
	
	@objc func getStringAtOffset(_ offset: Int) -> XGString {
		
		var currentOffset = offset
		
		var currChar = 0x0
		
		let string = XGString(string: "", file: self.file, sid: 0)
		var complete = false
		
		while (currentOffset < self.stringTable.length - 1 && !complete) {
			
			currChar = stringTable.get2BytesAtOffset(currentOffset)
			currentOffset += 2
			
			
			// These are special characters used by the game. Similar to escape sequences like \n or \t for newlines and tabs.
			// It is to be hoped that we'll be able to figure out what they all mean eventually.
			if currChar == 0xFFFF {
				
				let sp = XGSpecialCharacters.id(stringTable.get2BytesAtOffset(currentOffset))
				currentOffset += 2
				
				if sp.id == 0xFFFF {
					complete = true
				} else {
					string.append(.special(sp, []))
				}
				
			} else {
				// This is a regular character so read normally.
				string.append(.unicode(currChar))
			}
			
		}
		
		return string
		
	}
	
	@objc func stringWithID(_ stringID: Int) -> XGString? {
		
		let offset = offsetForStringID(stringID)
		
		if offset != nil  {
			
			if offset! + 2 >= self.stringTable.length {
				return nil
			}
			
			let string = getStringAtOffset(offset!)
			string.id = stringID
			return string
			
		}
		
		return nil
	}
	
	@objc func stringSafelyWithID(_ stringID: Int) -> XGString {
		
		let string = stringWithID(stringID)
		
		return string ?? XGString(string: "-", file: nil, sid: 0)
	}
	
	@objc func containsStringWithId(_ stringID: Int) -> Bool {
		return stringIDs.contains(stringID)
	}
	
	@objc func allStrings() -> [XGString] {
		
		var strings = [XGString]()
		
		for sid in self.stringIDs {
			
			let string = self.stringSafelyWithID(sid)
			strings.append(string)
			
		}
		return strings
	}
	
	@objc func purge() {
		
		let strings = self.allStrings()
		for str in strings {
			
			let string = XGString(string: "-", file: self.file, sid: str.id)
			
			let copyStream = self.stringTable.getCharStreamFromOffset(0, length: self.stringOffsets[str.id]!)
			
			let dataCopy = XGMutableData(byteStream: copyStream, file: self.file)
			
			let oldText = self.stringWithID(str.id)!
			let difference = string.dataLength - oldText.dataLength
			
			if difference <= self.extraCharacters {
				
				let stream = string.byteStream
				
				dataCopy.appendBytes(stream)
				
				
				let oldEnd = self.endOffsetForStringId(string.id)
				
				let newEnd = stringTable.getCharStreamFromOffset(oldEnd, length: fileSize - oldEnd)
				
				let endData = XGMutableData(byteStream: newEnd, file: self.file)
				
				dataCopy.appendBytes(endData.charStream)
				
				if string.dataLength > oldText.dataLength {
					
					for _ in 0 ..< difference {
						
						let currentOff = dataCopy.length - 1
						let range = NSMakeRange(currentOff, 1)
						
						dataCopy.deleteBytesInRange(range)
						
					}
					
					self.increaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
				}
				
				if string.dataLength < oldText.dataLength {
					
					let difference = oldText.dataLength - string.dataLength
					var emptyByte : UInt8 = 0x0
					
					for _ in 0 ..< difference {
						
						dataCopy.data.append(&emptyByte, length: 1)
						
					}
					
					self.decreaseOffsetsAfter(stringOffsets[string.id]!, byCharacters: difference)
				}
				
			}
			
			self.stringTable = dataCopy
			self.updateOffsets()
			
		}
		
		self.save()
		printg("Purged String Table:",self.file.fileName)
		
		
	}
	
	@objc func printAllStrings() {
		for string in self.allStrings() {
			print(string.string,"\n")
		}
	}
	
}
