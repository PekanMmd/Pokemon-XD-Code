//
//  XGStringTableReference.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation


let kNumberOfStringsOffset = 0x04
let kEndOfHeader		   = 0x10

// high order 12 bits are compared with the string table's first 2 bytes
// always seems to be 0 though
let kMaxStringID 		   = 0xFFFFF

enum XGLanguages : Int, Codable {
	
	case Japanese = 0
	case EnglishUK
	case EnglishUS
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
	var startOffset = 0x0 // where in the file the string table is located. used for files like common.rel which have more than just the table
	var stringTable = XGMutableData()
	var stringOffsets = [Int : Int]()
	var stringIDs = [Int]()
	
	var numberOfEntries: Int {
		return stringTable.get2BytesAtOffset(kNumberOfStringsOffset)
	}
	
	var fileSize : Int {
		return self.stringTable.length
	}
	
	var extraCharacters: Int {
		
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

	subscript(id: Int) -> XGString {
		return getStringSafelyWithID(id: id)
	}
	
	class func common_rel() -> XGStringTable {
		if game == .XD {
			let start: Int
			let size: Int
			switch region {
			case .US: start = 0x4E274; size = 0xDC70
			case .EU: start = 0x50234; size = 0xDC70
			case .JP: start = 0x4D028; size = 0xAC8C
			case .OtherGame: start = 0; size = 0
			}
			return XGStringTable(file: .common_rel, startOffset: start, fileSize: size)
		} else {
			if region == .JP {
				return XGStringTable(file: .common_rel, startOffset: 0x4580, fileSize: 0x9cf8)
			} else if region == .US {
				return XGStringTable(file: .common_rel, startOffset: 0x59890, fileSize: 0xC770)
			} else {
				return XGStringTable(file: .common_rel, startOffset: 0x5A448, fileSize: 0xC544)
			}
		}
		
	}

	class func common_rel2() -> XGStringTable { // second string table in common_rel in colosseum
		if game == .XD {
			// same as common_rel1
			return common_rel()
		} else {
			if region == .JP {
				// same as common_rel1. couldn't find it in JP version
				return XGStringTable(file: .common_rel, startOffset: 0x4580, fileSize: 0x9cf8)
			} else if region == .US {
				return XGStringTable(file: .common_rel, startOffset: 0x66000, fileSize: 0x124E0)
			} else {
				return XGStringTable(file: .common_rel, startOffset: 0x995EC, fileSize: 0x12480)
			}
		}

	}
	
	class func common_rel3() -> XGStringTable { // third string table in common_rel in colosseum
		if game == .XD {
			// same as common_rel1
			return common_rel()
		} else {
			if region == .JP {
				// same as common_rel1. couldn't find it in JP version
				return XGStringTable(file: .common_rel, startOffset: 0x4580, fileSize: 0x9cf8)
			} else if region == .US {
				return XGStringTable(file: .common_rel, startOffset: 0x784e0, fileSize: 0x13068)
			} else {
				return XGStringTable(file: .common_rel, startOffset: 0xF7FD4, fileSize: 0x13110)
			}
		}
		
	}
	
	class func tableres2() -> XGStringTable? {
		
		if game == .XD && !isDemo && region != .JP {
			return XGStringTable(file: .tableres2, startOffset: 0x048F88, fileSize: 0x16E84)
		} else {
			return nil
		}
		
	}
	
	class func dol() -> XGStringTable {
		
		if game == .XD {
			let start: Int
			let size: Int
			switch region {
			case .US:
				start = 0x374FC0
				size = 0x178BC
			case .JP:
				start = 0x38B0B0
				size = 0x11D10
			case .EU:
				start = 0x372AD8
				size = 0x17938
			case .OtherGame:
				start = 0
				size = 0
			}
			return  XGStringTable(file: .dol, startOffset: start, fileSize: size)
		} else {
			if region == .JP {
				return XGStringTable(file: .dol, startOffset: 0x2bece0, fileSize: 0xd850)
			} else if region == .US {
				return XGStringTable(file: .dol, startOffset: 0x2cc810, fileSize: 0x124e0)
			} else {
				return XGStringTable(file: .dol, startOffset: 0x2c1b20, fileSize: 0x124e0)
				
			}
		}
		
	}
	
	class func dol2() -> XGStringTable {
		guard game == .XD else { return dol() }

		let start: Int
		let size: Int
		switch region {
		case .US:
			start = 0x38c87c
			size = 0x364
		case .JP:
			start = 0x39CDC0
			size = 0x2A0
		case .EU:
			start = 0x3EA5A4
			size = 0x364
		case .OtherGame:
			start = 0
			size = 0
		}
		return  XGStringTable(file: .dol, startOffset: start, fileSize: size)
	}
	
	
	init(file: XGFiles, startOffset: Int, fileSize: Int) {
		super.init()
		
		self.file = file
		self.startOffset = startOffset
		self.stringTable = XGMutableData(byteStream: file.data!.charStream, file: file)
		
		stringTable.deleteBytes(start: 0, count: startOffset)
		stringTable.deleteBytes(start: fileSize, count: stringTable.length - fileSize)
		
		getOffsets()
	}
	
	func save() {
		
		if self.startOffset == 0 {
			stringTable.save()
		} else {
			if let data = file.data {
				data.replaceBytesFromOffset(self.startOffset, withByteStream: stringTable.byteStream)
				if data.save() {
					let msgFile = XGFiles.nameAndFolder(stringTable.file.fileName + XGFileTypes.json.fileExtension, stringTable.file.folder)
					if msgFile.exists {
						writeJSON(to: msgFile)
					}
				}
			}
		}
	}
	
	@discardableResult func addString(_ string: XGString, increaseSize: Bool, save: Bool) -> Bool {
		
		if numberOfEntries == 0xFFFF {
			printg("String table \(stringTable.file.fileName) has the maximum number of entries!")
			return false
		}
		
		if !containsStringWithId(string.id) {
			
			if string.id == 0 {
				printg("Cannot add string with id 0")
				return false
			}
			
			let bytesRequired = string.dataLength + 8
			if extraCharacters > bytesRequired {
				stringTable.deleteBytes(start: stringTable.length - bytesRequired, count: bytesRequired)
			} else {
				if startOffset != 0 || !increaseSize {
					printg("Couldn't add string \(string.string) to \(stringTable.file.fileName) because it doesn't have enough space.")
					printg("Requires: \(bytesRequired) bytes but only has \(self.extraCharacters) bytes available.")
					printg("Try shortening some other strings.")
					if startOffset == 0 {
						printg("You can also enable file size increases in the settings to allow larger text. This shouldn't cause any issues.")
					}
					return false
				}
			}
			
			stringTable.insertRepeatedByte(byte: 0, count: bytesRequired, atOffset: (numberOfEntries * 8) + kEndOfHeader)
			let bytes = string.byteStream.map { (i) -> Int in
				return Int(i)
			}
			stringTable.replaceBytesFromOffset( ((numberOfEntries + 1) * 8) + kEndOfHeader, withByteStream: bytes)
			
			increaseOffsetsAfter(0, by: bytesRequired)
			stringOffsets[string.id] = ((numberOfEntries + 1) * 8) + kEndOfHeader
			stringIDs.append(string.id)
			
			stringTable.replace2BytesAtOffset(kNumberOfStringsOffset, withBytes: numberOfEntries + 1)
			updateOffsets()
			
			if save {
				self.save()
			}
			return true
			
		} else {
			
			return replaceString(string, save: save)
		}
	}
	
	func getOffsets() {
		
		var currentOffset = kEndOfHeader
		
		for _ in 0 ..< numberOfEntries {
			
			let id = (stringTable.getWordAtOffset(currentOffset) & 0xFFFFF).int
			let offset = stringTable.getWordAtOffset(currentOffset + 4).int
			self.stringOffsets[id] = offset
			self.stringIDs.append(id)
			currentOffset += 8
			
		}
		
	}
	
	func updateOffsets() {
		
		var currentOffset = kEndOfHeader
		
		var sids = self.stringIDs
		sids.sort{$0 < $1}
		
		for sid in sids {
			
			let id : UInt32 = sid < 0 ? 0xFFFFFFFF : UInt32(sid)
			stringTable.replaceWordAtOffset(currentOffset, withBytes: id)
			stringTable.replaceWordAtOffset(currentOffset + 4, withBytes: UInt32(stringOffsets[sid]!))
			currentOffset += 8
			
		}
		
	}
	
	
	
	func decreaseOffsetsAfter(_ offset: Int, by bytes: Int) {

		for sid in self.stringIDs {
			if let off = stringOffsets[sid] {
				if off > offset {
					stringOffsets[sid] = off - bytes
				}
			}
		}

	}

	func increaseOffsetsAfter(_ offset: Int, by bytes: Int) {

		for sid in self.stringIDs {
			if let off = stringOffsets[sid] {
				if off > offset {
					stringOffsets[sid] = off + bytes
				}
			}
		}

	}
	
	func offsetForStringID(_ stringID : Int) -> Int? {
		return self.stringOffsets[stringID]
	}
	
	func endOffsetForStringId(_ stringID : Int) -> Int {
		
		let startOff = offsetForStringID(stringID)!
		let text = stringWithID(stringID)!
		
		return startOff + text.dataLength
		
	}
	
	func getStringAtOffset(_ offset: Int) -> XGString {
		
		var currentOffset = offset
		
		var currChar = 0x0
		var nextChar = 0x1
		
		let string = XGString(string: "", file: self.file, sid: 0)
		
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
				
				let sp = XGSpecialCharacters(rawValue: stringTable.getByteAtOffset(currentOffset))!
				currentOffset += 1
				
				let extra = sp.extraBytes
				
				let stream = stringTable.getByteStreamFromOffset(currentOffset, length: extra)
				currentOffset += extra
				
				string.append(.special(sp, stream))
				
			} else {
			// This is a regular character so read normally.
				
				string.append(.unicode(currChar))
			}
			
			nextChar = stringTable.get2BytesAtOffset(currentOffset)
			
		}
		
