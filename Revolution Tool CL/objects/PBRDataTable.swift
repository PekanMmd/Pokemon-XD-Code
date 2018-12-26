//
//  PBRDataTable.swift
//  Revolution Tool CL
//
//  Created by The Steez on 25/12/2018.
//

import Foundation

private var tablesLoaded = false
private var tables = [Int : PBRDataTable]()
private let kNumberOfDataTables = 0x21

private var allTables : [Int: PBRDataTable] {
	if !tablesLoaded {
		let common : XGFsys? = XGFiles.fsys("common").exists ? XGFiles.fsys("common").fsysData : nil
		for i in 0 ..< kNumberOfDataTables {
			let file = XGFiles.common(i, .dta)
			if !file.exists {
				if let c = common {
					if i < c.numberOfEntries {
						if let f = c.decompressedDataForFileWithIndex(index: i) {
							f.file = file
							f.save()
						}
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

class PBRDataTable : CustomStringConvertible {
	
	var description: String {
		var text = self.file.fileName + "\nEntries: " + self.entries.count.string + "\n"
		
		for entry in self.entries {
			text += "\n" + entry.byteStream.hexStream
		}
		
		return text
	}
	
	private var startOffset = 0
	private var entries = [XGMutableData]()
	private var file = XGFiles.common(0, .dta)
	
	var numberOfEntries : Int {
		return entries.count
	}
	
	init(file: XGFiles) {
		self.file = file
		
		if self.file.exists {
			let data = self.file.data!
			
			let entryCount = data.get4BytesAtOffset(0)
			let entrySize  = data.get4BytesAtOffset(4)
			self.startOffset = data.get4BytesAtOffset(8)
			
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
	
	func data() -> XGMutableData {
		
		if self.entries.count > 0 {
			self.setEntrySize(self.entries[0].length)
		}
		
		var bytes = [UInt8](repeating: 0, count: startOffset)
		for entry in self.entries {
			bytes += entry.charStream
		}
		while bytes.count % 16 != 0 {
			bytes.append(0)
		}
		
		let start = self.startOffset
		let entryCount = self.entries.count
		let entrySize = entryCount == 0 ? 0 : self.entries[0].length
		let dataSize = entryCount * entrySize
		let fileSize = bytes.count
		
		let d = XGMutableData(byteStream: bytes, file: self.file)
		d.replace4BytesAtOffset(0, withBytes: entryCount)
		d.replace4BytesAtOffset(4, withBytes: entrySize)
		d.replace4BytesAtOffset(8, withBytes: start)
		d.replace4BytesAtOffset(16, withBytes: start)
		d.replace4BytesAtOffset(20, withBytes: dataSize)
		d.replace4BytesAtOffset(24, withBytes: fileSize)
		
		return d
	}
	
	func save() {
		self.data().save()
	}
	
	class func tableWithID(_ id: Int) -> PBRDataTable? {
		return allTables[id]
	}
	
	static var countries = tableWithID(1)
	static var holdItems = tableWithID(2)
//	static var colosseums? = tableWithID(3)
	static var typeMatchups = tableWithID(4)
	static var clothes = tableWithID(6)
	static var baseStats = tableWithID(8)
	static var evolutions = tableWithID(9)
	static var items = tableWithID(19)
	static var clothes2 = tableWithID(24)
	static var moves = tableWithID(30)
	static var levelUpMoves = tableWithID(32)
	
}










