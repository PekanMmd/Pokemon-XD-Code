//
//  PBRDataTableEntry.swift
//  Revolution Tool CL
//
//  Created by The Steez on 26/12/2018.
//

import Foundation

class PBRDataTableEntry {
	
	private var data = XGMutableData()
	private var index = 0
	private var table = 0
	
	init(index: Int, tableId: Int) {
		let d = PBRDataTable.tableWithID(tableId)!.dataForEntryWithIndex(index)!
		self.data = d
		self.index = index
		self.table = tableId
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
	
	
	func save() {
		PBRDataTable.tableWithID(self.table)!.replaceData(data: self.data, forIndex: self.index)
		PBRDataTable.tableWithID(self.table)!.save()
	}
	
}