		return string
		
	}
	
	func stringWithID(_ stringID: Int) -> XGString? {
		
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
	
	func stringSafelyWithID(_ stringID: Int) -> XGString {
		
		let string = stringWithID(stringID)
		
		return string ?? XGString(string: "-", file: nil, sid: 0)
	}
	
	func containsStringWithId(_ stringID: Int) -> Bool {
			return stringIDs.contains(stringID)
	}
	
	func numberOfFreeMSGIDsFrom(_ stringID: Int) -> Int {
		var free = 0
		for i in 0 ..< 10 { // just 10 to make it quick
			if self.containsStringWithId(stringID + i) {
				return free
			}
			free += 1
		}
		return free
	}
	
	func allStrings() -> [XGString] {
		
		var strings = [XGString]()
		
		for sid in self.stringIDs {
			
			let string = self.stringSafelyWithID(sid)
			strings.append(string)
			
		}
		return strings
	}
	
	func purge() {
		
		let strings = self.allStrings()
		for str in strings {
			let string = XGString(string: "-", file: file, sid: str.id)
			replaceString(string, save: false)
		}
		
		self.save()
		printg("Purged String Table:",self.file.fileName)
		
		
	}
	
	func printAllStrings() {
		for string in self.allStrings() {
			printg(string.string,"\n")
		}
	}
	
}

