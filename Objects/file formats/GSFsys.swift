//
//  GSFsys.swift
//  GoD Tool
//
//  Created by Stars Momodu on 28/03/2021.
//

import Foundation

struct GSFsysEntry {
	var name: String
	var id: Int

	static let entrySize = game == .Colosseum ? 0x8 : 0x10
}

class GSFsys {

	private let unknownValue: Int
	private(set) var entries: [GSFsysEntry]

	private init() {
		entries = []
		if let data = XGFiles.GSFsys.data {
			unknownValue = data.get4BytesAtOffset(4)
			let numberOfEntries = data.get4BytesAtOffset(8)
//			let namesStartOffset = data.get4BytesAtOffset(20)
			let entriesStartOffset = data.get4BytesAtOffset(16)

			for i in 0 ..< numberOfEntries {
				let entryOffset = entriesStartOffset + (GSFsysEntry.entrySize * i)
				let fsysID = data.get4BytesAtOffset(entryOffset)
				let nameOffset = data.get4BytesAtOffset(entryOffset + 4)
				let name = data.getStringAtOffset(nameOffset) + ".fsys"
				entries.append(.init(name: name, id: fsysID))
			}
		} else {
			assertionFailure("Failed to init GSFsys")
			unknownValue = -1
		}
	}

	static var shared: GSFsys = GSFsys()
	static func reload() {
		shared = GSFsys()
	}

	func entryWithID(_ id: Int) -> GSFsysEntry? {
		return entries.first { (entry) -> Bool in
			entry.id == id
		}
	}

	func entryWithName(_ name: String) -> GSFsysEntry? {
		return entries.first { (entry) -> Bool in
			entry.name == name
		}
	}

	func addEntry(id: Int, name: String) {
		entries.append(.init(name: name, id: id))
	}

	func renameEntry(withID id: Int, to newName: String) {
		if let entry = entryWithID(id) {
			let newEntry = GSFsysEntry(name: newName, id: entry.id)
			if let index = entries.firstIndex(where: { (check) -> Bool in
				return check.id == id
			}) {
				entries[index] = newEntry
			}
		}
	}

	func renameEntry(withName name: String, to newName: String) {
		if let entry = entryWithName(name) {
			let newEntry = GSFsysEntry(name: newName, id: entry.id)
			if let index = entries.firstIndex(where: { (check) -> Bool in
				return check.name == name
			}) {
				entries[index] = newEntry
			}
		}
	}

	func removeEntries(id: Int) {
		entries.removeAll { (entry) -> Bool in
			entry.id == id
		}
	}

	func removeEntries(name: String) {
		entries.removeAll { (entry) -> Bool in
			entry.name == name
		}
	}

	func data() -> XGMutableData {
		let data = XGMutableData(length: 0x20)

		// header
		data.file = .GSFsys
		data.replaceWordAtOffset(0, withBytes: 0x474C4C41) // GLLA magic bytes
		data.replace4BytesAtOffset(4, withBytes: unknownValue)
		data.replace4BytesAtOffset(8, withBytes: entries.count)
		data.replace4BytesAtOffset(20, withBytes: 0x20) // end of header

		var nameOffsetsByID = [Int : Int]()

		for entry in entries {
			let string = entry.name.replacingOccurrences(of: ".fsys", with: "").unicodeRepresentation.map { (byte) -> UInt8 in
				return UInt8(byte & 0xFF)
			}
			nameOffsetsByID[entry.id] = data.length
			data.appendBytes(string)
		}
		while data.length % 16 != 0 {
			data.appendBytes([0])
		}
		data.replace4BytesAtOffset(16, withBytes: data.length)
		for entry in entries {
			let newEntry = XGMutableData(length: GSFsysEntry.entrySize)
			newEntry.replace4BytesAtOffset(0, withBytes: entry.id)
			newEntry.replace4BytesAtOffset(4, withBytes: nameOffsetsByID[entry.id] ?? 0)
			data.appendData(newEntry)
		}
		data.appendData(.init(length: 16))
		while data.length % 16 != 0 {
			data.appendBytes([0])
		}

		return data
	}
}
