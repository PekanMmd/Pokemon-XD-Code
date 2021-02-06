//
//  PBRDataTable.swift
//  Revolution Tool CL
//
//  Created by The Steez on 25/12/2018.
//

import Foundation

#if GAME_PBR
private var dataTablesByFile = [String: GoDDataTable]()
#else
private var dataTablesByIndex = [Int: GoDDataTable]()
#endif

class GoDDataTable: CustomStringConvertible {
	
	var description: String {
		#if GAME_PBR
		var text = self.file.fileName + "\nEntries: " + self.entries.count.string + "\n"
		#else
		var text = "Table \(file.path)\nEntries: " + self.entries.count.string + "\n"
		#endif
		
		for entry in self.entries {
			text += "\n" + entry.byteStream.hexStream
		}
		
		return text
	}
	
	var startOffset 	= 0

	#if GAME_PBR
	var file = XGFiles.common(0)
	var subStartOffset  = 0
	var unknown = 0
	var postCount = 0
	var predata  = [UInt8]()
	var postdata = [UInt8]()
	#else
	var file: XGFiles
	#endif
	
	var entries  = [XGMutableData]()
	
	var numberOfEntries : Int {
		return entries.count
	}

	#if GAME_PBR
	private init(file: XGFiles) {
		self.file = file
		
		if self.file.exists {
			let data = self.file.data!
			
			var entryCount = 0
			var entrySize = 0
			
			switch self.file {
			case .common:
				entryCount = data.get4BytesAtOffset(0)
				entrySize  = data.get4BytesAtOffset(4)
				self.subStartOffset = data.get4BytesAtOffset(8)
				self.unknown = data.get4BytesAtOffset(12)
				self.startOffset = data.get4BytesAtOffset(16)
				
			case .dckt:
				entryCount = data.get4BytesAtOffset(8)
				entrySize  = kSizeOfTrainerData
				self.startOffset = XGDecks.headerSize
				self.subStartOffset = startOffset
				
			case .dckp:
				entryCount = data.get4BytesAtOffset(8)
				entrySize  = kSizeOfPokemonData
				self.startOffset = XGDecks.headerSize
				self.subStartOffset = startOffset
				
			case .dcka:
				entryCount = data.get4BytesAtOffset(8)
				entrySize  = 0x24
				self.startOffset = XGDecks.headerSize
				self.subStartOffset = startOffset
				
			default: break
			}
			
			if startOffset > subStartOffset {
				predata = data.getCharStreamFromOffset(subStartOffset, length: startOffset - subStartOffset)
			}
			
			if startOffset + (entryCount * entrySize) <= data.length {
				for i in 0 ..< entryCount {
					let offset = startOffset + (i * entrySize)
					let bytes = data.getCharStreamFromOffset(offset, length: entrySize)
					let entry = XGMutableData(byteStream: bytes)
					self.entries.append(entry)
				}
				
				let dataEnd = startOffset + (entryCount * entrySize)
				let postCount = data.length - (dataEnd)
				if postCount > 0 {
					postdata = data.getCharStreamFromOffset(dataEnd, length: postCount)
				}
			} else {
				printg("Error: invalid data table \(self.file.path)")
			}

			dataTablesByFile[file.path] = self
		}
	}
	#else
	private init(index: CommonIndexes, entrySize: Int) {
		file = .common_rel

		if let data = XGFiles.common_rel.data {
			let entryCount = CommonIndexes(rawValue: index.rawValue + 1)!.value
			startOffset = index.startOffset

			if startOffset + (entryCount * entrySize) <= data.length {
				for i in 0 ..< entryCount {
					let offset = startOffset + (i * entrySize)
					let bytes = data.getCharStreamFromOffset(offset, length: entrySize)
					let entry = XGMutableData(byteStream: bytes)
					self.entries.append(entry)
				}
			} else {
				printg("Error: invalid data table: \(file.path) \(index) \(index.startOffset.hexString())")
			}

			dataTablesByIndex[index.rawValue] = self
		}
	}
	#endif
	
	func dataForEntryWithIndex(_ index: Int) -> XGMutableData? {
		if index >= 0, index < entries.count {
			return entries[index]
		}
		return nil
	}

	func entryWithIndex(_ index: Int) -> GoDDataTableEntry? {
		return GoDDataTableEntry(index: index, table: self)
	}
	
	func offsetForEntryWithIndex(_ index: Int) -> Int {
		return startOffset + (index * entrySize)
	}
	
	func replaceData(data: XGMutableData, forIndex index: Int) {
		if index < 0 {
			printg("Error adding data for index \(index) to file \(self.file.path).\nThe index was negative.")
		} else if index < self.entries.count {
			self.entries[index] = data
		} else if index == self.entries.count {
			self.entries.append(data)
		} else {
			printg("Error adding data for index \(index) to file \(self.file.path).\nThe index was too large.")
		}
	}
	
	func addEntry(data: XGMutableData) {
		self.entries.append(data)
	}
	
	func setEntrySize(_ size: Int) {
		guard size > 0 else {
			printg("Cannot set data table entry size to 0.")
			return
		}

		for entry in self.entries {
			while entry.length > size {
				entry.deleteBytes(start: entry.length - 1, count: 1)
			}
			while entry.length < size {
				entry.appendBytes([0])
			}
		}
	}
	
	var entrySize: Int {
		return numberOfEntries == 0 ? 0 : self.entries[0].length
	}
	
