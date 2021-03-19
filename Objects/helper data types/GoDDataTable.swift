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
	var file: XGFiles
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
			case .indexAndFsysName(_, "common"):
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
		let entryCount = self.entries.count
		let dataSize = entryCount * entrySize
		let entrySize = entryCount == 0 ? 0 : self.entries[0].length
		#endif

		let d = XGMutableData(byteStream: bytes, file: self.file)

		#if GAME_PBR
		switch self.file {
		case .indexAndFsysName(_, "common"):
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

	static var pokemonIcons = tableForFile(.indexAndFsysName(region == .JP ? 6 : 0, "common"))
	static var countries = tableForFile(.indexAndFsysName(region == .JP ? 7 : 1, "common"))
	static var shopItems = tableForFile(.indexAndFsysName(region == .JP ? 8 : 2, "common"))
	static var colosseumsUnknown = region == .JP ? nil : tableForFile(.indexAndFsysName(3, "common")) //Doesn't exist in JP I,) "common")O
	static var typeMatchups = tableForFile(.indexAndFsysName(region == .JP ? 10 : 4, "common"))
	static var expTables = tableForFile(.indexAndFsysName(region == .JP ? 11 : 5, "common"))
	static var pokemonModels = tableForFile(.indexAndFsysName(region == .JP ? 12 : 6, "common"))
	static var pokemonModelEffect = tableForFile(.indexAndFsysName(region == .JP ? 13 : 7, "common"))
	static var pokemonBaseStats = tableForFile(.indexAndFsysName(region == .JP ? 14 : 8, "common"))
	static var evolutions = tableForFile(.indexAndFsysName(region == .JP ? 15 : 9, "common"))
	static var ballModels = tableForFile(.indexAndFsysName(region == .JP ? 23 : 10, "common"))
	static var colosseumsRules = tableForFile(.indexAndFsysName(region == .JP ? 24 : 11, "common"))
	static var fightAIBattlePass = tableForFile(.indexAndFsysName(region == .JP ? 25 : 12, "common"))
	static var fightAIExpectData = tableForFile(.indexAndFsysName(region == .JP ? 26 : 13, "common"))
	static var fightAIPokemonPartData = tableForFile(.indexAndFsysName(region == .JP ? 27 : 14, "common"))
	static var fightAIValues = tableForFile(.indexAndFsysName(region == .JP ? 28 : 15, "common"))
	static var fightAIMoveData = tableForFile(.indexAndFsysName(region == .JP ? 29 : 16, "common"))
	static var flagIDs = tableForFile(.indexAndFsysName(region == .JP ? 0 : 17, "common"))
	static var floorEvent = tableForFile(.indexAndFsysName(region == .JP ? 1 : 18, "common"))
	static var items = tableForFile(.indexAndFsysName(region == .JP ? 2 : 19, "common"))
	static var menuBattleRules = tableForFile(.indexAndFsysName(region == .JP ? 3 : 20, "common"))
	static var pokemonBodies = tableForFile(.indexAndFsysName(region == .JP ? 4 : 21, "common"))
	static var pokemonFaces = tableForFile(.indexAndFsysName(region == .JP ? 5 : 22, "common"))
	static var abilities = tableForFile(.indexAndFsysName(region == .JP ? 17 : 23, "common"))
	static var trainerCustomParts = tableForFile(.indexAndFsysName(region == .JP ? 18 : 24, "common"))
	static var trainerCustomTable = tableForFile(.indexAndFsysName(region == .JP ? 19 : 25, "common"))
	static var trainerEvent = tableForFile(.indexAndFsysName(region == .JP ? 20 : 26, "common"))
	static var trainerModels = tableForFile(.indexAndFsysName(region == .JP ? 21 : 27, "common"))
	static var trainerTitles = tableForFile(.indexAndFsysName(region == .JP ? 22 : 28, "common"))
	static var TMs = tableForFile(.indexAndFsysName(region == .JP ? 30 : 29, "common"))
	static var moves = tableForFile(.indexAndFsysName(region == .JP ? 31 : 30, "common"))
	static var tutorialData = tableForFile(.indexAndFsysName(region == .JP ? 9 : 31, "common"))
	static var levelUpMoves = tableForFile(.indexAndFsysName(region == .JP ? 16 : 32, "common"))
	#endif
	
}










