//
//  PBRStringTable.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 05/03/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfStringsOffset		 = 0x06
let kStringTableIDOffset   		 = 0x08
let kStringTableLanguageOffset   = 0x0C
let kEndOfHeader		  		 = 0x10

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

	static var mes_common = XGFiles.typeAndFsysName(.msg, region == .JP ? "common" : "mes_common")
	
	var file = XGFiles.nameAndFolder("", .Documents) {
		didSet {
			stringTable.file = file
		}
	}
	var startOffset = 0x0 // where in the file the string table is located. used for files like common.rel which have more than just the table
	var stringTable = XGMutableData()
	var stringOffsets = [Int : Int]()
	var stringIDs = [Int]()

	var tableID = 0
	var language = XGStringTableLanguages.english
	
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
		self.stringTable = file.data!
		
		stringTable.deleteBytes(start: 0, count: startOffset)
		stringTable.deleteBytes(start: fileSize, count: stringTable.length - fileSize)

		setup()
	}

	init(data: XGMutableData) {
		super.init()

		self.file = data.file
		self.startOffset = 0
		self.stringTable = data

		setup()
	}

	private func setup() {
		tableID = stringTable.get4BytesAtOffset(kStringTableIDOffset)
		let languageBinary = stringTable.getWordAtOffset(kStringTableLanguageOffset)
		language = XGStringTableLanguages.fromBinary(languageBinary)

		getOffsets()
	}
	
	func save() {
		
		if self.startOffset == 0 {
			stringTable.save()
		} else {
			let data = file.data!
			data.replaceBytesFromOffset(self.startOffset, withByteStream: stringTable.byteStream)
			data.save()
		}
	}

	@discardableResult
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

			if string.id > numberOfEntries + 1 {
				printg("Cannot add string with id \(string.id). Must add string ids in order.")
				printg("Next available id is \(numberOfEntries + 1)")
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

			self.stringTable.replaceBytesFromOffset( ((numberOfEntries + 1) * 4) + kEndOfHeader, withByteStream: string.byteStream)
			
			self.increaseOffsetsAfter(0, by: bytesRequired)
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
	
	func getOffsets() {
		
		var currentOffset = kEndOfHeader
		
		for id in 1 ... numberOfEntries {
			
			let offset = stringTable.getWordAtOffset(currentOffset).int
			self.stringOffsets[id] = offset
			self.stringIDs.append(id)
			currentOffset += 4
			
		}
		
	}
	
	func updateOffsets() {
		
		var currentOffset = kEndOfHeader
		
		var sids = self.stringIDs
		sids.sort{$0 < $1}
		
		for sid in sids {
			
			stringTable.replaceWordAtOffset(currentOffset, withBytes: UInt32(stringOffsets[sid]!))
			currentOffset += 4
			
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
		
		let string = XGString(string: "", file: self.file, sid: 0)
		var complete = false
		
		while (currentOffset < self.stringTable.length - 1 && !complete) {
			
			currChar = stringTable.get2BytesAtOffset(currentOffset)
			currentOffset += 2

			// These are special characters used by the game. Similar to escape sequences like \n or \t for newlines and tabs.
			if currChar == 0xFFFF {
				
				let sp = XGSpecialCharacters.id(stringTable.get2BytesAtOffset(currentOffset))
				currentOffset += 2
				
				if sp.id == 0xFFFF {
					complete = true
				} else {
					let extra = sp.extraBytes

					let stream = stringTable.getByteStreamFromOffset(currentOffset, length: extra)
					currentOffset += extra

					string.append(.special(sp, stream))
				}
				
			} else {
				// This is a regular character so read normally.
				string.append(.unicode(currChar))
			}
			
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
			let empty = str.duplicateWithString("-")
			replaceString(empty)
		}
		
		self.save()
		printg("Purged String Table:",self.file.fileName)
		
		
	}
	
	func printAllStrings() {
		for string in self.allStrings() {
			printg(string.string,"\n")
		}
	}
	
	func writeJSON(to file: XGFiles) {
		guard let data = try? JSONRepresentation(), data.write(to: file) else {
			printg("Failed to write JSON to:", file.path)
			return
		}
		if settings.verbose {
			printg("Successfully wrote JSON to:", file.path)
		}
	}

	func removeKanji() {
		for string in self.allStrings() where string.hasFurigana {
			string.removeKanji()
			replaceString(string, save: false)
		}
	}
	
}

enum XGStringTableLanguages: String, CaseIterable, Codable {
	case japanese
	case english
	case french
	case german
	case italian
	case spanish

	var binary: UInt32 {
		switch self {
		case .japanese:
			return 0x4A504A50
		case .english:
			return 0x5553554B
		case .french:
			return 0x46524652
		case .german:
			return 0x53505350
		case .italian:
			return 0x49544954
		case .spanish:
			return 0x47524752
		}
	}

	static func fromBinary(_ binary: UInt32) -> XGStringTableLanguages {
		for language in allCases {
			if language.binary == binary {
				return language
			}
		}
		return .english
	}
}

struct XGStringTableMetaData: Codable {
	let file: XGFiles
	let tableID: Int
	let language: XGStringTableLanguages
	let strings: [String]
}

extension XGStringTable: Encodable {
	enum XGStringTableDecodingError: Error {
		case invalidData
	}
	
	enum CodingKeys: String, CodingKey {
		case file, tableID, language, strings
	}

	static func fromJSON(data: Data, removeKanji: Bool = false) throws -> XGStringTable {
		let decodedMetaData = try? JSONDecoder().decode(XGStringTableMetaData.self, from: data)
		guard let metaData = decodedMetaData else {
			throw XGStringTableDecodingError.invalidData
		}

		let numberOfStrings = metaData.strings.count

		let data = XGMutableData()
		data.file = metaData.file

		// Header
		data.appendBytes([0x4D, 0x45, 0x53, 0x47]) // MESG magic bytes
		data.appendBytes(numberOfStrings.charArray)
		data.appendBytes(metaData.tableID.charArray)
		data.appendBytes(metaData.language.binary.charArray)

		// Pointers
		let headerSize = 16
		let pointerSize = 4 * numberOfStrings
		let endOfPointers = headerSize + pointerSize

		let pointerInitData = [UInt8](repeating: 0, count: pointerSize)
		data.appendBytes(pointerInitData)

		var currentStringOffset = endOfPointers
		var currentPointerOffset = headerSize

		for str in metaData.strings {
			data.replace4BytesAtOffset(currentPointerOffset, withBytes: currentStringOffset)
			let string = XGString(string: str, file: nil, sid: nil)
			if removeKanji {
				string.removeKanji()
			}
			let stringData = string.byteStream
			data.appendBytes(stringData)
			currentStringOffset += stringData.count
			currentPointerOffset += 4
		}

		return XGStringTable(data: data)
	}

	static func fromJSONFile(file: XGFiles) throws -> XGStringTable {
		let url = URL(fileURLWithPath: file.path)
		let data = try Data(contentsOf: url)
		return try fromJSON(data: data)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(file, forKey: .file)
		try container.encode(tableID, forKey: .tableID)
		try container.encode(language, forKey: .language)
		try container.encode(allStrings().map { $0.string }, forKey: .strings)
	}
}
