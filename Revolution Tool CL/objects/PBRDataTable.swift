//
//  PBRDataTable.swift
//  Revolution Tool CL
//
//  Created by The Steez on 25/12/2018.
//

import Foundation

private var tablesLoaded = false
private var tables = [Int : PBRDataTable]()
private var decksLoaded = false
private var decks = [Int : PBRDataTable]()
private let kNumberOfDataTables = 0x21
private let kNumberOfPokemonDecks = 19
private let kNumberOfTrainerDecks = 26

private var allTables : [Int: PBRDataTable] {
	if !tablesLoaded {
		let common : XGFsys? = XGFiles.fsys("common").exists ? XGFiles.fsys("common").fsysData : nil
		for i in 0 ..< kNumberOfDataTables {
			let file = XGFiles.common(i)
			if !file.exists {
				if let c = common {
					if let f = c.decompressedDataForFileWithIndex(index: i) {
						f.file = file
						f.save()
					}
				}
			}
			if file.exists {
				tables[i] = PBRDataTable(file: file)
			}
		}
		tablesLoaded = true
	}
	return tables
}
private var allDecks : [Int : PBRDataTable] {
	if !decksLoaded {
		let deck : XGFsys? = XGFiles.fsys("deck").exists ? XGFiles.fsys("deck").fsysData : nil
		for i in 0 ..< kNumberOfTrainerDecks {
			let file = XGFiles.dckt(i)
			if !file.exists {
				if let d = deck {
					if let f = d.decompressedDataForFileWithIndex(index: i) {
						f.file = file
						f.save()
					}
				}
			}
			if file.exists {
				decks[i] = PBRDataTable(file: file)
			}
		}
		for i in 0 ..< kNumberOfPokemonDecks {
			let file = XGFiles.dckp(i)
			if !file.exists {
				if let d = deck {
					if let f = d.decompressedDataForFileWithIndex(index: i + kNumberOfTrainerDecks) {
						f.file = file
						f.save()
					}
				}
			}
			if file.exists {
				decks[i + kNumberOfTrainerDecks] = PBRDataTable(file: file)
			}
		}
		if !XGFiles.dcka.exists {
			if let d = deck {
				if let f = d.decompressedDataForFileWithIndex(index: d.numberOfEntries - 1) {
					f.file = .dcka
					f.save()
				}
			}
		}
		if XGFiles.dcka.exists {
			decks[kNumberOfTrainerDecks + kNumberOfPokemon] = PBRDataTable(file: XGFiles.dcka)
		}
		decksLoaded = true
	}
	return decks
}

class PBRDataTable : CustomStringConvertible {
	
	var description: String {
		var text = self.file.fileName + "\nEntries: " + self.entries.count.string + "\n"
		
		for entry in self.entries {
			text += "\n" + entry.byteStream.hexStream
		}
		
		return text
	}
	
	var startOffset = 0
	var subStartOffset = 0
	var entries = [XGMutableData]()
	var file = XGFiles.common(0)
	var predata = [UInt8]()
	
	var numberOfEntries : Int {
		return entries.count
	}
	
	init(file: XGFiles) {
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
			} else {
				printg("Error: invalid data table \(self.file.path)")
			}
		}
		
	}
	
	func dataForEntryWithIndex(_ index: Int) -> XGMutableData? {
		if index < self.entries.count {
			return entries[index]
		}
		return nil
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
		// common only
		if size > 0 {
			for entry in self.entries {
				while entry.length > size {
					entry.deleteBytes(start: entry.length - 1, count: 1)
				}
				while entry.length < size {
					entry.appendBytes([0])
				}
			}
		}
	}
	
	var entrySize : Int {
		return numberOfEntries == 0 ? 0 : self.entries[0].length
	}
	
	func data() -> XGMutableData {
		
		if self.entries.count > 0 {
			self.setEntrySize(self.entries[0].length)
		}
		
		var bytes = [UInt8](repeating: 0, count: subStartOffset) + predata
		for entry in self.entries {
			bytes += entry.charStream
		}
		while bytes.count % 16 != 0 {
			bytes.append(0)
		}
		
		let start = self.startOffset
		let subStart = self.subStartOffset
		let entryCount = self.entries.count
		let entrySize = entryCount == 0 ? 0 : self.entries[0].length
		let dataSize = entryCount * entrySize
		let fileSize = bytes.count
		
		let d = XGMutableData(byteStream: bytes, file: self.file)
		switch self.file {
		case .common:
			d.replace4BytesAtOffset(0, withBytes: entryCount)
			d.replace4BytesAtOffset(4, withBytes: entrySize)
			d.replace4BytesAtOffset(8, withBytes: subStart)
			d.replace4BytesAtOffset(16, withBytes: start)
			d.replace4BytesAtOffset(20, withBytes: dataSize)
			d.replace4BytesAtOffset(24, withBytes: fileSize)
			
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
		
		return d
	}
	
	func save() {
		self.data().save()
	}
	
	class func tableWithID(_ id: Int) -> PBRDataTable? {
		return allTables[id]
	}
	
	private class func deckWithID(_ id: Int) -> PBRDataTable? {
		return allDecks[id]
	}
	
	class func trainerDeckWithID(_ id: Int) -> PBRDataTable? {
		return deckWithID(id)
	}
	
	class func pokemonDeckWithID(_ id: Int) -> PBRDataTable? {
		return deckWithID(id + kNumberOfTrainerDecks)
	}
	
	class func AIDeck() -> PBRDataTable? {
		return deckWithID(kNumberOfPokemonDecks + kNumberOfTrainerDecks)
	}
	
	static var pokemonImages = tableWithID(0)!
	static var countries = tableWithID(1)!
	static var holdItems = tableWithID(2)!
//	static var colosseums? = tableWithID(3)!
	static var typeMatchups = tableWithID(4)!
	static var pokemonModels = tableWithID(6)!
	static var baseStats = tableWithID(8)!
	static var evolutions = tableWithID(9)!
	static var wzxbthr = tableWithID(10)!
	//	static var colosseums2? = tableWithID(11)!
	static var items = tableWithID(19)!
	static var formeSprites = tableWithID(21)!
	static var formeModels = tableWithID(22)!
	static var clothes = tableWithID(24)!
	static var wzxbthr2 = tableWithID(26)!
	static var presetTrainerModels = tableWithID(27)!
	static var TMs = tableWithID(29)!
	static var moves = tableWithID(30)!
	static var levelUpMoves = tableWithID(32)!
	
}










