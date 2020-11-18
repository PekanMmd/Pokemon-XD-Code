//
//  PBRDataTableEntry.swift
//  Revolution Tool CL
//
//  Created by The Steez on 26/12/2018.
//

import Foundation

class PBRDataTableEntry: XGIndexedValue {

	var index = 0
	var size: Int {
		data.length
	}

	var data = XGMutableData()
	var rawBytes: [Int] {
		return data.byteStream
	}

	private weak var table: PBRDataTable?
	
	init(index: Int, table: PBRDataTable) {
		self.data = table.dataForEntryWithIndex(index) ?? XGMutableData(byteStream: [UInt8](repeating: 0, count: table.entrySize))
		self.index = index
		self.table = table
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
		guard let table = self.table else {
			printg("Couldn't save table for entry with index:", index)
			return
		}
		table.save()
	}
	
	static func pokemonIcons(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.pokemonIcons)}
	static func shopItems(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.items) }
	static func typeMatchups(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.typeMatchups) }
	static func pokemonModels(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.pokemonModels) }
	static func baseStats(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.pokemonBaseStats) }
	static func evolutions(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.evolutions) }
	static func items(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.items) }
	static func pokemonFaces(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.pokemonFaces) }
	static func pokemonBodies(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.pokemonBodies) }
	static func TMs(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.TMs)}
	static func moves(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.moves) }
	static func levelUpMoves(index: Int) -> PBRDataTableEntry { return PBRDataTableEntry(index: index, table: PBRDataTable.levelUpMoves) }
	
}