	func data() -> XGMutableData {
		
		if self.entries.count > 0 {
			self.setEntrySize(self.entries[0].length)
		}

		#if GAME_PBR
		var bytes = [UInt8](repeating: 0, count: subStartOffset) + predata
		#else
		var bytes = [UInt8]()
		#endif

		for entry in self.entries {
			bytes += entry.charStream
		}

		#if GAME_PBR
		while bytes.count % 16 != 0 {
			bytes.append(0)
		}
		bytes += postdata
		#endif

		#if GAME_PBR
		let start = self.startOffset
		let subStart = self.subStartOffset
		let fileSize = bytes.count
		let dataSize = entryCount * entrySize
		let entryCount = self.entries.count
		let entrySize = entryCount == 0 ? 0 : self.entries[0].length
		#endif

		let d = XGMutableData(byteStream: bytes, file: self.file)

		#if GAME_PBR
		switch self.file {
		case .common:
			d.replace4BytesAtOffset(0, withBytes: entryCount)
			d.replace4BytesAtOffset(4, withBytes: entrySize)
			d.replace4BytesAtOffset(8, withBytes: subStart)
			d.replace4BytesAtOffset(12, withBytes: unknown)
			d.replace4BytesAtOffset(16, withBytes: start)
			d.replace4BytesAtOffset(20, withBytes: dataSize)
			d.replace4BytesAtOffset(24, withBytes: fileSize - (postCount * 4))
			d.replace4BytesAtOffset(28, withBytes: postCount)
			d.replace4BytesAtOffset(32, withBytes: dataSize + startOffset)
			
		case .dckt:
			d.replaceWordAtOffset(0, withBytes: XGDeckTypes.DCKT.rawValue)
			d.replace4BytesAtOffset(4, withBytes: fileSize)
			d.replace4BytesAtOffset(8, withBytes: entryCount)
			
		case .dckp:
			d.replaceWordAtOffset(0, withBytes: XGDeckTypes.DCKP.rawValue)
			d.replace4BytesAtOffset(4, withBytes: fileSize)
			d.replace4BytesAtOffset(8, withBytes: entryCount)
			
		case .dcka:
			d.replaceWordAtOffset(0, withBytes: XGDeckTypes.DCKA.rawValue)
			d.replace4BytesAtOffset(4, withBytes: fileSize)
			d.replace4BytesAtOffset(8, withBytes: entryCount)
			
		default: break
		}
		#endif
		
		return d
	}

	func save() {
		#if GAME_PBR
		data().save()
		#else
		if let data = file.data {
			data.replaceBytesFromOffset(startOffset, withByteStream: self.data().byteStream)
			data.save()
		}
		#endif
	}

	#if !GAME_PBR
	class func tableForIndex(_ index: CommonIndexes, entrySize: Int) -> GoDDataTable? {
		return dataTablesByIndex[index.rawValue] ?? GoDDataTable(index: index, entrySize: entrySize)
	}
	#else
	class func tableForFile(_ file: XGFiles) -> GoDDataTable {
		return dataTablesByFile[file.path] ?? GoDDataTable(file: file)
	}

	static var pokemonIcons = tableForFile(.common(region == .JP ? 6 : 0))
	static var countries = tableForFile(.common(region == .JP ? 7 : 1))
	static var shopItems = tableForFile(.common(region == .JP ? 8 : 2))
	static var colosseumsUnknown = region == .JP ? nil : tableForFile(.common(3)) //Doesn't exist in JP ISO
	static var typeMatchups = tableForFile(.common(region == .JP ? 10 : 4))
	static var expTables = tableForFile(.common(region == .JP ? 11 : 5))
	static var pokemonModels = tableForFile(.common(region == .JP ? 12 : 6))
	static var pokemonModelEffect = tableForFile(.common(region == .JP ? 13 : 7))
	static var pokemonBaseStats = tableForFile(.common(region == .JP ? 14 : 8))
	static var evolutions = tableForFile(.common(region == .JP ? 15 : 9))
	static var ballModels = tableForFile(.common(region == .JP ? 23 : 10))
	static var colosseumsRules = tableForFile(.common(region == .JP ? 24 : 11))
	static var fightAIBattlePass = tableForFile(.common(region == .JP ? 25 : 12))
	static var fightAIExpectData = tableForFile(.common(region == .JP ? 26 : 13))
	static var fightAIPokemonPartData = tableForFile(.common(region == .JP ? 27 : 14))
	static var fightAIValues = tableForFile(.common(region == .JP ? 28 : 15))
	static var fightAIMoveData = tableForFile(.common(region == .JP ? 29 : 16))
	static var flagIDs = tableForFile(.common(region == .JP ? 0 : 17))
	static var floorEvent = tableForFile(.common(region == .JP ? 1 : 18))
	static var items = tableForFile(.common(region == .JP ? 2 : 19))
	static var menuBattleRules = tableForFile(.common(region == .JP ? 3 : 20))
	static var pokemonBodies = tableForFile(.common(region == .JP ? 4 : 21))
	static var pokemonFaces = tableForFile(.common(region == .JP ? 5 : 22))
	static var abilities = tableForFile(.common(region == .JP ? 17 : 23))
	static var trainerCustomParts = tableForFile(.common(region == .JP ? 18 : 24))
	static var trainerCustomTable = tableForFile(.common(region == .JP ? 19 : 25))
	static var trainerEvent = tableForFile(.common(region == .JP ? 20 : 26))
	static var trainerModels = tableForFile(.common(region == .JP ? 21 : 27))
	static var trainerTitles = tableForFile(.common(region == .JP ? 22 : 28))
	static var TMs = tableForFile(.common(region == .JP ? 30 : 29))
	static var moves = tableForFile(.common(region == .JP ? 31 : 30))
	static var tutorialData = tableForFile(.common(region == .JP ? 9 : 31))
	static var levelUpMoves = tableForFile(.common(region == .JP ? 16 : 32))
	#endif
	
}