struct XGStringTableMetaData: Codable {
	let file: XGFiles
	let startOffset: Int
	let fixedFileSize: Int
	let strings: [XGString]
}

extension XGStringTable: Encodable {
	enum XGStringTableDecodingError: Error {
		case invalidFile(file: XGFiles)
	}
	
	enum CodingKeys: String, CodingKey {
		case file, startOffset, fixedFileSize, strings
	}
	
	static func fromJSON(data: Data, save: Bool = false) throws -> XGStringTable {
		let metaData = try JSONDecoder().decode(XGStringTableMetaData.self, from: data)
		let file = metaData.file
		guard file.exists else {
			throw XGStringTableDecodingError.invalidFile(file: file)
		}
		let startOffset = metaData.startOffset
		let fixedFileSize = metaData.fixedFileSize
		
		let table = XGStringTable(file: file, startOffset: startOffset, fileSize: startOffset == 0 ? file.fileSize : fixedFileSize)
		
		let strings = metaData.strings
		for string in strings {
			table.addString(string, increaseSize: startOffset == 0, save: save)
		}
		return table
	}
	
	static func fromJSONFile(file: XGFiles, save: Bool = false) throws -> XGStringTable {
		let url = URL(fileURLWithPath: file.path)
		let data = try Data(contentsOf: url)
		return try fromJSON(data: data, save: save)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.file, forKey: .file)
		try container.encode(self.startOffset, forKey: .startOffset)
		try container.encode(self.startOffset == 0 ? 0 : self.fileSize, forKey: .fixedFileSize)
		try container.encode(self.allStrings(), forKey: .strings)
	}
}









