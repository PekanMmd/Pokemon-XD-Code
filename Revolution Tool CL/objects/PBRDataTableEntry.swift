//
//  PBRDataTableEntry.swift
//  Revolution Tool CL
//
//  Created by The Steez on 26/12/2018.
//

import Foundation

class PBRDataTableEntry : XGIndexedValue {
	
	var data = XGMutableData()
	internal var index = 0
	private  var table = 0
	private  var deckType = XGDeckTypes.none
	
	init(index: Int, tableId: Int) {
		self.data = PBRDataTable.tableWithID(tableId)!.dataForEntryWithIndex(index)!
		self.index = index
		self.table = tableId
		self.deckType = .none
	}
	
	init(index: Int, deck: XGDecks) {
		self.index = index
		
		switch deck {
		case .dckt(let i):
			self.data = PBRDataTable.trainerDeckWithID(i)!.dataForEntryWithIndex(index)!
			self.table = i
			self.deckType = .DCKT
		case .dckp(let i):
			self.data = PBRDataTable.pokemonDeckWithID(i)!.dataForEntryWithIndex(index)!
			self.table = i
			self.deckType = .DCKP
		case .dcka:
			self.data = PBRDataTable.AIDeck()!.dataForEntryWithIndex(index)!
			self.table = 0
			self.deckType = .DCKA
		case .null:
			break
		}
		
	}
	
	func getBool(_ off: Int) -> Bool {
		return getByte(off) == 1
	}
	
	func getByte(_ off: Int) -> Int {
		return self.data.getByteAtOffset(off)
	}
	
	func getSignedByte(_ off: Int) -> Int {
		let b = getByte(off)
		return b >= 0x80 ? b - 0x100 : b
	}
	
	func getShort(_ off: Int) -> Int {
		return self.data.get2BytesAtOffset(off)
	}
	
	func getSignedShort(_ off: Int) -> Int {
		let b = getShort(off)
		return b >= 0x8000 ? b - 0x10000 : b
	}
	
	func getWord(_ off: Int) -> UInt32 {
		return self.data.getWordAtOffset(off)
	}
	
	func getSignedWord(_ off: Int) -> Int {
		return getWord(off).int32
	}
	
	func setBool(_ off: Int, to: Bool) {
		self.setByte(off, to: to ? 1 : 0)
	}
	
	func setByte(_ off: Int, to: Int) {
		self.data.replaceByteAtOffset(off, withByte: to & 0xFF)
	}
	
	func setSignedByte(_ off: Int, to: Int) {
		let b = to < 0 ? 0x100 + to : to
		self.setByte(off, to: b)
	}
	
	func setShort(_ off: Int, to: Int) {
		self.data.replace2BytesAtOffset(off, withBytes: to & 0xFFFF)
	}
	
	func setSignedShort(_ off: Int, to: Int) {
		let b = to < 0 ? 0x10000 + to : to
		self.setShort(off, to: b)
	}
	
	func setWord(_ off: Int, to: UInt32) {
		self.data.replaceWordAtOffset(off, withBytes: to)
	}
	
	func setSignedWord(_ off: Int, to: Int) {
		self.setWord(off, to: to.unsigned)
	}
	
	func getByteStream(_ off: Int, count: Int) -> [Int] {
		return self.data.getByteStreamFromOffset(off, length: count)
	}
	
	func getWordStream(_ off: Int, count: Int) -> [UInt32] {
		return self.data.getWordStreamFromOffset(off, length: count * 4)
	}
	
	func setByteStream(_ off: Int, bytes: [Int]) {
		self.data.replaceBytesFromOffset(off, withByteStream: bytes)
	}
	
	func save() {
		if deckType == .none {
			PBRDataTable.tableWithID(self.table)!.replaceData(data: self.data, forIndex: self.index)
			PBRDataTable.tableWithID(self.table)!.save()
		} else if deckType == .DCKT {
			PBRDataTable.trainerDeckWithID(self.table)!.replaceData(data: self.data, forIndex: self.index)
			PBRDataTable.trainerDeckWithID(self.table)!.save()
		} else if deckType == .DCKP {
			PBRDataTable.pokemonDeckWithID(self.table)!.replaceData(data: self.data, forIndex: self.index)
			PBRDataTable.pokemonDeckWithID(self.table)!.save()
		} else if deckType == .DCKA {
			PBRDataTable.AIDeck()!.replaceData(data: self.data, forIndex: self.index)
			PBRDataTable.AIDeck()!.save()
		}
	}
	
	static func pokemonImages(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 0)}
	static func countries(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 1) }
	static func holdItems(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 2) }
	//	static func colosseums(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 3) }?
	static func typeMatchups(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 4) }
	static func pokemonModels(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 6) }
	static func baseStats(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 8) }
	static func evolutions(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 9) }
	static func items(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 19) }
	static func formeSprites(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 21) }
	static func clothes(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 24) }
	static func TMs(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 29)}
	static func moves(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 30) }
	static func levelUpMoves(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, tableId: 32) }
	
}







